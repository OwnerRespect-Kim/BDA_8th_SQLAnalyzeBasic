## 집계 함수
## groupby
## count(*)

select count(productCode), count(distinct productCode) from products;
# 두 개의 값이 같다는 결과가 나왔다.
# 즉, 이말은 간단하게 중복값이 없다는 의미이다.

select count(customerNumber), count(distinct customerNumber) from payments;
# 두 개의 값이 다르다는 결과가 나왔다.
# 즉, 이말은 중복값이 존재한다는 의미이다.

select count(customerNumber), count(distinct customerNumber),
       count(customerName), count(contactFirstName) from customers;

## group by랑 어떻게 다른가?
select customerNumber, count(customerNumber) from customers
group by customerNumber;

select customerNumber, customerName, count(customerNumber) from customers
group by customerNumber, customerName;

select sum(priceEach) from orderdetails;

## 주문한 product별 전체 주문금액 합계
select count(productCode), count(distinct productCode)
from orderdetails;

## 두 개가 다르다 중복이 있다 -> 한 개의 제품은 여러 사람이 구매할 수 있다.

select sum(priceEach) from orderdetails
group by productCode;

# 1. 생각
    ## 주문한 고객들 중에서 city와 state가 가장 많은 곳은 어디인지 데이터를 추출해달라는 요청이 왔다고 하자.
        ## join을 사용해야 한다. (customer 테이블과 orders 테이블을 조인한다.)
        ## 요구조건을 정확히 이해해야 한다.
            ## 1. 주문을 했는지를 체크한다.
            ## 2. city와 state가 많은 곳을 확인하기 위해 집계함수를 사용해야 한다.
            ## 3. 결과적으로 city 몇 개, state 몇 개 이런식으로 출력이 되어야 한다.

# 2. 로직
    ## 주문한 고객의 어느 city, state 살고 있는지를 확인하는 쿼리를 짜보자!
        ## condition : 주문한 고객들 요구조건, city, state
        ## table : orders, customers라는 테이블을 사용해야겠다.
        ## join key : customerNumber
        ## how to join : left, right, outer, inner
        ## 필요한 컬럼 : city, state group by를 이용한 집계

# 3. 쿼리 작성
    ## inner만 써야 하는 경우가 아니면 일단은 left 기준을 잡고 진행하는 것도 같은 결과이긴 하다.

select c.customernumber, c.city, c.state from customers as c;

select o.customerNumber, count(c.city), count(c.state) from orders as o
left join customers c
on o.customerNumber = c.customerNumber
where o.status = 'Shipped'
group by o.customerNumber;

select count(o.customerNumber) as cnt_cust, c.city, c.state, count(distinct o.customerNumber) as dis_cnt_cust from orders as o
left join customers c
on o.customerNumber = c.customerNumber
where o.status = 'Shipped'
group by c.city, c.state
order by 3 desc;

# 4. 검증
    ## 27, Madrid가 맞는지 확인 (중복제거의 경우 5, NYC)
        # 마드리드 사는 사람들의 수를 확인한다.

select * from customers
where city = 'Madrid';

## 141, 237, 344, 458, 465라는 번호의 customerNumber가 나왔다.

select count(*) from orders
where customerNumber in(141, 237, 344, 458, 465) # 숫자 대신에 위의 쿼리를 서브 쿼리로 사용하여 검증해도 된다.
and status = 'Shipped';

## 27이 나왔다.

## 만약 검증을 했는데 맞지 않다면?
select count(distinct customerNumber) from customers;

select * from customers as c
left join orders as o
on c.customerNumber = o.customerNumber
where orderNumber is null; # null 값이 24개

# 위의 테이블에서는 null값을 포함해서 350개 였는데 null 값을 빼고 아래의 테이블과 비교함으로써 326개임을 맞추었다.
select count(*) from orders as o
left join customers c
on o.customerNumber = c.customerNumber;
