--�������� ����
--����ŷ, �Ƶ�����, KFC ����
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE SIDO = '����������'
AND gb IN ('����ŷ','�Ƶ�����','KFC')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;

--�Ե�����
SELECT sido, sigungu, COUNT(*)
FROM fastfood
WHERE SIDO = '����������'
AND gb IN ('�Ե�����')
GROUP BY sido, sigungu;
ORDER BY sido, sigungu, gb;

--����
SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l, ROUND(a.cnt/b.cnt, 2) point
--140��
FROM (SELECT sido, sigungu, COUNT(*)cnt
        FROM fastfood
        WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
        GROUP BY sido, sigungu)a,
        
        --188��
        (SELECT sido, sigungu, COUNT(*)cnt
        FROM fastfood
        WHERE gb IN ('�Ե�����')
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

--�õ�, �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�
SELECT f.sido, f.sigungu, f.point, t.sido, t.sigungu, t.sal
FROM 
    (SELECT ROWNUM frn, a.*
     FROM
      (SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l, ROUND(a.cnt/b.cnt, 2) point
       FROM 
        (SELECT sido, sigungu, COUNT(*)cnt
         FROM fastfood
         WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
         GROUP BY sido, sigungu)a,
        
        (SELECT sido, sigungu, COUNT(*)cnt
         FROM fastfood
         WHERE gb IN ('�Ե�����')
         GROUP BY sido, sigungu)b
       WHERE a.sido = b.sido AND a.sigungu = b.sigungu
       ORDER BY point desc)a) f, 
    (SELECT a.*, ROWNUM trn
     FROM
      (SELECT sido, sigungu, sal
       FROM tax
       ORDER BY sal desc)a) t
WHERE f.frn = t.trn;



--emp_test ���̺� ����
DROP TABLE emp_test;

--multiple insert�� ���� ���̺� ����
--empno, ename �ΰ��� �÷��� ���� emp_test, emp_test2 ���̺���
--emp ���̺�κ��� �����Ѵ�. (CTAS)
--�����ʹ� �������� �ʴ´�.
CREATE TABLE emp_test AS;
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

--INSERT ALL
--�ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

--INSERT ������ Ȯ��
SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT ALL �÷� ����
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
    ELSE    --������ ������� ���� ���� ����
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual ;

SELECT *
FROM emp_test;

SELECT *
FROM emp_test2;

--INSERT FIRST
--���ǿ� �����ϴ� ù��° INSERT ������ ����
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

--MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--        ���ǿ� �����ϴ� �����Ͱ� ������ INSERT  

--empno�� 7369�� �����͸� emp���̺�� ���� ���� (insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno = 7369;

SELECT *
FROM emp_test;

--emp���̺��� ������ �� emp_test���̺��� empno�� ���� ���� ���� �����Ͱ� ���� ���
--emp_test.ename = ename || '_merge' ������ update
--�����Ͱ� ���� ��쿡�� emp_test���̺� insert
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

--�ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������
--merge�ϴ� ���
ROLLBACK;

--empno = 1, ename = 'brown'
--empno�� ���� ���� ������ ename�� 'brown'���� update
--empno�� ���� ���� ������ �ű� insert
SELECT *
FROM emp_test;

MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (1, 'brown');
    
--merge�� ������� ���� ��� �Ʒ� 3���� ������ ����ؾ� �Ѵ�!
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

--��� ������ �޿� ��
SELECT null, sum(sal)
FROM emp;

ORDER BY deptno, sal;

SELECT *
FROM emp;
--�� ������ ROLLUP���·� ����
SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);


--rollup
--group by�� ���� �׷��� ����
--GROUP BY ROLLUP( (col,))
--�÷��� �����ʿ������� �����ذ��鼭 ���� ����׷��� 
--GROUP BY�Ͽ� UNION�� �Ͱ� ����
--  ex : GROUP BY ROLLUP (job, deptno)
--       GROUP BY job, deptno
--       UNION
--       GROUP BY job
--       UNION
--       GROUP BY --> �Ѱ� ( ��� �࿡ ���� �׷��Լ� ����)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


--GROUPING SETS (col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY���� �̿�ȴ�.

--GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp���̺��� �̿��Ͽ� �μ��� �޿��հ� ������(job)�� �޿����� ���Ͻÿ�

--�μ���ȣ, job, �޿��հ�
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