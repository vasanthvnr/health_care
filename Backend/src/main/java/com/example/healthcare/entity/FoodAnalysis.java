package com.example.healthcare.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "food_analysis")
public class FoodAnalysis {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String imageUrl;     // URL or path to uploaded image (optional, for reference)

    @Column(length = 1000)
    private String ingredients;  // comma separated ingredient list detected

    private boolean isHealthy;

    @Column(length = 2000)
    private String healthMessage; // message like "Good for health" or side effects

    public FoodAnalysis() {}

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getIngredients() {
        return ingredients;
    }

    public void setIngredients(String ingredients) {
        this.ingredients = ingredients;
    }

    public boolean isHealthy() {
        return isHealthy;
    }

    public void setHealthy(boolean healthy) {
        isHealthy = healthy;
    }

    public String getHealthMessage() {
        return healthMessage;
    }

    public void setHealthMessage(String healthMessage) {
        this.healthMessage = healthMessage;
    }
}