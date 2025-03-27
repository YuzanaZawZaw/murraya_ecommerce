package com.ecommerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import com.ecommerce.model.Wishlist;
import com.ecommerce.repository.ProductRepository;
import com.ecommerce.repository.UserRepository;
import com.ecommerce.repository.WishlistRepository;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Service
public class WishlistService {

    @Autowired
    private WishlistRepository wishlistRepository;
    
    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    public void addToWishlist(Long userId, int productId) {
        Product product = productRepository.getProductByProductId(productId);

        User user= userRepository.findById(userId.intValue()).orElseThrow(() -> new IllegalArgumentException("User not found."));
        if (product == null) {
            throw new IllegalArgumentException("Product not found.");
        }   
 
        Wishlist wishlist = new Wishlist();
        wishlist.setUser(user);
        wishlist.setProduct(product);
        wishlistRepository.save(wishlist);
    }

    public void removeFromWishlist(Long userId, int productId) {
        Wishlist wishlist = wishlistRepository.findByUserUserIdAndProductProductId(userId, productId);
        if (wishlist != null) {
            wishlistRepository.delete(wishlist);
        } else {
            throw new IllegalArgumentException("Product not found in wishlist");
        }
    }

    public List<Wishlist> getWishlistItemsByUserId(Long userId) {
        return wishlistRepository.findAllByUserUserId(userId);
    }

    public boolean isProductInWishlist(Long userId, int productId) {
        Wishlist wishlist = wishlistRepository.findByUserUserIdAndProductProductId(userId, productId);
        return wishlist != null;
    }
}

