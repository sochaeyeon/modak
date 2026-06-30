<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>단체채팅방 | 모닥모닥</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/group-chat-room.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div class="chat-layout">

    <!-- 상단 바 -->
    <div class="room-topbar">
        <button class="btn-back" id="btnBack" type="button" aria-label="뒤로가기">
            <i class="ri-arrow-left-line"></i>
        </button>
        <div class="top-avatar group-avatar"><i class="ri-group-2-fill"></i></div>
        <div class="top-info">
            <div class="top-name" id="topName">…</div>
            <div class="top-sub" id="topSub">멤버 0명</div>
        </div>
        <div class="btn-more" id="btnMore" role="button" tabindex="0" aria-label="채팅방 메뉴">
            <i class="ri-more-2-fill"></i>
            <div class="more-menu" id="moreMenu">
                <button id="menuMembers" type="button">
                    <i class="ri-team-line"></i><span>멤버 목록</span>
                </button>
                <button id="menuInvite" type="button" style="display:none;">
                    <i class="ri-user-add-line"></i><span>멤버 초대</span>
                </button>
                <button id="menuLeave" type="button">
                    <i class="ri-logout-box-r-line"></i><span>채팅방 나가기</span>
                </button>
            </div>
        </div>
    </div>

    <!-- 메시지 영역 -->
    <div class="msg-area" id="msgArea">
        <div class="empty-chat" id="emptyChat">
            <div class="empty-icon"><i class="ri-group-2-line"></i></div>
            <p>단체채팅이 시작됐어요!<br><strong>첫 메시지를 남겨보세요.</strong></p>
        </div>
        <div class="typing-wrap" id="typingWrap" style="display:none;">
            <div class="typing-text" id="typingText"></div>
        </div>
    </div>

    <div class="input-wrap" id="inputWrap">
        <div class="textarea-box">
            <input type="file" id="chatImageInput" accept="image/*" style="display:none;">
            <button type="button" class="btn-img" id="btnImage" aria-label="이미지 보내기">
                <i class="ri-image-add-line"></i>
            </button>
            <textarea id="msgInput" placeholder="메시지를 입력하세요" rows="1"></textarea>
        </div>
        <button class="btn-send" id="btnSend" type="button" disabled aria-label="메시지 전송">
            <i class="ri-send-plane-fill"></i>
        </button>
        <button type="button" class="btn-emoji" id="btnEmoji" aria-label="스티커 열기">
            <i class="ri-emotion-line"></i>
        </button>
    </div>
</div>

<div id="stickerPanel" class="sticker-panel">
    <c:if test="${false}"></c:if>
    <img src="/img/sticker/modak1.png"><img src="/img/sticker/modak2.png">
    <img src="/img/sticker/modak3.png"><img src="/img/sticker/modak4.png">
    <img src="/img/sticker/modak5.png"><img src="/img/sticker/modak6.png">
    <img src="/img/sticker/modak7.png"><img src="/img/sticker/modak8.png">
    <img src="/img/sticker/modak9.png"><img src="/img/sticker/modak10.png">
</div>

<!-- 멤버 목록 패널 -->
<div class="modal-bg" id="memberModal">
    <div class="modal-box member-modal-box">
        <div class="modal-title"><i class="ri-team-line"></i> 참여 멤버 (<span id="memberTotalCount">0</span>)</div>
        <div class="member-panel-list" id="memberPanelList"></div>
        <button type="button" class="delete-cancel-btn" id="memberModalClose">닫기</button>
    </div>
</div>

<!-- 멤버 초대 모달 -->
<div class="modal-bg" id="inviteModal">
    <div class="modal-box">
        <div class="modal-title"><i class="ri-user-add-line"></i> 멤버 초대</div>
        <div class="member-select-list" id="inviteList"></div>
        <div class="invite-empty" id="inviteEmpty" style="display:none;">초대할 수 있는 맞팔로우 친구가 없어요.</div>
        <div class="modal-btns">
            <button type="button" class="modal-btn cancel" id="inviteCancel">취소</button>
            <button type="button" class="modal-btn confirm-block" id="inviteConfirm" disabled>초대하기</button>
        </div>
    </div>
</div>

<!-- 채팅방 나가기 모달 -->
<div class="modal-bg" id="leaveRoomModal">
    <div class="modal-box">
        <div class="modal-icon leave-icon"><i class="ri-logout-box-r-line"></i></div>
        <div class="modal-title">채팅방을 나갈까요?</div>
        <div class="modal-desc">
            나가면 이 채팅방이 내 목록에서 사라집니다.<br>
            방장이 나가면 다음 멤버에게 방장이 위임됩니다.
        </div>
        <div class="modal-btns">
            <button class="modal-btn cancel" id="leaveCancel" type="button">취소</button>
            <button class="modal-btn confirm-block" id="leaveConfirm" type="button">나가기</button>
        </div>
    </div>
</div>

<div class="toast" id="toast"></div>

<script>
    var ROOM_ID = new URLSearchParams(location.search).get('roomId');
    var MY_ID = '${sessionScope.sessionId}';
    var pollTimer = null;
    var typingSendTimer = null;
    var lastMsgId = 0;
    var lastDateStr = '';
    var isHost = false;
    var memberMap = {};   // userId -> {nickname, profileImg, role}

    $(function () {
        if (!ROOM_ID) {
            showToast('잘못된 접근입니다.');
            setTimeout(function () { location.href = '/chat-room/group/list.do'; }, 1500);
            return;
        }

        loadMembers(true);
        loadMessages(false);
        startPolling();

        $('#btnBack').on('click', function () { history.back(); });

        $('#btnEmoji').on('click', function (e) {
            e.stopPropagation();
            $('#stickerPanel').toggle();
        });
        $(document).on('click', function () { $('#stickerPanel').hide(); });

        $('#stickerPanel img').on('click', function () {
            sendSticker($(this).attr('src'));
            $('#stickerPanel').hide();
        });

        $('#btnMore').on('click', function (e) {
            e.stopPropagation();
            $('#moreMenu').toggleClass('open');
        });
        $(document).on('click', function () { $('#moreMenu').removeClass('open'); });

        $('#menuMembers').on('click', function () {
            $('#moreMenu').removeClass('open');
            openMemberModal();
        });
        $('#memberModalClose').on('click', function () { $('#memberModal').removeClass('open'); });
        $('#memberModal').on('click', function (e) { if (e.target === this) $(this).removeClass('open'); });

        $('#menuInvite').on('click', function () {
            $('#moreMenu').removeClass('open');
            openInviteModal();
        });
        $('#inviteCancel').on('click', function () { $('#inviteModal').removeClass('open'); });
        $('#inviteModal').on('click', function (e) { if (e.target === this) $(this).removeClass('open'); });

        $('#menuLeave').on('click', function () {
            $('#moreMenu').removeClass('open');
            $('#leaveRoomModal').addClass('open');
        });
        $('#leaveCancel').on('click', function () { $('#leaveRoomModal').removeClass('open'); });
        $('#leaveRoomModal').on('click', function (e) { if (e.target === this) $(this).removeClass('open'); });
        $('#leaveConfirm').on('click', leaveRoom);

        $('#btnImage').on('click', function () { $('#chatImageInput').click(); });

        $('#chatImageInput').on('change', function () {
            if (!this.files || !this.files[0]) return;

            var formData = new FormData();
            formData.append('roomId', ROOM_ID);
            formData.append('image', this.files[0]);

            $.ajax({
                url: '/chat-room/group/send-image.dox', type: 'POST',
                data: formData, processData: false, contentType: false, dataType: 'json',
                success: function (res) {
                    if (res.result === 'success') {
                        $('#chatImageInput').val('');
                        loadMessages(true);
                    } else {
                        showToast(res.message || '이미지 전송 실패');
                    }
                },
                error: function () { showToast('이미지 전송 중 오류가 발생했습니다.'); }
            });
        });

        $('#btnSend').on('click', sendMessage);

        $('#msgInput')
            .on('input', function () {
                this.style.height = '22px';
                this.style.height = Math.min(this.scrollHeight, 96) + 'px';
                $('#btnSend').prop('disabled', !$(this).val().trim());
                sendTyping();
            })
            .on('keydown', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    if (!$('#btnSend').prop('disabled')) sendMessage();
                }
            });

        $('#msgArea').on('click', '.m-avatar, .m-nick', function () {
            var userId = $(this).closest('.msg-row').data('sender');
            if (userId) location.href = '/user/profile.do?userId=' + encodeURIComponent(userId);
        });
    });

    // ── 멤버 ─────────────────────────────────────
    function loadMembers(initial) {
        $.ajax({
            url: '/chat-room/group/members.dox', type: 'POST',
            data: { roomId: ROOM_ID }, dataType: 'json',
            success: function (res) {
                if (res.result !== 'success') return;

                memberMap = {};
                (res.list || []).forEach(function (m) {
                    memberMap[m.userId] = m;
                    if (m.userId === MY_ID && m.role === 'HOST') isHost = true;
                });

                $('#topSub').text('멤버 ' + (res.list || []).length + '명');
                $('#menuInvite').toggle(isHost);

                if (initial) {
                    $.ajax({
                        url: '/chat-room/group/rooms.dox', type: 'POST', dataType: 'json',
                        success: function (r2) {
                            var room = (r2.list || []).find(function (rm) {
                                return String(rm.roomId) === String(ROOM_ID);
                            });
                            if (room) $('#topName').text(room.roomName);
                        }
                    });
                }
            }
        });
    }

    function openMemberModal() {
        var list = Object.values(memberMap);
        $('#memberTotalCount').text(list.length);

        var html = '';
        list.forEach(function (m) {
            var imgHtml = m.profileImg
                ? '<img src="' + escAttr(m.profileImg) + '">'
                : '<div class="member-fb">' + escHtml((m.nickname || m.userId || '?').charAt(0)) + '</div>';

            html += '<div class="member-panel-row" data-user-id="' + escAttr(m.userId) + '">' +
                '<div class="member-avatar">' + imgHtml + '</div>' +
                '<span class="member-nick">' + escHtml(m.nickname || m.userId) + '</span>' +
                (m.role === 'HOST' ? '<span class="host-badge">방장</span>' : '') +
                '</div>';
        });

        $('#memberPanelList').html(html);
        $('#memberModal').addClass('open');

        $('#memberPanelList .member-panel-row').on('click', function () {
            location.href = '/user/profile.do?userId=' + encodeURIComponent($(this).data('user-id'));
        });
    }

    // ── 멤버 초대 ─────────────────────────────────
    function openInviteModal() {
        $('#inviteList').empty();
        $('#inviteEmpty').hide();
        $('#inviteConfirm').prop('disabled', true);

        $.ajax({
            url: '/follow/mutual.dox', type: 'POST', dataType: 'json',
            success: function (res) {
                var mutuals = (res.result === 'success') ? (res.list || []) : [];
                var candidates = mutuals.filter(function (u) { return !memberMap[u.userId]; });

                if (!candidates.length) {
                    $('#inviteEmpty').show();
                } else {
                    var html = '';
                    candidates.forEach(function (u) {
                        var imgHtml = u.profileImg
                            ? '<img src="' + escAttr(u.profileImg) + '">'
                            : '<div class="member-fb">' + escHtml((u.nickname || u.userName || '?').charAt(0)) + '</div>';

                        html += '<label class="member-row" data-user-id="' + escAttr(u.userId) + '">' +
                            '<input type="checkbox" class="invite-check" value="' + escAttr(u.userId) + '">' +
                            '<div class="member-avatar">' + imgHtml + '</div>' +
                            '<span class="member-nick">' + escHtml(u.nickname || u.userName) + '</span>' +
                            '</label>';
                    });
                    $('#inviteList').html(html);
                }

                $('#inviteModal').addClass('open');
            }
        });
    }

    $(document).on('change', '.invite-check', function () {
        $('#inviteConfirm').prop('disabled', $('.invite-check:checked').length === 0);
    });

    $(document).on('click', '#inviteConfirm', function () {
        var ids = $('.invite-check:checked').map(function () { return $(this).val(); }).get();
        if (!ids.length) return;

        $.ajax({
            url: '/chat-room/group/invite.dox', type: 'POST',
            data: { roomId: ROOM_ID, memberIds: ids.join(',') }, dataType: 'json',
            success: function (res) {
                if (res.result === 'success') {
                    showToast('멤버를 초대했어요.');
                    $('#inviteModal').removeClass('open');
                    loadMembers(false);
                } else {
                    showToast(res.message || '초대 실패');
                }
            }
        });
    });

    // ── 메시지 ────────────────────────────────────
    function loadMessages(isPolling) {
        $.ajax({
            url: '/chat-room/group/messages.dox', type: 'POST',
            data: { roomId: ROOM_ID }, dataType: 'json',
            success: function (res) {
                if (res.result !== 'success' || !res.list) return;
                renderMessages(res.list, isPolling);
            }
        });
    }

    function renderMessages(list, isPolling) {
        var area = document.getElementById('msgArea');
        var isBottom = area.scrollHeight - area.scrollTop - area.clientHeight < 100;

        if (!list.length) { $('#emptyChat').show(); return; }
        $('#emptyChat').hide();

        if (isPolling) {
            var newMsgs = list.filter(function (m) { return parseInt(m.MESSAGE_ID) > lastMsgId; });
            if (!newMsgs.length) return;

            var prevSender = null, prevMinute = null;
            var $lastRow = $('#msgArea .msg-row').last();
            if ($lastRow.length) {
                prevSender = $lastRow.attr('data-sender');
                prevMinute = $lastRow.attr('data-minute');
            }

            newMsgs.forEach(function (m) {
                var minute = (m.CREATED_AT || '').slice(0, 16);
                var isCont = prevSender === m.SENDER_ID && prevMinute === minute;
                insertDateSep(m);
                $('#typingWrap').before(buildBubble(m, isCont));
                lastMsgId = Math.max(lastMsgId, parseInt(m.MESSAGE_ID));
                prevSender = m.SENDER_ID; prevMinute = minute;
            });

            if (isBottom) scrollToBottom(true);
            return;
        }

        $('#msgArea .date-sep, #msgArea .msg-row').remove();
        var prevSenderFull = null, prevMinuteFull = null;
        lastDateStr = ''; lastMsgId = 0;

        list.forEach(function (m) {
            var minute = (m.CREATED_AT || '').slice(0, 16);
            var isCont = prevSenderFull === m.SENDER_ID && prevMinuteFull === minute;
            insertDateSep(m);
            $('#typingWrap').before(buildBubble(m, isCont));
            lastMsgId = Math.max(lastMsgId, parseInt(m.MESSAGE_ID));
            prevSenderFull = m.SENDER_ID; prevMinuteFull = minute;
        });

        setTimeout(function () { scrollToBottom(false); }, 50);
    }

    function insertDateSep(m) {
        var d = (m.CREATED_AT || '').slice(0, 10);
        if (!d || d === lastDateStr) return;
        $('#typingWrap').before('<div class="date-sep"><span>' + formatDateLabel(d) + '</span></div>');
        lastDateStr = d;
    }

    function buildBubble(m, isCont) {
        var isMe = m.SENDER_ID === MY_ID;
        var side = isMe ? 'me' : 'other';
        var minute = (m.CREATED_AT || '').slice(0, 16);

        var cls = 'msg-row ' + side + (isCont ? ' cont' : '');

        var imgHtml = m.SENDER_IMG
            ? '<img src="' + escAttr(m.SENDER_IMG) + '" alt="">'
            : '<div class="av-fb">' + escHtml((m.SENDER_NICK || '?').charAt(0)) + '</div>';

        var nickHtml = (!isMe && !isCont)
            ? '<div class="m-nick">' + escHtml(m.SENDER_NICK || m.SENDER_ID || '') + '</div>'
            : '';

        var bubbleContent = '';
        var content = m.CONTENT || '';

        if (m.MESSAGE_TYPE === 'STICKER') {
            bubbleContent = '<img class="chat-sticker" src="' + escAttr(content) + '" alt="스티커">';
        } else if (m.MESSAGE_TYPE === 'IMAGE') {
            bubbleContent = '<img class="chat-img" src="' + escAttr(content) + '" alt="채팅 이미지">';
        } else {
            bubbleContent = escHtml(content);
        }

        var meta = '<div class="m-meta"><div class="m-time">' + formatTime(m.CREATED_AT) + '</div></div>';

        return '<div class="' + cls + '" data-message-id="' + escAttr(m.MESSAGE_ID) + '" data-sender="' + escAttr(m.SENDER_ID) + '" data-minute="' + escAttr(minute) + '">' +
            '<div class="m-avatar">' + imgHtml + '</div>' +
            '<div class="m-body">' + nickHtml +
            '<div class="m-row"><div class="bubble">' + bubbleContent + '</div>' + meta + '</div>' +
            '</div></div>';
    }

    function sendMessage() {
        var content = $('#msgInput').val().trim();
        if (!content) return;

        $('#btnSend').prop('disabled', true);
        $('#msgInput').val('').css('height', 'auto');

        $.ajax({
            url: '/chat-room/group/send.dox', type: 'POST',
            data: { roomId: ROOM_ID, content: content }, dataType: 'json',
            success: function (res) {
                if (res.result === 'success') {
                    loadMessages(true);
                } else {
                    showToast(res.message || '전송 실패');
                }
            },
            error: function () { showToast('네트워크 오류가 발생했어요.'); }
        });
    }

    function sendSticker(url) {
        $.ajax({
            url: '/chat-room/group/send-sticker.dox', type: 'POST',
            data: { roomId: ROOM_ID, content: url }, dataType: 'json',
            success: function (res) { if (res.result === 'success') loadMessages(true); }
        });
    }

    function sendTyping() {
        clearTimeout(typingSendTimer);
        typingSendTimer = setTimeout(function () {
            $.ajax({ url: '/chat-room/group/typing.dox', type: 'POST', data: { roomId: ROOM_ID } });
        }, 300);
    }

    function checkTyping() {
        $.ajax({
            url: '/chat-room/group/typing/list.dox', type: 'POST',
            data: { roomId: ROOM_ID }, dataType: 'json',
            success: function (res) {
                var users = (res.result === 'success') ? (res.typingUsers || []) : [];

                if (!users.length) { $('#typingWrap').hide(); return; }

                var names = users.map(function (uid) {
                    return (memberMap[uid] && memberMap[uid].nickname) || uid;
                });

                var text = names.length === 1
                    ? names[0] + '님이 입력 중…'
                    : names[0] + ' 외 ' + (names.length - 1) + '명이 입력 중…';

                $('#typingText').text(text);
                $('#typingWrap').css('display', 'flex');
            }
        });
    }

    function leaveRoom() {
        $.ajax({
            url: '/chat-room/group/leave.dox', type: 'POST',
            data: { roomId: ROOM_ID }, dataType: 'json',
            success: function (res) {
                if (res.result === 'success') {
                    showToast('채팅방을 나갔어요.');
                    setTimeout(function () { location.href = '/chat-room/group/list.do'; }, 700);
                } else {
                    showToast(res.message || '나가기 실패');
                }
            }
        });
    }

    function startPolling() {
        if (pollTimer) clearInterval(pollTimer);
        pollTimer = setInterval(function () {
            loadMessages(true);
            checkTyping();
        }, 3000);
    }

    function scrollToBottom(smooth) {
        var a = document.getElementById('msgArea');
        a.scrollTo({ top: a.scrollHeight, behavior: smooth ? 'smooth' : 'auto' });
    }

    function formatTime(s) {
        if (!s) return '';
        var d = new Date(s.replace(' ', 'T'));
        var h = d.getHours(), m = d.getMinutes();
        return (h < 12 ? '오전 ' : '오후 ') + (h % 12 || 12) + ':' + String(m).padStart(2, '0');
    }

    function formatDateLabel(s) {
        if (!s) return '';
        var d = new Date(s);
        var days = ['일', '월', '화', '수', '목', '금', '토'];
        return d.getFullYear() + '년 ' + (d.getMonth() + 1) + '월 ' + d.getDate() + '일 ' + days[d.getDay()] + '요일';
    }

    function escHtml(s) {
        return String(s || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\n/g, '<br>');
    }
    function escAttr(s) { return String(s || '').replace(/"/g, '&quot;'); }

    function showToast(msg) {
        var t = $('#toast').text(msg).addClass('show');
        setTimeout(function () { t.removeClass('show'); }, 2600);
    }

    $(window).on('beforeunload', function () { if (pollTimer) clearInterval(pollTimer); });
</script>

</body>
</html>