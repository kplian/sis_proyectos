<?php
/**
*@package pXP
*@file gen-MODFaseConceptoIngasPago.php
*@author  (eddy.gutierrez)
*@date 14-12-2018 13:31:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 	#5	  endeETR		09/01/2019	EGS				Se agrego totalizadores de importe
 */

class MODFaseConceptoIngasPago extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFaseConceptoIngasPago(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_concepto_ingas_pago_sel';
		$this->transaccion='PRO_FACOINPA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->capturaCount('total_importe','numeric'); //#5
						
		//Definicion de la lista del resultado del query
		$this->captura('id_fase_concepto_ingas_pago','int4');
		$this->captura('id_fase_concepto_ingas','int4');
		$this->captura('importe','numeric');
		$this->captura('fecha_pago','date');
		$this->captura('fecha_pago_real','date');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('descripcion','varchar');//#
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFaseConceptoIngasPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_concepto_ingas_pago_ime';
		$this->transaccion='PRO_FACOINPA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('fecha_pago','fecha_pago','date');
		$this->setParametro('fecha_pago_real','fecha_pago_real','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');//#

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFaseConceptoIngasPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_concepto_ingas_pago_ime';
		$this->transaccion='PRO_FACOINPA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase_concepto_ingas_pago','id_fase_concepto_ingas_pago','int4');
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');
		$this->setParametro('importe','importe','numeric');
		$this->setParametro('fecha_pago','fecha_pago','date');
		$this->setParametro('fecha_pago_real','fecha_pago_real','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('descripcion','descripcion','varchar');//#

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFaseConceptoIngasPago(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_concepto_ingas_pago_ime';
		$this->transaccion='PRO_FACOINPA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase_concepto_ingas_pago','id_fase_concepto_ingas_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>