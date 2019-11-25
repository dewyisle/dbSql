--member테이블을 이용하여 member2 테이블 생성
--member2테이블에서 
--김은대 회원(mem_id='a001')의 직업(mem_job)을 '군인'으로 변경 후 commit하고 조회

CREATE TABLE member2 AS
SELECT *
FROM member;

UPDATE member2 SET mem_job='군인'
WHERE mem_id = 'a001';

COMMIT;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id='a001';

--buyprod에서
--제품별 제품 구매 수량(buy_qty) 합계, 제품 구매 금액(buy_cost) 합계
--제품코드, 제품명, 수량합계, 금액합계
SELECT buy_prod, prod_name, sum_qty, sum_cost
FROM
(SELECT buy_prod, SUM(buy_qty) sum_qty, sum(buy_cost) sum_cost
FROM buyprod
GROUP BY buy_prod)a, prod b
WHERE a.buy_prod = b.prod_id;

--VW_PROD_BUY(view생성)
CREATE OR REPLACE VIEW VW_PROD_BUY AS
SELECT buy_prod, prod_name, sum_qty, sum_cost
FROM
    (SELECT buy_prod, SUM(buy_qty) sum_qty, sum(buy_cost) sum_cost
    FROM buyprod
    GROUP BY buy_prod)a, prod b
WHERE a.buy_prod = b.prod_id;

SELECT *
FROM USER_VIEWS;

--window함수 도전해보기 실습 ana0) 사원의 부서별 급여(sal)별 순위 구하기
--선생님쿼리
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
    FROM
        (SELECT ename, sal, deptno
        FROM emp
        ORDER BY deptno, sal DESC)a)a,
    (SELECT b.rn, ROWNUM j_rn
    FROM
        (SELECT a.deptno, b.rn
        FROM
            (SELECT deptno, COUNT(*) cnt --3,5,6
            FROM emp
            GROUP BY deptno)a,
            (SELECT ROWNUM rn
            FROM emp)b
        WHERE a.cnt >= b.rn
        ORDER BY a.deptno, b.rn)b)b
WHERE a.j_rn=b.j_rn;

--분석함수(window함수)를 통해 위의 복잡한 쿼리를 간단하게 작성할 수 있다.
SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;
