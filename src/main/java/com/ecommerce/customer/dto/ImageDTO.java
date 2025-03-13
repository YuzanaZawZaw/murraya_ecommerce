package com.ecommerce.customer.dto;

public class ImageDTO {
    private int id;
    private String imageUrl;
    private long imageSize;
    private String imageContentType;
    public ImageDTO(){

    }
    public ImageDTO(int id,String imageUrl,long imageSize,String imageContentType){
        this.id=id;
        this.imageUrl=imageUrl;
        this.imageSize=imageSize;
        this.imageContentType=imageContentType;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    public long getImageSize() {
        return imageSize;
    }
    public void setImageSize(long imageSize) {
        this.imageSize = imageSize;
    }
    public String getImageContentType() {
        return imageContentType;
    }
    public void setImageContentType(String imageContentType) {
        this.imageContentType = imageContentType;
    }
    
}
