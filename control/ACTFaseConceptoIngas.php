<?php
/**
*@package pXP
*@file gen-ACTFaseConceptoIngas.php
*@author  (admin)
*@date 24-05-2018 19:13:39
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFaseConceptoIngas extends ACTbase{    
			
	function listarFaseConceptoIngas(){
		$this->objParam->defecto('ordenacion','id_fase_concepto_ingas');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_fase')!=''){
			$this->objParam->addFiltro("facoing.id_fase = ".$this->objParam->getParametro('id_fase'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFaseConceptoIngas','listarFaseConceptoIngas');
		} else{
			$this->objFunc=$this->create('MODFaseConceptoIngas');
			
			$this->res=$this->objFunc->listarFaseConceptoIngas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFaseConceptoIngas(){
		$this->objFunc=$this->create('MODFaseConceptoIngas');	
		if($this->objParam->insertar('id_fase_concepto_ingas')){
			$this->res=$this->objFunc->insertarFaseConceptoIngas($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFaseConceptoIngas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFaseConceptoIngas(){
			$this->objFunc=$this->create('MODFaseConceptoIngas');	
		$this->res=$this->objFunc->eliminarFaseConceptoIngas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>