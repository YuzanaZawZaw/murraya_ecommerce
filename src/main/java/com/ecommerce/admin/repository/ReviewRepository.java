package com.ecommerce.admin.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ecommerce.customer.model.Review;

/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface ReviewRepository extends JpaRepository<Review, Long>{

    @Query("SELECT r FROM Review r WHERE r.product.productId = :productId")
    List<Review> getReviewsByProductId(@Param("productId") int productId);

    Review findByReviewId(long reviewId);

}
