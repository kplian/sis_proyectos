<?php
/**
*@package pXP
*@file gen-ACTUnidadComingdet.php
*@author  (egutierrez)
*@date 08-08-2019 15:05:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTUnidadComingdet extends ACTbase{    
			
	function listarUnidadComingdet(){
		$this->objParam->defecto('ordenacion','id_unidad_comingdet');

		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_componente_concepto_ingas_det')!='' ){
            $this->objParam->addFiltro("uncom.id_componente_concepto_ingas_det = ".$this->objParam->getParametro('id_componente_concepto_ingas_det'));
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODUnidadComingdet','listarUnidadComingdet');
		} else{
			$this->objFunc=$this->create('MODUnidadComingdet');
			
			$this->res=$this->objFunc->listarUnidadComingdet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarUnidadComingdet(){
		$this->objFunc=$this->create('MODUnidadComingdet');	
		if($this->objParam->insertar('id_unidad_comingdet')){
			$this->res=$this->objFunc->insertarUnidadComingdet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarUnidadComingdet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarUnidadComingdet(){
			$this->objFunc=$this->create('MODUnidadComingdet');	
		$this->res=$this->objFunc->eliminarUnidadComingdet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>