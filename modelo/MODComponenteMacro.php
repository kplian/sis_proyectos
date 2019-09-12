<?php
/**
*@package pXP
*@file gen-MODComponenteMacro.php
*@author  (admin)
*@date 22-07-2019 14:47:14
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 ISSUE       FECHA       AUTHOR          DESCRIPCION
 #26        12/09/2019      EGS          se agrega uc al componente macro
*/

class MODComponenteMacro extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarComponenteMacro(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_componente_macro_sel';
		$this->transaccion='PRO_COMPM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_componente_macro','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_proyecto','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('codigo','varchar');//#22
        $this->captura('componente_macro_tipo','varchar');//#22
        $this->captura('desc_componente_macro_tipo','varchar');//#22
        $this->captura('id_unidad_constructiva','int4');//26
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarComponenteMacro(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_macro_ime';
		$this->transaccion='PRO_COMPM_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
        $this->setParametro('codigo','codigo','varchar');//#22
        $this->setParametro('componente_macro_tipo','componente_macro_tipo','varchar');//#22

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarComponenteMacro(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_macro_ime';
		$this->transaccion='PRO_COMPM_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_componente_macro','id_componente_macro','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
        $this->setParametro('codigo','codigo','varchar');//#22
        $this->setParametro('componente_macro_tipo','componente_macro_tipo','varchar');//#22
        $this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarComponenteMacro(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_macro_ime';
		$this->transaccion='PRO_COMPM_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_componente_macro','id_componente_macro','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>