package com.ecommerce.customer.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonBackReference;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Entity
@Table(name = "product_metrics")
public class ProductMetrics {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer metricId;

    @OneToOne
    @JoinColumn(name = "product_id", referencedColumnName = "product_id", nullable = false)
    @JsonBackReference
    private Product product;

    private Integer views = 0;
    private Integer purchases = 0;
    private Integer likes = 0;

    @Column(name = "updated_at", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP")
    private LocalDateTime updatedAt;

    // Constructors
    public ProductMetrics() {}

    public ProductMetrics(Product product) {
        this.product = product;
        this.views = 0;
        this.purchases = 0;
        this.likes = 0;
    }

    // Getters and Setters
    public Integer getMetricId() {
        return metricId;
    }

    public void setMetricId(Integer metricId) {
        this.metricId = metricId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Integer getViews() {
        return views;
    }

    public void setViews(Integer views) {
        this.views = views;
    }

    public Integer getPurchases() {
        return purchases;
    }

    public void setPurchases(Integer purchases) {
        this.purchases = purchases;
    }

    public Integer getLikes() {
        return likes;
    }

    public void setLikes(Integer likes) {
        this.likes = likes;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
