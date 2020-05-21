<?php
/**
*@package pXP
*@file 
*@author  
*@date 
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 ISSUE			FECHA			AUTHOR			DESCRIPCION
 #15 EndeEtr	31/07/2019	 	EGS				 creacion Reporte de invitaciones
 #59            21/05/2020      EGS             funciones para el Reporte  de ejecucion
*/
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once dirname(__FILE__).'/../../pxp/lib/lib_reporte/ReportePDFFormulario.php';

require_once(dirname(__FILE__).'/../reportes/RPlanPagoProyectoXls.php');
require_once(dirname(__FILE__).'/../reportes/RLanzamientoItemXls.php');
require_once(dirname(__FILE__).'/../reportes/RPresupuestoXls.php');
require_once(dirname(__FILE__).'/../reportes/RInvitacionXls.php');
require_once(dirname(__FILE__).'/../reportes/REjecucionCC.php');



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

        if($this->objParam->getParametro('tipo_reporte')=='ejecucion'){ //#59

            $this->objFunc=$this->create('MODReporte');
            $dataSource = $this->objFunc->listarRepCentrosCostoEjecucion($this->objParam);
            $this->objFunc=$this->create('MODReporte');
            $dataSourceTotal = $this->objFunc->listarTotCentrosCostoEjecucion($this->objParam);
            $this->objFunc=$this->create('MODReporte');
            $dataSourceGestion = $this->objFunc->listarGesCentrosCostoPresupuestado($this->objParam);
            //var_dump('total',$dataSourceMB);exit;
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

            $nombreArchivo = uniqid(md5(session_id()).'-REPCC') . '.pdf';
            $tamano = 'LETTER';
            $orientacion = 'P';
            $this->objParam->addParametro('orientacion',$orientacion);
            $this->objParam->addParametro('tamano',$tamano);
            $this->objParam->addParametro('titulo_archivo',$titulo);
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
            $this->objParam->addParametro('datos_proyecto',$datosProy->getDatos());
            $this->objParam->addParametro('datos_ejecucion',$dataSource->getDatos());
            $this->objParam->addParametro('datos_ejecucion_total',$dataSourceTotal->getDatos());
            $this->objParam->addParametro('datos_presupuesto_gestion',$dataSourceGestion->getDatos());
            //Instancia la clase de pdf
           //var_dump($this->objParam);exit;
            $reporte = new REjecucionCC($this->objParam);

            $reporte->datosHeader($this->objParam);
            //$reporte->generarReporte();//en html
            $reporte->generarReporte1($this->objParam); //#1
            $reporte->output($reporte->url_archivo,'F');

            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
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