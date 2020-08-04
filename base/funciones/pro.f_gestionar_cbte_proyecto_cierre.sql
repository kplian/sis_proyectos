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
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 0      PRO       ETR           24/09/2018  RCM         Creación del archivo
 #18    PRO       ETR           02/09/2019  RCM         Lógica para considerar que a veces generará 2 cbtes y otras 3 cbtes.
 #60    PRO       ETR           28/07/2020  RCM         Lógica para considerar el caso de q el cbte 2 no se genere
***************************************************************************
*/

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
    v_sw_fin            boolean = false;
    v_estado_1          varchar;
    v_estado_2          varchar;
    v_estado_3          varchar;

BEGIN

    v_nombre_funcion = 'pro.f_gestionar_cbte_proyecto_cierre';

    --1) Obtención de datos
    select
    p.id_proyecto,
    p.id_estado_wf_cierre,
    p.id_proceso_wf_cierre,
    p.estado_cierre,
    ew.id_funcionario,
    ew.id_depto,
    p.id_int_comprobante_1,
    p.id_int_comprobante_2,
    p.id_int_comprobante_3
    into
    v_registros
    from pro.tproyecto p
    inner join wf.testado_wf ew
    on ew.id_estado_wf = p.id_estado_wf_cierre
    where p.id_int_comprobante_1 = p_id_int_comprobante
    or p.id_int_comprobante_2 = p_id_int_comprobante
    or p.id_int_comprobante_3 = p_id_int_comprobante;

    --2) Valida que el comprobante esté relacionado con un proyecto
    if v_registros.id_proyecto is null then
      raise exception 'El comprobante no está relacionado con ningún Proyecto (Id. Cbte: %, %)',p_id_int_comprobante,v_registros;
    end if;


    --3) Verificación de validación de los 4 comprobantes
    select estado_reg
    into v_estado_1
    from conta.tint_comprobante
    where id_int_comprobante = v_registros.id_int_comprobante_1;

    select estado_reg
    into v_estado_2
    from conta.tint_comprobante
    where id_int_comprobante = v_registros.id_int_comprobante_2;

    select estado_reg
    into v_estado_3
    from conta.tint_comprobante
    where id_int_comprobante = v_registros.id_int_comprobante_3;

    --Inicio #60
    --Inicio #18
    IF COALESCE(v_estado_1, '') = 'validado'
    AND ((COALESCE(v_estado_2, '') = 'validado' AND v_registros.id_int_comprobante_2 IS NOT NULL) OR v_registros.id_int_comprobante_2 IS NULL)
    AND ((COALESCE(v_estado_3, '') = 'validado' AND v_registros.id_int_comprobante_3 IS NOT NULL) OR v_registros.id_int_comprobante_3 IS NULL) THEN
        v_sw_fin = TRUE;
    END IF;
    --Fin #18
    --Fin #60


    --4) Finaliza el movimiento si es que los 3 comprobantes de depreciación generados han sido validados
     if v_sw_fin then

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
        from wf.f_obtener_estado_wf(v_registros.id_proceso_wf_cierre, v_registros.id_estado_wf_cierre,null,'siguiente');

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
                                v_registros.id_estado_wf_cierre,
                                v_registros.id_proceso_wf_cierre,
                                p_id_usuario,
                                p_id_usuario_ai, -- id_usuario_ai
                                p_usuario_ai, -- usuario_ai
                                v_registros.id_depto,
                                'Comprobantes validados'
                            );

        --Actualiza estado del proceso
        update pro.tproyecto set
        id_estado_wf_cierre    = v_id_estado_actual,
        estado_cierre          = va_codigo_estado[1],
        id_usuario_mod         = p_id_usuario,
        fecha_mod              = now(),
        id_usuario_ai          = p_id_usuario_ai,
        usuario_ai             = p_usuario_ai
        where id_proyecto = v_registros.id_proyecto;

     end if;

    --Respuesta
    return true;

EXCEPTION

  WHEN OTHERS THEN

          v_resp = '';
          v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
          v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
          v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);

          RAISE EXCEPTION '%', v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;