<?php
/**
*@package pXP
*@file gen-InvitacionDet.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:59
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InvitacionDetFrm=Ext.extend(Phx.frmInterfaz,{
	breset: true,
	bcancel: true,

	
	constructor:function(config){
		this.maestro=config;
		
		console.log('maestro',this.maestro=config);
		
		console.log('tipo det',this.maestro.data.tipo);
		console.log('gestion',this.maestro.data.id_gestion);
    	//llama al constructor de la clase padre
		Phx.vista.InvitacionDetFrm.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
		
		this.iniciarEventos();
		
		//this.iniciar();
		//this.bloquearMenus();
		
		},
   onReset:function(){
		this.form.getForm().reset();
		this.loadValoresIniciales();
		this.iniciarEventos();
	},



			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_invitacion_det'
			},
			type:'Field',
			form:true 
		},
			
	
		{
			config: {
				name: 'invitacion_det__tipo',
				fieldLabel: 'Tipo',
				anchor: '95%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'invitacion_det__tipo',
				hiddenName: 'invitacion_det__tipo',
				gwidth: 55,
				baseParams:{
					cod_subsistema:'PRO',
					catalogo_tipo:'tinvitacion_det__tipo'
				},
				valueField: 'codigo',
				hidden: false
			},
			type: 'ComboRec',
			id_grupo: 0,
			grid: false,
			form: true
		},
		
		
		/*
		{
			config:{
				name:'invitacion_det__tipo',
				fieldLabel:'invitacion_det__tipo',
				typeAhead: true,
				allowBlank:false,
				triggerAction: 'all',
				emptyText:'plani...',
				selectOnFocus:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
					fields: ['ID', 'valor'],
					data :	[
						['planif','planif'],
						['no_planif','no_planif']
					]
				}),
				valueField:'ID',
				displayField:'valor',
				width:250,							
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},*/
		{
            config:{
                name: 'id_concepto_ingas',
                fieldLabel: 'Concepto de Gasto',
                allowBlank: false,
                emptyText: 'Concepto...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
                    id : 'id_concepto_ingas',
                    root: 'datos',
                    sortInfo:{
                        field: 'desc_ingas',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot','desc_gestion','tipo'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'desc_ingas#par.codigo',movimiento:'gasto'}
                }),
                
               	valueField: 'id_concepto_ingas',
				displayField: 'desc_ingas',
				gdisplayField: 'desc_ingas',
				hiddenName: 'id_concepto_ingas',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				listWidth:500,
				resizable:true,
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width: 250,
				gwidth:250,
				minChars:2,
				anchor:'100%',
				qtip:'Si el concepto de gasto que necesita no existe por favor comuníquese con el área de presupuestos para solicitar la creación.',
				//tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p></div></tpl>',
				renderer:function(value, p, record){
					return String.format('{0}', record.data['desc_ingas']);
				}
            },
            type:'ComboBox',
			bottom_filter: true,
            filters:{pfiltro:'cig.desc_ingas',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },

		
		{
			config: {
				name: 'id_fase_concepto_ingas',
				fieldLabel: 'Fase Concepto Ingas',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_proyectos/control/FaseConceptoIngas/listarFaseConceptoIngas',
					id: 'id_fase_concepto_ingas',
					root: 'datos',
					sortInfo: {
						field: 'id_fase_concepto_ingas',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_fase_concepto_ingas','descripcion','desc_ingas','cantidad_est','precio','nombre_fase','codigo_fase','id_unidad_medida','tipo','id_fase','id_concepto_ingas'],
					remoteSort: true,
					baseParams: {par_filtro: 'facoing.id_fase_concepto_ingas#facoing.descripcion#facoing.id_unidad_medida#cig.tipo'}
				}),
				
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Fase: </b>{codigo_fase}-{nombre_fase}</p>\
		                       <p><b>Servicio/Bien: </b>{tipo}</p>\
		                      <p><b>Cantidad: </b>{cantidad_est}</p>\
		                       <p><b>Precio Unitario: </b>{precio}</p>\
		                      </div></tpl>',
				valueField: 'id_fase_concepto_ingas',
				displayField: 'desc_ingas',
				gdisplayField: 'desc_ingas',
				hiddenName: 'id_fase_concepto_ingas',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['desc_ingas']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'facoing.id_fase_concepto_ingas',type: 'string'},
			grid: true,
			form: true
		},
		{
			config: {
                name: 'id_fase',
                fieldLabel: 'Fase',
                allowBlank: false,
                emptyText: 'Elija una opción',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/Fase/listarFase',
                    id: 'id_fase',
                    root: 'datos',
                    fields: ['id_fase','codigo','nombre','descripcion'],
                    totalProperty: 'total',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    baseParams:{
                        start: 0,
                        limit: 10,
                        sort: 'id_fase',
                        dir: 'ASC',
                        par_filtro:'fase.id_fase#fase.codigo#fase.descripcion#fase.nombre'
                    }
                }),
             	tpl:'<tpl for=".">\ <div class="x-combo-list-item"><p><b>Fase: </b>{codigo}-{nombre}</p>\<p><b>Descripcion: </b>{descripcion}</p>\</div></tpl>',
                valueField: 'id_fase',
                hiddenValue: 'id_fase',
                displayField: 'codigo',
                gdisplayField: 'descripcion',
                mode: 'remote',
                triggerAction: 'all',
                lazyRender: true,
                pageSize: 15,
               
                minChars: 2,
                gwidth: 120
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'fase.codigo',type: 'string'},
			
			grid: true,
			form: true
		},
		
			{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_invitacion'
			},
			type:'Field',
			form:true 
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
				filters:{pfiltro:'ivtd.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		
			{
			config: {
                name: 'id_unidad_medida',
                fieldLabel: 'Unidad Medida',
                allowBlank: false,
                emptyText: 'Elija una opción',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/UnidadMedida/listarUnidadMedida',
                    id: 'id_unidad_medida',
                    root: 'datos',
                    fields: ['id_unidad_medida','codigo','descripcion'],
                    totalProperty: 'total',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    baseParams:{
                        start: 0,
                        limit: 10,
                        sort: 'descripcion',
                        dir: 'ASC',
                        par_filtro:'ume.id_unidad_medida#ume.codigo#ume.descripcion'
                    }
                }),
                renderer : function(value, p, record) {
					Phx.CP.loadingHide();
					//return String.format('{0}', record.data['codigo']);
					
				},
                valueField: 'id_unidad_medida',
                hiddenValue: 'id_unidad_medida',
                displayField: 'descripcion',
                gdisplayField: 'desc_unidad_medida',
                mode: 'remote',
                triggerAction: 'all',
                lazyRender: true,
                pageSize: 15,
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo} - {descripcion}</p></div></tpl>',
                minChars: 2,
                gwidth: 120
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'ume.codigo',type: 'string'},
			egrid:true,
			grid: true,
			form: true
		},
		
			{
				config:{
					name: 'cantidad_sol',
					fieldLabel: 'Cantidad',
					allowBlank: true,
					anchor: '80%',
					gwidth: 80,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
						
					}
				},
					type:'NumberField',
					filters:{pfiltro:'ivtd.cantidad_sol',type:'numeric'},
					id_grupo:0,
					bottom_filter: true,
					egrid:true,
					grid:true,
					form:true
			},
				{
				config:{
					name: 'precio',
					fieldLabel: 'Precio',
					allowBlank: true,
					anchor: '80%',
					gwidth: 80,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
						
					}
				},
					type:'NumberField',
					filters:{pfiltro:'ivtd.precio',type:'numeric'},
					id_grupo:0,
					bottom_filter: true,
					egrid:true,
					grid:true,
					form:true
			},
			{
			config: {
				name: 'id_centro_costo',
				fieldLabel: 'Centro Costo',
				allowBlank: true,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/CentroCosto/listarCentroCostoGrid',
					id: 'id_centro_costo',
					root: 'datos',
					sortInfo: {
						field: 'codigo_cc',
						direction: 'ASC'
					},
					totalProperty: 'codigo_cc',
					fields: ['id_centro_costo', 'codigo_cc', 'descripcion_tcc','id_gestion'],
					remoteSort: true,
					baseParams: {par_filtro: 'codigo_cc#descripcion_tcc'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo_cc}</p>\
		                       <p><b>Descripcion: </b>{descripcion_tcc}</p>\
		                        </div></tpl>',
				
				valueField: 'id_centro_costo',
				displayField: 'codigo_cc',
				gdisplayField: 'codigo_tcc',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo_tcc']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'codigo_cc#descripcion',type: 'string'},
			grid: true,
			form: true
		},
			
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'ivtd.Descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		
			{
			config:{
				name: 'desc_fase',
				fieldLabel: 'desc_fase',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'desc_fase',type:'string'},
				//egrid:true,
				id_grupo:0,
				grid:true,
				form:false
			},
				{
			config:{
				name: 'desc_ingas',
				fieldLabel: 'desc_ingas',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'desc_ingas',type:'string'},
				//egrid:true,
				id_grupo:0,
				grid:true,
				form:false
			},
			{
				config:{
					name: 'cantidad_est',
					fieldLabel: 'cantidad_est',
					allowBlank: true,
					anchor: '80%',
					gwidth: 80,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
						
					}
				},
					type:'NumberField',
					filters:{pfiltro:'cantidad_est',type:'numeric'},
					id_grupo:0,
					bottom_filter: true,
					//egrid:true,
					grid:true,
					form:false
			},
			{
				config:{
					name: 'precio_est',
					fieldLabel: 'precio_est',
					allowBlank: true,
					anchor: '80%',
					gwidth: 80,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}',  Ext.util.Format.number(value,'0,000.00'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0,000.00'));
						}
						
					}
				},
					type:'NumberField',
					filters:{pfiltro:'precio_est',type:'numeric'},
					id_grupo:0,
					bottom_filter: true,
					//egrid:true,
					grid:true,
					form:false
			},
			
			{
			config:{
				name: 'observaciones',
				fieldLabel: 'observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'ivtd.observaciones',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
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
				filters:{pfiltro:'ivtd.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ivtd.fecha_reg',type:'date'},
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
				filters:{pfiltro:'ivtd.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'ivtd.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
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
		}
	],
	tam_pag:50,	
	title:'invitacion det',
	ActSave:'../../sis_proyectos/control/InvitacionDet/insertarInvitacionDet',
	ActDel:'../../sis_proyectos/control/InvitacionDet/eliminarInvitacionDet',
	ActList:'../../sis_proyectos/control/InvitacionDet/listarInvitacionDet',
	id_store:'id_invitacion_det',
	fields: [
		{name:'id_invitacion_det', type: 'numeric'},
		{name:'id_fase_concepto_ingas', type: 'numeric'},
		{name:'id_invitacion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'observaciones', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_ingas', type: 'string'},
		
		{name:'cantidad_sol', type: 'numeric'},
		{name:'id_unidad_medida', type: 'numeric'},
		{name:'precio', type: 'numeric'},
		
		{name:'desc_unidad_medida', type: 'string'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_fase', type: 'numeric'},
		'codigo'
		
		
		
											
	],
	sortInfo:{
		field: 'id_invitacion_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	bedit:false,
	 onReloadPage: function(m) {    	
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_invitacion')].valorInicial = this.maestro.id_invitacion;
        //Filtro para los datos
        this.store.baseParams = {
            id_invitacion: this.maestro.id_invitacion
        };
        
       
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });
    },
    /*
    onButtonNew: function(){
    	
    	
		Phx.vista.InvitacionDetFrn.superclass.onButtonNew.call(this);
		
		this.ocultarComponente(this.Cmp.id_concepto_ingas);
		this.ocultarComponente(this.Cmp.id_fase_concepto_ingas);
	    this.ocultarComponente(this.Cmp.observaciones);
	    this.ocultarComponente(this.Cmp.id_unidad_medida);
	     
	    this.ocultarComponente(this.Cmp.cantidad_sol);
	    this.ocultarComponente(this.Cmp.precio);
		

		
	},*/
	
	iniciar:function(){
			
			this.Cmp.id_unidad_medida.store.baseParams.id_unidad_medida = this.Cmp.id_unidad_medida.getValue();
			this.Cmp.id_unidad_medida.store.load({params:{start:0,limit:this.tam_pag}, 
			callback : function (r) {                        
				if (r.length > 0 ) {                        
					                    	
					 this.Cmp.id_unidad_medida.setValue(r[0].data.id_unidad_medida);
					                }     
					                                    
					                }, scope : this
					            });
			
		
		
	},
    	
    	iniciarEventos: function(){
    		
    	console.log('invitacion',this.maestro.data.id_invitacion)	
    	this.Cmp.id_invitacion.setValue(this.maestro.data.id_invitacion);

 	   //this.cmpIdUnMe = this.getComponente('id_unidad_medida');
 		this.mostrarComponente(this.Cmp.invitacion_det__tipo);	 
		this.ocultarComponente(this.Cmp.id_concepto_ingas);
		
		this.ocultarComponente(this.Cmp.id_fase);
		
		this.ocultarComponente(this.Cmp.id_fase_concepto_ingas);
	    this.ocultarComponente(this.Cmp.observaciones);
	    this.ocultarComponente(this.Cmp.id_unidad_medida);
	     
	    this.ocultarComponente(this.Cmp.cantidad_sol);
	    this.ocultarComponente(this.Cmp.precio);
	    
	    this.ocultarComponente(this.Cmp.id_centro_costo);
	    this.ocultarComponente(this.Cmp.descripcion);

			 this.Cmp.invitacion_det__tipo.on('select',function(combo,record,index){
						console.log('data',record.data);
						//if(record.data.ID == 'planif' ){
						if(record.data.codigo == 'planif' ){
									
								 this.Cmp.id_fase_concepto_ingas.reset();
							     this.Cmp.observaciones.reset();
							     this.Cmp.id_unidad_medida.reset();     
							     this.Cmp.cantidad_sol.reset();
							     this.Cmp.precio.reset();								
								 this.Cmp.id_concepto_ingas.reset();
								 this.Cmp.id_fase.reset();
																	
								
								
								 this.ocultarComponente(this.Cmp.id_concepto_ingas);
								 this.ocultarComponente(this.Cmp.id_fase);
								 this.Cmp.id_concepto_ingas.allowBlank=true;
								 this.Cmp.id_fase.allowBlank=true;		
							     this.mostrarComponente(this.Cmp.id_fase_concepto_ingas);
							     this.mostrarComponente(this.Cmp.observaciones);
							     this.mostrarComponente(this.Cmp.id_unidad_medida);     
							     this.mostrarComponente(this.Cmp.cantidad_sol);
							     this.mostrarComponente(this.Cmp.precio);
								
								 this.mostrarComponente(this.Cmp.id_centro_costo);
							     this.mostrarComponente(this.Cmp.descripcion);
							     console.log(this.maestro.tipo);
							     
							   
							     //this.Cmp.id_fase_concepto_ingas.store.baseParams.tipo= this.maestro.data.tipo;
							     
							     this.Cmp.id_fase_concepto_ingas.store.baseParams= {tipo:this.maestro.data.tipo , id_proyecto:this.maestro.data.id_proyecto};

							     
							     this.Cmp.id_concepto_ingas.store.baseParams.tipo= this.maestro.data.tipo;
							     
							     this.Cmp.id_centro_costo.store.baseParams.id_gestion=this.maestro.data.id_gestion;


									
							     this.Cmp.id_fase_concepto_ingas.on('select', function(cmb,rec,i){
								////se aumento filtro para el controlador de ACTUnidadMedida.php en sis parametros
								
							   this.Cmp.id_fase.setValue(rec.data.id_fase);
							   this.Cmp.id_concepto_ingas.setValue(rec.data.id_concepto_ingas);
								
							    this.Cmp.id_unidad_medida.store.baseParams.query = rec.data.id_unidad_medida;
							    this.Cmp.id_unidad_medida.store.load({params:{start:0,limit:this.tam_pag}, 
					               callback : function (r) {                        
					                    if (r.length > 0 ) {                        
					                    	
					                       this.Cmp.id_unidad_medida.setValue(r[0].data.id_unidad_medida);
					                    }     
					                                    
					                }, scope : this
					            });
			 
							     //this.Cmp.id_unidad_medida.setValue(rec.data.desc_unidad_medida);
					             this.Cmp.cantidad_sol.setValue(rec.data.cantidad_est);
					             this.Cmp.precio.setValue(rec.data.precio);
					            
					            } ,this);

						} else{
								 this.Cmp.id_fase_concepto_ingas.reset();
							     this.Cmp.observaciones.reset();
							     this.Cmp.id_unidad_medida.reset();     
							     this.Cmp.cantidad_sol.reset();
							     this.Cmp.precio.reset();
							     this.Cmp.id_concepto_ingas.reset();
								 this.Cmp.id_fase.reset();	
							     
							     this.mostrarComponente(this.Cmp.id_concepto_ingas);
							     this.mostrarComponente(this.Cmp.id_fase);								 
							     this.ocultarComponente(this.Cmp.id_fase_concepto_ingas);
							     this.Cmp.id_fase_concepto_ingas.allowBlank=true;
							    							     
							     this.mostrarComponente(this.Cmp.observaciones);
							     this.mostrarComponente(this.Cmp.id_unidad_medida);	     
							     this.mostrarComponente(this.Cmp.cantidad_sol);
							     this.mostrarComponente(this.Cmp.precio);
							     
							     this.mostrarComponente(this.Cmp.id_centro_costo);
							     this.mostrarComponente(this.Cmp.descripcion);
							     
								 this.Cmp.id_fase.store.baseParams={id_proyecto:this.maestro.data.id_proyecto};
							
								
						} 
						
					
						
					},this);
			
			
					

    	},
   
     successSave:function(resp)
        {
            Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            this.panel.close();
        },

		 		
 
 		   
    
})
</script>
		
		