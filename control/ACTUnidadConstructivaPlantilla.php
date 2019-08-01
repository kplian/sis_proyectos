<?php
/**
*@package pXP
*@file gen-ACTUnidadConstructiva.php
*@author  (egutierrez)
*@date 06-05-2019 14:16:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
	ISSUE		FORK		FECHA			AUTHOR				DESCRIPCION
 	 #16		ETR			01/08/2019		EGS					CREACION
 
 * */

class ACTUnidadConstructivaPlantilla extends ACTbase{    
			
	function listarUnidadConstructivaPlantilla(){
		$this->objParam->defecto('ordenacion','id_unidad_constructiva_plantilla');
		
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('solo_raices') == 'si'){
			$this->objParam->addFiltro("unconpl.id_unidad_constructiva_plantilla_fk is null");
		}
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODUnidadConstructivaPlantilla','listarUnidadConstructiva');
		} else{
			$this->objFunc=$this->create('MODUnidadConstructivaPlantilla');
			
			$this->res=$this->objFunc->listarUnidadConstructivaPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarUnidadConstructivaPlantilla(){
		$this->objFunc=$this->create('MODUnidadConstructivaPlantilla');	
		if($this->objParam->insertar('id_unidad_constructiva_plantilla')){
			$this->res=$this->objFunc->insertarUnidadConstructivaPlantilla($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarUnidadConstructivaPlantilla($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarUnidadConstructivaPlantilla(){
			$this->objFunc=$this->create('MODUnidadConstructivaPlantilla');	
		$this->res=$this->objFunc->eliminarUnidadConstructivaPlantilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarUnidadConstructivaPlantillaArb(){
				
        //Obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');

        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
           
        } else {
            $this->objParam->addParametro('id_padre',$id_fase);
        }
		/*
        if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("fase.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}*/

		$this->objFunc=$this->create('MODUnidadConstructivaPlantilla');
        $this->res=$this->objFunc->listarUnidadConstructivaPlantillaArb();
		
				
		
		$this->res->setTipoRespuestaArbol();
		

		$arreglo=array();
		
			
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_unidad_constructiva_plantilla'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_unidad_constructiva_plantilla_fk'));
        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #codigo# </b>'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'descripcion'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #codigo#</b><br/><br> #descripcion#'));


        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
        												'draggable' => true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form_edit.png'),
                                                        $arreglo);

        /*se ande un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */


         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'draggable' => true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form_edit.png'),
                                                        $arreglo);


		$this->res->addNivelArbol('tipo_nodo','hoja',array(
                                                        'leaf'=>true,
                                                        'allowDelete'=>false,
                                                        'allowEdit'=>false,
                                                        'tipo_nodo'=>'hoja',
                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
                                                        $arreglo);
	      
		 //var_dump( $this->res->imprimirRespuesta($this->res->generarJson()));
        $this->res->imprimirRespuesta($this->res->generarJson());

   }
			
}

?>