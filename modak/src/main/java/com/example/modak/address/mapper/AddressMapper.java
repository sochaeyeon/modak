package com.example.modak.address.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.address.model.Address;

@Mapper
public interface AddressMapper {
	
	// 배송지 추가
	public int insertAddress(HashMap<String, Object> map);
	
	// 배송지 목록 조회
	public List<Address> selectAddressList(HashMap<String, Object> map);
}
