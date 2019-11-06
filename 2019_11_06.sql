--�׷��Լ�
--multi row function : �������� ���� �Է����� �ϳ��� ���� ���� ����
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT ������ GROUP BY ���� ����� COL, EXPRESS ǥ�� ����

-- ������ ���� ���� �޿� ��ȸ 
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

--�μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM emp;

-- group function �ǽ� grp3)
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

-- group function �ǽ� grp4)
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm,
       COUNT(*) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

-- group function �ǽ� grp5)
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyy,
       COUNT(*) CNT
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY hire_yyyy;

-- group function �ǽ� grp6)
SELECT COUNT(deptno) cnt --COUNT(*) cnt �� ����
FROM dept;

-- distinct �ߺ�����
SELECT distinct deptno
FROM emp;

--JOIN
--emp ���̺��� dname �÷��� ����  --> �μ���ȣ(deptno)�ۿ� ����
desc emp;

--emp���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

--�����;�����Ʈ
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

--ansi natural join : ���̺��� �÷����� ���� �÷��� �������� JOIN
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

--from ���� ���� ��� ���̺� ����
--where ���� �������� ���
--������ ����ϴ� ���� ���൵ �������
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; --job�� SALES�� ����� ������� ��ȸ
  
--������ ����(WHERE�� ���� �ٲ㵵 ���� ���)!
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.job = 'SALESMAN'
  AND emp.deptno = dept.deptno;

--JOIN with ON (�����ڰ� ���� �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

--SELF join : ���� ���̺��� ����
--emp���̺��� mgr������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
--a : ��������, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno 
  AND a.empno BETWEEN 7369 AND 7698;
  
--non-equijoing (��� ������ �ƴ� ���)
SELECT *
FROM salgrade;

--������ �޿� �����?
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
  
-- �ǽ� join0)
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno;

-- �ǽ� join0_1)
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
  
-- �ǽ� join0_2)
SELECT emp.empno, emp.ename, emp.sal, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.sal > 2500
ORDER BY dept.dname;

-- �ǽ� join0_3)
SELECT emp.empno, emp.ename, emp.sal, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500 AND empno > 7600
ORDER BY dept.dname;

-- �ǽ� join0_4)
SELECT emp.empno, emp.ename, emp.sal, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY dept.dname;

