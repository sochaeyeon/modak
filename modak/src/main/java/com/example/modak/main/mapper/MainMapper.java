package com.example.modak.main.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.camp.model.Camp;

@Mapper
public interface MainMapper {
    // 메인화면 캠핑장 목록 조회
    List<Camp> selectMainCampList(HashMap<String, Object> params);

    // 메인 데이터 등록
    void insertMainCamp(HashMap<String, Object> params);

    // 메인 데이터 수정
    void updateMainCamp(HashMap<String, Object> params);

    // 메인 데이터 삭제
    void deleteMainCamp(HashMap<String, Object> params);
}