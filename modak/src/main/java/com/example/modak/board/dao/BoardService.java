package com.example.modak.board.dao;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.alarm.dao.AlarmService;
import com.example.modak.board.mapper.BoardMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class BoardService {
	@Autowired
	private AlarmService alarmService;
    @Autowired private BoardMapper mapper;
    @Autowired private HttpSession session;
    

    private String getUserId() {
        return (String) session.getAttribute("sessionId");
    }

    // ═══════════════════════ 목록 ═══════════════════════

    public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            int page     = Integer.parseInt(String.valueOf(map.getOrDefault("page", "1")));
            int pageSize = Integer.parseInt(String.valueOf(map.getOrDefault("pageSize", "15")));
            map.put("offset", (page - 1) * pageSize);
            map.put("pageSize", pageSize);

            List<Map<String, Object>> list = mapper.selectBoardList(map);
            List<Map<String, Object>> hotList = mapper.selectHotBoardList();

            applyEditorThumbnail(list);
            applyEditorThumbnail(hotList);

            result.put("result", "success");
            result.put("list", list);
            result.put("totalCount", mapper.selectBoardCount(map));
            result.put("hotList", hotList);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ═══════════════════════ 상세 ═══════════════════════

    @Transactional
    public HashMap<String, Object> getBoardDetail(Long boardId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            HashMap<String, Object> param = new HashMap<>();
            param.put("boardId", boardId);

            // 조회수 증가
            mapper.increaseViewCount(param);

            Map<String, Object> board = mapper.selectBoardById(param);
            if (board == null) {
                result.put("result", "fail");
                result.put("message", "게시글을 찾을 수 없습니다.");
                return result;
            }

            // 이미지
            List<Map<String, Object>> imgList = mapper.selectBoardImgList(param);

            // 댓글
            List<Map<String, Object>> commentList = mapper.selectCommentList(param);
         // 태그
            List<String> tagList = mapper.selectTagsByBoardId(boardId);

            // 투표
            Map<String, Object> poll = null;
            List<Map<String, Object>> pollOptions = null;

            if ("Y".equals(String.valueOf(board.get("HAS_POLL")))) {
                poll = mapper.selectPollByBoardId(param);

                if (poll != null) {
                    HashMap<String, Object> pollParam = new HashMap<>();
                    pollParam.put("pollId", poll.get("POLL_ID"));
                    pollOptions = mapper.selectPollOptions(pollParam);

                    if (userId != null) {
                        pollParam.put("userId", userId);

                        int voted = mapper.selectVoteExists(pollParam);
                        poll.put("myVoted", voted > 0);

                        if (voted > 0) {
                            Map<String, Object> myVote = mapper.selectMyVote(pollParam);
                            poll.put("myOptionId", myVote != null ? myVote.get("optionId") : null);
                        }
                    }
                } else {
                    board.put("HAS_POLL", "N");
                }
            }

            // 내 반응
            List<Map<String, Object>> myReactions = new ArrayList<>();
            if (userId != null) {
                HashMap<String, Object> reactionParam = new HashMap<>();
                reactionParam.put("userId", userId);
                reactionParam.put("boardId", boardId);
                myReactions = mapper.selectMyReactions(reactionParam);
            }

            // 북마크 여부
            boolean bookmarked = false;
            if (userId != null) {
                HashMap<String, Object> bookmarkParam = new HashMap<>();
                bookmarkParam.put("userId", userId);
                bookmarkParam.put("boardId", boardId);
                bookmarked = mapper.selectBookmarkExists(bookmarkParam) > 0;
            }

            result.put("result", "success");
            result.put("board", board);
            result.put("imgList", imgList);
            result.put("commentList", commentList);
            result.put("tagList", tagList);
            result.put("poll", poll);
            result.put("pollOptions", pollOptions);
            result.put("myReactions", myReactions);
            result.put("bookmarked", bookmarked);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("getBoardDetail 오류: " + e.getMessage());
            result.put("result", "fail");
            result.put("message", e.getMessage());
        }

        return result;
    }
    // ═══════════════════════ 작성 ═══════════════════════

    @Transactional
    public HashMap<String, Object> writeBoard(HashMap<String, Object> map,
                                               MultipartFile[] files,
                                               String question,
                                               List<String> options,
                                               String endDate,
                                               List<String> tags,        // ★ 추가
                                               HttpServletRequest request) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            if (userId == null) {
                result.put("result", "fail");
                result.put("message", "로그인이 필요합니다.");
                return result;
            }
            map.put("userId", userId);

            boolean hasPoll = question != null && !question.isEmpty();
            map.put("hasPoll", hasPoll ? "Y" : "N");

            mapper.insertBoard(map);
            Long boardId = Long.parseLong(String.valueOf(map.get("boardId")));

            // ★ 본문 추출 제거 → 태그 입력칸에서 받은 tags 사용
            if (tags != null) {
                for (String tag : tags) {
                    if (tag == null || tag.isBlank()) continue;
                    String cleanTag = tag.replace("#", "").trim();
                    if (cleanTag.isEmpty()) continue;
                    HashMap<String, Object> tagMap = new HashMap<>();
                    tagMap.put("boardId", boardId);
                    tagMap.put("tagName", cleanTag);
                    mapper.insertBoardTag(tagMap);
                }
            }

            // 이미지 저장
            if (files != null) {
                int order = 1;
                for (MultipartFile file : files) {
                    if (file == null || file.isEmpty()) continue;
                    String imgUrl = saveFile(file, request);
                    HashMap<String, Object> imgMap = new HashMap<>();
                    imgMap.put("boardId",   boardId);
                    imgMap.put("imgUrl",    imgUrl);
                    imgMap.put("sortOrder", order++);
                    mapper.insertBoardImg(imgMap);
                }
            }

            // 투표 저장
            if (hasPoll && options != null && options.size() >= 2) {
                HashMap<String, Object> pollMap = new HashMap<>();
                pollMap.put("boardId",  boardId);
                pollMap.put("question", question);
                pollMap.put("endDate",  endDate);
                mapper.insertPoll(pollMap);
                Long pollId = Long.parseLong(String.valueOf(pollMap.get("pollId")));

                for (int i = 0; i < options.size(); i++) {
                    HashMap<String, Object> optMap = new HashMap<>();
                    optMap.put("pollId",     pollId);
                    optMap.put("optionText", options.get(i));
                    optMap.put("sortOrder",  i + 1);
                    mapper.insertPollOption(optMap);
                }
            }

            result.put("result",  "success");
            result.put("boardId", boardId);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", e.getMessage());
        }
        return result;
    }

    // ═══════════════════════ 삭제 ═══════════════════════

    public HashMap<String, Object> deleteBoard(Long boardId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            HashMap<String, Object> map = new HashMap<>();
            map.put("boardId", boardId);
            map.put("userId",  userId);
            mapper.deleteBoard(map);
            result.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ═══════════════════════ 댓글 ═══════════════════════

    @Transactional
    public HashMap<String, Object> writeComment(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            if (userId == null) {
                result.put("result", "fail");
                result.put("message", "로그인이 필요합니다.");
                return result;
            }
            map.put("userId", userId);
            mapper.insertComment(map);
         // 🔥 게시글 댓글 알람 (답글 아닐 때)
            Object parentId = map.get("parentId");

            if (parentId == null || "".equals(String.valueOf(parentId).trim())) {
                Map<String, Object> boardInfo = mapper.selectBoardById(map);

                if (boardInfo != null) {
                    String receiverId = String.valueOf(boardInfo.get("USER_ID"));
                    String senderId = userId;

                    // 자기 글에는 알람 안 보내기
                    if (!receiverId.equals(senderId)) {
                        alarmService.createAlarm(
                            receiverId,
                            "BOARD_COMMENT",
                            "게시글에 댓글이 달렸어요",
                            "작성한 게시글에 새로운 댓글이 등록되었습니다.",
                            map.get("boardId")
                        );
                    }
                }
            }
            
           parentId = map.get("parentId");
            System.out.println("parentId = " + parentId);

            if (parentId != null && !"".equals(String.valueOf(parentId).trim())) {
                Map<String, Object> parentComment = mapper.selectCommentById(parentId);
                System.out.println("parentComment = " + parentComment);

                if (parentComment != null) {
                    String receiverId = String.valueOf(parentComment.get("USER_ID"));
                    String senderId = userId;

                    System.out.println("receiverId = " + receiverId);
                    System.out.println("senderId = " + senderId);

                    if (!receiverId.equals(senderId)) {
                        alarmService.createAlarm(
                            receiverId,
                            "BOARD_REPLY",
                            "내 댓글에 답글이 달렸어요",
                            "작성한 댓글에 새 답글이 등록되었습니다.",
                            map.get("boardId")
                        );
                    }
                }
            }

            HashMap<String, Object> boardParam = new HashMap<>();
            boardParam.put("boardId", map.get("boardId"));
            mapper.increaseCommentCount(boardParam);

            result.put("result",    "success");
            result.put("commentId", map.get("commentId"));
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    @Transactional
    public HashMap<String, Object> deleteComment(Long commentId, Long boardId) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            HashMap<String, Object> map = new HashMap<>();
            map.put("commentId", commentId);
            map.put("userId",    userId);
            mapper.deleteComment(map);

            HashMap<String, Object> boardParam = new HashMap<>();
            boardParam.put("boardId", boardId);
            mapper.decreaseCommentCount(boardParam);

            result.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ═══════════════════════ 추천/싫어요 ═══════════════════════

    @Transactional
    public HashMap<String, Object> toggleReaction(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            if (userId == null) {
                result.put("result", "fail");
                result.put("message", "로그인이 필요합니다.");
                return result;
            }
            map.put("userId", userId);

            // ★ "null" 문자열, 빈 문자열 → 실제 null 변환
            if (isBlank(map.get("commentId"))) map.put("commentId", null);
            if (isBlank(map.get("boardId")))   map.put("boardId",   null);

            String type   = String.valueOf(map.get("type"));   // LIKE / DISLIKE
            String target = String.valueOf(map.get("target")); // BOARD / COMMENT
            boolean isBoard = "BOARD".equals(target);

            int exists = mapper.selectReactionExists(map);

            if (exists > 0) {
                // ── 이미 눌렀음 → 취소
                mapper.deleteReaction(map);
                if (isBoard) {
                    if ("LIKE".equals(type))    mapper.decreaseBoardLikeCount(map);
                    else                        mapper.decreaseBoardDislikeCount(map);
                } else {
                    mapper.decreaseCommentLikeCount(map);
                }
                result.put("action", "removed");

            } else {
                // ── 반대 타입이 눌려 있으면 먼저 제거
                String oppositeType = "LIKE".equals(type) ? "DISLIKE" : "LIKE";
                map.put("type", oppositeType);
                int oppositeExists = mapper.selectReactionExists(map);
                if (oppositeExists > 0) {
                    mapper.deleteReaction(map);
                    if (isBoard) {
                        if ("LIKE".equals(oppositeType))    mapper.decreaseBoardLikeCount(map);
                        else                                mapper.decreaseBoardDislikeCount(map);
                    } else {
                        mapper.decreaseCommentLikeCount(map);
                    }
                }

                // ── 원래 타입으로 INSERT
                map.put("type", type);
                mapper.insertReaction(map);
                if ("LIKE".equals(type)) {
                    if (isBoard) {
                        Map<String, Object> boardInfo = mapper.selectBoardById(map);
                        if (boardInfo != null) {
                            String receiverId = String.valueOf(boardInfo.get("USER_ID"));
                            if (!receiverId.equals(userId)) {
                                alarmService.createAlarm(
                                    receiverId,
                                    "BOARD_LIKE",
                                    "게시글에 추천이 눌렸어요",
                                    "작성한 게시글에 추천이 추가되었습니다.",
                                    map.get("boardId")
                                );
                            }
                        }
                    } else {
                        Map<String, Object> commentInfo = mapper.selectCommentById(map.get("commentId"));
                        if (commentInfo != null) {
                            String receiverId = String.valueOf(commentInfo.get("USER_ID"));
                            if (!receiverId.equals(userId)) {
                                alarmService.createAlarm(
                                    receiverId,
                                    "COMMENT_LIKE",
                                    "댓글에 좋아요가 눌렸어요",
                                    "작성한 댓글에 좋아요가 추가되었습니다.",
                                    commentInfo.get("BOARD_ID")
                                );
                            }
                        }
                    }
                }
                if (isBoard) {
                    if ("LIKE".equals(type))    mapper.increaseBoardLikeCount(map);
                    else                        mapper.increaseBoardDislikeCount(map);
                } else {
                    mapper.increaseCommentLikeCount(map);
                }
                result.put("action", "added");
            }

            if (isBoard) mapper.updateHotFlag();

            result.put("result", "success");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ★ null / "" / "null" 체크 헬퍼
    private boolean isBlank(Object val) {
        if (val == null) return true;
        String s = String.valueOf(val).trim();
        return s.isEmpty() || "null".equals(s);
    }

    // ═══════════════════════ 신고 ═══════════════════════

    public HashMap<String, Object> reportBoard(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            if (userId == null) {
                result.put("result", "fail");
                result.put("message", "로그인이 필요합니다.");
                return result;
            }
            map.put("userId", userId);

            int exists = mapper.selectReportExists(map);
            if (exists > 0) {
                result.put("result",  "duplicate");
                result.put("message", "이미 신고한 게시글입니다.");
                return result;
            }

            mapper.insertReport(map);

            if ("BOARD".equals(map.get("target"))) {
                mapper.blindBoardIfReported(map);
            }

            result.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ═══════════════════════ 투표 ═══════════════════════

    @Transactional
    public HashMap<String, Object> vote(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();
        try {
            String userId = getUserId();
            if (userId == null) {
                result.put("result", "fail");
                result.put("message", "로그인이 필요합니다.");
                return result;
            }
            map.put("userId", userId);

            int exists = mapper.selectVoteExists(map);
            if (exists > 0) {
                result.put("result",  "duplicate");
                result.put("message", "이미 투표하셨습니다.");
                return result;
            }

            mapper.insertVote(map);
            mapper.increaseVoteCount(map);

            result.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
        }
        return result;
    }

    // ═══════════════════════ 파일 저장 ═══════════════════════

    private String saveFile(MultipartFile file, HttpServletRequest request) throws Exception {
        String uploadPath = request.getServletContext().getRealPath("/img/board");

        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        String ext = originalName.substring(originalName.lastIndexOf("."));
        String saveName = UUID.randomUUID().toString() + ext;

        file.transferTo(new File(dir, saveName));

        return "/img/board/" + saveName;
    }
    
    @Transactional
    public HashMap<String, Object> toggleBookmark(HashMap<String, Object> map) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            String userId = getUserId();

            if (userId == null) {
                result.put("result", "fail");
                result.put("message", "로그인이 필요합니다.");
                return result;
            }

            map.put("userId", userId);

            int exists = mapper.selectBookmarkExists(map);

            if (exists > 0) {
                mapper.deleteBookmark(map);
                result.put("bookmarked", false);
            } else {
                mapper.insertBookmark(map);
                result.put("bookmarked", true);
            }

            result.put("result", "success");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", e.getMessage());
        }

        return result;
    }
    
    public HashMap<String, Object> getBookmarkList(String userId) {
        HashMap<String, Object> result = new HashMap<>();

        if (userId == null || userId.isBlank()) {
            result.put("result", "fail");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        List<Map<String, Object>> list = mapper.selectBookmarkList(userId);

        result.put("result", "success");
        result.put("list", list);

        return result;
    }
    public HashMap<String, Object> getBoardListByTag(String tag) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            List<Map<String, Object>> list = mapper.selectBoardListByTag(tag);

            applyEditorThumbnail(list);

            result.put("result", "success");
            result.put("list", list);
            result.put("tag", tag);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            result.put("message", e.getMessage());
        }

        return result;
    }
    private String extractFirstImgUrl(String content) {
        if (content == null || content.isBlank()) {
            return null;
        }

        Pattern pattern = Pattern.compile(
            "<img[^>]+src=[\"']([^\"']+)[\"']",
            Pattern.CASE_INSENSITIVE
        );

        Matcher matcher = pattern.matcher(content);

        if (matcher.find()) {
            return matcher.group(1);
        }

        return null;
    }

    private void applyEditorThumbnail(List<Map<String, Object>> list) {
        if (list == null) {
            return;
        }

        for (Map<String, Object> item : list) {
            Object thumbObj = item.get("thumbUrl");

            if (thumbObj != null && !String.valueOf(thumbObj).isBlank()) {
                continue;
            }

            Object contentObj = item.get("CONTENT");

            if (contentObj == null) {
                contentObj = item.get("content");
            }

            String editorImgUrl = extractFirstImgUrl(
                contentObj != null ? String.valueOf(contentObj) : null
            );

            if (editorImgUrl != null) {
                item.put("thumbUrl", editorImgUrl);
            }
        }
    }
}