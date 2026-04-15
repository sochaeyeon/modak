package com.example.modak.cart.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.cart.mapper.CartMapper;

@Service
public class CartService {

	@Autowired 
	CartMapper cartMapper;
	
}
