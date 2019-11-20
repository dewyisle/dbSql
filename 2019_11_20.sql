--GROUPING(cube, rollup절의 사용된 컬럼)
--해당컬럼이 소계 계산에 사용된 경우 1
--사용되지 않은 경우 0

--job 컬럼
--case1. GROUPING(job)=1 AND GROUPING(deptno) =1
--       job --> 총계
--case else
--       job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND 
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE job
       END job,
       CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job || ' 소계 :'
            ELSE TO_CHAR(deptno)
        END deptno,
        sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--실습 GROUP_AD3)
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '총계'
            ELSE TO_CHAR(deptno)
        END deptno,
       CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 0 THEN '부서 소계 :'
            ELSE job
        END job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);


--CUBE (col, col2...)
--CUBE절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
--CUBE에 나열된 컬럼에 대해 방향성은 없다(rollup과의 차이)
--GROUP BY CUBE(job, deptno)
--00 : GROUP BY job, deptno
--0X : GROUP BY job
--X0 : GROUP BY deptno
--XX : GROUP BY --모든 데이터에 대해서...
SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

--GROUP BY 복습
SELECT deptno, COUNT(ename) 사원수, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY deptno, job;
--

-- subquery를 통한 업데이트
DROP TABLE emp_test;

--emp테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test테이블로 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test 테이블의 dept테이블에서 관리되고있는 dname컬럼(VARCHAR2(14))을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test테이블의 dname컬럼을 dept테이블의 dname컬럼 값으로 업데이트하는 쿼리 작성
UPDATE emp_test SET dname = (SELECT dname 
                             FROM dept 
                             WHERE dept.deptno = emp_test.deptno);
--WHERE empno IN (72369,7499);                      
COMMIT;                  

--correlated subquery update 실습 sub_al)
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt = (SELECT COUNT(dname)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY dname) ;
                                
--선생님 쿼리 (이렇게 하면 데이터가 없는 경우 0으로 들어감) 
UPDATE dept_test SET empcnt = (SELECT COUNT(*)
                                FROM emp
                                WHERE deptno = dept_test.deptno) ;

SELECT *
FROM dept_test;
ROLLBACK;

SELECT COUNT(dname)
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dname;

--correlated subquery delete 실습 sub_a2)
INSERT INTO dept_test VALUES (98, 'it', 'daejeon', 0);
INSERT INTO dept_test VALUES (99, 'it', 'daejeon', 0);

DELETE dept_test WHERE NOT EXISTS (SELECT 'X'
                                   FROM emp
                                   WHERE deptno = dept_test.deptno);
                                      
SELECT * 
FROM dept_test;

SELECT * 
FROM dept_test
WHERE NOT EXISTS(SELECT 'X' FROM emp WHERE deptno = dept_test.deptno);  

SELECT *
FROM dept_test
WHERE empcnt not in (select count(*) FROM emp WHERE deptno = dept_test.deptno 
                        group by deptno);
                        
--correlated subquery delete 실습 sub_a2)
UPDATE emp_test a SET sal = sal+200 
                WHERE sal < (SELECT ROUND(AVG(sal), 2) avg
                            FROM emp_test b
                            WHERE a.deptno = b.deptno);

--평균보다 급여 작은 애들!
SELECT *
FROM emp_test a
WHERE sal < (SELECT ROUND(AVG(sal), 2) avg
            FROM emp_test b
            WHERE a.deptno = b.deptno);
--부서별 평균급여!
SELECT ROUND(AVG(sal), 2) avg
FROM emp_test
GROUP BY deptno;

SELECT *
FROM emp_test;

-- emp, emp_test empno 컬럼으로 같은 값끼리 조회
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
--2. emp.empno, emp.ename, emp.sal, emp_test.sal,
--  해당사원(emp테이블 기준)이 속한 부서의 급여평균

SELECT emp.empno, emp.ename, emp.sal, et.sal
FROM emp, emp_test et
WHERE emp.empno = et.empno;

SELECT emp.empno, emp.ename, emp.sal, et.sal, a.avg
FROM emp, emp_test et, (SELECT deptno, ROUND(AVG(emp.sal), 2) avg
                        FROM emp
                        GROUP BY deptno)a
WHERE emp.empno = et.empno AND et.deptno = a.deptno;


SELECT ROUND(AVG(emp.sal), 2) avg
                        FROM emp
                        GROUP BY deptno;
                        

--과제 SQL응용PPT 26,27
--p26/ 실습 GROUP_AD4)
SELECT dname, job, SUM(sal) sal
FROM emp, dept 
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname;

--p26/ 실습 GROUP_AD5)
SELECT CASE WHEN GROUPING(dname) = 1
             AND GROUPING(job) = 1 THEN '총합'
            ELSE dname
        END dname, job, SUM(sal) sal
FROM emp, dept 
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname;