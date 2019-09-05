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
            this.unirAtributos(); //ejecutamos primero para que los atributos extra se carguen y visualizaen
            //llama al constructor de la clase padre
            Phx.vista.ConceptoIngasPro.superclass.constructor.call(this,config);
            //ocultar botones
            this.getBoton('inserOT').hide();
            this.getBoton('inserAuto').hide();
            this.getBoton('addImagen').hide();
            this.init();
            this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista }});
            this.iniciarEventos();
            this.addButton('btnAgrup', {
                text : 'Agrupadores',
                iconCls : 'bexecdb',
                disabled : false,
                handler : this.cigAgr,
                tooltip : '<b>Componentes'
            });

        },
        cigAgr: function(){//#
            var data = this.getSelectedData();
            var win = Phx.CP.loadWindows(
                '../../../sis_proyectos/vista/componente_concepto_ingas/ConceptoIngasAgrPro.php',
                'Agrupadores de Concepto ingreso/gasto', {
                    width: '95%',
                    height: '90%'
                },
                this.maestro,
                this.idContenedor,
                'ConceptoIngasAgrPro'
            );
        },
        bedit:true,
        bnew:false,
        bdel:false,
        bsave:false,
        inciarEventos: function (){

        },
        onButtonEdit:function(){
            var data = this.getSelectedData();
            this.formEdit(data);
        },
        formEdit: function(data){
                var win = Phx.CP.loadWindows(
                    '../../../sis_proyectos/vista/componente_concepto_ingas/AgregarAgrupador.php',
                    'Editar', {
                        width: '30%',
                        height: '20%'
                    },
                    data,
                    this.idContenedor,
                    'AgregarAgrupador'//clase de la vista
                );
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
        },/*
        tabeast: [
            {
                url:'../../../sis_proyectos/vista/componente_concepto_ingas_det/ConceptoIngasDetAgrPro.php',
                title:'Agrupadores Detalle Conceptos Ingreso/Gasto',
                width:'50%',
                height:'50%',
                cls:'ConceptoIngasDetAgrPro'
            }],*/
        tabsouth: [
            {
                url:'../../../sis_proyectos/vista/componente_concepto_ingas_det/ConceptoIngasDetPro.php',
                title:'Lista de Detalles Conceptos Ingreso/Gasto',
                width:'50%',
                height:'50%',
                cls:'ConceptoIngasDetPro'
            }],

        unirAtributos: function (){
            var me = this;
            this.Atributos = this.Atributos.concat(me.extraAtributos);
            this.fields = this.fields.concat(me.extraFields);
        },

        extraAtributos:[
            {
                config: {
                    name: 'id_concepto_ingas_agrupador',
                    fieldLabel: 'Agrupador',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/ConceptoIngasAgrupador/listarConceptoIngasAgrupador',
                        id: 'id_concepto_ingas_agrupador',
                        root: 'datos',
                        sortInfo: {
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_concepto_ingas_agrupador', 'nombre'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'coinagr.id_concepto_ingas_agrupador#',start:0, limit:50 }
                    }),
                    valueField: 'id_concepto_ingas_agrupador',
                    displayField: 'nombre',
                    gdisplayField: 'nombre',
                    hiddenName: 'id_concepto_ingas_agrupador',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '100%',
                    gwidth: 150,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['id_concepto_ingas_agrupador']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                grid: true,
                form: true
            },
        ],

        extraFields:[
            {name:'id_concepto_ingas_agrupador', type: 'string'},
        ],
    }
</script>

