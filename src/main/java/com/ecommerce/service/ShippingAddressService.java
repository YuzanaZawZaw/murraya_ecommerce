package com.ecommerce.service;

import com.ecommerce.dto.ShippingAddressDTO;
import com.ecommerce.model.ShippingAddress;
import com.ecommerce.repository.ShippingAddressRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ShippingAddressService {

    @Autowired
    private ShippingAddressRepository shippingAddressRepository;

    public ShippingAddressDTO getShippingAddressByUserId(Long userId) {
        ShippingAddress shippingAddress = shippingAddressRepository.findByUserUserId(userId);
        return convertToDTO(shippingAddress);
    }
    
    public ShippingAddressDTO convertToDTO(ShippingAddress shippingAddress) {
        ShippingAddressDTO shippingAddressDTO = new ShippingAddressDTO();
        shippingAddressDTO.setAddressLine1(shippingAddress.getAddressLine1());
        shippingAddressDTO.setAddressLine2(shippingAddress.getAddressLine2());
        shippingAddressDTO.setCity(shippingAddress.getCity());
        shippingAddressDTO.setState(shippingAddress.getState());
        shippingAddressDTO.setZipCode(shippingAddress.getPostalCode());
        shippingAddressDTO.setCountry(shippingAddress.getCountry());
        shippingAddressDTO.setPhoneNumber(shippingAddress.getPhoneNumber());
        return shippingAddressDTO;
    }
}
