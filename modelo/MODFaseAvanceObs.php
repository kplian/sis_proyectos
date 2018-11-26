<?php
/**
*@package pXP
*@file gen-MODFaseAvanceObs.php
*@author  (rchumacero)
*@date 15-10-2018 19:59:14
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFaseAvanceObs extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarFaseAvanceObs(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_avance_obs_sel';
		$this->transaccion='PRO_FAAVOB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_fase_avance_obs','int4');
		$this->captura('id_fase','int4');
		$this->captura('fecha','date');
		$this->captura('observaciones','varchar');
		$this->captura('porcentaje','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('tipo','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarFaseAvanceObs(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_avance_obs_ime';
		$this->transaccion='PRO_FAAVOB_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarFaseAvanceObs(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_avance_obs_ime';
		$this->transaccion='PRO_FAAVOB_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase_avance_obs','id_fase_avance_obs','int4');
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarFaseAvanceObs(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_avance_obs_ime';
		$this->transaccion='PRO_FAAVOB_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase_avance_obs','id_fase_avance_obs','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>