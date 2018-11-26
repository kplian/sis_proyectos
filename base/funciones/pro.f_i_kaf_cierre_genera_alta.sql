CREATE OR REPLACE FUNCTION pro.f_i_kaf_cierre_genera_alta (
  p_id_usuario integer,
  p_id_proyecto integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM  (KPLIAN)
Fecha: 14/11/2018
Descripción: Generación del Alta de Activos en el cierre de proyectos
*/
DECLARE

    v_nombre_funcion    text;
    v_resp              varchar;
    v_rec               record;
    v_rec_det           record;
    v_rec_af            record;
    v_rec_af_det        record;
    v_id_cat_movimiento integer;
    v_id_movimiento     integer;
    v_id_movimiento_af  integer;
    v_id_depto          integer;

BEGIN

    v_nombre_funcion = 'pro.f_i_kaf_cierre_genera_alta';

    --Búsqueda del proyecto
    if not exists(select 1 from pro.tproyecto
                where id_proyecto = p_id_proyecto) then
        raise exception 'Proyecto no encontrado (%)',p_id_proyecto;
    end if;

    if exists(select 1 from pro.tproyecto
                where id_proyecto = p_id_proyecto
                and estado_cierre != 'alta') then
        raise exception 'El Proyecto debería estar en estado de Alta para continuar(%)',p_id_proyecto;
    end if;

    --Verifica que tenga activos fijos definidos
    if not exists(select 1 from pro.tproyecto_activo
                 where id_proyecto = p_id_proyecto) then
        raise exception 'Falta la definición de activos fijos';
    end if;

    -----------------------------------
    --Creación del movimiento de alta
    -----------------------------------
    --Obtención del ID del movimiento Alta
    select cat.id_catalogo
    into v_id_cat_movimiento
    from param.tcatalogo cat
    inner join param.tcatalogo_tipo ctip
    on ctip.id_catalogo_tipo = cat.id_catalogo_tipo
    where ctip.tabla = 'tmovimiento__id_cat_movimiento'
    and cat.codigo = 'alta';

    if v_id_cat_movimiento is null then
        raise exception 'No se encuentra registrado el Proceso de Alta. Comuníquese con el administrador del sistema.';
    end if;

    --Obtención de datos del Proyecto
    select fecha_fin, id_depto_conta, codigo, nombre
    into v_rec
    from pro.tproyecto
    where id_proyecto = p_id_proyecto;

    --Obtención del depto de AF en relación al depto de Conta
    select id_depto
    into v_id_depto
    from param.tdepto dep
    where dep.codigo = 'AF'
    and dep.modulo = 'KAF';

    --Definción de parámetros
    select
    'N/D' as direccion,
    null as fecha_hasta,
    v_id_cat_movimiento as id_cat_movimiento,
    v_rec.fecha_fin as fecha_mov,
    v_id_depto as id_depto,
    'Alta de los activos fijos, cierre proyecto '|| v_rec.codigo||' - '||v_rec.nombre as glosa,
    null as id_funcionario,
    null as id_oficina,
    null as _id_usuario_ai,
    p_id_usuario as id_usuario,
    null as _nombre_usuario_ai,
    null as id_persona,
    null as codigo,
    null as id_deposito,
    null as id_depto_dest,
    null as id_deposito_dest,
    null id_funcionario_dest,
    null as id_movimiento_motivo
    into v_rec_af;

    --Creación del movimiento
    v_id_movimiento = kaf.f_insercion_movimiento(p_id_usuario, hstore(v_rec_af));

    --Bucle del detalle de activos
    for v_rec_det in (select id_activo_fijo
                    from pro.tproyecto_activo
                    where id_proyecto = p_id_proyecto) loop

        --Definición de parámetros
        select
        v_id_movimiento as id_movimiento,
        v_rec_det.id_activo_fijo as id_activo_fijo,
        null as id_movimiento_motivo,
        null as importe,
        null as vida_util,
        null as _nombre_usuario_ai,
        null as _id_usuario_ai,
        null as depreciacion_acum
        into v_rec_af_det;

        --Inserción del movimiento
        v_id_movimiento_af = kaf.f_insercion_movimiento_af(p_id_usuario, hstore(v_rec_af_det));

    end loop;

    --Respuesta
    return 'Hecho';

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