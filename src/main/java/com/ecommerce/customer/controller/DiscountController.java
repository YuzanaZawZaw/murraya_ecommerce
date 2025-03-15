package com.ecommerce.customer.controller;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ecommerce.admin.model.ErrorResponse;
import com.ecommerce.customer.model.Discount;
import com.ecommerce.customer.service.DiscountService;

@RestController
@RequestMapping("/admin/discounts")
public class DiscountController {
    @Autowired
    private DiscountService discountService;

    @PostMapping("/apply")
    public ResponseEntity<String> applyDiscount(@RequestParam int productId) {
        try {
            BigDecimal discountedPrice = discountService.applyDiscount(productId);
            return ResponseEntity.ok("Discounted Price: " + discountedPrice);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/apply/{productId}")
    public ResponseEntity<?> applyDiscount(@PathVariable int productId, @RequestBody Discount discount) {
        try {
            Discount appliedDiscount = discountService.applyDiscountToProduct(productId, discount);
            return ResponseEntity.ok(appliedDiscount);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/addDiscount")
    public ResponseEntity<?> addDiscount(@RequestBody Discount discount) {
        try {
            Discount newDiscount = discountService.addDiscount(discount);
            return ResponseEntity.ok(newDiscount);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    
    @PutMapping("/updateDiscount/{discountId}")
    public ResponseEntity<?> updateDiscount(@PathVariable int discountId, @RequestBody Discount updatedDiscount) {
        System.out.println("id from updateDiscount::::" + discountId);

        Discount existingDiscount = discountService.getDiscountById(discountId);
        try {
            if (existingDiscount != null) {
                existingDiscount.setCode(updatedDiscount.getCode());
                existingDiscount.setDiscountPercentage(updatedDiscount.getDiscountPercentage());
                existingDiscount.setFreeDelivery(updatedDiscount.getFreeDelivery());
                existingDiscount.setStartDate(updatedDiscount.getStartDate());
                existingDiscount.setEndDate(updatedDiscount.getEndDate());

                Discount savedDiscount = discountService.savedDiscount(existingDiscount);

                return ResponseEntity.ok(savedDiscount);
            } else {
                return ResponseEntity.status(400).body("Discount doesn't exist");
            }
        } catch (Exception e) {
            ErrorResponse errorResponse = new ErrorResponse("Can't update discount " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }

    }

    @DeleteMapping("/deleteDiscount/{discountId}")
    public ResponseEntity<?> deleteProduct(@PathVariable int discountId) {
        System.out.println("Hello from delete controller: " + discountId);
        try {
            Discount existDiscount = discountService.getDiscountById(discountId);

            if (existDiscount == null) {
                return ResponseEntity.status(400).body("Discount id : " + discountId + " not found");
            }

            discountService.deleteDiscount(existDiscount);
            return ResponseEntity.ok("Discount deleted successfully");
        } catch (Exception e) {
            ErrorResponse errorResponse = new ErrorResponse(
                    "Discount id : " + discountId + " not found" + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

}
