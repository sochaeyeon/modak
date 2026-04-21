package com.example.modak.camp.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.modak.camp.model.Camp;

@Mapper
public interface CampMapper {

    /** 캠핑장 목록 조회 (중복 제거 DB 처리) */
    List<Camp> selectCampList(HashMap<String, Object> params);

    /** CAMP 테이블 저장 */
    int insertCampList(List<Camp> list);

    /** CAMP_IMG 테이블 저장 */
    int insertCampImg(HashMap<String, Object> params);

    /** 리뷰 목록 조회 */
    List<HashMap<String, Object>> selectReviewList(HashMap<String, Object> params);

    /** 리뷰 등록 */
    int insertReview(HashMap<String, Object> params);
}
