package com.example.modak.model;

import lombok.Data;

// 규칙
// 카멜표기법 사용
@Data
public class Default {
    // DB컬럼명과 똑같아야 함(대소문자 구분x, 카멜표기법 사용)
    // int userId;
    // String name;
    // int age;
    // String phone;

    // 테이블 조인할 경우
    // join 테이블
    // String GradeName;
}