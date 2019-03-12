<?php
/**
*@package pXP
*@file gen-ACTInvitacion.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:20
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 	ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 	#5	  endeETR		09/01/2019	EGS				Se agrego parametros por defecto
    #7	  endeETR		29/01/2019	EGS				se creo las funciones para listar combos procesos de solicitudes de compra y sus detalles e insertar una invitacion regularizada  
*/

class ACTInvitacion extends ACTbase{    
			
	function listarInvitacion(){
		$this->objParam->defecto('ordenacion','id_invitacion');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->defecto('cantidad',1000000);#5
		$this->objParam->defecto('puntero', 0);#5
		
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("ivt.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));	
		}
		if($this->objParam->getParametro('id_grupo')!=''){
			$this->objParam->addFiltro("ivt.id_grupo = ".$this->objParam->getParametro('id_grupo'));	
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
	function listarSolicituCompraCombo(){ //#7
		$this->objParam->defecto('ordenacion','id_solicitud');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->defecto('cantidad',1000000);
		$this->objParam->defecto('puntero', 0);
		
		//var_dump($this->objParam);exit;
		$this->objFunc=$this->create('MODInvitacion');
			
		$this->res=$this->objFunc->listarSolicituCompraCombo($this->objParam);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}	
	function listarSolicituCompraDetCombo(){//#7
		$this->objParam->defecto('ordenacion','id_solicitud_det');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->defecto('cantidad',1000000);
		$this->objParam->defecto('puntero', 0);
		
		if($this->objParam->getParametro('id_solicitud')!=''){
			$this->objParam->addFiltro("sold.id_solicitud = ".$this->objParam->getParametro('id_solicitud'));	
		}
		
		//var_dump($this->objParam);exit;
		$this->objFunc=$this->create('MODInvitacion');
			
		$this->res=$this->objFunc->listarSolicituCompraDetCombo($this->objParam);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function invitacionRegularizada(){//#7
		
		$this->objParam->addParametro('p_id_usuario',$_SESSION["ss_id_usuario"]);
		
		$this->objFunc=$this->create('MODInvitacion');	
	
		$this->res=$this->objFunc->invitacionRegularizada($this->objParam);			
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
		
			
}

?>