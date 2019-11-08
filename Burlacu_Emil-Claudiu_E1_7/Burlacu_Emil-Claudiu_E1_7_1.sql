@'http://www.info.uaic.ro/~vcosmin/pagini/resurse_psgbd/Script/Script.sql';
/

set serveroutput on;
/

DROP TYPE tabel_marire_data;
/

DROP TYPE marire_data;
/

CREATE TYPE marire_data AS OBJECT (
   salar_nou   NUMBER,
   data_marire DATE
);
/

CREATE TYPE tabel_marire_data AS TABLE OF marire_data;
/

ALTER TABLE EMP ADD (raise_date tabel_marire_data) NESTED TABLE raise_date STORE AS raise_date_table;  
/

DROP TYPE lista_marire;
/

CREATE OR REPLACE TYPE angajat_marire AS OBJECT (
   empno_m   INTEGER(4),
   procent_marire INTEGER(2)
);
/

CREATE TYPE lista_marire AS TABLE OF angajat_marire;
/

CREATE OR REPLACE PACKAGE pachet_mariri IS
FUNCTION marire
      (tabela_mariri IN lista_marire) RETURN BOOLEAN;
FUNCTION afisare_mariri 
       RETURN BOOLEAN;
END pachet_mariri;
/

CREATE OR REPLACE PACKAGE BODY pachet_mariri IS
--functia ce va efectua marirea si memorarea acesteia si timpului la care aceasta a fost efectuata--
FUNCTION marire(tabela_mariri IN lista_marire) RETURN BOOLEAN
IS
  sal_vechi NUMBER;
  updated_raise_table tabel_marire_data:=tabel_marire_data();
BEGIN
       FOR indx IN 1..tabela_mariri.COUNT
       LOOP
          BEGIN
            SELECT raise_date INTO updated_raise_table FROM EMP WHERE EMP.EMPNO=tabela_mariri(INDX).empno_m;          
            IF updated_raise_table IS NULL
              THEN 
                updated_raise_table:=tabel_marire_data();
                SELECT SAL INTO sal_vechi FROM EMP WHERE EMPNO=tabela_mariri(INDX).empno_m;
              ELSE
                sal_vechi:=updated_raise_table(updated_raise_table.COUNT).salar_nou;            
            END IF;          
            updated_raise_table.EXTEND;
            updated_raise_table(updated_raise_table.COUNT):=marire_data(sal_vechi+sal_vechi*(tabela_mariri(INDX).procent_marire/100),SYSDATE);          
            UPDATE EMP SET raise_date=updated_raise_table WHERE EMP.EMPNO=tabela_mariri(INDX).empno_m;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Nu exista nici un angajat cu ID-ul dat');
          END;        
       END LOOP;
       RETURN TRUE;
END;
--functia de afisare a salariatilor cu cresterile sale si timpul la care acestea au fost efectuate--
FUNCTION afisare_mariri RETURN BOOLEAN
IS
BEGIN
  FOR ANGAJAT_MARIRI IN (SELECT ENAME,raise_date FROM EMP)
  LOOP
     IF ANGAJAT_MARIRI.raise_date IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE(TRIM(ANGAJAT_MARIRI.ENAME) || ' : ');
      FOR MARIRE IN 1..ANGAJAT_MARIRI.raise_date.COUNT
      LOOP
       DBMS_OUTPUT.PUT_LINE('    '||ANGAJAT_MARIRI.raise_date(MARIRE).salar_nou || ' ' || ANGAJAT_MARIRI.raise_date(MARIRE).data_marire );         
      END LOOP;
     END IF;
  END LOOP;
  RETURN TRUE;
END;
END pachet_mariri;
/

--blocul anonim ce apelea functii de marire si afisare a acestora--
DECLARE
  tabela lista_marire:=lista_marire();
  validare BOOLEAN;
BEGIN
    tabela.extend(1);
    tabela(1):=angajat_marire(7902,20);
    tabela.extend(1);
    tabela(2):=angajat_marire(25,20);
    tabela.extend(1);
    tabela(3):=angajat_marire(7934,20);
    tabela.extend(1);
    tabela(4):=angajat_marire(7934,15);
    tabela.extend(1);
    tabela(5):=angajat_marire(7934,15);
    tabela.extend(1);
    tabela(6):=angajat_marire(7900,60);
    tabela.extend(1);
    tabela(7):=angajat_marire(7900,60);
    validare:=marire(tabela);
    validare:=afisare_mariri;
    validare:=marire(tabela);
    validare:=afisare_mariri;
END;
/