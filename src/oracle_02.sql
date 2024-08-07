/*
< 서브쿼리 내용 부분 추가 >
1. exists 연산자
- 서브쿼리의 데이터가 존재하는지를 확인하고 존재하면 true, 존재하지 않으면 false를 리턴

문제1) 10번 부서에 해당하는 부서명이 존재한다면 사원의 정보를 출력하시오.
문제2) 50번 부서에 해당하는 부서명이 존재한다면 사원의 정보를 출력하시오.
*/

-- 1번:  사원 정보 출력함
select * from employee
where exists (select dno from employee where dno = 10);

-- 2번: 사원 정보를 출력하지 않음
select * from employee
where exists (select dno from employee where dno = 50);

/*
< DML >
    - 생성된 테이블에 데이터를 조회, 추가, 수정, 삭제하는 명령
    - select(데이터 조회) 정리
    - insert(데이터 추가), update(데이터 수정), delete(데이터 삭제)
    - sqldeveloper에서는 commit(확정) 명령을 사용해야 DB서버에 반영이 된다.

    1. insert문
        insert into 테이블명(컬럼명, 컬럼명, ...) values(값, 값, ...);
        
    - 1번 방법: 컬럼과 컬럼에 대한 값을 정확하게 나열하여 추가하는 방법
    insert into dept(dno, dname, loc) values(10, '회계팀', '과천');
    
    - 2번 방법: 특정 컬럼만 값을 추가하는 방법
    - 추가하지 않은 컬럼의 값은 null이 됨.
    - 명시적으로 null을 추가할 수도 있음.
    - not null인 컬럼은 생략할 수 없음.★
    insert into dept(dno, dname) values(20, '연구팀');
    
    - 3번 방법: 컬럼명을 생략하는 방법
    - 테이블의 모든 컬럼의 값을 생성한 순서대로 누락없이 입력할 때만 가능
    
    - 4번 방법: 다른 테이블의 데이터를 추가하는 방법
    
*/

-- 테이블 확인
select table_name, status from user_tables;

-- 테이블 삭제
drop table emp;
drop table dept;

-- 테이블 복제
create table emp as select * from employee where 0 = 1;
create table dept as select * from department where 0 = 1;

-- 테이블 데이터 확인, 구조 확인
select * from emp;
desc emp;
select * from dept;
desc dept;

-- 1번 추가: 컬럼명, 값을 차례대로 모두 나열하여 추가하는 방법
insert into dept(dno, dname, loc) values(10, '회계팀', '서울');
commit;
select * from dept;

-- 2번 추가: 특정 컬럼만 추가하는 방법 1번(추가하지 않는 컬럼 생략)
insert into dept(dno, dname) values(20, '연구팀');
commit;
select * from dept;

-- 2번 추가: 특정 컬럼만 추가하는 방법 2번(추가하지 않는 컬럼을 null로 삽입)
insert into dept(dno, dname, loc) values(30, '영업팀', null);
commit;
select * from dept;

-- 3번 추가: 컬럼명을 생략하는 방법
insert into dept values(40, '운영팀', '일산');
commit;
select * from dept;

-- 에러: SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
insert into dept values(50, '기획팀');

-- 가능: 컬럼명을 생략하고, 삽입하지 않는 컬럼은 null을 추가하면 됨.
insert into dept values(50, '기획팀', null);
commit;
select * from dept;

-- 날짜 데이터를 추가하는 방법
-- 날짜형식: yyyy/mm/dd, yy/mm/dd, yyyy-mm-dd
insert into emp(eno, ename, hiredate) values(1000, '이정재', '2024/03/02');
commit;
select eno, ename, to_char(hiredate, 'yyyy-mm-dd') from emp;

insert into emp(eno, ename, hiredate) values(2000, '이병헌', '24/03/03');
commit;
select * from emp;
select eno, ename, to_char(hiredate, 'yyyy/mm/dd') from emp;

insert into emp(eno, ename, hiredate) values(3000, '위하준', '2024-03-04');
commit;
select * from emp;
select eno, ename, to_char(hiredate, 'yy/mm/dd') from emp;

-- 오늘 날짜를 추가, sysdate
insert into emp(eno, ename, hiredate) values(4000, '공유', sysdate);
commit;
select eno "사번", ename "사원명", to_char(hiredate, 'yyyy-mm-dd') "입사날짜" from emp;

-- 1번 - 다른 테이블의 모든 데이터를 복사하여 추가
insert into emp select * from employee;
commit;
select * from emp;

-- 2번 - 다른 테이블의 특정 데이터만 복사하여 추가
truncate table emp;
insert into emp select * from employee where dno = 10;
commit;
select * from emp;

-- 3번 - 다른 테이블의 특정 컬럼만 복사하여 추가
insert into emp(eno, ename, job, hiredate, salary) select eno, ename, job, hiredate, salary from employee;
commit;
select * from emp;

-- 에러: SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
insert into emp select eno, ename, job, hiredate, salary from employee;

/*
< DML >
    2. update문
    - 테이블의 데이터를 조건에 의해서 수정하는 명령문
    update 필드명
    set 변경할 컬럼과 값
    where 조건식

*/

truncate table emp;
truncate table dept;
insert into emp select * from employee;
insert into dept select * from department;
commit;

select * from emp;
select * from dept;
select table_name from user_tables;

-- 문제1) 30번 부서의 업무를 CLARK으로 변경하시오.
update emp
set job = 'CLARK'
where dno = 30;

commit;

-- 문제2) SCOTT 사원의 연봉을 4000으로 수정하시오.
update emp
set salary = 4000
where ename = 'SCOTT';
commit;

-- 문제3) 10번 부서의 부서명을 PROGRAMMING, 지역명을 SEOUL로 변경하시오.
update dept
set dname = 'PROGRAMMING', loc = 'SEOUL'
where dno = 10;
commit;

-- 문제4) 20번 부서의 지역명을 30번 부서의 지역명으로 변경하시오.
update dept
set loc = (select loc from dept where dno = 30)
where dno = 20;
commit;

-- 문제5) 40번 부서의 부서명과 지역명을 10번 부서의 부서명과 지역명으로 변경하시오.
-- 다중열 서브쿼리(조건이 같을때만 사용 가능)
update dept
set (dname, loc) = (select dname, loc from dept where dno = 10) 
where dno = 40;
commit;

-- 문제6) 10번 부서에서 근무하는 사원의 연봉을 10% 인상하시오.
update emp
set salary = salary + salary * 0.1
where dno = 10;
rollback;
commit;

-- 문제7) 사번이 7788인 사원의 업무와 급여를 사번이 7499인 사원의 업무와 급여와 일치하도록 수정하시오.
update emp
set (job, salary) = (select job, salary from emp where eno = 7499)
where eno = 7788;
commit;

select * from emp;
select * from dept;

-- 문제) 30번 부서에서 근무하고, 업무가 SALESMAN인 사원의 연봉을20% 인상하고, 성과금을 100더해서 인상하도록 수정하시오.
update emp
set salary = salary + salary * 0.2, commission = nvl(commission, 0) + 100
where dno = 30 and job = 'SALESMAN';

/*
< DML >
    3. delete
    - 테이블에서 조건에 해당하는 데이터를 삭제하는 명령문
    - from은 생략가능(오라클에서는)
    delete from 테이블명
    where 조건식

*/

-- 문제1) dept 테이블에서 10부서의 데이터를 삭제하시오.
delete from dept
where dno = 10;

select * from dept;
commit;

-- 테이블 삭제하고 다시 값 추가
truncate table emp;
truncate table dept;

insert into emp select * from employee;
insert into dept select * from department;
commit;
select * from emp;
select * from dept;

-- 문제2) RESEARCH 부서를 삭제하시오.
delete dept where dname = 'RESEARCH';
select * from dept;
commit;

-- 문제3) 연봉이 1000보다 작은 사원의 정보를 삭제하시오.
delete emp where salary < 1000;
select * from emp;
commit;

-- 문제4) 상관이 없는 사원의 정보를 삭제하시오.
delete emp where manager is null;
select * from emp;
commit;

-- 문제5) 연봉이 1000에서 2000(포함) 사이의 사원의 정보를 삭제하시오.
delete emp where salary between 1000 and 2000;
select * from emp;
commit;

-- 문제6) SALES 부서에서 근무하는 사원의 정보를 삭제하시오.
delete emp where dno = (select dno from dept where dname = 'SALES');
select * from emp;
commit;

-- 문제7) 부서번호가 10 또는 40인 부서를 삭제하시오.
delete dept where dno in (10, 40);
select * from dept;
commit;

-- 문제8) emp 테이블에서 모든 데이터를 삭제하시오.
-- where절을 사용하지 않으면 모든 데이터를 삭제
delete from emp;
select * from emp;
commit;

/*
< truncate table, delete from의 차이 >
1. truncate table : 메모리의 공간까지 모두 삭제, 모든 데이터를 삭제할 때 권장, DDL(commit이 필요없음)
2. delete from : 데이터만 삭제(메모리의 공간은 남아있음), 조건식에 대한 데이터를 삭제할 때 사용, DML(commit이 필요함)

    ★★★★★
    < 제약 조건 (Constraint Rule) >
    - 데이터가 무결성을 가지도록 하는 조건
    - 테이블에 유효하지 않은 데이터는 입력할 수 없도록 각 컬럼에 설정하는 조건
    
    < null과 not null >
    1. null : 값이 없어도 되는 상태
    2. not null : 값이 반드시 존재해야 하는 상태
    
    < RDBMS의 여러 가지 키 >
        1. 후보키(Candidate key)
        - 기본키가 될 수 있는 키들
        - 최소성과 유일성을 만족함
        
        2. 기본키(primary key)
        - 후보키들 중에서 기본키로 선택된 키
        - 최소성과 유일성을 만족함
        
        3. 대체키(alternate key)
        - 후보키들 중에서 기본키로 선택된 키가 아닌 키
        - 최소성과 유일성을 만족함
        
        4. 슈퍼키(super key)
        - 두 개 이상의 컬럼을 사용하여 기본키로 사용할 수 있도록 만든 키
        - 유일성은 만족하고, 최소성은 만족하지 않음
        
        5. 외래키(foreign key)
        - 부모 테이블의 기본키를 참조하여 참조 무결성 제약조건을 가지도록 하는 키
    
    < 제약 조건의 종류 >
        1. not null
        - 컬럼에 null값을 갖지 못하도록 저장하는 것
        
        2. unique
        - 모든 데이터 중에서 유일한 값을 가지도록 하는 것
        
        3. primary key
        - 기본키(주키), 표기할 때는 PK
        - 컬럼에 null값을 가질 수 없고, 유일한 값을 가지도록 하는 것
        - not null과 unique를 합친 제약 조건
        
        4. foreign key
        - 외래키, 표기할 때는 FK
        - 자식 테이블에 컬럼이 부모 테이블의 특정 컬럼을 참조하도록 만든 키
        - 참조 무결성을 설정하는 키
        # 부모 테이블: 자식 테이블에 의해서 참조가 되는 테이블, 참조되는 컬럼은 반드시 기본키(PK)이어양 함. 
        # 자식 테이블: 부모 테이블을 참조하는 테이블, 참조하는 컬럼은 외래키(FR)가 됨.
        
        5. check
        - 컬럼에 허용하는 값의 범위를 설정하도록 하는 것
        
        < 제약 조건은 아니고, 추가적으로 알아두는 기본 개념 >
        - default : 컬럼에 값을 설정하지 않을 때 기본적으로 갖게 되는 값
        - 

*/

drop table emp;
drop table dept;

-- 1. not null: 제약 조건
create table emp (
eno number(4)not null,
ename varchar2(10) not null,
job varchar2(9),
salary number(7, 2)
);

select * from emp;
desc emp;

-- 실행된다
insert into emp(eno, ename) values(1000, 'KIM');
select * from emp;

-- 에러: ORA-01400: NULL을 ("HM01"."EMP"."ENAME") 안에 삽입할 수 없습니다
-- => not null 자리에 null을 넣을 수 없다라는 해석.
insert into emp(eno, job) values(2000, 'MANAGER');

insert into emp(eno, ename) values(1000, 'LEE');
select * from emp;

-- 에러: ORA-01400: NULL을 ("HM01"."EMP"."ENO") 안에 삽입할 수 없습니다
insert into emp(ename, job, salary) values('HONG', 'CLERK', 3000);

-- 2. unique 제약 조건
create table emp2 (
eno number(4) unique,
ename varchar2(10) not null,
job varchar2(9),
salary number(7, 2)
);

-- 실행된다
insert into emp2(eno, ename) values(1000, 'KIM');
select * from emp2;
desc emp2;
commit;

-- 에러: ORA-00001: 무결성 제약 조건(HM01.SYS_C007305)에 위배됩니다
-- unique 제약 조건에 위배됨
-- => 유일해야 하는 자리에 유니크 자리에 같은 값을 또 값을 넣을 수 없다라는 해석
insert into emp2(eno, ename) values(1000, 'LEE');

-- null은 unique한 것으로 간주됨.
insert into emp2(ename, job) values('LEE', 'SALESMAN');
select * from emp2;

-- 3. primary key 제약조건
create table emp3 (
eno number(4) primary key,
ename varchar2(10) not null,
job varchar2(9),
salary number(7, 2)
);

-- 실행된다
insert into emp3(eno, ename) values(1000, 'KIM');
select * from emp3;

-- 에러: ORA-01400: NULL을 ("HM01"."EMP3"."ENO") 안에 삽입할 수 없습니다
insert into emp3(ename, job) values('LEE', 'ANALYST');

-- 에러: ORA-00001: 무결성 제약 조건(HM01.SYS_C007307)에 위배됩니다
insert into emp3(eno, ename) values(1000, 'LEE');

-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."EMP3"."ENO") 안에 삽입할 수 없습니다
insert into emp3(eno, ename) values(null, 'PARK');

-- 4. foreign key 제약조건
drop table emp;
drop table dept;

-- (1) 부모 테이블을 먼저 생성해야 함.
-- 부서 테이블(부모 테이블), 반드시 PK가 있어야 함.
create table dept (
dno number(2) constraint dept_dno_pk primary key,
dname varchar2(14),
loc varchar2(13)
);

desc dept;

insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');

select * from dept;
commit;

-- (2) 그 다음에 자식 테이블을 생성함
-- 사원 테이블 (자식 테이블) -> FK를 설정함
create table emp (
eno number(4) constraint emp_eno_pk  primary key,
ename varchar2(10) constraint emp_ename_nn not null,
job varchar2(8),
salary number(7, 2),
dno number(2) constraint emp_dno_fk references dept
);

desc emp;

/*
    < user_constraints >
    - 사용자가 생성한 테이블의 제약조건을 확인하는 데이터 사전
    
    < 유용한 필드 >
    1. owner: 사용자 계정
    -
    2. table_name: 테이블 이름
    3. constraint_name: 제약조건 이름
    4. constraint_type: 제약조건 종류,
        P: primary key
        C: not null, check
        U: unique
        R(Refernce, 참조한다): foreign key
    5. status: 제약조건 상태, enbled: 사용 가능, disbled: 사용 불가
    6. search_condition: not null과 check 제약 조건을 구분 한다 (=> C)
    -
    7. last_change: 최종수정 날짜
    8. index_name: 인덱스 이름

*/

select * from user_constraints;
select * from user_constraints where table_name in ('EMP', 'DEPT');
select table_name, constraint_name, constraint_type from user_constraints where table_name in ('EMP', 'DEPT');

-- 4. foreign key 제약조건 확인
-- null은 허용, dno는 foreign key만 설정함.
insert into emp(eno, ename) values(1000, 'KIM');
select * from emp;

insert into emp(eno, ename) values(2000, 'LEE');
select * from emp;

insert into emp(eno, ename, dno) values(3000, 'PARK', 10);
select * from emp;
commit;

-- 에러: ORA-02291: 무결성 제약조건(HM01.EMP_DNO_FK)이 위배되었습니다- 부모 키가 없습니다
-- dept 테이블에 존재하지 않는 부서번호
insert into emp(eno, ename, dno) values(4000, 'CHKI', 50);

-- 데이터 추가
insert into emp(eno, ename, dno) values(5000, 'JUNG', 10);
insert into emp(eno, ename, dno) values(6000, 'HUNG', 20);

-- dept 테이블에서 10부서를 삭제한다면
-- 에러: ORA-02292: 무결성 제약조건(HM01.EMP_DNO_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
-- ◈ 부모 테이블을 참조하고 있는 자식 테이블에 10번 부서 데이터가 있어서 삭제할 수 없음
delete dept where dno = 10;

-- ###########################################################################################3
/*
1. 테이블을 생성하는 방법 (제약조건 포함)
- 컬럼명 타입 constraint 제약조건이름 제약조건
ex) eno number(4) constraint emp_eno_pk primary key
- 제약조건이름 만드는 방법: 테이블명_컬럼명_제약조건 으로 만들것을 추천
ex) emp_eno_pk : emp 테이블에 있는 eno 컬럼에 primary key의 제약조건이 걸려있다

2. 제약조건을 사용하는 위치에 따른 방법
- 컬럼 레벨로 작성하는 방법: 컬럼명 뒤에 제약조건을 적는 방법
- 테이블 레벨로 작성하는 방법: 테이블의 맨 마지막에 제약조건을 적는 방법
# not null 제약조건은 컬럼 레벨에만 사용 가능(테이블 레벨로는 작성 불가)


*/

select table_name from user_tables;
drop table emp;
drop table dept;

-- 부모: dept 테이블 생성 (컬럼 레벨)
create table dept (
dno number(2) constraint dept_dno_pk primary key,
dname varchar2(14) constraint dept_dname_nn not null,
loc varchar2(13) constraint dept_loc_nn not null
);

select table_name, constraint_name, constraint_type, status from user_constraints where table_name in ('DEPT');
select * from dept;

-- 자식: emp 테이블 생성 (컬럼 레벨, 테이블 레벨)
-- check 제약조건 설정, default 값 설정
-- not null, check: 컬럼 레벨로 제약조건을 설정
-- PK, FK: 테이블 레벨로 제약조건을 설정
create table emp (
eno number(4), -- ◈
ename varchar2(10) constraint emp_ename_nn not null,
job varchar2(9),
manager number(4),
hiredate date default sysdate,   -- ◈해석: hiredate 값을 넣지 않으면 오늘 날짜를 넣어라
salary number(7, 2) constraint emp_salary_c check (salary between 2000 and 5000),
commission number(7, 2),
dno number(2) constraint emp_dno_nn not null,
-- 테이블 레벨 
constraint emp_eno_pk primary key(eno), -- ◈primary key는 위쪽에 eno에 써도 상관 없음
constraint emp_dno_fk foreign key(dno) references dept(dno) -- dno는 not null, foreign key를 둘다 줘야 함
);

desc emp;
select table_name, constraint_name, constraint_type, status from user_constraints where table_name in ('EMP');

-- dept 테이블 데이터 추가

insert into dept values(10, '회계팀', '서울');
insert into dept values(20, '연구팀', '인천');
insert into dept values(30, '영업팀', '과천');
insert into dept values(40, '운영팀', '부천');
select * from dept;

-- emp 테이블 데이터 추가
-- 참조 무결성 확인 -> foreign key 제약조건을 확인

insert into emp(eno, ename, salary, dno) values(1000, 'KIM', 2000, 10);
select * from emp;
commit;

-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."EMP"."DNO") 안에 삽입할 수 없습니다
insert into emp(eno, ename, salary, dno) values(2000, 'LEE', 3000, null);

-- 에러: ORA-02291: 무결성 제약조건(HM01.EMP_DNO_FK)이 위배되었습니다- 부모 키가 없습니다
insert into emp(eno, ename, salary, dno) values(3000, 'LEE', 4000, 50);

--해결책 1번: dept 테이블에 50번 부서를 생성하고, emp 테이블에 데이터를 추가
insert into dept values(50, '홍보팀', '일산');
select * from dept;
commit;

-- dept 테이블에 50번 부서를 추가한 후, emp 테이블 50번 부서의 데이터를 추가함 -> 성공
insert into emp(eno, ename, salary, dno) values(3000, 'LEE', 4000, 50);
select * from emp;

-- dept 테이블에서 50번 부서를 삭제
-- 에러: ORA-02292: 무결성 제약조건(HM01.EMP_DNO_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
delete dept
where dno = 50;

-- 해결책 1번: 50번 부서에서 근무하는 사원을 삭제한 후, 50번 부서를 삭제
delete emp where dno = 50;
select * from emp;
commit;

delete dept where dno = 50;
select * from dept;

-- #############################################################################################
-- 체크 제약조건 확인: salary number(7, 2) constraint emp_salary_c check (salary between 2000 and 5000),
-- 성공
insert into emp(eno, ename, salary, dno) values(4000, 'PARK', 3000, 20);
select * from emp;
commit;

-- 에러: ORA-02290: 체크 제약조건(HM01.EMP_SALARY_C)이 위배되었습니다
insert into emp(eno, ename, salary, dno) values(5000, 'CHOI', 1000, 30);
select * from emp;

-- 참조 무결성 확인
-- dept 테이블을 제거
-- 에러: ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
drop table dept;

-- 참조 무결성이 설정되어 있을 때 강제로 부모 테이블을 삭제하는 방법 (추천하는 방법은 아님)
-- 제약조건이 걸려 있을 때는 constraint
drop table dept cascade constraint purge;
drop table dept cascade constraint;
desc dept;
desc emp;

drop table emp;
select table_name, constraint_name, constraint_type, search_condition, status from user_constraints where table_name in ('EMP', 'DEPT');

drop table dept;
drop table emp;
select table_name from user_tables;
-- 확인 문제
create table dept (
dno number(2) constraint dept_dno_pk primary key,
dname varchar2(14) constraint dept_dname_u unique,
loc varchar2(13) constraint dept_loc_c check(loc in ('서울', '인천', '부천', '일산', '구리'))
);

select table_name, constraint_name, constraint_type, search_condition, status
from user_constraints
where table_name in ('DEPT');

create table emp (
eno number(4),
ename varchar2(10) constraint emp_ename_u unique,
job varchar2(9) constraint emp_job_c check(job in ('사원', '대리', '과장', '부장', '차장')),
hiredate date default sysdate,
salary number(7, 2) constraint emp_salary_c check (salary between 3000 and 6000),
dno number(2) constraint emp_dno_nn not null,
constraint emp_eno_pk primary key(eno),
constraint emp_dno_fk foreign key(dno) references dept(dno)
);

-- dept 테이블 데이터 추가
insert into dept values(10, 'A팀', '서울');
insert into dept values(20, 'B팀', '인천');
insert into dept values(30, 'C팀', '구리');
insert into dept values(40, 'D팀', '부천');
insert into dept values(50, 'E팀', '일산');

-- dno: primary key 제약조건
-- 에러: insert into dept(dname, loc) values('A팀', '인천');
insert into dept(dname, loc) values('A팀', '인천');

-- dname: unique 제약조건
-- 에러: ORA-00001: 무결성 제약 조건(HM01.DEPT_DNO_PK)에 위배됩니다
insert into dept values(50, 'C팀', '구리');
-- 에러: ORA-00001: 무결성 제약 조건(HM01.DEPT_DNO_PK)에 위배됩니다
insert into dept values(30, 'A팀', '부천');

-- loc: check 제약조건
-- 에러: ORA-02290: 체크 제약조건(HM01.DEPT_LOC_C)이 위배되었습니다
insert into dept values(60, 'B팀', '부산');

select * from dept;

-- emp 테이블 데이터 추가
insert into emp(eno, ename, job, salary, dno) values(1000, '홍길동', '사원', 3000, 10);
insert into emp(eno, ename, job, salary, dno) values(2000, '김길동', '대리', 4000, 20);
insert into emp(eno, ename, job, salary, dno) values(3000, '박땡땡', '과장', 4800, 40);
insert into emp(eno, ename, job, salary, dno) values(4000, '김철수', '부장', 5000, 50);
insert into emp(eno, ename, job, salary, dno) values(5000, '박똥똥', '차장', 5000, 30);
insert into emp(eno, ename, job, salary, dno) values(6000, '최길동', '부장', 5200, 30);

-- eno: primary key 제약조건
-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."EMP"."ENO") 안에 삽입할 수 없습니다
insert into emp(eno, ename, job, salary, dno) values(null, '홍길동', '사원', 3000, 10);

-- 에러: ORA-00001: 무결성 제약 조건(HM01.EMP_ENO_PK)에 위배됩니다
insert into emp(eno, ename, job, salary, dno) values(5000, '박철수', '사원', 3000, 10);

-- ename: unique 제약조건
-- 에러: ORA-00001: 무결성 제약 조건(HM01.EMP_ENAME_U)에 위배됩니다
insert into emp(eno, ename, job, salary, dno) values(6000, '홍길동', '부장', 5000, 20);

-- salary: check 제약조건
-- 에러: ORA-02290: 체크 제약조건(HM01.EMP_SALARY_C)이 위배되었습니다
insert into emp(eno, ename, job, salary, dno) values(6000, '김철수', '사원', 2999, 10);

-- dno: not null 제약조건
-- 에러: ORA-01400: NULL을 ("HM01"."EMP"."DNO") 안에 삽입할 수 없습니다
insert into emp(eno, ename, job, salary) values(6000, '김철수', '사원', 2999);

-- dno: foreign key 제약조건
-- 에러: ORA-02291: 무결성 제약조건(HM01.EMP_DNO_FK)이 위배되었습니다- 부모 키가 없습니다
insert into emp(eno, ename, job, salary, dno) values(6000, '김통통', '사원', 3000, 60);

-- default값 확인
-- table_name, column_name, data_type, data_default
select * from user_tab_columns where table_name in ('EMP');
select table_name, column_name, data_type, data_default from user_tab_columns where table_name in ('EMP');

select * from emp;
commit;

drop table emp;
drop table dept;
select table_name from user_tables;
