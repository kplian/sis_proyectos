<?php
/**
*@package pXP
*@file FaseavanceObsProy.php
*@author  RCM
*@date 24/10/2018
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FaseAvanceObsProy = {
	require:'../../../sis_proyectos/vista/fase_avance_obs/FaseAvanceObs.php',
    requireclase:'Phx.vista.FaseAvanceObs',
    tipo: 'avance_visual',
    constructor: function(config) {
    	Phx.vista.FaseAvanceObsProy.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
    },
    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_proyecto')].valorInicial = this.maestro.id_proyecto;
        this.Atributos[this.getIndAtributo('tipo')].valorInicial = this.tipo;

        //Filtro para los datos
        this.store.baseParams = {
            id_proyecto: this.maestro.id_proyecto,
            tipo: this.tipo
        };

        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });
    }

}
</script>