package com.ecommerce.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.dto.ReviewDTO;
import com.ecommerce.model.Product;
import com.ecommerce.model.Review;
import com.ecommerce.model.User;
import com.ecommerce.repository.ProductRepository;
import com.ecommerce.repository.ReviewRepository;
import com.ecommerce.repository.UserRepository;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class ReviewService {
    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    private static final Logger logger = LoggerFactory.getLogger(ReviewService.class);

    public List<Review> getReviewsByProductId(int productId) {
        return reviewRepository.getReviewsByProductId(productId);
    }

    public void approveReview(long reviewId) {
        Review review = reviewRepository.findByReviewId(reviewId);
        review.setApprove(true);
        reviewRepository.save(review);
    }

    public void deleteReview(long reviewId) {
        reviewRepository.deleteById(reviewId);
    }

    public void createReview(long userId, ReviewDTO reviewDTO) {
        // Fetch the product and user entities
        Product product = productRepository.findById(reviewDTO.getProductId())
                .orElseThrow(() -> new IllegalArgumentException("Product not found"));
        User user = userRepository.findById((int) userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Create a new Review entity
        Review review = new Review();
        review.setProduct(product);
        review.setUser(user);
        review.setRating(reviewDTO.getRating());
        review.setComment(reviewDTO.getComment());
        review.setApprove(false); // Default to not approved
        review.setCreatedAt(
                java.util.Date.from(LocalDateTime.now().atZone(java.time.ZoneId.systemDefault()).toInstant()));

        // Save the review
        reviewRepository.save(review);
    }

    public List<ReviewDTO> getUserReviews(Long userId) {
        List<Review> reviews = reviewRepository.findByUserUserId(userId);
        return reviews.stream().map(review -> {
            ReviewDTO dto = new ReviewDTO();
            dto.setReviewId(review.getReviewId());
            dto.setProductId(review.getProduct().getProductId());
            dto.setProductName(review.getProduct().getName());
            dto.setRating(review.getRating());
            dto.setComment(review.getComment());
            dto.setCreatedAt(review.getCreatedAt());
            return dto;
        }).collect(Collectors.toList());
    }

    public void deleteReview(Long userId, int reviewId) {
        List<Review> reviews = reviewRepository.findByUserUserId(userId);
        logger.info("reviews ", reviews.size());
        for (Review review : reviews) {
            if (review.getReviewId() == reviewId) {
                reviewRepository.delete(review);
                break;
            }
        }
    }
}
