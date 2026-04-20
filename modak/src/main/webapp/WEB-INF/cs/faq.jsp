<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자주 묻는 질문 - 모닥모닥</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --cream: #f7f3ee; --orange: #d4714a; --text-dark: #3a3530;
            --text-mid: #7a7068; --text-light: #b0a89e; --border: #e8e0d8;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Noto Sans KR', sans-serif; background: #fff; color: var(--text-dark); line-height: 1.7; }
        
        .faq-wrap { max-width: 1000px; margin: 60px auto; padding: 0 20px; }
        .eyebrow { font-size: 12px; color: var(--text-light); letter-spacing: 1.5px; margin-bottom: 5px; }
        .faq-title { font-size: 28px; font-weight: 700; margin-bottom: 40px; }

        .faq-layout { display: flex; gap: 50px; }
        
        /* 사이드바 */
        .faq-sidebar { width: 150px; flex-shrink: 0; }
        .faq-sidebar ul { list-style: none; }
        .faq-sidebar li { 
            font-size: 15px; color: var(--text-light); padding: 10px 0; 
            cursor: pointer; transition: 0.2s; 
        }
        .faq-sidebar li.active { color: var(--text-dark); font-weight: 700; }

        /* 메인 영역 */
        .faq-main { flex: 1; }
        .faq-tabs { display: flex; border-bottom: 1px solid var(--border); margin-bottom: 20px; }
        .faq-tab { 
            padding: 10px 25px; cursor: pointer; color: var(--text-light); 
            position: relative; transition: 0.2s;
        }
        .faq-tab.active { color: var(--orange); font-weight: 700; }
        .faq-tab.active::after {
            content: ''; position: absolute; bottom: -1px; left: 0; 
            width: 100%; height: 2px; background: var(--orange);
        }

        /* 아코디언 리스트 */
        .faq-item { border-bottom: 1px solid var(--border); }
        .faq-question { 
            padding: 20px 5px; cursor: pointer; display: flex; 
            justify-content: space-between; align-items: center; 
        }
        .q-text { font-size: 15px; transition: 0.2s; }
        .faq-item.active .q-text { color: var(--orange); font-weight: 500; }
        
        /* 주황색 화살표 */
        .q-arrow { 
            width: 8px; height: 8px; border-top: 2px solid var(--text-light); 
            border-right: 2px solid var(--text-light); transform: rotate(135deg); 
            transition: 0.3s; margin-right: 10px;
        }
        .faq-item.active .q-arrow { transform: rotate(-45deg); border-color: var(--orange); }

        /* 답변 영역 (DB anwser 출력) */
        .faq-answer { 
            max-height: 0; overflow: hidden; background: var(--cream);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); 
            border-radius: 8px; margin-bottom: 0;
        }
        .faq-item.active .faq-answer { max-height: 1000px; margin-bottom: 20px; padding: 25px; }
        .answer-inner { font-size: 14px; color: var(--text-mid); line-height: 1.8; }
        .answer-inner a { color: var(--orange); text-decoration: underline; }
    </style>
</head>
<body>

<div id="app" class="faq-wrap">
    <div class="eyebrow">FAQ</div>
    <h1 class="faq-title">자주 묻는 질문</h1>

    <div class="faq-layout">
        <aside class="faq-sidebar">
            <ul>
                <li v-for="menu in sideMenus" 
                    :class="{active: selectSide === menu}" 
                    @click="fnChangeSide(menu)">{{ menu }}</li>
            </ul>
        </aside>

        <main class="faq-main">
            <div class="faq-tabs">
                <div v-for="tab in topTabs" 
                     class="faq-tab" 
                     :class="{active: selectTab === tab}" 
                     @click="fnChangeTab(tab)">{{ tab }}</div>
            </div>

            <div class="faq-list">
                <div v-for="(item, index) in faqList" 
                     :key="item.faqId" 
                     class="faq-item" 
                     :class="{active: activeIndex === index}">
                    
                    <div class="faq-question" @click="fnToggle(index)">
                        <span class="q-text">{{ item.question }}</span>
                        <span class="q-arrow"></span>
                    </div>
                    
                    <div class="faq-answer">
                        <div class="answer-inner" v-html="item.anwser"></div>
                    </div>
                </div>

                <div v-if="faqList.length == 0" style="padding: 100px; text-align: center; color: #ccc;">
                    등록된 질문이 없습니다.
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    var app = new Vue({
        el: '#app',
        data: {
            sideMenus: ['전체', '서비스 안내', '요금 / 결제', '회원 / 계정', '기타 문의'],
            topTabs: ['전체', '서비스', '요금', '계정'],
            selectSide: '전체',
            selectTab: '전체',
            faqList: [],
            activeIndex: null
        },
        methods: {
            fnGetList: function() {
                var self = this;
                // 이미지의 Controller 주소인 /faq.dox 사용
                $.ajax({
                    url: "/faq.dox",
                    type: "POST",
                    dataType: "json",
                    // Mapper에서 사용하는 category 파라미터 전송
                    data: { category: self.selectTab === '전체' ? '' : self.selectTab },
                    success: function(data) {
                        // FaqService에서 반환한 resultMap의 "list" 매핑
                        self.faqList = data.list;
                        self.activeIndex = null;
                    }
                });
            },
            fnToggle: function(index) {
                this.activeIndex = (this.activeIndex === index) ? null : index;
            },
            fnChangeSide: function(menu) {
                this.selectSide = menu;
                this.fnGetList();
            },
            fnChangeTab: function(tab) {
                this.selectTab = tab;
                this.fnGetList();
            }
        },
        mounted: function() {
            this.fnGetList();
        }
    });
</script>

</body>
</html>