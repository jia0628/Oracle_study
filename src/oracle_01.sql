-- 한 줄 주석
/*
여러 줄 주석
< sql developer를 사용할 때 주의점 >
    1. 자동 저장을 지원하지 않으므로, 수시로 저장을 할 것.
    2. 이전 내용의 에러가 있으면, 다음 내용이 실행되지 않음.
    3. sql developer로 느려지고, 중단되는 경우가 자주 발생함.
*/

/*
< 테이블명을 정하는 규칙 >
    > 중요: 자바의 클래스와 매핑됨.
    1. 영문자, 한글, 숫자, 특수기호(_, $, #) 사용 가능
    2. 숫자는 첫글자로는 사용 불가
    3. 공백은 사용 불가
    4. 키워드(예약어) 사용 불가
    5. 같은 계정에서는 같은 이름의 테이블명은 사용 불가
    6. 30Byte까지 사용 가능, (영어는 30글자, 한글은 10글자(express 버전))
    7. 권장 사항
        - 한글은 사용하지 않을 것을 권장
        - 특수기호는 _(언더바)만 사용할 것을 권장, ($,#)은 시스템에서 사용하기 때문
        - 테이블명은 명사형으로 사용할 것을 권장

< 컬럼명을 정하는 규칙 >
    > 자바 클래스의 멤버변수명과 매핑됨.
    1. 영문자, 한글, 숫자, 특수기호(_, $, #) 사용 가능
    2. 공백은 사용 불가
    3. 키워드(예약어)는 사용 불가
    4. 30Byte까지 사용 가능, (영어는 30글자, 한글은 10글자(express 버전))
    5. 한 테이블에서 같은 이름의 컬럼명은 사용 불가
    6. 컬럼명의 대소문자 구분이 없음(컬럼명이 출력될 때는 모두 대문자로 출력)
       소문자 컬럼명으로 지정하려면 ''(홀따옴표)로 묶어서 지정
    7. 권장 사항
        - 한글은 사용하지 않을 것을 권장
        - 특수기호는 _(언더바)만 사용할 것을 권장, ($,#)은 시스템에서 사용하기 때문
        - 컬럼명은 명사형으로 명확하게 만들 것을 권장
        - 숫자는 컬럼의 첫 글자로 사용은 가능하지만, 사용하지 않을 것을 권장

< DDL > Data Defintione Language(데이터 정의어)
    1. create table: 테이블 생성
    2. alter table: 테이블 구조 변경 (데이터 수정X)
    3. drop table: 테이블 제거

###############################################################################
< 테이블 생성하는 방법 >
    1. 직접 생성하는 방법
    create table 테이블명 (
    컬럼명 타입,
    컬럼명 타입,
    컬럼명 타입
    );
    
    # 테이블 복제는 제약조건은 복사되지 않음.
    create table 테이블명 as 서브쿼리;
    
    2. 테이블 복제 1번
    - 원본 테이블의 구조와 내용을 모두 복사함.
    - 제약조건은 복사되지 않음.
    ex) create table dept2 as (select * from department);
    
    3. 테이블 복제 2번
    - 원본 테이블에서 특정 컬럼만 복사함.
    ex) create table emp as (select eno, ename, job, salary from employee); 
    
    4. 테이블 복제 3번
    - 원본 테이블에서 특정 컬럼을 사용자가 원하는 이름으로 변경하여 복사함.
    ex) create table emp2 as(select eno e_no, ename e_name, salary sal, commission comm from employee);
    
    5. 테이블 복제 4번
    - 원본 테이블에서 새로운 컬럼을 생성하여 복사함.
    ex) create table emp3 as (select eno, ename, salary, nvl(commission, 0) comm, salary+nvl(commission, 0) t_salary from employee);
    
    6. 테이블 복제 5번
    - 원본 테이블에서 조건식을 사용하여 특정 데이터만 복사함.
    ex) create table emp4 as (select * from employee where salary between 2000 and 3000);

    7. 테이블 복제 6번
    - 원본 테이블에서 데이터는 복사하지 않고 테이블의 구조만 복사함.
    ex) create table emp8 as (select * from employee where 0 = 1);
*/

-- 1. 직접 생성
create table dept (
dno number(2),
dname varchar2(14),
loc varchar2(13)
);

-- 테이블의 내용 확인
select * from dept;

-- 테이블의 구조 확인
desc dept;

-- 2. 테이블 복제 1 -> 모든 구조와 내용을 복사
create table dept2 as (select * from department);

select * from dept2;
desc dept2;

-- 3. 테이블 복제 2 -> 특정 컬럼을 복사
create table emp as (select eno, ename, job, salary from employee);

select * from emp;
desc emp;

-- 4. 테이블 복제 3 -> 특정 컬럼을 사용자가 원하는 컬럼명으로 변경하여 복사
create table emp2 as(select eno e_no, ename e_name, salary sal, commission comm from employee);

select * from emp2;
desc emp2;

-- 5. 테이블 복제 4 -> 원본 테이블에서 새로운 컬럼을 생성하여 복사
create table emp3 as (select eno, ename, salary, nvl(commission, 0) comm, salary+nvl(commission, 0) t_salary from employee);

select * from emp3;
desc emp3;

-- 6. 테이블 복제 5 -> 원본 테이블에서 조건식을 사용하여 특정 데이터만 복사
-- 연봉이 2000에서 3000(포함)사이의 데이터만 복사
create table emp4 as (select * from employee where salary between 2000 and 3000);

select * from emp4;
desc emp4;

-- 문제1) employee 테이블에서 사번, 사원명, 업무, 입사일, 부서번호 컬럼을
-- 10번, 20번 부서의 데이터만 복사하여 emp5 테이블로 복제하시오.
create table emp5 as (select eno, ename, job, hiredate, dno from employee where dno in(10, 20));

select * from emp5 order by dno;
desc emp5;

-- 문제2) 사번, 사원명, 업무, 부서번호, 부서명, 지역명 컬럼을 가진 emp6 테이블을 복제하여 생성하시오.
create table emp7 as (select eno, ename, job, e.dno, dname, loc from employee e, department d where e.dno = d.dno);

select * from emp7;
desc emp7;

-- 7. 테이블 복제 6번 -> 원본 테이블에서 데이터는 복사하지 않고 테이블의 구조만 복사함.
create table emp8 as (select * from employee where 0 = 1);

select * from emp8;
desc emp8;

/*
데이터 사전 (data dictionary)
- 사용자와 데이터베이스의 자원을 효율적으로 사용하고 관리하기 위해서 다양한 정보를 저장한 시스템 테이블의 집합
- 사용자가 데이터 사전을 직접 수정하거나 삭제할 수 없고, 확인만 가능
- ★오라클에서만 제공하는 기능

<데이터 사전의 종료>
    1. USER_***: 사용자가 소유한 객체에 대한 정보
    2. ALL_***: 사용자와 사용자에게 권한을 부여한 객체에 대한 정보
    3. DBA_***: DBA만 접근 가능한 객체에 대한 정보
    4. V$_***: DB 성능에 대한 정보
    
    1) user_***
    - 사용자가 생성한 테이블, 뷰, 인덱스 등의 객체에 관한 정보
    ex) user_tables: 사용자가 생성한 테이블에 관한 정보
    
    2) all_***
    - 사용자와 사용자 접근할 수 있도록 권한을 부여받은 테이블, 뷰 인덱스 등의 객체에 관한 정보
    ex) all_tables: 사용자가 생성한 테이블과 사용자가 권한을 부여받은 테이블에 관한 정보
    
    3) dba_***
    - DB 관리자 또는 시스템 관리자만 접근할 수 있는 객체에 관한 정보
    ex) dba_table: 관리자만 접근 가능한 테이블에 관한 정보
*/

-- user_tables: 사용자가 생성한 테이블에 관한 모든 정보
select * from user_tables; -- 정식 명령어, 권장
select * from tabs;        -- 약식 명령어
select table_name from user_tables;
-- status: VALID(사용가능), INVALID(사용불가능)
select table_name, status from user_tables;

-- all_tables
select * from all_tables;
select count(*) from all_tables;

-- dba_tables
select * from dba_tables;
select count(*) from dba_tables;

-- 테이블 제거
drop table dept2;
select table_name from user_tables; -- 테이블 확인

-- 테이블 복제
create table emp as select * from employee;
create table dept as select * from department;

select table_name from user_tables;

select * from emp;
desc emp;
select * from dept;
desc dept;

/*
< 테이블 구조 변경 >
- alter table 테이블명 ~

1. 컬럼 추가 < add >
    - emp 테이블에 date 타입의 birthday 컬럼을 추가
    alter table emp add(birthday date);

2. 컬럼 길이 변경 < modify >
    - emp 테이블에서 ename 컬럼의 길이를 varchar2(20)으로 변경 -> 길이를 크게 하는 것은 가능
    alter table emp modify(ename varchar2(20));

    - emp 테이블에서 ename 컬럼의 길이를 varchar2(5)로 변경
    -> 길이를 작게 하는 것은 저장된 데이터의 길이보다 크거나 같다면 가능, 데이터의 길이보다 작다면 불가능
    alter table emp modify(ename varchar2(5));

3. 컬럼명 변경 < rename column >
    alter table emp rename column birthday to birth;

4. 컬럼 삭제 < drop column >
    - 데이터가 있는 컬럼 삭제할 때는 컬럼의 데이터도 모두 삭제되므로 주의할 것!
    alter table emp drop column birth;

5. 컬럼을 사용불가로 설정 - 주의
    - 컬럼을 사용불가로 설정하면 사용가능 상태로 되돌릴수가 없음.
    - 삭제할 것을 전제로 사용하는 명령.
    - ex) commission 컬럼을 삭제할 생각인데, 낮에는 사용자가 많아서 컬럼의 삭제가 어려움.
    - unused로 사용불가 설정만 해두고, 사용자가 적은 밤에 unused로 표시해둔 컬럼을 삭제하기 위해서 사용함.
    alter table emp set unused(commission);
    
6. 사용불가로 설정된 컬럼을 삭제
    alter table emp drop unused columns;

< 테이블명 변경 >
rename 원본 테이블명 to 변경 테이블명; 

< 테이블의 데이터를 잘라내는 명령 >
- 데이터가 저장되어 있는 메모리의 공간도 삭제함.
truncate table 테이블명;

< 테이블 제거 명령 >
drop table 테이블명;

*/

-- 컬럼 추가
alter table emp add(birthday date);
select * from emp;
desc emp;

-- 컬럼 길이 변경 -> 길이를 크게 하는 것은 가능
alter table emp modify(ename varchar2(20));
desc emp;

-- 컬럼 길이 변경 -> 길이를 작게 하는 것은 저장된 데이터의 길이보다 크거나 같다면 가능, 데이터의 길이보다 작다면 불가능
alter table emp modify(ename varchar2(8));
desc emp;

-- ORA-01441: 일부 값이 너무 커서 열 길이를 줄일 수 없음
-- 01441. 00000 -  "cannot decrease column length because some value is too big"
alter table emp modify(ename varchar2(5));

-- 컬럼명 변경
alter table emp rename column birthday to birth;
desc emp;

-- 컬럼 삭제: 데이터가 없는 컬럼
alter table emp drop column birth;
desc emp;

-- 컬럼 삭제: 데이터가 있는 컬럼
alter table emp drop column commission;
select * from emp;
desc emp;

-- 테이블명 변경
rename emp to emp2;

select * from emp2;

-- 테이블에서 데이터를 잘라내는 명령
truncate table emp2;
select * from emp2;
desc emp2;

-- 테이블 제거 명령
drop table emp2;
select * from emp2;
desc emp2;
 
create table emp as select * from employee;
select * from emp;
desc emp;

-- commisssion 컬럼을 사용불가 상태로 설정
alter table emp set unused(commission);
select * from emp;
desc emp;

-- unused 컬럼 삭제
alter table emp drop unused columns;


/*
< DDL 정리 >
    - 테이블을 생성, 변경, 제거하는 명령
    - 제약조건을 부분을 빼고 기본 문법을 익힘.
    create table, alter table, drop table, truncate table, rename

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
    - not null인 컬럼은 생략할 수 없음.
    insert into dept(dno, dname) values(20, '연구팀');
    

*/
drop table emp;
drop table dept;
create table emp as select * from employee where 0 = 1;
create table dept as select * from department where 0 = 1;

select * from emp;
desc emp;
select * from dept;
desc dept;

-- 추가 1번 방법
insert into dept(dno, dname, loc) values(10, '회계팀', '과천');
-- ★ commit: 오라클 터미널에 삽입하겠다 (툴에서 auto commit이 false 상태)
commit; 
select * from dept;

-- 추가 2-1번 방법 
insert into dept(dno, dname) values(20, '연구팀');
commit;
select * from dept;

-- 추가 2-2번 방법 : null을 명시적으로 표시
insert into dept(dno, dname, loc) values(30, '영업팀', null);
commit;
select * from dept;





