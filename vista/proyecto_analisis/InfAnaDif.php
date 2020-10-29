<?php
/**
*@package pXP
*@file InFAnaDif.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	Issue 			Fecha 			Autor				Descripcion
 	#MDID-11    	29/10/2020		EGS					Tablero de informacion de saldos
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InfAnaDif=Ext.extend(Phx.frmInterfaz,{
	
	botones:false,
	constructor:function(config){
     	this.maestro=config.maestro;
		this.panelResumen = new Ext.Panel({html:'',autoScroll: true ,width: '100%',
            height: '100%'});
    	this.Grupos = [
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
        console.log('html',maestro);
        if (maestro != undefined){
            var saldo_activo = maestro["saldo_activo"]?maestro["saldo_activo"]:'';
            var saldo_gasto = maestro["saldo_gasto"]?maestro["saldo_gasto"]:'';
            var saldo_ingreso = maestro["saldo_ingreso"]?maestro["saldo_ingreso"]:'';
            var saldo_pasivo = maestro["saldo_pasivo"]?maestro["saldo_pasivo"]:'';

            var saldo_activo_cbt = maestro["saldo_activo_cbt"]?maestro["saldo_activo_cbt"]:'';
            var saldo_gasto_cbt = maestro["saldo_gasto_cbt"]?maestro["saldo_gasto_cbt"]:'';
            var saldo_ingreso_cbt = maestro["saldo_ingreso_cbt"]?maestro["saldo_ingreso_cbt"]:'';
            var saldo_pasivo_cbt = maestro["saldo_pasivo_cbt"]?maestro["saldo_pasivo_cbt"]:'';

            var saldo_activo_cbtII = maestro["saldo_activo_cbtii"]?maestro["saldo_activo_cbtii"]:'';
            var saldo_gasto_cbtII = maestro["saldo_gasto_cbtii"]?maestro["saldo_gasto_cbtii"]:'';
            var saldo_ingreso_cbtII = maestro["saldo_ingreso_cbtii"]?maestro["saldo_ingreso_cbtii"]:'';
            var saldo_pasivo_cbtII = maestro["saldo_pasivo_cbtii"]?maestro["saldo_pasivo_cbtii"]:'';

            var saldo_activo_cbtIII = maestro["saldo_activo_cbtiii"]?maestro["saldo_activo_cbtiii"]:'';
            var saldo_gasto_cbtIII = maestro["saldo_gasto_cbtiii"]?maestro["saldo_gasto_cbtiii"]:'';
            var saldo_ingreso_cbtIII = maestro["saldo_ingreso_cbtiii"]?maestro["saldo_ingreso_cbtiii"]:'';
            var saldo_pasivo_cbtIII = maestro["saldo_pasivo_cbtiii"]?maestro["saldo_pasivo_cbtiii"]:'';
        }else{
            var saldo_activo = '';
            var saldo_gasto = '';
            var saldo_ingreso = '';
            var saldo_pasivo = '';

            var saldo_activo_cbt = '';
            var saldo_gasto_cbt = '';
            var saldo_ingreso_cbt = '';
            var saldo_pasivo_cbt = '';

            var saldo_activo_cbtII = '';
            var saldo_gasto_cbtII = '';
            var saldo_ingreso_cbtII = '';
            var saldo_pasivo_cbtII = '';

            var saldo_activo_cbtIII = '';
            var saldo_gasto_cbtIII = '';
            var saldo_ingreso_cbtIII = '';
            var saldo_pasivo_cbtIII = '';

        }
		  var html = String.format("<b><u> Saldos Iniciales</u> </b>\
		                            <table style='width:100%; border-collapse:collapse;' bgcolor='#342D56' > \
		  	  										<tr>\
													      <td ><font color='silver'>Saldo Activo:</font></td>\
													    <td style='padding: 3px;'><font color='silver'>{0}</font></td> \
													  </tr>\
		   			    							  <tr>\
													    <td ><font color='gray'>Saldo Pasivo:</font> </td>\
													    <td style='padding: 3px;'><font color='gray'>{1}</font></td> \
													  </tr >\
													  <tr>\
													      <td ><font color='olive'>Saldo Ingreso:</font></td>\
													    <td style='padding: 3px;'><font color='olive'>{2}</font></td> \
													  </tr>\
													  <tr>\
													        <td ><font color='darkseagreen'>Saldo Gasto:</font></td>\
													    <td style='padding: 3px;' ><font color='darkseagreen'>{3}</font></td>\
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
        var htmlCbt = String.format("<b><u>Saldos CBT I</u></b><table style='width:100%; border-collapse:collapse;' bgcolor='#342D56'> \
		  	  										<tr>\
													      <td ><font color='silver'>Saldo Activo:</font></td>\
													    <td style='padding: 3px;'><font color='silver'>{0}</font></td> \
													  </tr>\
		   			    							  <tr>\
													    <td ><font color='gray'>Saldo Pasivo:</font> </td>\
													    <td style='padding: 3px;'><font color='gray'>{1}</font></td> \
													  </tr >\
													  <tr>\
													      <td ><font color='olive'>Saldo Ingreso:</font></td>\
													    <td style='padding: 3px;'><font color='olive'>{2}</font></td> \
													  </tr>\
													  <tr>\
													        <td ><font color='darkseagreen'>Saldo Gasto:</font></td>\
													    <td style='padding: 3px;' ><font color='silver'>{3}</font></td>\
													  </tr>\
													   </table>" ,
            Ext.util.Format.number(saldo_activo_cbt,'000.000,00/i'),
            Ext.util.Format.number(saldo_pasivo_cbt,'000.000,00/i'),
            Ext.util.Format.number(saldo_ingreso_cbt,'000.000,00/i'),
            Ext.util.Format.number(saldo_gasto_cbt,'000.000,00/i')
            // Ext.util.Format.number(stea,'000.000,00/i'),
            // Ext.util.Format.number(total_fase_concepto_ingas,'000.000,00/i'),
            // Ext.util.Format.number(total_invitacion,'000.000,00/i'),


        );
        var htmlCbtII = String.format("<b><u>Saldos CBT II</u></b><table style='width:100%; border-collapse:collapse;' bgcolor='#342D56'> \
		  	  									<tr>\
													      <td ><font color='silver'>Saldo Activo:</font></td>\
													    <td style='padding: 3px;'><font color='silver'>{0}</font></td> \
													  </tr>\
		   			    							  <tr>\
													    <td ><font color='gray'>Saldo Pasivo:</font> </td>\
													    <td style='padding: 3px;'><font color='olive'>{1}</font></td> \
													  </tr >\
													  <tr>\
													      <td ><font color='olive'>Saldo Ingreso:</font></td>\
													    <td style='padding: 3px;'><font color='olive'>{2}</font></td> \
													  </tr>\
													  <tr>\
													        <td ><font color='darkseagreen'>Saldo Gasto:</font></td>\
													    <td style='padding: 3px;' ><font color='darkseagreen'>{3}</font></td>\
													  </tr>\
													   </table>" ,
            Ext.util.Format.number(saldo_activo_cbtII,'000.000,00/i'),
            Ext.util.Format.number(saldo_pasivo_cbtII,'000.000,00/i'),
            Ext.util.Format.number(saldo_ingreso_cbtII,'000.000,00/i'),
            Ext.util.Format.number(saldo_gasto_cbtII,'000.000,00/i')
            // Ext.util.Format.number(stea,'000.000,00/i'),
            // Ext.util.Format.number(total_fase_concepto_ingas,'000.000,00/i'),
            // Ext.util.Format.number(total_invitacion,'000.000,00/i'),


        );
        var htmlCbtIII = String.format("<b><u>Saldos CBT III</u></b><table style='width:100%; border-collapse:collapse;' bgcolor='#342D56'> \
		  	  									<tr>\
													      <td ><font color='silver'>Saldo Activo:</font></td>\
													    <td style='padding: 3px;'><font color='silver'>{0}</font></td> \
													  </tr>\
		   			    							  <tr>\
													    <td ><font color='gray'>Saldo Pasivo:</font> </td>\
													    <td style='padding: 3px;'><font color='gray'>{1}</font></td> \
													  </tr >\
													  <tr>\
													      <td ><font color='olive'>Saldo Ingreso:</font></td>\
													    <td style='padding: 3px;'><font color='gray'>{2}</font></td> \
													  </tr>\
													  <tr>\
													        <td ><font color='darkseagreen'>Saldo Gasto:</font></td>\
													    <td style='padding: 3px;' ><font color='darkseagreen'>{3}</font></td>\
													  </tr>\
													   </table>" ,
            Ext.util.Format.number(saldo_activo_cbtIII,'000.000,00/i'),
            Ext.util.Format.number(saldo_pasivo_cbtIII,'000.000,00/i'),
            Ext.util.Format.number(saldo_ingreso_cbtIII,'000.000,00/i'),
            Ext.util.Format.number(saldo_gasto_cbtIII,'000.000,00/i')
            // Ext.util.Format.number(stea,'000.000,00/i'),
            // Ext.util.Format.number(total_fase_concepto_ingas,'000.000,00/i'),
            // Ext.util.Format.number(total_invitacion,'000.000,00/i'),


        );

        html =  String.format("<div style=' width: 90% ;height: 100% '>"+ html + htmlCbt + htmlCbtII + htmlCbtIII+ " </div>");
		this.panelResumen.update({html,autoScroll: true})
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

