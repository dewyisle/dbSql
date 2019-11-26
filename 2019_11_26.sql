--�м��Լ�
SELECT ename, sal, deptno, 
        RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) d_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rown
FROM emp;

--window�Լ� (�ǽ� ana1) ����� ��ü�޿������� rank���� �м��Լ��� �̿��Ͽ� ���ϼ���
--                      ��, �޿��� ������ ��� ����� ���� ����� ��������.
SELECT empno, ename, sal, deptno,
        RANK() OVER (ORDER BY sal DESC, empno) rank,
        DENSE_RANK() OVER (ORDER BY sal DESC, empno) d_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC, empno) rown
FROM emp;

--window�Լ� (�ǽ� no_ana2) ����� -> ���, �̸�, �ش����� ���� �μ��� ����� ��ȸ
SELECT empno, ename, emp.deptno, cnt
FROM emp,
    (SELECT deptno, COUNT(deptno) cnt
    FROM emp
    GROUP BY deptno)b
WHERE emp.deptno = b.deptno
ORDER BY deptno;

 --�м��Լ��� ���Ѻμ��� ������
SELECT ename, empno, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--�μ��� ����� �޿��հ�
-- SUM�м��Լ�
SELECT ename, empno, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno) sum_sal
FROM emp;

--window�Լ� (�ǽ� ana2)
SELECT empno, ename, sal,deptno,
    ROUND((AVG(sal) OVER (PARTITION BY deptno)), 2) cnt
FROM emp;

--window�Լ� (�ǽ� ana3)
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--window�Լ� (�ǽ� ana4)
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--�μ��� �����ȣ�� ���� �������
--�μ��� �����ȣ�� ���� �������,
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER (PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG(������)
--������
--LEAD(������)
--�޿��� ���� ������ ���� ���� �� �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--                            �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�
SELECT empno, ename, sal, 
        LAG(sal) OVER (ORDER BY sal) lag_sal,
        LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;

--�ǽ�ana5
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER By sal DESC, hiredate) lead_sal
FROM emp;

--�ǽ�ana6
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER By sal DESC, hiredate) lag_sal
FROM emp;

--�ǽ� no_ana3)
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
--UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� �����
--CURRENT ROW : ������
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� �����
--N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

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
        --RANGE�� �ߺ����� ������ �ߺ����� ���� SUM(������)
        SUM(sal) OVER (ORDER BY sal
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ran_sum,
        SUM(sal) OVER (ORDER BY sal
        RANGE UNBOUNDED PRECEDING) ran_sum2
FROM emp;