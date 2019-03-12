<?php
/**
*@package pXP
*@file gen-MODFase.php
*@author  (admin)
*@date 25-10-2017 13:16:54
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE FORK		FECHA		AUTHOR			DESCRIPCION
 	#5		EndeEtr	09/01/2019	EGS				Se aumento el campo precio_item que es la suma de los items en la fase
 	#7		EndeEtr	20/02/2019	EGS				se agrego el campo nro items
*/

class MODFase extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarFase(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_sel';
		$this->transaccion='PRO_FASE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_fase','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('id_fase_fk','int4');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('observaciones','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('fecha_fin','date');
		$this->captura('estado','varchar');
	
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarFase(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_ime';
		$this->transaccion='PRO_FASE_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('id_fase_fk','id_fase_fk','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha_ini_real','fecha_ini_real','date');
		$this->setParametro('fecha_fin_real','fecha_fin_real','date');
		$this->setParametro('id_tipo_cc','id_tipo_cc','integer');
		$this->setParametro('estado_reg','estado_reg','varchar');
		
	

		//Ejecuta la instruccion
		$this->armarConsulta();
				//echo 'CCCCCCCCC: '.$this->armarConsulta;exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarFase(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_ime';
		$this->transaccion='PRO_FASE_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('id_fase_fk','id_fase_fk','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha_ini_real','fecha_ini_real','date');
		$this->setParametro('fecha_fin_real','fecha_fin_real','date');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarFase(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_fase_ime';
		$this->transaccion='PRO_FASE_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_fase','id_fase','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarFasesArb(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_fase_sel';
		$this-> setCount(false);
		$this->transaccion='PRO_FASEARB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('node','node','varchar');
		//$this->setParametro('id_ep','id_ep','integer');

		//Definicion de la lista del resultado del query
		//$this->captura('id','int4');
		$this->captura('id_fase_concepto_ingas','int4');
		$this->captura('id_fase','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('id_fase_fk','int4');
		$this->captura('descripcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('nombre','varchar');
		$this->captura('codigo','varchar');
		$this->captura('estado','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('observaciones','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		
		$this->captura('id_proceso_wf','integer');
		$this->captura('id_estado_wf','integer');
		$this->captura('nro_tramite','varchar');
		
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('tipo_nodo','varchar');
		
		$this->captura('fecha_ini_real','date');
		$this->captura('fecha_fin_real','date');
		$this->captura('precio_item','numeric');//#5
		$this->captura('nro_items','integer');//#7
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();

		return $this->respuesta;
    }
	
	function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'pro.ft_fase_ime';
        $this->transaccion = 'PRO_SIGEFAS_INS';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_fase','id_fase','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');		
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        $this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }


    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_fase_ime';
        $this->transaccion='PRO_ANTEFAS_IME';
        $this->tipo_procedimiento='IME';                
        //Define los parametros para la funcion
         $this->setParametro('id_fase','id_fase','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');		
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


}
?>