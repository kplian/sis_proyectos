<?php
/**
*@package pXP
*@file gen-MODProyectoColumnaTcc.php
*@author  (rchumacero)
*@date 17-09-2018 15:27:06
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProyectoColumnaTcc extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarProyectoColumnaTcc(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_columna_tcc_sel';
		$this->transaccion='PRO_COLTCC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto_columna_tcc','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_tipo_cc','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_cc','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarProyectoColumnaTcc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_columna_tcc_ime';
		$this->transaccion='PRO_COLTCC_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarProyectoColumnaTcc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_columna_tcc_ime';
		$this->transaccion='PRO_COLTCC_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_columna_tcc','id_proyecto_columna_tcc','int4');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarProyectoColumnaTcc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_columna_tcc_ime';
		$this->transaccion='PRO_COLTCC_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_columna_tcc','id_proyecto_columna_tcc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function importarProyectoColumnaTcc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_columna_tcc_ime';
		$this->transaccion='PRO_COLTCC_IMP';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('centro_costo','centro_costo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarColumnasProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_columna_tcc_ime';
		$this->transaccion='PRO_COLTCCIMP_DEL';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>