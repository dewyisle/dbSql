--SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ
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
                 
--������ �̿��� �������� ���
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN (:name1, :name2) );
                 
-- ANY : set�߿� �����ϴ°� �ϳ��� ������ ��(ũ��񱳿� ���)
-- SMITH�� WARD ���� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE sal < ANY(SELECT sal --800, 1250
                FROM emp
                WHERE ename IN('SMITH', 'WARD'));

SELECT sal --800, 1250 -->1250���� ���� �޿��� �޴� ����
FROM emp
ORDER BY sal;
WHERE ename IN('SMITH', 'WARD');

--SMITH�� WARD���� �޿��� ���� ���� ��ȸ
--SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal --800, 1250 -->1250���� ���� �޿��� �޴� ����
                FROM emp
                WHERE ename IN('SMITH', 'WARD'));
                
--NOT IN

--�������� ��������
--1. �������� ����� ��ȸ
-- .mgr �÷��� ���� ������ ����
--DISTINCT(�ߺ�����)
SELECT DISTINCT mgr
FROM emp;

--� ������ ������ ������ �ϴ� �������� ��ȸ
SELECT *
FROM emp
WHERE empno IN(7839,7782,7698,7902,7566,7788);

SELECT *
FROM emp
WHERE empno IN(SELECT mgr
               FROM emp);
               
--������ ������ ���� �ʴ� ���� ���� ��ȸ
-- �� NOT IN ������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
-- NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� �� ���
SELECT *
FROM emp    --7839,7782,7698,7902,7566,7788 ���� 6���� ����� ���Ե��� �ʴ� ����
WHERE empno NOT IN(SELECT NVL(mgr, -9999)
                   FROM emp);

--pair wise
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
--7698 30
-- 7839 10
--���� �߿� �����ڿ� �μ���ȣ�� (7698,30)�̰ų� (7839, 10)�� ���
--mgr, deptno �÷��� [����]�� ���� ��Ű�� �������� ��ȸ
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
              
--SCALAR SUBQUERY : SELECT ���� �����ϴ� ���� ����(�� ���� �ϳ��� ��, �ϳ��� �÷�)
-- ������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname
                              FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

--sub4 �����ͻ��� 
SELECT *
FROM deptno;

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

COMMIT;

-- �ǽ� sub4) ������ ������ ���� �μ� ��ȸ
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM emp);
                     
-- �ǽ� sub5) cycle, product ���̺� �̿� cid=1�� ���� �������� �ʴ� ��ǰ ��ȸ
SELECT pid, pnm
FROM product
WHERE pid NOT IN(SELECT pid
                 FROM cycle
                 WHERE cid = 1);
                 
-- �ǽ� sub6) cycle ���̺� �̿�, cid=2�� ���� �����ϴ� ��ǰ �� cid=1�� ���� �����ϴ� ��ǰ ��ȸ
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle
WHERE pid IN (SELECT pid FROM cycle WHERE cid=2) AND cid= 1;

-- �ǽ� sub7) cycle���̺� �̿�, cid=2�� �� �������� �� cid =1�� ���� �����ϴ� 
--          ��ǰ�� ���� ������ ��ȸ, ����� ��ǰ����� �����ϴ� �����ۼ�
SELECT c.cid, cnm, c.pid, pnm, day, cnt
FROM cycle c, product p, customer cm
WHERE c.pid = p.pid AND c.cid = cm.cid
AND c.pid IN (SELECT pid FROM cycle WHERE cid=2) AND c.cid=1;

--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);

--MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);

--EXISTS ������ - �ǽ� sub8)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- �ǽ� sub9)
SELECT *
FROM product
WHERE pid NOT IN(SELECT pid FROM cycle WHERE cid = 1);

SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'x' FROM cycle WHERE product.pid=pid AND cid=1);

--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(EXISTS)
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
              
--���տ���
--UNION : ������, �ߺ��� ����
--        DBMS������ �ߺ��� �����ϱ� ���� �����͸� ����
--        (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--UNION ALL : UNION�� ���� ����
--            �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� => �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ�
--            UNION�����ں��� ���ɸ鿡�� ����  
-- ����� 7566 �Ǵ� 7698�� ��� ��ȸ(����̶� �̸�)

SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--����� 7369, 7499 �� ��� ��ȸ (���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno =7369 OR empno = 7499;

--UNION ALL(�ߺ����, ���Ʒ� ������ ��ġ�⸸ �Ѵ�.)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno =7566 OR empno = 7698;

--INTERSECT (������ : �� �Ʒ� ���հ� ���뵥����)
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--MINUS(������ : �� ���տ��� �Ʒ������� ����)
-- ������ ����
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--������ ���Ʒ� �ٲ㺽!
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