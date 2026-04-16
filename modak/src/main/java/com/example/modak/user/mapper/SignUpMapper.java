package com.example.modak.user.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.user.model.User;

@Mapper
public interface SignUpMapper {

	// 회원가입
	public int insertUser(HashMap<String, Object> map);
	
	// 아이디 중복 찾기
	public User selectUser(HashMap<String, Object> map);
}
