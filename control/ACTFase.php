<?php
/**
*@package pXP
*@file gen-ACTFase.php
*@author  (admin)
*@date 25-10-2017 13:16:54
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/
class ACTFase extends ACTbase{    
			
	function listarFase(){
		$this->objParam->defecto('ordenacion','id_fase');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("fase.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODFase','listarFase');
		} else{
			$this->objFunc=$this->create('MODFase');
			
			$this->res=$this->objFunc->listarFase($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarFase(){
		$this->objFunc=$this->create('MODFase');	
		if($this->objParam->insertar('id_fase')){
			$this->res=$this->objFunc->insertarFase($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarFase($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarFase(){
			$this->objFunc=$this->create('MODFase');	
		$this->res=$this->objFunc->eliminarFase($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function listarFasesArb($node,$id_tipo_cc){
        //Obtiene el parametro nodo enviado por la vista
        //$node=$this->objParam->getParametro('node');
        //$tipo_nodo=$this->objParam->getParametro('tipo_nodo');
                    
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
            $this->objParam->addParametro('id_tipo_cc',$id_tipo_cc);
        } else {
            $this->objParam->addParametro('id_padre',$id_fase);
        }

        if($this->objParam->getParametro('id_proyecto')!=''){
			$this->objParam->addFiltro("fase.id_proyecto = ".$this->objParam->getParametro('id_proyecto'));
		}
        
		$this->objFunc=$this->create('MODFase');
        $this->res=$this->objFunc->listarFasesArb();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_fase'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_fase_fk'));
        
        
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
                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
                                                        $arreglo);
														
		
		$this->res->addNivelArbol('tipo_nodo','hoja',array(
                                                        'leaf'=>true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hoja',
                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
                                                        $arreglo);												
														

        $this->res->imprimirRespuesta($this->res->generarJson());         

   }

   function listarTipoCcArb(){
        //Obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_cuenta=$this->objParam->getParametro('id_tipo_cc');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
        $swCargarFase=true;       
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
            $swCargarFase=false;
        } else {
            $this->objParam->addParametro('id_padre',$id_tipo_cc);
        }

        if($this->objParam->getParametro('id_fase')==''){
        	$this->objFunc=$this->create('sis_parametros/MODTipoCc');
	        $this->res=$this->objFunc->listarTipoCcArb();
	        
	        $this->res->setTipoRespuestaArbol();
	        
	        $arreglo=array();
	        
	        array_push($arreglo,array('nombre'=>'id','valor'=>'id_tipo_cc'));
	        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_tipo_cc_fk'));
	        
	        
	        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #codigo# - #descripcion#</b>'));
	        array_push($arreglo,array('nombre'=>'cls','valor'=>'descripcion'));
	        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #codigo#</b><br/>#descripcion#'));
	        
	        
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
	                                                        'leaf'=>false,
	                                                        'allowDelete'=>true,
	                                                        'allowEdit'=>true,
	                                                        'tipo_nodo'=>'hoja',
	                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
	                                                        $arreglo);												

			$arbTcc = json_decode($this->res->generarJson());
        }
		
		
        //Cargar el árbol de fases
        if($swCargarFase){
        	/*if($node=='id'){
	            $this->objParam->addParametro('id_padre','%');
	            $this->objParam->addParametro('id_tipo_cc',$id_tipo_cc);
	        } else {
	            $this->objParam->addParametro('id_padre',$id_fase);
	        }

	        if($this->objParam->getParametro('id_proy')!=''){
				//$this->objParam->addFiltro("fase.id_proyecto = ".$this->objParam->getParametro('id_proy'));
				$this->objParam->addFiltro("fase.id_tipo_cc = ".$node);
			}*/

			if($this->objParam->getParametro('id_ep')!=''){
				//echo 'saaaa: '.$node;exit;
				//$this->objParam->addFiltro("fase.id_tipo_cc = ".$node);
			}
	        
			$this->objFunc=$this->create('MODFase');
	        $this->res=$this->objFunc->listarFasesArb();
	        
	        $this->res->setTipoRespuestaArbol();
	        
	        $arreglo=array();
	        
	        array_push($arreglo,array('nombre'=>'id','valor'=>'id_fase'));
	        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_fase_fk'));
	        
	        
	        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #codigo# - #nombre#</b>'));
	        array_push($arreglo,array('nombre'=>'cls','valor'=>'descripcion'));
	        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #codigo#</b><br/><br> #descripcion#'));
	        
	        
	        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
	                                                        'allowDelete'=>true,
	                                                        'allowEdit'=>true,
	                                                        'cls'=>'folder',
	                                                        'tipo_nodo'=>'raiz',
	                                                        'icon'=>'../../../lib/imagenes/gear.png'),
	                                                        $arreglo);
	         

	        $this->res->addNivelArbol('tipo_nodo','hijo',array(
	                                                        'leaf'=>false,
	                                                        'allowDelete'=>true,
	                                                        'allowEdit'=>true,
	                                                        'tipo_nodo'=>'hijo',
	                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
	                                                        $arreglo);
															
			
			$this->res->addNivelArbol('tipo_nodo','hoja',array(
	                                                        'leaf'=>true,
	                                                        'allowDelete'=>true,
	                                                        'allowEdit'=>true,
	                                                        'tipo_nodo'=>'hoja',
	                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
	                                                        $arreglo);	
			$arbFase = json_decode($this->res->generarJson());

        }
        
		$arb=$arbTcc;
		if(count($arbFase)>0){
			if(count($arbTcc)>0){
				$arb=array_merge($arbTcc,$arbFase);
			} else {
				$arb=$arbFase;
			}
		}

        $this->res->imprimirRespuesta(json_encode($arb));

   }
			
}

?>