<?php
/**
*@package pXP
*@file gen-MODUnidadConstructiva.php
*@author  (egutierrez)
*@date 06-05-2019 14:16:09
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE		FORK		FECHA			AUTHOR				DESCRIPCION
 	 #16		ETR			01/08/2019		EGS					CREACION
 *  #26         ETR          12/09/2019     EGS                 se agrego combo de ucm
 */

class MODUnidadConstructiva extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarUnidadConstructiva(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_constructiva_sel';
		$this->transaccion='PRO_UNCON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_constructiva','int4');
		$this->captura('id_proyecto','int4');
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
		$this->captura('id_unidad_constructiva_fk','int4');
		$this->captura('activo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarUnidadConstructiva(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_ime';
		$this->transaccion='PRO_UNCON_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_unidad_constructiva_fk','id_unidad_constructiva_fk','varchar');
		$this->setParametro('activo','activo','varchar');
        $this->setParametro('id_unidad_constructiva_tipo','id_unidad_constructiva_tipo','int4');
        $this->setParametro('tipo_configuracion','tipo_configuracion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarUnidadConstructiva(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_ime';
		$this->transaccion='PRO_UNCON_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_unidad_constructiva_fk','id_unidad_constructiva_fk','int4');
		$this->setParametro('activo','activo','varchar');
        $this->setParametro('id_unidad_constructiva_tipo','id_unidad_constructiva_tipo','int4');
        $this->setParametro('tipo_configuracion','tipo_configuracion','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarUnidadConstructiva(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_ime';
		$this->transaccion='PRO_UNCON_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarUnidadConstructivaArb(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_constructiva_sel';
		$this->transaccion='PRO_UNCONARB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this-> setCount(false);
		
		$this->setParametro('node','node','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_constructiva','int4');
		$this->captura('id_proyecto','int4');
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
		$this->captura('id_unidad_constructiva_fk','int4');
		$this->captura('tipo_nodo','varchar');
		$this->captura('activo','varchar');
        $this->captura('id_unidad_constructiva_tipo','int4');
        $this->captura('desc_unidad_constructiva_tipo','varchar');
        $this->captura('tipo_configuracion','varchar');
        $this->captura('desc_tipo_configuracion','varchar');
        $this->captura('tension','varchar');
        $this->captura('desc_componente_macro_tipo','varchar');

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	function agregarPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_ime';
		$this->transaccion='PRO_UNCONAP_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');
		$this->setParametro('id_unidad_constructiva_plantilla','id_unidad_constructiva_plantilla','int4');
		$this->setParametro('id_proyecto','id_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->getConsulta();
		//exit;


		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	function deleteArbol(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_unidad_constructiva_ime';
		$this->transaccion='PRO_UNCDELARB_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarConceptoingasUcCombo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_constructiva_sel';
		$this->transaccion='PRO_CONINGASUC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		//$this->setCount(false);		
		//Definicion de la lista del resultado del query
		$this->captura('id_concepto_ingas','int4');
		$this->captura('desc_ingas','varchar');
		$this->captura('tipo','varchar');

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarConceptoingasDetUcCombo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_unidad_constructiva_sel';
		$this->transaccion='PRO_COINDETUC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		//$this->setCount(false);
		
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_unidad_constructiva','int4');
		$this->captura('codigo','varchar');
		$this->captura('desc_ingas','varchar');
		$this->captura('id_proyecto','int4');
		$this->captura('activo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function listarUnidadConstructivaMacroHijos(){//#26
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_unidad_constructiva_sel';
        $this->transaccion='PRO_UNCONMH_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_unidad_constructiva_macro','id_unidad_constructiva_macro','int4');
        //Definicion de la lista del resultado del query
        $this->captura('id_unidad_constructiva','int4');
        $this->captura('id_proyecto','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('nombre','varchar');
        $this->captura('codigo','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('id_unidad_constructiva_fk','int4');
        $this->captura('activo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function ListarUnidadConstructivaMacro(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_unidad_constructiva_sel';
        $this->transaccion='PRO_UNCONMA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_unidad_constructiva_hijo','id_unidad_constructiva_hijo','int4');
        //Definicion de la lista del resultado del query
        $this->captura('id_unidad_constructiva','int4');
            //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
			
}
?>