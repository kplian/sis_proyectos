<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoAnaIngDif = {
	require:'../../../sis_proyectos/vista/proyecto/ProyectoBase.php',
    requireclase:'Phx.vista.ProyectoBase',
    constructor: function(config) {
    	//this.initButtons=[this.cmbEstado];//Un combo que da la opcion de recargar el estado que se elija

    	Phx.vista.ProyectoAnaIngDif.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
        this.iniciarEventos();
        this.addButton('btnChequeoDocumentosWf',
	            {
	                text: 'Documentos',
	                grupo:[0,1,2,3],
	                iconCls: 'bchecklist',
	                disabled: true,
	                handler: this.loadCheckDocumentosWf,
	                tooltip: '<b>Documentos del Trámite</b><br/>Permite ver los documentos asociados al NRO de trámite.'
	            });
    this.load({params:{start:0, limit:this.tam_pag, planificacion:'si'}});//#8
    },
    iniciarEventos: function(){

    	
    },
    	loadCheckDocumentosWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
        	)},

	tabsouth: [
        {
            url:'../../../sis_proyectos/vista/proyecto_suspension/ProyectoSuspension.php',
            title:'Registro de Suspensiones',
            height:'50%',
            cls:'ProyectoSuspension'
        },
        {
            url:'../../../sis_proyectos/vista/proyecto_hito/ProyectoHito.php',
            title:'Hitos de Negocio Complementario',
            height:'50%',
            cls:'ProyectoHito'
        }],

		preparaMenu: function(n){
		
		var tb = Phx.vista.ProyectoAnaIngDif.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();
		console.log('tb',tb);
            this.getBoton('btnChequeoDocumentosWf').enable();
		return tb;
	},
	liberaMenu: function(){
		var tb = Phx.vista.ProyectoAnaIngDif.superclass.liberaMenu.call(this);
		if (tb) {
            this.getBoton('btnChequeoDocumentosWf').disable();
        }
		return tb;
	},
    bdel:false,
    bnew:false,
    bedit:false,
    bsave:false
}
</script>

