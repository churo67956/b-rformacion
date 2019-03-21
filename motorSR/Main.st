
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	

	
	//fallo seta
	IF di_seta THEN
		fallo_seta := TRUE;
	END_IF
	
	//si pulsamos el boton de reset
	IF di_reset THEN
		fallo_seta := FALSE ;
	END_IF
	di_reset := FALSE ;
	
	
	//fallo disyuntor
	fallo_disyuntor := di_disyuntor ;



	
	// FALLO
	led_fallo := fallo_seta OR fallo_disyuntor ;		

	// START --> SOLO CON BOTON
	IF di_start THEN
		motor := TRUE ;
	END_IF
	di_start := FALSE ;
	
	
	
	// STOP --> CON BOTON
	IF di_stop THEN
		motor := FALSE ;
	END_IF
	di_stop := FALSE ;
		
	// STOP --> FALLO
	IF led_fallo THEN
		motor := FALSE ;
	END_IF
	
	
	
	// LED START
	led_marcha := motor ;
	
		
END_PROGRAM



