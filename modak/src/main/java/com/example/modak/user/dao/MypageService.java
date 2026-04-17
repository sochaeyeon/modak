package com.example.modak.user.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.modak.user.mapper.MypageMapper;
import com.example.modak.user.model.MypageSummary;
import com.example.modak.user.model.User;

@Service
public class MypageService {

    @Autowired
    MypageMapper mypageMapper;
    
    public User getMyPageUser(String userId) {
        return mypageMapper.selectMypageUser(userId);
    }
    
    public MypageSummary getMypageSummary(String userId) {
        return mypageMapper.selectMypageSummary(userId);
    }
}