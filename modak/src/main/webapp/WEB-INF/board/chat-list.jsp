<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅 목록 | 모닥모닥</title>
    <%@ include file="/WEB-INF/common/header.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/chat-list.css">
</head>
<body>

<div class="chat-wrap">

    <div class="chat-header">
        <h2>💬 채팅</h2>
        <span class="badge-count" id="totalUnread">0</span>
    </div>

    <div class="search-box">
        <input type="text" id="searchInput" placeholder="대화 상대 검색…" oninput="filterRooms(this.value)">
        <span class="ico-search">🔍</span>
    </div>

    <!-- 스켈레톤 (로딩 중) -->
    <div id="skeletonWrap">
        <c:forEach var="i" begin="1" end="4">
            <div class="skeleton-card">
                <div class="skeleton sk-avatar"></div>
                <div class="sk-lines">
                    <div class="skeleton sk-line1"></div>
                    <div class="skeleton sk-line2"></div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 실제 목록 -->
    <div class="room-list" id="roomList" style="display:none;"></div>

    <!-- 빈 상태 -->
    <div class="empty-state" id="emptyState" style="display:none;">
        <div class="ico">🏕️</div>
        <p>아직 진행 중인 대화가 없어요.<br>상품 페이지에서 판매자에게 먼저 말을 걸어보세요!</p>
    </div>

</div>

<script>
let allRooms = [];

// ── 채팅방 목록 불러오기 ──────────────────────────
function loadRooms() {
    $.ajax({
        url: '/chat-room/rooms.dox',
        type: 'POST',
        dataType: 'json',
        success: function(res) {
            $('#skeletonWrap').hide();
            if (res.result !== 'success' || !res.list || res.list.length === 0) {
                $('#emptyState').show();
                return;
            }
            allRooms = res.list;
            renderRooms(allRooms);
            $('#roomList').show();

            // 총 안읽음 배지
            const total = allRooms.reduce((s, r) => s + (parseInt(r.UNREAD_COUNT) || 0), 0);
            $('#totalUnread').text(total > 99 ? '99+' : total);
        },
        error: function() {
            $('#skeletonWrap').hide();
            $('#emptyState').show();
        }
    });
}

// ── 목록 렌더링 ────────────────────────────────────
function renderRooms(list) {
    const wrap = $('#roomList').empty();
    if (!list.length) { $('#emptyState').show(); return; }
    $('#emptyState').hide();

    list.forEach(function(r) {
        const unread  = parseInt(r.UNREAD_COUNT) || 0;
        const imgHtml = r.OTHER_IMG
            ? `<img src="${r.OTHER_IMG}" alt="">`
            : `<div class="avatar-fallback">${(r.OTHER_NICK || '?').charAt(0)}</div>`;
        const dotHtml = unread > 0
            ? `<span class="unread-dot">${unread > 9 ? '9+' : unread}</span>` : '';
        const badgeHtml = unread > 0
            ? `<span class="unread-badge">${unread > 99 ? '99+' : unread}</span>` : '';
        const timeStr  = formatTime(r.LAST_AT);
        const lastMsg  = r.LAST_MSG || '대화를 시작해보세요 🔥';

        wrap.append(`
            <a class="room-card" href="/chat-room/room.do?roomId=${r.ROOM_ID}&otherId=${r.OTHER_ID}">
                <div class="avatar">
                    ${imgHtml}
                    ${dotHtml}
                </div>
                <div class="room-info">
                    <div class="room-name">${escHtml(r.OTHER_NICK || r.OTHER_ID)}</div>
                    <div class="room-last">${escHtml(lastMsg)}</div>
                </div>
                <div class="room-meta">
                    <span class="room-time">${timeStr}</span>
                    ${badgeHtml}
                </div>
            </a>
        `);
    });
}

// ── 검색 필터 ──────────────────────────────────────
function filterRooms(keyword) {
    if (!keyword.trim()) { renderRooms(allRooms); return; }
    const kw = keyword.toLowerCase();
    renderRooms(allRooms.filter(r =>
        (r.OTHER_NICK || '').toLowerCase().includes(kw) ||
        (r.LAST_MSG   || '').toLowerCase().includes(kw)
    ));
}

// ── 유틸 ───────────────────────────────────────────
function formatTime(dateStr) {
    if (!dateStr) return '';
    const d   = new Date(dateStr.replace(' ', 'T'));
    const now  = new Date();
    const diff = (now - d) / 1000;
    if (diff < 60)         return '방금';
    if (diff < 3600)       return Math.floor(diff / 60) + '분 전';
    if (diff < 86400)      return Math.floor(diff / 3600) + '시간 전';
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const dd = String(d.getDate()).padStart(2, '0');
    return mm + '/' + dd;
}
function escHtml(str) {
    return String(str)
        .replace(/&/g,'&amp;').replace(/</g,'&lt;')
        .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

// ── 초기화 ─────────────────────────────────────────
$(function() { loadRooms(); });
</script>

<%@ include file="/WEB-INF/common/footer.jsp" %>
</body>
</html>
