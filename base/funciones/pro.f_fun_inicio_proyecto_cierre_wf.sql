CREATE OR REPLACE FUNCTION pro.f_fun_inicio_proyecto_cierre_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_id_depto_lb integer = NULL::integer,
  p_id_cuenta_bancaria integer = NULL::integer,
  p_estado_anterior varchar = 'no'::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Proyectos
 FUNCION:       pro.f_fun_inicio_proyecto_cierre_wf

 DESCRIPCION:   Actualiza los estados despues del registro de estado en tabla transaccional
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

    v_nombre_funcion                text;
    v_resp                          varchar;
    v_rec                           record;
    v_id_int_comprobante            integer;
    v_plantilla_cbte                varchar[];


BEGIN

    --Identificación del nombre de la función
    v_nombre_funcion = 'pro.f_fun_inicio_proyecto_cierre_wf';
    v_plantilla_cbte[0] = 'PRO-CIE1';
    v_plantilla_cbte[1] = 'PRO-CIE2';
    v_plantilla_cbte[2] = 'PRO-CIE3';

    ---------------------
    --Obtención de datos
    ---------------------
    select
    p.id_proyecto,
    p.estado_cierre,
    p.id_estado_wf_cierre,
    p.fecha_fin
    into v_rec
    from pro.tproyecto p
    where p.id_proceso_wf_cierre = p_id_proceso_wf;

    --Actualización del estado del proyecto
    update pro.tproyecto set
    id_estado_wf_cierre = p_id_estado_wf,
    estado_cierre       = p_codigo_estado,
    id_usuario_mod      = p_id_usuario,
    id_usuario_ai       = p_id_usuario_ai,
    usuario_ai          = p_usuario_ai,
    fecha_mod           = now()
    where id_proceso_wf_cierre = p_id_proceso_wf;

    ---------------------------------
    ---Lógica específica por estado
    ---------------------------------

    if p_codigo_estado = 'cbte' then

        --Verifica que exista información en la tabla del SIGEMA
        if not exists(select 1
                    from pro.tproyecto_activo
                    where id_proyecto = v_rec.id_proyecto) then
            raise exception 'Aún no se definieron loas activos fijos para el cierre';
        end if;

        --Genera el comprobante 1
        v_id_int_comprobante = conta.f_gen_comprobante
                                (
                                    v_rec.id_proyecto,
                                    v_plantilla_cbte[0],
                                    p_id_estado_wf,
                                    p_id_usuario,
                                    p_id_usuario_ai,
                                    p_usuario_ai
                                );

        --Actualización del Id del comprobante
        update pro.tproyecto set
        id_int_comprobante_1 = v_id_int_comprobante
        where id_proceso_wf_cierre = p_id_proceso_wf;

        /*--Genera el comprobante 2
        v_id_int_comprobante = conta.f_gen_comprobante
                                (
                                    v_rec.id_proyecto,
                                    v_plantilla_cbte[0],
                                    p_id_estado_wf,
                                    p_id_usuario,
                                    p_id_usuario_ai,
                                    p_usuario_ai
                                );

        --Actualización del Id del comprobante
        update pro.tproyecto set
        id_int_comprobante_2 = v_id_int_comprobante
        where id_proceso_wf_cierre = p_id_proceso_wf;

        --Genera el comprobante 3
        v_id_int_comprobante = conta.f_gen_comprobante
                                (
                                    v_rec.id_proyecto,
                                    v_plantilla_cbte[0],
                                    p_id_estado_wf,
                                    p_id_usuario,
                                    p_id_usuario_ai,
                                    p_usuario_ai
                                );

        --Actualización del Id del comprobante
        update pro.tproyecto set
        id_int_comprobante_3 = v_id_int_comprobante
        where id_proceso_wf_cierre = p_id_proceso_wf;*/

    elsif p_codigo_estado = 'finalizado' then


    end if;

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