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
    #MDID-8            08/10/2020              EGS                 Se agrega Campos de WF
 * #MDID-10             13/10/2020             EGS                  Se agrega filtro pos tipo_cc
 * #MDID-11              29/10/2020           EGS                 se agrega saldos para el panel
 *****************************************************************************************/

class ACTProyectoAnalisis extends ACTbase{

    function listarProyectoAnalisis(){
		$this->objParam->defecto('ordenacion','id_proyecto_analisis');
        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("proana.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        if($this->objParam->getParametro('id_tipo_cc')!=''){ //#MDID-10
            $this->objParam->addFiltro("proana.id_tipo_cc = ".$this->objParam->getParametro('id_tipo_cc'));
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
        $this->objParam->addParametro('id_funcionario',$_SESSION["ss_id_funcionario"]);

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
    function siguienteEstado(){//#MDID-8
        $this->objFunc=$this->create('MODProyectoAnalisis');
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function anteriorEstado(){//#MDID-8
        $this->objFunc=$this->create('MODProyectoAnalisis');
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarAnalisisDiferido(){//#MDID-11
        $this->objParam->defecto('ordenacion','id_proyecto_analisis');

        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objFunc=$this->create('MODProyectoAnalisis');
        $this->res=$this->objFunc->listarAnalisisDiferido($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>