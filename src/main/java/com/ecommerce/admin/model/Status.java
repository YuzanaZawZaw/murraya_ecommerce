package com.ecommerce.admin.model;

import jakarta.persistence.*;
/**
 *
 * @author Yuzana Zaw Zaw
 */
//JPA (Java Persistence API)
@Entity
@Table(name = "status") 
public class Status {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    @Column(name = "status_id")
    private int statusId;

    @Column(name = "status_name", nullable = false, length = 50) 
    private String statusName;

    @Column(name = "description", length = 255) 
    private String description;

    @ManyToOne 
    @JoinColumn(name = "parent_status_id",foreignKey = @ForeignKey(name = "status_ibfk_1")) 
    private Status parentStatus;

    public Status() {}

    public Status(String statusName, String description, Status parentStatus) {
        this.statusName = statusName;
        this.description = description;
        this.parentStatus = parentStatus;
    }

    // Getters and Setters
    

    public String getStatusName() {
        return statusName;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public Status getParentStatus() {
        return parentStatus;
    }

    public void setParentStatus(Status parentStatus) {
        this.parentStatus = parentStatus;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Status{" +
                "id=" + statusId +
                ", statusName='" + statusName + '\'' +
                ", description='" + description + '\'' +
                ", parentStatus=" + (parentStatus != null ? parentStatus.getStatusName() : "None") +
                '}';
    }
}