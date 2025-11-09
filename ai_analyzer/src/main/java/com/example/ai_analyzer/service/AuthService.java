package com.example.ai_analyzer.service;

import com.example.ai_analyzer.dto.AuthRequest;
import com.example.ai_analyzer.dto.AuthResponse;
import com.example.ai_analyzer.dto.SignupRequest;
import com.example.ai_analyzer.entity.User;
import com.example.ai_analyzer.repository.UserRepository;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

  private final UserRepository userRepository;
  private final PasswordEncoder passwordEncoder;

  // Use a secure key from environment variables or config in production
  private final String SECRET_KEY = "secret";

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
        .healthIssues(request.getHealthIssues())
        .build();

    userRepository.save(user);

    // Generate JWT token
    String token = generateToken(user.getEmail());

    return new AuthResponse(token, user.getEmail());
  }

  // Login: validates credentials and returns token/email
  public AuthResponse login(AuthRequest request) {
    Optional<User> userOpt = userRepository.findByEmail(request.getEmail());
    if (userOpt.isEmpty()) {
      return new AuthResponse(null, null);
    }

    User user = userOpt.get();

    if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
      return new AuthResponse(null, null);
    }

    String token = generateToken(user.getEmail());

    return new AuthResponse(token, user.getEmail());
  }

  // JWT token generator for 24 hours validity
  private String generateToken(String email) {
    return Jwts.builder()
        .setSubject(email)
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 86400000)) // 1 day
        .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
        .compact();
  }
}
