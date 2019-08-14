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
    Phx.vista.ConceptoIngasPro={
        require:'../../../sis_parametros/vista/concepto_ingas/ConceptoIngas.php',
        requireclase:'Phx.vista.ConceptoIngas',
        title:'Concepto Ingreso/Gasto',
        nombreVista: 'conceptoIngasPro',
        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.ConceptoIngasPro.superclass.constructor.call(this,config);
            //ocultar botones
            this.getBoton('inserOT').hide();
            this.getBoton('inserAuto').hide();
            this.getBoton('addImagen').hide();
            this.init();
            this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista }});
            this.iniciarEventos();

        },
        bedit:false,
        bnew:false,
        bdel:false,
        bsave:false,
        inciarEventos: function (){

        },
        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.ConceptoIngasPro.superclass.preparaMenu.call(this,n);
            //this.getBoton('diagrama_gantt').enable();
             return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.ConceptoIngasPro.superclass.liberaMenu.call(this);
            if(tb){
                //this.getBoton('btnChequeoDocumentosWf').disable();

            }
            return tb
        },
        tabeast: [
            {
                url:'../../../sis_proyectos/vista/componente_concepto_ingas_det/ConceptoIngasDetAgrPro.php',
                title:'Agrupadores Detalle Conceptos Ingreso/Gasto',
                width:'50%',
                height:'50%',
                cls:'ConceptoIngasDetAgrPro'
            }],
        tabsouth: [
            {
                url:'../../../sis_proyectos/vista/componente_concepto_ingas_det/ConceptoIngasDetPro.php',
                title:'Lista de Detalles Conceptos Ingreso/Gasto',
                width:'50%',
                height:'50%',
                cls:'ConceptoIngasDetPro'
            }],
    }
</script>

