<?php
/**
*@package pXP
*@file gen-Invitacion.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:20
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Invitacion = {
	
	require:'../../../sis_proyectos/vista/invitacion/InvitacionBase.php',
    requireclase:'Phx.vista.InvitacionBase',
//Phx.vista.Invitacion=Ext.extend(Phx.gridInterfaz,{
	
	constructor:function(config){
		this.maestro=config; ///config.maestro quitar para poder recibir datos

		//llama al constructor de la clase padre
		Phx.vista.Invitacion.superclass.constructor.call(this,config);
		
		///carga el valor por dedfecto como un array en el arreglo de atributos segun posicion
		this.Atributos[1].valorInicial=this.maestro.id_proyecto;
		
		///
		this.init();
		this.load({params:{start:0, limit:this.tam_pag,id_proyecto:this.maestro.id_proyecto}});
		
		this.addButton('ant_estado',{ argument: {estado: 'anterior'},text:'Atras',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        
        this.addButton('sig_estado',{ text:'Siguiente', iconCls: 'badelante', disabled: true, handler: this.sigEstado, tooltip: '<b>Pasar al Siguiente Estado</b>'});
        
        this.addBotonesGantt();
        
        /*
        this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0],
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            });
        
        this.addButton('btnObs',{
                    text :'Obs Wf',
                    grupo:[0],
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onOpenObs,
                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
        });
		*/
		this.iniciarEventos(); 
		          

	},
		
	      iniciarEventos: function () {
           
           	//console.log('maestro invitacion',this.maestro.id_proyecto);
           	//this.Cmp.id_proyecto.valorInicial = this.maestro.id_proyecto;
     	 	this.Cmp.tipo.store.loadData(this.arrayStore['Bien'].concat(this.arrayStore['Servicio'])); 
            },
       
          arrayStore :{
			'Bien':[
				['Bien','Bienes'],
				//['inmueble','Inmuebles'],
				//['vehiculo','Vehiculos']
			],
			'Servicio':[
				['Servicio','Servicios'],
                //20180319 - calvarez - quitar en desarrollo tb por que usuarios VIP estan usando sin saber y no existe flujo que cubra estas 2 opciones
				//['consultoria_personal','Consultoria de Personas'],
				//['consultoria_empresa','Consultoria de Empresas'],
				//['alquiler_inmueble','Alquiler Inmuebles']
			]
		},  
            
        antEstado: function(res){
		var rec=this.sm.getSelected(),
			obsValorInicial;

		Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
			'Estado de Wf',
			{   modal: true,
			    width: 450,
			    height: 250
			}, 
			{    data: rec.data, 
				 estado_destino: res.argument.estado,
			     obsValorInicial: obsValorInicial }, this.idContenedor,'AntFormEstadoWf',
			{
			    config:[{
			              event:'beforesave',
			              delegate: this.onAntEstado,
			            }],
			   scope:this
			});
	},    
            
            
      sigEstado:function(){                   
      var rec=this.sm.getSelected();
      this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal:true,
                                    width:700,
                                    height:450
                                }, {data:{
                                	   id_invitacion:rec.data.id_invitacion,
                                       id_estado_wf:rec.data.id_estado_wf,
                                       id_proceso_wf:rec.data.id_proceso_wf,
                                    	
                                    }}, this.idContenedor,'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            }],
                                    
                                    scope:this
                                 });        
               
     },
     onSaveWizard:function(wizard,resp){
        //console.log(wizard);
        //Phx.CP.loadingShow();
        Ext.Ajax.request({
            //url:'../../sis_workflow/control/ProcesoWf/siguienteEstadoProcesoWf',
            url:'../../sis_proyectos/control/Invitacion/siguienteEstado',
            params:{
                id_invitacion:      wizard.data.id_invitacion,
                id_proceso_wf_act:  resp.id_proceso_wf_act,
                id_estado_wf_act:   resp.id_estado_wf_act,
                id_tipo_estado:     resp.id_tipo_estado,
                id_funcionario_wf:  resp.id_funcionario_wf,
                id_depto_wf:        resp.id_depto_wf,
                obs:                resp.obs,
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success:this.successWizard,
            failure: this.conexionFailure,
            argument:{wizard:wizard},
            timeout:this.timeout,
            scope:this
        });
         
    },
       successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    /*
        onAntEstado:function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                //url:'../../sis_workflow/control/ProcesoWf/anteriorEstadoProcesoWf',
                url:'../../sis_proyectos/control/Invitacion/anteriorEstado',
                params:{id_proceso_wf:resp.id_proceso_wf, 
                        id_estado_wf:resp.id_estado_wf, 
                        operacion: 'cambiar',
                        obs:resp.obs},
                argument:{wizard:wizard},        
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            }); 
     },*/
      onAntEstado: function(wizard,resp){
        Phx.CP.loadingShow();
        var operacion = 'cambiar';

        Ext.Ajax.request({
              //url:'../../sis_workflow/control/ProcesoWf/anteriorEstadoProcesoWf',
                url:'../../sis_proyectos/control/Invitacion/anteriorEstado',
            params:{
            	id_invitacion:      wizard.data.id_invitacion,
                id_proceso_wf: resp.id_proceso_wf,
                id_estado_wf:  resp.id_estado_wf,  
                obs: resp.obs,
                operacion: operacion,
                id_cobro_simple: resp.data.id_cobro_simple
             },
            argument:{wizard:wizard},  
            success: this.successAntEstado,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },
     
     		
    successAntEstado:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    
	addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls : 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
	            items: [{
	                id:'b-gantti-' + this.idContenedor,
	                text: 'Gantt Imagen',
	                tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
	                handler:this.diagramGantt,
	                scope: this
	            }, {
	                id:'b-ganttd-' + this.idContenedor,
	                text: 'Gantt Dinámico',
	                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
	                handler:this.diagramGanttDinamico,
	                scope: this
	            },
	             {
                id:'b-ganttJs-' + this.idContenedor,
                text: 'Gantt JS',
                tooltip: '<b>Muestra el reporte </b>',
                handler:this.diagramGanttJs,
                scope: this
            	}]
            }
        });
		this.tbar.add(this.menuAdqGantt);
    },
    diagramGantt: function (){			
		var data=this.sm.getSelected().data.id_proceso_wf;
		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
			params:{'id_proceso_wf':data},
			success: this.successExport,
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope: this
		});			
	},
	
	diagramGanttDinamico: function (){			
		var data=this.sm.getSelected().data.id_proceso_wf;
		window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)		
	},
	
	//gantt con js improvide
	 diagramGanttJs : function(){			
		var data=this.sm.getSelected().data.id_proceso_wf;
		window.open('../../../sis_workflow/reportes/gantt/gantt_jsgantt.html?id_proceso_wf='+data)		
	},
	
	
		preparaMenu: function(n) {

		var data = this.getSelectedData();
		var tb = this.tbar;
		Phx.vista.Invitacion.superclass.preparaMenu.call(this, n);
		
       
        
        
		this.getBoton('ant_estado').disable();
		this.getBoton('sig_estado').disable();

		
			
			
			if(data.estado == 'borrador') {			
				
				this.getBoton('sig_estado').enable();
				
			} else if(data.estado == 'finalizado'){
				this.getBoton('sig_estado').disable();
				this.getBoton('del').disable();
				this.getBoton('edit').disable();
			} else if(data.estado == 'finalizado'||data.estado == 'sol_compra'){
				this.getBoton('sig_estado').disable();
				this.getBoton('ant_estado').disable();
				this.getBoton('del').disable();
				this.getBoton('edit').disable();
			} else {
				this.getBoton('ant_estado').enable();
				this.getBoton('sig_estado').enable();
				this.getBoton('del').enable();
				this.getBoton('edit').enable();
			}	

			 
	

		//Habilita el resto de los botones
        this.getBoton('diagrama_gantt').enable();
        //this.getBoton('btnObs').enable();
        //this.getBoton('btnChequeoDocumentosWf').enable();
         
        //boton de recibo
   
       
        

        
		return tb
	},

		
		
	liberaMenu: function() {
		var tb = Phx.vista.Invitacion.superclass.liberaMenu.call(this);
		if (tb) {
			this.getBoton('sig_estado').disable();
			this.getBoton('ant_estado').disable();
            this.getBoton('diagrama_gantt').disable();
            //this.getBoton('btnObs').disable();
            //this.getBoton('btnChequeoDocumentosWf').disable();
            
            
           // this.getBoton('btnDetalleDocumentoCobroSimple').disable();
            
           
		}
	
		return tb
	},
		loadCheckDocumentosSolWf:function() {
        var rec=this.sm.getSelected();
        rec.data.nombreVista = this.nombreVista;
        Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
            'Documentos del Proceso',
            {
                width:'90%',
                height:500
            },
            rec.data,
            this.idContenedor,
            'DocumentoWf'
        )
    },
    
    
        onOpenObs:function() {
        var rec=this.sm.getSelected();            
        var data = {
        	id_proceso_wf: rec.data.id_proceso_wf,
        	id_estado_wf: rec.data.id_estado_wf,
        	num_tramite: rec.data.num_tramite
        }
        
        Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
                'Observaciones del WF',
                {
                    width: '80%',
                    height: '70%'
                },
                data,
                this.idContenedor,
                'Obs');
    },
    
      successAntEstado:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    
	  
    tabsouth: [{
		url: '../../../sis_proyectos/vista/invitacion_det/InvitacionDet.php',
        title: 'Invitacion Det',
        height: '40%',
        cls: 'InvitacionDet'
    }],
	
}
//})

</script>
		
		