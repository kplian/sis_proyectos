<?php
/**
*@package pXP
*@file gen-ACTComponenteConceptoIngas.php
*@author  (admin)
*@date 22-07-2019 14:49:24
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTComponenteConceptoIngas extends ACTbase{    
			
	function listarComponenteConceptoIngas(){
		$this->objParam->defecto('ordenacion','id_componente_concepto_ingas');
        if($this->objParam->getParametro('id_componente_macro')!='' ){
            $this->objParam->addFiltro("comingas.id_componente_macro = ".$this->objParam->getParametro('id_componente_macro'));
        }else {
            if ($this->objParam->getParametro('nombreVista') == 'ComponenteConceptoIngas'){
                $this->objParam->addFiltro("comingas.id_componente_macro = 0");
            }
        }
        if($this->objParam->getParametro('id_proyecto')!='' ){
            $this->objParam->addFiltro("cm.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        if($this->objParam->getParametro('tipo')!='' ){
            $this->objParam->addFiltro("cig.tipo = ''".$this->objParam->getParametro('tipo')."''");
        }
		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODComponenteConceptoIngas','listarComponenteConceptoIngas');
		} else{
			$this->objFunc=$this->create('MODComponenteConceptoIngas');
			
			$this->res=$this->objFunc->listarComponenteConceptoIngas($this->objParam);
		}
        if ($this->objParam->getParametro('nombreVista') == 'ComponenteConceptoIngas') {
            $temp = Array();
            $temp['precio_total_det'] = $this->res->extraData['total_precio_det'];
            $temp['tipo_reg'] = 'summary';

            $this->res->total++;
            $this->res->addLastRecDatos($temp);
        }


		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarComponenteConceptoIngas(){
		$this->objFunc=$this->create('MODComponenteConceptoIngas');	
		if($this->objParam->insertar('id_componente_concepto_ingas')){
			$this->res=$this->objFunc->insertarComponenteConceptoIngas($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarComponenteConceptoIngas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarComponenteConceptoIngas(){
			$this->objFunc=$this->create('MODComponenteConceptoIngas');	
		$this->res=$this->objFunc->eliminarComponenteConceptoIngas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>