<?php
/**
*@package pXP
*@file gen-MODUnidadConstructivaTipo.php
*@author  (egutierrez)
*@date 18-09-2019 19:13:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				18-09-2019 19:13:12								CREACION

*/

class MODUnidadConstructivaTipo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarUnidadConstructivaTipo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_constructiva_tipo_sel';
		$this->transaccion='PRO_UCT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_constructiva_tipo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('componente_macro_tipo','varchar');
		$this->captura('tension','varchar');
		$this->captura('nombre','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('desc_componente_macro_tipo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarUnidadConstructivaTipo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_tipo_ime';
		$this->transaccion='PRO_UCT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('componente_macro_tipo','componente_macro_tipo','varchar');
		$this->setParametro('tension','tension','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarUnidadConstructivaTipo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_tipo_ime';
		$this->transaccion='PRO_UCT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva_tipo','id_unidad_constructiva_tipo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('componente_macro_tipo','componente_macro_tipo','varchar');
		$this->setParametro('tension','tension','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarUnidadConstructivaTipo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_tipo_ime';
		$this->transaccion='PRO_UCT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva_tipo','id_unidad_constructiva_tipo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarUnidadConstructivaTipoCombo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_unidad_constructiva_tipo_sel';
        $this->transaccion='PRO_UCTCB_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_unidad_constructiva_tipo','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('componente_macro_tipo','varchar');
        $this->captura('tension','varchar');
        $this->captura('desc_unidad_constructiva_tipo','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('desc_componente_macro_tipo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>