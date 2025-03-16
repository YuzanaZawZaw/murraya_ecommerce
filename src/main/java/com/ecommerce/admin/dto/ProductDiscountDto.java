package com.ecommerce.admin.dto;

import java.math.BigDecimal;

public class ProductDiscountDto {
    private int productId;
    private String productName;
    private BigDecimal price;
    private int stockQuantity;
    private int discountId;

    private String discountCode;
    private BigDecimal discountedPrice;
    private Double discountPercentage;
    
    public ProductDiscountDto(){

    }
    public ProductDiscountDto(String productName,String discountCode,BigDecimal price,Double discountPercentage,BigDecimal discountedPrice){
        this.productName=productName;
        this.price=price;
        this.discountCode=discountCode;
        this.discountPercentage=discountPercentage;
        this.discountedPrice=discountedPrice;
    }

    public ProductDiscountDto(int productId,String productName,BigDecimal price,int stockQuantity,int discountId){
        this.productId=productId;
        this.productName=productName;
        this.price=price;
        this.stockQuantity=stockQuantity;
        this.discountId=discountId;
    }
    public String getDiscountCode() {
        return discountCode;
    }
    public void setDiscountCode(String discountCode) {
        this.discountCode = discountCode;
    }
    public BigDecimal getDiscountedPrice() {
        return discountedPrice;
    }
    public void setDiscountedPrice(BigDecimal discountedPrice) {
        this.discountedPrice = discountedPrice;
    }
    public Double getDiscountPercentage() {
        return discountPercentage;
    }
    public void setDiscountPercentage(Double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }
    public int getDiscountId() {
        return discountId;
    }
    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }
    public int getProductId() {
        return productId;
    }
    public void setProductId(int productId) {
        this.productId = productId;
    }
    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }
    public BigDecimal getPrice() {
        return price;
    }
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    public int getStockQuantity() {
        return stockQuantity;
    }
    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
}
