-- emp���̺��� �μ���ȣ(deptno)�� ����
--emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ��� 
--dept ���̺�� ������ ���� �μ��� ��ȸ

--���� ����
-- ANSI : ���̺�1 JOIN ���̺�2 ON(���̺�.COL = ���̺�2.COL)
--        emp JOIN dept ON(emp.deptno = dept.deptno)
-- ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.COL = ���̺�2.COL
--          FROM emp, dept WHERE emp.deptno = dept.deptno

--�����ȣ, �����, �μ���ȣ, �μ���
--ANSI
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);
--ORACLE
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept 
WHERE emp.deptno = dept.deptno;

-- �ǽ� join0_2)
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.sal > 2500
ORDER BY dept.dname;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno AND emp.sal >2500)
ORDER BY dept.dname;

-- �ǽ� join0_3)
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500 AND empno > 7600
ORDER BY dept.dname;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno 
                      AND emp.sal >2500 
                      And emp.empno > 7600)
ORDER BY dept.dname;

-- �ǽ� join0_4)
SELECT emp.empno, emp.ename, emp.sal, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY dept.dname;

SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno 
                      AND emp.sal >2500 
                      And emp.empno > 7600
                      AND dept.dname = 'RESEARCH')
ORDER BY dept.dname;

--base_tables.sql �ǽ� join1)
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p JOIN lprod l ON(p.prod_lgu = l.lprod_gu);

--base_tables.sql �ǽ� join2)
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod_buyer = buyer_id;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON(prod_buyer = buyer_id);

--base_tables.sql �ǽ� join3)
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member AND cart_prod = prod_id;

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON(mem_id = cart_member) 
            JOIN prod ON(cart_prod = prod_id);
            
--base_tables.sql �ǽ� join4)
SELECT cm.cid, cnm, pid, day, cnt 
FROM customer cm, cycle c
WHERE cm.cid = c.cid
  AND cnm IN('brown', 'sally');
  
SELECT cm.cid, cnm, pid, day, cnt
FROM customer cm JOIN cycle c ON(cm.cid = c.cid AND cnm IN('brown', 'sally'));

--base_tables.sql �ǽ� join5)
SELECT cm.cid, cnm, c.pid, pnm, day, cnt 
FROM customer cm, cycle c, product p
WHERE cm.cid = c.cid AND c.pid = p.pid
  AND cnm IN('brown', 'sally');
  
SELECT cm.cid, cnm, c.pid, pnm, day, cnt
FROM customer cm JOIN cycle c ON(cm.cid = c.cid) 
                 JOIN product p ON(c.pid = p.pid) 
                 AND cnm IN('brown', 'sally');
                 
--base_tables.sql �ǽ� join6)
SELECT customer.cid, customer.cnm, cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM customer, cycle, product 
WHERE customer.cid = cycle.cid 
  AND cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm, cycle.pid, product.pnm;

--������ ��Ʈ
--1.��, ��ǰ�� ���� �Ǽ��� ���Ѵ�.(inline-view)
--2. 1������ ���� inline-view�� customer, product ���̺�� �����Ѵ�.
SELECT a.cid, c.cnm, a.pid, p.pnm, a.cnt
FROM customer c, product p,
    (SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid) a
WHERE c.cid = a.cid AND a.pid = p.pid;

--WITH�� �̿��� Ǭ ������ Ǯ��
with cycle_groupby as(
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid)
SELECT customer.cid, cnm, product.pid, pnm, cnt
FROM cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
  AND cycle_groupby.pid = product.pid;
  
--base_tables.sql �ǽ� join7)
SELECT c.pid, pnm, SUM(cnt)
FROM cycle c, product p
WHERE c.pid = p.pid
GROUP BY c.pid, pnm;
