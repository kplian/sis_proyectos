<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	Issue 			Fecha 			Autor				Descripcion
 	#3				31/12/2018		EGS					Aumentar Importe Stea
 *  #10	EndeEtr		02/04/2019		EGS					Se agrego Totalizadores de fase_concepto y det invitacion
 *  #56             10/03/2020      EGS                 Se agrega los campos justificacion, id_lugar ,caracteristica_tecnica
 * #MDID-4          29/09/2020      EGS                 Se agrega si el proyecto es diferido

 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoBase=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ProyectoBase.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}});

	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto'
			},
			type:'Field',
			form:true
		},
        {
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'nombreVista'
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
				gwidth: 100,
				maxLength:20,
				/*renderer: function( value, metaData, record, rowIndex, colIndex, store ) {
	                var id = Ext.id();
	                (function(){
	                    var progress = new Ext.ProgressBar({
	                        renderTo: id,
	                        value: 0.85,
	                        text: 'aqui va el texto'
	                    });
	                }).defer(25);
	                return '<div id="'+ id + '"></div>';
            	}*/
			},
				type:'TextField',
				filters:{pfiltro:'proy.codigo',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'estado',
				fieldLabel: 'Estado',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
				type:'TextField',
				filters:{pfiltro:'proy.estado',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
				type:'TextField',
				filters:{pfiltro:'proy.nombre',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Fecha Ini',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'proy.fecha_ini',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fecha Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'proy.fecha_fin',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'fecha_ini_real',
				fieldLabel: 'Fecha Ini Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'proy.fecha_ini_real',type:'date'},
				id_grupo:1,
				grid:true,
				form:false//#
		},
		{
			config:{
				name: 'fecha_fin_real',
				fieldLabel: 'Fecha Fin Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'proy.fecha_fin_real',type:'date'},
				id_grupo:1,
				grid:true,
				form:false//#
		},

		{
			config: {
				name: 'id_tipo_cc',
				fieldLabel: 'Centro Costo/Proyecto',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_parametros/control/TipoCc/listartipoCcAll',
					id: 'id_tipo_cc',
					root: 'datos',
					sortInfo: {
						field: 'codigo',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_tipo_cc', 'codigo', 'descripcion'],
					remoteSort: true,
					baseParams: {par_filtro: 'tcc.codigo#tcc.descripcion'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo}</p>\
		                       <p><b>Descripcion: </b>{descripcion}</p>\
		                        </div></tpl>',

				valueField: 'id_tipo_cc',
				displayField: 'codigo',
				gdisplayField: 'codigo_tcc',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
                anchor: '80%',
                gwidth: 100,
				minChars: 2,
				renderer : function(value, p, record) {
					return String.format('{0}', record.data['codigo_tcc']);
				}
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'tcc.codigo#tcc.descripcion',type: 'string'},
			grid: true,
			form: true
		},

		{
			config: {
				name: 'id_fase_plantilla',
				fieldLabel: 'Plantilla Proyecto:',
				allowBlank: false,
				emptyText: 'Elija una opción...',
				store: new Ext.data.JsonStore({
					url: '../../sis_proyectos/control/FasePlantilla/listarFasePlantilla',
					id: 'id_fase_plantilla',
					root: 'datos',
					sortInfo: {
						field: 'id_fase_plantilla',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_fase_plantilla', 'codigo', 'nombre'],
					remoteSort: true,

					baseParams: {par_filtro: 'faspla.id_fase_plantilla#faspla.codigo#faspla.nombre',raiz:'raiz'}
				}),
				tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo}</p>\
		                       <p><b>Nombre: </b>{nombre}</p>\
		                        </div></tpl>',

				valueField: 'id_fase_plantilla',
				displayField: 'nombre',
				gdisplayField: 'codigo',
				forceSelection: true,
				typeAhead: false,
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 15,
				queryDelay: 1000,
				anchor: '80%',
                gwidth: 100,
				minChars: 2,

			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {pfiltro: 'faspla.id_fase_plantilla#faspla.codigo',type: 'string'},
			grid: true,
			form: true
		},
		{
            config:{
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                anchor: '80%',
                gwidth: 100,
                gdisplayField: 'desc_moneda',//mapea al store del grid
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'mon.codigo',type:'string'},
            grid: true,
            form: true
        },
        		//#3 31/12/2018		EGS	
		{
			config:{
				name: 'importe_max',
				fieldLabel: 'Stea',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				galign: 'right',
				maxLength:1179650,
				allowNegative:false,
			
				renderer:function (value,p,record){
						if(record.data.tipo_reg != 'summary'){
							return  String.format('{0}',  Ext.util.Format.number(value,'000.000.000,00/i'));
						}
						else{
							Ext.util.Format.usMoney
							return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));
						}	
				}
			},
				type:'MoneyField',
				filters:{pfiltro:'proy.importe_max',type:'numeric'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:true
		},
				//#3 31/12/2018		EGS
        {//#56
            config:{
                name: 'id_lugar',
                fieldLabel: 'Lugar',
                allowBlank: true,
                emptyText:'Lugar...',
                store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_parametros/control/Lugar/listarLugar',
                        id: 'id_lugar',
                        root: 'datos',
                        sortInfo:{
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_lugar','id_lugar_fk','codigo','nombre','tipo','sw_municipio','sw_impuesto','codigo_largo'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{tipos:"''departamento'',''pais'',''localidad'',''ciudad''",par_filtro:'nombre'}
                    }),
                valueField: 'id_lugar',
                displayField: 'nombre',
                gdisplayField:'lugar',
                hiddenName: 'id_lugar',
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:50,
                queryDelay:500,
                anchor: '80%',
                gwidth: 100,
                forceSelection:true,
                minChars:2,
                renderer:function (value, p, record){return String.format('{0}', record.data['lugar']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'lug.nombre',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {//#56
            config:{
                name: 'justificacion',
                fieldLabel: 'Justificacion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:500
            },
            type:'TextArea',
            filters:{pfiltro:'proy.justificacion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },

        {
            config:{//#56
                name: 'caracteristica_tecnica',
                fieldLabel: 'Caracteristicas Tecnicas',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1000
            },
            type:'TextArea',
            filters:{pfiltro:'proy.caracteristica_tecnica',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {//MDID-4
            config:{
                name:'diferido',
                fieldLabel:'es diferido?',
                allowBlank:false,
                emptyText:'...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                gwidth: 100,
                store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :    [['si','si'],
                        ['no','no']]

                }),
                valueField:'ID',
                displayField:'valor',
                //renderer:function (value, p, record){if (value == 1) {return 'si'} else {return 'no'}}
            },
            type:'ComboBox',
            valorInicial: 'no',
            id_grupo:0,
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
				filters:{pfiltro:'proy.estado_reg',type:'string'},
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
				filters:{pfiltro:'proy.usuario_ai',type:'string'},
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
				filters:{pfiltro:'proy.fecha_reg',type:'date'},
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'proy.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'proy.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,
	title:'Proyecto',
	ActSave:'../../sis_proyectos/control/Proyecto/insertarProyecto',
	ActDel:'../../sis_proyectos/control/Proyecto/eliminarProyecto',
	ActList:'../../sis_proyectos/control/Proyecto/listarProyecto',
	id_store:'id_proyecto',
	fields: [
		{name:'id_proyecto', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_tipo_cc', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'codigo_tcc', type: 'string'},
		{name:'desc_tcc', type: 'string'},
		{name:'id_moneda', type: 'numeric'},
		{name:'desc_moneda', type: 'string'},

		{name:'fecha_ini_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin_real', type: 'date',dateFormat:'Y-m-d'},

		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'importe_max', type: 'numeric'},
		'total_fase_concepto_ingas',//#10
		'total_invitacion',//#10
        {name:'justificacion', type: 'string'},//#56
        {name:'id_lugar', type: 'numeric'},'lugar',//#56
        {name:'caracteristica_tecnica', type: 'string'},//#56
        {name:'diferido', type: 'string'},//#MDID-4


	],
	sortInfo:{
		field: 'id_proyecto',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

	onButtonNew: function(){
		Phx.vista.ProyectoBase.superclass.onButtonNew.call(this);
		this.mostrarComponente(this.Cmp.id_fase_plantilla);
	},
	onButtonEdit: function(){
		Phx.vista.ProyectoBase.superclass.onButtonEdit.call(this);
		this.Cmp.id_fase_plantilla.allowBlank=true;
		this.ocultarComponente(this.Cmp.id_fase_plantilla);
	}

})
</script>

