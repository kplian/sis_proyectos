<?php
/**
 *@package pXP
 *@file gen-InvitacionDet.php
 *@author  (eddy.gutierrez)
 *@date 22-08-2018 22:32:59
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
ISSUE		FECHA		AUTHOR			DESCRIPCION
#6	EndeEtr 24/01/2019	 EGS		    Se hace validacion paa que la invitacion tenga fecha al querer añadir un detalle
#7	EndeEtr 04/02/2019	 EGS		    Se hace validacion para que no guarde en estado de sol_compra
#8	EndeEtr 18/03/2019	 EGS		    se fuerza a escoger centro de costo
#15 EndeEtr	31/07/2019	 EGS			reestrctura de los archivos
 * */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.InvitacionDet = {
        nombreVista:'Invitacion',
        require:'../../../sis_proyectos/vista/invitacion_det/InvitacionDetBase.php',
        requireclase:'Phx.vista.InvitacionDetBase',
        constructor:function(config){
            this.maestro=config.maestro;
            var v_fecha = null;
            var estado_proyecto;
            var estado_invitacion;
            var id_tipo_cc;
            //llama al constructor de la clase padre
            Phx.vista.InvitacionDet.superclass.constructor.call(this,config);
            this.init();
            //this.load({params:{start:0, limit:this.tam_pag}})
            this.iniciarEventos();
            this.iniciar();
            this.bloquearMenus();

        },
        onReloadPage: function(m) {
            this.maestro = m;
            this.obtenerProyecto(this.maestro);
            this.estado_invitacion = this.maestro.estado;
            this.Atributos[this.getIndAtributo('id_invitacion')].valorInicial = this.maestro.id_invitacion;
            //Filtro para los datos

            this.setColumnHeader('precio','(e)'+this.cmpPrecio.fieldLabel +' '+ this.maestro.desc_moneda)
            this.setColumnHeader('precio_t',this.cmpPrecioT.fieldLabel +' '+ this.maestro.desc_moneda)
            //this.setColumnHeader('precio_est',this.cmpPrecioEst.fieldLabel +' '+ this.maestro.desc_moneda)

            this.store.baseParams = {
                id_invitacion: this.maestro.id_invitacion
            };
            this.load({ params: {start: 0,limit: 50 }});
        },

        obtenerProyecto: function(config){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_proyectos/control/Proyecto/listarProyecto',
                params:{
                    id_proyecto: config.id_proyecto,
                },
                success: function(resp){
                    Phx.CP.loadingHide();
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

                    this.estado_proyecto =reg.datos[0]['estado'];
                    this.id_tipo_cc =reg.datos[0]['id_tipo_cc'];

                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });

        },

        onButtonNew: function(){
            Phx.vista.InvitacionDet.superclass.onButtonNew.call(this);

            if(this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado')
            {
                alert ('El proyecto se encuentra en estado de ' + this.estado_proyecto);
            }
            else{
            this.iniciarEventos();
            }

        },

        iniciar:function(){


            ///Carga la columna de la grilla de combo remoto que tiene egrid
            this.Cmp.id_unidad_medida.store.baseParams.query = this.Cmp.id_unidad_medida.getValue();
            this.Cmp.id_unidad_medida.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {

                        this.Cmp.id_unidad_medida.setValue(r[0].data.id_unidad_medida);
                    }

                }, scope : this
            });



        },

        iniciarEventos: function(){
            this.cmpPrecio = this.getComponente('precio');
            this.cmpPrecioT = this.getComponente('precio_t');
            //this.cmpPrecioEst = this.getComponente('precio_est');
            //this.Cmp.id_invitacion.setValue(this.maestro.data.id_invitacion);
            //this.cmpIdUnMe = this.getComponente('id_unidad_medida');
            this.mostrarComponente(this.Cmp.invitacion_det__tipo);

            this.ocultarComponente(this.Cmp.id_concepto_ingas);

            this.ocultarComponente(this.Cmp.id_fase);

            this.ocultarComponente(this.Cmp.id_fase_concepto_ingas);
            this.ocultarComponente(this.Cmp.observaciones);
            this.ocultarComponente(this.Cmp.id_unidad_medida);

            this.ocultarComponente(this.Cmp.cantidad_sol);
            this.ocultarComponente(this.Cmp.precio);
            this.ocultarComponente(this.Cmp.precio_t);
            this.ocultarComponente(this.Cmp.precio_est);
            this.ocultarComponente(this.Cmp.id_centro_costo);
            this.ocultarComponente(this.Cmp.descripcion);
            this.ocultarComponente(this.Cmp.codigo);
            this.ocultarComponente(this.Cmp.id_unidad_constructiva);

            this.Cmp.invitacion_det__tipo.on('select',function(combo,record,index){
                //if(record.data.ID == 'planif' ){
                if(record.data.codigo === 'planif' ){

                    this.Cmp.id_fase_concepto_ingas.reset();
                    this.Cmp.observaciones.reset();
                    this.Cmp.id_unidad_medida.reset();
                    this.Cmp.cantidad_sol.reset();
                    this.Cmp.precio.reset();
                    this.Cmp.id_concepto_ingas.reset();
                    this.Cmp.id_fase.reset();
                    this.Cmp.id_unidad_constructiva.reset();

                    this.ocultarComponente(this.Cmp.id_concepto_ingas);
                    this.ocultarComponente(this.Cmp.id_fase);
                    this.Cmp.id_concepto_ingas.allowBlank=true;
                    this.Cmp.id_fase.allowBlank=true;
                    this.mostrarComponente(this.Cmp.id_fase_concepto_ingas);
                    this.mostrarComponente(this.Cmp.observaciones);
                    this.mostrarComponente(this.Cmp.id_unidad_medida);
                    this.mostrarComponente(this.Cmp.cantidad_sol);
                    this.mostrarComponente(this.Cmp.precio);

                    this.mostrarComponente(this.Cmp.id_centro_costo);
                    this.mostrarComponente(this.Cmp.descripcion);
                    this.mostrarComponente(this.Cmp.id_unidad_constructiva);

                    ///el parametro invitacion : 'no' hace que devuelva aquellos fase concepto de gasto que no esten en una invitacion
                    this.Cmp.id_fase_concepto_ingas.store.baseParams.tipo = this.maestro.tipo ;
                    this.Cmp.id_fase_concepto_ingas.store.baseParams.id_proyecto = this.maestro.id_proyecto;
                    //this.Cmp.id_fase_concepto_ingas.store.baseParams.invitacion = 'no';


                    this.Cmp.id_concepto_ingas.store.baseParams.tipo= this.maestro.tipo;

                    this.Cmp.id_centro_costo.store.baseParams.id_gestion=this.maestro.id_gestion;

                    this.Cmp.id_centro_costo.store.baseParams.id_tipo_cc = this.id_tipo_cc ;



                    this.Cmp.id_fase_concepto_ingas.on('select', function(cmb,rec,i){

                        ////se aumento filtro para el controlador de ACTUnidadMedida.php en sis parametros

                        this.Cmp.id_fase.setValue(rec.data.id_fase);
                        this.Cmp.id_concepto_ingas.setValue(rec.data.id_concepto_ingas);

                        this.Cmp.id_unidad_medida.store.baseParams.query = rec.data.id_unidad_medida;
                        this.Cmp.id_unidad_medida.store.load({params:{start:0,limit:this.tam_pag},
                            callback : function (r) {
                                if (r.length > 0 ) {

                                    this.Cmp.id_unidad_medida.setValue(r[0].data.id_unidad_medida);
                                }

                            }, scope : this
                        });
                        this.Cmp.id_unidad_constructiva.store.baseParams.activo = 'si';
                        this.Cmp.id_unidad_constructiva.store.baseParams.id_proyecto = this.maestro.id_proyecto;
                        this.Cmp.id_unidad_constructiva.store.load({params:{start:0,limit:this.tam_pag},
                            callback : function (r) {
                                if (r.length > 0 ) {

                                    this.Cmp.id_unidad_constructiva.setValue(r[0].data.id_unidad_constructiva);
                                }

                            }, scope : this
                        });

                    } ,this);
                    this.Cmp.cantidad_sol.allowBlank=true;
                    this.Cmp.precio.allowBlank=true;
                    this.Cmp.codigo.allowBlank=false;//#9
                } else{
                    this.Cmp.id_fase_concepto_ingas.reset();
                    this.Cmp.observaciones.reset();
                    this.Cmp.id_unidad_medida.reset();
                    this.Cmp.cantidad_sol.reset();
                    this.Cmp.precio.reset();
                    this.Cmp.id_concepto_ingas.reset();
                    this.Cmp.id_fase.reset();
                    this.Cmp.id_unidad_constructiva.reset();

                    this.mostrarComponente(this.Cmp.id_concepto_ingas);
                    this.mostrarComponente(this.Cmp.id_fase);
                    this.ocultarComponente(this.Cmp.id_fase_concepto_ingas);
                    this.Cmp.id_fase_concepto_ingas.allowBlank=true;

                    this.mostrarComponente(this.Cmp.observaciones);
                    this.mostrarComponente(this.Cmp.id_unidad_medida);
                    this.mostrarComponente(this.Cmp.cantidad_sol);
                    this.mostrarComponente(this.Cmp.precio);

                    this.mostrarComponente(this.Cmp.id_centro_costo);
                    this.mostrarComponente(this.Cmp.descripcion);

                    this.Cmp.id_fase.store.baseParams={id_proyecto:this.maestro.id_proyecto};
                    this.Cmp.id_centro_costo.store.baseParams.id_gestion=this.maestro.id_gestion;
                    this.Cmp.id_centro_costo.store.baseParams.id_tipo_cc = this.id_tipo_cc ;
                    this.Cmp.id_concepto_ingas.store.baseParams.tipo= this.maestro.tipo;
                    this.Cmp.cantidad_sol.allowBlank=false;
                    this.Cmp.precio.allowBlank=false;
                    this.mostrarComponente(this.Cmp.codigo);
                    this.mostrarComponente(this.Cmp.id_unidad_constructiva);
                    
                    this.Cmp.id_concepto_ingas.on('select', function(cmb,rec,i){
                        this.Cmp.id_unidad_constructiva.reset();
                        this.Cmp.id_unidad_constructiva.store.baseParams.id_concepto_ingas = rec.data.id_concepto_ingas;
                        this.Cmp.id_unidad_constructiva.store.baseParams.id_proyecto = this.maestro.id_proyecto;
                        this.Cmp.id_unidad_constructiva.store.load({params:{start:0,limit:this.tam_pag},
                            callback : function (r) {
                                if (r.length > 0 ) {

                                    this.Cmp.id_unidad_constructiva.setValue(r[0].data.id_unidad_constructiva);
                                }
                                else{
                                    this.Cmp.id_unidad_constructiva.reset();

                                }

                            }, scope : this
                        });

                    } ,this);


                }



            },this);
        },


        preparaMenu: function(n){

            var tb = Phx.vista.InvitacionDet.superclass.preparaMenu.call(this);
            var data = this.getSelectedData();

            if (tb && this.bnew && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado' || this.estado_invitacion == 'sol_compra')) {
                tb.items.get('b-new-' + this.idContenedor).disable();
            }
            if (tb && this.bedit && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado'  || this.estado_invitacion == 'sol_compra')) {
                tb.items.get('b-edit-' + this.idContenedor).disable();
            }
            if (tb && this.bdel && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado'  || this.estado_invitacion == 'sol_compra')) {
                tb.items.get('b-del-' + this.idContenedor).disable();
            }
            //#7
            if (tb && this.bsave && (this.estado_proyecto == 'cierre' || this.estado_proyecto == 'finalizado'  || this.estado_invitacion == 'sol_compra')) {
                tb.items.get('b-save-' + this.idContenedor).disable();
            }//#7
            return tb;
        },


    }
</script>

S