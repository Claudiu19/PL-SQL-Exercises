CREATE OR REPLACE TYPE Manager UNDER Employee (
  nrEmp INTEGER,
  MEMBER FUNCTION orderMGR (mgrCompare Manager) RETURN INTEGER,
  CONSTRUCTOR FUNCTION Manager RETURN SELF AS RESULT
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY Manager AS 

  MEMBER FUNCTION orderMGR (mgrCompare Manager) RETURN INTEGER IS
  BEGIN
    IF mgrCompare.nrEmp>nrEmp THEN RETURN (-1);
    ELSIF mgrCompare.nrEmp=nrEmp THEN RETURN 0;
    ELSIF mgrCompare.nrEmp<nrEmp THEN RETURN 1;
    END IF;
  END;
  
  CONSTRUCTOR FUNCTION Manager RETURN SELF AS RESULT AS
    BEGIN
      RETURN;
    END;
END;
/
