package com.example.modak.camp.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MainMapper {
	// 베스트 대여 상품 4개
    List<HashMap<String, Object>> selectBestRentalList(HashMap<String, Object> map);
    
    // 신규 구매 상품 4개
    List<HashMap<String, Object>> selectNewPurchaseList(HashMap<String, Object> map);
    
    // 최신 리뷰 3개
    List<HashMap<String, Object>> selectLatestReviews(HashMap<String, Object> map);
}
