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
	
	// 기본 배송지 해제
	public int updateDefaultYnToN(HashMap<String, Object> map);
	
	// 배송지 수정
	public int updateAddress(HashMap<String, Object> map);
	
	// 배송지 삭제
	public int deleteAddress(HashMap<String, Object> map);

}
