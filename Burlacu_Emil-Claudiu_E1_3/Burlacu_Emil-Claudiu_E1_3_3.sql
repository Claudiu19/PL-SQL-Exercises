--ex3--
SET SERVEROUTPUT ON;
DECLARE
  CURSOR c_emp IS
  SELECT * FROM EMP;  
  CURSOR c_mgr (mgr_id NUMBER,emp_sal NUMBER,emp_hiredate DATE) IS
  SELECT * FROM EMP WHERE EMPNO = mgr_id AND SAL + emp_sal>4000 AND HIREDATE<emp_hiredate
  FOR UPDATE NOWAIT;  
BEGIN
  FOR emp_line IN c_emp LOOP
    FOR mgr_line IN c_mgr (emp_line.MGR,emp_line.SAL,emp_line.HIREDATE) LOOP
      IF (c_mgr%FOUND) THEN
        DBMS_OUTPUT.PUT_LINE('Nume angajat: ' || emp_line.ename ||'  Nume manager: '|| mgr_line.ename);
        UPDATE EMP SET SAL=SAL+1 WHERE EMPNO = emp_line.EMPNO;
        UPDATE EMP SET SAL=SAL+1 WHERE EMPNO = mgr_line.EMPNO;
      END IF;  
    END LOOP;
  END LOOP;
END;
/