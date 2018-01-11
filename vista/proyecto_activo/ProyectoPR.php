<?php
/**
*@package pXP
*@file Proyeto.php
*@author  RCM
*@date 26/09/2017
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoPR = {
	require:'../../../sis_parametros/vista/proyecto/Proyecto.php',
    requireclase:'Phx.vista.Proyecto',
    constructor: function(config) {
    	Phx.vista.ProyectoPR.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
        //Boton para la definicion de activos fijos
        this.addButton('btnDefAct',
            {
                text: 'Activos Fijos',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.abrirDefActivos
            }
        );
    },
    abrirDefActivos: function(){
    	var data=this.sm.getSelected();
    	Phx.CP.loadWindows('../../../sis_proyectos/vista/proyecto_activo/ProyectoActivo.php',
            'Definición de Activos',
            {
                width:'50%',
                height:'85%'
            },
            data,
            this.idContenedor,
            'ProyectoActivo'
        )
    },
    preparaMenu: function(n){
    	Phx.vista.ProyectoPR.superclass.preparaMenu.call(this);
    	//Se habilita botón para Definición de Activos
        this.getBoton('btnDefAct').enable();
    },
    liberaMenu:function(){
    	Phx.vista.ProyectoPR.superclass.liberaMenu.call(this);
    	//Se deshabilita botón para Definición de Activos
        this.getBoton('btnDefAct').disable();
    }
}
</script>