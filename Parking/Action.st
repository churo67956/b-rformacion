
//control de las luces de completo del parking
ACTION light_control:
	enough_place_in_resident_park;
	do_fullResidentPark := enoughPlace = FALSE;
	enough_place_in_normal_park;
	do_fullResidentPark := enoughPlace = FALSE;
END_ACTION

//funcion de atencion a la peticion del usuario
ACTION attend_user_request
	IF di_residential_entry THEN//peticion de entrada como residente
		state := RESIDENT_ENTRY;//entrada de residente		
	ELSIF di_normal_entry THEN//peticion de entrada normal
		state := NORMAL_ENTRY;//entrada normal
	ELSIF di_residential_exit THEN//peticion de entrada como residente
		state := RESIDENT_ENTRY;//entrada de residente		
	ELSIF di_normal_exit THEN//peticion de entrada normal
		state := NORMAL_ENTRY;//entrada normal
	END_IF
	di_residential_exit := FALSE;//resetamos el estado del boton de salida residencial
	di_normal_exit := FALSE;//resetamos el estado del boton de salida normal
	di_residential_entry := FALSE;//resetamos el estado del boton de entrada residencial
	di_normal_entry := FALSE;//resetamos el estado del boton de entrada normal
END_ACTION

ACTION normal_entry
	do_entryDoor := TRUE;//abre la puerta de entrada
	npnormal := npnormal + 1;//incrementa el numero de coches
	//do_entryDoor := FALSE;//cierra la puerta de entrada 
END_ACTION

ACTION normal_exit
	do_normalExitDoor := TRUE;//abre la puerta de entrada
	npnormal := npnormal - 1;
	//do_normalExitDoor := FALSE
END_ACTION

ACTION resident_entry
	do_entryDoor := TRUE;//abre la puerta de entrada
	do_access := TRUE;//abre la puerta de acceso residencia
	rpnormal := rpnormal + 1;
	//	do_entryDoor := FALSE;//cierra la puerta de entrada 
	//	do_access := FALSE;//cierra la puerta de acceso
	state := WAIT;
END_ACTION

ACTION resident_exit;
	do_residentExitDoor := TRUE;//abre la puerta de entrada
	rpnormal := rpnormal - 1;
	//	do_residentExitDoor := FALSE;//abre la puerta de entrada
END_ACTION

ACTION open_entry_door
	allow_entry;//esta permitida la entrada
	IF allowEntry = FALSE THEN
		IF state = RESIDENT_ENTRY THEN//solicitamos una entrada normal
			state := WAIT;//actualizamos el estado
			di_normal_entry := TRUE;//simulamos el pulsado del boton
		END_IF
	END_IF
END_ACTION



ACTION open_exit_door
	IF state = RESIDENT_EXIT THEN //usuarios residenciales
		IF rpcounter > 0 THEN//numero de plazas ocupadas en el parking residencia inferior al maximo
			allow_exit = TRUE;//si existe sitio libre
		ELSE
			allow_exit = FALSE;//no existe sitio libre
		END_IF
	ELSIF state = NORMAL_EXIT THEN //usuarios normales
		IF npcounter > 0 THEN//numero de plazas ocupadas en el parking residencia inferior al maximo
			allow_exit = TRUE;//si existe sitio libre
		ELSE
			allow_exit = FALSE;//no existe sitio libre
		END_IF
	END_IF
	IF allow_exit = FALSE THEN
		state := WAIT;
	END_IF
END_ACTION

ACTION allow_entry
	IF state = RESIDENT_ENTRY THEN //usuarios residenciales
		enough_place_in_resident_park;
		IF enoughPlaceResidentPark THEN
			allowEntry := TRUE;
		ELSE
			allowEntry := FALSE;
		END_IF
	ELSIF state = NORMAL_ENTRY THEN //usuarios normales
		enough_place_in_normal_park;
		IF enoughPlaceNormalPark THEN
			allowEntry := TRUE;
		ELSE
			allowEntry := FALSE;
		END_IF
	ELSE
		allowEntry := FALSE;	
	
		END_ACTION

		ACTION enough_place_in_resident_park 
		IF rpcounter < MAXRP THEN//numero de plazas ocupadas en el parking residencia inferior al maximo
			enoughPlaceResidentPark = TRUE;//si existe sitio libre
		ELSE
			enoughPlaceResidentPark= FALSE;//no existe sitio libre
		END_IF
		END_ACTION

		ACTION enough_place_in_normal_park 
		IF npcounter < MAXNP THEN//numero de plazas ocupadas en el parking residencia inferior al maximo
			enoughPlaceNormalPark = TRUE;//si existe sitio libre
		ELSE
			enoughPlaceNormalPark = FALSE;//no existe sitio libre
		END_IF
		END_ACTION