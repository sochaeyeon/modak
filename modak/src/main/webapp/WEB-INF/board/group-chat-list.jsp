<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>단체채팅 | 모닥모닥</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/group-chat-list.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="chat-wrap">

    <div class="chat-header">
        <h2>
            <i class="ri-group-2-line chat-title-icon"></i>
            단체채팅
        </h2>
        <button type="button" class="btn-create-group" id="btnCreateGroup">
            <i class="ri-add-line"></i> 단체채팅 만들기
        </button>
    </div>

    <div class="search-box">
        <input type="text" id="searchInput" placeholder="채팅방 이름 검색…" oninput="filterRooms(this.value)">
        <span class="ico-search"><i class="ri-search-line"></i></span>
    </div>

    <!-- 스켈레톤 -->
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

    <div class="room-list" id="roomList" style="display:none;"></div>

    <div class="empty-state" id="emptyState" style="display:none;">
        <div class="ico"><i class="ri-group-line"></i></div>
        <p>아직 참여 중인 단체채팅이 없어요.<br>맞팔로우한 친구들과 단체채팅을 시작해보세요!</p>
        <button type="button" class="btn-create-group" id="btnCreateGroupEmpty">
            <i class="ri-add-line"></i> 단체채팅 만들기
        </button>
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

    function loadRooms() {
        fetch('/chat-room/group/rooms.dox', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }
        })
            .then(function (res) { return res.json(); })
            .then(function (res) {
                document.getElementById('skeletonWrap').style.display = 'none';

                if (res.result !== 'success' || !res.list || res.list.length === 0) {
                    document.getElementById('roomList').style.display = 'none';
                    document.getElementById('emptyState').style.display = 'block';
                    return;
                }

                allRooms = res.list;
                renderRooms(allRooms);
                document.getElementById('roomList').style.display = 'block';
            })
            .catch(function () {
                document.getElementById('skeletonWrap').style.display = 'none';
                document.getElementById('emptyState').style.display = 'block';
            });
    }

    function renderRooms(list) {
        const wrap = document.getElementById('roomList');
        wrap.innerHTML = '';

        if (!list || !list.length) {
            document.getElementById('emptyState').style.display = 'block';
            return;
        }
        document.getElementById('emptyState').style.display = 'none';

        list.forEach(function (r) {
            const roomId = r.roomId;
            const roomName = r.roomName || '단체채팅';
            const memberCount = r.memberCount || 0;
            const lastMessage = fnPreviewText(r.lastMessage);
            const lastAt = r.lastMessageAt || '';

            wrap.insertAdjacentHTML('beforeend',
                '<a class="room-card" href="/chat-room/group/room.do?roomId=' + encodeURIComponent(roomId) + '">' +
                    '<div class="avatar group-avatar"><i class="ri-group-2-fill"></i></div>' +
                    '<div class="room-info">' +
                        '<div class="room-name">' + escHtml(roomName) + ' <span class="room-member-count">' + memberCount + '명</span></div>' +
                        '<div class="room-last">' + escHtml(lastMessage) + '</div>' +
                    '</div>' +
                    '<div class="room-meta">' +
                        '<span class="room-time">' + escHtml(lastAt) + '</span>' +
                    '</div>' +
                '</a>'
            );
        });
    }

    function filterRooms(keyword) {
        if (!keyword.trim()) { renderRooms(allRooms); return; }
        const kw = keyword.toLowerCase();
        renderRooms(allRooms.filter(function (r) {
            return (r.roomName || '').toLowerCase().includes(kw);
        }));
    }

    function fnPreviewText(message) {
        if (!message) return '대화를 시작해보세요';
        const text = String(message).trim();
        if (text.startsWith('/img/chat/')) return '사진을 보냈습니다.';
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

    // ── 만들기 모달 ──────────────────────────────
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

    document.addEventListener('DOMContentLoaded', function () {
        loadRooms();

        document.getElementById('btnCreateGroup').addEventListener('click', openCreateModal);
        document.getElementById('btnCreateGroupEmpty').addEventListener('click', openCreateModal);
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