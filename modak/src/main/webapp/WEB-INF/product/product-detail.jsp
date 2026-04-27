<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>모닥모닥 - 상품상세</title>
    <link rel="stylesheet" href="/css/product/product-detail.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/common/header.jsp" %>
<div id="app" v-cloak>
    <div class="wrap">
        <div class="ptop">
            <div class="gallery">
                <div class="gm">
                    <div class="gem" id="gem">
                        <img v-if="mainImgUrl"
                            :src="mainImgUrl" alt="상품 메인 이미지"
                            style="width:100%; height:100%; object-fit:cover;">
                        <img v-else src="/img/product/default.jpg"
                            style="width:100%; height:100%; object-fit:cover;">
                    </div>
                </div>
                <div class="gthumbs">
                    <div v-for="(img, idx) in productImages" :key="idx"
                        class="gth" :class="{ on: mainImgUrl === img.imgUrl }"
                        @click="setMainImg(img.imgUrl)">
                        <img :src="img.imgUrl"
                            style="width:100%; height:100%; object-fit:cover; display:block;">
                    </div>
                </div>
            </div>

            <!-- INFO -->
            <div class="pinfo">
                <div class="pbrand">{{ productInfo.brandName }}</div>
                <h1 class="ptitle">{{ productInfo.productName }}</h1>
                <div class="rrow">
                    <div class="stars"><span class="st" style="color:#ddd">★★★★★</span></div>
                    <span style="font-size:12px;color:var(--muted)">
                        <a href="#" style="color:var(--orange);text-decoration:none">(리뷰 {{ reviewList.length }}개)</a>
                        | 구매·대여 {{ orderCount }}회
                    </span>
                </div>

                <!-- MODE TOGGLE 숨김 -->
                <div class="mtog" style="display:none;">
                    <button class="mbtn on" id="mb-buy" onclick="setMode('buy')" :disabled="productType === 'RENTAL'">🛒 구매하기</button>
                    <button class="mbtn" id="mb-rent" onclick="setMode('rent')" :disabled="productType === 'PURCHASE'">📅 대여하기</button>
                </div>

                <!-- BUY PRICE -->
                <div class="buy-only">
                    <div class="pbox-buy">
                        <div class="prow"><span class="pnow">{{ formatPrice(productInfo.price) }}</span></div>
                        <div class="porig">23,150,000원</div>
                        <div class="pnote">쿠폰 적용시 최대 10% 할인</div>
                    </div>
                </div>

                <!-- RENT PRICE -->
                <div class="rent-only">
                    <div class="pbox-rent">
                        <div class="prow">
                            <span class="rent-per">1박당</span>
                            <span class="rent-num">{{ formatPrice(productInfo.price) }}</span>
                            <span class="rent-unit"> / 박</span>
                        </div>
                        <div style="font-size:13px;color:var(--muted);margin-top:4px;">
                            보증금 <strong style="color:#333;">{{ formatPrice(productInfo.deposit) }}</strong>
                            <span style="font-size:11px;">(반납 후 환불)</span>
                        </div>
                    </div>
                </div>

                <hr class="div">

                <!-- 옵션 선택 -->
                <div v-if="productOptions.length > 0">
                    <button @click="optionOpen = true"
                        style="width:100%;display:flex;justify-content:space-between;align-items:center;
                               padding:12px 16px;background:#f9f9f9;border:1px solid #eee;
                               border-radius:8px;cursor:pointer;font-size:14px;font-weight:600;
                               font-family:inherit;margin-bottom:8px;">
                        <span>🎛️ 옵션 선택
                            <span v-if="Object.keys(selectedOptions).length > 0" style="color:var(--orange);margin-left:8px;font-size:13px;">
                                {{ Object.values(selectedOptions).map(o => o.optionValue).join(' / ') }}
                            </span>
                            <span v-else style="color:var(--muted);margin-left:8px;font-size:13px;">옵션을 선택해주세요</span>
                        </span>
                        <span style="color:var(--orange);">▼</span>
                    </button>

                    <div v-if="optionOpen"
                        style="position:fixed;top:0;left:0;width:100%;height:100%;
                               background:rgba(0,0,0,0.5);z-index:9000;
                               display:flex;align-items:center;justify-content:center;"
                        @click.self="optionOpen = false">
                        <div style="background:#fff;border-radius:16px;padding:24px;
                                    width:360px;max-width:95vw;box-shadow:0 8px 32px rgba(0,0,0,0.2);">
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
                                <span style="font-size:16px;font-weight:700;">옵션 선택</span>
                                <button @click="optionOpen = false"
                                    style="background:none;border:none;font-size:20px;cursor:pointer;color:#999;">✕</button>
                            </div>
                            <div v-for="(opts, optionName) in groupedOptions" :key="optionName" style="margin-bottom:20px;">
                                <div style="font-size:13px;font-weight:600;color:#555;margin-bottom:10px;">{{ optionName }}</div>
                                <div style="display:flex;flex-wrap:wrap;gap:8px;">
                                    <div v-for="opt in opts" :key="opt.optionId"
                                        @click="selectOption(optionName, opt)"
                                        :style="selectedOptions[optionName]?.optionId === opt.optionId
                                            ? 'padding:8px 14px;border-radius:20px;border:2px solid var(--orange);background:#fff7f0;color:var(--orange);font-size:13px;font-weight:600;cursor:pointer;'
                                            : 'padding:8px 14px;border-radius:20px;border:1px solid #ddd;background:#fafafa;color:#333;font-size:13px;cursor:pointer;'">
                                        {{ opt.optionValue }}
                                        <span v-if="opt.addPrice > 0" style="font-size:11px;color:var(--orange);margin-left:4px;">
                                            +{{ opt.addPrice.toLocaleString() }}원
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div style="padding:12px;background:#fafafa;border-radius:8px;font-size:13px;min-height:44px;margin-bottom:14px;">
                                <div v-if="Object.keys(selectedOptions).length > 0" style="color:#333;">
                                    <span v-for="(opt, name) in selectedOptions" :key="name" style="display:inline-block;margin-right:8px;">
                                        <span style="color:var(--muted);">{{ name }}:</span>
                                        <strong style="color:var(--orange);margin-left:4px;">{{ opt.optionValue }}</strong>
                                    </span>
                                    <span v-if="totalAddPrice > 0" style="float:right;color:var(--orange);font-weight:700;">
                                        +{{ totalAddPrice.toLocaleString() }}원
                                    </span>
                                </div>
                                <div v-else style="color:#bbb;">옵션을 선택해주세요.</div>
                            </div>
                            <div style="display:flex;gap:8px;">
                                <button @click="selectedOptions = {}"
                                    style="flex:1;padding:10px;border:1px solid #eee;border-radius:8px;background:#fff;cursor:pointer;font-size:13px;font-family:inherit;">초기화</button>
                                <button @click="optionOpen = false"
                                    style="flex:2;padding:10px;border:none;border-radius:8px;background:var(--orange);color:#fff;cursor:pointer;font-size:14px;font-weight:600;font-family:inherit;">확인</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-if="productOptions.length === 0" class="osec">
                    <div class="olabel" style="color:var(--muted);font-size:13px;">옵션 없음</div>
                </div>

                <!-- BUY OPTIONS -->
                <div class="buy-only">
                    <button @click="qtyOpen = true"
                        style="width:100%;display:flex;justify-content:space-between;align-items:center;
                               padding:12px 16px;background:#f9f9f9;border:1px solid #eee;
                               border-radius:8px;cursor:pointer;font-size:14px;font-weight:600;
                               font-family:inherit;margin-bottom:8px;">
                        <span>🔢 수량 선택
                            <span style="color:var(--orange);margin-left:8px;font-size:13px;">{{ qty }}개</span>
                            <span v-if="remainQty > 0" style="color:var(--green);font-size:12px;margin-left:6px;">({{ remainQty }}개 남음)</span>
                            <span v-else-if="remainQty === 0 && qty > 0" style="color:var(--orange);font-size:12px;margin-left:6px;">(잔여 재고 없음)</span>
                            <span v-else style="color:var(--red);font-size:12px;margin-left:6px;">(품절)</span>
                        </span>
                        <span style="color:var(--orange);">▼</span>
                    </button>

                    <div v-if="qtyOpen"
                        style="position:fixed;top:0;left:0;width:100%;height:100%;
                               background:rgba(0,0,0,0.5);z-index:9000;
                               display:flex;align-items:center;justify-content:center;"
                        @click.self="qtyOpen = false">
                        <div style="background:#fff;border-radius:16px;padding:24px;width:320px;max-width:95vw;box-shadow:0 8px 32px rgba(0,0,0,0.2);">
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
                                <span style="font-size:16px;font-weight:700;">수량 선택</span>
                                <button @click="qtyOpen = false" style="background:none;border:none;font-size:20px;cursor:pointer;color:#999;">✕</button>
                            </div>
                            <div style="text-align:center;font-size:13px;color:var(--muted);margin-bottom:20px;">
                                <span v-if="displayQty > 0">현재 재고 <strong style="color:var(--green);">{{ displayQty }}개</strong> 남아있습니다</span>
                                <span v-else style="color:var(--red);font-weight:600;">품절된 상품입니다</span>
                            </div>
                            <div style="display:flex;align-items:center;justify-content:center;gap:0;margin-bottom:24px;">
                                <button @click="chgQty(-1)"
                                    style="width:48px;height:48px;border:1.5px solid var(--border);border-radius:8px 0 0 8px;background:#fafafa;font-size:22px;cursor:pointer;color:var(--text);display:flex;align-items:center;justify-content:center;">−</button>
                                <div style="width:80px;height:48px;border-top:1.5px solid var(--border);border-bottom:1.5px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:700;color:var(--orange);background:#fff;">{{ qty }}</div>
                                <button @click="chgQty(1)"
                                    style="width:48px;height:48px;border:1.5px solid var(--border);border-radius:0 8px 8px 0;background:#fafafa;font-size:22px;cursor:pointer;color:var(--text);display:flex;align-items:center;justify-content:center;">+</button>
                            </div>
                            <div style="padding:12px 16px;background:#fafafa;border-radius:8px;display:flex;justify-content:space-between;font-size:13px;margin-bottom:16px;">
                                <span style="color:var(--muted);">{{ formatPrice(unitPrice) }} × {{ qty }}개</span>
                                <strong style="color:var(--orange);">{{ totalPriceFormatted }}</strong>
                            </div>
                            <button @click="qtyOpen = false"
                                style="width:100%;padding:12px;border:none;border-radius:8px;background:var(--orange);color:#fff;cursor:pointer;font-size:15px;font-weight:700;font-family:inherit;">확인</button>
                        </div>
                    </div>

                    <div class="booking-summary">
                        <div v-if="Object.keys(selectedOptions).length > 0 || qty > 0">
                            <div v-for="(opt, name) in selectedOptions" :key="name"
                                style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--muted);">
                                <span>{{ name }}</span><span style="color:#333;font-weight:500;">{{ opt.optionValue }}</span>
                            </div>
                            <div v-if="totalAddPrice > 0"
                                style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--orange);">
                                <span>옵션 추가금</span><span>+{{ formatPrice(totalAddPrice) }}</span>
                            </div>
                            <div style="display:flex;justify-content:space-between;font-size:14px;margin-bottom:4px;">
                                <span style="color:var(--muted)">수량</span>
                                <span>{{ formatPrice(unitPrice) }} × {{ qty }}개</span>
                            </div>
                            <hr style="border:none;border-top:1px solid #f0c8a0;margin:8px 0;">
                            <div style="display:flex;justify-content:space-between;align-items:center;">
                                <span style="font-size:14px;color:var(--muted)">총 상품금액</span>
                                <span style="font-size:1.8rem;font-weight:bold;color:var(--orange);">{{ totalPriceFormatted }}</span>
                            </div>
                        </div>
                        <div v-else style="color:#bbb;">옵션과 수량을 선택해주세요.</div>
                    </div>

                    <div class="arow" style="margin-top:12px;">
                        <button class="bwish" id="wb1" :class="{ on: isWished }" @click="fnWish($event)">{{ isWished ? '❤️' : '🤍' }}</button>
                        <button class="bcart" @click="fnAddToCart">장바구니 담기</button>
                        <button class="bbuy">바로 구매하기</button>
                    </div>
                </div>

                <!-- RENT CALENDAR -->
                <div class="rent-only" style="max-width:700px;">
                    <button @click="calOpen = true"
                        style="width:100%;display:flex;justify-content:space-between;align-items:center;
                               padding:12px 16px;background:#f9f9f9;border:1px solid #eee;
                               border-radius:8px;cursor:pointer;font-size:14px;font-weight:600;
                               font-family:inherit;margin-bottom:8px;">
                        <span>📅 날짜 선택
                            <span v-if="startDate && endDate" style="color:var(--orange);margin-left:8px;font-size:13px;">{{ startDate }} ~ {{ endDate }} ({{ rentDays }}박)</span>
                            <span v-else-if="startDate" style="color:var(--orange);margin-left:8px;font-size:13px;">{{ startDate }} 선택됨</span>
                            <span v-else style="color:var(--muted);margin-left:8px;font-size:13px;">날짜를 선택해주세요</span>
                        </span>
                        <span style="color:var(--orange);">▼</span>
                    </button>

                    <div v-if="calOpen"
                        style="position:fixed;top:0;left:0;width:100%;height:100%;
                               background:rgba(0,0,0,0.5);z-index:9000;
                               display:flex;align-items:center;justify-content:center;"
                        @click.self="calOpen = false">
                        <div style="background:#fff;border-radius:16px;padding:24px;width:360px;max-width:95vw;box-shadow:0 8px 32px rgba(0,0,0,0.2);">
                            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                                <span style="font-size:16px;font-weight:700;">날짜 선택</span>
                                <button @click="calOpen = false" style="background:none;border:none;font-size:20px;cursor:pointer;color:#999;">✕</button>
                            </div>
                            <div class="cal-nav" style="margin-bottom:8px;">
                                <button @click="changeMonth(-1)">‹</button>
                                <h2 style="font-weight:bold;font-size:15px;">{{ currentYear }}년 {{ currentMonth + 1 }}월</h2>
                                <button @click="changeMonth(1)">›</button>
                            </div>
                            <div class="cal-grid">
                                <div v-for="w in ['일','월','화','수','목','금','토']" :key="w" class="day-name">{{w}}</div>
                                <div v-for="(day, idx) in calendarDays" :key="idx"
                                    :class="getDayClass(day)" @click="onDayClick(day)">
                                    <span v-if="day">{{ day.date }}</span>
                                </div>
                            </div>
                            <div style="margin-top:16px;padding:12px;background:#fafafa;border-radius:8px;font-size:13px;min-height:44px;">
                                <div v-if="startDate && endDate" style="color:#333;">
                                    {{ startDate }} ~ {{ endDate }}
                                    <strong style="color:var(--orange);margin-left:6px;">{{ rentDays }}박</strong>
                                </div>
                                <div v-else-if="startDate" style="color:var(--orange);font-weight:600;">종료일을 선택해주세요.</div>
                                <div v-else style="color:#bbb;">시작일을 선택해주세요.</div>
                            </div>
                            <div style="display:flex;gap:8px;margin-top:12px;">
                                <button @click="startDate=null; endDate=null;"
                                    style="flex:1;padding:10px;border:1px solid #eee;border-radius:8px;background:#fff;cursor:pointer;font-size:13px;font-family:inherit;">초기화</button>
                                <button @click="calOpen = false" :disabled="!startDate || !endDate"
                                    :style="(startDate && endDate)
                                        ? 'flex:2;padding:10px;border:none;border-radius:8px;background:var(--orange);color:#fff;cursor:pointer;font-size:14px;font-weight:600;font-family:inherit;'
                                        : 'flex:2;padding:10px;border:none;border-radius:8px;background:#ddd;color:#999;cursor:not-allowed;font-size:14px;font-weight:600;font-family:inherit;'">확인</button>
                            </div>
                        </div>
                    </div>

                    <div class="booking-summary">
                        <div v-if="startDate && endDate">
                            <p style="font-size:0.9rem;color:#888;margin-bottom:8px;">{{ startDate }} ~ {{ endDate }} ({{ rentDays }}박)</p>
                            <div v-if="totalAddPrice > 0" style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--muted);">
                                <span>기본가</span><span>{{ formatPrice(productInfo.price) }} / 박</span>
                            </div>
                            <div v-if="totalAddPrice > 0" style="display:flex;justify-content:space-between;font-size:13px;margin-bottom:4px;color:var(--orange);">
                                <span>옵션 추가금</span><span>+{{ formatPrice(totalAddPrice) }} / 박</span>
                            </div>
                            <div style="display:flex;justify-content:space-between;font-size:14px;margin-bottom:4px;">
                                <span style="color:var(--muted)">대여료 ({{ rentDays }}박)</span>
                                <span>{{ formatPrice(unitPrice * rentDays) }}</span>
                            </div>
                            <div style="display:flex;justify-content:space-between;font-size:14px;margin-bottom:8px;">
                                <span style="color:var(--muted)">보증금 <span style="font-size:11px;">(반납 후 환불)</span></span>
                                <span>{{ formatPrice(productInfo.deposit) }}</span>
                            </div>
                            <hr style="border:none;border-top:1px solid #eee;margin:8px 0;">
                            <div style="display:flex;justify-content:space-between;align-items:center;">
                                <span style="font-size:14px;color:var(--muted)">결제 예정금액</span>
                                <span style="font-size:1.8rem;font-weight:bold;color:var(--orange);">{{ formatPrice(unitPrice * rentDays + productInfo.deposit) }}</span>
                            </div>
                        </div>
                        <div v-else style="color:#bbb;">캘린더에서 예약 날짜를 선택해주세요.</div>
                    </div>

                    <div class="arow" style="margin-top:12px;">
                        <button class="bwish" id="wb2" :class="{ on: isWished }" @click="fnWish($event)">{{ isWished ? '❤️' : '🤍' }}</button>
                        <button class="bcart" @click="fnAddToCart">장바구니 담기</button>
                        <button class="bbuy"
                            :disabled="!startDate || !endDate"
                            :style="(!startDate || !endDate) ? 'opacity:0.4;cursor:not-allowed;' : ''"
                            @click="fnRent">
                            {{ (startDate && endDate) ? '대여 신청하기' : '날짜를 선택하세요' }}
                        </button>
                    </div>
                </div>

                <!-- DELIVERY -->
                <div class="delbox">
                    <div class="drow buy-only"><span class="dkey">배송</span><span class="dv"><strong>무료배송</strong> · 오늘 주문 시 내일 도착</span></div>
                    <div class="drow rent-only"><span class="dkey">수령/반납</span><span class="dv"><strong>무료 배송</strong> 또는 매장 직수령 · 반납일 오전 10시까지</span></div>
                    <div class="drow"><span class="dkey">반품</span><span class="dv">구매 후 30일 이내 무료 반품</span></div>
                    <div class="drow">
                        <span class="dkey">적립</span>
                        <span class="dv buy-only"><strong>420포인트</strong> 적립</span>
                        <span class="dv rent-only">대여 확정 시 <strong>80포인트/박</strong> 적립</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- TABS -->
        <div>
            <div class="tnav">
                <button class="tbtn on" @click="stab('det', $event)">상품 정보</button>
                <button class="tbtn" @click="stab('rev', $event)">리뷰 ({{ reviewList.length }})</button>
                <button class="tbtn" @click="stab('qna', $event)">Q&A</button>
                <button class="tbtn" @click="stab('shp', $event)">배송/대여 안내</button>
            </div>
            <div class="tcont">
                <div class="tpane on" id="tp-det">
                    <h3 style="font-size:15px;font-weight:700;margin-bottom:12px">🏕️ 제품 특징</h3>
                    <div class="flist">
                        <div class="fi" v-for="f in productFeatures" :key="f.featureId">
                            <div class="fic">{{ f.icon }}</div>
                            <div class="fit"><h4>{{ f.title }}</h4><p>{{ f.content }}</p></div>
                        </div>
                    </div>
                    <hr class="div" style="margin:18px 0">
                    <h3 style="font-size:15px;font-weight:700;margin-bottom:12px">📋 상품 스펙</h3>
                    <table class="spec">
                        <tr v-if="productSpec.capacity"><th>수용 인원</th><td>{{ productSpec.capacity }}</td></tr>
                        <tr v-if="productSpec.size"><th>전개 사이즈</th><td>{{ productSpec.size }}</td></tr>
                        <tr v-if="productSpec.weight"><th>총 중량</th><td>{{ productSpec.weight }}</td></tr>
                        <tr v-if="productSpec.material"><th>소재 (외피)</th><td>{{ productSpec.material }}</td></tr>
                        <tr v-if="productSpec.origin"><th>원산지</th><td>{{ productSpec.origin }}</td></tr>
                        <tr v-if="!productSpec.capacity && !productSpec.size">
                            <td colspan="2" style="text-align:center;color:var(--muted);padding:20px">등록된 스펙 정보가 없습니다.</td>
                        </tr>
                    </table>
                </div>

                <div class="tpane" id="tp-rev">
                    <div class="rsum2">
                        <div class="rbig">
                            <div class="rn">{{ avgRating }}</div>
                            <div class="stars" style="justify-content:center;display:flex;margin:5px 0">
                                <span v-for="(star, i) in avgStars" :key="i" class="st" :style="{ color: star === '★' ? '' : '#ddd' }">{{ star }}</span>
                            </div>
                            <div class="ro">{{ reviewList.length }}개 리뷰</div>
                        </div>
                        <div class="rbars">
                            <div class="bbar" v-for="d in ratingDist" :key="d.score">
                                <span class="blbl">{{ d.score }}점</span>
                                <div class="btrk"><div class="bfil" :style="{ width: d.pct + '%' }"></div></div>
                                <span class="bcnt">{{ d.count }}</span>
                            </div>
                        </div>
                    </div>
                    <div v-if="reviewList.length === 0" style="text-align:center;padding:36px 0;color:var(--muted);font-size:14px">아직 작성된 리뷰가 없습니다.</div>
                    <div class="rcard" v-for="review in reviewList" :key="review.reviewId">
                        <div class="rhead">
                            <div class="review-user">
                                <img class="review-profile" :src="review.profileImgUrl || '/img/profile/default.png'">
                                <div>
                                    <div class="rname">
                                        {{ review.nickname || review.userId }}
                                        <span v-if="review.gradeId >= 4" class="grade-badge vip">VIP</span>
                                        <span v-else-if="review.gradeId == 3" class="grade-badge gold">GOLD</span>
                                        <span v-else-if="review.gradeId == 2" class="grade-badge silver">SILVER</span>
                                    </div>
                                    <div class="stars" style="display:flex;gap:1px;margin-top:3px">
                                        <span v-for="(star, i) in getStars(review.rating)" :key="i" class="st"
                                            :style="{ fontSize:'12px', color: star === '★' ? '' : '#ddd' }">{{ star }}</span>
                                        <span style="font-size:12px;color:#999;margin-left:6px;">{{ Number(review.rating).toFixed(1) }}점</span>
                                    </div>
                                </div>
                            </div>
                            <div class="rdate">{{ review.createdAt }}</div>
                        </div>
                        <div class="rtext" style="font-weight:600;margin-bottom:4px">{{ review.title }}</div>
                        <div class="rtext">{{ review.content }}</div>
                        <div v-if="review.imageUrl" style="margin:10px 0;">
                            <img :src="review.imageUrl"
                                style="width:80px;height:80px;object-fit:cover;border-radius:8px;cursor:pointer;"
                                @click="openImg(review.imageUrl)">
                        </div>
                        <div class="rhelprow">
                            <span>도움이 됐나요?</span>
                            <button class="hbtn">👍 도움돼요</button>
                            <button class="report-btn" @click="reportReview(review.reviewId)">🚨 신고</button>
                        </div>
                    </div>
                </div>

                <div class="tpane" id="tp-qna">
                    <div v-if="faqList.length > 0" style="margin-bottom:20px;">
                        <div v-for="f in faqList" :key="f.faqId" style="border-bottom:1px solid #eee;">
                            <div @click="openFaqId = openFaqId === f.faqId ? null : f.faqId"
                                style="display:flex;justify-content:space-between;align-items:center;padding:14px 4px;cursor:pointer;">
                                <span style="font-size:14px;font-weight:600;">
                                    <span style="color:var(--orange);margin-right:6px;">Q.</span>{{ f.question }}
                                </span>
                                <span style="color:var(--orange);font-size:20px;line-height:1;">{{ openFaqId === f.faqId ? '−' : '+' }}</span>
                            </div>
                            <div v-if="openFaqId === f.faqId"
                                style="padding:12px 8px 16px 24px;font-size:13px;color:#555;background:#fafafa;border-radius:6px;line-height:1.8;margin-bottom:4px;">
                                <span style="color:var(--muted);margin-right:6px;">A.</span>{{ f.answer }}
                            </div>
                        </div>
                    </div>
                    <div v-else style="text-align:center;padding:20px 0;color:var(--muted);font-size:14px;">등록된 FAQ가 없습니다.</div>
                    <div style="text-align:center;padding:20px 0 8px;">
                        <p style="font-size:13px;color:var(--muted);margin-bottom:12px;">원하는 답변을 찾지 못하셨나요?<br>평균 24시간 내 답변드립니다.</p>
                        <button @click="fnInquiry"
                            style="background:var(--orange);color:#fff;border:none;border-radius:8px;padding:10px 24px;font-size:14px;cursor:pointer;font-family:inherit;font-weight:500;">1:1 문의하기</button>
                    </div>
                </div>

                <div class="tpane" id="tp-shp">
                    <table class="spec">
                        <tr><th>배송 방법</th><td>택배 (CJ 대한통운) 또는 매장 직수령</td></tr>
                        <tr><th>배송비</th><td>무료배송 (제주·도서산간 +3,000원)</td></tr>
                        <tr><th>대여 반납</th><td>반납일 오전 10시까지 · 택배 반납 가능</td></tr>
                        <tr><th>연체 요금</th><td>1일당 12,000원 (대여가의 150%)</td></tr>
                        <tr><th>파손/분실</th><td>수리 비용 또는 정가의 80% 배상</td></tr>
                        <tr><th>반품/교환</th><td>수령 후 30일 이내 (구매 상품)</td></tr>
                    </table>
                </div>
            </div>
        </div>

        <!-- RELATED -->
        <div class="rel" v-if="relatedList.length > 0">
            <h2 class="sectl">같은 카테고리 상품</h2>
            <div class="rgrid">
                <div class="pcard" v-for="item in relatedList" :key="item.productId" @click="goDetail(item.productId)">
                    <div class="pcimg">
                        <img v-if="item.imgUrl" :src="item.imgUrl" style="width:100%;height:100%;object-fit:cover;">
                        <span v-else style="font-size:48px;">🏕️</span>
                    </div>
                    <div class="pcbody">
                        <div class="pcbr">{{ item.brandName }}</div>
                        <div class="pcnm">{{ item.productName }}</div>
                        <div class="pcprice">{{ formatPrice(item.price) }}</div>
                        <div class="pcacts">
                            <button class="pca1" v-if="item.productType === 'RENTAL' || item.productType === 'BOTH'" @click.stop="goDetail(item.productId, 'rent')">대여</button>
                            <button class="pca2" v-if="item.productType === 'PURCHASE' || item.productType === 'BOTH'" @click.stop="goDetail(item.productId, 'buy')">구매</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 리뷰 이미지 모달 -->
        <div v-if="reviewImgModal.open" class="img-modal-overlay" @click.self="reviewImgModal.open = false">
            <div class="img-modal-box">
                <button class="img-modal-close" @click="reviewImgModal.open = false">✕</button>
                <img :src="reviewImgModal.url" class="img-modal-photo">
            </div>
        </div>

        <!-- 확인 모달 -->
        <div v-if="confirmModal.open" class="confirm-overlay" @click.self="confirmCancel">
            <div class="confirm-box">
                <div class="confirm-title">알림</div>
                <div class="confirm-message">{{ confirmModal.message }}</div>
                <div class="confirm-btns">
                    <button class="confirm-cancel" @click="confirmCancel">{{ confirmModal.cancelText }}</button>
                    <button class="confirm-ok" @click="confirmOk">{{ confirmModal.okText }}</button>
                </div>
            </div>
        </div>
    </div>
</div><!-- /#app -->

<%@ include file="/WEB-INF/common/footer.jsp" %>

<script>
const loginUserId = '${sessionScope.sessionId}';
const LS_KEY = 'modak_guest_cart'; // 장바구니 localStorage 키

function showToast(msg) {
    var t = document.getElementById('toast');
    if (!t) {
        t = document.createElement('div');
        t.id = 'toast';
        t.style.cssText = 'position:fixed;bottom:30px;left:50%;transform:translateX(-50%);background:#333;color:#fff;padding:10px 20px;border-radius:8px;font-size:13px;z-index:9999;display:none;';
        document.body.appendChild(t);
    }
    t.textContent = msg;
    t.style.display = 'block';
    setTimeout(function(){ t.style.display = 'none'; }, 2200);
}

function setGem(e, el) {
    document.getElementById('gem').textContent = e;
    document.querySelectorAll('.gth').forEach(t => t.classList.remove('on'));
    el.classList.add('on');
}

function setMode(m) {
    const r = m === 'rent';
    document.getElementById('mb-buy').classList.toggle('on', !r);
    document.getElementById('mb-rent').classList.toggle('on', r);
    document.body.classList.toggle('rent', r);
    if (window.__vueApp) window.__vueApp.cartMode = r ? 'RENT' : 'BUY';
}

const app = Vue.createApp({
    data() {
        return {
            productId: '${productId}',
            productInfo: {},
            productImages: [],
            mainImgUrl: '',
            reviewList: [],
            orderCount: 0,
            productType: '',
            availableQty: 0,
            totalQty: 0,
            qty: 1,
            currentYear: new Date().getFullYear(),
            currentMonth: new Date().getMonth(),
            rentedRanges: [],
            startDate: null,
            endDate: null,
            isWished: false,
            relatedList: [],
            productSpec: {},
            productFeatures: [],
            faqList: [],
            openFaqId: null,
            calOpen: false,
            productOptions: [],
            selectedOptions: {},
            optionOpen: false,
            qtyOpen: false,
            cartMode: 'RENT',
            isLogin: false,          // ← 추가: 로그인 여부
            confirmModal: { open: false, message: '', okText: '확인', cancelText: '취소', onOk: null },
            reviewImgModal: { open: false, url: '' },
        };
    },

    computed: {
        displayQty() {
            return this.productType === 'PURCHASE' ? this.totalQty : this.availableQty;
        },
        remainQty() { return this.displayQty - this.qty; },
        calendarDays() {
            const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
            const lastDate = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();
            const days = [];
            for (let i = 0; i < firstDay; i++) days.push(null);
            for (let d = 1; d <= lastDate; d++) {
                const dateObj = new Date(this.currentYear, this.currentMonth, d);
                const fullStr = this.formatDateCal(dateObj);
                days.push({ date: d, full: fullStr, isRented: this.checkIsRented(fullStr), isPast: dateObj < new Date().setHours(0,0,0,0) });
            }
            return days;
        },
        rentDays() {
            if (!this.startDate || !this.endDate) return 0;
            return Math.ceil((new Date(this.endDate) - new Date(this.startDate)) / (1000 * 60 * 60 * 24));
        },
        avgRating() {
            if (!this.reviewList.length) return '0.0';
            const sum = this.reviewList.reduce((acc, r) => acc + (r.rating || 0), 0);
            return (sum / this.reviewList.length).toFixed(1);
        },
        avgStars() {
            const rounded = Math.round(parseFloat(this.avgRating));
            return Array.from({ length: 5 }, (_, i) => i < rounded ? '★' : '☆');
        },
        ratingDist() {
            const dist = { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };
            this.reviewList.forEach(r => { const s = Math.round(r.rating); if (dist[s] !== undefined) dist[s]++; });
            const total = this.reviewList.length || 1;
            return [5,4,3,2,1].map(score => ({ score, count: dist[score], pct: Math.round((dist[score]/total)*100) }));
        },
        groupedOptions() {
            const groups = {};
            this.productOptions.forEach(opt => {
                if (!groups[opt.optionName]) groups[opt.optionName] = [];
                groups[opt.optionName].push(opt);
            });
            return groups;
        },
        totalAddPrice() {
            return Object.values(this.selectedOptions).reduce((sum, opt) => sum + (opt.addPrice || 0), 0);
        },
        unitPrice() { return (this.productInfo.price || 0) + this.totalAddPrice; },
        totalPrice() { return this.unitPrice * this.qty; },
        totalPriceFormatted() { return this.totalPrice.toLocaleString('ko-KR') + '원'; },
    },

    methods: {
        /* ── 로그인 체크 ── */
        checkLogin() {
            let self = this;
            $.ajax({
                url: '/user/session-check.dox', type: 'POST', dataType: 'json',
                success(res) { self.isLogin = res.isLogin === true; },
                error()     { self.isLogin = false; }
            });
        },

        /* ── localStorage 헬퍼 ── */
        loadGuestCart() {
            try { return JSON.parse(localStorage.getItem(LS_KEY)) || []; }
            catch(e) { return []; }
        },
        saveGuestCart(cart) {
            localStorage.setItem(LS_KEY, JSON.stringify(cart));
        },

        /* ── 상품 정보 로드 ── */
        fnDetail() {
            let self = this;
            $.ajax({
                url: '/product/detail.dox', type: 'POST',
                data: { productId: self.productId }, dataType: 'json',
                success(data) {
                    self.productInfo     = data.info;
                    self.orderCount      = data.orderCount || 0;
                    self.availableQty    = data.info.availableQty || 0;
                    self.totalQty        = data.info.totalQty || 0;
                    self.productSpec     = data.spec || {};
                    self.productFeatures = data.features || [];
                    self.faqList         = data.faqList || [];
                    self.productOptions  = data.options || [];
                    self.productType     = data.info.productType || '';
                    self.fetchRelatedProducts(data.info.categoryId);

                    if (self.productType === 'RENTAL') { setMode('rent'); self.cartMode = 'RENT'; }
                    else if (self.productType === 'PURCHASE') { setMode('buy'); self.cartMode = 'BUY'; }

                    // 위시 상태
                    $.ajax({
                        url: '/user/wishlist/list.dox', type: 'POST', dataType: 'json',
                        success(wRes) {
                            if (wRes.result === 'success' && wRes.list) {
                                const wishedIds = wRes.list.map(w => w.productId);
                                self.isWished = wishedIds.indexOf(parseInt(self.productId)) !== -1;
                            }
                        }
                    });
                }
            });
        },
        fetchProductImages() {
            let self = this;
            $.ajax({
                url: '/product/detail.dox', type: 'POST',
                data: { productId: self.productId },
                success(data) {
                    const imageList = data.img || [];
                    self.productImages = imageList;
                    if (imageList.length > 0) {
                        const main = imageList.find(i => i.mainImg === 'Y');
                        self.mainImgUrl = main ? main.imgUrl : imageList[0].imgUrl;
                    } else {
                        self.mainImgUrl = '/img/product/default.jpg';
                    }
                },
                error() { self.productImages = []; self.mainImgUrl = '/img/product/default.jpg'; }
            });
        },
        setMainImg(imgUrl) { this.mainImgUrl = imgUrl; },

        fnGetReviews() {
            let self = this;
            $.ajax({
                url: '/review/list.dox', type: 'POST',
                data: { productId: self.productId, page: 1, pageSize: 10 }, dataType: 'json',
                success(data) { self.reviewList = data.list || []; },
                error()       { self.reviewList = []; }
            });
        },

        /* ── 장바구니 담기 (회원/비회원 분기 핵심) ── */
        fnAddToCart() {
            let self = this;

            // 옵션 검증
            if (self.productOptions.length > 0) {
                const optionGroupCount = Object.keys(self.groupedOptions).length;
                const selectedCount    = Object.keys(self.selectedOptions).length;
                if (selectedCount < optionGroupCount) { showToast('옵션을 선택해주세요.'); return; }
            }

            // 대여 날짜 검증
            if (self.productType === 'RENTAL' && (!self.startDate || !self.endDate)) {
                showToast('대여 날짜를 선택해주세요.'); return;
            }

            // 구매 수량 검증
            if (self.productType === 'PURCHASE') {
                if (self.qty < 1) { showToast('수량을 선택해주세요.'); return; }
                if (self.qty > self.totalQty) { showToast('재고가 부족합니다.'); return; }
            }

            const optionId = Object.values(self.selectedOptions)[0]?.optionId || null;
            const optionName = Object.values(self.selectedOptions)[0]?.optionValue || null;

            /* ══ 비회원: localStorage 저장 ══ */
            if (!self.isLogin) {
                const cart = self.loadGuestCart();

                const newItem = {
                    cartId:      Date.now(),           // 임시 고유 ID
                    cartType:    self.productType,
                    productId:   parseInt(self.productId),
                    productName: self.productInfo.productName || '',
                    price:       self.unitPrice,
                    quantity:    self.qty,
                    imgUrl:      self.mainImgUrl || '',
                    brandName:   self.productInfo.brandName || '',
                    optionId:    optionId,
                    optionName:  optionName,
                    rentalStart: self.productType === 'RENTAL' ? self.startDate : null,
                    rentalEnd:   self.productType === 'RENTAL' ? self.endDate   : null,
                };

                // 중복 체크
                const dup = cart.find(c =>
                    c.productId   === newItem.productId &&
                    c.cartType    === newItem.cartType  &&
                    c.optionId    === newItem.optionId  &&
                    c.rentalStart === newItem.rentalStart &&
                    c.rentalEnd   === newItem.rentalEnd
                );

                if (dup) {
                    dup.quantity += self.qty;
                    self.saveGuestCart(cart);
                    self.openConfirm('이미 같은 조건의 상품이 있어 수량을 추가했습니다. 장바구니로 이동할까요?', function() {
                        location.href = '/cart/list.do';
                    }, '이동하기');
                } else {
                    cart.push(newItem);
                    self.saveGuestCart(cart);
                    self.openConfirm('장바구니에 담았습니다. 장바구니로 이동할까요?', function() {
                        location.href = '/cart/list.do';
                    }, '이동하기');
                }

                // 헤더 카운트 업데이트
                const countEl = document.getElementById('cartCount');
                if (countEl) countEl.textContent = cart.length;
                return;
            }

            /* ══ 회원: 서버 API 호출 ══ */
            const param = {
                productId:   self.productId,
                quantity:    self.qty,
                cartType:    self.productType,
                optionId:    optionId == null ? '' : optionId,
                rentalStart: self.productType === 'RENTAL' ? self.startDate : '',
                rentalEnd:   self.productType === 'RENTAL' ? self.endDate   : ''
            };

            $.ajax({
                url: '/cart/add.dox', type: 'POST',
                data: param, dataType: 'json',
                success(res) {
                    if (res.result === 'duplicate') {
                        self.openConfirm('이미 같은 조건의 상품이 있습니다. 장바구니로 이동할까요?', function() {
                            location.href = '/cart/list.do';
                        }, '이동하기');
                    } else if (res.result === 'success') {
                        self.openConfirm('장바구니에 담았습니다. 장바구니로 이동할까요?', function() {
                            location.href = '/cart/list.do';
                        }, '이동하기');
                    } else {
                        showToast('장바구니 담기 실패');
                    }
                },
                error() { showToast('장바구니 담기 중 오류가 발생했습니다.'); }
            });
        },

        /* ── 나머지 메서드 ── */
        getStars(rating) { return Array.from({ length: 5 }, (_, i) => i < rating ? '★' : '☆'); },
        formatDate(dateStr) { if (!dateStr) return ''; return dateStr.slice(0,10).replace(/-/g,'.'); },
        stab(n, event) {
            const el = event.currentTarget;
            document.querySelectorAll('.tbtn').forEach(b => b.classList.remove('on'));
            document.querySelectorAll('.tpane').forEach(p => p.classList.remove('on'));
            el.classList.add('on');
            document.getElementById('tp-' + n).classList.add('on');
            if (n === 'rev' && this.reviewList.length === 0) this.fnGetReviews();
        },
        openImg(url) { this.reviewImgModal.open = true; this.reviewImgModal.url = url; },
        formatPrice(price) { if (!price) return '0원'; return Number(price).toLocaleString('ko-KR') + '원'; },
        chgQty(d) {
            const max = this.displayQty;
            const next = this.qty + d;
            if (next < 1) return;
            if (next > max) { showToast('재고가 부족합니다. (최대 ' + max + '개)'); return; }
            this.qty = next;
        },
        formatDateCal(dateVal) {
            const d = new Date(dateVal);
            return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
        },
        checkIsRented(targetStr) {
            if (!this.rentedRanges || !this.rentedRanges.length) return false;
            return this.rentedRanges.some(range => {
                const s = this.formatDateCal(range.startDate || range.START_DATE);
                const e = this.formatDateCal(range.returnDate || range.RETURN_DATE);
                return targetStr >= s && targetStr <= e;
            });
        },
        getDayClass(day) {
            if (!day) return 'cal-day empty';
            if (day.isRented) return 'cal-day rented';
            if (day.isPast)   return 'cal-day past';
            if (day.full === this.startDate || day.full === this.endDate) return 'cal-day selected';
            if (this.startDate && this.endDate && day.full > this.startDate && day.full < this.endDate) return 'cal-day in-range';
            return 'cal-day available';
        },
        onDayClick(day) {
            if (!day || day.isPast || day.isRented) return;
            if (!this.startDate || (this.startDate && this.endDate)) {
                this.startDate = day.full; this.endDate = null;
            } else {
                if (day.full < this.startDate)       this.startDate = day.full;
                else if (day.full === this.startDate) this.startDate = null;
                else                                 this.endDate = day.full;
            }
        },
        changeMonth(diff) {
            const d = new Date(this.currentYear, this.currentMonth + diff, 1);
            this.currentYear  = d.getFullYear();
            this.currentMonth = d.getMonth();
        },
        fetchRentedDates() {
            let self = this;
            $.ajax({
                url: '/rental/calendar/dates.dox', type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ itemId: self.productId }),
                success(res) { if (res.result === 'success') self.rentedRanges = res.rentedList; }
            });
        },
        fnRent() {
            if (!this.startDate || !this.endDate) { showToast('날짜를 선택해주세요.'); return; }
            this.openConfirm('대여 신청하시겠습니까?', function() {
                const self = window.__vueApp;
                $.ajax({
                    url: '/rental/apply.dox', type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ itemId: self.productId, startDate: self.startDate, endDate: self.endDate }),
                    success(res) { if (res.result === 'success') { showToast('신청 완료!'); location.reload(); } }
                });
            }, '신청하기');
        },
        fnWish(e) {
            e.stopPropagation();
            let self = this;
            $.ajax({
                url: '/user/wishlist/toggle.dox', type: 'POST',
                data: { productId: self.productId }, dataType: 'json',
                success(res) {
                    if (res.result === 'success') {
                        self.isWished = !self.isWished;
                        showToast(self.isWished ? '❤️ 위시리스트에 추가됐어요' : '위시리스트에서 제거됐어요');
                    } else {
                        self.openConfirm('로그인이 필요합니다. 로그인하시겠습니까?', function() {
                            location.href = '/user/login.do';
                        }, '로그인하기');
                    }
                }
            });
        },
        fetchRelatedProducts(categoryId) {
            let self = this;
            $.ajax({
                url: '/product/related.dox', type: 'POST',
                data: { categoryId, productId: self.productId }, dataType: 'json',
                success(res) { if (res.result === 'success') self.relatedList = res.list || []; }
            });
        },
        goDetail(productId, mode) {
            let url = '/product/detail.do?productId=' + productId;
            if (mode) url += '&mode=' + mode;
            location.href = url;
        },
        fnInquiry() { location.href = '/inquiry.do'; },
        selectOption(optionName, opt) {
            if (this.selectedOptions[optionName]?.optionId === opt.optionId) {
                const copy = { ...this.selectedOptions };
                delete copy[optionName];
                this.selectedOptions = copy;
            } else {
                this.selectedOptions = { ...this.selectedOptions, [optionName]: opt };
            }
        },
        reportReview(reviewId) {
            this.openConfirm('이 리뷰를 신고하시겠습니까?', function() {
                console.log('신고된 리뷰 ID:', reviewId);
            }, '신고하기');
        },
        openConfirm(message, onOk, okText = '확인', cancelText = '취소') {
            this.confirmModal.message    = message;
            this.confirmModal.onOk       = onOk;
            this.confirmModal.okText     = okText;
            this.confirmModal.cancelText = cancelText;
            this.confirmModal.open       = true;
        },
        confirmOk() {
            if (typeof this.confirmModal.onOk === 'function') this.confirmModal.onOk();
            this.confirmModal.open = false;
        },
        confirmCancel() { this.confirmModal.open = false; },
    },

    mounted() {
        window.__vueApp = this;
        this.checkLogin();      // ← 로그인 체크 먼저
        this.fnDetail();
        this.fetchProductImages();
        this.fnGetReviews();
    }
});

app.mount('#app');
</script>
</body>
</html>
