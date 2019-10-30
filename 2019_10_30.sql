-- SELECT : ��ȸ�� �÷� ���
--        - ��ü �÷� ��ȸ : *
--        - �Ϻ� �÷� : �ش� �÷��� ���� (, ����) 
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� �������.
-- �� keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
 SELECT * FROM prod;
 
-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;

-- SELECT(�ǽ� select1) ��ȸ�ϱ�
-- ����1) lprod ���̺��� ��� �����͸� ��ȸ�ϴ� ����
SELECT * FROM lprod;

-- ����2) buyer ���̺��� buyer_id, buyer_name �÷��� ��ȸ�ϴ� ����
SELECT buyer_id, buyer_name
From buyer;

-- ����3) cart���̺��� ��� ������ ��ȸ
SELECT * FROM cart;

-- ����4) member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ
SELECT mem_id, mem_pass, mem_name
FROM member;


-- ������ / ��¥���� 
-- date type + ���� : ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�.
SELECT userid, usernm, reg_dt,
       reg_dt + 5 reg_dt_after5, 
       reg_dt - 5 as reg_dt_before5 
FROM users;

-- colum alias(�ǽ� select2) �÷���Ī�����ϱ�
-- ����1) 
SELECT prod_id id, prod_name name
FROM prod;

-- ����2)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

-- ����3)
SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;

-- ���ڿ� ����
-- java + --> sql ||
-- CONCAT(str, str) �Լ�
-- users���̺��� userid, usernm ��ġ��
SELECT userid, usernm, userid || usernm,
        CONCAT(userid, usernm)
FROM users;


-- ���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid,
        CONCAT('����� ���̵� : ', userid)
FROM users;

-- �ǽ� sel_conl1
SELECT *
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' QUERY 
FROM user_tables;


-- desc table
-- ���̺� ���ǵ� �÷��� �˰� ���� ��
-- 1. desc
-- 2. select * from ���̺��
desc emp;

SELECT *
FROM emp;


--WHERE��, ���� ������
