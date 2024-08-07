-- hm 계정

-- 사용자 계정 확인 (DBA만 사용 가능)
select * from dba_users;

-- 세션 연결 (관리자 명령 전에 사용)
alter session set "_ORACLE_SCRIPT" = true;

-- 사용자 계정 제거 (DBA만 가능)
drop user user01 cascade;

-- 사용자 계정 생성
create user user01 identified by 1234;
create user user02 identified by 1234;
create user user03 identified by 1234;

-- 권한 부여
grant create session, create table to user01;
grant create session to user02;
grant create session to user03;

-- 테이블스페이스 사용 설정
alter user user01 default tablespace users quota unlimited on users;
alter user user02 default tablespace users quota unlimited on users;
alter user user03 default tablespace users quota unlimited on users;

-- 사용자 계정 확인
select * from dba_users;
select * from dba_users where username in ('HM01', 'USER01', 'USER02', 'USER03');


-- DBA로부터 부여받은 권한 확인
select * from session_privs;

-- 사용자가 부여한 권한, 사용자가 부여받은 권한
select * from user_tab_prive;

-- 사용자가 부여한 권한, 사용자가 부여받은 권한 확인
select * from user_tab_privs;

-- 롤 권한 확인
-- ADMIN_OPTION 컬럼 : NO(부여받은 롤 권한), YES(생성한 롤 권한)
select * from user_role_privs;

-- 상세한 롤 권한 확인
select * from role_tab_privs;
select * from role_tab_privs where role = 'ROLE_TEST01';


-- [ 롤 생성과 권한 부여 순서 ]
-- DBA(관리자)만 사용 가능
alter session set "_ORACLE_SCRIPT" = true;

-- 1. 롤 생성
create role role_test01;

-- 2. 롤에 권한 부여
grant select, insert on hm01.emp to role_test01;
grant select, update on hm01.dept to role_test01;
grant select, delete on hm01.grade to role_test01;

-- 3. 사용자에게 롤 권한을 부여
grant role_test01 to user01;

-- 4. 롤 권한 제거
drop role role_test01;

/*
    < Synonym (동의어, 시노님) >
    - 데이터베이스 객체에 대한 별칭
    - 부여받은 권한을 사용할 때는 '원본계정명.테이블명'으로 사용하는 것이 불편, 이 이름을 간단한 별칭으로 사용하는 것.
    
    < 동의어의 종류 >
    1. 전용 동의어 (private synonym)
    - 사용자가 생성하여 사용하는 동의어
    - 객체에 대한 권한을 부여받은 사용자가 정의하여 사용함, 정의한 사용자만 사용함
    - create synonym 권한이 있어야 함.
    
    2. 공용 동의어 (public synonym)
    - 전체 사용자가 사용할 수 있는 동의어
    - 권한을 부여하는 사용자가 생성하는 동의어
    - 오직 DBA 권한을 가진 사용자만 생성 가능
    - public을 붙여서 생성함.
    
*/

-- synonym 생성 권한 부여
grant create synonym to user01;

-- 권한 부여
grant select on emp to user01;

-- 공용 동의어 생성
create public synonym d2 for dept;

-- 권한 부여
grant select on dept to public;

-- 공용 동의어 확인
select * from all_synonyms;
select * from all_synonyms where synonym_name in ('D2');

-- 공용 동의어 삭제
drop public synonym d2;

-- 사용자 계정 삭제
drop user user01;
drop user user02;
drop user user03;

/*
    < PL/SQL >
    - Procedural Language SQL
    - SQL 만으로 구현하기 어려운 작업을 처리하기 위해 SQL에서 사용하는 절차지향 프로그래밍 언어(객체지향 X)
    - 변수, 조건문, 반복문, 예외처리 등의 다양한 프로그래밍 방법으로 SQL문을 실행할 수 있음.
    
    < PL/SQL의 장점 >
    - 변수, 상수 등을 사용할 수 있음.
    - 조건에 따른 조건문을 사용할 수 있음.
    - 반복문을 통해 반복하는 SQL문을 처리할 수 있음.
    - 예외처리를 통해 예외상황을 처리할 수 있음.
    
    < PL/SQL의 형식 >
    declare    // 선언부 - 변수 또는 상수를 선언. (선택)
    begin      // 실행부 - 조건문, 반복문, 함수 정의, 출력, 값 할당, SQL 사용 등의 프로그래밍 내용을 작성. (필수)
    exception  // 예외처리부 - 실행부에서 예외가 발생했을 때 처리. (선택)
    end;       // PL/SQL의 끝 (필수)
    /          // 실행 (필수)
    
    < PL/SQL의 규칙 >
    - 실행문 뒤에는 반드시 ;(세미콜론)을 사용함
    - PL/SQL문의 끝에는 end;을 사용함
    - PL/SQL문을 실행할 때는 /을 사용해야 함
    - 출력할 때는 dbms_output.put_line() 함수를 사용함.
    - 실행 결과를 화면으로 출력할 때는 set.serveroutput on; 명령을 실행해야 함. (최초 1번만)
    - --(단일 행 주석), 여러 행 주석도 사용 가능
    
    < PL/SQL의 변수 명명법 >
    - 영어, 한글, 숫자, 기호($, #, _) 사용 가능
    - 숫자 첫글자로는 사용 불가
    - 공백 사용 불가
    - 예약어 사용 불가
    - 영어 대소문자 구분하지 않음
    - 30Byte까지 사용 가능
    # 권장: 한글 사용하지 않음, 기호는 _만 사용함, 변수명 앞에는 v_를 붙여서 명명함. 
    # 상수를 선언할 때는 constant 키워드를 사용함.
    
    < PL/SQL 연산자 >
    - 기본적으로는 SQL 연산자 사용법을 따름.
    - 대입할 때는 :=(할당 연산자)을 사용
    
    < PL/SQL 변수의 타입 > ★
    1. 스칼라 타입(scalar type)
    - PL/SQL 안에서 직접 선언하는 데이터 타입
    - number(자리수), number(전체자리수, 소수점자리수), varchar2(자리수), date, boolean(논리형, 추가됨)
    
    2. 래퍼런스 타입(reference type)
    - 기존 테이블의 변수 타입을 참조하는 데이터 타입
    - 1) 컬럼 1개 참조
       - 테이블명.컬럼명%type
       ex) v_dno dept.dno%type;
    - 2) 테이블의 컬럼 전체 참조 (rowtype 방법)
       - 테이블명%rowtype
       ex) v_dept dept%rowtype;
    
    
*/

-- 문제1) 'Welcome to PL/SQL'을 출력하시오.
-- PL/SQL을 사용할 때 맨 처음 한번 아래의 명령을 실행해야 함.
--  dbms_output.put_line()을 실행하기 위한 명령.
set serveroutput on;

begin
    dbms_output.put_line('Welcome to PL/SQL');
end;
/

-- 문제2) 사번이 7788이고, 사원명이 SCOTT인 사원의 사번과 사원명을 출력하시오.
declare
    -- 변수 선언 자리
    -- ◈꼭 v를 붙여야하는건 아님(관습적인 표현)
    v_eno number(4) := 7788;  -- 초기화도 함께
    v_ename varchar2(10);
begin
    -- 변수에 값을 대입
    v_ename := 'SCOTT';
    dbms_output.put_line('사번: ' || v_eno || ', 사원명: ' || v_ename);  -- ◈||는 +라고 생각

end;
/

-- 문제3) SCOTT 사원의 연봉이 3000이고, 세금 10%를 공제한 실질 연봉을 출력하시오.
-- 스칼라 타입 변수 사용
-- 변수: v_ename: 문자10자리, v_salary(연봉): 전체7자리, 소수점2자리, v_salary2(실질연봉): 전체7자리, 소수점2자리
-- 상수: v_tax: 전체 4자리, 소수점2자리
-- 출력화면: SCOTT 사원의 실질 연봉: 2700

-- 상수도 선언하고 바로 초기화 해야한다.
declare
    v_tax constant number(4, 2) := 0.1;
    v_ename varchar2(10) := 'SCOTT';
    v_salary number(7, 2) := 3000;
    v_salary2 number(7, 2);
begin
    -- ◈상수는 다른 값으로 바꿀 수 없다.
    -- v_tax := 0.2;
    v_salary2 := v_salary - v_salary * v_tax;
    dbms_output.put_line(v_ename || ' 사원의 실질 연봉: ' || v_salary2);
end;
/

drop table emp;
drop table dept;
drop table grade;
create table emp as select * from employee;
create table dept as select * from department;


-- not null, default 사용
-- 문제4) 10번 부서의 부서명인 영업부를 출력하시오.
-- not null은 선언하고 바로 값을 초기화 해야한다.
-- default 값의 사용
declare
    v_dno number(2) not null := 10;
    v_dname varchar2(10) default '영업부';
begin
    -- ORA-06550: 줄 2, 열11:PLS-00218: NOT NULL로 정의된 변수는 초기치를 할당하여야 합니다
    -- v_dno := 10;
    -- ◈not null은 값의 변경은 가능하다.
    -- v_dno := 40;
    dbms_output.put_line(v_dname || ' 부서의 부서번호: ' || v_dno);
end;
/

-- 문제5) 30번 부서에서 부서번호, 부서명, 지역명을 dept 테이블을 사용하여 출력하시오.
-- 5-1) 스칼라 변수 사용
declare
    v_dno number(2);
    v_dname varchar2(10);
    v_loc varchar2(9);
begin
    -- SQL문 사용
    -- into를 사용하여 테이블로부터 연이은 할당값을 변수에 대입
    select dno, dname, loc into v_dno, v_dname, v_loc
    from dept
    where dno = 30;
    
   dbms_output.put_line(v_dno || ' | ' || v_dname || ' | ' || v_loc);
end;
/

-- 5-2) 래퍼런스 변수 사용
declare
    v_dno dept.dno%type;
    v_dname dept.dname%type;
    v_loc dept.loc%type;
begin
    select dno, dname, loc into v_dno, v_dname, v_loc
    from dept
    where dno = 30;
    dbms_output.put_line(v_dno || ' | ' || v_dname || ' | ' || v_loc);
end;
/

-- 5-3) 래퍼런스 변수 사용 (rowtype)
declare
    -- dept 테이블의 전체 컬럼의 정보를 가지고 온다
    v_dept dept%rowtype;
begin
    select dno, dname, loc into v_dept.dno, v_dept.dname, v_dept.loc
    from dept
    where dno = 30;
    dbms_output.put_line(v_dept.dno || ' | ' || v_dept.dname || ' | ' || v_dept.loc);
end;
/

-- 문제6) emp 테이블에서 ALLEN 사원의 사번, 사원명, 연봉, 성과급, 총연봉을 출력하시오.
-- v_tot: 총연봉

-- 6-1) 스칼라 타입
declare
    v_eno number(4);
    v_ename varchar2(10);
    v_salary number(7, 2);
    v_commission number(7, 2);
    v_tot number(7, 2);
begin
    -- 1번 방법
--    select eno, ename, salary, commission, salary + nvl(commission, 0) into v_eno, v_ename, v_salary, v_commission, v_tot
--    from emp
--    where ename = 'ALLEN';
    
    -- 2번 방법
    select eno, ename, salary, commission into v_eno, v_ename, v_salary, v_commission
    from emp
    where ename = 'ALLEN';
    
    v_tot := v_salary + nvl(v_commission, 0);
    dbms_output.put_line(v_eno || '(사번) | '|| v_ename || '(사원명) | ' || v_salary || '(연봉) | ' || v_commission || '(성과급) | ' || v_tot || '(총연봉)');
end;
/

-- 6-2) 래퍼런스 타입(각 컬럼별)
declare
    v_eno emp.eno%type;
    v_ename emp.ename%type;
    v_salary emp.salary%type;
    v_commission emp.commission%type;
    v_tot emp.salary%type;
begin
    select eno, ename, salary, commission, salary + commission into v_eno, v_ename, v_salary, v_commission, v_tot
    from emp
    where ename = 'ALLEN';
    
    dbms_output.put_line(v_eno || '(사번) | '|| v_ename || '(사원명) | ' || v_salary || '(연봉) | ' || v_commission || '(성과급) | ' || v_tot || '(총연봉)');
end;
/

-- 6-3) 래퍼런스 타입(rowtype)
declare
   v_emp emp%rowtype;
   v_tot emp.salary%type;
begin
    select eno, ename, salary, commission into v_emp.eno, v_emp.ename, v_emp.salary, v_emp.commission
    from emp
    where ename = 'ALLEN';
    
    v_tot := v_emp.salary + v_emp.commission;
    
    dbms_output.put_line(v_emp.eno || '(사번) | '|| v_emp.ename || '(사원명) | ' || v_emp.salary || '(연봉) | ' || v_emp.commission || '(성과급) | ' || v_tot || '(총연봉)');
end;
/

/*
    < 조건문 >
    1. if문
        1-1. 조건 1개
        ->  if 조건식 then
                실행문;
            and if;
        
        1-2. 조건 2개
        ->  if 조건식 then
                실행문;
            else
                실행문;
            end if;
        
        1-3. 조건 3개 이상
        ->  if 조건식 then
                실행문;
            elsif 조건식 then
                실행문;
            else
                실행문;
            end if;
    
    2. case문
        case
            when 조건식 then 실행문;
            when 조건식 then 실행문;
            when 조건식 then 실행문;
            when 조건식 then 실행문;
            else;
        end case;
    
*/

-- 문제1) 주어진 변수가 양수인지 음수인지 0인지를 판별하시오.
-- &변수명: 값을 입력할 수 있는 대화상자를 띄어줌.

-- if문 
declare
--    v_num number := 10;
    v_num number;
    v_result varchar2(10);
begin
    -- &변수명
    v_num := &input;
    -- if문
    if v_num > 0 then
        v_result := '양수';
    elsif v_num < 0 then
        v_result := '음수';
    else
        v_result := 0;
    end if;
    
    dbms_output.put_line(v_num || '은 ' || v_result || '입니다');
end;
/

-- case문
declare
--    v_num number := 10;
    v_num number;
    v_result varchar2(10);
begin
    -- &변수명
    v_num := &input;
   -- case문
   case
        when v_num > 0 then v_result := '양수';
        when v_num < 0 then v_result := '음수';
        else v_result := 0;
    end case;
    
    dbms_output.put_line(v_num || '은 ' || v_result || '입니다');
end;
/

-- 문제2) 국어, 영어, 수학 점수를 입력하여 총점, 평균, 학점을 출력하시오.
-- v_kor, v_eng, v_mat, v_tot, v_ave, v_grd
-- 학점계산 부분은 조건문으로 처리(if문, case문)
-- 학점은 평균이 90점 이상이면 A, 80점 이상이면 B, 70점 이상이면 C, 60점 이상이면 D, 60점 미만이면 F
-- 입력: 92, 92, 91
-- 출력화면 설계:
-- 총점: 275, 평균: 91.66, 학점: A

-- if문
declare
    v_kor number(3);
    v_eng number(3);
    v_mat number(3);
    v_tot number(3);
    v_ave number(7, 4);
    v_grd char(1);
begin
    -- 입력 받기
    v_kor := &input;
    v_eng := &input;
    v_mat := &input;
    
    v_tot := v_kor + v_eng + v_mat;
    v_ave := v_tot / 3;
    
    if v_ave >= 90 then v_grd := 'A';
    elsif v_ave >= 80 then v_grd := 'B';
    elsif v_ave >= 70 then v_grd := 'C';
    elsif v_ave >= 60 then v_grd := 'D';
    else v_grd := 'F';
    end if;
    
    dbms_output.put_line('총점: ' || v_tot || ' 평균: ' || trunc(v_ave, 2) || ' 학점: ' || v_grd);
end;
/

 -- case문
declare
    v_kor number(3);
    v_eng number(3);
    v_mat number(3);
    v_tot number(3);
    v_ave number(7, 4);
    v_grd char(1);
begin
    -- 입력 받기
    v_kor := &input;
    v_eng := &input;
    v_mat := &input;

    v_tot := v_kor + v_eng + v_mat;
    v_ave := v_tot / 3;
    
    case
        when v_ave >= 90 then v_grd := 'A';
        when v_ave >= 80 then v_grd := 'B';
        when v_ave >= 70 then v_grd := 'C';
        when v_ave >= 60 then v_grd := 'D';
        else v_grd := 'F';
    end case;
    
    dbms_output.put_line('총점: ' || v_tot || ' 평균: ' || trunc(v_ave, 2) || ' 학점: ' || v_grd);
end;
/

/*
    < 반복문 >
    1. 기본 loop문
    ->  loop
            실행문;
            증감값;
            탈출조건;
        end loop;
    
    2. while문
    - 프로그래밍의 whle문의 사용법이 동일
    ->  while 조건식 loop
            실행문;
            증감값;
        end loop;
    
    3. for문
    -- 시작값부터 끝값(포함)까지 무조건 1씩만 증가하면서 반복
    -- i는 제어변수(인덱스)
    -- for문은 1씩 증가하면서 모든 요소를 순회하는 것을 전제로 하며 사용함.
    -- reverse: 거꾸로 출력, 끝값부터 시작값까지 1씩 감소하면서 반복함.
    ->  for i in 시작값..끝값 loop
            
        end loop;

*/

-- 문제1) 1부터 10까지 1씩 증가하는 값을 출력하시오.

-- 1번 - 기본 loop문
declare
    v_num number := 1;   -- 초기값
begin
    loop
        dbms_output.put_line(v_num);
        v_num := v_num + 1;    -- 증감값
        -- 탈출조건(if문)
        -- if v_num > 10 then exit;  
        -- end if;
        exit when v_num > 10;
    end loop;
end;
/

-- 2번 - while문
declare
    v_num number := 1;  -- 초기값
begin
    -- 반복문을 도는 조건
    while v_num <= 10 loop
        dbms_output.put_line(v_num);
        v_num := v_num + 1;
    end loop;
end;
/

-- 3번 - for문
begin
    for i in 1..10 loop
        dbms_output.put_line(i);
    end loop;
end;
/

-- 거꾸로 출력
begin
    for i in reverse 1..10 loop
        dbms_output.put_line(i);
    end loop;
end;
/

-- 문제2) 입력한 수까지의 3의 배수를 출력하고, 개수와 합계를 출력하시오.
-- 3가지 반복문으로 처리하시오.
-- 변수명: v_num, v_cnt, v_sum
-- 나머지 함수: mod()
-- 입력값: 10
-- 출력화면 설계:
-- 3 6 9
-- 1부터 10까지의 3의 배수의 합계: 16, 개수: 3

-- 1번 loop문
declare
    v_num number;
    v_cnt number;
    v_sum number;
begin
    v_num := &input;
    loop
        dbms_output.put_line(v_num);
        dbms_output.put_line('1부터 ' || v_num || ' 까지의 3의 배수의 합계: ' || v_sum || ', 개수: ' || v_cnt);
        v_num := v_num + 1; -- 증감값
        if mod(v_num, 3) = 0 then exit; -- 탈출조건
        end if;
    end loop;
end;
/

-- 2번 while문
declare
    v_num number;
    v_cnt number;
    v_sum number;
begin
    v_num := &input;
   while mod(v_num, 3) = 0 loop
        dbms_output.put_line(v_num);
        v_num := v_num + 1;
    end loop;
end;
/

--3 번 for문
declare
    v_num number;
    v_cnt number;
    v_sum number;
begin
    v_num := &input;
    for i in 1..10 loop
        dbms_output.put_line(v_num);
    end loop;
end;
/


-- 문제3) 입력한 수까지의 3의 배수이면서 4의 배수를 출력하고, 합계와 개수를 출력하시오.
-- 3가지 반복문으로 처리하시오.
-- 변수명: v_num, v_cnt, v_sum
-- 나머지 함수: mod()
-- 입력값: 10
-- 출력화면 설계:
-- 12 24 36 48 60 72 84 96
-- 1부터 100까지의 3의 배수이면서 4의 배수의 합계: 432, 개수: 8


-- 문제4) 입력한 수까지 중에서 3의 배수를 제외한 수를 출력하고, 합계와 개수를 출력하시오.
-- 3가지 반복문으로 처리하시오.
-- 변수명: v_num, v_cnt, v_sum
-- 나머지 함수: mod()
-- 입력값: 10
-- 출력화면 설계:
-- 1 2 4 5 7 8 10
-- 1부터 10까지의 3의 배수를 제외한 수의 합계: 37, 개수: 7
