<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 	#8	  endeETR		18/03/2019	EGS				se filtra por estado nuevo y ejecucion 
	#16	 ETR			01/08/2019	EGS				Se agrega boton de unidades Contructivas
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoPr = {
	require:'../../../sis_proyectos/vista/proyecto/ProyectoBase.php',
    requireclase:'Phx.vista.ProyectoBase',
    constructor: function(config) {
    	//this.initButtons=[this.cmbEstado];//Un combo que da la opcion de recargar el estado que se elija

    	Phx.vista.ProyectoPr.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();
        this.reportePlanPago();
        this.iniciarEventos();
		
        this.addBotonesGantt();
		
		this.addButton('btnCompMacr', {//#
			text : 'Subesta. y Lineas',//#
			iconCls : 'bexecdb',
			disabled : true,
			handler : this.compMacr,
			tooltip : '<b>Componentes'
		});
		this.addButton('btnUniCons', { //#16
			text : 'Unidades Const.',
			iconCls : 'bexecdb',
			disabled : true,
			handler : this.openUniCons,
			tooltip : '<b>Unidades Constructoras'
       		 });
		this.addButton('btnFases', {
			text : 'Fases',
			iconCls : 'bexecdb',
			disabled : true,
			handler : this.openFases,
			tooltip : '<b>Fases del Proyecto</b><br>Interfaz para el registro de las fases que componen al proyecto'
		});

		this.addButton('btnInvitacion',{
       	    text: 'Invitaciones',
       	    iconCls: 'blist',
       	    disabled: true,
       	    handler: this.mostraInvitacion,
       	    tooltip: 'Invitaciones'});
       	    
       	this.addButton('ant_estado',{ argument: {estado: 'anterior'},text:'Atras',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        
        this.addButton('sig_estado',{ text:'Siguiente', iconCls: 'badelante', disabled: true, handler: this.sigEstado, tooltip: '<b>Pasar al Siguiente Estado</b>'});
        this.addButton('btnChequeoDocumentosWf',
	            {
	                text: 'Documentos',
	                grupo:[0,1,2,3],
	                iconCls: 'bchecklist',
	                disabled: true,
	                handler: this.loadCheckDocumentosWf,
	                tooltip: '<b>Documentos del Trámite</b><br/>Permite ver los documentos asociados al NRO de trámite.'
	            });
	    this.addButton('btnAdqPro',{ 
       	    text: 'Adq Programadas', 
       	    iconCls: 'blist', 
       	    disabled: false, 
       	    handler: this.adquisicionesProgramadas, 
       	    tooltip: 'Adquicisiones Programadas'});

       	 /*
       	 this.addButton('btnReportPro',{ 
       	    text: 'Reporte', 
       	    iconCls: 'blist', 
       	    disabled: false, 
       	    handler: this.reportesProyectoN, 
       	    tooltip: 'Reportes del Proyecto'});*/
       	   
		this.cmbEstado.on('select',this.capturaFiltros,this);
		this.cmbEstado.fireEvent('select');
     
    this.load({params:{start:0, limit:this.tam_pag, planificacion:'si'}});//#8
    },
    
    capturaFiltros:function(combo, record, index){
		this.store.baseParams.nombre_vista = this.nombreVista;
		//this.tipo = this.cmbVersion.getValue();
		this.store.baseParams.estado=this.cmbEstado.getValue();//busca en la grilla el campo solicitado
	    this.load(); 
	},
	
	cmbEstado:new Ext.form.ComboBox({
		            grupo:[0],
	       			name:'cmp_estado',
	       			fieldLabel:'Estado',
	       			allowBlank:true,
	       			forceSelection:false,
	       			emptyText:'Estado',
	       			typeAhead: false,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    //value:'1',
	       		    mode: 'local',
	       		    width: 100,
	       		    store:['nuevo','ejecucion','cierre','finalizado']
	 }),
    
    
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
    addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls : 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
	            items: [{
	                id:'b-gantti-' + this.idContenedor,
	                text: 'Gantt - Items',
	                tooltip: '<b>Muestra un reporte gantt segun sus Items</b>',
	                handler:this.diagramGanttItem,
	                scope: this
	            }, {
	                id:'b-ganttd-' + this.idContenedor,
	                text: 'Gantt Proyecto - Fases',
	                tooltip: '<b>Muestra el reporte gantt del proyecto con las Fases</b>',
	                handler:this.diagramGanttDinamico,
	                scope: this
	            }]
            }
        });
		this.tbar.add(this.menuAdqGantt);
    },
    diagramGantt: function (){			
		var data=this.sm.getSelected().data.id_proyecto;
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
			params:{'id_proyecto':data},
			success: this.successExport,
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope: this
		});			
	},
	
	diagramGanttItem: function (){			
		var data=this.sm.getSelected().data.id_proyecto;
		window.open('../../../sis_proyectos/reportes/gantt/gantt_dinamico_item_v2.html?id_proyecto='+data)		
	},
   diagramGanttDinamico: function (){			
		var data=this.sm.getSelected().data.id_proyecto;
		window.open('../../../sis_proyectos/reportes/gantt/gantt_dinamico.html?id_proyecto='+data)		
	},

	tabsouth: [
        {
            url:'../../../sis_proyectos/vista/componente_macro/ComponenteMacroMp.php',
            title:'Subestaciones y Lineas',
            height:'50%',
            cls:'ComponenteMacroMp'
        },
    {
		url:'../../../sis_proyectos/vista/fase_avance_obs/FaseAvanceObsProy.php',
		title:'Avance Visual',
		height:'50%',
		cls:'FaseAvanceObsProy'
	}, {
		url: '../../../sis_proyectos/vista/proyecto_funcionario/ProyectoFuncionario.php',
		title: 'Funcionarios del proyecto',
		height: '50%',
		cls: 'ProyectoFuncionario'
	}, {
		url: '../../../sis_proyectos/vista/proyecto_contrato/ProyectoContrato.php',
		title: 'Contratos',
		height: '50%',
		cls: 'ProyectoContrato'
	}],
    compMacr: function(){//#
        var data = this.getSelectedData();
        var win = Phx.CP.loadWindows(
            '../../../sis_proyectos/vista/componente_macro/ComponenteMacro.php',
            'Subestaciones y Lineas', {
                width: '95%',
                height: '90%'
            },
            data,
            this.idContenedor,
            'ComponenteMacro'
        );
    },
	openFases: function(){
		var data = this.getSelectedData();
		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/fase/Fase.php',
			'Fases', {
			    width: '95%',
			    height: '90%'
			},
			data,
			this.idContenedor,
			'Fase'
		);
	},
	openUniCons: function(){//#16
		var data = this.getSelectedData();
		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/unidad_constructiva/UnidadConstructiva.php',
			'Unidad Constructiva', {
			    width: '95%',
			    height: '90%'
			},
			data,
			this.idContenedor,
			'UnidadConstructiva'
		);
	},

	mostraInvitacion: function(){
		var data = this.getSelectedData();
		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/invitacion/Invitacion.php',
			'Invitaciones', {
			    width: '80%',
			    height: '70%'
			},
			data,
			this.idContenedor,
			'Invitacion'//clase de la vista
		);
	},
			
	 adquisicionesProgramadas: function(){
			var data = this.getSelectedData();
			var win = Phx.CP.loadWindows(
				'../../../sis_proyectos/vista/fase_concepto_ingas/AdqProgramada.php',
				'Facturas', {
				    width: '80%',
				    height: '70%'
				},
				data,
				this.idContenedor,
				'AdqProgramada'//clase de la vista
			);
		},
	
		reportesProyectoN: function(){
			var data = this.getSelectedData();
			var win = Phx.CP.loadWindows(
				'../../../sis_proyectos/vista/reporte/ReporteResumen.php',
				'Reportes', {
				    width: '30%',
				    height: '30%'
				},
				data,
				this.idContenedor,
				'ReporteResumen'//clase de la vista
			);
		},
		
		reportePlanPago: function() {
			this.reporPlan = new Ext.Toolbar.SplitButton({
				id: 'btnReCobro' + this.idContenedor,
				text: 'Reportes',
				disabled: false,
				grupo:[0],
				iconCls : 'bprint',
				handler:this.formFiltroRe,
				scope: this,
				menu:{
					items: [{
						id:'b-cobro-pdf-' + this.idContenedor,
						text: 'Filtrar',
						tooltip: '<b>Filtro de parametros a visualizar</b>',
						handler:this.formFiltroRe,
						scope: this
					}
				]}
			});
			this.tbar.add(this.reporPlan);
			},
	
		formFiltroRe: function(){
		var data = this.getSelectedData();
		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/reporte/ReporteResumenN.php',
			'Reportes', {
			    width: '25%',
			    height: '40%'
			},
			data,
			this.idContenedor,
			'ReporteResumenN',
			{
				config:[{
					event:'beforesave',
					delegate: this.reportesProyecto,
				}],
				scope:this
			}
			
			)
		},
		reportesProyecto : function (wizard,resp){	
						
				 console.log('resp',resp);	
					Phx.CP.loadingShow();		
					Ext.Ajax.request({
						url:'../../sis_proyectos/control/Reporte/listarReportes',
						params:
						{	
							
							'id_proyecto':resp.id_proyecto,
							'tipo_reporte':resp.tipo_reporte,
							
			
						},
						success: this.successExport,		
						failure: this.conexionFailure,
						timeout: 3.6e+6,
						scope:this
					});
		},
				
		preparaMenu: function(n){
		
		var tb = Phx.vista.ProyectoPr.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();
		console.log('tb',tb);
		this.getBoton('btnChequeoDocumentosWf').enable();
		this.getBoton('diagrama_gantt').enable();
		this.getBoton('btnFases').enable();
		this.getBoton('btnInvitacion').enable();
		this.getBoton('btnAdqPro').enable();
		this.getBoton('btnUniCons').enable();//#16
		this.getBoton('btnCompMacr').enable();//#
		//this.getBoton('btnReportPro').enable();

		if(data.estado == 'finalizado' ){
		this.getBoton('sig_estado').disable();
		}
		else{
			this.getBoton('sig_estado').enable();
		}
		
		if(data.estado == 'nuevo' || data.estado == 'finalizado'){
		this.getBoton('ant_estado').disable();
		}
		else{
			this.getBoton('ant_estado').enable();
		}
		
		if (tb && this.bedit && (data.estado == 'cierre' || data.estado == 'finalizado' )) {
            tb.items.get('b-edit-' + this.idContenedor).disable()
            }
         if (tb && this.bdel && (data.estado == 'cierre' || data.estado == 'finalizado' )) {
            tb.items.get('b-del-' + this.idContenedor).disable()
            }
		return tb;
	},
	liberaMenu: function(){
		var tb = Phx.vista.ProyectoPr.superclass.liberaMenu.call(this);
		if (tb) {
		
		this.getBoton('btnChequeoDocumentosWf').disable();
		this.getBoton('diagrama_gantt').disable();
		this.getBoton('btnFases').disable();
		this.getBoton('btnInvitacion').disable();
		this.getBoton('btnAdqPro').disable();
	
		this.getBoton('sig_estado').disable();
		this.getBoton('ant_estado').disable();
		
        this.getBoton('diagrama_gantt').disable();
		this.getBoton('btnUniCons').disable();//#16
		this.getBoton('btnCompMacr').disable();//#
        //this.getBoton('btnReportPro').disable();

        
		}
		return tb;
	},
 	onButtonNew: function(){
 		
 		console.log('hola');
		Phx.vista.ProyectoPr.superclass.onButtonNew.call(this);
		
	   this.Cmp.fecha_ini_real.disable(true);
	   this.Cmp.fecha_fin_real.disable(true);
	   		
		
		
	},
    onButtonEdit: function(){
    	var rec=this.sm.getSelected();
    	console.log('rec',rec.json.estado);
    	Phx.vista.ProyectoPr.superclass.onButtonEdit.call(this);  
    	if (rec.json.estado == 'nuevo'){
    		  this.Cmp.fecha_ini.enable(true);
	    	  this.Cmp.fecha_fin.enable(true);
    	 }
    	 else{
    	 	  this.Cmp.fecha_ini.disable(true);
	    	  this.Cmp.fecha_fin.disable(true);
    	 }
   
    	
    	if (rec.json.estado == 'ejecucion') {
    		  this.Cmp.fecha_ini_real.enable(true);
	     	  this.Cmp.fecha_fin_real.enable(true);
    		
    	} else{
    		  this.Cmp.fecha_ini_real.disable(true);
	     	  this.Cmp.fecha_fin_real.disable(true);
    		
    	};
    	   	
 
    },
                
     antEstado: function(res){
		var rec=this.sm.getSelected(),
		obsValorInicial;
		console.log('obsValorInicial',obsValorInicial);
		Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
			'Estado de Wf',
			{   modal: true,
			    width: 450,
			    height: 250
			}, 
			{    data: rec.data, 
				 estado_destino: res.argument.estado,
			     obsValorInicial: obsValorInicial 
			 }, 
			 this.idContenedor,'AntFormEstadoWf',
			{
			    config:[{
			              event:'beforesave',
			              delegate: this.onAntEstado,
			            }],
			   scope:this
			});
	}, 
	onAntEstado: function(wizard,resp){
        Phx.CP.loadingShow();
        var operacion = 'cambiar';

        Ext.Ajax.request({
              //url:'../../sis_workflow/control/ProcesoWf/anteriorEstadoProcesoWf',
                url:'../../sis_proyectos/control/Proyecto/anteriorEstado',
            params:{
            	id_proyecto: wizard.data.id_proyecto,
                id_proceso_wf: resp.id_proceso_wf,
                id_estado_wf:  resp.id_estado_wf,  
                obs: resp.obs,
                operacion: operacion
             },
            argument:{wizard:wizard},  
            success: this.successAntEstado,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    }, 
    
       successAntEstado:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },  
    
      sigEstado:function(){                   
      var rec=this.sm.getSelected();
      console.log('data',rec);
      this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal:true,
                                    width:700,
                                    height:450
                                }, {data:{
                                	   id_proyecto:rec.data.id_proyecto,
                                       id_estado_wf:rec.data.id_estado_wf,
                                       id_proceso_wf:rec.data.id_proceso_wf,
                                    	
                                    }}, this.idContenedor,'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            }],
                                    
                                    scope:this
                                 });        
               
     },
      onSaveWizard:function(wizard,resp){
        //console.log(wizard);
        //Phx.CP.loadingShow();
        Ext.Ajax.request({
            //url:'../../sis_workflow/control/ProcesoWf/siguienteEstadoProcesoWf',
            url:'../../sis_proyectos/control/Proyecto/siguienteEstado',
            params:{
                id_proyecto:      wizard.data.id_proyecto,
                id_proceso_wf_act:  resp.id_proceso_wf_act,
                id_estado_wf_act:   resp.id_estado_wf_act,
                id_tipo_estado:     resp.id_tipo_estado,
                id_funcionario_wf:  resp.id_funcionario_wf,
                id_depto_wf:        resp.id_depto_wf,
                obs:                resp.obs,
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success:this.successWizard,
            failure: this.conexionFailure,
            argument:{wizard:wizard},
            timeout:this.timeout,
            scope:this
        });
         
    },
       successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    
    
}
</script>

