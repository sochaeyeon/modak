<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>채팅 | 모닥모닥</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/chat-list.css">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div class="chat-wrap">

                    <div class="chat-header">
                        <h2>
                            <i class="ri-chat-3-line chat-title-icon"></i>
                            채팅
                        </h2>
                        <span class="badge-count" id="totalUnread">0</span>
                        <button type="button" class="btn-create-group" id="btnCreateChat">
                            <i class="ri-add-line"></i> 새 채팅 시작
                        </button>
                    </div>

                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="대화 상대 또는 채팅방 검색…"
                            oninput="filterRooms(this.value)">
                        <span class="ico-search">
                            <i class="ri-search-line"></i>
                        </span>
                    </div>

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
                        <div class="ico">
                            <i class="ri-chat-off-line"></i>
                        </div>
                        <p>아직 진행 중인 대화가 없어요.<br>상품 페이지에서 판매자에게 말을 걸거나 새 채팅을 시작해보세요!</p>
                    </div>

                </div>

                <div class="modal-bg" id="createModal">
                    <div class="modal-box">
                        <div class="modal-title"><i class="ri-user-add-line"></i> 새 채팅 시작</div>

                        <div class="member-select-head">
                            맞팔로우 중인 사용자에게 대화를 걸어보세요
                        </div>

                        <div class="member-select-list" id="mutualList">
                            <div class="member-loading" id="mutualLoading">
                                <div class="member-spinner"></div>
                                불러오는 중…
                            </div>
                        </div>

                        <div class="modal-btns">
                            <button type="button" class="modal-btn cancel" id="createCancel">취소</button>
                            <button type="button" class="modal-btn confirm-block" id="createConfirm" disabled>대화
                                시작</button>
                        </div>
                    </div>
                </div>

                <div class="toast" id="toast"></div>

                <script>
                    let allRooms = [];
                    let mutualUsers = [];
                    let selectedUserId = null;

                    // ── 채팅방 목록 불러오기 (1:1만) ──────────────
                    function loadRooms() {
                        fetch('/chat-room/rooms.dox', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }
                        })
                            .then(function (r) { return r.json(); })
                            .catch(function () { return { result: 'fail' }; })
                            .then(function (res) {
                                document.getElementById("skeletonWrap").style.display = "none";

                                allRooms = (res.result === 'success' ? (res.list || []) : [])
                                    .map(normalizeDirect)
                                    .sort(function (a, b) {
                                        return new Date((b.sortTime || '').replace(' ', 'T')) - new Date((a.sortTime || '').replace(' ', 'T'));
                                    });

                                if (allRooms.length === 0) {
                                    document.getElementById("roomList").style.display = "none";
                                    document.getElementById("emptyState").style.display = "block";
                                    return;
                                }

                                renderRooms(allRooms);
                                document.getElementById("roomList").style.display = "block";

                                const total = allRooms.reduce(function (sum, r) { return sum + (r.unread || 0); }, 0);
                                document.getElementById("totalUnread").textContent = total > 99 ? "99+" : total;
                            });
                    }

                    // ── 데이터 정규화 ────────────────────────────────────
                    function normalizeDirect(r) {
                        return {
                            roomId: r.ROOM_ID || r.roomId,
                            otherId: r.OTHER_ID || r.otherId,
                            name: r.OTHER_NICK || r.otherNick || r.OTHER_ID || r.otherId || '상대방',
                            img: r.OTHER_IMG || r.otherImg,
                            lastText: r.LAST_MSG || r.lastMsg || '',
                            lastAtRaw: r.LAST_AT || r.lastAt,
                            sortTime: r.LAST_AT || r.lastAt,
                            unread: parseInt(r.UNREAD_COUNT || r.unreadCount || 0)
                        };
                    }

                    // ── 목록 렌더링 ────────────────────────────────────
                    function renderRooms(list) {
                        const wrap = document.getElementById("roomList");
                        wrap.innerHTML = "";

                        if (!list || !list.length) {
                            document.getElementById("emptyState").style.display = "block";
                            return;
                        }

                        document.getElementById("emptyState").style.display = "none";

                        list.forEach(function (r) {
                            const lastMsg = fnChatPreviewText(r.lastText);
                            const timeStr = formatTime(r.lastAtRaw);
                            const hasUnread = r.unread > 0;

                            const imgHtml = r.img
                                ? '<img src="' + escHtml(r.img) + '" alt="">'
                                : '<div class="avatar-fallback">' + escHtml(String(r.name).charAt(0)) + '</div>';
                            const dotHtml = hasUnread
                                ? '<span class="unread-dot">' + (r.unread > 9 ? "9+" : r.unread) + '</span>'
                                : "";
                            const avatarHtml = '<div class="avatar">' + imgHtml + dotHtml + '</div>';
                            const href = '/chat-room/room.do?roomId=' + encodeURIComponent(r.roomId || "") + '&otherId=' + encodeURIComponent(r.otherId || "");

                            const badgeHtml = hasUnread
                                ? '<span class="unread-badge">' + (r.unread > 99 ? "99+" : r.unread) + '</span>'
                                : "";

                            wrap.insertAdjacentHTML(
                                "beforeend",
                                '<a class="room-card' + (hasUnread ? ' has-unread' : '') + '" href="' + href + '">' +
                                avatarHtml +
                                '<div class="room-info">' +
                                '<div class="room-name">' + escHtml(r.name) + '</div>' +
                                '<div class="room-last">' + escHtml(lastMsg) + '</div>' +
                                '</div>' +
                                '<div class="room-meta">' +
                                '<span class="room-time">' + escHtml(timeStr) + '</span>' +
                                badgeHtml +
                                '</div>' +
                                '</a>'
                            );
                        });
                    }

                    // ── 검색 필터 ─────────────────────────────────────
                    function filterRooms(keyword) {
                        if (!keyword.trim()) { renderRooms(allRooms); return; }

                        const kw = keyword.toLowerCase();

                        renderRooms(allRooms.filter(function (r) {
                            return (r.name || '').toLowerCase().includes(kw) ||
                                (r.lastText || '').toLowerCase().includes(kw);
                        }));
                    }

                    // ── 유틸 ───────────────────────────────────────────
                    function formatTime(dateStr) {
                        if (!dateStr) return '';
                        const d = new Date(String(dateStr).replace(' ', 'T'));
                        if (isNaN(d.getTime())) return '';

                        const now = new Date();
                        const diff = (now - d) / 1000;
                        if (diff < 60) return '방금';
                        if (diff < 3600) return Math.floor(diff / 60) + '분 전';
                        if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
                        const mm = String(d.getMonth() + 1).padStart(2, '0');
                        const dd = String(d.getDate()).padStart(2, '0');
                        return mm + '/' + dd;
                    }

                    function fnChatPreviewText(message) {
                        if (!message) return "대화를 시작해보세요";

                        const text = String(message).trim();
                        const isImage =
                            text.startsWith("/upload/") ||
                            text.startsWith("/img/") ||
                            text.includes("/chat/") ||
                            /\.(jpg|jpeg|png|gif|webp|bmp)$/i.test(text);

                        if (isImage) return "사진을 보냈습니다.";
                        return text;
                    }

                    function escHtml(str) {
                        return String(str || '')
                            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
                    }

                    function showToast(msg) {
                        const t = document.getElementById('toast');
                        t.textContent = msg;
                        t.classList.add('show');
                        setTimeout(function () { t.classList.remove('show'); }, 2300);
                    }

                    // ── 새 채팅 시작 모달 ──────────────────────────────
                    function openCreateModal() {
                        selectedUserId = null;
                        document.getElementById('createConfirm').disabled = true;
                        document.getElementById('createModal').classList.add('open');

                        // 매번 열 때마다 로딩 상태부터 보여준다
                        const wrap = document.getElementById('mutualList');
                        wrap.innerHTML = '<div class="member-loading"><div class="member-spinner"></div>불러오는 중…</div>';

                        fetch('/follow/mutual.dox', { method: 'POST' })
                            .then(function (res) { return res.json(); })
                            .then(function (res) {
                                mutualUsers = (res.result === 'success') ? (res.list || []) : [];
                                renderMutualList();
                            })
                            .catch(function () {
                                mutualUsers = [];
                                renderMutualList();
                                showToast('사용자 목록을 불러오지 못했어요. 다시 시도해주세요.');
                            });
                    }

                    function closeCreateModal() {
                        document.getElementById('createModal').classList.remove('open');
                    }

                    function renderMutualList() {
                        const wrap = document.getElementById('mutualList');
                        wrap.innerHTML = '';

                        if (!mutualUsers.length) {
                            wrap.innerHTML = '<div class="member-empty">맞팔로우 중인 사용자가 없어요.</div>';
                            return;
                        }

                        mutualUsers.forEach(function (u) {
                            const imgHtml = u.profileImg
                                ? '<img src="' + escHtml(u.profileImg) + '">'
                                : '<div class="member-fb">' + escHtml((u.nickname || u.userName || '?').charAt(0)) + '</div>';

                            wrap.insertAdjacentHTML('beforeend',
                                '<label class="member-row" data-user-id="' + escHtml(u.userId) + '">' +
                                '<input type="radio" name="chatTarget" class="member-check" value="' + escHtml(u.userId) + '">' +
                                '<div class="member-avatar">' + imgHtml + '</div>' +
                                '<span class="member-nick">' + escHtml(u.nickname || u.userName) + '</span>' +
                                '</label>'
                            );
                        });
                    }

                    // ── 초기화 ─────────────────────────────────────────
                    document.addEventListener("DOMContentLoaded", function () {
                        loadRooms();

                        document.getElementById('btnCreateChat').addEventListener('click', openCreateModal);
                        document.getElementById('createCancel').addEventListener('click', closeCreateModal);

                        document.getElementById('createModal').addEventListener('click', function (e) {
                            if (e.target === this) closeCreateModal();
                        });

                        document.getElementById('mutualList').addEventListener('change', function (e) {
                            if (!e.target.classList.contains('member-check')) return;

                            // 선택된 행만 강조 표시
                            document.querySelectorAll('#mutualList .member-row').forEach(function (row) {
                                row.classList.remove('selected');
                            });
                            e.target.closest('.member-row').classList.add('selected');

                            selectedUserId = e.target.value;
                            document.getElementById('createConfirm').disabled = false;
                        });

                        document.getElementById('createConfirm').addEventListener('click', function () {
                            if (!selectedUserId) { showToast('대화할 상대를 선택해주세요.'); return; }

                            const $btn = document.getElementById('createConfirm');
                            $btn.disabled = true;
                            $btn.textContent = '연결 중…';

                            // roomId 없이 room.do로 바로 이동하면 "잘못된 접근"으로 막히므로
                            // create.dox로 방을 먼저 생성(또는 기존 방 조회)한 뒤 roomId를 받아서 이동한다.
                            fetch('/chat-room/create.dox', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                                body: 'toUser=' + encodeURIComponent(selectedUserId)
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    // 서버는 새로 만든 경우 "success", 이미 있던 방을 찾은 경우 "exists"를 리턴한다.
                                    // 둘 다 정상 케이스이므로 같이 처리해야 한다.
                                    if (res.result !== 'success' && res.result !== 'exists') {
                                        showToast(res.message || '채팅방을 시작할 수 없어요.');
                                        $btn.disabled = false;
                                        $btn.textContent = '대화 시작';
                                        return;
                                    }

                                    const roomId = res.roomId || res.ROOM_ID
                                        || (res.room && (res.room.roomId || res.room.ROOM_ID));

                                    if (!roomId) {
                                        showToast('채팅방 정보를 받지 못했어요.');
                                        $btn.disabled = false;
                                        $btn.textContent = '대화 시작';
                                        return;
                                    }

                                    location.href = '/chat-room/room.do?roomId=' + encodeURIComponent(roomId)
                                        + '&otherId=' + encodeURIComponent(selectedUserId);
                                })
                                .catch(function () {
                                    showToast('네트워크 오류가 발생했어요.');
                                    $btn.disabled = false;
                                    $btn.textContent = '대화 시작';
                                });
                        });
                    });
                </script>

                <%@ include file="/WEB-INF/common/footer.jsp" %>
        </body>

        </html>
