<?php
/**
*@package pXP
*@file gen-MODUnidadConstructiva.php
*@author  (egutierrez)
*@date 06-05-2019 14:16:09
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE		FORK		FECHA			AUTHOR				DESCRIPCION
 	 #16		ETR			01/08/2019		EGS					CREACION
*/

class MODUnidadConstructivaPlantilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarUnidadConstructivaPlantilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_constructiva_plantilla_sel';
		$this->transaccion='PRO_UNCONPL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_constructiva_plantilla','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_unidad_constructiva_plantilla_fk','int4');
		$this->captura('activo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarUnidadConstructivaPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_plantilla_ime';
		$this->transaccion='PRO_UNCONPL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_unidad_constructiva_plantilla_fk','id_unidad_constructiva_plantilla_fk','varchar');
		$this->setParametro('activo','activo','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarUnidadConstructivaPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_plantilla_ime';
		$this->transaccion='PRO_UNCONPL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva_plantilla','id_unidad_constructiva_plantilla','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_unidad_constructiva_plantilla_fk','id_unidad_constructiva_plantilla_fk','int4');
		$this->setParametro('activo','activo','varchar');



		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarUnidadConstructivaPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_plantilla_ime';
		$this->transaccion='PRO_UNCONPL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva_plantilla','id_unidad_constructiva_plantilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarUnidadConstructivaPlantillaArb(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_constructiva_plantilla_sel';
		$this->transaccion='PRO_UNCONPLARB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this-> setCount(false);
		
		$this->setParametro('node','node','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_constructiva_plantilla','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_unidad_constructiva_plantilla_fk','int4');
		$this->captura('tipo_nodo','varchar');
		$this->captura('activo','varchar');

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//var_dump('hola',$this->respuesta);exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
		
			
}
?>