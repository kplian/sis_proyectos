
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
    Phx.vista.UnidadComingdet = {
        require: '../../../sis_proyectos/vista/unidad_comingdet/UnidadComingdetBase.php',
        requireclase: 'Phx.vista.UnidadComingdetBase',
        title: 'Unidad Constructiva...',
        nombreVista: 'UnidadComingdet',
        constructor: function(config) {
            Phx.vista.UnidadComingdet.superclass.constructor.call(this,config);
        }
    };
</script>