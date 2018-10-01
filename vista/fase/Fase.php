<?php
/**
*@package pXP
*@file gen-Fase.php
*@author  (admin)
*@date 25-10-2017 13:16:54
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Fase=Ext.extend(Phx.arbGridInterfaz,{

	constructor:function(config){
		this.maestro=config;
		Phx.vista.Fase.superclass.constructor.call(this,config);

		//Valores del padre/
		
		this.Atributos[1].valorInicial=this.maestro.id_proyecto;
        console.log(this.maestro.id_proyecto);
		/*Ext.apply(this.loaderTree.baseParams,{
			id_tipo_cc: this.maestro.id_tipo_cc
		});
*/
		this.init();

		//Botón para abrir los conceptos de gasto
		/*
		this.addButton('btnConceptoIngas', {
			text: 'Servicios/Bienes',
			iconCls: 'bexecdb',
			disabled: true,
			handler: this.openConceptoIngas,
			tooltip: '<b>Fases del Proyecto</b><br>Interfaz para el registro de las fases que componen al proyecto'
		});*/
	},
	

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase'
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
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase_fk'
			},
			type:'Field',
			form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_tipo_cc'
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
				gwidth: 200,
				maxLength:20
			},
			type:'TextField',
			filters:{pfiltro:'fase.codigo',type:'string'},
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
				gwidth: 150,
				maxLength:150
			},
			type:'TextField',
			filters:{pfiltro:'fase.nombre',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: true,
				anchor: '80%',
				gwidth: 250,
				maxLength:5000
			},
			type:'TextField',
			filters:{pfiltro:'fase.descripcion',type:'string'},
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
			filters:{pfiltro:'fase.estado',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_ini',
				fieldLabel: 'Inicio',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fase.fecha_ini',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'Fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fase.fecha_fin',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5000
			},
			type:'TextField',
			filters:{pfiltro:'fase.observaciones',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_ini_real',
				fieldLabel: 'Inicio Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type: 'DateField',
			filters: {pfiltro:'fase.fecha_ini',type:'date'},
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config:{
				name: 'fecha_fin_real',
				fieldLabel: 'Fin Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type: 'DateField',
			filters: {pfiltro:'fase.fecha_fin',type:'date'},
			id_grupo: 1,
			grid: true,
			form: false
		},
        {
			config:{
				id: 'pr-av-'+this.idContenedor,
				name: 'avance',
				fieldLabel: 'Avance',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:5000,
				renderer: function( value, metaData, record ) {
	                var id = 'pr-av-'+this.idContenedor;
	                console.log('ora ora si');
	                (function(){
	                    var progress = new Ext.ProgressBar({
	                        renderTo: id,
	                        value: 0.85,
	                        text: 'aqui va el texto'
	                    });
	                }).defer(25);
	                return '<div id="'+ id + '">SDSDSDSDD</div>';
	            }
			},
			type: 'TextField',
			id_grupo: 1,
			grid: true,
			form: false
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
			filters:{pfiltro:'fase.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'fase.usuario_ai',type:'string'},
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
			filters:{pfiltro:'fase.fecha_reg',type:'date'},
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
			filters:{pfiltro:'fase.id_usuario_ai',type:'numeric'},
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
			filters:{pfiltro:'fase.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	tam_pag:50,
	title:'Fase',
	ActSave:'../../sis_proyectos/control/Fase/insertarFase',
	ActDel:'../../sis_proyectos/control/Fase/eliminarFase',
	ActList:'../../sis_proyectos/control/Fase/listarFasesArb',
	id_store:'id_fase',
	textRoot:'Fases',
    id_nodo:'id_fase',
    id_nodo_p:'id_fase_fk',

	fields: [
		{name:'id', type: 'numeric'},
		{name:'id_fase', type: 'numeric'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'id_fase_fk', type: 'numeric'},
		{name:'codigo', type: 'string'},
		{name:'nombre', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'observaciones', type: 'string'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_ini_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_tipo_cc', type: 'integer'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'tipo_nodo', type: 'string'}
	],
	sortInfo:{
		field: 'id_fase',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	rootVisible: false,
	expanded: false,
	onButtonNew: function(){
		Phx.vista.Fase.superclass.onButtonNew.call(this);
		var selectedNode = this.sm.getSelectedNode();
		if(selectedNode&&selectedNode.attributes&&selectedNode.attributes.id_tipo_cc){
			this.Cmp.id_tipo_cc.setValue(selectedNode.attributes.id_tipo_cc);
		}
	},
	onButtonEdit: function(){
		Phx.vista.Fase.superclass.onButtonEdit.call(this);
		this.Cmp.id_tipo_cc.setValue(this.maestro.id_tipo_cc);
	},
	onBeforeLoad: function(treeLoader, node){
		console.log('qqq',this.id_nodo,node.attributes[this.id_nodo]);
		treeLoader.baseParams[this.id_nodo] = node.attributes[this.id_nodo];
		//treeLoader.baseParams.id_tipo_cc = this.maestro.id_tipo_cc;
		treeLoader.baseParams.id_proyecto = this.maestro.id_proyecto;
	},
	preparaMenu: function(n) {
		var tb = Phx.vista.Fase.superclass.preparaMenu.call(this);
		var selectedNode = this.sm.getSelectedNode();

		//Si es un nodo del tipo de centro de costo deshabilita botones
		if(selectedNode&&selectedNode.attributes&&selectedNode.attributes.id_ep){
			this.getBoton('edit').disable();
		    this.getBoton('del').disable();
		    //this.getBoton('btnConceptoIngas').disable();
		} else {
			//this.getBoton('btnConceptoIngas').enable();
		}

		return tb;
	},
	openConceptoIngas: function(){
		var data = this.getSelectedData();
		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/fase_concepto_ingas/FaseConceptoIngas.php',
			'Servicios/Bienes', {
			    width: '90%',
			    height: '80%'
			},
			data,
			this.idContenedor,
			'FaseConceptoIngas'
		);
	},
		 tabeast: [{
		 url:'../../../sis_proyectos/vista/fase_concepto_ingas/FaseConceptoIngas.php',
          title:'Bienes/Servicios', 
          width:'40%',
          height:'50%',
          cls:'FaseConceptoIngas'
	}], 
})
</script>


