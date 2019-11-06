--그룹함수
--multi row function : 여러개의 행을 입력으로 하나의 열과 행을 생성
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능

-- 직원중 가장 높은 급여 조회 
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM emp;

-- group function 실습 grp3)
SELECT decode(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
       MAX(sal) max_sal, 
       MIN(sal) min_sal, 
       ROUND(AVG(sal), 2),
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY dname;

-- group function 실습 grp4)
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm,
       COUNT(*) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

-- group function 실습 grp5)
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy,
       COUNT(*) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY hire_yyyy;

-- group function 실습 grp6)
SELECT COUNT(deptno) cnt --COUNT(*) cnt 와 같음
FROM dept;

-- distinct 중복제거
SELECT distinct deptno
FROM emp;

--JOIN
--emp 테이블에는 dname 컬럼이 없다  --> 부서번호(deptno)밖에 없음
desc emp;

--emp테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

--데이터업데이트
UPDATE emp SET dname = 'ACCOUNTING' WHERE deptno =10;
UPDATE emp SET dname = 'RESEARCH' WHERE deptno =20;
UPDATE emp SET dname = 'SALES' WHERE deptno =30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP By dname;

ALTER TABLE emp DROP COLUMN DNAME;

SELECT *
FROM emp;

--ansi natural join : 테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN
SELECT deptno, ename, dname
FROM emp NATURAL JOIN dept;

--ORACLE JOIN
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from 절에 조인 대상 테이블 나열
--where 절에 조인조건 기술
--기존에 사용하던 조건 제약도 기술가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; --job이 SALES인 사람만 대상으로 조회
  
--순서가 없다(WHERE절 순서 바꿔도 같은 결과)!
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
  AND emp.deptno = dept.deptno;

--JOIN with ON (개발자가 조인 컬럼은 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

--SELF join : 같은 테이블끼리 조인
--emp테이블의 mgr정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
--a : 직원정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno 
  AND a.empno BETWEEN 7369 AND 7698;
  
--non-equijoing (등식 조인이 아닌 경우)
SELECT *
FROM salgrade;

--직원의 급여 등급은?
SELECT *
FROM emp;

--oracle
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

--ansi
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

----------------
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno 
  AND a.empno = 7369;
  
--non eqoi join
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno = 7369;
  
-- 실습 join0)
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno;

-- 실습 join0_1)
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno IN (10, 30);
--ORDER BY deptno;

SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND (emp.deptno = 10
   OR emp.deptno = 30);

SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND dept.deptno IN (10, 30);
  
-- 실습 join0_2)
SELECT emp.empno, emp.ename, emp.sal, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.sal > 2500
ORDER BY dept.dname;

-- 실습 join0_3)
SELECT emp.empno, emp.ename, emp.sal, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500 AND empno > 7600
ORDER BY dept.dname;

-- 실습 join0_4)
SELECT emp.empno, emp.ename, emp.sal, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY dept.dname;

