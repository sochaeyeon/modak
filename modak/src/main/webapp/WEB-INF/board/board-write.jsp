<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page deferredSyntaxAllowedAsLiteral="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글쓰기 - 모닥모닥</title>
    <link rel="stylesheet" href="/css/common/font.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        :root {
            --cream:#F6F0E6; --orange:#E8732A; --orange2:#C4621E;
            --brown:#2C1E0F; --brown3:#8B6B4A; --brown4:#B89A7A;
            --white:#FFFDF8; --border:rgba(44,30,15,.1);
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { background:var(--cream); color:var(--brown); font-family:'Apple SD Gothic Neo',sans-serif; }
        [v-cloak] { display:none; }

        .page-wrap { max-width:800px; margin:0 auto; padding:32px 24px 80px; }

        .write-title { font-size:22px; font-weight:800; margin-bottom:28px; color:var(--brown); }

        .form-section {
            background:var(--white); border:1.5px solid var(--border);
            border-radius:18px; padding:28px; margin-bottom:16px;
        }
        .form-label {
            font-size:12px; font-weight:800; color:var(--brown3);
            letter-spacing:.06em; margin-bottom:10px; display:block;
        }
        .form-input, .form-textarea, .form-select {
            width:100%; padding:12px 16px; border:1.5px solid var(--border);
            border-radius:12px; background:#fff; color:var(--brown);
            font-size:14px; font-family:inherit; outline:none;
            transition:border-color .18s;
        }
        .form-input:focus, .form-textarea:focus, .form-select:focus {
            border-color:var(--orange);
            box-shadow:0 0 0 3px rgba(232,115,42,.1);
        }
        .form-textarea { min-height:240px; resize:vertical; line-height:1.7; }
        .form-select { height:44px; cursor:pointer; }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:16px; }

        /* 이미지 업로드 */
        .img-upload-area {
            border:2px dashed var(--border); border-radius:14px;
            padding:24px; text-align:center; cursor:pointer;
            transition:border-color .18s, background .18s;
        }
        .img-upload-area:hover { border-color:var(--orange); background:rgba(232,115,42,.04); }
        .img-preview-list { display:flex; flex-wrap:wrap; gap:10px; margin-top:14px; }
        .img-preview-item {
            position:relative; width:90px; height:90px;
            border-radius:10px; overflow:hidden; border:1.5px solid var(--border);
        }
        .img-preview-item img { width:100%; height:100%; object-fit:cover; }
        .img-remove {
            position:absolute; top:4px; right:4px; width:20px; height:20px;
            border-radius:50%; background:rgba(0,0,0,.55); color:#fff;
            border:none; font-size:11px; cursor:pointer;
            display:flex; align-items:center; justify-content:center;
        }

        /* 제품 링크 */
        .product-search-wrap { position:relative; }
        .product-search-result {
            position:absolute; top:100%; left:0; right:0; z-index:100;
            background:#fff; border:1.5px solid var(--border); border-radius:12px;
            box-shadow:0 8px 24px rgba(0,0,0,.1); max-height:240px; overflow-y:auto;
        }
        .product-item {
            display:flex; align-items:center; gap:12px; padding:12px 14px;
            cursor:pointer; transition:background .15s;
        }
        .product-item:hover { background:rgba(232,115,42,.06); }
        .product-item img { width:44px; height:44px; border-radius:8px; object-fit:cover; }

        /* 투표 */
        .poll-section { margin-top:14px; }
        .poll-toggle {
            display:flex; align-items:center; gap:10px; cursor:pointer;
            padding:12px 16px; border:1.5px solid var(--border); border-radius:12px;
            background:#fff; font-size:13px; font-weight:700; color:var(--brown3);
            transition:all .18s;
        }
        .poll-toggle.active { border-color:var(--orange); color:var(--orange); background:rgba(232,115,42,.06); }
        .poll-option-row { display:flex; align-items:center; gap:8px; margin-top:8px; }
        .poll-option-row input { flex:1; }
        .btn-remove-option {
            width:32px; height:32px; border-radius:8px; border:1.5px solid var(--border);
            background:#fff; color:var(--brown3); cursor:pointer; font-size:14px;
            transition:all .18s;
        }
        .btn-remove-option:hover { border-color:red; color:red; }
        .btn-add-option {
            height:36px; padding:0 14px; border:1.5px dashed var(--border);
            border-radius:10px; background:transparent; color:var(--brown3);
            font-size:12px; font-weight:700; cursor:pointer; margin-top:8px;
            transition:all .18s;
        }
        .btn-add-option:hover { border-color:var(--orange); color:var(--orange); }

        /* 하단 버튼 */
        .action-row { display:flex; gap:12px; justify-content:flex-end; margin-top:8px; }
        .btn-cancel {
            height:46px; padding:0 24px; border:1.5px solid var(--border);
            border-radius:12px; background:#fff; color:var(--brown3);
            font-size:14px; font-weight:700; cursor:pointer; transition:all .18s;
        }
        .btn-cancel:hover { border-color:var(--brown3); }
        .btn-submit {
            height:46px; padding:0 32px; border:none; border-radius:12px;
            background:var(--orange); color:#fff; font-size:14px; font-weight:800;
            cursor:pointer; transition:background .18s;
        }
        .btn-submit:hover { background:var(--orange2); }
        .btn-submit:disabled { opacity:.5; cursor:not-allowed; }

        /* 토스트 */
        .toast {
            position:fixed; left:50%; bottom:32px; transform:translateX(-50%) translateY(20px);
            padding:12px 22px; border-radius:999px; background:var(--brown);
            color:var(--white); font-size:13px; opacity:0; pointer-events:none;
            transition:.25s ease; z-index:9999;
        }
        .toast.show { opacity:1; transform:translateX(-50%) translateY(0); }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>

<div id="app" v-cloak>
<div class="page-wrap">
    <div class="write-title">✏️ 글쓰기</div>

    <!-- 기본 정보 -->
    <div class="form-section">
        <div class="form-row">
            <div>
                <label class="form-label">카테고리</label>
                <select class="form-select" v-model="form.category">
                    <option value="FREE">🗣 자유</option>
                    <option value="REVIEW">⭐ 후기</option>
                    <option value="TIP">💡 꿀팁</option>
                    <option value="QNA">❓ Q&A</option>
                </select>
            </div>
            <div>
                <label class="form-label">제목</label>
                <input class="form-input" v-model="form.title" placeholder="제목을 입력하세요">
            </div>
        </div>
        <div>
            <label class="form-label">내용</label>
            <textarea class="form-textarea" v-model="form.content"
                placeholder="캠핑 이야기를 자유롭게 나눠보세요 🔥"></textarea>
        </div>
    </div>

    <!-- 이미지 -->
    <div class="form-section">
        <label class="form-label">📷 이미지 첨부 (최대 5장)</label>
        <div class="img-upload-area" @click="$refs.fileInput.click()" v-if="images.length < 5">
            <div style="font-size:32px;margin-bottom:8px;">📸</div>
            <div style="font-size:13px;color:var(--brown3);">클릭하여 이미지를 추가하세요</div>
            <div style="font-size:11px;color:var(--brown4);margin-top:4px;">JPG, PNG, WEBP · {{ images.length }}/5</div>
        </div>
        <input type="file" ref="fileInput" accept="image/*" multiple
               style="display:none" @change="fnAddImages">
        <div class="img-preview-list">
            <div class="img-preview-item" v-for="(img, i) in images" :key="i">
                <img :src="img.preview">
                <button class="img-remove" @click="fnRemoveImage(i)">✕</button>
            </div>
        </div>
    </div>

    <!-- 제품 링크 -->
    <div class="form-section">
        <label class="form-label">🔗 제품 링크 (선택)</label>
        <div class="product-search-wrap">
            <input class="form-input" v-model="productKeyword"
                   placeholder="연관 캠핑 장비를 검색하세요"
                   @input="fnSearchProduct" @focus="showProductResult = true">
            <div class="product-search-result" v-if="showProductResult && productResults.length > 0">
                <div class="product-item" v-for="p in productResults" :key="p.productId"
                     @click="fnSelectProduct(p)">
                    <img :src="p.imgUrl || '/img/product/default.jpg'" :alt="p.productName">
                    <div>
                        <div style="font-size:13px;font-weight:700;color:var(--brown);">{{ p.productName }}</div>
                        <div style="font-size:11px;color:var(--brown3);">{{ Number(p.price).toLocaleString() }}원</div>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="selectedProduct" style="display:flex;align-items:center;gap:12px;margin-top:12px;
             padding:12px 14px;border:1.5px solid rgba(232,115,42,.3);border-radius:12px;background:rgba(232,115,42,.06);">
            <img :src="selectedProduct.imgUrl" style="width:44px;height:44px;border-radius:8px;object-fit:cover;">
            <div style="flex:1">
                <div style="font-size:13px;font-weight:700;">{{ selectedProduct.productName }}</div>
                <div style="font-size:11px;color:var(--brown3);">{{ Number(selectedProduct.price).toLocaleString() }}원</div>
            </div>
            <button @click="selectedProduct = null; productKeyword = ''"
                style="border:none;background:none;color:var(--brown3);cursor:pointer;font-size:16px;">✕</button>
        </div>
    </div>

    <!-- 투표 -->
    <div class="form-section">
        <div class="poll-toggle" :class="{ active: showPoll }" @click="showPoll = !showPoll">
            <span>📊</span>
            <span>{{ showPoll ? '투표 기능 켜짐' : '투표 추가하기' }}</span>
            <span style="margin-left:auto;">{{ showPoll ? '▲' : '▼' }}</span>
        </div>

        <div class="poll-section" v-if="showPoll">
            <div style="margin-top:14px;">
                <label class="form-label">투표 질문</label>
                <input class="form-input" v-model="poll.question" placeholder="무엇을 물어볼까요?">
            </div>
            <div style="margin-top:12px;">
                <label class="form-label">선택지 (최소 2개)</label>
                <div class="poll-option-row" v-for="(opt, i) in poll.options" :key="i">
                    <input class="form-input" v-model="poll.options[i]"
                           :placeholder="'선택지 ' + (i + 1)">
                    <button class="btn-remove-option" @click="fnRemoveOption(i)"
                            v-if="poll.options.length > 2">✕</button>
                </div>
                <button class="btn-add-option" @click="poll.options.push('')"
                        v-if="poll.options.length < 6">+ 선택지 추가</button>
            </div>
            <div style="margin-top:12px;">
                <label class="form-label">투표 마감일 (선택)</label>
                <input class="form-input" type="date" v-model="poll.endDate"
                       style="max-width:180px;">
            </div>
        </div>
    </div>

    <!-- 버튼 -->
    <div class="action-row">
        <button class="btn-cancel" @click="history.back()">취소</button>
        <button class="btn-submit" @click="fnSubmit" :disabled="isSubmitting">
            {{ isSubmitting ? '등록 중...' : '🔥 글 등록하기' }}
        </button>
    </div>
</div>

<div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
</div>

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
const { createApp } = Vue;
createApp({
    data() {
        return {
            form: { title: '', content: '', category: 'FREE' },
            images: [],
            productKeyword: '', productResults: [],
            selectedProduct: null, showProductResult: false,
            showPoll: false,
            poll: { question: '', options: ['', ''], endDate: '' },
            isSubmitting: false,
            toastVisible: false, toastMsg: '',
            productTimer: null
        };
    },
    methods: {
        fnAddImages(e) {
            const files = Array.from(e.target.files);
            const remaining = 5 - this.images.length;
            files.slice(0, remaining).forEach(file => {
                const reader = new FileReader();
                reader.onload = ev => {
                    this.images.push({ file, preview: ev.target.result });
                };
                reader.readAsDataURL(file);
            });
            e.target.value = '';
        },
        fnRemoveImage(i) { this.images.splice(i, 1); },
        fnRemoveOption(i) { this.poll.options.splice(i, 1); },
        fnSearchProduct() {
            clearTimeout(this.productTimer);
            if (!this.productKeyword.trim()) { this.productResults = []; return; }
            this.productTimer = setTimeout(() => {
                $.ajax({
                    url: '/product/list.dox', type: 'POST',
                    data: { searchKeyword: this.productKeyword, page: 1, pageSize: 8 },
                    success: (res) => {
                        this.productResults = res.list || [];
                    }
                });
            }, 300);
        },
        fnSelectProduct(p) {
            this.selectedProduct = p;
            this.productKeyword  = p.productName;
            this.showProductResult = false;
        },
        showToast(msg) {
            this.toastMsg     = msg;
            this.toastVisible = true;
            setTimeout(() => { this.toastVisible = false; }, 2500);
        },
        fnSubmit() {
            if (!this.form.title.trim()) { this.showToast('제목을 입력해주세요.'); return; }
            if (!this.form.content.trim()) { this.showToast('내용을 입력해주세요.'); return; }
            if (this.showPoll) {
                if (!this.poll.question.trim()) { this.showToast('투표 질문을 입력해주세요.'); return; }
                const validOpts = this.poll.options.filter(o => o.trim());
                if (validOpts.length < 2) { this.showToast('선택지를 2개 이상 입력해주세요.'); return; }
            }

            this.isSubmitting = true;
            const fd = new FormData();
            fd.append('title',    this.form.title);
            fd.append('content',  this.form.content);
            fd.append('category', this.form.category);
            if (this.selectedProduct) fd.append('productId', this.selectedProduct.productId);
            this.images.forEach(img => fd.append('files', img.file));

            if (this.showPoll) {
                fd.append('pollQuestion', this.poll.question);
                fd.append('pollEndDate',  this.poll.endDate);
                this.poll.options.filter(o => o.trim()).forEach(o => fd.append('pollOptions', o));
            }

            $.ajax({
                url: '/board/write.dox', type: 'POST',
                data: fd, processData: false, contentType: false,
                success: (res) => {
                    this.isSubmitting = false;
                    if (res.result === 'success') {
                        location.href = '/board/detail.do?boardId=' + res.boardId;
                    } else {
                        this.showToast(res.message || '등록에 실패했습니다.');
                    }
                },
                error: () => { this.isSubmitting = false; this.showToast('서버 오류가 발생했습니다.'); }
            });
        }
    },
    mounted() {
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.product-search-wrap')) {
                this.showProductResult = false;
            }
        });
    }
}).mount('#app');
</script>
</body>
</html>
