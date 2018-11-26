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
    id_proyecto_activo: '',
    tam_pag: 50,
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

        this.getColumns();
        this.crearVentana();
        this.crearVentanaDetalle();
    },
    getColumns: function(){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            //url: '../../sis_parametros/control/CentroCosto/listarCentroCostoProyecto',
            url: '../../sis_proyectos/control/ProyectoColumnaTcc/listarProyectoColumnaTcc',
            params: {
                start: 0,
                limit: 50,
                sort: 'coltcc.id_tipo_cc',
                dir: 'ASC',
                id_proyecto: this.id_proyecto
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
        var rec = this.gridCierre.getSelectionModel().getSelected().data;

        /////////////
        //Drop downs
        ////////////
        //Clasificación
        var recClas = new Ext.data.Record({id_clasificacion: rec.id_clasificacion, clasificacion: rec.desc_clasificacion },'id_clasificacion');
        this.cmbClasificacion.store.add(recClas);
        this.cmbClasificacion.store.commitChanges();
        this.cmbClasificacion.modificado = true;
        this.cmbClasificacion.setValue(rec.id_clasificacion);
        //Depto.
        recClas = new Ext.data.Record({id_depto: rec.id_depto, nombre: rec.desc_depto},'id_depto');
        this.id_depto.store.add(recClas);
        this.id_depto.store.commitChanges();
        this.id_depto.modificado = true;
        this.id_depto.setValue(rec.id_depto);
        //Centro costo
        recClas = new Ext.data.Record({id_centro_costo: rec.id_centro_costo, codigo_cc: rec.desc_centro_costo, movimiento_tipo_pres: 'ingreso_egreso'},'id_centro_costo');
        this.id_centro_costo.store.add(recClas);
        this.id_centro_costo.store.commitChanges();
        this.id_centro_costo.modificado = true;
        this.id_centro_costo.setValue(rec.id_centro_costo);
        //Ubicación
        recClas = new Ext.data.Record({id_ubicacion: rec.id_ubicacion, codigo: rec.desc_ubicacion },'id_ubicacion');
        this.id_ubicacion.store.add(recClas);
        this.id_ubicacion.store.commitChanges();
        this.id_ubicacion.modificado = true;
        this.id_ubicacion.setValue(rec.id_ubicacion);
        //Grupo
        recClas = new Ext.data.Record({id_grupo: rec.id_grupo, nombre: rec.desc_grupo },'id_grupo');
        this.id_grupo.store.add(recClas);
        this.id_grupo.store.commitChanges();
        this.id_grupo.modificado = true;
        this.id_grupo.setValue(rec.id_grupo);
        //Grupo Clasificación
        recClas = new Ext.data.Record({id_grupo_clasif: rec.id_grupo_clasif, nombre: rec.desc_grupo_clasif },'id_grupo_clasif');
        this.id_grupo_clasif.store.add(recClas);
        this.id_grupo_clasif.store.commitChanges();
        this.id_grupo_clasif.modificado = true;
        this.id_grupo_clasif.setValue(rec.id_grupo_clasif);
        //Unidad de Medida
        recClas = new Ext.data.Record({id_unidad_medida: rec.id_unidad_medida, codigo: rec.desc_unmed },'id_unidad_medida');
        this.id_unidad_medida.store.add(recClas);
        this.id_unidad_medida.store.commitChanges();
        this.id_unidad_medida.modificado = true;
        this.id_unidad_medida.setValue(rec.id_unidad_medida);

        ///Fields
        this.id_proyecto_activo = rec.id_proyecto_activo;
        this.txtDenominacion.setValue(rec.denominacion);
        this.txtDescripcion.setValue(rec.descripcion);
        this.txtObservaciones.setValue(rec.observaciones);

        this.cantidad_det.setValue(rec.cantidad_det);
        this.estado.setValue(rec.estado);
        this.ubicacion.setValue(rec.ubicacion);
        this.nro_serie.setValue(rec.nro_serie);
        this.marca.setValue(rec.marca);
        this.fecha_ini_dep.setValue(rec.fecha_ini_dep);
        this.vida_util_anios.setValue(rec.vida_util_anios);
        this.codigo_af_rel.setValue(rec.codigo_af_rel);

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
        _cols.push({header: 'Código AF', dataIndex: 'codigo',renderer: function(value,metadata,rec,index){
            if(rec.data.id_proyecto_activo>0){
                metadata.style="background-color:"+col1;
            }
            return value;
        }});
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
            return String.format('<b >{0}</b>', Ext.util.Format.number(value,'0,000.000000'));
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
        this._colsData.push({name:'cantidad_det',type:'numeric'});
        this._colsData.push({name:'id_depto',type:'numeric'});
        this._colsData.push({name:'estado',type:'string'});
        this._colsData.push({name:'id_lugar',type:'numeric'});
        this._colsData.push({name:'ubicacion',type:'string'});
        this._colsData.push({name:'id_centro_costo',type:'numeric'});
        this._colsData.push({name:'id_ubicacion',type:'numeric'});
        this._colsData.push({name:'id_grupo',type:'numeric'});
        this._colsData.push({name:'id_grupo_clasif',type:'numeric'});
        this._colsData.push({name:'nro_serie',type:'string'});
        this._colsData.push({name:'marca',type:'string'});
        this._colsData.push({name:'fecha_ini_dep',type:'date',dateFormat:'Y-m-d'});
        this._colsData.push({name:'desc_depto', type:'string'});
        this._colsData.push({name:'desc_centro_costo', type:'string'});
        this._colsData.push({name:'desc_ubicacion', type:'string'});
        this._colsData.push({name:'desc_grupo', type:'string'});
        this._colsData.push({name:'desc_clasif_ae', type:'string'});
        this._colsData.push({name:'vida_util_anios', type: 'numeric'});
        this._colsData.push({name:'id_unidad_medida', type: 'numeric'});
        this._colsData.push({name:'codigo_af_rel', type: 'string'});
        this._colsData.push({name:'desc_unmed', type: 'string'});
        this._colsData.push({name:'codigo', type: 'string'});
        this._colsData.push({name:'id_activo_fijo', type: 'numeric'});

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
                return Ext.util.Format.number(value,'0,000.000000');
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
        this.tbBtnDet = new Ext.Button({
            iconCls: 'new',
            tooltip: '<b>Incremento Actualización</b>',
            text: 'Inc.Act.',
            handler: this.onButtonDet,
            scope: this
        });

        /*this.tbBtnImp = new Ext.Button({
            iconCls: 'bact',
            tooltip: '<b>Importa valoración</b>Importa los activos valorados desde un formato excel (xlsx)',
            text: 'Importar Valoración',
            handler: this.SubirArchivo,
            scope: this
        });*/

        this.tbar = new Ext.Toolbar({
          enableOverflow: true,
          defaults: {
               scale: 'large',
               iconAlign:'top',
               minWidth: 50,
               boxMinWidth: 50
            },
            items: [this.tbBtnNew,this.tbBtnEdit,this.tbBtnDel,this.tbBtnAct,this.tbBtnDet]
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
                limit: this.tam_pag,
                dir: 'asc',
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

        //Eventos Grid
        this.gridCierre.on('cellclick', this.abrirEnlace, this);

        //Phx.CP.loadingHide();
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

        this.cantidad_det = new Ext.form.NumberField({
          fieldLabel: 'Cantidad',
          name: 'cantidad_det',
          allowBlank: true,
          maxLength: 100,
          anchor: '97%',
          minValue: 1
        });

        this.id_depto = new Ext.form.ComboBox({
            name: 'id_depto',
            fieldLabel: 'Depto.',
            allowBlank: true,
            emptyText:'Seleccione un registro...',
            store: new Ext.data.JsonStore({
                url: '../../sis_parametros/control/Depto/listarDeptoFiltradoDeptoUsuario',
                id: 'id_depto',
                root: 'datos',
                fields: ['id_depto','codigo','nombre'],
                totalProperty: 'total',
                sortInfo: {
                    field: 'codigo',
                    direction: 'ASC'
                },
                baseParams:{
                    start: 0,
                    limit: 10,
                    sort: 'codigo',
                    dir: 'ASC',
                    codigo_subsistema: 'KAF',
                    par_filtro:'DEPPTO.codigo#DEPPTO.nombre'
                }
            }),
            valueField: 'id_depto',
            displayField: 'nombre',
            gdisplayField: 'codigo_depto',
            hiddenName: 'id_depto',
            mode: 'remote',
            triggerAction: 'all',
            typeAhead: false,
            lazyRender: true,
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['codigo_depto']);
            },
            anchor: '97%'
        });

        this.estado = new Ext.form.TextField({
          fieldLabel: 'Estado',
          name: 'estado',
          allowBlank: true,
          maxLength: 100,
          anchor: '97%'
        });

        this.ubicacion = new Ext.form.TextArea({
          fieldLabel: 'Ubicación',
          name: 'ubicacion',
          allowBlank: true,
          maxLength: 100,
          anchor: '97%'
        });

        this.id_centro_costo = new Ext.form['ComboRec']({
            name: 'id_centro_costo',
            fieldLabel: 'Centro Costo',
            allowBlank: true,
            tinit:false,
            origen:'CENTROCOSTO',
            gdisplayField: 'centro_costo',
            qtip: 'Centro de Costo para la Depreciación',
            width: 350,
            listWidth: 350,
            gwidth: 300,
            renderer:function (value, p, record){return String.format('{0}',record.data['centro_costo']);},
            id: this.idContenedor+'_id_centro_costo'
        });

        this.id_ubicacion = new Ext.form.ComboBox({
            name: 'id_ubicacion',
            fieldLabel: 'Local',
            allowBlank: true,
            emptyText:'Seleccione un registro...',
            store: new Ext.data.JsonStore({
                url: '../../sis_kactivos_fijos/control/Ubicacion/listarUbicacion',
                id: 'id_ubicacion',
                root: 'datos',
                fields: ['id_ubicacion','codigo','nombre'],
                totalProperty: 'total',
                sortInfo: {
                    field: 'codigo',
                    direction: 'ASC'
                },
                baseParams:{
                    start: 0,
                    limit: 10,
                    sort: 'codigo',
                    dir: 'ASC',
                    par_filtro:'ubi.codigo#ubi.nombre'
                }
            }),
            valueField: 'id_ubicacion',
            displayField: 'codigo',
            gdisplayField: 'desc_ubicacion',
            hiddenName: 'id_ubicacion',
            mode: 'remote',
            triggerAction: 'all',
            typeAhead: false,
            lazyRender: true,
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['desc_ubicacion']);
            },
            anchor: '97%'
        });

        this.id_grupo = new Ext.form.ComboBox({
            name: 'id_grupo',
            fieldLabel: 'Grupo AE',
            allowBlank: true,
            emptyText:'Seleccione un registro...',
            store: new Ext.data.JsonStore({
                url: '../../sis_kactivos_fijos/control/Grupo/ListarGrupo',
                id: 'id_grupo',
                root: 'datos',
                sortInfo:{
                    field: 'codigo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_grupo','codigo','nombre'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'codigo#nombre'}
            }),
            valueField: 'id_grupo',
            displayField: 'nombre',
            gdisplayField: 'desc_grupo_ae',
            hiddenName: 'id_grupo',
            mode: 'remote',
            triggerAction: 'all',
            typeAhead: false,
            lazyRender: true,
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['desc_grupo_ae']);
            },
            anchor: '97%'
        });

        this.id_grupo_clasif = new Ext.form.ComboBox({
            name: 'id_grupo_clasif',
            fieldLabel: 'Clasificación AE',
            allowBlank: true,
            emptyText:'Seleccione un registro...',
            store: new Ext.data.JsonStore({
                url: '../../sis_kactivos_fijos/control/Grupo/ListarGrupo',
                id: 'id_grupo',
                root: 'datos',
                sortInfo:{
                    field: 'codigo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_grupo','codigo','nombre'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'codigo#nombre', tipo: 'clasificacion'}
            }),
            valueField: 'id_grupo',
            displayField: 'nombre',
            gdisplayField: 'desc_clasif_ae',
            hiddenName: 'id_grupo',
            mode: 'remote',
            triggerAction: 'all',
            typeAhead: false,
            lazyRender: true,
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['desc_clasif_ae']);
            },
            anchor: '97%'
        });

        this.nro_serie = new Ext.form.TextField({
          fieldLabel: 'Nro.Serie',
          name: 'nro_serie',
          allowBlank: true,
          maxLength: 100,
          anchor: '97%'
        });

        this.marca = new Ext.form.TextField({
          fieldLabel: 'Marca',
          name: 'marca',
          allowBlank: true,
          maxLength: 100,
          anchor: '97%'
        });

        this.fecha_ini_dep = new Ext.form.DateField({
          fieldLabel: 'Fecha Inicio Depreciación',
          name: 'fecha_ini_dep',
          allowBlank: true,
          maxLength: 100,
          anchor: '97%'
        });

        this.vida_util_anios = new Ext.form.NumberField({
          fieldLabel: 'Vida Útil (Años)',
          name: 'vida_util_anios',
          allowBlank: false,
          anchor: '97%'
        });

        this.id_unidad_medida = new Ext.form.ComboBox({
            name: 'id_unidad_medida',
            fieldLabel: 'Unidad Medida',
            allowBlank: false,
            emptyText:'Seleccione un registro...',
            store: new Ext.data.JsonStore({
                url: '../../sis_parametros/control/UnidadMedida/listarUnidadMedida',
                id: 'id_unidad_medida',
                root: 'datos',
                sortInfo:{
                    field: 'codigo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_unidad_medida','codigo','descripcion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'codigo#descripcion'}
            }),
            valueField: 'id_unidad_medida',
            displayField: 'codigo',
            gdisplayField: 'desc_unmed',
            hiddenName: 'id_unidad_medida',
            mode: 'remote',
            triggerAction: 'all',
            typeAhead: false,
            lazyRender: true,
            pageSize: 15,
            queryDelay: 1000,
            minChars: 2,
            renderer: function(value, p, record) {
                return String.format('{0}', record.data['desc_unmed']);
            },
            anchor: '97%'
        });

        this.codigo_af_rel = new Ext.form.TextField({
          fieldLabel: 'Código AF relacionado',
          name: 'codigo_af_rel',
          allowBlank: true,
          maxLength: 100,
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
                    items: [this.cmbClasificacion,this.txtDenominacion,this.txtDescripcion,this.txtObservaciones,
                            this.cantidad_det,this.id_unidad_medida, this.id_depto, this.estado, this.ubicacion, this.id_centro_costo,
                            this.id_ubicacion, this.id_grupo, this.id_grupo_clasif, this.nro_serie, this.marca, this.fecha_ini_dep,
                            this.vida_util_anios,this.codigo_af_rel],
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
                observaciones: this.txtObservaciones.getValue(),
                cantidad_det: this.cantidad_det.getValue(),
                id_depto: this.id_depto.getValue(),
                estado: this.estado.getValue(),
                ubicacion: this.ubicacion.getValue(),
                id_centro_costo: this.id_centro_costo.getValue(),
                id_ubicacion: this.id_ubicacion.getValue(),
                id_grupo: this.id_grupo.getValue(),
                id_grupo_clasif: this.id_grupo_clasif.getValue(),
                nro_serie: this.nro_serie.getValue(),
                marca: this.marca.getValue(),
                fecha_ini_dep: this.fecha_ini_dep.getValue(),
                vida_util_anios: this.vida_util_anios.getValue(),
                id_unidad_medida: this.id_unidad_medida.getValue(),
                codigo_af_rel: this.codigo_af_rel.getValue()
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
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url: '../../sis_proyectos/control/ProyectoActivo/listarProyectoActivoTablaDatosTotales',
            params: {
                start: 0,
                limit: this.tam_pag,
                sort: 'cc.id_tipo_cc',
                dir: 'ASC',
                id_proyecto: this.id_proyecto
            },
            success: function(res,params){
                var response = Ext.decode(res.responseText).datos;
                var recTotal1 = this.definirRecordTotales('MAYOR x CC',response[0], -1),
                    recTotal2 = this.definirRecordTotales('CIERRE x CC',response[1], -2),
                    recTotal3 = this.definirRecordSaldo('SALDO x CC',response, -3);

                this.storeGrid.add(recTotal1);
                this.storeGrid.add(recTotal2);
                this.storeGrid.add(recTotal3);
                this.storeGrid.commitChanges();
                Phx.CP.loadingHide();
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
        console.log('def',index,rec)
        var objTotal={}
        objTotal.observaciones = label;
        objTotal.desc_clasificacion = '';
        Ext.iterate(rec[0], function(key,value,collection){
            objTotal[key] = rec[0][key]-rec[1][key];
        },this);
        objTotal.id_proyecto_activo = index;
        objTotal.costo = rec[0]['total']-rec[1]['total'];
        return new Ext.data.Record(objTotal,label.toLowerCase()+index);
    },
    SubirArchivo: function(rec)
    {
        Phx.CP.loadWindows
        (
            '../../../sis_contabilidad/vista/int_transaccion/SubirArchivoTran.php',
            'Subir Transacciones desde Excel',
            {
                modal: true,
                width: 450,
                height: 150
            },
            this.maestro,
            this.idContenedor,
            'SubirArchivoTran'
        );
    },

    onButtonDet: function(){
        var data=this.gridCierre.getSelectionModel().getSelected().data;
        Phx.CP.loadWindows('../../../sis_proyectos/vista/proyecto_activo_det_mon/ProyectoActivoDetMon.php',
            'Incrementro por Actualización ',
            {
                width:'90%',
                height:'90%'
            },
            data,
            this.idContenedor,
            'ProyectoActivoDetMon'
        )
    },
    abrirEnlace: function(cell,rowIndex,columnIndex,e){
        if(cell.colModel.getColumnHeader(columnIndex)=='Código AF'){
            var data = this.gridCierre.getSelectionModel().getSelected().data;
            if(data.id_activo_fijo){
                Phx.CP.loadWindows('../../../sis_kactivos_fijos/vista/activo_fijo/ActivoFijo.php',
                    'Detalle', {
                        width:'90%',
                        height:'90%'
                    }, {
                        lnk_id_activo_fijo: data.id_activo_fijo,
                        link: true
                    },
                    this.idContenedor,
                    'ActivoFijo'
                );
            }
        }
    }

});
</script>