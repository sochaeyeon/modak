package com.example.modak.common;

public class Message {

   // 1. 성공 메세지    
   // 등록
    public static final String SUCCESS_ADD = "정상적으로 등록되었습니다.";
    
    // 수정
    public static final String SUCCESS_UPDATE = "정상적으로 수정되었습니다.";
    
    // 삭제
    public static final String SUCCESS_DELETE = "정상적으로 삭제되었습니다.";
    
    // 조회
    public static final String SUCCESS_SELECT = "정상적으로 조회되었습니다.";
    
    // 주문
    public static final String SUCCESS_ORDER = "주문이 완료되었습니다.";
    
    // 결제
    public static final String SUCCESS_PAYMENT = "결제가 완료되었습니다.";
    
    // 환불
    public static final String SUCCESS_REFUND = "환불이 완료되었습니다.";


    // 2. 실패 메세지    
    public static final String FAIL_ADD = "등록에 실패했습니다.";
    public static final String FAIL_UPDATE = "수정에 실패했습니다.";
    public static final String FAIL_DELETE = "삭제에 실패했습니다.";
    public static final String FAIL_SELECT = "조회에 실패했습니다.";
    
    public static final String FAIL_ORDER = "주문 처리에 실패했습니다.";
    public static final String FAIL_PAYMENT = "결제 처리에 실패했습니다.";


    // 3. 공통 에러 메세지    
    // 서버 에러
    public static final String ERROR_SERVER = "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.";
    
    // 일반 에러
    public static final String ERROR_COMMON = "예기치 못한 문제가 발생했습니다.";
    
    // 권한 없음
    public static final String ERROR_UNAUTHORIZED = "권한이 없습니다.";
    
    // 로그인 필요
    public static final String ERROR_LOGIN_REQUIRED = "로그인이 필요합니다.";


   // 4. 검증 메세지    
    public static final String VALID_REQUIRED = "필수 입력값입니다.";
    public static final String VALID_INVALID = "올바르지 않은 값입니다.";
    
    public static final String VALID_EMAIL = "이메일 형식이 올바르지 않습니다.";
    public static final String VALID_PASSWORD = "비밀번호 형식이 올바르지 않습니다.";


    // 5. 사용자 관련    
    public static final String USER_LOGIN_SUCCESS = "로그인되었습니다.";
    public static final String USER_LOGIN_FAIL = "아이디 또는 비밀번호가 올바르지 않습니다.";
    
    public static final String USER_SIGNUP_SUCCESS = "회원가입이 완료되었습니다.";
    public static final String USER_SIGNUP_FAIL = "회원가입에 실패했습니다.";
    
    public static final String USER_NOT_FOUND = "사용자 정보를 찾을 수 없습니다.";


   // 6. 기타 메세지    
    public static final String EMPTY_RESULT = "조회된 데이터가 없습니다.";
}