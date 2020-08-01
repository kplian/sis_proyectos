<?php
// Extend the TCPDF class to create custom MultiRow
class REjecucionCC extends  ReportePDF {
	var $cabecera;
	var $detalleCbte;
	var $ancho_hoja;
	var $gerencia;
	var $numeracion;
	var $ancho_sin_totales;
	var $cantidad_columnas_estaticas;
	var $total;
	var $with_col;
	var $datos_proyecto;
	var $datos_ejecucion ;
    var $datos_ejecucion_total ;
    var $datos_presupuesto_gestion ;
	function datosHeader ( $detalle) {

        $this->datos_proyecto = $detalle->getParametro('datos_proyecto');
        $this->datos_ejecucion = $detalle->getParametro('datos_ejecucion');
        $this->datos_ejecucion_total = $detalle->getParametro('datos_ejecucion_total');
        $this->datos_presupuesto_gestion = $detalle->getParametro('datos_presupuesto_gestion');
       // var_dump('datos_ejecucion',$this->datos_ejecucion);
        $this->SetHeaderMargin(15); //margen top header
		 
	}
	
	function Header() {
                $this->SetHeaderMargin(30);
                //$this->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
		 	    $this->SetMargins(15, 50, 15);
				$newDate = date("d/m/Y", strtotime( $this->cabecera[0]['fecha']));		
				$dataSource = $this->datos_detalle; 
			    ob_start();
				include(dirname(__FILE__).'/../reportes/tpl/ejecucion/cabecera.php');
		        $content = ob_get_clean();
				$this->writeHTML($content, false, false, false, false, '');

	}

	 function generarReporte1() {
	 	
		$this->AddPage();
		
		$with_col = $this->with_col;
         //adiciona glosa
		ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/ejecucion/cuerpo.php');
        $content = ob_get_clean();
		
		ob_start();
		include(dirname(__FILE__).'/../reportes/tpl/ejecucion/detalle.php');
        $content2 = ob_get_clean();
		$this->writeHTML($content.$content2, false, false, false, false, '');
		
		$this->SetFont ('helvetica', '', 5 , '', 'default', true );
		
		//$this->Ln(2);
		$this->revisarfinPagina($content);

		$this->Ln(2);
		
	} 

   function revisarfinPagina($content){
		$dimensions = $this->getPageDimensions();
		$hasBorder = false; //flag for fringe case
		
		$startY = $this->GetY();
		$test = $this->getNumLines($content, 80);
		
		//if (($startY + 10 * 6) + $dimensions['bm'] > ($dimensions['hk'])) {
		    
		//if ($startY +  $test > 250) {
		$auxiliar = 250;
		//if($this->page==1){
		//	$auxiliar = 250;	
		//}
       //var_dump('variable',$startY,$test,$auxiliar);
		if ($startY +  $test > $auxiliar) {
			//$this->Ln();
			//$this->subtotales('Pasa a la siguiente página. '.$startY);
			//$this->subtotales('Pasa a la siguiente página');
			$startY = $this->GetY();			
			if($startY < 240){//##61
				//$this->AddPage();
			}
			else{
				$this->AddPage();
			}
			
			
			//$this->writeHTML('<p>text'.$startY.'</p>', false, false, true, false, '');		    
		} 
	}
}
?>