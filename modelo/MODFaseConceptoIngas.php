<?php
/**
*@package pXP
*@file gen-MODFaseConceptoIngas.php
*@author  (admin)
*@date 24-05-2018 19:13:39
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODFaseConceptoIngas extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarFaseConceptoIngas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_concepto_ingas_sel';
		$this->transaccion='PRO_FACOING_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_fase_concepto_ingas','int4');
		$this->captura('id_fase','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_unidad_medida','int4');
		$this->captura('tipo_cambio_mt','numeric');
		$this->captura('descripcion','varchar');
		$this->captura('tipo_cambio_mb','numeric');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('cantidad_est','numeric');
		$this->captura('precio_mb','numeric');
		$this->captura('precio','numeric');
		$this->captura('precio_mt','numeric');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_ingas','varchar');
		$this->captura('tipo','varchar');
		$this->captura('desc_unidad_medida','varchar');
		
		$this->captura('codigo_fase','varchar');
		$this->captura('nombre_fase','varchar');
		
		$this->captura('id_proyecto','int4');
		
		$this->captura('tipo_nodo','varchar');
		
		
		$this->captura('precio_total','numeric');
		$this->captura('fecha_estimada','date');
		$this->captura('fecha_fin','date');
		
		$this->captura('estado_proyecto','varchar');
		
		$this->captura('id_funcionario','int4');
		$this->captura('desc_funcionario','varchar');		
		$this->captura('precio_real','numeric');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarFaseConceptoIngas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_concepto_ingas_ime';
		$this->transaccion='PRO_FACOING_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_unidad_medida','id_unidad_medida','int4');
		$this->setParametro('tipo_cambio_mt','tipo_cambio_mt','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('tipo_cambio_mb','tipo_cambio_mb','numeric');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('cantidad_est','cantidad_est','numeric');
		$this->setParametro('precio_mb','precio_mb','numeric');
		$this->setParametro('precio','precio','numeric');
		$this->setParametro('precio_mt','precio_mt','numeric');
		$this->setParametro('fecha_estimada','fecha_estimada','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');				
		$this->setParametro('precio_real','precio_real','numeric');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarFaseConceptoIngas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_concepto_ingas_ime';
		$this->transaccion='PRO_FACOING_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('id_unidad_medida','id_unidad_medida','int4');
		$this->setParametro('tipo_cambio_mt','tipo_cambio_mt','numeric');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('tipo_cambio_mb','tipo_cambio_mb','numeric');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('cantidad_est','cantidad_est','numeric');
		$this->setParametro('precio_mb','precio_mb','numeric');
		$this->setParametro('precio','precio','numeric');
		$this->setParametro('precio_mt','precio_mt','numeric');
		$this->setParametro('fecha_estimada','fecha_estimada','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');				
		$this->setParametro('precio_real','precio_real','numeric');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarFaseConceptoIngas(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_concepto_ingas_ime';
		$this->transaccion='PRO_FACOING_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
		function listarFaseConceptoIngasProgramado(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_concepto_ingas_sel';
		$this->transaccion='PRO_FACOINGPRO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_fase_concepto_ingas','int4');
		$this->captura('id_fase','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_unidad_medida','int4');
		$this->captura('tipo_cambio_mt','numeric');
		$this->captura('descripcion','varchar');
		$this->captura('tipo_cambio_mb','numeric');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('cantidad_est','numeric');
		$this->captura('precio_mb','numeric');
		$this->captura('precio','numeric');
		$this->captura('precio_mt','numeric');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_ingas','varchar');
		$this->captura('tipo','varchar');
		
		$this->captura('codigo_fase','varchar');
		$this->captura('nombre_fase','varchar');
		
		$this->captura('id_proyecto','int4');
	
		$this->captura('fecha_estimada','date');
	    $this->captura('id_invitacion_det','integer');
		$this->captura('dias','integer');
		$this->captura('estado_tiempo','varchar');
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>