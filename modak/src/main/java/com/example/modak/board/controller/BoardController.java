package com.example.modak.board.controller;

import com.example.modak.board.dao.BoardService;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired private BoardService boardService;
    @Autowired private HttpSession session;

    // ── 페이지 라우팅 ──
    @GetMapping("/list.do")
    public String listPage() { return "board/board-list"; }

    @GetMapping("/write.do")
    public String writePage() { return "board/board-write"; }

    @GetMapping("/detail.do")
    public String detailPage() { return "board/board-detail"; }

    // ── API ──

    @PostMapping(value = "/list.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getBoardList(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(boardService.getBoardList(map));
    }

    @PostMapping(value = "/detail.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getBoardDetail(@RequestParam Long boardId) {
        return new Gson().toJson(boardService.getBoardDetail(boardId));
    }

    @PostMapping(value = "/write.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String writeBoard(
            @RequestParam HashMap<String, Object> map,
            @RequestParam(required = false) MultipartFile[] files,
            @RequestParam(required = false) String pollQuestion,
            @RequestParam(required = false) List<String> pollOptions,
            @RequestParam(required = false) String pollEndDate,
            HttpServletRequest request) {

        return new Gson().toJson(
            boardService.writeBoard(map, files, pollQuestion, pollOptions, pollEndDate, request)
        );
    }

    @PostMapping(value = "/delete.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String deleteBoard(@RequestParam Long boardId) {
        return new Gson().toJson(boardService.deleteBoard(boardId));
    }

    @PostMapping(value = "/comment/write.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String writeComment(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(boardService.writeComment(map));
    }

    @PostMapping(value = "/comment/delete.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String deleteComment(@RequestParam Long commentId, @RequestParam Long boardId) {
        return new Gson().toJson(boardService.deleteComment(commentId, boardId));
    }

    @PostMapping(value = "/reaction.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String toggleReaction(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(boardService.toggleReaction(map));
    }

    @PostMapping(value = "/report.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String report(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(boardService.reportBoard(map));
    }

    @PostMapping(value = "/poll/vote.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String vote(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(boardService.vote(map));
    }
    
    @PostMapping(value = "/bookmark.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String toggleBookmark(@RequestParam HashMap<String, Object> map) {
        return new Gson().toJson(boardService.toggleBookmark(map));
    }
    @PostMapping(value = "/tag/list.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getBoardListByTag(@RequestParam String tag) {
        return new Gson().toJson(boardService.getBoardListByTag(tag));
    }
}