<?php
/**
*@package pXP
*@file gen-ACTFaseConceptoIngas.php
*@author  (admin)
*@date 24-05-2018 19:13:39
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
	ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 	#5	  endeETR		09/01/2019	EGS				Se agrego totalizadores de precio y precio_real
 */

class ACTFaseConceptoIngas extends ACTbase{    
			
	function listarFaseConceptoIngas(){
		$this->objParam->defecto('ordenacion','id_fase_concepto_ingas');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_fase')!=''){
			$this->objParam->addFiltro("facoing.id_fase = ".$this->objParam->getParametro('id_fase'));
		}
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("fase.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}
		if($this->objParam->getParametro('tipo')!=''){
			$this->objParam->addFiltro("cig.tipo = ''".$this->objParam->getParametro('tipo')."''");
		}
		if($this->objParam->getParametro('invitacion')=='no'){
			$this->objParam->addFiltro("invd.id_invitacion_det is null");
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFaseConceptoIngas','listarFaseConceptoIngas');
		} else{
			$this->objFunc=$this->create('MODFaseConceptoIngas');
			
			$this->res=$this->objFunc->listarFaseConceptoIngas($this->objParam);
		}
		//#5
		//añade le total de elementos que existe en la grilla
		for ($i=0; $i < count($this->res->datos); $i++) { 
			$arrayTotal = array('total' => $this->res->total ,'tipo_reg'=> 'registry');
			$this->res->datos[$i] = array_merge($this->res->datos[$i],$arrayTotal);			

		}

		$temp = Array();
		   	$temp['total']= $this->res->total;
			$temp['precio'] = $this->res->extraData['total_precio'];
			$temp['precio_real'] = $this->res->extraData['total_precio_real'];
			$temp['tipo_reg'] = 'summary';
			$temp['id_fase_concepto_ingas'] = 0;
			$this->res->total++;
			
			$this->res->addLastRecDatos($temp);	
			//#5
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFaseConceptoIngas(){
		$this->objFunc=$this->create('MODFaseConceptoIngas');	
		if($this->objParam->insertar('id_fase_concepto_ingas')){
			$this->res=$this->objFunc->insertarFaseConceptoIngas($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFaseConceptoIngas($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFaseConceptoIngas(){
			$this->objFunc=$this->create('MODFaseConceptoIngas');	
		$this->res=$this->objFunc->eliminarFaseConceptoIngas($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarFaseConceptoIngasProgramado(){
		$this->objParam->defecto('ordenacion','id_fase_concepto_ingas');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_fase')!=''){
			$this->objParam->addFiltro("facoing.id_fase = ".$this->objParam->getParametro('id_fase'));
		}
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("fase.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}
		
		if($this->objParam->getParametro('estado_tiempo')!=''){
			$this->objParam->addFiltro("est.estado = ''".$this->objParam->getParametro('estado_tiempo')."''");
		}
		
	

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFaseConceptoIngas','listarFaseConceptoIngasProgramado');
		} else{
			$this->objFunc=$this->create('MODFaseConceptoIngas');
			
			$this->res=$this->objFunc->listarFaseConceptoIngasProgramado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
		
			
}

?>