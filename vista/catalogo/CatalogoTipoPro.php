<?php
/**
 *@package pXP
 *@file ConceptoIngasPro.php
 *@author  (admin)
 *@date 07-03-2019 13:53:18
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *  #ISSUE       FECHA       AUTHOR          DESCRIPCION
    #29         18/09/2019  EGS             Creacion
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CatalogoTipoPro={
        require:'../../../sis_parametros/vista/catalogo_tipo/CatalogoTipo.php',
        requireclase:'Phx.vista.CatalogoTipo',
        title:'Parametros',
        nombreVista: 'CatalogoTipoPro',
        constructor:function(config){
            this.maestro = config;
            let subsistema;
            Phx.vista.CatalogoTipoPro.superclass.constructor.call(this,config);
            console.log('this',this);
            this.maestro=this;
            this.obtenerSubsistema();
            this.init();
            this.iniciaEventos();


        },
        iniciaEventos : function(){
        },
        obtenerSubsistema:function(){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_seguridad/control/Subsistema/listarSubsistema',
                params:{
                    codigo: 'PRO',
                    start:0,
                    limit:50
                },
                success: function(resp){
                    Phx.CP.loadingHide();
                    var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                        this.subsistema=reg.datos[0]['id_subsistema'];
                        this.store.baseParams={id_subsistema:reg.datos[0]['id_subsistema']};
                        this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista }});
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope:this
            });
        },

        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.CatalogoTipoPro.superclass.preparaMenu.call(this,n);
            //this.getBoton('diagrama_gantt').enable();
            return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.CatalogoTipoPro.superclass.liberaMenu.call(this);
            if(tb){
                //this.getBoton('btnChequeoDocumentosWf').disable();

            }
            return tb
        },

        onButtonNew:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            Phx.vista.CatalogoTipoPro.superclass.onButtonNew.call(this);
            console.log('s',this.subsistema);
            this.Cmp.id_subsistema.disable(true);
            this.Cmp.id_subsistema.store.baseParams.query = this.subsistema;
            this.Cmp.id_subsistema.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {
                        this.Cmp.id_subsistema.setValue(this.subsistema);
                    }else{
                        this.Cmp.id_subsistema.reset();
                    }
                }, scope : this
            });


        },
        onButtonEdit:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            Phx.vista.CatalogoTipoPro.superclass.onButtonEdit.call(this);
            console.log('s',this.subsistema);
            this.Cmp.id_subsistema.disable(true);
            this.Cmp.id_subsistema.store.baseParams.query = this.subsistema;
            this.Cmp.id_subsistema.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {
                        this.Cmp.id_subsistema.setValue(this.subsistema);
                    }else{
                        this.Cmp.id_subsistema.reset();
                    }
                }, scope : this
            });
        },
        tabsouth: [{
            url: '../../../sis_proyectos/vista/catalogo/CatalogoPro.php',
            title: 'Registro',
            height: '40%',
            cls: 'CatalogoPro'
        }],
    }
</script>
