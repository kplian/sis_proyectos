CREATE OR REPLACE FUNCTION pro.f_i_kaf_registrar_activos (
  p_id_usuario integer,
  p_id_proyecto integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Proyectos
 FUNCION:       pro.f_i_kaf_registrar_activos
 DESCRIPCION:   Funcion que registra el detalle del cierre en el activo fijo
 AUTOR:         RCM
 FECHA:         28/09/2018
 COMENTARIOS:
***************************************************************************
 ISSUE      SIS     EMPRESA  FECHA        AUTOR       DESCRIPCION
            PRO     ETR      28/09/2019   RCM         Creación del archivo
 #19        PRO     ETR      19/08/2019   RCM         Corrección importes de alta considerando la actualización
 #33        PRO     ETR      30/09/2019   RCM         Inclusión de total depreciación mensual del incremento y total inc. dep. acum.
 #36        PRO     ETR      16/10/2019   RCM         Adición de campo Funcionario
 #38        PRO     ETR      17/10/2019   RCM         Adición de campo Fecha de compra
 #41        PRO     ETR      22/10/2019   RCM         Adición de condición fecha is null en la consulta de AF existentes
 #50        PRO     ETR      09/12/2019   RCM         Inclusión de almacén en importación de cierre
 #57        PRO     ETR      25/03/2020   RCM         Adición de id_proyecto_activo y id_movimiento_af_especial para creación de activos fijos
 #58        PRO     ETR      29/04/2020   RCM         Inclusión de fecha para TC inicial predefinido para la primera depreciación del AF enla creación de AFVs
 #60        PRO     ETR      29/07/2020   RCM         Modificación de cálculo auxiliar de depreciación en caso de adiciones, considerando fecha de inicio depreciación
 #SIS-2     PRO     ETR      24/09/2020   RCM         Modificación de fecha fin del proyecto por fecha del cbte. para las adiciones, para que prevalezca la fecha del cbte.
 #SIS-4     PRO     ETR      12/01/2020   RCM         En caso de cierre de proyectos, para las adiciones el importe sin modificación debe ser por moneda no sólo en moneda base
 #ETR-3360  PRO     ETR      20/03/2021   RCM         No actualización de importes ni en cáluclo auxiliar de depreciación (por UFV en baja)
***************************************************************************
*/
DECLARE

    v_resp                  varchar;
    v_nombre_funcion        text;
    v_rec                   record;
    v_rec_af                record;
    v_monto_bs              numeric;
    v_monto_ufv             numeric;
    v_id_moneda_bs          integer;
    v_id_moneda_ufv         integer;
    v_id_activo_fijo        integer;
    v_id_cat_estado_fun     integer;
    v_id_cat_estado_compra  integer;
    v_id_depto              integer;
    v_id_responsable_depto  integer;
    v_id_funcionario        integer;
    v_id_deposito           integer;
    v_id_oficina            integer;
    v_monto_rescate         numeric;
    v_codigo                varchar;
    v_sw_primero            boolean;
    v_id_movimiento         integer;
    v_id_cat_movimiento     integer;
    v_rec_proy              record;
    v_id_moneda_base        integer;
    v_id_moneda_dep         integer;
    --Inicio #19
    v_id_movimiento_af      integer;
    v_fun                   varchar;
    v_acceso_directo        varchar;
    v_clase                 varchar;
    v_parametros_ad         varchar;
    v_tipo_noti             varchar;
    v_titulo                varchar;
    v_id_estado_actual      integer;
    v_codigo_estado_sig     varchar;
    v_id_tipo_estado        integer;
    v_id_estado_wf_act      integer;
    v_id_proceso_wf_act     integer;
    --Fin #19
    v_act_x_ufv             VARCHAR; --#ETR-3360

BEGIN

    v_nombre_funcion = 'pro.f_i_kaf_registrar_activos';

    ----------------------------------
    -- VALIDACIONES
    ----------------------------------
    --Verificar existencia del proyecto
    if not exists (select 1 from pro.tproyecto
                    where id_proyecto = p_id_proyecto) then
        raise exception 'Proyecto inexistente';
    end if;

    --Verificar que el proceso del cierre esté en estado 'Activos Fijos'
    if exists (select 1 from pro.tproyecto
                where id_proyecto = p_id_proyecto
                and estado_cierre <> 'af') then
        raise exception 'No se puede generar registros en el Sistema de Activos Fijos, el estado debería estar en ''Activos Fijos''';
    end if;


    -----------------------------------
    -- OBTENCIÓN DE DATOS OBLIGATORIOS
    -----------------------------------
    --Obtención de datos del proyecto
    select fecha_fin, codigo, nombre
    into v_rec_proy
    from pro.tproyecto
    where p_id_proyecto = p_id_proyecto;

    --Obtención de las monedas
    select id_moneda
    into v_id_moneda_bs
    from param.tmoneda
    where codigo = 'BS';

    select id_moneda
    into v_id_moneda_ufv
    from param.tmoneda
    where codigo = 'UFV';

    --Obtención de variable global para verificar si se actualizará o no
    v_act_x_ufv = pxp.f_get_variable_global('kaf_actualizar_baja_ufv');--#ETR-3360

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

    --Inicio #SIS-2
    SELECT id_funcionario
    INTO v_id_funcionario
    FROM orga.tfuncionario
    WHERE codigo = 'FUNADM';

    IF v_id_funcionario IS NULL THEN
        select fun.id_funcionario
        into v_id_funcionario
        from segu.tusuario usu
        inner join orga.vfuncionario_persona fun
        on fun.id_persona = usu.id_persona
        where usu.id_usuario = v_id_responsable_depto;
    END IF;
    --Fin #SIS-2

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
    and coalesce(uof.fecha_finalizacion, now()) >= now()
    and uof.estado_reg = 'activo'
    and uof.tipo = 'oficial';

    --Moneda base
    v_id_moneda_base = param.f_get_moneda_base();

    ---------------------------------
    -- REGISTRO DE LOS ACTIVOS FIJOS
    ---------------------------------

    --Recorrer el proyecto activo con su respectiva valoración, de los que no tienen activo fijo previo para relacionar (columna codigo_af_rel)
    --Inicio # 19
    FOR v_rec IN
    (
        WITH tactivos AS (
            SELECT DISTINCT --#41
            pa.id_proyecto,
            pa.id_proyecto_activo,
            SUM(pad.monto) OVER (PARTITION BY pa.id_proyecto_activo) AS importe_activo,
            SUM(pad.monto) OVER (PARTITION BY pa.id_proyecto) AS importe_total
            FROM pro.tproyecto_activo pa
            INNER JOIN pro.tproyecto_activo_detalle pad
            ON pad.id_proyecto_activo = pa.id_proyecto_activo
            WHERE pa.id_proyecto = p_id_proyecto
        ), tcbtes AS (
            SELECT
            py.id_proyecto,
            SUM(tr.importe_debe_mb) AS importe_mb,
            SUM(tr.importe_debe_mt) AS importe_mt,
            SUM(tr.importe_debe_ma) AS importe_ma
            FROM conta.tint_transaccion tr
            INNER JOIN pro.tproyecto py
            ON py.id_int_comprobante_1 = tr.id_int_comprobante
            OR py.id_int_comprobante_3 = tr.id_int_comprobante
            WHERE py.id_proyecto = p_id_proyecto
            GROUP BY py.id_proyecto
        )
        SELECT
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
        pa.vida_util_anios * 12 AS vida_util,
        pa.id_unidad_medida,
        py.id_moneda,
        pa.observaciones,
        py.fecha_fin,
        cb.importe_mb * ac.importe_activo / ac.importe_total AS monto_bs,
        cb.importe_mt * ac.importe_activo / ac.importe_total AS monto_usd,
        cb.importe_ma * ac.importe_activo / ac.importe_total AS monto_ufv,
        pa.id_funcionario, --#36
        pa.fecha_compra --#38
        FROM pro.tproyecto_activo pa
        INNER JOIN tactivos ac
        ON ac.id_proyecto_activo = pa.id_proyecto_activo
        INNER JOIN tcbtes cb
        ON cb.id_proyecto = pa.id_proyecto
        INNER JOIN pro.tproyecto py
        ON py.id_proyecto = pa.id_proyecto
        WHERE pa.id_proyecto = p_id_proyecto
        AND COALESCE(pa.codigo_af_rel, '') = ''
        AND pa.id_almacen IS NULL --#50
    ) LOOP

        --Parámetros
        SELECT
        NULL                                                AS id_persona,
        0                                                   AS cantidad_revaloriz,
        NULL                                                AS id_proveedor,
        v_rec.fecha_compra                                  AS fecha_compra, --#38
        v_id_cat_estado_fun                                 AS id_cat_estado_fun,
        v_rec.ubicacion                                     AS ubicacion,
        NULL                                                AS documento,
        v_rec.observaciones                                 AS observaciones,
        1::integer                                          AS monto_rescate,
        v_rec.denominacion                                  AS denominacion,
        COALESCE(v_rec.id_funcionario, v_id_funcionario)    AS id_funcionario, --#36
        v_id_deposito                                       AS id_deposito,
        v_rec.monto_usd                                     AS monto_compra_orig,
        v_rec.monto_bs                                      AS monto_compra,
        v_id_moneda_bs                                      AS id_moneda,
        v_rec.descripcion                                   AS descripcion,
        v_rec.id_moneda                                     AS id_moneda_orig,
        v_rec.fecha_ini_dep                                 AS fecha_ini_dep,
        v_id_cat_estado_compra                              AS id_cat_estado_compra,
        v_rec.vida_util                                     AS vida_util_original,
        'registrado'                                        AS estado,
        v_rec.id_clasificacion                              AS id_clasificacion,
        v_id_oficina                                        AS id_oficina,
        v_rec.id_depto                                      AS id_depto,
        p_id_usuario                                        AS id_usuario_reg,
        NULL                                                AS usuario_ai,
        NULL                                                AS id_usuario_ai,
        NULL                                                AS id_usuario_mod,
        'si'                                                AS en_deposito,
        NULL                                                AS codigo_ant,
        v_rec.marca                                         AS marca,
        v_rec.nro_serie                                     AS nro_serie,
        v_rec.id_unidad_medida                              AS id_unidad_medida,
        v_rec.cantidad_det::integer                         AS cantidad_af,
        v_rec.monto_usd                                     AS monto_compra_orig_100,
        NULL                                                AS nro_cbte_asociado,
        NULL                                                AS fecha_cbte_asociado,
        NULL                                                AS id_cotizacion_det,
        NULL                                                AS id_preingreso_det,
        v_rec.id_ubicacion                                  AS id_ubicacion,
        v_rec.id_grupo                                      AS id_grupo,
        v_rec.id_grupo_clASif                               AS id_grupo_clasif,
        v_rec.id_centro_costo                               AS id_centro_costo,
        v_rec.monto_bs                                      AS monto_compra_sin_actualiz,
        v_rec.id_proyecto_activo                            AS id_proyecto_activo --#57
        INTO v_rec_af;

        --Inserción de activo fijo
        v_id_activo_fijo = kaf.f_insercion_af
                            (
                                p_id_usuario,
                                hstore(v_rec_af),
                                'si'
                            );

        --Generación del código para el activo
        v_codigo = kaf.f_genera_codigo
                    (
                        v_id_activo_fijo
                    );

        UPDATE kaf.tactivo_fijo SET
        codigo = v_codigo
        WHERE id_activo_fijo = v_id_activo_fijo;

        --Inserción de los AFV en todas las monedas
        --Bs
        v_monto_rescate = 1;
        INSERT INTO kaf.tactivo_fijo_valores (
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
            monto_vigente_orig_100,
            id_proyecto_activo, --#57
            fecha_tc_ini_dep --#58
        ) VALUES (
            p_id_usuario,
            now(),
            'activo',
            v_id_activo_fijo,
            v_rec.monto_bs,            --  monto_vigente_orig
            v_rec.vida_util,      --  vida_util_orig
            DATE_TRUNC('day', v_rec.fecha_ini_dep), --#58
            0,
            0,
            0,
            v_rec.monto_bs,            --  monto_vigente
            v_rec.vida_util,      --  vida_util
            'activo',
            'si',
            v_monto_rescate,           --  monto_rescate
            NULL,
            'alta',
            v_codigo,
            (SELECT id_moneda_dep FROM kaf.tmoneda_dep WHERE id_moneda = v_id_moneda_bs), --id_moneda_dep
            v_id_moneda_bs,
            v_rec.fecha_ini_dep,           --  fecha_ini  desde cuando se considera el activo valor
            v_rec.monto_bs,
            v_rec.id_proyecto_activo, --#57
            --Inicio #ETR-3360
            CASE COALESCE(v_act_x_ufv, '')
                WHEN '' THEN DATE_TRUNC('month', v_rec.fecha_ini_dep) - '1 day'::INTERVAL --#58
                ELSE DATE_TRUNC('month', v_rec.fecha_ini_dep)
            END
            --Fin #ETR-3360
        );

        --USD
        v_monto_rescate = param.f_convertir_moneda
                        (
                            v_id_moneda_bs, --moneda origen para conversion
                            v_rec.id_moneda,   --moneda a la que sera convertido
                            1, --este monto siemrpe estara en moenda base
                            v_rec.fecha_fin,
                            'O',-- tipo oficial, venta, compra
                            NULL --defecto dos decimales
                        );

        INSERT INTO kaf.tactivo_fijo_valores(
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
            monto_vigente_orig_100,
            id_proyecto_activo, --#57
            fecha_tc_ini_dep --#58
        ) VALUES(
            p_id_usuario,
            now(),
            'activo',
            v_id_activo_fijo,
            v_rec.monto_usd,            --  monto_vigente_orig
            v_rec.vida_util,      --  vida_util_orig
            DATE_TRUNC('day', v_rec.fecha_ini_dep), --#58           --  fecha_ini_dep
            0,
            0,
            0,
            v_rec.monto_usd,            --  monto_vigente
            v_rec.vida_util,      --  vida_util
            'activo',
            'si',
            v_monto_rescate,           --  monto_rescate
            NULL,
            'alta',
            v_codigo,
            (SELECT id_moneda_dep FROM kaf.tmoneda_dep WHERE id_moneda = v_rec.id_moneda), --id_moneda_dep
            v_rec.id_moneda,
            v_rec.fecha_ini_dep,           --  fecha_ini  desde cuando se considera el activo valor
            v_rec.monto_usd,
            v_rec.id_proyecto_activo, --#57
            --Inicio #ETR-3360
            CASE COALESCE(v_act_x_ufv, '')
                WHEN '' THEN DATE_TRUNC('month', v_rec.fecha_ini_dep) - '1 day'::INTERVAL --#58
                ELSE DATE_TRUNC('month', v_rec.fecha_ini_dep)
            END
            --Fin #ETR-3360
        );

        --UFV
        v_monto_rescate = param.f_convertir_moneda
                        (
                            v_id_moneda_bs, --moneda origen para conversion
                            v_id_moneda_ufv,   --moneda a la que sera convertido
                            1, --este monto siemrpe estara en moenda base
                            v_rec.fecha_fin,
                            'O',-- tipo oficial, venta, compra
                            NULL --defecto dos decimales
                        );

        INSERT INTO kaf.tactivo_fijo_valores(
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
            monto_vigente_orig_100,
            id_proyecto_activo, --#57
            fecha_tc_ini_dep --#58
        ) VALUES (
            p_id_usuario,
            now(),
            'activo',
            v_id_activo_fijo,
            v_rec.monto_ufv,            --  monto_vigente_orig
            v_rec.vida_util,      --  vida_util_orig
            DATE_TRUNC('day', v_rec.fecha_ini_dep), --#58           --  fecha_ini_dep
            0,
            0,
            0,
            v_rec.monto_ufv,            --  monto_vigente
            v_rec.vida_util,      --  vida_util
            'activo',
            'si',
            v_monto_rescate,           --  monto_rescate
            NULL,
            'alta',
            v_codigo,
            (SELECT id_moneda_dep FROM kaf.tmoneda_dep WHERE id_moneda = v_id_moneda_ufv), --id_moneda_dep
            v_id_moneda_ufv,
            v_rec.fecha_ini_dep,           --  fecha_ini  desde cuando se considera el activo valor
            v_rec.monto_ufv,
            v_rec.id_proyecto_activo,
            --Inicio #ETR-3360
            CASE COALESCE(v_act_x_ufv, '')
                WHEN '' THEN DATE_TRUNC('month', v_rec.fecha_ini_dep) - '1 day'::INTERVAL --#58
                ELSE DATE_TRUNC('month', v_rec.fecha_ini_dep)
            END
            --Fin #ETR-3360
        );

        --Actualización del ID activo fijo en proyecto activo
        UPDATE pro.tproyecto_activo SET
        id_activo_fijo = v_id_activo_fijo
        WHERE id_proyecto_activo = v_rec.id_proyecto_activo;

    END LOOP;

    ------------------------------------------------------------------------------------
    -- Relaciona el cierre con los activos fijos que tienen su inmovilizado previamente
    ------------------------------------------------------------------------------------
    --Crea el movimiento de ajuste si existe algún activo para relacionar
    IF EXISTS(SELECT 1 FROM pro.tproyecto_activo
            WHERE id_proyecto = p_id_proyecto
            AND COALESCE(codigo_af_rel,'') <> ''
            AND COALESCE(codigo_af_rel,'') <> 'GASTO'
            AND id_almacen IS NULL --#50
    ) THEN

        --Obtención del ID del movimiento de Ajuste
        SELECT cat.id_catalogo
        INTO v_id_cat_movimiento
        FROM param.tcatalogo cat
        INNER JOIN param.tcatalogo_tipo ctip
        ON ctip.id_catalogo_tipo = cat.id_catalogo_tipo
        WHERE ctip.tabla = 'tmovimiento__id_cat_movimiento'
        AND cat.codigo = 'ajuste';

        IF v_id_cat_movimiento IS NULL THEN
            RAISE EXCEPTION 'No se encuentra registrado el Proceso de Ajuste. Comuníquese con el administrador del sistema.';
        END IF;

        --Parámetros del movimiento de ajuste
        SELECT
        'N/D' AS direccion,
        NULL AS fecha_hasta,
        v_id_cat_movimiento AS id_cat_movimiento,
        v_rec_proy.fecha_fin AS fecha_mov,
        v_id_depto AS id_depto,
        'Ajuste por incremento por Cierre de Proyecto ' || v_rec_proy.codigo || ' - ' || v_rec_proy.nombre AS glosa,
        NULL AS id_funcionario,
        NULL AS id_oficina,
        NULL AS _id_usuario_ai,
        p_id_usuario AS id_usuario,
        NULL AS _nombre_usuario_ai,
        NULL AS id_persona,
        NULL AS codigo,
        NULL AS id_deposito,
        NULL AS id_depto_dest,
        NULL AS id_deposito_dest,
        NULL AS id_funcionario_dest,
        NULL AS id_movimiento_motivo
        INTO v_rec_af;

        --Creación del movimiento
        v_id_movimiento = kaf.f_insercion_movimiento
                        (
                            p_id_usuario,
                            hstore(v_rec_af)
                        );


        --Crea el detalle del movimiento
        v_id_activo_fijo = 0;

        FOR v_rec IN
        (
            WITH tactivos AS (
                SELECT DISTINCT --#41
                pa.id_proyecto,
                pa.id_proyecto_activo,
                SUM(pad.monto) OVER (PARTITION BY pa.id_proyecto_activo) AS importe_activo,
                SUM(pad.monto) OVER (PARTITION BY pa.id_proyecto) AS importe_total
                FROM pro.tproyecto_activo pa
                INNER JOIN pro.tproyecto_activo_detalle pad
                ON pad.id_proyecto_activo = pa.id_proyecto_activo
                WHERE pa.id_proyecto = p_id_proyecto
            ), tcbtes AS (
                SELECT
                py.id_proyecto,
                cb.fecha, --#SIS-2
                SUM(tr.importe_debe_mb) AS importe_mb,
                SUM(tr.importe_debe_mt) AS importe_mt,
                SUM(tr.importe_debe_ma) AS importe_ma
                FROM conta.tint_transaccion tr
                INNER JOIN pro.tproyecto py
                ON py.id_int_comprobante_1 = tr.id_int_comprobante
                OR py.id_int_comprobante_3 = tr.id_int_comprobante
                --Inicio #SIS-2
                INNER JOIN conta.tint_comprobante cb
                ON cb.id_int_comprobante = tr.id_int_comprobante
                --Fin #SIS-2
                WHERE py.id_proyecto = p_id_proyecto
                GROUP BY py.id_proyecto, cb.fecha --#SIS-2
            ), tfecha_ult_dep AS (
                SELECT
                mdep.id_activo_fijo_valor, afv.id_activo_fijo, mdep.id_moneda,
                MAX(mdep.fecha) AS max_fecha
                FROM kaf.tmovimiento_af_dep mdep
                INNER JOIN kaf.tactivo_fijo_valores afv
                ON afv.id_activo_fijo_valor = mdep.id_activo_fijo_valor
                GROUP BY mdep.id_activo_fijo_valor, afv.id_activo_fijo, mdep.id_moneda
            )
            SELECT
            af.id_activo_fijo,
            v_id_cat_estado_fun AS id_cat_estado_fun,
            mdep.vida_util AS vida_util,
            CASE afv.id_moneda
                WHEN 1 THEN
                    --Inicio #ETR-3360
                    CASE COALESCE(v_act_x_ufv, '')
                        WHEN '' THEN
                            --Actualización del importe a incrementar
                            (
                                param.f_get_tipo_cambio(3, (date_trunc('month', py.fecha_fin) - interval '1 day')::date, 'O') /
                                param.f_get_tipo_cambio(3, date_trunc('month', py.fecha_ini)::date, 'O') * --RCM 12/01/2020
                                COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0)
                            ) + COALESCE(mdep.monto_vigente, 0)
                        ELSE 
                            COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0) + COALESCE(mdep.monto_vigente, 0)
                    END
                    --Fin #ETR-3360
                WHEN 2 THEN
                    COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0) + COALESCE(mdep.monto_vigente, 0)
                WHEN 3 THEN
                    COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0) + COALESCE(mdep.monto_vigente, 0)
            END as importe,
            afv.id_moneda,
            /*CASE afv.id_moneda
                WHEN 1 THEN
                    --Actualización del importe a incrementar
                    COALESCE
                    (
                        (
                            param.f_get_tipo_cambio(3, (date_trunc('month', py.fecha_fin) - interval '1 day')::date, 'O') /
                            param.f_get_tipo_cambio(3, date_trunc('year', py.fecha_fin)::date, 'O') *
                            COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0) - afv.monto_rescate
                        ) /
                        mdep.vida_util,
                        0
                    ) + mdep.depreciacion_acum
                WHEN 2 THEN
                    ((COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0) - afv.monto_rescate) / mdep.vida_util) + mdep.depreciacion_acum
                WHEN 3 THEN
                    ((COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0) - afv.monto_rescate) / mdep.vida_util) + mdep.depreciacion_acum
            END as depreciacion_acum,*/
            CASE afv.id_moneda
                WHEN 1 THEN
                    (SELECT po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.depreciacion_acum
                WHEN 2 THEN
                    (SELECT po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.depreciacion_acum
                WHEN 3 THEN
                    (SELECT po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.depreciacion_acum
            END as depreciacion_acum,
            /*CASE afv.id_moneda
                WHEN 1 THEN
                    --Actualización del importe a incrementar
                    COALESCE
                    (
                        (
                            param.f_get_tipo_cambio(3, (date_trunc('month', py.fecha_fin) - interval '1 day')::date, 'O') /
                            param.f_get_tipo_cambio(3, date_trunc('year', py.fecha_fin)::date, 'O') *
                            COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0) - afv.monto_rescate
                        ) /
                        mdep.vida_util,
                        0
                    ) + mdep.depreciacion_per
                WHEN 2 THEN
                    ((COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0) - afv.monto_rescate) / mdep.vida_util) + mdep.depreciacion_per
                WHEN 3 THEN
                    ((COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0) - afv.monto_rescate) / mdep.vida_util) + mdep.depreciacion_per
            END as depreciacion_per,*/
            CASE afv.id_moneda
                WHEN 1 THEN
                    (SELECT po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.depreciacion_per
                WHEN 2 THEN
                    (SELECT po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.depreciacion_per
                WHEN 3 THEN
                    (SELECT po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.depreciacion_per
            END as depreciacion_per,
            CASE afv.id_moneda
                WHEN 1 THEN
                    --Actualización del importe a incrementar
                    COALESCE(mdep.monto_actualiz, 0)  /*+
                    (
                        param.f_get_tipo_cambio(3, (date_trunc('month', py.fecha_fin) - interval '1 day')::date, 'O') /
                        param.f_get_tipo_cambio(3, date_trunc('year', py.fecha_fin)::date, 'O') *
                        COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0)
                    ) */ --#33
                WHEN 2 THEN
                    COALESCE(mdep.monto_actualiz, 0) --+ COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0) --#33
                WHEN 3 THEN
                    COALESCE(mdep.monto_actualiz, 0) --+ COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0) --#33
            END AS monto_vigente_actualiz,
            mdep.fecha + INTERVAL '1 MONTH' AS fecha_ini_dep,
            CASE afv.id_moneda
                WHEN 1 THEN
                    --Inicio #ETR-3360
                    CASE COALESCE(v_act_x_ufv, '')
                        WHEN '' THEN
                            --Actualización del importe a incrementar
                            (
                                param.f_get_tipo_cambio(3, (date_trunc('month', py.fecha_fin) - interval '1 day')::date, 'O') /
                                param.f_get_tipo_cambio(3, (DATE_TRUNC('month', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, 'O') * --#60
                                COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0)
                            )
                        ELSE
                            COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0)
                    END
                    --Fin #ETR-3360
                WHEN 2 THEN
                    COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0)
                WHEN 3 THEN
                    COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0)
            END AS importe_modif,
            mdep.id_activo_fijo_valor,
            af.codigo,            afv.id_moneda_dep,
            pa.id_proyecto_activo,

            --Inicio #33: adición de columnas
            CASE afv.id_moneda
                WHEN 1 THEN
                    (SELECT po_dep_mes_total FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    ))
                WHEN 2 THEN
                    (SELECT po_dep_mes_total FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    ))
                WHEN 3 THEN
                    (SELECT po_dep_mes_total FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    ))
            END as total_depreciacion_mes,

            CASE afv.id_moneda
                WHEN 1 THEN
                    (SELECT po_inc_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    ))
                WHEN 2 THEN
                    (SELECT po_inc_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    ))
                WHEN 3 THEN
                    (SELECT po_inc_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    ))
            END as total_inc_dep_acum,
            CASE afv.id_moneda
                WHEN 1 THEN
                    (SELECT po_valor_actualiz - po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.monto_vigente
                WHEN 2 THEN
                    (SELECT po_valor_actualiz - po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.monto_vigente
                WHEN 3 THEN
                    (SELECT po_valor_actualiz - po_depreciacion_acum FROM kaf.f_calculo_aux_deprec2
                    (
                        --date_trunc('month', py.fecha_ini)::date,  --RCM 12/01/2020
                        --(DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE, --#60
                        DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini))::DATE,
                        --(date_trunc('month', py.fecha_fin) - interval '1 day')::date,
                        (date_trunc('month', py.fecha_fin))::date,
                        (mdep.vida_util + EXTRACT(year FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date))*12 + EXTRACT(month FROM age((date_trunc('month', py.fecha_fin) - interval '1 day')::date,date_trunc('month', py.fecha_ini)::date)) + 1)::integer, --#33 --RCM 13/02/2020
                        COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0),
                        afv.id_moneda,
                        (DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_ini)) - INTERVAL '1 day')::DATE
                    )) + mdep.monto_vigente
            END as valor_neto,
            --Fin #33
            --Inicio #SIS-4
            CASE afv.id_moneda
                WHEN 1 THEN
                    COALESCE(cb.importe_mb * ac.importe_activo / ac.importe_total, 0)
                WHEN 2 THEN
                    COALESCE(cb.importe_mt * ac.importe_activo / ac.importe_total, 0)
                WHEN 3 THEN
                    COALESCE(cb.importe_ma * ac.importe_activo / ac.importe_total, 0)
            END AS importe_modif_sin_act
            --Fin #SIS-4
            FROM pro.tproyecto_activo pa
            INNER JOIN pro.tproyecto py
            ON py.id_proyecto = pa.id_proyecto
            INNER JOIN kaf.tactivo_fijo af
            ON (af.codigo = pa.codigo_af_rel OR af.codigo_ant = pa.codigo_af_rel)
            INNER JOIN kaf.tactivo_fijo_valores afv
            ON afv.id_activo_fijo = af.id_activo_fijo
            INNER JOIN tfecha_ult_dep ud
            ON ud.id_activo_fijo_valor = afv.id_activo_fijo_valor
            AND ud.id_moneda = afv.id_moneda
            INNER JOIN kaf.tmovimiento_af_dep mdep
            ON mdep.id_activo_fijo_valor = ud.id_activo_fijo_valor
            AND mdep.id_moneda = ud.id_moneda
            AND mdep.fecha = ud.max_fecha
            INNER JOIN tactivos ac
            ON ac.id_proyecto_activo = pa.id_proyecto_activo
            INNER JOIN tcbtes cb
            ON cb.id_proyecto = pa.id_proyecto
            WHERE pa.id_proyecto = p_id_proyecto
            AND COALESCE(pa.codigo_af_rel, '') <> ''
            AND COALESCE(pa.codigo_af_rel, '') <> 'GASTO'
            AND pa.id_almacen IS NULL --#50
            AND afv.fecha_fin IS NULL --#41
            ORDER BY af.id_activo_fijo, mdep.id_moneda
        ) LOOP

            IF v_id_activo_fijo <> v_rec.id_activo_fijo AND v_rec.id_moneda = v_id_moneda_base THEN

                --Crea el registro de movimiento detalle
                INSERT INTO kaf.tmovimiento_af(
                id_usuario_reg, fecha_reg,      estado_reg,     id_movimiento,      id_activo_fijo,     id_cat_estado_fun,
                vida_util,      importe,        id_moneda,      depreciacion_acum,  depreciacion_per,   monto_vigente_actualiz,
                fecha_ini_dep,  importe_modif,  id_activo_fijo_valor_original
                ) VALUES (
                p_id_usuario,
                NOW(),
                'activo',
                v_id_movimiento,
                v_rec.id_activo_fijo,
                v_id_cat_estado_fun,
                v_rec.vida_util,
                v_rec.importe,
                v_rec.id_moneda,
                v_rec.depreciacion_acum,
                v_rec.depreciacion_per,
                v_rec.monto_vigente_actualiz,
                v_rec.fecha_ini_dep,
                v_rec.importe_modif,
                v_rec.id_activo_fijo_valor
                ) RETURNING id_movimiento_af INTO v_id_movimiento_af;

                --Finalización de los AFVs actuales del activo fijo
                v_fun = kaf.f_afv_finalizar
                        (
                            p_id_usuario,
                            v_rec.id_activo_fijo,
                            (v_rec.fecha_ini_dep)::date
                        );

                --Setea el id activo fijo
                v_id_activo_fijo = v_rec.id_activo_fijo;
                v_id_movimiento_af = NULL;

            END IF;

            --Creación de los nuevos AFVs
            INSERT INTO kaf.tactivo_fijo_valores (
                id_usuario_reg,
                fecha_reg,
                estado_reg,
                id_activo_fijo,
                vida_util_orig,
                fecha_ini_dep,
                vida_util,
                estado,
                principal,
                id_movimiento_af,
                tipo,
                codigo,
                id_moneda_dep,
                id_moneda,
                fecha_inicio,
                id_activo_fijo_valor_original,
                monto_rescate,
                monto_vigente_orig_100,
                monto_vigente_orig,
                monto_vigente,
                monto_vigente_actualiz_inicial,
                depreciacion_per_inicial,
                depreciacion_acum_inicial,
                importe_modif,
                --Inicio #33
                aux_depmes_tot_del_inc,
                aux_inc_dep_acum_del_inc,
                --Fin #33
                fecha_tc_ini_dep, --#58
                id_proyecto_activo, --#60
                importe_modif_sin_act --#60
            ) VALUES (
                p_id_usuario,
                NOW(),
                'activo',
                v_rec.id_activo_fijo,
                v_rec.vida_util,
                DATE_TRUNC('month', v_rec.fecha_ini_dep), --#58
                v_rec.vida_util,
                'activo',
                'no',
                v_id_movimiento_af,
                'ajuste',
                v_rec.codigo,
                v_rec.id_moneda_dep,
                v_rec.id_moneda,
                v_rec.fecha_ini_dep,
                v_rec.id_activo_fijo_valor,

                CASE v_rec.id_moneda
                    WHEN v_id_moneda_base THEN 1
                    ELSE
                        param.f_convertir_moneda
                        (
                            v_id_moneda_base, --moneda origen para conversion
                            v_rec.id_moneda,   --moneda a la que sera convertido
                            1, --este monto siemrpe estara en moenda base
                            v_rec.fecha_ini_dep::date,
                            'O',-- tipo oficial, venta, compra
                            NULL --defecto dos decimales
                        )
                END,

                v_rec.importe,--v_rec.importe, --#33
                v_rec.valor_neto,--v_rec.importe, --#33
                v_rec.importe,--v_rec.importe, --#33
                v_rec.monto_vigente_actualiz,
                v_rec.depreciacion_per,
                v_rec.depreciacion_acum,
                v_rec.importe_modif,
                --Inicio #33
                v_rec.total_depreciacion_mes,
                v_rec.total_inc_dep_acum,
                --Fin #33
                --Inicio #ETR-3360
                CASE COALESCE(v_act_x_ufv, '')
                    WHEN '' THEN 
                        DATE_TRUNC('month', v_rec.fecha_ini_dep) - '1 day'::INTERVAL --#58
                    ELSE
                        v_act_x_ufv::date
                END,
                --Fin #ETR-3360
                v_rec.id_proyecto_activo, --#60
                v_rec.importe_modif_sin_act --#60
            );

        END LOOP;

        -------------------------------------
        --Finaliza el movimiento por defecto
        -------------------------------------
        --Obtención del estado finalizado y datos principales para el cambio de estado
        SELECT
        te.id_tipo_estado,
        ew.id_estado_wf,
        ew.id_proceso_wf,
        mov.id_depto,
        te.codigo
        INTO
        v_id_tipo_estado,
        v_id_estado_wf_act,
        v_id_proceso_wf_act,
        v_id_depto,
        v_codigo_estado_sig
        FROM kaf.tmovimiento mov
        INNER JOIN wf.testado_wf ew
        ON ew.id_estado_wf = mov.id_estado_wf
        INNER JOIN wf.tproceso_wf pw
        ON pw.id_proceso_wf = ew.id_proceso_wf
        INNER JOIN wf.ttipo_estado te
        ON te.id_tipo_proceso = pw.id_tipo_proceso
        WHERE mov.id_movimiento = v_id_movimiento
        AND te.codigo = 'finalizado';

        --Definición de datos para la notificación
        v_acceso_directo = '../../../sis_kactivos_fijos/vista/movimiento/Movimiento.php';
        v_clase = 'Movimiento';
        v_parametros_ad = '{filtro_directo: {campo: "mov.id_proceso_wf", valor: "' || v_id_proceso_wf_act::varchar || '"}}';
        v_tipo_noti = 'notificacion';
        v_titulo  = 'Finalización';

        --Cambio de estado a Finalizado
        v_id_estado_actual = wf.f_registra_estado_wf
                            (
                                v_id_tipo_estado,
                                NULL,
                                v_id_estado_wf_act,
                                v_id_proceso_wf_act,
                                p_id_usuario,
                                NULL,
                                NULL,
                                v_id_depto,
                                'Obs: Finalización automática del movimiento',
                                v_acceso_directo,
                                v_clase,
                                v_parametros_ad,
                                v_tipo_noti,
                                v_titulo
                            );

        --Actualiza el estado actual del movimiento
        UPDATE kaf.tmovimiento SET
        id_estado_wf = v_id_estado_actual,
        estado = v_codigo_estado_sig
        WHERE id_movimiento = v_id_movimiento;
        ----------------------------------------
        ----------------------------------------
        ----------------------------------------

    END IF;
    --Fin #19

    RETURN 'hecho';


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
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION pro.f_i_kaf_registrar_activos (p_id_usuario integer, p_id_proyecto integer)
  OWNER TO postgres;