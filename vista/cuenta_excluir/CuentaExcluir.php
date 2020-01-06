<?php
/**
*@package pXP
*@file CuentaExcluir.php
*@author  (rchumacero)
*@date 06-01-2020 19:22:43
*@description Interfaz para registro de las cuentas contables a excluir en el proceso de Cierre de Proyectos

***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 #51    PRO       ETR           06/01/2020  RCM         Creación del archivo
***************************************************************************
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaExcluir = Ext.extend(Phx.gridInterfaz, {

	constructor: function(config){
		this.maestro = config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CuentaExcluir.superclass.constructor.call(this, config);
		this.init();
		this.load({params:{start: 0, limit: this.tam_pag}})
	},

	Atributos:[
		{
			//configuracion del componente
			config: {
				labelSeparator: '',
				inputType: 'hidden',
				name: 'id_cuenta_excluir'
			},
			type: 'Field',
			form: true
		},
		{
			config: {
				name: 'nro_cuenta',
				fieldLabel: 'Código Cuenta',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength: 20
			},
			type: 'TextField',
			filters: { pfiltro: 'cunexc.nro_cuenta', type: 'string'},
			id_grupo: 1,
			grid: true,
			form: true,
			bottom_filter: true
		},
		{
			config: {
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 10
			},
			type:'TextField',
			filters: { pfiltro: 'cunexc.estado_reg', type: 'string' },
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config: {
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer: function (value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type: 'DateField',
			filters: { pfiltro: 'cunexc.fecha_reg', type: 'date' },
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config: {
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 4
			},
			type: 'Field',
			filters: { pfiltro: 'usu1.cuenta', type: 'string' },
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config: {
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 300
			},
			type: 'TextField',
			filters: { pfiltro: 'cunexc.usuario_ai', type: 'string' },
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config: {
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 4
			},
			type: 'Field',
			filters: { pfiltro: 'cunexc.id_usuario_ai', type: 'numeric' },
			id_grupo: 1,
			grid: false,
			form: false
		},
		{
			config: {
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer: function (value, p, record) {
					return value ? value.dateFormat('d/m/Y H:i:s') : ''
				}
			},
			type: 'DateField',
			filters: { pfiltro: 'cunexc.fecha_mod', type: 'date' },
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config: {
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength: 4
			},
			type: 'Field',
			filters: { pfiltro: 'usu2.cuenta', type: 'string' },
			id_grupo: 1,
			grid: true,
			form: false
		}
	],
	tam_pag: 50,
	title: 'Exclusión Cuentas Contables',
	ActSave: '../../sis_proyectos/control/CuentaExcluir/insertarCuentaExcluir',
	ActDel: '../../sis_proyectos/control/CuentaExcluir/eliminarCuentaExcluir',
	ActList: '../../sis_proyectos/control/CuentaExcluir/listarCuentaExcluir',
	id_store: 'id_cuenta_excluir',
	fields: [
		{ name: 'id_cuenta_excluir', type: 'numeric' },
		{ name: 'id_cuenta', type: 'numeric' },
		{ name: 'estado_reg', type: 'string' },
		{ name: 'nro_cuenta', type: 'string' },
		{ name: 'usuario_ai', type: 'string' },
		{ name: 'fecha_reg', type: 'date', dateFormat:'Y-m-d H:i:s.u' },
		{ name: 'id_usuario_reg', type: 'numeric' },
		{ name: 'id_usuario_ai', type: 'numeric' },
		{ name: 'fecha_mod', type: 'date', dateFormat:'Y-m-d H:i:s.u' },
		{ name: 'id_usuario_mod', type: 'numeric' },
		{ name: 'usr_reg', type: 'string' },
		{ name: 'usr_mod', type: 'string' },

	],
	sortInfo:{
		field: 'id_cuenta_excluir',
		direction: 'ASC'
	},
	bdel: true,
	bsave: true
})
</script>

