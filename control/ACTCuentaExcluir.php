<?php
/**
*@package pXP
*@file ACTCuentaExcluir.php
*@author  (rchumacero)
*@date 06-01-2020 19:22:43
*@description Registro de las cuentas contables a excluir en el proceso de Cierre de Proyectos

***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 #51    PRO       ETR           06/01/2020  RCM         Creación del archivo
***************************************************************************

*/

class ACTCuentaExcluir extends ACTbase{

	function listarCuentaExcluir(){
		$this->objParam->defecto('ordenacion','id_cuenta_excluir');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODCuentaExcluir','listarCuentaExcluir');
		} else{
			$this->objFunc=$this->create('MODCuentaExcluir');

			$this->res=$this->objFunc->listarCuentaExcluir($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarCuentaExcluir(){
		$this->objFunc=$this->create('MODCuentaExcluir');
		if($this->objParam->insertar('id_cuenta_excluir')){
			$this->res=$this->objFunc->insertarCuentaExcluir($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarCuentaExcluir($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarCuentaExcluir(){
			$this->objFunc=$this->create('MODCuentaExcluir');
		$this->res=$this->objFunc->eliminarCuentaExcluir($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>