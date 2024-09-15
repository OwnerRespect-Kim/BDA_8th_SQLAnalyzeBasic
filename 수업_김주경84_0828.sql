### case 1
### Join 없는 단순 집계, 추출 작업
### 이런 경우는 거의 대부분 없다. ( 단순한 집계 )
### 다른 직무 사람들도 이정도는 직접한다. -> 직접 할 수 있는 직접 한다.
### 데이터 분석을 요청 -> 자기들이 할 수 없으니 ( 힘들다 )
### 내가 분석하기 위한 스텝 중 하나 ( 목적지를 가기 위한 걸음 )

select * from customers
where country= 'USA'
and state = 'MA'
and city = 'Boston';

### case 2
### join 있는 경우
### 테이블 + 테이블 = 새로운 데이터 / 테이블, 테이블 나눠서 생각하기에는 테이블 추출하기 어렵다.
### 고객 + 주문 = 고객이 주문한 금액
### 요구 조건이 온다.
### 다른 팀에서, 다른 부서에 데이터 분석 or 추출 요청 등이 온다.
### 3개월 전 주문한 고객 중에서 다시 1개월 후에 재주문한 (재방문) 사람들의 평균 구매금액, 주문상품, 어떤 페이지를 들어갔는지? 체류 시간 등등
### 1. - 결론적으로 내가 구해야 하는 게 무엇이야? 주문금액
### 2. - 주문 금액을 구하기 위한 조건?
###     - 활성화 고객, 주문 주기, 기간, 이벤트 등의 조건이 다양할 것 -> 이러한 조건들을 잘 체크해야 한다.
### 3. - join 유무를 생각해 보자!
###    - join 0
###        - 테이블 구조 이해해야 한다. 중복값이 있는지, PK, FK관계 등
###        - 어떤 컬럼 기준으로 할꺼야!?
###        - 어떤 조인 할껀데?
### 4. - 검증
###     - join 연산에 대한 검증
###     - 결과에 대한 값 검증
### 5. 쿼리를 작성
### 6. 효율적인 쿼리를 작성하기 위해서 고민~

### CASE 3
### 데이터 마트나 대시보드 작업이 필요한 경우
### 쿼리를 통해서 우리가 사용할 마트를 제작하고 해당 마트를 만들 쿼리를 작성해야 한다.
### 1. 문제정의 후 -> 해당 마트나 대시보드가 필요한 사람들의 요구사항을 잘 정리해야 한다.
###     - 대부분 요구사항에 따라 쿼리가 다 달라진다.
###     - 한 번 작업하고 또 수행한다. -> 비용 발생, 한 번에 효율적인 작업을 하기 위해 다양한 확장성과 전체적인 부분까지 고려해야 한다.
###     - A라는 팀이 우리는 고객의 퍼널분석이 필요하다. 유입 -> 로그인 -> add_to_cart -> purchase
###     - 어? 퍼널만 고려할 게 아니라 -> 이 퍼널 내에 다른 경로나 또는 다른 경우의 수들도 모두 다 포함해서 한 번에 만들면 더 효율적이지 않나?
### 대부분 데이터는 Timestamp처럼 데이터가 쌓인다. -> partion 시간의 데이터를 잘 이해하고 생각을 해야한다.
### 2. 기준점 데이터를 계속해서 누적으로 적재하면서 보여줘야하는 상황 -> orderdate와 같은 ymd 데이터로 나뉘어진다.
###    - 국제시간 기준, 한국시간 기준 UTC 확인도 꼭 잘 해야 한다. +9 우리나라 시간

### 마트는 어떻게 만드는가?
### order에 대한 마트를 하나 만들어서
### 주문에 대한 시각화를 진행한다. 새로운 마트를 하나 만들어서 대시보드로 구현해야 한다.
### order에 대한 정보와 디테일들이 필요하다.
### orderdate 시계열 적인 기준
### 주문 고객은 customerNumber
### 주문수량, 주문금액 알 수 있다.

### 주문번호의 주문금액, 주문수량, 주문자 수 마트로 만들어서 시각화를 하자!
### 테이블을 만들어야 한다.
###

select
    o.orderDate,
    o.customerNumber, ## 중복 포함인지 아닌지
    od.priceEach,
    od.quantityOrdered
from
orders as o
left join orderdetails as od
on o.orderNumber = od.orderNumber
group by o.orderDate
order by 1;
-- where o.orderNumber is null; # null 값 유무 확인

### 요구 조건에 따라 달라진다.
### if orderDate로 기준 잡을 때
### if orderNumber와 orderDate 기준을 잡았을 때

select
    o.orderDate,
    -- o.orderNumber,
    count(o.customerNumber),
    sum(od.priceEach),
    sum(od.quantityOrdered)
from orders as o
left join orderdetails as od
on o.orderNumber = od.orderNumber
group by o.orderDate
having orderDate = '2005-05-01'
order by 1;