<?php
/**
*@package pXP
*@file gen-ProyectoActivoDetalle.php
*@author  (admin)
*@date 10-10-2017 18:02:07
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoActivoDetalle=Ext.extend(Phx.gridInterfaz,{
	operacion: 'nuevo',

	mainRegionPanel: {
        title: 'Datos Proyecto',
        region:'west',
        collapsed: true,
        width: 250
    },

	constructor:function(config){
		this.maestro=config;
    	//llama al constructor de la clase padre
		Phx.vista.ProyectoActivoDetalle.superclass.constructor.call(this,config);
		this.init();

		//Setea store par el listado
		this.store.baseParams = {
			id_proyecto_activo: this.maestro.id_proyecto_activo,
			id_tipo_cc: this.maestro.id_tipo_cc
		};

		//Setea los valores por defecto en el formulario
		this.Atributos[1].valorInicial = this.maestro.id_proyecto_activo;
		this.Atributos[2].valorInicial = this.maestro.id_tipo_cc;

		//Carga de los datos
		this.load({params:{start:0, limit:this.tam_pag}})

		//
		this.dataTemplate = new Ext.XTemplate(
        '<div class="details">',
            '<tpl for=".">',
                '<b>Código: </b>',
                '<span>{codigo}</span>',
            '</tpl>',
        '</div>'
    	);

		this.dataTemplate.compile();
		this.panelData = new Ext.Panel();
		//var detailEl = Ext.getCmp(this.panelData.getId()).body;//.body;
		this.dataTemplate.overwrite(this.panelData, {codigo: 'HOLA'});
		//detailEl.slideIn('l', {stopFx:true,duration:.3});

		//var detailEl = Ext.getCmp(this.maestro+'proyData');//.body;
		//console.log('ddddd',detailEl);
        /*this.dataTemplate.overwrite(detailEl, {});
        detailEl.slideIn('l', {stopFx:true,duration:.3});*/

        //Seteo del id_tipo_cc del combo de cuentas
        Ext.apply(this.Cmp.nro_cuenta.getStore().baseParams,{id_tipo_cc: this.maestro.id_tipo_cc});
        //Ext.apply(this.Cmp.id_comprobante.getStore().baseParams,{id_tipo_cc: this.maestro.id_tipo_cc});

        //Eventos
        this.Cmp.nro_cuenta.on('select',this.onSelectCuenta,this);
        //this.Cmp.id_comprobante.on('select',this.onSelectComprobante,this);
	},

	Atributos:[
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto_activo_detalle'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto_activo'
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
			config: {
				name: 'nro_cuenta',
				fieldLabel: 'Cuenta',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/Cuenta/listarCuentaTCC',
					id: 'nro_cuenta',
					root: 'datos',
					sortInfo: {
						field: 'nro_cuenta',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['nro_cuenta','nombre_cuenta'],
					remoteSort: true,
					baseParams: {par_filtro: 'cue.nro_cuenta#cue.nombre_cuenta'}
				}),
				valueField: 'nro_cuenta',
				displayField: 'nro_cuenta',
				gdisplayField: 'desc_cuenta',
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>Nro.Cuenta: </b>{nro_cuenta}</p><p><b>Cuenta: </b> {nombre_cuenta}</p></div></tpl>',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				resizable: true,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer: function(value, p, record) {
					return String.format('{0}',record.data['desc_cuenta']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			grid: true,
			form: true
		},
	   	/*{
			config: {
				name: 'id_comprobante',
				fieldLabel: 'Comprobante',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/IntComprobante/listarIntComprobanteTCCCuenta',
					id: 'id_int_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'fecha',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_int_comprobante','fecha','nro_tramite','glosa1'],
					remoteSort: true
				}),
				valueField: 'id_int_comprobante',
				displayField: 'nro_tramite',
				gdisplayField: 'nro_tramite',
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>Fecha: </b>{fecha}</p><p><b>Número: </b> {nro_tramite}</p><p><b>Glosa: </b> {glosa1}</p></div></tpl>',
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
					return String.format('{0}',record.data['nro_tramite']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			filters: {pfiltro: 'com.nro_tramite',type: 'string'},
			grid: true,
			form: true
		},*/
		/*{
			config: {
				name: 'id_comprobante',
				fieldLabel: 'Comprobante',
				allowBlank: false,
				tinit:true,
   			    resizable:true,
   			    tasignacion:true,
   			    tname:'id_comprobante',
		        tdisplayField:'nro_tramite',
   				turl:'../../../sis_contabilidad/vista/int_comprobante/IntComprobanteReg.php',
	   			ttitle:'Comprobantes',
	   			tconfig:{width:'80%',height:'90%'},
	   			tdata:{llega: 'o no llega'},
	   			tcls:'IntComprobanteReg',
	   			pid:this.idContenedor,
				emptyText: 'Comprobante...',
				store: new Ext.data.JsonStore({
					url: '../../sis_contabilidad/control/IntComprobante/listarIntComprobanteTCCCuenta',
					id: 'id_int_comprobante',
					root: 'datos',
					sortInfo: {
						field: 'fecha',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_int_comprobante','fecha','nro_tramite','glosa1'],
					remoteSort: true
				}),
				valueField: 'id_int_comprobante',
				displayField: 'nro_tramite',
				gdisplayField: 'nro_tramite',
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>Fecha: </b>{fecha}</p><p><b>Número: </b> {nro_tramite}</p><p><b>Glosa: </b> {glosa1}</p></div></tpl>',
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
					return String.format('{0}',record.data['nro_tramite']);
				}
			},
			type: 'TrigguerCombo',
			id_grupo: 1,
			filters: {pfiltro: 'com.nro_tramite',type: 'string'},
			grid: true,
			form: true
		},*/
		{
			config: {
				name: 'codigo_partida',
				fieldLabel: 'Partida',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_presupuestos/control/Partida/listarPartida',
					id: 'codigo',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['codigo','nombre_partida'],
					remoteSort: true,
					baseParams: {par_filtro: 'par.codigo#par.nombre_partida'}
				}),
				valueField: 'codigo',
				displayField: 'codigo',
				gdisplayField: 'desc_partida',
				tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>Código: </b>{codigo}</p><p><b>Partida: </b> {nombre_partida}</p></div></tpl>',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				resizable: true,
				anchor: '100%',
				gwidth: 150,
				minChars: 2,
				renderer: function(value, p, record) {
					return String.format('{0}',record.data['desc_partida']);
				}
			},
			type: 'ComboBox',
			id_grupo: 1,
			grid: true,
			form: true
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Justificación',
				allowBlank: false,
				anchor: '97%',
				gwidth: 100,
				maxLength:5000
			},
			type:'TextArea',
			filters:{pfiltro:'pracde.observaciones',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'monto',
				fieldLabel: 'Importe',
				allowBlank: false,
				anchor: '97%',
				gwidth: 100,
				maxLength:1179650
			},
			type:'NumberField',
			filters:{pfiltro:'pracde.monto',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'porcentaje',
				fieldLabel: 'Porcentaje',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
			type:'NumberField',
			filters:{pfiltro:'pracde.porcentaje',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config: {
				name: 'fecha',
				fieldLabel: 'Fecha Cbte.',
				allowBlank: true,
				anchor: '80%',
				maxValue: new Date(),
				gwidth: 100,
				format: 'd/m/Y',
				renderer: function(value, p, record) {
					return value ? value.dateFormat('d/m/Y') : ''
				}
			},
			type: 'DateField',
			filters: {pfiltro: 'com.fecha',type: 'date'},
			id_grupo: 2,
			grid: true,
			form: false
		},
		{
			config:{
				name: 'glosa1',
				fieldLabel: 'Glosa Cbte.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				renderer: function(value, metaData, record, rowIndex, colIndex, store) {
                    metaData.css = 'multilineColumn';
                    return String.format('{0}', value);
                }
			},
			type:'TextField',
			filters:{pfiltro:'com.glosa1',type:'string'},
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
			filters:{pfiltro:'pracde.estado_reg',type:'string'},
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
			filters:{pfiltro:'pracde.id_usuario_ai',type:'numeric'},
			id_grupo:1,
			grid:false,
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
			filters:{pfiltro:'pracde.fecha_reg',type:'date'},
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
			filters:{pfiltro:'pracde.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'pracde.fecha_mod',type:'date'},
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
				name: 'cuenta_total_cbte',
				fieldLabel: 'Total Cuenta por Cbte.',
				allowBlank: true,
				width: 150,
				gwidth: 100,
				maxLength:4,
				disabled: true
			},
			type:'Field',
			id_grupo:2,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'cuenta_utilizado_cbte',
				fieldLabel: 'Utilizado por Cbte.',
				allowBlank: true,
				width: 150,
				gwidth: 100,
				maxLength:4,
				disabled: true
			},
			type:'Field',
			id_grupo:2,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'cuenta_saldo_cbte',
				fieldLabel: 'Saldo por Cbte.',
				allowBlank: true,
				width: 150,
				gwidth: 100,
				maxLength:4,
				disabled: true
			},
			type:'Field',
			id_grupo:2,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'cuenta_total',
				fieldLabel: 'Total Cuenta',
				allowBlank: true,
				width: 150,
				gwidth: 100,
				maxLength:4,
				disabled: true
			},
			type:'Field',
			id_grupo:3,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'cuenta_utilizado',
				fieldLabel: 'Utilizado',
				allowBlank: true,
				width: 150,
				gwidth: 100,
				maxLength:4,
				disabled: true
			},
			type:'Field',
			id_grupo:3,
			grid:false,
			form:true
		},
		{
			config:{
				name: 'cuenta_saldo',
				fieldLabel: 'Saldo',
				allowBlank: true,
				width: 150,
				gwidth: 100,
				maxLength:4,
				disabled: true
			},
			type:'Field',
			id_grupo:3,
			grid:false,
			form:true
		}
	],
	tam_pag:50,
	title:'Detalle',
	ActSave:'../../sis_proyectos/control/ProyectoActivoDetalle/insertarProyectoActivoDetalle',
	ActDel:'../../sis_proyectos/control/ProyectoActivoDetalle/eliminarProyectoActivoDetalle',
	ActList:'../../sis_proyectos/control/ProyectoActivoDetalle/listarProyectoActivoDetalle',
	id_store:'id_proyecto_activo_detalle',
	fields: [
		{name:'id_proyecto_activo_detalle', type: 'numeric'},
		{name:'id_proyecto_activo', type: 'numeric'},
		{name:'id_comprobante', type: 'numeric'},
		{name:'porcentaje', type: 'numeric'},
		{name:'observaciones', type: 'string'},
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'monto', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'nro_cuenta', type: 'string'},
		{name:'desc_cuenta', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'nro_tramite', type: 'string'},
		{name:'glosa1', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'desc_partida', type: 'string'}
	],
	sortInfo:{
		field: 'id_proyecto_activo_detalle',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	Grupos: [{
		layout: 'column',
		border: false,
		defaults: {
			border: false
		},
		items: [{
			bodyStyle: 'padding-right:5px;',
			items: [{
				xtype: 'fieldset',
				title: 'Detalle',
				autoHeight: true,
				width: 500,
				columns: 1,
				items: [],
				id_grupo: 1
			}]
		}, {
			bodyStyle: 'padding-left:5px;',
			items: [{
				xtype: 'fieldset',
				title: 'Saldo Cuenta por Comprobante',
				autoHeight: true,
				columns: 2,
				items: [],
				id_grupo: 2
			}]
		}, {
			bodyStyle: 'padding-left:5px;',
			items: [{
				xtype: 'fieldset',
				title: 'Total Saldo Cuenta',
				autoHeight: true,
				columns: 2,
				items: [],
				id_grupo: 3
			}]
		}]
	}],
	fheight:'50%',
    fwidth: '80%',
    onSelectCuenta: function(combo,record,index){
    	//Inicializa los saldos
    	this.inicializarSaldos('total');
    	//Setea el store del combo de comprobante
    	//Ext.apply(this.Cmp.id_comprobante.getStore().baseParams,{nro_cuenta: record.data.nro_cuenta});
    	//Obtiene y carga el saldo total de la cuenta
    	Ext.Ajax.request({
            url: '../../sis_proyectos/control/ProyectoActivoDetalle/obtenerCuentaSaldo',
            params: {
                nro_cuenta: this.Cmp.nro_cuenta.getValue(),
                id_tipo_cc: this.maestro.id_tipo_cc,
                operacion: this.operacion
            },
            success: function(res,params){
                var response = Ext.decode(res.responseText).ROOT.datos;
                this.Cmp.cuenta_total.setValue(response.cuenta_total);
                this.Cmp.cuenta_utilizado.setValue(response.cuenta_utilizado);
                this.Cmp.cuenta_saldo.setValue(response.cuenta_saldo);
            },
            argument: this.argumentSave,
            failure: Phx.CP.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },
    onSelectComprobante: function(combo,record,index){
    	//Inicializa los saldos
    	this.inicializarSaldos();
    	//Obtiene y carga el saldo de la cuenta por comprobante
    	Ext.Ajax.request({
            url: '../../sis_proyectos/control/ProyectoActivoDetalle/obtenerCuentaSaldo',
            params: {
                nro_cuenta: this.Cmp.nro_cuenta.getValue(),
                id_tipo_cc: this.maestro.id_tipo_cc,
                id_comprobante: record.data.id_comprobante,
                operacion: this.operacion
            },
            success: function(res,params){
                var response = Ext.decode(res.responseText).ROOT.datos;
                this.Cmp.cuenta_total_cbte.setValue(response.cuenta_total);
                this.Cmp.cuenta_utilizado_cbte.setValue(response.cuenta_utilizado);
                this.Cmp.cuenta_saldo_cbte.setValue(response.cuenta_saldo);
            },
            argument: this.argumentSave,
            failure: Phx.CP.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },
    inicializarSaldos: function(tipo){
    	if(tipo=='total'){
	    	this.Cmp.cuenta_total.setValue(0);
	        this.Cmp.cuenta_utilizado.setValue(0);
	        this.Cmp.cuenta_saldo.setValue(0);

    	} else {
	        this.Cmp.cuenta_total_cbte.setValue(0);
	        this.Cmp.cuenta_utilizado_cbte.setValue(0);
	        this.Cmp.cuenta_saldo_cbte.setValue(0);
    	}
    },
    onButtonNew: function(){
    	this.operacion = 'nuevo';
		Phx.vista.ProyectoActivoDetalle.superclass.onButtonNew.call(this);
	},
	onButtonEdit: function(){
    	this.operacion = 'editar';
		Phx.vista.ProyectoActivoDetalle.superclass.onButtonEdit.call(this);
	}
})
</script>

