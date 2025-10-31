package com.example.ai_analyzer.service;

import com.example.ai_analyzer.dto.*;
import com.example.ai_analyzer.entity.User;
import com.example.ai_analyzer.repository.UserRepository;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

  private final UserRepository userRepository;
  private final PasswordEncoder passwordEncoder;

  private final String SECRET_KEY = "secret"; // Use a secure key in production

  // Signup: creates user and returns token/email for login
  public AuthResponse signup(SignupRequest request) {
    Optional<User> existingUser = userRepository.findByEmail(request.getEmail());
    if (existingUser.isPresent()) {
      // User already exists, return null token/email
      return new AuthResponse(null, null);
    }

    User user = User.builder()
        .email(request.getEmail())
        .password(passwordEncoder.encode(request.getPassword()))
        .healthIssues(request.getHealthIssues()) // stored in DB
        .build();

    userRepository.save(user);

    // Generate token for login purposes
    String token = generateToken(user.getEmail());

    // Return only token and email
    return new AuthResponse(token, user.getEmail());
  }

  // Login: validates credentials and returns token/email
  public AuthResponse login(AuthRequest request) {
    Optional<User> userOpt = userRepository.findByEmail(request.getEmail());
    if (userOpt.isEmpty()) {
      // Invalid credentials
      return new AuthResponse(null, null);
    }

    User user = userOpt.get();

    if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
      // Invalid credentials
      return new AuthResponse(null, null);
    }

    String token = generateToken(user.getEmail());

    return new AuthResponse(token, user.getEmail());
  }

  // Reset password: generates token for password reset
  public String resetPassword(ResetPasswordRequest request) {
    Optional<User> userOpt = userRepository.findByEmail(request.getEmail());
    if (userOpt.isEmpty()) {
      return "User not found";
    }

    User user = userOpt.get();
    String resetToken = UUID.randomUUID().toString();
    user.setResetToken(resetToken);
    userRepository.save(user);

    // In a real application, send this token via email
    return "Password reset token: " + resetToken;
  }

  // Generate JWT token
  private String generateToken(String email) {
    return Jwts.builder()
        .setSubject(email)
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 1 day
        .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
        .compact();
  }
}
