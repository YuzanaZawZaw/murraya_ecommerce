package com.ecommerce.customer.dto;

import java.math.BigDecimal;

public class ProductDetailsDTO {
    private int productId;
    private String name;
    private String description;
    private BigDecimal price;
    private int imageId;
    private int views;
    private int purchases;
    private int likes;

    public ProductDetailsDTO() {

    }

    public ProductDetailsDTO(int productId, String name, String description, int imageId,String firstImageUrl,
    int views,int purchases,int likes) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.imageId=imageId;
        this.views=views;
        this.purchases=purchases;
        this.likes=likes;
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

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public int getPurchases() {
        return purchases;
    }

    public void setPurchases(int purchases) {
        this.purchases = purchases;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

}
