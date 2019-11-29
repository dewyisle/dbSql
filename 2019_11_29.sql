--CURSOR를 명시적으로 선언하지 않고
--LOOP에서 inline 형태로 cursor 사용

set serveroutput on;
--익명블록
DECLARE
    --cursor 선언 --> LOOP에서 inline 선언
BEGIN
    --for(string str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

--cursor, 로직제어 실습 PRO_3
DECLARE
BEGIN
    FOR rec IN (SELECT ((MAX(dt)-MIN(dt))/(COUNT(*)-1)) a FROM dt) LOOP
        dbms_output.put_line(rec.a);
    END LOOP;
END;
/

--선생님 쿼리(비효율)
CREATE OR REPLACE PROCEDURE avgdt
IS
    --선언부
    prev_dt DATE;
    ind NUMBER := 0;    --인덱스 선언!
    diff NUMBER := 0;
BEGIN
    --dt테이블 모든 데이터 조회
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        --rec : dt컬럼
        --먼저읽은 데이터(dt) - 다음 데이터(dt) :
        IF ind = 0 THEN --LOOP의 첫 시작
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

--cursor, 로직제어 실습 PRO_4 1/2
SELECT *
FROM daily;

SELECT *
FROM cycle;

--선생님 쿼리
CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2)
IS
    --달력의 행정보를 저장할 RECORD TYPE
    TYPE cal_row IS RECORD (
        dt VARCHAR(8),
        d  VARCHAR(1));
        
    --달력 정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --애음주기 cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM')+(LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(p_yyyymm, 'YYYYMM')+(LEVEL-1), 'D') d
           BULK COLLECT INTO cal
    FROM dual
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm, 'YYYYMM')), 'DD'));
    
    --생성하려고 하는 년월의 실적 데이터를 삭제한다.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --애음주기 loop
    FOR rec IN cycle_cursor LOOP
        FOR i IN 1..cal.count LOOP
            -- 애음주기의 요일과 일자의 요일이 일치하는지 비교
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

--선생님 쿼리(효율, 조인이용)
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


