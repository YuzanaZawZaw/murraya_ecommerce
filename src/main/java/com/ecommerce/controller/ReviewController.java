package com.ecommerce.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;

import com.ecommerce.config.JWTUtils;
import com.ecommerce.dto.ReviewDTO;
import com.ecommerce.model.Review;
import com.ecommerce.service.ReviewService;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@RestController
@RequestMapping(value = "/admin/reviews", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
public class ReviewController {
    @Autowired
    private ReviewService reviewService;

    @Autowired
    private JWTUtils jwtUtil;

    @GetMapping("/{productId}")
    public ResponseEntity<List<ReviewDTO>> getReviewsByProductId(@PathVariable int productId) {
        System.out.println("LOADING REVIEWS");
        List<Review> reviews = reviewService.getReviewsByProductId(productId);
        System.out.println("reviews");
        List<ReviewDTO> reviewDtoList = new ArrayList<>();
        for (Review review : reviews) {
            ReviewDTO reviewDTO = new ReviewDTO();
            reviewDTO.setReviewId(review.getReviewId());
            reviewDTO.setRating(review.getRating());
            reviewDTO.setComment(review.getComment());
            reviewDTO.setApprove(review.getApprove());
            reviewDTO.setProductName(review.getProduct().getName());
            reviewDTO.setUserName(review.getUser().getUserName());
            reviewDTO.setCreatedAt(review.getCreatedAt());
            reviewDtoList.add(reviewDTO);
        }
        return ResponseEntity.ok(reviewDtoList);
    }

    @PutMapping("/{reviewId}/approve")
    public ResponseEntity<?> approveReview(@PathVariable int reviewId) {
        reviewService.approveReview(reviewId);
        return ResponseEntity.ok(Map.of("message", "Review Approved"));
    }

    @DeleteMapping("/{reviewId}")
    public ResponseEntity<?> deleteReview(@PathVariable int reviewId) {
        reviewService.deleteReview(reviewId);
        return ResponseEntity.ok(Map.of("message", "Review Deleted"));
    }

    @DeleteMapping("/deleteReview")
    public ResponseEntity<?> deleteReviewByUser(@RequestHeader("Authorization") String authorizationHeader,
            @RequestParam int reviewId) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }
            reviewService.deleteReview(userId,reviewId);
            return ResponseEntity.ok(Map.of("message", "Review Deleted"));

        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", "Failed to delete review: " + e.getMessage()));
        }
    }

    @PostMapping("/createReview")
    public ResponseEntity<?> createReview(@RequestHeader("Authorization") String authorizationHeader,
            @RequestBody ReviewDTO reviewDTO) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);
            if (userId == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
            }
            // Call the service to create a new review
            reviewService.createReview(userId, reviewDTO);
            return ResponseEntity.ok(Map.of("message", "Review Created Successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", "Failed to create review: " + e.getMessage()));
        }
    }

    @GetMapping("/userReviews")
    public ResponseEntity<List<ReviewDTO>> getUserReviews(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            String token = authorizationHeader.replace("Bearer ", "");
            Long userId = jwtUtil.extractUserId(token);

            List<ReviewDTO> userReviews = reviewService.getUserReviews(userId);
            return ResponseEntity.ok(userReviews);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

}
