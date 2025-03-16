package com.ecommerce.customer.model;

import java.time.LocalDate;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

@Entity
public class Discount {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int discountId;

    @OneToMany(mappedBy = "discount", cascade = CascadeType.ALL)
    @JsonBackReference
    private Set<Product> products;

    private String code;
    private Double discountPercentage;
    
    private Boolean freeDelivery;
    private LocalDate startDate;
    private LocalDate endDate;

    public Discount() {
    }

    public Discount(String code, Double discountPercentage, Boolean freeDelivery, LocalDate startDate, LocalDate endDate) {
        this.code = code;
        this.discountPercentage = discountPercentage;
        this.freeDelivery = freeDelivery;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public Set<Product> getProducts() {
        return products;
    }

    public void setProducts(Set<Product> products) {
        this.products = products;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }


    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public Double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(Double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public Boolean getFreeDelivery() {
        return freeDelivery;
    }

    public void setFreeDelivery(Boolean freeDelivery) {
        this.freeDelivery = freeDelivery;
    }
}