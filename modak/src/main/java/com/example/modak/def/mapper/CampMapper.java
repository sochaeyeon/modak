package com.example.modak.def.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.modak.def.model.Camp;

@Mapper
public interface CampMapper {
    // 캠핑장 목록 조회
    List<Camp> selectCampList(HashMap<String, Object> params);

    // CAMP 테이블 저장
    int insertCampList(List<Camp> list);

    // CAMP_IMG 테이블 저장 (추가됨)
    int insertCampImg(HashMap<String, Object> params);

    // 리뷰 목록 조회
    List<HashMap<String, Object>> selectReviewList(HashMap<String, Object> params);

    // 리뷰 등록
    int insertReview(HashMap<String, Object> params);
}