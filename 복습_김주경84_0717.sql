SELECT * FROM customers;
SELECT * FROM orders;

# 두 테이블을 join 했을 때 값이 다르게 나왔다!

## 350개의 카운트
SELECT COUNT(*) from customers c
left join orders o
on c.customerNumber = o.customerNumber;

## 326개의 카운트
SELECT COUNT(*) from customers c
right join orders o
on c.customerNumber = o.customerNumber;

## 24개의 차이가 존재
## 왜 이런 차이가 발생하는가?
## Left join의 경우 왼쪽 기준의 값들이 모두 다 살려져 있는 상태이다. <- 오른쪽 교집합의 값들이 붙는 것
## Right join의 경우 오른쪽 기준의 값들이 모두 다 살려져 있는 상태이다. <- 왼쪽 교집합의 값들이 붙는 것

## 두 가지 방법으로 확인해 보자!
## 첫 번째 방법은 orders 테이블에 주문 내역이 없는 고객들의 수가 24명인지 customers 테이블에서 확인한다.
## 두 번째 방법은 위의 350개 값이 나오는 쿼리에서 하나를 찍어가지고 na 값인지 확인하는 것이다.

## 첫 번째 방법
SELECT * FROM customers
where customerNumber NOT IN (SELECT DISTINCT customerNumber FROM orders);

### 서브쿼리 설명
#### SELECT DISTINCT customerNumber FROM orders
    # DISTINCT를 이용하여 orders 테이블에서 customerNumber 열의 중복된 값을 제거한다.
#
### 메인쿼리 설명
#### SELECT * FROM customers
#### WHERE customerNumber NOT IN (result of Subquery)
    # customers 테이블에서 customerNumber가 서브쿼리 결과에 포함되지 않는 열을 선택 후 해당하는 행들을 반환한다.
#
### 즉, 위 코드의 결과는 orders 테이블에 존재하지 않는 customerNumber를 가진 모든 고객을 반환한다.
#
### 위 코드의 목적은 orders 테이블에 주문 내역이 없는 고객들을 찾는 것이다.

## 두 번째 방법
SELECT * FROM customers c
left join orders o
on c.customerNumber = o.customerNumber
WHERE c.customerNumber IN(273, 409, 125);

### 코드의 실행 결과를 보면 위 customerNumber의 orderNumber 열은 na값으로 되어 있다.
 ## 즉, customer이지만 order는 따로 하지 않은 것이다.

### 참고
### inner join을 하면 위의 right join의 결과와 같은 326이 나온다.
SELECT COUNT(*) FROM customers c
inner join orders o
on c.customerNumber = o.customerNumber;

#################################################################
#################################################################

## 공통테이블 표현식 CTE Common Table Expression
## 자주 사용할 테이블을 미리 만들어서 먼저 불러오고 그 테이블로 다른 테이블과 조인이나 다른 작업을 할 때 사용하는 경우
## 재사용하려는 재귀 공통 테이블 표현식에 의미

## 형식
## with[지정할 테이블 명] (불러올 열1, 불러올 열2)
## as
## (
##  <SELECT 문>
## )
## SELECT (불러올 열 1) FROM [지정할 테이블 명]

SELECT * FROM customers;

WITH cte_customer_nyc (customerNumber, customerName)
AS
(
    SELECT customerNumber, customerName FROM customers where CITY = 'NYC'
    UNION ALL
    SELECT customerNumber, customerName FROM customers where CITY = 'Paris'
)
SELECT customerNumber from cte_customer_nyc;

### 코드 설명
 ### SELECT * FROM customers;

    # customers 테이블의 모든 행을 선택한다.

 ### WITH cte_customer_nyc (customerNumber, customerName)
   # AS
   # (
   #    SELECT customerNumber, customerName FROM customers where CITY = 'NYC'
   #    UNION ALL
   #    SELECT customerNumber, customerName FROM customers where CITY = 'Paris'
   # )

    # cte_customer_nyc라는 이름의 CTE를 정의한다.
    # 두 개의 SELECT문을 사용하여 데이터를 결합한다.
     # 첫 번째 SELECT문은 customers 테이블에서 CITY 컬럼이 'NYC'인 행을 선택한다.
     # 두 번째 SELECT문은 customers 테이블에서 CITY 컬럼이 'Paris'인 행을 선택한다.
     # UNION ALL은 두 결과 집합을 결합하며, 중복된 행을 제거하지 않는다.

 ### SELECT customerNumber from cte_customer_nyc;

    # CTE에서 customerNumber 열을 선택하여 반환한다.

#################################################################
#################################################################

## 문자열 함수 CONCAT(붙일 컬럼, 구분자, 컬럼)
SELECT CONCAT(city, '-', state) as city_state
    , city
    , state
    , customerNumber
FROM customers;

### 위 코드의 실행 결과로 새로 만들어지는 열 city_state의 경우
### customers 테이블에서 불러온 city컬럼의 값이 Null이거나 state의 값이 Null인 경우
### city_state의 값도 Null이 된다.

## 문자열 함수 CONCAT_WS(구분자, 붙일 컬럼1, 붙일 컬럼2, 붙일 컬럼n)
SELECT CONCAT_WS(' / ', city, state, postalCode, country) FROM customers;

## Null 값은 자동으로 무시된다. 아래 두 코드의 출력 결과는 똑같다.
SELECT CONCAT_WS(' / ', city, country, state) FROM customers;
SELECT CONCAT_WS(' / ', city, Null, country, Null, state) FROM customers;

#################################################################
#################################################################

## 변환 함수 CAST와 CONVERT
## 데이터의 자료형을 변환한다.
## 형식 :
## CAST(컬럼 as 데이터 유형)
## CONVERT(컬럼, 데이터 유형)
## 자료형 변환은 오류가 발생할 수 있기에 잘 알고 있어야 한다.

SELECT CAST(customerNumber as char) FROM customers;
SELECT CONVERT(customerNumber, char) FROM customers;

SELECT CAST(orderDate as date) FROM orders;
SELECT CAST(orderDate as char) FROM orders;

#################################################################
#################################################################

## 결측값(Null)을 대체하는 함수
## IFNULL, COALESCE
## IFNULL(컬럼, 대체할 값)
## COALESCE(열, 열) - NULL이 아닌 값이 나올 때까지 여러 열을 입력할 수 있다.

SELECT IFNULL(addressLine2, 'Level-2') FROM customers;
## 위 코드를 해석하면 customers 테이블의 컬럼 affressLine2의 Null 값을 'Level-2로 대체한다는 의미이다.

SELECT COALESCE(addressLine2, state)
    ,addressLine2
    ,state
    from customers;
## 첫 번째 인자로 전달한 열에 null이 있으면 -> 그다음 인자로 작성한 열에 데이터로 대체 하는 것
## 즉, 위 코드에서 'COALESCE(addressLine2, state)'라는 컬럼은 기본적으로 다 Null로 만들어진다.
## 그래서 그 값을 두 개의 인자에서 값을 가져와서 대체하려고 한다.
## 만약 첫 번째 인자인 addressLine2의 값도 null이라면 두 번째 인자인 state를 확인한다.
## 두 번째 인자에서 값이 있다면 가지고 오고 (위 코드의 2번째 행이 그 사례이다.)
## 두 번째 인자에도 값이 없다면 그대로 Null이다. (위 코드의 1번째 행이 그 사례이다.)

#################################################################
#################################################################

## lower, UPPER
## lower의 문자열을 소문자로
## UPPER의 경우 문자열을 대문자로 변환하는 함수이다.
SELECT lower(customerName), UPPER(customerName) FROM customers;

#################################################################
#################################################################

## 공백제거 함수
## Ltrim 왼쪽 공백 제거, Rtrim 오른쪽 공백 제거, Trim 전체 공백 제거
SELECT CustomerName From customers;
SELECT Ltrim(CustomerName) From customers;
SELECT Rtrim(CustomerName) From customers;
SELECT Trim(CustomerName) From customers;

#################################################################
#################################################################

## 지정한 위치의 문자열을 반환하는 함수 SubString
## substring(열, 인덱스,인덱스)
SELECT SubString(customerName, 1, 5) ,customerName From customers;
# 위 코드는 customerName의 각 데이터 중 앞의 5글자만을 불러오는 컬럼을 새로 만든다.