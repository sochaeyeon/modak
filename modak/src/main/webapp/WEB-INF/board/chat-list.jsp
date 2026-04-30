<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅 목록 | 모닥모닥</title>
    <%@ include file="/WEB-INF/common/header.jsp" %>
    <style>
        :root {
            --cream:   #F6F0E6;
            --brown:   #3B2412;
            --brown2:  #5C3D1E;
            --orange:  #E8732A;
            --orange2: #F59248;
            --gray:    #8a8070;
            --border:  rgba(92,61,30,0.15);
            --card-bg: #FFFDF9;
        }

        body { background: var(--cream); font-family: 'Noto Sans KR', sans-serif; color: var(--brown); }

        /* ── 레이아웃 ─────────────────────── */
        .chat-wrap {
            max-width: 760px;
            margin: 48px auto;
            padding: 0 16px 80px;
        }

        /* ── 헤더 ─────────────────────────── */
        .chat-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
        }
        .chat-header h2 {
            font-size: 22px;
            font-weight: 700;
            color: var(--brown);
            margin: 0;
        }
        .chat-header .badge-count {
            background: var(--orange);
            color: #fff;
            font-size: 12px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            min-width: 24px;
            text-align: center;
        }

        /* ── 검색 ─────────────────────────── */
        .search-box {
            position: relative;
            margin-bottom: 20px;
        }
        .search-box input {
            width: 100%;
            padding: 13px 48px 13px 18px;
            border: 1.5px solid var(--border);
            border-radius: 14px;
            background: var(--card-bg);
            font-size: 14px;
            color: var(--brown);
            outline: none;
            box-sizing: border-box;
            transition: border-color .2s;
        }
        .search-box input:focus { border-color: var(--orange); }
        .search-box .ico-search {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
            font-size: 18px;
            pointer-events: none;
        }

        /* ── 목록 ─────────────────────────── */
        .room-list { display: flex; flex-direction: column; gap: 10px; }

        .room-card {
            display: flex;
            align-items: center;
            gap: 14px;
            background: var(--card-bg);
            border: 1.5px solid var(--border);
            border-radius: 18px;
            padding: 16px 18px;
            cursor: pointer;
            transition: border-color .2s, box-shadow .2s, transform .15s;
            text-decoration: none;
            color: inherit;
        }
        .room-card:hover {
            border-color: var(--orange);
            box-shadow: 0 4px 18px rgba(232,115,42,0.12);
            transform: translateY(-1px);
        }

        /* 아바타 */
        .avatar {
            position: relative;
            flex-shrink: 0;
        }
        .avatar img, .avatar .avatar-fallback {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--border);
        }
        .avatar .avatar-fallback {
            background: linear-gradient(135deg, var(--orange2), var(--orange));
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-weight: 700;
            font-size: 18px;
        }
        .avatar .unread-dot {
            position: absolute;
            bottom: 2px;
            right: 2px;
            width: 14px;
            height: 14px;
            background: var(--orange);
            border: 2px solid var(--card-bg);
            border-radius: 50%;
            font-size: 8px;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        /* 텍스트 */
        .room-info { flex: 1; min-width: 0; }
        .room-name {
            font-weight: 600;
            font-size: 15px;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .room-last {
            font-size: 13px;
            color: var(--gray);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* 시간 */
        .room-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 6px;
            flex-shrink: 0;
        }
        .room-time { font-size: 11px; color: var(--gray); }
        .unread-badge {
            background: var(--orange);
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            min-width: 20px;
            height: 20px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 5px;
        }

        /* ── 빈 상태 ───────────────────────── */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
        }
        .empty-state .ico { font-size: 56px; margin-bottom: 16px; }
        .empty-state p { color: var(--gray); font-size: 15px; line-height: 1.7; }

        /* ── 로딩 스켈레톤 ─────────────────── */
        @keyframes shimmer {
            0%   { background-position: -600px 0; }
            100% { background-position:  600px 0; }
        }
        .skeleton {
            background: linear-gradient(90deg, #ede8e0 25%, #f6f0e6 50%, #ede8e0 75%);
            background-size: 600px 100%;
            animation: shimmer 1.4s infinite;
            border-radius: 10px;
        }
        .skeleton-card {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px 18px;
            background: var(--card-bg);
            border: 1.5px solid var(--border);
            border-radius: 18px;
            margin-bottom: 10px;
        }
        .sk-avatar { width: 52px; height: 52px; border-radius: 50%; }
        .sk-lines  { flex: 1; }
        .sk-line1  { height: 14px; width: 55%; margin-bottom: 8px; }
        .sk-line2  { height: 12px; width: 80%; }
    </style>
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
