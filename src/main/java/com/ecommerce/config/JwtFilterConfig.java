package com.ecommerce.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Configuration
public class JwtFilterConfig {
    @Bean
    public JwtFilter jwtFilter(JWTUtils jwtUtil, CustomUserDetailsService customUserDetailsService) {
        return new JwtFilter(jwtUtil, customUserDetailsService);
    }
}
