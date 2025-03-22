package com.ecommerce.customer.service;

import com.ecommerce.customer.dto.OrderRequestDTO;
import com.ecommerce.customer.model.*;
import com.ecommerce.customer.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private ShippingAddressRepository shippingAddressRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private UserRepository userRepository;

    public void placeOrder(Long userId, OrderRequestDTO orderRequest) {
        // Fetch the user
        User user = userRepository.findById(userId.intValue())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Save the shipping address
        ShippingAddress shippingAddress = shippingAddressRepository.findByUser(user);
        if (shippingAddress != null) {
            shippingAddressRepository.delete(shippingAddress);
        }
        shippingAddress = new ShippingAddress();
        shippingAddress.setUser(user);
        shippingAddress.setAddressLine1(orderRequest.getShippingAddress().getAddressLine1());
        shippingAddress.setAddressLine2(orderRequest.getShippingAddress().getAddressLine2());
        shippingAddress.setCity(orderRequest.getShippingAddress().getCity());
        shippingAddress.setState(orderRequest.getShippingAddress().getState());
        shippingAddress.setPostalCode(orderRequest.getShippingAddress().getZipCode());
        shippingAddress.setCountry(orderRequest.getShippingAddress().getCountry());
        shippingAddress.setPhoneNumber(orderRequest.getShippingAddress().getPhoneNumber());
        shippingAddressRepository.save(shippingAddress);

        // Save the order
        Order order = new Order();
        order.setUser(user);
        order.setTotalAmount(orderRequest.getTotalAmount());
        order.setStatus(orderRequest.getStatus());
        order.setTax(orderRequest.getTax());
        order.setCreatedAt(LocalDateTime.now());
        orderRepository.save(order);

        // Save the order items
        orderRequest.getOrderItems().forEach(orderItemDTO -> {
            OrderItem orderItem = new OrderItem();
            Product product = new Product();
            product.setProductId(orderItemDTO.getProductId());
            orderItem.setOrder(order);
            orderItem.setProduct(product);
            orderItem.setQuantity(orderItemDTO.getQuantity());
            orderItem.setPrice(orderItemDTO.getPrice());
            orderItem.setTotalPrice(orderItemDTO.getTotalPrice());
            orderItemRepository.save(orderItem);
        });

        // Save the payment
        Payment payment = new Payment();
        payment.setUser(user);
        payment.setOrder(order);
        payment.setAmount(orderRequest.getTotalAmount());
        payment.setPaymentMethod(orderRequest.getPaymentMethod());
        payment.setStatus(Payment.PaymentStatus.PENDING);
        payment.setCreatedAt(LocalDateTime.now());
        paymentRepository.save(payment);
    }
}
