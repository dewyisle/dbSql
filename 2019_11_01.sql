-- ����
-- WHERE
-- ������
-- �� : =, !=, <>, >=, >, <=, <
-- BETWEEN start And end
-- IN (set)
-- LIKE 'S%'(% : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
-- IS NULL (!= NULL)
-- AND, OR, NOT

-- emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� ����������ȸ
-- BETWEEN AND
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('19810601', 'YYYYMMDD') AND TO_DATE('19861231', 'YYYYMMDD');

-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('19810601', 'YYYYMMDD') 
  AND hiredate <= TO_DATE('19861231', 'YYYYMMDD');
  
-- emp���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- AND, OR �ǽ� where12)emp���̺�, job�� SALESMAN�̰ų� �����ȣ 78�� �����ϴ�
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';  

-- AND, OR �ǽ� where13)emp���̺�, job�� SALESMAN�̰ų� �����ȣ 78�� �����ϴ� (LIKE������ ������)
-- empno�� ���� 4�ڸ����� ���
-- empno : 78,780, 789
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno =78   
   OR empno >=780 AND empno < 790
   OR empno >=7800 AND empno < 7900;
  
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno = 78 
   OR empno BETWEEN 780 AND 789
   OR empno BETWEEN 7800 AND 7899;

-- AND, OR �ǽ� where14) emp���̺�, job�� SALESMAN�̰ų� �����ȣ 78�� �����ϸ鼭 �Ի����� 810601����
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
  OR (empno LIKE '78%' AND hiredate >= To_DATE('1981/06/01', 'YYYY/MM/DD'));
  
-- order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
-- order by ������ WHERE�� ������ ���
-- WHERE���� ���� ��� FROM�� ������ ���
-- emp���̺��� ename �������� �������� ����
SELECT *
FROM emp
ORDER BY ename ASC;

-- ASC : default
-- ASC�� �Ⱥٿ��� �� ������ ������
SELECT *
FROM emp
ORDER BY ename; -- ASC

-- �̸�(ename)�� �������� ��������
SELECT *
FROM emp
ORDER BY ename desc;

-- job�� �������� ������������ ����, ���� ���� ���� ��� ���(empno)���� �������� ����
SELECT *
FROM emp
ORDER By job DESC, empno;

-- ��Ī���� �����ϱ�
-- �����ȣ(empno), �����(ename), ����(sal*12) as year_sal
-- year_sal ��Ī���� �������� ����
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER By year_sal;

-- SELECT�� �÷� ���� �ε����� ����
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER By 4;

-- �ǽ� orderby1) dept���̺� ��������� �μ��̸����� ��������
SELECT *
FROM dept
ORDER BY dname;

-- �ǽ�1-2) dept���̺� ��� ���� �μ���ġ�� �������� ����
SELECT *
FROM dept
ORDER BY loc desc;

-- �ǽ� orderby2) emp���̺� , ��(comm)������ �ִ� �������ȸ, ���̹����� ���� ��ȸ,
--                           ���� ��� �����������
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

-- �ǽ� orderby3) emp���̺�, �������ִ»���� ��ȸ, ����(job) ��������,
--                          ������ ������ ����� ū ���������ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- �ǽ� orderby4) emp���̺�, 10���μ�(deptno) Ȥ�� 30���μ� ���ϴ� ��� ��
--                          �޿�(sal)�� 1500�Ѵ� ����� ��ȸ, �̸���������
SELECT *
FROM emp
WHERE deptno IN (10, 30)
  AND sal > 1500
ORDER BY ename DESC;

--
DESC emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM =2; --������ �� ����, =1�ΰ�� ���� <=2�� ��� ���� ������ 1������ �����;��� !!!??
--WHERE ROWNUM <= 10

-- emp���̺��� ���(empno), �̸�(ename)�� �޿��������� �������� �����ϰ�
-- ���ĵ� ��� ������ ROWNUM
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal; --ROWNUM�� ���׹���! 

SELECT ROWNUM, a.*
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal) a;

-- �ǽ� row_1) emp���̺�, ROWNUM���� 1~10�� ���� ��ȸ
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 10;

-- �ǽ� row_2) emp���̺�, ROWNUM���� 11~20�� ���� ��ȸ
SELECT *
FROM 
    (SELECT ROWNUM rn, a.*
FROM
    (SELECT empno, ename, sal
     FROM emp
     ORDER BY sal) a)
WHERE rn BETWEEN 11 and 20;
-- ROWNUM �� ORDER BY�� �Բ� �� �� ����! ���� ROWNUM�� ���׹�����.. 

-- FUNCTION
-- DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;  -- �Ѱ��� ����!

SELECT 'HELLO WORLD'
FROM emp;   -- ���̺� �ش��ϴ� �Ǽ���ŭ ����!

-- ���ڿ� ��ҹ��� ���� �Լ�
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hello, World'),UPPER('Hello, World'), INITCAP('hello, world')
FROM dual;

SELECT LOWER('Hello, World'),UPPER('Hello, World'), INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN'; -- where�� ������ �ɸ� ������ŭ ����!

-- FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; -- �÷��� FUNCTION �ִ°� ����!

-- ������ SQL ĥ������
-- 1. �º��� �������� ���ƶ�
-- �º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
-- Function Based Index -> FBI

-- CONCAT : ���ڿ� ���� - �� ���� ���ڿ��� �����ϴ� �Լ�
SELECT CONCAT('HELLO', ', WORLD')CONCAT
FROM dual;

-- SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
-- LENGTH : ���ڿ��� ����
-- INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù ��° �ε���
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') CONCAT, -- ���ڿ� 3�� �����ϰ� �;!
       SUBSTR('HELLO, WORLD', 0, 5) substr,
       SUBSTR('HELLO, WORLD', 1, 5) substr1,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       -- INSTR(���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��) 
       INSTR('HELLO, WORLD', 'O', 6) instr1, -- 6���ε��� ���� ã�� ���ڿ� ��ġ ǥ��
       -- LPAD(���ڿ�, ��ü���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���� ��� �߰��� ����)
       LPAD('HELLO, WORLD', 15, '*') lpad,  -- �߰����ڿ��� �������� ������ ���� �߰�
       RPAD('HELLO, WORLD', 15, '*') rpad
FROM dual;

-- ���ڿ� 3�� �����ϰ�;! ->�̰ž��� ������..?????
SELECT 'HELLO' || ', ' || 'WORLD'
FROM dual;
