package com.example.modak.user.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SmsAuthMapper {

    void expireSmsAuth(HashMap<String, Object> map);

    void insertSmsAuth(HashMap<String, Object> map);

    HashMap<String, Object> selectLatestSmsAuth(HashMap<String, Object> map);

    void updateSmsAuthVerified(HashMap<String, Object> map);

    HashMap<String, Object> selectVerifiedSmsAuth(HashMap<String, Object> map);
}