<?php
/**
*@package pXP
*@file gen-ACTComponenteMacro.php
*@author  (admin)
*@date 22-07-2019 14:47:14
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTComponenteMacro extends ACTbase{    
			
	function listarComponenteMacro(){
		$this->objParam->defecto('ordenacion','id_componente_macro');
        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("compm.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODComponenteMacro','listarComponenteMacro');
		} else{
			$this->objFunc=$this->create('MODComponenteMacro');
			
			$this->res=$this->objFunc->listarComponenteMacro($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarComponenteMacro(){
		$this->objFunc=$this->create('MODComponenteMacro');	
		if($this->objParam->insertar('id_componente_macro')){
			$this->res=$this->objFunc->insertarComponenteMacro($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarComponenteMacro($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarComponenteMacro(){
			$this->objFunc=$this->create('MODComponenteMacro');	
		$this->res=$this->objFunc->eliminarComponenteMacro($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>