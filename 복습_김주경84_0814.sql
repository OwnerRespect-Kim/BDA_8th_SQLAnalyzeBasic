## 재사용을 해야 하는 경우
## order 중에서 status Shipped인 경우에만 추출해야 한다.
## credit limit 0 이상인 고객들만 분석이 필요하다.
## with

## CTE를 사용하는 이유 : 가독성과 재사용성, 단계적 데이터 처리 등

## 'with'절을 사용하여 서브쿼리를 재사용하는 방법

    ## CTE(공통 테이블 표현식, WITH 절) 정의
    ## 두 개의 CTE | 1. order_shipped CTE 2. credit_non_zero CTE
    ## CTE는 이후 메인 쿼리에서 재사용될 수 있다.
    with order_shipped as (
        select * from orders
        where status = 'Shipped'
    ),
    credit_non_zero as (
        select * from customers
        where creditLimit > 0
    )

    ## main query
    ## order_shipped CTE와, credit_non_zero CTE의
     -- customerNumber를 기준으로 inner join을 수행
    select * from order_shipped as o
    inner join credit_non_zero as cnz
    on o.customerNumber = cnz.customerNumber;

## 건당 구매 금액
## (전체 매출) / 사람 수 = 사람당 매출이 나온다.
## (전체 매출) / 주문 수 = 건당 가격
## 건단가, 객단가
## LTV 한 사람이 얼마의 가치를 주느냐?
## 1인 거래가 평균적으로 얼마의 매출을 발생시키는가?
## 월별

## 전체 주문 303
## 유니크한 고객은 98
## 동일 product를 주문한 고객은 없네?

    ## CTE 정의
    with order_shipped as (
        select * from orders
        where status = 'Shipped'
    )

    ## main query
     # select절
    select
        substr(os.orderDate, 1,7) -- 연도와 월을 추출한다. ex) 2024-07
       , sum((od.quantityOrdered) * (od.priceEach)) as total -- 월별 총 매출 계산
         # ATV, Average Transaction Value 계산
         # 총 매출을 해당 월의 고유 주문 수로 나누어 건당 평균 매출을 계산한다.
       , sum((od.quantityOrdered) * (od.priceEach)) / count(distinct os.orderNumber) as ATV
     # from절
    from order_shipped as os -- 정의한 CTE를 사용한다.
    left join orderdetails as od
    on os.orderNumber = od.orderNumber
     # group by절
    group by substr(os.orderDate, 1,7)
     # order by절
    order by 3 desc; -- ATV 열을 기준으로 내림차순 정렬 즉, 평균 거래 금액이 높은 월부터 순서대로 나온다.


#################################################################
#################################################################


## 필수과제 코드

## 필수과제
## 가설을 세우고 검증하기 위해서 아래의 조건을 수행해보자.
## 1. 연도, 월별 주문 월에 따라 가장 많은 구매 금액을 사용한 나라의 Top 5를 한 번 살펴보자!
## 2. Top 5가 연도별 월별로 동일한 순위를 가지고 있는지 살펴보자!

    ## 1. 월별로 주문 top 5 확인
    with orders_with_details as (
        -- orders 테이블과 orderdetails 테이블을 조인하여 필요한 데이터를 준비한다.
        select
            o.orderNumber,
            o.orderDate,
            o.customerNumber,
            c.country,
            (od.quantityOrdered * od.priceEach) as total_amount
        from orders o
        join orderdetails od on o.orderNumber = od.orderNumber
        join customers c on o.customerNumber = c.customerNumber
        where o.status = 'Shipped'
    ),
    monthly_country_sales as (
        -- 월별로 나라별 총 구매 금액 계산
        select
            substr(o.orderDate, 1, 7) as date_y_m,
            o.country,
            sum(o.total_amount) as total_sales
        from orders_with_details o
        group by date_y_m, o.country
    ),
    most5_country_sales as (
        -- 월별로 상위 5개 나라를 선정
        select
            date_y_m,
            country,
            total_sales,
            dense_rank() over (partition by date_y_m order by total_sales desc) as top
        from monthly_country_sales
    )

    -- main query : 상위 5개 나라만 선택
    select date_y_m, country, sum(total_sales), top
    from most5_country_sales
    where top <= 5
    group by date_y_m, country, top
    order by date_y_m, sum(total_sales) desc;

    -- 가설1 : 주문 월에 따라 가장 많은 구매를 한 나라들이 달라질 것이다.
    -- select date_y_m, country, sum(total_sales), top
    -- from most5_country_sales
    -- where top <= 1
    -- group by date_y_m, country, top
    -- order by date_y_m, sum(total_sales) desc;

    #################################################################
    #################################################################

    ## 2. 연도별로 주문 top 5 확인
        with orders_with_details as (
        -- orders 테이블과 orderdetails 테이블을 조인하여 필요한 데이터를 준비한다.
        select
            o.orderNumber,
            o.orderDate,
            o.customerNumber,
            c.country,
            (od.quantityOrdered * od.priceEach) as total_amount
        from orders o
        join orderdetails od on o.orderNumber = od.orderNumber
        join customers c on o.customerNumber = c.customerNumber
        where o.status = 'Shipped'
    ),
    monthly_country_sales as (
        -- 연도별로 나라별 총 구매 금액 계산
        select
            substr(o.orderDate, 1, 4) as date_year,
            o.country,
            sum(o.total_amount) as total_sales
        from orders_with_details o
        group by date_year, o.country
    ),
    most5_country_sales as (
        -- 연도별로 상위 5개 나라를 선정
        select
            date_year,
            country,
            total_sales,
            dense_rank() over (partition by date_year order by total_sales desc) as top
        from monthly_country_sales
    )

    -- main query : 상위 5개 나라만 선택
    select date_year, country, sum(total_sales), top
    from most5_country_sales
    where top <= 5
    group by date_year, country, top
    order by date_year, sum(total_sales) desc;


## 내가 생각한 가설과 맞는지? query 검증하고 추출해서 정리
## 가설1. 주문 월에 따라 가장 많은 구매를 한 나라들이 달라질 것이다.
## 가설2. 성수기(특정 월)에 특정 구매가 급증할 것이다.
## 가설3. 연도별 가장 많은 구매를 한 나라의 순위는 크게 달라지지 않을 것이다.