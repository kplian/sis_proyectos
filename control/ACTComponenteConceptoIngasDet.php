<?php
/**
*@package pXP
*@file gen-ACTComponenteConceptoIngasDet.php
*@author  (admin)
*@date 22-07-2019 14:50:29
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
#ISSUE				FECHA				AUTOR				DESCRIPCION
#21 EndeEtr         30/08/2019          EGS                 filtro de concepto ingas
*/

class ACTComponenteConceptoIngasDet extends ACTbase{    
			
	function listarComponenteConceptoIngasDet(){
		$this->objParam->defecto('ordenacion','id_componente_concepto_ingas_det');
        if($this->objParam->getParametro('id_componente_concepto_ingas')!='' ){
            $this->objParam->addFiltro("comindet.id_componente_concepto_ingas = ".$this->objParam->getParametro('id_componente_concepto_ingas'));
        }
        if($this->objParam->getParametro('id_concepto_ingas')!='' ){//#21
            $this->objParam->addFiltro("cci.id_concepto_ingas = ".$this->objParam->getParametro('id_concepto_ingas'));
        }
        if($this->objParam->getParametro('id_proyecto')!='' ){
            $this->objParam->addFiltro("cm.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODComponenteConceptoIngasDet','listarComponenteConceptoIngasDet');
		} else{
			$this->objFunc=$this->create('MODComponenteConceptoIngasDet');
			
			$this->res=$this->objFunc->listarComponenteConceptoIngasDet($this->objParam);
		}

        $temp = Array();
        $temp['precio_total_det'] = $this->res->extraData['total_precio_det'];
        $temp['tipo_reg'] = 'summary';

        $this->res->total++;

        $this->res->addLastRecDatos($temp);

		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarComponenteConceptoIngasDet(){
		$this->objFunc=$this->create('MODComponenteConceptoIngasDet');	
		if($this->objParam->insertar('id_componente_concepto_ingas_det')){
			$this->res=$this->objFunc->insertarComponenteConceptoIngasDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarComponenteConceptoIngasDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarComponenteConceptoIngasDet(){
			$this->objFunc=$this->create('MODComponenteConceptoIngasDet');	
		$this->res=$this->objFunc->eliminarComponenteConceptoIngasDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>