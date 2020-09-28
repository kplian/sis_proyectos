<?php
/****************************************************************************************
*@package pXP
*@file gen-MODProyectoSuspension.php
*@author  (egutierrez)
*@date 28-09-2020 19:25:30
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                28-09-2020 19:25:30    egutierrez             Creacion    
  #
*****************************************************************************************/

class MODProyectoSuspension extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarProyectoSuspension(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_proyecto_suspension_sel';
        $this->transaccion='PRO_REGSUS_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_proyecto_suspension','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_proyecto','int4');
		$this->captura('fecha_desde','date');
		$this->captura('fecha_hasta','date');
		$this->captura('descripcion','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
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
            
    function insertarProyectoSuspension(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_suspension_ime';
        $this->transaccion='PRO_REGSUS_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('fecha_desde','fecha_desde','date');
		$this->setParametro('fecha_hasta','fecha_hasta','date');
		$this->setParametro('descripcion','descripcion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarProyectoSuspension(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_suspension_ime';
        $this->transaccion='PRO_REGSUS_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_suspension','id_proyecto_suspension','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('fecha_desde','fecha_desde','date');
		$this->setParametro('fecha_hasta','fecha_hasta','date');
		$this->setParametro('descripcion','descripcion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarProyectoSuspension(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_suspension_ime';
        $this->transaccion='PRO_REGSUS_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_suspension','id_proyecto_suspension','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>