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
    Phx.vista.ConceptoIngasAgrPro={
        require:'../../../sis_parametros/vista/concepto_ingas_agrupador/ConceptoIngasAgrupador.php',
        requireclase:'Phx.vista.ConceptoIngasAgrupador',
        title:'Agrupador Concepto Ingreso/Gasto',
        nombreVista: 'ConceptoIngasAgrPro',
        constructor:function(config){

            this.maestro = config;
            this.unirAtributos(); //ejecutamos primero para que los atributos extra se carguen y visualizaen
            Phx.vista.ConceptoIngasAgrPro.superclass.constructor.call(this,config);
            this.maestro=this;
            this.init();
            this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista }});
            this.iniciaEventos();
        },
         iniciaEventos : function(){
        },
        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.ConceptoIngasAgrPro.superclass.preparaMenu.call(this,n);
            //this.getBoton('diagrama_gantt').enable();
            return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.ConceptoIngasAgrPro.superclass.liberaMenu.call(this);
            if(tb){
                //this.getBoton('btnChequeoDocumentosWf').disable();

            }
            return tb
        },

        onButtonNew:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            //this.ocultarComponente(this.Cmp.fecha_ini);
            Phx.vista.ConceptoIngasAgrPro.superclass.onButtonNew.call(this);
        },
        unirAtributos: function (){
            var me = this;
            this.Atributos = this.Atributos.concat(me.extraAtributos);
            this.fields = this.fields.concat(me.extraFields);
        },

        extraAtributos:[
            {//#22
                config: {
                    name: 'tipo_agrupador',
                    fieldLabel: 'Tipo',
                    anchor: '95%',
                    tinit: false,
                    allowBlank: true,
                    origen: 'CATALOGO',
                    gdisplayField: 'tipo_agrupador',
                    hiddenName: 'tipo_agrupador',
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:150,
                    baseParams:{
                        cod_subsistema:'PRO',
                        catalogo_tipo:'tcomponente_macro_tipo'
                    },
                    valueField: 'codigo',
                    hidden: false,
                    renderer: function(value, p, record) {
                        return String.format('{0}', record.data['tipo_agrupador']);
                    },
                },
                type: 'ComboRec',
                id_grupo: 0,
                grid: true,
                form: true
            },
        ],

        extraFields:[
            {name:'tipo_agrupador', type: 'string'},
        ],
        arrayDefaultColumHidden:['fecha_mod','usr_reg','usr_mod','estado_reg','fecha_reg','id_usuario_ai','usuario_ai'],
    }
</script>
