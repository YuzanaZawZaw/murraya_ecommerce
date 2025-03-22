package com.ecommerce.customer.service;

import com.ecommerce.customer.model.Cart;
import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.model.User;
import com.ecommerce.customer.repository.CartRepository;
import com.ecommerce.customer.repository.ProductRepository;
import com.ecommerce.customer.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    public void addToCart(Long userId, int productId, int quantity) {
        // Fetch the user
        User user = userRepository.findById(userId.intValue()).orElseThrow(() -> new IllegalArgumentException("User not found."));

        // Fetch the product
        Product product = productRepository.getProductByProductId(productId);
        if (product == null) {
            throw new IllegalArgumentException("Product not found.");
        }

        // Check if the product is already in the cart
        Cart existingCart = cartRepository.findByUserAndProduct(user, product);
        if (existingCart != null) {
            // Update the quantity if the product is already in the cart
            existingCart.setQuantity(existingCart.getQuantity() + quantity);
            cartRepository.save(existingCart);
        } else {
            // Add a new product to the cart
            Cart cart = new Cart();
            cart.setUser(user);
            cart.setProduct(product);
            cart.setQuantity(quantity);
            cart.setAddedAt(LocalDateTime.now());
            cartRepository.save(cart);
        }
    }

    public List<Cart> cartDetailsInfoByUserId(long userId) {
        return cartRepository.findAllByUserUserId(userId);
    }

    public void removeProductFromCart(Long userId, Long productId) {
        Cart cart = cartRepository.findByUserUserIdAndProductProductId(userId, productId);
        if (cart != null) {
            cartRepository.delete(cart);
        } else {
            throw new IllegalArgumentException("Product not found in cart");
        }
    }

    public void removeAllProductFromCart(Long userId) {
        List<Cart> cart = cartRepository.findByUserUserId(userId);
        for (Cart c : cart) {
            cartRepository.delete(c);
        }
    }
}
