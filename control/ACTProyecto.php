<?php
/**
*@package pXP
*@file gen-ACTProyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
include_once(dirname(__FILE__).'/../../lib/lib_general/ExcelInput.php');
class ACTProyecto extends ACTbase{

	function listarProyecto(){
		$this->objParam->defecto('ordenacion','id_proyecto');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('estado')!=''){
			$this->objParam->addFiltro("proy.estado = ''".$this->objParam->getParametro('estado')."''");
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODProyecto','listarProyecto');
		} else{
			$this->objFunc=$this->create('MODProyecto');

			$this->res=$this->objFunc->listarProyecto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function insertarProyecto(){
		$this->objFunc=$this->create('MODProyecto');
		if($this->objParam->insertar('id_proyecto')){
			$this->res=$this->objFunc->insertarProyecto($this->objParam);
		} else{
			$this->res=$this->objFunc->modificarProyecto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function eliminarProyecto(){
		$this->objFunc=$this->create('MODProyecto');
		$this->res=$this->objFunc->eliminarProyecto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function ImportarCierreValorado(){
		$arregloFiles = $this->objParam->getArregloFiles();
        $ext = pathinfo($arregloFiles['archivo']['name']);
        $extension = $ext['extension'];
        $error = 'no';
        $mensaje_completo = '';
        $cc=array();

        if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])) {
            if (!in_array($extension, array('xls', 'xlsx', 'XLS', 'XLSX'))) {
                $mensaje_completo = "La extensión del archivo debe ser XLS o XLSX";
                $error = 'error_fatal';
            } else {
            	$archivoExcel = new ExcelInput($arregloFiles['archivo']['tmp_name'], 'CIERREP');
                $archivoExcel->recuperarColumnasExcel();
                $arrayArchivo = $archivoExcel->leerColumnasArchivoExcel();

                //Elimina los activos y el detalle y Verifica/crea el WF del cierre
                $this->objFunc = $this->create('MODProyectoActivo');
                $this->res = $this->objFunc->eliminarProyectoActivosDetalle($this->objParam);

                if ($this->res->getTipo() == 'ERROR') {
                	$this->res->imprimirRespuesta($this->res->generarJson());
		            exit;
                }

                $cont=0;
                foreach ($arrayArchivo as $fila) {

                	if($cont>0){
	                	//Guarda el registro del activo
						$this->objParam->addParametro('clasificacion',$fila['clasificacion']);
						$this->objParam->addParametro('vida_util_anios',$fila['vida_util_anios']);
						$this->objParam->addParametro('nro_serie',$fila['nro_serie']);
						$this->objParam->addParametro('marca',$fila['marca']);
						$this->objParam->addParametro('denominacion',$fila['denominacion']);
						$this->objParam->addParametro('descripcion',$fila['descripcion']);
						$this->objParam->addParametro('cantidad_det',$fila['cantidad']);
						$this->objParam->addParametro('unidad',$fila['unidad']);
						$this->objParam->addParametro('ubicacion',$fila['ubicacion']);
						$this->objParam->addParametro('local',$fila['local']);
						$this->objParam->addParametro('fecha_compra',$fila['fecha_compra']);
						$this->objParam->addParametro('costo',$fila['costo']);
						$this->objParam->addParametro('valor_compra',$fila['valor_compra']);
						$this->objParam->addParametro('moneda',$fila['moneda']);
						$this->objParam->addParametro('fecha_ini_dep',$fila['fecha_ini_dep']);
						$this->objParam->addParametro('grupo_ae',$fila['grupo_ae']);
						$this->objParam->addParametro('clasificacion_ae',$fila['clasificacion_ae']);
						$this->objParam->addParametro('centro_costo',$fila['centro_costo']);
						$this->objParam->addParametro('codigo_activo',$fila['codigo_activo']);
						$this->objParam->addParametro('observaciones',$fila['pedido']);
						$this->objParam->addParametro('codigo_activo_rel',$fila['codigo_activo_rel']);

						$this->objFunc = $this->create('MODProyectoActivo');
	                    $this->res = $this->objFunc->ImportarCierreValorado($this->objParam);

	                    if ($this->res->getTipo() == 'ERROR') {
	                    	$this->res->imprimirRespuesta($this->res->generarJson());
				            exit;

	                        $error = 'error';
	                        $mensaje_completo = "Error al guardar el fila en tabla :  " . $this->res->getMensajeTec();
	                        break;
	                    } else {
	                    	$dat = $this->res->getDatos();
	                    	$idProyectoActivo = $dat['id_proyecto_activo'];
	                    	$this->objParam->addParametro('id_proyecto_activo',$idProyectoActivo);

	                    	for ($i=0; $i < 50; $i++) {
	                    		if($fila["centro_costo_$i"]!=''){
	                    			//echo "centro_costo_$i: ".$fila["centro_costo_$i"]."<br>";
	                    			$this->objParam->addParametro('centro_costo',$cc[$i]);
	                    			$this->objParam->addParametro('monto',$fila["centro_costo_$i"]);

	                    			$this->objFunc = $this->create('MODProyectoActivoDetalle');
	                    			$this->res = $this->objFunc->ImportarCierreValoradoDet($this->objParam);

	                    			if ($this->res->getTipo() == 'ERROR') {
				                    	$this->res->imprimirRespuesta($this->res->generarJson());
							            exit;

				                        $error = 'error';
				                        $mensaje_completo = "Error al guardar el fila en tabla :  " . $this->res->getMensajeTec();
				                        break;
				                    }
	                    		}
	                    	}
	                    }

	                    //Guarda el detalle del costeo

                	} else {
                		//Borra todas las columnas
                		$this->objFunc = $this->create('MODProyectoColumnaTcc');
                		$this->res = $this->objFunc->eliminarColumnasProyecto($this->objParam);

            			if ($this->res->getTipo() == 'ERROR') {
	                    	$this->res->imprimirRespuesta($this->res->generarJson());
				            exit;
	                    }

                		//Obtiene los códigos de los centros de costo
                		for ($i=0; $i < 50; $i++) {
                			if($fila["centro_costo_$i"]!=''){
	                			//Guarda los nombres de los centos de costo en variable local
	                    		$cc[$i] = $fila["centro_costo_$i"];
	                    		//Almacena en la base de datos las columnas para la importación
	                    		$this->objParam->addParametro('centro_costo',$fila["centro_costo_$i"]);
	                			$this->objFunc = $this->create('MODProyectoColumnaTcc');
	                			$this->res = $this->objFunc->importarProyectoColumnaTcc($this->objParam);

	                			if ($this->res->getTipo() == 'ERROR') {
			                    	$this->res->imprimirRespuesta($this->res->generarJson());
						            exit;
			                    }
                			}
                    	}
                	}
                	$cont++;
                }
            }
        } else {
            $mensaje_completo = "No se subio el archivo";
            $error = 'error_fatal';
        }



        if ($error == 'error_fatal') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTIntTransaccion.php',$mensaje_completo,
                $mensaje_completo,'control');
            //si no es error fatal proceso el archivo
        }

        if ($error == 'error') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTIntTransaccion.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
                $mensaje_completo,'control');

        } else if ($error == 'no') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('EXITO','ACTIntTransaccion.php','El archivo fue ejecutado con éxito',
                'El archivo fue ejecutado con éxito','control');
        }

        //devolver respuesta
        $this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());

	}

	function siguienteEstadoCierre(){
        $this->objFunc=$this->create('MODProyecto');
        $this->res=$this->objFunc->siguienteEstadoCierre($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function anteriorEstadoCierre(){
        $this->objFunc=$this->create('MODProyecto');
        $this->res=$this->objFunc->anteriorEstadoCierre($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
	
	function siguienteEstado(){
        $this->objFunc=$this->create('MODProyecto');  
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function anteriorEstado(){
        $this->objFunc=$this->create('MODProyecto');  
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>