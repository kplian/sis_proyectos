<?php
/**
*@package pXP
*@file 
*@author  
*@date 
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 ISSUE			FECHA			AUTHOR			DESCRIPCION
 #15 EndeEtr	31/07/2019	 	EGS				 creacion Reporte de invitaciones
*/

require_once(dirname(__FILE__).'/../reportes/RPlanPagoProyectoXls.php');
require_once(dirname(__FILE__).'/../reportes/RLanzamientoItemXls.php');
require_once(dirname(__FILE__).'/../reportes/RPresupuestoXls.php');
require_once(dirname(__FILE__).'/../reportes/RInvitacionXls.php');



class ACTReporte extends ACTbase{

	function listarReportes(){

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
					$this->objParam->defecto('cantidad',1000000000);
					$this->objParam->defecto('puntero', 0);
					$this->objParam->addFiltro("proy.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
			}
				
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
					$this->objParam->defecto('cantidad',1000000000);
					$this->objParam->defecto('puntero', 0);
					$this->objParam->addFiltro("proy.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
				}
				
				$this->objFunc=$this->create('MODProyecto');
				$datosProy = $this->objFunc->listarProyecto($this->objParam);
				
				$this->objParam->addParametroConsulta('filtro','0=0');
				
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
				

		}
		
		if($this->objParam->getParametro('tipo_reporte')=='presupuesto'){
			
				$this->objFunc=$this->create('MODReporte');
				$datos = $this->objFunc->listarPresupuesto($this->objParam);
				
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
				
	}
	
	function listarReporteInvitacion(){//#15
		$this->objParam->defecto('ordenacion','id_invitacion');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->defecto('cantidad',1000000000);
		$this->objParam->defecto('puntero', 0);
		
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("ivt.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));	
		}
		if($this->objParam->getParametro('id_tipo_estado')!=''){
			$this->objParam->addFiltro("ew.id_tipo_estado in (".$this->objParam->getParametro('id_tipo_estado').")");	
		}
		
		if ($this->objParam->getParametro('tipo_fecha')!='') {
			$fecha = $this->objParam->getParametro('tipo_fecha');
			
		}
		else {
			$fecha = 'fecha';
		}
		
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')==''){
			$this->objParam->addFiltro("( ivt.".$fecha."::date  >= ''%".$this->objParam->getParametro('desde')."%''::date)");	
		}
		
		if($this->objParam->getParametro('desde')=='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("( ivt.".$fecha."::date  <= ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}
		
		if($this->objParam->getParametro('desde')!='' && $this->objParam->getParametro('hasta')!=''){
			$this->objParam->addFiltro("( ivt.".$fecha."::date  BETWEEN ''%".$this->objParam->getParametro('desde')."%''::date  and ''%".$this->objParam->getParametro('hasta')."%''::date)");	
		}
		
		
		$this->objFunc=$this->create('MODReporte');
			
		$datos=$this->objFunc->listarReporteInvitacion($this->objParam);
		//var_dump($datos);
		///añadimos los datos del proyecto 
		$this->objParam->addParametroConsulta('filtro','0=0');
		
		if($this->objParam->getParametro('id_proyecto')!=''){
					//seteamos los datos de la consulta
					$this->objParam->parametros_consulta['puntero'] = '0';
					$this->objParam->parametros_consulta['cantidad'] = '10000';
					$this->objParam->parametros_consulta['ordenacion'] = 'id_proyecto';
					$this->objParam->parametros_consulta['dir_ordenacion'] = 'asc';					
					$this->objParam->addFiltro("proy.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
				}
				
		$this->objFunc=$this->create('MODProyecto');
	    $datosProy = $this->objFunc->listarProyecto($this->objParam);

		$titulo ='Invitacion';
		$nombreArchivo=uniqid(md5(session_id()).$titulo);
		$nombreArchivo.='.xls';
				
		$this->objParam->addParametro('nombre_archivo',$nombreArchivo);
		
		//agregamos los datos a los parametros
		$this->objParam->addParametro('datos_proyecto',$datosProy->datos);		
		$this->objParam->addParametro('datos',$datos->datos);
						
		$this->objReporteFormato=new RInvitacionXls($this->objParam);
		$this->objReporteFormato->generarDatos();
		$this->objReporteFormato->generarReporte();
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
	}
}
?>