<?php
/****************************************************************************************
*@package pXP
*@file gen-MODProyectoAnalisisDet.php
*@author  (egutierrez)
*@date 29-09-2020 12:44:12
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                29-09-2020 12:44:12    egutierrez             Creacion    
  #
*****************************************************************************************/

class MODProyectoAnalisisDet extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarProyectoAnalisisDet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_proyecto_analisis_det_sel';
        $this->transaccion='PRO_PROANADE_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_proyecto_analisis_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_proyecto_analisis','int4');
		$this->captura('id_int_transaccion','int4');
		$this->captura('estado','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('nro_tramite_cbte','varchar');
        $this->captura('fecha_cbte','date');
        $this->captura('glosa_cbte','varchar');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('desc_partida','text');
        $this->captura('desc_centro_costo','text');
        $this->captura('desc_cuenta','text');
        $this->captura('desc_auxiliar','text');
        $this->captura('tipo_cuenta','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarProyectoAnalisisDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_det_ime';
        $this->transaccion='PRO_PROANADE_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('estado','estado','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarProyectoAnalisisDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_det_ime';
        $this->transaccion='PRO_PROANADE_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_analisis_det','id_proyecto_analisis_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');
		$this->setParametro('id_int_transaccion','id_int_transaccion','int4');
		$this->setParametro('estado','estado','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarProyectoAnalisisDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_analisis_det_ime';
        $this->transaccion='PRO_PROANADE_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_analisis_det','id_proyecto_analisis_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarIntransaccionAnadet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_proyecto_analisis_det_sel';
        $this->transaccion='PRO_PROINTRA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_proyecto_analisis','id_proyecto_analisis','int4');
        $this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
        //Definicion de la lista del resultado del query
        $this->captura('id_int_transaccion','int4');
        $this->captura('nro_tramite_cbte','varchar');
        $this->captura('fecha_cbte','date');
        $this->captura('glosa_cbte','varchar');
        $this->captura('importe_debe_mb','numeric');
        $this->captura('importe_haber_mb','numeric');
        $this->captura('desc_partida','text');
        $this->captura('desc_centro_costo','text');
        $this->captura('desc_cuenta','text');
        $this->captura('desc_auxiliar','text');
        $this->captura('tipo_cuenta','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>