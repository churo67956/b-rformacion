
PROGRAM _INIT
	(* Insert code here *)

	
END_PROGRAM

PROGRAM _CYCLIC
	IF di_plus THEN
		result := di_val1 + di_val2;
	ELSIF di_substract THEN
		result := di_val1 - di_val2;
	ELSIF di_times THEN
		result := di_val1 * di_val2;
	ELSIF di_divs THEN
		IF (di_val2 = 0) THEN
			result := 0
		ELSE
			result := di_val1 / di_val2;
		END_IF
	ELSIF di_pow THEN
		result := di_val1 * di_val1;
	ELSIF di_sqrts THEN
		IF di_val2 > 0 THEN
			result := SQRT(di_val2);
		ELSE
			result := 0;
		END_IF
	END_IF
	
	di_plus := FALSE;
	di_substract := FALSE;
	di_times := FALSE;
	di_pow := FALSE;
	di_sqrts := FALSE;
			
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

