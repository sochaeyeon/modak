<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="main-footer">
    <div class="footer-container">
        <div class="footer-top">
            <div class="footer-col">
                <h4 class="footer-logo">🔥 모닥모닥</h4>
                <p class="slogan">자연과 함께하는 특별한 순간을<br>모닥모닥이 함께합니다.</p>
            </div>

            <div class="footer-col">
                <h4>서비스</h4>
                <ul>
                    <li><a href="/rent">대여하기</a></li>
                    <li><a href="/buy">구매하기</a></li>
                    <li><a href="/campsite">캠핑장 찾기</a></li>
                    <li><a href="/new-items">신상품</a></li>
                    <li><a href="/best">베스트</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>고객지원</h4>
                <ul>
                    <li><a href="/notice">공지사항</a></li>
                    <li><a href="/faq">자주 묻는 질문</a></li>
                    <li><a href="/qna">1:1 문의</a></li>
                    <li><a href="/delivery">배송 조회</a></li>
                    <li><a href="/return">반품/교환</a></li>
                </ul>
            </div>

            <div class="footer-col info-col">
                <h4>문의</h4>
                <p class="cs-number">1588-0000</p>
                <p>운영시간<br>평일 09:00 - 18:00</p>
                <p>이메일<br><a href="mailto:hello@modakmodak.kr">hello@modakmodak.kr</a></p>
            </div>
        </div>

        <hr class="footer-divider">

        <div class="footer-bottom">
            <div class="copyright">
                © 2026 MODAK MODAK. All rights reserved.
            </div>
            <div class="legal-links">
                <a href="/terms.jsp">이용약관</a>
                <a href="/privacy-policy.jsp" class="bold">개인정보처리방침</a>
                <a href="/marketing-consent.jsp">환불정책</a>
            </div>
        </div>
    </div>
</footer>

<style>
    .main-footer {
        background-color: #fdfaf7; /* 디자인의 미색 배경 반영 */
        padding: 60px 0 30px;
        color: #555;
        font-size: 13px;
    }

    .footer-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .footer-top {
        display: flex;
        justify-content: space-between;
        margin-bottom: 40px;
    }

    .footer-col {
        flex: 1;
    }

    .footer-col h4 {
        font-size: 15px;
        font-weight: 700;
        color: #333;
        margin-bottom: 20px;
    }

    .footer-logo {
        font-size: 18px !important;
        color: #e67e22 !important;
    }

    .footer-col ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-col ul li {
        margin-bottom: 10px;
    }

    .footer-col a {
        color: #777;
        text-decoration: none;
        transition: color 0.2s;
    }

    .footer-col a:hover {
        color: #e67e22;
    }

    .slogan {
        line-height: 1.6;
        color: #888;
    }

    .cs-number {
        font-size: 20px;
        font-weight: 700;
        color: #333;
        margin-bottom: 10px;
    }

    .info-col p {
        line-height: 1.6;
        margin-bottom: 15px;
    }

    .footer-divider {
        border: 0;
        border-top: 1px solid #eee;
        margin-bottom: 20px;
    }

    .footer-bottom {
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #999;
        font-size: 12px;
    }

    .legal-links a {
        margin-left: 20px;
        color: #999;
        text-decoration: none;
    }

    .legal-links a.bold {
        font-weight: 700;
        color: #666; /* 개인정보처리방침 강조 */
    }
</style>