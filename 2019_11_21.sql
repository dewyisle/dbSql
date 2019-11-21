--서브쿼리 ADVANCED (WITH) 
-- 부서별 평균 급여가 직원전체 급여 평균보다 높은부서의 부서번호와 부서별 급여 평균금액 조회
--1. 전체직원의 급여 평균 (2073.21)
SELECT ROUND(AVG(sal), 2)
FROM emp;
--2. 부서별 직원의 급여 평균
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;
--3. 결과 도출
SELECT *
FROM
   (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2)
                    FROM emp);

--쿼리블럭을 WITH절에 선언하여 쿼리를 간단하게 표현한다.
WITH dept_avg_sal AS(SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
                    FROM emp
                    GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2) FROM emp);

-- 달력 만들기
--STEP1. 해당 년월의 일자 만들기
--CONNECT BY LEVEL

--201911
--DATE + 정수 = 일자 더하기 연산
SELECT  MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon,
        MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wed,
        MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM')+(level-1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'iw') iw,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'd') d
    FROM dual a
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))a
GROUP BY DECODE(d, 1, a.iw+1, a.iw)
ORDER BY DECODE(d, 1, a.iw+1, a.iw);


--
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

--SALES
SELECT *
FROM sales;

--실습 calendar1) 
--달력만들기 복습데이터.sql의 일별실적데이터 이용, 1~6월의 월별실적데이터 구하세요
SELECT MIN(DECODE(TO_CHAR(dt, 'MM'), '01', SUM(sales))) JAN, 
       MIN(DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales))) FEB,
       MIN(DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales))) MAR, 
       MIN(DECODE(TO_CHAR(dt, 'MM'), '04', SUM(sales))) APR,
       MIN(DECODE(TO_CHAR(dt, 'MM'), '03', SUM(sales))) MAY, 
       MIN(DECODE(TO_CHAR(dt, 'MM'), '06', SUM(sales))) JUN
FROM sales
GROUP BY TO_CHAR(dt, 'MM');


--
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;

--계층쿼리
--START WITH : 계층의 시작부분을 정의
--CONNECT BY : 계층간 연결조건을 정의
SELECT *
FROM dept_h;
--하향식 계층쿼리 (가장 최상위 조직에서부터 모든 조직을 탐색) 
--LPAD를 이용해 계층구조를 시각화 할 수 있음!
--계층쿼리 실습h_1)
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0' --START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR : 현재 읽은 데이터(XX회사)

--계층쿼리 실습h_2) 정보시스템부 하위 부서계층 구조 조회쿼리 작성
SELECT LEVEL LV, deptcd, 
       LPAD('-', (LEVEL-1)*4,' ') || dept_h.deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
