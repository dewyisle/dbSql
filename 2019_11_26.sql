--분석함수
SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) d_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rown
FROM emp;

--window함수 (실습 ana1) 사원의 전체급여순위를 rank등의 분석함수를 이용하여 구하세요
--                      단, 급여가 동일할 경우 사번이 빠른 사람이 높은순위.
SELECT empno, ename, sal, deptno,
        RANK() OVER (ORDER BY sal DESC, empno) rank,
        DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;

--window함수 (실습 no_ana2) 모든사원 -> 사번, 이름, 해당사원이 속한 부서의 사원수 조회
SELECT empno, ename, emp.deptno, cnt
FROM emp,
    (SELECT deptno, COUNT(deptno) cnt
    FROM emp
    GROUP BY deptno)b
WHERE emp.deptno = b.deptno
ORDER BY deptno;

 --분석함수를 통한부서별 직원수
SELECT ename, empno, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--부서별 사원의 급여합계
-- SUM분석함수
SELECT ename, empno, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--window함수 (실습 ana2)
SELECT empno, ename, sal,deptno,
    ROUND((AVG(sal) OVER (PARTITION BY deptno)), 2) cnt
FROM emp;

--window함수 (실습 ana3)
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--window함수 (실습 ana4)
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--부서별 사원번호가 가장 빠른사람
--부서별 사원번호가 가장 느린사람,
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG(이전행)
--현재행
--LEAD(다음행)
--급여가 높은 순으로 정렬 했을 때 자기보다 한단계 급여가 낮은 사람의 급여,
--                            자기보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, sal, 
        LAG(sal) OVER (ORDER BY sal) lag_sal,
        LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

--실습ana5
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER By sal DESC, hiredate) lead_sal
FROM emp;

--실습ana6
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER By sal DESC, hiredate) lag_sal
FROM emp;

--실습 no_ana3)
SELECT a.empno, a.ename, a.sal, SUM(b.sal) C_SUM
FROM 
    (SELECT a.*, rownum rn
    FROM 
        (SELECT *
        FROM emp
        ORDER BY sal)a)a,
    (SELECT a.*, rownum rn
    FROM 
        (SELECT *
        FROM emp
        ORDER BY sal, empno)a)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal, a.rn
ORDER BY a.rn, a.empno ;

--WINDOWING
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든행
--CURRENT ROW : 현재행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal,
        
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,
        
        SUM(sal) OVER (ORDER BY sal, empno 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3
FROM emp;

--ana7
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
        
        SUM(sal) OVER (ORDER BY sal
        ROWS UNBOUNDED PRECEDING) row_sum2,
        --RANGE는 중복값이 있으면 중복값도 같이 SUM(더해줌)
        SUM(sal) OVER (ORDER BY sal
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ran_sum,
        SUM(sal) OVER (ORDER BY sal
        RANGE UNBOUNDED PRECEDING) ran_sum2
FROM emp;