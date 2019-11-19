--대전지역 한정
--버거킹, 맥도날드, KFC 개수
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE SIDO = '대전광역시'
AND gb IN ('버거킹','맥도날드','KFC')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;

--롯데리아
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE SIDO = '대전광역시'
AND gb IN ('롯데리아')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;

--전국
SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l, ROUND(a.cnt/b.cnt, 2) point
--140건
FROM (SELECT sido, sigungu, COUNT(*)cnt
        FROM fastfood
        WHERE gb IN ('버거킹','맥도날드','KFC')
        GROUP BY sido, sigungu)a,
        
        --188건
        (SELECT sido, sigungu, COUNT(*)cnt
        FROM fastfood
        WHERE gb IN ('롯데리아')
        GROUP BY sido, sigungu)b
WHERE a.sido = b.sido AND a.sigungu = b.sigungu
ORDER BY point desc;

------------------------------------------------------
SELECT *
FROM tax;

SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
FROM tax
ORDER BY sal desc;
--ORDER BY point desc;

--시도, 시군구, 버거지수, 시도, 시군구, 연말정산 납입액
SELECT f.sido, f.sigungu, f.point, t.sido, t.sigungu, t.sal
FROM 
    (SELECT ROWNUM frn, a.*
     FROM
      (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l, ROUND(a.cnt/b.cnt, 2) point
       FROM 
        (SELECT sido, sigungu, COUNT(*)cnt
         FROM fastfood
         WHERE gb IN ('버거킹','맥도날드','KFC')
         GROUP BY sido, sigungu)a,
        
        (SELECT sido, sigungu, COUNT(*)cnt
         FROM fastfood
         WHERE gb IN ('롯데리아')
         GROUP BY sido, sigungu)b
       WHERE a.sido = b.sido AND a.sigungu = b.sigungu
       ORDER BY point desc)a) f, 
    (SELECT a.*, ROWNUM trn
     FROM
      (SELECT sido, sigungu, sal
       FROM tax
       ORDER BY sal desc)a) t
WHERE f.frn = t.trn;



--emp_test 테이블 제거
DROP TABLE emp_test;

--multiple insert를 위한 테이블 생성
--empno, ename 두개의 컬럼을 갖는 emp_test, emp_test2 테이블을
--emp 테이블로부터 생성한다. (CTAS)
--데이터는 복제하지 않는다.
CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

--INSERT ALL
--하나의 INSERT SQL 문장으로 여러 테이블에 데이터를 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

--INSERT 데이터 확인
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT ALL 컬럼 정의
ROLLBACK;

INSERT ALL 
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 as empno, 'brown' as ename FROM dual UNION ALL
SELECT 2 as empno, 'sally' as ename FROM dual ;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--multiple insert ( conditional insert)
ROLLBACK;
INSERT ALL 
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE    --조건을 통과하지 못할 때만 실행
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual ;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT FIRST
--조건에 만족하는 첫번째 INSERT 구문만 실행
ROLLBACK;
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual ;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--MERGE : 조건에 만족하는 데이터가 있으면 UPDATE
--        조건에 만족하는 데이터가 없으면 INSERT  

--empno가 7369인 데이터를 emp테이블로 부터 복사 (insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;

SELECT *
FROM emp_test;

--emp테이블의 데이터 중 emp_test테이블의 empno와 같은 값을 갖는 데이터가 있을 경우
--emp_test.ename = ename || '_merge' 값으로 update
--데이터가 없을 경우에는 emp_test테이블에 insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
MERGE INTO emp_test
USING (SELECT empno, ename 
       FROM emp
       WHERE emp.empno IN(7369, 7499))emp
 ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN 
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    
SELECT *
FROM emp_test;

--다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로
--merge하는 경우
ROLLBACK;

--empno = 1, ename = 'brown'
--empno가 같은 값이 있으면 ename을 'brown'으로 update
--empno가 같은 값이 없으면 신규 insert
SELECT *
FROM emp_test;

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (1, 'brown');
    
--merge를 사용하지 않을 경우 아래 3개의 쿼리를 사용해야 한당!
SELECT 'X'
FROM emp_test
WHERE empno=1;

UPDATE emp_test SET ename = 'brown' || '_merge'
WHERE empno=1;

INSERT INTO emp_test VALUES (1, 'brown');
--

--GROUP_AD1
SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno

UNION ALL

--모든 직원의 급여 합
SELECT null, sum(sal)
FROM emp;

ORDER BY deptno, sal;

SELECT *
FROM emp;
--위 쿼리를 ROLLUP형태로 변경
SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);


--rollup
--group by의 서브 그룹을 생성
--GROUP BY ROLLUP( (col,))
--컬럼을 오른쪽에서부터 제거해가면서 나온 서브그룹을 
--GROUP BY하여 UNION한 것과 동일
--  ex : GROUP BY ROLLUP (job, deptno)
--       GROUP BY job, deptno
--       UNION
--       GROUP BY job
--       UNION
--       GROUP BY --> 총계 ( 모든 행에 대해 그룹함수 적용)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


--GROUPING SETS (col1, col2...)
--GROUPING SETS의 나열된 항목이 하나의 서브그룹으로 GROUP BY절에 이용된다.

--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp테이블을 이용하여 부서별 급여합과 담당업무(job)별 급여합을 구하시오

--부서번호, job, 급여합계
SELECT deptno, null job, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null deptno, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT job, deptno, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS (deptno, job, (deptno, job));