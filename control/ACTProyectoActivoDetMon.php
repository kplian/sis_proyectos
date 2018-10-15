<?php
/**
*@package pXP
*@file gen-ACTProyectoActivoDetMon.php
*@author  (rchumacero)
*@date 05-10-2018 18:01:38
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProyectoActivoDetMon extends ACTbase{

	function listarProyectoActivoDetMon(){
		$this->objParam->defecto('ordenacion','id_proyecto_activo_det_mon');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto_activo')!=''){
			$this->objParam->addFiltro("adetm.id_proyecto_activo_detalle in (select id_proyecto_activo_detalle
																			from pro.tproyecto_activo_detalle
																			where id_proyecto_activo = ".$this->objParam->getParametro('id_proyecto_activo').")");
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoActivoDetMon','listarProyectoActivoDetMon');
		} else{
			$this->objFunc=$this->create('MODProyectoActivoDetMon');

			$this->res=$this->objFunc->listarProyectoActivoDetMon($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarProyectoActivoDetMon(){
		$this->objFunc=$this->create('MODProyectoActivoDetMon');
		if($this->objParam->insertar('id_proyecto_activo_det_mon')){
			$this->res=$this->objFunc->insertarProyectoActivoDetMon($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarProyectoActivoDetMon($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarProyectoActivoDetMon(){
			$this->objFunc=$this->create('MODProyectoActivoDetMon');
		$this->res=$this->objFunc->eliminarProyectoActivoDetMon($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>