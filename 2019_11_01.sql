-- 복습
-- WHERE
-- 연산자
-- 비교 : =, !=, <>, >=, >, <=, <
-- BETWEEN start And end
-- IN (set)
-- LIKE 'S%'(% : 다수의 문자열과 매칭, _ : 정확히 한글자 매칭)
-- IS NULL (!= NULL)
-- AND, OR, NOT

-- emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원정보조회
-- BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19810601', 'YYYYMMDD') AND TO_DATE('19861231', 'YYYYMMDD');

-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD') 
  AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');
  
-- emp테이블에서 관리자(mgr)이 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- AND, OR 실습 where12)emp테이블, job이 SALESMAN이거나 사원번호 78로 시작하는
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';  

-- AND, OR 실습 where13)emp테이블, job이 SALESMAN이거나 사원번호 78로 시작하는 (LIKE연산자 사용금지)
-- empno는 정수 4자리까지 허용
-- empno : 78,780, 789
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno =78   
   OR empno >=780 AND empno < 790
   OR empno >=7800 AND empno < 7900;
  
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno = 78 
   OR empno BETWEEN 780 AND 789
   OR empno BETWEEN 7800 AND 7899;

-- AND, OR 실습 where14) emp테이블, job이 SALESMAN이거나 사원번호 78로 시작하면서 입사일자 810601이후
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
  OR (empno LIKE '78%' AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD'));
  
-- order by 컬럼명 | 별칭 | 컬럼인덱스 [ASC | DESC]
-- order by 구문은 WHERE절 다음에 기술
-- WHERE절이 없을 경우 FROM절 다음에 기술
-- emp테이블을 ename 기준으로 오름차순 정렬
SELECT *
FROM emp
ORDER BY ename ASC;

-- ASC : default
-- ASC를 안붙여도 위 쿼리와 동일함
SELECT *
FROM emp
ORDER BY ename; -- ASC

-- 이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename desc;

-- job을 기준으로 내림차순으로 정렬, 만약 값이 같을 경우 사번(empno)으로 오름차순 정렬
SELECT *
FROM emp
ORDER By job DESC, empno;

-- 별칭으로 정렬하기
-- 사원번호(empno), 사원명(ename), 연봉(sal*12) as year_sal
-- year_sal 별칭으로 오름차순 정렬
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER By year_sal;

-- SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER By 4;

-- 실습 orderby1) dept테이블 모든정보를 부서이름으로 오름차순
SELECT *
FROM dept
ORDER BY dname;

-- 실습1-2) dept테이블 모든 정보 부서위치로 내림차순 정렬
SELECT *
FROM dept
ORDER BY loc desc;

-- 실습 orderby2) emp테이블 , 상여(comm)정보가 있는 사람만조회, 많이받으면 먼저 조회,
--                           같을 경우 사번오름차순
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

-- 실습 orderby3) emp테이블, 관리자있는사람만 조회, 직군(job) 오름차순,
--                          직업이 같으면 사번이 큰 사원먼저조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- 실습 orderby4) emp테이블, 10번부서(deptno) 혹은 30번부서 속하는 사람 중
--                          급여(sal)가 1500넘는 사람만 조회, 이름내림차순
SELECT *
FROM emp
WHERE deptno IN (10, 30)
  AND sal > 1500
ORDER BY ename DESC;

--
DESC emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM =2; --가져올 수 없음, =1인경우 가능 <=2인 경우 가능 무조건 1번부터 가져와야함 !!!??
--WHERE ROWNUM <= 10

-- emp테이블에서 사번(empno), 이름(ename)을 급여기준으로 오름차순 정렬하고
-- 정렬된 결과 순으로 ROWNUM
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal; --ROWNUM이 뒤죽박죽! 

SELECT ROWNUM, a.*
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) a;

-- 실습 row_1) emp테이블, ROWNUM값이 1~10인 값만 조회
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10;

-- 실습 row_2) emp테이블, ROWNUM값이 11~20인 값만 조회
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
FROM
    (SELECT empno, ename, sal
     FROM emp
     ORDER BY sal) a)
WHERE rn BETWEEN 11 and 20;
-- ROWNUM 과 ORDER BY는 함께 쓸 수 없음! 쓰면 ROWNUM이 뒤죽박죽임.. 

-- FUNCTION
-- DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;  -- 한개만 나옴!

SELECT 'HELLO WORLD'
FROM emp;   -- 테이블에 해당하는 건수만큼 나옴!

-- 문자열 대소문자 관련 함수
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'),UPPER('Hello, World'), INITCAP('hello, world')
FROM dual;

SELECT LOWER('Hello, World'),UPPER('Hello, World'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN'; -- where에 조건을 걸면 갯수만큼 나옴!

-- FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; -- 컬럼에 FUNCTION 주는건 지양!

-- 개발자 SQL 칠거지악
-- 1. 좌변을 가공하지 말아라
-- 좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
-- Function Based Index -> FBI

-- CONCAT : 문자열 결합 - 두 개의 문자열을 결합하는 함수
SELECT CONCAT('HELLO', ', WORLD')CONCAT
FROM dual;

-- SUBSTR : 문자열의 부분 문자열 (java : String.substring)
-- LENGTH : 문자열의 길이
-- INSTR : 문자열에 특정 문자열이 등장하는 첫 번째 인덱스
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') CONCAT, -- 문자열 3개 결합하고 싶어여!
       SUBSTR('HELLO, WORLD', 0, 5) substr,
       SUBSTR('HELLO, WORLD', 1, 5) substr1,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       -- INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시) 
       INSTR('HELLO, WORLD', 'O', 6) instr1, -- 6번인덱스 이후 찾을 문자열 위치 표시
       -- LPAD(문자열, 전체문자열길이, 문자열이 전체문자열길이에 미치지 못할 경우 추가할 문자)
       LPAD('HELLO, WORLD', 15, '*') lpad,  -- 추가문자열을 지정하지 않으면 공백 추가
       RPAD('HELLO, WORLD', 15, '*') rpad
FROM dual;

-- 문자열 3개 결합하고싶어여! ->이거쓰면 편하잖..?????
SELECT 'HELLO' || ', ' || 'WORLD'
FROM dual;
