package com.example.modak.board.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.modak.board.dao.BoardService;
import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

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
    public String detailPage(@RequestParam(required = false) Long boardId) {

        if (boardId == null) {
            return "redirect:/board/list.do";
        }

        return "board/board-detail";
    }
    @GetMapping("/edit.do")
    public String editPage() {
        return "board/board-edit";
    }
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
            @RequestParam(required = false) List<String> tags,  // ★ 추가
            HttpServletRequest request) {

        return new Gson().toJson(
            boardService.writeBoard(map, files, pollQuestion, pollOptions, pollEndDate, tags, request) 
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
    
    @PostMapping("/editor/image-upload.dox")
    @ResponseBody
    public HashMap<String, Object> uploadEditorImage(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request
    ) {
        HashMap<String, Object> result = new HashMap<>();

        try {
            if (file == null || file.isEmpty()) {
                result.put("result", "fail");
                result.put("message", "업로드할 이미지가 없습니다.");
                return result;
            }

            String contentType = file.getContentType();

            if (contentType == null || !contentType.startsWith("image/")) {
                result.put("result", "fail");
                result.put("message", "이미지 파일만 업로드할 수 있습니다.");
                return result;
            }

            String uploadPath = request.getServletContext().getRealPath("/img/board");

            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String originalName = file.getOriginalFilename();
            String ext = "";

            if (originalName != null && originalName.lastIndexOf(".") != -1) {
                ext = originalName.substring(originalName.lastIndexOf("."));
            }

            String saveName = UUID.randomUUID().toString() + ext;

            File saveFile = new File(dir, saveName);
            file.transferTo(saveFile);

            String imgUrl = "/img/board/" + saveName;

            result.put("result", "success");
            result.put("imgUrl", imgUrl);

        } catch (Exception e) {
            result.put("result", "fail");
            result.put("message", "이미지 업로드 중 오류가 발생했습니다.");
        }

        return result;
    }
    @PostMapping(value = "/edit-info.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getBoardEditInfo(@RequestParam Long boardId) {
        return new Gson().toJson(boardService.getBoardEditInfo(boardId));
    }
    
    @PostMapping(value = "/recent-posts.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getRecentPosts(
            @RequestParam String targetUserId,
            @RequestParam(defaultValue = "3") int limit) {

        HashMap<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> posts = boardService.getRecentPosts(targetUserId, limit);
            result.put("result", "success");
            result.put("posts", posts);
        } catch (Exception e) {
            result.put("result", "fail");
            result.put("message", "최근 글을 불러오지 못했습니다.");
        }
        return new Gson().toJson(result);
    }
    
    @GetMapping("/.well-known/appspecific/com.chrome.devtools.json")
    @ResponseBody
    public ResponseEntity<Void> chromeDevToolsProbe() {
        return ResponseEntity.noContent().build(); // 204
    }
    
    @PostMapping(value = "/edit.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String editBoard(
            @RequestParam HashMap<String, Object> map,
            @RequestParam(required = false) String pollQuestion,
            @RequestParam(required = false) List<String> pollOptions,
            @RequestParam(required = false) String pollEndDate,
            @RequestParam(required = false) List<String> tags) {

        return new Gson().toJson(
            boardService.editBoard(map, pollQuestion, pollOptions, pollEndDate, tags)
        );
    }
}