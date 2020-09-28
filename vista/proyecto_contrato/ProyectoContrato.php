<?php
/**
*@package pXP
*@file gen-ProyectoContrato.php
*@author  (admin)
*@date 29-09-2017 17:05:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *  ISSUE       FECHA       AUTHOR          DESCRIPCION
 *  #MDID-2     28/09/2020  EGS             Se agrgan los capos de fecha_orden_proceder,plazo_dias,monto_anticipo,observaciones
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoContrato=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ProyectoContrato.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto_contrato'
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
				name: 'nro_contrato',
				fieldLabel: 'Nro.Contrato',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
				type:'TextField',
				filters:{pfiltro:'procon.nro_contrato',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre/Objeto',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'procon.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
            config:{
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                anchor: '100%',
                gdisplayField: 'moneda',//mapea al store del grid
                gwidth: 100,
                baseParams: { 'filtrar_base': 'si' },
                renderer: function (value, p, record){return String.format('{0}', record.data['moneda']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'mon.codigo#mon.moneda',type:'string'},
            grid: true,
            form: true
        },
		{
			config:{
				name: 'monto_total',
				fieldLabel: 'Monto Total',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'procon.monto_total',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Ini',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'procon.fecha_ini',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'cantidad_meses',
				fieldLabel: 'Cantidad Meses',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'procon.cantidad_meses',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y', 
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'procon.fecha_fin',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tipo_pagos',
				fieldLabel: 'Tipo Pago',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:15
			},
				type:'TextField',
				filters:{pfiltro:'procon.tipo_pagos',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'resumen',
				fieldLabel: 'Resumen',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1000
			},
				type:'TextArea',
				filters:{pfiltro:'procon.resumen',type:'string'},
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
				filters:{pfiltro:'procon.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
            config:{
                name:'id_proveedor',
                hiddenName: 'id_proveedor',
                origen:'PROVEEDOR',
                fieldLabel:'Proveedor',
                allowBlank:false,
                tinit:false,
                gwidth:200,
                valueField: 'id_proveedor',
                gdisplayField: 'desc_proveedor',
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_proveedor']);}
             },
            type:'ComboRec',//ComboRec
            id_grupo:0,
            filters:{pfiltro:'prov.desc_proveedor',type:'string'},
            bottom_filter:true,
            grid:true,
            form:true
        },
        {//#MDID-2
            config:{
                name: 'fecha_orden_proceder',
                fieldLabel: 'Fecha Orden Proceder.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'procon.fecha_orden_proceder',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {//#MDID-2
            config:{
                name: 'plazo_dias',
                fieldLabel: 'Plazos Dias',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'NumberField',
            filters:{pfiltro:'procon.plazo_dias',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {//#MDID-2
            config:{
                name: 'monto_anticipo',
                fieldLabel: 'Monto Anticipo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            filters:{pfiltro:'procon.monto_anticipo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {//#MDID-2
            config:{
                name: 'observaciones',
                fieldLabel: 'Observaciones',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextArea',
            filters:{pfiltro:'procon.observaciones',type:'string'},
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
				filters:{pfiltro:'procon.estado_reg',type:'string'},
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
				filters:{pfiltro:'procon.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'procon.fecha_reg',type:'date'},
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
				filters:{pfiltro:'procon.usuario_ai',type:'string'},
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
				filters:{pfiltro:'procon.fecha_mod',type:'date'},
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
	title:'Contratos',
	ActSave:'../../sis_proyectos/control/ProyectoContrato/insertarProyectoContrato',
	ActDel:'../../sis_proyectos/control/ProyectoContrato/eliminarProyectoContrato',
	ActList:'../../sis_proyectos/control/ProyectoContrato/listarProyectoContrato',
	id_store:'id_proyecto_contrato',
	fields: [
		{name:'id_proyecto_contrato', type: 'numeric'},
		{name:'nro_contrato', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'monto_total', type: 'numeric'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'cantidad_meses', type: 'numeric'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'tipo_pagos', type: 'string'},
		{name:'resumen', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_proveedor', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_proveedor', type: 'string'},
		{name:'moneda', type: 'string'},
        {name:'fecha_orden_proceder', type: 'date',dateFormat:'Y-m-d'},
        {name:'monto_anticipo', type: 'numeric'},
        {name:'plazo_dias', type: 'numeric'},
        {name:'observaciones', type: 'string'},
	],
	sortInfo:{
		field: 'id_proyecto_contrato',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	onReloadPage: function(m) {
		this.maestro = m;
		this.Atributos[1].valorInicial = this.maestro.id_proyecto;

		//Define the filter to apply for activos fijod drop down
		this.store.baseParams = {
			id_proyecto: this.maestro.id_proyecto
		};
		this.load({
			params: {
				start: 0,
				limit: 50
			}
		});
	},
	east: {
		url: '../../../sis_proyectos/vista/contrato_pago/ContratoPago.php',
		title: 'Pagos',
		width: '40%',
		cls: 'ContratoPago'
	}
})
</script>
		
		