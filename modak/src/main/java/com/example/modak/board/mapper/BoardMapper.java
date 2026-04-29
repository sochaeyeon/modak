package com.example.modak.board.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {

    // 게시글
    List<Map<String, Object>> selectBoardList(HashMap<String, Object> map);
    int selectBoardCount(HashMap<String, Object> map);
    List<Map<String, Object>> selectHotBoardList();
    Map<String, Object> selectBoardById(HashMap<String, Object> map);
    int insertBoard(HashMap<String, Object> map);
    int updateBoard(HashMap<String, Object> map);
    int deleteBoard(HashMap<String, Object> map);
    int increaseViewCount(HashMap<String, Object> map);
    int increaseCommentCount(HashMap<String, Object> map);
    int decreaseCommentCount(HashMap<String, Object> map);
    int updateHotFlag();

    // 이미지
    int insertBoardImg(HashMap<String, Object> map);
    List<Map<String, Object>> selectBoardImgList(HashMap<String, Object> map);
    int deleteBoardImg(HashMap<String, Object> map);
    int deleteBoardImgAll(HashMap<String, Object> map);

    // 댓글
    List<Map<String, Object>> selectCommentList(HashMap<String, Object> map);
    int insertComment(HashMap<String, Object> map);
    int deleteComment(HashMap<String, Object> map);

    // 추천/싫어요
    int selectReactionExists(HashMap<String, Object> map);
    int insertReaction(HashMap<String, Object> map);
    int deleteReaction(HashMap<String, Object> map);
 
    int increaseBoardLikeCount(HashMap<String, Object> map);
    int decreaseBoardLikeCount(HashMap<String, Object> map);
    int increaseBoardDislikeCount(HashMap<String, Object> map);
    int decreaseBoardDislikeCount(HashMap<String, Object> map);
    int increaseCommentLikeCount(HashMap<String, Object> map);
    int decreaseCommentLikeCount(HashMap<String, Object> map);
    List<Map<String, Object>> selectMyReactions(HashMap<String, Object> map);

    // 신고
    int selectReportExists(HashMap<String, Object> map);
    int insertReport(HashMap<String, Object> map);
    int blindBoardIfReported(HashMap<String, Object> map);

    // 투표
    int insertPoll(HashMap<String, Object> map);
    int insertPollOption(HashMap<String, Object> map);
    Map<String, Object> selectPollByBoardId(HashMap<String, Object> map);
    List<Map<String, Object>> selectPollOptions(HashMap<String, Object> map);
    int selectVoteExists(HashMap<String, Object> map);
    Map<String, Object> selectMyVote(HashMap<String, Object> map);
    int insertVote(HashMap<String, Object> map);
    int increaseVoteCount(HashMap<String, Object> map);
}