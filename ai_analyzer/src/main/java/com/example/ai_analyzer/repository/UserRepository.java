package com.example.ai_analyzer.repository;

import com.example.ai_analyzer.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    Optional<User> findByResetToken(String resetToken);
    
    List<User> findByHealthIssues(String healthIssues);

    // Delete users with empty/null health issues
    void deleteByHealthIssuesIsNull();

    void deleteByHealthIssues(String healthIssues);
}
