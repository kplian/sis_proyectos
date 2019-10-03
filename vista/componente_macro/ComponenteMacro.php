<?php
/**
*@package pXP
*@file gen-ComponenteMacro.php
*@author  (admin)
*@date 22-07-2019 14:47:14
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE       FECHA        AUTHOR          DESCRIPCION
    #27        16/09/2019   EGS             Se agrego campo f_desadeanizacion,f_seguridad,f_escala_xfd_montaje,f_escala_xfd_obra_civil,porc_prueba
    #34EndeEtr 03/10/2019   EGS             Se agregaron totalizdores

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ComponenteMacro=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config;
        this.construirGrupos();//#27
    	//llama al constructor de la clase padre
		Phx.vista.ComponenteMacro.superclass.constructor.call(this,config);
		this.init();
		this.inciarEventos();
		this.load({params:{start:0, limit:this.tam_pag ,id_proyecto:this.maestro.id_proyecto}})
	},
    inciarEventos: function(){
    },
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_componente_macro'
			},
			type:'Field',
			form:true 
		},
        {//#22
            config: {
                name: 'componente_macro_tipo',
                fieldLabel: 'Tipo',
                anchor: '95%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'componente_macro_tipo',
                hiddenName: 'componente_macro_tipo',
                gwidth: 55,
                baseParams:{
                    cod_subsistema:'PRO',
                    catalogo_tipo:'tcomponente_macro_tipo'
                },
                valueField: 'codigo',
                hidden: false,
                renderer: function(value, p, record) {
                    return String.format('{0}', record.data['desc_componente_macro_tipo']);
                },
            },
            type: 'ComboRec',
            id_grupo: 0,
            grid: true,
            form: true
        },
        {//#22
            config: {
                name: 'tension',
                fieldLabel: 'Tension',
                anchor: '95%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'tension',
                hiddenName: 'tension',
                gwidth: 55,
                baseParams:{
                    cod_subsistema:'PRO',
                    catalogo_tipo:'tipo_tension'
                },
                valueField: 'codigo',
                hidden: false,
                renderer: function(value, p, record) {
                    return String.format('{0}', record.data['tension']);
                },
            },
            type: 'ComboRec',
            id_grupo: 0,
            grid: true,
            form: true
        },

        {//#22
            config:{
                name: 'codigo',
                fieldLabel: 'Codigo',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'compm.codigo',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },

		{
			config:{
				name: 'nombre',
				fieldLabel: 'nombre',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:200
			},
				type:'TextField',
				filters:{pfiltro:'compm.nombre',type:'string'},
				id_grupo:0,
				grid:true,
				form:true
		},
        { //#34
            config:{
                name: 'precio_total_cig',
                fieldLabel: 'Precio Total',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                galign: 'right ',
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false
        },

		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'compm.descripcion',type:'string'},
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
                maxLength:10
            },
            type:'NumberField',
            id_grupo:0,
            grid:true,
            form:true
        },
        {//#27
            config:{
                name: 'f_seguridad',
                fieldLabel: 'F. S. ',
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
                name: 'f_escala_xfd_montaje',
                fieldLabel: 'F. EscalaXFdistancia',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:true
        },
        {//#27
            config:{
                name: 'f_escala_xfd_obra_civil',
                fieldLabel: 'F. EscalaXFdistancia',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'NumberField',
            id_grupo:2,
            grid:true,
            form:true
        },
        {//#27
            config:{
                name: 'porc_prueba',
                fieldLabel: 'Porcentaje Pruebas',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'NumberField',
            id_grupo:3,
            grid:true,
            form:true
        },
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
            config:{
                name: 'estado_reg',
                fieldLabel: 'Estado Reg.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            filters:{pfiltro:'compm.estado_reg',type:'string'},
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
				filters:{pfiltro:'compm.fecha_reg',type:'date'},
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
				filters:{pfiltro:'compm.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'compm.usuario_ai',type:'string'},
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
				filters:{pfiltro:'compm.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_unidad_constructiva'
            },
            type:'Field',
            form:true
        },
	],
	tam_pag:50,	
	title:'Componente Macro',
	ActSave:'../../sis_proyectos/control/ComponenteMacro/insertarComponenteMacro',
	ActDel:'../../sis_proyectos/control/ComponenteMacro/eliminarComponenteMacro',
	ActList:'../../sis_proyectos/control/ComponenteMacro/listarComponenteMacro',
	id_store:'id_componente_macro',
	fields: [
		{name:'id_componente_macro', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'codigo', type: 'string'},//#22
        {name:'componente_macro_tipo', type: 'string'},//#22
        {name:'desc_componente_macro_tipo', type: 'string'},//#22
        {name:'id_unidad_constructiva', type: 'numeric'},//#26
        {name:'f_desadeanizacion', type: 'numeric'},//#27
        {name:'f_seguridad', type: 'numeric'},//#27
        {name:'f_escala_xfd_montaje', type: 'numeric'},//#27
        {name:'f_escala_xfd_obra_civil', type: 'numeric'},//#27
        {name:'porc_prueba', type: 'numeric'},//#27
        {name:'tension', type: 'string'},
        {name:'precio_total_cig', type: 'numeric'},//#34

	],
	sortInfo:{
		field: 'id_componente_macro',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    onButtonNew: function(){
        Phx.vista.ComponenteMacro.superclass.onButtonNew.call(this);
        this.Cmp.id_proyecto.setValue(this.maestro.id_proyecto);
    },
    tabeast: [
        {
            url:'../../../sis_proyectos/vista/componente_concepto_ingas/ComponenteConceptoIngas.php',
            title:'Lista de Conceptos Ingreso/Gasto',
            width:'80%',
            height:'90%',
            cls:'ComponenteConceptoIngas'
        }],
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
                            title: 'Datos',
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
                    }, {
                            bodyStyle: 'padding-left:5px;',
                            items: [{
                                xtype: 'fieldset',
                                title: 'Datos Prueba',
                                autoHeight: true,
                                items: [],
                                id_grupo:3
                            }]
                        }
                    ]
                }
            ];

        },

}
)
</script>
		
		