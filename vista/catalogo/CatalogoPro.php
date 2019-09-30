<?php
/**
 *@package pXP
 *@file ConceptoIngasPro.php
 *@author  (admin)
 *@date 07-03-2019 13:53:18
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * #ISSUE       FECHA       AUTHOR          DESCRIPCION
    #29         18/09/2019  EGS             Creacion
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CatalogoPro={
        require:'../../../sis_parametros/vista/catalogo/Catalogo.php',
        requireclase:'Phx.vista.Catalogo',
        title:'Parametros',
        nombreVista: 'CatalogoPro',
        constructor:function(config){
            this.maestro = config;
            Phx.vista.CatalogoPro.superclass.constructor.call(this,config);
            this.maestro=this;
            this.init();
            this.iniciaEventos();
            this.bloquearMenus();
            //this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista }});

        },
        iniciaEventos : function(){
        },

        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.CatalogoPro.superclass.preparaMenu.call(this,n);
            //this.getBoton('diagrama_gantt').enable();
            return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.CatalogoPro.superclass.liberaMenu.call(this);
            if(tb){
                //this.getBoton('btnChequeoDocumentosWf').disable();

            }
            return tb
        },

        onButtonNew:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            Phx.vista.CatalogoPro.superclass.onButtonNew.call(this);
            this.Cmp.id_subsistema.disable(true);
            this.Cmp.id_subsistema.store.baseParams.query = this.maestro.id_subsistema;
            this.Cmp.id_subsistema.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {
                        this.Cmp.id_subsistema.setValue(this.maestro.id_subsistema);
                    }else{
                        this.Cmp.id_subsistema.reset();
                    }
                }, scope : this
            });
            this.Cmp.id_catalogo_tipo.disable(true);
            this.Cmp.id_catalogo_tipo.store.baseParams.query = this.maestro.id_catalogo_tipo;
            this.Cmp.id_catalogo_tipo.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {
                        this.Cmp.id_catalogo_tipo.setValue(this.maestro.id_catalogo_tipo);
                    }else{
                        this.Cmp.id_catalogo_tipo.reset();
                    }
                }, scope : this
            });

        },
        onButtonEdit:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            Phx.vista.CatalogoPro.superclass.onButtonEdit.call(this);
            this.Cmp.id_subsistema.disable(true);
            this.Cmp.id_subsistema.store.baseParams.query = this.maestro.id_subsistema;
            this.Cmp.id_subsistema.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {
                        this.Cmp.id_subsistema.setValue(this.maestro.id_subsistema);
                    }else{
                        this.Cmp.id_subsistema.reset();
                    }
                }, scope : this
            });
            this.Cmp.id_catalogo_tipo.disable(true);
            this.Cmp.id_catalogo_tipo.store.baseParams.query = this.maestro.id_catalogo_tipo;
            this.Cmp.id_catalogo_tipo.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {
                        this.Cmp.id_catalogo_tipo.setValue(this.maestro.id_catalogo_tipo);
                    }else{
                        this.Cmp.id_catalogo_tipo.reset();
                    }
                }, scope : this
            });
        },
        onReloadPage: function(m) {
            this.maestro = m;

            //Filtro para los datos
            this.store.baseParams = {
                id_catalogo_tipo: this.maestro.id_catalogo_tipo
            };
            this.load({ params: {start: 0,limit: 50 }});
        },

    }
</script>
