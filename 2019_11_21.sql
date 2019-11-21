--�������� ADVANCED (WITH) 
-- �μ��� ��� �޿��� ������ü �޿� ��պ��� �����μ��� �μ���ȣ�� �μ��� �޿� ��ձݾ� ��ȸ
--1. ��ü������ �޿� ��� (2073.21)
SELECT ROUND(AVG(sal), 2)
FROM emp;
--2. �μ��� ������ �޿� ���
SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno;
--3. ��� ����
SELECT *
FROM
   (SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2)
                    FROM emp);

--�������� WITH���� �����Ͽ� ������ �����ϰ� ǥ���Ѵ�.
WITH dept_avg_sal AS(SELECT deptno, ROUND(AVG(sal), 2) d_avgsal
                    FROM emp
                    GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal > (SELECT ROUND(AVG(sal), 2) FROM emp);

-- �޷� �����
--STEP1. �ش� ����� ���� �����
--CONNECT BY LEVEL

--201911
--DATE + ���� = ���� ���ϱ� ����
SELECT  MAX(DECODE(d, 1, dt)) sun, MAX(DECODE(d, 2, dt)) mon,
        MAX(DECODE(d, 3, dt)) tue, MAX(DECODE(d, 4, dt)) wed,
        MAX(DECODE(d, 5, dt)) thu, MAX(DECODE(d, 6, dt)) fri,
        MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM')+(level-1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'iw') iw,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM')+(level-1), 'd') d
    FROM dual a
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))a
GROUP BY DECODE(d, 1, a.iw+1, a.iw)
ORDER BY DECODE(d, 1, a.iw+1, a.iw);


--
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

--SALES
SELECT *
FROM sales;

--�ǽ� calendar1) 
--�޷¸���� ����������.sql�� �Ϻ����������� �̿�, 1~6���� �������������� ���ϼ���
SELECT MIN(DECODE(TO_CHAR(dt, 'MM'), '01', SUM(sales))) JAN, 
       MIN(DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales))) FEB,
       MIN(DECODE(TO_CHAR(dt, 'MM'), '02', SUM(sales))) MAR, 
       MIN(DECODE(TO_CHAR(dt, 'MM'), '04', SUM(sales))) APR,
       MIN(DECODE(TO_CHAR(dt, 'MM'), '03', SUM(sales))) MAY, 
       MIN(DECODE(TO_CHAR(dt, 'MM'), '06', SUM(sales))) JUN
FROM sales
GROUP BY TO_CHAR(dt, 'MM');


--
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

--��������
--START WITH : ������ ���ۺκ��� ����
--CONNECT BY : ������ ���������� ����
SELECT *
FROM dept_h;
--����� �������� (���� �ֻ��� ������������ ��� ������ Ž��) 
--LPAD�� �̿��� ���������� �ð�ȭ �� �� ����!
--�������� �ǽ�h_1)
SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4, ' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0' --START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; --PRIOR : ���� ���� ������(XXȸ��)

--�������� �ǽ�h_2) �����ý��ۺ� ���� �μ����� ���� ��ȸ���� �ۼ�
SELECT LEVEL LV, deptcd, 
       LPAD('-', (LEVEL-1)*4,' ') || dept_h.deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
