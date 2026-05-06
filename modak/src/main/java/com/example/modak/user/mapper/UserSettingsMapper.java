package com.example.modak.user.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.modak.user.model.PhoneVerification;
import com.example.modak.user.model.User;

@Mapper
public interface UserSettingsMapper {

	// 계정설정 정보 조회
	User selectUserSettings(String userId);

	// 기본정보 저장
	int updateUserBasicInfo(User user);

	// 번호 바뀌었을 때 인증상태 초기화
	int resetPhoneVerification(@Param("userId") String userId);

	// 인증번호 저장
	int insertPhoneVerification(PhoneVerification phoneVerification);

	// 최근 인증번호 조회
	PhoneVerification selectLatestPhoneVerification(@Param("userId") String userId, @Param("phone") String phone);

	// 인증 완료 처리
	int updatePhoneVerificationSuccess(@Param("verificationId") Long verificationId);

	// USER 테이블 인증 완료 처리
	int updateUserPhoneVerified(@Param("userId") String userId, @Param("userPhone") String userPhone);

	int updatePhoneVerifySuccess(User user);

	// 휴대폰 인증 완료 처리
	int updatePhoneVerified(HashMap<String, Object> map);

	// 휴대폰 번호 변경 시 인증 초기화
	int resetPhoneVerifyStatus(HashMap<String, Object> map);

	// 이름/닉네임만 수정
	int updateUserBasicInfo(HashMap<String, Object> map);

	int updateUserPassword(HashMap<String, Object> map);
	
	int deleteUser(String userId);
	
	int updateProfileImage(@Param("userId") String userId,
            @Param("profileImgUrl") String profileImgUrl);
}