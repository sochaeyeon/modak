<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비속어 단어 관리 - 관리자</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background: #F6F0E6; color: #3B2412; padding: 30px; }
        .wrap { max-width: 600px; margin: 0 auto; }
        h2 { margin-bottom: 20px; }
        .add-row { display: flex; gap: 8px; margin-bottom: 20px; }
        .add-row input { flex: 1; height: 42px; border: 1.5px solid rgba(92,61,30,.15); border-radius: 10px; padding: 0 14px; font-size: 14px; box-sizing: border-box; }
        .add-row button { height: 42px; padding: 0 18px; border: none; border-radius: 10px; background: #E8732A; color: #fff; font-weight: 700; cursor: pointer; }
        .add-row button:hover { background: #5C3D1E; }
        table { width: 100%; border-collapse: collapse; background: #FFFDF9; border-radius: 14px; overflow: hidden; }
        th, td { padding: 12px 14px; text-align: left; border-bottom: 1px solid rgba(92,61,30,.08); font-size: 14px; }
        th { background: #EDE6D5; font-weight: 800; }
        tr:last-child td { border-bottom: none; }
        .del-btn { border: none; background: none; color: #c0392b; font-weight: 700; cursor: pointer; }
        .del-btn:hover { text-decoration: underline; }
        .empty-row td { text-align: center; color: #9e9386; padding: 30px 0; }
    </style>
</head>
<body>
<div class="wrap">
    <h2>비속어 단어 관리</h2>

    <div class="add-row">
        <input type="text" id="wordInput" placeholder="추가할 단어 입력" maxlength="50">
        <button id="addBtn">추가</button>
    </div>

    <table>
        <thead>
            <tr><th>단어</th><th>등록일</th><th></th></tr>
        </thead>
        <tbody id="wordTableBody"></tbody>
    </table>
</div>

<script>
    function loadList() {
        $.ajax({
            url: '/admin/badword/list.dox', type: 'POST', dataType: 'json',
            success: function (res) {
                var body = $('#wordTableBody');
                body.empty();

                var list = res.list || [];

                if (list.length === 0) {
                    body.append('<tr class="empty-row"><td colspan="3">등록된 단어가 없습니다.</td></tr>');
                    return;
                }

                list.forEach(function (w) {
                    body.append(
                        '<tr>' +
                            '<td>' + escHtml(w.word) + '</td>' +
                            '<td>' + escHtml(w.createdAt) + '</td>' +
                            '<td><button class="del-btn" data-id="' + w.wordId + '">삭제</button></td>' +
                        '</tr>'
                    );
                });
            },
            error: function () {
                alert('목록을 불러오지 못했습니다.');
            }
        });
    }

    function escHtml(str) {
        return String(str || '')
            .replace(/&/g, '&amp;').replace(/</g, '&lt;')
            .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    $('#wordInput').on('keydown', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            $('#addBtn').click();
        }
    });

    $('#addBtn').on('click', function () {
        var word = $('#wordInput').val().trim();
        if (!word) return;

        $.ajax({
            url: '/admin/badword/add.dox', type: 'POST', data: { word: word }, dataType: 'json',
            success: function (res) {
                if (res.result === 'success') {
                    $('#wordInput').val('').focus();
                    loadList();
                } else {
                    alert(res.message || '추가에 실패했습니다.');
                }
            },
            error: function () {
                alert('서버 오류가 발생했습니다.');
            }
        });
    });

    $('#wordTableBody').on('click', '.del-btn', function () {
        var wordId = $(this).data('id');
        if (!confirm('이 단어를 삭제하시겠습니까?')) return;

        $.ajax({
            url: '/admin/badword/delete.dox', type: 'POST', data: { wordId: wordId }, dataType: 'json',
            success: function (res) {
                if (res.result === 'success') {
                    loadList();
                } else {
                    alert('삭제에 실패했습니다.');
                }
            },
            error: function () {
                alert('서버 오류가 발생했습니다.');
            }
        });
    });

    $(document).ready(loadList);
</script>
</body>
</html>