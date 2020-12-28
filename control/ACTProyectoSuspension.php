<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTProyectoSuspension.php
*@author  (egutierrez)
*@date 28-09-2020 19:25:30
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                28-09-2020 19:25:30    egutierrez             Creacion    
  #
*****************************************************************************************/

class ACTProyectoSuspension extends ACTbase{    
            
    function listarProyectoSuspension(){
		$this->objParam->defecto('ordenacion','id_proyecto_suspension');
        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("regsus.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProyectoSuspension','listarProyectoSuspension');
        } else{
        	$this->objFunc=$this->create('MODProyectoSuspension');
            
        	$this->res=$this->objFunc->listarProyectoSuspension($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarProyectoSuspension(){
        $this->objFunc=$this->create('MODProyectoSuspension');    
        if($this->objParam->insertar('id_proyecto_suspension')){
            $this->res=$this->objFunc->insertarProyectoSuspension($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarProyectoSuspension($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarProyectoSuspension(){
        	$this->objFunc=$this->create('MODProyectoSuspension');    
        $this->res=$this->objFunc->eliminarProyectoSuspension($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>