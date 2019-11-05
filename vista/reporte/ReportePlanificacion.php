<?php
/**
 *@package pXP
 *@file    ItemEntRec.php
 *@author  
 *  *@date   
 *@description Reporte Material Entregado/Recibido
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
	Phx.vista.ReportePlanificacion = Ext.extend(Phx.frmInterfaz, {
	    tipo:'reporte',
		constructor : function(config) {
			
			this.maestro=config;
			
			console.log('maestro',this.maestro);
			this.Atributos[0].valorInicial=this.maestro.id_componente_macro;
            this.Atributos[1].valorInicial=this.maestro.id_proyecto;
			Phx.vista.ReportePlanificacion.superclass.constructor.call(this, config);
			this.init();
			this.iniciarEventos();
		
		},
		

		Atributos : [
		
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
								['plan_ini','Planificacion Inicial']

							]
				}),
				valueField: 'variable',
				displayField: 'valor',
			},
			type:'ComboBox',
			form:true
		},

		],
		title : 'Generar Reporte',

		topBar : true,
		botones : false,
		labelSubmit : 'Imprimir',
		tooltipSubmit : '<b>Generar Reporte</b>',
		
		
		tipo : 'reporte',
		clsSubmit : 'bprint',

		
		agregarArgsExtraSubmit: function() {

    	},
    	iniciarEventos: function(){
            this.Cmp.tipo_reporte.on('select', function(combo, record, index){
                console.log('rec',record.data.valor);
                if (record.data.variable === 'plan_ini'){
                    console.log('rec',record);
                    this.ActSave = '../../sis_proyectos/control/ReportePlanificacion/listarPlanificacionInicial';

                }
            }, this);
    	},

        successSave:function(resp){
            Phx.CP.loadingHide();
            var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            var nomRep = objRes.ROOT.detalle.archivo_generado;
            if(Phx.CP.config_ini.x==1){
                nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
            }
            window.open('../../../lib/lib_control/Intermediario.php?r='+nomRep+'&t='+new Date().toLocaleTimeString())
            this.panel.close();
        },

   
})
</script>