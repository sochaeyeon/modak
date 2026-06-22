package com.example.modak.product.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.example.modak.product.model.ProductQna;

@Mapper
public interface ProductQnaMapper {
    // QnA 목록 및 갯수 조회
    List<ProductQna> selectQnaList(HashMap<String, Object> map);
    int selectQnaTotalCount(HashMap<String, Object> map);

    // QnA 등록, 수정, 삭제
    int insertQna(ProductQna qna);
    int updateQna(ProductQna qna);
    int deleteQna(HashMap<String, Object> map);
    
    // 어드민 제품문의목록
    List<ProductQna> selectAdminQnaList(HashMap<String, Object> map);
    int updateQnaAnswer(HashMap<String, Object> map);
    
    // 어드민 사이드바 배지용 - 미답변 건수
    int selectWaitingQnaCount();
}