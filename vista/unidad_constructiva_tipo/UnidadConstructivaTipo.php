<?php
/**
*@package pXP
*@file gen-UnidadConstructivaTipo.php
*@author  (egutierrez)
*@date 18-09-2019 19:13:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				18-09-2019				 (egutierrez)	    CREACION
 #32            30/09/2019              EGS                 Se agrego combo tension en tipo unidad constructiva
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UnidadConstructivaTipo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.UnidadConstructivaTipo.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_unidad_constructiva_tipo'
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
                gwidth: 100,
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
        {//#32
            config: {
                name: 'tension',
                fieldLabel: 'Tension',
                anchor: '95%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'tension',
                hiddenName: 'tension',
                gwidth: 100,
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
		{
			config:{
				name: 'nombre',
				fieldLabel: 'nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'uct.nombre',type:'string'},
                bottom_filter:true,
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 500,
				maxLength:500
			},
				type:'TextField',
				filters:{pfiltro:'uct.descripcion',type:'string'},
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
            filters:{pfiltro:'uct.estado_reg',type:'string'},
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
				filters:{pfiltro:'uct.fecha_reg',type:'date'},
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
				filters:{pfiltro:'uct.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'uct.usuario_ai',type:'string'},
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
				filters:{pfiltro:'uct.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Unidad Constructiva tipo',
	ActSave:'../../sis_proyectos/control/UnidadConstructivaTipo/insertarUnidadConstructivaTipo',
	ActDel:'../../sis_proyectos/control/UnidadConstructivaTipo/eliminarUnidadConstructivaTipo',
	ActList:'../../sis_proyectos/control/UnidadConstructivaTipo/listarUnidadConstructivaTipo',
	id_store:'id_unidad_constructiva_tipo',
	fields: [
		{name:'id_unidad_constructiva_tipo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'componente_macro_tipo', type: 'string'},
		{name:'tension', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'desc_componente_macro_tipo', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_unidad_constructiva_tipo',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		