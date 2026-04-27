<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>회원가입 - 모닥모닥</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/user/sign-up.css">
    </head>

    <body>
        <div id="app">
            <!-- ── 왼쪽 패널 (로그인 동일) ── -->
            <div class="left-panel">
                <div class="brand">
                    <a href="/main.do" class="brand-name">모닥모닥</a>
                </div>

            <div class="hero-text">
                <p class="hero-eyebrow">CAMPING RENTAL & SHOP</p>
                <h1 class="hero-title">모닥모닥과 함께<br><em>캠핑을 시작해보세요</em></h1>
                <p class="hero-desc">
                    회원가입 후 캠핑용품 구매부터 대여까지 한 번에.<br>
                    필요한 장비를 더 가볍고 편리하게 준비하고,<br>
                    주문과 대여 내역도 손쉽게 관리해보세요.
                </p>
            </div>

            <div class="left-mini-badge">
                <span>캠핑용품 대여</span>
                <span>캠핑용품 구매</span>
                <span>빠른 배송</span>
            </div>

            <div class="left-stats">
                <div class="stat-card">
                    <strong>RENTAL</strong>
                    <p>필요한 기간만 부담 없이 대여</p>
                </div>
                <div class="stat-card">
                    <strong>SHOP</strong>
                    <p>원하는 장비는 바로 구매 가능</p>
                </div>
                <div class="stat-card">
                    <strong>DELIVERY</strong>
                    <p>집에서 받고 캠핑장으로 떠나요</p>
                </div>
            </div>

            <div class="left-quote">
                <span class="quote-mark">"</span>
                <p>장비 준비는 가볍게, 캠핑의 설렘은 더 크게.</p>
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

        <!-- ── 오른쪽 패널 ── -->
        <div class="right-panel">

            <!-- 가입 전 -->
            <div class="signup-box" v-if="!signupSuccessed">

                <div class="signup-heading">
                    <h2>함께 불을 피워볼까요</h2>
                    <p>회원가입 후 모닥모닥의 구매·대여 서비스를 이용해보세요.</p>
                </div>

                <!-- 아이디 -->
                <div class="field">
                    <label>아이디<span class="required">*</span></label>
                    <div class="input-wrap input-with-btn">
                        <input v-model="userId" type="text" id="userIdInput"
                            placeholder="아이디를 입력해주세요">
                        <button type="button" class="btn-check" @click="fnCheckUserId">중복체크</button>
                    </div>
                    <p class="field-hint" id="userIdHint"></p>
                </div>

                <!-- 이름 + 별명 -->
                <div class="field-row">
                    <div class="field">
                        <label>이름 <span class="required">*</span></label>
                        <div class="input-wrap">
                            <input v-model="userName" type="text" id="nameInput"
                                placeholder="홍길동" oninput="validateName()">
                            <span class="input-icon" id="nameIcon"></span>
                        </div>
                        <p class="field-hint" id="nameHint"></p>
                    </div>
                    <div class="field">
                        <label>별명 <span class="required">*</span></label>
                        <div class="input-wrap">
                            <input v-model="nickName" type="text" id="nickInput"
                                placeholder="불꽃이" oninput="validateNick()">
                            <span class="input-icon" id="nickIcon"></span>
                        </div>
                        <p class="field-hint" id="nickHint">커뮤니티에서 사용할 이름이에요.</p>
                    </div>
                </div>

                <!-- 이메일 -->
                <div class="field">
                    <label>이메일 <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input v-model="email" type="email" id="emailInput"
                            placeholder="hello@modakmodak.kr" oninput="validateEmail()">
                        <span class="input-icon">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                <rect x="1" y="3" width="14" height="10" rx="2" stroke="#b09070" stroke-width="1.4"/>
                                <path d="M1.5 4L8 9.5L14.5 4" stroke="#b09070" stroke-width="1.4" stroke-linecap="round"/>
                            </svg>
                        </span>
                    </div>
                    <p class="field-hint" id="emailHint"></p>
                </div>

                <!-- 비밀번호 -->
                <div class="field">
                    <label>비밀번호 <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input v-model="userPwd" type="password" id="pwInput"
                            placeholder="영문·숫자 포함 8자 이상" oninput="validatePw()">
                        <span class="input-icon" onclick="togglePw('pwInput')" id="eyeIcon1">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4"/>
                                <circle cx="8" cy="8" r="1.8" fill="#b09070"/>
                            </svg>
                        </span>
                    </div>
                    <div style="margin-top:6px; display:flex; gap:4px;">
                        <div id="str1" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                        <div id="str2" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                        <div id="str3" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                        <div id="str4" style="flex:1;height:3px;border-radius:2px;background:rgba(180,140,100,.2);transition:background .3s;"></div>
                    </div>
                    <p class="field-hint" id="pwHint"></p>
                </div>

                <!-- 비밀번호 확인 -->
                <div class="field">
                    <label>비밀번호 확인 <span class="required">*</span></label>
                    <div class="input-wrap">
                        <input type="password" id="pwConfirm"
                            placeholder="비밀번호를 한 번 더 입력하세요" oninput="validateConfirm()">
                        <span class="input-icon" onclick="togglePw('pwConfirm')" id="eyeIcon2">
                            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                                <ellipse cx="8" cy="8" rx="6" ry="4" stroke="#b09070" stroke-width="1.4"/>
                                <circle cx="8" cy="8" r="1.8" fill="#b09070"/>
                            </svg>
                        </span>
                    </div>
                    <p class="field-hint" id="confirmHint"></p>
                </div>

                <!-- 약관 -->
                <div class="terms-section">
                    <label class="terms-all">
                        <input type="checkbox" class="cb all-cb" id="agreeAll"
                            :checked="agreeAll" @change="toggleAll">
                        <span>전체 동의하기</span>
                    </label>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" class="cb term-cb required-term"
                                v-model="term1" @change="updateAll">
                            <span><em>[필수]</em>이용약관 동의</span>
                        </label>
                        <a href="http://localhost:8080/terms.do" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" class="cb term-cb required-term"
                                v-model="term2" @change="updateAll">
                            <span><em>[필수]</em>개인정보처리방침 동의</span>
                        </label>
                        <a href="http://localhost:8080/privacyPolicy.do" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <label class="terms-check">
                            <input type="checkbox" class="cb term-cb"
                                v-model="marketingYn" @change="updateAll">
                            <span><em>[선택]</em>마케팅 정보 수신 동의</span>
                        </label>
                        <a href="http://localhost:8080/marketingConsent.do" class="terms-link">보기</a>
                    </div>
                </div>

                <button type="button" class="btn-signup" @click="fnSignUp">모닥 시작하기 🔥</button>

                <p class="login-row">
                    이미 모닥이 있으신가요?
                    <a @click="fnGoLogin">로그인하기 →</a>
                </p>
            </div>

            <!-- 가입 성공 후 -->
            <div class="signup-success-box" v-else>
                <div class="success-fire">🔥</div>
                <h2>회원가입이 완료되었어요</h2>
                <p>이제 모닥모닥에서 따뜻한 이야기를 시작해보세요.</p>
                <button type="button" class="btn-signup" @click="fnGoLogin">
                    로그인 페이지로 이동
                </button>
            </div>
        </div>
    </div>
</body>

</html>

<script>
    function togglePw(id) {
        const inp = document.getElementById(id);
        inp.type = inp.type === 'password' ? 'text' : 'password';
    }

    const okSvg = `<svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="7.5" cy="7.5" r="6.5" fill="#5a9a6a" opacity=".15"/><path d="M4.5 7.5L6.5 9.5L10.5 5.5" stroke="#5a9a6a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
    const errSvg = `<svg width="15" height="15" viewBox="0 0 15 15" fill="none"><circle cx="7.5" cy="7.5" r="6.5" fill="#c94f1e" opacity=".12"/><path d="M5 5L10 10M10 5L5 10" stroke="#c94f1e" stroke-width="1.5" stroke-linecap="round"/></svg>`;

    function setField(inputId, iconId, hintId, valid, msg) {
        const inp = document.getElementById(inputId);
        const hint = document.getElementById(hintId);

        if (inp.value === '') {
            inp.classList.remove('valid', 'invalid');
            if (iconId) document.getElementById(iconId).innerHTML = '';
            hint.className = 'field-hint';
            hint.textContent = msg || '';
            return;
        }

        inp.classList.toggle('valid', valid);
        inp.classList.toggle('invalid', !valid);

        if (iconId) {
            document.getElementById(iconId).innerHTML = valid ? okSvg : errSvg;
        }

        hint.className = 'field-hint ' + (valid ? 'ok' : 'error');
        hint.textContent = msg;
    }

    function validateName() {
        const v = document.getElementById('nameInput').value;
        setField('nameInput', 'nameIcon', 'nameHint',
            v.length >= 2,
            v.length >= 2 ? '좋아요!' : '이름은 2자 이상 입력해주세요.');
    }

    function validateNick() {
        const v = document.getElementById('nickInput').value.trim();
        const ok = /^[가-힣a-zA-Z0-9_]{2,12}$/.test(v);

        setField('nickInput', 'nickIcon', 'nickHint',
            ok,
            ok ? '사용 가능한 별명이에요!' : '한글·영문·숫자·_ 2~12자로 입력해주세요.');
    }

    function validateEmail() {
        const v = document.getElementById('emailInput').value;
        const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);

        setField('emailInput', null, 'emailHint',
            ok,
            ok ? '올바른 이메일 형식이에요.' : '이메일 형식을 확인해주세요.');
    }

    function validatePw() {
        const v = document.getElementById('pwInput').value;
        const bars = ['str1', 'str2', 'str3', 'str4'].map(id => document.getElementById(id));
        const colors = ['#e0621a', '#e0621a', '#f0a030', '#5a9a6a'];

        let score = 0;
        if (v.length >= 8) score++;
        if (/[A-Za-z]/.test(v) && /[0-9]/.test(v)) score++;
        if (/[^A-Za-z0-9]/.test(v)) score++;
        if (v.length >= 12) score++;

        bars.forEach((b, i) => {
            b.style.background = i < score ? colors[Math.min(score - 1, 3)] : 'rgba(180,140,100,.2)';
        });

        const labels = ['', '취약한 비밀번호', '보통 비밀번호', '강한 비밀번호', '매우 강한 비밀번호'];

        setField('pwInput', null, 'pwHint',
            score >= 2,
            score > 0 ? labels[score] : '영문·숫자를 포함해 8자 이상 입력해주세요.');

        if (document.getElementById('pwConfirm').value) validateConfirm();
    }

    function validateConfirm() {
        const pw = document.getElementById('pwInput').value;
        const conf = document.getElementById('pwConfirm').value;

        setField('pwConfirm', null, 'confirmHint',
            pw === conf && conf !== '',
            pw === conf ? '비밀번호가 일치해요.' : '비밀번호가 일치하지 않아요.');
    }

    function showToast(msg) {
        let toast = document.getElementById("toast");

        if (!toast) {
            toast = document.createElement("div");
            toast.id = "toast";
            toast.style.cssText =
                "position:fixed;bottom:30px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:10px 20px;border-radius:8px;font-size:13px;z-index:9999;display:none;";
            document.body.appendChild(toast);
        }

        toast.textContent = msg;
        toast.style.display = "block";

        setTimeout(() => {
            toast.style.display = "none";
        }, 2000);
    }

    const app = Vue.createApp({
        data() {
            return {
                userId: '',
                userName: '',
                nickName: '',
                email: '',
                userPwd: '',
                checked: false,
                signupSuccessed: false,
                marketingYn: false,
                agreeAll: false,
                term1: false,
                term2: false
            };
        },

        methods: {
            toggleAll() {
                const all = !this.agreeAll;
                this.agreeAll = all;
                this.term1 = all;
                this.term2 = all;
                this.marketingYn = all;
            },

            updateAll() {
                this.agreeAll = this.term1 && this.term2 && this.marketingYn;
            },

            fnSignUp() {
                const self = this;

                const requiredList = [
                    { id: "userIdInput", msg: "아이디를 입력해주세요." },
                    { id: "nameInput", msg: "이름을 입력해주세요." },
                    { id: "nickInput", msg: "별명을 입력해주세요." },
                    { id: "emailInput", msg: "이메일을 입력해주세요." },
                    { id: "pwInput", msg: "비밀번호를 입력해주세요." },
                    { id: "pwConfirm", msg: "비밀번호 확인을 입력해주세요." }
                ];

                for (let item of requiredList) {
                    const el = document.getElementById(item.id);
                    const value = el.value.trim();

                    if (value.length === 0) {
                        const field = el.closest(".field");
                        const hint = field.querySelector(".field-hint");

                        el.classList.remove("valid");
                        el.classList.add("invalid");

                        hint.className = "field-hint error";
                        hint.textContent = item.msg;

                        el.focus();
                        showToast(item.msg);
                        return;
                    }
                }

                const idRegex = /^[a-zA-Z0-9_]{4,20}$/;
                if (!idRegex.test(self.userId.trim())) {
                    const el = document.getElementById("userIdInput");
                    const hint = document.getElementById("userIdHint");

                    el.classList.add("invalid");
                    hint.className = "field-hint error";
                    hint.textContent = "아이디는 영문·숫자·_ 4~20자로 입력해주세요.";

                    el.focus();
                    showToast("아이디 형식을 확인해주세요.");
                    return;
                }

                if (!self.checked) {
                    const el = document.getElementById("userIdInput");
                    const hint = document.getElementById("userIdHint");

                    el.classList.add("invalid");
                    hint.className = "field-hint error";
                    hint.textContent = "아이디 중복 확인을 해주세요.";

                    el.focus();
                    showToast("아이디 중복 확인이 필요합니다.");
                    return;
                }

                if (!/^[가-힣a-zA-Z0-9_]{2,12}$/.test(self.nickName.trim())) {
                    const el = document.getElementById("nickInput");
                    const hint = document.getElementById("nickHint");

                    el.classList.add("invalid");
                    hint.className = "field-hint error";
                    hint.textContent = "별명은 한글·영문·숫자·_ 2~12자로 입력해주세요.";

                    el.focus();
                    showToast("별명 형식을 확인해주세요.");
                    return;
                }

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(self.email.trim())) {
                    const el = document.getElementById("emailInput");
                    const hint = document.getElementById("emailHint");

                    el.classList.add("invalid");
                    hint.className = "field-hint error";
                    hint.textContent = "이메일 형식을 확인해주세요.";

                    el.focus();
                    showToast("이메일 형식을 확인해주세요.");
                    return;
                }

                const pw = document.getElementById("pwInput").value.trim();
                const conf = document.getElementById("pwConfirm").value.trim();

                if (pw !== conf) {
                    const el = document.getElementById("pwConfirm");
                    const hint = document.getElementById("confirmHint");

                    el.classList.add("invalid");
                    hint.className = "field-hint error";
                    hint.textContent = "비밀번호가 일치하지 않아요.";

                    el.focus();
                    showToast("비밀번호가 일치하지 않습니다.");
                    return;
                }

                if (!self.term1 || !self.term2) {
                    showToast("필수 약관에 동의해주세요.");
                    return;
                }

                const param = {
                    userId: self.userId.trim(),
                    userName: self.userName.trim(),
                    nickName: self.nickName.trim(),
                    email: self.email.trim(),
                    userPwd: self.userPwd.trim(),
                    marketingYn: self.marketingYn ? "Y" : "N"
                };

                $.ajax({
                    url: "/user/sign-up.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success(data) {
                        if (data.result === "success") {
                            self.signupSuccessed = true;
                        } else {
                            showToast(data.message || "회원가입에 실패했습니다.");
                        }
                    },
                    error() {
                        showToast("회원가입 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnCheckUserId() {
                const self = this;

                const input = document.getElementById("userIdInput");
                const hint = document.getElementById("userIdHint");
                const userId = self.userId.trim();

                if (userId === "") {
                    self.checked = false;
                    input.classList.remove("valid");
                    input.classList.add("invalid");
                    hint.className = "field-hint error";
                    hint.textContent = "아이디를 입력해주세요.";
                    input.focus();
                    showToast("아이디를 입력해주세요.");
                    return;
                }

                const idRegex = /^[a-zA-Z0-9_]{4,20}$/;
                if (!idRegex.test(userId)) {
                    self.checked = false;
                    input.classList.remove("valid");
                    input.classList.add("invalid");
                    hint.className = "field-hint error";
                    hint.textContent = "아이디는 영문·숫자·_ 4~20자로 입력해주세요.";
                    input.focus();
                    showToast("아이디 형식을 확인해주세요.");
                    return;
                }

                $.ajax({
                    url: "/user/check-user-id.dox",
                    dataType: "json",
                    type: "POST",
                    data: { userId: userId },
                    success(data) {
                        hint.textContent = data.message;

                        if (data.result === "success") {
                            input.classList.remove("invalid");
                            input.classList.add("valid");
                            hint.className = "field-hint ok";
                            self.checked = true;
                        } else {
                            input.classList.remove("valid");
                            input.classList.add("invalid");
                            hint.className = "field-hint error";
                            self.checked = false;
                        }
                    },
                    error() {
                        self.checked = false;
                        showToast("아이디 중복 확인 중 오류가 발생했습니다.");
                    }
                });
            },

            fnGoLogin() {
                pageChange("/user/login.do", {});
            }
        },

        watch: {
            userId(newVal) {
                this.checked = false;

                if (newVal !== newVal.trim()) {
                    this.userId = newVal.trim();
                    return;
                }

                const input = document.getElementById("userIdInput");
                const hint = document.getElementById("userIdHint");

                if (!input || !hint) return;

                const value = newVal.trim();

                if (value === "") {
                    input.classList.remove("valid", "invalid");
                    hint.textContent = "";
                    hint.className = "field-hint";
                    return;
                }

                if (value.length < 4) {
                    input.classList.remove("valid");
                    input.classList.add("invalid");
                    hint.textContent = "아이디는 4자 이상 입력해주세요.";
                    hint.className = "field-hint error";
                    return;
                }

                input.classList.remove("invalid");
                input.classList.remove("valid");
                hint.textContent = "아이디 중복 확인이 필요합니다.";
                hint.className = "field-hint";
            }
        }
    });

    app.mount('#app');
</script>