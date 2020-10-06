<?php
/****************************************************************************************
*@package pXP
*@file gen-ProyectoAnalisis.php
*@author  (egutierrez)
*@date 29-09-2020 12:44:10
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                29-09-2020 12:44:10    egutierrez            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoAnalisis=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        let total_registros;
        let formr;
        console.log('config',config);
        this.maestro=config;
        this.Atributos[this.getIndAtributo('id_proyecto')].valorInicial = this.maestro.id_proyecto;
        //llama al constructor de la clase padre
        Phx.vista.ProyectoAnalisis.superclass.constructor.call(this,config);
        this.init();
        this.store.baseParams = {
            id_proyecto: this.maestro.id_proyecto
        };
        this.load({
            params: {
                start: 0,
                limit: 50
            }
        });
    },

    Atributos:[
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
                name:'id_proveedor',
                hiddenName: 'id_proveedor',
                origen:'PROVEEDOR',
                fieldLabel:'Proveedor',
                allowBlank:false,
                baseParams: { par_filtro: 'id_proveedor#desc_proveedor#codigo#rotulo_comercial'},
                //tinit:false,
                width: '80%',
                valueField: 'id_proveedor',
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_proveedor']);}
            },
            type:'ComboRec',//ComboRec
            id_grupo:1,
            form:true,
            grid:true
        },
        {
            config:{
                name: 'fecha',
                fieldLabel: 'Fecha',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'proana.fecha',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'glosa',
                fieldLabel: 'Glosa',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:500
            },
                type:'TextField',
                filters:{pfiltro:'proana.glosa',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:30
            },
                type:'TextField',
                filters:{pfiltro:'proana.estado',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'saldo_activo',
                fieldLabel: 'Saldo Activo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30,
                allowDecimals : true,
                decimalPrecision : 2,
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,000/i'));

                }
            },
            type:'NumberField',
            filters:{pfiltro:'proana.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },

        {
            config:{
                name: 'saldo_pasivo',
                fieldLabel: 'Saldo Pasivo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30,
                allowDecimals : true,
                decimalPrecision : 2,
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,000/i'));

                }
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'saldo_ingreso',
                fieldLabel: 'Saldo Ingreso',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30,
                allowDecimals : true,
                decimalPrecision : 2,
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,000/i'));

                }
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'saldo_gasto',
                fieldLabel: 'Saldo Gasto',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30,
                allowDecimals : true,
                decimalPrecision : 2,
                renderer:function (value,p,record){
                    Ext.util.Format.usMoney
                    return  String.format('<b><font size=2 >{0}</font><b>', Ext.util.Format.number(value,'000.000.000,000/i'));

                }
            },
            type:'NumberField',
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
            filters:{pfiltro:'proana.estado_reg',type:'string'},
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
                filters:{pfiltro:'proana.fecha_reg',type:'date'},
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
                filters:{pfiltro:'proana.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'proana.usuario_ai',type:'string'},
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
                filters:{pfiltro:'proana.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Análisis Ingresos Diferidos',
    ActSave:'../../sis_proyectos/control/ProyectoAnalisis/insertarProyectoAnalisis',
    ActDel:'../../sis_proyectos/control/ProyectoAnalisis/eliminarProyectoAnalisis',
    ActList:'../../sis_proyectos/control/ProyectoAnalisis/listarProyectoAnalisis',
    id_store:'id_proyecto_analisis',
    fields: [
		{name:'id_proyecto_analisis', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'glosa', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'id_proveedor', type: 'string'},
        {name:'desc_proveedor', type: 'string'},
        {name:'saldo_activo', type: 'numeric'},
        {name:'saldo_pasivo', type: 'numeric'},
        {name:'saldo_ingreso', type: 'numeric'},
        {name:'saldo_gasto', type: 'numeric'},
        
    ],
    sortInfo:{
        field: 'id_proyecto_analisis',
        direction: 'ASC'
    },
    bdel:true,
    bsave:true,
    tabsouth: [
        {
            url:'../../../sis_proyectos/vista/proyecto_analisis_det/ProyectoAnalisisDetActivo.php',
            title:'Activo',
            height:'50%',
            cls:'ProyectoAnalisisDetActivo'
        },
        {
            url:'../../../sis_proyectos/vista/proyecto_analisis_det/ProyectoAnalisisDetPasivo.php',
            title:'Pasivo',
            height:'50%',
            cls:'ProyectoAnalisisDetPasivo'
        },
        {
            url:'../../../sis_proyectos/vista/proyecto_analisis_det/ProyectoAnalisisDetIngreso.php',
            title:'Ingreso',
            height:'50%',
            cls:'ProyectoAnalisisDetIngreso'
        },
        {
            url:'../../../sis_proyectos/vista/proyecto_analisis_det/ProyectoAnalisisDetGasto.php',
            title:'Gasto',
            height:'50%',
            cls:'ProyectoAnalisisDetGasto'
        }],

        onButtonNew:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentesSS
            Phx.vista.ProyectoAnalisis.superclass.onButtonNew.call(this);
            this.formr = 'new';
            this.obtenerProveedor(this.maestro);


        },
    onButtonEdit:function(){
        //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentesSS
        Phx.vista.ProyectoAnalisis.superclass.onButtonEdit.call(this);
        var data = this.getSelectedData();
        this.formr = 'edit';
        this.obtenerProveedor(this.maestro);
    },
    obtenerProveedor: function(config){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_proyectos/control/ProyectoAnalisis/listarProyectoProveedor',
            params:{
                id_proyecto:  this.Cmp.id_proyecto.getValue()
            },
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                    console.log('reg.datos[0]',reg.datos[0]);
                if (reg.datos.length != 0 && this.formr =='new'){
                    this.Cmp.id_proveedor.store.baseParams.query = reg.datos[0]['id_proveedor'];
                    this.Cmp.id_proveedor.store.load({params:{start:0,limit:this.tam_pag},
                        callback : function (r) {
                            if (r.length > 0 ) {
                                this.Cmp.id_proveedor.setValue(r[0].data.id_proveedor);
                                this.Cmp.id_proveedor.disable();
                            }else{
                                this.Cmp.id_proveedor.reset();
                                this.Cmp.id_proveedor.enable();
                            }
                        }, scope : this
                    });
                }
                if(reg.datos[0] == undefined ){
                    this.total_registros = 1;
                }else{
                    this.total_registros = reg.datos[0]['total_registros'];
                }
                if(this.total_registros == 1 ){
                    this.Cmp.id_proveedor.enable();
                }
                else{
                    this.Cmp.id_proveedor.disable();
                }

            },
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope:this
        });

    },
   
    }
)
</script>
        
        