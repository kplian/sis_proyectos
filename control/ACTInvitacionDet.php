<?php
/**
*@package pXP
*@file gen-ACTInvitacionDet.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:59
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTInvitacionDet extends ACTbase{    
			
	function listarInvitacionDet(){
		$this->objParam->defecto('ordenacion','id_invitacion_det');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_invitacion')!=''){
			$this->objParam->addFiltro("ivtd.id_invitacion = ".$this->objParam->getParametro('id_invitacion'));	
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODInvitacionDet','listarInvitacionDet');
		} else{
			$this->objFunc=$this->create('MODInvitacionDet');
			
			$this->res=$this->objFunc->listarInvitacionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarInvitacionDet(){
		$this->objFunc=$this->create('MODInvitacionDet');	
		if($this->objParam->insertar('id_invitacion_det')){
			$this->res=$this->objFunc->insertarInvitacionDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarInvitacionDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarInvitacionDet(){
			$this->objFunc=$this->create('MODInvitacionDet');	
		$this->res=$this->objFunc->eliminarInvitacionDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>