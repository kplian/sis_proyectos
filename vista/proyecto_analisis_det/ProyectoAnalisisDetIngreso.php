<?php
/**
 *@package pXP
 *@file gen-Licencia.php
 *@author  (admin)
 *@date 07-03-2019 13:53:18
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ProyectoAnalisisDetIngreso={
        require:'../../../sis_proyectos/vista/proyecto_analisis_det/ProyectoAnalisisDetBase.php',
        requireclase:'Phx.vista.ProyectoAnalisisDetBase',
        title:'ProyectoAnalisisDetIngreso',
        nombreVista: 'ProyectoAnalisisDetIngreso',
        tipo_cuenta:'ingreso',
        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.ProyectoAnalisisDetIngreso.superclass.constructor.call(this,config);
            this.init();
            var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
            if(dataPadre){
                this.onEnablePanel(this, dataPadre);
            } else {
                this.bloquearMenus();
            }

        },
        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.ProyectoAnalisisDetIngreso.superclass.preparaMenu.call(this,n);

            return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.ProyectoAnalisisDetIngreso.superclass.liberaMenu.call(this);
            if(tb){
            }
            return tb
        },


    }
</script>

