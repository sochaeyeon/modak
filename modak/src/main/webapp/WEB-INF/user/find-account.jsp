<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>아이디 · 비밀번호 찾기 - 모닥모닥</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/user/find-account.css">
    </head>

    <body>
        <!-- HEADER -->
        <%@ include file="/WEB-INF/common/header.jsp" %>
            <div id="app" v-cloak>


                <!-- MAIN -->
                <main>
                    <div class="find-card">

                        <!-- LEFT PANEL -->
                        <div class="left-panel">
                            <div>
                                <div class="panel-label">Account Recovery</div>
                                <div class="panel-title">잊어버린<br>정보를<br><em>찾아드려요</em></div>
                                <div class="panel-desc">
                                    모닥모닥과 함께했던<br>
                                    따뜻한 시간들을<br>
                                    다시 이어가세요.
                                </div>
                            </div>

                            <div class="campfire-wrap">
                                <div class="flames">
                                    <div class="flame flame-outer"></div>
                                    <div class="flame flame-mid"></div>
                                    <div class="flame flame-inner"></div>
                                    <div class="flame flame-core"></div>
                                </div>
                                <div class="logs">
                                    <div class="log log-3"></div>
                                    <div class="log log-1"></div>
                                    <div class="log log-2"></div>
                                    <div class="ember-glow"></div>
                                </div>
                                <div class="stones">
                                    <div class="stone stone-1"></div>
                                    <div class="stone stone-2"></div>
                                    <div class="stone stone-3"></div>
                                    <div class="stone stone-4"></div>
                                    <div class="stone stone-5"></div>
                                </div>
                                <div class="ground-shadow"></div>
                            </div>
                        </div>

                        <!-- RIGHT PANEL -->
                        <div class="right-panel">

                            <!-- TAB -->
                            <div class="tab-row">
                                <button class="tab-btn active" onclick="switchTab('id', this)">아이디 찾기</button>
                                <button class="tab-btn" onclick="switchTab('pw', this)">비밀번호 찾기</button>

                                <div class="tab-underline"></div>
                            </div>

                            <!-- ═══ 아이디 찾기 패널 ═══ -->
                            <div class="panel-content active" id="panel-id">
                                <div class="section-title" v-if="!isIdFound">아이디 찾기</div>
                                <div class="section-desc" v-if="!isIdFound">가입 시 입력한 정보로 아이디를 확인할 수 있어요.</div>

                                <div class="method-tabs" v-if="!isIdFound">
                                    <button class="method-btn active" onclick="switchIdMethod('email', this)">이름 +
                                        이메일</button>
                                    <button class="method-btn" onclick="switchIdMethod('phone', this)">이름 +
                                        전화번호</button>

                                    <!-- 🔥 추가 -->
                                    <div class="method-underline"></div>
                                </div>

                                <!-- 이름 + 이메일 -->
                                <div id="id-email-form" v-if="!isIdFound">
                                    <div class="form-group">
                                        <label class="form-label">이름</label>
                                        <input v-model="userName" @input="fnClearNameError" type="text"
                                            class="form-input" :class="{ 'input-error': nameErrMsg }"
                                            placeholder="실명을 입력해 주세요" id="id-name-email" />
                                        <div v-if="nameErrMsg" class="error-msg">{{ nameErrMsg }}</div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">이메일</label>
                                        <input v-model="email" @input="fnValidateEmail" type="email" class="form-input"
                                            :class="{ 'input-error': emailErrMsg }" placeholder="가입한 이메일 주소"
                                            id="id-email" />
                                        <div v-if="emailErrMsg" class="error-msg">{{ emailErrMsg }}</div>
                                        <div v-if="emailOkMsg" class="ok-msg">{{ emailOkMsg }}</div>
                                    </div>
                                    <div v-if="findIdErrMsg" class="form-result-error">
                                        {{ findIdErrMsg }}
                                    </div>
                                    <button class="btn-submit" @click="fnGetUserId">아이디 찾기</button>
                                </div>

                                <!-- 결과 박스 -->
                                <div class="result-box show" v-else>
                                    <div class="result-label">회원님의 아이디</div>
                                    <div class="result-value">{{ userId }}</div>
                                    <div class="result-date">입력하신 정보와 일치하는 아이디를 찾았어요.</div>

                                    <button class="btn-submit" @click="fnGoLogin" style="margin-top:20px;">
                                        로그인하러 가기
                                    </button>
                                </div>

                                <!-- 이름 + 전화번호 -->
                                <div id="id-phone-form" class="hidden" v-if="!isIdFound">
                                    <div class="form-group">
                                        <label class="form-label">이름</label>
                                        <input v-model="userName" @input="fnClearNameError" type="text"
                                            class="form-input" :class="{ 'input-error': nameErrMsg }"
                                            placeholder="실명을 입력해 주세요" id="id-name-phone" />
                                        <div v-if="nameErrMsg" class="error-msg">{{ nameErrMsg }}</div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">휴대폰 번호</label>
                                        <div class="input-row">
                                            <input v-model="userPhone" @input="fnOnlyNumber" type="text"
                                                class="form-input" :class="{ 'input-error': phoneErrMsg }"
                                                placeholder="01012345678" maxlength="11" id="id-phone" />
                                            <button class="btn-verify" type="button" @click="fnSendSmsCode"
                                                :disabled="smsVerified">
                                                인증번호 전송
                                            </button>
                                        </div>
                                        <div v-if="phoneErrMsg" class="error-msg">{{ phoneErrMsg }}</div>
                                        <div v-if="phoneOkMsg" class="ok-msg">{{ phoneOkMsg }}</div>

                                        <div v-if="smsSendMsg" class="ok-msg">{{ smsSendMsg }}</div>
                                    </div>

                                    <div class="form-group" v-if="smsSent">
                                        <label class="form-label">
                                            인증번호
                                            <span class="timer-badge" id="sms-timer"></span>
                                        </label>
                                        <div class="input-row">
                                            <input v-model="authCode" type="text" class="form-input"
                                                placeholder="6자리 숫자 입력" maxlength="6" />
                                            <button class="btn-verify" type="button" @click="fnVerifySmsCode"
                                                :disabled="smsVerified">
                                                인증 확인
                                            </button>
                                        </div>
                                        <div v-if="verifySuccessMsg" class="ok-msg">{{ verifySuccessMsg }}</div>
                                    </div>

                                    <div v-if="findIdErrMsg" class="form-result-error">
                                        {{ findIdErrMsg }}
                                    </div>

                                    <button class="btn-submit" @click="fnFindIdByPhone">아이디 찾기</button>
                                </div>

                                <div class="notice-box" style="margin-top:20px;" v-if="!isIdFound">
                                    <strong>참고.</strong> 소셜 계정(카카오, 네이버)으로 가입하셨다면
                                    해당 서비스를 통해 로그인해 주세요.
                                </div>

                                <div class="notice-box" style="margin-top:20px;" v-else>
                                    <strong>안내.</strong> 확인된 아이디로 로그인해 주세요.
                                </div>
                            </div>

                            <!-- ═══ 비밀번호 찾기 패널 ═══ -->
                            <div class="panel-content" id="panel-pw">

                                <!-- step indicator -->
                                <div class="step-indicator">
                                    <div class="step">
                                        <div class="step-circle active" id="step1-circle">1</div>
                                        <div class="step-text active" id="step1-text">본인 확인</div>
                                    </div>
                                    <div class="step-line" id="step-line-1"></div>
                                    <div class="step">
                                        <div class="step-circle" id="step2-circle">2</div>
                                        <div class="step-text" id="step2-text">인증</div>
                                    </div>
                                    <div class="step-line" id="step-line-2"></div>
                                    <div class="step">
                                        <div class="step-circle" id="step3-circle">3</div>
                                        <div class="step-text" id="step3-text">재설정</div>
                                    </div>
                                </div>

                                <!-- STEP 1: 본인 확인 -->
                                <div id="pw-step1">
                                    <div class="section-title">본인 확인</div>
                                    <div class="section-desc">아이디와 가입한 이메일로 인증을 진행해요.</div>
                                    <div class="form-group">
                                        <label class="form-label">아이디</label>
                                        <input v-model="pwId" @input="fnResetPwVerifyState" type="text"
                                            class="form-input" placeholder="사용 중인 아이디" :disabled="pwVerified" />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">이메일</label>
                                        <div class="input-row">
                                            <input v-model="pwEmail" @input="fnResetPwVerifyState" type="email"
                                                class="form-input" placeholder="가입한 이메일 주소" :disabled="pwVerified" />
                                            <button class="btn-verify" type="button" @click="fnSendPwVerifyEmail"
                                                :disabled="pwVerified">
                                                인증 메일 발송
                                            </button>
                                        </div>
                                    </div>

                                    <div class="form-group" v-if="pwMailSent">
                                        <label class="form-label">
                                            이메일 인증코드
                                            <span class="timer-badge" id="pw-timer"></span>
                                        </label>
                                        <div class="input-row">
                                            <input v-model="pwAuthCode" type="text" class="form-input"
                                                placeholder="이메일로 받은 6자리 코드" maxlength="6" :disabled="pwVerified" />
                                            <button class="btn-verify" type="button" @click="fnVerifyPwEmailCode"
                                                :disabled="pwVerified">
                                                인증 확인
                                            </button>
                                        </div>
                                        <div v-if="pwVerifyMsg" class="ok-msg">{{ pwVerifyMsg }}</div>
                                    </div>
                                    <div v-if="pwErrMsg" class="form-result-error">
                                        {{ pwErrMsg }}
                                    </div>
                                    <button class="btn-submit" @click="fnNextPwStep">다음 단계로</button>
                                </div>

                                <!-- STEP 2: 인증 완료 -->
                                <div id="pw-step2" class="hidden">
                                    <div class="section-title">인증 완료</div>
                                    <div class="section-desc">본인 확인이 완료되었어요. 새 비밀번호를 설정해 주세요.</div>
                                    <div
                                        style="background:linear-gradient(135deg,#fff8f3,#fff0e6);border:1.5px solid #ffd4b8;border-radius:12px;padding:18px 20px;margin-bottom:20px;display:flex;align-items:center;gap:14px;">
                                        <svg width="36" height="36" viewBox="0 0 36 36" fill="none">
                                            <circle cx="18" cy="18" r="17" fill="#e8622a" opacity="0.12"
                                                stroke="#e8622a" stroke-width="1.5" />
                                            <path d="M11 19l5 5 9-10" stroke="#e8622a" stroke-width="2.2"
                                                stroke-linecap="round" stroke-linejoin="round" />
                                        </svg>
                                        <div>
                                            <div style="font-size:13px;font-weight:700;color:var(--brown);">인증이 완료되었어요
                                            </div>
                                            <div style="font-size:11.5px;color:var(--text-sub);margin-top:2px;">
                                                {{ pwUserName }} 님, 새 비밀번호를 설정해 주세요.
                                            </div>
                                        </div>
                                    </div>
                                    <button class="btn-submit" onclick="goPwStep(3)">비밀번호 재설정하기</button>
                                </div>

                                <!-- STEP 3: 재설정 -->
                                <div id="pw-step3" class="hidden">
                                    <!-- 🔹 비밀번호 입력 영역 -->
                                    <div v-if="!pwResetDone">
                                        <div class="form-group">
                                            <label class="form-label">새 비밀번호</label>
                                            <input id="pw-new" type="password" class="form-input"
                                                placeholder="8자 이상, 영문+숫자+특수문자" oninput="checkPwStrength(this.value)" />

                                            <div id="pw-strength-wrap" style="margin-top:8px;display:none;">
                                                <div
                                                    style="height:4px;border-radius:2px;background:var(--border);overflow:hidden;">
                                                    <div id="pw-strength-bar"
                                                        style="height:100%;width:0%;border-radius:2px;transition:width 0.3s, background 0.3s;">
                                                    </div>
                                                </div>
                                                <div id="pw-strength-label"
                                                    style="font-size:11px;margin-top:4px;color:var(--text-sub);"></div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">비밀번호 확인</label>
                                            <input id="pw-confirm" type="password" class="form-input"
                                                placeholder="비밀번호를 다시 입력해 주세요" oninput="checkPwMatch()" />
                                            <div id="pw-match-msg" style="font-size:11px;margin-top:4px;"></div>
                                        </div>

                                        <div v-if="pwErrMsg" class="error-msg">{{ pwErrMsg }}</div>

                                        <button class="btn-submit" type="button" @click="fnResetPassword">
                                            비밀번호 변경 완료
                                        </button>
                                    </div>

                                    <!-- 🔹 완료 메시지 -->
                                    <div class="success-box" v-if="pwResetDone">

                                        <div class="success-icon">✓</div>

                                        <div class="success-title">비밀번호 변경 완료</div>

                                        <div class="success-desc">
                                            비밀번호가 안전하게 변경되었어요.<br>
                                            다시 로그인해 주세요.
                                        </div>

                                        <button class="btn-submit" onclick="location.href='/user/login.do'">
                                            로그인 하러가기
                                        </button>
                                    </div>

                                </div>

                            </div>

                            <!-- bottom links -->
                            <div class="bottom-links">
                                <a href="http://localhost:8080/user/login.do">로그인</a>
                                <a href="http://localhost:8080/user/sign-up.do">회원가입</a>
                                <a href="http://localhost:8080/cs-center.do">고객센터</a>
                            </div>

                        </div><!-- /right-panel -->
                    </div><!-- /find-card -->
                </main>
            </div>
            <%@ include file="/WEB-INF/common/footer.jsp" %>
    </body>

    </html>

    <script>
        // ── TAB SWITCH ──
        function switchTab(tab, btn) {
            const idPanel = document.getElementById('panel-id');
            const pwPanel = document.getElementById('panel-pw');

            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            if (tab === 'id') {
                idPanel.classList.add('active');
                pwPanel.classList.remove('active');
            } else {
                pwPanel.classList.add('active');
                idPanel.classList.remove('active');
            }

            // 🔥 underline 이동
            const underline = document.querySelector('.tab-underline');
            underline.style.width = btn.offsetWidth + 'px';
            underline.style.left = btn.offsetLeft + 'px';
        }
        window.addEventListener('load', () => {
            const tabActive = document.querySelector('.tab-btn.active');
            const tabUnderline = document.querySelector('.tab-underline');

            if (tabActive && tabUnderline) {
                tabUnderline.style.width = tabActive.offsetWidth + 'px';
                tabUnderline.style.left = tabActive.offsetLeft + 'px';
            }

            const methodActive = document.querySelector('.method-btn.active');
            const methodUnderline = document.querySelector('.method-underline');

            if (methodActive && methodUnderline) {
                methodUnderline.style.width = methodActive.offsetWidth + 'px';
                methodUnderline.style.left = methodActive.offsetLeft + 'px';
            }
        });

        // ── ID METHOD SWITCH ──
        function switchIdMethod(method, btn) {
            document.querySelectorAll('.method-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            document.getElementById('id-email-form').classList.toggle('hidden', method !== 'email');
            document.getElementById('id-phone-form').classList.toggle('hidden', method !== 'phone');

            // 🔥 밑줄 이동
            const underline = document.querySelector('.method-underline');

            underline.style.width = btn.offsetWidth + 'px';
            underline.style.left = btn.offsetLeft + 'px';
        }

        // ── SMS SEND ──
        function sendSms(timerId) {
            const verifyGroup = document.getElementById('id-verify-group');
            if (verifyGroup) verifyGroup.style.display = 'block';
            startTimer(timerId, 180);
        }

        // ── TIMER ──
        function startTimer(id, seconds) {
            const el = document.getElementById(id);
            if (!el) return;
            el.classList.remove('hidden');
            let remaining = seconds;
            clearInterval(el._timer);
            el._timer = setInterval(() => {
                const m = String(Math.floor(remaining / 60)).padStart(2, '0');
                const s = String(remaining % 60).padStart(2, '0');
                el.textContent = m + ':' + s;
                if (--remaining < 0) {
                    clearInterval(el._timer);
                    el.textContent = '만료됨';
                    el.style.color = '#c44e1e';
                }
            }, 1000);
        }

        // ── FIND ID ──
        function findId() {
            const result = document.getElementById('id-result');
            result.classList.add('show');
        }



        // ── PW STEPS ──
        function goPwStep(step) {
            // hide all steps
            [1, 2, 3].forEach(i => {
                document.getElementById('pw-step' + i).classList.add('hidden');
            });
            document.getElementById('pw-step' + step).classList.remove('hidden');

            // update step indicator
            [1, 2, 3].forEach(i => {
                const circle = document.getElementById('step' + i + '-circle');
                const text = document.getElementById('step' + i + '-text');
                circle.classList.remove('active', 'done');
                text.classList.remove('active');
                if (i < step) { circle.classList.add('done'); }
                if (i === step) { circle.classList.add('active'); text.classList.add('active'); }
            });
            document.getElementById('step-line-1').classList.toggle('done', step > 1);
            document.getElementById('step-line-2').classList.toggle('done', step > 2);
        }

        // ── PW STRENGTH ──
        function checkPwStrength(val) {
            const wrap = document.getElementById('pw-strength-wrap');
            const bar = document.getElementById('pw-strength-bar');
            const lbl = document.getElementById('pw-strength-label');
            if (!val) { wrap.style.display = 'none'; return; }
            wrap.style.display = 'block';
            let score = 0;
            if (val.length >= 8) score++;
            if (/[A-Z]/.test(val)) score++;
            if (/[0-9]/.test(val)) score++;
            if (/[^A-Za-z0-9]/.test(val)) score++;
            const levels = [
                { pct: '20%', color: '#e55353', label: '매우 약함' },
                { pct: '40%', color: '#e8622a', label: '약함' },
                { pct: '65%', color: '#f0a500', label: '보통' },
                { pct: '85%', color: '#4caf50', label: '강함' },
                { pct: '100%', color: '#2e7d32', label: '매우 강함' },
            ];
            const lvl = levels[score] || levels[0];
            bar.style.width = lvl.pct;
            bar.style.background = lvl.color;
            lbl.textContent = lvl.label;
            lbl.style.color = lvl.color;
        }

        // ── PW MATCH ──
        function checkPwMatch() {
            const pw1 = document.getElementById('pw-new').value;
            const pw2 = document.getElementById('pw-confirm').value;
            const msg = document.getElementById('pw-match-msg');
            if (!pw2) { msg.textContent = ''; return; }
            if (pw1 === pw2) {
                msg.textContent = '비밀번호가 일치해요.';
                msg.style.color = '#4caf50';
            } else {
                msg.textContent = '비밀번호가 일치하지 않아요.';
                msg.style.color = '#e55353';
            }
        }

        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (키 : 값)
                    // list : [] 
                    userName: '',
                    userPhone: '',
                    email: '',
                    nameErrMsg: '',
                    emailErrMsg: '',
                    emailOkMsg: '',
                    phoneErrMsg: '',
                    phoneOkMsg: '',
                    userId: '',
                    isIdFound: false,
                    findIdErrMsg: '',
                    findMethod: 'email',
                    smsSent: false,
                    smsVerified: false,
                    authCode: '',
                    verifySuccessMsg: '',
                    smsSendMsg: '',
                    verifySuccessMsg: '',
                    pwId: '',
                    pwEmail: '',
                    pwVerified: false,
                    pwMailSent: false,
                    pwErrMsg: '',
                    pwVerifyMsg: '',
                    pwAuthCode: '',
                    pwUserName: '',
                    pwResetDone: false
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnGetUserId: function () {
                    let self = this;
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                    self.nameErrMsg = '';
                    self.emailErrMsg = '';
                    self.emailOkMsg = '';
                    self.findIdErrMsg = '';

                    let isValid = true;

                    if (self.userName.trim() === '') {
                        self.nameErrMsg = '이름을 입력해 주세요.';
                        isValid = false;
                    }

                    if (self.email.trim() === '') {
                        self.emailErrMsg = '이메일을 입력해 주세요.';
                        isValid = false;
                    } else if (!emailRegex.test(self.email.trim())) {
                        self.emailErrMsg = '올바른 이메일 형식이 아니에요.';
                        isValid = false;
                    } else {
                        self.emailOkMsg = '올바른 이메일 형식이에요.';
                    }

                    if (!isValid) {
                        return;
                    }


                    let param = {
                        // 백엔드로 전달할 데이터
                        userName: self.userName,
                        userPhone: self.userPhone,
                        email: self.email
                    };
                    $.ajax({
                        url: "http://localhost:8080/user/find-id.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // 받은 데이터를 변수에 저장하세요
                            if (data.result == 'success') {
                                self.userId = data.info.userId;
                                self.isIdFound = true;
                            } else {
                                self.findIdErrMsg = '입력하신 정보와 일치하는 아이디가 없어요.';
                            }
                        }
                    });
                },

                fnClearNameError: function () {
                    let self = this;
                    if (self.userName.trim() !== '') {
                        self.nameErrMsg = '';
                    }
                    self.findIdErrMsg = '';
                },

                fnValidateEmail: function () {
                    let self = this;
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    const email = self.email.trim();

                    self.emailErrMsg = '';
                    self.emailOkMsg = '';
                    self.findIdErrMsg = '';

                    if (email === '') {
                        return;
                    }

                    if (!emailRegex.test(email)) {
                        self.emailErrMsg = '올바른 이메일 형식이 아니에요.';
                    } else {
                        self.emailOkMsg = '올바른 이메일 형식이에요.';
                    }
                },
                fnValidatePhone: function () {
                    let self = this;
                    const phoneRegex = /^01[0-9]\d{7,8}$/;

                    self.phoneErrMsg = '';
                    self.phoneOkMsg = '';
                    self.findIdErrMsg = '';

                    const phone = self.userPhone.trim().replace(/-/g, '');

                    if (phone === '') {
                        return;
                    }

                    if (!phoneRegex.test(phone)) {
                        self.phoneErrMsg = '올바르지 않은 번호입니다.';
                    } else {
                        self.phoneOkMsg = '';
                    }
                },
                fnSendSmsCode: function () {
                    let self = this;
                    const phoneRegex = /^01[0-9]\d{7,8}$/;

                    self.nameErrMsg = '';
                    self.phoneErrMsg = '';
                    self.phoneOkMsg = '';
                    self.findIdErrMsg = '';

                    let phone = self.userPhone.trim().replace(/-/g, '');

                    if (self.userName.trim() === '') {
                        self.nameErrMsg = '이름을 입력해 주세요.';
                        return;
                    }

                    if (phone === '') {
                        self.phoneErrMsg = '휴대폰 번호를 입력해 주세요.';
                        return;
                    }

                    if (!phoneRegex.test(phone)) {
                        self.phoneErrMsg = '올바르지 않은 번호입니다.';
                        return;
                    }

                    $.ajax({
                        url: "/user/sms/send-code.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userName: self.userName,
                            userPhone: phone,
                            authPurpose: "FIND_ID"
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.smsSent = true;
                                self.smsVerified = false;

                                self.smsSendMsg = '인증번호 발송 완료!';
                                self.findIdErrMsg = '';

                                self.$nextTick(function () {
                                    startTimer('sms-timer', 180);
                                });

                            } else {
                                self.findIdErrMsg = data.message;
                                self.verifySuccessMsg = '';
                            }
                        },
                        error: function () {
                            self.findIdErrMsg = "문자 발송 중 오류가 발생했어요.";
                        }
                    });
                },

                fnVerifySmsCode: function () {
                    let self = this;

                    self.findIdErrMsg = '';
                    self.verifySuccessMsg = '';

                    if (!self.authCode || self.authCode.trim() === '') {
                        self.findIdErrMsg = '인증번호를 입력해 주세요.';
                        return;
                    }

                    $.ajax({
                        url: "/user/sms/verify-code.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userPhone: self.userPhone.trim().replace(/-/g, ''),
                            authCode: self.authCode.trim(),
                            authPurpose: "FIND_ID"
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.smsVerified = true;   // 🔥 여기서 잠금
                                self.verifySuccessMsg = '인증이 완료되었습니다.';
                                self.smsSendMsg = '';
                                self.findIdErrMsg = '';
                            } else {
                                // ❗ 실패해도 막지 않는다
                                self.smsVerified = false;
                                self.findIdErrMsg = data.message;
                            }
                        },
                        error: function () {
                            self.findIdErrMsg = "인증 확인 중 오류가 발생했어요.";
                        }
                    });
                },

                fnFindIdByPhone: function () {
                    let self = this;

                    self.findIdErrMsg = '';

                    if (!self.smsVerified) {
                        self.findIdErrMsg = '휴대폰 인증을 먼저 완료해 주세요.';
                        return;
                    }

                    $.ajax({
                        url: "/find-id-by-phone.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userName: self.userName,
                            userPhone: self.userPhone.trim().replace(/-/g, '')
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.userId = data.info.userId;
                                self.isIdFound = true;
                            } else {
                                self.findIdErrMsg = data.message;
                            }
                        },
                        error: function () {
                            self.findIdErrMsg = "아이디 조회 중 오류가 발생했어요.";
                        }
                    });
                },
                fnGoLogin: function () {
                    location.href = "/user/login.do";
                },
                fnOnlyNumber: function () {
                    let self = this;

                    self.userPhone = self.userPhone.replace(/[^0-9]/g, '').slice(0, 11);

                    // 🔥 번호 바뀌면 인증 초기화
                    self.smsVerified = false;
                    self.verifySuccessMsg = '';
                },

                fnNextPwStep: function () {
                    let self = this;
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                    self.pwErrMsg = '';

                    if (!self.pwId || self.pwId.trim() === '') {
                        self.pwErrMsg = '아이디를 입력해 주세요.';
                        return;
                    }

                    if (!self.pwEmail || self.pwEmail.trim() === '') {
                        self.pwErrMsg = '이메일을 입력해 주세요.';
                        return;
                    }

                    if (!emailRegex.test(self.pwEmail.trim())) {
                        self.pwErrMsg = '올바른 이메일 형식이 아니에요.';
                        return;
                    }

                    if (!self.pwVerified) {
                        self.pwErrMsg = '이메일 인증을 완료해 주세요.';
                        return;
                    }

                    goPwStep(2);
                },
                fnSendPwVerifyEmail: function () {
                    let self = this;
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                    self.pwErrMsg = '';
                    self.pwVerifyMsg = '';

                    if (!self.pwId || self.pwId.trim() === '') {
                        self.pwErrMsg = '아이디를 입력해 주세요.';
                        return;
                    }

                    if (!self.pwEmail || self.pwEmail.trim() === '') {
                        self.pwErrMsg = '이메일을 입력해 주세요.';
                        return;
                    }

                    if (!emailRegex.test(self.pwEmail.trim())) {
                        self.pwErrMsg = '올바른 이메일 형식이 아니에요.';
                        return;
                    }

                    self.pwMailSent = true;
                    self.pwVerified = false;
                    self.pwVerifyMsg = '인증 메일을 발송 중이에요. 메일함을 확인해 주세요.';

                    self.$nextTick(function () {
                        startTimer('pw-timer', 300);
                    });

                    $.ajax({
                        url: "/user/send-pw-auth-email.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: self.pwId.trim(),
                            email: self.pwEmail.trim()
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.pwVerifyMsg = '인증 메일을 발송했어요. 메일함을 확인해 주세요.';
                                self.pwErrMsg = '';
                            } else {
                                self.pwMailSent = false;
                                self.pwVerifyMsg = '';
                                self.pwErrMsg = data.message;
                            }
                        },
                        error: function () {
                            self.pwMailSent = false;
                            self.pwVerifyMsg = '';
                            self.pwErrMsg = "인증메일 발송 중 오류가 발생했어요.";
                        }
                    });
                },
                fnVerifyPwEmailCode: function () {
                    let self = this;

                    self.pwErrMsg = '';
                    self.pwVerifyMsg = '';

                    if (!self.pwAuthCode || self.pwAuthCode.trim() === '') {
                        self.pwErrMsg = '인증번호를 입력해 주세요.';
                        return;
                    }

                    $.ajax({
                        url: "/user/verify-pw-auth-email.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: self.pwId,
                            email: self.pwEmail,
                            authCode: self.pwAuthCode
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.pwVerified = true;
                                self.pwVerifyMsg = data.message;
                                self.pwErrMsg = '';

                                self.pwUserName = data.userName;
                            } else {
                                self.pwVerified = false;
                                self.pwErrMsg = data.message;
                            }
                        },
                        error: function () {
                            self.pwErrMsg = "인증 확인 중 오류가 발생했어요.";
                        }
                    });
                },
                fnResetPassword: function () {
                    let self = this;

                    const pw1 = document.getElementById('pw-new').value;
                    const pw2 = document.getElementById('pw-confirm').value;

                    self.pwErrMsg = '';

                    if (!pw1 || !pw2) {
                        self.pwErrMsg = '새 비밀번호를 입력해 주세요.';
                        return;
                    }

                    if (pw1 !== pw2) {
                        self.pwErrMsg = '비밀번호가 일치하지 않아요.';
                        return;
                    }

                    $.ajax({
                        url: "/user/reset-password.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: self.pwId,
                            newPassword: pw1
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.pwErrMsg = '';
                                self.pwResetDone = true;
                            } else {
                                self.pwErrMsg = data.message;
                            }
                        },
                        error: function () {
                            self.pwErrMsg = "비밀번호 변경 중 오류가 발생했어요.";
                        }
                    });
                },
                fnResetPwVerifyState: function () {
                    let self = this;

                    self.pwVerified = false;
                    self.pwMailSent = false;
                    self.pwAuthCode = '';
                    self.pwVerifyMsg = '';
                    self.pwErrMsg = '';
                },


            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
            }
        });

        app.mount('#app');
    </script>