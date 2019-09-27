<?php
/**
*@package pXP
*@file gen-ACTUnidadConstructivaTipo.php
*@author  (egutierrez)
*@date 18-09-2019 19:13:12
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				18-09-2019 19:13:12								CREACION

*/

class ACTUnidadConstructivaTipo extends ACTbase{    
			
	function listarUnidadConstructivaTipo(){
		$this->objParam->defecto('ordenacion','id_unidad_constructiva_tipo');
        if($this->objParam->getParametro('componente_macro_tipo')!=''){
            $this->objParam->addFiltro("uct.componente_macro_tipo = ''".$this->objParam->getParametro('componente_macro_tipo')."''");
        }
        if($this->objParam->getParametro('tension')!=''){
            $this->objParam->addFiltro("(uct.tension = ''".$this->objParam->getParametro('tension')."'' or uct.tension is null )");
        }
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODUnidadConstructivaTipo','listarUnidadConstructivaTipo');
		} else{
			$this->objFunc=$this->create('MODUnidadConstructivaTipo');
			
			$this->res=$this->objFunc->listarUnidadConstructivaTipo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarUnidadConstructivaTipo(){
		$this->objFunc=$this->create('MODUnidadConstructivaTipo');	
		if($this->objParam->insertar('id_unidad_constructiva_tipo')){
			$this->res=$this->objFunc->insertarUnidadConstructivaTipo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarUnidadConstructivaTipo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarUnidadConstructivaTipo(){
			$this->objFunc=$this->create('MODUnidadConstructivaTipo');	
		$this->res=$this->objFunc->eliminarUnidadConstructivaTipo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>