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
              <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board-write.css">
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
                                <div style="font-size:11px;color:var(--brown4);margin-top:4px;">JPG, PNG, WEBP · {{
                                    images.length }}/5</div>
                            </div>
                            <input type="file" ref="fileInput" accept="image/*" multiple style="display:none"
                                @change="fnAddImages">
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
                                <input class="form-input" v-model="productKeyword" placeholder="연관 캠핑 장비를 검색하세요"
                                    @input="fnSearchProduct" @focus="showProductResult = true">
                                <div class="product-search-result"
                                    v-if="showProductResult && productResults.length > 0">
                                    <div class="product-item" v-for="p in productResults" :key="p.productId"
                                        @click="fnSelectProduct(p)">
                                        <img :src="p.imgUrl || '/img/product/default.jpg'" :alt="p.productName">
                                        <div>
                                            <div style="font-size:13px;font-weight:700;color:var(--brown);">{{
                                                p.productName }}</div>
                                            <div style="font-size:11px;color:var(--brown3);">{{
                                                Number(p.price).toLocaleString() }}원</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-if="selectedProduct"
                                style="display:flex;align-items:center;gap:12px;margin-top:12px;
             padding:12px 14px;border:1.5px solid rgba(232,115,42,.3);border-radius:12px;background:rgba(232,115,42,.06);">
                                <img :src="selectedProduct.imgUrl"
                                    style="width:44px;height:44px;border-radius:8px;object-fit:cover;">
                                <div style="flex:1">
                                    <div style="font-size:13px;font-weight:700;">{{ selectedProduct.productName }}</div>
                                    <div style="font-size:11px;color:var(--brown3);">{{
                                        Number(selectedProduct.price).toLocaleString() }}원</div>
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
                            <button class="btn-cancel" @click="fnCancel">취소</button>
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
                                fnCancel() {
                                    const hasInput =
                                        this.form.title.trim() ||
                                        this.form.content.trim() ||
                                        this.images.length > 0 ||
                                        this.selectedProduct ||
                                        this.showPoll;

                                    if (hasInput) {
                                        if (!confirm('작성 중인 내용이 사라집니다. 취소하시겠습니까?')) {
                                            return;
                                        }
                                    }

                                    location.href = '/board/list.do';
                                },
                                fnSelectProduct(p) {
                                    this.selectedProduct = p;
                                    this.productKeyword = p.productName;
                                    this.showProductResult = false;
                                },
                                showToast(msg) {
                                    this.toastMsg = msg;
                                    this.toastVisible = true;
                                    setTimeout(() => { this.toastVisible = false; }, 2500);
                                },
                                fnSubmit() {
                                    if (!this.form.title.trim()) {
                                        this.showToast('제목을 입력해주세요.');
                                        return;
                                    }

                                    if (!this.form.content.trim()) {
                                        this.showToast('내용을 입력해주세요.');
                                        return;
                                    }

                                    // 🔥 투표 검증 먼저
                                    if (this.showPoll) {
                                        if (!this.poll.question.trim()) {
                                            this.showToast('투표 질문을 입력해주세요.');
                                            return;
                                        }

                                        const validOpts = this.poll.options.filter(o => o.trim());

                                        if (validOpts.length < 2) {
                                            this.showToast('선택지를 2개 이상 입력해주세요.');
                                            return;
                                        }

                                        if (!this.poll.endDate) {
                                            this.showToast('투표 마감 날짜를 선택해주세요!');
                                            return;
                                        }
                                    }

                                    this.isSubmitting = true;

                                    // 🔥 여기서 fd 생성
                                    const fd = new FormData();

                                    fd.append('title', this.form.title);
                                    fd.append('content', this.form.content);
                                    fd.append('category', this.form.category);

                                    if (this.selectedProduct) {
                                        fd.append('productId', this.selectedProduct.productId);
                                    }

                                    this.images.forEach(img => fd.append('files', img.file));

                                    // 🔥 검증 끝나고 넣기
                                    if (this.showPoll) {
                                        fd.append('pollQuestion', this.poll.question);
                                        fd.append('pollEndDate', this.poll.endDate);

                                        this.poll.options
                                            .filter(o => o.trim())
                                            .forEach(o => fd.append('pollOptions', o));
                                    }

                                    $.ajax({
                                        url: '/board/write.dox',
                                        type: 'POST',
                                        data: fd,
                                        processData: false,
                                        contentType: false,
                                        success: (res) => {
                                            this.isSubmitting = false;
                                            if (res.result === 'success') {
                                                location.href = '/board/detail.do?boardId=' + res.boardId;
                                            } else {
                                                this.showToast(res.message || '등록에 실패했습니다.');
                                            }
                                        },
                                        error: () => {
                                            this.isSubmitting = false;
                                            this.showToast('서버 오류가 발생했습니다.');
                                        }
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