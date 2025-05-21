package com.example.healthcare.repository;

import com.example.healthcare.entity.FoodAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FoodAnalysisRepository extends JpaRepository<FoodAnalysis, Long> {
}