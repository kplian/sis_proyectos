<?php
/**
*@package pXP
*@file gen-ACTFaseConceptoIngasPago.php
*@author  (eddy.gutierrez)
*@date 14-12-2018 13:31:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
	ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 	#5	  endeETR		09/01/2019	EGS				Se agrego totalizadores de importe y precio_item
 */

class ACTFaseConceptoIngasPago extends ACTbase{    
			
	function listarFaseConceptoIngasPago(){
		$this->objParam->defecto('ordenacion','id_fase_concepto_ingas_pago');
		
		
		if($this->objParam->getParametro('id_fase_concepto_ingas')!=''){
            $this->objParam->addFiltro(" facoinpa.id_fase_concepto_ingas = ''".$this->objParam->getParametro('id_fase_concepto_ingas')."''");    
        }

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFaseConceptoIngasPago','listarFaseConceptoIngasPago');
		} else{
			$this->objFunc=$this->create('MODFaseConceptoIngasPago');
			
			$this->res=$this->objFunc->listarFaseConceptoIngasPago($this->objParam);
		}
		//recupero los datos del item que estan asociados al plan de pago que es solo es uno
		$this->objParam->addParametroConsulta('filtro',' 0 = 0 ');
		$this->objParam->addParametroConsulta('ordenacion','id_fase_concepto_ingas');		
		$this->objParam->addParametro('sort','id_fase_concepto_ingas');
		$this->objParam->addParametro('limit',1);
		
		if($this->objParam->getParametro('id_fase_concepto_ingas')!=''){
            $this->objParam->addFiltro(" facoing.id_fase_concepto_ingas = ''".$this->objParam->getParametro('id_fase_concepto_ingas')."''");    
        }
		$objFuncN=$this->create('MODFaseConceptoIngas');
		$datos = $objFuncN->listarFaseConceptoIngas($this->objParam);
        $datos= $datos->datos;
		///recuperamos el precio del item 
		//#5
		$precio = $datos[0]['precio'];
		$temp = Array();
			$temp['importe'] = $this->res->extraData['total_importe'];
			$temp['tipo_reg'] = 'summary';
			$temp['id_fase_concepto_ingas_pago'] = 0;
			$temp['precio_item'] = $precio;
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);
		//#5		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFaseConceptoIngasPago(){
		$this->objFunc=$this->create('MODFaseConceptoIngasPago');	
		if($this->objParam->insertar('id_fase_concepto_ingas_pago')){
			$this->res=$this->objFunc->insertarFaseConceptoIngasPago($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFaseConceptoIngasPago($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFaseConceptoIngasPago(){
			$this->objFunc=$this->create('MODFaseConceptoIngasPago');	
		$this->res=$this->objFunc->eliminarFaseConceptoIngasPago($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>