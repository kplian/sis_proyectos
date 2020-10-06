<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTProyectoAnalisis.php
*@author  (egutierrez)
*@date 29-09-2020 12:44:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                29-09-2020 12:44:10    egutierrez             Creacion    
  #
*****************************************************************************************/

class ACTProyectoAnalisis extends ACTbase{    
            
    function listarProyectoAnalisis(){
		$this->objParam->defecto('ordenacion','id_proyecto_analisis');
        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("proana.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }

        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProyectoAnalisis','listarProyectoAnalisis');
        } else{
        	$this->objFunc=$this->create('MODProyectoAnalisis');
            
        	$this->res=$this->objFunc->listarProyectoAnalisis($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarProyectoAnalisis(){
        $this->objFunc=$this->create('MODProyectoAnalisis');    
        if($this->objParam->insertar('id_proyecto_analisis')){
            $this->res=$this->objFunc->insertarProyectoAnalisis($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarProyectoAnalisis($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarProyectoAnalisis(){
        	$this->objFunc=$this->create('MODProyectoAnalisis');    
        $this->res=$this->objFunc->eliminarProyectoAnalisis($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarProyectoProveedor(){
        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("proana.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        $this->objFunc=$this->create('MODProyectoAnalisis');
        $this->res=$this->objFunc->listarProyectoProveedor($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>