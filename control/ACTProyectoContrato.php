<?php
/**
*@package pXP
*@file gen-ACTProyectoContrato.php
*@author  (admin)
*@date 29-09-2017 17:05:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProyectoContrato extends ACTbase{    
			
	function listarProyectoContrato(){
		$this->objParam->defecto('ordenacion','id_proyecto_contrato');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("procon.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoContrato','listarProyectoContrato');
		} else{
			$this->objFunc=$this->create('MODProyectoContrato');
			
			$this->res=$this->objFunc->listarProyectoContrato($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarProyectoContrato(){
		$this->objFunc=$this->create('MODProyectoContrato');	
		if($this->objParam->insertar('id_proyecto_contrato')){
			$this->res=$this->objFunc->insertarProyectoContrato($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarProyectoContrato($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarProyectoContrato(){
			$this->objFunc=$this->create('MODProyectoContrato');	
		$this->res=$this->objFunc->eliminarProyectoContrato($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>