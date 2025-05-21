package com.example.healthcare.controller;

import com.example.healthcare.entity.FoodAnalysis;
import com.example.healthcare.service.FoodAnalysisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/food")
public class FoodAnalysisController {

    @Autowired
    private FoodAnalysisService service;

    /**
     * Analyze food image and return health analysis
     * @param imageUrl (in real app, this could be multipart upload or base64 string)
     */
    @PostMapping("/analyze")
    public FoodAnalysis analyzeFood(@RequestParam String imageUrl) {
        return service.analyzeFoodImage(imageUrl);
    }
}