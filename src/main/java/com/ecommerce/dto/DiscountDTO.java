package com.ecommerce.dto;

import java.math.BigDecimal;
/**
 *
 * @author Yuzana Zaw Zaw
 */
public class DiscountDTO {
    private String discountCode;
    private BigDecimal discountedPrice;
    private Double discountPercentage;

    public DiscountDTO(){

    }
    
    public DiscountDTO(String discountCode,BigDecimal discountedPrice,Double discountPercentage ){
        this.discountCode=discountCode;
        this.discountedPrice=discountedPrice;
        this.discountPercentage=discountPercentage;
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
