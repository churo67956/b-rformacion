
PROGRAM _INIT
	(* Insert code here *)
	estado := 0;
END_PROGRAM

PROGRAM _CYCLIC
	
	IF estado = 0 THEN //estado de inicializacion
		di_pulsadorOn := 0; ////reinicio del contador del pulsador ON
		di_pulsadorOff := 0; //reinicio del contador del pulsador OFF
		do_led := 0; ////led apagado
	ELSIF estado = 1 THEN //estado de espera y de control del flujo
		IF di_pulsadorOn = 2 THEN //doble pulsacion , MAS PRIORITARIO
			di_pulsadorOn := 0; //reinicio del contador del pulsador ON
			do_led := TRUE; //encendemos el led
		ELSE
			IF di_pulsadorOff = 1 THEN //pulsador OFF
				di_pulsadorOff :=0; ////reinicio del contador del pulsador OFF
				do_led := FALSE; //apagamos el led
				di_pulsadorOn := 0; ////reinicio del contador del pulsador ON
			END_IF
		END_IF
	ELSIF estado = 2 THEN ////estado de pulsador ON
		di_pulsadorOn := di_pulsadorOn + 1;
		estado := 1;
	ELSIF estado = 3 THEN	///estado de pulsador OFF		
		di_pulsadorOff := di_pulsadorOff + 1;
		estado := 1;
	END_IF	
	
		
		
	
	
END_PROGRAM

