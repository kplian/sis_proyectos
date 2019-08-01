<?php
/**
*@package pXP
*@file gen-ACTComponenteConceptoIngasDet.php
*@author  (admin)
*@date 22-07-2019 14:50:29
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTComponenteConceptoIngasDet extends ACTbase{    
			
	function listarComponenteConceptoIngasDet(){
		$this->objParam->defecto('ordenacion','id_componente_concepto_ingas_det');
        if($this->objParam->getParametro('id_componente_concepto_ingas')!='' ){
            $this->objParam->addFiltro("comindet.id_componente_concepto_ingas = ".$this->objParam->getParametro('id_componente_concepto_ingas'));
        }
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODComponenteConceptoIngasDet','listarComponenteConceptoIngasDet');
		} else{
			$this->objFunc=$this->create('MODComponenteConceptoIngasDet');
			
			$this->res=$this->objFunc->listarComponenteConceptoIngasDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarComponenteConceptoIngasDet(){
		$this->objFunc=$this->create('MODComponenteConceptoIngasDet');	
		if($this->objParam->insertar('id_componente_concepto_ingas_det')){
			$this->res=$this->objFunc->insertarComponenteConceptoIngasDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarComponenteConceptoIngasDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarComponenteConceptoIngasDet(){
			$this->objFunc=$this->create('MODComponenteConceptoIngasDet');	
		$this->res=$this->objFunc->eliminarComponenteConceptoIngasDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>