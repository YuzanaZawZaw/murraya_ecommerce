package com.ecommerce.customer.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.ecommerce.customer.dto.ImageDTO;
import com.ecommerce.customer.model.Image;
import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.repository.ImageRepository;
import com.ecommerce.customer.repository.ProductRepository;
/**
*
* @author Yuzana Zaw Zaw
*/
@Service
public class ImageService {

    @Autowired
    private ImageRepository imageRepository;

    @Autowired
    private ProductRepository productRepository;

    public void saveImage(int productId, MultipartFile[] images) throws IOException {
        
        for (MultipartFile file : images) {
       
            Product product=productRepository.getProductByProductId(productId);
            Image image = new Image();
            image.setProduct(product);
            image.setImageData(file.getBytes());
            image.setImageContentType(file.getContentType());
            image.setImageSize((int) file.getSize());
            image.setImageUrl(file.getOriginalFilename());
            imageRepository.save(image);
        }
        
    }

    public byte[] getImageById(int imageId) {
        return imageRepository.findById(imageId)
                .map(Image::getImageData)
                .orElse(null);
    }

    public List<ImageDTO> getImagesByProductId(int productId) {
        List<Image> images=imageRepository.findImagesByProductId(productId);
        List<ImageDTO> imageDTOs=new ArrayList<>();
        for (Image image : images) {
            ImageDTO imageDTO=new ImageDTO();
            imageDTO.setId(image.getImageId());
            imageDTO.setImageUrl(image.getImageUrl());
            imageDTO.setImageContentType(image.getImageContentType());
            imageDTO.setImageSize(image.getImageSize());
            imageDTOs.add(imageDTO);
        }
        return imageDTOs;
    }

    public String getImageContentTypeById(int imageId) {
        return imageRepository.findById(imageId)
                .map(Image::getImageContentType) 
                .orElseThrow(() -> new RuntimeException("Image not found"));
    }

    public void deleteImageById(int imageId) {
        imageRepository.deleteById(imageId);
    }
}
