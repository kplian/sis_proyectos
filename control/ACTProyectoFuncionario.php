<?php
/**
*@package pXP
*@file gen-ACTProyectoFuncionario.php
*@author  (admin)
*@date 28-09-2017 20:12:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProyectoFuncionario extends ACTbase{    
			
	function listarProyectoFuncionario(){
		$this->objParam->defecto('ordenacion','id_proyecto_funcionario');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("proyfu.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoFuncionario','listarProyectoFuncionario');
		} else{
			$this->objFunc=$this->create('MODProyectoFuncionario');
			
			$this->res=$this->objFunc->listarProyectoFuncionario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarProyectoFuncionario(){
		$this->objFunc=$this->create('MODProyectoFuncionario');	
		if($this->objParam->insertar('id_proyecto_funcionario')){
			$this->res=$this->objFunc->insertarProyectoFuncionario($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarProyectoFuncionario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarProyectoFuncionario(){
			$this->objFunc=$this->create('MODProyectoFuncionario');	
		$this->res=$this->objFunc->eliminarProyectoFuncionario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>