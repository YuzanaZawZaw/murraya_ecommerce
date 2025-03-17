package com.ecommerce.customer.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.model.ProductMetrics;
import com.ecommerce.customer.repository.ProductMetricsRepository;

import jakarta.transaction.Transactional;
/**
*
* @author Yuzana Zaw Zaw
*/
@Service
public class ProductMetricsService {
    @Autowired
    private ProductMetricsRepository productMetricsRepository;

    @Transactional
    public void incrementViews(int productId) {
        ProductMetrics metrics = productMetricsRepository.findByProductProductId(productId)
                .orElse(new ProductMetrics());
        if (metrics.getMetricId() == null) {
            metrics.setProduct(new Product()); 
            metrics.getProduct().setProductId(productId);
        }

        metrics.setViews(metrics.getViews() + 1);
        productMetricsRepository.save(metrics);
    }

    @Transactional
    public void incrementPurchases(Integer productId) {
        ProductMetrics metrics = productMetricsRepository.findByProductProductId(productId)
                .orElse(new ProductMetrics());
        if (metrics.getMetricId() == null) {
            metrics.setProduct(new Product()); 
            metrics.getProduct().setProductId(productId);
        }
        metrics.setPurchases(metrics.getPurchases() + 1);
        metrics.setUpdatedAt(LocalDateTime.now());
        productMetricsRepository.save(metrics);
    }

    @Transactional
    public void incrementLikes(Integer productId) {
        ProductMetrics metrics = productMetricsRepository.findByProductProductId(productId)
                .orElse(new ProductMetrics());
        if (metrics.getMetricId() == null) {
            metrics.setProduct(new Product()); 
            metrics.getProduct().setProductId(productId);
        }

        metrics.setLikes(metrics.getLikes() + 1);
        metrics.setUpdatedAt(LocalDateTime.now());
        productMetricsRepository.save(metrics);
    }
}
