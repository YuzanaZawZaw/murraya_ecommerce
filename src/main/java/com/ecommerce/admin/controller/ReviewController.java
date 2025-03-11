package com.ecommerce.admin.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.MediaType;

import com.ecommerce.admin.dto.ReviewDTO;
import com.ecommerce.admin.service.ReviewService;
import com.ecommerce.customer.model.Review;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@RestController
@RequestMapping(value = "/admin/reviews", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
public class ReviewController {
@Autowired
    private ReviewService reviewService;

    @GetMapping("/{productId}")
    public ResponseEntity<List<ReviewDTO>> getReviewsByProductId(@PathVariable int productId) {
        List<Review> reviews=reviewService.getReviewsByProductId(productId);
        List<ReviewDTO> reviewDtoList = new ArrayList<>();
        for (Review review : reviews) {
            ReviewDTO reviewDTO=new ReviewDTO();
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

}
