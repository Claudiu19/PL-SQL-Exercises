--ex 1--
DROP TABLE Fibonacci;
CREATE TABLE Fibonacci
(
	id int,
	valoare int
);
DECLARE
	prec_prec_nmb int:=1;
	prec_nmb int:=1;
	curr_nmb int:=2;
	fib_counter int:=1;
BEGIN
	WHILE curr_nmb<1000 LOOP
		INSERT INTO Fibonacci VALUES(fib_counter,curr_nmb);
		prec_prec_nmb:=prec_nmb;
		prec_nmb:=curr_nmb;
		curr_nmb:=prec_prec_nmb+prec_nmb;
		fib_counter:=fib_counter+1;
	END LOOP;
END;
/