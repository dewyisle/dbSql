--���κ���
-- ���� �� ��?
-- RDBMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
-- EMP���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ�������
-- �μ� ��ȣ�� �����ְ�, �μ���ȣ�� ���� dept���̺�� ������ ���� 
-- �ش� �μ��� ������ ������ �� �ִ�.

--���� ��ȣ, �����̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
--emp, dept
SELECT emp.empno, emp.ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�μ���ȣ, �μ���, �ش�μ��� �ο���
--count(col) : col���� �����ϸ� 1, null : 0
--             ����� �ñ��� ���̸� *
SELECT dept.deptno, dept.dname, COUNT(empno) cnt
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dept.deptno, dept.dname;

--TOTAL ROW : 14
SELECT COUNT(*), COUNT(empno), COUNT(mgr), COUNT(comm)
FROM emp;

--OUTER JOIN : ���ο� �����ص� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ����� 
--             �������� �ϴ� ���� ����
--LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ���
--                  �ϴ� ���� ����
--RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������ 
--                  �ǵ��� �ϴ� ���� ����
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - �ߺ�����

--����������, �ش� ������ ������ ���� outer join
--��������, �����̸�, �����ڹ�ȣ, ������ �̸�
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp  a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp  a JOIN emp b ON(a.mgr = b.empno);

--oracle outer join(left, right�� ���� fullouter�� ������������)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr,b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr,b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno = 10);

--oracle outer ���������� outer���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ����
--outer joining�� ���������� �۵��Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
  AND b.deptno(+) = 10;
  
--ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);

--outer join �ǽ� outerjoin1)
SELECT  b.buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                       AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--oracle
SELECT b.buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outer join �ǽ� outerjoin2)
SELECT  TO_DATE('05/01/25', 'YY/MM/DD'), buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                       AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--outer join �ǽ� outerjoin3)
SELECT  TO_DATE('05/01/25', 'YY/MM/DD'), buy_prod, prod_id, prod_name, nvl(buy_qty, 0)
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id 
                                       AND buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--outer join �ǽ� outerjoin4)
SELECT p.pid, pnm, nvl(cid, 1)cid, nvl(day, 0)day, nvl(cnt, 0)cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
  AND cid(+) = 1;

--outer join �ǽ� outerjoin5)
SELECT a.pid, pnm, a.cid, cm.cnm, day, cnt
FROM customer cm,
    (SELECT p.pid, pnm, nvl(cid, 1)cid, nvl(day, 0)day, nvl(cnt, 0)cnt
    FROM cycle c, product p
    WHERE c.pid(+) = p.pid
      AND cid(+) = 1) a
WHERE a.cid = cm.cid
  AND cnm = 'brown';  
  
--cross join �ǽ� crossjoin1)
SELECT cid, cnm, pid, pnm
FROM customer CROSS JOIN product;

--subquery : main������ ���ϴ� �κ� ����
--���Ǵ� ��ġ : 
-- SELECT - scalar subquery (�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�.)
-- FROM - inline view
-- WHERE - subquery

--SCALAR subquery
SELECT empno, ename, SYSDATE now/*���糯¥*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now/*���糯¥*/
FROM emp;

--SMITH���� ���� �μ��� ��� ������� 
--1. SMITH�� �μ���ȣ(�� ���� ��ü�� 20�̶�� ���� ����?!)
SELECT deptno --20
FROM emp
WHERE ename = 'SMITH';
--2. 20�� �μ��� ����ִ�?
SELECT *
FROM emp
WHERE deptno = 20;
--3. ���� �����ش�
SELECT *
FROM emp
WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH');

--�������� �ǽ� sub1) ��� �޿����� ���� �޿� �޴� ������ ��ȸ
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT ROUND(AVG(sal), 2)
             FROM emp);

--�������� �ǽ� sub2) ��� �޿����� ���� �޿� �޴� �������� ��ȸ
SELECT *
FROM emp
WHERE sal > (SELECT ROUND(AVG(sal), 2)
             FROM emp);
             
--�������� �ǽ� sub3)
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));