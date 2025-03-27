package com.ecommerce.dto;

import java.math.BigDecimal;
import java.util.List;

import com.ecommerce.model.Image;
/**
 *
 * @author Yuzana Zaw Zaw
 */
public class ProductImagesDetailsDTO {
    private int productId;
    private String name;
    private String description;
    private BigDecimal price;
    private List<Image> images;
    private int stockQuantity;

    private int discountId;
    private String discountCode;
    private BigDecimal discountedPrice;
    private Double discountPercentage;
    private Boolean freeDelivery;

    public ProductImagesDetailsDTO() {

    }

    public ProductImagesDetailsDTO(String name, String description, BigDecimal price,List<Image> images,String discountCode,
    BigDecimal discountedPrice,Double discountPercentage,int stockQuantity,Boolean freeDelivery) {
        this.name = name;
        this.description = description;
        this.price=price;
        this.images=images;
        this.discountCode=discountCode;
        this.discountedPrice=discountedPrice;
        this.discountPercentage=discountPercentage;
        this.stockQuantity=stockQuantity;
        this.freeDelivery=freeDelivery;
    }

    public Boolean getFreeDelivery() {
        return freeDelivery;
    }

    public void setFreeDelivery(Boolean freeDelivery) {
        this.freeDelivery = freeDelivery;
    }
    
    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public List<Image> getImages() {
        return images;
    }

    public void setImages(List<Image> images) {
        this.images = images;
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
