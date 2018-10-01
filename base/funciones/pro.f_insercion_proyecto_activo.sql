CREATE OR REPLACE FUNCTION pro.f_insercion_proyecto_activo (
  p_id_usuario integer,
  p_parametros public.hstore
)
RETURNS integer AS
$body$
/*
Autor: RCM
Fecha: 14/09/2018
Descripción: Función para crear un nuevo proyecto activo
*/
DECLARE

	v_id_proyecto_activo    integer;
    v_nombre_funcion        varchar;
    v_resp					varchar;

BEGIN

    --Nombre de la función
    v_nombre_funcion = 'pro.f_insercion_proyecto_activo';

    --Sentencia de la insercion
    insert into pro.tproyecto_activo(
    id_proyecto,
    observaciones,
    estado_reg,
    denominacion,
    descripcion,
    id_clasificacion,
    id_usuario_reg,
    fecha_reg,
    usuario_ai,
    id_usuario_ai,
    fecha_mod,
    id_usuario_mod,
    cantidad_det,
    id_depto,
    estado,
    --id_lugar,
    ubicacion,
    id_centro_costo,
    id_ubicacion,
    id_grupo,
    id_grupo_clasif,
    nro_serie,
    marca,
    fecha_ini_dep,
    vida_util_anios,
    id_unidad_medida,
    codigo_af_rel
    ) values(
    (p_parametros->'id_proyecto')::integer,
    (p_parametros->'observaciones')::varchar,
    'activo',
    (p_parametros->'denominacion')::varchar,
    (p_parametros->'descripcion')::varchar,
    (p_parametros->'id_clasificacion')::integer,
    p_id_usuario,
    now(),
    (p_parametros->'_nombre_usuario_ai')::varchar,
    (p_parametros->'_id_usuario_ai')::integer,
    null,
    null,
    (p_parametros->'cantidad_det')::numeric,
    (p_parametros->'id_depto')::integer,
    'registrado',
    --(p_parametros->'id_lugar')::integer,
    (p_parametros->'ubicacion')::varchar,
    (p_parametros->'id_centro_costo')::integer,
    (p_parametros->'id_ubicacion')::integer,
    (p_parametros->'id_grupo')::integer,
    (p_parametros->'id_grupo_clasif')::integer,
    (p_parametros->'nro_serie')::varchar,
    (p_parametros->'marca')::varchar,
    (p_parametros->'fecha_ini_dep')::date,
    (p_parametros->'vida_util_anios')::integer,
    (p_parametros->'id_unidad_medida')::integer,
    (p_parametros->'codigo_af_rel')::varchar
    )RETURNING id_proyecto_activo into v_id_proyecto_activo;

    --Respuesta
    return v_id_proyecto_activo;

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