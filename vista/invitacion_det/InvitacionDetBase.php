<?php
/**
 *@package pXP
 *@file gen-InvitacionDetBase.php
 *@author  (eddy.gutierrez)
 *@date 22-08-2018 22:32:59
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
ISSUE		FECHA		AUTHOR			DESCRIPCION
#6	EndeEtr 24/01/2019	 EGS		    Se hace validacion paa que la invitacion tenga fecha al querer añadir un detalle
#7	EndeEtr 04/02/2019	 EGS		    Se hace validacion para que no guarde en estado de sol_compra
#8	EndeEtr 18/03/2019	 EGS		    se fuerza a escoger centro de costo
#15 EndeEtr	31/07/2019	 EGS			se hace reestructura de archivos
 *  * */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.InvitacionDetBase=Ext.extend(Phx.gridInterfaz,{

        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.InvitacionDetBase.superclass.constructor.call(this,config);
            this.init();
            this.iniciarEventos();
            this.iniciar();
            this.bloquearMenus();
        },
        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_invitacion_det'
                },
                type:'Field',
                form:true
            },
            {
                config: {
                    name: 'invitacion_det__tipo',
                    fieldLabel: 'Tipo',
                    anchor: '95%',
                    tinit: false,
                    allowBlank: true,
                    origen: 'CATALOGO',
                    gdisplayField: 'invitacion_det__tipo',
                    hiddenName: 'invitacion_det__tipo',
                    gwidth: 55,
                    baseParams:{
                        cod_subsistema:'PRO',
                        catalogo_tipo:'tinvitacion_det__tipo'
                    },
                    valueField: 'codigo',
                    hidden: false
                },
                type: 'ComboRec',
                id_grupo: 0,
                filters:{pfiltro:'mov.prestamo',type:'string'},
                grid: false,
                form: true
            },

            {
                config: {
                    name: 'id_fase',
                    fieldLabel: 'Fase',
                    allowBlank: false,
                    emptyText: 'Elija una opción',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_proyectos/control/Fase/listarFase',
                        id: 'id_fase',
                        root: 'datos',
                        fields: ['id_fase','codigo','nombre','descripcion'],
                        totalProperty: 'total',
                        sortInfo: {
                            field: 'codigo',
                            direction: 'ASC'
                        },
                        baseParams:{
                            start: 0,
                            limit: 10,
                            sort: 'id_fase',
                            dir: 'ASC',
                            par_filtro:'fase.id_fase#fase.codigo#fase.descripcion#fase.nombre'
                        }
                    }),
                    tpl:'<tpl for=".">\ <div class="x-combo-list-item"><p><b>Fase: </b>{codigo}-{nombre}</p>\<p><b>Descripcion: </b>{descripcion}</p>\</div></tpl>',
                    valueField: 'id_fase',
                    hiddenValue: 'id_fase',
                    displayField: 'codigo',
                    gdisplayField: 'descripcion',
                    mode: 'remote',
                    triggerAction: 'all',
                    lazyRender: true,
                    pageSize: 15,

                    minChars: 2,
                    anchor: '100%',
                    gwidth: 150,
                    renderer:function(value, p, record){
                        return String.format('{0}', record.data['desc_fase']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'fase.codigo',type: 'string'},

                grid: true,
                form: true
            },
            {
                config:{
                    name: 'codigo',
                    fieldLabel: 'Codigo',
                    allowBlank: false,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:1000
                },
                type:'TextField',
                id_grupo:1,
                grid:false,
                form:true
            },
            {
                config:{
                    name: 'desc_ingas',
                    fieldLabel: 'Concepto de Gasto',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 250,
                    maxLength:1000
                },
                type:'TextField',
                filters:{pfiltro:'cig.desc_ingas,cig.tipo',type:'string'},
                bottom_filter:true,
                //egrid:true,
                id_grupo:0,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'id_concepto_ingas',
                    fieldLabel: 'Concepto de Gasto',
                    allowBlank: false,
                    emptyText: 'Concepto...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
                        id : 'id_concepto_ingas',
                        root: 'datos',
                        sortInfo:{
                            field: 'desc_ingas',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot','desc_gestion'],
                        remoteSort: true,
                        baseParams: { par_filtro: 'desc_ingas#par.codigo',movimiento:'gasto'}//, autorizacion: 'viatico'}
                    }),
                    tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Concepto de Gasto: </b>{desc_ingas}</p>\
		                       <p><b>Movimiento:</b>{movimiento}</p>\
		                        <p><b>Partida:</b>{desc_partida}</p> </div></tpl>',
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
                bottom_filter: false,
                filters:{pfiltro:'cig.desc_ingas',type:'string'},
                id_grupo:1,
                grid:false,
                form:true
            },
            {
                config: {
                    name: 'id_fase_concepto_ingas',
                    fieldLabel: 'Fase Concepto Ingas',
                    allowBlank: false,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_proyectos/control/FaseConceptoIngas/listarFaseConceptoIngasCombo',
                        id: 'id_fase_concepto_ingas',
                        root: 'datos',
                        sortInfo: {
                            //field: 'id_fase_concepto_ingas',
                            field: 'fase.codigo',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        //#9
                        fields: ['id_fase_concepto_ingas','descripcion','desc_ingas','cantidad_est','precio','nombre_fase','codigo_fase','id_unidad_medida','tipo','id_fase','id_concepto_ingas','desc_moneda','total_invitacion_det','codigo','codigo_uc'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'facoing.id_fase_concepto_ingas#facoing.descripcion#facoing.id_unidad_medida#cig.tipo#fase.codigo'}//#7
                    }),

                    //#9
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>Codigo: </b>{codigo}</p>\
							   <p><b>Concepto Gasto: </b>{desc_ingas}</p>\
							   <p><b>Fase: </b>{codigo_fase}-{nombre_fase}</p>\
		                       <p><b>Servicio-Bien: </b>{tipo}</p>\
		                       <p><b>Moneda: </b>{desc_moneda}</p>\
		                       <p><b>Precio Total Estimado: </b>{precio}</p>\
		                       <p><b>Total Asignado: </b>{total_invitacion_det}</p>\
		                       <p><b>Unidad Constructiva: </b>{codigo_uc}</p>\
		                       </div></tpl>',
                    valueField: 'id_fase_concepto_ingas',
                    displayField: 'desc_ingas',
                    gdisplayField: 'desc_ingas',
                    hiddenName: 'id_fase_concepto_ingas',
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
                        return String.format('{0}', record.data['desc_ingas']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'facoing.id_fase_concepto_ingas',type: 'string'},
                grid: false,
                form: true
            },
            {
                config:{
                    name: 'id_unidad_constructiva',
                    fieldLabel: 'Unidad Constructiva',
                    allowBlank: false,
                    emptyText: 'Concepto...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_proyectos/control/UnidadConstructiva/listarUnidadConstructiva',
                        id : 'id_unidad_constructiva',
                        root: 'datos',
                        sortInfo:{
                            field: 'id_unidad_constructiva',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_unidad_constructiva','codigo','nombre','activo'],
                        remoteSort: true,
                        baseParams: { par_filtro: 'uncon.id_unidad_constructiva#uncon.codigo#uncon.nombre#uncon.activo'}
                    }),
                    tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo: </b>{codigo}</p>\ <p><b>Nombre: </b>{nombre}</p>\ </div></tpl>',
                    valueField: 'id_unidad_constructiva',
                    displayField: 'codigo',
                    gdisplayField: 'codigo',
                    hiddenName: 'id_unidad_constructiva',
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
                    qtip:'La unidad Constructiva en la que pertenece el concepto de gasto',
                    renderer:function(value, p, record){
                        return String.format('{0}', record.data['codigo_uc']);

                    }
                },
                type:'ComboBox',
                bottom_filter: true,
                filters:{pfiltro:'uncon.codigo',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },


            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_invitacion'
                },
                type:'Field',
                form:true
            },



            {
                config: {
                    name: 'id_unidad_medida',
                    fieldLabel: 'Unidad Medida',
                    allowBlank: false,
                    emptyText: 'Elija una opción',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/UnidadMedida/listarUnidadMedida',
                        id: 'id_unidad_medida',
                        root: 'datos',
                        fields: ['id_unidad_medida','codigo','descripcion'],
                        totalProperty: 'total',
                        sortInfo: {
                            field: 'codigo',
                            direction: 'ASC'
                        },
                        baseParams:{
                            start: 0,
                            limit: 10,
                            sort: 'descripcion',
                            dir: 'ASC',
                            par_filtro:'ume.id_unidad_medida#ume.codigo#ume.descripcion'
                        }
                    }),
                    renderer : function(value, p, record) {
                        Phx.CP.loadingHide();
                        //return String.format('{0}', record.data['codigo']);

                    },
                    valueField: 'id_unidad_medida',
                    hiddenValue: 'id_unidad_medida',
                    displayField: 'descripcion',
                    gdisplayField: 'desc_unidad_medida',
                    mode: 'remote',
                    triggerAction: 'all',
                    lazyRender: true,
                    pageSize: 15,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo} - {descripcion}</p></div></tpl>',
                    minChars: 2,
                    gwidth: 120
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'ume.codigo',type: 'string'},
                egrid:true,
                grid: true,
                form: true
            },

            {
                config:{
                    name: 'cantidad_sol',
                    fieldLabel: 'Cantidad',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 80,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
                        }
                        else{
                            Ext.util.Format.usMoney
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
                        }

                    }
                },
                type:'NumberField',
                filters:{pfiltro:'ivtd.cantidad_sol',type:'numeric'},
                id_grupo:0,
                bottom_filter: true,
                egrid:true,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'precio',
                    fieldLabel: 'Precio Unitario',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 150,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){

                            //return value;
                            return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
                        }
                        else{
                            Ext.util.Format.usMoney
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
                        }

                    }
                },
                type:'MoneyField',
                filters:{pfiltro:'ivtd.precio',type:'numeric'},
                id_grupo:0,
                bottom_filter: true,
                egrid:true,
                grid:true,
                form:true
            },

            {
                config:{
                    name: 'cantidad_est',
                    fieldLabel: 'Cantidad Estimada',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
                        }
                        else{
                            Ext.util.Format.usMoney
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
                        }

                    }
                },
                type:'NumberField',
                filters:{pfiltro:'cantidad_est',type:'numeric'},
                id_grupo:0,
                bottom_filter:false,
                //egrid:true,
                grid:false,
                form:false
            },
            {
                config:{
                    name: 'precio_t',
                    fieldLabel:'Precio Total',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 150,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){

                        var total = record.data.cantidad_sol*record.data.precio;
                        //total = total.toFixed(2);
                        var tol=total.toLocaleString();
                        var to = tol.toString();
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format(to,Ext.util.Format.number(value,'0.000,00/i'));
                        }
                        else{
                            Ext.util.Format.usMoney

                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
                        }

                    }
                },
                type:'MoneyField',
                filters:{pfiltro:'precio_t',type:'numeric'},
                id_grupo:0,
                bottom_filter:false,
                //egrid:true,
                grid:true,
                form:true
            },
            {
                config:{
                    name:'precio_est',
                    fieldLabel:'Precio Total Estimado',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 200,
                    galign: 'right ',
                    maxLength:1179650,
                    renderer:function (value,p,record){
                        if(record.data.tipo_reg != 'summary'){
                            return  String.format('{0}',  Ext.util.Format.number(value,'0.000,00/i'));
                        }
                        else{
                            Ext.util.Format.usMoney
                            return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'0.000,00/i'));
                        }

                    }
                },
                type:'MoneyField',
                filters:{pfiltro:'precio_est',type:'numeric'},
                id_grupo:0,
                bottom_filter:false,
                //egrid:true,
                grid:false,
                form:true
            },
            {
                config:{
                    name: 'observaciones',
                    fieldLabel: 'observaciones',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:1000
                },
                type:'TextField',
                filters:{pfiltro:'ivtd.observaciones',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config: {
                    name: 'id_centro_costo',
                    fieldLabel: 'Centro Costo',
                    allowBlank: false,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/TipoCc/listarTipoCcArbHijos',
                        id: 'id_tipo_cc',
                        root: 'datos',
                        sortInfo: {
                            field: 'id_tipo_cc',
                            direction: 'ASC'
                        },
                        totalProperty: 'id_tipo_cc',
                        fields: ['id_tipo_cc', 'codigo', 'descripcion','id_centro_costo'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'codigo#descripcion'}
                    }),
                    tpl:'<tpl for=".">\
		                       <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo}</p>\
		                       <p><b>Descripcion: </b>{descripcion}</p>\
		                        </div></tpl>',

                    valueField: 'id_centro_costo',
                    displayField: 'codigo',
                    gdisplayField: 'codigo',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '80%',
                    gwidth: 150,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['codigo']);
                    }
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'codigo#descripcion',type: 'string'},
                grid: true,
                form: true
            },
            {
                config:{
                    name: 'descripcion',
                    fieldLabel: 'Descripcion',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:1000
                },
                type:'TextField',
                filters:{pfiltro:'ivtd.Descripcion',type:'string'},
                id_grupo:1,
                grid:true,
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
                filters:{pfiltro:'ivtd.estado_reg',type:'string'},
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
                    name: 'usuario_ai',
                    fieldLabel: 'Funcionaro AI',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:300
                },
                type:'TextField',
                filters:{pfiltro:'ivtd.usuario_ai',type:'string'},
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
                filters:{pfiltro:'ivtd.fecha_reg',type:'date'},
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
                filters:{pfiltro:'ivtd.id_usuario_ai',type:'numeric'},
                id_grupo:1,
                grid:false,
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
                filters:{pfiltro:'ivtd.fecha_mod',type:'date'},
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
            }
        ],
        tam_pag:50,
        title:'invitacion det',
        ActSave:'../../sis_proyectos/control/InvitacionDet/insertarInvitacionDet',
        ActDel:'../../sis_proyectos/control/InvitacionDet/eliminarInvitacionDet',
        ActList:'../../sis_proyectos/control/InvitacionDet/listarInvitacionDet',
        id_store:'id_invitacion_det',
        fields: [
            {name:'id_invitacion_det', type: 'numeric'},
            {name:'id_fase', type: 'numeric'},
            {name:'id_fase_concepto_ingas', type: 'numeric'},
            {name:'id_invitacion', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'observaciones', type: 'string'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'desc_ingas', type: 'string'},

            {name:'cantidad_sol', type: 'numeric'},
            {name:'id_unidad_medida', type: 'numeric'},
            {name:'precio', type: 'numeric'},

            {name:'desc_unidad_medida', type: 'string'},

            {name:'id_centro_costo', type: 'numeric'},
            {name:'descripcion', type: 'string'},
            {name:'codigo_cc', type: 'string'},
            'codigo',
            'desc_fase',
            'cantidad_est',
            {name:'precio_est', type: 'numeric'},
            {name:'id_unidad_constructiva', type: 'numeric'},'codigo_uc'


        ],
        sortInfo:{
            field: 'id_invitacion_det',
            direction: 'ASC'
        },
        bdel:true,
        bsave:true,
        bedit:false,
    })
</script>

