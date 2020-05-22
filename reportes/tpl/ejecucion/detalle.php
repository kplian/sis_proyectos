<font size="12"><table width="100%" cellpadding="5px"  rules="cols" border="1">
        <tr>
            <td style="text-align:center"  width="100%" >
                <b>Resumen Ejecución Presupuestaria</b>
            </td>

        </tr>
        <tr>
            <td style="text-align:left"  width="30%" ><b>Total Ejecutado Hasta el Momento:</b>
            </td>
            <td style="text-align:justify" width="70%">
                <?php  echo number_format( $this->datos_ejecucion_total[0]['total_monto_mb'] , 2, ',', '.').' '.$this->datos_ejecucion_total[0]['desc_moneda_base']; ?>
            </td>
        </tr>
        <tr>
            <td style="text-align:left" width="30%" ><b>Presupuesto Vigente para la Gestión:</b>
            </td>
            <td style="text-align:justify" width="70%">&nbsp;&nbsp;
                <?php  echo number_format( $this->datos_presupuesto_gestion[0]['gestion_monto_mb'] , 2, ',', '.').' '.$this->datos_presupuesto_gestion[0]['desc_moneda_base']; ?>
            </td>
        </tr>
</table></font>
<br/>
<table width="100%" align="center" cellpadding="10px">
    <tr>
        <td><p><b>Ejecución por Gestión</b></p></td>
    </tr>
</table>


<table border="1">
       <tr align="center">
<?php
     $i = 1;
    foreach ($this->datos_ejecucion as $datos) {
        echo '<td style=" background-color:#AFA6A5  ;">' . $datos['gestion'] .'</td>';
        $i++;
    }
    ?>
    </tr>
    <tr >
        <?php
        $i = 1;
        foreach ($this->datos_ejecucion as $datos) {
            echo '<td style=""> &nbsp; ' .  number_format( $datos['monto_mb'] , 2, ',', '.').' '.$datos['desc_moneda_base'].'</td>';
            $i++;
        }
        ?>
    </tr>
</table>
