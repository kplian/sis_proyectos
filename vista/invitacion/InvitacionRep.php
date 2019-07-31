<?php
/**
*@package pXP
*@file InvitacionRep.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	Issue 		Fork		Fecha 			Autor				Descripcion
 * 	#15			ETR			31/07/2019		EGS					creacion 
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InvitacionRep=Ext.extend(Phx.frmInterfaz,{
	labelSubmit: '<i class="fa fa-check"></i> Imprimir',
	constructor:function(config){
		this.maestro=config;	
    	//llama al constructor de la clase padre
		Phx.vista.InvitacionRep.superclass.constructor.call(this,config);
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
					name: 'id_proyecto'
			},
			type:'Field',
			form:true
		},
          {
                config:{
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Hasta',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
          	{
                   config:{
                       name:'tipo_fecha',
                       fieldLabel:'Fecha',
                       allowBlank:true,
                       emptyText:'Elige deacuerdo a que fecha se hara la busqueda',
                       typeAhead: true,
                       triggerAction: 'all',
                       lazyRender:true,
                       mode: 'local',                       
                       gwidth: 100,
                       store:new Ext.data.ArrayStore({
                    fields: ['ID', 'valor'],
                    data :    [['fecha','Fecha Estimada'],    
                            ['fecha_real','Fecha Lanzamiento']]
                                
                    }),
                    valueField:'ID',
                    displayField:'valor',
                   },
                   type:'ComboBox',
                   valorInicial: 'fecha',
                   id_grupo:0,                   
                   grid:true,
                   form:true
           },
           {
            config:{
                name: 'id_tipo_estado',
                fieldLabel: 'Estado',
                allowBlank: false,
                emptyText: 'Elegir ...',
                tinit:false,
                resizable:true,
                tasignacion:false,
                store: new Ext.data.JsonStore({
                    url: '../../sis_workflow/control/TipoEstado/listarTipoEstado',
                    id : 'id_tipo_estado',
                    root: 'datos',
                    sortInfo:{
                        field: 'id_tipo_estado',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_estado','codigo_estado'],
                    remoteSort: true,
                    baseParams: { par_filtro: 'id_tipo_estado#codigo_estado'}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item" ><div class="awesomecombo-item {checked}"><p><b>Codigo: </b>{codigo_estado}</p></div>\
		                      </div></tpl>',
               	valueField: 'id_tipo_estado',
				displayField: 'codigo',
				gdisplayField: 'codigo',
				hiddenName: 'id_tipo_estado',
				forceSelection:true,
				typeAhead: false,
				triggerAction: 'all',
				listWidth:500,
				//resizable:true,
				lazyRender:true,
				mode:'remote',
				pageSize:10,
				queryDelay:1000,
				width: 250,
                enableMultiSelect:true,
				gwidth:250,
				minChars:2,
				anchor:'80%',
				qtip:'Estados de invitacion',
				renderer:function(value, p, record){
				
				}
            },
            type:'AwesomeCombo',
			bottom_filter: true,
            filters:{pfiltro:'codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        }
	],
	tam_pag:50,
	title:'Reporte',
	ActSave:'../../sis_proyectos/control/Reporte/listarReporteInvitacion',
	iniciarEventos:function(){
		//setea los campos con los parametros enviados del padre
		this.Cmp.id_proyecto.setValue(this.maestro.data.id_proyecto);
		this.obtenerTipoProceso();
		this.ocultarComponente(this.Cmp.tipo_fecha);
		
		this.Cmp.desde.on('select', function(cmb,rec,i){
			console.log('cmb',cmb,'rec',rec,'i',i)
			if (rec != null){
				this.mostrarComponente(this.Cmp.tipo_fecha);	
			}else{
				this.ocultarComponente(this.Cmp.tipo_fecha);	
			}	
		} ,this);
		
		this.Cmp.hasta.on('select', function(cmb,rec,i){
			console.log('cmb',cmb,'rec',rec,'i',i)
				if (rec != null){
				this.mostrarComponente(this.Cmp.tipo_fecha);
				
				}else{
				this.ocultarComponente(this.Cmp.tipo_fecha);	
				}	            
		} ,this);
		
		
		
	},
	successSave:function(resp)
        {
        	
        	Phx.CP.loadingHide();
			var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		    var nomRep = objRes.ROOT.detalle.archivo_generado;
			if(Phx.CP.config_ini.x==1){  			
			        	nomRep = Phx.CP.CRIPT.Encriptar(nomRep);
			 }
			window.open('../../../lib/lib_control/Intermediario.php?r='+nomRep+'&t='+new Date().toLocaleTimeString())
			        	
            Phx.CP.loadingHide();
            this.panel.close();
       },
    //recuperamos el id del tipo de proceso con el codigo definido   
    obtenerTipoProceso: function(config){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_workflow/control/TipoProceso/listarTipoProceso',
                params:{
                    codigo:'INV',
                },
                success: function(resp){
                	 Phx.CP.loadingHide();
                     var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                   
                        console.log('datos ajax',reg);
                        //agregamos el id_tipo_proceso como parametro al campo de id_tipo_etado 
                        this.Cmp.id_tipo_estado.store.baseParams.id_tipo_proceso = reg.datos[0]['id_tipo_proceso'];

                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });
 
        },
})
</script>

