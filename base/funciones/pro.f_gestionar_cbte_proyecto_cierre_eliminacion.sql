CREATE OR REPLACE FUNCTION pro.f_gestionar_cbte_proyecto_cierre_eliminacion (
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
 FUNCION:       pro.f_gestionar_cbte_proyecto_cierre_eliminacion

 DESCRIPCION:   Esta funcion gestiona la eliminación de los cbtes validados
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

    v_nombre_funcion        text;
    v_resp                  varchar;
    v_registros             record;
    v_id_estado_actual      integer;
    v_id_proceso_wf         integer;
    v_id_tipo_estado        integer;
    v_id_funcionario        integer;
    v_id_usuario_reg        integer;
    v_id_depto              integer;
    v_codigo_estado         varchar;
    v_id_estado_wf_ant      integer;
    v_reg_cbte              record;

BEGIN

    v_nombre_funcion = 'pro.f_gestionar_cbte_proyecto_cierre_eliminacion';

    --1) Obtención de datos
    select
    p.id_proyecto,
    p.id_estado_wf_cierre,
    p.id_proceso_wf_cierre,
    p.estado_cierre,
    p.nro_tramite_cierre,
    p.id_int_comprobante_1,
    c.estado_reg as estado_cbte
    into
    v_registros
    from pro.tproyecto p
    inner join conta.tint_comprobante c on c.id_int_comprobante = p.id_int_comprobante_1
    where p.id_int_comprobante_1 = p_id_int_comprobante;

    --2) Validar que tenga una cuenta documentada
    IF v_registros.id_proyecto is NULL  THEN
        raise exception 'El comprobante no está relacionado a ningún proyecto';
    END IF;

    --3) Cambio de estado
    select
    ic.estado_reg
    INTO
    v_reg_cbte
    from conta.tint_comprobante ic
    where ic.id_int_comprobante = p_id_int_comprobante;

    IF v_reg_cbte.estado_reg = 'validado' THEN
        raise exception 'El comprobante no puede ser eliminado por estar Validado';
    END IF;

    --Recupera estado anterior segun Log del WF
    SELECT
        ps_id_tipo_estado,
        ps_id_funcionario,
        ps_id_usuario_reg,
        ps_id_depto,
        ps_codigo_estado,
        ps_id_estado_wf_ant
    into
        v_id_tipo_estado,
        v_id_funcionario,
        v_id_usuario_reg,
        v_id_depto,
        v_codigo_estado,
        v_id_estado_wf_ant
    FROM wf.f_obtener_estado_ant_log_wf(v_registros.id_estado_wf_cierre);

    --
    select
        ew.id_proceso_wf
    into
        v_id_proceso_wf
    from wf.testado_wf ew
    where ew.id_estado_wf = v_id_estado_wf_ant;

    --Registra el nuevo estado
    v_id_estado_actual = wf.f_registra_estado_wf
                        (
                            v_id_tipo_estado,
                            v_id_funcionario,
                            v_registros.id_estado_wf_cierre,
                            v_id_proceso_wf,
                            p_id_usuario,
                            p_id_usuario_ai,
                            p_usuario_ai,
                            v_id_depto,
                            'Eliminación del comprobante: '|| COALESCE(v_registros.id_int_comprobante_1::varchar,'NaN')
                        );

    --Actualiza estado de la solicitud
    update pro.tproyecto set
    id_estado_wf_cierre = v_id_estado_actual,
    estado_cierre       = v_codigo_estado,
    id_usuario_mod      = p_id_usuario,
    fecha_mod           = now(),
    id_int_comprobante_1= NULL,
    id_usuario_ai       = p_id_usuario_ai,
    usuario_ai          = p_usuario_ai
    where id_proyecto = v_registros.id_proyecto;

    RETURN  TRUE;

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