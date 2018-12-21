<?php
/**
*@package pXP
*@file    ReporteResumenN.php
*@author  manuel guerra
*@date    09-10-2017
*@description muestra un formulario que muestra la cuenta y el monto de la transferencia
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ReporteResumenN=Ext.extend(Phx.frmInterfaz,{
		
	layout:'fit',
	maxCount:0,
	breset :false,
	constructor:function(config){
		this.maestro=config;
		
		console.log('config',this.maestro.id_proyecto);
		
		Phx.vista.ReporteResumenN.superclass.constructor.call(this,config);
		this.init(); 
		this.iniciarEventos();		
		this.loadValoresIniciales();		
	},

	Atributos:[
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
				name:'tipo_reporte',
				fieldLabel:'Reporte de ',
				allowBlank:false,
				emptyText:'Reporte de',
				typeAhead: true,
				triggerAction: 'all',
				lazyRender:true,
				mode: 'local',
				valueField: 'tipo',
				//anchor: '100%',
				//gwidth: 100,
				width:150,
				store:new Ext.data.ArrayStore({
					fields: ['variable', 'valor'],
					data : [    
								['plan_pago','PLan Pago'],
								['lanzamiento_item','Lanzamiento Items'],
								['presupuesto','Presupuesto'],
							
							]
				}),
				valueField: 'variable',
				displayField: 'valor',
				/*
				listeners: {
					'afterrender': function(combo){			  
						combo.setValue('todo');
					}
				}*/
			},
			type:'ComboBox',
			form:true
		},

	],
	

	title:'Filtro',
	
	/*
 successSave:function(resp)
        {
            Phx.CP.loadingHide();
            this.panel.close();
        },
       
        */
    	iniciarEventos: function(){
    		
        	this.Atributos[this.getIndAtributo('id_proyecto')].valorInicial = this.maestro.id_proyecto;


    	},
    	
    	onSubmit:function(){
		//TODO passar los datos obtenidos del wizard y pasar  el evento save		
		if (this.form.getForm().isValid()) {
			this.fireEvent('beforesave',this,this.getValues());
			this.getValues();
			}
			this.panel.close();
		},
	
		
		getValues:function(){		
		var resp = {			
			id_proyecto:this.Cmp.id_proyecto.getValue(),
			tipo_reporte:this.Cmp.tipo_reporte.getValue(),


		}
		return resp;
	}
	

})
</script>
