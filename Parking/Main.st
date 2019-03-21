
	
PROGRAM _INIT
	state := WAIT;
END_PROGRAM



PROGRAM _CYCLIC 
	
		IF state = WAIT THEN //estado de espera
			
			//ATENCION DE LAS PETICIONS DEL USUARIO
			IF di_residential_entry THEN//peticion de entrada como residente
				state := RESIDENT_ENTRY;//entrada de residente		
			ELSIF di_normal_entry THEN//peticion de entrada normal
				state := NORMAL_ENTRY;//entrada normal
			ELSIF di_residential_exit THEN//peticion de entrada como residente
				state := RESIDENT_EXIT;//entrada de residente		
			ELSIF di_normal_exit THEN//peticion de entrada normal
				state := NORMAL_EXIT;//entrada normal
			END_IF
			//FIN DE LA ATENCION A LAS PETICIONES DEL USUARIO
			
			//CONTROL DEL PASO DE LOS COCHES
			IF state = RESIDENT_ENTRY THEN
				allow_entry_rp := rpcounter < MAXRP;	
			ELSIF state = NORMAL_ENTRY THEN
				allow_entry_np:= rpcounter < MAXRP;
			END_IF
			allow_entry := allow_entry_np OR allow_entry_rp;
			IF allow_entry = FALSE THEN
				IF allow_entry_rp = FALSE THEN
					di_normal_entry := TRUE;//simulamos el pulsado del boton
				END_IF
				state := WAIT;
			END_IF
			//FIN DEL CONTROL DE PASO DE LOS COCHES
			
			//CONTROL DE SALIDA DE COCHES
			allow_exit = (state = RESIDENT_EXIT AND rpcounter > 0) OR (state = NORMAL_EXIT AND npcounter > 0);
			IF allow_exit = FALSE THEN
				state := WAIT;
			END_IF
			//FIN CONTROL DE SALIDA DE COCHES
			
			//ACTUALIZAMOS LAS VARIABLES DE SALIDA
			do_full_rp := NOT allow_entry_rp;//bombilla parque lleno residencial
			do_full_np := NOT allow_entry_np;//bombilla parque lleno normal
			//FIN ACTUALIZACION DE LAS VARIABLES DE SALIDA
			
			//RESETEAMOS LAS VARIABLES DE ENTRADA
			di_residential_exit := FALSE;//resetamos el estado del boton de salida residencial
			di_normal_exit := FALSE;//resetamos el estado del boton de salida normal
			di_residential_entry := FALSE;//resetamos el estado del boton de entrada residencial
			di_normal_entry := FALSE;//resetamos el estado del boton de entrada normal
			//FIN RESETEAMOS LAS VARIABLES DE ENTRADA
			
			//RESETEAMOS LAS VARIABLES DE ESTADO DE USUARIO
			allow_entry_rp := FALSE;
			allow_entry_np := FALSE;
			//FIN RESETEAMOS LAS VARIABLES DE ESTADO DE USUARIO
			
		ELSIF state = RESIDENT_ENTRY THEN
			do_entryDoor := TRUE;//abre la puerta de entrada
			do_access := TRUE;//abre la puerta de acceso residencia
			rpnormal := rpnormal + 1;//incrementa en uno el numero de plazas ocupadas
			state := WAIT;
		ELSIF state = NORMAL_ENTRY THEN
			do_entryDoor := TRUE;//abre la puerta de entrada
			npnormal := npnormal + 1;//incrementa el numero de coches
			state := WAIT;
		ELSIF NORMAL_EXIT THEN
			do_normalExitDoor := TRUE;//abre la puerta de entrada
			npnormal := npnormal - 1;
			state := WAIT;
		ELSIF state = RESIDENT_ENTRY THEN
			do_entryDoor := TRUE;//abre la puerta de entrada
			do_access := TRUE;//abre la puerta de acceso residencia
			rpnormal := rpnormal + 1;
			state := WAIT;
		ELSIF state = RESIDENT_EXIT THEN
			do_residentExitDoor := TRUE;//abre la puerta de entrada
			rpnormal := rpnormal - 1;
			state := WAIT;
		END_IF
	END_PROGRAM


