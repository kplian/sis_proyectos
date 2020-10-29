CREATE OR REPLACE FUNCTION pro.f_gestionar_cbte_proyecto_analisis(
	p_id_usuario integer,
	p_id_usuario_ai integer,
	p_usuario_ai character varying,
	p_id_int_comprobante integer,
	p_conexion character varying DEFAULT NULL::character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:       Proyectos
 FUNCION:       pro.f_gestionar_cbte_proyecto_analisis

 DESCRIPCION:   Esta funcion gestiona los cbtes cuando son validados
 AUTOR:         MZM
 FECHA:         13/10/2020
 COMENTARIOS:

***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 0      PRO       ETR           13/10/2020  MZM         Creación del archivo
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

    v_nombre_funcion = 'pro.f_gestionar_cbte_proyecto_analisis';

    --1) Obtención de datos
    select
    p.id_proyecto,
    p.id_proyecto_analisis,
    p.id_estado_wf,
    p.id_proceso_wf,
    p.estado,
    ew.id_funcionario,
    ew.id_depto,
    p.id_int_comprobante_1,
    p.id_int_comprobante_2,
    p.id_int_comprobante_3
    into
    v_registros
    from pro.tproyecto_analisis p
    inner join wf.testado_wf ew
    on ew.id_estado_wf = p.id_estado_wf
    where p.id_int_comprobante_1 = p_id_int_comprobante
    or p.id_int_comprobante_2 = p_id_int_comprobante
    or p.id_int_comprobante_3 = p_id_int_comprobante;

    --2) Valida que el comprobante esté relacionado con un proyecto
    if v_registros.id_proyecto_analisis  is null then
      raise exception 'El comprobante no está relacionado con ningún Analisis de Proyecto (Id. Cbte: %, %)',p_id_int_comprobante,v_registros;
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


    --4) Finaliza el movimiento si es que los 3 comprobantes de analisis generados han sido validados
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
        update pro.tproyecto_analisis set
        id_estado_wf    	   = v_id_estado_actual,
        estado	               = va_codigo_estado[1],
        id_usuario_mod         = p_id_usuario,
        fecha_mod              = now(),
        id_usuario_ai          = p_id_usuario_ai,
        usuario_ai             = p_usuario_ai
        where id_proyecto_analisis = v_registros.id_proyecto_analisis;

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
$BODY$;

ALTER FUNCTION pro.f_gestionar_cbte_proyecto_analisis(integer, integer, character varying, integer, character varying)
    OWNER TO postgres;