--ex1--
SET SERVEROUTPUT ON;
DECLARE
BEGIN
  FOR names IN (SELECT ename
    FROM emp
    WHERE sal>1500)
    LOOP
      DBMS_OUTPUT.PUT_LINE(names.ename);
    END LOOP;
END;
/