<font size="12">
<table  width="100%" cellpadding="5px"  border="1" >
		<tr>
            <td style="text-align:justify" width="100%" ><b>Justificación del Proyecto: </b><?php  echo $this->datos_proyecto[0]['justificacion']; ?>
            </td>
<!--            <td style="text-align:justify" width="70%">-->
<!--                --><?php // echo $this->datos_proyecto[0]['justificacion']; ?>
<!--            </td>-->
		</tr>

        <tr>
            <td style="text-align:left" width="30%" ><b>Tiempo Ejecución:</b>
            </td>

            <td style="text-align:justify" width="70%">
               <table>
                   <tr>
                       <td width="20%"><b>Desde:</b>
                       </td>
                       <td width="80%">
                           <?php  echo date("d/m/Y",strtotime($this->datos_proyecto[0]['fecha_ini']));?>
                       </td>

                   </tr>
                   <tr>
                       <td><b>Hasta:</b>
                       </td>
                       <td>
                           <?php echo date("d/m/Y",strtotime($this->datos_proyecto[0]['fecha_fin']));?>
                       </td>

                   </tr>
               </table>
            </td>
        </tr>
        <tr>
            <td style="text-align:justify" width="100%" ><b>Caracteristicas Técnicas:</b> <?php echo $this->datos_proyecto[0]['caracteristica_tecnica']; ?>
            </td>
<!--            <td style="text-align:justify" width="70%">-->
<!--                --><?php // echo $this->datos_proyecto[0]['caracteristica_tecnica']; ?>
<!--            </td>-->
        </tr>

        <tr>
            <td style="text-align:left" width="30%" ><b>Stea:</b>
            </td>
            <td style="text-align:justify" width="70%">
                <?php  echo number_format($this->datos_proyecto[0]['importe_max'], 2, ',', '.'); echo ' ' ; echo $this->datos_proyecto[0]['desc_moneda'] ; ?>
            </td>
        </tr>

</table></font>