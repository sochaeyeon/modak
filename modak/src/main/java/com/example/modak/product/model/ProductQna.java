package com.example.modak.product.model; 

import lombok.Data;

@Data 
public class ProductQna {
    private Long qnaId;
    private Long productId;
    private String userId;
    
    private String optionName;      // 선택한 옵션 문자열
    private String questionContent; // 질문 내용
    private String answerContent;   // 답변 내용
    private String status;          // WAITING (대기), COMPLETED (완료)
    private String secretYn;        // 비밀글 여부 (Y/N)
    
    private String createdAt;
    private String updatedAt;
    private String answeredAt;

    // --- DB 테이블에는 없지만, 목록 화면에 뿌려줄 때 JOIN해서 가져올 추가 정보 ---
    private String nickname;        // 작성자 닉네임 (또는 마스킹된 아이디)
    private String profileImgUrl;   // 작성자 프로필 이미지 (리뷰처럼 보여줄 경우)
    
    private String productName; // admin 제품문의 목록용 JOIN 정보
}