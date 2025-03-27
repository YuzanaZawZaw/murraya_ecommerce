package com.ecommerce.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OrderDTO {
    private Integer orderId;
    private String customerName;
    private BigDecimal totalAmount;
    private BigDecimal tax;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime estimatedDeliveryDate;
    List<OrderItemDTO> orderItems;
    private ShippingAddressDTO shippingAddressDTO;
    
    public ShippingAddressDTO getShippingAddressDTO() {
        return shippingAddressDTO;
    }
    public void setShippingAddressDTO(ShippingAddressDTO shippingAddressDTO) {
        this.shippingAddressDTO = shippingAddressDTO;
    }
    public List<OrderItemDTO> getOrderItems() {
        return orderItems;
    }
    public void setOrderItems(List<OrderItemDTO> orderItems) {
        this.orderItems = orderItems;
    }
    public Integer getOrderId() {
        return orderId;
    }
    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }
    public String getCustomerName() {
        return customerName;
    }
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    public BigDecimal getTax() {
        return tax;
    }
    public void setTax(BigDecimal tax) {
        this.tax = tax;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    public LocalDateTime getEstimatedDeliveryDate() {
        return estimatedDeliveryDate;
    }
    public void setEstimatedDeliveryDate(LocalDateTime estimatedDeliveryDate) {
        this.estimatedDeliveryDate = estimatedDeliveryDate;
    }
    
}
