<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>제품리스트</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
       
    </style>
</head>
<body>
    <div id="app">
        <div>
            <div v-for="item in list" :key="item.id">
                
                <div>
                    <span>{{ item.productId }}</span>
                </div>

                <div>
                    <div>{{ item.productName }}</div>
                    <div>{{ item.productType }}</div>

                    <div>
                        <span>{{ item.price }}원</span>
                        <span>보증금 {{ item.deposit }}원</span>
                    </div>

                    <div>
                        <button>대여하기</button>
                        <button>구매하기</button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (키 : 값)
                list : []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {
                    // 백엔드로 전달할 데이터
                };
                $.ajax({
                    url: "http://localhost:8080/product/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        // 받은 데이터를 변수에 저장하세요
                        self.list = data.list;
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
        }
    });

    app.mount('#app');
</script>