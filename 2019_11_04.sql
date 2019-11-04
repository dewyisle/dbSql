-- 복습 where 11

SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR hiredate >= To_DATE('19810601', 'YYYYMMDD');
 
 
----------------------------------------  
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
AND mgr IS NOT NULL;

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
OR mgr IS NOT NULL;
--!?!?!?!!?!?!?!

-- ROWNUM
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;

--ROWNUM과 정렬문제
--ORDER BY절은 SELECT절 이후에 동작
--ROWNUM 가상컬럼이 적용되고나서 정렬되기 때문에
--우리가 원하는대로 첫번째 데이터부터 순차적인 번호 부여가 되질 않는다.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY 절을 포함한 인라인 뷰를 구성
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename)a;

--ROWNUM : 1번부터 읽어야 된다.
--WHERE절에 ROWNUM값을 중간만 읽는건 불가능
-- 안되는 케이스
-- WHERE  ROWNUM = 2
-- WHERE ROWNUM >= 2

--가능한 케이스
--WHERE ROWNUM = 1
--WHERE ROWNUM <= 10

SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename)a;
    
--페이징 처리를 위한 꼼수 ROWNUM에 별칭을 부여, 해당 SQL을 INLINE VIEW로 감싸고 
--별칭을 통해 페이징처리
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
       FROM
        (SELECT e.*
        FROM emp e
        ORDER BY ename)a)
 WHERE rn BETWEEN 10 AND 14;
 
 
 
 -- CONCAT : 문자열 결합 - 두 개의 문자열을 결합하는 함수
SELECT CONCAT('HELLO', ', WORLD')CONCAT
FROM dual;

-- SUBSTR : 문자열의 부분 문자열 (java : String.substring)
-- LENGTH : 문자열의 길이
-- INSTR : 문자열에 특정 문자열이 등장하는 첫 번째 인덱스
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') CONCAT, -- 문자열 3개 결합하고 싶어여!
       SUBSTR('HELLO, WORLD', 0, 5) substr,
       SUBSTR('HELLO, WORLD', 1, 5) substr1,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       -- INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시) 
       INSTR('HELLO, WORLD', 'O', 6) instr1, -- 6번인덱스 이후 찾을 문자열 위치 표시
       -- LPAD(문자열, 전체문자열길이, 문자열이 전체문자열길이에 미치지 못할 경우 추가할 문자)
       LPAD('HELLO, WORLD', 15, '*') lpad,  -- 추가문자열을 지정하지 않으면 공백 추가
       RPAD('HELLO, WORLD', 15, '*') rpad,
       --TRIM 문자열 맨 앞과 맨뒤의 공백을 제거해줌, 가운데는 아님
       REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'world') replace,
       TRIM('  HELLO, WORLD  ') trim,
       TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

-- ROUND(대상숫자, 반올림 결과 자리수)
SELECT ROUND(105.54, 1) r1, --소수점 둘째 자리에서 반올림
       ROUND(105.55, 1) r2, -- 소수점 둘째 자리에서 반올림
       ROUND(105.55, 0) r3, -- 소수점 첫째 자리에서 반올림
       ROUND(105.55, -1) r4 -- 정수 첫째 자리에서 반올림
FROM dual;

SELECT empno, ename, sal, /*ROUND(sal/1000) quotient,*/ MOD(sal, 1000) reminder --0~999
FROM emp;

--TRUNC
SELECT 
TRUNC(105.54, 1) T1, -- 소수점 둘째 자리에서 절삭
TRUNC(105.55, 1) T2, -- 소수점 둘째 자리에서 절삭
TRUNC(105.55, 0) T3, -- 소수점 첫째 자리에서 절삭
TRUNC(105.55, -1) T4 -- 정수 첫째 자리에서 절삭
FROM dual;

--SYSDATE : 오라클이 설치된 서버의 현재 날짜 + 시간정보를 리턴
--별도의 인자가 없는 함수

--TO_CHAR : DATE타입을 문자열로 변환
-- 날짜를 문자열로 변환시에 포맷을 지정
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE + (1/24/60)*30, 'YYYY/MM/DD HH24:MI:SS')       
FROM dual;

-- date 실습 fn1)
SELECT TO_DATE('20191231', 'YYYY/MM/DD') lastday,
       TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 lastday_before5,
       SYSDATE now,
       SYSDATE-3 now_before3
FROM dual;

--fn1이런방법도 있음
SELECT LASTDAY, LASTDAY-5 as LASTDAY_BEFORE5,
       NOW, NOW-3 NOW_BEFORE3
FROM
    (SELECT TO_DATE('20191231', 'YYYY/MM/DD') lastday,
           SYSDATE now
    FROM dual);
    
--date format
-- 년도 : YYYY, YY, RRRR, RR : 두자일 때랑 4자일때랑 다음
-- RR : 50보다 클 경우 앞자리는 19, 50보다 작을경우 앞자리는 20
-- YYYY, RRRR은 동일 가급적이면 명시적으로 표현
-- D : 요일을 숫자로 표기(일요일-1, 월요일-2, 화요일-3 ... 토요일-7)
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
       TO_CHAR(SYSDATE, 'D') d, --오늘은 월요일(2)
       TO_CHAR(SYSDATE, 'IW') iw, --주차 표기
       TO_CHAR(TO_DATE('20191229', 'YYYYMMDD'), 'IW') this_year
FROM dual;       

-- date실습 fn2)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_width_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

--날짜의 반올림(ROUND), 절삭(TRUNC)
-- ROUND(DATE, '포맷') YYYY, MM, DD
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
       TO_CHAR(ROUND(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as round_yyyy,
       TO_CHAR(ROUND(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm,
       TO_CHAR(ROUND(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as round_dd,
       TO_CHAR(ROUND(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as round_mm
FROM emp
WHERE ename = 'SMITH';

SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
       TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS') as trunc_yyyy,
       TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
       TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') as trunc_dd,
       TO_CHAR(TRUNC(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') as trunc_mm
FROM emp
WHERE ename = 'SMITH';

SELECT SYSDATE + 30 -- 28, 29, 31
FROM dual;

--날짜 연산함수
--MONTHS_BETWEEN(DATE, DATE) : 두 날짜 사이의 개월 수
--19801217-20191104 -->20191117
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       MONTHS_BETWEEN(SYSDATE, hiredate) months_between, 
       MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename='SMITH';

--확인용
SELECT MOD(467, 12)
FROM dual;

--ADD_MONTHS(DATE, 개월수) : DATE의 개월수가 지난 날짜
-- 개월수가 양수일 경우 미래, 음수일 경우 과거
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
       ADD_MONTHS(hiredate, 467) add_months,
       ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename='SMITH';

--NEXT_DAY(DATE, 요일) : DATE이후 첫번째 요일의 날짜
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, --오늘 날짜 이후 첫 토요일 일자
       NEXT_DAY(SYSDATE, '토요일') first_sat --오늘 날짜 이후 첫 토요일 일자
FROM dual;

--LAST_DAY(DATE) : 해당 날짜가 속한 월의 마지막 일자
SELECT SYSDATE, LAST_DAY(SYSDATE) last_day,
       LAST_DAY(ADD_MONTHS(SYSDATE, 1)) last_day_12
FROM dual;

--DATE + 정수 = DATE(DATE에서 정수만큼 이후의 DATE)
--D1 + 정수  = D2
--양변에서 D2차감
--D1 + 정수 -D2 = D2-D2
--D1 + 정수 -D2 = 0
--D1 + 정수 = D2
--양변에 D1차감
--D1+정수 -D1 = D2 -D1
-- 정수 = D2-D1
--날짜에서 날짜를 빼면 일자가 나온다

SELECT TO_DATE('20191104', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') d1,
       TO_DATE('20191201', 'YYYYMMDD') - TO_DATE('20191101', 'YYYYMMDD') d2,
       --201908 : 2019년의 8월의 일수 : 31
       ADD_MONTHS(TO_DATE('201908','YYYYMM'), 1) - TO_DATE('201908', 'YYYYMM')
FROM dual;

--date종합실습 fn3)
