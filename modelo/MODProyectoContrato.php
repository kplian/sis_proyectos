<?php
/**
*@package pXP
*@file gen-MODProyectoContrato.php
*@author  (admin)
*@date 29-09-2017 17:05:43
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
    ISSUE       FECHA       AUTHOR          DESCRIPCION
 *  #MDID-2     28/09/2020  EGS             Se agrgan los capos de fecha_orden_proceder,plazo_dias,monto_anticipo,observaciones
 */

class MODProyectoContrato extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProyectoContrato(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_contrato_sel';
		$this->transaccion='PRO_PROCON_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto_contrato','int4');
		$this->captura('nro_contrato','varchar');
		$this->captura('nombre','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('monto_total','numeric');
		$this->captura('fecha_ini','date');
		$this->captura('id_proyecto','int4');
		$this->captura('cantidad_meses','int4');
		$this->captura('fecha_fin','date');
		$this->captura('tipo_pagos','varchar');
		$this->captura('resumen','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_proveedor','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_proveedor','varchar');
		$this->captura('moneda','varchar');
        $this->captura('fecha_orden_proceder','date');//#MDID-2
        $this->captura('plazo_dias','integer');//#MDID-2
        $this->captura('monto_anticipo','numeric');//#MDID-2
        $this->captura('observaciones','varchar');//#MDID-2
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarProyectoContrato(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_contrato_ime';
		$this->transaccion='PRO_PROCON_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('nro_contrato','nro_contrato','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('monto_total','monto_total','numeric');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('cantidad_meses','cantidad_meses','int4');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('tipo_pagos','tipo_pagos','varchar');
		$this->setParametro('resumen','resumen','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('fecha_orden_proceder','fecha_orden_proceder','date');//#MDID-2
        $this->setParametro('plazo_dias','plazo_dias','integer');//#MDID-2
        $this->setParametro('monto_anticipo','monto_anticipo','numeric');//#MDID-2
        $this->setParametro('observaciones','observaciones','varchar');//#MDID-2

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarProyectoContrato(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_contrato_ime';
		$this->transaccion='PRO_PROCON_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_contrato','id_proyecto_contrato','int4');
		$this->setParametro('nro_contrato','nro_contrato','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('monto_total','monto_total','numeric');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('cantidad_meses','cantidad_meses','int4');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('tipo_pagos','tipo_pagos','varchar');
		$this->setParametro('resumen','resumen','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('fecha_orden_proceder','fecha_orden_proceder','date');//#MDID-2
        $this->setParametro('plazo_dias','plazo_dias','integer');//#MDID-2
        $this->setParametro('monto_anticipo','monto_anticipo','numeric');//#MDID-2
        $this->setParametro('observaciones','observaciones','varchar');//#MDID-2

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProyectoContrato(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_contrato_ime';
		$this->transaccion='PRO_PROCON_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_contrato','id_proyecto_contrato','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>