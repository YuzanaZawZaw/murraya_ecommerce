package com.ecommerce.admin.dto;

import java.util.Date;

public class ReviewDTO {
    private long reviewId;
    private String userName;
    private String productName;
    private Integer rating;
    private String comment;
    private boolean approve;
    private Date createdAt;


    public ReviewDTO() {

    }

    public ReviewDTO(long reviewId, String userName, String productName, Integer rating, String comment,
            boolean approve,Date createdAt) {
        this.reviewId = reviewId;
        this.userName = userName;
        this.productName = productName;
        this.rating = rating;
        this.comment = comment;
        this.approve = approve;
        this.createdAt=createdAt;
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
