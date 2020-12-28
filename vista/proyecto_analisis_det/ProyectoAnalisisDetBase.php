<?php
/****************************************************************************************
*@package pXP
*@file gen-ProyectoAnalisisDet.php
*@author  (egutierrez)
*@date 29-09-2020 12:44:12
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                29-09-2020 12:44:12    egutierrez            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoAnalisisDetBase=Ext.extend(Phx.gridInterfaz,{
    title:'ProyectoAnalisisDetBase',
    nombreVista: 'ProyectoAnalisisDetBase',
    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.ProyectoAnalisisDetBase.superclass.constructor.call(this,config);
        this.init();
        this.bloquearMenus();
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_proyecto_analisis_det'
            },
            type:'Field',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_proyecto_analisis'
            },
            type:'Field',
            form:true
        },
        {
            config: {
                name: 'id_int_transaccion',
                fieldLabel: 'transaccion',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/ProyectoAnalisisDet/listarIntransaccionAnadet',
                    id: 'id_int_transaccion',
                    root: 'datos',
                    sortInfo: {
                        field: 'id_int_transaccion',
                        direction: 'ASC'
                    },

                    totalProperty: 'total',
                    fields: ['id_int_transaccion','nro_tramite_cbte','fecha_cbte','glosa_cbte','importe_debe_mb','importe_haber_mb','desc_partida','desc_centro_costo','desc_cuenta','desc_auxiliar','tipo_cuenta'],
                    remoteSort: true,
                    baseParams: {par_filtro:'id_int_transaccion#nro_tramite#fecha#glosa#importe_debe_mb#importe_haber_mb#desc_partida#desc_centro_costo#desc_cuenta#desc_auxiliar#tipo_cuenta'}
                }),
                tpl:'<tpl for=".">\ <div class="x-combo-list-item"><p><b>Nro Tramite Cbte: </b>{nro_tramite_cbte}</p>\
                                <p><b>Fecha: </b>{fecha_cbte}</p>\
                               <p><b>Debe : </b>{importe_debe_mb}</p>\
                               <p><b>Haber: </b>{importe_haber_mb}</p>\
                               </div></tpl>',
                valueField: 'id_int_transaccion',
                displayField: 'id_int_transaccion',
                gdisplayField: 'id_int_transaccion',
                hiddenName: 'id_int_transaccion',
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
                    return String.format('{0}', record.data['id_int_transaccion']);
                },
                listeners: {
                    'afterrender': function(combo){
                    },
                    'expand':function (combo) {
                        this.store.reload();
                    }
                },
            },
            type: 'ComboBox',
            id_grupo: 0,
            grid: true,
            form: true
        },

        {
            config:{
                name: 'nro_tramite_cbte',
                fieldLabel: 'Nro Tramite Cbte',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'cbt.nro_tramite',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'fecha_cbte',
                fieldLabel: 'Fecha Cbte',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'cbt.fecha',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'glosa_cbte',
                fieldLabel: 'Glosa Cbte',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'cbt.glosa1',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'importe_debe_mb',
                fieldLabel: 'Importe Debe MB',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'NumberField',
            filters:{pfiltro:'intra.importe_debe_mb',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'importe_haber_mb',
                fieldLabel: 'Importe Haber MB',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'NumberField',
            filters:{pfiltro:'intra.importe_haber_mb',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'desc_partida',
                fieldLabel: 'Partida',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'desc_centro_costo',
                fieldLabel: 'Centro de Costo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'cc.codigo_cc',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'desc_cuenta',
                fieldLabel: 'Cuenta',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'cue.nro_cuenta',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'desc_auxiliar',
                fieldLabel: 'Auxiliar',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        // {
        //     config: {
        //         name: 'id_int_transaccion',
        //         fieldLabel: 'Transaccion',
        //         allowBlank: true,
        //         emptyText: 'Elija una opción...',
        //         store: new Ext.data.JsonStore({
        //             url: '../../sis_/control/Clase/Metodo',
        //             id: 'id_',
        //             root: 'datos',
        //             sortInfo: {
        //                 field: 'nombre',
        //                 direction: 'ASC'
        //             },
        //             totalProperty: 'total',
        //             fields: ['id_', 'nombre', 'codigo'],
        //             remoteSort: true,
        //             baseParams: {par_filtro: 'movtip.nombre#movtip.codigo'}
        //         }),
        //         valueField: 'id_',
        //         displayField: 'nombre',
        //         gdisplayField: 'desc_',
        //         hiddenName: 'id_int_transaccion',
        //         forceSelection: true,
        //         typeAhead: false,
        //         triggerAction: 'all',
        //         lazyRender: true,
        //         mode: 'remote',
        //         pageSize: 15,
        //         queryDelay: 1000,
        //         anchor: '100%',
        //         gwidth: 150,
        //         minChars: 2,
        //         renderer : function(value, p, record) {
        //             return String.format('{0}', record.data['desc_']);
        //         }
        //     },
        //     type: 'ComboBox',
        //     id_grupo: 0,
        //     filters: {pfiltro: 'movtip.nombre',type: 'string'},
        //     grid: true,
        //     form: false
        // },
        {
            config:{
                name: 'estado',
                fieldLabel: 'estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:30
            },
                type:'TextField',
                filters:{pfiltro:'proanade.estado',type:'string'},
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
            filters:{pfiltro:'proanade.estado_reg',type:'string'},
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
                filters:{pfiltro:'proanade.fecha_reg',type:'date'},
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
                filters:{pfiltro:'proanade.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'proanade.usuario_ai',type:'string'},
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
                filters:{pfiltro:'proanade.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Detalle',
    ActSave:'../../sis_proyectos/control/ProyectoAnalisisDet/insertarProyectoAnalisisDet',
    ActDel:'../../sis_proyectos/control/ProyectoAnalisisDet/eliminarProyectoAnalisisDet',
    ActList:'../../sis_proyectos/control/ProyectoAnalisisDet/listarProyectoAnalisisDet',
    id_store:'id_proyecto_analisis_det',
    fields: [
		{name:'id_proyecto_analisis_det', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_proyecto_analisis', type: 'numeric'},
		{name:'id_int_transaccion', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'nro_tramite_cbte', type: 'string'},
        {name:'fecha_cbte', type: 'date',dateFormat:'Y-m-d'},
        {name:'glosa_cbte', type: 'string'},
        {name:'importe_debe_mb', type: 'numeric'},
        {name:'importe_haber_mb', type: 'numeric'},
        {name:'desc_partida', type: 'string'},
        {name:'desc_centro_costo', type: 'string'},
        {name:'desc_cuenta', type: 'string'},
        {name:'desc_auxiliar', type: 'string'},
        {name:'tipo_cuenta', type: 'string'},
        
    ],
    sortInfo:{
        field: 'id_proyecto_analisis_det',
        direction: 'ASC'
    },
    bdel:true,
    bsave:false,
    bedit:false,
    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_proyecto_analisis;

        this.Cmp.id_int_transaccion.store.baseParams.id_proyecto_analisis = this.maestro.id_proyecto_analisis;
        this.Cmp.id_int_transaccion.store.baseParams.tipo_cuenta = this.tipo_cuenta;



        this.store.baseParams = {
            id_proyecto_analisis: this.maestro.id_proyecto_analisis,
            tipo_cuenta:this.tipo_cuenta,
            nombreVista:this.nombreVista
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });


    },
    onButtonNew:function(){
        //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
        //this.ocultarComponente(this.Cmp.fecha_ini);
        Phx.vista.ProyectoAnalisisDetBase.superclass.onButtonNew.call(this);
        //seteamos un valor fijo que vienen de la vista maestro para id_gui

        this.Cmp.id_int_transaccion.store.load({params:{start:0,limit:this.tam_pag},
            callback : function (r) {
                if (r.length > 0 ) {
                    this.Cmp.id_int_transaccion.setValue(r[0].data.id_int_transaccion);
                }else{
                    this.Cmp.id_int_transaccion.reset();
                }
            }, scope : this
        });
    },

    successDel:function(resp){
        Phx.vista.ProyectoAnalisisDetBase.superclass.successDel.call(this);
        Phx.CP.getPagina(this.idContenedorPadre).onButtonAct();
    },

    }
)
</script>
        
        