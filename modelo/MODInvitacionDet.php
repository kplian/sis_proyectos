<?php
/**
*@package pXP
*@file gen-MODInvitacionDet.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:59
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODInvitacionDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarInvitacionDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_invitacion_det_sel';
		$this->transaccion='PRO_IVTD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_invitacion_det','int4');
		$this->captura('id_fase_concepto_ingas','int4');
		$this->captura('id_invitacion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('observaciones','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		
		$this->captura('cantidad_sol','numeric');
		$this->captura('id_unidad_medida','int4');
		$this->captura('precio','numeric');
		
		$this->captura('desc_fase','text');
		$this->captura('desc_ingas','text');
		$this->captura('cantidad_est','numeric');
		$this->captura('precio_est','numeric');
		
		$this->captura('id_centro_costo','int4');
		$this->captura('descripcion','text');
		$this->captura('codigo_cc','varchar');
		
		//$this->captura('desc_unidad_medida','varchar');
		
		//$this->captura('desc_ingas','varchar');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarInvitacionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_invitacion_det_ime';
		$this->transaccion='PRO_IVTD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');
		$this->setParametro('id_invitacion','id_invitacion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		
		$this->setParametro('cantidad_sol','cantidad_sol','numeric');
		$this->setParametro('id_unidad_medida','id_unidad_medida','int4');
		$this->setParametro('precio','precio','numeric');
		
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarInvitacionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_invitacion_det_ime';
		$this->transaccion='PRO_IVTD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_invitacion_det','id_invitacion_det','int4');
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');
		$this->setParametro('id_invitacion','id_invitacion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		
		$this->setParametro('cantidad_sol','cantidad_sol','numeric');
		$this->setParametro('id_unidad_medida','id_unidad_medida','int4');
		$this->setParametro('precio','precio','numeric');

		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('descripcion','descripcion','text');
		
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('id_concepto_inga','id_concepto_ingas','int4');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarInvitacionDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_invitacion_det_ime';
		$this->transaccion='PRO_IVTD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_invitacion_det','id_invitacion_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>