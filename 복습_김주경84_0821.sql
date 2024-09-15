### 순위 지정 함수
#   - sql에서 순위를 지정하는 함수는 데이터를 특정 조건에 따라 순위를 부여하는데 사용된다.
#   - 대표적인 순위 함수로는 row_number(), rank(), dense_rank()가 있다.
#        - row_number() : 모든 행에 유일한 순위를 부여, 동일한 값이라도 서로 다른 순위를 부여
#        - rank() : 동일한 값은 같은 순위를 부여하지만, 다음 순위는 건너뛴다.
#        - dense_rank() : 동일한 값은 같은 순위를 부여하며, 다음 순위는 건너뛰지 않고 연속적으로 부여된다.
#   - 주로 over()절, order by와 함께 사용된다.

### row_number() 함수를 이용한 예시 코드
-- 고객 이름과 고객 정보를 매출(amount) 순으로 정렬하여 순위를 부여
SELECT
    c.customernumber,
    c.customerName,
    p.paymentDate,
    p.amount,
    ROW_NUMBER() OVER (ORDER BY p.amount DESC) AS rowNumber
FROM
    customers AS c
INNER JOIN
    payments AS p
ON
    c.customerNumber = p.customerNumber;

-- group by를 이용하여 고객별 총 매출액을 집계한 후, ROW_NUMBER()를 통해 순위를 부여
SELECT
    c.customernumber,
    c.customerName,
    SUM(p.amount) AS totalAmount,
    ROW_NUMBER() OVER (ORDER BY SUM(p.amount) DESC) AS rowNumber
FROM
    customers AS c
INNER JOIN
    payments AS p
ON
    c.customerNumber = p.customerNumber
GROUP BY
    c.customernumber, c.customerName
ORDER BY
    totalAmount DESC;

-- PARTITION BY c.country는 국가별로 데이터를 분할하여, 각 국가 내에서 고객의 매출 순위를 부여
SELECT
    c.country,
    c.customernumber,
    c.customerName,
    SUM(p.amount) AS totalAmount,
    ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY SUM(p.amount) DESC) AS countryNumber
FROM
    customers AS c
INNER JOIN
    payments AS p
ON
    c.customerNumber = p.customerNumber
GROUP BY
    c.country, c.customerNumber, c.customerName
ORDER BY
    c.country;

### rank()와 dense_rank()
SELECT
    c.country,
    c.city,
    p.amount,
    RANK() OVER (PARTITION BY c.country, c.city ORDER BY p.amount DESC) AS rankNumber,
    DENSE_RANK() OVER (PARTITION BY c.country, c.city ORDER BY p.amount DESC) AS denseRankNumber
FROM
    customers AS c
INNER JOIN
    payments AS p
ON
    c.customerNumber = p.customerNumber;

### CTE 사용
-- CTE를 사용하여 각 국가별 1등과 2등의 매출액 차이를 계산하는 예시 코드
WITH first_country AS (
    SELECT
        sub.country,
        MAX(sub.amount) AS amount
    FROM (
        SELECT
            c.country,
            c.city,
            p.amount,
            ROW_NUMBER() OVER (PARTITION BY c.country, c.city ORDER BY p.amount DESC) AS country_city_Number
        FROM
            customers AS c
        INNER JOIN
            payments AS p ON c.customerNumber = p.customerNumber
    ) AS sub
    WHERE sub.country_city_Number = 1
    GROUP BY sub.country
),
second_country AS (
    SELECT
        sub.country,
        MAX(sub.amount) AS amount
    FROM (
        SELECT
            c.country,
            c.city,
            p.amount,
            ROW_NUMBER() OVER (PARTITION BY c.country, c.city ORDER BY p.amount DESC) AS country_city_Number
        FROM
            customers AS c
        INNER JOIN
            payments AS p ON c.customerNumber = p.customerNumber
    ) AS sub
    WHERE sub.country_city_Number = 2
    GROUP BY sub.country
)
SELECT
    fc.country,
    fc.amount AS first_amount,
    sc.amount AS second_amount
FROM
    first_country AS fc
INNER JOIN
    second_country AS sc
ON
    fc.country = sc.country;