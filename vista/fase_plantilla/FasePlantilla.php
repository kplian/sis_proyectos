<?php
/**
*@package pXP
*@file gen-FasePlantilla.php
*@author  (rchumacero)
*@date 15-08-2018 13:05:07
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FasePlantilla = Ext.extend(Phx.arbInterfaz, {

	constructor: function(config) {
		this.maestro = config.maestro;
		Phx.vista.FasePlantilla.superclass.constructor.call(this, config);
		this.init();
		this.definirEventos();
	},
	Atributos: [{
		config: {
			labelSeparator: '',
			inputType: 'hidden',
			name: 'id_fase_plantilla'
		},
		type: 'Field',
		form: true
	}, {
		config: {
			labelSeparator: '',
			inputType: 'hidden',
			name: 'id_fase_plantilla_fk'
		},
		type: 'Field',
		form: true
	}, {
		config: {
			name: 'codigo',
			fieldLabel: 'Código',
			allowBlank: false,
			anchor: '100%',
			maxLength: 20
		},
		type: 'Field',
		filters: {
			pfiltro: 'faspla.codigo',
			type: 'string'
		},
		id_grupo: 1,
		grid: true,
		form: true
	}, {
		config: {
			name: 'nombre',
			fieldLabel: 'Nombre',
			allowBlank: false,
			anchor: '100%',
			gwidth: 150,
			maxLength: 100
		},
		type: 'TextField',
		filters: {
			pfiltro: 'faspla.nombre',
			type: 'string'
		},
		id_grupo: 1,
		grid: true,
		form: true
	}, {
		config : {
			name : 'descripcion',
			fieldLabel : 'Descripción',
			allowBlank : true,
			anchor : '100%',
			gwidth : 5000,
			maxLength : 100
		},
		type : 'TextArea',
		filters : {
			pfiltro : 'faspla.descripcion',
			type : 'string'
		},
		id_grupo : 1,
		grid : true,
		form : true
	}, {
		config : {
			name : 'observaciones',
			fieldLabel : 'Observaciones',
			allowBlank : true,
			anchor : '100%',
			gwidth : 5000,
			maxLength : 100
		},
		type : 'TextArea',
		filters : {
			pfiltro : 'faspla.observaciones',
			type : 'string'
		},
		id_grupo : 1,
		grid : true,
		form : true
	}, {
		config: {
            fieldLabel: 'Plantilla Centro de Costo',
            name: 'id_tipo_cc_plantilla',
            hiddenName: 'id_tipo_cc_plantilla',
            allowBlank: true,
            emptyText: 'Elija una opción',
            store: new Ext.data.JsonStore({
                url: '../../sis_parametros/control/TipoCcPlantilla/listarTipoCcPlantilla',
                id: 'id_tipo_cc_plantilla',
                root: 'datos',
                fields: ['id_tipo_cc_plantilla','codigo','descripcion'],
                totalProperty: 'total',
                sortInfo: {
                    field: 'descripcion',
                    direction: 'ASC'
                },
                baseParams:{
                    start: 0,
                    limit: 10,
                    sort: 'descripcion',
                    dir: 'ASC',
                    par_filtro:'tcc.descripcion',
                    solo_raices:'si'
                }
            }),
            valueField: 'id_tipo_cc_plantilla',
            displayField: 'codigo',
            gdisplayField: 'codigo',
            mode: 'remote',
            triggerAction: 'all',
            lazyRender: true
		},
		type: 'ComboBox',
		id_grupo: 0,
		filters:{pfiltro:'tcc.descripcion',type:'string'},
		grid: true,
		form: true
	}],
	title : 'Plantilla',
	ActSave : '../../sis_proyectos/control/FasePlantilla/insertarFasePlantilla',
	ActDel : '../../sis_proyectos/control/FasePlantilla/eliminarFasePlantilla',
	ActList : '../../sis_proyectos/control/FasePlantilla/listarFasePlantillaArb',
	ActDragDrop:'../../sis_proyectos/control/FasePlantilla/guardarDragDrop',
	id_store : 'id_fase_plantilla',
	textRoot : 'Plantillas de Proyectos',
	id_nodo : 'id_fase_plantilla',
	id_nodo_p : 'id_fase_plantilla_fk',
	idNodoDD : 'id_fase_plantilla',
	idOldParentDD : 'id_fase_plantilla_fk',
	idTargetDD : 'id_fase_plantilla',
	enableDD : true,

	fields : [
	{name: 'id_fase_plantilla',type: 'numeric'},
	{name: 'id_fase_plantilla_fk',type: 'numeric'},
	{name: 'codigo',type: 'string'},
	{name: 'nombre',type: 'string'},
	{name: 'descripcion',type: 'string'},
	{name: 'observaciones',type: 'string'},
	{name: 'estado_reg',type: 'string'},
	{name: 'usuario_ai',type: 'string'},
	{name: 'fecha_reg',type: 'date', dateFormat:'Y-m-d H:i:s.u'},
	{name: 'id_usuario_reg',type: 'numeric'},
	{name: 'id_usuario_ai',type: 'numeric'},
	{name: 'id_usuario_mod',type: 'numeric'},
	{name: 'fecha_mod',type: 'date', dateFormat:'Y-m-d H:i:s.u'},
	{name: 'usr_reg',type: 'string'},
	{name: 'usr_mod',type: 'string'}

	],
	sortInfo : {
		field : 'id_fase_plantilla',
		direction : 'ASC'
	},
	bdel: true,
	bsave: false,
	bexcel: false,
	rootVisible: true,
	fwidth: 420,
	fheight: 300,
	onNodeDrop: function(o) {
	    this.ddParams = {
	        tipo_nodo : o.dropNode.attributes.tipo_nodo
	    };
	    this.idTargetDD = 'id_fase_plantilla';
	    if (o.dropNode.attributes.tipo_nodo == 'raiz' || o.dropNode.attributes.tipo_nodo == 'hijo') {
	        this.idNodoDD = 'id_fase_plantilla';
	        this.idOldParentDD = 'id_fase_plantilla_fk';
	    } else if(o.dropNode.attributes.tipo_nodo == 'item') {
	        this.idNodoDD = 'id_item';
            this.idOldParentDD = 'id_p';
	    }
	    Phx.vista.FasePlantilla.superclass.onNodeDrop.call(this, o);
	},

	successSave: function(resp) {
		Phx.vista.FasePlantilla.superclass.successSave.call(this, resp);
		var selectedNode = this.sm.getSelectedNode();
		if(selectedNode){
			selectedNode.attributes.estado = 'restringido';
		}
	},
	successBU: function(resp) {
		Phx.CP.loadingHide();
		var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		if (!reg.ROOT.error) {
			alert(reg.ROOT.detalle.mensaje)
		} else {

			alert('ocurrio un error durante el proceso')
		}
		resp.argument.node.reload();

	},
	definirEventos: function(){

	},
	onButtonNew: function(){
		var data={};
		data.id='id';
		if(this.sm.getSelectedNode()){
			data = this.sm.getSelectedNode().attributes;
		}

		this.Cmp.id_tipo_cc_plantilla.hide();
		if(data.id=='id'){
			this.Cmp.id_tipo_cc_plantilla.show();
		}
		console.log('qqq',data)
		Phx.vista.FasePlantilla.superclass.onButtonNew.call(this);
	}

});
</script>
