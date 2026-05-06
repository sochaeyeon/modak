<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>채팅 목록 | 모닥모닥</title>
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
                    </div>

                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="대화 상대 검색…" oninput="filterRooms(this.value)">
                        <span class="ico-search">
                            <i class="ri-search-line"></i>
                        </span>
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
                        <div class="ico">
                            <i class="ri-chat-off-line"></i>
                        </div>
                        <p>아직 진행 중인 대화가 없어요.<br>상품 페이지에서 판매자에게 먼저 말을 걸어보세요!</p>
                    </div>

                </div>

                <script>
                    let allRooms = [];

                    // ── 채팅방 목록 불러오기 ──────────────────────────
                    function loadRooms() {
                        console.log("loadRooms 실행됨");

                        fetch('/chat-room/rooms.dox', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                            }
                        })
                            .then(function (response) {
                                console.log("채팅방 목록 status:", response.status);

                                if (!response.ok) {
                                    throw new Error("HTTP " + response.status);
                                }

                                return response.json();
                            })
                            .then(function (res) {
                                console.log("채팅방 목록 응답:", res);

                                document.getElementById("skeletonWrap").style.display = "none";

                                if (res.result !== "success" || !res.list || res.list.length === 0) {
                                    document.getElementById("roomList").style.display = "none";
                                    document.getElementById("emptyState").style.display = "block";
                                    return;
                                }

                                allRooms = res.list;
                                renderRooms(allRooms);

                                document.getElementById("roomList").style.display = "block";

                                const total = allRooms.reduce(function (sum, r) {
                                    return sum + parseInt(r.UNREAD_COUNT || r.unreadCount || 0);
                                }, 0);

                                document.getElementById("totalUnread").textContent = total > 99 ? "99+" : total;
                            })
                            .catch(function (error) {
                                console.log("채팅방 목록 호출 실패:", error);

                                document.getElementById("skeletonWrap").style.display = "none";
                                document.getElementById("roomList").style.display = "none";
                                document.getElementById("emptyState").style.display = "block";
                            });
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
                            const roomId = r.ROOM_ID || r.roomId;
                            const otherId = r.OTHER_ID || r.otherId;
                            const otherNick = r.OTHER_NICK || r.otherNick || otherId || "상대방";
                            const otherImg = r.OTHER_IMG || r.otherImg;
                            const rawLastMsg = r.LAST_MSG || r.lastMsg || "";
                            const lastMsg = fnChatPreviewText(rawLastMsg);
                            const lastAt = r.LAST_AT || r.lastAt;
                            const unread = parseInt(r.UNREAD_COUNT || r.unreadCount || 0);

                            const imgHtml = otherImg
                                ? '<img src="' + escHtml(otherImg) + '" alt="">'
                                : '<div class="avatar-fallback">' + escHtml(String(otherNick).charAt(0)) + '</div>';

                            const dotHtml = unread > 0
                                ? '<span class="unread-dot">' + (unread > 9 ? "9+" : unread) + '</span>'
                                : "";

                            const badgeHtml = unread > 0
                                ? '<span class="unread-badge">' + (unread > 99 ? "99+" : unread) + '</span>'
                                : "";

                            const timeStr = formatTime(lastAt);

                            wrap.insertAdjacentHTML(
                                "beforeend",
                                '<a class="room-card" href="/chat-room/room.do?roomId=' + encodeURIComponent(roomId || "") + '&otherId=' + encodeURIComponent(otherId || "") + '">' +
                                '<div class="avatar">' +
                                imgHtml +
                                dotHtml +
                                '</div>' +
                                '<div class="room-info">' +
                                '<div class="room-name">' + escHtml(otherNick) + '</div>' +
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

                    // ── 검색 필터 ──────────────────────────────────────
                    function filterRooms(keyword) {
                        if (!keyword.trim()) {
                            renderRooms(allRooms);
                            return;
                        }

                        const kw = keyword.toLowerCase();

                        renderRooms(allRooms.filter(function (r) {
                            const otherNick = r.OTHER_NICK || r.otherNick || "";
                            const lastMsg = r.LAST_MSG || r.lastMsg || "";

                            return otherNick.toLowerCase().includes(kw) ||
                                lastMsg.toLowerCase().includes(kw);
                        }));
                    }

                    // ── 유틸 ───────────────────────────────────────────
                    function formatTime(dateStr) {
                        if (!dateStr) return '';
                        const d = new Date(dateStr.replace(' ', 'T'));
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
                        if (!message) {
                            return "대화를 시작해보세요";
                        }

                        const text = String(message).trim();

                        // 이미지 경로 또는 이미지 파일명으로 끝나는 경우
                        const isImage =
                            text.startsWith("/upload/") ||
                            text.startsWith("/img/") ||
                            text.includes("/chat/") ||
                            /\.(jpg|jpeg|png|gif|webp|bmp)$/i.test(text);

                        if (isImage) {
                            return "사진을 보냈습니다.";
                        }

                        return text;
                    }
                    function escHtml(str) {
                        return String(str)
                            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
                    }

                    // ── 초기화 ─────────────────────────────────────────
                    document.addEventListener("DOMContentLoaded", function () {
                        console.log("chat-list.jsp DOMContentLoaded");
                        loadRooms();
                    });
                </script>

                <%@ include file="/WEB-INF/common/footer.jsp" %>
        </body>

        </html>