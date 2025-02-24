package com.ecommerce.customer.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ecommerce.customer.model.Category;

public interface CategoryRepository extends JpaRepository<Category, String>{

    List<Category> findByParentCategoryIsNull();

    List<Category> findByParentCategory(Category category);
    
}
