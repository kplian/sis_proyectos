<?php
/**
*@package pXP
*@file gen-ComponenteConceptoIngasDet.php
*@author  (admin)
*@date 22-07-2019 14:50:29
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ComponenteConceptoIngasDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.ComponenteConceptoIngasDet.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
        this.bloquearMenus();
        this.iniciarEventos();
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
                    url: '../../sis_parametros/control/ConceptoIngasDet/listarConceptoIngasDetCombo',
                    id: 'id_concepto_ingas_det',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_concepto_ingas_det', 'nombre','descripcion'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'coind.id_concepto_ingas_det#coind.nombre#coind.descripcion',start: 0, limit: 50,agrupador:'no'}
                }),
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
                anchor: '100%',
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
            id_grupo:1,
            grid:true,
            form:false
        },        {
            config:{
                name: 'tension',
                fieldLabel: 'Tension',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },        {
            config:{
                name: 'peso',
                fieldLabel: 'Peso',
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
		{
			config:{
				name: 'cantidad_est',
				fieldLabel: 'cantidad',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179648
			},
				type:'NumberField',
				filters:{pfiltro:'comindet.cantidad_est',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'precio',
				fieldLabel: 'precio Unitario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1179650
			},
				type:'NumberField',
				filters:{pfiltro:'comindet.precio',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
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
	tam_pag:50,	
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
        {name:'id_unidad_constructiva', type: 'numeric'},
        {name:'codigo_uc', type: 'string'},
        {name:'desc_agrupador', type: 'string'},
        {name:'aislacion', type: 'string'},
        {name:'tension', type: 'string'},
        {name:'peso', type: 'numeric'},
        {name:'id_proyecto', type: 'numeric'}
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
        this.store.baseParams = {id_componente_concepto_ingas: this.maestro.id_componente_concepto_ingas};
        this.Cmp.id_concepto_ingas_det.store.baseParams.id_concepto_ingas = this.maestro.id_concepto_ingas;
        this.load({params: {start: 0, limit: 50}})
    },
    onButtonNew:function(){
        //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
        //this.ocultarComponente(this.Cmp.fecha_ini);
        Phx.vista.ComponenteConceptoIngasDet.superclass.onButtonNew.call(this);
        this.mostrarComponente(this.Cmp.id_concepto_ingas_det);
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
    tabsouth: [
        {
            url:'../../../sis_proyectos/vista/unidad_comingdet/UnidadComingdet.php',
            title:'Unidad Constructiva',
            width:'100%',
            height:'40%',
            cls:'UnidadComingdet'
        }],


    }
)
</script>
		
		