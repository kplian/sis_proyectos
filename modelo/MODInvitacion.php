<?php
/**
*@package pXP
*@file gen-MODInvitacion.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:20
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 	ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
    #7	  endeETR		29/01/2019	EGS				se creo las funciones para listar combos procesos de solicitudes de compra y sus detalles e insertar una invitacion regularizada  
    #15	Etr				31/07/2019	EGS		    se agrego boton para lanzamientos y reporte invitaciones
 
 */

class MODInvitacion extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarInvitacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_invitacion_sel';
		$this->transaccion='PRO_IVT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_invitacion','int4');
		$this->captura('id_proyecto','int4');
		$this->captura('codigo','varchar');
		$this->captura('fecha','date');
		$this->captura('descripcion','varchar');
		$this->captura('fecha_real','date');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_estado_wf','int4');
		$this->captura('nro_tramite','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');

		$this->captura('id_funcionario','int4');
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
		$this->captura('tipo','varchar');
		$this->captura('lugar_entrega','varchar');
		$this->captura('dias_plazo_entrega','int4');

		$this->captura('desc_moneda','varchar');
		$this->captura('desc_funcionario','varchar');
		$this->captura('desc_depto','varchar');
		$this->captura('id_proceso_wf','int4');
        $this->captura('anio','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('id_categoria_compra','int4');
		$this->captura('id_solicitud','int4');
		
		$this->captura('id_presolicitud','int4');
		$this->captura('pre_solicitud','varchar');
		$this->captura('id_grupo','int4');
		
		$this->captura('desc_categoria_compra','varchar');
		$this->captura('desc_grupo','varchar');
		$this->captura('id_invitacion_fk','int4');//#15





		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarInvitacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_invitacion_ime';
		$this->transaccion='PRO_IVT_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('fecha_real','fecha_real','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');

		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('lugar_entrega','lugar_entrega','varchar');
		$this->setParametro('dias_plazo_entrega','dias_plazo_entrega','int4');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		
		$this->setParametro('pre_solicitud','pre_solicitud','varchar');
		$this->setParametro('id_grupo','id_grupo','int4');
		$this->setParametro('id_invitacion_fk','id_invitacion_fk','int4');//#15

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarInvitacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_invitacion_ime';
		$this->transaccion='PRO_IVT_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_invitacion','id_invitacion','int4');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('fecha_real','fecha_real','date');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('nro_tramite','nro_tramite','varchar');

		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('lugar_entrega','lugar_entrega','varchar');
		$this->setParametro('dias_plazo_entrega','dias_plazo_entrega','int4');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		
		$this->setParametro('pre_solicitud','pre_solicitud','varchar');
		$this->setParametro('id_grupo','id_grupo','int4');
		$this->setParametro('id_invitacion_fk','id_invitacion_fk','int4');//#15
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarInvitacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_invitacion_ime';
		$this->transaccion='PRO_IVT_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_invitacion','id_invitacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}



	function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'pro.ft_invitacion_ime';
        $this->transaccion = 'PRO_SIGEIVT_INS';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_invitacion','id_invitacion','int4');
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
        $this->procedimiento='pro.ft_invitacion_ime';
        $this->transaccion='PRO_ANTEIVT_IME';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
         $this->setParametro('id_invitacion','id_invitacion','int4');
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
	function listarSolicituCompraCombo(){//#7
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_invitacion_sel';
		$this->transaccion='PRO_IVTADQ_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_estado_wf','int4');
		$this->captura('id_solicitud','int4');
		$this->captura('fecha_soli','date');
		$this->captura('id_tipo_estado','int4');
		$this->captura('num_tramite','varchar');
		$this->captura('codigo_estado','varchar');		
		$this->captura('cantidad_detalle_sol','integer');
		$this->captura('cantidad_detalle_inv','integer');
		$this->captura('id_moneda','int4');
		$this->captura('codigo_moneda','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	function listarSolicituCompraDetCombo(){//#7
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_invitacion_sel';
		$this->transaccion='PRO_INDADQ_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id','integer');
		$this->captura('id_solicitud_det','int4');
		$this->captura('id_solicitud','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('desc_ingas','varchar');
		$this->captura('cantidad','integer');
		$this->captura('precio_unitario','numeric');
		$this->captura('precio_total','numeric');	
		$this->captura('id_centro_costo','int4');
		$this->captura('descripcion','text');
		$this->captura('codigo_moneda','varchar');
		$this->captura('precio_total_conversion','numeric');
		$this->captura('codigo_moneda_total_conversion','varchar');
		
			
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	function invitacionRegularizada(){ //#7
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.f_inserta_invitacion';
		$this->transaccion='PRO_IVTREG_IME';
		$this->tipo_procedimiento='IME';//tipo de transaccion
		$this->setParametro('p_id_usuario','p_id_usuario','int4');
		
		//Definicion de la lista del resultado del query
		$this->setParametro('id_fase','id_fase','int4');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('id_fase_concepto_ingas','id_fase_concepto_ingas','int4');
		$this->setParametro('id_solicitud_det','id_solicitud_det','varchar');
		$this->setParametro('id_invitacion','id_invitacion','int4');
		$this->setParametro('asociar_invitacion','asociar_invitacion','varchar');
		
	
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function estadosInvitacion(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_invitacion_ime';
        $this->transaccion='PRO_ESTIVT_IME';
        $this->tipo_procedimiento='IME';//tipo de transaccion
        //$this->setCount(false);
        //Definicion de la lista del resultado del query
        $this->setParametro('id_invitacion','id_invitacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump('rsp', $this->respuesta);
        //Devuelve la respuesta
        return $this->respuesta;
    }

 

}
?>