package com.example.modak.address.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.address.model.Address;

@Mapper
public interface AddressMapper {
	
	public int insertAddress(HashMap<String, Object> map);
	
	public List<Address> selectAddressList(HashMap<String, Object> map);
	
	public int updateDefaultYnToN(HashMap<String, Object> map);
	
	public int updateAddress(HashMap<String, Object> map);
	
	public int deleteAddress(HashMap<String, Object> map);
	
	int updateUserPhoneIfEmpty(HashMap<String, Object> map);

}
