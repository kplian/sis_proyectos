<?php
/**
*@package pXP
*@file InvitacionReg.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	Issue 	Fork		Fecha 			Autor				Descripcion
 	#7		endeEtr   	29/01/2019		EGS					Creacion.Relaciona un fase_concepto_ingas con un item de una solicitud en proceso y genera o asocia con una invitacion
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InvitacionReg=Ext.extend(Phx.frmInterfaz,{

	constructor:function(config){
		this.maestro=config;	
    	//llama al constructor de la clase padre
		Phx.vista.InvitacionReg.superclass.constructor.call(this,config);
		this.init();
		console.log('config',config);
		this.iniciarEventos();
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
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase_concepto_ingas'
			},
			type:'Field',
			form:true
		},
		{
			config:{
				name : 'asociar_invitacion',
				fieldLabel : 'Asociar Invitacion',
				allowBlank: false,
				items: [
					{boxLabel: 'No', name: 'asociar_invitacion', inputValue: 'no', checked: true},
					{boxLabel: 'Si', name: 'asociar_invitacion', inputValue: 'si'}
				
				],
			},
			type : 'RadioGroupField',
			id_grupo : 1,
			form : true,
			grid:true
		 },
				{
            config:{
                name: 'id_invitacion',
                fieldLabel: 'Invitacion',
                allowBlank: false,
                emptyText: 'Elegir ...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/Invitacion/listarInvitacion',
                    id : 'id_invitacion',
                    root: 'datos',
                    sortInfo:{
                        field: 'id_invitacion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_invitacion','codigo','id_proyecto'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'ivt.id_invitacion#ivt.codigo#ivt.id_proyecto'}
                }),
                tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo: </b>{codigo}</p>\
		                       </div></tpl>',
               	valueField: 'id_invitacion',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'id_invitacion',
				forceSelection:false,
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
				anchor:'80%',
				qtip:'Procesos de solicitutes de compra',
				//tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p></div></tpl>',
				renderer:function(value, p, record){
				
				}
            },
            type:'ComboBox',
            id_grupo:1,
            grid:true,
            form:true
        },
        
		{
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
                emptyText: 'Codigo de nueva Invitacion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:20,

			},
				type:'TextField',
				filters:{pfiltro:'inv.codigo',type:'string'},
				id_grupo:1,
				bottom_filter:true,
				grid:true,
				form:true
		},
		{
            config:{
                name: 'id_solicitud',
                fieldLabel: 'Proceso Adq',
                allowBlank: false,
                emptyText: 'Elegir ...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/Invitacion/listarSolicituCompraCombo',
                    id : 'id_solicitud',
                    root: 'datos',
                    sortInfo:{
                        field: 'num_tramite',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_solicitud','fecha_soli','num_tramite','codigo_estado','codigo_moneda'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'sol.num_tramite#tp.codigo'}
                }),
                tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Nro Tramite: </b>{num_tramite}</p>\
		                       <p><b>Estado: </b>{codigo_estado}</p>\
		                        <p><b>Moneda: </b>{codigo_moneda}</p>\
		                        <p><b>Fecha de Solicitud: </b>{fecha_soli}</p> </div></tpl>',
               	valueField: 'id_solicitud',
				displayField: 'num_tramite',
				gdisplayField: 'num_tramite',
				hiddenName: 'id_solicitud',
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
				anchor:'80%',
				qtip:'Procesos de solicitutes de compra',
				//tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p></div></tpl>',
				renderer:function(value, p, record){
				
				}
            },
            type:'ComboBox',
			bottom_filter: true,
            filters:{pfiltro:'sol.num_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_solicitud_det',
                fieldLabel: 'Detalle Solicitud',
                allowBlank: false,
                emptyText: 'Elegir ...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/Invitacion/listarSolicituCompraDetCombo',
                    id : 'id_solicitud_det',
                    root: 'datos',
                    sortInfo:{
                        field: 'id_solicitud_det',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id','id_solicitud_det','id_solicitud','id_concepto_ingas','desc_ingas','cantidad','precio_unitario','precio_total','id_centro_costo','descripcion','codigo_moneda','codigo_moneda_total_conversion','precio_total_conversion'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'sold.id_solicitud#coinga.desc_ingas#sold.cantidad'}
                }),
                tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Concepto de Gasto: </b>{id}-{desc_ingas}</p>\
		                       <p><b>Cantidad: </b>{cantidad}</p>\
		                        <p><b>Precio Unitario: </b>{precio_unitario}</p>\
		                        <p><b>Precio Total {codigo_moneda} : </b>{precio_total}</p> \
		                        <p><b>Precio Total {codigo_moneda_total_conversion} : </b>{precio_total_conversion}</p> \
		                        <p><b>Descripcion: </b>{descripcion}</p></div></tpl>',
               	valueField: 'id_solicitud_det',
				displayField: 'desc_ingas',
				gdisplayField: 'desc_ingas',
				hiddenName: 'id_solicitud_det',
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
				anchor:'80%',
				qtip:'Procesos de solicitutes de compra',
				//tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p></div></tpl>',
				renderer:function(value, p, record){
				
				}
            },
            type:'ComboBox',
			bottom_filter: true,
            filters:{pfiltro:'coinga.desc_ingas',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },

	],
	tam_pag:50,
	title:'Regularizacion',
	ActSave:'../../sis_proyectos/control/Invitacion/invitacionRegularizada',
	iniciarEventos:function(){
		//setea los campos con los parametros enviados del padre
		this.Cmp.id_proyecto.setValue(this.maestro.data.id_proyecto);
		this.Cmp.id_fase.setValue(this.maestro.data.id_fase);
		this.Cmp.id_fase_concepto_ingas.setValue(this.maestro.data.id_fase_concepto_ingas);
  		//oculta el campo la primera vezqu abre la ventana
  		this.ocultarComponente(this.Cmp.id_invitacion);
		
		//al cambiar el campo de la solicitud este rellena el campo id_soolicitu_det con los detalles de esta misma 
		this.Cmp.id_solicitud.on('select',function(combo,record,index){
				this.Cmp.id_solicitud_det.store.baseParams.id_solicitud = record.data.id_solicitud;
							    this.Cmp.id_solicitud_det.store.load({params:{start:0,limit:this.tam_pag}, 
					               callback : function (r) {                        
					                    if (r.length > 0 ) {                        
					                        console.log('r',r);	
					                       this.Cmp.id_solicitud_det.setValue(r[0].data.id_solicitud_det);
					                    }     
					                                    
					                }, scope : this
					            });
		},this);
		//al cambiar el estado de asociar_invitacion este oculta y resetea los campos  codigo e id_invitacion
		this.Cmp.asociar_invitacion.on('change', function(cmp, check){
    		    
    		    if(check.getRawValue() =='no'){
    		  		this.ocultarComponente(this.Cmp.id_invitacion);
    		    	this.mostrarComponente(this.Cmp.codigo);
    		    	this.Cmp.id_invitacion.allowBlank=true;
					this.Cmp.codigo.reset();
 					this.Cmp.id_invitacion.reset();

    		    }
    		    else{
    		    	this.mostrarComponente(this.Cmp.id_invitacion);
   					this.ocultarComponente(this.Cmp.codigo);		
    		    	this.Cmp.codigo.allowBlank=true;
 					this.Cmp.id_invitacion.reset();
 					console.log('this.maestro.data.id_proyecto',this.maestro.data.id_proyecto);
 					
 					this.Cmp.id_invitacion.store.baseParams.id_proyecto = this.maestro.data.id_proyecto;
							    this.Cmp.id_invitacion.store.load({params:{start:0,limit:this.tam_pag}, 
					               callback : function (r) {                        
					                    if (r.length > 0 ) {                        
					                        console.log('r',r);	
					                       this.Cmp.id_invitacion.setValue(r[0].data.id_invitacion);
					                    }     
					                                    
					                }, scope : this
					 });
			    }
    		}, this);
		
	},
	successSave:function(resp)
        {
            Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            this.panel.close();
       },
})
</script>

