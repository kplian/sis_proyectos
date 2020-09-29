<?php
/****************************************************************************************
*@package pXP
*@file gen-MODProyectoHito.php
*@author  (egutierrez)
*@date 28-09-2020 20:15:06
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                28-09-2020 20:15:06    egutierrez             Creacion    
  #
*****************************************************************************************/

class MODProyectoHito extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarProyectoHito(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_proyecto_hito_sel';
        $this->transaccion='PRO_PROHIT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_proyecto_hito','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_proyecto','int4');
		$this->captura('descripcion','varchar');
		$this->captura('fecha_plan','date');
		$this->captura('importe_plan','numeric');
		$this->captura('fecha_real','date');
		$this->captura('importe_real','numeric');
		$this->captura('observaciones','varchar');
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
            
    function insertarProyectoHito(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_hito_ime';
        $this->transaccion='PRO_PROHIT_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('fecha_plan','fecha_plan','date');
		$this->setParametro('importe_plan','importe_plan','numeric');
		$this->setParametro('fecha_real','fecha_real','date');
		$this->setParametro('importe_real','importe_real','numeric');
		$this->setParametro('observaciones','observaciones','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarProyectoHito(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_hito_ime';
        $this->transaccion='PRO_PROHIT_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_hito','id_proyecto_hito','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('fecha_plan','fecha_plan','date');
		$this->setParametro('importe_plan','importe_plan','numeric');
		$this->setParametro('fecha_real','fecha_real','date');
		$this->setParametro('importe_real','importe_real','numeric');
		$this->setParametro('observaciones','observaciones','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarProyectoHito(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_hito_ime';
        $this->transaccion='PRO_PROHIT_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_proyecto_hito','id_proyecto_hito','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>