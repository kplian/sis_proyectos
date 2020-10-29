<?php
/****************************************************************************************
*@package pXP
*@file gen-CuentaIncluir.php
*@author  (egutierrez)
*@date 19-10-2020 14:17:13
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                19-10-2020 14:17:13    egutierrez            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CuentaIncluir=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.CuentaIncluir.superclass.constructor.call(this,config);
        this.init();
        this.load({params:{start:0, limit:this.tam_pag}})
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_cuenta_incluir'
            },
            type:'Field',
            form:true 
        },
        {
            config: {
                name: 'nro_cuenta',
                fieldLabel: 'Código Cuenta',
                allowBlank: false,
                anchor: '80%',
                gwidth: 250,
                maxLength: 20
            },
            type: 'TextField',
            filters: { pfiltro: 'cunexc.nro_cuenta', type: 'string'},
            id_grupo: 1,
            grid: true,
            form: true,
            bottom_filter: true
        },
        {
            config: {
                name: 'tipo',
                fieldLabel: 'Tipo',
                anchor: '100%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'tipo',
                hiddenName: 'tipo',
                gwidth: 150,
                baseParams:{
                    cod_subsistema:'PRO',
                    catalogo_tipo:'tcuenta_excluir_tipo'
                },
                valueField: 'codigo',
                hidden: false
            },
            valorInicial: 'diferido',
            type: 'ComboRec',
            id_grupo: 0,
            grid: true,
            form: true
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
            filters:{pfiltro:'cueinc.estado_reg',type:'string'},
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
                filters:{pfiltro:'cueinc.fecha_reg',type:'date'},
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
                filters:{pfiltro:'cueinc.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'cueinc.usuario_ai',type:'string'},
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
                filters:{pfiltro:'cueinc.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Cuentas a Incluir',
    ActSave:'../../sis_proyectos/control/CuentaIncluir/insertarCuentaIncluir',
    ActDel:'../../sis_proyectos/control/CuentaIncluir/eliminarCuentaIncluir',
    ActList:'../../sis_proyectos/control/CuentaIncluir/listarCuentaIncluir',
    id_store:'id_cuenta_incluir',
    fields: [
		{name:'id_cuenta_incluir', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'nro_cuenta', type: 'string'},
		{name:'tipo', type: 'string'},
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
        field: 'id_cuenta_incluir',
        direction: 'ASC'
    },
    bdel:true,
    bsave:true
    }
)
</script>
        
        