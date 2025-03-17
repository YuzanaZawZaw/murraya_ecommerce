package com.ecommerce.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.ecommerce.admin.dto.DiscountDTO;
import com.ecommerce.admin.model.ErrorResponse;
import com.ecommerce.customer.model.Discount;
import com.ecommerce.customer.model.Product;
import com.ecommerce.customer.service.DiscountService;

@RestController
@RequestMapping(value = "/admin/discounts", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
public class DiscountController {

    @Autowired
    private DiscountService discountService;

    @GetMapping("/apply")
    public ResponseEntity<?> getAppliedDiscount(@RequestParam int productId) {
        try {
            DiscountDTO dto = discountService.applyDiscount(productId);
            return ResponseEntity.ok(dto);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/applyDiscount")
    public ResponseEntity<?> applyDiscount(@RequestParam int productId, @RequestParam String discountCode) {
        try {
            Discount appliedDiscount = discountService.applyDiscountToProduct(productId, discountCode);
            if (appliedDiscount == null) {
                return ResponseEntity.status(400).body("Discount doesn't exist");
            }
            return ResponseEntity.ok(appliedDiscount);
        } catch (RuntimeException e) {
            ErrorResponse errorResponse = new ErrorResponse("Can't aplly discount " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    @PutMapping("/removeDiscount")
    public ResponseEntity<?> removeDiscount(@RequestParam int productId, @RequestParam String discountCode) {
        try {
            Product existingProduct = discountService.removeDiscountFromProduct(productId, discountCode);
            if (existingProduct == null) {
                return ResponseEntity.status(400).body("Product doesn't exist");
            }
            return ResponseEntity.ok(existingProduct);
        } catch (RuntimeException e) {
            ErrorResponse errorResponse = new ErrorResponse("Can't remove discount " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    // create discount
    @PostMapping("/addDiscount")
    public ResponseEntity<?> addDiscount(@RequestBody Discount discount) {
        try {
            Discount existDiscount = discountService.findDistcountByCode(discount.getCode());
            if (existDiscount != null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(Map.of("error", "Discount code is already defined. Try another one"));
            }
            Discount newDiscount = discountService.addDiscount(discount);
            return ResponseEntity.ok(newDiscount);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // update discount
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

    @GetMapping("/viewDiscount/{discountId}")
    @ResponseBody
    public ResponseEntity<?> viewDiscount(@PathVariable int discountId) {
        Discount existingDiscount = discountService.getDiscountById(discountId);
        Map<String, Object> response = new HashMap<>();
        response.put("discount", existingDiscount);
        return ResponseEntity.ok(response);
    }

}
