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
            <button type="button" class="btn-create-group" id="btnCreateGroup">
                <i class="ri-add-line"></i> 단체채팅 만들기
            </button>
        </div>

        <div class="search-box">
            <input type="text" id="searchInput" placeholder="대화 상대 또는 채팅방 검색…" oninput="filterRooms(this.value)">
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
            <p>아직 진행 중인 대화가 없어요.<br>상품 페이지에서 판매자에게 말을 걸거나 단체채팅을 만들어보세요!</p>
        </div>

    </div>

    <!-- 단체채팅 만들기 모달 -->
    <div class="modal-bg" id="createModal">
        <div class="modal-box">
            <div class="modal-title"><i class="ri-group-2-line"></i> 단체채팅 만들기</div>

            <input type="text" id="roomNameInput" class="group-input" placeholder="채팅방 이름을 입력하세요" maxlength="30">

            <div class="member-select-head">
                맞팔로우 멤버 선택 (<span id="selectedCount">0</span> / <span id="maxCount">49</span>)
            </div>

            <div class="member-select-list" id="mutualList">
                <div class="member-empty" id="mutualEmpty" style="display:none;">
                    맞팔로우 중인 사용자가 없어요.
                </div>
            </div>

            <div class="modal-btns">
                <button type="button" class="modal-btn cancel" id="createCancel">취소</button>
                <button type="button" class="modal-btn confirm-block" id="createConfirm" disabled>만들기</button>
            </div>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        let allRooms = [];
        let mutualUsers = [];
        let selectedIds = [];
        const MAX_MEMBER = 50;

        // ── 채팅방 목록 불러오기 (1:1 + 단체 병합) ──────────────
        function loadRooms() {
            Promise.all([
                fetch('/chat-room/rooms.dox', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }
                }).then(function (r) { return r.json(); }).catch(function () { return { result: 'fail' }; }),

                fetch('/chat-room/group/rooms.dox', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }
                }).then(function (r) { return r.json(); }).catch(function () { return { result: 'fail' }; })
            ]).then(function (results) {
                const res1 = results[0];
                const res2 = results[1];

                document.getElementById("skeletonWrap").style.display = "none";

                const directRooms = (res1.result === 'success' ? (res1.list || []) : []).map(normalizeDirect);
                const groupRooms = (res2.result === 'success' ? (res2.list || []) : []).map(normalizeGroup);

                allRooms = directRooms.concat(groupRooms).sort(function (a, b) {
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
                type: '1:1',
                roomId: r.ROOM_ID || r.roomId,
                otherId: r.OTHER_ID || r.otherId,
                name: r.OTHER_NICK || r.otherNick || r.OTHER_ID || r.otherId || '상대방',
                img: r.OTHER_IMG || r.otherImg,
                lastText: r.LAST_MSG || r.lastMsg || '',
                lastAtRaw: r.LAST_AT || r.lastAt,
                sortTime: r.LAST_AT || r.lastAt,
                unread: parseInt(r.UNREAD_COUNT || r.unreadCount || 0),
                memberCount: null
            };
        }

        function normalizeGroup(r) {
            return {
                type: 'GROUP',
                roomId: r.roomId,
                otherId: null,
                name: r.roomName || '단체채팅',
                img: null,
                lastText: r.lastMessage || '',
                lastAtRaw: r.lastMessageAt,
                sortTime: r.lastMessageAt,
                unread: 0,
                memberCount: r.memberCount || 0
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

                let avatarHtml, href, metaExtraHtml = '';

                if (r.type === 'GROUP') {
                    avatarHtml = '<div class="avatar group-avatar"><i class="ri-group-2-fill"></i></div>';
                    href = '/chat-room/group/room.do?roomId=' + encodeURIComponent(r.roomId);
                    metaExtraHtml = '<span class="room-member-count">' + r.memberCount + '명</span>';
                } else {
                    const imgHtml = r.img
                        ? '<img src="' + escHtml(r.img) + '" alt="">'
                        : '<div class="avatar-fallback">' + escHtml(String(r.name).charAt(0)) + '</div>';
                    const dotHtml = r.unread > 0
                        ? '<span class="unread-dot">' + (r.unread > 9 ? "9+" : r.unread) + '</span>'
                        : "";
                    avatarHtml = '<div class="avatar">' + imgHtml + dotHtml + '</div>';
                    href = '/chat-room/room.do?roomId=' + encodeURIComponent(r.roomId || "") + '&otherId=' + encodeURIComponent(r.otherId || "");
                }

                const badgeHtml = r.unread > 0
                    ? '<span class="unread-badge">' + (r.unread > 99 ? "99+" : r.unread) + '</span>'
                    : "";

                wrap.insertAdjacentHTML(
                    "beforeend",
                    '<a class="room-card" href="' + href + '">' +
                        avatarHtml +
                        '<div class="room-info">' +
                            '<div class="room-name">' + escHtml(r.name) + ' ' + metaExtraHtml + '</div>' +
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

        // ── 검색 필터 (이름/마지막메시지 공통) ─────────────────
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

        // ── 단체채팅 만들기 모달 ──────────────────────────────
        function openCreateModal() {
            document.getElementById('roomNameInput').value = '';
            selectedIds = [];
            updateSelectedCount();
            document.getElementById('createModal').classList.add('open');

            fetch('/follow/mutual.dox', { method: 'POST' })
                .then(function (res) { return res.json(); })
                .then(function (res) {
                    mutualUsers = (res.result === 'success') ? (res.list || []) : [];
                    renderMutualList();
                });
        }

        function closeCreateModal() {
            document.getElementById('createModal').classList.remove('open');
        }

        function renderMutualList() {
            const wrap = document.getElementById('mutualList');
            wrap.innerHTML = '';

            if (!mutualUsers.length) {
                document.getElementById('mutualEmpty').style.display = 'block';
                return;
            }
            document.getElementById('mutualEmpty').style.display = 'none';

            mutualUsers.forEach(function (u) {
                const imgHtml = u.profileImg
                    ? '<img src="' + escHtml(u.profileImg) + '">'
                    : '<div class="member-fb">' + escHtml((u.nickname || u.userName || '?').charAt(0)) + '</div>';

                wrap.insertAdjacentHTML('beforeend',
                    '<label class="member-row" data-user-id="' + escHtml(u.userId) + '">' +
                        '<input type="checkbox" class="member-check" value="' + escHtml(u.userId) + '">' +
                        '<div class="member-avatar">' + imgHtml + '</div>' +
                        '<span class="member-nick">' + escHtml(u.nickname || u.userName) + '</span>' +
                    '</label>'
                );
            });
        }

        function updateSelectedCount() {
            document.getElementById('selectedCount').textContent = selectedIds.length;
            document.getElementById('createConfirm').disabled =
                selectedIds.length === 0 || !document.getElementById('roomNameInput').value.trim();
        }

        // ── 초기화 ─────────────────────────────────────────
        document.addEventListener("DOMContentLoaded", function () {
            loadRooms();

            document.getElementById('btnCreateGroup').addEventListener('click', openCreateModal);
            document.getElementById('createCancel').addEventListener('click', closeCreateModal);

            document.getElementById('createModal').addEventListener('click', function (e) {
                if (e.target === this) closeCreateModal();
            });

            document.getElementById('roomNameInput').addEventListener('input', updateSelectedCount);

            document.getElementById('mutualList').addEventListener('change', function (e) {
                if (!e.target.classList.contains('member-check')) return;

                const id = e.target.value;

                if (e.target.checked) {
                    if (selectedIds.length >= MAX_MEMBER - 1) {
                        e.target.checked = false;
                        showToast('최대 ' + (MAX_MEMBER - 1) + '명까지 초대할 수 있어요.');
                        return;
                    }
                    selectedIds.push(id);
                } else {
                    selectedIds = selectedIds.filter(function (v) { return v !== id; });
                }

                updateSelectedCount();
            });

            document.getElementById('createConfirm').addEventListener('click', function () {
                const roomName = document.getElementById('roomNameInput').value.trim();
                if (!roomName) { showToast('채팅방 이름을 입력해주세요.'); return; }
                if (selectedIds.length === 0) { showToast('초대할 멤버를 선택해주세요.'); return; }

                this.disabled = true;
                this.textContent = '만드는 중…';

                fetch('/chat-room/group/create.dox', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                    body: 'roomName=' + encodeURIComponent(roomName)
                        + '&memberIds=' + encodeURIComponent(selectedIds.join(','))
                        + '&maxMember=' + MAX_MEMBER
                })
                    .then(function (res) { return res.json(); })
                    .then(function (res) {
                        if (res.result === 'success') {
                            location.href = '/chat-room/group/room.do?roomId=' + res.roomId;
                        } else {
                            showToast(res.message || '생성에 실패했습니다.');
                            document.getElementById('createConfirm').disabled = false;
                            document.getElementById('createConfirm').textContent = '만들기';
                        }
                    })
                    .catch(function () {
                        showToast('서버 오류가 발생했습니다.');
                        document.getElementById('createConfirm').disabled = false;
                        document.getElementById('createConfirm').textContent = '만들기';
                    });
            });
        });
    </script>

    <%@ include file="/WEB-INF/common/footer.jsp" %>
</body>
</html>