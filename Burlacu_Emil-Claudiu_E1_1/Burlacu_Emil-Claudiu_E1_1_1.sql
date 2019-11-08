--ex 1--
DECLARE
	nume_prenume emp.ename%type;
	lungime int;
BEGIN
	select  initcap(lower(ename)), length(trim(ename)) into nume_prenume,lungime
	from emp
	where length(trim(ename))=(select max(length(trim(ename))) from emp) and rownum=1;
	dbms_output.put_line('Nume cu/fara prenume: ' || nume_prenume || ' Lungimea numelui: ' || lungime);
END;
/