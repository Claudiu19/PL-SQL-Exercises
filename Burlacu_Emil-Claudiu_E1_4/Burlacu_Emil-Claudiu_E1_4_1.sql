SET SERVEROUTPUT ON;
--cream tabela cu coordonatele copacilor--
    DROP TABLE TREES;
	CREATE TABLE TREES
	(
	  X INTEGER,
	  Y INTEGER,
	  TREE_TYPE VARCHAR2(10)
	);

--procedura care populeaza tabela cu  coordonatele copacilor si tipul lor--
CREATE OR REPLACE PROCEDURE plant_trees (nmb_trees IN INTEGER,artari IN OUT INTEGER,arini IN OUT INTEGER,mesteacani IN OUT INTEGER,faguri IN OUT INTEGER,stejari IN OUT INTEGER) IS
  tree_type INTEGER;
BEGIN
	  FOR i IN 1..nmb_trees LOOP
	      tree_type := DBMS_RANDOM.VALUE(1,5);
	      CASE tree_type 
	        WHEN 1 THEN INSERT INTO TREES(X,Y,TREE_TYPE) VALUES(DBMS_RANDOM.VALUE(0,1000),DBMS_RANDOM.VALUE(0,1000),'Artar'); artari:=artari+1;
	        WHEN 2 THEN INSERT INTO TREES(X,Y,TREE_TYPE) VALUES(DBMS_RANDOM.VALUE(0,1000),DBMS_RANDOM.VALUE(0,1000),'Arin'); arini:=arini+1;
	        WHEN 3 THEN INSERT INTO TREES(X,Y,TREE_TYPE) VALUES(DBMS_RANDOM.VALUE(0,1000),DBMS_RANDOM.VALUE(0,1000),'Mesteacan'); mesteacani:=mesteacani+1;
	        WHEN 4 THEN INSERT INTO TREES(X,Y,TREE_TYPE) VALUES(DBMS_RANDOM.VALUE(0,1000),DBMS_RANDOM.VALUE(0,1000),'Fag'); faguri:=faguri+1;
	        WHEN 5 THEN INSERT INTO TREES(X,Y,TREE_TYPE) VALUES(DBMS_RANDOM.VALUE(0,1000),DBMS_RANDOM.VALUE(0,1000),'Stejar'); stejari:=stejari+1;
	      END CASE;
	  END LOOP;  
END;
/
--fct care calculeaza numarul de copaci care trebuie taiati pentru o anumita locatie--
CREATE OR REPLACE FUNCTION nmb_trees_to_cut (xx IN INTEGER, yy IN INTEGER) RETURN INTEGER IS
  nmb_of_trees INTEGER;
BEGIN
  SELECT COUNT(*) INTO nmb_of_trees
  FROM (SELECT * FROM TREES WHERE X<=xx+25 AND X>=xx-25 AND Y<=yy+25 AND Y>=yy-25  )
  WHERE  POWER((X-xx),2)+POWER((Y-yy),2)<=625;
  RETURN (nmb_of_trees);
END;
/
--blocul anonim care ruleaza procedura pentru 1100000 de copaci si afiseaza la sfarsit numarul de copaci de fiecare tip--
DECLARE
  artari INTEGER:=0;
  arini INTEGER:=0;
  mesteacani INTEGER:=0;
  faguri INTEGER:=0;
  stejari INTEGER:=0;
BEGIN
  plant_trees(1100000,artari,arini,mesteacani,faguri,stejari);
  DBMS_OUTPUT.PUT_LINE(artari||' '||arini||' '||faguri||' '||mesteacani||' '||stejari);
  --DBMS_OUTPUT.PUT_LINE(nmb_trees_to_cut(55,70));
END;
/
--cream tabela cu 100 de locatii random--
DROP TABLE LOCATIONS;
CREATE TABLE LOCATIONS
(
  X INTEGER,
  Y INTEGER
);

--procedura care populeaza tabela locatii cu 100 locatii--
CREATE OR REPLACE PROCEDURE create_locations IS
BEGIN
  FOR i IN 1..100 LOOP
        INSERT INTO LOCATIONS(X,Y) VALUES(DBMS_RANDOM.VALUE(0,1000),DBMS_RANDOM.VALUE(0,1000));
  END LOOP;   
END;
/

--blocul anonim care ruleaza procedura ce creeaza tabela cu locatii--
BEGIN
create_locations;
END;
/

--se creaza indexul pe coloane X si Y
DROP INDEX minim;

CREATE INDEX minim ON TREES(X,Y);

--se testeaza indexul--
SELECT MIN(nmb_trees_to_cut(X,Y)) FROM LOCATIONS;