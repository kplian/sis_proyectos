<?php
/**
*@package pXP
*@file gen-Fase.php
*@author  (admin)
*@date 25-10-2017 13:16:54
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	ISSUE FORK		FECHA		AUTHOR			DESCRIPCION
 	#5		EndeEtr	09/01/2019	EGS				Se aumento el campo precio_item que es la suma de los items en la fase
 * 	#7		EndeEtr	20/02/2019	EGS				validacion que pinta de color cuando existe items en el nodo fase
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.Fase=Ext.extend(Phx.arbGridInterfaz,{
	nombreVista:'Fase',
	constructor:function(config){
		this.maestro=config;
		Phx.vista.Fase.superclass.constructor.call(this,config);

		//Valores del padre/

		this.Atributos[1].valorInicial=this.maestro.id_proyecto;
		console.log('id_proyecto',this.maestro.id_proyecto);
        console.log('Estado',this.maestro.estado);

		this.init();
		this.addBotonesGantt();

		//Botón para abrir los conceptos de gasto
		/*
		this.addButton('btnConceptoIngas', {
			text: 'Servicios/Bienes',
			iconCls: 'bexecdb',
			disabled: true,
			handler: this.openConceptoIngas,
			tooltip: '<b>Fases del Proyecto</b><br>Interfaz para el registro de las fases que componen al proyecto'
		});*/
		 	    
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
	     this.DesplegarArbol();  
	},
	//despliega el arbol al abrir la ventana
	  DesplegarArbol:function(){
            	this.treePanel.expandAll();	
       },

	   loadCheckDocumentosWf:function() {
       //var rec=this.sm.getSelected();
       var selectedNode = this.sm.getSelectedNode();
		 
	   console.log('nombreVista',this.nombreVista);
       selectedNode.attributes.nombreVista = this.nombreVista;
       Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    selectedNode.attributes,
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
	                text: 'Gantt Imagen',
	                tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
	                handler:this.diagramGantt,
	                scope: this
	            }, {
	                id:'b-ganttd-' + this.idContenedor,
	                text: 'Gantt Dinámico',
	                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
	                handler:this.diagramGanttDinamico,
	                scope: this
	            }]
            }
        });
		this.tbar.add(this.menuAdqGantt);
    },
    diagramGantt: function (){			
		//var data=this.sm.getSelected().data.id_proceso_wf;
		
		var selectedNode = this.sm.getSelectedNode().attributes.id_proceso_wf;

		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
			params:{'id_proceso_wf':selectedNode},
			success: this.successExport,
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope: this
		});			
	},
	
	diagramGanttDinamico: function (){			
//		var data=this.sm.getSelected().data.id_proceso_wf;

		var selectedNode = this.sm.getSelectedNode().attributes.id_proceso_wf;

		window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+selectedNode)		
	},


	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_wf'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estado_wf'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase_fk'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_cc'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 200,
				maxLength:20,
				gtpl: function (p){//Es como el Renderer de grilla pero para arboles
					//pinta  el codigo cuando existe un item registrado en la fase
					if(this.nro_items != null){//#7
					return  String.format('<b><font size=2 style="color:#B2B4FD";>'+this.codigo+'</font><b>');
						
					}else{
					return  this.codigo;
						
					}
                          // return this.codigo;
			   }	
			},
			type:'TextField',
			filters:{pfiltro:'fase.codigo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:150
			},
			type:'TextField',
			filters:{pfiltro:'fase.nombre',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:5000
			},
			type:'TextField',
			filters:{pfiltro:'fase.descripcion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
			type:'TextField',
			filters:{pfiltro:'fase.estado',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro. Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
			type:'TextField',
			filters:{pfiltro:'fase.estado',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				gtpl:function (p){
					console.log ('this.fecha_ini',this.fecha_ini);
					return this.fecha_ini;
					}
			},
			type:'DateField',
			filters:{pfiltro:'fase.fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				gtpl:function (p){
					console.log ('this.fecha_fin',this.fecha_fin);
					return this.fecha_fin;
					}
			},
			type:'DateField',
			filters:{pfiltro:'fase.fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5000
			},
			type:'TextField',
			filters:{pfiltro:'fase.observaciones',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_ini_real',
				fieldLabel: 'Inicio Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type: 'DateField',
			filters: {pfiltro:'fase.fecha_ini',type:'date'},
			id_grupo: 1,
			grid: true,
			form: true
		},
		{
			config:{
				name: 'fecha_fin_real',
				fieldLabel: 'Fin Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type: 'DateField',
			filters: {pfiltro:'fase.fecha_fin',type:'date'},
			id_grupo: 1,
			grid: true,
			form: true
		},
		//#5 EGS
		{
			config:{
				name: 'precio_item',
				fieldLabel: 'Precio Total Bienes/Servicios',
				allowBlank: true,
				anchor: '80%',
				gwidth: 110,
				decimalSeparator :',',
				maxLength:1179650,
				galign: 'right',
				allowNegative:false,
				gtpl: function (p){//Es como el Renderer de grilla pero para arboles
                           return Ext.util.Format.number(this.precio_item,'0.000,00/i');
			   }									

			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:false
		},
		//#5 EGS
        {
			config:{
				id: 'pr-av-'+this.idContenedor,
				name: 'avance',
				fieldLabel: 'Avance',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5000,
				renderer: function( value, metaData, record ) {
	                var id = 'pr-av-'+this.idContenedor;
	                console.log('ora ora si');
	                (function(){
	                    var progress = new Ext.ProgressBar({
	                        renderTo: id,
	                        value: 0.85,
	                        text: 'aqui va el texto'
	                    });
	                }).defer(25);
	                return '<div id="'+ id + '">SDSDSDSDD</div>';
	            }
			},
			type: 'TextField',
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'fase.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'fase.usuario_ai',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fase.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'fase.id_usuario_ai',type:'numeric'},
			id_grupo:1,
			grid:false,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fase.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	tam_pag:50,
	title:'Fase',
	ActSave:'../../sis_proyectos/control/Fase/insertarFase',
	ActDel:'../../sis_proyectos/control/Fase/eliminarFase',
	ActList:'../../sis_proyectos/control/Fase/listarFasesArb',
	id_store:'id_fase',
	textRoot:'Fases',
    id_nodo:'id_fase',
    id_nodo_p:'id_fase_fk',

	fields: [
		{name:'id', type: 'numeric'},
		{name:'id_fase', type: 'numeric'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'id_fase_fk', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'observaciones', type: 'string'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_ini_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_tipo_cc', type: 'integer'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'tipo_nodo', type: 'string'},
				
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'precio_item', type: 'numeric'},//#5 EGS

	],
	sortInfo:{
		field: 'id_fase',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	rootVisible: false,
	expanded: false,
	onButtonNew: function(){
		Phx.vista.Fase.superclass.onButtonNew.call(this);
		var selectedNode = this.sm.getSelectedNode();
        this.Cmp.fecha_ini_real.disable(true);
	   	this.Cmp.fecha_fin_real.disable(true);
	   	
		if(selectedNode&&selectedNode.attributes&&selectedNode.attributes.id_tipo_cc){
			this.Cmp.id_tipo_cc.setValue(selectedNode.attributes.id_tipo_cc);
		}
	},
	onButtonEdit: function(){
		var selectedNode = this.sm.getSelectedNode();
		console.log('selectedNode',selectedNode.attributes);
		
		Phx.vista.Fase.superclass.onButtonEdit.call(this);
		this.Cmp.id_tipo_cc.setValue(this.maestro.id_tipo_cc);
	if (selectedNode.attributes.estado == 'nuevo'){
    		  this.Cmp.fecha_ini.enable(true);
	    	  this.Cmp.fecha_fin.enable(true);
    	 }
    	 else{
    	 	  this.Cmp.fecha_ini.disable(true);
	    	  this.Cmp.fecha_fin.disable(true);
    	 }
	if (selectedNode.attributes.estado == 'ejecucion') {
    		  this.Cmp.fecha_ini_real.enable(true);
	     	  this.Cmp.fecha_fin_real.enable(true);
    		
    	} else{
    		  this.Cmp.fecha_ini_real.disable(true);
	     	  this.Cmp.fecha_fin_real.disable(true);
    		
    	};  
		
		
		
	},
	onBeforeLoad: function(treeLoader, node){
		console.log('qqq',this.id_nodo,node.attributes[this.id_nodo]);
		treeLoader.baseParams[this.id_nodo] = node.attributes[this.id_nodo];
		//treeLoader.baseParams.id_tipo_cc = this.maestro.id_tipo_cc;
		treeLoader.baseParams.id_proyecto = this.maestro.id_proyecto;
	},
	preparaMenu: function(n) {
		var tb = Phx.vista.Fase.superclass.preparaMenu.call(this);
		var selectedNode = this.sm.getSelectedNode();
		
		this.getBoton('btnChequeoDocumentosWf').enable();
		this.getBoton('diagrama_gantt').enable();
		
		//Si es un nodo del tipo de centro de costo deshabilita botones
		if(selectedNode&&selectedNode.attributes&&selectedNode.attributes.id_ep){
			this.getBoton('edit').disable();
		    this.getBoton('del').disable();
		    //this.getBoton('btnConceptoIngas').disable();
		} else {
			//this.getBoton('btnConceptoIngas').enable();
		}
		
		
		if(selectedNode.attributes.estado == 'finalizado' ){
		this.getBoton('sig_estado').disable();
		}
		else{
			this.getBoton('sig_estado').enable();
		}
		
		if(selectedNode.attributes.estado == 'nuevo' ){
		this.getBoton('ant_estado').disable();
		}
		else{
			this.getBoton('ant_estado').enable();
		}
		
		if(this.maestro.estado == 'cierre' || this.maestro.estado == 'finalizado' ){
			this.getBoton('sig_estado').disable();
			this.getBoton('ant_estado').disable();
		}
		  if (tb && this.bnew && (this.maestro.estado == 'cierre' || this.maestro.estado == 'finalizado' )) {
            tb.items.get('b-new-' + this.idContenedor).disable()
            }
		
		if (tb && this.bedit && (this.maestro.estado == 'cierre' || this.maestro.estado == 'finalizado' )) {
            tb.items.get('b-edit-' + this.idContenedor).disable()
            }
         if (tb && this.bdel && (this.maestro.estado == 'cierre' || this.maestro.estado == 'finalizado' )) {
            tb.items.get('b-del-' + this.idContenedor).disable()
            }
		
		
		return tb;
	},
	liberaMenu: function() {
		var tb = Phx.vista.Fase.superclass.liberaMenu.call(this);
		if (tb) {
			this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('diagrama_gantt').disable();
            	
			this.getBoton('sig_estado').disable();
			this.getBoton('ant_estado').disable();
            
		}
	
		return tb
	},
	openConceptoIngas: function(){
		var data = this.getSelectedData();
		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/fase_concepto_ingas/FaseConceptoIngas.php',
			'Servicios/Bienes', {
			    width: '90%',
			    height: '80%'
			},
			data,
			this.idContenedor,
			'FaseConceptoIngas'
		);
	},
	tabeast: [{
		url:'../../../sis_proyectos/vista/fase_concepto_ingas/FaseConceptoIngas.php',
		title:'Bienes/Servicios',
		width:'40%',
		height:'50%',
		cls:'FaseConceptoIngas'
	}, {
		url:'../../../sis_proyectos/vista/fase_avance_obs/FaseAvanceObsAv.php',
		title:'Avance de Supervicion',
		width:'40%',
		height:'50%',
		cls:'FaseAvanceObsAv'
	}, {
		url:'../../../sis_proyectos/vista/fase_avance_obs/FaseAvanceObsOb.php',
		title:'Notas',
		width:'40%',
		height:'50%',
		cls:'FaseAvanceObsOb'
	}],
	
	antEstado: function(res){
	  var selectedNode = this.sm.getSelectedNode();
	  console.log('selectedNode.attributes',selectedNode.attributes);
			//obsValorInicial;

		Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
			'Estado de Wf',
			{   modal: true,
			    width: 450,
			    height: 250
			}, 
			{    data: selectedNode.attributes, 
				 estado_destino: res.argument.estado
			    // obsValorInicial: obsValorInicial 
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
                url:'../../sis_proyectos/control/Fase/anteriorEstado',
            params:{
            	id_fase: wizard.data.id_fase,
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
       this.root.reload();
    },  
    
      sigEstado:function(){                   
     
      var selectedNode = this.sm.getSelectedNode();
	  console.log('selectedNode.attributes',selectedNode.attributes);
     
      this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal:true,
                                    width:700,
                                    height:450
                                }, {data:{
                                	   id_fase:selectedNode.attributes.id_fase,
                                       id_estado_wf:selectedNode.attributes.id_estado_wf,
                                       id_proceso_wf:selectedNode.attributes.id_proceso_wf,
                                    	
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
            url:'../../sis_proyectos/control/Fase/siguienteEstado',
            params:{
                id_fase:      wizard.data.id_fase,
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
        this.root.reload();
    },
})
</script>


