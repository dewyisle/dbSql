-- procedure ���� �ǽ� pro_3
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept_test.deptno%TYPE, p_dname IN dept_test.dname%TYPE, p_loc IN dept_test.loc%TYPE)
IS
BEGIN
    UPDATE dept_test SET deptno = p_deptno, dname = p_dname, loc = p_loc
    WHERE deptno = p_deptno;
    COMMIT;
END;
/

exec UPDATEdept_test(99, 'ddit_m', 'daejeoon');

SELECT *
FROM dept_test;
ROLLBACK;

--ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ���� Ÿ��
set serveroutput on;

DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || dept_row.dname || ', ' ||dept_row.loc);
END;
/

--���պ��� : record
DECLARE
    -- UserVO userVo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE);
        
    v_dname dept.dname%TYPE;
    v_row dept_row;
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ', ' || v_row.dname);
END;
/

--tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    --java : Ÿ�� ������;
    --pl/sql : ������ Ÿ��;
    v_dept dept_tab;
    
    bi BINARY_INTEGER;
BEGIN
    bi := 100;
    
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    dbms_output.put_line(bi);
    
    FOR i IN 1..v_dept.count LOOP
    --dbms_output.put_line(v_dept(0).dname);
    dbms_output.put_line(v_dept(1).dname);
    END LOOP;
    /*dbms_output.put_line(v_dept(2).dname);
    dbms_output.put_line(v_dept(3).dname);
    dbms_output.put_line(v_dept(4).dname);
    dbms_output.put_line(v_dept(5).dname);*/
END;
/

SELECT *
FROM dept;

--IF
--ELSE IF -->ELSIF
--END IF;

DECLARE 
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    If ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF' || ind);
    ELSE
        dbms_output.put_line('ELSE');
    END IF;
END;
/

--FOR LOOP;
--FOR �ε��� ���� IN ���۰�..���ᰪ LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/

-- LOOP : ��� ���� �Ǵ� ������ LOOP�ȿ��� ����
-- java : while(true)
DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_line('for i :' || i);
        i :=i+1;
        EXIT WHEN i>5;
    END LOOP;
END;
/

--cursor, �������� �ǽ� pro_3)
SELECT *
FROM dt;

DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    v_dt dt_tab;
    i NUMBER;
    dt_avg NUMBER;
BEGIN
    SELECT *
    BULK COLLECT INTO v_dt
    FROM dt
    ORDER BY dt;
    
    i := 1;
    dt_avg := 0;
    
     LOOP
        dt_avg := dt_avg +(v_dt(i+1).dt - v_dt(i).dt);
        i := i+1;
        EXIT WHEN i>v_dt.count-1;
     END LOOP;
    
    dbms_output.put_line(dt_avg/(i-1));
END;
/

SELECT *
FROM dt;

--lead, lag �������� ����, ���� �����͸� ������ �� �ִ�.
SELECT AVG(diff)
FROM
    (SELECT dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
    FROM dt);

-- �м��Լ��� ������� ���ϴ� ȯ�濡��
SELECT AVG(a.dt-b.dt)
FROM
    (SELECT ROWNUM rn, dt
    FROM
        (SELECT dt
        FROM dt
        ORDER BY dt DESC))a,
    (SELECT ROWNUM rn, dt
    FROM
        (SELECT dt
        FROM dt
        ORDER BY dt DESC))b
WHERE a.rn= b.rn(+)-1;

--��������
SELECT (MAX(dt)-MIN(dT)) / (COUNT(*)-1) avg
FROM dt;

DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; --���̻� ���� �����Ͱ� ���� �� ����
    END LOOP;
END;
/

--FOR LOOP CURSOR ����
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

--�Ķ���Ͱ� �ִ� ����� Ŀ��
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_line(emp.empno || ', ' || emp.ename || ', ' || emp.job);
    END LOOP;
END;
/