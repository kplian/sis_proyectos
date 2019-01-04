<?php
/**
*@package pXP
*@file 
*@author  
*@date 
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

require_once(dirname(__FILE__).'/../reportes/RPlanPagoProyectoXls.php');
require_once(dirname(__FILE__).'/../reportes/RLanzamientoItemXls.php');
require_once(dirname(__FILE__).'/../reportes/RPresupuestoXls.php');



class ACTReporte extends ACTbase{

	function listarReportes(){
		/*
		$this->objParam->defecto('ordenacion','id_fase');
		$this->objParam->defecto('dir_ordenacion','asc');
		*/
		//var_dump($this->objParam);
	if($this->objParam->getParametro('tipo_reporte')=='plan_pago'){

		$this->objFunc=$this->create('MODReporte');
		$gestion=$this->objFunc->listarGestionProyecto($this->objParam);
		
		
		$this->objParam->addParametro('gestion',$gestion->getDatos());
		
		$this->objFunc=$this->create('MODReporte');
		$datos = $this->objFunc->listarPlanPagoProyecto($this->objParam);
		//var_dump($datos);
		
		
			if($this->objParam->getParametro('id_proyecto')!=''){
					$this->objParam->defecto('ordenacion','id_proyecto');
					$this->objParam->defecto('dir_ordenacion','asc');
					$this->objParam->defecto('cantidad',1000000);
					$this->objParam->defecto('puntero', 0);
					$this->objParam->addFiltro("proy.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
			}
				
				//var_dump($this->objParam);
				$this->objFunc=$this->create('MODProyecto');
				$datosProy = $this->objFunc->listarProyecto($this->objParam);
				
		
		
			$titulo ='ITEMS';
			$nombreArchivo=uniqid(md5(session_id()).$titulo);
			$nombreArchivo.='.xls';
			
			$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
			$this->objParam->addParametro('datos_proyecto',$datosProy->datos);			
			
			$this->objParam->addParametro('gestion',$gestion->getDatos());
			$this->objParam->addParametro('datos',$datos->datos);			
			$this->objReporteFormato=new RPlanPagoProyectoXls($this->objParam);
			$this->objReporteFormato->generarDatos();
			$this->objReporteFormato->generarReporte();
			$this->mensajeExito=new Mensaje();
			$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
			$this->mensajeExito->setArchivoGenerado($nombreArchivo);
			$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());		
		}
		if($this->objParam->getParametro('tipo_reporte')=='lanzamiento_item'){
			
				$this->objFunc=$this->create('MODReporte');
				$datos = $this->objFunc->listarLanzamientoFaseConceptoIngas($this->objParam);
				$titulo ='Lanzamiento';
				$nombreArchivo=uniqid(md5(session_id()).$titulo);
				$nombreArchivo.='.xls';
				
				if($this->objParam->getParametro('id_proyecto')!=''){
					$this->objParam->defecto('ordenacion','id_proyecto');
					$this->objParam->defecto('dir_ordenacion','asc');
					$this->objParam->defecto('cantidad',1000000);
					$this->objParam->defecto('puntero', 0);
					$this->objParam->addFiltro("proy.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
				}
				
				//var_dump($this->objParam);
				$this->objFunc=$this->create('MODProyecto');
				$datosProy = $this->objFunc->listarProyecto($this->objParam);
				
				$this->objParam->addParametroConsulta('filtro','0=0');
				//var_dump($datosProy);
				
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				
				$this->objParam->addParametro('datos_proyecto',$datosProy->datos);			
				$this->objParam->addParametro('datos',$datos->datos);			
				$this->objReporteFormato=new RLanzamientoItemXls($this->objParam);
				$this->objReporteFormato->generarDatos();
				$this->objReporteFormato->generarReporte();
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	
				
				//var_dump($datos);

		}
		
		if($this->objParam->getParametro('tipo_reporte')=='presupuesto'){
			
				$this->objFunc=$this->create('MODReporte');
				$datos = $this->objFunc->listarPresupuesto($this->objParam);
				
				//var_dump($datos);
				
				$titulo ='Presupuesto';
				$nombreArchivo=uniqid(md5(session_id()).$titulo);
				$nombreArchivo.='.xls';
				
				$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
				
				$this->objParam->addParametro('datos',$datos->datos);			
				$this->objReporteFormato=new RPresupuestoXls($this->objParam);
				$this->objReporteFormato->generarDatos();
				$this->objReporteFormato->generarReporte();
				$this->mensajeExito=new Mensaje();
				$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
				$this->mensajeExito->setArchivoGenerado($nombreArchivo);
				$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());	
				

		}
		
			/*
			if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
				$this->objReporte = new Reporte($this->objParam,$this);
				$this->res = $this->objReporte->generarReporteListado('MODProyectoActivo','listarProyectoActivoTablaDatosTotales');
			} else{
				$this->objFunc=$this->create('MODReporte');
				$this->res=$this->objFunc->listarPlanPagoProyecto($this->objParam);
			}
			$this->res->imprimirRespuesta($this->res->generarJson());*/
		
	}
}
?>