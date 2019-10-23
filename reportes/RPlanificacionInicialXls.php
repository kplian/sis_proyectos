<?php
 
class RPlanificacionInicialXls
{
	private $docexcel;
	private $objWriter;
	private $numero;
	private $equivalencias=array();
	private $objParam;
	public  $url_archivo;
	public  $filaInicio;
	public  $total;
	public  $total1;
	public  $total2;
	public  $total3;
	public  $total4;

	var $count;
	function __construct(CTParametro $objParam)
	{
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
		$datos_cm = $this->objParam->getParametro('datos_cm');
		$datos_proyecto = $this->objParam->getParametro('datos_proyecto');
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
					'rgb' => 'DBDBA0'
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
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
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
		if($shit==0){


					$this->docexcel->getActiveSheet()->getStyle('A1:L1')->applyFromArray($styleTitulos3);

					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,1,'Proyecto: '.$datos_proyecto[0]['codigo'].'-'.$datos_proyecto[0]['nombre']);
									
					//aplica estilo a una linea a una fila de celdas
					$this->docexcel->getActiveSheet()->getStyle('A2:L2')->applyFromArray($styleTitulos4);

					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,$datos_cm[0]['codigo'].'-'.$datos_cm[0]['nombre']);
					$this->docexcel->getActiveSheet()->mergeCells('A1:L1');
					$this->docexcel->getActiveSheet()->mergeCells('A2:L2');

					$this->docexcel->getActiveSheet()->getStyle('A4:L4')->applyFromArray($styleTitulos2);

					//$this->docexcel->getActiveSheet()->getStyle('A3:V3')->applyFromArray($styleTitulos2);
					//SE COLOCA LAS DIMENSIONES QUE TENDRA LAS CELDAS
					$this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(70);
					$this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(10);
					$this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);
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
					$this->docexcel->getActiveSheet()->getColumnDimension('S')->setWidth(20);
					$this->docexcel->getActiveSheet()->getColumnDimension('T')->setWidth(18);	
					$this->docexcel->getActiveSheet()->getColumnDimension('U')->setWidth(25);
					$this->docexcel->getActiveSheet()->getColumnDimension('V')->setWidth(25);						
					//*************************************Cabecera************************//
					//automaticamente selecciona el campo en las celdas
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					//$this->docexcel->getActiveSheet()->getStyle('A3:G3')->getAlignment()->setWrapText(true);
					
					 //une celdas 
					 



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

					$this->docexcel->getActiveSheet()->setCellValue('A4','Item');
					$this->docexcel->getActiveSheet()->setCellValue('B4','Descripción');
					$this->docexcel->getActiveSheet()->setCellValue('C4','Unid');
					$this->docexcel->getActiveSheet()->setCellValue('D4','Cant.');
					$this->docexcel->getActiveSheet()->setCellValue('E4','F.desadeanizacion');
					$this->docexcel->getActiveSheet()->setCellValue('F4','P.Unitario');
					$this->docexcel->getActiveSheet()->setCellValue('G4','F.escalaXFdistancia');
					$this->docexcel->getActiveSheet()->setCellValue('H4','P.Total');
					$this->docexcel->getActiveSheet()->setCellValue('I4','F.escalaXFdistancia');
					$this->docexcel->getActiveSheet()->setCellValue('J4','P.Unit');
					$this->docexcel->getActiveSheet()->setCellValue('K4','P.Unit');
					$this->docexcel->getActiveSheet()->setCellValue('L4','Totales');

					
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
			//blanco derecha negrita
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
		//blanco izquierda
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
		///BLANCO IZQUIERDA Negrita
		$styleTitulos7 = array(
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
		//blanco derecha
		$styleTitulos8 = array(
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

		$this->numero = 0;
		$fila = 5;
		$agrupador=0;
		$id_concepto_ingas=0;
		$datos = $this->objParam->getParametro('datos');
		//var_dump('$datos',$this->objParam);
		$this->imprimeCabecera(0,'Invitacion');
		foreach ($datos as $value) {

			if ($value['id_concepto_ingas'] != $id_concepto_ingas) {
				///La primera vez no entra
				if($id_concepto_ingas != 0) {
					$this->formatNumber($fila);
					$this->subtotales($fila);
					//estilo de los subtotales
					$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':A'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('F'.($fila).':F'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('G'.($fila).':G'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('I'.($fila).':I'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('J'.($fila).':J'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('K'.($fila).':K'.($fila).'')->applyFromArray($styleTitulos3);
					$this->docexcel->getActiveSheet()->getStyle('L'.($fila).':L'.($fila).'')->applyFromArray($styleTitulos3);
					$fila = $fila + 2;
				}


				$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':A'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('F'.($fila).':F'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('G'.($fila).':G'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('I'.($fila).':I'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('J'.($fila).':J'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('K'.($fila).':K'.($fila).'')->applyFromArray($styleTitulos7);
				$this->docexcel->getActiveSheet()->getStyle('L'.($fila).':L'.($fila).'')->applyFromArray($styleTitulos7);

				$this->cabeceraTabla($fila, $value);
				$this->filaInicio = $fila+1;
			} else {
				if($value['es_agrupador'] == 'si'){
					$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':A'.($fila).'')->applyFromArray($styleTitulos5);
					$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('F'.($fila).':F'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('G'.($fila).':G'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('I'.($fila).':I'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('J'.($fila).':J'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('K'.($fila).':K'.($fila).'')->applyFromArray($styleTitulos7);
					$this->docexcel->getActiveSheet()->getStyle('L'.($fila).':L'.($fila).'')->applyFromArray($styleTitulos7);

				}
				else{
					$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':A'.($fila).'')->applyFromArray($styleTitulos5);
					$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos6);
					$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('F'.($fila).':F'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('G'.($fila).':G'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('I'.($fila).':I'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('J'.($fila).':J'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('K'.($fila).':K'.($fila).'')->applyFromArray($styleTitulos8);
					$this->docexcel->getActiveSheet()->getStyle('L'.($fila).':L'.($fila).'')->applyFromArray($styleTitulos8);
					$this->numero++;
					$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $this->numero);
				}

				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['desc_coingd']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['desc_unidad_medida']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['cantidad_est']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['f_desadeanizacion']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['precio']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['f_escala_xfd_montaje']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['precio_montaje']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['f_escala_xfd_obra_civil']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['precio_obra_civil']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['precio_prueba']);
				$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['total']);
			}
			$id_concepto_ingas=$value['id_concepto_ingas'];
			$fila++;

		}

		//estilo del ultimo subtotales
		$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':A'.($fila).'')->applyFromArray($styleTitulos7);
		$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('F'.($fila).':F'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('G'.($fila).':G'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('I'.($fila).':I'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('J'.($fila).':J'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('K'.($fila).':K'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('L'.($fila).':L'.($fila).'')->applyFromArray($styleTitulos3);
		$this->subtotales($fila);
		$this->formatNumber($fila);
		$fila=$fila+2;
		//estilo del Total
		$this->docexcel->getActiveSheet()->getStyle('A'.($fila).':A'.($fila).'')->applyFromArray($styleTitulos7);
		$this->docexcel->getActiveSheet()->getStyle('B'.($fila).':B'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('C'.($fila).':C'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('D'.($fila).':D'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('E'.($fila).':E'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('F'.($fila).':F'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('G'.($fila).':G'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('H'.($fila).':H'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('I'.($fila).':I'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('J'.($fila).':J'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('K'.($fila).':K'.($fila).'')->applyFromArray($styleTitulos3);
		$this->docexcel->getActiveSheet()->getStyle('L'.($fila).':L'.($fila).'')->applyFromArray($styleTitulos3);
		$this->totales($fila);
		$this->formatNumber($fila);
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
	function cabeceraTabla($fila,$value) {
		$this->docexcel->getActiveSheet()->setCellValue("B$fila",$value['desc_coingd']);
		$this->docexcel->getActiveSheet()->setCellValue("F$fila",'Suministro');
		$this->docexcel->getActiveSheet()->setCellValue("H$fila",'Montaje');
		$this->docexcel->getActiveSheet()->setCellValue("J$fila",'O. Civiles');
		$this->docexcel->getActiveSheet()->setCellValue("K$fila",'Pruebas');
		$this->docexcel->getActiveSheet()->setCellValue("L$fila",'Total');



	}
	function subtotales($fila) {
		$filaInicio=$this->filaInicio;

		$this->docexcel->getActiveSheet()->setCellValue("B$fila",'Totales');
		$fila=$fila-1;

		$formula='=SUMPRODUCT(D'.$filaInicio.':D'.$fila.',E'.$filaInicio.':E'.$fila.',F'.$filaInicio.':F'.$fila.')';
		$formula1='=SUMPRODUCT(D'.$filaInicio.':D'.$fila.',G'.$filaInicio.':G'.$fila.',H'.$filaInicio.':H'.$fila.')';
		$formula2='=SUMPRODUCT(D'.$filaInicio.':D'.$fila.',I'.$filaInicio.':I'.$fila.',J'.$filaInicio.':J'.$fila.')';
		$formula3='=SUMPRODUCT(D'.$filaInicio.':D'.$fila.',K'.$filaInicio.':K'.$fila.')';
		$formula4='=SUM(L'.$filaInicio.':L'.($fila).')';

		$fila=$fila+1;

		$sum=PHPExcel_Calculation::getInstance($this->docexcel)->calculateFormula($formula,"F$fila", $this->docexcel->getActiveSheet()->getCell("F$fila"));
		$sum1=PHPExcel_Calculation::getInstance($this->docexcel)->calculateFormula($formula1,"H$fila", $this->docexcel->getActiveSheet()->getCell("H$fila"));
		$sum2=PHPExcel_Calculation::getInstance($this->docexcel)->calculateFormula($formula2,"J$fila", $this->docexcel->getActiveSheet()->getCell("J$fila"));
		$sum3=PHPExcel_Calculation::getInstance($this->docexcel)->calculateFormula($formula3,"K$fila", $this->docexcel->getActiveSheet()->getCell("K$fila"));
		$sum4=PHPExcel_Calculation::getInstance($this->docexcel)->calculateFormula($formula4,"L$fila", $this->docexcel->getActiveSheet()->getCell("L$fila"));

		$this->total= $this->total + $sum;
		$this->total1= $this->total1 + $sum1;
		$this->total2= $this->total2 + $sum2;
		$this->total3= $this->total3 + $sum3;
		$this->total4= $this->total4 + $sum4;


		//var_dump($sum);exit;
		$this->docexcel->getActiveSheet()->setCellValue("F$fila",$sum);
		$this->docexcel->getActiveSheet()->setCellValue("H$fila",$sum1);
		$this->docexcel->getActiveSheet()->setCellValue("J$fila",$sum2);
		$this->docexcel->getActiveSheet()->setCellValue("K$fila",$sum3);
		$this->docexcel->getActiveSheet()->setCellValue("L$fila",$sum4);


	}
	function totales($fila) {
		$this->docexcel->getActiveSheet()->setCellValue("B$fila",'*(no incluye impuestos ni costos financieros)');
		$this->docexcel->getActiveSheet()->setCellValue("C$fila",'TOTALES:');
		$this->docexcel->getActiveSheet()->setCellValue("F$fila",$this->total);
		$this->docexcel->getActiveSheet()->setCellValue("H$fila",$this->total1);
		$this->docexcel->getActiveSheet()->setCellValue("J$fila",$this->total2);
		$this->docexcel->getActiveSheet()->setCellValue("K$fila",$this->total3);
		$this->docexcel->getActiveSheet()->setCellValue("L$fila",$this->total4);

	}
	function formatNumber($fila) {
		$filaInicio=$this->filaInicio;
		$this->docexcel->getActiveSheet()->getStyle('D'.($filaInicio).':D'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('E'.($filaInicio).':E'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('F'.($filaInicio).':F'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('G'.($filaInicio).':G'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('H'.($filaInicio).':H'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('I'.($filaInicio).':I'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('J'.($filaInicio).':J'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('K'.($filaInicio).':K'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');
		$this->docexcel->getActiveSheet()->getStyle('L'.($filaInicio).':L'.($fila).'')->getNumberFormat()->setFormatCode('#,##0.00');

	}
	
}
?>
