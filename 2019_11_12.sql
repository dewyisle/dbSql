--sub7
--1������ �Դ� ������ǰ
--2������ �Դ� ������ǰ���� ����
SELECT cycle.cid, customer.cnm, product.pid, pnm, day, cnt
FROM cycle, customer, product
WHERE cycle.cid=1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN (SELECT pid FROM cycle WHERE cid=2);

--sub9
SELECT *
fROM product
WHERE NOT EXISTS (SELECT 'x' FROM cycle WHERE cid=1 AND pid = product.pid);

--1������ �����ϴ� ��ǰ
SELECT pid
FROM cycle
WHERE cid=1;

--DML(insert)
INSERT INTO emp(empno, ename, job)
values ( 9999, 'brown', null);

SELECT *
FROM emp
WHERE empno=9999;

rollback;

desc emp;

SELECT *
FROM user_tab_columns
WHERE table_name = 'EMP'
ORDER BY column_id;

1. empno
2. ename
3. job
4. mgr
5. hiredate
6. sal
7. comm
8. deptno

INSERT INTO emp
VALUES (9999, 'brown', 'ranger', null, sysdate, 2500, null, 40);
COMMIT;

--SELECT ��� (������)�� INSERT
INSERT INTO emp(empno, ename)
SELECT deptno, dname
FROM dept;

SELECT *
FROM emp;

--UPDATE
--UPDATE ���̺� SET �÷�=��, �÷�=��....
--WHERE condition

SELECT *
FROM dept;

UPDATE dept SET dname='���IT', loc='ym'
-- WHERE deptno=99;

--������ -���ݿ����� (����Ʈ�����--13000, ���, �Ϲ�����, ������-650)
--�ֹιι�ȣ ���ڸ�
UPDATE ��������̺� SET ��й�ȣ = �ֹι�ȣ ���ڸ�
WHERE ����� ������ ='�����';

SELECT*
FROM emp;

--�����ȣ�� 9999�� ������ emp���̺��� ����
DELETE emp
WHERE empno=9999;

--�μ� ���̺��� �̿��ؼ� emp ���̺� �Է��� 5���� ���̹��� ����
--10,20,30,40,99 --> empno <100, empno BETWEEEN 10 AND 99
DELETE emp
WHERE empno < 100;

DELETE emp
WHERE empno BETWEEM 10 AND 99;

rollback;

DELETE emp
WHERE empno IN(SELECT deptno FROM dept);

commit;

--LV1 ->LV3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

--DML������ ���� Ʈ����� ����
INSERT INTO dept
values (99, 'ddit', 'daejeon');

SELECT * 
FROM dept;

--DDL : AUTO COMMIT, rollback�� �ȵȴ�.
--CREATE
CREATE TABLE ranger_new (
    ranger_no NUMBER,   --����Ÿ��
    ranger_name VARCHAR2(50), --���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);
desc ranger_new;

--ddl�� rollback�� ������� �ʴ´�.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000, 'brown');

commit;

SELECT *
FROM ranger_new;

--��¥Ÿ�Կ��� Ư�� �ʵ� ��������
--ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate, 'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, 
       TO_CHAR(reg_dt, 'MM'),
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;

--��������
--DEPT ����ؼ� DEPT_TEST ����
desc dept_test;
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY,   --deptno �÷��� �ĺ��ڷ� ����
    dname varchar(14),              --�ĺ��ڷ� ������ �Ǹ� ���� �ߺ���
    loc varchar(13)                 --�� �� ������, null�� ���� ����.
);

--primary key���� ���� Ȯ��
--1. deptno�÷��� null�� �� �� ����.
--2. deptno�÷��� �ߺ��� ���� �� �� ����.
INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon'); --���� : �ߺ���

rollback;

--����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (1, 'ddit2', 'daejeon');  -- �������� �� �� �ϳ��� �ߺ��ƴϸ�
                                                       -- �� ���� ����  
SELECT *
FROM dept_test;

rollback;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, null, 'daejeon'); --���� : NOT NULL

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon'); --���� : �ߺ����߻�