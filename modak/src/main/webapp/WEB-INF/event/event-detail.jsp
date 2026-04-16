<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>상품 상세 - 가헤코리</title>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
			rel="stylesheet">
		<style>
			*,
			*::before,
			*::after {
				box-sizing: border-box;
				margin: 0;
				padding: 0;
			}

			:root {
				--bg: #f5f0ea;
				--surface: #fff;
				--orange: #e07a3b;
				--orange-dark: #c96830;
				--orange-light: #fdf0e8;
				--text: #2c2c2a;
				--muted: #888;
				--light: #bbb;
				--border: #e5ddd4;
				--radius: 10px;
				--star: #f4a839;
				--blue: #3a8be0;
				--blue-light: #eef5fd;
				--green: #2eaa6e;
				--green-light: #eaf8f1;
				--red: #e04b3a;
				--red-light: #fdecea;
				--yellow: #f0b429;
			}

			body {
				background: var(--bg);
				font-family: 'Noto Sans KR', sans-serif;
				color: var(--text);
				font-size: 14px;
				line-height: 1.6;
			}

			header {
				background: var(--surface);
				border-bottom: 1px solid var(--border);
				padding: 0 32px;
				height: 52px;
				display: flex;
				align-items: center;
				justify-content: space-between;
				position: sticky;
				top: 0;
				z-index: 200;
			}

			.logo {
				font-size: 17px;
				font-weight: 700;
			}

			.h-right {
				display: flex;
				align-items: center;
				gap: 14px;
			}

			.icon-btn {
				background: none;
				border: none;
				cursor: pointer;
				font-size: 18px;
				padding: 4px;
				position: relative;
			}

			.badge {
				position: absolute;
				top: -2px;
				right: -4px;
				background: var(--orange);
				color: #fff;
				border-radius: 50%;
				font-size: 9px;
				font-weight: 700;
				width: 16px;
				height: 16px;
				display: flex;
				align-items: center;
				justify-content: center;
			}

			.btn-out {
				background: none;
				border: 1px solid var(--border);
				border-radius: 6px;
				padding: 5px 12px;
				font-size: 12px;
				cursor: pointer;
				font-family: inherit;
			}

			.nav-strip {
				background: var(--surface);
				border-bottom: 1px solid var(--border);
				padding: 0 32px;
				display: flex;
				overflow-x: auto;
			}

			.ntab {
				padding: 10px 15px;
				font-size: 13px;
				color: var(--muted);
				cursor: pointer;
				border-bottom: 2px solid transparent;
				white-space: nowrap;
			}

			.ntab.on {
				color: var(--orange);
				border-bottom-color: var(--orange);
				font-weight: 500;
			}

			.crumb {
				padding: 10px 32px;
				font-size: 12px;
				color: var(--light);
				display: flex;
				gap: 5px;
			}

			.crumb a {
				color: var(--light);
				text-decoration: none;
			}

			.wrap {
				max-width: 1100px;
				margin: 0 auto;
				padding: 0 24px 60px;
			}

			.ptop {
				display: grid;
				grid-template-columns: 460px 1fr;
				gap: 40px;
				margin-bottom: 48px;
			}

			/* gallery */
			.gallery {
				display: flex;
				flex-direction: column;
				gap: 12px;
			}

			.gm {
				background: var(--surface);
				border-radius: var(--radius);
				border: 1px solid var(--border);
				aspect-ratio: 1/1;
				display: flex;
				align-items: center;
				justify-content: center;
				position: relative;
				overflow: hidden;
			}

			.gem {
				font-size: 140px;
				filter: drop-shadow(0 4px 12px rgba(0, 0, 0, 0.08));
			}

			.gtag {
				position: absolute;
				top: 14px;
				left: 14px;
				background: var(--orange);
				color: #fff;
				font-size: 11px;
				font-weight: 700;
				padding: 3px 8px;
				border-radius: 4px;
			}

			.gthumbs {
				display: flex;
				gap: 8px;
			}

			.gth {
				width: 80px;
				height: 80px;
				background: var(--surface);
				border-radius: 8px;
				border: 1.5px solid var(--border);
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 30px;
				cursor: pointer;
				transition: border-color .15s;
			}

			.gth.on,
			.gth:hover {
				border-color: var(--orange);
			}

			/* info */
			.pinfo {
				display: flex;
				flex-direction: column;
			}

			.pbrand {
				font-size: 12px;
				color: var(--muted);
				margin-bottom: 5px;
			}

			.ptitle {
				font-size: 20px;
				font-weight: 700;
				line-height: 1.35;
				margin-bottom: 10px;
			}

			.rrow {
				display: flex;
				align-items: center;
				gap: 10px;
				margin-bottom: 14px;
			}

			.stars {
				display: flex;
				gap: 1px;
			}

			.st {
				color: var(--star);
				font-size: 13px;
			}

			/* MODE TOGGLE */
			.mtog {
				display: flex;
				background: var(--bg);
				border-radius: 10px;
				padding: 4px;
				gap: 4px;
				margin-bottom: 14px;
				border: 1px solid var(--border);
			}

			.mbtn {
				flex: 1;
				padding: 9px;
				border-radius: 7px;
				border: none;
				background: none;
				font-size: 14px;
				font-weight: 500;
				cursor: pointer;
				font-family: inherit;
				color: var(--muted);
				transition: all .2s;
				display: flex;
				align-items: center;
				justify-content: center;
				gap: 6px;
			}

			.mbtn.on {
				background: var(--surface);
				color: var(--orange);
				box-shadow: 0 1px 4px rgba(0, 0, 0, .1);
			}

			/* price */
			.pbox-buy {
				background: var(--orange-light);
				border-radius: 8px;
				padding: 14px 16px;
				margin-bottom: 14px;
			}

			.prow {
				display: flex;
				align-items: baseline;
				gap: 10px;
			}

			.pct {
				font-size: 22px;
				font-weight: 700;
				color: var(--orange);
			}

			.pnow {
				font-size: 26px;
				font-weight: 700;
			}

			.porig {
				font-size: 13px;
				color: var(--light);
				text-decoration: line-through;
				margin-top: 2px;
			}

			.pnote {
				font-size: 12px;
				color: var(--muted);
				margin-top: 6px;
			}

			.pbox-rent {
				background: var(--blue-light);
				border-radius: 8px;
				padding: 14px 16px;
				margin-bottom: 14px;
				border: 1px solid #c5daf5;
			}

			.rent-per {
				font-size: 13px;
				color: var(--blue);
				font-weight: 500;
			}

			.rent-num {
				font-size: 26px;
				font-weight: 700;
			}

			.rent-unit {
				font-size: 13px;
				color: var(--muted);
			}

			.div {
				border: none;
				border-top: 1px solid var(--border);
				margin: 12px 0;
			}

			/* options */
			.osec {
				margin-bottom: 11px;
			}

			.olabel {
				font-size: 13px;
				font-weight: 500;
				margin-bottom: 6px;
				display: flex;
				align-items: center;
				gap: 6px;
			}

			.ochips {
				display: flex;
				flex-wrap: wrap;
				gap: 6px;
			}

			.chip {
				padding: 5px 13px;
				border-radius: 20px;
				border: 1px solid var(--border);
				font-size: 13px;
				cursor: pointer;
				background: var(--surface);
				transition: all .15s;
			}

			.chip:hover {
				border-color: var(--orange);
				color: var(--orange);
			}

			.chip.on {
				background: var(--orange);
				border-color: var(--orange);
				color: #fff;
				font-weight: 500;
			}

			.chip.off {
				opacity: .35;
				cursor: not-allowed;
				text-decoration: line-through;
			}

			.qrow {
				display: flex;
			}

			.qbtn {
				width: 34px;
				height: 34px;
				border: 1px solid var(--border);
				background: var(--surface);
				cursor: pointer;
				font-size: 18px;
				display: flex;
				align-items: center;
				justify-content: center;
			}

			.qbtn:first-child {
				border-radius: 6px 0 0 6px;
			}

			.qbtn:last-child {
				border-radius: 0 6px 6px 0;
			}

			.qbtn:hover {
				background: var(--bg);
			}

			.qinp {
				width: 48px;
				height: 34px;
				border: 1px solid var(--border);
				border-left: none;
				border-right: none;
				text-align: center;
				font-size: 14px;
				font-family: inherit;
				background: var(--surface);
			}

			.qinp:focus {
				outline: none;
			}

			/* ─── CALENDAR ─── */
			.calsec {
				margin-bottom: 12px;
			}

			.calwrap {
				background: var(--surface);
				border: 1px solid var(--border);
				border-radius: 10px;
				overflow: hidden;
			}

			.calhead {
				display: flex;
				align-items: center;
				justify-content: space-between;
				padding: 13px 16px 9px;
				border-bottom: 1px solid var(--border);
			}

			.cnav {
				background: none;
				border: none;
				cursor: pointer;
				font-size: 18px;
				color: var(--muted);
				padding: 2px 8px;
				border-radius: 5px;
			}

			.cnav:hover {
				background: var(--bg);
			}

			.cmonth {
				font-size: 15px;
				font-weight: 700;
			}

			.calgrid {
				padding: 10px 12px 12px;
			}

			.calwds {
				display: grid;
				grid-template-columns: repeat(7, 1fr);
				margin-bottom: 3px;
			}

			.cwd {
				text-align: center;
				font-size: 11px;
				font-weight: 500;
				color: var(--muted);
				padding: 4px 0;
			}

			.caldays {
				display: grid;
				grid-template-columns: repeat(7, 1fr);
				gap: 2px;
			}

			.cday {
				aspect-ratio: 1/1;
				display: flex;
				flex-direction: column;
				align-items: center;
				justify-content: center;
				border-radius: 8px;
				cursor: pointer;
				font-size: 13px;
				position: relative;
				transition: all .12s;
				user-select: none;
			}

			.cday:hover:not(.emp):not(.past):not(.nos) {
				background: var(--orange-light);
				color: var(--orange);
			}

			.cday.emp {
				cursor: default;
			}

			.cday.past {
				color: var(--light);
				cursor: not-allowed;
			}

			.cday.sun {
				color: var(--red);
			}

			.cday.sat {
				color: var(--blue);
			}

			.cday.past.sun,
			.cday.past.sat {
				color: var(--light);
			}

			.cday.td {
				font-weight: 700;
			}

			.cday.td::after {
				content: '';
				position: absolute;
				bottom: 3px;
				left: 50%;
				transform: translateX(-50%);
				width: 4px;
				height: 4px;
				border-radius: 50%;
				background: var(--orange);
			}

			.cday.nos {
				color: var(--light);
				cursor: not-allowed;
			}

			.sdot {
				width: 5px;
				height: 5px;
				border-radius: 50%;
				position: absolute;
				bottom: 3px;
				left: 50%;
				transform: translateX(-50%);
			}

			.cday.low .sdot {
				background: var(--yellow);
			}

			.cday.mid .sdot,
			.cday.ful .sdot {
				background: var(--green);
			}

			.cday.nos .sdot {
				background: #ddd;
			}

			/* range */
			.cday.rs {
				background: var(--orange) !important;
				color: #fff !important;
				border-radius: 8px 0 0 8px;
			}

			.cday.re {
				background: var(--orange) !important;
				color: #fff !important;
				border-radius: 0 8px 8px 0;
			}

			.cday.rs.re {
				border-radius: 8px;
			}

			.cday.ir {
				background: var(--orange-light);
				color: var(--orange);
				border-radius: 0;
			}

			.cday.rs .sdot,
			.cday.re .sdot,
			.cday.ir .sdot {
				display: none;
			}

			.cday.rs::after,
			.cday.re::after {
				display: none;
			}

			.leg {
				display: flex;
				gap: 16px;
				padding: 9px 14px;
				border-top: 1px solid var(--border);
				background: #faf8f5;
				flex-wrap: wrap;
			}

			.litem {
				display: flex;
				align-items: center;
				gap: 5px;
				font-size: 11px;
				color: var(--muted);
			}

			.ldot {
				width: 8px;
				height: 8px;
				border-radius: 50%;
			}

			.ddisp {
				display: grid;
				grid-template-columns: 1fr auto 1fr;
				gap: 8px;
				align-items: center;
				margin-top: 10px;
			}

			.dbox {
				background: var(--bg);
				border: 1.5px solid var(--border);
				border-radius: 8px;
				padding: 10px 12px;
			}

			.dbox.fl {
				border-color: var(--orange);
				background: var(--orange-light);
			}

			.dlbl {
				font-size: 11px;
				color: var(--muted);
				font-weight: 500;
				margin-bottom: 2px;
			}

			.dval {
				font-size: 14px;
				font-weight: 700;
			}

			.dbox.fl .dval {
				color: var(--orange);
			}

			.darr {
				font-size: 18px;
				color: var(--muted);
				text-align: center;
			}

			.rstatus {
				border-radius: 7px;
				padding: 8px 10px;
				font-size: 12px;
				font-weight: 500;
				margin-top: 8px;
				display: none;
			}

			.rstatus.good {
				background: var(--green-light);
				color: var(--green);
				display: flex;
				align-items: center;
				gap: 6px;
			}

			.rstatus.warn {
				background: #fff8e6;
				color: #b07a10;
				display: flex;
				align-items: center;
				gap: 6px;
			}

			.rstatus.none {
				background: var(--red-light);
				color: var(--red);
				display: flex;
				align-items: center;
				gap: 6px;
			}

			.rsum {
				background: var(--blue-light);
				border: 1px solid #c5daf5;
				border-radius: 8px;
				padding: 14px 16px;
				margin-top: 10px;
				display: none;
			}

			.rsum.show {
				display: block;
			}

			.rsrow {
				display: flex;
				justify-content: space-between;
				align-items: center;
				font-size: 13px;
				margin-bottom: 6px;
			}

			.rsrow:last-child {
				margin-bottom: 0;
				padding-top: 8px;
				border-top: 1px solid #c5daf5;
			}

			.rskey {
				color: var(--muted);
			}

			.rsval {
				font-weight: 500;
			}

			.rstotal {
				font-size: 18px;
				font-weight: 700;
				color: var(--blue) !important;
			}

			/* action */
			.selbox {
				background: #faf7f4;
				border: 1px solid var(--border);
				border-radius: 8px;
				padding: 11px 14px;
				margin: 12px 0;
				display: flex;
				align-items: center;
				justify-content: space-between;
			}

			.trow {
				display: flex;
				justify-content: space-between;
				align-items: center;
				padding-bottom: 12px;
			}

			.tprice {
				font-size: 22px;
				font-weight: 700;
				color: var(--orange);
			}

			.arow {
				display: flex;
				gap: 10px;
				margin-top: 2px;
			}

			.bwish {
				width: 48px;
				height: 48px;
				border: 1.5px solid var(--border);
				background: var(--surface);
				border-radius: 8px;
				font-size: 20px;
				cursor: pointer;
				display: flex;
				align-items: center;
				justify-content: center;
				transition: all .15s;
				flex-shrink: 0;
			}

			.bwish:hover,
			.bwish.on {
				border-color: #e04b6a;
			}

			.bcart {
				flex: 1;
				height: 48px;
				border: 1.5px solid var(--orange);
				background: var(--surface);
				border-radius: 8px;
				font-size: 14px;
				font-weight: 700;
				color: var(--orange);
				cursor: pointer;
				font-family: inherit;
			}

			.bcart:hover {
				background: var(--orange-light);
			}

			.bbuy {
				flex: 1;
				height: 48px;
				border: none;
				background: var(--orange);
				border-radius: 8px;
				font-size: 14px;
				font-weight: 700;
				color: #fff;
				cursor: pointer;
				font-family: inherit;
			}

			.bbuy:hover {
				background: var(--orange-dark);
			}

			.brent {
				flex: 1;
				height: 48px;
				border: none;
				background: var(--blue);
				border-radius: 8px;
				font-size: 14px;
				font-weight: 700;
				color: #fff;
				cursor: pointer;
				font-family: inherit;
				transition: all .15s;
			}

			.brent:hover:not(:disabled) {
				background: #2d7ad4;
			}

			.brent:disabled {
				background: #b0c9ec;
				cursor: not-allowed;
			}

			.delbox {
				background: var(--surface);
				border: 1px solid var(--border);
				border-radius: 8px;
				padding: 11px 14px;
				margin-top: 12px;
				display: flex;
				flex-direction: column;
				gap: 7px;
			}

			.drow {
				display: flex;
				gap: 14px;
				font-size: 12px;
			}

			.dkey {
				color: var(--muted);
				min-width: 60px;
			}

			.dv strong {
				color: var(--orange);
				font-weight: 700;
			}

			/* show/hide by mode */
			.buy-only {}

			.rent-only {
				display: none;
			}

			body.rent .buy-only {
				display: none;
			}

			body.rent .rent-only {
				display: block;
			}

			/* tabs */
			.tnav {
				display: flex;
				border-bottom: 2px solid var(--border);
				background: var(--surface);
				border-radius: var(--radius) var(--radius) 0 0;
			}

			.tbtn {
				flex: 1;
				padding: 13px;
				font-size: 13px;
				font-weight: 500;
				background: none;
				border: none;
				cursor: pointer;
				color: var(--muted);
				font-family: inherit;
				border-bottom: 2px solid transparent;
				margin-bottom: -2px;
				transition: color .15s;
			}

			.tbtn.on {
				color: var(--orange);
				border-bottom-color: var(--orange);
			}

			.tcont {
				background: var(--surface);
				border-radius: 0 0 var(--radius) var(--radius);
				padding: 26px;
				border: 1px solid var(--border);
				border-top: none;
			}

			.tpane {
				display: none;
			}

			.tpane.on {
				display: block;
			}

			.spec {
				width: 100%;
				border-collapse: collapse;
				font-size: 13px;
			}

			.spec th,
			.spec td {
				padding: 9px 13px;
				border-bottom: 1px solid var(--border);
				text-align: left;
			}

			.spec th {
				background: #faf7f4;
				color: var(--muted);
				font-weight: 500;
				width: 150px;
			}

			.flist {
				display: grid;
				grid-template-columns: 1fr 1fr;
				gap: 10px;
				margin: 14px 0;
			}

			.fi {
				display: flex;
				gap: 10px;
				background: var(--bg);
				border-radius: 8px;
				padding: 11px;
			}

			.fic {
				font-size: 20px;
				flex-shrink: 0;
			}

			.fit h4 {
				font-size: 13px;
				font-weight: 700;
				margin-bottom: 2px;
			}

			.fit p {
				font-size: 12px;
				color: var(--muted);
			}

			.rsum2 {
				display: flex;
				gap: 32px;
				align-items: center;
				background: var(--bg);
				border-radius: 10px;
				padding: 18px;
				margin-bottom: 18px;
			}

			.rbig .rn {
				font-size: 46px;
				font-weight: 700;
				line-height: 1;
			}

			.rbig .ro {
				font-size: 12px;
				color: var(--muted);
				margin-top: 4px;
			}

			.rbars {
				flex: 1;
				display: flex;
				flex-direction: column;
				gap: 5px;
			}

			.bbar {
				display: flex;
				align-items: center;
				gap: 8px;
				font-size: 12px;
			}

			.blbl {
				color: var(--muted);
				min-width: 24px;
				text-align: right;
			}

			.btrk {
				flex: 1;
				height: 6px;
				background: #e8e0d8;
				border-radius: 3px;
				overflow: hidden;
			}

			.bfil {
				height: 100%;
				background: var(--star);
				border-radius: 3px;
			}

			.bcnt {
				color: var(--light);
				min-width: 28px;
			}

			.rcard {
				border: 1px solid var(--border);
				border-radius: 8px;
				padding: 13px;
				margin-bottom: 10px;
			}

			.rhead {
				display: flex;
				justify-content: space-between;
				margin-bottom: 6px;
			}

			.rname {
				font-size: 13px;
				font-weight: 500;
			}

			.rdate {
				font-size: 12px;
				color: var(--light);
			}

			.rtext {
				font-size: 13px;
				line-height: 1.65;
			}

			.rprod {
				font-size: 11px;
				color: var(--muted);
				margin-top: 5px;
			}

			.rhelprow {
				margin-top: 6px;
				font-size: 12px;
				color: var(--muted);
				display: flex;
				gap: 8px;
				align-items: center;
			}

			.hbtn {
				background: none;
				border: 1px solid var(--border);
				border-radius: 4px;
				padding: 2px 8px;
				cursor: pointer;
				font-size: 12px;
				font-family: inherit;
				color: var(--muted);
			}

			.hbtn:hover {
				border-color: var(--orange);
				color: var(--orange);
			}

			.rel {
				margin-top: 44px;
			}

			.sectl {
				font-size: 17px;
				font-weight: 700;
				margin-bottom: 16px;
			}

			.rgrid {
				display: grid;
				grid-template-columns: repeat(4, 1fr);
				gap: 13px;
			}

			.pcard {
				background: var(--surface);
				border-radius: var(--radius);
				border: 1px solid var(--border);
				overflow: hidden;
				cursor: pointer;
				transition: transform .15s, box-shadow .15s;
			}

			.pcard:hover {
				transform: translateY(-3px);
				box-shadow: 0 8px 24px rgba(0, 0, 0, .08);
			}

			.pcimg {
				aspect-ratio: 1/1;
				background: #faf7f4;
				display: flex;
				align-items: center;
				justify-content: center;
				font-size: 58px;
				position: relative;
			}

			.pcbdg {
				position: absolute;
				top: 8px;
				left: 8px;
				background: var(--orange);
				color: #fff;
				font-size: 10px;
				font-weight: 700;
				padding: 2px 6px;
				border-radius: 3px;
			}

			.pcbody {
				padding: 10px;
			}

			.pcbr {
				font-size: 11px;
				color: var(--muted);
				margin-bottom: 2px;
			}

			.pcnm {
				font-size: 12px;
				font-weight: 500;
				line-height: 1.4;
				margin-bottom: 4px;
			}

			.pcs {
				display: flex;
				align-items: center;
				gap: 3px;
				font-size: 11px;
				color: var(--muted);
				margin-bottom: 4px;
			}

			.pcs .s {
				color: var(--star);
			}

			.pcprice {
				font-size: 14px;
				font-weight: 700;
			}

			.pcacts {
				display: flex;
				gap: 5px;
				margin-top: 7px;
			}

			.pca1 {
				flex: 1;
				padding: 6px;
				border: 1px solid var(--orange);
				background: none;
				border-radius: 5px;
				font-size: 11px;
				color: var(--orange);
				cursor: pointer;
				font-family: inherit;
				font-weight: 500;
			}

			.pca2 {
				flex: 1;
				padding: 6px;
				background: var(--orange);
				border: none;
				border-radius: 5px;
				font-size: 11px;
				color: #fff;
				cursor: pointer;
				font-family: inherit;
				font-weight: 500;
			}
		</style>
	</head>

	<body>

		<header>
			<div class="logo">가헤코리</div>
			<div class="h-right">
				<button class="icon-btn">🔍</button>
				<button class="icon-btn">🤍</button>
				<button class="icon-btn">🛒<span class="badge">3</span></button>
				<button class="btn-out">로그 아웃</button>
			</div>
		</header>

		<nav class="nav-strip">
			<div class="ntab">⛺ 캠핑 전체</div>
			<div class="ntab on">🔥 텐트</div>
			<div class="ntab">🌿 침낭·매트</div>
			<div class="ntab">🪓 취사도구</div>
			<div class="ntab">💡 조명</div>
			<div class="ntab">🎒 배낭·가방</div>
			<div class="ntab">🧥 의류·신발</div>
			<div class="ntab">📦 기타 용품</div>
		</nav>

		<div class="wrap">
			<div class="crumb"><a href="#">홈</a> › <a href="#">캠핑 장비</a> › <a href="#">텐트</a> › <span
					style="color:var(--muted)">헬리녹스 쿠투 GT 1인용 텐트</span></div>

			<div class="ptop">
				<!-- GALLERY -->
				<div class="gallery">
					<div class="gm">
						<span class="gtag">베스트</span>
						<div class="gem" id="gem">⛺</div>
					</div>
					<div class="gthumbs">
						<div class="gth on" onclick="setGem('⛺',this)">⛺</div>
						<div class="gth" onclick="setGem('🏕️',this)">🏕️</div>
						<div class="gth" onclick="setGem('🔦',this)">🔦</div>
						<div class="gth" onclick="setGem('🎒',this)">🎒</div>
						<div class="gth" onclick="setGem('🌙',this)">🌙</div>
					</div>
				</div>

				<!-- INFO -->
				<div class="pinfo">
					<div class="pbrand">헬리녹스 · 텐트/쉘터</div>
					<h1 class="ptitle">헬리녹스 쿠투 GT 1인용 텐트<br>경량 백패킹 전천후</h1>
					<div class="rrow">
						<div class="stars"><span class="st">★</span><span class="st">★</span><span
								class="st">★</span><span class="st">★</span><span class="st" style="color:#ddd">★</span>
						</div>
						<span style="font-size:13px;font-weight:500">4.3</span>
						<span style="font-size:12px;color:var(--muted)"><a href="#"
								style="color:var(--orange);text-decoration:none">(리뷰 119개)</a> | 구매·대여 238회</span>
					</div>

					<!-- MODE TOGGLE -->
					<div class="mtog">
						<button class="mbtn on" id="mb-buy" onclick="setMode('buy')">🛒 구매하기</button>
						<button class="mbtn" id="mb-rent" onclick="setMode('rent')">📅 대여하기</button>
					</div>

					<!-- BUY PRICE -->
					<div class="buy-only">
						<div class="pbox-buy">
							<div class="prow"><span class="pct">16%</span><span class="pnow">42,000원</span></div>
							<div class="porig">50,000원</div>
							<div class="pnote">💳 카드사 추가 최대 5% 할인 적용 가능</div>
						</div>
					</div>

					<!-- RENT PRICE -->
					<div class="rent-only">
						<div class="pbox-rent">
							<div class="prow"><span class="rent-per">1박당</span><span class="rent-num">8,000원</span><span
									class="rent-unit"> / 박</span></div>
							<div style="font-size:12px;color:var(--muted);margin-top:4px">3박 이상 <strong
									style="color:var(--blue)">10% 할인</strong> · 7박 이상 <strong
									style="color:var(--blue)">20% 할인</strong></div>
							<div style="font-size:12px;color:var(--muted);margin-top:3px">⏱ 반납일 오전 10시까지 · 연체 시 1일
								12,000원</div>
						</div>
					</div>

					<hr class="div">

					<!-- 색상 (공통) -->
					<div class="osec">
						<div class="olabel">색상</div>
						<div class="ochips">
							<div class="chip on" onclick="pickChip(this,'col')">블랙</div>
							<div class="chip" onclick="pickChip(this,'col')">오렌지</div>
							<div class="chip" onclick="pickChip(this,'col')">그린</div>
							<div class="chip off">화이트 (품절)</div>
						</div>
					</div>

					<!-- BUY OPTIONS -->
					<div class="buy-only">
						<div class="osec">
							<div class="olabel">옵션</div>
							<div class="ochips">
								<div class="chip on" onclick="pickChip(this,'opt')">텐트 단품</div>
								<div class="chip" onclick="pickChip(this,'opt')">텐트 + 풋프린트</div>
								<div class="chip" onclick="pickChip(this,'opt')">텐트 + 스노우 스커트</div>
							</div>
						</div>
						<div class="osec">
							<div class="olabel">수량</div>
							<div class="qrow">
								<button class="qbtn" onclick="chgQ(-1)">−</button>
								<input class="qinp" id="qinp" type="number" value="1" min="1" max="99" readonly>
								<button class="qbtn" onclick="chgQ(1)">+</button>
							</div>
						</div>
						<div class="selbox">
							<span style="font-size:13px">블랙 / 텐트 단품 / <span id="qdsp">1</span>개</span>
							<span style="font-size:15px;font-weight:700" id="bprice">42,000원</span>
						</div>
						<div class="trow">
							<span style="font-size:13px;color:var(--muted)">총 상품금액</span>
							<span class="tprice" id="btotal">42,000원</span>
						</div>
						<div class="arow">
							<button class="bwish" id="wb1" onclick="togWish()">🤍</button>
							<button class="bcart">장바구니 담기</button>
							<button class="bbuy">바로 구매하기</button>
						</div>
					</div>

					<!-- RENT CALENDAR -->
					<div class="rent-only">
						<div class="calsec">
							<div class="olabel">
								📅 대여 날짜 선택
								<span style="font-size:11px;color:var(--muted);font-weight:400">시작일 → 반납일 순서로 클릭</span>
							</div>

							<div class="calwrap">
								<div class="calhead">
									<button class="cnav" onclick="prevMo()">‹</button>
									<span class="cmonth" id="cmlbl"></span>
									<button class="cnav" onclick="nextMo()">›</button>
								</div>
								<div class="calgrid">
									<div class="calwds">
										<div class="cwd" style="color:var(--red)">일</div>
										<div class="cwd">월</div>
										<div class="cwd">화</div>
										<div class="cwd">수</div>
										<div class="cwd">목</div>
										<div class="cwd">금</div>
										<div class="cwd" style="color:var(--blue)">토</div>
									</div>
									<div class="caldays" id="cdays"></div>
								</div>
								<div class="leg">
									<div class="litem">
										<div class="ldot" style="background:var(--green)"></div> 여유 (5개↑)
									</div>
									<div class="litem">
										<div class="ldot" style="background:var(--yellow)"></div> 적음 (1~4개)
									</div>
									<div class="litem">
										<div class="ldot" style="background:#ddd"></div> 재고 없음
									</div>
									<div class="litem" style="margin-left:auto;font-size:11px;color:var(--muted)">● 오늘
									</div>
								</div>
							</div>

							<!-- 날짜 표시 -->
							<div class="ddisp">
								<div class="dbox" id="ds">
									<div class="dlbl">📦 대여 시작일</div>
									<div class="dval" id="dsv" style="font-size:13px;color:var(--muted)">날짜를 선택하세요</div>
								</div>
								<div class="darr">→</div>
								<div class="dbox" id="de">
									<div class="dlbl">🏠 반납일</div>
									<div class="dval" id="dev" style="font-size:13px;color:var(--muted)">날짜를 선택하세요</div>
								</div>
							</div>

							<!-- 재고 상태 -->
							<div id="stockEl"></div>

							<!-- 대여 요금 요약 -->
							<div class="rsum" id="rsumEl">
								<div class="rsrow"><span class="rskey">대여 기간</span><span class="rsval"
										id="rsDays">—</span></div>
								<div class="rsrow"><span class="rskey">기본 요금</span><span class="rsval"
										id="rsBase">—</span></div>
								<div class="rsrow" id="rsDiscRow" style="display:none"><span class="rskey"
										id="rsDiscLbl">할인</span><span class="rsval" style="color:var(--blue)"
										id="rsDsc">—</span></div>
								<div class="rsrow"><span class="rskey" style="font-weight:600">최종 대여 금액</span><span
										class="rsval rstotal" id="rsTotal">—</span></div>
							</div>
						</div>

						<div class="arow">
							<button class="bwish" id="wb2" onclick="togWish()">🤍</button>
							<button class="brent" id="rentBtn" disabled>날짜를 선택해 주세요</button>
						</div>
					</div>

					<!-- DELIVERY -->
					<div class="delbox">
						<div class="drow buy-only"><span class="dkey">배송</span><span class="dv"><strong>무료배송</strong> ·
								오늘 주문 시 내일 도착</span></div>
						<div class="drow rent-only"><span class="dkey">수령/반납</span><span class="dv"><strong>무료
									배송</strong> 또는 매장 직수령 · 반납일 오전 10시까지</span></div>
						<div class="drow"><span class="dkey">반품</span><span class="dv">구매 후 30일 이내 무료 반품</span></div>
						<div class="drow"><span class="dkey">적립</span><span class="dv buy-only"><strong>420포인트</strong>
								적립</span><span class="dv rent-only">대여 확정 시 <strong>80포인트/박</strong> 적립</span></div>
					</div>
				</div>
			</div>

			<!-- TABS -->
			<div>
				<div class="tnav">
					<button class="tbtn on" onclick="stab('det',this)">상품 정보</button>
					<button class="tbtn" onclick="stab('rev',this)">리뷰 (119)</button>
					<button class="tbtn" onclick="stab('qna',this)">Q&amp;A (12)</button>
					<button class="tbtn" onclick="stab('shp',this)">배송/대여 안내</button>
				</div>
				<div class="tcont">
					<div class="tpane on" id="tp-det">
						<h3 style="font-size:15px;font-weight:700;margin-bottom:12px">🏕️ 제품 특징</h3>
						<div class="flist">
							<div class="fi">
								<div class="fic">⚡</div>
								<div class="fit">
									<h4>초경량 설계</h4>
									<p>총 중량 1.38kg, 장거리 백패킹 최적화.</p>
								</div>
							</div>
							<div class="fi">
								<div class="fic">💧</div>
								<div class="fit">
									<h4>방수 성능</h4>
									<p>내수압 3,000mm 이상 고성능 방수 코팅.</p>
								</div>
							</div>
							<div class="fi">
								<div class="fic">🌬️</div>
								<div class="fit">
									<h4>통기성 이중 구조</h4>
									<p>결로 최소화, 쾌적한 내부 유지.</p>
								</div>
							</div>
							<div class="fi">
								<div class="fic">🛠️</div>
								<div class="fit">
									<h4>간편 설치</h4>
									<p>색상 구분 폴+클립 시스템, 10분 내 설치.</p>
								</div>
							</div>
						</div>
						<hr class="div" style="margin:18px 0">
						<h3 style="font-size:15px;font-weight:700;margin-bottom:12px">📋 상품 스펙</h3>
						<table class="spec">
							<tr>
								<th>브랜드</th>
								<td>헬리녹스 (Helinox)</td>
							</tr>
							<tr>
								<th>수용 인원</th>
								<td>1인용</td>
							</tr>
							<tr>
								<th>전개 사이즈</th>
								<td>220 × 90 × 105 cm</td>
							</tr>
							<tr>
								<th>총 중량</th>
								<td>1,380g</td>
							</tr>
							<tr>
								<th>소재 (외피)</th>
								<td>20D 나일론 립스탑 (내수압 3,000mm)</td>
							</tr>
							<tr>
								<th>폴 소재</th>
								<td>DAC 알루미늄 합금</td>
							</tr>
							<tr>
								<th>원산지</th>
								<td>대한민국</td>
							</tr>
						</table>
					</div>
					<div class="tpane" id="tp-rev">
						<div class="rsum2">
							<div class="rbig">
								<div class="rn">4.3</div>
								<div class="stars" style="justify-content:center;display:flex;margin:5px 0"><span
										class="st">★</span><span class="st">★</span><span class="st">★</span><span
										class="st">★</span><span class="st" style="color:#ddd">★</span></div>
								<div class="ro">119개 리뷰</div>
							</div>
							<div class="rbars">
								<div class="bbar"><span class="blbl">5점</span>
									<div class="btrk">
										<div class="bfil" style="width:55%"></div>
									</div><span class="bcnt">65</span>
								</div>
								<div class="bbar"><span class="blbl">4점</span>
									<div class="btrk">
										<div class="bfil" style="width:25%"></div>
									</div><span class="bcnt">30</span>
								</div>
								<div class="bbar"><span class="blbl">3점</span>
									<div class="btrk">
										<div class="bfil" style="width:12%"></div>
									</div><span class="bcnt">14</span>
								</div>
								<div class="bbar"><span class="blbl">2점</span>
									<div class="btrk">
										<div class="bfil" style="width:5%"></div>
									</div><span class="bcnt">6</span>
								</div>
								<div class="bbar"><span class="blbl">1점</span>
									<div class="btrk">
										<div class="bfil" style="width:3%"></div>
									</div><span class="bcnt">4</span>
								</div>
							</div>
						</div>
						<div class="rcard">
							<div class="rhead">
								<div>
									<div class="rname">hyun****</div>
									<div class="stars" style="display:flex;gap:1px;margin-top:3px"><span class="st"
											style="font-size:12px">★</span><span class="st"
											style="font-size:12px">★</span><span class="st"
											style="font-size:12px">★</span><span class="st"
											style="font-size:12px">★</span><span class="st"
											style="font-size:12px">★</span></div>
								</div>
								<div class="rdate">2025.11.12</div>
							</div>
							<div class="rtext">백패킹 갈 때마다 챙기는 텐트입니다. 무게가 정말 가볍고 설치가 쉬워요. 강원도 한겨울에도 결로가 거의 없어서 놀랐습니다!
							</div>
							<div class="rprod">블랙 / 구매</div>
							<div class="rhelprow"><span>도움이 됐나요?</span><button class="hbtn">👍 도움돼요 (23)</button></div>
						</div>
						<div class="rcard">
							<div class="rhead">
								<div>
									<div class="rname">park****</div>
									<div class="stars" style="display:flex;gap:1px;margin-top:3px"><span class="st"
											style="font-size:12px">★</span><span class="st"
											style="font-size:12px">★</span><span class="st"
											style="font-size:12px">★</span><span class="st"
											style="font-size:12px">★</span><span
											style="font-size:12px;color:#ddd">★</span></div>
								</div>
								<div class="rdate">2025.10.28</div>
							</div>
							<div class="rtext">대여로 먼저 써보고 너무 좋아서 구매했습니다. 방수 성능이 탁월해요!</div>
							<div class="rprod">오렌지 / 대여 후 구매</div>
							<div class="rhelprow"><span>도움이 됐나요?</span><button class="hbtn">👍 도움돼요 (17)</button></div>
						</div>
					</div>
					<div class="tpane" id="tp-qna">
						<div style="text-align:center;padding:36px 0;color:var(--muted)">
							<div style="font-size:36px;margin-bottom:10px">💬</div>
							<p style="font-size:15px;font-weight:500;margin-bottom:4px">Q&A가 12개 있습니다</p>
							<p style="font-size:13px">궁금한 점을 남겨주세요. 평균 24시간 내 답변합니다.</p>
							<button
								style="margin-top:14px;background:var(--orange);color:#fff;border:none;border-radius:8px;padding:10px 24px;font-size:14px;cursor:pointer;font-family:inherit;font-weight:500">문의하기</button>
						</div>
					</div>
					<div class="tpane" id="tp-shp">
						<table class="spec">
							<tr>
								<th>배송 방법</th>
								<td>택배 (CJ 대한통운) 또는 매장 직수령</td>
							</tr>
							<tr>
								<th>배송비</th>
								<td>무료배송 (제주·도서산간 +3,000원)</td>
							</tr>
							<tr>
								<th>대여 반납</th>
								<td>반납일 오전 10시까지 · 택배 반납 가능</td>
							</tr>
							<tr>
								<th>연체 요금</th>
								<td>1일당 12,000원 (대여가의 150%)</td>
							</tr>
							<tr>
								<th>파손/분실</th>
								<td>수리 비용 또는 정가의 80% 배상</td>
							</tr>
							<tr>
								<th>반품/교환</th>
								<td>수령 후 30일 이내 (구매 상품)</td>
							</tr>
						</table>
					</div>
				</div>
			</div>

			<!-- RELATED -->
			<div class="rel">
				<h2 class="sectl">함께 대여하면 좋은 상품</h2>
				<div class="rgrid">
					<div class="pcard">
						<div class="pcimg"><span class="pcbdg">베스트</span>🏕️</div>
						<div class="pcbody">
							<div class="pcbr">스노우피크</div>
							<div class="pcnm">스노우피크 랜드록 2024</div>
							<div class="pcs"><span class="s">★</span> 4.8 (176)</div>
							<div class="pcprice">35,000원</div>
							<div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div>
						</div>
					</div>
					<div class="pcard">
						<div class="pcimg">🔦</div>
						<div class="pcbody">
							<div class="pcbr">블랙다이아몬드</div>
							<div class="pcnm">캠프 나이오 리액터 헤드랜턴</div>
							<div class="pcs"><span class="s">★</span> 4.7 (88)</div>
							<div class="pcprice">3,500원</div>
							<div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div>
						</div>
					</div>
					<div class="pcard">
						<div class="pcimg"><span class="pcbdg" style="background:#3ab5e0">NEW</span>🎒</div>
						<div class="pcbody">
							<div class="pcbr">그레고리</div>
							<div class="pcnm">그레고리 발토로 75L</div>
							<div class="pcs"><span class="s">★</span> 4.5 (71)</div>
							<div class="pcprice">15,000원</div>
							<div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div>
						</div>
					</div>
					<div class="pcard">
						<div class="pcimg">🔥</div>
						<div class="pcbody">
							<div class="pcbr">MSR</div>
							<div class="pcnm">MSR 드래곤플라이 멀티연료 버너</div>
							<div class="pcs"><span class="s">★</span> 4.5 (93)</div>
							<div class="pcprice">9,000원</div>
							<div class="pcacts"><button class="pca1">대여</button><button class="pca2">구매</button></div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<script>
			// gallery
			function setGem(e, el) {document.getElementById('gem').textContent = e; document.querySelectorAll('.gth').forEach(t => t.classList.remove('on')); el.classList.add('on');}

			// mode
			function setMode(m) {
				const r = m === 'rent';
				document.getElementById('mb-buy').classList.toggle('on', !r);
				document.getElementById('mb-rent').classList.toggle('on', r);
				document.body.classList.toggle('rent', r);
			}

			// chips
			function pickChip(el, g) {el.closest('.ochips').querySelectorAll('.chip:not(.off)').forEach(c => c.classList.remove('on')); el.classList.add('on'); updBuy();}

			// buy qty
			let qty = 1; const BP = 42000;
			function chgQ(d) {qty = Math.max(1, Math.min(99, qty + d)); document.getElementById('qinp').value = qty; document.getElementById('qdsp').textContent = qty; updBuy();}
			function updBuy() {const t = (BP * qty).toLocaleString('ko-KR') + '원'; document.getElementById('bprice').textContent = t; document.getElementById('btotal').textContent = t;}

			// wish
			let wished = false;
			function togWish() {wished = !wished;['wb1', 'wb2'].forEach(id => {const b = document.getElementById(id); if (b) {b.textContent = wished ? '❤️' : '🤍'; b.classList.toggle('on', wished);} });}

			// tabs
			function stab(n, el) {document.querySelectorAll('.tbtn').forEach(b => b.classList.remove('on')); document.querySelectorAll('.tpane').forEach(p => p.classList.remove('on')); el.classList.add('on'); document.getElementById('tp-' + n).classList.add('on');}

			// ─── CALENDAR ───
			const today = new Date(); today.setHours(0, 0, 0, 0);
			let calY = today.getFullYear(), calM = today.getMonth();
			let rS = null, rE = null, picking = false;

			function stk(ds) {let h = 0; for (const c of ds) {h = (h * 31 + c.charCodeAt(0)) & 0xffffffff;} const v = Math.abs(h) % 10; if (v < 2) return 0; if (v < 5) return Math.abs(h) % 3 + 1; return Math.abs(h) % 5 + 5;}
			function ds(y, m, d) {return `${y}-${String(m + 1).padStart(2, '0')}-${String(d).padStart(2, '0')}`;}
			function fmt(dt) {const d = ['일', '월', '화', '수', '목', '금', '토']; return `${dt.getFullYear()}년 ${dt.getMonth() + 1}월 ${dt.getDate()}일 (${d[dt.getDay()]})`;}

			function drawCal() {
				document.getElementById('cmlbl').textContent = `${calY}년 ${calM + 1}월`;
				const first = new Date(calY, calM, 1).getDay();
				const last = new Date(calY, calM + 1, 0).getDate();
				const g = document.getElementById('cdays');
				g.innerHTML = '';
				for (let i = 0; i < first; i++) {const e = document.createElement('div'); e.className = 'cday emp'; g.appendChild(e);}
				for (let d = 1; d <= last; d++) {
					const str = ds(calY, calM, d);
					const dt = new Date(calY, calM, d);
					const past = dt < today;
					const dow = dt.getDay();
					const stk2 = stk(str);
					const el = document.createElement('div');
					el.className = 'cday';
					if (past) el.classList.add('past');
					if (dow === 0 && !past) el.classList.add('sun');
					if (dow === 6 && !past) el.classList.add('sat');
					if (dt.getTime() === today.getTime()) el.classList.add('td');
					if (!past) {
						if (stk2 === 0) el.classList.add('nos');
						else if (stk2 <= 4) el.classList.add('low');
						else el.classList.add('ful');
						const dot = document.createElement('div'); dot.className = 'sdot'; el.appendChild(dot);
					}
					// range
					if (rS && rE) {
						const s = rS.getTime(), e = rE.getTime(), t = dt.getTime();
						if (t === s) el.classList.add('rs');
						else if (t === e) el.classList.add('re');
						else if (t > s && t < e) el.classList.add('ir');
					} else if (rS && dt.getTime() === rS.getTime()) el.classList.add('rs');
					const num = document.createElement('span'); num.textContent = d; el.prepend(num);
					if (!past && stk2 > 0) el.addEventListener('click', () => onDay(dt, stk2));
					g.appendChild(el);
				}
			}

			function onDay(dt, stk2) {
				if (!rS || (!picking && rE)) {rS = dt; rE = null; picking = true; updDates(); drawCal(); return;}
				if (picking) {
					if (dt < rS) {rS = dt; picking = true; updDates(); drawCal(); return;}
					rE = dt; picking = false;
					updDates(); chkRange(); updSum(); drawCal();
				}
			}

			function chkRange() {
				if (!rS || !rE) return;
				let mn = 999, cur = new Date(rS);
				while (cur <= rE) {mn = Math.min(mn, stk(ds(cur.getFullYear(), cur.getMonth(), cur.getDate()))); cur.setDate(cur.getDate() + 1);}
				const el = document.getElementById('stockEl');
				const rb = document.getElementById('rentBtn');
				if (mn === 0) {el.innerHTML = '<div class="rstatus none">⚠️ 선택 기간 중 재고가 없는 날짜가 있습니다. 다른 날짜를 선택해 주세요.</div>'; rb.disabled = true; rb.textContent = '해당 기간 대여 불가';}
				else if (mn <= 4) {el.innerHTML = `<div class="rstatus warn">⚡ 선택 기간 내 최소 재고 ${mn}개 남았습니다!</div>`; rb.disabled = false; rb.textContent = '대여 신청하기';}
				else {el.innerHTML = `<div class="rstatus good">✅ 선택 기간 내 재고 충분 (최소 ${mn}개 이상)</div>`; rb.disabled = false; rb.textContent = '대여 신청하기';}
			}

			function updDates() {
				const ds2 = document.getElementById('ds'), de = document.getElementById('de');
				const dsv = document.getElementById('dsv'), dev = document.getElementById('dev');
				if (rS) {dsv.textContent = fmt(rS); dsv.style.color = 'var(--text)'; dsv.style.fontSize = '13px'; ds2.classList.add('fl');}
				else {dsv.textContent = '날짜를 선택하세요'; dsv.style.color = 'var(--muted)'; ds2.classList.remove('fl');}
				if (rE) {dev.textContent = fmt(rE); dev.style.color = 'var(--text)'; dev.style.fontSize = '13px'; de.classList.add('fl');}
				else {dev.textContent = '날짜를 선택하세요'; dev.style.color = 'var(--muted)'; de.classList.remove('fl');}
				if (!rE) {document.getElementById('stockEl').innerHTML = ''; document.getElementById('rsumEl').classList.remove('show'); const rb = document.getElementById('rentBtn'); rb.disabled = true; rb.textContent = rS ? '반납일을 선택해 주세요' : '날짜를 선택해 주세요';}
			}

			function updSum() {
				if (!rS || !rE) return;
				const nights = Math.round((rE - rS) / 86400000);
				if (nights <= 0) return;
				const base = 8000 * nights;
				let disc = 0, dlbl = '';
				if (nights >= 7) {disc = Math.round(base * .2); dlbl = '7박 이상 20% 할인';}
				else if (nights >= 3) {disc = Math.round(base * .1); dlbl = '3박 이상 10% 할인';}
				const total = base - disc;
				document.getElementById('rsDays').textContent = `${nights}박 ${nights + 1}일`;
				document.getElementById('rsBase').textContent = `${base.toLocaleString('ko-KR')}원 (8,000원 × ${nights}박)`;
				const dr = document.getElementById('rsDiscRow');
				if (disc > 0) {dr.style.display = 'flex'; document.getElementById('rsDiscLbl').textContent = dlbl; document.getElementById('rsDsc').textContent = `- ${disc.toLocaleString('ko-KR')}원`;}
				else dr.style.display = 'none';
				document.getElementById('rsTotal').textContent = `${total.toLocaleString('ko-KR')}원`;
				document.getElementById('rsumEl').classList.add('show');
			}

			function prevMo() {calM--; if (calM < 0) {calM = 11; calY--;} drawCal();}
			function nextMo() {calM++; if (calM > 11) {calM = 0; calY++;} drawCal();}

			drawCal();
		</script>
	</body>

	</html>


	<script>
		const app = Vue.createApp({
			data() {
				return {
					eventId: "${map.eventId}",
					info: {}
				};
			},
			methods: {
				// 함수(메소드) - (key : function())

				fnGetInfo: function () {
					let self = this;
					let param = {
						eventId: self.eventId
					};
					$.ajax({
						url: "http://localhost:8080/event/detail.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							console.log(data);
							self.info = data.info;
						}
					});
				}
			}, // methods
			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
				self.fnGetInfo();
			}
		});

		app.mount('#app');
	</script>