<?php
/**
*@package pXP
*@file MODGanttProyecto.php
*@author  (admin)
*@date 18-04-2013 09:01:51
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODGanttProyecto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			

function listarGanttPro(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.f_gant_pro';// nombre procedimiento almacenado
        $this->transaccion='PRO_GATNREPRO_SEL';//nombre de la transaccion
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        
        $this->setTipoRetorno('record');
        
        $this->setParametro('id_proyecto','id_proyecto','integer');
		$this->setParametro('orden','orden','varchar');
        
       //Definicion de la lista del resultado del query
        $this->captura('id','integer');                          
        $this->captura('id_proceso_wf','integer');
        $this->captura('id_estado_wf','integer');
        $this->captura('tipo','varchar');       
        $this->captura('nombre','varchar');
        $this->captura('fecha_ini','TIMESTAMP');
       
        $this->captura('fecha_fin','TIMESTAMP');
		$this->captura('fecha_ini_real','TIMESTAMP');
       
        $this->captura('fecha_fin_real','TIMESTAMP'); 
		$this->captura('dias','integer');
		$this->captura('dias_real','integer');
      
        $this->captura('descripcion','varchar');
        $this->captura('id_siguiente','integer');
        $this->captura('tramite','varchar');
        $this->captura('codigo','varchar');
        
        $this->captura('id_funcionario','integer');
        $this->captura('funcionario','text');
        $this->captura('id_usuario','integer');
        $this->captura('cuenta','varchar');
        $this->captura('id_depto','integer');
        $this->captura('depto','varchar');
        $this->captura('nombre_usuario_ai','varchar');
		$this->captura('arbol','varchar');
		$this->captura('id_padre','integer');
		$this->captura('id_obs','integer');
		$this->captura('id_anterior','integer');
		$this->captura('etapa','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('disparador','varchar');
		$this->captura('grupo','boolean');
		
		
        
        
        //$this->captura('id_estructura_uo','integer');
        //Ejecuta la funcion
        $this->armarConsulta();
        
        //echo $this->getConsulta();
        $this->ejecutarConsulta();
        return $this->respuesta;

    }
		function listarGanttProItem(){
		        //Definicion de variables para ejecucion del procedimiento
		        $this->procedimiento='pro.f_gant_pro';// nombre procedimiento almacenado
		        $this->transaccion='PRO_GATNREPIT_SEL';//nombre de la transaccion
		        $this->tipo_procedimiento='SEL';//tipo de transaccion
		        $this->setCount(false);
		        
		        $this->setTipoRetorno('record');
		        
		        $this->setParametro('id_proyecto','id_proyecto','integer');
				$this->setParametro('orden','orden','varchar');
		        
		       //Definicion de la lista del resultado del query
		        $this->captura('id','integer');                          
		        $this->captura('id_proceso_wf','integer');
		        $this->captura('id_estado_wf','integer');
		        $this->captura('tipo','varchar');       
		        $this->captura('nombre','varchar');
		        $this->captura('fecha_ini','TIMESTAMP');
		       
		        $this->captura('fecha_fin','TIMESTAMP');
				$this->captura('fecha_ini_real','TIMESTAMP');
		       
		        $this->captura('fecha_fin_real','TIMESTAMP'); 
		      
		        $this->captura('descripcion','varchar');
		        $this->captura('id_siguiente','integer');
		        $this->captura('tramite','varchar');
		        $this->captura('codigo','varchar');
		        
		        $this->captura('id_funcionario','integer');
		        $this->captura('funcionario','text');
		        $this->captura('id_usuario','integer');
		        $this->captura('cuenta','varchar');
		        $this->captura('id_depto','integer');
		        $this->captura('depto','varchar');
		        $this->captura('nombre_usuario_ai','varchar');
				$this->captura('arbol','varchar');
				$this->captura('id_padre','integer');
				$this->captura('id_obs','integer');
				$this->captura('id_anterior','integer');
				$this->captura('etapa','varchar');
				$this->captura('estado_reg','varchar');
				$this->captura('disparador','varchar');
				$this->captura('agrupador','boolean');
				$this->captura('item','varchar');
				$this->captura('des_ingas','varchar');
				$this->captura('duplicado','boolean');
				
		        
		        
		        //$this->captura('id_estructura_uo','integer');
		        //Ejecuta la funcion
		        $this->armarConsulta();
		        
		        //echo $this->getConsulta();
		        $this->ejecutarConsulta();
				//var_dump($this->respuesta); exit;
		        return $this->respuesta;
		
		    }
		
}
?>