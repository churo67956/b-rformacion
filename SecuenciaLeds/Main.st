
PROGRAM _INIT

	//variable de estado de inicio, por defecto a TRUE
	inicio := TRUE;
	
	//LEDS
	di_led_fijo := TRUE;
	di_led_3seg := FALSE;
	di_led_2seg := FALSE;
	di_led_4seg := FALSE;
	
END_PROGRAM

PROGRAM _CYCLIC
//	
//	IF inicio = TRUE THEN //estamos en inicio, luego nadie a pulsado el btn
//		
//		IF di_btn_inicio THEN // tras pulsar el btn
//			//ya no estamos en inicio
//			inicio := FALSE;
//			//led fijo apagado
//			di_led_fijo := FALSE;
//			//empezar a temporizar los 3 seg
//			TON_3seg.IN := TRUE;
//
//			//encender led de 3 segundos
//			di_led_3seg:= TRUE;
//			
//			di_btn_inicio := FALSE;
//		END_IF
//		
//	ELSE //tras pulsar el btn de inicio empezar una animacion
//		
//		IF TON_3seg.Q = TRUE THEN //han pasado 3 segundos
//			//desactivmos el temporizador
//			TON_3seg.IN := FALSE;
//			//apagamos el led de 3 segunos
//			di_led_3seg:= FALSE;
//			//empezar a temporizar los 2 seg
//			TON_2seg.IN := TRUE;
//
//			//encendemos el led de 2 segundos
//			di_led_2seg := TRUE;
//		ELSE
//			IF TON_2seg.Q = TRUE THEN //han pasado 2 segundos
//				//desactivmos el temporizador
//				TON_2seg.IN := FALSE;
//				//apagamos el led de 3 segunos
//				di_led_2seg:= FALSE;
//				//empezar a temporizar los 2 seg
//				TON_4seg.IN := TRUE;
//			
//				//encendemos el led de 4 segundos
//				di_led_4seg := TRUE;
//			ELSE
//				IF TON_4seg.Q = TRUE THEN //han pasado 4 segundos
//					//desactivmos el temporizador
//					TON_4seg.IN := FALSE;
//					//apagamos el led de 4 segunos
//					di_led_4seg:= FALSE;
//					//encendemos el led fijo
//					di_led_fijo := TRUE;
//					//ponemos la variable de inicio a true
//					inicio := TRUE;
//				END_IF	
//			END_IF
//		END_IF
//		di_btn_inicio := FALSE;
//	END_IF
//	
	
	

	
	IF inicio = TRUE AND di_btn_inicio THEN
		TON_3seg.IN := TRUE ;
		inicio := FALSE ;
	ELSE
		di_btn_inicio := FALSE ;
		IF TON_3seg.Q THEN
			TON_3seg.IN := FALSE ;
			TON_2seg.IN := TRUE ;
		ELSE
			IF TON_2seg.Q THEN
				TON_2seg.IN := FALSE ;
				TON_4seg.IN := TRUE ;
			ELSE
				IF TON_4seg.Q THEN
					TON_4seg.IN := FALSE ;
					inicio 		:= TRUE ;
				END_IF
			END_IF
		END_IF
	END_IF
	
	// LEDS
	di_led_2seg := TON_2seg.IN ;
	di_led_3seg := TON_3seg.IN ;
	di_led_4seg := TON_4seg.IN ;
	di_led_fijo := NOT TON_2seg.IN AND NOT TON_3seg.IN  AND NOT TON_4seg.IN ;
	
	
	
	
	TON_3seg.PT := T#3s;
	TON_3seg();
	TON_2seg.PT := T#2s;
	TON_2seg();	
	TON_4seg.PT := T#4s;	
	TON_4seg();
	
END_PROGRAM

