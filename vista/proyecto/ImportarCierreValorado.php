<?php
/**
*@package pXP
*@file    SubirArchivo.php
*@author  RCM
*@date    13/09/2018
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ImportarCierreValorado=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_proyectos/control/Proyecto/ImportarCierreValorado',

    constructor:function(config){
        Phx.vista.ImportarCierreValorado.superclass.constructor.call(this,config);
        this.init();
        this.loadValoresIniciales();
    },

    loadValoresIniciales:function(){
        Phx.vista.ImportarCierreValorado.superclass.loadValoresIniciales.call(this);
        this.getComponente('id_proyecto').setValue(this.id_proyecto);
    },

    successSave:function(resp){
        console.log('sssssssss');
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
    },


    Atributos:[
        {
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
                fieldLabel: 'Archivo',
                gwidth: 130,
                inputType: 'file',
                name: 'archivo',
                allowBlank: false,
                buttonText: '',
                maxLength: 150,
                anchor:'100%'
            },
            type:'Field',
            form:true
        }
    ],
    title:'Subir Archivo',
    fileUpload:true

}
)
</script>
