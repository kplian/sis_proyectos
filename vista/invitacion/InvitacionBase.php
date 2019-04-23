<?php
/**
*@package pXP
*@file gen-Invitacion.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:20
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InvitacionBase=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config; ///config.maestro quitar para poder recibir datos

		//llama al constructor de la clase padre
		Phx.vista.InvitacionBase.superclass.constructor.call(this,config);

	},

	Atributos:[
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
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto'
			},
			type:'Field',
			form:true
		}
		,
		{
				config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name : 'pre_solicitud',
				fieldLabel : 'Presolicitud',
				allowBlank: false,
				items: [
					{boxLabel: 'No', name: 'pre_solicitud', inputValue: 'no', checked: true},
					{boxLabel: 'Si', name: 'pre_solicitud', inputValue: 'si'}
				
				],
			},
			type : 'RadioGroupField',
			id_grupo : 1,
			form : true,
			grid:true
		 },
		    {
            config:{
                name:'id_grupo',
                fieldLabel:'Grupo de Compras',
                emptyText:'Grupo...',
                store: new Ext.data.JsonStore({

                    url: '../../sis_adquisiciones/control/Grupo/listarGrupo',
                    id: 'id_grupo',
                    root: 'datos',
                    sortInfo:{
                        field: 'id_grupo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_grupo','nombre','obs'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nombre#obs'}
                }),
                valueField: 'id_grupo',
                displayField: 'nombre',
                gdisplayField:'desc_grupo',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p><p>CI:{obs}</p> </div></tpl>',
                hiddenName: 'id_grupo',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                width:250,
                gwidth:280,
                minChars:2,
                renderer:function (value, p, record){
                	
                	return String.format('{0}', record.data['desc_grupo']);
               }
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'gru.nombre#gru.obs',
                        type:'string'
                    },
           
            grid:false,
            form:true
        },

		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
				type:'TextField',
				bottom_filter:true,
				filters:{pfiltro:'ivt.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
				config:{
					name: 'tipo',
					fieldLabel: 'Tipo',
					allowBlank: false,
					emptyText: 'Tipo...',
					store: new Ext.data.ArrayStore({
						fields :['variable','valor'],
						data :  []}),

					valueField: 'variable',
					displayField: 'valor',
					forceSelection: true,
					triggerAction: 'all',
					lazyRender: true,
					resizable:true,
					mode: 'local',
					width: '80%'
				},
				type:'ComboBox',
				id_grupo:1,
				form:true,
				grid: true,
		},
		{
			config: {
				name: 'id_categoria_compra',
				hiddenName: 'id_categoria_compra',
				fieldLabel: 'Categoria de Compra',
				typeAhead: false,
				forceSelection: false,
				allowBlank: false,
				emptyText: 'Categorias...',
				store: new Ext.data.JsonStore({
					url: '../../sis_adquisiciones/control/CategoriaCompra/listarCategoriaCompra',
					id: 'id_categoria_compra',
					root: 'datos',
					sortInfo: {
						field: 'catcomp.nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_categoria_compra', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'catcomp.id_categoria_compra#catcomp.nombre#catcomp.codigo',codigo_subsistema:'ADQ'}
				}),
				valueField: 'id_categoria_compra',
				displayField: 'nombre',
				gdisplayField: 'desc_categoria_compra',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				renderer: function(value, p, record) {
					return String.format('{0}', record.data['desc_categoria_compra']);
				},
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p>Codigo: <strong>{codigo}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,

			grid: false,
			form: true
		},
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro. Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:150
			},
				type:'TextField',
				bottom_filter:true,
				filters:{pfiltro:'ivt.nro_tramite',type:'string'},
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
				filters:{pfiltro:'ivt.estado',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ivt.fecha',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'fecha_real',
				fieldLabel: 'Fecha Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y',
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ivt.fecha_real',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},

			{
	   			config:{
	       		    name:'id_funcionario',
	       		     hiddenName: 'id_funcionario',
	   				origen:'FUNCIONARIOCAR',
	   				fieldLabel:'Funcionario',
	   				allowBlank:false,
	                gwidth:200,
	   				valueField: 'id_funcionario',
	   			    gdisplayField: 'desc_funcionario',
	   			    baseParams: {par_filtro: 'id_funcionario#desc_funcionario1'},

	   			    //baseParams: { es_combo_solicitud : 'si' },
	      			renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
	       	     },
	   			type:'ComboRec',//ComboRec
	   			id_grupo:0,
	   			filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
	   			bottom_filter:true,
	   		    grid:false,
	   			form:true
			 },

			{
	   			config:{
	   				name:'id_depto',
	   				 hiddenName: 'id_depto',
	   				 url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
		   				origen:'DEPTO',
		   				allowBlank:false,
		   				fieldLabel: 'Depto',
		   				gdisplayField:'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
		   				width:250,
	   			        gwidth:180,
		   				baseParams:{par_filtro: 'id_depto',estado:'activo',codigo_subsistema:'ADQ'},//parametros adicionales que se le pasan al store
		      			renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
	   			},
	   			//type:'TrigguerCombo',
	   			type:'ComboRec',
	   			id_grupo:0,
	   			filters:{pfiltro:'depto.nombre',type:'string'},
	   		    grid:false,
	   			form:true
	       	},
        {
            config:{
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                anchor: '100%',
                gdisplayField: 'desc_moneda',//mapea al store del grid
                gwidth: 50,
                baseParams: { par_filtro: 'id_moneda' },
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'mon.codigo',type:'string'},
            grid: true,
            form: true
        },


			{
				config:{
					name: 'lugar_entrega',
					fieldLabel: 'Lugar de Entrega',
					//qtip:'Proporcionar una buena descripcion para informar al proveedor, Ej. Entrega en oficinas de aeropuerto Cochabamba, Jaime Rivera #28',
					allowBlank:true,
					width: '100%',
					maxLength:255
				},
				type:'TextArea',
				id_grupo: 1,
				form:true,
				grid:true
			},

			{
				config:{
					name: 'dias_plazo_entrega',
					fieldLabel: 'Dias de Entrega (Calendario)',
					//qtip: '¿Después de cuantos días calendario de emitida  la orden de compra se hara la entrega de los bienes?. EJM. Quedara de esta forma en la orden de Compra:  (Tiempo de entrega: X días calendario  a partir del dia siguiente de emitida la presente orden)',
					allowBlank: true,
					allowDecimals: false,
					width: 100,
					minValue:1,
					maxLength:10
				},
				type:'NumberField',
				filters:{pfiltro:'sold.dias_plazo_entrega',type:'numeric'},
				id_grupo: 1,
				form:true,
				grid:true
			},

		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: true,
				anchor: '100%',
				width: '100%',
			    maxLength:300
			},
				type:'TextArea',
				bottom_filter:true,
				filters:{pfiltro:'ivt.descripcion',type:'string'},
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
				filters:{pfiltro:'ivt.estado_reg',type:'string'},
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
				filters:{pfiltro:'ivt.fecha_reg',type:'date'},
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estado_wf'
			},
			type:'Field',
			form:true
		},
		{
			//configuracion del componente
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
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'ivt.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'ivt.usuario_ai',type:'string'},
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
				filters:{pfiltro:'ivt.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,
	title:'invitacion',
	ActSave:'../../sis_proyectos/control/Invitacion/insertarInvitacion',
	ActDel:'../../sis_proyectos/control/Invitacion/eliminarInvitacion',
	ActList:'../../sis_proyectos/control/Invitacion/listarInvitacion',
	id_store:'id_invitacion',
	fields: [
		{name:'id_invitacion', type: 'numeric'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'descripcion', type: 'string'},
		{name:'fecha_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'nro_tramite', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},

		{name:'id_funcionario', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'lugar_entrega', type: 'string'},
		{name:'dias_plazo_entrega', type: 'numeric'},

		{name:'desc_moneda', type: 'string'},
		{name:'desc_funcionario', type: 'string'},
		{name:'desc_depto', type: 'string'},

		{name:'id_gestion', type: 'numeric'},
		'id_proceso_wf',
		{name:'id_categoria_compra', type: 'numeric'},'desc_categoria_compra',
		{name:'id_solicitud', type: 'numeric'},
		{name:'pre_solicitud', type: 'string'},
		{name:'id_grupo', type: 'numeric'},'desc_grupo','nombre'


	],
	sortInfo:{
		field: 'id_invitacion',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,

}
)
</script>

