set serveroutput on;
/

CREATE OR REPLACE VIEW allObjects AS
  SELECT *
  FROM ALL_OBJECTS
  WHERE OWNER=USER;
/