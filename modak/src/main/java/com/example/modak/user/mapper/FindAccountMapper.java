package com.example.modak.user.mapper;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.user.model.User;

@Mapper
public interface FindAccountMapper {

	// 아이디 찾기
	public User selectUserId(HashMap<String, Object> map);

    User selectUserByNameAndPhone(HashMap<String, Object> map);
    
    // 이메일 인증
    User selectUserByIdAndEmail(HashMap<String, Object> map);

    int deletePwResetAuth(HashMap<String, Object> map);

    int insertPwResetAuth(HashMap<String, Object> map);

    Map<String, Object> selectPwResetAuth(HashMap<String, Object> map);

    int updatePwResetAuthVerified(HashMap<String, Object> map);

    Map<String, Object> selectVerifiedPwResetAuth(HashMap<String, Object> map);

    int updateUserPassword(HashMap<String, Object> map);
    
    User selectUserById(HashMap<String, Object> map);
}
