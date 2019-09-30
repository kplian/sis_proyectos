<?php
/**
*@package pXP
*@file gen-UnidadComingdet.php
*@author  (egutierrez)
*@date 08-08-2019 15:05:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UnidadComingdet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.UnidadComingdet.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
        this.bloquearMenus();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_unidad_comingdet'
			},
			type:'Field',
			form:true 
		},
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
            config: {
                name: 'id_unidad_constructiva',
                fieldLabel: 'Unidad Constructiva',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/UnidadConstructiva/listarUnidadConstructivaMacroHijos',
                    id: 'id_unidad_constructiva',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_unidad_constructiva', 'nombre', 'codigo'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'id_unidad_constructiva#nombre#codigo',start: 0, limit: 50}
                }),
                valueField: 'id_unidad_constructiva',
                displayField: 'codigo',
                gdisplayField: 'codigo',
                hiddenName: 'id_unidad_constructiva',
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
                    return String.format('{0}', record.data['desc_uc']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'codigo',type: 'string'},
            grid: true,
            form: true
        },
		{
			config:{
				name: 'cantidad_asignada',
				fieldLabel: 'Cantidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'uncom.cantidad_asignada',type:'numeric'},
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
				filters:{pfiltro:'uncom.estado_reg',type:'string'},
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
				filters:{pfiltro:'uncom.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'uncom.fecha_reg',type:'date'},
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
				filters:{pfiltro:'uncom.usuario_ai',type:'string'},
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
				filters:{pfiltro:'uncom.fecha_mod',type:'date'},
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
	title:'Unidad constructiva',
	ActSave:'../../sis_proyectos/control/UnidadComingdet/insertarUnidadComingdet',
	ActDel:'../../sis_proyectos/control/UnidadComingdet/eliminarUnidadComingdet',
	ActList:'../../sis_proyectos/control/UnidadComingdet/listarUnidadComingdet',
	id_store:'id_unidad_comingdet',
	fields: [
		{name:'id_unidad_comingdet', type: 'numeric'},
		{name:'id_unidad_constructiva', type: 'numeric'},
		{name:'cantidad_asignada', type: 'numeric'},
		{name:'id_componente_concepto_ingas_det', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'desc_uc', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_unidad_comingdet',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    onReloadPage: function (m) {
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_componente_concepto_ingas_det')].valorInicial = this.maestro.id_componente_concepto_ingas_det;
        this.store.baseParams = {id_componente_concepto_ingas_det: this.maestro.id_componente_concepto_ingas_det};
        this.Cmp.id_unidad_constructiva.store.baseParams.id_proyecto=this.maestro.id_proyecto;
        this.Cmp.id_unidad_constructiva.store.baseParams.id_unidad_constructiva_macro =this.maestro.id_unidad_constructiva_macro;
        this.load({params: {start: 0, limit: 50}})
    },
	}
)
</script>
		
		