INSERT INTO `bda_Bnew`.`bda_member` (`member_id`, `member_name`, `member_score`) VALUES ('20241239', '정지영', '99');

select * from bda_member;


DROP DATABASE IF EXISTS market_db; -- 만약 market_db가 존재하면 우선 삭제한다.
CREATE DATABASE market_db;

USE market_db;
CREATE TABLE member -- 회원 테이블
( mem_id  		CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  mem_name    	VARCHAR(10) NOT NULL, -- 이름
  mem_number    INT NOT NULL,  -- 인원수
  addr	  		CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  phone1		CHAR(3), -- 연락처의 국번(02, 031, 055 등)
  phone2		CHAR(8), -- 연락처의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 평균 키
  debut_date	DATE  -- 데뷔 일자
);
CREATE TABLE buy -- 구매 테이블
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   mem_id  	CHAR(8) NOT NULL, -- 아이디(FK)
   prod_name 	CHAR(6) NOT NULL, --  제품이름
   group_name 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 가격
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (mem_id) REFERENCES member(mem_id)
);

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015.10.19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016.08.08');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015.01.15');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015.04.21');
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007.08.02');
INSERT INTO member VALUES('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019.02.12');
INSERT INTO member VALUES('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014.08.01');
INSERT INTO member VALUES('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011.02.10');
INSERT INTO member VALUES('SPC', '우주소녀', 13, '서울', '02', '88888888', 162, '2016.02.25');
INSERT INTO member VALUES('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014.06.19');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '아이폰', '디지털', 200, 5);
INSERT INTO buy VALUES(NULL, 'BLK', '청바지', '패션', 50, 3);
INSERT INTO buy VALUES(NULL, 'MMU', '에어팟', '디지털', 80, 10);
INSERT INTO buy VALUES(NULL, 'GRL', '혼공SQL', '서적', 15, 5);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 2);
INSERT INTO buy VALUES(NULL, 'APN', '청바지', '패션', 50, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 1);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 4);

select * from member;
select * from buy;

select * from member;
select * from buy;

### SQL기초 문법
### select from where 기본적인 뼈대 구조
### select *(전체컬럼 다 가지고 와!) from table명이 온다. 그 후에 where
## ; 마무리를 하지 않으면 간혹 에러가 날 수 있다.

select * from member;

## 내가 원하는 속성만 몇 개 가지고 오자!
select mem_name, addr, phone1 from member;

select * from member;

## 내가 원하는 순서로 뒤집을 수 있다.

select phone2, mem_id from member;

## buy테이블을 가지고 오자!

select * from buy;
select num, mem_id, prod_name from buy
limit 5;

select * from member;

## SQL의 문법 구조 ##
## select 열_(속성)이름
## from 테이블명
## where 조건식
## group by 열(속성)명
## having 조건식 -> group by를 통한 해당 데이터셋의 조건절
## order by 열(속성)명 정렬
## limit 숫자 ( 원하는 데이터 크기만 출력 )


### where 조건까지 추가 하기
##1.  where 절을 추가해서 주소가 경기인 사람만 출력!
##2. mem_name 블랙핑크 출력
##3. mem_number 6명 이상인 경우
select * from member;

## 1. 조건 주소가 서울인 경우
select *
	from member
		where addr = '서울';

## 2.mem_name 여자친구
select *
	from member
		where mem_name = '여자친구';

## 3.mem_number 7 이상인 경우
select *
	from member
		where mem_number >= 7;

## 내가 원하는 컬럼 추출이 가능하다.
## 예를 들어서 데뷔일자만 출력

select debut_date
	from member
		where mem_name = '트와이스';

## where 조건을 2개 이상 사용해보자 !
## and , or 사용하면 된다.

select * from member;

# 멤버수 7 이상이면서 키 164 이하인 경우
select * from member
	where mem_number >= 7
    and height <= 164;

## between and 로 구간의 값을 출력하자
## 키가 165~170 데이터만 추출해야 하는 경우

select * from member
	where height between 165 and 170;