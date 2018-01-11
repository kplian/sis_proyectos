<?php
/**
*@package pXP
*@file gen-MODContratoPago.php
*@author  (admin)
*@date 29-09-2017 17:05:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODContratoPago extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarContratoPago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_contrato_pago_sel';
		$this->transaccion='PRO_CONPAG_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_contrato_pago','int4');
		$this->captura('id_proyecto_contrato','int4');
		$this->captura('fecha_plan','date');
		$this->captura('id_moneda','int4');
		$this->captura('monto','numeric');
		$this->captura('fecha_pago','date');
		$this->captura('monto_pagado','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('moneda','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarContratoPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_contrato_pago_ime';
		$this->transaccion='PRO_CONPAG_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_contrato','id_proyecto_contrato','int4');
		$this->setParametro('fecha_plan','fecha_plan','date');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('fecha_pago','fecha_pago','date');
		$this->setParametro('monto_pagado','monto_pagado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarContratoPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_contrato_pago_ime';
		$this->transaccion='PRO_CONPAG_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_contrato_pago','id_contrato_pago','int4');
		$this->setParametro('id_proyecto_contrato','id_proyecto_contrato','int4');
		$this->setParametro('fecha_plan','fecha_plan','date');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('fecha_pago','fecha_pago','date');
		$this->setParametro('monto_pagado','monto_pagado','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarContratoPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_contrato_pago_ime';
		$this->transaccion='PRO_CONPAG_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_contrato_pago','id_contrato_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>