## from 절에 들어가는 서브쿼리
## 인라인 뷰 inline view
## from 문에서 사용한 서브쿼리 결과는 테이블처럼 사용된다.
## 다른 테이블과 다시 조인할 수 있다. 쿼리를 격리할 수 있다.

## where 절에 조건
Select * from member
where mem_id in (select mem_id from member where mem_number > 1);
### 위 코드의 동작 방식
### 1. Subquery 실행 SELECT mem_id FROM member WHERE mem_number > 1;
### : 이 쿼리는 'mem_number'가 1보다 큰 모든 'mem_id' 값을 반환한다.
### 2. Main Query 실행 SELECT * FROM member WHERE mem_id IN (Subquery 반환값)
### : 메인 쿼리는 서브 쿼리 결과 리스트에 있는 'mem_id' 값을 가진 모든 행을 'member' 테이블에서 선택한다.

## 테이블처럼 사용된다
Select mem_id, mem_number from member where mem_number > 1;
### 위 코드의 동작 방식
### 'mem_number'가 1보다 큰 모든 'mem_id'와 'mem_number' 값을 반환한다.

Select * from buy; ## buy 테이블은 member 테이블과 'mem_id'이라는 같은 이름을 가진 칼럼이 있다.

Select m.mem_id, m.addr, m.phone1 from member m
inner join buy b
on m.mem_id = b.mem_id;
### 위 코드의 동작 방식
### 1. FROM 절 : 'member' 테이블을 'm'이라는 별칭으로 참조하며, 'buy' 테이블을 'b'라는 별칭으로 참조한다.
### 2. INNER JOIN : 두 테이블에서 'mem_id'가 일치하는 행들만 결합한다.
     # 즉, 'member'와 'buy' 테이블 모두에 존재하는 'mem_id' 값이 있는 행들만 결과에 포함된다.
### 3. SELECT : 조인된 결과에서 'm.mem_id', 'm.addr', 'm.phone1' 열을 선택한다.

### inner join
Select m.mem_id, m.addr, m.phone1 from member m
inner join (select * from buy where price > 200) b
on m.mem_id = b.mem_id;
### 위 코드의 동작 방식
### 1. Subquery : 'buy' 테이블에서 'price'가 200보다 큰 행들만 선택한다.
### 2. Main Query : 'member' 테이블을 'm'이라는 별칭으로 참조하며, 'buy' 테이블을 'b'라는 별칭으로 참조한다.
     # 그 다음 'member' 테이블과 서브쿼리 결과를 'mem_id' 열을 기준으로 조인한다.
     # 조인된 결과에서 'm.mem_id', 'm.dr',ad 'm.phone1' 열을 선택한다.
## 참고
## select * from buy where price > 200 조건 자체가 블랙핑크밖에 없음 (바로 위 코드의 Subquery이다.)
select * from buy where price > 200;
select * from (select * from buy where price > 200) as b;

### Select문 subquery
## 스칼라 서브쿼리
## 무조건 반드시 1개의 행을 반환해야 하며 sum, count, min, max 등의 집계 함수와 사용하는 경우가 많다.
## 양식 : select 내가 원하는 컬럼, 출력값의 기준

select mem_id from buy;

select * from member;

select (select mem_id from member where addr = '경기') from buy;
### 위 코드의 동작 방식
### 1. Subquery : 'addr'이 '경기'인 'member' 테이블의 모든 'mem_id'를 반환한다.
    # 이 때 데이터에서 'addr'이 '경기'인 'mem_id'는 'APN'과 'WMN'이다.
### 2. Main Query : 'buy' 테이블의 각 행마다 서브쿼리를 실행한다.
    # 각 행에 대해 'member' 테이블에서 'addr'이 '경기'인 'mem_id' 값을 가져오려고 시도한다.
### 실행 결과로 오류가 발생한다. 'buy' 테이블에서 'mem_id'가 'APN'인 행은 4개가 있기 때문이다.
    # 서브쿼리는 단일 값만을 반환할 수 있다.

select (select mem_id from member where addr = '경북') as new_star, mem_id from buy;
### 위 코드의 동작 방식
### 1. Subquery : 'addr'이 '경북'인 모든 'mem_id' 값을 반환한다.
    # 이 때 데이터에서 'addr'이 '경북'인 'mem_id'는 'RED'이다.
### 2. Main Query : 'buy' 테이블의 각 행마다 서브쿼리를 실행한다.
    # 'addr'이 '경북'인 'member' 테이블의 'mem_id'값을 'new_star'라는 별칭으로 반환
    # 'buy' 테이블의 각 행에 대해 'new_star' 값은 동일하게 서브쿼리 결과인 'RED'가 된다.

select
# Subquery 시작
(select m.mem_id from member m
inner join (select * from buy where price > 200) b
on m.mem_id = b.mem_id) # Subquery 끝
as new_variable from buy
where price > 300;
### 위 코드의 동작 방식
### 1. Subquery : 'price'가 200보다 큰 'buy' 테이블의 행들과 'member' 테이블을 'mem_id'를 기준으로 조인한다.
    # 이 때 조인의 결과는 'price'가 200을 초과하는 모든 'mem_id' 값들을 반환한다.
### 2. Main Query : SELECT (Subquery의 반환 값) AS new_variable FROM buy WHERE price > 300;
    # 'buy' 테이블에서 'price'가 300보다 큰 행들을 필터링하고, 필터링한 행에 대해 서브쿼리가 실행되며 값을 반환한다.

## from 절에 있는 member join 시켰다. 해당 join된 값만 mem_id 출력을 한다.
select mem_name,
(select mem_id from buy b where b.price > 500),
(select mem_id from buy b where b.mem_id = m.mem_id and b.price > 500),
'에어팟2'
from member m;
### 위 코드의 동작 방식
### 1. 첫 번째 Subquery : 'buy' 테이블에서 'price'가 500을 초과하는 모든 'mem_id'를 반환하려고 한다.
    # 이 때 데이터에서 'price'가 500을 초과하는 'mem_id'는 'BLK' 하나이다.
### 2. 두 번째 Subquery : 'buy' 테이블에서 'member' 테이블의 'mem_id'와 일치하고, 'price'가 500을 초과하는 'mem_id'를 반환한다.
### 3. Main Query : 'member' 테이블을 'm'이라는 별칭으로 참조한다.
    # 'member' 테이블의 'mem_name', 첫 번째 Subquery의 반환 결과, 두 번째 Subquery의 반환 결과, '에어팟2'를 선택하여 반환한다.
    # '에어팟2'는 모든 행에서 동일한 문자열 '에어팟2'를 반환한다.

select * from customers; # customerNumber key 값
select * from orders; # orderNumber key 값,
# 위의 두 테이블은 칼럼 중 customerNumber라는 같은 칼럼명을 가지고 있다.

select count(*) from customers;
# 위 테이블의 행 개수를 반환한다. (122개이다.)

## 중복에 대한 체크 방법
select count(customerNumber), customerNumber from customers
group by customerNumber
having count(customerNumber) > 1;
### 위 코드의 동작 방식
### 1. GROUP BY customerNumber : 'customers' 테이블의 'customerNumber' 열을 기준으로 데이터를 그룹화한다.
    # 이 후 같은 'customerNumber' 값을 가진 행들을 하나의 그룹으로 묶는다.
### 2. COUNT(customerNumber) : 각 그룹에 속한 행의 수를 센다.
### 3. HAVING COUNT(customerNumber) : 'HAVING' 절은 'GROUP BY'절로 그룹화된 각 그룹에 대해 조건을 지정한다.
    # 여기서는 각 그룹의 행 수가 1보다 큰 그룹만 선택한다. 즉, 같은 'customerNumber'가 2번 이상 나타나는 경우만 결과에 포함된다.

select count(city) from customers;
# 위 customers 테이블 중 city 컬럼의 행 개수를 반환한다. (122개이다.)

select count(city), city from customers
group by city
having count(city) > 1;
### 위 코드의 동작 방식
### 1. GROUP BY city : 'customers' 테이블의 'city' 열을 기준으로 데이터를 그룹화한다.
    # 이 후 같은 'city' 값을 가진 행들을 하나의 그룹으로 묶는다.
### 2. COUNT(city) : 각 그룹에 속한 행의 수를 센다.
### 3. HAVING COUNT(city) : 'HAVING' 절은 'GROUP BY'절로 그룹화된 각 그룹에 대해 조건을 지정한다.
    # 여기서는 각 그룹의 행 수가 1보다 큰 그룹만 선택한다. 즉, 같은 'city'가 2번 이상 나타나는 경우만 결과에 포함된다.

## 중복에 대한 체크 방법 검증
## 위에서 city의 값이 'NYC'인 행이 5개였다.
select * from customers
where city = 'NYC'; # 5개의 행이 필터링이 된다.

# 왼쪽 기준 (350개)
select * from customers c
left join orders o
on c.customerNumber = o.customerNumber;

select count(*) from customers c
left join orders o
on c.customerNumber = o.customerNumber;

# 오른쪽 기준 (320개)
select * from customers c
right join orders o
on c.customerNumber = o.customerNumber;

select count(*) from customers c
right join orders o
on c.customerNumber = o.customerNumber;

## 찍히는 개수가 다르다.

select count(c.customerNumber), c.customerNumber from customers c
left join orders o
on c.customerNumber = o.customerNumber
group by c.customerNumber;

## order 문제가 있는 것인가?
select count(customerNumber), customerNumber from orders
group by customerNumber
having count(customerNumber);

select * from orders
where customerNumber = 103;