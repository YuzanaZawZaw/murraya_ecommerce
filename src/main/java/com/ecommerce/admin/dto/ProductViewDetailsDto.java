package com.ecommerce.admin.dto;

import java.math.BigDecimal;

import com.ecommerce.admin.model.Category;
import com.ecommerce.admin.model.Status;
/**
 *
 * @author Yuzana Zaw Zaw
 */
public class ProductViewDetailsDto {
    private int productId;
    private String name;
    private String description;
    private BigDecimal price;
    private int stockQuantity;
    private Category category;
    private Status status;

    public ProductViewDetailsDto(){

    }
    public ProductViewDetailsDto(int productId,String name,String description,BigDecimal price,int stockQuantity,
    Category category,Status status){
        this.productId=productId;
        this.name=name;
        this.description=description;
        this.price=price;
        this.stockQuantity=stockQuantity;
        this.category=category;
        this.status=status;
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
    public int getStockQuantity() {
        return stockQuantity;
    }
    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
    public Category getCategory() {
        return category;
    }
    public void setCategory(Category category) {
        this.category = category;
    }
    public Status getStatus() {
        return status;
    }
    public void setStatus(Status status) {
        this.status = status;
    }

}
