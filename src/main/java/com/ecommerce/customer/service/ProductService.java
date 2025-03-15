package com.ecommerce.customer.service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.admin.dto.ProductDTO;
import com.ecommerce.customer.dto.ProductDetailsDTO;
import com.ecommerce.customer.model.Discount;
import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.repository.DiscountRepository;
import com.ecommerce.customer.repository.ProductRepository;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private DiscountRepository discountRepository;

    public Product addProduct(Product product) {
        return productRepository.save(product);
    }

    public List<Product> getProductList() {
        List<Product> productList = productRepository.findAll();
        return productList;
    }

    public List<ProductDTO> getAllProducts() {
        List<Product> productList = productRepository.findAll();
        List<ProductDTO> productDTOList = new ArrayList<>();
        for (Product product : productList) {
            ProductDTO productDTO = new ProductDTO();
            productDTO.setProductId(product.getProductId());
            productDTO.setProductName(product.getName());
            productDTOList.add(productDTO);
        }
        return productDTOList;
    }

    public Product getProductById(int productId) {
        Product product = productRepository.getProductByProductId(productId);
        return product;
    }

    public void deleteProduct(int productId) {
        Product product = productRepository.getProductByProductId(productId);
        productRepository.delete(product);
    }

    public void saveProduct(Product existingProduct) {
        productRepository.save(existingProduct);
    }

    private ProductDetailsDTO convertToDTO(Product product) {
        ProductDetailsDTO dto = new ProductDetailsDTO();
        dto.setProductId(product.getProductId());
        dto.setName(product.getName());
        dto.setDescription(product.getDescription());
        dto.setPrice(product.getPrice());

        if (product.getImages() != null && !product.getImages().isEmpty()) {
            dto.setImageId(product.getImages().get(0).getImageId());
        }

        // if (product.getMetrics() != null) {
        // dto.setViews(product.getMetrics().getViews());
        // dto.setPurchases(product.getMetrics().getPurchases());
        // dto.setLikes(product.getMetrics().getLikes());
        // }

        return dto;
    }

    public List<ProductDetailsDTO> getTrendingProducts(String categoryId) {
        return productRepository.findTrendingProductsByParentCategoryId(categoryId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<ProductDetailsDTO> getNewArrivals() {
        System.out.println("Fetching new arrivals...");
        LocalDateTime thirtyDaysAgoLocal = LocalDateTime.now().minusDays(30);
        Instant thirtyDaysAgoInstant = thirtyDaysAgoLocal.atZone(ZoneId.systemDefault()).toInstant();
        
        List<Product> products = productRepository.findNewArrivals(thirtyDaysAgoInstant);
        System.out.println("Fetched products: " + products);
        return products.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public void assignDiscountToProduct(int productId, int discountId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Discount discount = discountRepository.findById(discountId)
                .orElseThrow(() -> new RuntimeException("Discount not found"));

        product.setDiscount(discount);
        productRepository.save(product);
    }
}
