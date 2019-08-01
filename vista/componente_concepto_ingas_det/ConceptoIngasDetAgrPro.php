<?php
/**
 *@package pXP
 *@file ConceptoIngasPro.php
 *@author  (admin)
 *@date 07-03-2019 13:53:18
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConceptoIngasDetAgrPro={
        require:'../../../sis_parametros/vista/concepto_ingas_det/ConceptoIngasDet.php',
        requireclase:'Phx.vista.ConceptoIngasDet',
        title:'Concepto Ingreso/Gasto Det',
        nombreVista: 'ConceptoIngasDetAgrPro',
        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            this.Atributos[this.getIndAtributo('id_concepto_ingas_det_fk')].grid=false;
            Phx.vista.ConceptoIngasDetAgrPro.superclass.constructor.call(this,config);

            this.init();
            this.bloquearMenus();
            this.iniciaEventos();
        },
        iniciaEventos : function(){
          this.ocultarComponente(this.Cmp.id_concepto_ingas_det_fk);
        },
        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.ConceptoIngasDetAgrPro.superclass.preparaMenu.call(this,n);
            //this.getBoton('diagrama_gantt').enable();
            return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.ConceptoIngasDetAgrPro.superclass.liberaMenu.call(this);
            if(tb){
                //this.getBoton('btnChequeoDocumentosWf').disable();

            }
            return tb
        },
        onReloadPage: function (m) {
            this.maestro = m;
            this.Atributos[this.getIndAtributo('id_concepto_ingas')].valorInicial = this.maestro.id_concepto_ingas;
            this.load({params: {start: 0, limit: 50, nombreVista:this.nombreVista, id_concepto_ingas: this.maestro.id_concepto_ingas,agrupador:'si'}});

        },
        onButtonNew:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            //this.ocultarComponente(this.Cmp.fecha_ini);
            Phx.vista.ConceptoIngasDetAgrPro.superclass.onButtonNew.call(this);
            this.Cmp.agrupador.setValue('si');
        },

    }
</script>
