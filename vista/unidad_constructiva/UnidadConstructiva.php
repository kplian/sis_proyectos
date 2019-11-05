<?php
/**
*@package pXP
*@file gen-UnidadConstructiva.php
*@author  (egutierrez)
*@date 06-05-2019 14:16:09
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	ISSUE		FORK		FECHA			AUTHOR				DESCRIPCION
 	 #16		ETR			01/08/2019		EGS					CREACION
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UnidadConstructiva=Ext.extend(Phx.arbGridInterfaz,{
    msgDel:'Realmente quiere Eliminar esta Unidad contructiva.Eliminara la subestacion o linea asociada, si no tienen conceptos de gasto',
	constructor:function(config){
		this.maestro=config;
        let data;
        this.Atributos[this.getIndAtributo('id_proyecto')].valorInicial = this.maestro.id_proyecto;
    	//llama al constructor de la clase padre
		Phx.vista.UnidadConstructiva.superclass.constructor.call(this,config);
		this.init();
        //this.getBoton('btnDelArb').hide();//ocultamos el botn por q no es necesario todavia
        //this.getBoton('btnAgrPla').hide();//ocultamos el botn por q no es necesario todavia
		//this.DesplegarArbol();
		
		this.addButton('btnDelArb',{
              text: 'Eliminacion de Arbol',
              iconCls: 'bdel',
              //disabled: true,
              handler: this.deleteArbol,
              tooltip: '<b>Elimina el nodo y sus nodos dependientes(hijos)'
          }); 
		
		this.addButton('btnAgrPla',{
              text: 'Agregar desde Plantilla',
              iconCls: 'bexport',
              //disabled: false,
              handler: this.agregarPlantilla,
              tooltip: '<b>Agregar desde Plantilla'
          });  
	},
	//despliega el arbol al abrir la ventana
	  DesplegarArbol:function(){
            	this.treePanel.expandAll();	
       },
       	onButtonAct : function() {
			this.sm.clearSelections();
			this.root.reload();
			this.treePanel.expandAll();	
		},
			
	Atributos:[
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
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_unidad_constructiva_fk'
			},
			type:'Field',
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
				filters:{pfiltro:'uncon.estado_reg',type:'string'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Codigo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 350,
				maxLength:350
			},
				type:'TextField',
				filters:{pfiltro:'uncon.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'desc_componente_macro_tipo',
                fieldLabel: 'SUB. Y LIN.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            id_grupo:1,
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
                maxLength:100
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config: {
                name: 'id_unidad_constructiva_tipo',
                fieldLabel: 'UC Tipo',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/UnidadConstructivaTipo/listarUnidadConstructivaTipoCombo',
                    id: 'id_unidad_constructiva_tipo',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_unidad_constructiva_tipo', 'desc_unidad_constructiva_tipo','tension','componente_macro_tipo','desc_componente_macro_tipo'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'uct.id_unidad_constructiva_tipo#uct.nombre',start:0, limit:50}
                }),
                tpl:'<tpl for=".">\<div class="x-combo-list-item"><p><b>Nombre:</b>{desc_unidad_constructiva_tipo}</p><p><b>Tipo:</b>{desc_componente_macro_tipo}</p>\<p><b>Tension: </b>{tension}</p>\</div></tpl>',
                valueField: 'id_unidad_constructiva_tipo',
                displayField: 'desc_unidad_constructiva_tipo',
                gdisplayField: 'desc_unidad_constructiva_tipo',
                hiddenName: 'id_unidad_constructiva_tipo',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '100%',
                gwidth: 300,
                minChars: 2,
                gtpl: function (p){//Es como el Renderer de grilla pero para arboles
                        return  this.desc_unidad_constructiva_tipo;
                },
                listeners: {
                    'expand':function (combo) {
                        this.store.reload();
                    }
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'uncon.id_unidad_constructiva_tipo',type: 'string'},
            grid: true,
            form: true
        },
		{
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'uncon.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:1000
			},
				type:'TextField',
				filters:{pfiltro:'uncon.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},

		{
                   config:{
                       name:'activo',
                       fieldLabel:'Activo ?',
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
            config: {
                name: 'tipo_configuracion',
                fieldLabel: 'Tipo Configuracion',
                anchor: '100%',
                tinit: false,
                allowBlank: true,
                origen: 'CATALOGO',
                gdisplayField: 'desc_tipo_configuracion',
                hiddenName: 'tipo',
                gwidth: 150,
                baseParams:{
                    cod_subsistema:'PRO',
                    catalogo_tipo:'ttipo_configuracion'
                },
                valueField: 'codigo',
                hidden: false
            },
            type: 'ComboRec',
            id_grupo: 0,
            grid: true,
            form: true
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
				filters:{pfiltro:'uncon.fecha_reg',type:'date'},
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
				filters:{pfiltro:'uncon.usuario_ai',type:'string'},
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
				filters:{pfiltro:'uncon.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'uncon.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Unidades Constructivas',
	ActSave:'../../sis_proyectos/control/UnidadConstructiva/insertarUnidadConstructiva',
	ActDel:'../../sis_proyectos/control/UnidadConstructiva/eliminarUnidadConstructiva',
	ActList:'../../sis_proyectos/control/UnidadConstructiva/listarUnidadConstructivaArb',
	id_store:'id_unidad_constructiva',
	textRoot:'Unidades',
    id_nodo:'id_unidad_constructiva',
    id_nodo_p:'id_unidad_constructiva_fk',
	fields: [
		{name:'id_unidad_constructiva', type: 'numeric'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_unidad_constructiva_fk', type: 'numeric'},
		{name:'activo', type: 'string'},
        {name:'id_unidad_constructiva_tipo', type: 'numeric'},
        {name:'desc_unidad_constructiva_tipo', type: 'string'},
        {name:'tipo_configuracion', type: 'string'},
        {name:'desc_tipo_configuracion', type: 'string'},
        {name:'tension', type: 'string'},
        {name:'desc_componente_macro_tipo', type: 'string'},
        {name:'desc_uct', type: 'string'},



    ],
	sortInfo:{
		field: 'id_unidad_constructiva',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	rootVisible: false,
	expanded: false,
	onBeforeLoad: function(treeLoader, node){
		treeLoader.baseParams[this.id_nodo] = node.attributes[this.id_nodo];
		treeLoader.baseParams.id_proyecto = this.maestro.id_proyecto;
	},
	preparaMenu: function(n) {
		
		var selectedNode = this.sm.getSelectedNode();
		
		var data = this.getSelectedData();
		var tb = this.tbar;
		Phx.vista.UnidadConstructiva.superclass.preparaMenu.call(this, n);
	    this.getBoton('btnAgrPla').enable();
  	    this.getBoton('btnDelArb').enable();

  		return tb
	},
	iniciarEventos: function(){

	},

    
     agregarPlantilla:function(){
    	var nodo = this.sm.getSelectedNode();
 		Phx.CP.loadWindows('../../../sis_proyectos/vista/unidad_constructiva/WizardAgregaPlantilla.php', 
			'Cfg Marca  ...', {
				width : 400,
				height : 150
			}, {
				'nodo':nodo.attributes,
			}, 
			this.idContenedor, 'WizardAgregaPlantilla')  		
    },

     deleteArbol:function(wizard,resp){
     	var selectedNode = this.sm.getSelectedNode();
		
		var opcion = confirm('Desea eliminar el nodo y los nodos dependientes');
			    if (opcion == true) {
				        //Phx.CP.loadingShow();
				        Ext.Ajax.request({
				            url:'../../sis_proyectos/control/UnidadConstructiva/deleteArbol',
				            params:{
				                id_unidad_constructiva: selectedNode.attributes.id_unidad_constructiva,
				                obs:                resp.obs,
				                json_procesos:      Ext.util.JSON.encode(resp.procesos)
				                },
				            success:this.successWizard,
				            failure: this.conexionFailure,
				            argument:{wizard:wizard},
				            timeout:this.timeout,
				            scope:this
				        });
				};

         
    },
     successWizard:function(resp){
        Phx.CP.loadingHide();
        this.onButtonAct();
    },
    onButtonNew: function(){
        var selectedNode = this.sm.getSelectedNode();
        Phx.vista.UnidadConstructiva.superclass.onButtonNew.call(this);
        //Obtenemos la unidad constructiva que esta relacionada a un componente macro en la rama el de segundo nivel
        this.obtenerUcMacro(selectedNode.id);
    },
    onButtonEdit: function(){
        var selectedNode = this.sm.getSelectedNode();
        //seteamos a una variable los datos del registro seleccionados para poder usar los filtros
        this.data = selectedNode.attributes;
        Phx.vista.UnidadConstructiva.superclass.onButtonEdit.call(this);
        //Obtenemos la unidad constructiva que esta relacionada a un componente macro en la rama el de segundo nivel
        this.obtenerUcMacro(selectedNode.attributes.id_unidad_constructiva_fk);



    },
    obtenerUcMacro: function(id){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_proyectos/control/UnidadConstructiva/ListarUnidadConstructivaMacro',
            params:{
                id_unidad_constructiva_hijo:id,
                start:0,
                limit:1,
            },
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                //recuperamos los datos del componente macro relacionados
                this.obtenerCompMacro(reg.datos[0]['id_unidad_constructiva']);
                //si la unidad constructiva seleccionada es la relacionada al component macro inactivamos algunos campos
                if (reg.datos[0]['id_unidad_constructiva'] == null ) {
                    this.Cmp.codigo.disable(true);
                    this.Cmp.activo.disable(true);
                    this.Cmp.id_unidad_constructiva_tipo.reset();
                    this.Cmp.id_unidad_constructiva_tipo.allowBlank=true;
                    this.Cmp.id_unidad_constructiva_tipo.disable(true);
                }else{
                    this.Cmp.codigo.enable(true);
                    this.Cmp.activo.enable(true);
                    this.Cmp.id_unidad_constructiva_tipo.allowBlank=true;
                    this.Cmp.id_unidad_constructiva_tipo.enable(true);
                }

            },
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope:this
        });
    },
    obtenerCompMacro: function(id){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_proyectos/control/ComponenteMacro/ListarComponenteMacro',
            params:{
                id_unidad_constructiva:id,
                start:0,
                limit:1,
            },
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                ///Añadimos los filtros por tipo y tension
                this.Cmp.id_unidad_constructiva_tipo.store.baseParams.componente_macro_tipo = reg.datos[0]['componente_macro_tipo'];
                this.Cmp.id_unidad_constructiva_tipo.store.baseParams.tension = reg.datos[0]['tension'];
                //si la peticion viene del edit recargamos el combo de tipo de unidad constructiva
                if (this.data != null){
                    this.Cmp.id_unidad_constructiva_tipo.store.baseParams.query = this.data.id_unidad_constructiva_tipo;
                    this.Cmp.id_unidad_constructiva_tipo.store.load({params:{start:0,limit:this.tam_pag},
                        callback : function (r) {
                            if (r.length > 0 ) {
                                this.Cmp.id_unidad_constructiva_tipo.setValue(this.data.id_unidad_constructiva_tipo);
                            }else{
                                this.Cmp.id_unidad_constructiva_tipo.reset();
                            }
                        }, scope : this
                    });

                }
                //volvemos a setear la query por que se traba al volver abrir el edit o new por segunda vez
                this.Cmp.id_unidad_constructiva_tipo.store.baseParams.query ='';
                //Recarga combo
                this.Cmp.id_unidad_constructiva_tipo.store.reload(true);
            },
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope:this
        });
    },


})
</script>
		
		