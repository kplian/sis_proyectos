<?php
/**
*@package pXP
*@file gen-FaseAvanceObs.php
*@author  (rchumacero)
*@date 15-10-2018 19:59:14
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FaseAvanceObs=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.FaseAvanceObs.superclass.constructor.call(this,config);
		this.init();

		var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        } else {
           this.bloquearMenus();
        }
	},

	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase_avance_obs'
			},
			type:'Field',
			form:true
		},
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
			config:{
				name: 'tipo',
				fieldLabel: 'Tipo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 90,
				maxLength:15,
				disabled: true
			},
			type:'TextField',
			filters:{pfiltro:'faavob.tipo',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha',
				fieldLabel: 'Fecha',
				allowBlank: true,
				anchor: '80%',
				gwidth: 80,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'faavob.fecha',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'porcentaje',
				fieldLabel: 'Porcentaje',
				allowBlank: true,
				anchor: '30%',
				gwidth: 100,
				maxValue: 100,
				minValue: 0
			},
			type:'NumberField',
			filters:{pfiltro:'faavob.porcentaje',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'observaciones',
				fieldLabel: 'Observaciones',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:5000
			},
			type:'TextArea',
			filters:{pfiltro:'faavob.observaciones',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'faavob.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: '',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'faavob.id_usuario_ai',type:'numeric'},
			id_grupo:1,
			grid:false,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
			type:'TextField',
			filters:{pfiltro:'faavob.usuario_ai',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'faavob.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				format: 'd/m/Y',
				renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'faavob.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	tam_pag:50,
	title:'Avance Visual',
	ActSave:'../../sis_proyectos/control/FaseAvanceObs/insertarFaseAvanceObs',
	ActDel:'../../sis_proyectos/control/FaseAvanceObs/eliminarFaseAvanceObs',
	ActList:'../../sis_proyectos/control/FaseAvanceObs/listarFaseAvanceObs',
	id_store:'id_fase_avance_obs',
	fields: [
		{name:'id_fase_avance_obs', type: 'numeric'},
		{name:'id_fase', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'observaciones', type: 'string'},
		{name:'porcentaje', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'tipo', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_proyecto', type: 'numeric'}
	],
	sortInfo:{
		field: 'fecha',
		direction: 'DESC'
	},
	bdel:true,
	bsave:true,
	onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[this.getIndAtributo('id_fase')].valorInicial = this.maestro.id_fase;
        this.Atributos[this.getIndAtributo('tipo')].valorInicial = this.tipo;

        //Filtro para los datos
        this.store.baseParams = {
            id_fase: this.maestro.id_fase,
            tipo: this.tipo
        };

        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });
    }

})
</script>