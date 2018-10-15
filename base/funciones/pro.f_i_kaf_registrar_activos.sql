CREATE OR REPLACE FUNCTION pro.f_i_kaf_registrar_activos (
  p_id_usuario integer,
  p_id_proyecto integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_i_kaf_registrar_activos
 DESCRIPCION:   Funcion que registra el detalle del cierre en el activo fijo
 AUTOR: 		RCM
 FECHA:	        28/09/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE

	v_resp		        varchar;
	v_nombre_funcion    text;
    v_rec				record;
    v_rec_af 			record;
    v_monto_bs			numeric;
    v_monto_ufv			numeric;
    v_id_moneda_bs		integer;
    v_id_moneda_ufv		integer;
    v_id_activo_fijo	integer;
    v_id_cat_estado_fun integer;
    v_id_cat_estado_compra integer;
    v_id_depto 			integer;
    v_id_responsable_depto integer;
    v_id_funcionario 	integer;
    v_id_deposito 		integer;
    v_id_oficina		integer;
    v_monto_rescate		numeric;
    v_codigo            varchar;

BEGIN

	v_nombre_funcion = 'pro.f_i_kaf_registrar_activos';

    ----------------------------------
    -- VALIDACIONES
    ----------------------------------
    --Verificar que el proceso del cierre esté en estado finalizado
    if not exists (select 1 from pro.tproyecto
    		where id_proyecto = p_id_proyecto) then
    	raise exception 'Proyecto inexistente';
    end if;

    --Verificar que el proceso del cierre esté en estado finalizado
    if exists (select 1 from pro.tproyecto
    		where id_proyecto = p_id_proyecto
            and estado_cierre <> 'af') then
    	raise exception 'No se puede generar registros en el Sistema de Activos Fijos, el estado debería estar en ''Activos Fijos''';
    end if;


    -----------------------------------
    -- OBTENCIÓN DE DATOS OBLIGATORIOS
    -----------------------------------
    --Obtención de las monedas
    select id_moneda
    into v_id_moneda_bs
    from param.tmoneda
    where codigo = 'BS';

    select id_moneda
    into v_id_moneda_ufv
    from param.tmoneda
    where codigo = 'UFV';

    --Estado funcional
    select cat.id_catalogo
    into v_id_cat_estado_fun
    from param.tcatalogo cat
    inner join param.tcatalogo_tipo ctip
    on ctip.id_catalogo_tipo = cat.id_catalogo_tipo
    where ctip.tabla = 'tactivo_fijo__id_cat_estado_fun'
    and cat.codigo = 'bueno';

    --Estado compra
    select cat.id_catalogo
    into v_id_cat_estado_compra
    from param.tcatalogo cat
    inner join param.tcatalogo_tipo ctip
    on ctip.id_catalogo_tipo = cat.id_catalogo_tipo
    where ctip.tabla = 'tactivo_fijo__id_cat_estado_compra'
    and cat.codigo = 'nuevo';

    --Depto de activos fijos
    select id_depto
    into v_id_depto
    from param.tdepto dep
	  where dep.id_subsistema in (select id_subsistema from segu.tsubsistema where codigo = 'KAF')
    and dep.codigo = 'AF';

    --Deposito
    if not exists(select 1
                from kaf.tdeposito
                where id_depto = v_id_depto) then
        raise exception 'No existe depósito para el Departamento ';
    end if;

    select id_deposito
    into v_id_deposito
    from kaf.tdeposito
    where id_depto = v_id_depto;

    --Responsable
    select id_usuario
    into v_id_responsable_depto
    from param.tdepto_usuario
    where id_depto = v_id_depto
    and cargo = 'responsable' limit 1;

    if not exists(select 1
                from segu.tusuario usu
                inner join orga.vfuncionario_persona fun
                on fun.id_persona = usu.id_persona
                where usu.id_usuario = v_id_responsable_depto
                ) then
        raise exception 'El usuario responsable del Dpto. no está registrado como funcionario';
    end if;

    select fun.id_funcionario
    into v_id_funcionario
    from segu.tusuario usu
    inner join orga.vfuncionario_persona fun
    on fun.id_persona = usu.id_persona
    where usu.id_usuario = v_id_responsable_depto;

    --Oficina del responsable
    if not exists(select 1
                  from orga.tuo_funcionario uof
                  inner join orga.tcargo car
                  on car.id_cargo = uof.id_cargo
                  where uof.id_funcionario = v_id_responsable_depto
                  and uof.fecha_asignacion <= now()
                  and coalesce(uof.fecha_finalizacion, now())>=now()
                  and uof.estado_reg = 'activo'
                  and uof.tipo = 'oficial') then
    end if;

    select car.id_oficina
    into v_id_oficina
    from orga.tuo_funcionario uof
    inner join orga.tcargo car
    on car.id_cargo = uof.id_cargo
    where uof.id_funcionario = v_id_responsable_depto
    and uof.fecha_asignacion <= now()
    and coalesce(uof.fecha_finalizacion, now())>=now()
    and uof.estado_reg = 'activo'
    and uof.tipo = 'oficial';

    ---------------------------------
    -- REGISTRO DE LOS ACTIVOS FIJOS
    ---------------------------------

    --Recorrer el proyecto activo con su respectiva valoración
    for v_rec in (select
                  pa.id_proyecto_activo,
                  pa.id_clasificacion,
                  pa.denominacion,
                  pa.descripcion,
                  pa.observaciones,
                  pa.cantidad_det,
                  pa.id_depto,
                  pa.id_lugar,
                  pa.ubicacion,
                  pa.id_centro_costo,
                  pa.id_ubicacion,
                  pa.id_grupo,
                  pa.id_grupo_clasif,
                  pa.nro_serie,
                  pa.marca,
                  pa.fecha_ini_dep,
                  pa.vida_util_anios * 12 as vida_util,
                  pa.id_unidad_medida,
                  py.id_moneda,
                  pa.observaciones,
                  py.fecha_fin,
                  param.f_convertir_moneda(
                     py.id_moneda,
                     v_id_moneda_bs,
                     sum(pad.monto),
                     py.fecha_fin,
                     'O',-- tipo oficial, venta, compra
                     NULL) as monto_bs,--defecto dos decimales
                  param.f_convertir_moneda(
                     py.id_moneda,
                     v_id_moneda_ufv,
                     sum(pad.monto),
                     py.fecha_fin,
                     'O',-- tipo oficial, venta, compra
                     NULL) as monto_ufv,--defecto dos decimales
                  sum(pad.monto) as monto_usd,
                  coalesce((select sum(importe_actualiz)
                   from pro.tproyecto_activo_det_mon m
                   inner join pro.tproyecto_activo_detalle ad
                   on ad.id_proyecto_activo_detalle = m.id_proyecto_activo_detalle
                   where ad.id_proyecto_activo = pa.id_proyecto_activo
                   ),0) as monto_actualiz_bs
                  from pro.tproyecto_activo pa
                  inner join pro.tproyecto_activo_detalle pad
                  on pad.id_proyecto_activo = pa.id_proyecto_activo
                  inner join pro.tproyecto py
                  on py.id_proyecto = pa.id_proyecto
                  left join pro.tproyecto_activo_det_mon padm
                  on padm.id_proyecto_activo_detalle = pad.id_proyecto_activo_detalle
                  where pa.id_proyecto = p_id_proyecto
                  group by pa.id_proyecto_activo,
                          pa.id_clasificacion,
                          pa.denominacion,
                          pa.descripcion,
                          pa.observaciones,
                          pa.cantidad_det,
                          pa.id_depto,
                          pa.id_lugar,
                          pa.ubicacion,
                          pa.id_centro_costo,
                          pa.id_ubicacion,
                          pa.id_grupo,
                          pa.id_grupo_clasif,
                          pa.nro_serie,
                          pa.marca,
                          pa.fecha_ini_dep,
                          pa.vida_util_anios,
                          pa.id_unidad_medida,
                          py.id_moneda,
                          py.fecha_fin,
                          pa.observaciones,
                          pa.ubicacion
                  ) loop


    	--Parámetros
        select
        null as id_persona,
        0 as cantidad_revaloriz,
        null as id_proveedor,
        v_rec.fecha_fin as fecha_compra,
        v_id_cat_estado_fun as id_cat_estado_fun,
        v_rec.ubicacion as ubicacion,
        null as documento,
        v_rec.observaciones as observaciones,
        1::integer as monto_rescate,
        v_rec.denominacion as denominacion,
        v_id_funcionario as id_funcionario,
        v_id_deposito as id_deposito,
        v_rec.monto_usd as monto_compra_orig,
        v_rec.monto_bs + v_rec.monto_actualiz_bs as monto_compra,
        v_id_moneda_bs as id_moneda,
        v_rec.descripcion as descripcion,
        v_rec.id_moneda as id_moneda_orig,
        v_rec.fecha_ini_dep as fecha_ini_dep,
        v_id_cat_estado_compra as id_cat_estado_compra,
        v_rec.vida_util as vida_util_original,
        'registrado' as estado,
        v_rec.id_clasificacion as id_clasificacion,
        v_id_oficina as id_oficina,
        v_rec.id_depto as id_depto,
        p_id_usuario as id_usuario_reg,
        null as usuario_ai,
        null as id_usuario_ai,
        null as id_usuario_mod,
        'si' as en_deposito,
        null as codigo_ant,
        v_rec.marca as marca,
        v_rec.nro_serie as nro_serie,
        v_rec.id_unidad_medida as id_unidad_medida,
        v_rec.cantidad_det::integer as cantidad_af,
        v_rec.monto_usd as monto_compra_orig_100,
        null as nro_cbte_asociado,
        null as fecha_cbte_asociado,
        null as id_cotizacion_det,
        null as id_preingreso_det,
        v_rec.id_ubicacion as id_ubicacion,
        v_rec.id_grupo as id_grupo,
        v_rec.id_grupo_clasif as id_grupo_clasif,
        v_rec.id_centro_costo as id_centro_costo,
        v_rec.monto_actualiz_bs as monto_compra_sin_actualiz
        into v_rec_af;

        --Inserción de activo fijo
		v_id_activo_fijo = kaf.f_insercion_af(p_id_usuario ,hstore(v_rec_af), 'si');

        --Generación del código para el activo
        v_codigo = kaf.f_genera_codigo(v_id_activo_fijo);

        update kaf.tactivo_fijo set
        codigo = v_codigo
        where id_activo_fijo = v_id_activo_fijo;

        --Inserción de los AFV en todas las monedas
        --Bs
        insert into kaf.tactivo_fijo_valores(
            id_usuario_reg,
            fecha_reg,
            estado_reg,
            id_activo_fijo,
            monto_vigente_orig,
            vida_util_orig,
            fecha_ini_dep,
            depreciacion_mes,
            depreciacion_per,
            depreciacion_acum,
            monto_vigente,
            vida_util,
            estado,
            principal,
            monto_rescate,
            id_movimiento_af,
            tipo,
            codigo,
            id_moneda_dep,
            id_moneda,
            fecha_inicio,
            monto_vigente_orig_100
        ) values(
            p_id_usuario,
            now(),
            'activo',
            v_id_activo_fijo,
            v_rec.monto_bs + v_rec.monto_actualiz_bs,            --  monto_vigente_orig
            v_rec.vida_util,      --  vida_util_orig
            v_rec.fecha_ini_dep,           --  fecha_ini_dep
            0,
            0,
            0,
            v_rec.monto_bs + v_rec.monto_actualiz_bs,            --  monto_vigente
            v_rec.vida_util,      --  vida_util
            'activo',
            'si',
            1,           --  monto_rescate
            null,
            'alta',
            v_codigo,
            2,
            v_id_moneda_bs,
            v_rec.fecha_ini_dep,           --  fecha_ini  desde cuando se considera el activo valor
            v_rec.monto_bs + v_rec.monto_actualiz_bs
        );

        --USD
        v_monto_rescate = param.f_convertir_moneda(v_id_moneda_bs, --moneda origen para conversion
                                                   v_rec.id_moneda,   --moneda a la que sera convertido
                                                   1, --este monto siemrpe estara en moenda base
                                                   v_rec.fecha_fin,
                                                   'O',-- tipo oficial, venta, compra
                                                   NULL);--defecto dos decimales

		insert into kaf.tactivo_fijo_valores(
            id_usuario_reg,
            fecha_reg,
            estado_reg,
            id_activo_fijo,
            monto_vigente_orig,
            vida_util_orig,
            fecha_ini_dep,
            depreciacion_mes,
            depreciacion_per,
            depreciacion_acum,
            monto_vigente,
            vida_util,
            estado,
            principal,
            monto_rescate,
            id_movimiento_af,
            tipo,
            codigo,
            id_moneda_dep,
            id_moneda,
            fecha_inicio,
            monto_vigente_orig_100
        ) values(
            p_id_usuario,
            now(),
            'activo',
            v_id_activo_fijo,
            v_rec.monto_usd,            --  monto_vigente_orig
            v_rec.vida_util,      --  vida_util_orig
            v_rec.fecha_ini_dep,           --  fecha_ini_dep
            0,
            0,
            0,
            v_rec.monto_usd,            --  monto_vigente
            v_rec.vida_util,      --  vida_util
            'activo',
            'si',
            1,           --  monto_rescate
            null,
            'alta',
            v_codigo,
            3,
            v_rec.id_moneda,
            v_rec.fecha_ini_dep,           --  fecha_ini  desde cuando se considera el activo valor
            v_rec.monto_usd
        );

        --UFV
        v_monto_rescate = param.f_convertir_moneda(v_id_moneda_bs, --moneda origen para conversion
                                                   v_id_moneda_ufv,   --moneda a la que sera convertido
                                                   1, --este monto siemrpe estara en moenda base
                                                   v_rec.fecha_fin,
                                                   'O',-- tipo oficial, venta, compra
                                                   NULL);--defecto dos decimales

        insert into kaf.tactivo_fijo_valores(
            id_usuario_reg,
            fecha_reg,
            estado_reg,
            id_activo_fijo,
            monto_vigente_orig,
            vida_util_orig,
            fecha_ini_dep,
            depreciacion_mes,
            depreciacion_per,
            depreciacion_acum,
            monto_vigente,
            vida_util,
            estado,
            principal,
            monto_rescate,
            id_movimiento_af,
            tipo,
            codigo,
            id_moneda_dep,
            id_moneda,
            fecha_inicio,
            monto_vigente_orig_100
        ) values(
            p_id_usuario,
            now(),
            'activo',
            v_id_activo_fijo,
            v_rec.monto_ufv,            --  monto_vigente_orig
            v_rec.vida_util,      --  vida_util_orig
            v_rec.fecha_ini_dep,           --  fecha_ini_dep
            0,
            0,
            0,
            v_rec.monto_ufv,            --  monto_vigente
            v_rec.vida_util,      --  vida_util
            'activo',
            'si',
            1,           --  monto_rescate
            null,
            'alta',
            v_codigo,
            4,
            v_id_moneda_ufv,
            v_rec.fecha_ini_dep,           --  fecha_ini  desde cuando se considera el activo valor
            v_rec.monto_ufv
        );

        --Actualización del ID activo fijo en proyecto activo
        update pro.tproyecto_activo set
        id_activo_fijo = v_id_activo_fijo
        where id_proyecto_activo = v_rec.id_proyecto_activo;

    end loop;

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
SECURITY INVOKER
COST 100;