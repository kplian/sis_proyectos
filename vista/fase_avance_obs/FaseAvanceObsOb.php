<?php
/**
*@package pXP
*@file FaseavanceObsAv.php
*@author  RCM
*@date 15/10/2018
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FaseAvanceObsOb = {
	require:'../../../sis_proyectos/vista/fase_avance_obs/FaseAvanceObs.php',
    requireclase:'Phx.vista.FaseAvanceObs',
    tipo: 'observacion',
    constructor: function(config) {
    	Phx.vista.FaseAvanceObsOb.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
    }
}
</script>