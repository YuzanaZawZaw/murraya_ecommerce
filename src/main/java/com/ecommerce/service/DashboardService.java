package com.ecommerce.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.dto.DashboardDTO;
import com.ecommerce.repository.OrderRepository;
import com.ecommerce.repository.UserRepository;

/**
*
* @author Yuzana Zaw Zaw
*/
@Service
public class DashboardService {
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private UserRepository userRepository;

    public DashboardDTO getTotalSalesAndOrders() {
        DashboardDTO dashboardDTO=new DashboardDTO();
        Double totalSales=orderRepository.calculateTotalSales();
        int totalOrders=orderRepository.countTotalOrders(); 
        int totalCustomers = userRepository.countTotalUsers();
        dashboardDTO.setTotalSales(totalSales);
        dashboardDTO.setTotalOrders(totalOrders);
        dashboardDTO.setTotalCustomers(totalCustomers);
        return dashboardDTO;
    }

}
