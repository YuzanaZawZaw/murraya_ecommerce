package com.ecommerce.admin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.admin.repository.ReviewRepository;
import com.ecommerce.customer.model.Review;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class ReviewService {
    @Autowired
    private ReviewRepository reviewRepository;

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

}
