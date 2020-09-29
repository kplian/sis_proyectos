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
Phx.vista.ProyectoHito=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.ProyectoHito.superclass.constructor.call(this,config);
        this.init();
        this.bloquearMenus();
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_proyecto_hito'
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
                name: 'descripcion',
                fieldLabel: 'Descripcion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:500
            },
                type:'TextField',
                filters:{pfiltro:'prohit.descripcion',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'fecha_plan',
                fieldLabel: 'Fecha Plan',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'prohit.fecha_plan',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'importe_plan',
                fieldLabel: 'Importe Plan',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:-5
            },
                type:'NumberField',
                filters:{pfiltro:'prohit.importe_plan',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'fecha_real',
                fieldLabel: 'Fecha Real',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'prohit.fecha_real',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'importe_real',
                fieldLabel: 'Importe Real',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:-5
            },
                type:'NumberField',
                filters:{pfiltro:'prohit.importe_real',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'observaciones',
                fieldLabel: 'Observaciones',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:500
            },
                type:'TextField',
                filters:{pfiltro:'prohit.observaciones',type:'string'},
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
            filters:{pfiltro:'prohit.estado_reg',type:'string'},
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
                filters:{pfiltro:'prohit.fecha_reg',type:'date'},
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
                filters:{pfiltro:'prohit.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'prohit.usuario_ai',type:'string'},
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
                filters:{pfiltro:'prohit.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Hitos de Negocio Complementario',
    ActSave:'../../sis_proyectos/control/ProyectoHito/insertarProyectoHito',
    ActDel:'../../sis_proyectos/control/ProyectoHito/eliminarProyectoHito',
    ActList:'../../sis_proyectos/control/ProyectoHito/listarProyectoHito',
    id_store:'id_proyecto_hito',
    fields: [
		{name:'id_proyecto_hito', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_proyecto', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'fecha_plan', type: 'date',dateFormat:'Y-m-d'},
		{name:'importe_plan', type: 'numeric'},
		{name:'fecha_real', type: 'date',dateFormat:'Y-m-d'},
		{name:'importe_real', type: 'numeric'},
		{name:'observaciones', type: 'string'},
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
        field: 'id_proyecto_hito',
        direction: 'ASC'
    },
    bdel:true,
    bsave:true,
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
        
        