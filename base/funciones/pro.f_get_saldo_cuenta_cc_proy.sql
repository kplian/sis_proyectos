CREATE OR REPLACE FUNCTION pro.f_get_saldo_cuenta_cc_proy (
  p_id_proyecto integer,
  p_id_tipo_cc integer,
  p_nro_cuenta varchar,
  out o_total numeric,
  out o_utilizado numeric,
  out o_saldo numeric
)
RETURNS record AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Proyectos
 FUNCION:       pro.f_get_saldo_cuenta_cc_proy
 DESCRIPCION:   Obtiene el saldo disponible de un Centro de Costo de un proyecto específico   
 AUTOR:         (RCM)
 FECHA:         13/10/2017
 COMENTARIOS:   
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   
 AUTOR:         
 FECHA:     
***************************************************************************/
DECLARE
    
    v_nombre_funcion    text;
    v_resp              varchar;
    v_total_cc          numeric;
    v_utilizado_cc      numeric;
    v_saldo_cc          numeric;
    v_id_proyecto_ep    integer;

BEGIN

    v_nombre_funcion = 'pro.f_get_saldo_cuenta_cc_proy';

    --Obtención del id del proyecto de la EP
    select id_proyecto_ep
    into v_id_proyecto_ep
    from pro.tproyecto proy
    where proy.id_proyecto = p_id_proyecto;

    if v_id_proyecto_ep is null then
        raise exception 'Proyecto EP inexistente';
    end if;

    --Obtención del TOTAL del CC
    select
    sum(ran.debe_mb) - sum(ran.haber_mb)
    into v_total_cc
    from conta.trango ran
    inner join param.ttipo_cc tcc
    on tcc.id_tipo_cc = ran.id_tipo_cc
    inner join param.tcentro_costo cc
    on cc.id_tipo_cc = tcc.id_tipo_cc
    inner join param.tep ep
    on ep.id_ep = cc.id_ep
    inner join param.tprograma_proyecto_acttividad ppa
    on ppa.id_prog_pory_acti = ep.id_prog_pory_acti
    where ppa.id_proyecto = v_id_proyecto_ep
    and tcc.id_tipo_cc = p_id_tipo_cc;

    --Obtención del total utilizado del CC en el cierre
    select
    sum(pad.monto)
    into v_utilizado_cc
    from pro.tproyecto_activo paf
    inner join pro.tproyecto_activo_detalle pad
    on pad.id_proyecto_activo = paf.id_proyecto_activo
    where paf.id_proyecto = p_id_proyecto
    and pad.id_tipo_cc = p_id_tipo_cc;

    --Obtención del saldo
    v_saldo_cc = coalesce(v_total_cc,0) - coalesce(v_utilizado_cc,0);

    --Salida
    o_total = coalesce(v_total_cc,0);
    o_utilizado = coalesce(v_utilizado_cc,0);
    o_saldo = coalesce(v_saldo_cc,0);
   

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