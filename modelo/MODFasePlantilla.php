<?php
/**
*@package pXP
*@file gen-MODFasePlantilla.php
*@author  (rchumacero)
*@date 15-08-2018 13:05:07
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFasePlantilla extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarFasePlantilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_plantilla_sel';
		$this->transaccion='PRO_FASPLA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_fase_plantilla','int4');
		$this->captura('id_fase_plantilla_fk','int4');
		$this->captura('estado','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('observaciones','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarFasePlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_plantilla_ime';
		$this->transaccion='PRO_FASPLA_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase_plantilla_fk','id_fase_plantilla_fk','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('id_tipo_cc_plantilla','id_tipo_cc_plantilla','integer');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarFasePlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_plantilla_ime';
		$this->transaccion='PRO_FASPLA_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase_plantilla','id_fase_plantilla','int4');
		$this->setParametro('id_fase_plantilla_fk','id_fase_plantilla_fk','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('id_tipo_cc_plantilla','id_tipo_cc_plantilla','integer');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarFasePlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_plantilla_ime';
		$this->transaccion='PRO_FASPLA_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase_plantilla','id_fase_plantilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarFasePlantillaArb(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_plantilla_sel';
		$this->setCount(false);
		$this->transaccion='PRO_FAPLARB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_fase_plantilla','int4');
		$this->captura('id_fase_plantilla_fk','int4');
		$this->captura('id_tipo_cc_plantilla','int4');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('descripcion','varchar'); //borrar
		$this->captura('observaciones','varchar'); //borrar
		$this->captura('estado','varchar');
		$this->captura('codigo_tipo_cc','varchar');
		$this->captura('desc_tipo_cc','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tipo_nodo','varchar');
		$this->captura('checked','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>