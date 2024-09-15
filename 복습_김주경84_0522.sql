-- 모든 멤버 정보를 조회하는 쿼리
select * from member;

-- 모든 구매 정보를 조회하는 쿼리
select * from buy;

-- in
-- 다중 값들이 존재할 때 그 값이 있는가?
-- 맥북프로, 아이폰, 에어팟 이게 있는 값인가?
-- 맥북프로 = ?
-- 세 가지 다중 값에서 있는지 없는지 체크한다.

-- 특정 제품들(맥북프로, 아이폰, 에어팟)이 포함된 구매 정보를 조회하는 쿼리
select * from buy
    where prod_name in ('맥북프로', '아이폰', '에어팟');

-- 특정 제품들(맥북프로, 아이폰, 에어팟)을 제외한 구매 정보를 조회하는 쿼리
select * from buy
    where prod_name NOT IN ('맥북프로', '아이폰', '에어팟');

-- like 문자열의 일부를 검색하는 경우 사용
-- ex) 청 으로 시작하는 경우의 값만 추출한다.
-- ex) 제일 앞 글자가 청이고 그 뒤에는 무엇이 와도 된다.
-- ex) 어떤 글자가 오는데 끝이 청인 경우

-- '청'으로 시작하는 제품명을 가진 구매 정보를 조회하는 쿼리
select * from buy
    where prod_name like '청%';

-- '청'으로 끝나는 제품명을 가진 구매 정보를 조회하는 쿼리
select * from buy
    where prod_name like '%청';

-- 제품명에 '청'이 포함된 구매 정보를 조회하는 쿼리
select * from buy
    where prod_name like '%청%';

-- 정확히 '청'이라는 제품명을 가진 구매 정보를 조회하는 쿼리
select * from buy
    where prod_name like '청';

-- '핑크'라는 이름을 가진 멤버 정보를 조회하는 쿼리
select * from member
    where mem_name like '핑크';

-- 우리가 배웠던 여러 조건들을 좀 더 사용해 보자!

-- 일단 멤버수는 12명 미만, 경남에만 살면 안 된다, 키는 170 미만
select * from member
    where mem_number < 12
    and addr != '경남'
    and height < 170;

-- 맥북프로, 에어팟, 아이폰이고 price, amount를 곱한 tot 가격이 1000 미만인 값들만 추출

select mem_id
    , price * amount as tot
    , price
    , amount
    from buy
        where prod_name in ('맥북프로', '아이폰', '에어팟')
        and price * amount < 1000;

-- 컬럼의 이름을 변경할 수 있다. as 별칭의 개념으로 설정할 수 있다.
-- 컬럼 쓰고 바뀔 컬럼명만 써도 바뀐다.
select * from buy;

-- 나열의 방법 order by
-- ex) mem_number로 내림차순, 오름차순 정렬해보자!
-- 디폴트는 오름차순
-- 내림차순은 desc
-- 수치정렬, 문자정렬도 가능
select * from member
order by mem_number;

select * from member
order by mem_number desc;

select * from member
order by mem_name desc;

select * from member
order by debut_date;

-- limit문
-- 제한을 걸어서 원하는 데이터 값만 몇 개 추출
-- 5개만 출력해라 -> limit 5

select * from member
order by mem_name
limit 5;

-- select
-- from
-- where
-- groupby
-- having
-- orderby
-- limit

-- 왜 이런 순서로 해야 하는지?

select * from member
where addr = '경기'
order by mem_number;
-- where addr = '경기'; where이 아래로 내려가면 오류 발생

-- 중복제거 (중요함)
-- 중복된 값을 제거하는 것

-- 값의 개수를 셀 수 있는 함수
-- 10개 행의 값
-- distinct

select count(*) from member;

select distinct(addr) from member;
select * from member;

-- groupby
-- 집계하여서 값을 통계치를 뽑는 것
-- 기준에 따라서 데이터를 묶어서 해당 묶은 값들의 요약 통계치 등을 통해 데이터를 요약할 수 있다.
-- group by를 쓰기 위해서는 요약 통계치나 통계관련된 함수를 같이 사용해야 한다.

-- sum()
-- avg()
-- min()
-- max()
-- count()
-- count(distinct())
-- 위의 집계함수 사용시 도메인 무자형, 수치형인 것 잘 확인해서 사용해야 한다.
-- select 문에 집계함수를 같이 사용해서 쿼리 작성하는 것

select count(mem_name) from member;
select count(distinct(mem_name)) from member;
-- 중복된 값이 있는지 없는지 간단하게 살펴볼 수 있는 쿼리

-- 이대로 하면 오류 발생
-- select * from member;
    -- 이 상태로만 하면 오류 발생 group by mem_name;

select mem_name
    , sum(mem_number)
    , sum(addr)
    , sum(height)
    , count(addr)
    from member
    group by mem_name;

select * from member;

select count(mem_id) from buy;

select count(distinct(mem_id)) from buy;

select mem_id
    , sum(price)
    , sum(amount)
    , avg(price)
    , avg(amount)
    from buy
    group by mem_id;

select * from buy;

-- having
-- group by를 한 상태에서 조건을 걸 때 사용한다.
-- group by를 한 상태로 어떠한 조건을 걸어서 데이터를 추출할 때 사용한다!!
-- group by는 having 친구다.

select mem_id
    ,sum(price)
    from buy
group by mem_id
having sum(price) > 280;

select * from buy;
-- price 15 이상, 아이폰, 에어팟, 맥북프로를 가진 그룹의 price의 평균과 amount avg 얼마인가?

select * from buy
where price >= 15
and prod_name in ('맥북프로', '에어팟', '아이폰');
-- group by mem_id; (문법 오류 발생)

-- having 절을 이용해서 조건으로 수식을 바꿔보자
-- ex) mem_id의 평균 price 100 이상인 경우와 amount 2 이상인 경우의 데이터를 추출

select mem_id
, sum(price)
, sum(amount)
from buy
group by mem_id
having sum(price) > 100
and sum(amount) > 2;

-- 그룹화된 데이터를 조회하는 예제
-- ex) 각 제품별로 구매 수량의 합계를 조회한다.
SELECT prod_name, SUM(amount) as total_amount
    FROM buy
    GROUP BY prod_name;

-- 그룹화된 데이터 중 특정 조건을 만족하는 데이터를 조회하는 예제
-- ex) 구매 수량이 3을 초과하는 제품들의 구매 수량 합계를 조회한다.
SELECT prod_name, SUM(amount) as total_amount
    FROM buy
    GROUP BY prod_name
    HAVING SUM(amount) > 3;

-- 데이터를 정렬하여 조회하는 예제
-- ex) 가격을 기준으로 오름차순 정렬 후 조회한다.
SELECT * FROM buy
    ORDER BY price ASC;