<?php
/**
*@package pXP
*@file gen-MODFase.php
*@author  (admin)
*@date 25-10-2017 13:16:54
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 	#5	  endeETR		09/01/2019	EGS				se agrego campos estado_lanzado y  dias_lanzado
 *  #15   ETR           31/07/2019	EGS             reporte Invitaciones 
 * 
 * 
 */

class MODReportePlanificacion extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarPlanificacionInicial (){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.f_reportes_planificacion_sel';
		$this->transaccion='PRO_PlAINI_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(FALSE);
		
		//Definicion de la lista del resultado del query
        $this->captura('agrupador','integer');
        $this->captura('es_agrupador','varchar');
        $this->captura('id_concepto_ingas','integer');
        $this->captura('desc_coingd','varchar');
        $this->captura('desc_unidad_medida','varchar');
        $this->captura('cantidad_est','numeric');
        $this->captura('f_desadeanizacion','numeric');
        $this->captura('precio','numeric');
        $this->captura('f_escala_xfd_montaje','numeric');
        $this->captura('precio_montaje','numeric');
        $this->captura('f_escala_xfd_obra_civil','numeric');
        $this->captura('precio_obra_civil','numeric');
        $this->captura('precio_prueba','numeric');
        $this->captura('total','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	
		
	
}
?>