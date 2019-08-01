<?php
/**
 * 
	ISSUE		FORK		FECHA			AUTHOR				DESCRIPCION
 	 #16		ETR			01/08/2019		EGS					CREACION
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.WizardAgregaPlantilla = Ext.extend(Phx.frmInterfaz,{
	constructor:function(config)
	{	this.maestro = config;
		this.panelResumen = new Ext.Panel({html:''});
		this.Grupos = [{
			xtype: 'fieldset',
			border: false,
			autoScroll: true,
			layout: 'form',
			items: [],
			id_grupo: 0
		},this.panelResumen
		];
		Phx.vista.WizardAgregaPlantilla.superclass.constructor.call(this,config);
		this.init();
		console.log('config',config);
		console.log('proyecto',this.maestro.nodo.id_proyecto); 
	},
	
	loadValoresIniciales:function(){    	
		Phx.vista.WizardAgregaPlantilla.superclass.loadValoresIniciales.call(this);
		this.Cmp.id_proyecto.setValue(this.maestro.nodo.id_proyecto);
		this.Cmp.id_unidad_constructiva.setValue(this.maestro.nodo.id_unidad_constructiva);

	},

	Atributos:[
		{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_unidad_constructiva'
			},
			type : 'Field',
			form : true,
			grid : false
		},
		
		{
			//configuracion del componente
			config : {
				labelSeparator : '',
				inputType : 'hidden',
				name : 'id_proyecto'
			},
			type : 'Field',
			form : true,
			grid : false
		},		
           {
            config:{
                name: 'id_unidad_constructiva_plantilla',
                fieldLabel: 'Plantilla',
                allowBlank: true,
                emptyText: 'Plantilla...',
                store:new Ext.data.JsonStore(
		                {
		                    url: '../../sis_proyectos/control/UnidadConstructivaPlantilla/listarUnidadConstructivaPlantilla',
		                    id: 'id_unidad_constructiva_plantilla',
		                    root:'datos',
		                    sortInfo:{
		                        field:'codigo',
		                        direction:'ASC'
		                    },
		                    totalProperty:'total',
		                    fields: ['id_unidad_constructiva_plantilla','descripcion','codigo'],
		                    remoteSort: true,
		                     baseParams:{
				                    start: 0,
				                    limit: 10,
				                    sort: 'descripcion',
				                    dir: 'ASC',
				                    par_filtro:'unconpl.descripcion',
				                    solo_raices:'si'
				              }
		                }),
                tpl:'<tpl for=".">\ <div class="x-combo-list-item"><p><b>Concepto de Gasto: </b>{codigo}</p>\</div></tpl>',
               	valueField: 'id_unidad_constructiva_plantilla',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'id_unidad_constructiva_plantilla',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				listWidth:500,
				resizable:true,
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width: 250,
				gwidth:250,
				minChars:2,
				anchor:'100%',
				qtip:'Si el concepto de gasto que necesita no existe por favor comuníquese con el área de presupuestos para solicitar la creación.',
				//tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p></div></tpl>',
				renderer:function(value, p, record){
					if (record.json.precio == record.json.total_prorrateo && record.json.precio != null ){
						return String.format('{0}', record.data['codigo']);
					}
					else{
						return String.format('<b><font size=3 style="color:#FF1700";>{0}</font><b>', record.data['desc_ingas']);												
					}
				}
            },
            type:'ComboBox',
			bottom_filter: true,
            filters:{pfiltro:'unconpla.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
	],
	labelSubmit: '<i class="fa fa-check"></i> Guardar',
	title: 'Modificar....',
	// Funcion guardar del formulario
	onSubmit: function(o) {
		var me = this;
		if (me.form.getForm().isValid()) {
			var parametros = me.getValForm()
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url : '../../sis_proyectos/control/UnidadConstructiva/agregarPlantilla',
				params : parametros,
				success : this.successGen,
				failure : this.conexionFailure,
				timeout : this.timeout,
				scope : this
			})
		}
	},
	
	successGen: function(resp){
		Phx.CP.loadingHide();
		Phx.CP.getPagina(this.idContenedorPadre).onButtonAct();
		this.panel.destroy();
		

	},


})
</script>