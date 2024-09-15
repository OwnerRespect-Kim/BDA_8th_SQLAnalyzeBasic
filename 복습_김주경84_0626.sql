## 데이터를 변경, 추가할 경우가 있다.
## 입력은 insert, 수정할 경우 update, 삭제는 delete

create table bda_8th (bda_id char(10), bda_name char(5), score int);

Select * from bda_8th;

#### insert
## insert into 불러올 테이블 values (값....)
insert into bda_8th values('wxyz', '김범수', 40);
insert into bda_8th values('wxyzA', '유나얼', 40);
insert into bda_8th values('wxyzB', '박효신', 40);
insert into bda_8th values('wxyzC', '장이수', null);

## 이런 형식도 가능하다.
## insert into 불러올 테이블 [(열...)] values (값....)
insert into bda_8th(bda_id, bda_name) values('wxyzD', '하현우');

## score가 20보다 큰 행들만 선택하여 출력한다.
Select * from bda_8th
where score > 20;

#### update
## update 테이블명 set 열 = 값 where 조건절;
Select * from bda_8th;

update bda_8th
    set bda_name = '나얼'
    where bda_name = '유나얼';
## '유나얼'의 이름을 set을 이용해서 '나얼'로 바꾼다.

Select * from bda_8th;

update bda_8th
    set score = 30
    where bda_name = '나얼';
## 이름이 '나얼'인 행의 score 값을 30으로 업데이트한다.

Select * from bda_8th;

#### Delete
## delete from 테이블명 where 조건;
delete from bda_8th
    where bda_name = '하현우';
select * from bda_8th;

## 조건절 없이 사용하면 테이블 자체가 삭제된다.
# delete from bda_8th;

#### 데이터 자료형을 변환하는 방법
## cast, convert
Select sum(price),
       avg(price)
from buy;

Select cast(avg(price) as signed) from buy; # 부호 있는 정수 타입으로 반환, signed는 avg(price)의 결과를 가장 가까운 정수로 변환
Select convert(avg(price), signed) from buy;
Select cast(avg(price) as char) from buy; # 결과가 문자 타입으로 반환된다.

## 시계열 데이터로 바꿔보자.
Select cast('2024/06/26' as date);

## select 문을 사용해가지고 계산을 빠르게 할 수도 있다.
Select 1 + 1;
Select 5 * 55 / 5;

#### join
### inner join

## 두 스키마는 mem_id라는 같은 이름을 가진 칼럼이 있다.
Select * from buy;
Select * from member;

Select * from member m
    inner join buy b
    on m.mem_id = b.mem_id;

## inner join을 통하여 내가 필요한 것만 가지고 올 수 있다.
Select m.mem_id, m.mem_name, b.price, b.amount from member m
    inner join buy b
    on m.mem_id = b.mem_id;

## 내가 필요한 테이블만 먼저 추려서 조인을 하게 되면 메모리 관점에서 효율적으로 사용할 수 있다. (연산 시간 등)
Select mem_id
    ,sum(price)
    ,sum(amount)
    from buy
group by mem_id;

Select * from member m
    inner join (Select mem_id
                ,sum(price)
                ,sum(amount)
                from buy
        group by mem_id) b
        on m.mem_id = b.mem_id;

Select * from member m
    inner join (Select mem_id
                ,sum(price) as price
                ,sum(amount) as amount
                from buy
        group by mem_id) b
        on m.mem_id = b.mem_id
        where price > 0
        and amount > 5
        order by height;

### left right outer
### left outer join

Select * from member m;

Select * from member m
	left outer join (select mem_id
			,sum(price) as price
			, sum(amount) as amount
			from buy
		group by mem_id) b
        on m.mem_id = b.mem_id;

Select * from member m
	right outer join (select mem_id
			,sum(price) as price
			, sum(amount) as amount
			from buy
		group by mem_id) b
        on m.mem_id = b.mem_id;