--ex2--
SET SERVEROUTPUT ON;
DECLARE
  CURSOR locatia (departament emp.deptno%TYPE) IS
  SELECT UNIQUE ENAME,LOC
  FROM EMP,DEPT
  WHERE (SAL/TO_NUMBER(SYSDATE-HIREDATE))=(SELECT MAX(SAL/TO_NUMBER(SYSDATE-HIREDATE)) FROM EMP WHERE Deptno = departament) AND DEPT.DEPTNO=departament; 
TheLocatia locatia%ROWTYPE;
BEGIN
  OPEN locatia (10);
  LOOP
  FETCH locatia INTO TheLocatia;
  EXIT WHEN locatia%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(TheLocatia.ENAME || '   '||TheLocatia.LOC);
  END LOOP;
  CLOSE locatia;
END;
/
