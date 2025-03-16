package com.ecommerce.customer.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.admin.dto.DiscountDTO;
import com.ecommerce.customer.model.Discount;
import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.repository.DiscountRepository;
import com.ecommerce.customer.repository.ProductRepository;

import jakarta.transaction.Transactional;

@Service
public class DiscountService {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private DiscountRepository discountRepository;

    public BigDecimal getDiscountedPrice(Product product) {
        Discount discount = product.getDiscount();
        BigDecimal price = product.getPrice();
        double discountPercentage = discount.getDiscountPercentage();
        BigDecimal discountMultiplier = BigDecimal.valueOf(1 - discountPercentage / 100);
        BigDecimal discountedPrice = price.multiply(discountMultiplier);
        return discountedPrice;
    }

    public DiscountDTO applyDiscount(int productId) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Discount discount = product.getDiscount();

        if (discount == null) {
            throw new RuntimeException("No discount applied to this product");
        }

        BigDecimal price = product.getPrice();
        double discountPercentage = discount.getDiscountPercentage();
        BigDecimal discountMultiplier = BigDecimal.valueOf(1 - discountPercentage / 100);
        BigDecimal discountedPrice = price.multiply(discountMultiplier);

        DiscountDTO dto=new DiscountDTO();
        dto.setDiscountCode(discount.getCode());
        dto.setDiscountPercentage(discount.getDiscountPercentage());
        dto.setDiscountedPrice(discountedPrice);

        return dto;
    }

    @Transactional
    public Discount applyDiscountToProduct(int productId, String discountCode) {
        Product product = productRepository.getProductByProductId(productId);

        if (product == null) {
            throw new RuntimeException("Product not found");
        }

        // Discount discount = new Discount();
        // discount.setCode(discountDetails.getCode());
        // discount.setDiscountPercentage(discountDetails.getDiscountPercentage());
        // discount.setFreeDelivery(discountDetails.getFreeDelivery());
        // discount.setStartDate(discountDetails.getStartDate());
        // discount.setEndDate(discountDetails.getEndDate());

        // discount = discountRepository.save(discount);

        Discount existDiscount=discountRepository.findDistcountByCode(discountCode);
        if(existDiscount==null){
            throw new RuntimeException("Discount not found");
        }
        product.setDiscount(existDiscount);
        productRepository.save(product);

        return existDiscount;
    }

    public List<Discount> getDiscountList() {
        List<Discount> discountList=discountRepository.findAll();
        return discountList;
    }

    public Discount addDiscount(Discount discountDetails) {
        Discount discount = new Discount();
        discount.setCode(discountDetails.getCode());
        discount.setDiscountPercentage(discountDetails.getDiscountPercentage());
        discount.setFreeDelivery(discountDetails.getFreeDelivery());
        discount.setStartDate(discountDetails.getStartDate());
        discount.setEndDate(discountDetails.getEndDate());

        discount = discountRepository.save(discount);

        return discount;
    }

    public Discount getDiscountById(int discountId) {
        Discount existDiscount=discountRepository.findDistcountByDiscountId(discountId);
        return existDiscount;
    }

    public Discount savedDiscount(Discount existingDiscount) {
        Discount savedDiscount=discountRepository.save(existingDiscount);
        return savedDiscount;
    }

    public void deleteDiscount(Discount existDiscount) {
        discountRepository.delete(existDiscount);
    }

    public Product removeDiscountFromProduct(int productId, String discountCode) {
        Discount existDiscount=discountRepository.findDistcountByCode(discountCode);
        Product product = productRepository.getProductByProductIdAndDiscountId(productId,existDiscount.getDiscountId());
        if(product==null){
            throw new RuntimeException("Product not found");
        }
        product.setDiscount(null);
        return productRepository.save(product);
    }
}
