--CURSOR�� ��������� �������� �ʰ�
--LOOP���� inline ���·� cursor ���

set serveroutput on;
--�͸���
DECLARE
    --cursor ���� --> LOOP���� inline ����
BEGIN
    --for(string str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

--cursor, �������� �ǽ� PRO_3
DECLARE
BEGIN
    FOR rec IN (SELECT ((MAX(dt)-MIN(dt))/(COUNT(*)-1)) a FROM dt) LOOP
        dbms_output.put_line(rec.a);
    END LOOP;
END;
/

--������ ����(��ȿ��)
CREATE OR REPLACE PROCEDURE avgdt
IS
    --�����
    prev_dt DATE;
    ind NUMBER := 0;    --�ε��� ����!
    diff NUMBER := 0;
BEGIN
    --dt���̺� ��� ������ ��ȸ
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        --rec : dt�÷�
        --�������� ������(dt) - ���� ������(dt) :
        IF ind = 0 THEN --LOOP�� ù ����
           prev_dt := rec.dt;
        ELSE
            diff := diff + prev_dt - rec.dt;
            prev_dt := rec.dt;
        END IF;
        
        ind := ind+1;
    END LOOP;
    dbms_output.put_line('diff : ' || diff / (ind-1));
END;
/

exec avgdt;

--cursor, �������� �ǽ� PRO_4 1/2
SELECT *
FROM daily;

SELECT *
FROM cycle;

--������ ����
CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2)
IS
    --�޷��� �������� ������ RECORD TYPE
    TYPE cal_row IS RECORD (
        dt VARCHAR(8),
        d  VARCHAR(1));
        
    --�޷� ������ ������ table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --�����ֱ� cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM')+(LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM')+(LEVEL-1), 'D') d
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'DD'));
    
    --�����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --�����ֱ� loop
    FOR rec IN cycle_cursor LOOP
        FOR i IN 1..cal.count LOOP
            -- �����ֱ��� ���ϰ� ������ ������ ��ġ�ϴ��� ��
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid, cal(i).dt, rec.cnt);
            END IF;
        END LOOP;    
    END LOOP;
    
    COMMIT;
END;
/

exec create_daily_sales('201911');

SELECT *
FROM daily;

DELETE cycle
WHERE day >= 20191100;
COMMIT;

--������ ����(ȿ��, �����̿�)
DELETE daily
WHERE dt LIKE '201911%';

INSERT INTO daily
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM cycle,
    (SELECT TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM')+(LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(:p_yyyymm, 'YYYYMM')+(LEVEL-1), 'D') d
    FROM dual
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:p_yyyymm, 'YYYYMM')), 'DD')))cal
WHERE cycle.day = cal.d;


