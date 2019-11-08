--ex3--
<<outer>>
DECLARE
	variabila int:=1;
	variabila_1 int:=2;
BEGIN
		DECLARE
			variabila int:=3;
			variabila_2 int:=4;
		BEGIN
			dbms_output.put_line('Var_loc suprascrie var_glob ' || variabila || ' Var doar locala: ' || variabila_2 || ' Var globala: ' || outer.variabila );
		END;
END;
/