<?php
/**
*@package pXP
*@file gen-UnidadConstructivaPlantilla.php
*@author  (egutierrez)
*@date 06-05-2019 14:16:09
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	ISSUE		FORK		FECHA			AUTHOR				DESCRIPCION
 	 #16		ETR			01/08/2019		EGS					CREACION
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.UnidadConstructivaPlantilla=Ext.extend(Phx.arbInterfaz,{

	constructor:function(config){
		this.maestro=config;
    	//llama al constructor de la clase padre
		Phx.vista.UnidadConstructivaPlantilla.superclass.constructor.call(this,config);
		this.init();
		this.DesplegarArbol();  
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
					name: 'id_unidad_constructiva_plantilla'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_unidad_constructiva_plantilla_fk'
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
				gwidth: 150,
				maxLength:250
			},
				type:'TextField',
				filters:{pfiltro:'uncon.codigo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
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
	title:'Unidades Constructivas Plantilla',
	ActSave:'../../sis_proyectos/control/UnidadConstructivaPlantilla/insertarUnidadConstructivaPlantilla',
	ActDel:'../../sis_proyectos/control/UnidadConstructivaPlantilla/eliminarUnidadConstructivaPlantilla',
	ActList:'../../sis_proyectos/control/UnidadConstructivaPlantilla/listarUnidadConstructivaPlantillaArb',
	id_store:'id_unidad_constructiva_plantilla',
	textRoot:'Plantillas',
    id_nodo:'id_unidad_constructiva_plantilla',
    id_nodo_p:'id_unidad_constructiva_plantilla_fk',
    idNodoDD : 'id_unidad_constructiva_plantilla',
	idOldParentDD : 'id_unidad_constructiva_plantilla_fk',
	idTargetDD : 'id_unidad_constructiva_plantilla',
	enableDD : true,
	fields: [
		{name:'id_unidad_constructiva_plantilla', type: 'numeric'},
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
		{name:'id_unidad_constructiva_plantilla_fk', type: 'numeric'},
		{name:'activo', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_unidad_constructiva_plantilla',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	//expanded: false,
	rootVisible: true,
	fwidth: 420,
	fheight: 300,
	
	onNodeDrop: function(o) {
	    this.ddParams = {
	        tipo_nodo : o.dropNode.attributes.tipo_nodo
	    };
	    this.idTargetDD = 'id_unidad_constructiva_plantilla';
	    if (o.dropNode.attributes.tipo_nodo == 'raiz' || o.dropNode.attributes.tipo_nodo == 'hijo') {
	        this.idNodoDD = 'id_unidad_constructiva_plantilla';
	        this.idOldParentDD = 'id_unidad_constructiva_plantilla_fk';
	    } else if(o.dropNode.attributes.tipo_nodo == 'item') {
	        this.idNodoDD = 'id_item';
            this.idOldParentDD = 'id_p';
	    }
	    Phx.vista.UnidadConstructivaPlantilla.superclass.onNodeDrop.call(this, o);
	},

	
	onBeforeLoad: function(treeLoader, node){
		console.log('qqq',this.id_nodo,node.attributes[this.id_nodo]);
		treeLoader.baseParams[this.id_nodo] = node.attributes[this.id_nodo];
		//treeLoader.baseParams.id_tipo_cc = this.maestro.id_tipo_cc;
		//treeLoader.baseParams.id_proyecto = this.maestro.id_proyecto;
	},
	iniciarEventos: function(){

	},
	onButtonNew: function(){
    	Phx.vista.UnidadConstructivaPlantilla.superclass.onButtonNew.call(this);
    },

	
	onButtonEdit: function(){
		var selectedNode = this.sm.getSelectedNode();

    	console.log('selectedNode',selectedNode.attributes);
    	Phx.vista.UnidadConstructivaPlantilla.superclass.onButtonEdit.call(this);

    },


})
</script>
		
		