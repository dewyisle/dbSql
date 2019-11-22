--상향식 계층쿼리
--특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아니다)
--디자인팀을 시작으로 상위부서를 조회
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

--
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

--실습 h_4) h_sum table이용, 
SELECT LPAD(' ',(level-1)*3, ' ')||s_id s_id, value
FROM h_sum
START WITH s_id=0
CONNECT BY PRIOR s_id=ps_id;

--
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

--실습 h_5)no_emp이용, 
SELECT LPAD(' ', 4*(LEVEL-1),' ')||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd;

--prunning branch (가지치기)
--계층쿼리에서 WHERE절은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다.

--dept_h테이블을 최상위 노드 부터 하향식으로 조회
SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, RPAD(' ', (LEVEL-1)*4, ' ')  || deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd 
            AND deptnm != '정보기획부';
---- WHERE절이 아닌 CONNECT BY PRIOR AND 절에 deptnm != '정보기획부'를 넣어야만 
--   예하 팀까지 삭제가 된다. 


--CONNECT_BY_ROOT(col) : col의 최상위 노드 컬럼 값
--SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이은 경로
--  .LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
--CONNECT_BY_ISLEAF : 해당 row가 leaf node인지 판별 (1:O, 0:X)
SELECT LPAD(' ', 4*(LEVEL-1),' ')||org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-') path_org_cd,
        CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd=parent_org_cd;

--
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

--h6) 게시글을 저장하는 board_test이용해 계층쿼리 작성
SELECT seq, LPAD(' ', 4*(level-1), ' ')|| title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq= parent_seq;

--h7) h6에서 최상위에 가장 최신글이 오도록 정렬(문제점 : 계층구조가 망가짐)
SELECT seq, LPAD(' ', 4*(level-1), ' ')|| title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq= parent_seq
ORDER BY seq desc;

--계층구조가 무너지지 않게 최신글 순 정렬(실습 h8)
SELECT seq, LPAD(' ', 4*(level-1), ' ')|| title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq= parent_seq
ORDER SIBLINGS BY seq desc;

--h9)
SELECT seq, LPAD(' ', 4*(level-1), ' ')|| title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq=parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq END DESC, seq;

--h9) 선생님쿼리1. CONNECT_BY_ROOT 이용
SELECT *
FROM
    (SELECT seq, LPAD(' ', 4*(level-1), ' ')|| title title,
           CONNECT_BY_ROOT(seq) r_seq
    FROM board_test
    START WITH parent_seq IS NULL
    CONNECT BY PRIOR seq= parent_seq)
ORDER BY r_seq DESC, seq; 

--h9) 선생님쿼리2. 컬럼생성
SELECT *
FROM board_test;
--글 그룹번호 컬럼 추가
ALTER TABLE board_test ADD (gn NUMBER);
--테이블로 가서 데이터 입력 
--쿼리작성
SELECT seq, LPAD(' ', 4*(level-1), ' ')|| title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

--
SELECT a.ename, a.sal, b.sal
FROM (SELECT ename, sal, ROWNUM rn
    FROM
        (SELECT ename, sal
        FROM emp
        ORDER BY sal DESC))a,
    (SELECT ename, sal, ROWNUM rn
    FROM
        (SELECT ename, sal
        FROM emp
        ORDER BY sal DESC))b
WHERE a.rn = b.rn(+)-1;


