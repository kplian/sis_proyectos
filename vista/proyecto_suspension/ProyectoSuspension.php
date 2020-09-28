<?php
/****************************************************************************************
*@package pXP
*@file gen-ProyectoSuspension.php
*@author  (egutierrez)
*@date 28-09-2020 19:25:30
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                28-09-2020 19:25:30    egutierrez            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProyectoSuspension=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.ProyectoSuspension.superclass.constructor.call(this,config);
        this.init();
        this.bloquearMenus();
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_proyecto_suspension'
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
                name: 'fecha_desde',
                fieldLabel: 'Fecha Desde',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'regsus.fecha_desde',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'fecha_hasta',
                fieldLabel: 'Fecha Hasta',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'regsus.fecha_hasta',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'Descripcion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:500
            },
                type:'TextField',
                filters:{pfiltro:'regsus.descripcion',type:'string'},
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
            filters:{pfiltro:'regsus.estado_reg',type:'string'},
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
                filters:{pfiltro:'regsus.fecha_reg',type:'date'},
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
                filters:{pfiltro:'regsus.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'regsus.usuario_ai',type:'string'},
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
                filters:{pfiltro:'regsus.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Registros de Suspensiones',
    ActSave:'../../sis_proyectos/control/ProyectoSuspension/insertarProyectoSuspension',
    ActDel:'../../sis_proyectos/control/ProyectoSuspension/eliminarProyectoSuspension',
    ActList:'../../sis_proyectos/control/ProyectoSuspension/listarProyectoSuspension',
    id_store:'id_proyecto_suspension',
    fields: [
		{name:'id_proyecto_suspension', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'fecha_desde', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_hasta', type: 'date',dateFormat:'Y-m-d'},
		{name:'descripcion', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        
    ],
    sortInfo:{
        field: 'id_proyecto_suspension',
        direction: 'ASC'
    },
    bdel:true,
    bsave:false,
    onReloadPage: function(m) {
        this.maestro = m;
        this.Atributos[1].valorInicial = this.maestro.id_proyecto;
        //Define the filter to apply for activos fijod drop down
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
    }
)
</script>
        
        