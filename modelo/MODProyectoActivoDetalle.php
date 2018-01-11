<?php
/**
*@package pXP
*@file gen-MODProyectoActivoDetalle.php
*@author  (admin)
*@date 10-10-2017 18:02:07
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProyectoActivoDetalle extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProyectoActivoDetalle(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_activo_detalle_sel';
		$this->transaccion='PRO_PRACDE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto_activo_detalle','int4');
		$this->captura('id_proyecto_activo','int4');
		$this->captura('id_comprobante','int4');
		$this->captura('nro_cuenta','varchar');
		$this->captura('id_tipo_cc','int4');
		$this->captura('porcentaje','numeric');
		$this->captura('monto','numeric');
		$this->captura('observaciones','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cuenta','text');
		$this->captura('fecha','date');
		$this->captura('nro_tramite','varchar');
		$this->captura('glosa1','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarProyectoActivoDetalle(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_detalle_ime';
		$this->transaccion='PRO_PRACDE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo','id_proyecto_activo','int4');
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarProyectoActivoDetalle(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_detalle_ime';
		$this->transaccion='PRO_PRACDE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo_detalle','id_proyecto_activo_detalle','int4');
		$this->setParametro('id_proyecto_activo','id_proyecto_activo','int4');
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('porcentaje','porcentaje','numeric');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('monto','monto','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProyectoActivoDetalle(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_detalle_ime';
		$this->transaccion='PRO_PRACDE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo_detalle','id_proyecto_activo_detalle','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function obtenerCuentaSaldo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_detalle_ime';
		$this->transaccion='PRO_CUESAL_LIS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('operacion','operacion','varchar');
		$this->setParametro('id_proyecto_activo_detalle','id_proyecto_activo_detalle','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>