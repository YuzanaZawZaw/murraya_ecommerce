package com.ecommerce.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ecommerce.model.Status;
import com.ecommerce.repository.StatusRepository;

/**
*
* @author Yuzana Zaw Zaw
*/
@Service
public class StatusService {
    @Autowired
    public StatusRepository statusRepository;

    public List<Status> getStatusList() {
        return statusRepository.findAll();
    }
}
