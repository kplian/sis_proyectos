<?php
/**
 *@package pXP
 *@file AgregarAgrupador.php
 *@author  (eddy.gutierrez)
 *@date 22-08-2018 22:32:59
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.AgregarAgrupador=Ext.extend(Phx.frmInterfaz,{
        breset: true,
        bcancel: true,


        constructor:function(config){
            this.maestro=config;
            //llama al constructor de la clase padre
            console.log('config',config);
            this.Atributos[this.getIndAtributo('id_concepto_ingas')].valorInicial = this.maestro.id_concepto_ingas;
            Phx.vista.AgregarAgrupador.superclass.constructor.call(this,config);
            this.init();
            this.iniciarEventos();
        },
        onReset:function(){
            this.form.getForm().reset();
            this.loadValoresIniciales();
            this.iniciarEventos();
        },

        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_concepto_ingas'
                },
                type:'Field',
                form:true
            },
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
                        fields: ['id_concepto_ingas_agrupador', 'nombre','tipo_agrupador'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'coinagr.id_concepto_ingas_agrupador#coinagr.nombre',start:0, limit:50}
                    }),
                    tpl:'<tpl for=".">\ <div class="x-combo-list-item"><p><b>Nombre: </b>{nombre}</p>\
                                <p><b>Tipo: </b>{tipo_agrupador}</p>\
                               </div></tpl>',
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
                        return String.format('{0}', record.data['nombre']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'movtip.nombre',type: 'string'},
                grid: true,
                form: true
            },


        ],
        tam_pag:50,

        ActSave:'../../sis_parametros/control/ConceptoIngasAgrupador/insertarAgrupador',
        bdel:true,
        bsave:true,
        bedit:false,


        iniciarEventos: function(){
            console.log('maestro',this.maestro);
            this.Cmp.id_concepto_ingas_agrupador.store.baseParams.query = this.maestro.id_concepto_ingas_agrupador;
            this.Cmp.id_concepto_ingas_agrupador.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    if (r.length > 0 ) {
                        this.Cmp.id_concepto_ingas_agrupador.setValue(this.maestro.id_concepto_ingas_agrupador);
                    }else{
                        this.Cmp.id_concepto_ingas_agrupador.reset();
                    }
                }, scope : this
            });
        },

        successSave:function(resp)
        {
            Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            this.panel.close();
        },
    })
</script>

