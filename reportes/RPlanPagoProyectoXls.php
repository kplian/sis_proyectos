<?php
 
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

	}
	function imprimeCabecera($shit,$tipo) {
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
					$this->docexcel->getActiveSheet()->getStyle('A1:F1')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,1,'Estimacion de plan de Pagos');						
					//aplica estilo a una linea a una fila de celdas
					$this->docexcel->getActiveSheet()->getStyle('A2:F2')->applyFromArray($styleTitulos4);
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->applyFromArray($styleTitulos4);
				    //$this->docexcel->getActiveSheet()->getStyle('A4:G4')->applyFromArray($styleTitulos4);
					
					//$this->docexcel->getActiveSheet()->getStyle('A3:F3')->applyFromArray($styleTitulos2);
					
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0].''.(3).':'.$this->equivalencias[0].''.(3).'')->applyFromArray($styleTitulos2);
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[1].''.(3).':'.$this->equivalencias[1].''.(3).'')->applyFromArray($styleTitulos2);
				   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[2].''.(3).':'.$this->equivalencias[2].''.(3).'')->applyFromArray($styleTitulos2);
				   
				   $numeroColumnaIni =0;
				   $numeroColumnaFin = 11;
				   $col_arrays = $this->objParam->getParametro('gestion');
				   for ($i=0; $i < count($col_arrays) ; $i++) {
				   	$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[3+$numeroColumnaIni].''.(1).':'.$this->equivalencias[3+$numeroColumnaFin].''.(1).'')->applyFromArray($styleTitulos3);				
					$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[3+$numeroColumnaIni].''.(2).':'.$this->equivalencias[3+$numeroColumnaFin].''.(2).'')->applyFromArray($styleTitulos4);				
					$this->docexcel->getActiveSheet()->getStyle($this->equivalencias[3+$numeroColumnaIni].''.(3).':'.$this->equivalencias[3+$numeroColumnaFin].''.(3).'')->applyFromArray($styleTitulos2);
				   $numeroColumnaIni = $numeroColumnaIni + 12;
				   $numeroColumnaFin = $numeroColumnaFin + 12;      
					}
					
					
					
					
					//$this->docexcel->getActiveSheet()->getStyle('A3:V3')->applyFromArray($styleTitulos2);
					//SE COLOCA LAS DIMENSIONES QUE TENDRA LAS CELDAS
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(50);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(18);
					
					$this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('P')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('R')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(18);	
					$this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(18);						
					//*************************************Cabecera************************//
					//automaticamente selecciona el campo en las celdas
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					
					 //une celdas 
				
					 
					 $this->docexcel->getActiveSheet()->mergeCells('A1:F1');
					
					 
					//$this->docexcel->getActiveSheet()->mergeCells('B2:C2');
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
	
					
					//
					
					$this->docexcel->getActiveSheet()->setCellValue('A3','Nº');
					$this->docexcel->getActiveSheet()->setCellValue('B3','ITEM');
					$this->docexcel->getActiveSheet()->setCellValue('C3','PRECIO ESTIMADO');
					
					$col_arrays = $this->objParam->getParametro('gestion');
					$numeroColumna=0;
					for ($i=0; $i < count($col_arrays) ; $i++) {
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3+$numeroColumna, 3, 'ENERO '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4+$numeroColumna, 3, 'FEBRERO '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5+$numeroColumna, 3, 'MARZO '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6+$numeroColumna, 3, 'ABRIL '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7+$numeroColumna, 3, 'MAYO '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8+$numeroColumna, 3, 'JUNIO '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9+$numeroColumna, 3, 'JULIO '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10+$numeroColumna, 3, 'AGOSTO '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11+$numeroColumna, 3, 'SEPTIEMBRE '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12+$numeroColumna, 3, 'OCTUBRE '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13+$numeroColumna, 3, 'NOVIEMBRE '.$col_arrays[$i]['anio']);
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14+$numeroColumna, 3, 'DICIEMBRE '.$col_arrays[$i]['anio']);
					$numeroColumna = $numeroColumna + 12;
					}
					
					
					
				
				
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
		$fila = 4;
		//var_dump($this->objParam->getParametro('datos'));
		$datos = $this->objParam->getParametro('datos');
		$this->imprimeCabecera(1,'ITEMS');
		//var_dump($datos[0]['importe_doc']);
		$primero='';
		$conteoFactura=0;
		$col_arrays = $this->objParam->getParametro('gestion');
		$numeroColumna = 0;
		foreach ($datos as $value){


						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
				     	$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['item']);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['precio_estimado']);
						
					
			for ($i=0; $i < count($col_arrays) ; $i++) {
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3+$numeroColumna, $fila, $value['enero_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4+$numeroColumna, $fila, $value['febrero_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5+$numeroColumna, $fila, $value['marzo_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6+$numeroColumna, $fila, $value['abril_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7+$numeroColumna, $fila, $value['mayo_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8+$numeroColumna, $fila, $value['junio_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9+$numeroColumna, $fila, $value['julio_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10+$numeroColumna, $fila, $value['agosto_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11+$numeroColumna, $fila, $value['septiembre_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12+$numeroColumna, $fila, $value['octubre_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13+$numeroColumna, $fila, $value['noviembre_'.$col_arrays[$i]['anio']]);
						$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14+$numeroColumna, $fila, $value['diciembre_'.$col_arrays[$i]['anio']]);
					$numeroColumna = $numeroColumna + 12;
					}				

			$this->numero++;
			$fila++;
			$numeroColumna = 0;
			
		}
			//var_dump('EQUIVALENCIAS',$this->equivalencias[0]);
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,'TOTALES:');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,'=SUM('.$this->equivalencias[2].'4:'.$this->equivalencias[2].''.($fila-1).')');
		  
		   $numeroColumna = 0;
		   for ($i=0; $i < count($col_arrays) ; $i++) {
		  
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3+$numeroColumna,$fila,'=SUM('.$this->equivalencias[3+$numeroColumna].'4:'.$this->equivalencias[3+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4+$numeroColumna,$fila,'=SUM('.$this->equivalencias[4+$numeroColumna].'4:'.$this->equivalencias[4+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5+$numeroColumna,$fila,'=SUM('.$this->equivalencias[5+$numeroColumna].'4:'.$this->equivalencias[5+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6+$numeroColumna,$fila,'=SUM('.$this->equivalencias[6+$numeroColumna].'4:'.$this->equivalencias[6+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7+$numeroColumna,$fila,'=SUM('.$this->equivalencias[7+$numeroColumna].'4:'.$this->equivalencias[7+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8+$numeroColumna,$fila,'=SUM('.$this->equivalencias[8+$numeroColumna].'4:'.$this->equivalencias[8+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9+$numeroColumna,$fila,'=SUM('.$this->equivalencias[9+$numeroColumna].'4:'.$this->equivalencias[9+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10+$numeroColumna,$fila,'=SUM('.$this->equivalencias[10+$numeroColumna].'4:'.$this->equivalencias[10+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11+$numeroColumna,$fila,'=SUM('.$this->equivalencias[11+$numeroColumna].'4:'.$this->equivalencias[11+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12+$numeroColumna,$fila,'=SUM('.$this->equivalencias[12+$numeroColumna].'4:'.$this->equivalencias[12+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13+$numeroColumna,$fila,'=SUM('.$this->equivalencias[13+$numeroColumna].'4:'.$this->equivalencias[13+$numeroColumna].''.($fila-1).')');
		   $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14+$numeroColumna,$fila,'=SUM('.$this->equivalencias[14+$numeroColumna].'4:'.$this->equivalencias[14+$numeroColumna].''.($fila-1).')');
		   $numeroColumna = $numeroColumna + 12; 
			}
			   
		   
		   
		   
		   
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0].''.(4).':'.$this->equivalencias[0].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[1].''.(4).':'.$this->equivalencias[1].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[2].''.(4).':'.$this->equivalencias[2].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   
		   $numeroColumna = 0;
		   for ($i=0; $i < count($col_arrays) ; $i++) {
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[3+$numeroColumna].''.(4).':'.$this->equivalencias[3+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[4+$numeroColumna].''.(4).':'.$this->equivalencias[4+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[5+$numeroColumna].''.(4).':'.$this->equivalencias[5+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[6+$numeroColumna].''.(4).':'.$this->equivalencias[6+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[7+$numeroColumna].''.(4).':'.$this->equivalencias[7+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[8+$numeroColumna].''.(4).':'.$this->equivalencias[8+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[9+$numeroColumna].''.(4).':'.$this->equivalencias[9+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[10+$numeroColumna].''.(4).':'.$this->equivalencias[10+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[11+$numeroColumna].''.(4).':'.$this->equivalencias[11+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[12+$numeroColumna].''.(4).':'.$this->equivalencias[12+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[13+$numeroColumna].''.(4).':'.$this->equivalencias[13+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[14+$numeroColumna].''.(4).':'.$this->equivalencias[14+$numeroColumna].''.($fila-1).'')->applyFromArray($styleTitulos5);
		   $numeroColumna = $numeroColumna + 12;   
			}
		   
		    $numeroColumna = 0;
		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[2+$numeroColumna].''.(4).':'.$this->equivalencias[2+$numeroColumna].''.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		     for ($i=0; $i < count($col_arrays) ; $i++) {
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[3+$numeroColumna].''.(4).':'.$this->equivalencias[3+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[4+$numeroColumna].''.(4).':'.$this->equivalencias[4+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[5+$numeroColumna].''.(4).':'.$this->equivalencias[5+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[6+$numeroColumna].''.(4).':'.$this->equivalencias[6+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[7+$numeroColumna].''.(4).':'.$this->equivalencias[7+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[8+$numeroColumna].''.(4).':'.$this->equivalencias[8+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[9+$numeroColumna].''.(4).':'.$this->equivalencias[9+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[10+$numeroColumna].''.(4).':'.$this->equivalencias[10+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[11+$numeroColumna].''.(4).':'.$this->equivalencias[11+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[12+$numeroColumna].''.(4).':'.$this->equivalencias[12+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[13+$numeroColumna].''.(4).':'.$this->equivalencias[13+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  		  $this->docexcel->getActiveSheet()->getStyle(''.$this->equivalencias[14+$numeroColumna].''.(4).':'.$this->equivalencias[14+$numeroColumna].''.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  
		     $numeroColumna = $numeroColumna + 12;   
			}
		   
		   
		   
		   
		   /*
		   $this->docexcel->getActiveSheet()->getStyle('P'.(4).':P'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('Q'.(4).':Q'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('R'.(4).':R'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('S'.(4).':S'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('T'.(4).':T'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('U'.(4).':U'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('V'.(4).':V'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('W'.(4).':W'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('X'.(4).':X'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('Y'.(4).':Y'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('Z'.(4).':Z'.($fila-1).'')->applyFromArray($styleTitulos5);

		   $this->docexcel->getActiveSheet()->getStyle('F'.(4).':F'.($fila-1).'')->applyFromArray($styleTitulos5);
		   */
		   
		   
		   
		 /*$this->docexcel->getActiveSheet()->getStyle('G'.(4).':G'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('H'.(4).':H'.($fila).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('I'.(4).':I'.($fila).'')->applyFromArray($styleTitulos5);*/
		   
		   
		   $this->docexcel->getActiveSheet()->getStyle('D'.(4).':D'.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   $this->docexcel->getActiveSheet()->getStyle('E'.(4).':E'.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   $this->docexcel->getActiveSheet()->getStyle('F'.(4).':F'.($fila-1).'')->getNumberFormat()->setFormatCode('#,##0.00');	
		   $this->docexcel->getActiveSheet()->getStyle('D'.($fila).':F'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   
		   
		  	
					

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