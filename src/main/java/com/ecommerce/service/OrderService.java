package com.ecommerce.service;

import com.ecommerce.dto.OrderDTO;
import com.ecommerce.dto.OrderHistoryDTO;
import com.ecommerce.dto.OrderItemDTO;
import com.ecommerce.dto.OrderRequestDTO;
import com.ecommerce.dto.ShippingAddressDTO;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.Payment;
import com.ecommerce.model.Product;
import com.ecommerce.model.ShippingAddress;
import com.ecommerce.model.Status;
import com.ecommerce.model.User;
import com.ecommerce.repository.OrderItemRepository;
import com.ecommerce.repository.OrderRepository;
import com.ecommerce.repository.PaymentRepository;
import com.ecommerce.repository.ProductRepository;
import com.ecommerce.repository.ShippingAddressRepository;
import com.ecommerce.repository.StatusRepository;
import com.ecommerce.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

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

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private StatusRepository statusRepository;

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
        order.setEstimatedDeliveryDate(LocalDateTime.now().plusDays(3)); // Set estimated delivery date to 3 days from
                                                                         // now
        orderRepository.save(order);

        // Save the order items and update product stock
        orderRequest.getOrderItems().forEach(orderItemDTO -> {
            OrderItem orderItem = new OrderItem();
            Product product = productRepository.findById(orderItemDTO.getProductId())
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Product not found with ID: " + orderItemDTO.getProductId()));

            // Decrease stock quantity
            if (product.getStockQuantity() < orderItemDTO.getQuantity()) {
                throw new IllegalArgumentException("Insufficient stock for product: " + product.getName());
            }
            product.setStockQuantity(product.getStockQuantity() - orderItemDTO.getQuantity());
            productRepository.save(product);

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

    public List<OrderHistoryDTO> getOrderHistoryByUserId(Long userId) {
        List<Order> orders = orderRepository.findByUserUserId(userId);
        return orders.stream().map(order -> {
            OrderHistoryDTO dto = new OrderHistoryDTO();
            dto.setOrderId(order.getOrderId());
            dto.setTotalAmount(order.getTotalAmount());
            dto.setTax(order.getTax());
            dto.setStatus(order.getStatus().getStatusName());
            dto.setCreatedAt(order.getCreatedAt());
            dto.setEstimatedDeliveryDate(order.getEstimatedDeliveryDate());

            // Map order items
            List<OrderItemDTO> orderItems = order.getOrderItems().stream().map(orderItem -> {
                OrderItemDTO itemDTO = new OrderItemDTO();
                itemDTO.setProductName(orderItem.getProduct().getName());
                itemDTO.setQuantity(orderItem.getQuantity());
                itemDTO.setPrice(orderItem.getPrice());
                itemDTO.setTotalPrice(orderItem.getTotalPrice());
                return itemDTO;
            }).collect(Collectors.toList());
            dto.setOrderItems(orderItems);

            return dto;
        }).toList();
    }

    public List<OrderDTO> getAllOrders() {
        List<Order> orders = orderRepository.findAll();
        return orders.stream().map(order -> {
            OrderDTO dto = new OrderDTO();
            dto.setOrderId(order.getOrderId());
            dto.setCustomerName(order.getUser().getFirstName() + order.getUser().getLastName());
            dto.setTotalAmount(order.getTotalAmount());
            dto.setStatus(order.getStatus().getStatusName());
            dto.setCreatedAt(order.getCreatedAt());
            return dto;
        }).collect(Collectors.toList());
    }

    public List<OrderDTO> getOrdersByStatus(String statusName) {
        Status status = statusRepository.findStatusByStatusName(statusName);
        List<Order> orders = orderRepository.findOrderByStatus(status);
        return orders.stream().map(order -> {
            OrderDTO dto = new OrderDTO();
            dto.setOrderId(order.getOrderId());
            dto.setCustomerName(order.getUser().getFirstName() + " " + order.getUser().getLastName());
            dto.setTotalAmount(order.getTotalAmount());
            dto.setStatus(order.getStatus().getStatusName());
            dto.setCreatedAt(order.getCreatedAt());
            return dto;
        }).collect(Collectors.toList());
    }

    public void confirmOrder(int orderId, String statusName) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        Status status = statusRepository.findStatusByStatusName(statusName);
        order.setStatus(status);
        orderRepository.save(order);
    }

    public OrderDTO getOrderDetailsById(int orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found"));
        Status status = statusRepository.findStatusByStatusName(order.getStatus().getStatusName());
        ShippingAddress shippingAddress = shippingAddressRepository.findByUser(order.getUser());
        OrderDTO dto = new OrderDTO();
        dto.setOrderId(order.getOrderId());
        dto.setCustomerName(order.getUser().getFirstName() + " " + order.getUser().getLastName());
        dto.setTax(order.getTax());
        dto.setTotalAmount(order.getTotalAmount());
        dto.setStatus(status.getStatusName());
        dto.setCreatedAt(order.getCreatedAt());
        dto.setEstimatedDeliveryDate(order.getEstimatedDeliveryDate());

        // shipping address
        ShippingAddressDTO shippingAddressDTO = new ShippingAddressDTO();
        shippingAddressDTO.setAddressLine1(shippingAddress.getAddressLine1());
        shippingAddressDTO.setAddressLine2(shippingAddress.getAddressLine2());
        shippingAddressDTO.setCity(shippingAddress.getCity());
        shippingAddressDTO.setState(shippingAddress.getState());
        shippingAddressDTO.setZipCode(shippingAddress.getPostalCode());
        shippingAddressDTO.setCountry(shippingAddress.getCountry());
        shippingAddressDTO.setPhoneNumber(shippingAddress.getPhoneNumber());
        dto.setShippingAddressDTO(shippingAddressDTO);

        // order items
        dto.setOrderItems(order.getOrderItems().stream().map(item -> {
            OrderItemDTO itemDTO = new OrderItemDTO();
            itemDTO.setProductName(item.getProduct().getName());
            itemDTO.setQuantity(item.getQuantity());
            itemDTO.setPrice(item.getPrice());
            itemDTO.setTotalPrice(item.getTotalPrice());
            return itemDTO;
        }).collect(Collectors.toList()));
        return dto;
    }

    public List<OrderDTO> getOrdersByDateRange(LocalDate fromDate, LocalDate toDate) {
        List<Order> orders = orderRepository.findByCreatedAtBetween(fromDate.atStartOfDay(),
                toDate.atTime(23, 59, 59));
        
        return orders.stream().map(order -> {
            Status status = statusRepository.findStatusByStatusName(order.getStatus().getStatusName());
            OrderDTO dto = new OrderDTO();
            dto.setOrderId(order.getOrderId());
            dto.setCreatedAt(order.getCreatedAt());
            dto.setEstimatedDeliveryDate(order.getEstimatedDeliveryDate());
            dto.setStatus(status.getStatusName());
            dto.setTotalAmount(order.getTotalAmount());
            dto.setTax(order.getTax());
            dto.setOrderItems(order.getOrderItems().stream().map(item -> {
                OrderItemDTO itemDTO = new OrderItemDTO();
                itemDTO.setProductName(item.getProduct().getName());
                itemDTO.setQuantity(item.getQuantity());
                itemDTO.setPrice(item.getPrice());
                itemDTO.setTotalPrice(item.getQuantity() * item.getPrice());
                return itemDTO;
            }).collect(Collectors.toList()));
            return dto;
        }).collect(Collectors.toList());
    }

}
