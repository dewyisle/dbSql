--GROUPING(cube, rollup���� ���� �÷�)
--�ش��÷��� �Ұ� ��꿡 ���� ��� 1
--������ ���� ��� 0

--job �÷�
--case1. GROUPING(job)=1 AND GROUPING(deptno) =1
--       job --> �Ѱ�
--case else
--       job --> job
SELECT CASE WHEN GROUPING(job) = 1 AND 
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE job
       END job,
       CASE WHEN GROUPING(job) = 0 AND
                 GROUPING(deptno) = 1 THEN job || ' �Ұ� :'
            ELSE TO_CHAR(deptno)
        END deptno,
        sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--�ǽ� GROUP_AD3)
SELECT deptno, job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

SELECT CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 1 THEN '�Ѱ�'
            ELSE TO_CHAR(deptno)
        END deptno,
       CASE WHEN GROUPING(job) = 1 AND
                 GROUPING(deptno) = 0 THEN '�μ� �Ұ� :'
            ELSE job
        END job, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);


--CUBE (col, col2...)
--CUBE���� ������ �÷��� ������ ��� ���տ� ���� ���� �׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����(rollup���� ����)
--GROUP BY CUBE(job, deptno)
--00 : GROUP BY job, deptno
--0X : GROUP BY job
--X0 : GROUP BY deptno
--XX : GROUP BY --��� �����Ϳ� ���ؼ�...
SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);

--GROUP BY ����
SELECT deptno, COUNT(ename) �����, SUM(sal)
FROM emp
GROUP BY deptno;

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY deptno, job;
--

-- subquery�� ���� ������Ʈ
DROP TABLE emp_test;

--emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test ���̺��� dept���̺��� �����ǰ��ִ� dname�÷�(VARCHAR2(14))�� �߰�
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

--emp_test���̺��� dname�÷��� dept���̺��� dname�÷� ������ ������Ʈ�ϴ� ���� �ۼ�
UPDATE emp_test SET dname = (SELECT dname 
                             FROM dept 
                             WHERE dept.deptno = emp_test.deptno);
--WHERE empno IN (72369,7499);                      
COMMIT;                  

--correlated subquery update �ǽ� sub_al)
DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt = (SELECT COUNT(dname)
                                FROM emp
                                WHERE emp.deptno = dept_test.deptno
                                GROUP BY dname) ;
                                
--������ ���� (�̷��� �ϸ� �����Ͱ� ���� ��� 0���� ��) 
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

--correlated subquery delete �ǽ� sub_a2)
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
                        
--correlated subquery delete �ǽ� sub_a2)
UPDATE emp_test a SET sal = sal+200 
                WHERE sal < (SELECT ROUND(AVG(sal), 2) avg
                            FROM emp_test b
                            WHERE a.deptno = b.deptno);

--��պ��� �޿� ���� �ֵ�!
SELECT *
FROM emp_test a
WHERE sal < (SELECT ROUND(AVG(sal), 2) avg
            FROM emp_test b
            WHERE a.deptno = b.deptno);
--�μ��� ��ձ޿�!
SELECT ROUND(AVG(sal), 2) avg
FROM emp_test
GROUP BY deptno;

SELECT *
FROM emp_test;

-- emp, emp_test empno �÷����� ���� ������ ��ȸ
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
--2. emp.empno, emp.ename, emp.sal, emp_test.sal,
--  �ش���(emp���̺� ����)�� ���� �μ��� �޿����

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
                        

--���� SQL����PPT 26,27
--p26/ �ǽ� GROUP_AD4)
SELECT dname, job, SUM(sal) sal
FROM emp, dept 
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname;

--p26/ �ǽ� GROUP_AD5)
SELECT CASE WHEN GROUPING(dname) = 1
             AND GROUPING(job) = 1 THEN '����'
            ELSE dname
        END dname, job, SUM(sal) sal
FROM emp, dept 
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP (dname, job)
ORDER BY dname;