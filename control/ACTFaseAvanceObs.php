<?php
/**
*@package pXP
*@file gen-ACTFaseAvanceObs.php
*@author  (rchumacero)
*@date 15-10-2018 19:59:14
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTFaseAvanceObs extends ACTbase{

	function listarFaseAvanceObs(){
		$this->objParam->defecto('ordenacion','id_fase_avance_obs');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_fase')!=''){
			$this->objParam->addFiltro("fao.id_fase = ".$this->objParam->getParametro('id_fase'));
		}

		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("fao.id_fase is null and fao.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}

		if($this->objParam->getParametro('tipo')!=''){
			$this->objParam->addFiltro("fao.tipo = ''".$this->objParam->getParametro('tipo')."''");
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFaseAvanceObs','listarFaseAvanceObs');
		} else{
			$this->objFunc=$this->create('MODFaseAvanceObs');

			$this->res=$this->objFunc->listarFaseAvanceObs($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarFaseAvanceObs(){
		$this->objFunc=$this->create('MODFaseAvanceObs');
		if($this->objParam->insertar('id_fase_avance_obs')){
			$this->res=$this->objFunc->insertarFaseAvanceObs($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarFaseAvanceObs($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarFaseAvanceObs(){
			$this->objFunc=$this->create('MODFaseAvanceObs');
		$this->res=$this->objFunc->eliminarFaseAvanceObs($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>