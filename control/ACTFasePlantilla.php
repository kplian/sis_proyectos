<?php
/**
 *@package pXP
 *@file gen-ACTFasePlantilla.php
 *@author  (rchumacero)
 *@date 15-08-2018 13:05:07
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 *  issue				FECHA		 AUTOR          DESCRIPCION			
 * 	1					21/08/2018   EGS			se aumento el filrto para solo raices
 * */
 

class ACTFasePlantilla extends ACTbase {

	function listarFasePlantilla() {
		$this -> objParam -> defecto('ordenacion', 'id_fase_plantilla');
		////////EGS-i-21/08/2018///
		///filtro para obteer solo las raices de la plantilla
		if ($this -> objParam -> getParametro('raiz') != '') {
			$this -> objParam -> addFiltro("faspla.id_fase_plantilla_fk is null");
		}

		/////EGS--21/08/2018////

		$this -> objParam -> defecto('dir_ordenacion', 'asc');
		if ($this -> objParam -> getParametro('tipoReporte') == 'excel_grid' || $this -> objParam -> getParametro('tipoReporte') == 'pdf_grid') {
			$this -> objReporte = new Reporte($this -> objParam, $this);
			$this -> res = $this -> objReporte -> generarReporteListado('MODFasePlantilla', 'listarFasePlantilla');
		} else {
			$this -> objFunc = $this -> create('MODFasePlantilla');

			$this -> res = $this -> objFunc -> listarFasePlantilla($this -> objParam);
		}
		$this -> res -> imprimirRespuesta($this -> res -> generarJson());
	}

	function insertarFasePlantilla() {
		$this -> objFunc = $this -> create('MODFasePlantilla');
		if ($this -> objParam -> insertar('id_fase_plantilla')) {
			$this -> res = $this -> objFunc -> insertarFasePlantilla($this -> objParam);
		} else {
			$this -> res = $this -> objFunc -> modificarFasePlantilla($this -> objParam);
		}
		$this -> res -> imprimirRespuesta($this -> res -> generarJson());
	}

	function eliminarFasePlantilla() {
		$this -> objFunc = $this -> create('MODFasePlantilla');
		$this -> res = $this -> objFunc -> eliminarFasePlantilla($this -> objParam);
		$this -> res -> imprimirRespuesta($this -> res -> generarJson());
	}

	function listarFasePlantillaArb() {
		$this -> objParam -> defecto('ordenacion', 'id_fase_plantilla');
		$this -> objParam -> defecto('dir_ordenacion', 'asc');

		if ($this -> objParam -> getParametro('id_fase_plantilla') != '') {
			if ($this -> objParam -> getParametro('id_fase_plantilla') == 'id') {
				$this -> objParam -> addFiltro("faspla.id_fase_plantilla_fk is null ");
			} else {
				$this -> objParam -> addFiltro("faspla.id_fase_plantilla_fk = " . $this -> objParam -> getParametro('id_fase_plantilla'));
			}
		} else {
			$this -> objParam -> addFiltro("faspla.id_fase_plantilla_fk is null ");
		}

		$this -> objFunc = $this -> create('MODFasePlantilla');
		$this -> res = $this -> objFunc -> listarFasePlantillaArb($this -> objParam);

		$this -> res -> setTipoRespuestaArbol();
		$arreglo = array();
		$arreglo_valores = array();

		//para cambiar un valor por otro en una variable
		/*array_push($arreglo_valores,array('variable'=>'checked','val_ant'=>'true','val_nue'=>true));
		 array_push($arreglo_valores,array('variable'=>'checked','val_ant'=>'false','val_nue'=>false));
		 $this->res->setValores($arreglo_valores);*/

		array_push($arreglo, array('nombre' => 'id', 'valor' => 'id_fase_plantilla'));
		array_push($arreglo, array('nombre' => 'id_p', 'valor' => 'id_fase_plantilla'));
		array_push($arreglo, array('nombre' => 'text', 'valores' => '[#codigo#]-#nombre#'));
		array_push($arreglo, array('nombre' => 'cls', 'valor' => 'descripcion'));
		array_push($arreglo, array('nombre' => 'qtip', 'valores' => '<b>#codigo#</b><br/>#nombre# #descripcion#'));

		/*Estas funciones definen reglas para los nodos en funcion a los tipo de nodos que contenga cada uno*/
		$this -> res -> addNivelArbol('tipo_nodo', 'raiz', array('leaf' => false,
																 'draggable' => true, 
																 'allowDelete' => true, 
																 'allowEdit' => true, 
																 'cls' => 'folder', 
																 'tipo_nodo' => 'raiz', 
																 'icon' => '../../../lib/imagenes/a_form_edit.png'),
																  $arreglo, $arreglo_valores);
		$this -> res -> addNivelArbol('tipo_nodo', 'hijo', array('leaf' => false, 
																 'draggable' => true, 
																 'allowDelete' => true, 
																 'allowEdit' => true, 
																 'tipo_nodo' => 'hijo', 
																 'icon' => '../../../lib/imagenes/a_form_edit.png'), 
																 $arreglo, $arreglo_valores);

		echo $this -> res -> imprimirRespuesta($this -> res -> generarJson());
	}

}
?>