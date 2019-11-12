--SMITH, WARD가 속하는 부서의 직원들 조회
SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;
   
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD') );
                 
--변수를 이용해 동적으로 사용
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN (:name1, :name2) );
                 
-- ANY : set중에 만족하는게 하나라도 있으면 참(크기비교에 사용)
-- SMITH나 WARD 보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal --800, 1250
                FROM emp
                WHERE ename IN('SMITH', 'WARD'));

SELECT sal --800, 1250 -->1250보다 적은 급여를 받는 직원
FROM emp
ORDER BY sal;
WHERE ename IN('SMITH', 'WARD');

--SMITH와 WARD보다 급여가 높은 직원 조회
--SMITH보다도 급여가 높고 WARD보다도 급여가 높은 사람(AND)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal --800, 1250 -->1250보다 높은 급여를 받는 직원
                FROM emp
                WHERE ename IN('SMITH', 'WARD'));
                
--NOT IN

--관리자의 직원정보
--1. 관리자인 사람만 조회
-- .mgr 컬럼에 값이 나오는 직원
--DISTINCT(중복제거)
SELECT DISTINCT mgr
FROM emp;

--어떤 직원의 관리자 역할을 하는 직원정보 조회
SELECT *
FROM emp
WHERE empno IN(7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE empno IN(SELECT mgr
               FROM emp);
               
--관리자 역할을 하지 않는 평사원 정보 조회
-- 단 NOT IN 연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
-- NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 후 사용
SELECT *
FROM emp    --7839,7782,7698,7902,7566,7788 다음 6개의 사번에 포함되지 않는 직원
WHERE empno NOT IN(SELECT NVL(mgr, -9999)
                   FROM emp);

--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
--7698 30
-- 7839 10
--직원 중에 관리자와 부서번호가 (7698,30)이거나 (7839, 10)인 사람
--mgr, deptno 컬럼을 [동시]에 만족 시키는 직원정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN(SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499,7782));
                        
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499,7782));
              
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
              FROM emp
              WHERE empno IN (7499,7782));
              
--SCALAR SUBQUERY : SELECT 절에 등장하는 서브 쿼리(단 값이 하나의 행, 하나의 컬럼)
-- 직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

--sub4 데이터생성 
SELECT *
FROM deptno;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

COMMIT;

-- 실습 sub4) 직원이 속하지 않은 부서 조회
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);
                     
-- 실습 sub5) cycle, product 테이블 이용 cid=1인 고객이 애음하지 않는 제품 조회
SELECT pid, pnm
FROM product
WHERE pid NOT IN(SELECT pid
                 FROM cycle
                 WHERE cid = 1);
                 
-- 실습 sub6) cycle 테이블 이용, cid=2인 고객이 애음하는 제품 중 cid=1인 고객도 애음하는 제품 조회
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle
WHERE pid IN (SELECT pid FROM cycle WHERE cid=2) AND cid= 1;

-- 실습 sub7) cycle테이블 이용, cid=2인 고객 애음제춤 중 cid =1인 고객도 애음하는 
--          제품의 애음 정보를 조회, 고객명과 제품명까지 포함하는 쿼리작성
SELECT c.cid, cnm, c.pid, pnm, day, cnt
FROM cycle c, product p, customer cm
WHERE c.pid = p.pid AND c.cid = cm.cid
AND c.pid IN (SELECT pid FROM cycle WHERE cid=2) AND c.cid=1;

--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에 성능면에서 유리

--MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);

--MGR가 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);

--EXISTS 연산자 - 실습 sub8)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- 실습 sub9)
SELECT *
FROM product
WHERE pid NOT IN(SELECT pid FROM cycle WHERE cid = 1);

SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'x' FROM cycle WHERE product.pid=pid AND cid=1);

--부서에 소속된 직원이 있는 부서 정보 조회(EXISTS)
SELECT *
FROM dept
WHERE EXISTS (SELECT 'x'
              FROM emp
              WHERE deptno = dept.deptno);
--IN
SELECT *
FROM dept
WHERE deptno IN (SELECT deptno
              FROM emp);
              
--집합연산
--UNION : 합집합, 중복을 제거
--        DBMS에서는 중복을 제거하기 위해 데이터를 정렬
--        (대량의 데이터에 대해 정렬시 부하)
--UNION ALL : UNION과 같은 개념
--            중복을 제거하지 않고, 위 아래 집합을 결합 => 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--            UNION연산자보다 성능면에서 유리  
-- 사번이 7566 또는 7698인 사원 조회(사번이랑 이름)

SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--사번이 7369, 7499 인 사원 조회 (사번, 이름)
SELECT empno, ename
FROM emp
WHERE empno =7369 OR empno = 7499;

--UNION ALL(중복허용, 위아래 집합을 합치기만 한다.)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno =7566 OR empno = 7698;

--INTERSECT (교집합 : 위 아래 집합간 공통데이터)
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--MINUS(차집합 : 위 집합에서 아래집합을 제거)
-- 순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--차집합 위아래 바꿔봄!
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369);

SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC01'
AND TABLE_NAME IN ('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN ('P', 'R');