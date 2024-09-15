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
