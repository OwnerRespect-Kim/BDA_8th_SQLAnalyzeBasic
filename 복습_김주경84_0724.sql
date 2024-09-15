## Like문
## ex) S로 시작하는 나라를 찾고 싶다.
 ## 이런식으로 특정 문자열의 패턴을 찾고 싶을 때 Like를 사용한다.
## 형식
 ## Like '%찾을문자'
 ## Like '찾을문자%'
 ## Like '%찾을문자%'
SELECT country FROM customers
WHERE country Like '%s'; -- 이 경우 뒤에 s가 있는 애들이 출력된다.

SELECT country FROM customers
WHERE country Like 's%'; -- 이 경우 앞에 s가 있는 애들이 출력된다.

SELECT country FROM customers
WHERE country Like '%s%'; -- 이 경우 s가 들어간 국가를 찾는다.

#################################################################
#################################################################

## Replace
## 특정 문자를 대체하는 함수
## 형식
 ## Replace(컬럼, 특정 문자, 바꿀 문자)
SELECT country
    , replace(country, 'A', 'B') -- A를 B로 대체한다는 의미이다.
    FROM customers;

## Like 문과 합쳐서 응용
SELECT country
    , replace(country, 'U', '1234')
    FROM customers
    WHERE country Like 'u%';

#################################################################
#################################################################

## FROM절을 사용하지 않아도 어떤 단순 계산들은 함수로 사용하면 계산이 된다.
## 바로바로 빠르게 값을 봐야하는 경우는 이런 식으로 사용해도 된다!
SELECT 55 * 5;

#################################################################
#################################################################

## 반복하는 함수가 Repeat
## 내가 원하는 값을 몇 번 반복할지 정할 수 있다.
## '0', 15

SELECT Repeat('0', 7); -- 7번 반복

#################################################################
#################################################################

## 문자열을 비교하는 함수도 있다.
## 특정 두 문자열이 같은지 틀린지 비교
## 형식
 ## strcmp (비교할 문자열1, 비교할 문자열2)
SELECT strcmp('ABCC', 'ABCc'); -- 두 문자열이 같으면 0을 출력한다.
SELECT strcmp('ABCde', 'ABCd'); -- 두 문자열이 다르면 1 또는 -1을 출력한다. (다른 값이 오른쪽에 있으면 -1, 왼쪽에 있으면 1)

#################################################################
#################################################################

## 날짜 함수
## 연, 월, 일, 시, 분, 초, 요일 등등
## 현업을 가면 데이터가 적재되어 있다. -> 적재가 되는 기준이 날짜 데이터 기준으로 적재가 된다.
## 주문, 이벤트 등이 다 대부분 날짜 기준으로 많이 진행이 된다.

## date, datetime
## 연월일, 연월일시분초

## 현재 시간을 불러오자!
## current_date, current_time
SELECT Current_Date(); -- 오늘의 연, 월, 일
SELECT Current_Time(); -- 현재의 시, 분, 초
SELECT Current_Timestamp(); -- 현재의 연, 월, 일, 시, 분, 초 동시에
SELECT now();

## 우리나라 기준 대신 UTC 국제기준으로 바라보는 경우도 있다.
## 우리나라는 UTC + 9시간 즉, UTC가 0이면 대한민국은 9시

SELECT now(2), now(3), now(4); -- 소수점 초까지 확인할 수 있게 해준다.

## UTC 국제기준
## 시간 차이가 나는 것을 확인할 수 있다.
SELECT Current_Date(), Current_Time(),
       Utc_Date(), Utc_Time();

## 날짜를 더하거나 뺄 수도 있다.
## date_add, date_sub
## date_add(날짜, interval, 빼거나 더하는 숫자, 보고자 하는 날짜 단위)

SELECT now(), Date_Add(now(), interval 20 year); -- 20년을 더해서 출력한다.
SELECT now(), Date_Add(now(), interval 20 month); -- 20달을 더해서 출력한다.
SELECT now(), Date_Add(now(), interval 20 day); -- 20일을 더해서 출력한다.

SELECT now(), Date_Sub(now(), interval 20 year); -- 20년을 빼서 출력한다.
SELECT now(), Date_Sub(now(), interval 20 month); -- 20월을 빼서 출력한다.
SELECT now(), Date_Sub(now(), interval 20 day); -- 20일을 빼서 출력한다.

## 날짜 간의 차이를 구하는 함수
## Datediff : 날짜 간의 일 수를 구할 수 있다. 시작과 종료를 인자로 받는다.
SELECT Datediff('2024-07-24 22:00:00.00', '2024-07-24 22:55:58.99'); -- 이 경우 시간 차이가 1시간을 안 넘어가기에 0이 출력된다.
## 일(Day)이 차이가 나면 뒤에 값은 다 날라가고 -(날짜 차이 수)
SELECT Datediff('2024-07-24 22:00:00.00', '2024-07-26 22:55:58.99');

## Timestampdiff
## 차이에 대해서 반환해서 값을 보여줄 수 있다.
## Timestampdiff(보고 싶은 기준, 시작, 종료)
SELECT Timestampdiff(month, '2024-07-24 22:00:00.00', '2024-07-26 22:55:58.99'); -- 이 경우 같은 7월이기에 0이 출력된다.
SELECT Timestampdiff(month, '2024-07-24 22:00:00.00', '2024-09-26 22:55:58.99');

## 요일을 반환하는 함수
## Dayname 해당 날짜가 어떤 요일인지 반환
SELECT Dayname(now()); -- 2024/07/24 날짜 기준인 수요일이 출력된다.

## 날짜의 특정 값들만 추춝하는 경우
## Year, Month, Week, Day
SELECT Year('2024-07-24')
    , Month('2024-07-24')
    , Day('2024-07-24')
    , Week('2024-07-24');

## 날짜형 데이터로 변환하는 함수
## Date_Format 날짜를 다양한 형식으로 표현해야 할 때 사용하는 것
## 2024.07.24 ==> 24.07.2024
## %Y, %y, %m, %d, %H, %M, %s (약어들)
-- 형식이 바뀌었다.
SELECT Date_Format('2024-07-24', '%m/%d/%Y');
SELECT Date_Format('2024-07-24', '%m-%d-%y');
SELECT Date_Format('2024-07-24', '%m.%d.%y');

## Get_Format 함수 : 각 국가별 시간을 알 수 있다.
## Get_Format(날짜, '국가') 해당 국가의 시간이 나온다.
## USA, EUR 등등

SELECT Date_Format(now(), Get_Format(time, 'EUR')) as EUR
, now() as KOR;

## 배운 문법을 가지고 orders 테이블에 적용해 보자!

SELECT *
    , Dayname(orderDate) as dayName
    , year(orderDate) as ody
    , month(orderDate) as odm
    , day(orderDate) as odd
    from orders;

## status 배송이 된 주문에 대해서 orderDate, shippedDate 둘의 차이를 먼저 계산해 보자!

-- 1. `orders` 테이블의 모든 열과 `orderDate`, `shippedDate`의 차이 계산
-- 2. `status`가 'Shipped'인 주문만 선택
-- 3. `DATEDIFF`와 `TIMESTAMPDIFF` 함수 사용

SELECT * FROM orders;

SELECT
    *,
    DATEDIFF(shippedDate, orderDate) AS days_difference,  -- 날짜 차이를 일 단위로 계산
    TIMESTAMPDIFF(HOUR, orderDate, shippedDate) AS hours_difference  -- 날짜 차이를 시간 단위로 계산
FROM
    orders
WHERE
    status = 'Shipped';  -- 배송된 주문만 선택

SELECT
    avg(DATEDIFF(shippedDate, orderDate)),  -- 날짜 차이를 일 단위로 계산
    avg(TIMESTAMPDIFF(HOUR, orderDate, shippedDate)) -- 날짜 차이를 시간 단위로 계산
FROM orders
WHERE status = 'Shipped';  -- 배송된 주문만 선택

SELECT * FROM orders
WHERE Datediff(orderDate, shippedDate) >= -4
And status = 'shipped';