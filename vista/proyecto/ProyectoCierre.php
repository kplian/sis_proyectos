<?php
/**
*@package pXP
*@file Proyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoCierre=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.ProyectoCierre.superclass.constructor.call(this,config);
        this.init();
        this.load({params:{start:0, limit:this.tam_pag, estado: 'precierre'}});

        this.addButton('btnImportCierre',
            {
                text: 'Subir Cierre',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.SubirArchivo,
                tooltip: '<b>Subir Transacciones</b><br/>desde Excel (xlsx).'
            }
        );

        //Boton para la definicion de activos fijos
        this.addButton('btnDefAct',
            {
                text: 'Definición Activos',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.abrirDefActivos
            }
        );

        //Adicion de botones en la barra de herramientas
        this.addButton('ant_estado',{ argument: {estado: 'anterior'},text:'Atras',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        this.addButton('sig_estado',{ text:'Siguiente', iconCls: 'badelante', disabled: true, handler: this.sigEstado, tooltip: '<b>Pasar al Siguiente Estado</b>'});
        this.addBotonesGantt();

    },

    Atributos:[
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
            config:{
                name: 'codigo',
                fieldLabel: 'Código',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:20,
                /*renderer: function( value, metaData, record, rowIndex, colIndex, store ) {
                    var id = Ext.id();
                    (function(){
                        var progress = new Ext.ProgressBar({
                            renderTo: id,
                            value: 0.85,
                            text: 'aqui va el texto'
                        });
                    }).defer(25);
                    return '<div id="'+ id + '"></div>';
                }*/
            },
                type:'TextField',
                filters:{pfiltro:'proy.codigo',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
        },
        {
            config:{
                name: 'estado_cierre',
                fieldLabel: 'Estado Cierre',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:150
            },
            type:'TextField',
            filters:{pfiltro:'proy.estado_cierre',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'nombre',
                fieldLabel: 'Nombre',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:150
            },
                type:'TextField',
                filters:{pfiltro:'proy.nombre',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
        },
        {
            config:{
                name: 'fecha_ini',
                fieldLabel: 'Fecha Ini',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y',
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'proy.fecha_ini',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
        },
        {
            config:{
                name: 'fecha_fin',
                fieldLabel: 'Fecha Fin',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y',
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'proy.fecha_fin',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
        },
        {
            config: {
                name: 'id_tipo_cc',
                fieldLabel: 'Centro Costo/Proyecto',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/TipoCc/listartipoCcAll',
                    id: 'id_tipo_cc',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_cc', 'codigo', 'descripcion'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'tcc.codigo#tcc.descripcion'}
                }),
                tpl:'<tpl for=".">\
                               <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo}</p>\
                               <p><b>Descripcion: </b>{descripcion}</p>\
                                </div></tpl>',

                valueField: 'id_tipo_cc',
                displayField: 'codigo',
                gdisplayField: 'codigo_tcc',
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
                    return String.format('{0}', record.data['codigo_tcc']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'tcc.codigo#tcc.descripcion',type: 'string'},
            grid: true,
            form: true
        },

        {
            config: {
                name: 'id_fase_plantilla',
                fieldLabel: 'Plantilla Proyecto:',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_proyectos/control/FasePlantilla/listarFasePlantilla',
                    id: 'id_fase_plantilla',
                    root: 'datos',
                    sortInfo: {
                        field: 'id_fase_plantilla',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_fase_plantilla', 'codigo', 'nombre'],
                    remoteSort: true,

                    baseParams: {par_filtro: 'faspla.id_fase_plantilla#faspla.codigo#faspla.nombre',raiz:'raiz'}
                }),
                tpl:'<tpl for=".">\
                               <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo}</p>\
                               <p><b>Nombre: </b>{nombre}</p>\
                                </div></tpl>',

                valueField: 'id_fase_plantilla',
                displayField: 'nombre',
                gdisplayField: 'codigo',
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
            filters: {pfiltro: 'faspla.id_fase_plantilla#faspla.codigo',type: 'string'},
            grid: true,
            form: true
        },
        {
            config:{
                name: 'id_depto_conta',
                hiddenName: 'Depto.Contabilidad',
                url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
                origen: 'DEPTO',
                allowBlank: false,
                fieldLabel: 'Depto',
                anchor: '100%',
                gdisplayField: 'desc_depto_conta',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                width: 250,
                gwidth: 180,
                baseParams: { estado:'activo',codigo_subsistema:'CONTA'},//parametros adicionales que se le pasan al store
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
            },
            type: 'ComboRec',
            id_grupo: 0,
            filters: { pfiltro:'dep.nombre#dep.codigo', type:'string'},
            grid: true,
            form: true
        },
        {
            config:{
                name: 'id_moneda',
                origen: 'MONEDA',
                allowBlank: false,
                fieldLabel: 'Moneda',
                anchor: '100%',
                gdisplayField: 'desc_moneda',//mapea al store del grid
                gwidth: 50,
                //baseParams: { 'filtrar_base': 'si' },
                renderer: function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type: 'ComboRec',
            id_grupo: 1,
            filters: { pfiltro:'mon.codigo',type:'string'},
            grid: true,
            form: true
        },
        {
            config:{
                name: 'id_int_comprobante_1',
                fieldLabel: 'Cbte. 1',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:20,
            },
                type:'TextField',
                filters:{pfiltro:'proy.id_int_comprobante_1',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:false
        },
        {
            config:{
                name: 'id_int_comprobante_2',
                fieldLabel: 'Cbte. 2',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:20,
            },
                type:'TextField',
                filters:{pfiltro:'proy.id_int_comprobante_2',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:false
        },
        {
            config:{
                name: 'id_int_comprobante_3',
                fieldLabel: 'Cbte. 3',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:20,
            },
                type:'TextField',
                filters:{pfiltro:'proy.id_int_comprobante_3',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:false
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
                filters:{pfiltro:'proy.estado_reg',type:'string'},
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
                filters:{pfiltro:'proy.usuario_ai',type:'string'},
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
                filters:{pfiltro:'proy.fecha_reg',type:'date'},
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
                name: 'id_usuario_ai',
                fieldLabel: 'Creado por',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
                type:'Field',
                filters:{pfiltro:'proy.id_usuario_ai',type:'numeric'},
                id_grupo:1,
                grid:false,
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
                filters:{pfiltro:'proy.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
        }
    ],
    tam_pag:50,
    title:'Proyecto',
    ActSave:'../../sis_proyectos/control/Proyecto/insertarProyecto',
    ActDel:'../../sis_proyectos/control/Proyecto/eliminarProyecto',
    ActList:'../../sis_proyectos/control/Proyecto/listarProyecto',
    id_store:'id_proyecto',
    fields: [
        {name:'id_proyecto', type: 'numeric'},
        {name:'codigo', type: 'string'},
        {name:'nombre', type: 'string'},
        {name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
        {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
        {name:'id_tipo_cc', type: 'numeric'},
        {name:'estado_reg', type: 'string'},
        {name:'usuario_ai', type: 'string'},
        {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'id_usuario_reg', type: 'numeric'},
        {name:'id_usuario_ai', type: 'numeric'},
        {name:'id_usuario_mod', type: 'numeric'},
        {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'usr_reg', type: 'string'},
        {name:'usr_mod', type: 'string'},
        {name:'codigo_tcc', type: 'string'},
        {name:'desc_tcc', type: 'string'},
        {name:'id_moneda', type: 'numeric'},
        {name:'desc_moneda', type: 'string'},
        {name:'id_depto_conta', type: 'numeric'},
        {name:'desc_depto', type: 'string'},
        {name:'id_int_comprobante_1', type: 'numeric'},
        {name:'id_int_comprobante_2', type: 'numeric'},
        {name:'id_int_comprobante_3', type: 'numeric'},
        {name:'id_proceso_wf_cierre', type: 'numeric'},
        {name:'id_estado_wf_cierre', type: 'numeric'},
        {name:'nro_tramite_cierre', type: 'string'},
        {name:'estado_cierre', type: 'string'},
        {name:'id_proceso_wf', type: 'numeric'},
        {name:'id_estado_wf', type: 'numeric'},
        {name:'nro_tramite', type: 'string'},
        {name:'estado', type: 'string'}
    ],
    sortInfo:{
        field: 'id_proyecto',
        direction: 'ASC'
    },
    bdel:true,
    bsave:true,

    onButtonNew: function(){
        Phx.vista.ProyectoCierre.superclass.onButtonNew.call(this);
        this.mostrarComponente(this.Cmp.id_fase_plantilla);
    },
    onButtonEdit: function(){
        Phx.vista.ProyectoCierre.superclass.onButtonEdit.call(this);
        this.Cmp.id_fase_plantilla.allowBlank=true;
        this.ocultarComponente(this.Cmp.id_fase_plantilla);
    },
    SubirArchivo: function(rec)
    {
        var record=this.sm.getSelected();
        Phx.CP.loadWindows
        (
            '../../../sis_proyectos/vista/proyecto/ImportarCierreValorado.php',
            'Importar Cierre desde Excel',
            {
                modal: true,
                width: 450,
                height: 150
            },
            record.data,
            this.idContenedor,
            'ImportarCierreValorado'
        );
    },
    abrirDefActivos: function(){
        var data=this.sm.getSelected();
        Phx.CP.loadWindows('../../../sis_proyectos/vista/proyecto_activo/ProyectoActivo.php',
            'Proyecto: '+data.data.codigo+' '+data.data.nombre,
            {
                width:'90%',
                height:'90%'
            },
            data,
            this.idContenedor,
            'ProyectoActivo'
        )
    },
    preparaMenu: function(n){
        Phx.vista.ProyectoCierre.superclass.preparaMenu.call(this);
        var data = this.getSelectedData();

        //Se habilita botón para Definición de Activos
        this.getBoton('btnDefAct').enable();
        this.getBoton('btnImportCierre').enable();
        this.getBoton('ant_estado').disable();
        this.getBoton('sig_estado').disable();
        this.getBoton('diagrama_gantt').enable();
        this.getBoton('btnImportCierre').disable();

        //Si está en modo histórico,no habilita ninguno de los botones que generan transacciones
        if(data.estado_cierre == 'borrador') {
            this.getBoton('sig_estado').enable();
        } else if(data.estado_cierre == 'cbte'||data.estado_cierre == 'finalizado' ||data.estado_cierre==''){
            //Deja inhabilitados los botones
        }  else {
            this.getBoton('ant_estado').enable();
            this.getBoton('sig_estado').enable();
        }

        //Botón Subir Cierre
        if(data.estado_cierre == 'borrador'||data.estado_cierre == '') {
            this.getBoton('btnImportCierre').enable();
        }

    },
    liberaMenu:function(){
        Phx.vista.ProyectoCierre.superclass.liberaMenu.call(this);
        //Se deshabilita botón para Definición de Activos
        this.getBoton('btnDefAct').disable();
        this.getBoton('btnImportCierre').disable();
    },
    antEstado: function(res){
        var rec=this.sm.getSelected(),
            obsValorInicial;

        Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {   modal: true,
                width: 450,
                height: 250
            },
            {    data: rec.data,
                 estado_destino: res.argument.estado,
                 obsValorInicial: obsValorInicial }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }],
               scope:this
            });
    },
    sigEstado:function(){
        var rec=this.sm.getSelected();
        this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:700,
                height:450
            }, {
                data:{
                    id_proyecto: rec.data.id_proyecto,
                    id_estado_wf: rec.data.id_estado_wf_cierre,
                    id_proceso_wf: rec.data.id_proceso_wf_cierre,
                    fecha_ini: rec.data.fecha_fin,
                }}, this.idContenedor,'FormEstadoWf',
            {
                config:[{
                  event:'beforesave',
                  delegate: this.onSaveWizard,

                }],
                scope:this
            });
    },
    addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2,3],
            iconCls: 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
                items: [{
                    id:'b-gantti-' + this.idContenedor,
                    text: 'Gantt Imagen',
                    tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
                    handler:this.diagramGantt,
                    scope: this
                }, {
                    id:'b-ganttd-' + this.idContenedor,
                    text: 'Gantt Dinámico',
                    tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
                    handler:this.diagramGanttDinamico,
                    scope: this
                }]
            }
        });
        this.tbar.add(this.menuAdqGantt);
    },
    onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_proyectos/control/Proyecto/siguienteEstadoCierre',
            params:{
                    id_proyecto:        wizard.data.id_proyecto,
                    id_proceso_wf_act:  resp.id_proceso_wf_act,
                    id_estado_wf_act:   resp.id_estado_wf_act,
                    id_tipo_estado:     resp.id_tipo_estado,
                    id_funcionario_wf:  resp.id_funcionario_wf,
                    id_depto_wf:        resp.id_depto_wf,
                    obs:                resp.obs,
                    json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success: this.successWizard,
            failure: this.conexionFailure,
            argument: { wizard:wizard },
            timeout: this.timeout,
            scope: this
        });
    },
    successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    onAntEstado: function(wizard,resp){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_proyectos/control/Proyecto/anteriorEstadoCierre',
            params:{
                id_proceso_wf: resp.data.id_proceso_wf_cierre,
                id_estado_wf:  resp.data.id_estado_wf_cierre,
                obs: resp.obs,
                id_proyecto: resp.data.id_proyecto
             },
            argument:{wizard:wizard},
            success: this.successAntEstado,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },
    successAntEstado:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    }

})
</script>

