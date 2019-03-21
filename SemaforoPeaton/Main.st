
PROGRAM _INIT
	(* Insert code here *)
	TON_green();
	TON_green.PT = T#5s;
	
	TON_yellow();
	TON_yellow.PT = T#5s;
	
	TON_red();
	TON_red.PT = T#5s;
	
	//EL SEMAFORO PARTE EN ROJO
	TON_red.IN := TRUE;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)

	
	
	IF TON_red.IN AND TON_red.Q = FALSE THEN //mientras estamos en rojo
		IF (pending_request = TRUE) THEN //atender a la solicitud pendiente
			let_cross := TRUE;//dejamos pasar a los usuarios
		END_IF
	ELSIF (TON_red.IN AND TON_red.Q) THEN //ya no estamos en rojo
		TON_red.IN := FALSE;
		IF pending_request THEN //si existia alguna solicitud
			pending_request := FALSE;//finalizamos la solicitud
		END_IF
		//arrancar el verde
		TON_green.IN:= TRUE;
	ELSIF (TON_green.IN AND TON_green.Q ) THEN //ya no estamos en rojo
		TON_green.IN := FALSE;//desabilitamos el contador
		TON_yellow.IN := TRUE; //arrancamos el amarrillo
	ELSIF (TON_yellow.IN AND TON_yellow.Q) THEN //ya no estamos en amarillo
		TON_yellow.IN := FALSE;//desabilitamos el contador
		TON_red.IN := TRUE;//arrancamos el rojo
	END_IF
	
	IF let_cross AND TON_cross.IN = FALSE THEN //dejamos pasar a los peatones
		TON_cross.IN := TRUE;//arrancamos el temporizador
	ELSIF (TON_cross.IN AND TON_cross.Q) THEN//han pasado los 3 seg
		TON_cross.IN := FALSE;
		let_cross := FALSE;//ya no dejamos pasar a los peatones
	END_IF
	
			
	//SOLICITAMOS PASAR
	IF (di_btn_press) THEN
		IF ( pending_request = FALSE) THEN //no existe solicitud
			pending_request := TRUE;//solicitud pendiente 
		(*ELSE
			//ya existe una solicitud pendiente por atender
		END_IF*)
		END_IF
	END_IF
	
	
	//led verde
	do_led_green := TON_green.IN AND TON_green.Q = FALSE;
	//led amarillo
	do_led_yellow := TON_yellow.IN AND TON_yellow.Q = FALSE;
	//led verde
	do_led_read := TON_red.IN AND TON_red.Q = FALSE;
	//led cruce peatones
	do_led_cross :=  TON_cross.IN AND TON_cross.Q = FALSE;
	//btn pulsar
	di_btn_press := FALSE;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

