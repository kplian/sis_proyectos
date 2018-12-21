CREATE OR REPLACE FUNCTION pro.f_i_kaf_actualizar_importe (
  p_fecha_ini date,
  p_fecha_fin date,
  p_importe numeric,
  p_id_moneda integer
)
RETURNS numeric AS
$body$
/**************************************************************************
 SISTEMA:     Sistema de Proyectos
 FUNCION:     pro.f_i_kaf_actualizar_importe
 DESCRIPCION: Actualiza el importe por inflación en el periodo de la fecha ini y fecha fin
 AUTOR:       RCM
 FECHA:       11/12/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE

    v_nombre_funcion text;
    v_resp varchar;
    v_importe numeric;
    v_importe_actualizado numeric;
    v_id_moneda_base integer;
    v_id_moneda_act integer;
    v_tc_ini numeric;
    v_tc_fin numeric;

BEGIN

    --Se obtiene la moneda base
    v_id_moneda_base = param.f_get_moneda_base();

    --Si la moneda del importe es diferente a la moneda base, hace la conversión a la moneda base
    v_importe = p_importe;
    if v_id_moneda_base <> p_id_moneda then
        v_importe = param.f_convertir_moneda(p_id_moneda, v_id_moneda_base,p_importe,p_fecha_fin,'O',6);
    end if;

    --Obtener la moneda de actualización
    select id_moneda_act
    into v_id_moneda_act
    from kaf.tmoneda_dep
    where id_moneda = v_id_moneda_base;

    --Obtener los tipos de cambio de UFV de inicio y fin
    v_tc_ini = param.f_get_tipo_cambio_v2(v_id_moneda_base, v_id_moneda_act, p_fecha_ini, 'O');
    v_tc_fin = param.f_get_tipo_cambio_v2(v_id_moneda_base, v_id_moneda_act, p_fecha_fin, 'O');

    --Actualización del importe
    v_importe_actualizado = v_importe * v_tc_fin / v_tc_ini;

    --Respuesta
    return round(v_importe_actualizado,2);


EXCEPTION

    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;