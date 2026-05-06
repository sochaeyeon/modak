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

            <link href="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.snow.css" rel="stylesheet">
            <script src="https://cdn.jsdelivr.net/npm/quill@1.3.7/dist/quill.min.js"></script>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css">

        </head>

        <body>
            <%@ include file="/WEB-INF/common/header.jsp" %>

                <div id="app" v-cloak>
                    <div class="page-wrap">
                        <div class="write-title">
                            <i class="ri-pencil-line"></i>
                            글쓰기
                        </div>
                        <!-- 기본 정보 -->
                        <div class="form-section">
                            <div class="form-row">
                                <div>
                                    <label class="form-label">카테고리</label>
                                    <select class="form-select" v-model="form.category">
                                        <option value="FREE">자유</option>
                                        <option value="REVIEW">후기</option>
                                        <option value="TIP">꿀팁</option>
                                        <option value="QNA">Q&A</option>
                                    </select>
                                </div>
                                <div>
                                    <label class="form-label">제목</label>
                                    <input class="form-input" v-model="form.title" placeholder="제목을 입력하세요">
                                </div>
                            </div>
                            <div>
                                <label class="form-label">
                                    <i class="ri-edit-2-line"></i>
                                    내용
                                </label>

                                <div class="quill-wrap">
                                    <div id="editorToolbar">
                                        <span class="ql-formats">
                                            <select class="ql-header">
                                                <option selected></option>
                                                <option value="1"></option>
                                                <option value="2"></option>
                                                <option value="3"></option>
                                            </select>
                                        </span>

                                        <span class="ql-formats">
                                            <button class="ql-bold" type="button"></button>
                                            <button class="ql-italic" type="button"></button>
                                            <button class="ql-underline" type="button"></button>
                                            <button class="ql-strike" type="button"></button>
                                        </span>

                                        <span class="ql-formats">
                                            <button class="ql-blockquote" type="button"></button>
                                            <button class="ql-code-block" type="button"></button>
                                        </span>

                                        <span class="ql-formats">
                                            <button class="ql-list" value="ordered" type="button"></button>
                                            <button class="ql-list" value="bullet" type="button"></button>
                                        </span>

                                        <span class="ql-formats">
                                            <select class="ql-align"></select>
                                            <select class="ql-color"></select>
                                            <select class="ql-background"></select>
                                        </span>

                                        <span class="ql-formats">
                                            <button class="ql-link" type="button"></button>
                                            <button class="ql-image" type="button"></button>
                                        </span>
                                        <span class="ql-formats">
                                            <button class="ql-clean" type="button"></button>
                                        </span>
                                    </div>

                                    <div id="editor"></div>
                                    <input id="editorImageInput" type="file" accept="image/*" style="display:none;">

                                </div>
                            </div>
                        </div>

                        <!-- 제품 링크 -->
                        <div class="form-section">
                            <label class="form-label">
                                <i class="ri-links-line"></i>
                                제품 링크 (선택)
                            </label>
                            <div class="product-search-wrap">
                                <input class="form-input" v-model="productKeyword" placeholder="연관 캠핑 장비를 검색하세요"
                                    @input="fnSearchProduct" @focus="showProductResult = true">
                                <div class="product-search-result"
                                    v-if="showProductResult && productResults.length > 0">
                                    <div class="product-item" v-for="p in productResults"
                                        :key="p.productId || p.PRODUCT_ID" @click="fnSelectProduct(p)">
                                        <img :src="p.imgUrl || p.IMG_URL || '/img/product/default.jpg'"
                                            :alt="p.productName || p.PRODUCT_NAME">
                                        <div>
                                            <div style="font-size:13px;font-weight:700;color:var(--brown);">
                                                {{ p.productName || p.PRODUCT_NAME }}
                                            </div>
                                            <div style="font-size:11px;color:var(--brown3);">
                                                {{ Number(p.price || p.PRICE || 0).toLocaleString() }}원
                                            </div>
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
                                <button class="selected-product-remove"
                                    @click="selectedProduct = null; productKeyword = ''" type="button"
                                    aria-label="선택 제품 삭제">
                                    <i class="ri-close-line"></i>
                                </button>
                            </div>
                        </div>
                        <!-- 투표 섹션 바로 위에 추가 -->
                        <div class="form-section">
                            <label class="form-label">
                                <i class="ri-price-tag-3-line"></i>
                                태그 (선택, 최대 5개)
                            </label>
                            <div class="tag-input-wrap">
                                <input class="form-input" v-model="tagInput" placeholder="#캠핑 #텐트 형식으로 입력 후 Enter"
                                    @keydown.enter.prevent="fnAddTag" style="margin-bottom:8px;">
                                <div class="tag-preview">
                                    <span class="tag-chip" v-for="(tag, i) in tags" :key="i">
                                        #{{ tag }}
                                        <button @click="tags.splice(i, 1)" type="button" aria-label="태그 삭제">
                                            <i class="ri-close-line"></i>
                                        </button>
                                    </span>
                                </div>
                            </div>
                            <div style="font-size:11px;color:var(--brown4);margin-top:4px;">
                                Enter로 태그 추가 · 최대 5개
                            </div>
                        </div>

                        <!-- 투표 -->
                        <div class="form-section">
                            <div class="poll-toggle" :class="{ active: showPoll }" @click="fnTogglePoll">
                                <span class="poll-toggle-left">
                                    <i class="ri-bar-chart-box-line"></i>
                                    <span>{{ showPoll ? '투표 기능 켜짐' : '투표 추가하기' }}</span>
                                </span>
                                <i :class="showPoll ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'"></i>
                            </div>

                            <div class="poll-section-fold" :class="{ open: showPoll, closing: pollClosing }"
                                v-show="showPoll || pollClosing">
                                <div class="poll-section-inner">
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
                                    <i v-if="!isSubmitting" class="ri-send-plane-fill"></i>
                                    {{ isSubmitting ? '등록 중...' : '글 등록하기' }}
                                </button>
                            </div>
                            <button type="button" class="page-top-btn" :class="{ show: showTopBtn }"
                                @click="fnScrollTop" aria-label="맨 위로 이동">
                                <i class="ri-arrow-up-line"></i>
                            </button>

                            <div class="toast" :class="{ show: toastVisible }">{{ toastMsg }}</div>
                        </div>
                    </div>
                </div>

                <%@ include file="/WEB-INF/common/footer.jsp" %>

                    <script>
                        const { createApp } = Vue;
                        createApp({
                            data() {
                                return {
                                    form: { title: '', category: 'FREE' },
                                    quill: null,
                                    productKeyword: '', productResults: [],
                                    selectedProduct: null, showProductResult: false,
                                    showPoll: false,
                                    poll: { question: '', options: ['', ''], endDate: '' },
                                    isSubmitting: false,
                                    toastVisible: false, toastMsg: '',
                                    productTimer: null,
                                    tags: [],       // ★ 추가
                                    tagInput: '',
                                    pollClosing: false,
                                    showTopBtn: false,
                                };
                            },
                            methods: {
                                fnRemoveOption(i) { this.poll.options.splice(i, 1); },
                                // ── 검색 ──
                                fnSearchProduct() {
                                    clearTimeout(this.productTimer);
                                    if (!this.productKeyword.trim()) { this.productResults = []; return; }
                                    this.productTimer = setTimeout(() => {
                                        $.ajax({
                                            url: '/product/list.dox', type: 'POST',
                                            data: {
                                                searchKeyword: this.productKeyword,
                                                page: 1,
                                                pageSize: 8,
                                                rentable: true,   // ★ 추가
                                                buyable: true     // ★ 추가
                                            },
                                            success: (res) => {
                                                this.productResults = res.list || [];
                                                this.showProductResult = true;
                                            },
                                            error: (err) => {
                                                console.log('에러:', err.status);
                                            }
                                        });
                                    }, 300);
                                },
                                fnSelectProduct(p) {
                                    this.selectedProduct = {
                                        productId: p.productId || p.PRODUCT_ID,
                                        productName: p.productName || p.PRODUCT_NAME,
                                        price: p.price || p.PRICE || 0,
                                        imgUrl: p.imgUrl || p.IMG_URL || p.mainImg || '/img/product/default.jpg'
                                    };
                                    this.productKeyword = this.selectedProduct.productName;
                                    this.showProductResult = false;
                                },

                                // ── 선택 ── 대소문자 모두 대응

                                fnAddTag() {
                                    let tag = this.tagInput.replace(/^#/, '').trim();
                                    if (!tag) return;
                                    if (this.tags.length >= 5) { this.showToast('태그는 최대 5개입니다.'); return; }
                                    if (this.tags.includes(tag)) { this.showToast('중복된 태그입니다.'); return; }
                                    this.tags.push(tag);
                                    this.tagInput = '';
                                },
                                fnCancel() {
                                    const editorText = this.quill ? this.quill.getText().trim() : '';
                                    const editorHtml = this.quill ? this.quill.root.innerHTML : '';
                                    const hasImage = editorHtml.includes('<img');

                                    const hasInput =
                                        this.form.title.trim() ||
                                        editorText ||
                                        hasImage ||
                                        this.selectedProduct ||
                                        this.showPoll ||
                                        this.tags.length > 0;

                                    if (hasInput) {
                                        if (!confirm('작성 중인 내용이 사라집니다. 취소하시겠습니까?')) {
                                            return;
                                        }
                                    }

                                    location.href = '/board/list.do';
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

                                    const contentHtml = this.quill.root.innerHTML;
                                    const contentText = this.quill.getText().trim();
                                    const hasImage = contentHtml.includes('<img');

                                    if (!contentText && !hasImage) {
                                        this.showToast('내용을 입력해주세요.');
                                        return;
                                    }

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
                                            this.showToast('투표 마감 날짜를 선택해주세요.');
                                            return;
                                        }
                                    }

                                    this.isSubmitting = true;

                                    const fd = new FormData();

                                    fd.append('title', this.form.title);
                                    fd.append('content', contentHtml);
                                    fd.append('category', this.form.category);

                                    if (this.selectedProduct) {
                                        fd.append('productId', this.selectedProduct.productId);
                                    }

                                    this.tags.forEach(t => fd.append('tags', t));

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
                                },
                                fnTogglePoll() {
                                    if (!this.showPoll) {
                                        this.pollClosing = false;
                                        this.showPoll = true;
                                        return;
                                    }

                                    this.showPoll = false;
                                    this.pollClosing = true;

                                    setTimeout(() => {
                                        this.pollClosing = false;
                                    }, 320);
                                },

                                fnHandleScroll() {
                                    this.showTopBtn = window.scrollY > 320;
                                },

                                fnScrollTop() {
                                    window.scrollTo({
                                        top: 0,
                                        behavior: 'smooth'
                                    });
                                },
                                fnUploadEditorImage(file) {
                                    if (!file) {
                                        return;
                                    }

                                    const fd = new FormData();
                                    fd.append('file', file);

                                    $.ajax({
                                        url: '/board/editor/image-upload.dox',
                                        type: 'POST',
                                        data: fd,
                                        processData: false,
                                        contentType: false,
                                        dataType: 'json',

                                        success: (res) => {
                                            console.log('이미지 업로드 응답:', res);

                                            if (!res || res.result !== 'success') {
                                                this.showToast((res && res.message) || '이미지 업로드에 실패했습니다.');
                                                return;
                                            }

                                            let imgUrl = res.imgUrl;

                                            if (!imgUrl) {
                                                this.showToast('이미지 경로를 받지 못했습니다.');
                                                return;
                                            }

                                            // Quill에는 절대경로로 넣는 게 가장 안정적
                                            if (imgUrl.startsWith('/')) {
                                                imgUrl = window.location.origin + imgUrl;
                                            }

                                            const index = Math.max(this.quill.getLength() - 1, 0);

                                            this.quill.insertEmbed(index, 'image', imgUrl, 'user');
                                            this.quill.insertText(index + 1, '\n', 'user');

                                            console.log('삽입 URL:', imgUrl);
                                            console.log('삽입 후 HTML:', this.quill.root.innerHTML);
                                        },

                                        error: (xhr) => {
                                            console.log('이미지 업로드 실패 상태:', xhr.status);
                                            console.log('이미지 업로드 실패 응답:', xhr.responseText);
                                            this.showToast('이미지 업로드 중 오류가 발생했습니다.');
                                        }
                                    });
                                }, fnOpenImagePicker() {
                                    const input = document.getElementById('editorImageInput');

                                    input.value = '';

                                    input.onchange = () => {
                                        const file = input.files && input.files[0];

                                        if (!file) {
                                            return;
                                        }

                                        this.fnUploadEditorImage(file);
                                    };

                                    input.click();
                                },
                            },
                            mounted() {
                                this.quill = new Quill('#editor', {
                                    theme: 'snow',
                                    placeholder: '캠핑 이야기를 자유롭게 작성해보세요. 사진도 본문 중간에 넣을 수 있어요.',
                                    modules: {
                                        toolbar: {
                                            container: '#editorToolbar',
                                            handlers: {
                                                image: () => {
                                                    this.fnOpenImagePicker();
                                                }
                                            }
                                        }
                                    }
                                });

                                this.fnOutsideProductClick = (e) => {
                                    const isProductSearch = e.target.closest('.product-search-wrap');
                                    const isQuillArea = e.target.closest('.quill-wrap');
                                    const isQuillTooltip = e.target.closest('.ql-tooltip');

                                    if (isProductSearch || isQuillArea || isQuillTooltip) {
                                        return;
                                    }

                                    this.showProductResult = false;
                                };

                                document.addEventListener('click', this.fnOutsideProductClick);
                                window.addEventListener('scroll', this.fnHandleScroll);

                                this.fnHandleScroll();
                            },

                            unmounted() {
                                document.removeEventListener('click', this.fnOutsideProductClick);
                                window.removeEventListener('scroll', this.fnHandleScroll);
                            }

                        }).mount('#app');
                    </script>
        </body>

        </html>