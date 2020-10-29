--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_fun_inicio_proyecto_analisis_wf (
  p_id_proyecto_analisis integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_estado_anterior varchar = 'no'::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Sistema
 FUNCION:       pro.f_fun_inicio_proyecto_analisis_wf

 DESCRIPCION:   Actualiza los estados en proceso WF
 AUTOR:         EGS
 FECHA:         08/10/2020
 COMENTARIOS:

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE

    v_nombre_funcion                text;
    v_resp                          varchar;
    v_mensaje                       varchar;
    v_registros                     record;
    v_rec                           record;

BEGIN

    --Identificación del nombre de la función
    v_nombre_funcion = 'pro.f_fun_inicio_proyecto_analisis_wf';

    ----------------------------------------------
    ----------------------------------------------
    select
        c.id_proyecto_analisis,
        c.estado,
        c.id_estado_wf,
        ew.id_funcionario
        into v_rec
    from pro.tproyecto_analisis c
    inner join wf.testado_wf ew on ew.id_estado_wf =  c.id_estado_wf
    where c.id_proyecto_analisis = p_id_proyecto_analisis;

    --Actualización del estado de la solicitud
    update pro.tproyecto_analisis set
    id_estado_wf    = p_id_estado_wf,
    estado          = p_codigo_estado,
    id_usuario_mod  = p_id_usuario,
    id_usuario_ai   = p_id_usuario_ai,
    usuario_ai      = p_usuario_ai,
    fecha_mod       = now()
    where id_proyecto_analisis = p_id_proyecto_analisis;
    --Respuesta
    return true;

EXCEPTION

    WHEN OTHERS THEN

        v_resp = '';
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