<?php
/**
 *@package pXP
 *@file gen-ComponenteConceptoIngas.php
 *@author  (admin)
 *@date 22-07-2019 14:49:24
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ComponenteConceptoIngas=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.ComponenteConceptoIngas.superclass.constructor.call(this,config);
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
                        name: 'id_componente_concepto_ingas'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_proyecto'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config: {
                        name: 'id_concepto_ingas_agrupador',
                        fieldLabel: 'Tipo',
                        allowBlank: false,
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
                        },
                        listeners: {
                            'afterrender': function(combo){
                            },
                            'expand':function (combo) {
                                this.store.reload();
                            }
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'movtip.nombre',type: 'string'},
                    grid: false,
                    form: true
                },

                {
                    config:{
                        name: 'id_concepto_ingas',
                        fieldLabel: 'Concepto de Gasto',
                        allowBlank: false,
                        emptyText: 'Concepto...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngas',
                            id : 'id_concepto_ingas',
                            root: 'datos',
                            sortInfo:{
                                field: 'desc_ingas',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot','desc_gestion'],
                            remoteSort: true,
                            baseParams: { par_filtro: 'desc_ingas#par.codigo',movimiento:'gasto',start:0, limit:50}//, autorizacion: 'viatico'}
                        }),
                        tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Concepto de Gasto: </b>{desc_ingas}</p>\
		                       <p><b>Movimiento:</b>{movimiento}</p>\</div></tpl>',
                        valueField: 'id_concepto_ingas',
                        displayField: 'desc_ingas',
                        gdisplayField: 'desc_ingas',
                        hiddenName: 'id_concepto_ingas',
                        forceSelection:true,
                        typeAhead: false,
                        triggerAction: 'all',
                        listWidth:500,
                        resizable:true,
                        lazyRender:true,
                        mode:'remote',
                        pageSize:10,
                        queryDelay:1000,
                        width: 250,
                        gwidth:250,
                        minChars:2,
                        anchor:'100%',
                        qtip:'Si el concepto de gasto que necesita no existe por favor comuníquese con el área de presupuestos para solicitar la creación.',
                        //tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p></div></tpl>',
                        renderer:function(value, p, record){
                            return String.format('{0}', record.data['desc_ingas']);
                        }
                    },
                    type:'ComboBox',
                    bottom_filter: true,
                    filters:{pfiltro:'cig.desc_ingas',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'precio_total_det',
                        fieldLabel: 'Precio Total',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:10,
                        galign: 'right ',
                    },
                    type:'NumberField',
                    id_grupo:1,
                    grid:true,
                    form:false
                },

                {
                    config: {
                        name: 'aislacion',
                        fieldLabel: 'Aislacion',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/ColumnaConceptoIngasDet/listarColumnaConceptoIngasDetCombo',
                            id: 'id',
                            root: 'datos',
                            sortInfo: {
                                field: 'valor',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id', 'valor'],
                            remoteSort: true,
                            baseParams: {par_filtro: '#v.valor',columna:'aislacion'}
                        }),
                        valueField: 'valor',
                        displayField: 'valor',
                        gdisplayField: 'valor',
                        hiddenName: 'valor',
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
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    grid: false,
                    form: true
                },
                {
                    config: {
                        name: 'tension',
                        fieldLabel: 'tension',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/ColumnaConceptoIngasDet/listarColumnaConceptoIngasDetCombo',
                            id: 'id',
                            root: 'datos',
                            sortInfo: {
                                field: 'valor',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id', 'valor'],
                            remoteSort: true,
                            baseParams: {par_filtro: '#v.valor',columna:'tension'}
                        }),
                        valueField: 'valor',
                        displayField: 'valor',
                        gdisplayField: 'valor',
                        hiddenName: 'valor',
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
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    grid: false,
                    form: true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_componente_macro'
                    },
                    type:'Field',
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
                    filters:{pfiltro:'comingas.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
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
                    filters:{pfiltro:'comingas.fecha_reg',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'comingas.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'comingas.usuario_ai',type:'string'},
                    id_grupo:1,
                    grid:true,
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
                    grid:true,
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
                    filters:{pfiltro:'comingas.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'Lista Concepto Ingas Componente',
            ActSave:'../../sis_proyectos/control/ComponenteConceptoIngas/insertarComponenteConceptoIngas',
            ActDel:'../../sis_proyectos/control/ComponenteConceptoIngas/eliminarComponenteConceptoIngas',
            ActList:'../../sis_proyectos/control/ComponenteConceptoIngas/listarComponenteConceptoIngas',
            id_store:'id_componente_concepto_ingas',
            fields: [
                {name:'id_componente_concepto_ingas', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'id_concepto_ingas', type: 'numeric'},
                {name:'id_componente_macro', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'desc_ingas', type: 'string'},
                {name:'id_proyecto', type: 'string'},
                {name:'porc_prueba', type: 'numeric'},//#28
                {name:'precio_total_det', type: 'numeric'},
            ],
            sortInfo:{
                field: 'id_componente_concepto_ingas',
                direction: 'ASC'
            },
            bdel:true,
            bsave:true,
            bedit:false,

            onReloadPage: function (m) {
                this.maestro = m;
                console.log('maestro',this.maestro);
                this.Atributos[this.getIndAtributo('id_componente_macro')].valorInicial = this.maestro.id_componente_macro;
                this.store.baseParams = {id_componente_macro: this.maestro.id_componente_macro};
                this.load({params: {start: 0, limit: 50}});

                this.Cmp.id_concepto_ingas_agrupador.store.baseParams.tipo_agrupador = this.maestro.componente_macro_tipo;

                this.Cmp.id_concepto_ingas_agrupador.on('select', function(cmb,rec,i){
                    console.log('rec',rec.data.id_concepto_ingas_agrupador);
                    this.Cmp.id_concepto_ingas.store.baseParams.id_concepto_ingas_agrupador = rec.data.id_concepto_ingas_agrupador;
                    this.Cmp.id_concepto_ingas.store.load({params:{start:0,limit:this.tam_pag},
                        callback : function (r) {
                            if (r.length > 0 ) {
                                this.Cmp.id_concepto_ingas.setValue(r[0].data.id_concepto_ingas);
                            }else{
                                this.Cmp.id_concepto_ingas.reset();
                            }
                        }, scope : this
                    });
                } ,this);

            },
            tabeast: [
                {
                    url:'../../../sis_proyectos/vista/componente_concepto_ingas_det/ComponenteConceptoIngasDet.php',
                    title:'Lista de Detalles Conceptos Ingreso/Gasto',
                    width:'70%',
                    height:'50%',
                    cls:'ComponenteConceptoIngasDet'
                }],
            reload:function (){
                this.store.reload();
                //Phx.CP.getPagina(this.idContenedorPadre).reload();

            }


        }
    )
</script>
		
		