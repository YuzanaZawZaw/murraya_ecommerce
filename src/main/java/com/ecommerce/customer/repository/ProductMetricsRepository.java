package com.ecommerce.customer.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ecommerce.customer.model.ProductMetrics;
/**
*
* @author Yuzana Zaw Zaw
*/
@Repository
public interface ProductMetricsRepository extends JpaRepository<ProductMetrics, Integer>{

    Optional<ProductMetrics> findByProductProductId(int productId);

}
