--ex3--
DROP TABLE FiboPrime;
CREATE TABLE FiboPrime
(
	prime int,
	value int	
);

	MERGE INTO FiboPrime f
	USING Fibonacci fib
	ON (f.value != null)
	WHEN NOT MATCHED THEN
	INSERT (f.prime,f.value) VALUES(0,fib.valoare)
/

	MERGE INTO FiboPrime f
	USING primes p
	ON (f.value = p.valoare)
	WHEN MATCHED THEN
	UPDATE SET
	f.prime=1
/