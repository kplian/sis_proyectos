<?php
/**
 *@package pXP
 *@file ConceptoIngasPro.php
 *@author  (admin)
 *@date 07-03-2019 13:53:18
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ConceptoIngasAgrPro={
        require:'../../../sis_parametros/vista/concepto_ingas_agrupador/ConceptoIngasAgrupador.php',
        requireclase:'Phx.vista.ConceptoIngasAgrupador',
        title:'Agrupador Concepto Ingreso/Gasto',
        nombreVista: 'ConceptoIngasAgrPro',
        constructor:function(config){

            this.maestro = config;
            this.unirAtributos(); //ejecutamos primero para que los atributos extra se carguen y visualizaen
            Phx.vista.ConceptoIngasAgrPro.superclass.constructor.call(this,config);
            this.maestro=this;
            this.init();
            this.load({params:{start:0, limit:this.tam_pag , nombreVista:this.nombreVista }});
            this.iniciaEventos();
            //this.grid.addListener('cellclick', this.oncellclick,this);
        },
        iniciaEventos : function(){
        },
        preparaMenu:function(n){
            var data = this.getSelectedData();
            var tb =this.tbar;
            Phx.vista.ConceptoIngasAgrPro.superclass.preparaMenu.call(this,n);
            //this.getBoton('diagrama_gantt').enable();
            return tb
        },
        liberaMenu:function(){
            var tb = Phx.vista.ConceptoIngasAgrPro.superclass.liberaMenu.call(this);
            if(tb){
                //this.getBoton('btnChequeoDocumentosWf').disable();

            }
            return tb
        },

        onButtonNew:function(){
            //llamamos primero a la funcion new de la clase padre por que reseta el valor los componentes
            //this.ocultarComponente(this.Cmp.fecha_ini);
            Phx.vista.ConceptoIngasAgrPro.superclass.onButtonNew.call(this);
        },
        unirAtributos: function (){
            var me = this;
            this.Atributos = this.Atributos.concat(me.extraAtributos);
            this.fields = this.fields.concat(me.extraFields);
        },

        extraAtributos:[
            /*  {
        config:{
            name: 'es_obra_civil',
            fieldLabel: 'Obra Civil',
            allowBlank: true,
            anchor: '40%',
            gwidth: 100,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender:true,
            mode: 'local',
            store:['si','no'],
            renderer:function (value,p,record){
                console.log('record grid',record);
                var checked = '';
                if(value === 'si'){
                    checked = 'checked';
                }
                return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:30px;width:30px;" type="checkbox"{0}></div>',checked);

            }
        },
        type:'ComboBox',
        id_grupo:0,
        valorInicial: 'no',
        grid: true,
        form: true
    },*/
            {
                config:{
                    name : 'es_obra_civil',
                    fieldLabel : 'Obra Civil',
                    allowBlank: false,
                    items: [
                        {boxLabel: 'No', name: 'es_obra_civil', inputValue: 'no', checked: true},
                        {boxLabel: 'Si', name: 'es_obra_civil', inputValue: 'si'}

                    ],
                },
                type : 'RadioGroupField',
                id_grupo : 1,
                form : true,
                grid:true
            },
            {//#22
                config: {
                    name: 'tipo_agrupador',
                    fieldLabel: 'Tipo',
                    anchor: '95%',
                    tinit: false,
                    allowBlank: true,
                    origen: 'CATALOGO',
                    gdisplayField: 'tipo_agrupador',
                    hiddenName: 'tipo_agrupador',
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:150,
                    baseParams:{
                        cod_subsistema:'PRO',
                        catalogo_tipo:'tcomponente_macro_tipo'
                    },
                    valueField: 'codigo',
                    hidden: false,
                    renderer: function(value, p, record) {
                        return String.format('{0}', record.data['tipo_agrupador']);
                    },
                },
                type: 'ComboRec',
                id_grupo: 0,
                grid: true,
                form: true
            },
        ],

        extraFields:[
            {name:'tipo_agrupador', type: 'string'},
            {name:'es_obra_civil', type: 'string'},
        ],
        arrayDefaultColumHidden:['fecha_mod','usr_reg','usr_mod','estado_reg','fecha_reg','id_usuario_ai','usuario_ai'],
        oncellclick : function(grid, rowIndex, columnIndex, e) {
            const record = this.store.getAt(rowIndex);
            console.log('record',this.store.getAt(rowIndex));
            console.log('grid',grid);
            console.log('rowIndex',rowIndex);
            console.log('columnIndex',columnIndex);
            console.log('e',e);
            console.log('cmp',this.Cmp.es_obra_civil);
            record.set('es_obra_civil',record.originalValue);
            //fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
            //if (fieldName === 'es_obra_civil')
            //this.insertObraCivil(record,fieldName);


        },
        insertObraCivil: function(record,name){
            Phx.CP.loadingShow();
            console.log('record',record);
            var data = record.data;
            var es_oc = this.Cmp.es_obra_civil.getValue();
            Ext.Ajax.request({
                url:'../../sis_parametros/control/ConceptoIngasAgrupador/insertObraCivil',
                params:{
                    id_concepto_ingas_agrupador: data.id_concepto_ingas_agrupador,
                    es_obra_civil: es_oc,
                    field_name: name
                },
                success: this.successRevision,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
            this.reload();
        },
        successRevision: function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        },
    }
</script>

