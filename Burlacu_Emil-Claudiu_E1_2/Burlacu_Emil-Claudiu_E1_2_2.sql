--ex 2--
DROP TABLE primes;
CREATE TABLE primes
(
	id int,
	valoare int
);
DECLARE
	prime_counter int:=0;
	ok int;
	heWhoDivides int;
BEGIN
	FOR i IN 2..1999 LOOP
		ok:=1;
		heWhoDivides:=2;
		LOOP
			EXIT WHEN heWhoDivides>SQRT(i);
			IF MOD(i,heWhoDivides)=0
			THEN
				ok:=0;
				EXIT;
			ELSE
				heWhoDivides:=heWhoDivides+1;
			END IF;
		END LOOP;	
		IF ok=1
		THEN
			prime_counter:=prime_counter+1;
			INSERT INTO primes VALUES (prime_counter,i);
		END IF;		
	END LOOP;
	DELETE FROM primes WHERE valoare>1500 and valoare<1800;
	dbms_output.put_line('Au fost sterse ' || SQL%ROWCOUNT || ' randuri');
END;
/