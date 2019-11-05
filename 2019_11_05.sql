--복습
-- 년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
--201911 --> 30 / 201912 --> 31

--한달 더한 후 원래값을 빼면 = 일수
--마지막날짜 구한 후 --> DD만 추출
SELECT TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
FROM dual;

--바인딩?
SELECT TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') day_cnt
FROM dual;

--param 으로 컬럼명 설정, 일수 앞에 나오게 !
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') day_cnt
FROM dual;

-- 설명되었습니다. (!)
explain plan for
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
/*
Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
--------------------------------------------------- 
 
   1 - filter("EMPNO"=7369)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
*/

explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--1000자릿수 표현
SELECT empno, ename, sal, TO_CHAR(sal, '999,999')sal_fmt
FROM emp;

--소수점 표현
SELECT empno, ename, sal, TO_CHAR(sal, '999,999.999')sal_fmt
FROM emp;

--화폐단위 표시
SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.999')sal_fmt
FROM emp;

-- 금액 앞에 0붙여줌
SELECT empno, ename, sal, TO_CHAR(sal, 'L009,999.999')sal_fmt
FROM emp;

--function null
--nvl(col1, col1이 null일 경우 대체할 값)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
       sal + comm, sal+ nvl(comm, 0)
    --nvl(sal + comm, 0)이렇게 쓰는 경우 sal이 더해진 값이 나오지 않음!
FROM emp;

--nvl2(col1, col1이 null이 아닐 경우 표현되는 값, col1이 null일 경우 표현되는 값)
SELECT empno, ename, sal, comm, nvl2(comm, comm, 0) + sal
 FROM emp;
 
 --NULL생성
 --NULLIF(expr1, expr2) 
 --expr1 == expr2 같으면 null
 --else : expr1
 SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
 FROM emp;
 
 --COALESCE(expr1, expr2, expr3....)
 --함수 인자 중 null이 아닌 첫번째 인자 
 SELECT empno, ename, sal, comm, coalesce(comm, sal)
 FROM emp;
 
 --null실습 fn4)
 SELECT empno, ename, mgr, nvl(mgr, 9999) mgr_n, 
                           nvl2(mgr, mgr, 9999) mgr_n1, 
                           coalesce(mgr, 9999) mgr_n2
 FROM emp;
 
 --null 실습 fn5)
 SELECT userid, usernm, reg_dt, nvl(reg_dt, sysdate) n_rwg_dt
 FROM users;
 
 --condition
 --case when
 SELECT empno, ename, job, sal,
        case
            when job = 'SALESMAN' then sal*1.05
            when job = 'MANAGER' then sal*1.10
            when job = 'PRESIDENT' then sal*1.20
            else sal
        end case_sal
 FROM emp;
 
 --decode(col,search1, return1, search2, return2....default) 
 SELECT empno, ename, job, sal,
        decode(job, 'SALESMAN',sal*1.05, 
                    'MANAGER', sal*1.10, 
                    'PRESIDENT', sal*1.20, sal) decode_sal
FROM emp;
 
 --condition 실습 cond1)
 SELECT empno, ename, deptno,
        decode(deptno, 10, 'ACCOUNTING', 
                       20, 'RESEARCH', 
                       30, 'SALES', 
                       40, 'OPERATIONS', 'DDIT') dname
 FROM emp;
 
 SELECT empno, ename, deptno,
        case
            when deptno=10 then 'ACCOUNTING'
            when deptno=20 then 'RESEARCH'
            when deptno=30 then 'SALES'
            when deptno=40 then 'OPERATIONS'
            else 'DDIT'
        end dname
FROM emp;
        
--condition 실습 cond2)
SELECT empno, ename, hiredate, TO_CHAR(hiredate, 'YY') year,
        case
            when MOD(TO_CHAR(hiredate, 'YY'), 2)=0 then '건강검진 비대상자'
            when MOD(TO_CHAR(hiredate, 'YY'), 2)=1 then '건강검진 대상자'
            else '괜찮아요'
        end contack_to_doctor
FROM emp;

SELECT empno, ename, hiredate, TO_CHAR(hiredate, 'YY') year,
        decode(MOD(TO_CHAR(hiredate, 'YY'), 2), 0, '건강검진 비대상자',
                                                1, '건강검진 대상자',
                                                   '괜찮아요') contact_to_doctor
FROM emp;

-- 매년 쓸 수 있는 쿼리(자동으로 대상자를 표기)! 맞는지 아닌지 모르겠다 효율적인 코드인가?
SELECT empno, ename, hiredate,
        case
            when MOD(TO_CHAR(sysdate, 'yy') - TO_CHAR(hiredate, 'YY'), 2) = 0 then '건강검진 대상자'
            else '건강검진 비대상자'
        end contacttodoctor
FROM emp;

--선생님의 매년쿼리
--올해수는 짝수인가? 홀수인가?
-- 1. 올해 년도 구하기 (DATE --> TO_CHAR(DATE, FORMAT))
-- 2. 올해 년도가 짝수인지 계산
--    어떤 수를 2로 나누면 나머지는 항상 2보다 작다.
--    2로 나눌 경우 나머지는 0, 1
--    MOD(대상, 나눌값)  
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM dual;
--emp테이블에서 입사잉ㄹ자가 홀수년인지 짝수년인지 확인
SELECT empno, ename, hiredate, 
        case
            when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2)
                then '건강검진 대상자'
            else '건강검진 비대상자'
        end cotact_to_doctor
FROM emp;


--condition 실습 cind3)
/*SELECT userid, usernm, alias, reg_dt,
        case 
            when MOD(TO_CHAR(reg_dt, 'yy'), 2)=1 then '건강검진 대상자'
            else '건강검진 비대상자'
        end contacttodoctor
FROM users;

SELECT userid, usernm, alias, reg_dt, nvl2(reg_dt, '건강검진 대상자', '건강검진 비대상자') contacttodoctor
FROM users;
*/--결과값은 같지만 출제의도와 다른 것만 같은 느낌!

-- 성생님
SELECT userid, usernm, alias, reg_dt, 
        case
            when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(reg_dt, 'YYYY'), 2)
                then '건강검진 대상자'
            else '건강검진 비대상자'
        end cotact_to_doctor
FROM users;

--그룹함수( AVG, MAX, MIN, SUM, COUNT )
--그룹함수는 NULL값을 계산대상에서 제외한다.
-- SUM(comm), COUNT(*), COUNT(mgr)
--MAX : 직원 중 가장 높은 급여를 받는 사람의 급여
--MIN : 직원 중 가장 낮은 급여를 받는 사람의 급여
--AVG : 직원의 급여 평균(ROUND : 소수점 둘째자리 까지만 나오게 --> 소수점 3째자리에서 반올림)
--SUM : 직원의 급여 전체합
--COUNT : 직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal,
      ROUND(AVG(sal), 2) avg_sal,
      SUM(sal) sum_sal,
      COUNT(*) emp_cnt,
      COUNT(sal) sal_cnt,
      COUNT(mgr) mgr_cnt,
      SUM(comm) 
FROM emp;

SELECT empno, ename, sal
FROM emp;

--부서별 가장 높은 급여를 받는 사람의 급여
--GROUP BY에 기술되지 않은 컬럼이 SELECT절에 기술될 경우 에러
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;
--부서별
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
      ROUND(AVG(sal), 2) avg_sal,
      SUM(sal) sum_sal,
      COUNT(*) emp_cnt,
      COUNT(sal) sal_cnt,
      COUNT(mgr) mgr_cnt,
      SUM(comm) 
FROM emp
GROUP BY deptno;

-- 그룹화와 관련없는 임의의 문자열('test'), 상수(1)는 올 수 있음!
SELECT deptno,'test', 1, MAX(sal) max_sal, MIN(sal) min_sal,
      ROUND(AVG(sal), 2) avg_sal,
      SUM(sal) sum_sal,
      COUNT(*) emp_cnt,
      COUNT(sal) sal_cnt,
      COUNT(mgr) mgr_cnt,
      SUM(comm) 
FROM emp
GROUP BY deptno;

-- 부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--gruop function 실습 grp1)
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) couut_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp;

--gruop function 실습 grp2)
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) couut_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;