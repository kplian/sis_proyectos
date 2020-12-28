<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTCuentaIncluir.php
*@author  (egutierrez)
*@date 19-10-2020 14:17:13
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                19-10-2020 14:17:13    egutierrez             Creacion    
  #
*****************************************************************************************/

class ACTCuentaIncluir extends ACTbase{    
            
    function listarCuentaIncluir(){
		$this->objParam->defecto('ordenacion','id_cuenta_incluir');

        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODCuentaIncluir','listarCuentaIncluir');
        } else{
        	$this->objFunc=$this->create('MODCuentaIncluir');
            
        	$this->res=$this->objFunc->listarCuentaIncluir($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarCuentaIncluir(){
        $this->objFunc=$this->create('MODCuentaIncluir');    
        if($this->objParam->insertar('id_cuenta_incluir')){
            $this->res=$this->objFunc->insertarCuentaIncluir($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarCuentaIncluir($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarCuentaIncluir(){
        	$this->objFunc=$this->create('MODCuentaIncluir');    
        $this->res=$this->objFunc->eliminarCuentaIncluir($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>