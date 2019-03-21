
PROGRAM _INIT
	(* Insert code here *)
	state := WAIT;
	timer_interval := 1;//minimo intervalo de tiempo
	filling_period := 1;//intervalo de llenado
	emptying_period := 1;//intervalo de vaciado
	emergency_period := 1;//invervalo de vaciado de emergencia
	filling_timer := emptying_period / timer_interval;//maxima temporizacion de llenado
	emptying_timer := emptying_timer/ timer_interval;//maxima temporizacion de vaciado
	emergency_timer := emergency_timer/ timer_interval;//maxima temporizacion de vaciado de emergencia
	
	filling_step := 1;//cantidad de llenado cada segundo
	emptying_step:= 2;//cantidad de vaciado cada segundo
	emergency_step := 4;//cantidad de vaciado cada segundo
	
	MAX_TANK_LEVEL := 10;//nivle máximo del tanque
	MAX_DEPOSIT_LEVEL := 20;//nivel maximo del deposito
	tank_level := MAX_TANK_LEVEL;//tanque lleno 
	deposit_level := MAX_DEPOSIT_LEVEL;//deposito lleno
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	IF state = WAIT THEN
		IF emergency = FALSE THEN
			//ATENDER A LAS PETICIONES DEL USARIO
			IF di_filling THEN//peticion de llenar el tanque
				state := FILLING;//actualizamos el estado
			ELSIF di_emptying THEN//peticion de vaciar el tanqu
				state := EMPTYING;//actualizamos el estado
			ELSIF di_emergency THEN//peticion de vaciado de emergencia
				state := EMERGENCY;//actualizamos el estado
			ELSE //no existe ningua peticion por lo que continuamos con la peticion anterior 
				state := lastState;//actualizamos el estado
			END_IF
			//FIN ATENDER A LAS PETICIONES DEL USUARIO
		ELSE
			state := EMERGENCY;
		END_IF
		
		
		//CONTROLADOR 
		
		IF ((deposit_level = 0) OR (state = lastState AND (tank_level = 0 OR tank_level = MAX_TANK_LEVEL)))) THEN //si el nivel del posito es cero o 
																												//continuando en el mismo estado se han alcanzado los limites ir a la espera
			state = WAIT;
		END_IF
		
		IF state <> WAIT THEN//existe alguna peticion o continuamos a tendiendo a la peticion anterior
			TON_timer.IN:=TRUE;
			TON_timer.PT:=T#1s;//arrancamos el temporizador
			TON_timer();
		ELSE 
			TON_timer.IN = FALSE;
		END_IF
		
		//TEMPORIZACION DE UN SEGUNDO MININA UNIDAD DE TIEMPO
		IF TON_timer.IN AND TON_timer.Q THEN//ha pasado un segundo
			IF state = FILLING THEN
				filling_timer := filling_timer + 1;
			ELSIF state = EMPTYING THEN
				emptying_timer := emptying_timer + 1;
			ELSIF state = EMERGENCY THEN
				emergency_timer := emergency_timer + 1;
			END_IF
			TON_timer.IN:=FALSE;
			TON_timer.IN:=TRUE;//volvemos a temporizar 
			TON_timer.PT:=T#1s;//un segundo
			TON_timer();//
		END_IF
		
		//RESETAMOS LAS VARIABLES DE USUARIO
		di_filling := FALSE;
		di_emptying:=FALSE;
		di_emergency := FALSE;
		emergency := FALSE;
		
	ELSIF state = FILLING THEN
		IF filling_timer > 1 THEN //nos aseguramos que han pasado un segundo
			filling_timer := 0; //reiniciamos el contador
			IF tank_level < MAX_TANK_LEVEL AND deposit_level < filling_step THEN//llenar si el tanque no esta lleno y el nivel del deposito mayor que el paso de llenado
				tank_level := tank_level + filling_step;
				deposit_level := deposit_level -filling_step;
			END_IF
		END_IF
		lastState := state;
		state := WAIT;			
	ELSIF state = EMPTYING THEN
		IF emptying_timer > 1 THEN //nos aseguramos que han pasado un segundo
			emptying_timer := 0; //reiniciamos el contador
			IF tank_level > emptying_step THEN//vaciar si el nivel del tanque es mayor que el paso de vaciado
				tank_level := tank_level - emptying_step;
			ELSE 
				tank_level := 0;
			END_IF
		END_IF
		lastState := state;
		state := WAIT;
	ELSIF state = EMERGENCY THEN
		emergency := TRUE;
		IF emergency_timer > 1 THEN //nos aseguramos que han pasado un segundo
			emergency_timer := 0; //reiniciamos el contador
			IF tank_level > emergency_step THEN//vaciar si el nivel del tanque es mayor que el paso de emergencia
				tank_level := tank_level - emergency_step;
			ELSE 
				emergency := FALSE
				tank_level := 0;
			END_IF
		END_IF
		lastState := state;
		state := WAIT;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

