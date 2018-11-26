<?php
/**
*@package pXP
*@file ACTGanttProyecto.php
*@author  (admin)
*@date 18-04-2013 09:01:51
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');

class ACTGanttProyecto extends ACTbase{    
			

	function listarGantPro(){
		$this->objParam->defecto('ordenacion','id_proceso_wf');
        $this->objParam->defecto('dir_ordenacion','asc');
		 
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODGanttProyecto','listarGanttPro');
		} else{
			$this->objFunc=$this->create('MODGanttProyecto');
			
			$this->res=$this->objFunc->listarGanttPro($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    
	function diagramaGanttTramite_kendo(){
					
				$dataSource = new DataSource();
			    //$idSolicitud = $this->objParam->getParametro('nro_tramite');
			    //$this->objParam->addParametroConsulta('id_plan_mant',$idPlanMant);
			    $this->objParam->addParametroConsulta('ordenacion','nro_tramite');
			    $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
			    $this->objParam->addParametroConsulta('cantidad',1000);
			    $this->objParam->addParametroConsulta('puntero',0);
			    
			    $this->objFunc = $this->create('MODGanttProyecto');
				
				
			    
			    $resultSolicitud = $this->objFunc->listarGanttPro();
				
				
			    
                        
               $resultSolicitud->imprimirRespuesta($resultSolicitud->generarJson());
                
		}
	//////////////EGS//////////////////////
	function diagramaGanttJS(){
					
				$dataSource = new DataSource();
			    //$idSolicitud = $this->objParam->getParametro('nro_tramite');
			    //$this->objParam->addParametroConsulta('id_plan_mant',$idPlanMant);
			    $this->objParam->addParametroConsulta('ordenacion','nro_tramite');
			    $this->objParam->addParametroConsulta('dir_ordenacion','ASC');
			    $this->objParam->addParametroConsulta('cantidad',1000);
			    $this->objParam->addParametroConsulta('puntero',0);
			    
			
				
			    $this->objFunc = $this->create('MODGanttProyecto');
				
				
			    $resultSolicitud = $this->objFunc->listarGanttPro();
				
                $resultSolicitud->imprimirRespuesta($resultSolicitud->generarJson());
                
		}
	//////////////EGS//////////////////////
			
}

?>