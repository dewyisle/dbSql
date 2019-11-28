SELECT *
FROM no_emp;

--1. leaf node ã��
SELECT LPAD(' ', (level-1)*4, ' ') || org_cd, LEVEL, s_emp
FROM
    (SELECT org_cd, parent_org_cd, SUM(s_emp) s_emp
    FROM
        (SELECT org_cd, parent_org_cd,
            SUM(no_emp/org_cnt) OVER (PARTITION BY gr ORDER BY rn 
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
            (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr,
                    COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
            FROM
                (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
                FROM no_emp
                START WITH parent_org_cd IS NULL
                CONNECT BY PRIOR org_cd = parent_org_cd) a
            START WITH leaf = 1
            CONNECT BY PRIOR parent_org_cd = org_cd))
    GROUP BY org_cd, parent_org_cd) 
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;

--PL/SQL
--�Ҵ翬�� :=
--System.out.println("") ---> dbms_output.put_line("");
--Log4j
--set serveroutput on; --��±���� Ȱ��ȭ

set serveroutput on;

--PL/SQL
--declare : ����, ��� ����
--begin : ���� ����
--exception : ����ó��
DESC dept;
set serveroutput on;
DECLARE
    --���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept;
    
    --SELECT ���� ����� ������ �� �Ҵ��ߴ��� Ȯ��.
    dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/
--����� 1���� ���� ��밡���� ����
DECLARE 
    --�������� ����
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno=10;
    --SELECT ���� ����� ������ �� �Ҵ��ߴ��� Ȯ��.
     dbms_output.put_line('dname : ' || dname || '(' || deptno || ')');
END;
/

--10���μ��� �μ��̸��� LOC������ ȭ������ϴ� ���ν���
--���ν����� : printdept
--CREATE OR REPLACE VIEW
CREATE OR REPLACE PROCEDURE printdept
IS
    --��������
    dname dept.dname%TYPE;
    loc   dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname, loc : ' || dname || ', ' || loc);
END;
/
exec printdept;

-----
CREATE OR REPLACE PROCEDURE printdept_p(p_deptno IN dept.deptno%TYPE)
IS
    --��������
    dname dept.dname%TYPE;
    loc   dept.loc%TYPE;
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname, loc : ' || dname || ', ' || loc);
END;
/
exec printdept_p(30);

--�ǽ� PRO_1)
CREATE OR REPLACE PROCEDURE printemp(p_empno IN emp.empno%TYPE)
IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO ename, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno AND empno = p_empno;
    
    dbms_output.put_line('ename, dname : ' || ename || ', ' || dname);
END;
/

exec printemp(7499);

--�ǽ� PRO_2)
CREATE OR REPLACE PROCEDURE registdept_test(p_deptno IN dept_test.deptno%TYPE, p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE)
IS
BEGIN
    INSERT INTO dept_test(deptno, dname, loc) VALUES(p_deptno, p_dname, p_loc);
    COMMIT;
END;
/

exec registdept_test('99', 'ddit', 'daejeon');

ROLLBACK;

SELECT *
FROM dept_test;