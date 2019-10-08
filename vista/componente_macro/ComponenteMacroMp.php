<?php
/**
*@package pXP
*@file gen-ComponenteMacro.php
*@author  (admin)
*@date 22-07-2019 14:47:14
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE       FECHA        AUTHOR          DESCRIPCION
    #27        16/09/2019   EGS             Se agrego campo f_desadeanizacion,f_seguridad,f_escala_xfd_montaje,f_escala_xfd_obra_civil,porc_prueba
    #34EndeEtr 03/10/2019   EGS             Se agregaron totalizdores

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ComponenteMacroMp = {
    require:'../../../sis_proyectos/vista/componente_macro/ComponenteMacro.php',
    requireclase:'Phx.vista.ComponenteMacro',
    title:'Subestaciones y Lineas',
    nombreVista:'ComponenteMacroMp',

	constructor:function(config){
		this.maestro=config;
    	//llama al constructor de la clase padre
		Phx.vista.ComponenteMacroMp.superclass.constructor.call(this,config);
		this.init();
		this.inciarEventos();
		this.bloquearMenus();
		//this.load({params:{start:0, limit:this.tam_pag ,id_proyecto:this.maestro.id_proyecto}});
	},
    inciarEventos: function(){
    },

	bdel:false,
	bsave:false,
    bnew:false,
    bedit:false,
    tabeast:undefined,
    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_proyecto')].valorInicial = this.maestro.id_proyecto;
        //Filtro para los datos
        this.store.baseParams = {
            id_proyecto: this.maestro.id_proyecto
        };

        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });
    },

}
</script>
		
		