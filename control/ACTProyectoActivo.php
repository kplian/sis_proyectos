<?php
/**
*@package pXP
*@file gen-ACTProyectoActivo.php
*@author  (admin)
*@date 31-08-2017 16:52:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTProyectoActivo extends ACTbase{

	function listarProyectoActivo(){
		$this->objParam->defecto('ordenacion','id_proyecto_activo');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("praf.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoActivo','listarProyectoActivo');
		} else{
			$this->objFunc=$this->create('MODProyectoActivo');

			$this->res=$this->objFunc->listarProyectoActivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarProyectoActivo(){
		$this->objFunc=$this->create('MODProyectoActivo');
		if($this->objParam->insertar('id_proyecto_activo')){
			$this->res=$this->objFunc->insertarProyectoActivo($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarProyectoActivo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarProyectoActivo(){
		$this->objFunc=$this->create('MODProyectoActivo');
		$this->res=$this->objFunc->eliminarProyectoActivo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarProyectoActivoTablaDatos(){
		$this->objParam->defecto('ordenacion','cc.id_centro_costo');
		$this->objParam->defecto('dir_ordenacion','asc');

		//Obtención de las columnas dinámicas (centros de costo)
		//$this->objFunc = $this->create('sis_parametros/MODCentroCosto');
		//$datos = $this->objFunc->listarCentroCostoProyecto($this->objParam);

		//Obtención directa de las columnas definidas en el proyecto
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("coltcc.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}

		$this->objFunc = $this->create('MODProyectoColumnaTcc');
		$datos = $this->objFunc->listarProyectoColumnaTcc($this->objParam);

		$this->objParam->addParametro('columnas_dinamicas',$datos->getDatos());

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoActivo','listarProyectoActivoTablaDatos');
		} else{
			$this->objFunc=$this->create('MODProyectoActivo');
			$this->res=$this->objFunc->listarProyectoActivoTablaDatos($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarProyectoActivoTablaDatosTotales(){
		$this->objParam->defecto('ordenacion','cc.id_centro_costo');
		$this->objParam->defecto('dir_ordenacion','asc');

		//Obtención de las columnas dinámicas (centros de costo)
		//$this->objFunc = $this->create('sis_parametros/MODCentroCosto');
		//$datos = $this->objFunc->listarCentroCostoProyecto($this->objParam);

		//Obtención directa de las columnas definidas en el proyecto
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("coltcc.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}
		$this->objFunc = $this->create('MODProyectoColumnaTcc');
		$datos = $this->objFunc->listarProyectoColumnaTcc($this->objParam);

		$this->objParam->addParametro('columnas_dinamicas',$datos->getDatos());


		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyectoActivo','listarProyectoActivoTablaDatosTotales');
		} else{
			$this->objFunc=$this->create('MODProyectoActivo');
			$this->res=$this->objFunc->listarProyectoActivoTablaDatosTotales($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarProyectoActivosDetalle(){
		$this->objFunc=$this->create('MODProyectoActivo');
		$this->res=$this->objFunc->eliminarProyectoActivosDetalle($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function crearWFProyectoCierre(){
		$this->objFunc=$this->create('MODProyectoActivo');
		$this->res=$this->objFunc->crearWFProyectoCierre($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

}

?>