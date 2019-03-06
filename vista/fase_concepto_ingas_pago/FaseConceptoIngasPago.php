<?php
/**
*@package pXP
*@file gen-FaseConceptoIngasPago.php
*@author  (eddy.gutierrez)
*@date 14-12-2018 13:31:35
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	ISSUE FORK			FECHA		AUTHOR			DESCRIPCION
 	#5	  endeETR		09/01/2019	EGS				Se agrego totalizadores dE IMPORTE
 *  #7	  endeETR		20/02/2019	EGS				se modifico funcion sucesave 
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.FaseConceptoIngasPago=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
	    var	estado_proyecto;
		var precio_maestro;
    	//llama al constructor de la clase padre
		Phx.vista.FaseConceptoIngasPago.superclass.constructor.call(this,config);
		this.init();
		//this.load({params:{start:0, limit:this.tam_pag}})
		this.bloquearMenus();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_fase_concepto_ingas_pago'
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
				name: 'fecha_pago',
				fieldLabel: 'Fecha Pago',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'facoinpa.fecha_pago',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		
		{
			config:{
				name: 'importe',
				fieldLabel: 'Importe',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				galign: 'right ',
				maxLength:1179650,
				allowNegative:false,				
				renderer:function (value,p,record){
					console.log('record',record)
						if(record.json.tipo_reg != 'summary'){//#5
							return  String.format('{0}',  Ext.util.Format.number(value,'000.000.000,00/i'));
						}
						else{
							///si es igual el precio del item al plan de pagos se vuelve blanco si no en rojo
							if (value != record.json.precio_item) {
								Ext.util.Format.usMoney
								return  String.format('<b><font size=3 style="color:#FF1700";>{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));
							} else{
								Ext.util.Format.usMoney
								return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,00/i'));
							};

						}	
				}	
			},
				type:'MoneyField',
				filters:{pfiltro:'facoinpa.importe',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},

		{
			config:{
				name: 'fecha_pago_real',
				fieldLabel: 'Fecha Pago Real',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'facoinpa.fecha_pago_real',type:'date'},
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
				filters:{pfiltro:'facoinpa.estado_reg',type:'string'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'facoinpa.id_usuario_ai',type:'numeric'},
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
				grid:false,
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
				filters:{pfiltro:'facoinpa.usuario_ai',type:'string'},
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
				filters:{pfiltro:'facoinpa.fecha_reg',type:'date'},
				id_grupo:1,
				grid:false,
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
				grid:false,
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
				filters:{pfiltro:'facoinpa.fecha_mod',type:'date'},
				id_grupo:1,
				grid:false,
				form:false
		}
	],
	tam_pag:50,	
	title:'Estimacion Plan de Pagos',
	ActSave:'../../sis_proyectos/control/FaseConceptoIngasPago/insertarFaseConceptoIngasPago',
	ActDel:'../../sis_proyectos/control/FaseConceptoIngasPago/eliminarFaseConceptoIngasPago',
	ActList:'../../sis_proyectos/control/FaseConceptoIngasPago/listarFaseConceptoIngasPago',
	id_store:'id_fase_concepto_ingas_pago',
	fields: [
		{name:'id_fase_concepto_ingas_pago', type: 'numeric'},
		{name:'id_fase_concepto_ingas', type: 'numeric'},
		{name:'importe', type: 'numeric'},
		{name:'fecha_pago', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_pago_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_fase_concepto_ingas_pago',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	onReloadPage: function (m) {
		//alert ('asda');
            this.maestro = m;
            console.log('maestro',this.maestro.precio);
            this.precio_maestro = this.maestro.precio;
            //this.Atributos[1].valorInicial = this.maestro.id_fase_concepto_ingas;
			this.Atributos[this.getIndAtributo('id_fase_concepto_ingas')].valorInicial = this.maestro.id_fase_concepto_ingas;
			this.estado_proyecto = this.maestro.estado_proyecto;
            this.store.baseParams = {id_fase_concepto_ingas: this.maestro.id_fase_concepto_ingas};
            this.load({params: {start: 0, limit: 50}})
       },
       
     preparaMenu: function(n){

		var tb = Phx.vista.FaseConceptoIngas.superclass.preparaMenu.call(this);
		var data = this.getSelectedData();
	
		console.log('estado_proyecto',this.estado_proyecto );
		if (tb && this.bnew && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado' )) {
            tb.items.get('b-new-' + this.idContenedor).disable();
            }
		if (tb && this.bedit && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado' )) {
            tb.items.get('b-edit-' + this.idContenedor).disable();
            }
         if (tb && this.bdel && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado' )) {
            tb.items.get('b-del-' + this.idContenedor).disable();
            }
 
		return tb;
	},
	 //al eliminar un elemento actualiza el padre
	onButtonDel:function(){
			Phx.vista.FaseConceptoIngasPago.superclass.onButtonDel.call(this);
			 Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
	
	},
	 //al crear o editar un elemento actualiza el padre
	successSave:function(resp)//#7
        {	console.log('resp',resp);
            Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            //this.window.hide();///cierra el panel del formulario
        if(resp.argument && resp.argument.news){
			if(resp.argument.def == 'reset'){
			  //this.form.getForm().reset();
			  this.onButtonNew();
			}			
		}
		else{
			this.window.hide();
		}

		this.reload();    
            
        },	
})
</script>
		
		