
PROGRAM _INIT
	//contador 3 veces
	times := 0;				
	//arrancamos los contadores
	TON_2seg.PT := T#2s;
	TON_2seg();
	TON_5seg.PT := T#5s;
	TON_5seg();
END_PROGRAM

PROGRAM _CYCLIC
	//ACCION : boton PRESS
	IF (di_btn_press) THEN
		IF (do_led = FALSE) THEN
			times := times + 1;
			IF ( times = 1 ) THEN
				start_timer_5seg := TRUE;
			END_IF
		END_IF
	END_IF
	
	//ACCION : boton RESET
	IF (di_btn_reset) THEN
		IF (do_led) THEN
			start_timer_2seg := TRUE;
		END_IF
	ELSE
		IF (do_led) THEN 
			stop_timer_2seg := TRUE;
		END_IF
	END_IF
	
	//CONTROL TEMPORIZADOR 2SEG
	IF (stop_timer_2seg) THEN //para de temporizar
		TON_2seg.IN = FALSE;
	ELSIF (start_timer_2seg = TRUE ) THEN //arrancar el temporizador de 2 seg
		TON_2seg.IN := TRUE; //ponemos a true IN
	END_IF
	
	IF (TON_2seg.Q) THEN //si ya hemos acabado de temporizar
		IF (di_btn_reset) THEN //aun se mantiene pulsado
			turn_on_led := FALSE;
		END_IF
	END_IF

	
	//CONTROL TEMPORIZADOR 5SEG
	IF (start_timer_5seg = TRUE) THEN //arrancar el temporizador de 5 seg
		TON_5seg.IN := TRUE; //ponemos a true IN
	ELSE
		IF (TON_5seg.IN AND TON_5seg.Q = FALSE) THEN //mientras el temporizador esta corriendo
			IF times >= 3 THEN //si el numero de pulsaciones es mayor que 3 
				turn_on_led := TRUE; //solicitud de encendido del led
			END_IF
		ELSIF (TON_5seg.Q) THEN //si ya hemos acabado de temporizar
			TON_5seg.IN := FALSE;//desactivamos el temporizador
			times := 0;//reiniciamos el contador
		END_IF
	END_IF
	
	do_led := turn_on_led;
	di_btn_press := FALSE;
	start_timer_2seg := FALSE;//nos aseguramos de bajar el flag
	stop_timer_2seg := FALSE;
	start_timer_5seg .= FALSE;
END_PROGRAM

