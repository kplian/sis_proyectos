CREATE OR REPLACE FUNCTION pro.f_i_kaf_cierre_genera_alta (
  p_id_usuario integer,
  p_id_proyecto integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Proyectos
 FUNCION:       pro.ft_proyecto_ime
 DESCRIPCION:   Generación del Alta de Activos en el cierre de proyectos
 AUTOR:         RCM  (KPLIAN)
 FECHA:         14/11/2018
 COMENTARIOS:

***************************************************************************
  ISSUE     SIS  EMPRESA  FECHA        AUTOR       DESCRIPCION
  #0        PRO  ETR      14/11/2018   RCM         Creación de archivo
  #18       PRO  ETR      02/09/2019   RCM         Filtro de activos ya existentes para no incluirlo en el movimiento
  #ETR-3345 PRO  ETR      26/03/2021   RCM         Cambio en glosa del alta igual que el Ajuste
  #ETR-3360 PRO  ETR      04-04-2021   RCM         Cambio de la fecha de Alta
***************************************************************************
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
    v_fecha_mov         DATE; --#ETR-3360

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

    --Inicio #ETR-3360: obtencion de fecha para el movimiento de los comprobantes del cierre
    SELECT
    cb.fecha
    INTO v_fecha_mov
    FROM conta.tint_transaccion tr
    INNER JOIN pro.tproyecto py
    ON py.id_int_comprobante_1 = tr.id_int_comprobante
    OR py.id_int_comprobante_3 = tr.id_int_comprobante
    INNER JOIN conta.tint_comprobante cb
    ON cb.id_int_comprobante = tr.id_int_comprobante
    WHERE py.id_proyecto = p_id_proyecto
    LIMIT 1;
    --Fin #ETR-3360

    --Definción de parámetros
    select
    'N/D' as direccion,
    null as fecha_hasta,
    v_id_cat_movimiento as id_cat_movimiento,
    v_fecha_mov as fecha_mov,
    v_id_depto as id_depto,
    'Alta de los activos fijos por Cierre de Proyecto '|| v_rec.codigo||' - '||v_rec.nombre as glosa, --#ETR-3345
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
    null as id_movimiento_motivo,
    'si' AS mov_rapido --#58
    into v_rec_af;

    --Creación del movimiento
    v_id_movimiento = kaf.f_insercion_movimiento(p_id_usuario, hstore(v_rec_af));

    --Bucle del detalle de activos
    FOR v_rec_det IN (SELECT id_activo_fijo
                    FROM pro.tproyecto_activo
                    WHERE id_proyecto = p_id_proyecto
                    AND COALESCE(codigo_af_rel, '') = '') LOOP --#18 se filtra que no entren los registros de activo fijos ya existentes

        --Definición de parámetros
        SELECT
        v_id_movimiento AS id_movimiento,
        v_rec_det.id_activo_fijo AS id_activo_fijo,
        NULL AS id_movimiento_motivo,
        NULL AS importe,
        NULL AS vida_util,
        NULL AS _nombre_usuario_ai,
        NULL AS _id_usuario_ai,
        NULL AS depreciacion_acum
        INTO v_rec_af_det;

        --Inserción del movimiento
        v_id_movimiento_af = kaf.f_insercion_movimiento_af(p_id_usuario, hstore(v_rec_af_det));

    END LOOP;

    --Respuesta
    RETURN 'Hecho';

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