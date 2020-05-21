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
 *  #59                 21/05/2020  EGS             funciones para el Reporte  de ejecucion
 * 
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
		$this->captura('nivel','integer');		
		$this->captura('codigo','varchar');
		$this->captura('item','varchar');
		$this->captura('precio_estimado','numeric');
		$this->captura('precio_real','numeric');
		$this->captura('total_prorrateado','numeric');
		$this->captura('mes','integer');

		//Definicion de la lista dinámica de columnas
		$col_arrays = $this->objParam->getParametro('gestion');
		//var_dump($col_arrays);exit;
		
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
		$this->captura('id_nivel','integer');
		$this->captura('id_nivel_I','integer');
		$this->captura('id_nivel_II','integer');
		$this->captura('id_nivel_III','integer');		
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
	    //$this->captura('id_invitacion_det','integer');
		$this->captura('dias','integer');
		$this->captura('estado_tiempo','varchar');
		$this->captura('gestion_item','integer');
		$this->captura('mes_item','integer');
		$this->captura('desc_funcionario','varchar');
		$this->captura('estado_lanzado','varchar');//#5
		$this->captura('dias_lanzado','integer');//#5
		$this->captura('num_tramite','varchar');
		$this->captura('id_funcionario','integer');//#5
		$this->captura('id_invitacion_det','integer');//#5
		$this->captura('desc_ingas_invd','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		//var_dump($this->respuesta);exit;
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
 	
 	function listarReporteInvitacion(){ //#15
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.f_reportes_proyecto_sel';
		$this->transaccion='PRO_REPIVT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		$this->setParametro('id_tipo_estado','id_tipo_estado','varchar');
		//Definicion de la lista del resultado del query
		$this->captura('id_invitacion','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('codigo','varchar');
		$this->captura('fecha','date');
		$this->captura('descripcion','varchar');
		$this->captura('fecha_real','date');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_estado_wf','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');

		$this->captura('id_funcionario','int4');
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
		$this->captura('tipo','varchar');
		$this->captura('lugar_entrega','varchar');
		$this->captura('dias_plazo_entrega','int4');

		$this->captura('desc_moneda','varchar');
		$this->captura('desc_funcionario','varchar');
		$this->captura('desc_depto','varchar');
		$this->captura('id_proceso_wf','int4');
        $this->captura('anio','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('id_categoria_compra','int4');
		$this->captura('id_solicitud','int4');
		
		$this->captura('id_presolicitud','int4');
		$this->captura('pre_solicitud','varchar');
		$this->captura('id_grupo','int4');
		
		$this->captura('desc_categoria_compra','varchar');
		$this->captura('desc_grupo','varchar');
		

		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function listarRepCentrosCostoEjecucion(){//#59
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.f_reporte_cc_ejecucion_sel';
        $this->transaccion='PRO_REPCCEJEC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(FALSE);
        $this->setTipoRetorno('record');
        //var_dump('excel');
        $this->setParametro('id_proyecto','id_proyecto','int4');

        //Definicion de la lista del resultado del query
        $this->captura('gestion','integer');
        $this->captura('monto_mb','numeric');
        $this->captura('monto_anticipo ','numeric');
        $this->captura('monto_anticipo_mb ','numeric');
        $this->captura('monto_desc_anticipo ','numeric');
        $this->captura('monto_desc_anticipo_mb','numeric');
        $this->captura('desc_moneda_base','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump($this->respuesta);exit;
        return $this->respuesta;
    }
    function listarTotCentrosCostoEjecucion(){//#59
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.f_reporte_cc_ejecucion_sel';
        $this->transaccion='PRO_RETOTCC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(FALSE);
        $this->setTipoRetorno('record');
        //var_dump('excel');
        $this->setParametro('id_proyecto','id_proyecto','int4');

        //Definicion de la lista del resultado del query
        $this->captura('total_monto_mb','numeric');
        $this->captura('total_monto_anticipo ','numeric');
        $this->captura('total_monto_anticipo_mb ','numeric');
        $this->captura('total_monto_desc_anticipo ','numeric');
        $this->captura('total_monto_desc_anticipo_mb','numeric');
        $this->captura('desc_moneda_base','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump($this->respuesta);exit;
        return $this->respuesta;
    }
    function listarGesCentrosCostoPresupuestado(){  //#59
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.f_reporte_cc_ejecucion_sel';
        $this->transaccion='PRO_RECCGEST_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(FALSE);
        $this->setTipoRetorno('record');
        //var_dump('excel');
        $this->setParametro('id_proyecto','id_proyecto','int4');

        //Definicion de la lista del resultado del query
        $this->captura('gestion_monto_mb','numeric');
        $this->captura('gestion_monto_anticipo ','numeric');
        $this->captura('gestion_monto_anticipo_mb ','numeric');
        $this->captura('gestion_monto_desc_anticipo ','numeric');
        $this->captura('gestion_monto_desc_anticipo_mb','numeric');
        $this->captura('desc_moneda_base','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump($this->respuesta);exit;
        return $this->respuesta;
    }
	
		
	
}
?>