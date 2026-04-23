<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="admin-sidebar">
    <div class="sidebar-logo">
        <span class="logo-fire">🔥</span>
        <span class="logo-text">모닥모닥</span>
        <span class="logo-sub">Admin Panel</span>
    </div>

    <div class="sidebar-nav">
        <div class="nav-section-label">Overview</div>
        <a href="/admin/dashboard.do" class="nav-item ${pageTitle == '대시보드' ? 'active' : ''}">
            <span class="nav-icon">📊</span> 대시보드
        </a>

        <div class="nav-section-label">매출 · 주문</div>
        <a href="/admin/sales.do" class="nav-item ${pageTitle == '매출관리' ? 'active' : ''}">
            <span class="nav-icon">💰</span> 매출 관리
        </a>
        <a href="/admin/orders.do" class="nav-item ${pageTitle == '주문관리' ? 'active' : ''}">
            <span class="nav-icon">📦</span> 주문 관리
        </a>
        <a href="/admin/rentals.do" class="nav-item ${pageTitle == '대여관리' ? 'active' : ''}">
            <span class="nav-icon">⛺</span> 대여 관리
        </a>

        <div class="nav-section-label">상품 · 콘텐츠</div>
        <a href="/admin/products.do" class="nav-item ${pageTitle == '상품관리' ? 'active' : ''}">
            <span class="nav-icon">🏕️</span> 상품 관리
        </a>
        <a href="/admin/stats.do" class="nav-item ${pageTitle == '조회수관리' ? 'active' : ''}">
            <span class="nav-icon">📈</span> 조회수 통계
        </a>
        <a href="/admin/events.do" class="nav-item ${pageTitle == '이벤트관리' ? 'active' : ''}">
            <span class="nav-icon">🎁</span> 이벤트 관리
        </a>

        <div class="nav-section-label">회원 · CS</div>
        <a href="/admin/members.do" class="nav-item ${pageTitle == '회원관리' ? 'active' : ''}">
            <span class="nav-icon">👥</span> 회원 관리
        </a>
        <a href="/admin/inquiry.do" class="nav-item ${pageTitle == '문의관리' ? 'active' : ''}">
            <span class="nav-icon">💬</span> 문의 답변
            <span class="nav-badge" id="inquiryBadge" style="display:none">0</span>
        </a>
        <a href="/admin/reviews.do" class="nav-item ${pageTitle == '리뷰관리' ? 'active' : ''}">
            <span class="nav-icon">⭐</span> 리뷰 관리
        </a>

        <a href="/admin/membership.do" class="nav-item ${pageTitle == '등급관리' ? 'active' : ''}">
            <span class="nav-icon">'💰</span> 등급 관리
        </a>

        <div class="nav-section-label">설정</div>
        <a href="/admin/coupons.do" class="nav-item ${pageTitle == '쿠폰관리' ? 'active' : ''}">
            <span class="nav-icon">🎫</span> 쿠폰 관리
        </a>
        <a href="/admin/camps.do" class="nav-item ${pageTitle == '캠핑장관리' ? 'active' : ''}">
            <span class="nav-icon">🗺️</span> 캠핑장 관리
        </a>
    </div>

    <div class="sidebar-footer">
        <a href="/main.do">← 사이트로 돌아가기</a>
    </div>
</nav>

<script>
/* 미답변 문의 배지 로드 */
$(function(){
    $.ajax({
        url: '/admin/inquiry/badge.dox', type: 'POST', dataType: 'json',
        success: function(res) {
            if (res.count > 0) {
                var badge = document.getElementById('inquiryBadge');
                if (badge) { badge.textContent = res.count; badge.style.display = 'inline-block'; }
            }
        }
    });
});
</script>
