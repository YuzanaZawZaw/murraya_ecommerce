package com.ecommerce.admin.dto;

import java.util.Date;
/**
 *
 * @author Yuzana Zaw Zaw
 */
public class ReviewDTO {
    private long reviewId;
    private long userId;
    private String userName;
    private int productId;
    private String productName;
    private Integer rating;
    private String comment;
    private boolean approve;
    private Date createdAt;


    public ReviewDTO() {

    }

    public ReviewDTO(long reviewId, String userName, String productName, Integer rating, String comment,
            boolean approve,Date createdAt,long userId,int productId) {
        this.reviewId = reviewId;
        this.userName = userName;
        this.productName = productName;
        this.rating = rating;
        this.comment = comment;
        this.approve = approve;
        this.createdAt=createdAt;
        this.productId=productId;
        this.userId=userId;
    }
    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public long getReviewId() {
        return reviewId;
    }

    public void setReviewId(long reviewId) {
        this.reviewId = reviewId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public boolean isApprove() {
        return approve;
    }

    public void setApprove(boolean approve) {
        this.approve = approve;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

}
