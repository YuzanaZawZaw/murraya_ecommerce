package com.ecommerce.customer.dto;

import java.math.BigDecimal;
/**
 *
 * @author Yuzana Zaw Zaw
 */
public class ProductDetailsDTO {
    private int productId;
    private String name;
    private String description;
    private BigDecimal price;
    private int imageId;

    private int discountId;
    private String discountCode;
    private BigDecimal discountedPrice;
    private Double discountPercentage;

    public ProductDetailsDTO() {

    }

    public ProductDetailsDTO(int productId, String name, String description, int imageId) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.imageId=imageId;
       
    }

    public ProductDetailsDTO(String name, String description, BigDecimal price,int imageId,String discountCode,
    BigDecimal discountedPrice,Double discountPercentage) {
        this.name = name;
        this.description = description;
        this.price=price;
        this.imageId=imageId;
        this.discountCode=discountCode;
        this.discountedPrice=discountedPrice;
        this.discountPercentage=discountPercentage;
    }
    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
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
    
}
