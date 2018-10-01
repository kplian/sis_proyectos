<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoPr = {
	require:'../../../sis_proyectos/vista/proyecto/ProyectoBase.php',
    requireclase:'Phx.vista.ProyectoBase',
    constructor: function(config) {
    	Phx.vista.ProyectoPr.superclass.constructor.call(this,config);
        this.maestro = config;
        this.init();

        //Botón para Imprimir el Comprobante
		this.addButton('btnFases', {
			text : 'Fases',
			iconCls : 'bexecdb',
			disabled : true,
			handler : this.openFases,
			tooltip : '<b>Fases del Proyecto</b><br>Interfaz para el registro de las fases que componen al proyecto'
		});
		
		this.addButton('btnInvitacion',{ 
       	    text: 'Invitaciones', 
       	    iconCls: 'blist', 
       	    disabled: true, 
       	    handler: this.mostraInvitacion, 
       	    tooltip: 'Invitaciones'});
    },
    
	tabsouth: [{
		url: '../../../sis_proyectos/vista/proyecto_funcionario/ProyectoFuncionario.php',
		title: 'Funcionarios del proyecto',
		height: '50%',
		cls: 'ProyectoFuncionario'
	}, {
		url: '../../../sis_proyectos/vista/proyecto_contrato/ProyectoContrato.php',
		title: 'Contratos',
		height: '50%',
		cls: 'ProyectoContrato'
	}],
	openFases: function(){
		var data = this.getSelectedData();
		console.log('mi data',data)
		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/fase/Fase.php',
			'Fases', {
			    width: '95%',
			    height: '90%'
			},
			data,
			this.idContenedor,
			'Fase'
		);
	},
	
	mostraInvitacion: function(){
		var data = this.getSelectedData();
		console.log('proyecto',data)

		var win = Phx.CP.loadWindows(
			'../../../sis_proyectos/vista/invitacion/Invitacion.php',
			'Invitaciones', {
			    width: '80%',
			    height: '70%'
			},
			data,
			this.idContenedor,
			'Invitacion'//clase de la vista
		);
	},
	preparaMenu: function(n){
		var tb = Phx.vista.ProyectoPr.superclass.preparaMenu.call(this);
		this.getBoton('btnFases').enable();
		 this.getBoton('btnInvitacion').enable();

		return tb;
	},
	liberaMenu: function(){
		var tb = Phx.vista.ProyectoPr.superclass.liberaMenu.call(this);
		this.getBoton('btnFases').disable();
		this.getBoton('btnInvitacion').disable();
		return tb;
	}
}
</script>
		
		