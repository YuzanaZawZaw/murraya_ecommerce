package com.ecommerce.repository;

import java.time.Instant;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ecommerce.model.Product;

/**
 *
 * @author Yuzana Zaw Zaw
 */
@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {

    Product getProductByProductId(int productId);

    @Query("SELECT p FROM Product p WHERE p.createdAt >= :dateThreshold")
    List<Product> findNewArrivals(@Param("dateThreshold") Instant dateThreshold);

    // @Query("SELECT p FROM Product p " +
    // "LEFT JOIN FETCH p.metrics pm " +
    // "LEFT JOIN FETCH p.images img " +
    // "LEFT JOIN p.category c " +
    // "WHERE p.status.statusId = 1 " +
    // "AND c.parentCategory.categoryId = :parentCategoryId " +
    // "AND img.imageId = (SELECT MIN(img2.imageId) FROM Image img2 WHERE
    // img2.product.productId = p.productId) " +
    // "ORDER BY COALESCE(pm.views, 4) DESC, COALESCE(pm.purchases, 4) DESC,
    // COALESCE(pm.likes, 4) DESC")
    // List<Product>
    // findTrendingProductsByParentCategoryId(@Param("parentCategoryId") String
    // parentCategoryId);

    @Query("SELECT p FROM Product p " +
            "LEFT JOIN FETCH p.metrics pm " +
            "LEFT JOIN FETCH p.images img " +
            "LEFT JOIN p.category c " +
            "WHERE p.status.statusId = 1 " +
            "AND c.parentCategory.categoryId = :parentCategoryId " +
            "AND (pm.views > 4) " + //OR pm.views IS NULL
            "AND (pm.likes > 4) " + // Show products with likes > 4 // no likes OR pm.likes IS NULL
            "AND img.imageId = (SELECT MIN(img2.imageId) FROM Image img2 WHERE img2.product.productId = p.productId) " +
            "ORDER BY COALESCE(pm.views, 0) DESC, COALESCE(pm.purchases, 0) DESC, COALESCE(pm.likes, 0) DESC")
    List<Product> findTrendingProductsByParentCategoryId(@Param("parentCategoryId") String parentCategoryId);

    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :query, '%'))")
    Page<Product> searchProducts(@Param("query") String query, Pageable pageable);

    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Product> findAllByQuery(@Param("query") String query);

    @Query("SELECT p FROM Product p WHERE p.productId = :productId AND p.discount.discountId = :discountId")
    Product getProductByProductIdAndDiscountId(@Param("productId") int productId, @Param("discountId") int discountId);

    @Query("SELECT p FROM Product p WHERE p.discount.discountId = :discountId")
    List<Product> getProductByDiscountId(@Param("discountId") int discountId);

    // List<Product> getDiscountedProductList();

    List<Product> findByDiscountIsNotNull();

    @Query("SELECT p FROM Product p JOIN p.discount d WHERE d IS NOT NULL AND d.freeDelivery = true")
    List<Product> findDiscountedProductsWithFreeDelivery();

    @Query("SELECT p FROM Product p WHERE LOWER(p.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(p.description) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<Product> searchProducts(@Param("query") String query);
    
    @Query("SELECT p FROM Product p " +
            "LEFT JOIN p.category c " +
            "WHERE p.status.statusId = 1 " +
            "AND c.parentCategory.categoryId = :parentCategoryId " )
    List<Product> findProductsByParentCategoryId(@Param("parentCategoryId") String parentCategoryId);

    @Query("SELECT p FROM Product p " +
            "LEFT JOIN p.category c " +
            "WHERE p.status.statusId = 1 " +
            "AND c.categoryId = :categoryId " )
    List<Product> findProductsByCategoryId(@Param("categoryId") String categoryId);

}
