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
        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        } else {
            this.bloquearMenus();
        }
		//this.load({params:{start:0, limit:this.tam_pag ,id_proyecto:this.maestro.id_proyecto}});
        this.addButton('btnReportPlani',{
            text: 'Reporte Planificacion',
            iconCls: 'blist',
            disabled: false,
            handler: this.reportesPlanificacion,
            tooltip: 'Reportes del Proyecto'})
	},
    inciarEventos: function(){
    },

	bdel:false,
	bsave:false,
    bnew:false,
    bedit:false,
    east:undefined,
    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_proyecto')].valorInicial = this.maestro.id_proyecto;
        //Filtro para los datos
        this.store.baseParams = {id_proyecto: this.maestro.id_proyecto  ,nombreVista: this.nombreVista};

        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });
    },
    reportesPlanificacion: function(){
        var data = this.getSelectedData();
        var win = Phx.CP.loadWindows(
            '../../../sis_proyectos/vista/reporte/ReportePlanificacion.php',
            'Reportes', {
                width: '30%',
                height: '30%'
            },
            data,
            this.idContenedor,
            'ReportePlanificacion'//clase de la vista
        );
    },
    preparaMenu: function(n){

        var tb = Phx.vista.ComponenteMacroMp.superclass.preparaMenu.call(this);
        var data = this.getSelectedData();
        this.getBoton('btnReportPlani').enable();
        return tb;
    },
    liberaMenu: function(){
        var tb = Phx.vista.ComponenteMacroMp.superclass.liberaMenu.call(this);
        if (tb) {
            this.getBoton('btnReportPlani').disable();
        }
        return tb;
    },

}
</script>
		
		