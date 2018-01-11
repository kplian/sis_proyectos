<?php
/**
*@package pXP
*@file ProyectoActivo.php
*@author  RCM
*@date 31-08-2017 16:52:19
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Ext.define('Phx.vista.ProyectoActivo', {
    extend: 'Ext.util.Observable',
    columnsMapId: [], //La posición del array tendrá el ID del centro de costo en función a la columma del grid
    id_proyecto: 0,
    id_proyecto_ep: 0,
    id_proyecto_activo: '',
    tam_pag: 200,
    columnIndex: -1,
    idProyectoActivo: -1,

    constructor: function(config){
        Ext.util.Format.thousandSeparator = '.';
        Ext.util.Format.decimalSeparator = ',';
        this.maestro = config;
        Ext.apply(this,config);
        this.callParent(arguments);
        this.panel = Ext.getCmp(this.idContenedor);
        
        this.id_proyecto = this.maestro.data.id_proyecto;
        this.id_proyecto_ep = this.maestro.data.id_proyecto_ep;

        this.getColumns();
        this.crearVentana();
        this.crearVentanaDetalle();

    },
    getColumns: function(){
        Ext.Ajax.request({
            url: '../../sis_parametros/control/CentroCosto/listarCentroCostoProyecto',
            params: {
                start: 0,
                limit: 50,
                sort: 'cc.id_tipo_cc',
                dir: 'ASC',
                id_proyecto_ep: this.id_proyecto_ep
            },
            success: function(res,params){
                var response = Ext.decode(res.responseText).datos;
                this.crearGrid(response);
            },
            argument: this.argumentSave,
            failure: Phx.CP.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },
    onButtonNew: function(){
        this.winDatos.setTitle('Nuevo Activo Fijo');
        this.id_proyecto_activo='';
        this.frmDatos.getForm().reset();
        this.winDatos.show();
    },
    onButtonEdit: function(record){
        this.winDatos.setTitle('Editar Activo Fijo');
        //Cargar formulario
        var rec = this.gridCierre.getSelectionModel().getSelected().data,
            recClas = new Ext.data.Record({id_clasificacion: rec.id_clasificacion, clasificacion: rec.desc_clasificacion },'id_clasificacion');

        this.cmbClasificacion.store.add(recClas);
        this.cmbClasificacion.store.commitChanges();
        this.cmbClasificacion.modificado = true;
        this.cmbClasificacion.setValue(rec.id_clasificacion);

        this.id_proyecto_activo = rec.id_proyecto_activo;
        this.txtDenominacion.setValue(rec.denominacion);
        this.txtDescripcion.setValue(rec.descripcion);
        this.txtObservaciones.setValue(rec.observaciones);

        this.winDatos.show();
    },
    onButtonDel: function(){
      console.log('onButtonDel');
    },
    onButtonAct: function(){
        this.storeGrid.reload();
    },
    crearGrid: function(response){
        var _cols=[],
            col1='#c2f0cc',
            col2='#EAA8A8',
            col3='#fafbd9';
        //Columnas por defecto
        _cols.push(new Ext.grid.RowNumberer());
        _cols.push({header: 'Denominación', dataIndex: 'denominacion',renderer: function(value,metadata,rec,index){
            if(rec.data.id_proyecto_activo>0){
                metadata.style="background-color:"+col1;
            }
            return value;
        }});
        _cols.push({header: 'Descripción', dataIndex: 'descripcion',renderer: function(value,metadata,rec,index){
            if(rec.data.id_proyecto_activo>0){
                metadata.style="background-color:"+col1;
            }
            return value;
        }});
        _cols.push({header: 'Clasificación', dataIndex: 'id_clasificacion',renderer: function(value,metadata,rec,index){
            if(rec.data.id_proyecto_activo>0){
                metadata.style="background-color:"+col1;
            }
            return String.format('{0}', rec.data['desc_clasificacion']);
        }});
        _cols.push({header: 'Observaciones', dataIndex: 'observaciones',renderer: function(value,metadata,rec,index){
            if(rec.data.id_proyecto_activo>0){
                metadata.style="background-color:"+col1;
            } else {
                 metadata.style="background-color:"+col3;
            }
            return value;
        }});
        _cols.push({header: 'Costo AF', dataIndex: 'costo',renderer: function(value,metadata,rec,index){
            if(rec.data.id_proyecto_activo>0){
                metadata.style="background-color:"+col2+';text-align: right;';
            } else {
                if(rec.data.observaciones=='SALDO x CC'&&value<0){
                    metadata.style='background-color: red; text-align: right;';// color: red;';
                } else {
                    metadata.style='text-align: right;';
                }
            }
            return String.format('<b >{0}</b>', Ext.util.Format.number(value,'0,000.00'));
        }});

        //Fields para el store
        this._colsData=[];

        //Columnas por defecto
        this._colsData.push({name:'id_proyecto_activo',type:'numeric'});
        this._colsData.push({name:'id_proyecto',type:'numeric'});
        this._colsData.push({name:'id_clasificacion',type:'numeric'});
        this._colsData.push({name:'denominacion',type:'string'});
        this._colsData.push({name:'descripcion',type:'string'});
        this._colsData.push({name:'observaciones',type:'string'});
        this._colsData.push({name:'desc_clasificacion',type:'string'});
        this._colsData.push({name:'costo',type:'numeric'});

        //Inicializa los valores del array para mapeo de Ids
        for (var i=0; i<=5; i++) {
            this.columnsMapId.push(0);
        }

        //Creación dinámica de las columnas en base a los centros de costo utilizados en el proyecto
        Ext.iterate(response, function(a,b){
            _cols.push({header: /*a.id_tipo_cc*/a.codigo_cc, dataIndex: 'cc_'+a.id_tipo_cc, renderer: function(value,metadata,rec,index){
                if(rec.data.observaciones=='SALDO x CC'&&value<0){
                    metadata.style='background-color: red; text-align: right;';// color: red;';
                } else {
                    metadata.style='text-align: right;';
                }
                return Ext.util.Format.number(value,'0,000.00');
            }});
            this._colsData.push({name: 'cc_'+a.id_tipo_cc, type:'numeric'});

            //Mapeo de Ids del centro de costo en función del nro. de columna
            this.columnsMapId.push(a.id_tipo_cc);   
        },this);

        //Creación del column model del grid
        this.colModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 120,
                sortable: true
            },
            columns: _cols
        });

        //Top toolbar
        this.tbBtnNew = new Ext.Button({
            iconCls: 'bnew',
            text: 'Nuevo',
            tooltip: '<b>Nuevo</b>',
            handler: this.onButtonNew,
            scope: this
        });
        this.tbBtnEdit = new Ext.Button({
            id: 'b-edit-' + this.idContenedor,
            iconCls: 'bedit',
            disabled: true,
            grupo: this.beditGroups,
            tooltip: '<b>Editar</b>',
            text: 'Editar',
            handler: this.onButtonEdit,
            scope: this
        });
        this.tbBtnDel = new Ext.Button({
            iconCls: 'bdel',
            disabled: true,
            tooltip: '<b>Eliminar</b>',
            text: 'Eliminar',
            handler: this.onButtonDel,
            scope: this
        });
        this.tbBtnAct = new Ext.Button({
            iconCls: 'bact',
            tooltip: '<b>Actualizar</b>',
            text: 'Actualizar',
            handler: this.onButtonAct,
            scope: this
        });

        this.tbar = new Ext.Toolbar({
          enableOverflow: true,
          defaults: {
               scale: 'large',
               iconAlign:'top',
               minWidth: 50,
               boxMinWidth: 50
            },
            items: [this.tbBtnNew,this.tbBtnEdit,this.tbBtnDel,this.tbBtnAct]
        });

        //Store para el grid
        this.storeGrid = new Ext.data.JsonStore({
            url: '../../sis_proyectos/control/ProyectoActivo/listarProyectoActivoTablaDatos',
            root: 'datos',
            sortInfo: 'cc.id_tipo_cc',
            totalProperty: 'total',
            fields: this._colsData,
            remoteSort: true,
            baseParams: {
                sort: 'id_proyecto_activo',
                start: 0,
                limit: 200,
                dir: 'asc',
                id_proyecto_ep: this.id_proyecto_ep,
                id_proyecto: this.id_proyecto
            }
        });

        //Bottom toolbar
        this.bbar = new Ext.PagingToolbar({
            pageSize:this.tam_pag,
            store:this.storeGrid,
            displayInfo: true,
            displayMsg: 'Registros {0} - {1} de {1}',
            emptyMsg: "No se tienen registros"
        });

        //Grid principal
        this.gridCierre = new Ext.grid.GridPanel({
            tbar: this.tbar,
            bbar: this.bbar,
            colModel: this.colModel,
            store: this.storeGrid,
            loadMask: true,
            sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        });

        this.storeGrid.on('load', this.cargarTotales,this);

        //Cargar store
        this.storeGrid.load();

       

        //Eevntos grid
        this.gridCierre.on('celldblclick',this.editCell,this);
        this.gridCierre.getSelectionModel().on('rowselect',this.selectGridRow,this);
        this.gridCierre.getSelectionModel().on('rowdeselect', this.deselectGridRow,this);

        //Render del panel con el grid creado
        this.panel.add(this.gridCierre);
        this.panel.doLayout();
    },
    crearVentana: function(){
        //Componentes
        this.cmbClasificacion = new Ext.form.ComboBox({
            name: 'cmbClasificacion',
            fieldLabel: 'Clasificación',
            allowBlank: true,
            emptyText:'Seleccione un registro...',
            store: new Ext.data.JsonStore({
                url: '../../sis_kactivos_fijos/control/Clasificacion/ListarClasificacionTree',
                id: 'id_clasificacion',
                root: 'datos',
                sortInfo: {
                    field: 'orden',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_clasificacion','clasificacion', 'id_clasificacion_fk','tipo_activo','depreciable','vida_util'],
                remoteSort: true,
                baseParams: {
                    par_filtro:'claf.clasificacion'
                }
            }),
            valueField: 'id_clasificacion',
            displayField: 'clasificacion',
            gdisplayField: 'clasificacion',
            hiddenName: 'id_clasificacion',
            mode: 'remote',
            triggerAction: 'all',
            typeAhead: false,
            lazyRender: true,
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['desc_clasificacion']);
            },
            anchor: '97%'
        });

        this.txtDenominacion = new Ext.form.TextField({
            fieldLabel: 'Denominación',
            name: 'denominacion',
            allowBlank: false,
            maxLength: 500,
            anchor: '97%'
        });

        this.txtDescripcion = new Ext.form.TextArea({
            fieldLabel: 'Descripción',
            name: 'descripcion',
            allowBlank: true,
            maxLength: 5000,
            anchor: '97%'
        });

        this.txtObservaciones = new Ext.form.TextArea({
            fieldLabel: 'Observaciones',
            name: 'observaciones',
            allowBlank: true,
            maxLength: 5000,
            anchor: '97%'
        });

        //Formulario
        this.frmDatos = new Ext.form.FormPanel({
            items: [{
                layout: 'form',
                defaults: {
                    border: false
                },
                items: {
                    xtype: 'fieldset',
                    border: false,
                    autoScroll: true,
                    layout: 'form',
                    items: [this.cmbClasificacion,this.txtDenominacion,this.txtDescripcion,this.txtObservaciones],
                    id_grupo: 0
                }
            }],
            padding: this.paddingForm,
            bodyStyle: this.bodyStyleForm,
            border: this.borderForm,
            frame: this.frameForm, 
            autoScroll: false,
            autoDestroy: true,
            autoScroll: true,
            region: 'center'
        });

        //Ventana
        this.winDatos = new Ext.Window({
            width: 600,
            height: 300,
            modal: true,
            closeAction: 'hide',
            labelAlign: 'top',
            title: 'Nuevo Activo Fijo',
            bodyStyle: 'padding:5px',
            layout: 'border',
            items: [this.frmDatos],
            buttons: [{
                text: 'Guardar',
                handler: this.onSubmit,
                scope: this
            }, {
                text: 'Cancelar',
                handler: function() {
                    this.winDatos.hide();
                },
                scope: this
            }]
        });
    },
    onSubmit: function(){
        if(this.frmDatos.getForm().isValid()){
            Phx.CP.loadingShow();
            var submit = {
                id_proyecto_activo: this.id_proyecto_activo,
                id_proyecto: this.id_proyecto,
                id_clasificacion: this.cmbClasificacion.getValue(),
                denominacion: this.txtDenominacion.getValue(),
                descripcion: this.txtDescripcion.getValue(),
                observaciones: this.txtObservaciones.getValue()
            };

            Ext.Ajax.request({
                url: '../../sis_proyectos/control/ProyectoActivo/insertarProyectoActivo',
                params: submit,
                isUpload: false,
                success: function(a,b,c){
                    this.winDatos.hide();
                    //Cargar store
                    this.storeGrid.load();
                    Phx.CP.loadingHide();
                },
                argument: Phx.CP.argumentSave,
                failure: Phx.CP.conexionFailure,
                timeout: Phx.CP.timeout,
                scope: this
            });
        }

    },
    editCell: function(obj, rowIndex, columnIndex, e){
        this.columnIndex = columnIndex;
        this.idProyectoActivo = this.storeGrid.getAt(rowIndex).data.id_proyecto_activo;
        var nombreActivo = this.storeGrid.getAt(rowIndex).data.denominacion;

        if(columnIndex>=6&&this.idProyectoActivo>0){
            var rec = obj.selModel.selections.items[0].data;
            rec.desc_cc = this.colModel.columns[columnIndex].header;
            rec.id_tipo_cc = this.columnsMapId[columnIndex];

            /*console.log('vvvvvvvvvvv',obj, rowIndex, columnIndex, e);
            console.log('RRR',this.columnsMapId[columnIndex]);
            console.log('colmodel',rec,this.colModel.columns[columnIndex].header);
            console.log('dato',this.storeGrid.getAt(rowIndex));
            this.onButtonNewEdit(rec);*/

            var win = Phx.CP.loadWindows(
                '../../../sis_proyectos/vista/proyecto_activo_detalle/ProyectoActivoDetalle.php',
                'Activo Fijo: '+nombreActivo, {
                    width: 870,
                    height : 620
                },
                rec,
                this.idContenedor,
                'ProyectoActivoDetalle'
            );

            var objWin = Ext.getCmp(win);
            //Evento para el cierre
            objWin.on('close',function(){
                this.storeGrid.load();
            },this);
        }
    },
    crearVentanaDetalle: function(){
        this.txtCentoCosto = new Ext.form.TextField({
            fieldLabel: 'Centro de Costo',
            name: 'det_centro_costo',
            allowBlank: true,
            anchor: '97%',
            readOnly: true,
            style: 'background-color: #ffffb3; background-image: none;'
        });
        this.txtCentoCostoTotal = new Ext.form.TextField({
            fieldLabel: 'Monto Total',
            name: 'det_centro_costo_total',
            allowBlank: true,
            anchor: '97%',
            readOnly: true,
            style: 'background-color: #ffffb3; background-image: none;'
        });
        this.txtCentoCostoSaldo = new Ext.form.TextField({
            fieldLabel: 'Saldo Actual',
            name: 'det_centro_costo_saldo',
            allowBlank: true,
            anchor: '97%',
            readOnly: true,
            style: 'background-color: #ffffb3; background-image: none;'
        });
        this.txtDetDenominacion = new Ext.form.TextField({
            fieldLabel: 'Denominación Activo',
            name: 'det_denominacion',
            allowBlank: true,
            anchor: '97%',
            readOnly: true,
            style: 'background-color: #ffffb3; background-image: none;'
        });
        this.txtDetDescripcion = new Ext.form.TextArea({
            fieldLabel: 'Descripción Activo',
            name: 'det_descripcion',
            allowBlank: true,
            anchor: '97%',
            readOnly: true,
            style: 'background-color: #ffffb3; background-image: none;'
        });
        this.txtDetObservaciones = new Ext.form.TextArea({
            fieldLabel: 'Observación Activo',
            name: 'det_observaciones',
            allowBlank: true,
            anchor: '97%',
            readOnly: true,
            style: 'background-color: #ffffb3; background-image: none;'
        });
        this.txtDetClasificacion = new Ext.form.TextField({
            fieldLabel: 'Clasificación',
            name: 'det_clasificacion',
            allowBlank: true,
            anchor: '97%',
            readOnly: true,
            style: 'background-color: #ffffb3; background-image: none;'
        });
        this.txtMontoActivo = new Ext.form.NumberField({
            fieldLabel: 'Monto Activo',
            name: 'det_monto_activo',
            allowBlank: false,
            anchor: '97%',
            allowDecimals: true,
            decimalPrecision: 2
        });
        this.txtDetObservacionesDet = new Ext.form.TextArea({
            fieldLabel: 'Justificación',
            name: 'det_observaciones',
            allowBlank: false,
            anchor: '97%',
            maxLength: 5000
        });


        this.pnlResumenCC = new Ext.form.FieldSet({
            bodyStyle: 'padding-right:5px;',
            layout: 'form',
            columnWidth: 0.5,
            title: 'Centro de Costo',
            items: [this.txtCentoCosto,this.txtCentoCostoTotal,this.txtCentoCostoSaldo],
            collapsible: true,
            autoHeight: true
        });
        this.pnlDatos = new Ext.form.FieldSet({
            layout: 'form',
            title: 'Costo Activo',
            items: [this.txtMontoActivo,this.txtDetObservacionesDet],
            collapsible: true
        });
        this.pnlResumenAF = new Ext.form.FieldSet({
            layout: 'form',
            title: 'Detalle Activo',
            items: [this.txtDetDenominacion,this.txtDetDescripcion,this.txtDetObservaciones,this.txtDetClasificacion],
            collapsible: true
        });



        //Formulario
        this.frmDatosDet = new Ext.form.FormPanel({
            items: [{
                layout: 'form',
                border: false,
                defaults: {
                    border: false
                },
                items: [this.pnlResumenCC,this.pnlDatos,this.pnlResumenAF]
            }],
            padding: this.paddingForm,
            bodyStyle: this.bodyStyleForm,
            border: this.borderForm,
            frame: this.frameForm, 
            autoScroll: false,
            autoDestroy: true,
            autoScroll: true,
            region: 'center'
        });

        //Ventana
        this.winDatosDet = new Ext.Window({
            width: 800,
            height: 350,
            modal: true,
            closeAction: 'hide',
            labelAlign: 'top',
            title: 'Costeo Activo',
            bodyStyle: 'padding:5px',
            layout: 'border',
            items: [this.frmDatosDet],
            buttons: [{
                text: 'Guardar',
                handler: this.onSubmitDet,
                scope: this
            }, {
                text: 'Cancelar',
                handler: function() {
                    this.winDatosDet.hide();
                },
                scope: this
            }]
        });
    },
    onButtonNewEdit: function(record){
        this.winDatosDet.setTitle('Costeo Activo: '+record.denominacion);
        this.frmDatosDet.getForm().reset();

        this.txtCentoCosto.setValue(record.desc_cc);
        this.txtDetDenominacion.setValue(record.denominacion);
        this.txtDetDescripcion.setValue(record.descripcion);
        this.txtDetObservaciones.setValue(record.observaciones);
        this.txtDetClasificacion.setValue(record.desc_clasificacion);

        this.winDatosDet.show();
    },
    onSubmitDet: function(button, event){
        if(this.frmDatosDet.getForm().isValid()){

            var params = {
                id_proyecto_activo: this.idProyectoActivo,
                id_comprobante: '',
                porcentaje: '',
                id_cotizacion: '',
                observaciones: this.txtObservaciones.getValue(),
                id_tipo_cc: this.columnsMapId[this.columnIndex],
                monto: this.txtMontoActivo.getValue(),
                id_solicitud_efectivo: ''
            };

            Ext.Ajax.request({
                url: '../../sis_proyectos/control/ProyectoActivoDetalle/insertarProyectoActivoDetalle',
                params: params,
                success: function(res,param){
                    var response = Ext.decode(res.responseText).datos;
                    this.winDatosDet.hide();
                    //Cargar store
                    this.storeGrid.load();
                },
                argument: this.argumentSave,
                failure: Phx.CP.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        }
    },
    selectGridRow: function(obj,index,rec){
        this.tbBtnEdit.setDisabled(false);
        this.tbBtnDel.setDisabled(false);
        //Deshabilita los botones de edición y eliminación si son las filas totalizadoras
        if(rec.data.id_proyecto_activo<=0){
            this.tbBtnEdit.setDisabled(true);
            this.tbBtnDel.setDisabled(true);
        }
    },
    deselectGridRow: function(){
        this.tbBtnEdit.setDisabled(true);
        this.tbBtnDel.setDisabled(true);
    },
    cargarTotales: function(){
        Ext.Ajax.request({
            url: '../../sis_proyectos/control/ProyectoActivo/listarProyectoActivoTablaDatosTotales',
            params: {
                start: 0,
                limit: 50,
                sort: 'cc.id_tipo_cc',
                dir: 'ASC',
                id_proyecto_ep: this.id_proyecto_ep,
                id_proyecto: this.id_proyecto
            },
            success: function(res,params){
                var response = Ext.decode(res.responseText).datos;
                console.log('resp AAA',response);

                var recTotal1 = this.definirRecordTotales('TOTAL x CC',response[0], -1),
                    recTotal2 = this.definirRecordTotales('UTILIZADO x CC',response[1], -2),
                    recTotal3 = this.definirRecordSaldo('SALDO x CC',response, -3);

                this.storeGrid.add(recTotal1);
                this.storeGrid.add(recTotal2);
                this.storeGrid.add(recTotal3);
                this.storeGrid.commitChanges();

            },
            argument: this.argumentSave,
            failure: Phx.CP.conexionFailure,
            timeout: this.timeout,
            scope: this
        });



        
    },
    definirRecordTotales: function(label, rec, index){
         //Carga de registro para el total
        var objTotal={}
        objTotal.observaciones = label;
        objTotal.desc_clasificacion = '';
        objTotal.costo = rec.total;
        Ext.iterate(rec, function(key,value,collection){
            objTotal[key] = value;
        },this);

        return new Ext.data.Record(objTotal,label.toLowerCase()+index);
    },
    definirRecordSaldo: function(label,rec,index){
        var objTotal={}
        objTotal.observaciones = label;
        objTotal.desc_clasificacion = '';
        Ext.iterate(rec[0], function(key,value,collection){
            objTotal[key] = rec[0][key]-rec[1][key];
        },this);
        objTotal.id_proyecto_activo = index;
        objTotal.costo = rec[0]['total']-rec[1]['total'];
        return new Ext.data.Record(objTotal,label.toLowerCase()+index);  
    }

});
</script>