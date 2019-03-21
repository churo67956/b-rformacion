//Autor : Erik Churo
//Descripcion : programa que realiza el control de temperatura
//este control es vital, ejecutar cada 10ms
PROGRAM _INIT
	
END_PROGRAM

PROGRAM _CYCLIC
	//control de temperatura
	IF ai_temperatura_real <= ai_temperatura_minima THEN //temperatura igual o inferior a la temperatura minima
		ao_alarma := 'Tº BAJA'; //mensaje de error, temperatura no suficiente
	ELSIF ai_temperatura_real >= ai_temperatura_maxima THEN //temperatura igual o superior a la temperatura maxima
		ao_alarma := 'Tº ALTA';//mensaje de error, temperatura excesiva
	ELSE ////temperatura correcta
		ao_alarma := 'Tº OK'; //mensaje de acierto
	END_IF
END_PROGRAM

