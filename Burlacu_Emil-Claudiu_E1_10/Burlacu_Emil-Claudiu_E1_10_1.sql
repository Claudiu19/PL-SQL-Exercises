set serveroutput on;
/

CREATE OR REPLACE VIEW moreThan1500 AS
  SELECT *
  FROM emp
  WHERE sal>1500
  ORDER BY ENAME;
/