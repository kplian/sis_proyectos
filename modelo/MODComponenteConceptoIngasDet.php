<?php
/**
*@package pXP
*@file gen-MODComponenteConceptoIngasDet.php
*@author  (admin)
*@date 22-07-2019 14:50:29
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODComponenteConceptoIngasDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_sel';
		$this->transaccion='PRO_COMINDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_componente_concepto_ingas_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_concepto_ingas_det','int4');
		$this->captura('id_componente_concepto_ingas','int4');
		$this->captura('cantidad_est','numeric');
		$this->captura('precio','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_ingas_det','varchar');
        $this->captura('id_unidad_constructiva','int4');
        $this->captura('codigo_uc','varchar');
        $this->captura('desc_agrupador','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
		$this->transaccion='PRO_COMINDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_concepto_ingas_det','id_concepto_ingas_det','int4');
		$this->setParametro('id_componente_concepto_ingas','id_componente_concepto_ingas','int4');
		$this->setParametro('cantidad_est','cantidad_est','numeric');
		$this->setParametro('precio','precio','numeric');
        $this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
		$this->transaccion='PRO_COMINDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_componente_concepto_ingas_det','id_componente_concepto_ingas_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_concepto_ingas_det','id_concepto_ingas_det','int4');
		$this->setParametro('id_componente_concepto_ingas','id_componente_concepto_ingas','int4');
		$this->setParametro('cantidad_est','cantidad_est','numeric');
		$this->setParametro('precio','precio','numeric');
        $this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
		$this->transaccion='PRO_COMINDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_componente_concepto_ingas_det','id_componente_concepto_ingas_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>