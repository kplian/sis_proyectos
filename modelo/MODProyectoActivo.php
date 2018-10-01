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

		$this->captura('desc_clasificacion','text');
		$this->captura('cantidad_det','numeric');
		$this->captura('id_depto','integer');
		$this->captura('estado','varchar');
		//$this->captura('id_lugar','integer');
		$this->captura('ubicacion','varchar');
		$this->captura('id_centro_costo','integer');
		$this->captura('id_ubicacion','integer');
		$this->captura('id_grupo','integer');
		$this->captura('id_grupo_clasif','integer');
		$this->captura('nro_serie','varchar');
		$this->captura('marca','varchar');
		$this->captura('fecha_ini_dep','date');
		$this->captura('codigo_depto','varchar');
		$this->captura('desc_tcc','text');
		$this->captura('desc_ubicacion','text');
		$this->captura('desc_grupo_ae','text');
		$this->captura('desc_clasif_ae','text');
		$this->captura('vida_util_anios','integer');
		$this->captura('id_unidad_medida','integer');
		$this->captura('codigo_af_rel','varchar');
		$this->captura('desc_unmed','varchar');

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
		$this->setParametro('cantidad_det','cantidad_det','numeric');
		$this->setParametro('id_depto','id_depto','integer');
		$this->setParametro('estado','estado','varchar');
		//$this->setParametro('id_lugar','id_lugar','integer');
		$this->setParametro('ubicacion','ubicacion','varchar');
		$this->setParametro('id_centro_costo','id_centro_costo','integer');
		$this->setParametro('id_ubicacion','id_ubicacion','integer');
		$this->setParametro('id_grupo','id_grupo','integer');
		$this->setParametro('id_grupo_clasif','id_grupo_clasif','integer');
		$this->setParametro('nro_serie','nro_serie','varchar');
		$this->setParametro('marca','marca','varchar');
		$this->setParametro('fecha_ini_dep','fecha_ini_dep','date');
		$this->setParametro('vida_util_anios','vida_util_anios','integer');
		$this->setParametro('id_unidad_medida','id_unidad_medida','integer');
		$this->setParametro('codigo_af_rel','codigo_af_rel','varchar');

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
		$this->setParametro('cantidad_det','cantidad_det','numeric');
		$this->setParametro('id_depto','id_depto','integer');
		$this->setParametro('estado','estado','varchar');
		//$this->setParametro('id_lugar','id_lugar','integer');
		$this->setParametro('ubicacion','ubicacion','varchar');
		$this->setParametro('id_centro_costo','id_centro_costo','integer');
		$this->setParametro('id_ubicacion','id_ubicacion','integer');
		$this->setParametro('id_grupo','id_grupo','integer');
		$this->setParametro('id_grupo_clasif','id_grupo_clasif','integer');
		$this->setParametro('nro_serie','nro_serie','varchar');
		$this->setParametro('marca','marca','varchar');
		$this->setParametro('fecha_ini_dep','fecha_ini_dep','date');
		$this->setParametro('vida_util_anios','vida_util_anios','integer');
		$this->setParametro('id_unidad_medida','id_unidad_medida','integer');
		$this->setParametro('codigo_af_rel','codigo_af_rel','varchar');

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

		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto','int4');
		$this->captura('id_proyecto_activo','int4');
		$this->captura('id_clasificacion','int4');
		$this->captura('denominacion','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('observaciones','varchar');
		$this->captura('desc_clasificacion','text');

		$this->captura('cantidad_det', 'numeric');
		$this->captura('id_depto', 'integer');
		$this->captura('estado', 'varchar');
		$this->captura('id_lugar', 'integer');
		$this->captura('ubicacion', 'varchar');
		$this->captura('id_centro_costo', 'integer');
		$this->captura('id_ubicacion', 'integer');
		$this->captura('id_grupo', 'integer');
		$this->captura('id_grupo_clasif', 'integer');
		$this->captura('nro_serie', 'varchar');
		$this->captura('marca', 'varchar');
		$this->captura('fecha_ini_dep', 'date');
		$this->captura('vida_util_anios', 'integer');
		$this->captura('id_unidad_medida', 'integer');
		$this->captura('codigo_af_rel', 'varchar');
		$this->captura('desc_depto', 'varchar');
		$this->captura('desc_centro_costo', 'varchar');
		$this->captura('desc_ubicacion', 'varchar');
		$this->captura('desc_grupo', 'varchar');
		$this->captura('desc_grupo_clasif', 'varchar');
		$this->captura('desc_unmed', 'varchar');

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

	function ImportarCierreValorado(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_ime';
		$this->transaccion='PRO_PRAF_XLS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','integer');
		$this->setParametro('item','item','integer');
		$this->setParametro('clasificacion','clasificacion','varchar');
		$this->setParametro('vida_util_anios','vida_util_anios','integer');
		$this->setParametro('nro_serie','nro_serie','varchar');
		$this->setParametro('marca','marca','varchar');
		$this->setParametro('denominacion','denominacion','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('cantidad_det','cantidad_det','numeric');
		$this->setParametro('unidad','unidad','varchar');
		$this->setParametro('ubicacion','ubicacion','varchar');
		$this->setParametro('local','local','varchar');
		$this->setParametro('fecha_compra','fecha_compra','date');
		$this->setParametro('costo','costo','numeric');
		$this->setParametro('valor_compra','valor_compra','numeric');
		$this->setParametro('moneda','moneda','varchar');
		$this->setParametro('fecha_ini_dep','fecha_ini_dep','date');
		$this->setParametro('grupo_ae','grupo_ae','varchar');
		$this->setParametro('clasificacion_ae','clasificacion_ae','varchar');
		$this->setParametro('centro_costo','centro_costo','varchar');
		$this->setParametro('codigo_activo','codigo_activo','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('codigo_activo_rel','codigo_activo_rel','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarProyectoActivosDetalle(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_ime';
		$this->transaccion='PRO_PRAFIMP_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function crearWFProyectoCierre(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_activo_ime';
		$this->transaccion='PRO_WFCIE_INS';
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