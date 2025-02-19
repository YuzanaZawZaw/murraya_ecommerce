package com.example.config;

import java.util.Base64;
import java.security.SecureRandom;

public class GenerateSecretKey {
    public static void main(String[] args) {
        byte[] keyBytes = new byte[32]; // 256-bit key
        new SecureRandom().nextBytes(keyBytes);
        String secretKey = Base64.getEncoder().encodeToString(keyBytes);
        System.out.println("Generated Secret Key: " + secretKey);
    }
}

