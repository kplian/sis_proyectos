<?php

/*
 *  ISSUE			FECHA:			AUTOR:					DESCRIPCION:
 	#6             24/01/2019       EGS                     se agrego style y se aplico a una columna
 */
class RPlanPagoProyectoXls
{
	private $docexcel;
	private $objWriter;
	private $numero;
	private $equivalencias=array();
	private $objParam;
	public  $url_archivo;
	var $liquido;
	var $descuento;
	var $importe;
	var $fila1;
	function __construct(CTParametro $objParam)
	{
		//var_dump($objParam);
		$this->objParam = $objParam;
		$this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
		set_time_limit(400);
		$cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
		$cacheSettings = array('memoryCacheSize'  => '10MB');
		PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);
		
		$this->docexcel = new PHPExcel();
		$this->docexcel->getProperties()->setCreator("PXP")
			->setLastModifiedBy("PXP")
			->setTitle($this->objParam->getParametro('titulo_archivo'))
			->setSubject($this->objParam->getParametro('titulo_archivo'))
			->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
			->setKeywords("office 2007 openxml php")
			->setCategory("Report File");
		$this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
		9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
		18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
		26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
		34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
		42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
		50=>'AY',51=>'AZ',
		52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
		60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
		68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
		76=>'BY',77=>'BZ');
		
		$this->meses=array( 0=>'enero',1=>'febrero',2=>'marzo',3=>'abril',4=>'mayo',5=>'junio',6=>'julio',7=>'agosto',8=>'septiembre',
		9=>'octubre',10=>'noviembre',11=>'diciembre',12=>'ENERO',13=>'FEBRERO',14=>'MARZO',15=>'ABRIL',16=>'MAYO',17=>'JUNIO',18=>'JULIO',19=>'AGOSTO',20=>'SEPTIEMBRE',
		21=>'OCTUBRE',22=>'NOVIEMBRE',23=>'DICIEMBRE');

	}
	function imprimeCabecera($shit,$tipo) {
		$datosProy = $this->objParam->getParametro('datos_proyecto');
		$datos = $this->objParam->getParametro('datos');
  	    //var_dump($datosProy);exit;
        $this->docexcel->createSheet($shit);
        $this->docexcel->setActiveSheetIndex($shit);
        $this->docexcel->getActiveSheet()->setTitle($tipo);
	
		$styleTitulos2 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '2D83C5'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 12,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '707A82'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
	$styleTitulos4 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => 'DB9E91'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		
		
		//
		if($shit==1){
				  foreach ($datos as $value){
								if ($value['nivel']== '1') {
									$precio_estimado=$precio_estimado+$value['precio_estimado'];									

									$total_prorrateo = $total_prorrateo + $value['total_prorrateado'];	
									$precio_real = $precio_real + $value['precio_real'];	
									
								}

							}

					$this->docexcel->getActiveSheet()->getStyle('A1:F1')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,1,'Estimacion de plan de Pagos');
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'Proyecto');						
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,2,$datosProy[0]['codigo'].'-'.$datosProy[0]['nombre']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,2,'Stea');	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,2,$datosProy[0]['importe_max']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,3,'Precio Estimado');	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,3,$precio_estimado);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,4,'Precio Actualizado');	
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,4,$precio_real);
					$this->docexcel->getActiveSheet()->getStyle('D'.(2).':D'.(2).'')->getNumberFormat()->setFormatCode('#,##0.00');
					$this->docexcel->getActiveSheet()->getStyle('D'.(3).':D'.(3).'')->getNumberFormat()->setFormatCode('#,##0.00');
					$this->docexcel->getActiveSheet()->getStyle('D'.(4).':D'.(4).'')->getNumberFormat()->setFormatCode('#,##0.00');
												
											
					//aplica estilo a una linea a una fila de celdas
					$this->docexcel->getActiveSheet()->getStyle('A2:F2')->applyFromArray($styleTitulos4);
					$this->docexcel->getActiveSheet()->getStyle('A3:F3')->applyFromArray($styleTitulos4);
					$this->docexcel->getActiveSheet()->getStyle('A4:F4')->applyFromArray($styleTitulos4);
					
				//los styles de la cabecera
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0].''.(5).':'.$this->equivalencias[0].''.(5).'')->applyFromArray($styleTitulos2);
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[1].''.(5).':'.$this->equivalencias[1].''.(5).'')->applyFromArray($styleTitulos2);
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[2].''.(5).':'.$this->equivalencias[2].''.(5).'')->applyFromArray($styleTitulos2);
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[3].''.(5).':'.$this->equivalencias[3].''.(5).'')->applyFromArray($styleTitulos2);
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[4].''.(5).':'.$this->equivalencias[4].''.(5).'')->applyFromArray($styleTitulos2);
				 
				   
				   $numeroColumnaIni =0;
				   $numeroColumnaFin = 11;
				   $col_arrays = $this->objParam->getParametro('gestion');
				   for ($i=0; $i < count($col_arrays) ; $i++) {
				   	$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[5+$numeroColumnaIni].''.(1).':'.$this->equivalencias[5+$numeroColumnaFin].''.(1).'')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[5+$numeroColumnaIni].''.(2).':'.$this->equivalencias[5+$numeroColumnaFin].''.(2).'')->applyFromArray($styleTitulos4);				
					$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[5+$numeroColumnaIni].''.(3).':'.$this->equivalencias[5+$numeroColumnaFin].''.(3).'')->applyFromArray($styleTitulos4);				
					$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[5+$numeroColumnaIni].''.(4).':'.$this->equivalencias[5+$numeroColumnaFin].''.(4).'')->applyFromArray($styleTitulos4);									
					$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[5+$numeroColumnaIni].''.(5).':'.$this->equivalencias[5+$numeroColumnaFin].''.(5).'')->applyFromArray($styleTitulos2);
				   $numeroColumnaIni = $numeroColumnaIni + 12;
				   $numeroColumnaFin = $numeroColumnaFin + 12;      
					}
					
					
					
					
					//$this->docexcel->getActiveSheet()->getStyle('A3:V3')->applyFromArray($styleTitulos2);
					//SE COLOCA LAS DIMENSIONES QUE TENDRA LAS CELDAS
					
					///incrementa la altura de la celda en el excel
					//$this->docexcel->getActiveSheet()->getRowDimension('B')->setRowHeight(10); 
					
					//this->docexcel->getActiveSheet()->getColumnDimension('B')->setAutoSize(true);
					
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);
					
					///Ancho de celdas del reporte
					$numeroColumna=0;
				   for ($i=0; $i < count($col_arrays) ; $i++) {
						 	for ($i=0; $i < 13; $i++) {
							 	 
							 $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[5+$numeroColumna+ $i])->setWidth(25);
							 
						 	}	
							$numeroColumna =$numeroColumna+12;
				   }	
					//*************************************Cabecera************************//
					//automaticamente selecciona el campo en las celdas
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					
					 //une celdas 
				
					 
					 $this->docexcel->getActiveSheet()->mergeCells('A1:F1');

					
					$this->docexcel->getActiveSheet()->setCellValue('A5','Nº');				
					$this->docexcel->getActiveSheet()->setCellValue('B5','ITEM');
					$this->docexcel->getActiveSheet()->setCellValue('C5','PRECIO ESTIMADO');
					$this->docexcel->getActiveSheet()->setCellValue('D5','TOTAL PRORRATEADO');				
					$this->docexcel->getActiveSheet()->setCellValue('E5','PRECIO ACTUALIZADO');				
					
					$col_arrays = $this->objParam->getParametro('gestion');
					$numeroColumna=0;
					///llenado de cabecera
					for ($i=0; $i < count($col_arrays) ; $i++) {

							$a = 5 + $numeroColumna;
							$b = 16 + $numeroColumna; 
							$m=12; 
						     for ($u=$a; $u <=$b ; $u++){
						     	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($u,5,$this->meses[$m].' '.$col_arrays[$i]['anio']);								
							 $m++;
							 }
					
					$numeroColumna = $numeroColumna + 12;
					}

		}		
	}

	function generarDatos()
	
	///azul  izquierdo
	{
		$styleTitulos3 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 10,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '2D83C5'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		///azul  derecha

		$styleTitulos4 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 10,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '2D83C5'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		//blanco derecho
		$styleTitulos5 = array(
			'font'  => array(
				'bold'  => false,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => '000000'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		///blanco izquierdo
		$styleTitulos6 = array(
			'font'  => array(
				'bold'  => false,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => '000000'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
				'setWrapText'=>true
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		//blanco derecho font rojo
		$styleTitulos7 = array(
			'font'  => array(
				'bold'  => false,
				'size'  => 11,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FF1700'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
			///azul  derecha font rojo

		$styleTitulos8 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 11,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FF1700'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => '2D83C5'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
	 ///naranja derecha
		$styleTitulos10 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 10,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => 'FFA500'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		$styleTitulos9 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 10,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => 'FFA500'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		//blanco Centro  #6 
		$styleTitulos11 = array(
			'font'  => array(
				'bold'  => false,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => '000000'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
			),
			'fill' => array(
				'type' => PHPExcel_Style_Fill::FILL_SOLID,
				'color' => array(
					'rgb' => 'FFFFFF'
				)
			),
			'borders' => array(
				'allborders' => array(
					'style' => PHPExcel_Style_Border::BORDER_THIN
				)
			)
		);
		$this->numero = 1;
		$fila = 6;
		//var_dump($this->objParam->getParametro('datos'));
		$datos = $this->objParam->getParametro('datos');
		$this->imprimeCabecera(1,'Plan Pago');
		//var_dump($datos[0]['importe_doc']);
		$precio=0;
		$conteoFactura=0;
		$col_arrays = $this->objParam->getParametro('gestion');
		$numeroColumna = 0;
		$total=0;
		foreach ($datos as $value){
						$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':A'.($fila).'')->applyFromArray($styleTitulos11);//#6 
			
						if ($value['nivel']== '3') {

							
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_padre'].'--'.$value['item']);
							///sumando los totales del padre nivel III en estimados y de los prorrateos en la fase 
							$total_prorrateo_III = 0;
							foreach ($datos as $valueData){
								if ($value['id_nivel_iii'] == $valueData['id_nivel_iii']&& $value['id'] != $valueData['id'] ) {
									$precio_III=$precio_III+$valueData['precio_estimado'];									

									$total_prorrateo_III = $total_prorrateo_III + $valueData['total_prorrateado'];	
									$precio_real_III = $precio_real_III + $valueData['precio_real'];	
									
								}

							}
							//Colocando style a la tabla
							$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos9);
							$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos10);
							
							//si los totales no son iguales se marca rojo
							if ($precio == $total_prorrateo) {
								$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos10);
							} else {
								$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos10);
							}
							$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos10);
							
							//seteamos los valores
							//$total=$total+$precio_III; //total precio estimado por fase padres
							//$totalPro = $totalPro + $total_prorrateo_III; //total prorrateo por fase padres
							//$totalReal= $totalReal+ $precio_real_III;//total precio real padres
							/*$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $precio_III);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $total_prorrateo_III);						
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $precio_real_III);*/
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['precio_estimado']);															
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,$value['total_prorrateado'] );
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,$value['precio_real'] );						
							$precio_III=0;
						    $total_prorrateo_III=0;
						    $precio_real_III =0;
						}
												
						if ($value['nivel']== '2') {

							
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_padre'].'--'.$value['item']);
							///sumando los totales del padre en estimados y de los prorrateos en la fase 
							$total_prorrateo = 0;
							foreach ($datos as $valueData){
								if ($value['id_nivel_ii'] == $valueData['id_nivel_ii'] && $value['id'] != $valueData['id']) {
									$precio=$precio+$valueData['precio_estimado'];									

									$total_prorrateo = $total_prorrateo + $valueData['total_prorrateado'];	
									$precio_real = $precio_real + $valueData['precio_real'];	
									
								}

							}
							//Colocando style a la tabla
							$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos3);
							$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos4);
							
							//si los totales no son iguales se marca rojo
							if ($precio == $total_prorrateo) {
								$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos4);
							} else {
								$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos8);
							}
							$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos4);
							
							//seteamos los valores
							$total=$total+$precio; //total precio estimado por fase padres
							$totalPro = $totalPro + $total_prorrateo; //total prorrateo por fase padres
							$totalReal= $totalReal+ $precio_real;//total precio real padres
							/*$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $precio);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $total_prorrateo);						
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $precio_real);*/
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['precio_estimado']);															
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,$value['total_prorrateado'] );
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,$value['precio_real'] );						
							
						
						}
						if ($value['nivel']== '1') {
							//Colocando style a la tabla si no es padre
							$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos6);
							$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos5);
							
							//si los totales no son iguales se marca rojo
							
							if ($value['precio_estimado'] == $value['total_prorrateado']) {
								$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos5);
							} else {
								$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos7);
							}
							$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos5);
							//seteamos los valores
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila,$value['item']);
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['precio_estimado']);															
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila,$value['total_prorrateado'] );
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila,$value['precio_real'] );													
																				
						}
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
						//$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['nombre_padre']);
						$this->docexcel->getActiveSheet()->getStyle("B$fila:B$fila")->getAlignment()->setWrapText(true);
						
			//insertamos los valores en las columnas 	
			for ($i=0; $i < count($col_arrays) ; $i++) {
				
							$a = 5 + $numeroColumna;
							$b = 16 + $numeroColumna; 
							$m=0; 
						     for ($u=$a; $u <=$b ; $u++){
								$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($u, $fila, $value[$this->meses[$m].'_'.$col_arrays[$i]['anio']]);
							 $m++;
							 }
					    $numeroColumna = $numeroColumna + 12;
					}				

			$this->numero++;
			$fila++;
			$numeroColumna = 0;
			$precio=0;
			$precio_real=0;
		}
			//var_dump('EQUIVALENCIAS',$this->equivalencias[0]);
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,'TOTALES:');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,$total);
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,$fila,$totalPro);
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,$fila,$totalReal);

		   $numeroColumna = 0;
		   //var_dump(count($col_arrays));exit;
		   for ($i=0; $i < count($col_arrays) ; $i++) {
		   	$a = 5 + $numeroColumna;
			$b = 16 + $numeroColumna;  
		     for ($u=$a; $u <=$b ; $u++) {
		     	///suma columnas  
				 $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($u,$fila,'=SUM('.$this->equivalencias[$u].'4:'.$this->equivalencias[$u].''.($fila-1).')');
				 //aplica formato en la columna
				 $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$u].''.(6).':'.$this->equivalencias[$u].''.($fila-1).'')->applyFromArray($styleTitulos5);
				 //aplica formato de numero en la columna
				 $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[$u].''.(6).':'.$this->equivalencias[$u].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
				 
			 }

		   $numeroColumna = $numeroColumna + 12;
		   }
		  // $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0].''.(4).':'.$this->equivalencias[0].''.($fila-1).'')->applyFromArray($styleTitulos5);
	   
		  $this->docexcel->getActiveSheet()->getStyle('C'.(4).':C'.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   $this->docexcel->getActiveSheet()->getStyle('D'.(4).':D'.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   $this->docexcel->getActiveSheet()->getStyle('E'.(4).':E'.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   $this->docexcel->getActiveSheet()->getStyle('F'.(4).':F'.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');	
		   $this->docexcel->getActiveSheet()->getStyle('C'.($fila).':E'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');

				//Marca desde una celda y una columna 
				/*
				$this->docexcel->getActiveSheet()->getStyle('D'.(3).':D'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('E'.(3).':E'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('F'.(3).':F'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('G'.(3).':G'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				/*
				$this->docexcel->getActiveSheet()->getStyle('K'.(3).':K'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('L'.(3).':L'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				
				
				$this->docexcel->getActiveSheet()->getStyle('M'.(3).':M'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('N'.(3).':N'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('O'.(3).':O'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				
				$this->docexcel->getActiveSheet()->getStyle('P'.(3).':P'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('Q'.(3).':Q'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('R'.(3).':R'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				$this->docexcel->getActiveSheet()->getStyle('S'.(3).':S'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				//*/
				/*
				$this->docexcel->getActiveSheet()->getStyle('A'.($fila+1).':S'.($fila+1).'')->applyFromArray($styleTitulos3);				
				//
				$this->docexcel->getActiveSheet()->getStyle('G'.($fila+1).':S'.($fila+1).'')->getNumberFormat()->setFormatCode('#,##0.00');
				//
						
				//$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fila+1,'TOTAL');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6,$fila+1,'=SUM(G4:G'.($fila-1).')');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila+1,'=SUM(H4:H'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila+1,'=SUM(I4:I'.($fila-1).')');				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,$fila+1,'=SUM(J4:J'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fila+1,'=SUM(K4:K'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11,$fila+1,'=SUM(L4:L'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12,$fila+1,'=SUM(M4:M'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13,$fila+1,'=SUM(N4:N'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14,$fila+1,'=SUM(O4:O'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15,$fila+1,'=SUM(P4:P'.($fila-1).')');
				
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(16,$fila+1,'=SUM(Q4:Q'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(17,$fila+1,'=SUM(R4:R'.($fila-1).')');
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(18,$fila+1,'=SUM(S4:S'.($fila-1).')');
											
				$formula = '=SUM(G1:G'.($fila-1).')';
				
				$sum = PHPExcel_Calculation::getInstance($this->docexcel)->calculateFormula($formula, 'A1', $this->docexcel->getActiveSheet()->getCell('A1'));
		
		$this->generarResultado(1,$sum);*/
		
	}

	function generarReporte(){
		$this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
		$this->objWriter->save($this->url_archivo);
	}
	
	
	function generarResultado ($sheet,$a){
		$this->docexcel->createSheet($sheet);
		$this->docexcel->setActiveSheetIndex(0);
		$this->imprimeCabecera($sheet,'TOTAL');
		$this->docexcel->getActiveSheet()->setTitle('TOTALES');
		$this->docexcel->getActiveSheet()->setCellValue('E5','TOTAL');
		$this->docexcel->getActiveSheet()->setCellValue('F5',$a);
		
	}
	
}
?>
