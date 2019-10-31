-- ���̺��� ������ ��ȸ
/*
    SELECT �÷� | express (���ڿ� ���) [as] ��Ī
    From �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)
*/

DESC user_tables;

SELECT table_name, 'SELECT * FROM ' || table_name || ';' AS select_query
FROM user_tables
WHERE table_name != 'EMP'; -- ��ü�Ǽ� -1

-- ���ں� ����
-- �μ���ȣ�� 30�� ���� ũ�ų� ���� �μ��� ���� ������ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

-- �μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

-- �Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
-- WHERE hiredate < '82/01/01';
WHERE hiredate < TO_DATE('01011982', 'MMDDYYYY'); --11��(�̱���¥��)
-- WHERE hiredate < TO_DATE('1982/01/01', 'YYYY/MM/DD'); -- 11��
-- WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD'); -- 3��
-- WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');

-- col BERWEEN X AMD Y ����
-- �÷��� ���� x���� ũ�ų� ����, y���� �۰ų� ���� ������
-- �޿� (sal)�� 1000���� ũ�ų� ����, Y���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

-- ���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����.
SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 30;

-- BTWEEN..and.. �ǽ� where1)emp ���̺�, �Ի����� 820101���ĺ��� 830101���� ��� ename, hiredate������ ��ȸ
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN To_DATE('1982/01/01', 'YYYY/MM/DD') AND TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- >=, >... �ǽ� where2)���ǿ� �´� ������ ��ȸ�ϱ�
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD') 
  AND hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD');

-- In ������
-- COL IN (values..)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno IN (10, 20); 

-- IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno = 10 
   OR deptno = 20; 

-- IN �ǽ� where3) users ���̺�, userid�� brown, cony, sally�� ������ (IN���)
SELECT userid ���̵�, usernm �̸�
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

-- COL LIKE 'S%'
-- COL�� ���� �빮�� S�� �����ϴ� ��� ��
-- COL LIKE 'S____'
-- COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

-- EMP ���̺��� �����̸��� S�� �����ϴ� ��� ���� ��ȸ
-- 'smith' �� 'SMITH'�� �ٸ� �÷��� ���� ��ҹ��� ������!
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

-- LIKE, %, _ �ǽ� where4)member���̺�, ����[��]���� ��� mem_id, mem_name ��ȸ
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

-- LIKE, %, _ �ǽ� where5)member���̺�, ȸ���̸��� ����[��]�� ���� ��� ��� mem_id, mem_name ��ȸ
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%'; -- mem_name�� ���ڿ� �ȿ� ���� ���Ե� ������ 
--WHERE mem_name LIKE '��%'; -- mem_name�� ������ �����ϴ� ������

-- NULL ��
-- col IS NULL
-- EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ
SELECT *
FROM emp
WHERE mgr IS NULL;
-- WHERE mgr != NULL; -- null�񱳰� �����Ѵ�.

-- �Ҽ� �μ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';
-- =, !=
-- is null, is not null 

-- IS NULL �ǽ� where6) emp���̺�, ��(comm)�� �ִ� ȸ������
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- AND / OR
-- ������(mgr) ����� 7698�̰� �޿��� 1000�̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal >= 1000;

-- emp���̺��� ������(mgr) ����� 7698�̰ų� �޿��� 1000(sal)�̻��� ���� ��ȸ
SELECT *
FROM emp
WHERE mgr = 7698
   OR sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

-- ���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;

-- IN, NOT IN �������� NULL ó��
-- emp ���̺��� ������(mgr) ����� 7698, 7839 �Ǵ� NULL�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
-- IN �����ڿ��� ������� NULL�� ���� ��� �ǵ����� ���� ������ �Ѵ�.   

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
  AND mgr IS NOT NULL;

-- AND, OR �ǽ� where7)emp���̺�, job�� SALESMAN�̰� �Ի����� 810601����
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');
   
-- AND, OR �ǽ� where8)emp���̺�, �μ���ȣ 10���ƴϰ� �Ի����� 810601����(IN, NOT IN��� ����)
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');
   
-- AND, OR �ǽ� where9)emp���̺�, �μ���ȣ 10���ƴϰ� �Ի����� 810601����(NOT IN���)
SELECT *
FROM emp
WHERE deptno NOT IN (10)
   AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');   
   
-- AND, OR �ǽ� where10)emp���̺�, �μ���ȣ 10���ƴϰ� �Ի����� 810601����
SELECT *
FROM emp
WHERE deptno IN (20, 30)
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD'); 
   
-- AND, OR �ǽ� where11)emp���̺�, job�� SALESMAN�̰ų� �Ի����� 810601����
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD'); 
   
-- AND, OR �ǽ� where12)emp���̺�, job�� SALESMAN�̰ų� �����ȣ 78�� �����ϴ�
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';  

-- AND, OR �ǽ� where13)emp���̺�, job�� SALESMAN�̰ų� �����ȣ 78�� �����ϴ� (LIKE������ ������)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno >=7800
  AND empno < 7900;  
  
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899;

-- AND, OR �ǽ� where14) emp���̺�, job�� SALESMAN�̰ų� �����ȣ 78�� �����ϸ鼭 �Ի����� 810601����
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%'
  AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD');