package com.example.ai_analyzer.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;

import java.util.HashMap;
import java.util.Random;

@Service
public class OtpService {

    // Inject from environment or application.properties
    @Value("${twilio.account_sid}")
    private String ACCOUNT_SID;

    @Value("${twilio.auth_token}")
    private String AUTH_TOKEN;

    @Value("${twilio.phone_number}")
    private String TWILIO_NUMBER;

    private final HashMap<String, String> otpStorage = new HashMap<>();

    public String generateOtp(String phoneNumber) {
        String otp = String.format("%06d", new Random().nextInt(999999));
        otpStorage.put(phoneNumber, otp);

        // Initialize Twilio
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);

        // Send OTP via SMS using Twilio
        Message message = Message.creator(
            new com.twilio.type.PhoneNumber(phoneNumber),      // destination (user's number)
            new com.twilio.type.PhoneNumber(TWILIO_NUMBER),    // source (Twilio number)
            "Your OTP is: " + otp
        ).create();

        System.out.println("Sent OTP to " + phoneNumber + ": " + otp);
        return otp;
    }

    public boolean verifyOtp(String phoneNumber, String otp) {
        return otp.equals(otpStorage.get(phoneNumber));
    }
}
