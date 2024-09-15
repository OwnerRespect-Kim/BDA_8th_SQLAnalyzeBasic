Select * from member;
Select * from buy;
## 두 테이블의 공통되는 컬럼명은 mem_id -> mem_id가 키 값이 된다.

### inner join (내부조인)
Select m.mem_id, m.addr, m.height, b.price, b.amount from member m # member table의 별칭을 m으로 지정했다.
inner join buy b # 두 번째 테이블
on m.mem_id = b.mem_id
where b.price < 100;

## buy 테이블의 mem_id 컬럼을 보면 중복되는 이름이 많다.
## 중복을 제거해보자. -> Distinct를 사용한다.
Select distinct m.mem_id
    from member m
inner join buy b
on m.mem_id = b.mem_id;

### outer join(left, right) / 외부조인

Select distinct m.mem_id, m.addr, m.height, b.price, b.amount from member m
left outer join buy b
on m.mem_id = b.mem_id;
## left outer join의 경우 왼쪽 테이블의 내용은 모두 출력이 되어야 한다.
## 즉, 여기서는 먼저 불러온 테이블인 member 테이블의 내용은 모두 출력이 되어야 한다.

## right outer join의 경우 반대이다. 즉, buy 테이블의 내용이 모두 출력이 되어야 한다.
Select distinct m.mem_id, m.addr, m.height, b.price, b.amount from member m
right outer join buy b
on m.mem_id = b.mem_id;

### cross join 상호조인
## 한쪽 테이블의 모든 행과 다른쪽 테이블의 모든행을 조인하는 것이다.
## 즉, 양쪽 테이블의 내용이 모두 출력이 되야 한다.
Select count(*) from buy
cross join member;
## 크로스 조인의 출력 결과는 두 테이블의 행 수간의 곱이다.
## 즉 member 테이블과 buy 테이블의 크로스 조인 결과는 120이다.

### self join
## 다른 테이블로 join하는 것이 아닌 내가 나를 join 해서 테이블을 새롭게 만드는 것이다.
## 테이블을 일단 새로 만들어보자.
Create table example_table (example_rank char(4), major char(4), number varchar(8));

Insert into example_table values('리더', null, '0001');
Insert into example_table values('재무이사', '리더', '0002');
Insert into example_table values('회계이사', '리더', '0003');
Insert into example_table values('금융이사', '리더', '0004');
Insert into example_table values('재무팀장', '재무이사', '0002-0');
Insert into example_table values('회계팀장', '회계이사', '0003-0');
Insert into example_table values('금융팀장', '금융이사', '0004-0');
Insert into example_table values('금융팀원', '금융팀원', '0004-0-0');

Select * from example_table;

## 팀장들의 직속 상관을 알고 싶다.
Select a.example_rank, b.example_rank, b.number from example_table a
inner join example_table b
on a.major = b.example_rank;

## 자세히 설명하면 다음과 같다.
    ## 재무이사
## a 테이블에서 example_rank가 '재무이사'이고, major는 '리더'인 경우.
## b 테이블에서 example_rank가 '리더'인 행을 찾는다.
## b 테이블에서 example_rank가 '리더'인 행은 number가 '0001'이다.
## 따라서, a.example_rank는 '재무이사', b.example_rank는 '리더', b.number는 '0001'이다.

    ## 회계이사
## a 테이블에서 example_rank가 '회계이사'이고, major는 '리더'이다.
## b 테이블에서 example_rank가 '리더'인 행을 찾는다.
## b 테이블에서 example_rank가 '리더'인 행은 number가 '0001'이다.
## 따라서, a.example_rank는 '회계이사', b.example_rank는 '리더', b.number는 '0001'이다.

    ## 금융이사
## a 테이블에서 example_rank가 '금융이사'이고, major는 '리더'이다.
## b 테이블에서 example_rank가 '리더'인 행을 이다.
## b 테이블에서 example_rank가 '리더'인 행은 number가 '0001'이다.
## 따라서, a.example_rank는 '금융이사', b.example_rank는 '리더', b.number는 '0001'이다.
## 이와 같이, 재무이사, 회계이사, 금융이사의 major가 모두 '리더'이기 때문에,
    ## 이들 세 행은 모두 '리더'와 조인되어 number 값이 '0001'인 결과를 출력한다.

#### Union & Union all : 합쳐질 때 같은 컬럼을 사용해야 한다.
### Union
### 두 개의 테이블을 합칠 때 중복을 제거하여 준다.
Select mem_id, mem_name from member
where mem_number <= 8
union
Select mem_id, mem_name from member
where mem_number <= 8;

### Union all
### 두 개의 테이블을 합칠 때 중복을 포함한다.
Select mem_id, mem_name from member
where mem_number <= 8
union all
Select mem_id, mem_name from member
where mem_number <= 8;

### 서브쿼리(subquery)
## 조인하지 않은 상태에서 다른 테이블과 일치하는 행을 찾거나 조인 결과를 다시 조인할 때 사용할 수 있다.
## 소괄호()로 감싸서 사용한다.
## 서브쿼리는 메인쿼리를 실행하기 전에 1번만 실행된다.
## 비교 연산자와 함께 서브 쿼리를 사용할 경우 서브 쿼리를 연산자 오른쪽에 기술
## 서브쿼리 내부에서 정렬을 order by를 사용할 수 없다.
## where, from, select 어디 위치에 들어가냐에 따라 서브쿼리가 달라진다.

## where 절에 넣어서 서브쿼리를 만들어보자.
## 아래 코드는 오류가 발생한다 -> where 조건에 하나의 값이 나와야 하는데, 다중값이 나오게 되기 때문이다.
Select * from member
where height = (Select * from member where height > 164);

Select * from member
where mem_id = (Select mem_id from member where height > 167); # 소녀시대만 출력이 된다.

## 다른 테이블의 쿼리를 사용해서 서브쿼리로 응용할 수 있다.
Select * from member
where mem_id = (Select mem_id from buy where prod_name = '맥북프로');

## 서브쿼리에서 나는 다중값을 꼭 사용하고 싶다.
## in 문법을 사용한다.
Select * from member
where mem_name in ('소녀시대', '트와이스');

## 앞서서 오류가 발생했던 코드에 '=' 대신 in을 사용하여 출력해보자.
Select * from member
where mem_id in (Select mem_id from member where height > 164);

## 서브쿼리 내에서 join을 사용해서 내용을 출력해보자.
SELECT * FROM member
WHERE mem_id NOT IN (
    SELECT m.mem_id FROM member m
    INNER JOIN buy b ON m.mem_id = b.mem_id
    WHERE m.mem_number < 8 AND m.height < 166
);

# 서브 쿼리 해석
#   SELECT m.mem_id FROM member m
#   INNER JOIN buy b ON m.mem_id = b.mem_id
#   WHERE m.mem_number < 8 AND m.height < 166
# 이 쿼리는 member와 buy 테이블을 조인하여 mem_number이 8 미만이고 height가 166 미만인 mem_id를 찾는다.
# 메인 쿼리 해석
# 서브쿼리의 결과에 포함되지 않는 mem_id를 가진 멤버를 반환

### any
## any 연산자는 서브쿼리 결과에서 값이 하나라도 만족하는 조건으로 데이터를 조회할 수 있다.
SELECT * FROM member
WHERE mem_id = any (
    SELECT m.mem_id FROM member m
    INNER JOIN buy b ON m.mem_id = b.mem_id
    WHERE m.mem_number < 8 AND m.height < 166
);

### Exists
### not Exists의 반대
### subquery의 결과값이 있는지 없는지를 확인해서 1행이라도 있으면 True, 없으면 False이다.
select count(*) from member # 주쿼리
where not Exists (select mem_id from member where height > 170);

select count(*) from member # 주쿼리
where not Exists (select mem_id from member where height < 169);