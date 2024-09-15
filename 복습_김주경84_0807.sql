Select * from customers;
Select * from products;

## 1. productLine에 대한 주문 금액이 얼마인가?
## 특정 조건이 필요한 것은 아니다.
## 주문 금액이 필요한 상황 -> 집계를 해야한다.
## productLine에 대한 -> groupby를 사용해야겠구나

## 내가 필요한 테이블은 무엇인가?
## products
## orderdetails
## join을 사용할 키는 ordderdetails와 productCode와 공통된 것이여야 한다.
## productCode가 공통된 컬럼(키)이다.

Select p.productLine, # products 테이블의 productLine 열을 선택한다.
sum(o.quantityOrdered) * sum(o.priceEach) as total_amount # 가격이랑 수량을 곱해서 총 금액을 구해주자.

From orderdetails o # orderdetails라는 테이블을 'o'라는 별칭으로 참조하자.

Left join products p # 두 테이블의 productCode 열을 기준으로 테이블을 조인하며,
    # Left join이기에 orderdetails 테이블에 있는 모든 행이 결과에 포함되며
    # products 테이블에 해당하는 productCode가 없으면 Null로 표시된다.
on o.productCode = p.productCode

group by p.productLine; # 동일한 productLine에 속하는 제품들을 하나의 그룹으로 묶어 집계

## 값 검증을 해보자.
Select sum(o.priceEach), sum(o.quantityOrdered), sum(o.priceEach) * sum(o.quantityOrdered)
From orderdetails o
Left join products p
on o.productCode = p.productCode
where p.productLine = 'Classic Cars';

## Classic Cars, 3881445390.64, 3881445390.64 값이 같다.

#################################################################
#################################################################

## 2. 주문 일자별로 주문 고객 수는 어떻게 되는가?
## 내가 필요한 테이블은 무엇인가?
## orders
## 따로 join을 생각하지 않아도 된다.
## 주문 일자를 정리하기 위해 orderDate 컬럼을 groupby 해야겠다.
## 주문 고객 수는? customerNumber를 count함수를 이용해 세면 되겠다.
## 주문 수량은 카운팅으로 할 수 있지만
## 고객수는 유니크한 값으로 확인하기 위해 distinct를 적용시키면 되겠구나.
## Having절을 사용하여 cnt와 unique_cnt의 값이 다른 것이 있는지 살펴보자.

Select orderDate, count(customerNumber) as cnt, count(distinct customerNumber) as unique_cnt
from orders
group by orderDate
-- Having count(customerNumber) <> count(Distinct customerNumber) # Having절을 사용하지 않을꺼면 각주처리 하자.
order by 1; # 첫 번째 열 기준으로 오름차순으로 정렬

## Having절 적용시켰을 때
## 위 코드의 결과로 '2005-02-10'의 cnt의 값은 2지만, unique_cnt의 값은 1이다.
## 이는 2005-02-10에 한 고객이 두 번의 주문을 했음을 의미한다.

## 이번에는 월별 주문수량을 살펴보자.
## orderDate의 형식은 '0000-00-00'이다.
## 7개의 문자열만 골라 추출하면 '0000-00'으로 정렬이 되겠다.
Select substr(orderDate, 1, 7), count(customerNumber) as cnt, count(distinct customerNumber) as unique_cnt
from orders
group by substr(orderDate, 1, 7)
Having count(customerNumber) <> count(Distinct customerNumber) # Having절을 사용하지 않을꺼면 각주처리 하자.
order by 1;

## Having절 적용시켰을 때
## 위 코드의 결과로 cnt의 값과 unique_cnt의 값이 다른 행이 12개 있다.
## 이것이 무엇을 의미하는가?
## 특정 고객이 한달 안에 여러 날에 걸쳐 주문했다는 것을 의미한다.

## cf) 연도별 주문수량
Select substr(orderDate, 1, 4), count(customerNumber) as cnt, count(distinct customerNumber) as unique_cnt
from orders
group by substr(orderDate, 1, 4)
order by 1;

## 위 코드의 경우에는 1년 안에 여러 날, 월에 걸쳐 주문했다는 것을 의미한다.

#################################################################
#################################################################

## 3. 국가별로 주문금액 수는 어떻게 되고, 주문금액 수가 가장 높은 고객의 수를 구해보자.
## 내가 필요한 테이블은 무엇인가?
## orders와, orderdetails, customer
## 공통된 컬럼은 orderNumber 즉, join key가 orderNumber이다.
## 주문을 취소한 경우 금액 총합에서 빼줘야 맞다. 그러므로, status 상태가 Shipped인 사람들만 골라주자.

Select o.orderNumber, o.customerNumber, ot.quantityOrdered, priceEach
from orders as o
left join orderdetails ot
on o.orderNumber = ot.orderNumber
where o.status = 'Shipped';

Select c.country,
       count(o.customerNumber) as cnt,
       count(distinct o.customerNumber) as unique_cnt,
       sum(ot.priceEach) * sum(ot.quantityOrdered) as total_amount
From orders as o
left join orderdetails ot
on o.orderNumber = ot.orderNumber
left join customers c
on o.customerNumber = c.customerNumber
where o.status = 'Shipped'
group by c.country
order by 3 desc; # 3번째 컬럼을 기준으로 내림차순