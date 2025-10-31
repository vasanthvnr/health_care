package com.example.ai_analyzer.service;

import com.example.ai_analyzer.utils.MultipartInputStreamFileResource;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

@Service
public class AnalysisService {

    private final String PYTHON_API_URL = "http://127.0.0.1:5000/analyze";

    public Map<String, Object> analyzeImage(MultipartFile image, String category, String healthIssues) {
        Map<String, Object> responseMap = new HashMap<>();

        try {
            // Prepare headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            // Prepare body with image
            LinkedMultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("image", new MultipartInputStreamFileResource(image.getInputStream(), image.getOriginalFilename()));
            // Add health issues as a string
            HttpHeaders healthHeaders = new HttpHeaders();
            healthHeaders.setContentType(MediaType.TEXT_PLAIN);
            HttpEntity<String> healthEntity = new HttpEntity<>(healthIssues, healthHeaders);
            body.add("healthIssues", healthIssues);
            // Build request entity
            HttpEntity<LinkedMultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

            // Send request
            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.postForEntity(PYTHON_API_URL, requestEntity, String.class);

            // Parse response
            if (response.getStatusCode() == HttpStatus.OK) {
                ObjectMapper mapper = new ObjectMapper();

                // Parse top-level JSON object
                Map<String, Object> pythonResponse = mapper.readValue(response.getBody(), Map.class);

                // Extract ingredients
                List<Map<String, Object>> pythonData = (List<Map<String, Object>>) pythonResponse.get("ingredients");

                List<Map<String, Object>> ingredientsList = new ArrayList<>();

                for (Map<String, Object> item : pythonData) {
                    Map<String, Object> ingredientInfo = new HashMap<>();
                    ingredientInfo.put("ingredient", item.get("ingredient"));
                    ingredientInfo.put("evaluation", item.get("evaluation"));
                    ingredientInfo.put("notSuitable", item.get("notSuitable")); // <-- New field from Python
                    ingredientInfo.put("reason", item.get("reason")); 
                    ingredientsList.add(ingredientInfo);
                }

                responseMap.put("status", pythonResponse.get("status"));
                responseMap.put("overallSafety", pythonResponse.get("overallSafety"));
                responseMap.put("overallMessage", pythonResponse.get("overallMessage"));
                responseMap.put("ingredients", ingredientsList);

            } else {
                responseMap.put("status", "error");
                responseMap.put("message", "Python service failed with status: " + response.getStatusCodeValue());
            }

        } catch (IOException e) {
            responseMap.put("status", "error");
            responseMap.put("message", "Error processing image: " + e.getMessage());
        } catch (Exception ex) {
            responseMap.put("status", "error");
            responseMap.put("message", "Unexpected error: " + ex.getMessage());
        }

        return responseMap;
    }
}
