<?php
/**
 *@package pXP
 *@file gen-MODComponenteConceptoIngas.php
 *@author  (admin)
 *@date 22-07-2019 14:49:24
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * ISSUE       FECHA       AUTHOR          DESCRIPCION
    #28        16/09/2019   EGS            se agrega campo porc_prueba
 */

class MODComponenteConceptoIngas extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarComponenteConceptoIngas(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_componente_concepto_ingas_sel';
        $this->transaccion='PRO_COMINGAS_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->capturaCount('total_precio_det','numeric');
        //Definicion de la lista del resultado del query
        $this->captura('id_componente_concepto_ingas','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('id_concepto_ingas','int4');
        $this->captura('id_componente_macro','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('desc_ingas','varchar');
        $this->captura('id_proyecto','int4');
        $this->captura('tipo','varchar');
        $this->captura('porc_prueba','numeric');
        $this->captura('precio_total_det','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarComponenteConceptoIngas(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_componente_concepto_ingas_ime';
        $this->transaccion='PRO_COMINGAS_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
        $this->setParametro('id_componente_macro','id_componente_macro','int4');
        $this->setParametro('aislacion','aislacion','varchar');
        $this->setParametro('tension','tension','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarComponenteConceptoIngas(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_componente_concepto_ingas_ime';
        $this->transaccion='PRO_COMINGAS_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_componente_concepto_ingas','id_componente_concepto_ingas','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
        $this->setParametro('id_componente_macro','id_componente_macro','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarComponenteConceptoIngas(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_componente_concepto_ingas_ime';
        $this->transaccion='PRO_COMINGAS_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_componente_concepto_ingas','id_componente_concepto_ingas','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>