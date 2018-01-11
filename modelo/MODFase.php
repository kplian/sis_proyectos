<?php
/**
*@package pXP
*@file gen-MODFase.php
*@author  (admin)
*@date 25-10-2017 13:16:54
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFase extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFase(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_sel';
		$this->transaccion='PRO_FASE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_fase','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('id_fase_fk','int4');
		$this->captura('descripcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('estado','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('observaciones','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFase(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_ime';
		$this->transaccion='PRO_FASE_INS';
		$this->tipo_procedimiento='IME';
		
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('id_fase_fk','id_fase_fk','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('observaciones','observaciones','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
				//echo 'CCCCCCCCC: '.$this->armarConsulta;exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFase(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_ime';
		$this->transaccion='PRO_FASE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('id_fase_fk','id_fase_fk','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('observaciones','observaciones','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFase(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_ime';
		$this->transaccion='PRO_FASE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase','id_fase','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarFasesArb(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_sel';
		$this-> setCount(false);
		$this->transaccion='PRO_FASEARB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('node','node','varchar'); 

		//Definicion de la lista del resultado del query
		$this->captura('id_fase','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('id_fase_fk','int4');
		$this->captura('descripcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('estado','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('observaciones','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tipo_nodo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		return $this->respuesta;       
    }
			
}
?>