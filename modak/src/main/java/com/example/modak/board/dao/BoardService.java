package com.example.modak.board.dao;

import com.example.modak.board.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.util.*;

@Service
public class BoardService {

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

            result.put("result",     "success");
            result.put("list",       mapper.selectBoardList(map));
            result.put("totalCount", mapper.selectBoardCount(map));
            result.put("hotList",    mapper.selectHotBoardList());
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

            // 투표
            Map<String, Object> poll = null;
            List<Map<String, Object>> pollOptions = null;
         // BoardService.java getBoardDetail - poll 처리 부분 수정
            if ("Y".equals(String.valueOf(board.get("HAS_POLL")))) {
                poll = mapper.selectPollByBoardId(param);
                if (poll != null) {  // ★ null 체크가 있는지 확인
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
                    // ★ poll 데이터 없으면 HAS_POLL 강제 N 처리
                    board.put("HAS_POLL", "N");
                }
            }

            // 내 반응
            List<Map<String, Object>> myReactions = new ArrayList<>();
            if (userId != null) {
                HashMap<String, Object> reactionParam = new HashMap<>();
                reactionParam.put("userId",  userId);
                reactionParam.put("boardId", boardId);
                myReactions = mapper.selectMyReactions(reactionParam);
            }

            result.put("result",      "success");
            result.put("board",       board);
            result.put("imgList",     imgList);
            result.put("commentList", commentList);
            result.put("poll",        poll);
            result.put("pollOptions", pollOptions);
            result.put("myReactions", myReactions);

        } catch (Exception e) {
            e.printStackTrace(); // ★ 이미 있는지 확인 - 없으면 추가
            System.out.println("getBoardDetail 오류: " + e.getMessage());
            result.put("result", "fail");
            result.put("message", e.getMessage()); // ★ 추가
        }
        return result;
    }

    // ═══════════════════════ 작성 ═══════════════════════

    @Transactional
    public HashMap<String, Object> writeBoard(HashMap<String, Object> map,
                                               MultipartFile[] files,
                                               String question,
                                               List<String> options,
                                               String endDate) {
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

            // 이미지 저장
            if (files != null) {
                int order = 1;
                for (MultipartFile file : files) {
                    if (file == null || file.isEmpty()) continue;
                    String imgUrl = saveFile(file);
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

    private String saveFile(MultipartFile file) throws Exception {
        String uploadPath = System.getProperty("user.home") + "/modak_uploads/board";
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String ext      = file.getOriginalFilename()
                              .substring(file.getOriginalFilename().lastIndexOf("."));
        String saveName = UUID.randomUUID().toString() + ext;
        file.transferTo(new File(dir, saveName));
        return "/upload/board/" + saveName;
    }
}