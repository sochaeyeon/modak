<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="admin-sidebar" id="adminSidebar">

    <!-- ── 로고 ── -->
    <div class="sl-logo">
        <div class="sl-logo-icon">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2C9 5.5 7.5 9 9 12.5c1-1.5 2.5-2.5 2.5-2.5S10.5 12.5 12 14.5c.8-1.5 2.5-3 2.5-4.5 0 1.5-.8 3-.8 3C15.5 12 16.5 9.5 16 7c-.8 2.5-2 4-4 3.5C14 8 13 5 12 2z" fill="currentColor"/>
                <ellipse cx="12" cy="20" rx="4" ry="1.5" fill="currentColor" opacity=".3"/>
            </svg>
        </div>
        <div class="sl-logo-text">
            <span class="sl-brand">모닥모닥</span>
            <span class="sl-panel">Admin Panel</span>
        </div>
    </div>

    <!-- ── 네비게이션 ── -->
    <div class="sl-nav">

        <div class="sl-section">Overview</div>
        <a href="/admin/dashboard.do" class="sl-item" data-path="/admin/dashboard.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="3" width="7" height="7" rx="1.5"/>
                    <rect x="14" y="3" width="7" height="7" rx="1.5"/>
                    <rect x="3" y="14" width="7" height="7" rx="1.5"/>
                    <rect x="14" y="14" width="7" height="7" rx="1.5"/>
                </svg>
            </div>
            <span>대시보드</span>
        </a>

        <div class="sl-section">매출 · 주문</div>
        <a href="/admin/sales.do" class="sl-item" data-path="/admin/sales.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="12" y1="1" x2="12" y2="23"/>
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
                </svg>
            </div>
            <span>매출 관리</span>
        </a>
        <a href="/admin/orders.do" class="sl-item" data-path="/admin/orders.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
            </div>
            <span>주문 관리</span>
        </a>
        <a href="/admin/rentals.do" class="sl-item" data-path="/admin/rentals.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9 22 9 12 15 12 15 22"/>
                </svg>
            </div>
            <span>대여 관리</span>
        </a>

        <div class="sl-section">상품 · 콘텐츠</div>
        <a href="/admin/products.do" class="sl-item" data-path="/admin/products.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                    <line x1="7" y1="7" x2="7.01" y2="7"/>
                </svg>
            </div>
            <span>상품 관리</span>
        </a>
        <a href="/admin/stats.do" class="sl-item" data-path="/admin/stats.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                </svg>
            </div>
            <span>조회수 통계</span>
        </a>
        <a href="/admin/events.do" class="sl-item" data-path="/admin/events.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
                </svg>
            </div>
            <span>이벤트 관리</span>
        </a>
        <a href="/admin/product-qna.do" class="sl-item" data-path="/admin/product-qna.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
            </div>
            <span>상품 문의</span>
            <span class="sl-badge" id="productQnaBadge" style="display:none">0</span>
        </a>

        <div class="sl-section">회원 · CS</div>
        <a href="/admin/members.do" class="sl-item" data-path="/admin/members.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                </svg>
            </div>
            <span>회원 관리</span>
        </a>
        <a href="/admin/inquiry.do" class="sl-item" data-path="/admin/inquiry.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                </svg>
            </div>
            <span>문의 답변</span>
            <span class="sl-badge" id="inquiryBadge" style="display:none">0</span>
        </a>
        <a href="/admin/reviews.do" class="sl-item" data-path="/admin/reviews.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
            </div>
            <span>리뷰 관리</span>
        </a>
        <a href="/admin/membership.do" class="sl-item" data-path="/admin/membership.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="8" r="6"/>
                    <path d="M15.477 12.89L17 22l-5-3-5 3 1.523-9.11"/>
                </svg>
            </div>
            <span>등급 관리</span>
        </a>

        <div class="sl-section">설정</div>
        <a href="/admin/coupons.do" class="sl-item" data-path="/admin/coupons.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                    <line x1="7" y1="7" x2="7.01" y2="7"/>
                </svg>
            </div>
            <span>쿠폰 관리</span>
        </a>
        <a href="/admin/camps.do" class="sl-item" data-path="/admin/camps.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="3 11 22 2 13 21 11 13 3 11"/>
                </svg>
            </div>
            <span>캠핑장 관리</span>
        </a>
        <a href="/admin/alarm.do" class="sl-item" data-path="/admin/alarm.do">
            <div class="sl-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                </svg>
            </div>
            <span>알람 관리</span>
        </a>

    </div><!-- sl-nav -->

    <!-- ── 푸터 ── -->
    <div class="sl-footer">
        <a href="/main.do" class="sl-footer-link">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:14px;height:14px;flex-shrink:0">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            </svg>
            사이트로 돌아가기
        </a>
    </div>

</nav>

<script>
/* active 감지 — URL 기반 */
(function() {
    var path = window.location.pathname;
    document.querySelectorAll('.sl-item[data-path]').forEach(function(el) {
        if (path === el.dataset.path) el.classList.add('active');
    });
})();

/* 미답변 문의 배지 */
$(function() {
    $.ajax({
        url: '/admin/inquiry/badge.dox', type: 'POST', dataType: 'json',
        success: function(res) {
            if (res && res.count > 0) {
                var b = document.getElementById('inquiryBadge');
                if (b) { b.textContent = res.count > 99 ? '99+' : res.count; b.style.display = 'inline-flex'; }
            }
        }
    });
});
</script>
