<?php
/**
*@package pXP
*@file gen-ACTUnidadConstructiva.php
*@author  (egutierrez)
*@date 06-05-2019 14:16:09
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
	ISSUE		FORK		FECHA			AUTHOR				DESCRIPCION
 	 #16		ETR			01/08/2019		EGS					CREACION
*    #26        etr         12/09/2019      EGS                 se añade combo para solo mande uc hijos segun ucm
 */

class ACTUnidadConstructiva extends ACTbase{    
			
	function listarUnidadConstructiva(){
		$this->objParam->defecto('ordenacion','id_unidad_constructiva');
		
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("uncon.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));	
		}

        if($this->objParam->getParametro('activo')!=''){
            $this->objParam->addFiltro("uncon.activo = ''".$this->objParam->getParametro('activo')."''");
        }
		

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODUnidadConstructiva','listarUnidadConstructiva');
		} else{
			$this->objFunc=$this->create('MODUnidadConstructiva');
			
			$this->res=$this->objFunc->listarUnidadConstructiva($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarUnidadConstructiva(){
		$this->objFunc=$this->create('MODUnidadConstructiva');	
		if($this->objParam->insertar('id_unidad_constructiva')){
			$this->res=$this->objFunc->insertarUnidadConstructiva($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarUnidadConstructiva($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarUnidadConstructiva(){
			$this->objFunc=$this->create('MODUnidadConstructiva');	
		$this->res=$this->objFunc->eliminarUnidadConstructiva($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarUnidadConstructivaArb(){
		
		
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("uncon.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));	
		}
		
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

		$this->objFunc=$this->create('MODUnidadConstructiva');
        $this->res=$this->objFunc->listarUnidadConstructivaArb();
		
				
		
		$this->res->setTipoRespuestaArbol();
		

		$arreglo=array();
		
			
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_unidad_constructiva'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_unidad_constructiva_fk'));


        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #codigo# - #nombre#</b>'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'descripcion'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #codigo#</b><br/><br> #descripcion#'));


        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);

        /*se ande un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */


         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
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

	function  agregarPlantilla(){
		$this->objFunc=$this->create('MODUnidadConstructiva');	
	    $this->res=$this->objFunc->agregarPlantilla($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function deleteArbol(){
		$this->objFunc=$this->create('MODUnidadConstructiva');	
		$this->res=$this->objFunc->deleteArbol($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	//lista los conceptos de gasto que existen en la unidades constructivas por proyecto		
	function listarConceptoingasUcCombo(){
		$this->objParam->defecto('ordenacion','id_concepto_ingas');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addParametroConsulta('cantidad',1000);
		$this->objParam->defecto('puntero', 0);
		
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("uncon.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));	
		}
		if($this->objParam->getParametro('tipo') != ''){
			$this->objParam->addFiltro("cig.tipo = ''".$this->objParam->getParametro('tipo')."''");	
		}
		//var_dump('obj',$this->objParam);exit;
		$this->objFunc=$this->create('MODUnidadConstructiva');
			
		$this->res=$this->objFunc->listarConceptoingasUcCombo($this->objParam);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	//lista los nodos hijos de un nodo tree
	function listarConceptoingasDetUcCombo(){
		$this->objParam->defecto('ordenacion','id_concepto_ingas');
		$this->objParam->defecto('dir_ordenacion','asc');
		$this->objParam->addParametroConsulta('cantidad',1000);
		$this->objParam->addParametroConsulta('puntero', 0);
		
		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("arb.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));	
		}
		//var_dump('obj',$this->objParam);exit;
		$this->objFunc=$this->create('MODUnidadConstructiva');
			
		$this->res=$this->objFunc->listarConceptoingasDetUcCombo($this->objParam);
		
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function listarUnidadConstructivaMacroHijos(){//#26
        $this->objParam->defecto('ordenacion','id_unidad_constructiva');

        if($this->objParam->getParametro('id_proyecto')!=''){
            $this->objParam->addFiltro("uncon.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
        }

        if($this->objParam->getParametro('activo')!=''){
            $this->objParam->addFiltro("uncon.activo = ''".$this->objParam->getParametro('activo')."''");
        }
        $this->objFunc=$this->create('MODUnidadConstructiva');
        $this->res=$this->objFunc->listarUnidadConstructivaMacroHijos($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>