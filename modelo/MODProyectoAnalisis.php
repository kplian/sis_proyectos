<?php
/****************************************************************************************
*@package pXP
*@file gen-MODProyectoAnalisis.php
*@author  (egutierrez)
*@date 29-09-2020 12:44:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                29-09-2020 12:44:10    egutierrez             Creacion    
  #MDID-8            08/10/2020              EGS                 Se agrega Campos de WF
  #MDID-10           13/10/2020              EGS                 Se agrega filto por tipo_cc
 *#MDID-11              29/10/2020           EGS                 se agrega saldos para el panel


 *****************************************************************************************/

class MODProyectoAnalisis extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarProyectoAnalisis(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_proyecto_analisis_sel';
        $this->transaccion='PRO_PROANA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_proyecto_analisis','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_proyecto','int4');
		$this->captura('fecha','date');
		$this->captura('glosa','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_proveedor','int4');
        $this->captura('desc_proveedor','varchar');
        $this->captura('saldo_activo','numeric');
        $this->captura('saldo_pasivo','numeric');
        $this->captura('saldo_ingreso','numeric');
        $this->captura('saldo_gasto','numeric');
        $this->captura('porc_diferido','numeric');//
        $this->captura('cerrar','varchar');//
        $this->captura('nro_tramite','varchar');//#MDID-8
        $this->captura('id_estado_wf','integer');//#MDID-8
        $this->captura('id_proceso_wf','integer');//#MDID-8
        $this->captura('id_tipo_cc','integer');//#MDID-10
        $this->captura('desc_tipo_cc','varchar');//#MDID-10



        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarProyectoAnalisis(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_ime';
        $this->transaccion='PRO_PROANA_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('glosa','glosa','varchar');
		$this->setParametro('estado','estado','varchar');
        $this->setParametro('id_proveedor','id_proveedor','int4');
        $this->setParametro('porc_diferido','porc_diferido','numeric');//
        $this->setParametro('cerrar','cerrar','varchar');//
        $this->setParametro('id_funcionario','id_funcionario','integer');//#MDID-8
        $this->setParametro('id_tipo_cc','id_tipo_cc','integer');//#MDID-6
		$this->setParametro('id_depto','id_depto','integer');//#MZM



        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarProyectoAnalisis(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_ime';
        $this->transaccion='PRO_PROANA_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('glosa','glosa','varchar');
        $this->setParametro('id_proveedor','id_proveedor','int4');
        $this->setParametro('porc_diferido','porc_diferido','numeric');//
        $this->setParametro('cerrar','cerrar','varchar');//

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarProyectoAnalisis(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_ime';
        $this->transaccion='PRO_PROANA_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarProyectoProveedor(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_sel';
        $this->transaccion='PRO_PROVEANA_SEL';
        $this->tipo_procedimiento='SEL';
        $this->setCount(false);

        //Define los parametros para la funcion
        $this->setParametro('id_proyecto','id_proyecto','int4');
        $this->captura('id_proveedor','int4');
        $this->captura('total_registros','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function siguienteEstado(){//#MDID-8
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'pro.ft_proyecto_analisis_ime';
        $this->transaccion = 'PRO_SIGEPROANA_INS';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function anteriorEstado(){//#MDID-8
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_ime';
        $this->transaccion='PRO_ANTEPROANA_IME';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');
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

    function listarAnalisisDiferido(){//MDID-11

        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.f_analisis_diferido_sel';
        $this->transaccion='PRO_ANADIF_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setTipoRetorno('record');

        $this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');

        $this->captura('id_proyecto_analisis','int4');
        $this->captura('saldo_activo','numeric');
        $this->captura('saldo_pasivo','numeric');
        $this->captura('saldo_ingreso','numeric');
        $this->captura('saldo_gasto','numeric');
        $this->captura('saldo_activo_cbt','numeric');
        $this->captura('saldo_pasivo_cbt','numeric');
        $this->captura('saldo_ingreso_cbt','numeric');
        $this->captura('saldo_gasto_cbt','numeric');
        $this->captura('saldo_activo_cbtII','numeric');
        $this->captura('saldo_pasivo_cbtII','numeric');
        $this->captura('saldo_ingreso_cbtII','numeric');
        $this->captura('saldo_gasto_cbtII','numeric');
        $this->captura('saldo_activo_cbtIII','numeric');
        $this->captura('saldo_pasivo_cbtIII','numeric');
        $this->captura('saldo_ingreso_cbtIII','numeric');
        $this->captura('saldo_gasto_cbtIII','numeric');

        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;

    }	  
		function generarCbteContable(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_ime';
        $this->transaccion='PRO_GENCBTE_IME';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proyecto','id_proyecto','int4');
        $this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');
        $this->setParametro('tipo','tipo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }	      

}
?>