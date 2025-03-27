package com.ecommerce.admin.dto;

public class DashboardDTO {
    private Double totalSales;
    private int totalOrders;
    private int totalCustomers;

    public Double getTotalSales() {
        return totalSales;
    }
    public void setTotalSales(Double totalSales) {
        this.totalSales = totalSales;
    }
    public int getTotalOrders() {
        return totalOrders;
    }
    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }
    public int getTotalCustomers() {
        return totalCustomers;
    }
    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public DashboardDTO(){

    }
    public DashboardDTO(Double totalSales,int totalOrders,int totalCustomers){
        this.totalSales=totalSales;
        this.totalOrders=totalOrders;
        this.totalCustomers=totalCustomers;
    }
}
