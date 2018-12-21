<?php
/**
*@package pXP
*@file gen-MODFase.php
*@author  (admin)
*@date 25-10-2017 13:16:54
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODReporte extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarGestionProyecto (){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.f_reportes_proyecto_sel';
		$this->transaccion='PRO_CUEPAGO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(FALSE);
		
		$this->setParametro('id_proyecto','id_proyecto','int4');
		
		//Definicion de la lista del resultado del query
		$this->captura('anio','integer');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
		function listarPlanPagoProyecto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.f_reportes_proyecto_sel';
		$this->transaccion='PRO_REPPAGO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(FALSE);
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');

		//Definicion de la lista del resultado del query
		$this->captura('id','int4');
		$this->captura('item','varchar');
		$this->captura('precio_estimado','numeric');
		$this->captura('mes','integer');

		//Definicion de la lista dinámica de columnas
		$col_arrays = $this->objParam->getParametro('gestion');
		for ($i=0; $i < count($col_arrays) ; $i++) {
			$this->captura('enero_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('febrero_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('marzo_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('abril_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('mayo_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('junio_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('julio_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('agosto_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('septiembre_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('octubre_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('noviembre_'.$col_arrays[$i]['anio'],'numeric');
			$this->captura('diciembre_'.$col_arrays[$i]['anio'],'numeric');			
		}	
		$this->captura('anio','integer');		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->respuesta);exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}		
	function listarLanzamientoFaseConceptoIngas(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.f_reportes_proyecto_sel';
		$this->transaccion='PRO_LANITEM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(FALSE);
				
		$this->setParametro('id_proyecto','id_proyecto','int4');
			
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
		$this->captura('gestion_item','integer');
		$this->captura('mes_item','integer');
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
function listarPresupuesto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.f_reportes_proyecto_sel';
		$this->transaccion='PRO_REPPRESU_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(FALSE);
				
		$this->setParametro('id_proyecto','id_proyecto','int4');
			
		//Definicion de la lista del resultado del query
		$this->captura('id','int4');
		$this->captura('id_padre','integer');
		$this->captura('id_item','integer');
		
		$this->captura('nombre_item','varchar');
		$this->captura('precio_item','numeric');
		$this->captura('codigo_item','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		//var_dump($this->respuesta);exit;
		return $this->respuesta;
	}
		
	
}
?>