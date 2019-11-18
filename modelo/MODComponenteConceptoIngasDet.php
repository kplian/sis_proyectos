<?php
/**
*@package pXP
*@file gen-MODComponenteConceptoIngasDet.php
*@author  (admin)
*@date 22-07-2019 14:50:29
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
#ISSUE				FECHA				AUTOR				DESCRIPCION
#21 EndeEtr         30/08/2019          EGS                 Se adiciona el id del proyecto
#25 EndeEtr         10/09/2019          EGS                 Adicion de cmp precio montaje, precio obci y precio pruebas
#26 EndeEtr         12/09/2019          EGS                 se muuestra la ucm
#27 EndeEtr         16/09/2019          EGS                 Se agrego campo f_desadeanizacion,f_seguridad,f_escala_xfd_montaje,f_escala_xfd_obra_civil,porc_prueba
#28 EndeEtr         16/09/2019          EGS                 se carga porc_prueba
#39 EndeEtr         17/10/2019          EGS                 Se agrega WF
#44 EndeEtr         11/11/2019          EGS                 seagregan campos de invitaciones referenciales de precios
 */

class MODComponenteConceptoIngasDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_sel';
		$this->transaccion='PRO_COMINDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->capturaCount('total_precio_det','numeric');
        $this->capturaCount('total_precio_mon','numeric');
        $this->capturaCount('total_precio_oc','numeric');
        $this->capturaCount('total_precio_pru','numeric');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_componente_concepto_ingas_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_concepto_ingas_det','int4');
		$this->captura('id_componente_concepto_ingas','int4');
		$this->captura('cantidad_est','numeric');
		$this->captura('precio','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_ingas_det','varchar');
        $this->captura('id_unidad_constructiva_macro','int4');//26
        $this->captura('codigo_uc','varchar');
        $this->captura('desc_agrupador','varchar');
        $this->captura('aislacion','varchar');
        $this->captura('tension','varchar');
        $this->captura('peso','numeric');
        $this->captura('id_proyecto','int4');//#21
        $this->captura('id_concepto_ingas','int4');//#21
        $this->captura('precio_montaje','numeric');//#25
        $this->captura('precio_obra_civil','numeric');//#25
        $this->captura('precio_prueba','numeric');//#25
        $this->captura('f_desadeanizacion','numeric');//#27
        $this->captura('f_seguridad','numeric');//#27
        $this->captura('f_escala_xfd_montaje','numeric');//#27
        $this->captura('f_escala_xfd_obra_civil','numeric');//#27
        $this->captura('porc_prueba','numeric');//#28
        $this->captura('tipo_configuracion','varchar');
        $this->captura('conductor','varchar');
        $this->captura('id_unidad_medida','integer');
        $this->captura('desc_unidad','varchar');
        $this->captura('precio_total_det','numeric');
        $this->captura('precio_total_mon','numeric');
        $this->captura('precio_total_oc','numeric');
        $this->captura('precio_total_pru','numeric');
        $this->captura('nro_tramite','varchar');//#39
        $this->captura('id_proceso_wf','integer');//#39
        $this->captura('id_estado_wf','integer');//#39
        $this->captura('estado','varchar');//#39
        $this->captura('codigo_inv_sumi','varchar');//#45
        $this->captura('codigo_inv_montaje','varchar');//#45
        $this->captura('codigo_inv_oc','varchar');//#45
        $this->captura('id_invitacion_dets','varchar');
        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
		$this->transaccion='PRO_COMINDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_concepto_ingas_det','id_concepto_ingas_det','int4');
		$this->setParametro('id_componente_concepto_ingas','id_componente_concepto_ingas','int4');
		$this->setParametro('cantidad_est','cantidad_est','numeric');
		$this->setParametro('precio','precio','numeric');
        $this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');
        $this->setParametro('aislacion','aislacion','varchar');
        $this->setParametro('tension','tension','varchar');
        $this->setParametro('peso','peso','numeric');
        $this->setParametro('precio_montaje','precio_montaje','numeric');//#25
        $this->setParametro('precio_obra_civil','precio_obra_civil','numeric');//#25
        $this->setParametro('precio_prueba','precio_prueba','numeric');//#25
        $this->setParametro('f_desadeanizacion','f_desadeanizacion','numeric');//#27
        $this->setParametro('f_seguridad','f_seguridad','numeric');//#27
        $this->setParametro('f_escala_xfd_montaje','f_escala_xfd_montaje','numeric');//#27
        $this->setParametro('f_escala_xfd_obra_civil','f_escala_xfd_obra_civil','numeric');//#27
        $this->setParametro('porc_prueba','porc_prueba','numeric');
        $this->setParametro('codigo_inv_sumi','codigo_inv_sumi','varchar');//#45
        $this->setParametro('codigo_inv_montaje','codigo_inv_montaje','varchar');//#45
        $this->setParametro('codigo_inv_oc','codigo_inv_oc','varchar');//#45
        $this->setParametro('id_invitacion_dets','id_invitacion_dets','integer[]');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
		$this->transaccion='PRO_COMINDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_componente_concepto_ingas_det','id_componente_concepto_ingas_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_concepto_ingas_det','id_concepto_ingas_det','int4');
		$this->setParametro('id_componente_concepto_ingas','id_componente_concepto_ingas','int4');
		$this->setParametro('cantidad_est','cantidad_est','numeric');
		$this->setParametro('precio','precio','numeric');
        $this->setParametro('id_unidad_constructiva','id_unidad_constructiva','int4');
        $this->setParametro('aislacion','aislacion','varchar');
        $this->setParametro('tension','tension','varchar');
        $this->setParametro('peso','peso','numeric');
        $this->setParametro('precio_montaje','precio_montaje','numeric');//#25
        $this->setParametro('precio_obra_civil','precio_obra_civil','numeric');//#25
        $this->setParametro('precio_prueba','precio_prueba','numeric');//#25
        $this->setParametro('f_desadeanizacion','f_desadeanizacion','numeric');//#27
        $this->setParametro('f_seguridad','f_seguridad','numeric');//#27
        $this->setParametro('f_escala_xfd_montaje','f_escala_xfd_montaje','numeric');//#27
        $this->setParametro('f_escala_xfd_obra_civil','f_escala_xfd_obra_civil','numeric');//#27
        $this->setParametro('porc_prueba','porc_prueba','numeric');
        $this->setParametro('codigo_inv_sumi','codigo_inv_sumi','varchar');//#45
        $this->setParametro('codigo_inv_montaje','codigo_inv_montaje','varchar');//#45
        $this->setParametro('codigo_inv_oc','codigo_inv_oc','varchar');//#45
        $this->setParametro('id_invitacion_dets','id_invitacion_dets','integer[]');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarComponenteConceptoIngasDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
		$this->transaccion='PRO_COMINDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_componente_concepto_ingas_det','id_componente_concepto_ingas_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function validacionMultiple(){//#
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
        $this->transaccion='PRO_VALIMUL_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('data_json','data_json','json_text');
        //$this->captura('id_tipo_estado','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump('$this->respuesta',$this->respuesta);exit;
        return $this->respuesta;

    }

    function siguienteEstadoMultiple(){//#
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_componente_concepto_ingas_det_ime';
        $this->transaccion='PRO_SIGESTMUL_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('data_json','data_json','json_text');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','integer');
        $this->setParametro('id_tipo_estado','id_tipo_estado','integer');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        //var_dump('$this->respuesta',$this->respuesta);exit;
        return $this->respuesta;

    }
    function listarPrecioHistoricoInvitacion(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.f_precio_historico_inv';
        $this->transaccion='PRO_PREHINV_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_invitacion_det','int4');
        $this->captura('codigo','varchar');
        $this->captura('id_solicitud_det','int4');
        $this->captura('precio_unitario_mb','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>