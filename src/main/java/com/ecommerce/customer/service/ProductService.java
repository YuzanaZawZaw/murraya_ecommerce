package com.ecommerce.customer.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    
}
