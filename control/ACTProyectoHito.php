<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTProyectoHito.php
*@author  (egutierrez)
*@date 28-09-2020 20:15:06
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                28-09-2020 20:15:06    egutierrez             Creacion    
  #MDID-12              16/10/2020          EGS                   Se agrega funciones de memoria 
*****************************************************************************************/

class ACTProyectoHito extends ACTbase{    
            
    function listarProyectoHito(){
		$this->objParam->defecto('ordenacion','id_proyecto_hito');
        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("prohit.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProyectoHito','listarProyectoHito');
        } else{
        	$this->objFunc=$this->create('MODProyectoHito');
            
        	$this->res=$this->objFunc->listarProyectoHito($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarProyectoHito(){
        $this->objFunc=$this->create('MODProyectoHito');    
        if($this->objParam->insertar('id_proyecto_hito')){
            $this->res=$this->objFunc->insertarProyectoHito($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarProyectoHito($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarProyectoHito(){
        	$this->objFunc=$this->create('MODProyectoHito');    
        $this->res=$this->objFunc->eliminarProyectoHito($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarProyectoHitoMemoria(){//#MDID-12
        $this->objParam->defecto('ordenacion','id_proyecto_hito');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProyectoHito','listarProyectoHitoMemoria');
        } else {
            $this->objFunc = $this->create('MODProyectoHito');
            $this->res = $this->objFunc->listarProyectoHitoMemoria($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarProyectoHitoCodigo(){//#MDID-12
        $this->objParam->defecto('ordenacion','codigo');
        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("prohit.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        $this->objFunc=$this->create('MODProyectoHito');
        $this->res=$this->objFunc->listarProyectoHitoCodigo($this->objParam);

        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>