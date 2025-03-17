package com.ecommerce.customer.service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.ecommerce.admin.dto.ProductDTO;
import com.ecommerce.admin.dto.ProductDiscountDto;
import com.ecommerce.admin.dto.ProductViewDetailsDto;
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

    private final DiscountService discountService;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private DiscountRepository discountRepository;

    ProductService(DiscountService discountService) {
        this.discountService = discountService;
    }

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

    public List<ProductDTO> getAllProducts(String query) {
        List<Product> productList = productRepository.findAllByQuery(query);
        List<ProductDTO> productDTOList = new ArrayList<>();
        for (Product product : productList) {
            ProductDTO productDTO = new ProductDTO();
            productDTO.setProductId(product.getProductId());
            productDTO.setProductName(product.getName());
            productDTOList.add(productDTO);
        }
        return productDTOList;
    }

    public ProductViewDetailsDto convertToProductViewDetailsDto(Product product) {
        ProductViewDetailsDto dto = new ProductViewDetailsDto();
        dto.setProductId(product.getProductId());
        dto.setName(product.getName());
        dto.setDescription(product.getDescription());
        dto.setPrice(product.getPrice());
        dto.setStockQuantity(product.getProductId());
        dto.setStatus(product.getStatus());
        dto.setCategory(product.getCategory());
        return dto;
    }

    public ProductViewDetailsDto getProductById(int productId) {
        Product product = productRepository.getProductByProductId(productId);
        return convertToProductViewDetailsDto(product);
    }

    public Product getProductByProductId(int productId) {
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

        if (product.getDiscount() != null) {
            dto.setDiscountCode(product.getDiscount().getCode());
            dto.setDiscountPercentage(product.getDiscount().getDiscountPercentage());
            dto.setDiscountedPrice(discountService.getDiscountedPrice(product));
        }

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

    public Page<ProductDiscountDto> searchProducts(String query, Pageable pageable) {
        return productRepository.searchProducts(query, pageable)
                .map(this::convertToProductDiscountDto);
    }

    public List<ProductDetailsDTO> userSearchProducts(String query) {
        List<ProductDetailsDTO> dto=productRepository.searchProducts(query).stream().map(this::convertToDTO)
        .collect(Collectors.toList());
        return dto;
    }

    private ProductDiscountDto convertToProductDiscountDto(Product product) {
        ProductDiscountDto dto = new ProductDiscountDto();
        dto.setProductId(product.getProductId());
        dto.setProductName(product.getName());
        dto.setPrice(product.getPrice());
        dto.setStockQuantity(product.getStockQuantity());
        if (product.getDiscount() == null) {
            dto.setDiscountId(0);
        } else {
            dto.setDiscountId(product.getDiscount().getDiscountId());
            dto.setDiscountCode(product.getDiscount().getCode());
            dto.setDiscountPercentage(product.getDiscount().getDiscountPercentage());
            dto.setDiscountedPrice(discountService.getDiscountedPrice(product));
        }
        return dto;
    }

    public List<ProductDiscountDto> getProductListByDiscountId(int discountId) {
        List<ProductDiscountDto> productList = productRepository.getProductByDiscountId(discountId).stream()
                .map(this::convertToProductDiscountDto).collect(Collectors.toList());
        return productList;
    }

    public List<ProductDetailsDTO> getDiscountedProductList() {
        List<ProductDetailsDTO> productList = productRepository.findByDiscountIsNotNull().stream()
                .map(this::convertToDTO).collect(Collectors.toList());
        return productList;
    }

    public List<ProductDetailsDTO> getFreeDeliveryProductList() {
        List<ProductDetailsDTO> productList = productRepository.findDiscountedProductsWithFreeDelivery().stream()
        .map(this::convertToDTO).collect(Collectors.toList());
        return productList;
    }
}
