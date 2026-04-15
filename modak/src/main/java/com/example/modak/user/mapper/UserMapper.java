package com.example.modak.user.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.user.model.User;

@Mapper
public interface UserMapper {
	
	// 회원가입
	public int insertUser(HashMap<String, Object> map);
	
	// 회원 한 명 검색
	public User selectUser(HashMap<String, Object> map);
}
