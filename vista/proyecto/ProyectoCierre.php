<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoCierre = {
	require:'../../../sis_proyectos/vista/proyecto/ProyectoBase.php',
    requireclase:'Phx.vista.ProyectoBase',
    constructor: function(config) {
    	Phx.vista.ProyectoCierre.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
        //Boton para la definicion de activos fijos
        this.addButton('btnDefAct',
            {
                text: 'Definición Activos',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.abrirDefActivos
            }
        );
    },
    abrirDefActivos: function(){
    	var data=this.sm.getSelected();
    	Phx.CP.loadWindows('../../../sis_proyectos/vista/proyecto_activo/ProyectoActivo.php',
            'Proyecto: '+data.data.codigo+' '+data.data.nombre,
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
    	Phx.vista.ProyectoCierre.superclass.preparaMenu.call(this);
    	//Se habilita botón para Definición de Activos
        this.getBoton('btnDefAct').enable();
    },
    liberaMenu:function(){
    	Phx.vista.ProyectoCierre.superclass.liberaMenu.call(this);
    	//Se deshabilita botón para Definición de Activos
        this.getBoton('btnDefAct').disable();
    }
}
</script>
		
		