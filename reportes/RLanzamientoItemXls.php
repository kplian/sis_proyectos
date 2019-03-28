<?php
 
class RLanzamientoItemXls
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
		//var_dump('report',$objParam);
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

	}
	function imprimeCabecera($shit,$tipo) {
		$datosProy = $this->objParam->getParametro('datos_proyecto');
		
		$datos = $this->objParam->getParametro('datos');
  //var_dump($shit);
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
		/*	$this->docexcel->getActiveSheet()->getStyle('D1:J1')->applyFromArray($styleTitulos3);				
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,1,'FACTURAS Y SUS COBROS');	
				*/
					$this->docexcel->getActiveSheet()->getStyle('C1:K1')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,1,'Lanzamiento Items');		
									
					//aplica estilo a una linea a una fila de celdas
					$this->docexcel->getActiveSheet()->getStyle('A2:N2')->applyFromArray($styleTitulos4);
					
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,2,'PROYECTO');											
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,2,$datosProy[0]['codigo'].'-'.$datosProy[0]['nombre']);	
					
					$this->docexcel->getActiveSheet()->getStyle('A3:N3')->applyFromArray($styleTitulos4);
					$this->docexcel->getActiveSheet()->getStyle('A4:N4')->applyFromArray($styleTitulos4);
					
					$this->docexcel->getActiveSheet()->getStyle('A6:N6')->applyFromArray($styleTitulos2);
					//$this->docexcel->getActiveSheet()->getStyle('A3:V3')->applyFromArray($styleTitulos2);
					//SE COLOCA LAS DIMENSIONES QUE TENDRA LAS CELDAS
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(50);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(35);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(50);
					$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(50);
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(50);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(18);
					
					$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(18);	
					$this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(25);
					$this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(25);						
					//*************************************Cabecera************************//
					//automaticamente selecciona el campo en las celdas
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					
					 //une celdas 
					$this->docexcel->getActiveSheet()->mergeCells('C1:K1');
					//$this->docexcel->getActiveSheet()->mergeCells('A2:B2');
					//$this->docexcel->getActiveSheet()->mergeCells('A3:B3');
					//$this->docexcel->getActiveSheet()->mergeCells('A4:B4');
					
					/*
					$this->docexcel->getActiveSheet()->mergeCells('B2:B3');
					$this->docexcel->getActiveSheet()->mergeCells('C2:C3');
					$this->docexcel->getActiveSheet()->mergeCells('D2:D3');
					$this->docexcel->getActiveSheet()->mergeCells('E2:E3');
					$this->docexcel->getActiveSheet()->mergeCells('F2:F3');
					$this->docexcel->getActiveSheet()->mergeCells('G2:G3');
					
					$this->docexcel->getActiveSheet()->mergeCells('P2:P3');								
					$this->docexcel->getActiveSheet()->mergeCells('Q2:Q3');
					$this->docexcel->getActiveSheet()->mergeCells('R2:R3');				
					$this->docexcel->getActiveSheet()->mergeCells('S2:S3');
					$this->docexcel->getActiveSheet()->mergeCells('T2:T3');
					$this->docexcel->getActiveSheet()->mergeCells('U2:U3');
					$this->docexcel->getActiveSheet()->mergeCells('V2:V3');
									
					
					$this->docexcel->getActiveSheet()->mergeCells('H2:I2');
					$this->docexcel->getActiveSheet()->mergeCells('J2:K2');
					$this->docexcel->getActiveSheet()->mergeCells('L2:M2');
					$this->docexcel->getActiveSheet()->mergeCells('N2:O2');*/

					$this->docexcel->getActiveSheet()->setCellValue('A6','Nº');
					$this->docexcel->getActiveSheet()->setCellValue('B6','MES');
					$this->docexcel->getActiveSheet()->setCellValue('C6','FASE');
					$this->docexcel->getActiveSheet()->setCellValue('D6','ENCARGADO');					
					$this->docexcel->getActiveSheet()->setCellValue('E6','BIEN/SERVICIO');
					$this->docexcel->getActiveSheet()->setCellValue('F6','TIPO');
					$this->docexcel->getActiveSheet()->setCellValue('G6','FECHA ESTIMADA');		
					$this->docexcel->getActiveSheet()->setCellValue('H6','DIAS FALTANTES');								
					$this->docexcel->getActiveSheet()->setCellValue('I6','PRECIO REFERENCIAL');
					$this->docexcel->getActiveSheet()->setCellValue('J6','CONCEPTO DE GASTO ASIGNADOS');
					$this->docexcel->getActiveSheet()->setCellValue('K6','DESCRIPCION');
					$this->docexcel->getActiveSheet()->setCellValue('L6','ESTADO');
					$this->docexcel->getActiveSheet()->setCellValue('M6','DIAS LANZAMIENTO');
					$this->docexcel->getActiveSheet()->setCellValue('N6','NRO TRAMITE');
					
				
				
		}		
	}

	function generarDatos()
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
				$styleTitulos5 = array(
			'font'  => array(
				'bold'  => true,
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
		$styleTitulos6 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => '000000'
				)
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
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
				$styleTitulos7 = array(
			'font'  => array(
				'bold'  => true,
				'size'  => 9,
				'name'  => 'Arial',
				'color' => array(
					'rgb' => 'FF2D00'
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
		
		
		$this->numero = 1;
		$fila = 7;
		//var_dump($this->objParam->getParametro('datos'));
		
		$mes='';
		$id_fase = 0;
		$id_funcionario = 0;
		$id_fase_concepto_ingas = 0;
		$tipo = '';
		$newDate = '';
		$dias = 0;
		$precio = 0;
		$datos = $this->objParam->getParametro('datos');
		$this->imprimeCabecera(1,'Items');
		foreach ($datos as $value){
					$mes_gestion='';
					if ($value['mes_item']== 1 ) {
						$mes_gestion = 'Enero-'.$value['gestion_item']; 
					}
					if ($value['mes_item']== 2 ) {
						$mes_gestion = 'Febrero-'.$value['gestion_item']; 
					}
					if ($value['mes_item']== 3 ) {
						$mes_gestion = 'Marzo-'.$value['gestion_item']; 
					}
					if ($value['mes_item']== 4 ) {
						$mes_gestion = 'Abril-'.$value['gestion_item']; 
										}
					if ($value['mes_item']== 5 ) {
						$mes_gestion = 'Mayo-'.$value['gestion_item']; 
										}
					if ($value['mes_item']== 6 ) {
						$mes_gestion = 'Junio-'.$value['gestion_item']; 
										}
					if ($value['mes_item']== 7 ) {
						$mes_gestion = 'Julio-'.$value['gestion_item']; 
										}
					if ($value['mes_item']== 8 ) {
						$mes_gestion = 'Agosto-'.$value['gestion_item']; 
					}
					if ($value['mes_item']== 9 ) {
						$mes_gestion = 'Septiembre-'.$value['gestion_item']; 
					}
					if ($value['mes_item']== 10 ) {
						$mes_gestion = 'Octubre-'.$value['gestion_item']; 
					}
					if ($value['mes_item']== 11) {
						$mes_gestion = 'Noviembre-'.$value['gestion_item']; 
										}
					if ($value['mes_item']== 12 ) {
						$mes_gestion = 'Diciembre-'.$value['gestion_item']; 
										}
					if ($value['mes_item']== '' ) {
						$mes_gestion = 'Sin Fecha'; 
										}
							$originalDateUP = $value['fecha_estimada'];
							$newDateUP = date("d/m/Y", strtotime($originalDateUP));
				
				If ($mes != $mes_gestion){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
				     	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $mes_gestion);

						
						
				}
				else{
						$this->docexcel->getActiveSheet()->mergeCells('A'.($fila-1).':A'.$fila.'');
						$this->docexcel->getActiveSheet()->mergeCells('B'.($fila-1).':B'.$fila.'');
						
				}
				If ($id_fase != $value['id_fase'] ){
				        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['nombre_fase']);
				}
				else{
						if ($mes == $mes_gestion) {
							$this->docexcel->getActiveSheet()->mergeCells('C'.($fila-1).':C'.$fila.'');
						}
						else{
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['nombre_fase']);							
						}
				}
				
				If ($id_funcionario != $value['id_funcionario'] ){
				        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_funcionario']);
				}
				else{
						if ($mes == $mes_gestion) {
							$this->docexcel->getActiveSheet()->mergeCells('D'.($fila-1).':D'.$fila.'');
						}
						else{
							$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['desc_funcionario']);							
						}
				}
				if ($id_fase_concepto_ingas != $value['id_fase_concepto_ingas'] ){
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['desc_ingas']);
						
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['tipo']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila,  $newDateUP);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['dias']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['precio']);
							
				}
				else{
						if ($mes == $mes_gestion) {
							$this->docexcel->getActiveSheet()->mergeCells('E'.($fila-1).':E'.$fila.'');
							
							$this->docexcel->getActiveSheet()->mergeCells('F'.($fila-1).':F'.$fila.'');
							$this->docexcel->getActiveSheet()->mergeCells('G'.($fila-1).':G'.$fila.'');
							$this->docexcel->getActiveSheet()->mergeCells('H'.($fila-1).':H'.$fila.'');
							$this->docexcel->getActiveSheet()->mergeCells('I'.($fila-1).':I'.$fila.'');							
							
							
						}
						else{
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['desc_ingas']);
						
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['tipo']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila,  $newDateUP);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['dias']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['precio']);
							
							
						}
				   }

						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['desc_ingas_invd']);		
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['descripcion']);												
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['estado_lanzado']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['dias_lanzado']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['num_tramite']);
						
						$this->numero++;
						
						if ($value['dias']>=0) {
								
							$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos5);
							
						} else {
							$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos7);
							
						}

			$mes = $mes_gestion;
			$id_fase=$value['id_fase'];
			$id_funcionario = $value['id_funcionario'] ;
			$tipo = $value['tipo'];
			$newDate = $newDateUP;
			$dias = $value['dias'];
			$precio = $value['precio'] ;
			$id_fase_concepto_ingas = $value['id_fase_concepto_ingas'];
			$fila++;
		
		}	
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7,$fila,'TOTALES:');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8,$fila,'=SUM(I7:I'.($fila-1).')');
			
			
		   $this->docexcel->getActiveSheet()->getStyle('A'.(7).':A'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('B'.(7).':B'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('C'.(7).':C'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('D'.(7).':D'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('E'.(7).':E'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('F'.(7).':F'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('G'.(7).':G'.($fila-1).'')->applyFromArray($styleTitulos5);
		  // $this->docexcel->getActiveSheet()->getStyle('H'.(7).':H'.($fila).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('I'.(7).':I'.($fila).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('H'.(7).':H'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('J'.(7).':J'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('K'.(7).':K'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('L'.(7).':L'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('M'.(7).':M'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('N'.(7).':N'.($fila-1).'')->applyFromArray($styleTitulos5);
		   
		  
			
			
				
		  // $this->docexcel->getActiveSheet()->getStyle('E'.(7).':E'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  // $this->docexcel->getActiveSheet()->getStyle('G'.(7).':G'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   $this->docexcel->getActiveSheet()->getStyle('I'.(7).':I'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');	

		  	
					

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
	//
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
