<?php
/**
*@package pXP
*@file gen-ACTInvitacion.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:20
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTInvitacion extends ACTbase{    
			
	function listarInvitacion(){
		$this->objParam->defecto('ordenacion','id_invitacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("ivt.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODInvitacion','listarInvitacion');
		} else{
			$this->objFunc=$this->create('MODInvitacion');
			
			$this->res=$this->objFunc->listarInvitacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarInvitacion(){
		$this->objFunc=$this->create('MODInvitacion');	
		if($this->objParam->insertar('id_invitacion')){
			$this->res=$this->objFunc->insertarInvitacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarInvitacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarInvitacion(){
			$this->objFunc=$this->create('MODInvitacion');	
		$this->res=$this->objFunc->eliminarInvitacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function siguienteEstado(){
        $this->objFunc=$this->create('MODInvitacion');  
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function anteriorEstado(){
        $this->objFunc=$this->create('MODInvitacion');  
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
			
}

?>