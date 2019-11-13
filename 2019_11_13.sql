--unique table level constraint
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    --CONSTRAINT �������Ǹ� CONSTRAINT TYPE [(�÷�....)]
    CONSTRAINT uk_dept_test_dname_loc UNIQUE (dname, loc)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
--ù��° ������ ���� dname, loc���� �ߺ��ǹǷ� �ι�° ������ ������� ���Ѵ�.
INSERT INTO dept_test VALUES (2, 'ddit', 'daejeon');

--foreign key(��������)
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
COMMIT;

--emp_test (empno, ename, deptno)
desc emp;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);
--dept_test ���̺� 1�� �μ���ȣ�� �����ϰ� 
--fk������ dept_test.deptno �÷��� �����ϵ��� �����Ͽ�
--1�� �̿��� �μ���ȣ�� emp_test ���̺� �Էµ� �� ����.

--emp_test fk �׽�Ʈ insert
INSERT INTO emp_test VALUES (9999, 'brown', 1);

--2�� �μ��� dept_test ���̺� �������� �ʴ� �������̱� ������
--fk���࿡ ���� INSERT�� ���������� �������� ���Ѵ�.
INSERT INTO emp_test VALUES (9999, 'sally', 2);

--���Ἲ ���࿡�� �߻��� �� �ؾ� �ɱ�??
--�Է��Ϸ��� �ϴ� ���� �´°ǰ�?? (2���� �³�? 1���Ƴ�??)
-- .�θ����̺� ���� �� �Է� �ȵƴ��� Ȯ�� (dept_test Ȯ��)

--fk���� table level constraint
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno)
);

--FK������ �����Ϸ��� �����Ϸ��� �÷��� �ε����� �����Ǿ��־�� �Ѵ�.
DROP TABLE emp_test; 
DROP TABLE dept_test; -- �ڽ��� �ִ°�� ���ְ�.. �ڽĸ��� ������ DROP����

CREATE TABLE dept_test(
    deptno NUMBER(2), /* PRIMARY KEY --> UNIQUE ���� --> �ε�������X */
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --dept_test.deptno�÷��� �ε����� ���� ������ ���������� 
    --fk������ ������ �� ����.
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

-- ���̺� ����
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9999, 'brown', 1);
commit;

DELETE emp_test WHERE empno=9999;

-- dept_test���̺��� deptno���� �����ϴ� �����Ͱ� ���� ��� ������ �Ұ����ϴ�.
-- ��, �ڽ� ���̺��� �����ϴ� �����Ͱ� ����� �θ����̺��� �����͸� ���� �����ϴ�.
DELETE dept_test WHERE deptno=1; 

--FK���� �ɼ�
--default : ������ �Է�/���� �� ���������� ó������� fk������
--          �������� �ʴ´�.
--ON DELETE CASCADE : �θ� ������ ������ �����ϴ� �ڽ� ���̺� ���� ����
--ON DELETE NULL : �θ� ������ ������ �����ϴ� �ڽ� ���̺� �� NULL ����
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno) ON DELETE CASCADE
);
INSERT INTO emp_test VALUES (9999, 'brown', 1);
commit;

--fk ���� default �ɼǽÿ��� �θ� ���̺��� �����͸� �����ϱ� ���� �ڽ� ���̺���
--�����ϴ� �����Ͱ� ����� ���������� ������ ��������
--ON DELETE CASCADE�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� �����͸� 
--���� �����Ѵ�.
--1. ���� ������ ���������� ���� �Ǵ���?
--2. �ڽ� ���̺� �����Ͱ� ���� �Ǿ�����?
DELETE dept_test
WHERE deptno=1;

SELECT *
FROM emp_test;



--fk���� ON DELETE SET NULL
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY 
    (deptno) REFERENCES dept_test(deptno) ON DELETE SET NULL
);
INSERT INTO dept_test VALUES (1, 'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9999, 'brown', 1);
commit;

--fk ���� default �ɼǽÿ��� �θ� ���̺��� �����͸� �����ϱ� ���� �ڽ� ���̺���
--�����ϴ� �����Ͱ� ����� ���������� ������ ��������
--ON DELETE SET NULL�� ��� �θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� ��������
--���� �÷��� NULL�� �����Ѵ�.
--1. ���� ������ ���������� ���� �Ǵ���?
--2. �ڽ� ���̺� �����Ͱ� NULL�� ���� �Ǿ�����?
DELETE dept_test
WHERE deptno=1;

SELECT *
FROM emp_test;

--CHECK ���� : �÷��� ���� ������ ����, Ȥ�� ���� �����Բ� ����
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER CHECK (sal >= 0)
); 
--sal�÷��� CHECK ���� ���ǿ� ���� 0�̰ų�, 0���� ū ���� �Է��� �����ϴ�.
INSERT INTO emp_test VALUES (9999, 'brown', 10000);
INSERT INTO emp_test VALUES (9998, 'sally', -10000);


-- CHECK�������� ��뿹)
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --emp_gb : 01 - ������, 02 - ����
    emp_gb VARCHAR2(2) CHECK (emp_gb IN ('01', '02'))
); 

INSERT INTO emp_test VALUES (9999, 'brown', '01');

--emp_gb �÷� üũ���࿡ ���� 01, 02�� �ƴ� ���� �Էµ� �� ����.
INSERT INTO emp_test VALUES (9998, 'sally', '03');

----------------------------------------------------------------

--SELECT ����� �̿��� TABLE ����
--Create Table ���̺�� AS
--SELECT ����
--> CTAS

DROP TABLE emp_test;
DROP TABLE dept_test;

--CUSTOMER ���̺��� ����Ͽ� CUSTOMER_TEST���̺�� ����
--CUSTOMER ���̺��� �����͵� ���� ����
CREATE TABLE customer_test AS
SELECT *
FROM CUSTOMER;

SELECT *
FROM CUSTOMER_test;

CREATE TABLE test AS
SELECT SYSDATE dt
FROM dual;

SELECT *
FROM test;

DROP TABLE test;

--�����ʹ� �������� �ʰ� Ư�� ���̺��� �÷� ���ĸ� ������ �� ������?
DROP TABLE customer_test;
CREATE TABLE customer_test AS
SELECT *
FROM customer
WHERE 1=2; --���� ���� �� ���� ������ �ְ� ���̺��� �����Ѵ�!! ex) 1=2, 1!=1

--NOT NULL �������� �̿��� ���������� ������� �ʴ´�.
CREATE TABLE test (
    c1 VARCHAR2(2) CHECK (c1 IN ('01','02'))
);
CREATE TABLE test2 AS
SELECT *
FROM test;

------------------------------------------------------------
--���̺� ����
--���ο� �÷� �߰�
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10)
); 

-- �ű� �÷� �߰�
ALTER TABLE emp_test ADD ( deptno NUMBER(2) );
desc emp_test;

--���� �÷� ����(���̺� �����Ͱ� ���� ��Ȳ)
ALTER TABLE emp_test MODIFY ( ename VARCHAR2(200) );
desc emp_test;
ALTER TABLE emp_test MODIFY ( ename NUMBER );

--�����Ͱ� �ִ� ��Ȳ���� �÷� ���� : �������̴�
INSERT INTO emp_test VALUES (9999, 1000, 10);
COMMIT;

-- ������ Ÿ���� �����ϱ� ���ؼ��� �÷� ���� ����־�� �Ѵ�.
ALTER TABLE emp_test MODIFY (ename VARCHAR2(10));

--DEFAULT ����
ALTER TABLE emp_test MODIFY (deptno DEFAULT 10);

--�÷��� ����
ALTER TABLE emp_test RENAME COLUMN deptno TO dno;

--�÷� ����(DROP)
ALTER TABLE emp_test DROP COLUMN dno;
ALTER TABLE emp_test DROP (dno);
DESC emp_test;

--���̺� ���� : �������� �߰�
--PRIMARY KEY
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

--�������� ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

--UNIQUE ���� - empno
ALTER TABLE emp_test ADD CONSTRAINT uk_emp_test UNIQUE (empno);

--UNIQUE ���� ���� : uk_emp_test
ALTER TABLE emp_test DROP CONSTRAINT uk_emp_test;

--FOREIGN KEY �߰�
-- �ǽ� 
--1. dept���̺��� DEPTNO�÷����� PRIMARY KEY ������ ���̺� ����
--ddl�� ���� ����
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
--2. emp ���̺��� empno �÷����� PRIMARY KEY ������ ���̺� ����
--ddl�� ���� ����
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
--3. emp���̺��� deptno�÷����� dept���̺��� deptno�÷���
--�����ϴ� dk������ ���̺� ���� ddl�� ���� ����
--emp --> dept(deptno)
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno)
REFERENCES dept (deptno);

--emp_test --> dept.deptno fk ���� ����
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
); 
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept FOREIGN KEY (deptno)
REFERENCES dept (deptno);

--CHECK ���� �߰� (ename ���� üũ, ���̰� 3���� �̻�)
ALTER TABLE emp_test ADD CONSTRAINT check_ename_len CHECK (LENGTH(ename) > 3);

INSERT INTO emp_test VALUES (9999, 'brown', 10);
INSERT INTO emp_test VALUES (9998, 'br', 10);
rollback;
SELECT*
FROM emp_test;

--CHECK ���� ����
ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;

--NOT NULL ���� �߰�
ALTER TABLE emp_test MODIFY (ename NOT NULL);

--NOT NULL ���� ���� (NULL ���)
ALTER TABLE emp_test MODIFY (ename NULL);