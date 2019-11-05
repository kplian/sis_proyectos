
<?php
/**
 *@package pXP
 *@file gen-SistemaDist.php
 *@author  (fprudencio)
 *@date 20-09-2011 10:22:05
 *@description Archivo con la interfaz de usuario que permite
 *el inico de procesos de compra a partir de las solicitude aprobadas
 *
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ComponenteConceptoIngas = {
        require: '../../../sis_proyectos/vista/componente_concepto_ingas/ComponenteConceptoIngasBase.php',
        requireclase: 'Phx.vista.ComponenteConceptoIngasBase',
        title: 'Unidad Constructiva...',
        nombreVista: 'ComponenteConceptoIngas',
        constructor: function(config) {
            Phx.vista.ComponenteConceptoIngas.superclass.constructor.call(this,config);
        }
    };
</script>