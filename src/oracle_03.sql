/*
< 제약조건의 변경 >
- 테이블의 구조를 변경하는 것
- alter table 명령을 사용
*/
-- 테이블의 구조와 데이터를 복제, 제약조건은 복제되지 않음.
create table emp as select * from employee; 
create table dept as select * from department;

select * from emp;
select * from dept;
desc emp;
desc dept;

select table_name, constraint_name, constraint_type, search_condition, status
from user_constraints
where table_name in ('EMPLOYEE', 'DEPARTMENT');

-- 제약조건은 복제되지 않은걸 확인.
select table_name, constraint_name, constraint_type, search_condition, status
from user_constraints
where table_name in ('EMP', 'DEPT');


-- ############ 1번 방법 ############
-- ◈제약조건을 추가한다 => 즉, 테이블의 구조를 변경한다.
-- 1. dept 테이블에 제약조건 추가
-- (1)dno: primary key 제약조건 추가
alter table dept
add constraint dept_dno_pk primary key(dno);

-- (2)dname: not null 제약조건 추가
/*
    에러: ORA-00904: : 부적합한 식별자
    not null 제약조건은 add constraint로 추가할 수 없다.
*/
--alter table dept
--add constraint dept_dname_nn not null(dname);

/*
modify : 변경
drop column : 컬럼 삭제
rename : 이름 변경
truncate : 테이블을 잘라냄
*/

-- ◈null을 not null로 변경한다라고 생각. (추가하는 개념이 아님)
alter table dept
modify dname constraint dept_dname_nn not null;

-- not null을 null로 변경한다.
alter table dept
modify dname null;

-- (3)loc 컬럼을 not null로 변경
alter table dept
modify loc constraint dept_loc_nn not null;

-- #수시로 테이블 제약조건 확인
select table_name, constraint_name, constraint_type, search_condition, status
from user_constraints
where table_name in ('EMP', 'DEPT')
order by table_name;

-- 2. emp 테이블에 제약조건 추가
-- (1)eno: PK
alter table emp
add constraint emp_eno_pk primary key(eno);

-- (2)ename: not null
alter table emp
modify ename constraint emp_ename_nn not null;

-- (3)job: check
alter table emp
add constraint emp_job_ck check (job in ('CLERK', 'SALESMAN', 'ANALYST', 'MANAGER', 'PRESIDENT'));

-- (4)salary: check
/*
    에러:ORA-02293: (HM01.EMP_SALARY_CK)을 검증할 수 없습니다 - 잘못된 제약을 확인합니다
        02293. 00000 - "cannot validate (%s.%s) - check constraint violated
    에러해석: 이미 존재하는 데이터의 2000 미만인 데이터가 있기 때문
*/
--alter table emp
--add constraint emp_salary_ck check (salary between 2000 and 5000);

alter table emp
add constraint emp_salary_ck check (salary between 100 and 5000);

-- <추가>commission을 not null로 변경
/*
    에러: ORA-02296: (HM01.EMP_COMMISSION_NN) 사용으로 설정 불가 - 널 값이 발견되었습니다.
        02296. 00000 - "cannot enable (%s.%s) - null values found
    에러해석: 이미 commission에 null값이 있기 때문에 not null로 바꾸지 못함
*/
--alter table emp
--modify commission constraint emp_commission_nn not null;

-- (5)dno: not null, FK
alter table emp
modify dno constraint emp_dno_nn not null;

alter table emp
add constraint emp_dno_fk foreign key(dno) references dept(dno);

-- (6)hiredate: default설정 (제약조건은 아님)
-- default가 아닌 컬럼을 default 컬럼으로 변경한다.
alter table emp
modify hiredate default sysdate;

-- default값은 제약조건확인법으로 못함.
select table_name, column_name, data_type, data_default
from user_tab_columns
where table_name in ('EMP');


-- ############ 2번 방법 ############
drop table emp;
drop table dept;
select table_name from user_tables;

create table emp as select * from employee;
create table dept as select * from department;
desc emp;
desc dept;

-- 1. dept 테이블에 제약조건 추가
-- (1)dno: primary key 제약조건 설정
alter table dept
modify dno constraint dept_dno_pk primary key;

-- (2)dname: not null 제약조건 설정
alter table dept
modify dname constraint dept_dname_nn not null;

-- (3)loc 컬럼을 not null로 변경
alter table dept
modify loc constraint dept_loc_nn not null;

-- #수시로 테이블 제약조건 확인
select table_name, constraint_name, constraint_type, search_condition, status
from user_constraints
where table_name in ('EMP', 'DEPT')
order by table_name;


-- 2. emp 테이블에 제약조건 추가
-- (1)eno: PK
alter table emp
modify eno constraint emp_eno_pk primary key;

-- (2)ename: not null
alter table emp
modify ename constraint emp_ename_nn not null;

-- (3)job: check
alter table emp
modify job constraint emp_job_ck check (job in('CLERK', 'SALESMAN', 'ANALYST', 'MANAGER', 'PRESIDENT'));

-- (4)salary: check
alter table emp
modify salary constraint emp_salary_ck check (salary between 100 and 5000);

-- (5)dno: not null, FK
alter table emp
modify dno constraint emp_dno_nn not null;

alter table emp
modify dno constraint emp_dno_fk references dept; -- 주의★

-- (6)hiredate: default설정 (제약조건은 아님)
-- default가 아닌 컬럼을 default 컬럼으로 변경한다.
alter table emp
modify hiredate default sysdate;

-- default값은 제약조건확인법으로 못함.
select table_name, column_name, data_type, data_default
from user_tab_columns
where table_name in ('EMP');


-- 3. dept 테이블에 데이터 추가
truncate table dept;
delete dept;  -- ◈제약조건은 빼고 데이터만 지움
insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');
select * from dept;
commit;

-- dept.dno 컬럼의 primary key 확인
-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."DEPT"."DNO") 안에 삽입할 수 없습니다
insert into dept values(null, 'INFO', 'SEOUL');
-- 에러: ORA-00001: 무결성 제약 조건(HM01.DEPT_DNO_PK)에 위배됩니다
insert into dept values(10, 'INFO', 'SEOUL');

-- dept.dname 컬럼의 not null 확인
-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."DEPT"."DNAME") 안에 삽입할 수 없습니다
insert into dept values(20, null, 'SEOUL');

-- dept.loc 컬럼의 not null 확인
-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."DEPT"."LOC") 안에 삽입할 수 없습니다
insert into dept values(10, 'INFO', null);


-- 4. emp 테이블에 데이터 추가
truncate table emp;
insert into emp(eno, ename, job, salary, dno) values(1000, 'KIM', 'CLERK', 3000, 10);
insert into emp(eno, ename, job, salary, dno) values(2000, 'LEE', 'SALESMAN', 4000, 20);
insert into emp(eno, ename, job, salary, dno) values(3000, 'CHOI', 'ANALYST', 2500, 30);
insert into emp(eno, ename, job, salary, dno) values(4000, 'PARK', 'MANAGER', 3500, 40);
insert into emp(eno, ename, job, salary, dno) values(5000, 'JUNG', 'PRESIDENT', 5000, 40);
select * from emp;

-- emp.eno 컬럼의 primary key 확인
-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."EMP"."ENO") 안에 삽입할 수 없습니다
insert into emp(eno, ename, job, salary, dno) values(null, 'KIM', 'CLERK', 3000, 10);
-- 에러: ORA-00001: 무결성 제약 조건(HM01.EMP_ENO_PK)에 위배됩니다
insert into emp(eno, ename, job, salary, dno) values(1000, 'TOM', 'MANAGER', 3000, 10);

-- emp.ename 컬럼의 not null 확인
-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."EMP"."ENAME") 안에 삽입할 수 없습니다
insert into emp(eno, ename, job, salary, dno) values(6000, null, 'MANAGER', 3000, 10);

-- emp.job 컬럼의 check 확인
-- 에러: ORA-02290: 체크 제약조건(HM01.EMP_JOB_CK)이 위배되었습니다
insert into emp(eno, ename, job, salary, dno) values(6000, 'TOM', 'INFO', 3000, 10);


-- emp.salary 컬럼의 check 확인
-- 에러: ORA-02290: 체크 제약조건(HM01.EMP_SALARY_CK)이 위배되었습니다
insert into emp(eno, ename, job, salary, dno) values(6000, 'TOM', 'CLERK', 6000, 10);

-- emp.eno 컬럼의 not null 확인
-- 에러: SQL 오류: ORA-01400: NULL을 ("HM01"."EMP"."DNO") 안에 삽입할 수 없습니다
insert into emp(eno, ename, job, salary, dno) values(6000, 'TOM', 'CLERK', 5000, null);
-- 에러: ORA-02291: 무결성 제약조건(HM01.EMP_DNO_FK)이 위배되었습니다- 부모 키가 없습니다
insert into emp(eno, ename, job, salary, dno) values(6000, 'TOM', 'CLERK', 5000, 60);

-- #########################################################################################
-- < 제약조건의 제거 >
-- foreign key가 설정되어 있을때의 제약조건 제거는 자식 테이블부터 제거한다.

-- 1. emp 테이블 제약조건 제거
-- (1) ename 컬럼의 not null 제거 (not null을 null로 변경한다라고 생각)
alter table emp
modify ename null;

-- (2) job 컬럼의 check 제거 (ename만 변경, 나머지는 다 제거)
alter table emp
drop constraint emp_job_ck;

-- (3) salary 컬럼의 check 제거
alter table emp
drop constraint emp_salary_ck;

-- (4) eno 컬럼의 primary key 제거
-- 1번 방법
alter table emp
drop constraint emp_eno_pk;
-- 2번 방법
alter table emp
drop primary key;

-- (5) dno 컬럼의 not null을 null로 변경
alter table emp
modify dno null;

-- (6) dno 컬럼의 foreign key 제거
alter table emp
drop constraint emp_dno_fk;


-- 2. dept 테이블 제약조건 제거
-- (1) dname 컬럼의 not null을 null로 변경
alter table dept
modify dname null;

-- (2) loc 컬럼의 not null을 null로 변경
alter table dept
modify loc null;

-- (3) dno 컬럼의 primary key 제거 -> 문제 발생
-- 에러: ORA-02273: 고유/기본 키가 외부 키에 의해 참조되었습니다 (foreign key 때문)
alter table dept
drop constraint dept_dno_pk;

-- 부모 테이블의 primary key 제거를 해결하는 방법 2가지
-- 1. 자식 테이블의 foreign key를 먼저 삭제하고 부모 테이블의 primary key를 삭제한다.
alter table emp
drop constraint emp_dno_fk;

-- 다시 생성
alter table dept
modify dno constraint dept_dno_pk primary key;

alter table emp
modify dno constraint emp_dno_fk references dept;

-- 2. 부모 테이블의 primary key를 강제로 지우는 방법
-- primary key를 강제로 지우면 자식 테이블의 foreign key도 자동으로 같이 삭제된다. ★
alter table dept
drop constraint dept_dno_pk cascade;

-- #########################################################################################
-- < 제약조건 이름 변경 >
alter table emp
rename constraint emp_salary_ck to emp_sal_c;

alter table emp
rename constraint emp_sal_c to emp_salary_ck;

-- 제약조건의 비활성화 -> 제약조건을 잠깐 끈다 ★ disable
alter table emp
disable constraint emp_salary_ck;
-- 확인
insert into emp(eno, ename, job, salary, dno) values(6000, 'HONG', 'MANAGER', 9000, 10);
select * from emp;
commit;

-- 제약조건의 활성화 enable
/*
    에러: ORA-02293: (HM01.EMP_SALARY_CK)을 검증할 수 없습니다 - 잘못된 제약을 확인합니다
    에러 해석: 이미 check 제약조건에 안맞는 값이 들어가서 활성화를 다시 시킬수 없다라는 뜻.
*/
alter table emp
enable constraint emp_salary_ck;

-- 제약조건을 위배하는 데이터는 삭제하고 다시 제약조건을 활성화시킨다
--delete emp where salary > 5000;
delete emp where salary not between 100 and 5000;

alter table emp
enable constraint emp_salary_ck;

-- #수시로 테이블 제약조건 확인
select table_name, constraint_name, constraint_type, search_condition, status
from user_constraints
where table_name in ('EMP', 'DEPT')
order by table_name;

-- #########################################################################################
/*
    < 뷰 (View) >
    - 하나 이상의 테이블로부터 만들어진 가상 테이블
    - 물리적으로 존재하진 않지만, 테이블과 같은 방법으로 사용함.
    - 실체는 없고, 텍스트로만 존재함.
    
    < 뷰의 종류 >
    1. 단순 뷰 : 하나의 테이블로부터 생성한 뷰
        - DML 명령을 실행할 수 있음.
        - DML 명령이 기본 테이블에 반영이 됨. -> 문제점
        
    2. 복합 뷰 : 두개 이상의 테이블로부터 생성한 뷰
        - 조인, 제약조건, 그룹 등의 유무에 따라 DML의 명령이 제한적으로 실행됨.
        - distinct, 그룹함수, rownum 등은 사용 불가
        
    < 뷰의 장점 >
    1. 보안성: 테이블의 특정 컬럼, 특정 행의 데이터의 노출을 막을 수 있다.
    2. 관리성: 필요한 정보만 접근하여 사용하므로 편리함.
    
    < 뷰의 옵션 >
    - 뷰의 조건절 뒤에 옵션을 사용하면 뷰를 통한 원본 테이블에 대한 변경을 제어할 수 있다.
    1. with read only : 뷰를 통해서는 조회만 가능하고, 추가, 수정, 삭제 작업을 할 수 없도록 함.
    2. with cheak option : 뷰의 조건식에 해당하는 데이터에 대해서만 추가, 수정이 가능하도록 설정 함.
    -> 주의! 조건절에 부합하지 않는 데이터도 삭제가 된다.
    
    < 뷰의 생성 방법 >
    1. create view 뷰이름 : 새로운 뷰 생성
    2. create or replace view 뷰이름 : 같은 이름 뷰가 있다면 제거하고, 다시 생성 -> 가장 많이 사용
    3. create or replace force view 뷰이름 : 테이블이 존재하지 않을때도 뷰를 생성
    -> 뷰는 물리적인 공간이 아닌 텍스트로만 존재하므로 가능.
    -> 테이블을 먼저 만들고, 테이블을 활용한 뷰를 생성하는 것이 일반적이지만
       필요에 따라 뷰를 먼저 만들어 두고, 나중에 테이블을 설계할 경우에 사용함.
    
*/
drop table emp;
drop table dept;
create table emp as select * from employee;
create table dept as select * from department;

-- 1. 단순뷰
-- (1) 단순 뷰 생성 1번
create view v_emp1 as select * from emp;
select * from v_emp1;
desc v_emp1;

-- 뷰 확인 (텍스트로 구성되어 있음을 확인)
select * from user_views;
select view_name, text from user_views;

-- (2) 단순 뷰 생성 2번 - 특정 컬럼
create view v_emp2 as select eno, ename, job, dno from emp;
select * from v_emp2;

-- (3) 단순 뷰 생성 3번 - 특정 컬럼을 컬렴명을 변경해서 생성
create view v_emp3(사번, 사원명, 업무, 부서번호) as select eno, ename, job, dno from emp;
select * from v_emp3;

-- (4) 단순 뷰 생성 4번 - 특정 컬럼과 특정 조건에 해당하는 데이터만 골라서 생성
create view v_emp4(사번, 사원명, 업무, 부서번호)
as select eno, ename, job, dno from emp where dno = 10;
select * from v_emp4;

-- 2. 복합 뷰
-- (1) 복합 뷰 생성 1번 - 2개의 테이블 조인
create view v_emp_com1
as select * from emp natural join dept;
select * from v_emp_com1;

-- (2) 복합 뷰 생성 2번 - 특정 컬럼과 특정 조건에 해당하는 데이터만 골라서 생성
create view v_emp_com2(사번, 사원명, 업무, 부서번호, 부서명, 지역명)
as select eno, ename, job, dno, dname, loc
from emp natural join dept
where dno = 30;

select * from v_emp_com2;

-- 3. 뷰 삭제
select view_name from user_views;
drop view v_emp_com2;

/*
문제1) emp 테이블을 사용하여 eno, ename, job, dno 컬럼과 업무가 SALESMAN인 데이터를 확인하는 v_emp 뷰를 생성하시오.

문제2) v_emp 뷰를 통해 데이터를 확인하고, 데이터 사전으로 확인하시오.

-- 문제점 확인
문제3) v_emp를 사용하여 SALESMAN의 부서번호를 40번으로 수정하시오.

-- 문제점 확인
문제4) v_emp를 사용하여 데이터를 추가하시오.
eno: 8000, ename: 김길동, dno: 30, job: SALESMAN

-- 문제점 확인
문제5) v_emp를 사용하여 사원명이 ALLEN인 사원의 정보를 삭제하시오.

*/
select table_name from user_tables;
select * from emp;

-- 문제1
create view v_emp as select eno, ename, job, dno from emp where job = 'SALESMAN';

-- 문제2
select * from v_emp;
select view_name, text from user_views;

-- 문제3
update v_emp
set dno = 40
where job = 'SALESMAN';
-- 문제점: 원본 테이블의 데이터도 같이 수정됨.
select * from v_emp;
select * from emp;

-- 문제4
insert into v_emp(eno, ename, job, dno) values(8000, '김길동', 'SALESMAN', 30);
-- 문제점: 원본 테이블에도 같이 추가됨.
select * from v_emp;
select * from emp;

-- 문제5
delete v_emp
where ename = 'ALLEN';
-- 문제점: 원본 테이블에서도 ALLEN이 삭제됨.
select * from v_emp;
select * from emp;

/*
    < 뷰의 사용에 대한 문제점과 해결책 1 번 >
    최종 문제점: 보안을 위해서 특정 컬럼, 특정 데이터만 확인할 수 있도록 뷰를 생성했지만,
               추가, 수정, 삭제 작업을 통해서 원본 테이블의 값도 변경하고 있다.
    
    해결책: 뷰를 생성할 때 뷰를 통해서 데이터의 추가, 수정, 삭제 작업을 할 수 없도록 설정한다. -> 읽기 전용으로 바꿈★
*/
rollback;

-- 뷰가 있다면 제거한 후 다시 생성하고, 없다면 생성
-- 읽기 전용 뷰 생성
create or replace view v_emp as select eno, ename, job, dno from emp
where job = 'SALESMAN' with read only;

select * from v_emp;
select * from emp;

-- 문제3
-- 에러: SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
update v_emp
set dno = 40
where job = 'SALESMAN';

-- 문제4
-- 에러: SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
insert into v_emp(eno, ename, job, dno) values(8000, '김길동', 'SALESMAN', 30);

-- 문제5
-- 에러: SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
delete v_emp
where ename = 'ALLEN';

/*
     < 뷰의 사용에 대한 문제점과 해결책 2 번 >
     문제점: 업무가 MANAGER인 데이터의 정보를 확인하는 뷰라면
            MANAGER인 사원의 데이터를 추가, 수정, 삭제하는 작업은 가능하게 하고,
            MANAGER가 아닌 사원의 데이터를 추가, 수정, 삭제하는 작업은 불가능하도록 설정
            
     해결책: 해당 뷰를 통해서 업무가 MANAGER인 사원의 데이터만 추가, 수정, 삭제하도록 함.
     
*/
create or replace view v_emp2 as select eno, ename, job, dno from emp
where job = 'MANAGER';

select * from v_emp2;
-- 생성된 view들 확인
select view_name, text from user_views;

-- 데이터 추가
insert into v_emp2 values(9000, 'KIM', 'SALESMAN', 30);
select * from v_emp2;
select * from emp;

-- 데이터 수정
update v_emp2
set job = 'SALESMAN'
where dno = 10;

select * from v_emp2;
select * from emp;

-- 데이터 삭제
delete v_emp2
where dno = 20;

select * from v_emp2;
select * from emp;

rollback;

-- 
create or replace view v_emp2 as select eno, ename, job, dno from emp
where job = 'MANAGER' with check option;

select * from v_emp2;
select * from emp;
select view_name, text from user_views;

-- [ 검증 작업 ]
-- 추가 작업 검증
-- 에러: SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
insert into v_emp2 values(9000, '김길동', 'SALESMAN', 30);
-- 성공
insert into v_emp2 values(9000, '김길동', 'MANAGER', 30);
select * from v_emp2;
select * from emp;

-- 수정 작업 검증
-- 에러: SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
update v_emp2
set job = 'SALESMAN'
where dno = 10;
-- 조건적이 다르므로 실행이 아예 안됨.
-- 0개 행 이(가) 업데이트되었습니다.
update v_emp2
set dno = 20
where job = 'SALESMAN';
-- 성공
update v_emp2
set dno = 40
where job = 'MANAGER';

select * from v_emp2;
select * from emp;


-- 삭제 작업 검증
-- 0개 행 이(가) 삭제되었습니다.
delete v_emp2
where job = 'SALESMAN';

-- 3개 행 이(가) 삭제되었습니다.
delete v_emp2
where job = 'MANAGER';

rollback;

-- 주의점: 삭제시에는 조건에 대한 검증이 되지 않음.
-- 1개 행 이(가) 삭제되었습니다.
delete v_emp2
where dno = 10;

-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
create or replace view v_notable as select eno, ename, job, dno from emp20;

-- 경고: 컴파일 오류와 함께 뷰가 생성되었습니다.
create or replace force view v_notable as select eno, ename, job, dno from emp20;

select * from v_notable;
desc v_notable;
select * from user_views;

-- 뷰 제거
drop view v_notable;

rollback;
drop table emp;
create table emp as select * from employee;
select * from emp;

-- 함수와 여러개의 컬럼을 활용해서 만든 가상컬럼이 있는 뷰
create or replace view v_emp1(사번, 사원명, 업무, 연봉, 성과급, 총연봉)
as select eno, ename, job, salary, nvl(commission, 0), salary+nvl(commission, 0) from emp;

select * from v_emp1;
desc v_emp1;

-- SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다
-- 함수와 여러개의 컬럼으로 만들어 낸 컬럼에 값을 추가하거나 변경할 수는 없다.
insert into v_emp1 values(9000, 'KIM', 'SALESMAN', 4500, 500, 6000);

-- 각 부서별 총급여와 평균급여를 구하는 v_salary뷰를 생서하시오.
create or replace view v_salary
as select dno 부서, sum(salary) 총급여, trunc(avg(salary), 2) 평균급여
from emp group by dno order by dno;

select * from v_salary;
desc v_salary;

-- SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다
insert into v_salary values(40, 15000, 5000);

/*
< 뷰 확인 학습 문제 >
문제1) emp 테이블로부터 입사년이 1981년인 사원의 사번, 사원명, 업무, 입사일, 연봉을 확인하는 뷰를 생성하시오.
- 뷰 이름: v_hiredate로 하시오.
- 뷰를 사용하여 조건에 해당하는 데이터만 추가, 수정이 가능하도록 옵션을 설정하시오.
- 뷰에 대해서 추가, 수정 조건을 검증하시오.
*/
-- 현재 생성된 뷰들 확인
select view_name from user_views;

--
create or replace view v_hiredate(사번, 사원명, 업무, 입사일, 연봉)
as eno, ename, job, hiredate, salary from emp
where substr(hiredate, 4, 2) = 

