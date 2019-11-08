SET SERVEROUTPUT ON;
CREATE OR REPLACE DIRECTORY dir_new1 AS 'D:\NEW';

CREATE OR REPLACE PACKAGE employee_management IS

-------------EX1-----------
  PROCEDURE add_employee
    (nume IN EMP.ENAME%TYPE, salary IN EMP.SAL%TYPE, job1 EMP.JOB%TYPE, boss_id EMP.EMPNO%TYPE);
-------------EX2-----------
  PROCEDURE remove_employee
    (nume IN EMP.ENAME%TYPE);
    
  PROCEDURE remove_employee
    (id_angajat IN EMP.EMPNO%TYPE); 
-------------EX3-----------    
  PROCEDURE add_dept
    (dname1 DEPT.DNAME%TYPE, dloc1 DEPT.LOC%TYPE);
-------------EX4-----------
    PROCEDURE DISPLAY_t
    (output VARCHAR2);
    
END employee_management;
/

CREATE OR REPLACE PACKAGE BODY employee_management IS

-------------EX1-----------

  PROCEDURE add_employee
        (nume IN EMP.ENAME%TYPE, salary IN EMP.SAL%TYPE, job1 EMP.JOB%TYPE, boss_id EMP.EMPNO%TYPE) IS
        unique_id EMP.EMPNO%TYPE;
        min_emp_nmb INTEGER:=-1;
        min_emp_nmb_tmp INTEGER:=-1;
        departamentt EMP.DEPTNO%TYPE:=0;
        boss_id_temp EMP.EMPNO%TYPE:=0;
        exceptie EXCEPTION;
      BEGIN
        SELECT MAX(EMPNO)+1 INTO unique_id FROM EMP;
        SELECT MIN(COUNT(EMPNO)) INTO min_emp_nmb FROM EMP WHERE EMP.JOB=job1 GROUP BY DEPTNO;
        IF (min_emp_nmb IS NULL) THEN 
          SELECT MIN(COUNT(EMPNO)) INTO min_emp_nmb FROM EMP GROUP BY DEPTNO; 
          SELECT DEPTNO INTO departamentt FROM DEPT WHERE DEPTNO NOT IN (SELECT DEPTNO FROM EMP) AND ROWNUM=1;
           IF(departamentt IS NULL) THEN          
            FOR deptTemp IN (SELECT UNIQUE DEPTNO FROM EMP) LOOP
              SELECT COUNT(*) INTO min_emp_nmb_tmp FROM EMP WHERE EMP.DEPTNO = deptTemp.DEPTNO;          
              IF(min_emp_nmb_tmp=min_emp_nmb) THEN
                departamenTt:=deptTemp.DEPTNO;
                EXIT;
              END IF;
            END LOOP;
          END IF;  
        ELSE
            FOR deptTemp IN (SELECT DEPTNO FROM DEPT) LOOP
                min_emp_nmb_tmp:=-1;
                SELECT COUNT(*) INTO min_emp_nmb_tmp FROM EMP WHERE EMP.JOB=job1 AND EMP.DEPTNO=deptTemp.DEPTNO;
                IF min_emp_nmb_tmp IS NULL THEN
                  departamentt:=deptTemp.DEPTNO;
                  EXIT;
                ELSIF min_emp_nmb_tmp=min_emp_nmb  THEN
                  departamentt:=deptTemp.DEPTNO;              
                END IF;
            END LOOP;
        END IF;
        SELECT EMPNO INTO boss_id_temp FROM EMP WHERE EMPNO=boss_id;
        INSERT INTO EMP(EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) VALUES(unique_id, nume, job1, boss_id, SYSDATE, salary, NULL, departamentt);
        EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu exista nici un sef cu ID-ul dat');
  END add_employee;   
  
-------------EX2-----------

---validation function for name----

FUNCTION validate_employee
    (nume IN EMP.ENAME%TYPE) RETURN BOOLEAN IS
    nume_temp  EMP.ENAME%TYPE;
  BEGIN
    SELECT ENAME INTO nume_temp FROM EMP WHERE EMP.ENAME=nume;
    RETURN TRUE;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN FALSE;   
  END validate_employee;
  
---validation function for id----

  FUNCTION validate_employee
    (id_emp IN EMP.EMPNO%TYPE) RETURN BOOLEAN IS
    id_temp  EMP.EMPNO%TYPE:=0;
  BEGIN
    SELECT EMPNO INTO id_temp FROM EMP WHERE EMP.EMPNO=id_emp;
    RETURN TRUE;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN FALSE;  
  END validate_employee;
  
----------remove function for name parameter-------

  PROCEDURE remove_employee
    (nume IN EMP.ENAME%TYPE) IS
    departament EMP.DEPTNO%TYPE;
    validare BOOLEAN:=FALSE;
    exceptie EXCEPTION;
    count_emp INTEGER:=0;
  BEGIN
    validare:=validate_employee(nume);
    IF (validare=FALSE)
      THEN RAISE exceptie;
    END IF;
    SELECT DEPTNO INTO departament FROM EMP WHERE ENAME=nume;
    SELECT COUNT(EMPNO) INTO count_emp FROM EMP WHERE DEPTNO=departament;
    DELETE FROM EMP WHERE ENAME=nume;
    IF(count_emp=1)
      THEN DELETE FROM DEPT WHERE DEPTNO = departament;
    END IF;
    EXCEPTION
    WHEN exceptie THEN DBMS_OUTPUT.PUT_LINE('NU EXISTA ASTFEL DE ANGAJAT');
  END remove_employee;
  
----------remove function for name parameter-------

  PROCEDURE remove_employee
    (id_angajat IN EMP.EMPNO%TYPE) IS
    departament EMP.DEPTNO%TYPE;
    validare BOOLEAN:=FALSE;
    exceptie EXCEPTION;
    count_emp INTEGER:=0;
  BEGIN
    validare:=validate_employee(id_angajat);
    IF (validare=FALSE)
      THEN RAISE exceptie;
    END IF;
    SELECT DEPTNO INTO departament FROM EMP WHERE EMPNO=id_angajat;
    SELECT COUNT(EMPNO) INTO count_emp FROM EMP WHERE DEPTNO=departament;
    DELETE FROM EMP WHERE EMPNO=id_angajat;
    IF(count_emp=1)
      THEN DELETE FROM DEPT WHERE DEPTNO = departament;
    END IF;
    EXCEPTION
    WHEN exceptie THEN DBMS_OUTPUT.PUT_LINE('NU EXISTA ASTFEL DE ANGAJAT');
  END remove_employee;
  
---------------------EX3---------------

  PROCEDURE add_dept
    (dname1 DEPT.DNAME%TYPE, dloc1 DEPT.LOC%TYPE) IS
    nr_dep DEPT.DEPTNO%TYPE;
  BEGIN
    SELECT MAX(DEPTNO)+10 INTO nr_dep FROM DEPT;
    INSERT INTO DEPT(DEPTNO,DNAME,LOC) VALUES(nr_dep,dname1,dloc1);
  END add_dept;
  
--------------------EX4-----------------------    

  PROCEDURE DISPLAY_t
    (output VARCHAR2) IS
    v_file UTL_FILE.FILE_TYPE;
  BEGIN
    IF(TRIM(output)='ecran')
      THEN
        FOR i IN (SELECT * FROM EMP) LOOP
          DBMS_OUTPUT.PUT_LINE('EMPNO: '||i.EMPNO||' ENAME: '||i.ENAME||' JOB: '||i.JOB||' MGR: '||i.MGR||' HIREDATE: '||i.HIREDATE||' SAL: '||i.SAL||' COMM: '||i.COMM||' DEPTNO: '||i.DEPTNO);
        END LOOP;
      ELSE
        v_file:= UTL_FILE.FOPEN ('DIR_NEW1', 'text.txt', 'w');
        FOR i IN (SELECT * FROM EMP) LOOP
          UTL_FILE.PUT_LINE(v_file,'EMPNO: '||i.EMPNO||' ENAME: '||i.ENAME||' JOB: '||i.JOB||' MGR: '||i.MGR||' HIREDATE: '||i.HIREDATE||' SAL: '||i.SAL||' COMM: '||i.COMM||' DEPTNO: '||i.DEPTNO);
        END LOOP;
        UTL_FILE.FCLOSE (v_file);  
    END IF;
    EXCEPTION
      WHEN UTL_FILE.INVALID_FILEHANDLE THEN RAISE_APPLICATION_ERROR(-20001,'Invalid File.');
      WHEN UTL_FILE.WRITE_ERROR THEN RAISE_APPLICATION_ERROR (-20002, 'Unable to write to file');  
  END DISPLAY_t;   
  
END employee_management;
/

------------------EX5------------
BEGIN  
    EMPLOYEE_MANAGEMENT.DISPLAY_t('ecran');
    EMPLOYEE_MANAGEMENT.ADD_DEPT('Integration','Madagascar');
    EMPLOYEE_MANAGEMENT.ADD_EMPLOYEE('Billy',2500,'Cafe-boy', 7782);
    EMPLOYEE_MANAGEMENT.ADD_EMPLOYEE('Johnny',2503,'ANALYST', 7782); 
    EMPLOYEE_MANAGEMENT.DISPLAY_t('ecran');
    EMPLOYEE_MANAGEMENT.DISPLAY_t('fisier');
    EMPLOYEE_MANAGEMENT.REMOVE_EMPLOYEE(7782);
    EMPLOYEE_MANAGEMENT.REMOVE_EMPLOYEE('Billy');
    EMPLOYEE_MANAGEMENT.DISPLAY_t('ecran');
END;
/
