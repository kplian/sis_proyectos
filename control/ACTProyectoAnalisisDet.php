<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTProyectoAnalisisDet.php
*@author  (egutierrez)
*@date 29-09-2020 12:44:12
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                29-09-2020 12:44:12    egutierrez             Creacion    
  #
*****************************************************************************************/

class ACTProyectoAnalisisDet extends ACTbase{    
            
    function listarProyectoAnalisisDet(){
		$this->objParam->defecto('ordenacion','id_proyecto_analisis_det');
        if($this->objParam->getParametro('id_proyecto_analisis')!=''){
            $this->objParam->addFiltro("proanade.id_proyecto_analisis = ".$this->objParam->getParametro('id_proyecto_analisis'));
        }
        if($this->objParam->getParametro('tipo_cuenta')!=''){
            $this->objParam->addFiltro("cue.tipo_cuenta = ''".$this->objParam->getParametro('tipo_cuenta')."''");
        }
        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProyectoAnalisisDet','listarProyectoAnalisisDet');
        } else{
        	$this->objFunc=$this->create('MODProyectoAnalisisDet');
            
        	$this->res=$this->objFunc->listarProyectoAnalisisDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarProyectoAnalisisDet(){
        $this->objFunc=$this->create('MODProyectoAnalisisDet');    
        if($this->objParam->insertar('id_proyecto_analisis_det')){
            $this->res=$this->objFunc->insertarProyectoAnalisisDet($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarProyectoAnalisisDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarProyectoAnalisisDet(){
        	$this->objFunc=$this->create('MODProyectoAnalisisDet');    
        $this->res=$this->objFunc->eliminarProyectoAnalisisDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarIntransaccionAnadet(){
        $this->objParam->defecto('ordenacion','id_int_transaccion');
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objFunc=$this->create('MODProyectoAnalisisDet');
        $this->res=$this->objFunc->listarIntransaccionAnadet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>