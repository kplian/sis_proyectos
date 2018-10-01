CREATE OR REPLACE FUNCTION pro.f_iniciar_wf_proyecto_cierre (
  p_id_usuario INTEGER,
  p_id_usuario_ai INTEGER,
  p_nombre_usuario_ai VARCHAR,
  p_id_proyecto INTEGER
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		f_iniciar_wf_proyecto_cierre
 DESCRIPCION:   Verifica si se inició el WF del cierre. En caso negativo lo crea
 AUTOR: 		RCM
 FECHA:	        21/09/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE

	v_resp		            varchar;
	v_nombre_funcion        text;
    v_id_proceso_macro		integer;
    v_codigo_tipo_proceso 	varchar;
    v_codigo_proceso_macro	varchar;
    v_id_gestion			integer;
    v_fecha_fin				date;
    v_num_tramite           varchar;
    v_id_proceso_wf         integer;
    v_id_estado_wf          integer;
    v_codigo_estado         varchar;
    v_id_depto				integer;

BEGIN

	v_nombre_funcion = 'pro.f_iniciar_wf_proyecto_cierre';
    v_codigo_proceso_macro = 'CP';

	if not exists(select 1 from pro.tproyecto
    			where id_proyecto = p_id_proyecto) then
    	raise exception 'Proyecto inexistente';
    end if;

    if exists(select 1
    		from pro.tproyecto
            where estado = 'precierre'
            and id_proceso_wf_cierre is null) then

        --Verifica que haya registrado el DEPTO
        if exists(select 1 from pro.tproyecto
        			where id_proyecto = p_id_proyecto
                    and id_depto_conta is null) then
        	raise exception 'Defina el Depto. de Contabilidad para el Cierre previamente en la pantalla de Cierre de Proyectos';
        end if;

    	--Se inicia el proceso WF
        --Obtener id del proceso macro
        select
        pm.id_proceso_macro
        into
        v_id_proceso_macro
        from wf.tproceso_macro pm
        where pm.codigo = v_codigo_proceso_macro;

        if v_id_proceso_macro is null then
            raise exception 'El proceso macro de codigo % no esta configurado en el sistema WF',v_codigo_proceso_macro;
        end if;

        --Obtener el codigo del tipo_proceso
        select tp.codigo
        into v_codigo_tipo_proceso
        from wf.ttipo_proceso tp
        where tp.id_proceso_macro = v_id_proceso_macro
        and tp.estado_reg = 'activo'
        and tp.inicio = 'si';

        if v_codigo_tipo_proceso is NULL THEN
            raise exception 'No existe un proceso inicial para el proceso macro indicado % (Revise la configuración)',v_codigo_proceso_macro;
        end if;

        select
        ges.id_gestion, pr.fecha_fin, pr.id_depto_conta
        into
        v_id_gestion, v_fecha_fin, v_id_depto
        from pro.tproyecto pr
        inner join param.tgestion ges
        on date_trunc('year',ges.fecha_ini) = date_trunc('year',pr.fecha_fin)
        where pr.id_proyecto = p_id_proyecto;

		----------------------
        --Inicio tramite en WF
        ----------------------
        SELECT
            ps_num_tramite ,
            ps_id_proceso_wf,
            ps_id_estado_wf,
            ps_codigo_estado
        into
            v_num_tramite,
            v_id_proceso_wf,
            v_id_estado_wf,
            v_codigo_estado
        FROM wf.f_inicia_tramite(
            p_id_usuario,
            p_id_usuario_ai,
            p_nombre_usuario_ai,
            v_id_gestion,
            v_codigo_tipo_proceso,
            NULL,
            v_id_depto,
            'Cierre de Proyecto al '||to_char(v_fecha_fin,'dd/mm/yyyy'),
            'S/N'
        );

        update pro.tproyecto set
        nro_tramite_cierre = v_num_tramite,
        id_proceso_wf_cierre = v_id_proceso_wf,
        id_estado_wf_cierre = v_id_estado_wf,
        estado_cierre = v_codigo_estado
        where id_proyecto = p_id_proyecto;

        --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','WF de cierre del proyeto creado (id_proyecto'||p_id_proyecto||')');
        v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto',p_id_proyecto::varchar);

        --Devuelve la respuesta
        return v_resp;

    end if;

    return 'hecho';

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
SECURITY INVOKER;