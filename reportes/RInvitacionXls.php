<?php
 
class RInvitacionXls
{
	private $docexcel;
	private $objWriter;
	private $numero;
	private $equivalencias=array();
	private $objParam;
	public  $url_archivo;

	var $count;
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
					
					$this->count = 0;
					foreach ($datos as $value){
						if($value['estado']!= 'borrador'){
							$this->count = $this->count + 1; 
						}
					}	
					
					$this->docexcel->getActiveSheet()->getStyle('A1:G1')->applyFromArray($styleTitulos3);
					if ($this->count != 0){
					$this->docexcel->getActiveSheet()->getStyle('H1:N1')->applyFromArray($styleTitulos3);				
					}
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,1,'Invitacion');		
									
					//aplica estilo a una linea a una fila de celdas
					$this->docexcel->getActiveSheet()->getStyle('A2:G2')->applyFromArray($styleTitulos4);
					if ($this->count != 0){
					$this->docexcel->getActiveSheet()->getStyle('H2:N2')->applyFromArray($styleTitulos4);
					}
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,2,'PROYECTO');											
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,2,$datosProy[0]['codigo'].'-'.$datosProy[0]['nombre']);						
					
					$this->docexcel->getActiveSheet()->getStyle('A4:G4')->applyFromArray($styleTitulos2);
					if ($this->count != 0){
					$this->docexcel->getActiveSheet()->getStyle('H4:N4')->applyFromArray($styleTitulos2);
					}
					//$this->docexcel->getActiveSheet()->getStyle('A3:V3')->applyFromArray($styleTitulos2);
					//SE COLOCA LAS DIMENSIONES QUE TENDRA LAS CELDAS
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(15);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(50);
					$this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(18);
					$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(25);
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
					 
					if ($this->count != 0){ 
					$this->docexcel->getActiveSheet()->mergeCells('C1:K1');
					}else{
					$this->docexcel->getActiveSheet()->mergeCells('C1:E1');	
					}
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

					$this->docexcel->getActiveSheet()->setCellValue('A4','NRO');
					$this->docexcel->getActiveSheet()->setCellValue('B4','PRESOLICITUD');
					$this->docexcel->getActiveSheet()->setCellValue('C4','CODIGO');
					$this->docexcel->getActiveSheet()->setCellValue('D4','TIPO');
					$this->docexcel->getActiveSheet()->setCellValue('E4','NUM. TRAMITE');					
					$this->docexcel->getActiveSheet()->setCellValue('F4','ESTADO');
					$this->docexcel->getActiveSheet()->setCellValue('G4','FECHA ESTIMADA');
					
					if ($this->count != 0){
					$this->docexcel->getActiveSheet()->setCellValue('H4','FECHA REAL');
					$this->docexcel->getActiveSheet()->setCellValue('I4','LUGAR ENTREGA');
					$this->docexcel->getActiveSheet()->setCellValue('J4','DIAS PLAZO ENTREGA');
					$this->docexcel->getActiveSheet()->setCellValue('K4','MONEDA');
					
					$this->docexcel->getActiveSheet()->setCellValue('L4','DEPTO');
					$this->docexcel->getActiveSheet()->setCellValue('M4','CATEGORIA');
					$this->docexcel->getActiveSheet()->setCellValue('N4','GRUPO');
					}
					
					/*					
					$this->docexcel->getActiveSheet()->setCellValue('E6','BIEN/SERVICIO');
					$this->docexcel->getActiveSheet()->setCellValue('F6','TIPO');
					$this->docexcel->getActiveSheet()->setCellValue('G6','FECHA ESTIMADA');		
					$this->docexcel->getActiveSheet()->setCellValue('H6','DIAS FALTANTES');								
					$this->docexcel->getActiveSheet()->setCellValue('I6','PRECIO REFERENCIAL');
					$this->docexcel->getActiveSheet()->setCellValue('J6','CONCEPTO DE GASTO ASIGNADOS');
					$this->docexcel->getActiveSheet()->setCellValue('K6','DESCRIPCION');
					$this->docexcel->getActiveSheet()->setCellValue('L6','ESTADO');
					$this->docexcel->getActiveSheet()->setCellValue('M6','DIAS LANZAMIENTO');
					$this->docexcel->getActiveSheet()->setCellValue('N6','NRO TRAMITE');*/
					
				
				
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
		$fila = 5;

		$datos = $this->objParam->getParametro('datos');
		//var_dump($datos);exit;
		$this->imprimeCabecera(1,'Invitacion');
		foreach ($datos as $value){
				
										
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['pre_solicitud']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['codigo']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['tipo']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['nro_tramite']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['estado']);						
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['fecha']);		

			if ($value['estado'] != 'borrador') {
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['fecha_real']);		
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['lugar entrega']);		
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['dias_plazo_entrega']);		
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['desc_moneda']);		
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['desc_depto']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(12, $fila, $value['desc_categoria_compra']);		
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['desc_grupo']);		
				


			}		
			$fila++;
		 	$this->numero++;
		}	
						
		   $this->docexcel->getActiveSheet()->getStyle('A'.(5).':A'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('B'.(5).':B'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('C'.(5).':C'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('D'.(5).':D'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('E'.(5).':E'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('F'.(5).':F'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('G'.(5).':G'.($fila-1).'')->applyFromArray($styleTitulos5);
		  
		  	if ($this->count != 0){
		   $this->docexcel->getActiveSheet()->getStyle('H'.(5).':H'.($fila-1).'')->applyFromArray($styleTitulos5);		 
		   $this->docexcel->getActiveSheet()->getStyle('I'.(5).':I'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('H'.(5).':H'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('J'.(5).':J'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('K'.(5).':K'.($fila-1).'')->applyFromArray($styleTitulos6);
		   $this->docexcel->getActiveSheet()->getStyle('L'.(5).':L'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('M'.(5).':M'.($fila-1).'')->applyFromArray($styleTitulos5);
		   $this->docexcel->getActiveSheet()->getStyle('N'.(5).':N'.($fila-1).'')->applyFromArray($styleTitulos5);
			}
		  
			
			
				
		  // $this->docexcel->getActiveSheet()->getStyle('E'.(7).':E'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		  // $this->docexcel->getActiveSheet()->getStyle('G'.(7).':G'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		   $this->docexcel->getActiveSheet()->getStyle('I'.(7).':I'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');	


		
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
