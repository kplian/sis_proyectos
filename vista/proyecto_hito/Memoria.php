<?php
/****************************************************************************************
*@package pXP
*@file gen-ProyectoHito.php
*@author  (egutierrez)
*@date 28-09-2020 20:15:06
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                28-09-2020 20:15:06    egutierrez            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Memoria=Ext.extend(Phx.gridInterfaz,{

    tam_pag: 50,
    bottom_filter: true,
    egrid: false,
    tipoStore: 'GroupingStore',//GroupingStore o JsonStore
    remoteGroup: true,
    groupField:'codigo',
    viewGrid: new Ext.grid.GroupingView({
        forceFit:false,
        //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
    }),

    nombreVista:'Memoria',
    constructor:function(config){
        this.maestro=config;
        console.log('config',config);
        //llama al constructor de la clase padre
        this.initButtons=[this.cmbGestion];
        Phx.vista.Memoria.superclass.constructor.call(this,config);
        this.init();
        this.cmbGestion.on('select', function(combo, record, index){
            this.tmpGestion = record.data.gestion;
            this.store.baseParams = {
                nombreVista:this.nombreVista,
                id_proyecto:this.maestro.id_proyecto,
                gestion:this.tmpGestion
            };
            this.load({ params: {start: 0,limit: 50 }});
        },this);




    },

    cmbGestion: new Ext.form.ComboBox({
        fieldLabel: 'Gestion',
        allowBlank: false,
        emptyText:'Gestion...',
        blankText: 'Año',
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Gestion/listarGestion',
                id: 'id_gestion',
                root: 'datos',
                sortInfo:{
                    field: 'gestion',
                    direction: 'DESC'
                },
                totalProperty: 'total',
                fields: ['id_gestion','gestion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_gestion',
        triggerAction: 'all',
        displayField: 'gestion',
        hiddenName: 'id_gestion',
        mode:'remote',
        pageSize:50,
        queryDelay:500,
        listWidth:'280',
        width:80
    }),
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
                name: 'codigo',
                fieldLabel: 'Codigo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:500
            },
            type:'TextField',
            filters:{pfiltro:'prohit.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'importe',
                fieldLabel: 'Importe',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:500
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:true,
        },
         {
            config:{
                name: 'enero',
                fieldLabel: 'Enero',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
                type:'NumberField',
                id_grupo:1,
                grid:true,
                form:false,
		},
        {
            config:{
                name: 'febrero',
                fieldLabel: 'Febrero',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'marzo',
                fieldLabel: 'Marzo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'abril',
                fieldLabel: 'Abril',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'mayo',
                fieldLabel: 'Mayo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'junio',
                fieldLabel: 'Junio',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'julio',
                fieldLabel: 'Julio',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'agosto',
                fieldLabel: 'Agosto',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'septiembre',
                fieldLabel: 'Septiembre',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'octubre',
                fieldLabel: 'Octubre',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },
        {
            config:{
                name: 'noviembre',
                fieldLabel: 'Noviembre',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
            type:'NumberField',
            id_grupo:1,
            grid:true,
            form:false,
        },

        {
            config:{
                name: 'diciembre',
                fieldLabel: 'Diciembre',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10,
                allowDecimals:true,
                decimalPrecision:2,
            },
                type:'NumberField',
                id_grupo:1,
                grid:true,
                form:false,
		},

    ],
    tam_pag:50,    
    title:'Memoria',
    ActList:'../../sis_proyectos/control/ProyectoHito/listarProyectoHitoMemoria',
    id_store:'id',
    fields: [
		{name:'id', type: 'numeric'},
        {name:'codigo', type: 'string'},
        {name:'importe', type: 'string'},
        {name:'enero', type: 'numeric'},
		{name:'febrero', type: 'numeric'},
        {name:'marzo', type: 'numeric'},
        {name:'abril', type: 'numeric'},
        {name:'mayo', type: 'numeric'},
        {name:'junio', type: 'numeric'},
        {name:'julio', type: 'numeric'},
        {name:'agosto', type: 'numeric'},
        {name:'septiembre', type: 'numeric'},
        {name:'octubre', type: 'numeric'},
        {name:'noviembre', type: 'numeric'},
        {name:'diciembre', type: 'numeric'},

    ],
    sortInfo:{
        field: 'id',
        direction: 'ASC'
    },
    bdel:false,
    bsave:false,
    bedit:false,
    bnew:false,
    validarFiltros:function(){
        if(this.cmbGestion.getValue()){
            this.desbloquearOrdenamientoGrid();
            return true;
        }
        else{
            this.bloquearOrdenamientoGrid();
            return false;
        }
    },
    onButtonAct:function(){
        //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentesSS
        if(!this.validarFiltros()){
            alert('Especifique la Gestion')
        }
        else{
            Phx.vista.Memoria.superclass.onButtonAct.call(this);
        }
    },



    }
)
</script>
        
        