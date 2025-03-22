package com.ecommerce.config;


import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;

import java.security.Key;
/**
*
* @author Yuzana Zaw Zaw
*/
@Component
public class JWTUtils {

    private final String SECRET_KEY = "w7HP0+wI9M7rptAjnscVEN16JacbE8f994lGluJvmwI=";

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public String extractRole(String token) {
        return extractClaim(token, claims -> claims.get("role", String.class)); 
    }
    
    public String extractModule(String token) {
        return extractClaim(token, claims -> claims.get("module", String.class));
    }

    public Long extractUserId(String token) {
        return extractClaim(token, claims -> claims.get("userId", Long.class));
    }
    
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    @SuppressWarnings("deprecation")
    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(token)
                .getBody();
    }

    Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    // @SuppressWarnings("deprecation")
    // public String generateToken(UserDetails userDetails) {
    //     Key key = Keys.hmacShaKeyFor(Base64.getDecoder().decode(SECRET_KEY));
    //     return Jwts.builder()
    //             .setSubject(userDetails.getUsername())
    //             .setIssuedAt(new Date())
    //             .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10)) // 10 hours
    //             .signWith(SignatureAlgorithm.HS256, key)
    //             .compact();
    // }

    public String generateToken(UserDetails userDetails, String module,String role,long userId) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("module", module); 
        claims.put("role", role); 
        claims.put("userId", userId);
        
        return createToken(claims, userDetails.getUsername());
    }

    @SuppressWarnings("deprecation")
    private String createToken(Map<String, Object> claims, String subject) {
        Key key = Keys.hmacShaKeyFor(Base64.getDecoder().decode(SECRET_KEY));
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() +  1000 * 60 * 60 * 10))
                .signWith(SignatureAlgorithm.HS256, key)
                .compact();
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        System.out.println("valid token");
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    public String extractToken(HttpServletRequest request) {
        String authorizationHeader = request.getHeader("Authorization");
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            return authorizationHeader.substring(7);
        }
        return null;
    }
}
