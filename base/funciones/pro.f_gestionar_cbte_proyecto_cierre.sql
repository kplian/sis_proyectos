CREATE OR REPLACE FUNCTION pro.f_gestionar_cbte_proyecto_cierre (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Proyectos
 FUNCION:       pro.f_gestionar_cbte_proyecto_cierre

 DESCRIPCION:   Esta funcion gestiona los cbtes cuando son validados
 AUTOR:         RCM
 FECHA:         24/09/2018
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
    v_registros         record;
    v_id_estado_actual  integer;
    va_id_tipo_estado   integer[];
    va_codigo_estado    varchar[];
    va_disparador       varchar[];
    va_regla            varchar[];
    va_prioridad        integer[];

BEGIN

    v_nombre_funcion = 'pro.f_gestionar_cbte_proyecto_cierre';

    --1) Obtención de datos
    select
    p.id_proyecto,
    p.id_estado_wf_cierre,
    p.id_proceso_wf_cierre,
    p.estado_cierre,
    ew.id_funcionario,
    ew.id_depto
    into
    v_registros
    from pro.tproyecto p
    inner join wf.testado_wf ew
    on ew.id_estado_wf = p.id_estado_wf_cierre
    where c.id_int_comprobante = p_id_int_comprobante;

    --2) Valida que el comprobante esté relacionado con un proyecto
    if v_registros.id_proyecto is null then
      raise exception 'El comprobante no está relacionado con ningún Proyecto (Id. Cbte: %, %)',p_id_int_comprobante,v_registros;
    end if;

    --3) Cambiar el estado del cierre del proyecto
    --Obtiene el siguiente estado del flujo
    select
    *
    into
    va_id_tipo_estado,
    va_codigo_estado,
    va_disparador,
    va_regla,
    va_prioridad
    from wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,null,'siguiente');

    if va_codigo_estado[2] is not null then
      raise exception 'El proceso de WF esta mal parametrizado, sólo admite un estado siguiente para el estado: %', v_registros.estado;
    end if;

    if va_codigo_estado[1] is null then
      raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente, para el estado: %', v_registros.estado;
    end if;

    --Estado siguiente
    v_id_estado_actual = wf.f_registra_estado_wf
                        (
                            va_id_tipo_estado[1],
                            v_registros.id_funcionario,
                            v_registros.id_estado_wf,
                            v_registros.id_proceso_wf,
                            p_id_usuario,
                            p_id_usuario_ai, -- id_usuario_ai
                            p_usuario_ai, -- usuario_ai
                            v_registros.id_depto,
                            'Comprobantes validados'
                        );

    --Actualiza estado del proceso
    update pro.troyecto set
    id_estado_wf_cierre    =  v_id_estado_actual,
    estado_cierre          = va_codigo_estado[1],
    id_usuario_mod  = p_id_usuario,
    fecha_mod       = now(),
    id_usuario_ai   = p_id_usuario_ai,
    usuario_ai      = p_usuario_ai
    where id_proyecto = v_registros.id_proyecto;

    --Respuesta
    return true;

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