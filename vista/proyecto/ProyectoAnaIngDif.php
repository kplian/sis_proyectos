<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 * MDID-4               29/09/2020  EGS             Se agrega botton de analisis diferidos
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoAnaIngDif = {
	require:'../../../sis_proyectos/vista/proyecto/ProyectoBase.php',
    requireclase:'Phx.vista.ProyectoBase',
    nombreVista:'ProyectoAnaIngDif',
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
        this.addButton('btnAnaDif', { //#MDID-4
            text : 'Análisis  Diferidos',
            iconCls : 'bexecdb',
            disabled : true,
            handler : this.openAnaDif,
            tooltip : '<b>Analisis Diferidos</b>'
        });
        this.store.baseParams = {
            diferido: 'si'
        };
        this.load({ params: {start: 0,limit: 50 }});
    },
    iniciarEventos: function(){
        this.Cmp.diferido.setValue('si');
        this.Cmp.nombreVista.setValue(this.nombreVista);
        //this.Cmp.id_tipo_cc.store.baseParams.movimiento='si';
        this.Cmp.importe_max.allowBlank = true;
        this.ocultarComponente(this.Cmp.importe_max);
        this.Cmp.id_moneda.allowBlank = true;
        this.ocultarComponente(this.Cmp.id_moneda);
        this.Cmp.id_fase_plantilla.allowBlank = true;
        this.ocultarComponente(this.Cmp.id_fase_plantilla);
    	
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
        },
        {
            url:'../../../sis_proyectos/vista/proyecto_contrato/ProyectoContrato.php',
            title:'Contratos',
            height:'50%',
            cls:'ProyectoContrato'
        }],

		preparaMenu: function(n){
		
		var tb = Phx.vista.ProyectoAnaIngDif.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();
		console.log('tb',tb);
            this.getBoton('btnChequeoDocumentosWf').enable();
            this.getBoton('btnAnaDif').enable();
		return tb;
	},
	liberaMenu: function(){
		var tb = Phx.vista.ProyectoAnaIngDif.superclass.liberaMenu.call(this);
		if (tb) {
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('btnAnaDif').disable();
        }
		return tb;
	},
    bdel:true,
    bnew:true,
    bedit:true,
    bsave:false,
    openAnaDif: function(){//#MDID-4
        var data = this.getSelectedData();
        var win = Phx.CP.loadWindows(
            '../../../sis_proyectos/vista/proyecto_analisis/ProyectoAnalisis.php',
            'Análisis  Diferidos', {
                width: '95%',
                height: '95%'
            },
            data,
            this.idContenedor,
            'ProyectoAnalisis'
        );
    },
    onButtonNew: function(){
        Phx.vista.ProyectoAnaIngDif.superclass.onButtonNew.call(this);
        this.iniciarEventos();
        //this.Cmp.fecha_fin_real.disable(true);

    },
    onButtonEdit: function(){
        Phx.vista.ProyectoAnaIngDif.superclass.onButtonEdit.call(this);
        this.iniciarEventos();
        //this.Cmp.fecha_fin_real.disable(true);

    },
}
</script>

