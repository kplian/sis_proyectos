<?php
/****************************************************************************************
*@package pXP
*@file gen-MODCuentaIncluir.php
*@author  (egutierrez)
*@date 19-10-2020 14:17:13
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                19-10-2020 14:17:13    egutierrez             Creacion    
  #
*****************************************************************************************/

class MODCuentaIncluir extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarCuentaIncluir(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='pro.ft_cuenta_incluir_sel';
        $this->transaccion='PRO_CUEINC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_cuenta_incluir','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nro_cuenta','varchar');
		$this->captura('tipo','varchar');
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
            
    function insertarCuentaIncluir(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_cuenta_incluir_ime';
        $this->transaccion='PRO_CUEINC_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('tipo','tipo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarCuentaIncluir(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_cuenta_incluir_ime';
        $this->transaccion='PRO_CUEINC_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_cuenta_incluir','id_cuenta_incluir','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nro_cuenta','nro_cuenta','varchar');
		$this->setParametro('tipo','tipo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarCuentaIncluir(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_cuenta_incluir_ime';
        $this->transaccion='PRO_CUEINC_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_cuenta_incluir','id_cuenta_incluir','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>