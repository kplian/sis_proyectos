<?php
/**
*@package pXP
*@file gen-InvitacionDet.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:59
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
		ISSUE		FECHA		AUTHOR			DESCRIPCION
		 #6	EndeEtr 24/01/2019	 EGS		    Se hace validacion paa que la invitacion tenga fecha al querer añadir un detalle
		 #7	EndeEtr 04/02/2019	 EGS		    Se hace validacion para que no guarde en estado de sol_compra
 * 		#8	EndeEtr 18/03/2019	 EGS		    se fuerza a escoger centro de costo
 * */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InvitacionDet=Ext.extend(Phx.gridInterfaz,{
		
		
	constructor:function(config){
		this.maestro=config.maestro;
		var v_fecha = null;
		var estado_proyecto;
		var estado_invitacion;
		var id_tipo_cc;
    	//llama al constructor de la clase padre
		Phx.vista.InvitacionDet.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
		this.iniciarEventos();
		this.iniciar();
		this.bloquearMenus();
		//console.log('maestro invitacion Det',this.maestro);

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
			config: {
				name: 'invitacion_det__tipo',
				fieldLabel: 'invitacion_det__tipo',
				anchor: '95%',
				tinit: false,
				allowBlank: true,
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
			filters:{pfiltro:'mov.prestamo',type:'string'},
			grid: false,
			form: true
		},
		{
			config:{
				name: 'desc_fase',
				fieldLabel: 'Fase',
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
				fieldLabel: 'Concepto de Gasto',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'cig.desc_ingas,cig.tipo',type:'string'},
				bottom_filter:true,
				//egrid:true,
				id_grupo:0,
				grid:true,
				form:false
			},
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
                    fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot','desc_gestion'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'desc_ingas#par.codigo',movimiento:'gasto'}//, autorizacion: 'viatico'}
                }),
                tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Concepto de Gasto: </b>{desc_ingas}</p>\
		                       <p><b>Movimiento:</b>{movimiento}</p>\
		                        <p><b>Partida:</b>{desc_partida}</p> </div></tpl>',
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
			bottom_filter: false,
            filters:{pfiltro:'cig.desc_ingas',type:'string'},
            id_grupo:1,
            grid:false,
            form:true
        },

		
		{
			config: {
				name: 'id_fase_concepto_ingas',
				fieldLabel: 'Fase Concepto Gasto',
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
					fields: ['id_fase_concepto_ingas','descripcion','desc_ingas','cantidad_est','precio','nombre_fase','codigo_fase','id_unidad_medida'],
					remoteSort: true,
					baseParams: {par_filtro: 'facoing.id_fase_concepto_ingas#facoing.descripcion#facoing.desc_ingas#id_unidad_medida'}
				}),
				
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Fase: </b>{codigo_fase}-{nombre_fase}</p>\
		                       <p><b>Servicio/Bien: </b>{descripcion}</p>\
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
			bottom_filter:false,
			filters: {pfiltro: 'ivtd.id_fase_concepto_ingas',type: 'string'},
			grid: false,
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
							return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
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
					fieldLabel: 'Precio Unitario',
					allowBlank: true,
					anchor: '80%',
					gwidth: 150,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							
							//return value;
							return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
						}
						
					}
				},
					type:'MoneyField',
					filters:{pfiltro:'ivtd.precio',type:'numeric'},
					id_grupo:0,
					bottom_filter: true,
					egrid:true,
					grid:true,
					form:true
			},
	
			{
				config:{
					name: 'cantidad_est',
					fieldLabel: 'Cantidad Estimada',
					allowBlank: true,
					anchor: '80%',
					gwidth: 100,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
						}
						
					}
				},
					type:'NumberField',
					filters:{pfiltro:'cantidad_est',type:'numeric'},
					id_grupo:0,
					bottom_filter:false,
					//egrid:true,
					grid:false,
					form:false
			},
			{
				config:{
					name: 'precio_t',
					fieldLabel:'Precio Total',
					allowBlank: true,
					anchor: '80%',
					gwidth: 150,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						
						var total = record.data.cantidad_sol*record.data.precio;
						//total = total.toFixed(2);
						var tol=total.toLocaleString();
						var to = tol.toString();
						if(record.data.tipo_reg != 'summary'){
							return  String.format(to,Ext.util.Format.number(value,'0.000,00/i'));
						}
						else{
							Ext.util.Format.usMoney
							
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
						}
						
					}
				},
					type:'MoneyField',
					filters:{pfiltro:'precio_t',type:'numeric'},
					id_grupo:0,
					bottom_filter:false,
					//egrid:true,
					grid:true,
					form:true
			},
			{
				config:{
					name:'precio_est',
					fieldLabel:'Precio Total Estimado',
					allowBlank: true,
					anchor: '80%',
					gwidth: 200,
					galign: 'right ',
					maxLength:1179650,
					renderer:function (value,p,record){
						console.log('record',record);
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
						}
						
					}
				},
					type:'MoneyField',
					filters:{pfiltro:'precio_est',type:'numeric'},
					id_grupo:0,
					bottom_filter:false,
					//egrid:true,
					grid:true,
					form:true
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
		config: {
				name: 'id_centro_costo',
				fieldLabel: 'Centro Costo',
				allowBlank: true,//#8
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
					fields: ['id_centro_costo', 'codigo_cc', 'descripcion_tcc'],
					remoteSort: true,
					baseParams: {par_filtro: 'codigo_cc#descripcion_tcc'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo_cc}</p>\
		                       <p><b>Descripcion: </b>{descripcion_tcc}</p>\
		                        </div></tpl>',
				
				valueField: 'id_centro_costo',
				displayField: 'codigo_cc',
				gdisplayField: 'codigo_cc',
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
					return String.format('{0}', record.data['codigo_cc']);
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
		{name:'id_fase', type: 'numeric'},
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
		
		{name:'id_centro_costo', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'codigo_cc', type: 'string'},
		'codigo',
		'desc_fase',
		'cantidad_est',
		{name:'precio_est', type: 'numeric'},
									
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
        console.log('maestro', this.maestro.estado);		
 	    this.obtenerProyecto(this.maestro);
        this.estado_invitacion = this.maestro.estado; 
        this.Atributos[this.getIndAtributo('id_invitacion')].valorInicial = this.maestro.id_invitacion;
        //Filtro para los datos
		
	     this.setColumnHeader('precio','(e)'+this.cmpPrecio.fieldLabel +' '+ this.maestro.desc_moneda)
	     this.setColumnHeader('precio_t',this.cmpPrecioT.fieldLabel +' '+ this.maestro.desc_moneda)
	     this.setColumnHeader('precio_est',this.cmpPrecioEst.fieldLabel +' '+ this.maestro.desc_moneda)

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
    
    	obtenerProyecto: function(config){
			//console.log('config id_proyecto',config.id_proyecto);
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_proyectos/control/Proyecto/listarProyecto',
                params:{
                    id_proyecto: config.id_proyecto,
                },
                success: function(resp){
                	 Phx.CP.loadingHide();
                     var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                   
                        //console.log('datos ajax',reg.datos[0]['estado']);
               			this.estado_proyecto =reg.datos[0]['estado'];
              			this.id_tipo_cc =reg.datos[0]['id_tipo_cc'];

               			
               		

                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });
 
        },
    
    onButtonNew: function(){
    	
    	/*
		Phx.vista.InvitacionDet.superclass.onButtonNew.call(this);
		
		this.ocultarComponente(this.Cmp.id_concepto_ingas);
		 this.ocultarComponente(this.Cmp.id_fase_concepto_ingas);
	     this.ocultarComponente(this.Cmp.observaciones);
	     this.ocultarComponente(this.Cmp.id_unidad_medida);
	     
	     this.ocultarComponente(this.Cmp.cantidad_sol);
	     this.ocultarComponente(this.Cmp.precio);*/
		console.log('estado',this.estado_proyecto);	
		if(this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado')
               			{
               				alert ('El proyecto se encuentra en estado de ' + this.estado_proyecto);
               			}
               			else{
               				//#6
               				if (this.maestro.id_gestion == null) {
						    		alert('Ingrese una Fecha en la Invitacion Por Favor ');
						    	}
    						else{
               				this.abrirFormulario('news');  
							}
               			}
	
	},
	
	iniciar:function(){


			///Carga la columna de la grilla de combo remoto que tiene egrid
			this.Cmp.id_unidad_medida.store.baseParams.query = this.Cmp.id_unidad_medida.getValue();
			this.Cmp.id_unidad_medida.store.load({params:{start:0,limit:this.tam_pag}, 
			callback : function (r) {                        
				if (r.length > 0 ) {                        
					                    	
					 this.Cmp.id_unidad_medida.setValue(r[0].data.id_unidad_medida);
					                }     
					                                    
					                }, scope : this
					            });
			
		
		
	},
    	
    	iniciarEventos: function(){		
    		this.cmpPrecio = this.getComponente('precio');
    		this.cmpPrecioT = this.getComponente('precio_t');
    		this.cmpPrecioEst = this.getComponente('precio_est');
			console.log('this.cmpPrecioT',this.cmpPrecioT)
			 this.Cmp.invitacion_det__tipo.on('select',function(combo,record,index){
		
						if(record.data.ID == 'planif' ){
								
								 this.ocultarComponente(this.Cmp.id_concepto_ingas);
								 this.Cmp.id_concepto_ingas.allowBlank=true;		
							     this.mostrarComponente(this.Cmp.id_fase_concepto_ingas);
							     this.mostrarComponente(this.Cmp.observaciones);
							     this.mostrarComponente(this.Cmp.id_unidad_medida);     
							     this.mostrarComponente(this.Cmp.cantidad_sol);
							     this.mostrarComponente(this.Cmp.precio);

							     this.Cmp.id_fase_concepto_ingas.on('select', function(cmb,rec,i){
							    
							    
							    ////se aumento filtro para el controlador de ACTUnidadMedida.php en sis parametros
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
								
							     this.mostrarComponente(this.Cmp.id_concepto_ingas);								 
							     this.ocultarComponente(this.Cmp.id_fase_concepto_ingas);
							     this.Cmp.id_fase_concepto_ingas.allowBlank=true;							     
							     this.mostrarComponente(this.Cmp.observaciones);
							     this.mostrarComponente(this.Cmp.id_unidad_medida);	     
							     this.mostrarComponente(this.Cmp.cantidad_sol);
							     this.mostrarComponente(this.Cmp.precio);

						} 
						
					
						
					},this);
			
			
					

    	},

	
	///se creo un nuevo formulario para regristrar ya que hay un bug en  la carga del egrid remoto con la carga en cascada de fase concepto gas al registrar 
	abrirFormulario: function(tipo, record){
   	       var me = this;
   	       
   	     //console.log('eso',me.maestro.id_invitacion);
   	     //console.log('tipo',this.maestro.tipo);
   	      //console.log('maestro fecha',this.maestro.fecha);
   	      //console.log('id_gestion',this.maestro.id_gestion);
   	      //console.log('id_proyecto',this.maestro.id_proyecto);
       	     console.log('id_tipo_cc',this.id_tipo_cc);

           this.v_fecha=this.maestro.fecha;   
   	       	
   	                me.objSolForm = Phx.CP.loadWindows('../../../sis_proyectos/vista/invitacion_det/InvitacionDetFrm.php',
			                                me.formTitulo,
			                                {
			                                    modal:true,
			                                    width:'50%',
												height:(me.regitrarDetalle == 'si')? '70%':'40%',
		
		
			                                    
			                                }, { data: { 
				                                	 //objPadre: me ,
				                                	 id_invitacion: me.maestro.id_invitacion,
				                                	 fecha: this.v_fecha,
				                                	 tipo: me.maestro.tipo,
				                                	 id_gestion: me.maestro.id_gestion,
				                                	 id_proyecto: me.maestro.id_proyecto,
				                                	 id_tipo_cc:this.id_tipo_cc,	                                	 

				                                	 datosOriginales: record,
				                                	 readOnly: (tipo=='noedit')? true: false
			                                    },
			                                     bsubmit: (tipo=='noedit')? false: true ,
			                                    regitrarDetalle: 'si'
			                                }, 
			                                this.idContenedor,
			                                'InvitacionDetFrm',
			                                {
			                                    config:[{
			                                              event:'successsave',
			                                              delegate: this.onSaveForm,
			                                              
			                                            }],
			                                    
			                                    scope:this
			                                 }); 
	                                 
	                                  
   },
   
   preparaMenu: function(n){

		var tb = Phx.vista.InvitacionDet.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();
	
		console.log('estado_proyecto',this.estado_proyecto );
		if (tb && this.bnew && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado' || this.estado_invitacion == 'sol_compra')) {
            tb.items.get('b-new-' + this.idContenedor).disable();
            }
		if (tb && this.bedit && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado'  || this.estado_invitacion == 'sol_compra')) {
            tb.items.get('b-edit-' + this.idContenedor).disable();
            }
         if (tb && this.bdel && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado'  || this.estado_invitacion == 'sol_compra')) {
            tb.items.get('b-del-' + this.idContenedor).disable();
            }
             //#7	
         if (tb && this.bsave && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado'  || this.estado_invitacion == 'sol_compra')) {
            tb.items.get('b-save-' + this.idContenedor).disable();
            }//#7	
		return tb;
	},
	   
    
})
</script>
		
		