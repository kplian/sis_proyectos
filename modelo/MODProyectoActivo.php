<?php
/**
*@package pXP
*@file gen-MODProyectoActivo.php
*@author  (admin)
*@date 31-08-2017 16:52:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProyectoActivo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProyectoActivo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_activo_sel';
		$this->transaccion='PRO_PRAF_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto_activo','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('observaciones','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('denominacion','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('id_clasificacion','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
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
			
	function insertarProyectoActivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_ime';
		$this->transaccion='PRO_PRAF_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('denominacion','denominacion','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_clasificacion','id_clasificacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarProyectoActivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_ime';
		$this->transaccion='PRO_PRAF_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo','id_proyecto_activo','int4');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('denominacion','denominacion','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('id_clasificacion','id_clasificacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProyectoActivo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_ime';
		$this->transaccion='PRO_PRAF_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proyecto_activo','id_proyecto_activo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarProyectoActivoTablaDatos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_activo_sel';
		$this->transaccion='PRO_PRAFTAB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('id_proyecto_ep','id_proyecto_ep','int4');

		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto','int4');
		$this->captura('id_proyecto_activo','int4');
		$this->captura('id_clasificacion','int4');
		$this->captura('denominacion','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('observaciones','varchar');
		$this->captura('desc_clasificacion','text');
		$this->captura('costo','numeric');

		//Definicion de la lista dinámica de columnas
		$col_arrays = $this->objParam->getParametro('columnas_dinamicas');
		for ($i=0; $i < count($col_arrays) ; $i++) { 
			$col = 'cc_'.$col_arrays[$i]['id_tipo_cc'];
			$this->captura($col,'numeric');
		}
				
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarProyectoActivoTablaDatosTotales(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_activo_sel';
		$this->transaccion='PRO_PRAFTOT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('id_proyecto_ep','id_proyecto_ep','int4');

		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto_activo','int4');
		$this->captura('total','numeric');

		//Definicion de la lista dinámica de columnas
		$col_arrays = $this->objParam->getParametro('columnas_dinamicas');
		for ($i=0; $i < count($col_arrays) ; $i++) { 
			$col = 'cc_'.$col_arrays[$i]['id_tipo_cc'];
			$this->captura($col,'numeric');
		}
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>