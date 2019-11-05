<?php
/**
*@package pXP
*@file gen-ComponenteConceptoIngasDet.php
*@author  (admin)
*@date 22-07-2019 14:50:29
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE                FECHA               AUTHOR          DESCRIPCION
    #25 EndeEtr         10/09/2019          EGS             Adicion de cmp precio montaje, precio obci y precio pruebas
 *  #27 EndeEtr         16/09/2019          EGS             Se agrego campo f_desadeanizacion,f_seguridad,f_escala_xfd_montaje,f_escala_xfd_obra_civil,porc_prueba
    #28                 16/09/2019          EGS             Carga de recio de pruebas con el factor d pruebas
    #39 EndeEtr         17/10/2019          EGS              Se agrega WF
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ComponenteConceptoIngasDet=Ext.extend(Phx.gridInterfaz,{
    nombreVista:'ComponenteConceptoIngasDet',
	constructor:function(config){
		this.maestro=config.maestro;
        this.construirGrupos();//#27
    	//llama al constructor de la clase padre
		Phx.vista.ComponenteConceptoIngasDet.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
        this.bloquearMenus();
        this.iniciarEventos();
        this.addButton('sig_estado_multiple',{
            grupo:[0],
            text:'Siguiente Multiple',
            iconCls: 'badelante',
            disabled:true,
            handler:this.sigEstadoMultiple,
            tooltip: '<b>Pasar varios regitros al Siguiente Estado</b>'
        });

    },
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_componente_concepto_ingas_det'
			},
			type:'Field',
			form:true 
		},
        {
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_componente_concepto_ingas'
            },
            type:'Field',
            form:true
        },

    	{
            config: {
                name: 'id_concepto_ingas_det',
                fieldLabel: 'Concepto Ingreso/Gasto Detalle',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/ConceptoIngasDet/listarConceptoIngasDet',
                    id: 'id_concepto_ingas_det',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_concepto_ingas_det', 'nombre','descripcion','tension'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'coind.id_concepto_ingas_det#coind.nombre#coind.descripcion',start: 0, limit: 50,agrupador:'no'},
                    listeners: {
                        'afterrender': function(combo){
                        },
                        'expand':function (combo) {
                            this.store.reload();
                        }
                    }
                }),
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>Nombre :{nombre}</p><p>Tension :{tension}</p></div></tpl>',
                valueField: 'id_concepto_ingas_det',
                displayField: 'nombre',
                gdisplayField: 'nombre',
                hiddenName: 'id_concepto_ingas_det',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '80%',
                gwidth: 350,
                minChars: 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_ingas_det']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'coind.nombre',type: 'string'},
            grid: true,
            form: true
        },
        {//#39
            config:{
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config: {
                name: 'id_unidad_medida',
                fieldLabel: 'Unidad Medida',
                allowBlank: true,
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
                valueField: 'id_unidad_medida',
                hiddenValue: 'id_unidad_medida',
                displayField: 'descripcion',
                gdisplayField: 'codigo',
                mode: 'remote',
                triggerAction: 'all',
                lazyRender: true,
                pageSize: 15,
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo} - {descripcion}</p></div></tpl>',
                minChars: 2,
                gwidth: 120,
                renderer : function(value, p, record) {
                    console.log('value',value,'p',p,'record',record);
                    return String.format('{0}', record.data['desc_unidad']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'ume.codigo',type: 'string'},
            grid: true,
            form: false
        },
        {
            config:{
                name: 'aislacion',
                fieldLabel: 'Aislacion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'tension',
                fieldLabel: 'Tension',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:0,
            grid:true,
            form:false
        },

        {
            config:{
                name: 'tipo_configuracion',
                fieldLabel: 'Tipo Configuracion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'conductor',
                fieldLabel: 'Conductor',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'peso',
                fieldLabel: 'Peso',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'NumberField',
            id_grupo:0,
            grid:true,
            form:true
        },
        {//#27
            config:{
                name: 'f_desadeanizacion',
                fieldLabel: 'F. Desadeanizacion ',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:3,
                renderer:function (value,p,record){
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,000/i'));

                }
            },
            type:'NumberField',
            id_grupo:0,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'cantidad_est',
				fieldLabel: 'Cantidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179648
			},
				type:'NumberField',
				filters:{pfiltro:'comindet.cantidad_est',type:'numeric'},
				id_grupo:0,
				grid:true,
				form:true
		},
        {
            config: {
                name: 'precio',
                fieldLabel: 'Precio Unitario',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/ComponenteConceptoIngasDet/listarPrecioHistorico',
                    id: 'id',
                    root: 'datos',
                    sortInfo: {
                        field: 'id',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id', 'precio_unitario_mb'],
                    remoteSort: true,
                    // baseParams: {par_filtro: 'cotd.precio_unitario_mb#'}
                }),
                valueField: 'precio_unitario_mb',
                displayField: 'precio_unitario_mb',
                gdisplayField: 'precio_unitario_mb',
                hiddenName: 'precio_unitario_mb',
                forceSelection: false,
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
                    return String.format('{0}', record.data['precio']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            grid: true,
            form: true
        },

        {
            config:{
                name: 'precio_total_det',
                fieldLabel: 'Total Precio Sum.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                galign: 'right ',
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'MoneyField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {//#28
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'porc_prueba'
            },
            type:'Field',
            form:true
        },

        {//#27
            config:{
                name: 'f_seguridad',
                fieldLabel: 'F. S. ',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                renderer:function (value,p,record){
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'NumberField',
            id_grupo:0,
            grid:true,
            form:true
        },
        {//#25
            config:{
                name: 'precio_montaje',
                fieldLabel: 'Precio Montaje',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1179650,
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'MoneyField',
            filters:{pfiltro:'comindet.precio_montaje',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'precio_total_mon',
                fieldLabel: 'Total Precio Mon.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                galign: 'right ',
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'MoneyField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {//#27
            config:{
                name: 'f_escala_xfd_montaje',
                fieldLabel: 'F. EscalaXFdistancia M.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                renderer:function (value,p,record){
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:true
        },

        {//#25
            config:{
                name: 'precio_obra_civil',
                fieldLabel: 'Precio O.Civiles',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1179650,
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'MoneyField',
            filters:{pfiltro:'comindet.precio_obra_civil',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'precio_total_oc',
                fieldLabel: 'Total Precio Oc.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                galign: 'right ',
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'MoneyField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {//#27
            config:{
                name: 'f_escala_xfd_obra_civil',
                fieldLabel: 'F. EscalaXFdistancia O.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                renderer:function (value,p,record){
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'NumberField',
            id_grupo:2,
            grid:true,
            form:true
        },
        {//#25
            config:{
                name: 'precio_prueba',
                fieldLabel: 'Precio Pruebas',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1179650,
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'MoneyField',
            filters:{pfiltro:'comindet.precio_prueba',type:'numeric'},
            id_grupo:3,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'precio_total_pru',
                fieldLabel: 'Total Precio Pru.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                galign: 'right ',
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));

                }
            },
            type:'MoneyField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'desc_agrupador',
                fieldLabel: 'Agrupador',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
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
				filters:{pfiltro:'comindet.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'comindet.fecha_reg',type:'date'},
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
				filters:{pfiltro:'comindet.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'comindet.usuario_ai',type:'string'},
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
				filters:{pfiltro:'comindet.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:100,
	title:'Concepto ingas detalle del componente',
	ActSave:'../../sis_proyectos/control/ComponenteConceptoIngasDet/insertarComponenteConceptoIngasDet',
	ActDel:'../../sis_proyectos/control/ComponenteConceptoIngasDet/eliminarComponenteConceptoIngasDet',
	ActList:'../../sis_proyectos/control/ComponenteConceptoIngasDet/listarComponenteConceptoIngasDet',
	id_store:'id_componente_concepto_ingas_det',
	fields: [
		{name:'id_componente_concepto_ingas_det', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_concepto_ingas_det', type: 'numeric'},
		{name:'id_componente_concepto_ingas', type: 'numeric'},
		{name:'cantidad_est', type: 'numeric'},
		{name:'precio', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_ingas_det', type: 'string'},
        {name:'id_unidad_constructiva_macro', type: 'numeric'},
        {name:'codigo_uc', type: 'string'},
        {name:'desc_agrupador', type: 'string'},
        {name:'aislacion', type: 'string'},
        {name:'tension', type: 'string'},
        {name:'peso', type: 'numeric'},
        {name:'id_proyecto', type: 'numeric'},//#21
        {name:'precio_montaje', type: 'numeric'},//#25
        {name:'precio_obra_civil', type: 'numeric'},//#25
        {name:'precio_prueba', type: 'numeric'},//#25
        {name:'f_desadeanizacion', type: 'numeric'},//#27
        {name:'f_seguridad', type: 'numeric'},//#27
        {name:'f_escala_xfd_montaje', type: 'numeric'},//#27
        {name:'f_escala_xfd_obra_civil', type: 'numeric'},//#27
        {name:'porc_prueba', type: 'numeric'},//#28
        {name:'tipo_configuracion', type: 'string'},
        {name:'conductor', type: 'string'},
        {name:'id_unidad_medida', type: 'numeric'},
        {name:'desc_unidad', type: 'string'},
        {name:'precio_total_det', type: 'numeric'},
        {name:'precio_total_mon', type: 'numeric'},
        {name:'precio_total_oc', type: 'numeric'},
        {name:'precio_total_pru', type: 'numeric'},
        {name:'nro_tramite', type: 'string'},//#39
        {name:'id_proceso_wf', type: 'numeric'},//#39
        {name:'id_estado_wf', type: 'numeric'},//#39
        {name:'estado', type: 'string'},//#39
	],
	sortInfo:{
		field: 'id_componente_concepto_ingas_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    onReloadPage: function (m) {
        this.maestro = m;
        console.log('maestro',this.maestro);
        this.Atributos[this.getIndAtributo('id_componente_concepto_ingas')].valorInicial = this.maestro.id_componente_concepto_ingas;
        this.store.baseParams = {id_componente_concepto_ingas: this.maestro.id_componente_concepto_ingas ,nombreVista:this.nombreVista };
        this.Cmp.id_concepto_ingas_det.store.baseParams.id_concepto_ingas = this.maestro.id_concepto_ingas;

        this.load({params: {start: 0, limit: this.tam_pag}});
        this.Cmp.precio_montaje.on('valid',function(field){//#28
            console.log('precio',this.maestro.porc_prueba);
            var pTot = this.Cmp.precio_montaje.getValue() *this.Cmp.porc_prueba.getValue();
            this.Cmp.precio_prueba.setValue(pTot);
        } ,this);


    },
    onButtonNew:function(){
        //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
        //this.ocultarComponente(this.Cmp.fecha_ini);
        Phx.vista.ComponenteConceptoIngasDet.superclass.onButtonNew.call(this);
        this.Cmp.id_concepto_ingas_det.store.baseParams.tension_macro = this.maestro.tension_macro;//#39
        this.Cmp.id_concepto_ingas_det.store.reload(true);//#39

        this.mostrarComponente(this.Cmp.id_concepto_ingas_det);
        /*
        this.Cmp.precio.on('valid',function(field){//#28
            var pTot = this.Cmp.precio_montaje.getValue() * this.maestro.porc_prueba;
            this.Cmp.precio_prueba.setValue(pTot);
        } ,this);*/
    },
    onButtonEdit:function(){
        var data = this.getSelectedData();
        //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentesSS
        Phx.vista.ComponenteConceptoIngasDet.superclass.onButtonEdit.call(this);
        this.ocultarComponente(this.Cmp.id_concepto_ingas_det);
        this.Cmp.id_concepto_ingas_det.store.baseParams.query = this.Cmp.id_concepto_ingas_det.getValue();
        this.Cmp.id_concepto_ingas_det.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    console.log('r',r);
                    if (r.length > 0 ) {
                        this.Cmp.id_concepto_ingas_det.setValue(r[0].data.id_concepto_ingas_det);
                    }

                }, scope : this
         });


    },

    tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
    remoteGroup: true,
    groupField: 'desc_agrupador',
    viewGrid: new Ext.grid.GroupingView({
            forceFit: false,
            // custom grouping text template to display the number of items per group
            //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        }),
    fwidth: 500,
    fheight: 480,
    south:
        {
            url:'../../../sis_proyectos/vista/unidad_comingdet/UnidadComingdet.php',
            title:'Unidad Constructiva',
            width:'100%',
            height:'40%',
            collapsed:true,
            cls:'UnidadComingdet'
        },

    construirGrupos: function () {//#27
        var me = this;
        this.panelResumen = new Ext.Panel({
            padding: '0 0 0 20',
            html: '',
            split: true,
            layout: 'fit'
        });

        me.Grupos = [
            {
                layout: 'form',
                border: false,
                defaults: {
                    border: false
                },
                items: [{
                    bodyStyle: 'padding-right:5px;',
                    items: [{
                        xtype: 'fieldset',
                        title: 'Datos Suministro',
                        autoHeight: true,
                        items: [],
                        id_grupo: 0
                    }]
                }, {
                    bodyStyle: 'padding-left:5px;',
                    items: [{
                        xtype: 'fieldset',
                        title: 'Datos Montaje',
                        autoHeight: true,
                        items: [],
                        id_grupo: 1
                    }]
                }, {
                    bodyStyle: 'padding-left:5px;',
                    items: [{
                        xtype: 'fieldset',
                        title: 'Datos Fundacion',
                        autoHeight: true,
                        items: [],
                        id_grupo: 2
                    }]
                },
                    {
                        bodyStyle: 'padding-left:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Prueba',
                            autoHeight: true,
                            items: [],
                            id_grupo: 3
                        }]
                    }
                ]
            }
        ];

    },
    successSave:function(resp)
        {

            Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            this.window.hide();
            this.reload();
            //this.panel.close();
        },

    sigEstadoMultiple:function(){
        // var rec=this.sm.getSelected();

        let filas = this.sm.getSelections();
        let data = [], aux = {};
        //arma una matriz de los identificadores de registros
        let rr = {};
        for (let i = 0; i < this.sm.getCount(); i++) {
            aux = {};
            aux[this.id_store] = filas[i].data[this.id_store];
            aux.id_estado_wf = filas[i].data.id_estado_wf;
            aux.id_proceso_wf = filas[i].data.id_proceso_wf;
            aux.estado = filas[i].data.estado;
            data.push(aux);
        }
        var rec = {maestro: this.sm.getSelected().data, data_wf: Ext.util.JSON.encode(data)};
        console.log('ooo',rec.data_wf);
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_proyectos/control/ComponenteConceptoIngasDet/validacionMultiple',
            params:{
                data_json:rec.data_wf,
                data_maestro:rec.maestro
            },
            success:function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                if (reg.ROOT.error) {
                    Ext.Msg.alert('Error','Error a recuperar la variable global')
                } else {
                    this.formEstadoWfMultiple(rec,reg.ROOT.datos.id_tipo_estado,reg.ROOT.datos.id_estado_wf);
                }
            },
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });


    },
    formEstadoWfMultiple : function (rec,id_tipo_estado,id_estado_wf) {
        Phx.CP.loadingHide();
        var win = Phx.CP.loadWindows(
            '../../../sis_proyectos/vista/componente_concepto_ingas_det/FormEstadoWfMultiple.php',
            'Estado de Wf Multiple', {
                //modal:true,
                width:700,
                height:450
            },
            {data:{
                    data_json:rec.data_wf,
                    data_maestro:rec.maestro,
                    id_tipo_estado:id_tipo_estado,
                    id_estado_wf:id_estado_wf
                }},
            this.idContenedor,
            'FormEstadoWfMultiple'//clase de la vista
        );
    }


    }
)
</script>
		
		