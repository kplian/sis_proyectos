<?php
/**
*@package pXP
*@file InvitacionLanz.php
*@author  (eddy.gutierrez)
*@date 22-08-2018 22:32:20
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	ISSUE			FECHA		AUTHOR			DESCRIPCION
	#15	ETR			31/07/2019	EGS				creacion 		
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.InvitacionLanz = {
	
	require:'../../../sis_proyectos/vista/invitacion/Invitacion.php',
    requireclase:'Phx.vista.Invitacion',
	constructor:function(config){
		
		this.maestro=config; ///config.maestro quitar para poder recibir datos

		//llama al constructor de la clase padre
		Phx.vista.InvitacionLanz.superclass.constructor.call(this,config);
		this.getBoton('btnRepInvitacion').hide();
        this.getBoton('btnInvLanz').hide();
		///carga el valor por dedfecto como un array en el arreglo de atributos segun posicion
		this.Atributos[1].valorInicial=this.maestro.data.id_proyecto;		
		this.init();
		this.load({params:{start:0, limit:this.tam_pag,id_proyecto:this.maestro.data.id_proyecto , id_invitacion_fk:this.maestro.data.id_invitacion }});

	},
	preparaMenu: function(n) {

		var data = this.getSelectedData();
		var tb = this.tbar;
		Phx.vista.InvitacionLanz.superclass.preparaMenu.call(this, n);
	
			this.getBoton('btnInvLanz').disable();

		return tb
	},

	liberaMenu: function() {
		var tb = Phx.vista.InvitacionLanz.superclass.liberaMenu.call(this);
		if (tb) {
			this.getBoton('btnInvLanz').disable();
          
		}
	
		return tb
	},

        onButtonNew: function(){
			this.insertar = 'nuevo';
			Phx.vista.InvitacionLanz.superclass.onButtonNew.call(this);
		
			this.Cmp.pre_solicitud.setValue(this.maestro.data.pre_solicitud);
			if(this.maestro.data.id_grupo != null ){
			this.Cmp.id_grupo.store.baseParams.query = this.maestro.data.id_grupo;
                                this.Cmp.id_grupo.store.load({params:{start:0,limit:this.tam_pag},
                                   callback : function (r) {                        
                                        if (r.length > 0 ) {                        
                                            
                                           this.Cmp.id_grupo.setValue(r[0].data.id_grupo);
                                        }     
                                                        
                                    }, scope : this
                                });				
				
			}								

			
			this.Cmp.codigo.setValue(this.maestro.data.codigo);
			this.Cmp.tipo.setValue(this.maestro.data.tipo);			
			this.Cmp.id_categoria_compra.store.baseParams.query = this.maestro.data.id_categoria_compra;
                                this.Cmp.id_categoria_compra.store.load({params:{start:0,limit:this.tam_pag},
                                   callback : function (r) {                        
                                        if (r.length > 0 ) {                        
                                            
                                           this.Cmp.id_categoria_compra.setValue(r[0].data.id_categoria_compra);
                                        }     
                                                        
                                    }, scope : this
                                });
 			this.Cmp.id_funcionario.store.baseParams.query = this.maestro.data.id_funcionario;
                                this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag},
                                   callback : function (r) {                        
                                        if (r.length > 0 ) {                        
                                            
                                           this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                                        }     
                                                        
                                    }, scope : this
                                });
			this.Cmp.id_depto.store.baseParams.query = this.maestro.data.id_depto;
                                this.Cmp.id_depto.store.load({params:{start:0,limit:this.tam_pag},
                                   callback : function (r) {                        
                                        if (r.length > 0 ) {                        
                                            
                                           this.Cmp.id_depto.setValue(r[0].data.id_depto);
                                        }     
                                                        
                                    }, scope : this
                                });
			this.Cmp.id_moneda.store.baseParams.query = this.maestro.data.id_moneda;
                                this.Cmp.id_moneda.store.load({params:{start:0,limit:this.tam_pag},
                                   callback : function (r) {                        
                                        if (r.length > 0 ) {                        
                                            
                                           this.Cmp.id_moneda.setValue(r[0].data.id_moneda);
                                        }     
                                                        
                                    }, scope : this
                                });
                                			         			
			this.Cmp.lugar_entrega.setValue(this.maestro.data.lugar_entrega);
			this.Cmp.dias_plazo_entrega.setValue(this.maestro.data.dias_plazo_entrega);
			this.Cmp.descripcion.setValue(this.maestro.data.descripcion);
								
			this.Cmp.codigo.enable(true);
			
			this.Cmp.pre_solicitud.on('change', function(cmp, check){
    		//this.Cmp.pre_solicitud.getValue(); 
    		    if(check.getRawValue() === 'no'){
    		  		this.ocultarComponente(this.Cmp.id_grupo);
     		  		this.mostrarComponente(this.Cmp.id_categoria_compra);
	  				this.Cmp.id_grupo.allowBlank=true;
					this.Cmp.codigo.enable(true);			
	  				this.Cmp.id_categoria_compra.reset();
	  				this.Cmp.id_categoria_compra.allowBlank=false;
    		    }
    		    else{
    		    	this.mostrarComponente(this.Cmp.id_grupo);
    		  		this.ocultarComponente(this.Cmp.id_categoria_compra);
    		    	this.Cmp.id_grupo.allowBlank=false; 		    	
			    	this.Cmp.codigo.disable(true);
	  				this.Cmp.id_categoria_compra.allowBlank=true;

			    }
    		}, this);
    		
    		this.Cmp.id_invitacion_fk.setValue(this.maestro.data.id_invitacion);
    		this.Cmp.codigo.disable(true);
		},

}
</script>
		
		