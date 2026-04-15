<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>불씨를 찾을 수 없어요 - 모닥모닥</title>
    <style>
        /* 기본 레이아웃 설정 */
        body, html {
            height: 100%;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Pretendard', sans-serif;
            background-color: #fff;
        }

        .error-container {
            text-align: center;
            max-width: 500px;
            padding: 20px;
        }

        /* 404 숫자 스타일 */
        .error-code {
            font-size: 120px;
            font-weight: 800;
            color: #b3391d; /* 진한 주황/갈색 톤 */
            line-height: 1;
            margin: 0;
        }

        /* 메인 메시지 */
        .error-title {
            font-size: 24px;
            font-weight: 600;
            color: #5d4037;
            margin: 20px 0;
        }

        /* 구분선 */
        .divider {
            width: 40px;
            height: 2px;
            background-color: #d7ccc8;
            margin: 0 auto 20px;
        }

        /* 서브 설명 텍스트 */
        .error-desc {
            font-size: 14px;
            line-height: 1.6;
            color: #8d6e63;
            margin-bottom: 30px;
        }

        /* 홈으로 돌아가기 버튼 */
        .home-btn {
            display: inline-block;
            padding: 12px 24px;
            font-size: 14px;
            color: #5d4037;
            text-decoration: none;
            border: 1px solid #d7ccc8;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .home-btn:hover {
            background-color: #fbe9e7;
            border-color: #ffccbc;
        }

        /* 하단 모닥불 일러스트 영역 */
        .illustration-box {
            margin-top: 50px;
            position: relative;
        }

        .campfire-img {
            width: 150px; /* 이미지 크기는 보유하신 파일에 맞춰 조절하세요 */
            opacity: 0.8;
        }
    </style>
</head>
<body>

    <div class="error-container">
        <h1 class="error-code">404</h1>
        <h2 class="error-title">불씨를 찾을 수 없어요</h2>
        <div class="divider"></div>
        
        <p class="error-desc">
            찾으시는 페이지가 꺼진 모닥불처럼 사라졌어요.<br>
            재가 된 링크일지도 모르니, 주소를 다시 확인해보세요.
        </p>

        <a href="${pageContext.request.contextPath}/" class="home-btn">
            🔥 홈으로 돌아가기
        </a>

        <div class="illustration-box">
            <img src="${pageContext.request.contextPath}/resources/images/campfire_off.png" 
                 alt="꺼진 모닥불" class="campfire-img">
        </div>
    </div>

</body>
</html>