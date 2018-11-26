<?php
/**
*@package pXP
*@file gen-AdqProgramada.php
*@author  (admin)
*@date 24-05-2018 19:13:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AdqProgramada=Ext.extend(Phx.gridInterfaz,{
	
	    gruposBarraTareas:[
        {name:'vencido',title:'<h1 align="center"><i class="fa fa-bars"></i> Vencidos</h1>',grupo:0,height:0},
        {name:'vigente',title:'<h1 align="center"><i class="fa fa-thumbs-o-up"></i> Por Vencer</h1>',grupo:1,height:0},
        {name:'otros',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Otros</h1>',grupo:2,height:0},
        ],
    	
    	bnewGroups: [0,1,2],
	    beditGroups: [0,1,2],
	    bdelGroups:  [0,1,2],
	    bactGroups:  [0,1,2],
	    btestGroups: [0,1,2],
	    bexcelGroups: [0,1,2],
	    
		 actualizarSegunTab: function(name, indice){
		 			console.log('name',name);
		              	 
		             this.store.baseParams.estado_tiempo = name;                           
		             this.load({params:{start:0, limit:this.tam_pag }});
		      
		    },
     	arrayDefaultColumHidden:['fecha_reg','usr_reg','fecha_mod','usr_mod','fecha_hasta','id_proceso_wf','id_estado_wf','id_funcionario','estado_reg','id_usuario_ai','usuario_ai','direccion','id_oficina'],
	    rowExpander: new Ext.ux.grid.RowExpander({
	            tpl : new Ext.Template(
	                '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Usuario Registro:&nbsp;&nbsp;</b> {usr_reg}</p>',
	                '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Fecha Registro:&nbsp;&nbsp;</b> {fecha_reg}</p>',           
	                '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Usuario Modificación:&nbsp;&nbsp;</b> {usr_mod}</p>',
	                '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Fecha Modificación:&nbsp;&nbsp;</b> {fecha_mod}</p>'
	            )
	    }) ,

		
	constructor:function(config){
		this.maestro=config;
		console.log('sss',config);
    	//llama al constructor de la clase padre
		Phx.vista.AdqProgramada.superclass.constructor.call(this,config);
		this.init();
		
		this.Atributos[1].valorInicial = this.maestro.id_proyecto;
		//Seteo del store de la grilla
		this.store.baseParams = {
			id_proyecto: this.maestro.id_proyecto,
			estado_tiempo:'vencido'
		};
		this.load({	params: {start: 0,limit: this.tam_pag}});
		this.iniciaEventos();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase_concepto_ingas'
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'estado_tiempo'
			 },
			type:'Field',
			form:true 
		},
			{
			config:{
				name:'id_bien_servicio',
				fieldLabel:'Bien/Servicio',
				typeAhead: true,
				allowBlank:false,
				triggerAction: 'all',
				emptyText:'Elija',
				selectOnFocus:false,
				forceSelection:true,
				mode:'local',
				store:new Ext.data.ArrayStore({
					fields: ['ID', 'valor'],
					data :	[
						['Bien','Bien'],
						['Servicio','Servicio']
						
					]
				}),
				valueField:'ID',
				displayField:'valor',
				width:250,
				/*listeners: {
					'afterrender': function(combo){			  
						combo.setValue('Bien');
					}
				}	*/					
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		       
        {
			config:{
				name: 'nombre_fase',
				fieldLabel: 'Fase',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'facoing.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},

				        
         {
			config:{
				name: 'tipo',
				fieldLabel: 'Tipo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextArea',
				filters:{pfiltro:'facoing.tipo',type:'string'},
				id_grupo:1,
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
					console.log('record',record);
					
				return '<tpl for="."><div class="x-combo-list-item"><p><b>Concepto de Gasto: </b> '+record.data['desc_ingas'] +'</p><p><b>Descripcion: </b> <font color="blue">'+record.data['descripcion']+'</font></p></div></tpl>';
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
			config:{
				name: 'fecha_estimada',
				fieldLabel: 'Fecha Estimada',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'facoing.fecha_estimada',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		 {
			config:{
				name: 'dias',
				fieldLabel: 'Dias Faltantes',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'facoing.dias_fatantes',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'facoing.descripcion',type:'string'},
				id_grupo:1,
				grid:false,
				form:true
		},

        {
			config:{
				name: 'cantidad_est',
				fieldLabel: 'Cantidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'facoing.cantidad_est',type:'numeric'},
				id_grupo:1,
				grid:true,
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
                        par_filtro:'ume.codigo#ume.descripcion'
                    }
                }),
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
			grid: true,
			form: true
		},
		{
			config:{
				name: 'precio',
				fieldLabel: 'Precio Unitario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 110,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'facoing.precio',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'precio_total',
				fieldLabel: 'Precio Total',
				allowBlank: true,
				anchor: '80%',
				gwidth: 110,
				maxLength:1179650,
				readOnly: true
			},
				type:'NumberField',
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tipo_cambio_mt',
				fieldLabel: 'TC MT',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'facoing.tipo_cambio_mt',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'tipo_cambio_mb',
				fieldLabel: 'TC MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'facoing.tipo_cambio_mb',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
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
				filters:{pfiltro:'facoing.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
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
				filters:{pfiltro:'facoing.estado_reg',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'precio_mb',
				fieldLabel: 'Precio MB',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'facoing.precio_mb',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'precio_mt',
				fieldLabel: 'Precio MT',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'facoing.precio_mt',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'facoing.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'facoing.usuario_ai',type:'string'},
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
				filters:{pfiltro:'facoing.fecha_reg',type:'date'},
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
				filters:{pfiltro:'facoing.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Fase Concepto de Gasto',
	/*
	ActSave:'../../sis_proyectos/control/FaseConceptoIngas/insertarFaseConceptoIngas',
	ActDel:'../../sis_proyectos/control/FaseConceptoIngas/eliminarFaseConceptoIngas',*/
	ActList:'../../sis_proyectos/control/FaseConceptoIngas/listarFaseConceptoIngasProgramado',
	id_store:'id_fase_concepto_ingas',
	fields: [
		{name:'id_fase_concepto_ingas', type: 'numeric'},
		{name:'id_fase', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_unidad_medida', type: 'numeric'},
		{name:'tipo_cambio_mt', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'tipo_cambio_mb', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'cantidad_est', type: 'numeric'},
		{name:'precio_mb', type: 'numeric'},
		{name:'precio', type: 'numeric'},
		{name:'precio_mt', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_ingas', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'desc_unidad_medida', type: 'string'},
		{name:'precio_total', type: 'numeric'},
		{name:'nombre_fase', type: 'string'},
		{name:'fecha_estimada', type: 'date'},
		{name:'estado_tiempo', type: 'string'},
		{name:'dias', type: 'numeric'},


	],
	sortInfo:{
		field: 'id_fase_concepto_ingas',
		direction: 'ASC'
	},
	bnew:false,
	bedit:false,
	bdel:false,
	bsave:false,

	iniciaEventos: function(){
		//Evento para obtener el total
		
		this.Cmp.id_bien_servicio.on('select',function(combo,record,index){
			console.log('tipo',record);
			
			
			this.Cmp.id_concepto_ingas.store.baseParams.tipo=record.data.ID;
			this.Cmp.id_concepto_ingas.store.load({params:{start:0,limit:this.tam_pag}, 
					               callback : function (r) {                        
					                    if (r.length > 0 ) {                        
					                    	
					                       this.Cmp.id_concepto_ingas.setValue(r[0].data.id_concepto_ingas);
					                    }     
					                                    
					                }, scope : this
					            });
			
		},this)
		
	 this.Cmp.id_concepto_ingas.on('select',function(combo,record,index){
			console.log('tipo',record);
			
			this.Cmp.id_concepto_ingas.store.baseParams.tipo=this.Cmp.id_bien_servicio.getValue();
		
		},this)
		
		this.Cmp.precio.on('blur',function(cmp){
			this.Cmp.precio_total.setValue(0);
			if(this.Cmp.cantidad_est.getValue()&&this.Cmp.precio.getValue()){
				this.Cmp.precio_total.setValue(this.Cmp.precio.getValue()*this.Cmp.cantidad_est.getValue());
			}
		},this);

		this.Cmp.cantidad_est.on('blur',function(cmp){
			this.Cmp.precio_total.setValue(0);
			if(this.Cmp.cantidad_est.getValue()&&this.Cmp.precio.getValue()){
				this.Cmp.precio_total.setValue(this.Cmp.precio.getValue()*this.Cmp.cantidad_est.getValue());
			}
		},this)
	},
	/*
	onReloadPage: function (m) {
				//alert ('asda');
				  
		            this.maestro = m;
		            this.store.baseParams = {id_proyecto: this.maestro.id_proyecto};
		           
		            this.load({params: {start: 0, limit: 50}})
		            this.Atributos[1].valorInicial = this.maestro.id_proyecto;
		            
	}*/
})
</script>