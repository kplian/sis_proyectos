<?php
/**
*@package pXP
*@file MODCuentaExcluir.php
*@author  (rchumacero)
*@date 06-01-2020 19:22:43
*@description Registro de las cuentas contables a excluir en el proceso de Cierre de Proyectos

***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 #51    PRO       ETR           06/01/2020  RCM         Creación del archivo
#MDID-9          ETR           30/03/2020  EGS         Se agrega tipo
***************************************************************************

*/

class MODCuentaExcluir extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarCuentaExcluir(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_cuenta_excluir_sel';
		$this->transaccion='PRO_CUNEXC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_cuenta_excluir','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nro_cuenta','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('tipo','varchar');//#MDID9

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarCuentaExcluir(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_cuenta_excluir_ime';
		$this->transaccion='PRO_CUNEXC_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
        $this->setParametro('tipo','tipo','varchar');//#MDID9

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarCuentaExcluir(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_cuenta_excluir_ime';
		$this->transaccion='PRO_CUNEXC_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_excluir','id_cuenta_excluir','int4');
		$this->setParametro('id_cuenta','id_cuenta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
        $this->setParametro('tipo','tipo','varchar');//#MDID9

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarCuentaExcluir(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_cuenta_excluir_ime';
		$this->transaccion='PRO_CUNEXC_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_cuenta_excluir','id_cuenta_excluir','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

}
?>