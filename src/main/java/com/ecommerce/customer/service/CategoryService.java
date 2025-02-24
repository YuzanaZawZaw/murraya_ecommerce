package com.ecommerce.customer.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.customer.model.Category;
import com.ecommerce.customer.repository.CategoryRepository;
/**
*
* @author Yuzana Zaw Zaw
*/
@Service
public class CategoryService {
    @Autowired
    private CategoryRepository categoryRepository;

    public List<Category> getTopLevelCategories() {
        return categoryRepository.findByParentCategoryIsNull();
    }

    public Map<Category, List<Category>> getCategoryHierarchy() {
        List<Category> topLevelCategories = getTopLevelCategories();
        Map<Category, List<Category>> hierarchy = new HashMap<>();

        for (Category category : topLevelCategories) {
            List<Category> subCategories = categoryRepository.findByParentCategory(category);
            hierarchy.put(category, subCategories);
        }

        return hierarchy;
    }
}
