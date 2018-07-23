<?php
/**
*@package pXP
*@file gen-FaseConceptoIngas.php
*@author  (admin)
*@date 24-05-2018 19:13:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FaseConceptoIngas=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config;
		console.log('sss',config);
    	//llama al constructor de la clase padre
		Phx.vista.FaseConceptoIngas.superclass.constructor.call(this,config);
		this.init();

		this.Atributos[1].valorInicial = this.maestro.id_fase;
		//Seteo del store de la grilla
		this.store.baseParams = {
			id_fase: this.maestro.id_fase
		};
		this.load({
			params: {
				start: 0,
				limit: this.tam_pag
			}
		});

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
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p></div></tpl>',
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
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: false,
				anchor: '80%',
				gwidth: 300,
				maxLength:500
			},
				type:'TextArea',
				filters:{pfiltro:'facoing.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
			config:{
				name: 'cantidad',
				fieldLabel: 'Cantidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'facoing.cantidad',type:'numeric'},
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
	ActSave:'../../sis_proyectos/control/FaseConceptoIngas/insertarFaseConceptoIngas',
	ActDel:'../../sis_proyectos/control/FaseConceptoIngas/eliminarFaseConceptoIngas',
	ActList:'../../sis_proyectos/control/FaseConceptoIngas/listarFaseConceptoIngas',
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
		{name:'cantidad', type: 'numeric'},
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
		{name:'precio_total', type: 'numeric'}
	],
	sortInfo:{
		field: 'id_fase_concepto_ingas',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

	iniciaEventos: function(){
		//Evento para obtener el total
		this.Cmp.precio.on('blur',function(cmp){
			this.Cmp.precio_total.setValue(0);
			if(this.Cmp.cantidad.getValue()&&this.Cmp.precio.getValue()){
				this.Cmp.precio_total.setValue(this.Cmp.precio.getValue()*this.Cmp.cantidad.getValue());
			}
		},this);

		this.Cmp.cantidad.on('blur',function(cmp){
			this.Cmp.precio_total.setValue(0);
			if(this.Cmp.cantidad.getValue()&&this.Cmp.precio.getValue()){
				this.Cmp.precio_total.setValue(this.Cmp.precio.getValue()*this.Cmp.cantidad.getValue());
			}
		},this)
	}
})
</script>