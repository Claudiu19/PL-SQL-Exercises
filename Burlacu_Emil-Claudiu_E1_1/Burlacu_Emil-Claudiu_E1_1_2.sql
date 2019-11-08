--ex2--
DECLARE
	constanta CONSTANT VARCHAR2(30) :='17-07-1994';
	day_of_week VARCHAR2(20):=TO_CHAR(TO_DATE(constanta,'DD-MM-YYYY'),'DAY');
	days INT:=(SYSDATE-TO_DATE(constanta,'DD-MM-YYYY'))+1;
	months INT:=MONTHS_BETWEEN(SYSDATE,TO_DATE(constanta,'DD-MM-YYYY'));
BEGIN
	dbms_output.put_line( 'Ziua saptamanii: '|| day_of_week || 'Luni: ' || months ||' Zile: '||days);
END;
/