package com.example.healthcare.service;

import com.example.healthcare.entity.FoodAnalysis;
import com.example.healthcare.repository.FoodAnalysisRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FoodAnalysisService {

    @Autowired
    private FoodAnalysisRepository repository;

    /**
     * Simulates image analysis and health check on ingredients.
     * In real app, integrate AI/image processing here.
     */
    public FoodAnalysis analyzeFoodImage(String imageUrl) {
        // For demo, hardcoded ingredients and health analysis logic
        // In real, use imageUrl to analyze image and detect ingredients

        FoodAnalysis analysis = new FoodAnalysis();
        analysis.setImageUrl(imageUrl);

        // Simulate ingredient detection (example)
        String detectedIngredients = "sugar, salt, tomatoes, cheese";
        analysis.setIngredients(detectedIngredients);

        // Simple health logic example
        if (detectedIngredients.contains("sugar") || detectedIngredients.contains("salt")) {
            analysis.setHealthy(false);
            analysis.setHealthMessage("This food contains high sugar or salt which can cause health issues like obesity or high blood pressure.");
        } else {
            analysis.setHealthy(true);
            analysis.setHealthMessage("This food is good for health, especially for children.");
        }

        // Save to DB
        return repository.save(analysis);
    }
}