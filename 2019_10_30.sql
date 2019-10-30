-- SELECT : 조회할 컬럼 명시
--        - 전체 컬럼 조회 : *
--        - 일부 컬럼 : 해당 컬럼명 나열 (, 구분) 
-- FROM : 조회할 테이블 명시
-- 쿼리를 여러줄에 나누어서 작성해도 상관없다.
-- 단 keyword는 붙여서 작성

-- 모든 컬럼을 조회
 SELECT * FROM prod;
 
-- 특정 컬럼만 조회
SELECT prod_id, prod_name
FROM prod;

-- SELECT(실습 select1) 조회하기
-- 문제1) lprod 테이블에서 모든 데이터를 조회하는 쿼리
SELECT * FROM lprod;

-- 문제2) buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리
SELECT buyer_id, buyer_name
From buyer;

-- 문제3) cart테이블에서 모든 데이터 조회
SELECT * FROM cart;

-- 문제4) member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회
SELECT mem_id, mem_pass, mem_name
FROM member;


-- 연산자 / 날짜연산 
-- date type + 정수 : 일자를 더한다.
-- null을 포함한 연산의 결과는 항상 null이다.
SELECT userid, usernm, reg_dt,
       reg_dt + 5 reg_dt_after5, 
       reg_dt - 5 as reg_dt_before5 
FROM users;

-- colum alias(실습 select2) 컬럼별칭지정하기
-- 문제1) 
SELECT prod_id id, prod_name name
FROM prod;

-- 문제2)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

-- 문제3)
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

-- 문자열 결합
-- java + --> sql ||
-- CONCAT(str, str) 함수
-- users테이블의 userid, usernm 합치기
SELECT userid, usernm, userid || usernm,
        CONCAT(userid, usernm)
FROM users;


-- 문자열 상수 (컬럼에 담긴 데이터가 아니라 개발자가 직접 입력한 문자열)
SELECT '사용자 아이디 : ' || userid,
        CONCAT('사용자 아이디 : ', userid)
FROM users;

-- 실습 sel_conl1
SELECT *
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' QUERY 
FROM user_tables;


-- desc table
-- 테이블에 정의된 컬럼을 알고 싶을 때
-- 1. desc
-- 2. select * from 테이블명
desc emp;

SELECT *
FROM emp;


--WHERE절, 조건 연산자
