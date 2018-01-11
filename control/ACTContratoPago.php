<?php
/**
*@package pXP
*@file gen-ACTContratoPago.php
*@author  (admin)
*@date 29-09-2017 17:05:48
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTContratoPago extends ACTbase{    
			
	function listarContratoPago(){
		$this->objParam->defecto('ordenacion','id_contrato_pago');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto_contrato')!=''){
			$this->objParam->addFiltro("conpag.id_proyecto_contrato = ".$this->objParam->getParametro('id_proyecto_contrato'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODContratoPago','listarContratoPago');
		} else{
			$this->objFunc=$this->create('MODContratoPago');
			
			$this->res=$this->objFunc->listarContratoPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarContratoPago(){
		$this->objFunc=$this->create('MODContratoPago');	
		if($this->objParam->insertar('id_contrato_pago')){
			$this->res=$this->objFunc->insertarContratoPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarContratoPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarContratoPago(){
			$this->objFunc=$this->create('MODContratoPago');	
		$this->res=$this->objFunc->eliminarContratoPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>