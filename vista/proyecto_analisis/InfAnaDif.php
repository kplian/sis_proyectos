<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	Issue 			Fecha 			Autor				Descripcion
 	#3				31/12/2018		EGS					Aumentar Importe Stea
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InfAnaDif=Ext.extend(Phx.frmInterfaz,{
	
	botones:false,
	constructor:function(config){
     	this.maestro=config.maestro;
		this.panelResumen = new Ext.Panel({html:''});
    	this.Grupos = [{

	                    xtype: 'fieldset',
	                    border: false,
	                    autoScroll: true,
	                    layout: 'form',
	                    items: [],
	                    id_grupo: 0
				               
				    },
				     this.panelResumen
				    ];
    	//llama al constructor de la clase padre
		Phx.vista.InfAnaDif.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
	},
  
    iniciarEventos: function(){
    	
       	//recupera los datos del proyecto
    	maestro = Phx.CP.getPagina(this.idContenedorPadre).retornarAnaDif();
    	
    	this.obtenerInfAnaDif(maestro);
    	

    },	
      ///recupera los datos del proyecto cuando se requiera  
    obtenerInfAnaDif: function(config){
			if (config != undefined){
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_proyectos/control/ProyectoAnalisis/listarAnalisisDiferido',
                    params:{
                        id_proyecto_analisis: config.id_proyecto_analisis,
                    },
                    success: function(resp){
                        Phx.CP.loadingHide();
                        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

                        console.log('datos ajax analisis',reg.datos[0]);

                        this.writeHtml(reg.datos[0]);

                    },
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope:this
                });


            }

 
        },
		
    //escribe los datos de proyecto en html
    writeHtml: function(maestro){

		var saldo_activo = maestro["saldo_activo"]?maestro["saldo_activo"]:'';
		var saldo_gasto = maestro["saldo_gasto"]?maestro["saldo_gasto"]:'';
		var saldo_ingreso = maestro["saldo_ingreso"]?maestro["saldo_ingreso"]:'';
		var saldo_pasivo = maestro["saldo_pasivo"]?maestro["saldo_pasivo"]:'';



		  var html = String.format("<b>Analisis de Diferimiento</b><table style='width:100%; border-collapse:collapse;'> \
		  	  										<tr>\
													      <td >Saldo Activo:</td>\
													    <td style='padding: 3px;'>{0}</td> \
													  </tr>\
		   			    							  <tr>\
													    <td >Saldo Pasivo: </td>\
													    <td style='padding: 3px;'>{1}</td> \
													  </tr >\
													  <tr>\
													      <td >Saldo Ingreso:</td>\
													    <td style='padding: 3px;'>{2}</td> \
													  </tr>\
													  <tr>\
													        <td >Saldo Gasto:</td>\
													    <td style='padding: 3px;' >{3}</td>\
													  </tr>\
													   </tr>\
													   </table>" ,
                                                      Ext.util.Format.number(saldo_activo,'000.000,00/i'),
                                                      Ext.util.Format.number(saldo_pasivo,'000.000,00/i'),
                                                      Ext.util.Format.number(saldo_ingreso,'000.000,00/i'),
                                                      Ext.util.Format.number(saldo_gasto,'000.000,00/i')
  													   // Ext.util.Format.number(stea,'000.000,00/i'),
  													   // Ext.util.Format.number(total_fase_concepto_ingas,'000.000,00/i'),
  													   // Ext.util.Format.number(total_invitacion,'000.000,00/i'),

																							  
												);
		   			    	
		this.panelResumen.update(html)
    },
    	
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proyecto_analisis'
			},
			type:'Field',
			form:true
		},

	],
	
	onReloadPage: function (m) {
					console.log("maestro inf",m)
		            this.maestro = m;
		            this.iniciarEventos();
		            
	},
	postReloadPage:function(data){
    	console.log('postReloadPage, puede sobrecagar opcionalmante para incrementar funcionalidad', data)
    },
	actualizarInfAnaDif: function (){
		this.iniciarEventos();
		
	}


})
</script>

