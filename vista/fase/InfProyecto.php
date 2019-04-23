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
Phx.vista.InfProyecto=Ext.extend(Phx.frmInterfaz,{
	
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
		Phx.vista.InfProyecto.superclass.constructor.call(this,config);
		this.init();
		this.iniciarEventos();
	},
  
    iniciarEventos: function(){
    	
       	//recupera los datos del proyecto
    	maestro = Phx.CP.getPagina(this.idContenedorPadre).retornarProyecto();
    	
    	this.obtenerProyecto(maestro);
    	

    },	
      ///recupera los datos del proyecto cuando se requiera  
     obtenerProyecto: function(config){
			//console.log('config id_proyecto',config.id_proyecto);
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_proyectos/control/Proyecto/listarProyecto',
                params:{
                    id_proyecto: config.id_proyecto,
                },
                success: function(resp){
                	 Phx.CP.loadingHide();
                     var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                   
                        console.log('datos ajax',reg.datos[0]);
                        
               					this.writeHtml(reg.datos[0]);
               		
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });
 
        },
		
    //escribe los datos de proyecto en html
    writeHtml: function(maestro){
    		console.log('proyecto',maestro);
    		    	 
		console.log('maestroinfo3',maestro);
		var codigo = maestro["codigo"]?maestro["codigo"]:'';
		var stea = maestro["importe_max"]?maestro["importe_max"]:0;
		var desc_moneda = maestro["desc_moneda"]?maestro["desc_moneda"]:'';
		var estado = maestro["estado"]?maestro["estado"]:'';
		var nombre = maestro["nombre"]?maestro["nombre"]:'';
		var total_fase_concepto_ingas = maestro["total_fase_concepto_ingas"]?maestro["total_fase_concepto_ingas"]:0;
		var total_invitacion = maestro["total_invitacion"]?maestro["total_invitacion"]:0;


		  var html = String.format("I<b>NFORMACION DEL PROYECTO</b><table style='width:100%; border-collapse:collapse;'> \
		  	  										<tr>\
													      <td ><b>Codigo:</b></td>\
													    <td style='padding: 3px;'>{0}</td> \
													  </tr>\
		   			    							  <tr>\
													    <td ><b>Nombre:</b> </td>\
													    <td style='padding: 3px;'>{1}</td> \
													  </tr >\
													  <tr>\
													      <td ><b>Stea:</b></td>\
													    <td style='padding: 3px;'>{2}</td> \
													  </tr>\
													  <tr>\
													        <td ><b>Total Bienes/Servicios:</b> </td>\
													    <td style='padding: 3px;' >{3}</td>\
													  </tr>\
													   </tr>\
													  <tr>\
													        <td ><b>Total Ejecutado: </b> </td>\
													    <td style='padding: 3px;' >{4}</td>\
													  </tr>\
													   </tr>\
													  <tr>\
													        <td ><b>Moneda:</b> </td>\
													    <td style='padding: 3px;' >{5}</td>\
													  </tr>\
													  <tr>\
													        <td ><b>Estado:</b> </td>\
													    <td style='padding: 3px;' >{6}</td>\
													  </tr>\
													  </table>" ,
													   codigo,
													   nombre,
  													   Ext.util.Format.number(stea,'000.000,00/i'),  													
  													   Ext.util.Format.number(total_fase_concepto_ingas,'000.000,00/i'),
  													   Ext.util.Format.number(total_invitacion,'000.000,00/i'),
  													   desc_moneda,
  													   estado
																							  
												);
		   			    	
		this.panelResumen.update(html)
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

	],
	
	onReloadPage: function (m) {
					console.log("maestro inf",m)
		            this.maestro = m;
		            this.iniciarEventos();
		            
	},
	postReloadPage:function(data){
    	console.log('postReloadPage, puede sobrecagar opcionalmante para incrementar funcionalidad', data)
    },
	actualizarInfProyecto: function (){
		this.iniciarEventos();
		
	}


})
</script>

