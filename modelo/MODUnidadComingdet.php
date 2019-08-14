<?php
/**
*@package pXP
*@file gen-MODUnidadComingdet.php
*@author  (egutierrez)
*@date 08-08-2019 15:05:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODUnidadComingdet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarUnidadComingdet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_comingdet_sel';
		$this->transaccion='PRO_UNCOM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_comingdet','int4');
		$this->captura('id_unidad_constructiva','int4');
		$this->captura('cantidad_asignada','numeric');
		$this->captura('id_componente_concepto_ingas_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('desc_uc','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarUnidadComingdet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_comingdet_ime';
		$this->transaccion='PRO_UNCOM_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');
		$this->setParametro('cantidad_asignada','cantidad_asignada','numeric');
		$this->setParametro('id_componente_concepto_ingas_det','id_componente_concepto_ingas_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarUnidadComingdet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_comingdet_ime';
		$this->transaccion='PRO_UNCOM_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_comingdet','id_unidad_comingdet','int4');
		$this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');
		$this->setParametro('cantidad_asignada','cantidad_asignada','numeric');
		$this->setParametro('id_componente_concepto_ingas_det','id_componente_concepto_ingas_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarUnidadComingdet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_comingdet_ime';
		$this->transaccion='PRO_UNCOM_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_comingdet','id_unidad_comingdet','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>