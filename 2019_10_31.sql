-- 테이블에서 데이터 조회
/*
    SELECT 컬럼 | express (문자열 상수) [as] 별칭
    From 데이터를 조회할 테이블(VIEW)
    WHERE 조건 (condition)
*/

DESC user_tables;

SELECT table_name, 'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE table_name != 'EMP'; -- 전체건수 -1

-- 숫자비교 연산
-- 부서번호가 30번 보다 크거나 같은 부서에 속한 직원조회
SELECT *
FROM emp
WHERE deptno >= 30;

-- 부서번호가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;

-- 입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
-- WHERE hiredate < '82/01/01';
WHERE hiredate < TO_DATE('01011982', 'MMDDYYYY'); --11명(미국날짜형)
-- WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD'); -- 11명
-- WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); -- 3명
-- WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');

-- col BERWEEN X AMD Y 연산
-- 컬럼의 값이 x보다 크거나 같고, y보다 작거나 같은 데이터
-- 급여 (sal)가 1000보다 크거나 같고, Y보다 작거나 같은 데이터를 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- 위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다.
SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 30;

-- BTWEEN..and.. 실습 where1)emp 테이블, 입사일자 820101이후부터 830101이전 사원 ename, hiredate데이터 조회
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN To_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- >=, >... 실습 where2)조건에 맞는 데이터 조회하기
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD') 
  AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- In 연산자
-- COL IN (values..)
-- 부서번호가 10 혹은 20인 직원 조회
SELECT *
FROM emp
WHERE deptno IN (10, 20); 

-- IN 연산자는 OR 연산자로 표현할 수 있다.
SELECT *
FROM emp
WHERE deptno = 10 
   OR deptno = 20; 

-- IN 실습 where3) users 테이블, userid가 brown, cony, sally인 데이터 (IN사용)
SELECT userid 아이디, usernm 이름
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

-- COL LIKE 'S%'
-- COL의 값이 대문자 S로 시작하는 모든 값
-- COL LIKE 'S____'
-- COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

-- EMP 테이블에서 직원이름이 S로 시작하는 모든 직원 조회
-- 'smith' 와 'SMITH'는 다름 컬럼의 값은 대소문자 구분함!
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- LIKE, %, _ 실습 where4)member테이블, 성이[신]씨인 사람 mem_id, mem_name 조회
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

-- LIKE, %, _ 실습 where5)member테이블, 회원이름에 글자[이]가 들어가는 모든 사람 mem_id, mem_name 조회
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%진%'; -- mem_name이 문자열 안에 진이 포함된 데이터 
--WHERE mem_name LIKE '진%'; -- mem_name이 진으로 시작하는 데이터

-- NULL 비교
-- col IS NULL
-- EMP 테이블에서 MGR 정보가 없는 사람(NULL) 조회
SELECT *
FROM emp
WHERE mgr IS NULL;
-- WHERE mgr != NULL; -- null비교가 실패한다.

-- 소속 부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != '10';
-- =, !=
-- is null, is not null 

-- IS NULL 실습 where6) emp테이블, 상여(comm)가 있는 회원정보
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- 관리자(mgr) 사번이 7698이고 급여가 1000이상인 사람
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal >= 1000;

-- emp테이블에서 관리자(mgr) 사번이 7698이거나 급여가 1000(sal)이상인 직원 조회
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal >= 1000;

-- emp 테이블에서 관리자(mgr) 사번이 7698이 아니고, 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

-- 위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;

-- IN, NOT IN 연산자의 NULL 처리
-- emp 테이블에서 관리자(mgr) 사번이 7698, 7839 또는 NULL이 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
-- IN 연산자에서 결과값에 NULL이 있을 경우 의도하지 않은 동작을 한다.   

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
  AND mgr IS NOT NULL;

-- AND, OR 실습 where7)emp테이블, job이 SALESMAN이고 입사일자 810601이후
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');
   
-- AND, OR 실습 where8)emp테이블, 부서번호 10번아니고 입사일자 810601이후(IN, NOT IN사용 금지)
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');
   
-- AND, OR 실습 where9)emp테이블, 부서번호 10번아니고 입사일자 810601이후(NOT IN사용)
SELECT *
FROM emp
WHERE deptno NOT IN (10)
   AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');   
   
-- AND, OR 실습 where10)emp테이블, 부서번호 10번아니고 입사일자 810601이후
SELECT *
FROM emp
WHERE deptno IN (20, 30)
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD'); 
   
-- AND, OR 실습 where11)emp테이블, job이 SALESMAN이거나 입사일자 810601이후
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD'); 
   
-- AND, OR 실습 where12)emp테이블, job이 SALESMAN이거나 사원번호 78로 시작하는
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';  

-- AND, OR 실습 where13)emp테이블, job이 SALESMAN이거나 사원번호 78로 시작하는 (LIKE연산자 사용금지)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno >=7800
  AND empno < 7900;  
  
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;

-- AND, OR 실습 where14) emp테이블, job이 SALESMAN이거나 사원번호 78로 시작하면서 입사일자 810601이후
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%'
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');