<?php
/**
*@package pXP
*@file gen-ACTProyectoColumnaTcc.php
*@author  (rchumacero)
*@date 17-09-2018 15:27:06
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProyectoColumnaTcc extends ACTbase{

	function listarProyectoColumnaTcc(){
		//$this->objParam->defecto('ordenacion','coltcc.id_tipo_cco');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("coltcc.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoColumnaTcc','listarProyectoColumnaTcc');
		} else{
			$this->objFunc=$this->create('MODProyectoColumnaTcc');

			$this->res=$this->objFunc->listarProyectoColumnaTcc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarProyectoColumnaTcc(){
		$this->objFunc=$this->create('MODProyectoColumnaTcc');
		if($this->objParam->insertar('id_proyecto_columna_tcc')){
			$this->res=$this->objFunc->insertarProyectoColumnaTcc($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarProyectoColumnaTcc($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarProyectoColumnaTcc(){
			$this->objFunc=$this->create('MODProyectoColumnaTcc');
		$this->res=$this->objFunc->eliminarProyectoColumnaTcc($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarColumnasProyecto(){
		$this->objFunc=$this->create('MODProyectoColumnaTcc');
		$this->res=$this->objFunc->eliminarColumnasProyecto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>