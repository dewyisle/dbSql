--조인복습
-- 조인 왜 씀?
-- RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
-- EMP테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는
-- 부서 번호만 갖고있고, 부서번호를 통해 dept테이블과 조인을 통해 
-- 해당 부서의 정보를 가져올 수 있다.

--직원 번호, 직원이름, 직원의 소속 부서번호, 부서이름
--emp, dept
SELECT emp.empno, emp.ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--부서번호, 부서명, 해당부서의 인원수
--count(col) : col값이 존재하면 1, null : 0
--             행수가 궁금한 것이면 *
SELECT dept.deptno, dept.dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dept.deptno, dept.dname;

--TOTAL ROW : 14
SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;

--OUTER JOIN : 조인에 실패해도 기준이 되는 테이블의 데이터는 조회결과가 
--             나오도록 하는 조인 형태
--LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록
--                  하는 조인 형태
--RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이 
--                  되도록 하는 조인 형태
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

--직원정보와, 해당 직원의 관리자 정보 outer join
--직원정보, 직원이름, 관리자번호, 관리자 이름
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp  a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp  a JOIN emp b ON(a.mgr = b.empno);

--oracle outer join(left, right만 존재 fullouter는 지원하지않음)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr,b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr,b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno = 10);

--oracle outer 문법에서는 outer테이블이 되는 모든 컬럼에 (+)를 붙여줘야
--outer joining이 정상적으로 작동한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
  AND b.deptno(+) = 10;
  
--ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);

--outer join 실습 outerjoin1)
SELECT  b.buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                       AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--oracle
SELECT b.buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outer join 실습 outerjoin2)
SELECT  TO_DATE('05/01/25', 'YY/MM/DD'), buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                       AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--outer join 실습 outerjoin3)
SELECT  TO_DATE('05/01/25', 'YY/MM/DD'), buy_prod, prod_id, prod_name, nvl(buy_qty, 0)
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                       AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--outer join 실습 outerjoin4)
SELECT p.pid, pnm, nvl(cid, 1)cid, nvl(day, 0)day, nvl(cnt, 0)cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
  AND cid(+) = 1;

--outer join 실습 outerjoin5)
SELECT a.pid, pnm, a.cid, cm.cnm, day, cnt
FROM customer cm,
    (SELECT p.pid, pnm, nvl(cid, 1)cid, nvl(day, 0)day, nvl(cnt, 0)cnt
    FROM cycle c, product p
    WHERE c.pid(+) = p.pid
      AND cid(+) = 1) a
WHERE a.cid = cm.cid
  AND cnm = 'brown';  
  
--cross join 실습 crossjoin1)
SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

--subquery : main쿼리에 속하는 부분 쿼리
--사용되는 위치 : 
-- SELECT - scalar subquery (하나의 행과, 하나의 컬럼만 조회되는 쿼리이어야 한다.)
-- FROM - inline view
-- WHERE - subquery

--SCALAR subquery
SELECT empno, ename, SYSDATE now/*현재날짜*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now/*현재날짜*/
FROM emp;

--SMITH씨가 속한 부서의 모든 사원정보 
--1. SMITH씨 부서번호(이 쿼리 자체가 20이라는 값을 가짐?!)
SELECT deptno --20
FROM emp
WHERE ename = 'SMITH';
--2. 20번 부서에 몇명있누?
SELECT *
FROM emp
WHERE deptno = 20;
--3. 쿼리 합쳐준다
SELECT *
FROM emp
WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH');

--서브쿼리 실습 sub1) 평균 급여보다 높은 급여 받는 직원수 조회
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT ROUND(AVG(sal), 2)
             FROM emp);

--서브쿼리 실습 sub2) 평균 급여보다 높은 급여 받는 직원정보 조회
SELECT *
FROM emp
WHERE sal > (SELECT ROUND(AVG(sal), 2)
             FROM emp);
             
--서브쿼리 실습 sub3)
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));