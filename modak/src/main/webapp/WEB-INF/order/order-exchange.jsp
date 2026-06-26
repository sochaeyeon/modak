<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>교환 신청 - 모닥모닥</title>
	<link rel="stylesheet" href="/css/common/font.css">
	<link rel="stylesheet" href="/css/order/order-exchange.css">
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/remixicon@4.5.0/fonts/remixicon.css" rel="stylesheet">

	</head>

	<body>

		<%@ include file="/WEB-INF/common/header.jsp" %>

			<div id="app" v-cloak>
				<div class="exchange-page">

					<!-- 헤더 -->
					<p class="page-eyebrow">ORDER EXCHANGE</p>
					<h1 class="page-title">교환 신청</h1>
					<p class="page-desc">구매하신 상품을 교환하실 수 있어요. 아래 정보를 입력해 주세요.</p>

					<!-- 스텝 바 -->
					<div class="step-bar">
						<div class="step" :class="{ active: currentStep >= 1, done: currentStep > 1 }">
							<div class="step-dot">{{ currentStep > 1 ? '✓' : '1' }}</div>
							<span>교환 사유</span>
						</div>
						<div class="step-line"></div>
						<div class="step" :class="{ active: currentStep >= 2, done: currentStep > 2 }">
							<div class="step-dot">{{ currentStep > 2 ? '✓' : '2' }}</div>
							<span>{{ exchangeMethod === 'PICKUP' ? '회수 주소' : '발송 안내' }}</span>
						</div>
						<div class="step-line"></div>
						<div class="step" :class="{ active: currentStep >= 3 }">
							<div class="step-dot">3</div>
							<span>최종 확인</span>
						</div>
					</div>

					<!-- 로딩 -->
					<div v-if="isLoading" class="section-card">
						<div class="spinner"></div>
					</div>

					<template v-else>

						<!-- ══ STEP 1: 교환 사유 ══ -->
						<template v-if="currentStep === 1">

							<!-- 주문 상품 정보 -->
							<div class="section-card">
								<div class="section-head">
									<h3>교환 상품</h3>
									<span class="head-badge">주문번호 {{ orderId }}</span>
								</div>
								<div class="section-body">
									<div class="order-product-card" v-if="orderInfo">
										<div class="op-thumb">
											<img v-if="orderInfo.imgUrl" :src="orderInfo.imgUrl"
												:alt="orderInfo.productName">
											<span v-else class="empty-thumb-icon"><i
													class="ri-shopping-bag-3-line"></i></span>
										</div>
										<div class="op-info">
											<p class="op-name">{{ orderInfo.productName || '상품명 없음' }}</p>
											<p class="op-meta">수량 {{ orderInfo.count || 1 }}개</p>
											<p class="op-meta" v-if="orderInfo.optionName">옵션: {{ orderInfo.optionName
												}}</p>
										</div>
										<div class="op-price">{{ fnPrice(orderInfo.price) }}</div>
									</div>
								</div>
							</div>

							<!-- 교환 사유 선택 -->
							<div class="section-card">
								<div class="section-head">
									<h3>교환 사유 선택</h3>
									<span class="head-badge">필수</span>
								</div>
								<div class="section-body">
									<div class="reason-grid">
										<div v-for="r in reasonList" :key="r.value" class="reason-chip"
											:class="{ active: selectedReason === r.value }"
											@click="selectedReason = r.value">
											<span class="chip-icon"><i :class="r.icon"></i></span>
											<span>{{ r.label }}</span>
										</div>
									</div>
									<div v-if="selectedReason">
										<label class="form-label" style="margin-top:6px;">
											상세 사유 <span style="color:var(--brown4);font-weight:300;"> (선택)</span>
										</label>
										<textarea class="reason-textarea" v-model="reasonDetail"
											:placeholder="selectedReason === 'OTHER' ? '교환 사유를 직접 입력해 주세요.' : '추가로 전달할 내용을 입력해 주세요.'"
											maxlength="300" @input="fnCountChar"></textarea>
										<div class="char-count">{{ reasonDetail.length }} / 300</div>
									</div>
								</div>
							</div>



							<!-- 교환 옵션 선택 -->
							<div class="section-card" v-if="availableOptions.length > 0">
								<div class="section-head">
									<h3>교환 옵션 선택</h3>
									<span class="head-badge">필수</span>
								</div>
								<div class="section-body">
									<p style="font-size:13px;color:#9B7B68;margin-bottom:12px;">
										현재 옵션: <strong>{{ orderInfo.optionName || '기본 옵션' }}</strong>
										<span style="color:#E8732A;font-weight:700;margin-left:6px;">
											{{ fnPrice(orderInfo.price) }}
										</span>
									</p>
									<div class="reason-grid">
										<div v-for="opt in availableOptions" :key="opt.optionItemId" class="reason-chip"
											:class="{ active: String(selectedOptionId) === String(opt.optionItemId), disabled: opt.availableQty <= 0 }"
											@click="opt.availableQty > 0 && (selectedOptionId = String(opt.optionItemId))">
											<span>{{ opt.itemName }}</span>
											<span style="font-size:12px;font-weight:700;display:block;margin-top:3px;"
												:style="{ color: fnPriceDiff(opt) > 0 ? '#E8732A' : fnPriceDiff(opt) < 0 ? '#4B8B57' : '#9B7B68' }">
												{{ fnPriceDiffLabel(opt) }}
											</span>
											<span style="font-size:11px;color:#B09080;display:block;margin-top:2px;">
												{{ opt.availableQty > 0 ? '재고 있음' : '품절' }}
											</span>
										</div>
									</div>

									<!-- 차액 안내 박스 -->
									<div v-if="selectedOptionId && priceDiff !== 0"
										style="margin-top:14px;padding:12px 16px;border-radius:10px;font-size:13px;"
										:style="{ background: priceDiff > 0 ? '#FFF4EE' : '#F0F7F1', border: priceDiff > 0 ? '1px solid #F5C4A0' : '1px solid #C5E0CB' }">
										<p :style="{ color: priceDiff > 0 ? '#E8732A' : '#4B8B57', fontWeight: 700 }">
											<i :class="priceDiff > 0 ? 'ri-add-circle-line' : 'ri-refund-2-line'"></i>
											{{ priceDiff > 0 ? '추가 결제 필요' : '차액 환불' }}:
											<strong>{{ Math.abs(priceDiff).toLocaleString() }}원</strong>
										</p>
										<p style="color:#9B7B68;margin-top:4px;font-size:12px;">
											{{ priceDiff > 0
											? '교환 처리 후 고객센터를 통해 추가 결제가 안내됩니다.'
											: '교환 처리 완료 후 차액이 환불됩니다.' }}
										</p>
									</div>
								</div>
							</div>

							<!-- 교환 방법 -->
							<div class="section-card">
								<div class="section-head">
									<h3>교환 방법</h3>
									<span class="head-badge">필수</span>
								</div>
								<div class="section-body">
									<div class="method-grid">
										<div class="method-card" :class="{ active: exchangeMethod === 'PICKUP' }"
											@click="exchangeMethod = 'PICKUP'">
											<div class="method-icon"><i class="ri-truck-line"></i></div>
											<div class="method-name">택배 회수</div>
											<div class="method-desc">기사님이 방문하여 수거</div>
										</div>
										<div class="method-card" :class="{ active: exchangeMethod === 'DIRECT' }"
											@click="exchangeMethod = 'DIRECT'">
											<div class="method-icon"><i class="ri-box-3-line"></i></div>
											<div class="method-name">직접 발송</div>
											<div class="method-desc">고객 직접 택배 발송</div>
										</div>
									</div>
								</div>
							</div>

							<!-- 배송비 안내 -->
							<div class="notice-box" style="margin-bottom:16px;"
								:style="{ borderColor: totalShippingFee > 0 ? '#E8732A' : '#4B8B57' }">
								<p class="notice-title"><i class="ri-truck-line"></i> 배송비 안내</p>
								<ul>
									<li v-if="shippingFeeByReason === 0" style="color:#4B8B57;font-weight:600;">
										판매자 귀책 사유로 배송비가 <strong>전액 무료</strong>입니다.
										<span v-if="isIslandAddr" style="font-size:11px;display:block;">(제주/도서산간 추가 배송비
											포함)</span>
									</li>
									<li v-else>
										고객 변심/기타 사유로 왕복 배송비 <strong>{{ shippingFeeByReason.toLocaleString()
											}}원</strong>이 부과됩니다.
									</li>
									<li v-if="isIslandAddr && shippingFeeByReason > 0"
										style="color:#E8732A;font-weight:600;">
										제주/도서산간 지역 추가 배송비 <strong>+{{ ISLAND_FEE.toLocaleString() }}원</strong>
									</li>
									<li v-if="totalShippingFee > 0" style="font-weight:700;color:#E8732A;">
										총 배송비: {{ totalShippingFee.toLocaleString() }}원
									</li>
								</ul>
							</div>



							<!-- 하단 차액 안내 박스 -->
							<div v-if="selectedOptionId && priceDiff !== 0"
								style="margin-top:14px;padding:12px 16px;border-radius:10px;font-size:13px;"
								:style="{ background: priceDiff > 0 ? '#FFF4EE' : '#F0F7F1', border: priceDiff > 0 ? '1px solid #F5C4A0' : '1px solid #C5E0CB' }">
								<p :style="{ color: priceDiff > 0 ? '#E8732A' : '#4B8B57', fontWeight: 700 }">
									<i :class="priceDiff > 0 ? 'ri-add-circle-line' : 'ri-refund-2-line'"></i>
									{{ priceDiff > 0 ? '추가 결제 필요' : '환불 예정' }}:
									<strong>
										{{ priceDiff > 0
										? Math.abs(priceDiff).toLocaleString()
										: Math.max(0, Math.abs(priceDiff) - (shippingFeeByReason > 0 ? totalShippingFee
										: 0)).toLocaleString() }}원
									</strong>
								</p>
								<p style="color:#9B7B68;margin-top:4px;font-size:12px;">
									{{ priceDiff > 0
									? '교환 처리 후 고객센터를 통해 추가 결제가 안내됩니다.'
									: shippingFeeByReason > 0
									? '차액 ' + Math.abs(priceDiff).toLocaleString() + '원 - 왕복배송비 ' +
									totalShippingFee.toLocaleString() + '원'
									: '교환 처리 완료 후 차액이 환불됩니다.' }}
								</p>
							</div>
				</div>
			</div>

			</template>

			<!-- ══ STEP 2: 회수 주소 / 직접 발송 안내 ══ -->
			<template v-if="currentStep === 2">

				<div class="section-card">
					<div class="section-head">
						<h3>{{ exchangeMethod === 'PICKUP' ? '회수 주소' : '직접 발송 안내' }}</h3>
						<span class="head-badge">
							{{ exchangeMethod === 'PICKUP' ? '필수' : '안내' }}
						</span>
					</div>

					<div class="section-body">

						<!-- 택배 회수 선택 시: 고객 회수 주소 입력 -->
						<template v-if="exchangeMethod === 'PICKUP'">

							<div class="exchange-guide-box">
								<div class="guide-icon">
									<i class="ri-truck-line"></i>
								</div>
								<div>
									<p class="guide-title">택배 회수를 선택하셨습니다.</p>
									<p class="guide-desc">
										기사님이 방문할 주소를 입력해 주세요. 입력한 주소로 상품 회수가 진행됩니다.
									</p>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">우편번호</label>
								<div class="zipcode-row">
									<input type="text" class="form-input" v-model="pickup.zipcode" readonly
										placeholder="우편번호">

									<button type="button" class="btn-search-addr" @click="fnSearchAddr">
										주소 검색
									</button>
								</div>
							</div>

							<div class="form-group">
								<label class="form-label">주소</label>
								<input type="text" class="form-input" v-model="pickup.address" readonly
									placeholder="주소 검색을 눌러주세요">
							</div>

							<div class="form-group">
								<label class="form-label">상세 주소</label>
								<input type="text" class="form-input" v-model="pickup.detailAddress"
									ref="detailAddrInput" placeholder="상세 주소를 입력해 주세요">
							</div>

							<div class="form-group">
								<label class="form-label">회수 요청 사항</label>
								<input type="text" class="form-input" v-model="pickup.memo"
									placeholder="예: 문 앞에 놓아주세요 (선택)">
							</div>

							<div class="notice-box" style="margin-top:4px;">
								<p class="notice-title">
									<i class="ri-information-line"></i>
									회수 신청 안내
								</p>
								<ul>
									<li>교환 신청 접수 후 회수 일정은 영업일 기준 1~3일 내 안내됩니다.</li>
									<li>상품은 구성품과 포장재를 가능한 그대로 준비해 주세요.</li>
									<li>상품 확인 후 동일 상품으로 교환 처리가 진행됩니다.</li>
								</ul>
							</div>
						</template>

						<!-- 직접 발송 선택 시: 모닥모닥 주소 안내만 표시 -->
						<template v-else>

							<div class="exchange-guide-box direct">
								<div class="guide-icon">
									<i class="ri-box-3-line"></i>
								</div>
								<div>
									<p class="guide-title">직접 발송을 선택하셨습니다.</p>
									<p class="guide-desc">
										고객님이 직접 택배를 접수해 아래 모닥모닥 물류센터 주소로 보내주시면 됩니다.
									</p>
								</div>
							</div>

							<div class="return-address-card">
								<div class="return-address-head">
									<i class="ri-map-pin-2-line"></i>
									<span>모닥모닥 교환 접수 주소</span>
								</div>

								<div class="return-address-body">
									<p class="return-zipcode">우편번호 06236</p>
									<p class="return-address-main">
										서울시 강남구 테헤란로 123 모닥모닥 물류센터
									</p>
									<p class="return-address-sub">
										교환 담당자 앞 / 주문번호 {{ orderId }}
									</p>
								</div>
							</div>

							<div class="notice-box" style="margin-top:14px;">
								<p class="notice-title">
									<i class="ri-information-line"></i>
									직접 발송 안내
								</p>
								<ul>
									<li>택배사는 자유롭게 선택하실 수 있습니다.</li>
									<li>상품 발송 시 주문번호를 메모지에 적어 동봉해 주세요.</li>
									<li>운송장 번호는 고객센터 또는 1:1 문의로 남겨주시면 처리가 더 빨라집니다.</li>
									<li>상품 도착 및 검수 후 동일 상품으로 교환이 진행됩니다.</li>
									<li>단순 변심의 경우 왕복 배송비가 부과될 수 있습니다.</li>
								</ul>
							</div>

						</template>

					</div>
				</div>

			</template>

			<!-- ══ STEP 3: 최종 확인 ══ -->
			<template v-if="currentStep === 3">

				<div class="section-card">
					<div class="section-head">
						<h3>신청 내용 확인</h3>
					</div>
					<div class="section-body">

						<!-- 상품 -->
						<div style="margin-bottom:20px;">
							<p class="form-label">교환 상품</p>
							<div class="order-product-card" v-if="orderInfo">
								<div class="op-thumb">
									<img v-if="orderInfo.imgUrl" :src="orderInfo.imgUrl">
									<span v-else class="empty-thumb-icon">
										<i class="ri-shopping-bag-3-line"></i>
									</span>
								</div>
								<div class="op-info">
									<p class="op-name">{{ orderInfo.productName }}</p>
									<p class="op-meta">수량 {{ orderInfo.count || 1 }}개</p>
								</div>
								<div class="op-price" v-if="priceDiff + totalShippingFee > 0" style="color:#E8732A;">
									추가 결제 {{ fnPrice(priceDiff + totalShippingFee) }}
								</div>
								<div class="op-price" v-else style="color:#4B8B57;">
									추가 결제 없음
								</div>
							</div>
						</div>

						<!-- 배송비 tr 아래에 추가 -->
						<tr v-if="priceDiff + totalShippingFee > 0" style="border-top:2px solid var(--cream2);">
							<td style="padding:12px 0;color:#E8732A;font-weight:700;">추가 결제</td>
							<td style="padding:12px 0;color:#E8732A;font-weight:700;font-size:15px;">
								{{ fnPrice(priceDiff + totalShippingFee) }}
							</td>
						</tr>

						<!-- 요약 테이블 -->
						<table style="width:100%;border-collapse:collapse;font-size:13px;">
							<tr style="border-bottom:1px solid var(--cream2);">
								<td style="padding:12px 0;color:var(--brown4);width:120px;font-weight:600;">
									교환 사유</td>
								<td style="padding:12px 0;color:var(--brown);font-weight:500;">{{
									fnReasonLabel(selectedReason) }}</td>
							</tr>
							<tr style="border-bottom:1px solid var(--cream2);" v-if="reasonDetail">
								<td style="padding:12px 0;color:var(--brown4);font-weight:600;">상세 사유</td>
								<td style="padding:12px 0;color:var(--brown3);">{{ reasonDetail }}</td>
							</tr>
							<tr style="border-bottom:1px solid var(--cream2);">
								<td style="padding:12px 0;color:var(--brown4);font-weight:600;">교환 방법</td>
								<td style="padding:12px 0;color:var(--brown);font-weight:500;">
									<span class="summary-method">
										<i :class="exchangeMethod === 'PICKUP' ? 'ri-truck-line' : 'ri-box-3-line'"></i>
										{{ exchangeMethod === 'PICKUP' ? '택배 회수' : '직접 발송' }}
									</span>
								</td>
							</tr>
							<!-- 교환 옵션 -->
							<tr style="border-bottom:1px solid var(--cream2);"
								v-if="selectedOptionId && availableOptions.length > 0">
								<td style="padding:12px 0;color:var(--brown4);width:120px;font-weight:600;">
									교환 옵션</td>
								<td style="padding:12px 0;color:var(--brown);font-weight:500;">
									{{ (availableOptions.find(function(o){ return String(o.optionItemId) ===
									String(selectedOptionId); }) || {}).itemName || '-' }}
									<span v-if="String(selectedOptionId) !== String(orderInfo.optionItemId)"
										style="font-size:11px;color:#E8732A;margin-left:6px;font-weight:700;">
										옵션 변경
									</span>
								</td>
							</tr>

							<!-- 배송비 -->
							<tr>
								<td style="padding:12px 0;color:var(--brown4);font-weight:600;">배송비</td>
								<td style="padding:12px 0;font-weight:700;"
									:style="{ color: totalShippingFee > 0 ? '#E8732A' : '#4B8B57' }">
									{{ totalShippingFee > 0 ? totalShippingFee.toLocaleString() + '원' : '무료'
									}}
									<span v-if="isIslandAddr"
										style="font-size:11px;display:block;color:#B09080;font-weight:400;margin-top:2px;">
										제주/도서산간 +{{ ISLAND_FEE.toLocaleString() }}원 포함
									</span>
								</td>
							</tr>
							<!-- 환불 금액 표시 -->
							<tr v-if="priceDiff < 0" style="border-top:2px solid var(--cream2);">
								<td style="padding:12px 0;color:#4B8B57;font-weight:700;">환불 예정</td>
								<td style="padding:12px 0;color:#4B8B57;font-weight:700;font-size:15px;">
									<span v-if="shippingFeeByReason > 0">
										{{ fnPrice(Math.max(0, Math.abs(priceDiff) - totalShippingFee)) }}
										<span style="font-size:11px;font-weight:400;color:#B09080;display:block;">
											(차액 {{ fnPrice(Math.abs(priceDiff)) }} - 왕복배송비 {{ fnPrice(totalShippingFee)
											}})
										</span>
									</span>
									<span v-else>{{ fnPrice(Math.abs(priceDiff)) }}</span>
								</td>
							</tr>
							<tr v-if="exchangeMethod === 'PICKUP'">
								<td style="padding:12px 0;color:var(--brown4);font-weight:600;">회수 주소</td>
								<td style="padding:12px 0;color:var(--brown3);">
									({{ pickup.zipcode }}) {{ pickup.address }} {{ pickup.detailAddress }}
									<span v-if="pickup.memo"
										style="display:block;font-size:11px;color:var(--brown4);margin-top:2px;">
										요청사항: {{ pickup.memo }}
									</span>
								</td>
							</tr>
							<tr v-else>
								<td style="padding:12px 0;color:var(--brown4);font-weight:600;">발송 주소</td>
								<td style="padding:12px 0;color:var(--brown3);">
									<span style="display:block;color:var(--brown);font-weight:700;">
										서울시 강남구 테헤란로 123 모닥모닥 물류센터
									</span>
									<span style="display:block;font-size:11px;color:var(--brown4);margin-top:2px;">
										교환 담당자 앞 / 주문번호 {{ orderId }}
									</span>
								</td>
							</tr>
						</table>

						<!-- 안내 -->
						<div class="notice-box" style="margin-top:20px;">
							<p class="notice-title">
								<i class="ri-information-line"></i>
								교환 처리 안내
							</p>

							<ul v-if="exchangeMethod === 'PICKUP'">
								<li>교환 신청 후 영업일 1~3일 내 회수 일정이 안내됩니다.</li>
								<li>기사님 방문 전 상품과 구성품을 함께 포장해 주세요.</li>
								<li>회수 상품 검수 후 동일 상품으로 교환 발송됩니다.</li>
								<li>다른 옵션을 원하시는 경우 교환이 아닌 환불 후 재주문으로 진행해 주세요.</li>
								<li>고객 변심의 경우 왕복 배송비가 부과될 수 있습니다.</li>
							</ul>

							<ul v-else>
								<li>상품을 직접 발송하신 뒤 운송장 번호를 고객센터에 남겨주세요.</li>
								<li>상품 도착 및 검수 후 동일 상품으로 교환 발송됩니다.</li>
								<li>옵션 변경 요청이 있는 경우 재고 확인 후 별도 안내드립니다.</li>
								<li>주문번호를 함께 동봉하면 확인이 더 빠릅니다.</li>
								<li>고객 변심의 경우 왕복 배송비가 부과될 수 있습니다.</li>
							</ul>
						</div>
					</div>
				</div>

			</template>

			</template><!-- /template v-else -->

			<!-- 하단 버튼 -->
			<div class="bottom-actions" v-if="!isLoading">
				<button class="btn-cancel" @click="fnPrev">
					<i class="ri-arrow-left-line"></i>
					{{ currentStep === 1 ? '돌아가기' : '이전' }}
				</button>

				<button class="btn-submit" :disabled="!fnCanNext()" @click="fnNext">
					{{ currentStep === 3
					? (priceDiff + totalShippingFee > 0 ? '결제하기'
					: priceDiff < 0 ? '환불 신청하기' : '교환 신청 완료' ) : '다음' }} <i v-if="currentStep !== 3"
						class="ri-arrow-right-line"></i>
				</button>
			</div>

			</div><!-- /exchange-page -->

			<!-- 완료 모달 -->
			<div class="modal-backdrop" v-if="modal.show" @click.self="fnCloseModal">
				<div class="modal-box">
					<div class="modal-icon">
						<i class="ri-checkbox-circle-line"></i>
					</div>
					<div class="modal-title">교환 신청 완료!</div>
					<div class="modal-desc">
						교환 신청이 접수되었습니다.<br>
						영업일 1~3일 내로 처리 결과를 안내드립니다.
					</div>
					<div class="modal-actions">
						<button class="modal-cancel" @click="fnGoHistory">주문내역 보기</button>
						<button class="modal-confirm" @click="fnGoMain">메인으로</button>
					</div>
				</div>
			</div>

			<div class="toast" id="toast"></div>

			</div><!-- /#app -->

			<%@ include file="/WEB-INF/common/footer.jsp" %>

				<script>
					var app = Vue.createApp({
						data: function () {
							return {
								orderId: new URLSearchParams(location.search).get('orderId') || '',
								token: new URLSearchParams(location.search).get('token') || '',
								isLoading: false,
								isSubmitting: false,
								currentStep: 1,
								orderInfo: null,

								selectedReason: '',
								reasonDetail: '',
								reasonList: [
									{ value: 'DEFECT', icon: 'ri-tools-line', label: '상품 불량/파손' },
									{ value: 'WRONG', icon: 'ri-error-warning-line', label: '오배송' },
									{ value: 'DIFF', icon: 'ri-file-list-3-line', label: '상품 설명 상이' },
									{ value: 'MISSING', icon: 'ri-inbox-unarchive-line', label: '구성품 누락' },
									{ value: 'MIND', icon: 'ri-chat-smile-2-line', label: '단순 변심' },
									{ value: 'OTHER', icon: 'ri-edit-2-line', label: '기타 직접 입력' },
								],

								exchangeMethod: 'PICKUP',
								pickup: { zipcode: '', address: '', detailAddress: '', memo: '' },

								availableOptions: [],
								selectedOptionId: '',
								shippingFee: 0,
								ISLAND_FEE: 3000,

								modal: { show: false },
							};
						},

						computed: {
							isIslandAddr: function () {
								var addr = (this.pickup.address || '') + ' ' + (this.pickup.detailAddress || '');
								return this.checkIsIsland(addr);
							},
							shippingFeeByReason: function () {
								var sellerFault = ['DEFECT', 'WRONG', 'DIFF', 'MISSING'];
								return sellerFault.indexOf(this.selectedReason) >= 0 ? 0 : 5000;
							},
							totalShippingFee: function () {
								// 판매자 귀책이면 제주/도서산간 포함 전액 무료
								if (this.shippingFeeByReason === 0) return 0;
								return this.shippingFeeByReason + (this.isIslandAddr ? this.ISLAND_FEE : 0);
							},
							priceDiff: function () {
								if (!this.selectedOptionId || !this.availableOptions.length) return 0;
								var selected = this.availableOptions.find(function (o) {
									return String(o.optionItemId) === String(this.selectedOptionId);
								}.bind(this));
								if (!selected) return 0;  // extraPrice 체크 제거!
								var original = this.availableOptions.find(function (o) {
									return String(o.optionItemId) === String(this.orderInfo.optionItemId);
								}.bind(this));
								var originalPrice = original ? (original.extraPrice || 0) : 0;
								return (selected.extraPrice || 0) - originalPrice;
							},
						},

						watch: {
							'pickup.address': function () { this.shippingFee = this.totalShippingFee; },
							'pickup.detailAddress': function () { this.shippingFee = this.totalShippingFee; },
							selectedReason: function () { this.shippingFee = this.totalShippingFee; },
						},

						methods: {
							fnInit: function () {
								var params = new URLSearchParams(location.search);
								this.orderId = params.get('orderId') || '';
								this.token = params.get('token') || '';

								if (!this.orderId) { this.fnShowToast('잘못된 접근입니다.'); return; }

								var isLogin = '${sessionScope.sessionId}' !== '';
								if (!isLogin && !this.token) {
									this.fnShowToast('비회원 주문조회 페이지에서 다시 진행해주세요.');
									return;
								}

								var self = this;
								this.isLoading = true;

								$.ajax({
									url: self.token ? '/order/guest/exchange-info.dox' : '/order/exchange/info.dox',
									type: 'POST',
									dataType: 'json',
									data: self.token
										? { orderId: self.orderId, token: self.token }
										: { orderId: self.orderId },
									success: function (res) {
										self.isLoading = false;
										if (res.result === 'success') {
											self.orderInfo = res.orderInfo;

											self.availableOptions = res.options || [];
											if (self.orderInfo && self.orderInfo.optionItemId) {
												self.selectedOptionId = String(self.orderInfo.optionItemId);
											}

											if (res.defaultAddress) {
												self.pickup.zipcode = res.defaultAddress.zipcode;
												self.pickup.address = res.defaultAddress.address;
												self.pickup.detailAddress = res.defaultAddress.detailedAddress;
											}
										} else {
											self.fnShowToast(res.message);
										}
									},
									error: function () {
										self.isLoading = false;
										self.fnShowToast('주문 정보를 불러오지 못했습니다.');
									}
								});
							},
							fnPriceDiff: function (opt) {
								if (!this.orderInfo) return 0;
								var original = this.availableOptions.find(function (o) {
									return String(o.optionItemId) === String(this.orderInfo.optionItemId);
								}.bind(this));
								var originalPrice = original ? (original.extraPrice || 0) : 0;
								return (opt.extraPrice || 0) - originalPrice;
							},
							fnPriceDiffLabel: function (opt) {
								var diff = this.fnPriceDiff(opt);
								if (diff === 0) return '동일 가격';
								return (diff > 0 ? '+' : '') + diff.toLocaleString() + '원';
							},

							checkIsIsland: function (addr) {
								if (!addr) return false;
								var n = addr.replace(/\s+/g, '');
								var patterns = ['제주', '제주도', '제주특별자치도', '서귀포', '울릉', '독도',
									'백령도', '연평도', '덕적도', '영흥도', '대부도', '거문도', '완도', '진도', '신안',
									'흑산도', '홍도', '가거도', '비금도', '도초도', '여수시돌산', '남해도', '창선도',
									'통영', '거제', '욕지도', '매물도', '고흥', '보성', '장흥'];
								return patterns.some(function (p) { return n.includes(p); });
							},

							fnSubmit: function () {
								if (this.isSubmitting) return;
								this.isSubmitting = true;

								var self = this;
								var isGuest = !!self.token;
								var url = isGuest ? '/order/guest/exchange.dox' : '/order/exchange/apply.dox';

								var data = {
									oldOptionItemId: (self.orderInfo && self.orderInfo.optionItemId) ? String(self.orderInfo.optionItemId) : '',
									newOptionItemId: self.selectedOptionId,
									quantity: self.orderInfo ? (self.orderInfo.count || 1) : 1,
									orderId: self.orderId,
									exchangeReason: self.selectedReason,
									reasonDetail: self.reasonDetail,
									exchangeMethod: self.exchangeMethod,
									zipcode: self.pickup.zipcode,
									address: self.pickup.address,
									detailAddress: self.pickup.detailAddress,
									detailedAddress: self.pickup.detailAddress,
									memo: self.pickup.memo,
									shippingFee: self.totalShippingFee,
									priceDiff: self.priceDiff,
									isSellerFault: ['DEFECT', 'WRONG', 'DIFF', 'MISSING'].indexOf(self.selectedReason) >= 0 ? 1 : 0
								};
								if (isGuest) data.token = self.token;

								$.ajax({
									url: url, type: 'POST', dataType: 'json', data: data,
									success: function (res) {
										self.isSubmitting = false;
										if (res.result === 'success') {
											var totalPayment = self.priceDiff + self.totalShippingFee;

											if (totalPayment > 0 && res.exchangeId) {
												// 추가 결제 필요 → 결제 페이지
												var item = {
													productName: self.orderInfo.productName,
													imgUrl: self.orderInfo.imgUrl,
													price: totalPayment,
													unitPrice: totalPayment,
													quantity: 1,
													optionName: (self.availableOptions.find(function (o) {
														return String(o.optionItemId) === String(self.selectedOptionId);
													}) || {}).itemName || '',
													shippingFee: 0,
													productId: self.orderInfo.productId,
													optionItemId: self.selectedOptionId
												};
												localStorage.setItem('checkout_items', JSON.stringify([item]));
												location.href = '/payment/checkout.do?buyNow=true&cartType=EXCHANGE&exchangeId=' + res.exchangeId;

											} else if (self.priceDiff < 0) {
												var isSellerFault = ['DEFECT', 'WRONG', 'DIFF', 'MISSING'].indexOf(self.selectedReason) >= 0;
												var refundAmount = Math.abs(self.priceDiff);

												if (!isSellerFault) {
													refundAmount = Math.max(0, refundAmount - self.totalShippingFee);
												}
												self.fnShowToast('환불 신청이 완료되었습니다. 환불 금액: ' + refundAmount.toLocaleString() + '원');
												setTimeout(function () {
													self.modal.show = true;
												}, 1500);

											} else {
												self.modal.show = true;
											}
										} else {
											self.fnShowToast(res.message || '교환 신청 실패');
										}
									},
									error: function () {
										self.isSubmitting = false;
										self.fnShowToast('서버 오류');
									}
								});
							},

							fnSearchAddr: function () {
								var self = this;
								new daum.Postcode({
									oncomplete: function (data) {
										var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
										self.pickup.zipcode = data.zonecode;
										self.pickup.address = addr;
										self.$nextTick(function () {
											if (self.$refs.detailAddrInput) self.$refs.detailAddrInput.focus();
										});
									}
								}).open();
							},

							fnCanNext: function () {
								if (this.currentStep === 1) {
									var optionOk = true;
									if (this.availableOptions.length > 0) {
										optionOk = !!this.selectedOptionId;
									}
									return !!this.selectedReason && !!this.exchangeMethod && optionOk;
								}
								if (this.currentStep === 2) {
									if (this.exchangeMethod === 'PICKUP')
										return !!this.pickup.address && !!this.pickup.detailAddress;
									return true;
								}
								return true;
							},

							fnNext: function () {
								if (!this.fnCanNext()) { this.fnShowToast('필수 항목을 입력해 주세요.'); return; }
								if (this.currentStep < 3) {
									this.currentStep++;
									window.scrollTo({ top: 0, behavior: 'smooth' });
								} else {
									this.fnSubmit();
								}
							},

							fnPrev: function () {
								if (this.currentStep > 1) {
									this.currentStep--;
									window.scrollTo({ top: 0, behavior: 'smooth' });
								} else {
									history.back();
								}
							},

							fnReasonLabel: function (val) {
								var r = this.reasonList.find(function (r) { return r.value === val; });
								return r ? r.label : '-';
							},
							fnPrice: function (v) { return Number(v || 0).toLocaleString() + '원'; },
							fnCountChar: function () {
								if (this.reasonDetail.length > 300) this.reasonDetail = this.reasonDetail.slice(0, 300);
							},
							fnShowToast: function (msg) {
								var t = document.getElementById('toast');
								if (!t) return;
								t.textContent = msg;
								t.classList.add('show');
								setTimeout(function () { t.classList.remove('show'); }, 2400);
							},
							fnCloseModal: function () { this.modal.show = false; },
							fnGoHistory: function () { location.href = '/order/history.do'; },
							fnGoMain: function () { location.href = '/main.do'; }
						},

						mounted: function () { this.fnInit(); }
					});

					app.mount('#app');
				</script>

	</body>

	</html>