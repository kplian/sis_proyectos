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

require_once(dirname(__FILE__).'/../reportes/RPlanificacionInicialXls.php');

class ACTReportePlanificacion extends ACTbase{

	function listarPlanificacionInicial(){

	    if($this->objParam->getParametro('id_componente_macro') !='' ){
            $this->objParam->addFiltro("cm.id_componente_macro = ".$this->objParam->getParametro('id_componente_macro'));
        }
        $this->objFunc=$this->create('MODReportePlanificacion');
        $this->res=$this->objFunc->listarPlanificacionInicial($this->objParam);
        $this->objParam->addParametro('datos',$this->res->datos);

        if($this->objParam->getParametro('id_componente_macro') !='' ){
            $this->obtenerComponenteMacro();
        }
        if($this->objParam->getParametro('id_proyecto') !='' ){
            $this->obtenerProyecto();
        }

            $titulo ='Planificacion ';
            $nombreArchivo=uniqid(md5(session_id()).$titulo);
            $nombreArchivo.='.xls';
            $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

            //var_dump('act',$this->objParam);

            $this->objReporteFormato=new RPlanificacionInicialXls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
            $this->mensajeExito=new Mensaje();
            $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se genero con éxito el reporte: '.$nombreArchivo,'control');
            $this->mensajeExito->setArchivoGenerado($nombreArchivo);
            $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
           //$this->res->imprimirRespuesta($this->res->generarJson());
    }
    function  obtenerComponenteMacro(){

        $ordenacion=$this->objParam->parametros_consulta['ordenacion'];
        $dir_ordenacion= $this->objParam->parametros_consulta['dir_ordenacion'];
        $puntero   = $this->objParam->parametros_consulta['puntero'];//#61
        $cantidad = $this->objParam->parametros_consulta['cantidad'];
        $filtro = $this->objParam->parametros_consulta['filtro'];
        //seteamos los parmetros para recuperar las columnas originales
        $this->objParam->parametros_consulta['ordenacion'] = 'id_componente_macro';
        $this->objParam->parametros_consulta['dir_ordenacion'] = 'ASC';
        $this->objParam->parametros_consulta['puntero'] = '0';
        $this->objParam->parametros_consulta['cantidad'] = '50';
        $this->objParam->parametros_consulta['filtro']= '0=0';
        if($this->objParam->getParametro('id_componente_macro') !='' ){
            $this->objParam->addFiltro("compm.id_componente_macro = ".$this->objParam->getParametro('id_componente_macro'));
        }
        $this->objFunc=$this->create('MODComponenteMacro');
        $this->res=$this->objFunc->listarComponenteMacro($this->objParam);
        $datos = $this->res->datos;
        //añadimos como un parametro
        $this->objParam->addParametro('datos_cm',$datos);
        //recuperamos los parametros originales de la consulta
        $this->objParam->parametros_consulta['ordenacion'] = $ordenacion;
        $this->objParam->parametros_consulta['dir_ordenacion']=$dir_ordenacion;
        $this->objParam->parametros_consulta['puntero'] = $puntero;
        $this->objParam->parametros_consulta['cantidad'] = $cantidad;
        $this->objParam->parametros_consulta['filtro'] = $filtro;
    }
    function  obtenerProyecto(){

        $ordenacion=$this->objParam->parametros_consulta['ordenacion'];
        $dir_ordenacion= $this->objParam->parametros_consulta['dir_ordenacion'];
        $puntero   = $this->objParam->parametros_consulta['puntero'];
        $cantidad = $this->objParam->parametros_consulta['cantidad'];
        $filtro = $this->objParam->parametros_consulta['filtro'];
        //seteamos los parmetros para recuperar las columnas originales
        $this->objParam->parametros_consulta['ordenacion'] = 'id_proyecto';
        $this->objParam->parametros_consulta['dir_ordenacion'] = 'ASC';
        $this->objParam->parametros_consulta['puntero'] = '0';
        $this->objParam->parametros_consulta['cantidad'] = '50';
        $this->objParam->parametros_consulta['filtro']= '0=0';
        if($this->objParam->getParametro('id_proyecto') !='' ){
            $this->objParam->addFiltro("proy.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }
        $this->objFunc=$this->create('MODProyecto');
        $this->res=$this->objFunc->listarProyecto($this->objParam);
        $datos = $this->res->datos;
        //añadimos como un parametro
        $this->objParam->addParametro('datos_proyecto',$datos);
        //recuperamos los parametros originales de la consulta
        $this->objParam->parametros_consulta['ordenacion'] = $ordenacion;
        $this->objParam->parametros_consulta['dir_ordenacion']=$dir_ordenacion;
        $this->objParam->parametros_consulta['puntero'] = $puntero;
        $this->objParam->parametros_consulta['cantidad'] = $cantidad;
        $this->objParam->parametros_consulta['filtro'] = $filtro;
    }
}
?>