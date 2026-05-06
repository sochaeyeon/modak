<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page deferredSyntaxAllowedAsLiteral="true" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>채팅방 | 모닥모닥</title>
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/chat-room.css">
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
                        <div class="top-avatar" id="topAvatar">
                            <img id="topImg" src="" alt="" style="display:none;">
                            <div class="av-fb" id="topFb">?</div>
                        </div>
                        <div class="top-info">
                            <div class="top-name" id="topName">…</div>
                            <div class="top-sub" id="topSub">모닥모닥 멤버</div>
                        </div>
                        <div class="btn-more" id="btnMore" role="button" tabindex="0" aria-label="채팅방 메뉴">
                            <i class="ri-more-2-fill"></i>
                            <div class="more-menu" id="moreMenu">
                                <button id="menuBlock" type="button">
                                    <i class="ri-forbid-2-line"></i>
                                    <span id="menuBlockTxt">차단하기</span>
                                </button>
                                <button id="menuLeave" type="button">
                                    <i class="ri-logout-box-r-line"></i>
                                    <span>채팅방 나가기</span>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 메시지 영역 -->
                    <div class="msg-area" id="msgArea">
                        <div class="empty-chat" id="emptyChat">
                            <div class="empty-icon">
                                <i class="ri-chat-heart-line"></i>
                            </div>
                            <p>모닥불처럼 따뜻한 대화를<br><strong>지금 시작해보세요!</strong></p>
                        </div>
                        <div class="typing-wrap" id="typingWrap">
                            <div class="m-avatar">
                                <img id="typingImg" src="" alt="" style="display:none;">
                                <div class="av-fb" id="typingFb">?</div>
                            </div>
                            <div class="typing-bubble">
                                <div class="t-dot"></div>
                                <div class="t-dot"></div>
                                <div class="t-dot"></div>
                            </div>
                        </div>
                    </div>
                    <button id="newMsgBtn" class="new-msg-btn" style="display:none;">
                        새 메시지 보기
                    </button>

                    <div class="blocked-bar" id="blockedBar">
                        <i class="ri-forbid-2-line"></i>
                        차단한 사용자입니다. 메시지를 보낼 수 없어요.
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
                    <img src="/img/sticker/modak1.png">
                    <img src="/img/sticker/modak2.png">
                    <img src="/img/sticker/modak3.png">
                    <img src="/img/sticker/modak4.png">
                    <img src="/img/sticker/modak5.png">
                    <img src="/img/sticker/modak6.png">
                    <img src="/img/sticker/modak7.png">
                    <img src="/img/sticker/modak8.png">
                    <img src="/img/sticker/modak9.png">
                    <img src="/img/sticker/modak10.png">
                    <img src="/img/sticker/modak11.png">
                    <img src="/img/sticker/modak12.png">
                    <img src="/img/sticker/modak13.png">
                    <img src="/img/sticker/modak14.png">
                    <img src="/img/sticker/modak15.png">
                    <img src="/img/sticker/modak16.png">
                    <img src="/img/sticker/modak17.png">
                    <img src="/img/sticker/modak18.png">
                    <img src="/img/sticker/modak19.png">
                    <img src="/img/sticker/modak20.png">
                </div>
                <!-- 미니 프로필 팝업 -->
                <div class="mini-profile" id="miniProfile" style="display:none;">
                    <div class="mp-header">
                        <div class="mp-avatar-wrap">
                            <img id="mpImg" src="" alt="" style="display:none;">
                            <div class="mp-av-fb" id="mpFb">?</div>
                        </div>
                        <div class="mp-header-info">
                            <div class="mp-name" id="mpName">…</div>
                            <div class="mp-grade" id="mpGrade"></div>
                        </div>
                    </div>
                    <div class="mp-stats">
                        <div class="mp-stat">
                            <span class="mp-stat-num" id="mpBoard">0</span>
                            <span class="mp-stat-label">게시글</span>
                        </div>
                        <div class="mp-stat">
                            <span class="mp-stat-num" id="mpComment">0</span>
                            <span class="mp-stat-label">댓글</span>
                        </div>
                        <div class="mp-stat">
                            <span class="mp-stat-num" id="mpLike">0</span>
                            <span class="mp-stat-label">받은추천</span>
                        </div>
                    </div>
                    <div class="mp-actions">
                        <button class="mp-btn primary" id="mpChatBtn" type="button">
                            <i class="ri-chat-3-line"></i>
                            <span>대화 중</span>
                        </button>
                        <button class="mp-btn secondary" id="mpProfileBtn">프로필 보기</button>
                    </div>
                </div>

                <!-- 차단 모달 -->
                <div class="modal-bg" id="blockModal">
                    <div class="modal-box">
                        <div class="modal-icon block-icon" id="modalIcon">
                            <i class="ri-forbid-2-line"></i>
                        </div>
                        <div class="modal-title" id="modalTitle">사용자를 차단할까요?</div>
                        <div class="modal-desc" id="modalDesc">차단하면 이 사용자의 메시지를<br>더 이상 받지 않게 됩니다.</div>
                        <div class="modal-btns">
                            <button class="modal-btn cancel" id="modalCancel">취소</button>
                            <button class="modal-btn confirm-block" id="modalConfirm">차단하기</button>
                        </div>
                    </div>
                </div>
                <!-- 메시지 삭제 모달 -->
                <div class="modal-bg" id="deleteMsgModal">
                    <div class="modal-box delete-msg-box">
                        <div class="modal-icon delete-icon">
                            <i class="ri-delete-bin-6-line"></i>
                        </div>

                        <div class="modal-title">메시지 삭제</div>
                        <div class="modal-desc">
                            삭제 방식을 선택해주세요.<br>
                            모두에게 삭제하면 상대방 화면에서도 메시지가 사라집니다.
                        </div>

                        <div class="delete-option-list">
                            <button type="button" class="delete-option" id="deleteForMe">
                                <span class="delete-option-icon soft">
                                    <i class="ri-user-line"></i>
                                </span>
                                <span class="delete-option-text">
                                    <strong>나에게만 삭제</strong>
                                    <em>내 채팅방에서만 보이지 않아요</em>
                                </span>
                                <i class="ri-arrow-right-s-line delete-option-arrow"></i>
                            </button>

                            <button type="button" class="delete-option danger" id="deleteForAll">
                                <span class="delete-option-icon danger">
                                    <i class="ri-group-line"></i>
                                </span>
                                <span class="delete-option-text">
                                    <strong>모두에게 삭제</strong>
                                    <em>상대방 채팅방에서도 삭제돼요</em>
                                </span>
                                <i class="ri-arrow-right-s-line delete-option-arrow"></i>
                            </button>
                        </div>

                        <button type="button" class="delete-cancel-btn" id="deleteCancel">취소</button>
                    </div>
                </div>
                <!-- 채팅방 나가기 모달 -->
                <div class="modal-bg" id="leaveRoomModal">
                    <div class="modal-box">
                        <div class="modal-icon leave-icon">
                            <i class="ri-logout-box-r-line"></i>
                        </div>
                        <div class="modal-title">채팅방을 나갈까요?</div>
                        <div class="modal-desc">
                            나가면 이 대화방이 내 채팅 목록에서 사라집니다.<br>
                            상대방의 채팅방은 유지됩니다.
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
                    var OTHER_ID = new URLSearchParams(location.search).get('otherId') || null;
                    var MY_ID = '${sessionScope.sessionId}';
                    var selectedDeleteMessageId = null;
                    var isBlocked = false;
                    var pollTimer = null;
                    var typingTimer = null;
                    var typingSendTimer = null;

                    var lastMsgId = 0;
                    var lastDateStr = '';

                    var mpUserId = null;
                    var mpChatState = '';
                    var mpRoomId = null;

                    $(function () {
                        if (!ROOM_ID) {
                            showToast('잘못된 접근입니다.');
                            setTimeout(function () {
                                location.href = '/chat-room/list.do';
                            }, 1500);
                            return;
                        }

                        loadOtherInfo();
                        checkBlock();

                        // 최초 진입 시 메시지 조회 + 읽음 처리
                        loadMessages(false);
                        sendActive();
                        checkActive();

                        startPolling();

                        $('#btnBack').on('click', function () {
                            history.back();
                        });

                        $('#topAvatar, #topName').on('click', function (e) {
                            e.stopPropagation();
                            openMiniProfile(OTHER_ID, this);
                        });
                        $('#btnEmoji').on('click', function (e) {
                            e.stopPropagation();
                            $('#stickerPanel').toggle();
                        });
                        $('#leaveCancel').on('click', closeLeaveRoomModal);

                        $('#leaveConfirm').on('click', leaveRoom);

                        $('#leaveRoomModal').on('click', function (e) {
                            if (e.target === this) {
                                closeLeaveRoomModal();
                            }
                        });
                        $(document).on('click', function () {
                            $('#stickerPanel').hide();
                        });

                        $('#stickerPanel img').on('click', function () {
                            var url = $(this).attr('src');
                            sendSticker(url);
                            $('#stickerPanel').hide();
                        });

                        $('#btnMore').on('click', function (e) {
                            e.stopPropagation();
                            $('#moreMenu').toggleClass('open');
                        });

                        $('#menuBlock').on('click', function () {
                            $('#moreMenu').removeClass('open');
                            openBlockModal();
                        });

                        $('#menuLeave').on('click', function (e) {
                            e.stopPropagation();
                            $('#moreMenu').removeClass('open');
                            openLeaveRoomModal();
                        });
                        function sendSticker(stickerUrl) {
                            $.ajax({
                                url: '/chat-room/send-sticker.dox',
                                type: 'POST',
                                data: {
                                    roomId: ROOM_ID,
                                    content: stickerUrl
                                },
                                dataType: 'json',
                                success: function (res) {
                                    if (res.result === 'success') {
                                        loadMessages(false);
                                    } else {
                                        showToast(res.message || '이모티콘 전송 실패');
                                    }
                                },
                                error: function () {
                                    showToast('이모티콘 전송 중 오류가 발생했습니다.');
                                }
                            });
                        }

                        $('#btnImage').on('click', function () {
                            $('#chatImageInput').click();
                        });

                        $('#chatImageInput').on('change', function () {
                            if (!this.files || !this.files[0]) return;

                            var formData = new FormData();
                            formData.append('roomId', ROOM_ID);
                            formData.append('image', this.files[0]);

                            $.ajax({
                                url: '/chat-room/send-image.dox',
                                type: 'POST',
                                data: formData,
                                processData: false,
                                contentType: false,
                                dataType: 'json',
                                success: function (res) {
                                    if (res.result === 'success') {
                                        $('#chatImageInput').val('');
                                        loadMessages(false);

                                        setTimeout(function () {
                                            loadMessages(true);
                                        }, 100);
                                    } else {
                                        showToast(res.message || '이미지 전송 실패');
                                    }
                                },
                                error: function () {
                                    showToast('이미지 전송 중 오류가 발생했습니다.');
                                }
                            });
                        });

                        $('#modalCancel').on('click', closeBlockModal);

                        $('#blockModal').on('click', function (e) {
                            if (e.target === this) closeBlockModal();
                        });

                        $('#modalConfirm').on('click', confirmBlock);

                        $('#mpChatBtn').on('click', onMpChatClick);

                        $('#mpProfileBtn').on('click', function () {
                            if (mpUserId) {
                                location.href = '/user/profile.do?userId=' + encodeURIComponent(mpUserId);
                            }
                        });

                        $(document).on('click', function () {
                            $('#miniProfile').hide();
                            $('#moreMenu').removeClass('open');
                        });

                        $('#miniProfile').on('click', function (e) {
                            e.stopPropagation();
                        });

                        $('#msgArea').on('click', '.m-avatar, .m-nick', function (e) {
                            e.stopPropagation();
                            openMiniProfile(OTHER_ID, this);
                        });
                        // 메시지 삭제 버튼 클릭 → 삭제 모달 열기
                        $('#msgArea').on('click', '.msg-del-btn', function (e) {
                            e.stopPropagation();

                            selectedDeleteMessageId = $(this).data('message-id');
                            $('#deleteMsgModal').addClass('open');
                        });

                        // 삭제 모달 취소
                        $('#deleteCancel').on('click', closeDeleteMsgModal);

                        // 삭제 모달 바깥 클릭 시 닫기
                        $('#deleteMsgModal').on('click', function (e) {
                            if (e.target === this) {
                                closeDeleteMsgModal();
                            }
                        });

                        // 나에게만 삭제
                        $('#deleteForMe').on('click', function () {
                            if (!selectedDeleteMessageId) return;

                            deleteMessage(selectedDeleteMessageId, 'ME');
                            closeDeleteMsgModal();
                        });

                        // 모두에게 삭제
                        $('#deleteForAll').on('click', function () {
                            if (!selectedDeleteMessageId) return;

                            deleteMessage(selectedDeleteMessageId, 'ALL');
                            closeDeleteMsgModal();
                        });


                        $('#btnSend').on('click', sendMessage);

                        $('#newMsgBtn').on('click', function () {
                            scrollToBottom(true);
                            $('#newMsgBtn').hide();
                        });

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

                                    if (!$('#btnSend').prop('disabled')) {
                                        sendMessage();
                                    }
                                }
                            });

                        $(window).on('focus', function () {
                            markAsRead();
                            loadMessages(true);
                        });

                        $(document).on('visibilitychange', function () {
                            if (!document.hidden) {
                                markAsRead();
                                loadMessages(true);
                            }
                        });
                    });

                    function markAsRead() {
                        if (!ROOM_ID) return;

                        $.ajax({
                            url: '/chat-room/read.dox',
                            type: 'POST',
                            data: { roomId: ROOM_ID }
                        });
                    }

                    function closeDeleteMsgModal() {
                        $('#deleteMsgModal').removeClass('open');
                        selectedDeleteMessageId = null;
                    }

                    function loadMessages(isPolling) {
                        $.ajax({
                            url: '/chat-room/messages.dox',
                            type: 'POST',
                            data: { roomId: ROOM_ID },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result !== 'success' || !res.list) return;

                                renderMessages(res.list, isPolling);

                                // 현재 방을 보고 있는 사용자는 바로 읽음 처리
                                markAsRead();
                            }
                        });
                    }

                    function renderMessages(list, isPolling) {
                        var area = document.getElementById('msgArea');
                        var isBottom = area.scrollHeight - area.scrollTop - area.clientHeight < 100;

                        if (!list.length) {
                            $('#emptyChat').show();
                            return;
                        }

                        $('#emptyChat').hide();

                        if (isPolling) {
                            // 중요: 새 메시지가 없어도 읽음 상태는 갱신해야 함
                            updateReadStatusOnly(list);

                            var newMsgs = list.filter(function (m) {
                                return parseInt(m.MESSAGE_ID) > lastMsgId;
                            });

                            if (!newMsgs.length) {
                                return;
                            }

                            hideTyping();

                            var prevSender = null;
                            var prevMinute = null;

                            var $lastRow = $('#msgArea .msg-row').last();
                            if ($lastRow.length) {
                                prevSender = $lastRow.attr('data-sender');
                                prevMinute = $lastRow.attr('data-minute');
                            }

                            newMsgs.forEach(function (m) {
                                var minute = (m.CREATED_AT || '').slice(0, 16);
                                var isCont = prevSender === m.SENDER_ID && prevMinute === minute;
                                var isGap = !isCont && prevSender !== null && prevSender !== m.SENDER_ID;

                                insertDateSep(m);
                                $('#typingWrap').before(buildBubble(m, isCont, isGap));

                                lastMsgId = Math.max(lastMsgId, parseInt(m.MESSAGE_ID));

                                prevSender = m.SENDER_ID;
                                prevMinute = minute;
                            });

                            updateReadStatusOnly(list);

                            if (isBottom) {
                                scrollToBottom(true);
                                $('#newMsgBtn').hide();
                            } else {
                                $('#newMsgBtn').show();
                            }

                            return;
                        }

                        $('#msgArea .date-sep, #msgArea .msg-row').remove();

                        var prevSenderFull = null;
                        var prevMinuteFull = null;

                        lastDateStr = '';
                        lastMsgId = 0;

                        list.forEach(function (m) {
                            var minute = (m.CREATED_AT || '').slice(0, 16);
                            var isCont = prevSenderFull === m.SENDER_ID && prevMinuteFull === minute;
                            var isGap = !isCont && prevSenderFull !== null && prevSenderFull !== m.SENDER_ID;

                            insertDateSep(m);
                            $('#typingWrap').before(buildBubble(m, isCont, isGap));

                            lastMsgId = Math.max(lastMsgId, parseInt(m.MESSAGE_ID));

                            prevSenderFull = m.SENDER_ID;
                            prevMinuteFull = minute;
                        });

                        updateReadStatusOnly(list);

                        setTimeout(function () {
                            scrollToBottom(false);
                        }, 50);
                    }
                    function deleteMessage(messageId, type) {
                        $.ajax({
                            url: '/chat-room/message/delete.dox',
                            type: 'POST',
                            data: {
                                roomId: ROOM_ID,
                                messageId: messageId,
                                type: type
                            },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result === 'success') {
                                    loadMessages(false);
                                    showToast(type === 'ALL' ? '모두에게서 메시지를 삭제했어요.' : '내 채팅방에서 메시지를 삭제했어요.');
                                } else {
                                    showToast(res.message || '삭제 실패');
                                }
                            },
                            error: function () {
                                showToast('서버 오류가 발생했습니다.');
                            }
                        });
                    }

                    function updateReadStatusOnly(list) {
                        list.forEach(function (m) {
                            if (m.SENDER_ID !== MY_ID) return;

                            var $row = $('#msgArea .msg-row[data-message-id="' + m.MESSAGE_ID + '"]');
                            if (!$row.length) return;

                            var $unread = $row.find('.m-unread');

                            if (m.IS_READ === 'Y') {
                                $unread
                                    .addClass('read')
                                    .removeClass('fail')
                                    .text('읽음');
                            } else {
                                $unread
                                    .removeClass('read fail')
                                    .text('1');
                            }
                        });
                    }

                    function insertDateSep(m) {
                        var d = (m.CREATED_AT || '').slice(0, 10);

                        if (!d || d === lastDateStr) return;

                        $('#typingWrap').before(
                            '<div class="date-sep"><span>' + formatDateLabel(d) + '</span></div>'
                        );

                        lastDateStr = d;
                    }

                    function buildBubble(m, isCont, isGap) {
                        var isMe = m.SENDER_ID === MY_ID;
                        var side = isMe ? 'me' : 'other';
                        var minute = (m.CREATED_AT || '').slice(0, 16);

                        var isDeleted = m.IS_DELETED === 'Y' || m.isDeleted === 'Y';

                        var cls = 'msg-row ' + side
                            + (isCont ? ' cont' : '')
                            + (isGap ? ' gap' : '')
                            + (isDeleted ? ' deleted-msg' : '');

                        var imgHtml = m.SENDER_IMG
                            ? '<img src="' + escAttr(m.SENDER_IMG) + '" alt="">'
                            : '<div class="av-fb">' + escHtml((m.SENDER_NICK || '?').charAt(0)) + '</div>';

                        var nickHtml = (!isMe && !isCont)
                            ? '<div class="m-nick">' + escHtml(m.SENDER_NICK || OTHER_ID || '') + '</div>'
                            : '';

                        var bubbleContent = '';
                        var messageType = m.MESSAGE_TYPE || m.messageType || 'TEXT';
                        var content = m.CONTENT || '';

                        if (isDeleted) {
                            bubbleContent =
                                '<span class="deleted-message-text">' +
                                '<i class="ri-delete-bin-line"></i>' +
                                '<span>삭제된 메시지입니다</span>' +
                                '</span>';
                        } else if (messageType === 'STICKER') {
                            bubbleContent = '<img class="chat-sticker" src="' + escAttr(content) + '" alt="스티커">';
                        } else if (messageType === 'IMAGE' || String(content).startsWith('/img/chat/')) {
                            bubbleContent = '<img class="chat-img" src="' + escAttr(content) + '" alt="채팅 이미지">';
                        } else {
                            bubbleContent = escHtml(content);
                        }

                        var readStatus = '';

                        if (isMe) {
                            if (m.IS_READ === 'Y') {
                                readStatus = '<div class="m-unread read">읽음</div>';
                            } else {
                                readStatus = '<div class="m-unread">1</div>';
                            }
                        }

                        if (m.TEMP_STATUS === 'sending') {
                            readStatus = '<div class="m-unread read">전송중</div>';
                        }

                        if (m.TEMP_STATUS === 'fail') {
                            readStatus = '<div class="m-unread fail">실패</div>';
                        }

                        var deleteBtn = '';

                        if (isMe && !isDeleted && !m.TEMP_STATUS) {
                            deleteBtn =
                                '<button type="button" class="msg-del-btn" data-message-id="' + escAttr(m.MESSAGE_ID) + '">' +
                                '삭제' +
                                '</button>';
                        }

                        var meta = '<div class="m-meta">' +
                            deleteBtn +
                            readStatus +
                            '<div class="m-time">' + formatTime(m.CREATED_AT) + '</div>' +
                            '</div>';

                        return '<div class="' + cls + '" data-message-id="' + escAttr(m.MESSAGE_ID) + '" data-sender="' + escAttr(m.SENDER_ID) + '" data-minute="' + escAttr(minute) + '">' +
                            '<div class="m-avatar">' + imgHtml + '</div>' +
                            '<div class="m-body">' +
                            nickHtml +
                            '<div class="m-row">' +
                            '<div class="bubble">' + bubbleContent + '</div>' +
                            meta +
                            '</div>' +
                            '</div>' +
                            '</div>';
                    }

                    function sendMessage() {
                        if (isBlocked) return;

                        var content = $('#msgInput').val().trim();
                        if (!content) return;

                        var tempId = 'temp-' + Date.now();

                        $('#btnSend').prop('disabled', true);
                        $('#msgInput').val('').css('height', 'auto');

                        $('#emptyChat').hide();

                        var tempMsg = {
                            MESSAGE_ID: tempId,
                            SENDER_ID: MY_ID,
                            SENDER_NICK: '',
                            SENDER_IMG: '',
                            CONTENT: content,
                            CREATED_AT: new Date().toISOString().slice(0, 19).replace('T', ' '),
                            IS_READ: 'N',
                            TEMP_STATUS: 'sending'
                        };

                        $('#typingWrap').before(buildBubble(tempMsg, false, false));
                        scrollToBottom(true);

                        $.ajax({
                            url: '/chat-room/send.dox',
                            type: 'POST',
                            data: {
                                roomId: ROOM_ID,
                                content: content
                            },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result === 'success') {
                                    loadMessages(false);

                                    setTimeout(function () {
                                        loadMessages(true);
                                    }, 100);

                                    return;
                                }

                                markTempMessageFail(tempId);
                                showToast('전송에 실패했어요.');
                            },
                            error: function () {
                                markTempMessageFail(tempId);
                                showToast('네트워크 오류가 발생했어요.');
                            }
                        });
                    }

                    function sendTyping() {
                        if (!ROOM_ID || isBlocked) return;

                        clearTimeout(typingSendTimer);

                        typingSendTimer = setTimeout(function () {
                            $.ajax({
                                url: '/chat-room/typing.dox',
                                type: 'POST',
                                data: { roomId: ROOM_ID }
                            });
                        }, 300);
                    }

                    function checkTyping() {
                        if (!ROOM_ID || !OTHER_ID) return;

                        $.ajax({
                            url: '/chat-room/typing/check.dox',
                            type: 'POST',
                            data: {
                                roomId: ROOM_ID,
                                otherId: OTHER_ID
                            },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result === 'success' && res.typing === true) {
                                    showTyping();
                                } else {
                                    hideTyping();
                                }
                            }
                        });
                    }

                    function markTempMessageFail(tempId) {
                        $('#msgArea .msg-row').each(function () {
                            var $row = $(this);
                            var text = $row.find('.m-unread.read').text();

                            if (text === '전송중') {
                                $row.find('.m-unread.read')
                                    .removeClass('read')
                                    .addClass('fail')
                                    .text('실패');
                            }
                        });

                        $('#btnSend').prop('disabled', false);
                    }

                    function startPolling() {
                        if (pollTimer) clearInterval(pollTimer);

                        pollTimer = setInterval(function () {
                            sendActive();
                            checkActive();
                            loadMessages(true);
                            checkTyping();
                        }, 3000);
                    }
                    function sendActive() {
                        $.ajax({
                            url: '/chat-room/active.dox',
                            type: 'POST'
                        });
                    }

                    function checkActive() {
                        if (!OTHER_ID) return;

                        $.ajax({
                            url: '/chat-room/active/check.dox',
                            type: 'POST',
                            data: {
                                otherId: OTHER_ID
                            },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result === 'success') {
                                    $('#topSub').text(res.status);
                                }
                            }
                        });
                    }
                    function openLeaveRoomModal() {
                        $('#leaveRoomModal').addClass('open');
                    }

                    function closeLeaveRoomModal() {
                        $('#leaveRoomModal').removeClass('open');
                        $('#leaveConfirm').prop('disabled', false).text('나가기');
                    }

                    function leaveRoom() {
                        var $btn = $('#leaveConfirm');

                        if ($btn.prop('disabled')) return;

                        $btn.prop('disabled', true).text('처리 중');

                        $.ajax({
                            url: '/chat-room/leave.dox',
                            type: 'POST',
                            data: { roomId: ROOM_ID },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result === 'success') {
                                    showToast('채팅방을 나갔어요.');

                                    setTimeout(function () {
                                        location.href = '/chat-room/list.do';
                                    }, 700);

                                    return;
                                }

                                showToast(res.message || '채팅방 나가기 실패');
                                closeLeaveRoomModal();
                            },
                            error: function () {
                                showToast('서버 오류가 발생했습니다.');
                                closeLeaveRoomModal();
                            }
                        });
                    }
                    function openMiniProfile(userId, triggerEl) {
                        if (!userId) return;

                        mpUserId = userId;

                        $('#mpImg').hide();
                        $('#mpFb').text((userId || '?').charAt(0).toUpperCase()).show();
                        $('#mpName').text($('#topName').text() || userId);
                        $('#mpGrade').text('');
                        $('#mpBoard').text('-');
                        $('#mpComment').text('-');
                        $('#mpLike').text('-');
                        $('#mpChatBtn')
                            .html('<i class="ri-chat-3-line"></i><span>대화 중</span>')
                            .prop('disabled', true);

                        positionPopup(triggerEl);
                        $('#miniProfile').show();

                        $.ajax({
                            url: '/user/mini-profile.dox',
                            type: 'POST',
                            data: { targetUserId: userId },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result !== 'success' || !res.user) return;

                                var u = res.user;

                                if (u.profileImg) {
                                    $('#mpImg').attr('src', u.profileImg).show();
                                    $('#mpFb').hide();
                                } else {
                                    $('#mpFb').text((u.nickname || '?').charAt(0).toUpperCase()).show();
                                    $('#mpImg').hide();
                                }

                                $('#mpName').text(u.nickname || userId);
                                $('#mpGrade').text(gradeLabel(u.communityGrade)); $('#mpGrade').html(
                                    '<i class="' + gradeIcon(u.communityGrade) + '"></i> ' + escHtml(gradeLabel(u.communityGrade))
                                );
                                $('#mpBoard').text(u.boardCount || 0);
                                $('#mpComment').text(u.commentCount || 0);
                                $('#mpLike').text(u.likeCount || 0);
                            }
                        });
                    }
                    function gradeIcon(g) {
                        return {
                            'SPROUT': 'ri-seedling-line',
                            'EMBER': 'ri-fire-line',
                            'CAMPER': 'ri-tent-line',
                            'FIRE_CAMPER': 'ri-blaze-line',
                            'MODAK': 'ri-award-line'
                        }[g] || 'ri-seedling-line';
                    }
                    function positionPopup(el) {
                        var rect = $(el)[0].getBoundingClientRect();
                        var popW = 240;
                        var popH = 320;
                        var vw = window.innerWidth;
                        var vh = window.innerHeight;

                        var x = rect.left;
                        var y = rect.bottom + 10;

                        if (x + popW > vw - 12) x = Math.max(8, vw - popW - 12);
                        if (y + popH > vh - 12) y = Math.max(8, rect.top - popH - 10);

                        $('#miniProfile').css({
                            position: 'fixed',
                            top: y + 'px',
                            left: x + 'px',
                            zIndex: 8000
                        }).show();
                    }

                    function onMpChatClick() {
                        showToast('현재 이 사용자와 대화 중이에요!');
                    }

                    function loadOtherInfo() {
                        $.ajax({
                            url: '/chat-room/rooms.dox',
                            type: 'POST',
                            dataType: 'json',
                            success: function (res) {
                                if (res.result !== 'success') {
                                    applyFallback();
                                    return;
                                }

                                var room = null;

                                (res.list || []).forEach(function (r) {
                                    if (String(r.ROOM_ID) === String(ROOM_ID)) {
                                        room = r;
                                    }
                                });

                                if (!room) {
                                    applyFallback();
                                    return;
                                }

                                OTHER_ID = room.OTHER_ID || room.otherId || room.OTHER_USER_ID || room.otherUserId || OTHER_ID;

                                var nick = room.OTHER_NICK || room.otherNick || OTHER_ID || '상대방';

                                $('#topName').text(nick);

                                if (room.OTHER_IMG) {
                                    $('#topImg').attr('src', room.OTHER_IMG).show();
                                    $('#topFb').hide();

                                    $('#typingImg').attr('src', room.OTHER_IMG).show();
                                    $('#typingFb').hide();
                                } else {
                                    var ch = nick.charAt(0).toUpperCase();

                                    $('#topFb').text(ch);
                                    $('#typingFb').text(ch);
                                }
                            },
                            error: applyFallback
                        });
                    }

                    function applyFallback() {
                        var nick = OTHER_ID || '상대방';
                        var ch = nick.charAt(0).toUpperCase();

                        $('#topName').text(nick);
                        $('#topFb').text(ch);
                        $('#typingFb').text(ch);
                    }

                    function openBlockModal() {
                        if (isBlocked) {
                            $('#modalIcon')
                                .removeClass('block-icon')
                                .addClass('unblock-icon')
                                .html('<i class="ri-shield-check-line"></i>');

                            $('#modalTitle').text('차단을 해제할까요?');
                            $('#modalDesc').html('차단을 해제하면 이 사용자와<br>다시 대화할 수 있어요.');
                            $('#modalConfirm')
                                .removeClass('confirm-block')
                                .addClass('confirm-unblock')
                                .text('해제하기');
                        } else {
                            $('#modalIcon')
                                .removeClass('unblock-icon')
                                .addClass('block-icon')
                                .html('<i class="ri-forbid-2-line"></i>');

                            $('#modalTitle').text('사용자를 차단할까요?');
                            $('#modalDesc').html('차단하면 이 사용자의 메시지를<br>더 이상 받지 않게 됩니다.');
                            $('#modalConfirm')
                                .removeClass('confirm-unblock')
                                .addClass('confirm-block')
                                .text('차단하기');
                        }

                        $('#blockModal').addClass('open');
                    }

                    function closeBlockModal() {
                        $('#blockModal').removeClass('open');
                    }

                    function confirmBlock() {
                        closeBlockModal();

                        $.ajax({
                            url: '/chat-room/block.dox',
                            type: 'POST',
                            data: { targetId: OTHER_ID },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result === 'success') {
                                    updateBlockUI(res.blocked);
                                    showToast(res.message);
                                }
                            }
                        });
                    }

                    function checkBlock() {
                        if (!OTHER_ID) return;

                        $.ajax({
                            url: '/chat-room/block/check.dox',
                            type: 'POST',
                            data: { targetId: OTHER_ID },
                            dataType: 'json',
                            success: function (res) {
                                if (res.result === 'success') {
                                    updateBlockUI(res.blocked);
                                }
                            }
                        });
                    }

                    function updateBlockUI(blocked) {
                        isBlocked = blocked;

                        $('#menuBlockTxt').text(blocked ? '차단 해제' : '차단하기');

                        if (blocked) {
                            $('#blockedBar').show();
                            $('#inputWrap').hide();
                        } else {
                            $('#blockedBar').hide();
                            $('#inputWrap').show();
                        }
                    }

                    function showTyping() {
                        $('#typingWrap').css('display', 'flex');
                        scrollToBottom(true);

                        clearTimeout(typingTimer);

                        typingTimer = setTimeout(hideTyping, 3000);
                    }

                    function hideTyping() {
                        $('#typingWrap').hide();
                        clearTimeout(typingTimer);
                    }

                    function scrollToBottom(smooth) {
                        var a = document.getElementById('msgArea');

                        a.scrollTo({
                            top: a.scrollHeight,
                            behavior: smooth ? 'smooth' : 'auto'
                        });
                    }

                    function formatTime(s) {
                        if (!s) return '';

                        var d = new Date(s.replace(' ', 'T'));
                        var h = d.getHours();
                        var m = d.getMinutes();

                        return (h < 12 ? '오전 ' : '오후 ') +
                            (h % 12 || 12) +
                            ':' +
                            String(m).padStart(2, '0');
                    }

                    function formatDateLabel(s) {
                        if (!s) return '';

                        var d = new Date(s);
                        var days = ['일', '월', '화', '수', '목', '금', '토'];

                        return d.getFullYear() +
                            '년 ' +
                            (d.getMonth() + 1) +
                            '월 ' +
                            d.getDate() +
                            '일 ' +
                            days[d.getDay()] +
                            '요일';
                    }

                    function gradeLabel(g) {
                        return {
                            'SPROUT': '새싹',
                            'EMBER': '불씨',
                            'CAMPER': '캠퍼',
                            'FIRE_CAMPER': '불꽃캠퍼',
                            'MODAK': '모닥불'
                        }[g] || '새싹';
                    }

                    function escHtml(s) {
                        return String(s || '')
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/\n/g, '<br>');
                    }

                    function escAttr(s) {
                        return String(s || '').replace(/"/g, '&quot;');
                    }

                    function showToast(msg) {
                        var t = $('#toast').text(msg).addClass('show');

                        setTimeout(function () {
                            t.removeClass('show');
                        }, 2600);
                    }

                    $(window).on('beforeunload', function () {
                        if (pollTimer) clearInterval(pollTimer);
                    });
                </script>
        </body>

        </html>