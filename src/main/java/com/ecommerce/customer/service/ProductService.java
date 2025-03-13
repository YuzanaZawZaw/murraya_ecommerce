package com.ecommerce.customer.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.admin.dto.ProductDTO;
import com.ecommerce.customer.dto.ProductDetailsDTO;
import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.repository.ProductRepository;
/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    public Product addProduct(Product product) {
       return productRepository.save(product);
    }

    public List<Product> getProductList() {
        List<Product> productList =productRepository.findAll();
        return productList;
    }

    public List<ProductDTO> getAllProducts() {
        List<Product> productList =productRepository.findAll();
        List<ProductDTO> productDTOList=new ArrayList<>();
        for(Product product:productList){
            ProductDTO productDTO=new ProductDTO();
            productDTO.setProductId(product.getProductId());
            productDTO.setProductName(product.getName());
            productDTOList.add(productDTO);
        }
        return productDTOList;
    }

    public Product getProductById(int productId) {
        Product product=productRepository.getProductByProductId(productId);
        return product;
    }

    public void deleteProduct(int productId) {
        Product product=productRepository.getProductByProductId(productId);
        productRepository.delete(product);
    }

    public void saveProduct(Product existingProduct) {
        productRepository.save(existingProduct);
    }
    
    // public List<ProductDetailsDTO> getTrendingProducts() {
    //     return productRepository.findTrendingProducts().stream()
    //             .map(this::convertToDTO)
    //             .collect(Collectors.toList());
    // }

    private ProductDetailsDTO convertToDTO(Product product) {
        ProductDetailsDTO dto = new ProductDetailsDTO();
        dto.setProductId(product.getProductId());
        dto.setName(product.getName());
        dto.setDescription(product.getDescription());
        dto.setPrice(product.getPrice());

        if (product.getImages() != null && !product.getImages().isEmpty()) {
            dto.setImageId(product.getImages().get(0).getImageId());
        }

        if (product.getMetrics() != null) {
            dto.setViews(product.getMetrics().getViews());
            dto.setPurchases(product.getMetrics().getPurchases());
            dto.setLikes(product.getMetrics().getLikes());
        }

        return dto;
    }

    public List<ProductDetailsDTO> getTrendingProducts(String categoryId) {
        return productRepository.findTrendingProductsByParentCategoryId(categoryId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

}
