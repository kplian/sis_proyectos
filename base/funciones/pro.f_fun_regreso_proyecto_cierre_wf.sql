CREATE OR REPLACE FUNCTION pro.f_fun_regreso_proyecto_cierre_wf (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Proyectos
 FUNCION:       pro.f_fun_regreso_proyecto_cierre_wf

 DESCRIPCION:   Actualiza los estados después del registro de un retroceso
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

    v_nombre_funcion          	text;
    v_resp    				          varchar;
    v_mensaje 				          varchar;
    v_reg_cuenta_doc		        record;

BEGIN

    v_nombre_funcion = 'pro.f_fun_regreso_proyecto_cierre_wf';

    --Actualiza estado en la solicitud
    update pro.tproyecto set
    id_estado_wf_cierre = p_id_estado_wf,
    estado_cierre       = p_codigo_estado,
    id_usuario_mod      = p_id_usuario,
    fecha_mod           = now(),
    id_usuario_ai       = p_id_usuario_ai,
    usuario_ai          = p_usuario_ai
    where id_proceso_wf_cierre = p_id_proceso_wf;

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