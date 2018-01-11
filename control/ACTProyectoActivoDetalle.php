<?php
/**
*@package pXP
*@file gen-ACTProyectoActivoDetalle.php
*@author  (admin)
*@date 10-10-2017 18:02:07
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProyectoActivoDetalle extends ACTbase{    
			
	function listarProyectoActivoDetalle(){
		$this->objParam->defecto('ordenacion','id_proyecto_activo_detalle');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto_activo')!=''){
			$this->objParam->addFiltro("pracde.id_proyecto_activo = ".$this->objParam->getParametro('id_proyecto_activo'));
		}
		if($this->objParam->getParametro('id_tipo_cc')!=''){
			$this->objParam->addFiltro("pracde.id_tipo_cc = ".$this->objParam->getParametro('id_tipo_cc'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoActivoDetalle','listarProyectoActivoDetalle');
		} else{
			$this->objFunc=$this->create('MODProyectoActivoDetalle');
			
			$this->res=$this->objFunc->listarProyectoActivoDetalle($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarProyectoActivoDetalle(){
		$this->objFunc=$this->create('MODProyectoActivoDetalle');	
		if($this->objParam->insertar('id_proyecto_activo_detalle')){
			$this->res=$this->objFunc->insertarProyectoActivoDetalle($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarProyectoActivoDetalle($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarProyectoActivoDetalle(){
		$this->objFunc=$this->create('MODProyectoActivoDetalle');	
		$this->res=$this->objFunc->eliminarProyectoActivoDetalle($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function obtenerCuentaSaldo(){
		$this->objFunc=$this->create('MODProyectoActivoDetalle');	
		$this->res=$this->objFunc->obtenerCuentaSaldo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>