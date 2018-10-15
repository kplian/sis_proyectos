<?php
/**
*@package pXP
*@file gen-MODProyectoActivoDetMon.php
*@author  (rchumacero)
*@date 05-10-2018 18:01:38
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProyectoActivoDetMon extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarProyectoActivoDetMon(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_activo_det_mon_sel';
		$this->transaccion='PRO_ADETM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto_activo_det_mon','int4');
		$this->captura('id_proyecto_activo_detalle','int4');
		$this->captura('id_moneda','int4');
		$this->captura('importe_actualiz','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_moneda','varchar');
		$this->captura('desc_tcc','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarProyectoActivoDetMon(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_det_mon_ime';
		$this->transaccion='PRO_ADETM_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo_detalle','id_proyecto_activo_detalle','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('importe_actualiz','importe_actualiz','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarProyectoActivoDetMon(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_det_mon_ime';
		$this->transaccion='PRO_ADETM_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo_det_mon','id_proyecto_activo_det_mon','int4');
		$this->setParametro('id_proyecto_activo_detalle','id_proyecto_activo_detalle','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('importe_actualiz','importe_actualiz','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarProyectoActivoDetMon(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_det_mon_ime';
		$this->transaccion='PRO_ADETM_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo_det_mon','id_proyecto_activo_det_mon','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>