--����
-- ��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
--201911 --> 30 / 201912 --> 31

--�Ѵ� ���� �� �������� ���� = �ϼ�
--��������¥ ���� �� --> DD�� ����
SELECT TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
FROM dual;

--���ε�?
SELECT TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') day_cnt
FROM dual;

--param ���� �÷��� ����, �ϼ� �տ� ������ !
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD') day_cnt
FROM dual;

-- ����Ǿ����ϴ�. (!)
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

--1000�ڸ��� ǥ��
SELECT empno, ename, sal, TO_CHAR(sal, '999,999')sal_fmt
FROM emp;

--�Ҽ��� ǥ��
SELECT empno, ename, sal, TO_CHAR(sal, '999,999.999')sal_fmt
FROM emp;

--ȭ����� ǥ��
SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.999')sal_fmt
FROM emp;

-- �ݾ� �տ� 0�ٿ���
SELECT empno, ename, sal, TO_CHAR(sal, 'L009,999.999')sal_fmt
FROM emp;

--function null
--nvl(col1, col1�� null�� ��� ��ü�� ��)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
       sal + comm, sal+ nvl(comm, 0)
    --nvl(sal + comm, 0)�̷��� ���� ��� sal�� ������ ���� ������ ����!
FROM emp;

--nvl2(col1, col1�� null�� �ƴ� ��� ǥ���Ǵ� ��, col1�� null�� ��� ǥ���Ǵ� ��)
SELECT empno, ename, sal, comm, nvl2(comm, comm, 0) + sal
 FROM emp;
 
 --NULL����
 --NULLIF(expr1, expr2) 
 --expr1 == expr2 ������ null
 --else : expr1
 SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
 FROM emp;
 
 --COALESCE(expr1, expr2, expr3....)
 --�Լ� ���� �� null�� �ƴ� ù��° ���� 
 SELECT empno, ename, sal, comm, coalesce(comm, sal)
 FROM emp;
 
 --null�ǽ� fn4)
 SELECT empno, ename, mgr, nvl(mgr, 9999) mgr_n, 
                           nvl2(mgr, mgr, 9999) mgr_n1, 
                           coalesce(mgr, 9999) mgr_n2
 FROM emp;
 
 --null �ǽ� fn5)
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
 
 --condition �ǽ� cond1)
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
        
--condition �ǽ� cond2)
SELECT empno, ename, hiredate, TO_CHAR(hiredate, 'YY') year,
        case
            when MOD(TO_CHAR(hiredate, 'YY'), 2)=0 then '�ǰ����� ������'
            when MOD(TO_CHAR(hiredate, 'YY'), 2)=1 then '�ǰ����� �����'
            else '�����ƿ�'
        end contack_to_doctor
FROM emp;

SELECT empno, ename, hiredate, TO_CHAR(hiredate, 'YY') year,
        decode(MOD(TO_CHAR(hiredate, 'YY'), 2), 0, '�ǰ����� ������',
                                                1, '�ǰ����� �����',
                                                   '�����ƿ�') contact_to_doctor
FROM emp;

-- �ų� �� �� �ִ� ����(�ڵ����� ����ڸ� ǥ��)! �´��� �ƴ��� �𸣰ڴ� ȿ������ �ڵ��ΰ�?
SELECT empno, ename, hiredate,
        case
            when MOD(TO_CHAR(sysdate, 'yy') - TO_CHAR(hiredate, 'YY'), 2) = 0 then '�ǰ����� �����'
            else '�ǰ����� ������'
        end contacttodoctor
FROM emp;

--�������� �ų�����
--���ؼ��� ¦���ΰ�? Ȧ���ΰ�?
-- 1. ���� �⵵ ���ϱ� (DATE --> TO_CHAR(DATE, FORMAT))
-- 2. ���� �⵵�� ¦������ ���
--    � ���� 2�� ������ �������� �׻� 2���� �۴�.
--    2�� ���� ��� �������� 0, 1
--    MOD(���, ������)  
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM dual;
--emp���̺��� �Ի��פ��ڰ� Ȧ�������� ¦�������� Ȯ��
SELECT empno, ename, hiredate, 
        case
            when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2)
                then '�ǰ����� �����'
            else '�ǰ����� ������'
        end cotact_to_doctor
FROM emp;


--condition �ǽ� cind3)
/*SELECT userid, usernm, alias, reg_dt,
        case 
            when MOD(TO_CHAR(reg_dt, 'yy'), 2)=1 then '�ǰ����� �����'
            else '�ǰ����� ������'
        end contacttodoctor
FROM users;

SELECT userid, usernm, alias, reg_dt, nvl2(reg_dt, '�ǰ����� �����', '�ǰ����� ������') contacttodoctor
FROM users;
*/--������� ������ �����ǵ��� �ٸ� �͸� ���� ����!

-- ������
SELECT userid, usernm, alias, reg_dt, 
        case
            when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(reg_dt, 'YYYY'), 2)
                then '�ǰ����� �����'
            else '�ǰ����� ������'
        end cotact_to_doctor
FROM users;

--�׷��Լ�( AVG, MAX, MIN, SUM, COUNT )
--�׷��Լ��� NULL���� ����󿡼� �����Ѵ�.
-- SUM(comm), COUNT(*), COUNT(mgr)
--MAX : ���� �� ���� ���� �޿��� �޴� ����� �޿�
--MIN : ���� �� ���� ���� �޿��� �޴� ����� �޿�
--AVG : ������ �޿� ���(ROUND : �Ҽ��� ��°�ڸ� ������ ������ --> �Ҽ��� 3°�ڸ����� �ݿø�)
--SUM : ������ �޿� ��ü��
--COUNT : ������ ��
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

--�μ��� ���� ���� �޿��� �޴� ����� �޿�
--GROUP BY�� ������� ���� �÷��� SELECT���� ����� ��� ����
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;
--�μ���
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal,
      ROUND(AVG(sal), 2) avg_sal,
      SUM(sal) sum_sal,
      COUNT(*) emp_cnt,
      COUNT(sal) sal_cnt,
      COUNT(mgr) mgr_cnt,
      SUM(comm) 
FROM emp
GROUP BY deptno;

-- �׷�ȭ�� ���þ��� ������ ���ڿ�('test'), ���(1)�� �� �� ����!
SELECT deptno,'test', 1, MAX(sal) max_sal, MIN(sal) min_sal,
      ROUND(AVG(sal), 2) avg_sal,
      SUM(sal) sum_sal,
      COUNT(*) emp_cnt,
      COUNT(sal) sal_cnt,
      COUNT(mgr) mgr_cnt,
      SUM(comm) 
FROM emp
GROUP BY deptno;

-- �μ��� �ִ� �޿�
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--gruop function �ǽ� grp1)
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) couut_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp;

--gruop function �ǽ� grp2)
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