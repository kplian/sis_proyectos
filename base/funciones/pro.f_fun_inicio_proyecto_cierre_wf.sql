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
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
  0     PRO       ETR           24/09/2018  RCM         Creación del archivo
 #18    PRO       ETR           08/08/2019  RCM         Modificación generación comprobante 1 para insertar directamente en las 3 monedas sin utilizar la plantilla
 #50    PRO       ETR           09/12/2019  RCM         Inclusión de almacén en importación de cierre
 #60    PRO       ETR           28/07/2020  RCM         Lógica para la generación cbte. 2 y 3. Nueva plantilla para cbte 3
***************************************************************************
*/
DECLARE

    v_nombre_funcion                text;
    v_resp                          varchar;
    v_rec                           record;
    v_id_int_comprobante            integer;
    v_plantilla_cbte                varchar[];
    v_id_int_comprobante4           integer;
    v_alta                          varchar;
    --Inicio #18
    v_saldo_cbtes_cierre            numeric;
    v_saldo_cbtes_conta             numeric;
    --Fin #18
    --Inicio #60
    v_haber_mb                      NUMERIC;
    v_debe_mb                       NUMERIC;
    --Fin #60

BEGIN

    --Identificación del nombre de la función
    v_nombre_funcion = 'pro.f_fun_inicio_proyecto_cierre_wf';
    v_plantilla_cbte[0] = 'PRO-CIE1V2';--#18 cambio de versión de la plantilla que sólo genera la cabecera
    v_plantilla_cbte[1] = 'PRO-CIE2';
    v_plantilla_cbte[2] = 'PRO-CIE3V2'; --#60 'PRO-CIE3'
    v_plantilla_cbte[3] = 'PRO-CIE4';

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
        ------------------------------------
        --GENERACIÓN DE COMPROBANTE CONTABLE
        ------------------------------------

        --Verificación existencia del proyecto
        if not exists(select 1
                    from pro.tproyecto_activo
                    where id_proyecto = v_rec.id_proyecto) then
            raise exception 'Proyecto inexistente';
        end if;

        -------------------------------
        --Genera el comprobante 1 de 4
        -------------------------------
        --Inicio #18 (Sólo genera la cabecera)
        v_id_int_comprobante = conta.f_gen_comprobante
                                (
                                    v_rec.id_proyecto,
                                    v_plantilla_cbte[0],
                                    p_id_estado_wf,
                                    p_id_usuario,
                                    p_id_usuario_ai,
                                    p_usuario_ai
                                );

        --Registro del detalle de comprobante (1/3): DEBE, LO QUE NO ES GASTO
        INSERT INTO conta.tint_transaccion
        (
            id_partida,
            id_centro_costo,
            estado_reg,
            id_cuenta,
            id_int_comprobante,
            importe_debe,
            importe_debe_mb,
            importe_debe_mt,
            importe_debe_ma,
            importe_gasto,
            importe_gasto_mb,
            importe_gasto_mt,
            importe_gasto_ma,
            importe_haber,
            importe_haber_mb,
            importe_haber_mt,
            importe_haber_ma,
            importe_recurso,
            importe_recurso_mb,
            importe_recurso_mt,
            importe_recurso_ma,
            id_usuario_reg,
            fecha_reg,
            glosa
        )
        WITH ttotales AS (
            SELECT
            py.id_proyecto,
            SUM(tr.importe_debe_mt - tr.importe_haber_mt) AS importe_mt,
            SUM(tr.importe_debe_ma - tr.importe_haber_ma) AS importe_ma
            FROM pro.tproyecto py
            JOIN pro.tproyecto_columna_tcc pc
            ON pc.id_proyecto = py.id_proyecto
            JOIN param.ttipo_cc tcc
            ON tcc.id_tipo_cc = pc.id_tipo_cc
            JOIN param.tcentro_costo cc
            ON cc.id_tipo_cc = pc.id_tipo_cc
            JOIN conta.tint_transaccion tr
            ON tr.id_centro_costo =
            cc.id_centro_costo
            JOIN conta.tint_comprobante cbte
            ON cbte.id_int_comprobante = tr.id_int_comprobante
            AND cbte.estado_reg::text = 'validado'::text
            AND cbte.fecha BETWEEN py.fecha_ini AND py.fecha_fin
            JOIN conta.tcuenta cue
            ON cue.id_cuenta = tr.id_cuenta
            WHERE NOT
            (cue.nro_cuenta IN
                (
                    SELECT nro_cuenta
                    FROM pro.tcuenta_excluir
                )
            )
            GROUP BY py.id_proyecto
        ), trel_contable AS(
            SELECT
            rc.id_tabla AS id_clasificacion,
            CASE trc.codigo_tipo_relacion
                WHEN 'CIEPRO' /*'ALTAAF'*/ THEN
                    (('{' || kaf.f_get_id_clasificaciones(rc.id_tabla, 'hijos')) || '}')::integer [ ]
                ELSE
                    null
            END AS nodos,
            rc.id_cuenta, rc.id_partida, rc.id_gestion, ges.gestion, trc.codigo_tipo_relacion, rc.id_centro_costo
            FROM conta.ttabla_relacion_contable tb
            JOIN conta.ttipo_relacion_contable trc
            ON trc.id_tabla_relacion_contable = tb.id_tabla_relacion_contable
            JOIN conta.trelacion_contable rc
            ON rc.id_tipo_relacion_contable = trc.id_tipo_relacion_contable
            INNER JOIN param.tgestion ges
            ON ges.id_gestion = rc.id_gestion
            WHERE
            (tb.esquema = 'KAF'
            AND tb.tabla = 'tclasificacion'
            AND trc.codigo_tipo_relacion = 'CIEPRO'/*'ALTAAF'*/)
            OR trc.codigo_tipo_relacion = 'CCDEPCON'

        )
        SELECT
        rc.id_partida,
        rc_1.id_centro_costo,
        'activo',
        rc.id_cuenta,
        v_id_int_comprobante,
        SUM(pad.monto) AS importe_debe,
        SUM(pad.monto * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) AS importe_debe_mb,
        SUM(pad.monto) AS importe_debe_mt,
        SUM(tot.importe_ma * pad.monto/tot.importe_mt) AS importe_debe_ma,
        SUM(pad.monto) AS importe_gasto,
        SUM(pad.monto * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) AS importe_gasto_mb,
        SUM(pad.monto) AS importe_gasto_mt,
        SUM(tot.importe_ma * pad.monto/tot.importe_mt) AS importe_gasto_ma,
        0 AS importe_haber,
        0 AS importe_haber_mb,
        0 AS importe_haber_mt,
        0 AS importe_haber_ma,
        0 AS importe_recurso,
        0 AS importe_recurso_mb,
        0 AS importe_recurso_mt,
        0 AS importe_recurso_ma,
        p_id_usuario,
        now(),
        pa.denominacion
        FROM pro.tproyecto_activo_detalle pad
        JOIN pro.tproyecto_activo pa ON pa.id_proyecto_activo = pad.id_proyecto_activo
        JOIN pro.tproyecto py ON py.id_proyecto = pa.id_proyecto
        JOIN ttotales tot ON tot.id_proyecto = py.id_proyecto
        JOIN trel_contable rc
        ON pa.id_clasificacion = ANY (rc.nodos)
        AND rc.codigo_tipo_relacion = 'CIEPRO' --'ALTAAF'
        AND rc.gestion = date_part('year', py.fecha_fin)::integer
        JOIN trel_contable rc_1
        ON rc_1.codigo_tipo_relacion = 'CCDEPCON'
        AND rc_1.gestion = date_part('year', py.fecha_fin)::integer
        WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
        AND py.id_proyecto = v_rec.id_proyecto
        AND pa.id_almacen IS NULL --#50
        GROUP BY py.id_proyecto, pa.id_proyecto_activo, pa.denominacion, pa.id_clasificacion,
        py.id_moneda, rc.id_cuenta, rc.id_partida, rc.gestion, rc_1.id_centro_costo
        HAVING SUM(pad.monto) > 0; --#60

        --Registro del detalle de comprobante (2/3): DEBE, LO QUE ES GASTO
        INSERT INTO conta.tint_transaccion
        (
            id_partida,
            id_centro_costo,
            estado_reg,
            id_cuenta,
            id_int_comprobante,
            importe_debe,
            importe_debe_mb,
            importe_debe_mt,
            importe_debe_ma,
            importe_gasto,
            importe_gasto_mb,
            importe_gasto_mt,
            importe_gasto_ma,
            importe_haber,
            importe_haber_mb,
            importe_haber_mt,
            importe_haber_ma,
            importe_recurso,
            importe_recurso_mb,
            importe_recurso_mt,
            importe_recurso_ma,
            id_usuario_reg,
            fecha_reg,
            glosa
        )
        WITH ttotales AS (
            SELECT
            py.id_proyecto,
            SUM(tr.importe_debe_mt - tr.importe_haber_mt) AS importe_mt,
            SUM(tr.importe_debe_ma - tr.importe_haber_ma) AS importe_ma
            FROM pro.tproyecto py
            JOIN pro.tproyecto_columna_tcc pc
            ON pc.id_proyecto = py.id_proyecto
            JOIN param.ttipo_cc tcc
            ON tcc.id_tipo_cc = pc.id_tipo_cc
            JOIN param.tcentro_costo cc
            ON cc.id_tipo_cc = pc.id_tipo_cc
            JOIN conta.tint_transaccion tr
            ON tr.id_centro_costo =
            cc.id_centro_costo
            JOIN conta.tint_comprobante cbte
            ON cbte.id_int_comprobante = tr.id_int_comprobante
            AND cbte.estado_reg::text = 'validado'::text
            AND cbte.fecha BETWEEN py.fecha_ini AND py.fecha_fin
            JOIN conta.tcuenta cue
            ON cue.id_cuenta = tr.id_cuenta
            WHERE NOT
            (cue.nro_cuenta IN
                (
                    SELECT nro_cuenta
                    FROM pro.tcuenta_excluir
                )
            )
            GROUP BY py.id_proyecto
        ), trel_contable AS(
            SELECT
            rc.id_cuenta, rc.id_partida, rc.id_gestion, ges.gestion, trc.codigo_tipo_relacion, rc.id_centro_costo
            FROM  conta.ttipo_relacion_contable trc
            JOIN conta.trelacion_contable rc
            ON rc.id_tipo_relacion_contable = trc.id_tipo_relacion_contable
            INNER JOIN param.tgestion ges
            ON ges.id_gestion = rc.id_gestion
            WHERE trc.codigo_tipo_relacion IN ('PRO-CIEGANT', 'CCDEPCON')
        )
        SELECT
        rc.id_partida,
        rc_1.id_centro_costo,
        'activo',
        rc.id_cuenta,
        v_id_int_comprobante,
        SUM(pad.monto) AS importe_debe,
        SUM(pad.monto * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) AS importe_debe_mb,
        SUM(pad.monto) AS importe_debe_mt,
        SUM(tot.importe_ma * pad.monto / tot.importe_mt) AS importe_debe_ma,
        SUM(pad.monto) AS importe_gasto,
        SUM(pad.monto * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) AS importe_gasto_mb,
        SUM(pad.monto) AS importe_gasto_mt,
        SUM(tot.importe_ma * pad.monto / tot.importe_mt) AS importe_gasto_ma,
        0 AS importe_haber,
        0 AS importe_haber_mb,
        0 AS importe_haber_mt,
        0 AS importe_haber_ma,
        0 AS importe_recurso,
        0 AS importe_recurso_mb,
        0 AS importe_recurso_mt,
        0 AS importe_recurso_ma,
        p_id_usuario,
        now(),
        pa.denominacion
        FROM pro.tproyecto_activo_detalle pad
        JOIN pro.tproyecto_activo pa ON pa.id_proyecto_activo = pad.id_proyecto_activo
        JOIN pro.tproyecto py ON py.id_proyecto = pa.id_proyecto
        JOIN ttotales tot ON tot.id_proyecto = py.id_proyecto
        JOIN trel_contable rc
        ON rc.codigo_tipo_relacion = 'PRO-CIEGANT'
        AND rc.gestion = date_part('year', py.fecha_fin)::integer
        JOIN trel_contable rc_1
        ON rc_1.codigo_tipo_relacion = 'CCDEPCON'
        AND rc_1.gestion = date_part('year', py.fecha_fin)::integer
        WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
        AND py.id_proyecto = v_rec.id_proyecto
        AND pa.id_almacen IS NULL --#50
        GROUP BY py.id_proyecto, pa.id_proyecto_activo, pa.denominacion, pa.id_clasificacion,
        py.id_moneda, rc.id_cuenta, rc.id_partida, rc.gestion, rc_1.id_centro_costo
        HAVING SUM(pad.monto) > 0; --#60

        --Inicio #50
        --Registro del detalle de comprobante (3/4): DEBE, LO QUE VA DIRECTO A ALMACÉN
        INSERT INTO conta.tint_transaccion
        (
            id_partida,
            id_centro_costo,
            estado_reg,
            id_cuenta,
            id_int_comprobante,
            importe_debe,
            importe_debe_mb,
            importe_debe_mt,
            importe_debe_ma,
            importe_gasto,
            importe_gasto_mb,
            importe_gasto_mt,
            importe_gasto_ma,
            importe_haber,
            importe_haber_mb,
            importe_haber_mt,
            importe_haber_ma,
            importe_recurso,
            importe_recurso_mb,
            importe_recurso_mt,
            importe_recurso_ma,
            id_usuario_reg,
            fecha_reg,
            glosa
        )
        WITH ttotales AS (
            SELECT
            py.id_proyecto,
            SUM(tr.importe_debe_mt - tr.importe_haber_mt) AS importe_mt,
            SUM(tr.importe_debe_ma - tr.importe_haber_ma) AS importe_ma
            FROM pro.tproyecto py
            JOIN pro.tproyecto_columna_tcc pc
            ON pc.id_proyecto = py.id_proyecto
            JOIN param.ttipo_cc tcc
            ON tcc.id_tipo_cc = pc.id_tipo_cc
            JOIN param.tcentro_costo cc
            ON cc.id_tipo_cc = pc.id_tipo_cc
            JOIN conta.tint_transaccion tr
            ON tr.id_centro_costo =
            cc.id_centro_costo
            JOIN conta.tint_comprobante cbte
            ON cbte.id_int_comprobante = tr.id_int_comprobante
            AND cbte.estado_reg::text = 'validado'::text
            AND cbte.fecha BETWEEN py.fecha_ini AND py.fecha_fin
            JOIN conta.tcuenta cue
            ON cue.id_cuenta = tr.id_cuenta
            WHERE NOT
            (cue.nro_cuenta IN
                (
                    SELECT nro_cuenta
                    FROM pro.tcuenta_excluir
                )
            )
            GROUP BY py.id_proyecto
        ), trel_contable AS (
            SELECT
            rc.id_cuenta, rc.id_partida, rc.id_gestion, ges.gestion, trc.codigo_tipo_relacion, rc.id_centro_costo
            FROM  conta.ttipo_relacion_contable trc
            JOIN conta.trelacion_contable rc
            ON rc.id_tipo_relacion_contable = trc.id_tipo_relacion_contable
            INNER JOIN param.tgestion ges
            ON ges.id_gestion = rc.id_gestion
            WHERE trc.codigo_tipo_relacion = 'CCDEPCON'
        ), trel_contable_alm AS (
            SELECT
            rc.id_tabla AS id_almacen, rc.id_cuenta, rc.id_partida, ges.gestion
            FROM conta.ttabla_relacion_contable tb
            JOIN conta.ttipo_relacion_contable trc
            ON trc.id_tabla_relacion_contable = tb.id_tabla_relacion_contable
            JOIN conta.trelacion_contable rc
            ON rc.id_tipo_relacion_contable = trc.id_tipo_relacion_contable
            JOIN param.tgestion ges
            ON ges.id_gestion = rc.id_gestion
            WHERE tb.esquema = 'ALM'
            AND tb.tabla = 'talmacen'
            AND trc.codigo_tipo_relacion = 'ALMING'
        )
        SELECT
        rcalm.id_partida,
        rc.id_centro_costo,
        'activo',
        rcalm.id_cuenta,
        v_id_int_comprobante,
        SUM(pad.monto) AS importe_debe,
        SUM(pad.monto * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) AS importe_debe_mb,
        SUM(pad.monto) AS importe_debe_mt,
        SUM(tot.importe_ma * pad.monto / tot.importe_mt) AS importe_debe_ma,
        SUM(pad.monto) AS importe_gasto,
        SUM(pad.monto * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) AS importe_gasto_mb,
        SUM(pad.monto) AS importe_gasto_mt,
        SUM(tot.importe_ma * pad.monto / tot.importe_mt) AS importe_gasto_ma,
        0 AS importe_haber,
        0 AS importe_haber_mb,
        0 AS importe_haber_mt,
        0 AS importe_haber_ma,
        0 AS importe_recurso,
        0 AS importe_recurso_mb,
        0 AS importe_recurso_mt,
        0 AS importe_recurso_ma,
        p_id_usuario,
        now(),
        pa.denominacion
        FROM pro.tproyecto_activo_detalle pad
        JOIN pro.tproyecto_activo pa
        ON pa.id_proyecto_activo = pad.id_proyecto_activo
        JOIN pro.tproyecto py
        ON py.id_proyecto = pa.id_proyecto
        JOIN ttotales tot
        ON tot.id_proyecto = py.id_proyecto
        JOIN trel_contable_alm rcalm
        ON rcalm.id_almacen = pa.id_almacen
        AND rcalm.gestion = date_part('year', py.fecha_fin)::integer
        JOIN trel_contable rc
        ON rc.gestion = date_part('year', py.fecha_fin)::integer
        WHERE pa.id_almacen IS NOT NULL
        AND py.id_proyecto = v_rec.id_proyecto
        GROUP BY py.id_proyecto, pa.id_proyecto_activo, pa.denominacion, pa.id_clasificacion,
        py.id_moneda, rcalm.id_cuenta, rcalm.id_partida, rcalm.gestion, rc.id_centro_costo
        HAVING SUM(pad.monto) > 0;
        --Fin #50

        --Registro del detalle de comprobante (4/4): HABER CON EL TOTAL
        INSERT INTO conta.tint_transaccion
        (
            id_partida,
            id_centro_costo,
            estado_reg,
            id_cuenta,
            id_int_comprobante,
            importe_debe,
            importe_debe_mb,
            importe_debe_mt,
            importe_debe_ma,
            importe_gasto,
            importe_gasto_mb,
            importe_gasto_mt,
            importe_gasto_ma,
            importe_haber,
            importe_haber_mb,
            importe_haber_mt,
            importe_haber_ma,
            importe_recurso,
            importe_recurso_mb,
            importe_recurso_mt,
            importe_recurso_ma,
            id_usuario_reg,
            fecha_reg
        )
        WITH trel_contable AS(
            SELECT rc_1.id_gestion,
            rc_1.id_partida,
            ges.gestion
            FROM conta.ttipo_relacion_contable trc
            JOIN conta.trelacion_contable rc_1
            ON rc_1.id_tipo_relacion_contable = trc.id_tipo_relacion_contable
            JOIN param.tgestion ges
            ON ges.id_gestion = rc_1.id_gestion
            WHERE trc.codigo_tipo_relacion::text = 'PRO-CIECBTE1'::text
        )
        SELECT
        rc.id_partida,
        cc.id_centro_costo,
        'activo',
        cue.id_cuenta,
        v_id_int_comprobante,
        0 AS importe_debe,
        0 AS importe_debe_mb,
        0 AS importe_debe_mt,
        0 AS importe_debe_ma,
        0 AS importe_gasto,
        0 AS importe_gasto_mb,
        0 AS importe_gasto_mt,
        0 AS importe_gasto_ma,
        SUM(tr.importe_debe_mt - tr.importe_haber_mt) AS importe_haber,
        SUM((tr.importe_debe_mt * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) - (tr.importe_haber_mt * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O'))) AS importe_haber_mb,
        SUM(tr.importe_debe_mt - tr.importe_haber_mt) AS importe_haber_mt,
        SUM(tr.importe_debe_ma - tr.importe_haber_ma) AS importe_haber_ma,
        SUM(tr.importe_debe_mt - tr.importe_haber_mt) AS importe_recurso,
        SUM((tr.importe_debe_mt * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O')) - (tr.importe_haber_mt * param.f_get_tipo_cambio_v2(py.id_moneda, param.f_get_moneda_base(), py.fecha_fin, 'O'))) AS importe_recurso_mb,
        SUM(tr.importe_debe_mt - tr.importe_haber_mt) AS importe_recurso_mt,
        SUM(tr.importe_debe_ma - tr.importe_haber_ma) AS importe_recurso_ma,
        p_id_usuario,
        now()
        FROM pro.tproyecto py
        JOIN pro.tproyecto_columna_tcc pc
        ON pc.id_proyecto = py.id_proyecto
        JOIN param.ttipo_cc tcc
        ON tcc.id_tipo_cc = pc.id_tipo_cc
        JOIN param.tcentro_costo cc
        ON cc.id_tipo_cc = pc.id_tipo_cc
        JOIN conta.tint_transaccion tr
        ON tr.id_centro_costo = cc.id_centro_costo
        JOIN conta.tint_comprobante cbte
        ON cbte.id_int_comprobante = tr.id_int_comprobante
        AND cbte.estado_reg::text = 'validado'::text
        AND cbte.fecha BETWEEN py.fecha_ini AND py.fecha_fin
        JOIN conta.tcuenta cue
        ON cue.id_cuenta = tr.id_cuenta
        JOIN trel_contable rc
        ON rc.gestion = date_part('year'::text, py.fecha_fin)::integer
        WHERE NOT (cue.nro_cuenta::text IN (
            SELECT tcuenta_excluir.nro_cuenta
            FROM pro.tcuenta_excluir
        ))
        AND py.id_proyecto = v_rec.id_proyecto
        GROUP BY py.id_proyecto, cc.id_centro_costo, cue.id_cuenta, cue.nro_cuenta,
        cue.nombre_cuenta, tcc.codigo, py.id_moneda, rc.id_partida
        HAVING SUM(tr.importe_debe_mt - tr.importe_haber_mt) > 0; --#60
        --Fin #18

        --Inicio #60
        --ENTRE EL DEBE Y HABER SE GENERA DIFERENCIA POR DECIMALES, PORQUE EL CBTE REDONDEA A 2. Y COMO EL HABER LO SUMA EN UNO NO PIERDE DECIMALES, PERO SI EL DEBE
        --ESA DIFERENCIA SE AJUSTARÁ EN UNA TRANSACCIÓN DEL DEBE
        SELECT SUM(importe_haber_mb), SUM(importe_debe_mb)
        INTO v_haber_mb, v_debe_mb
        FROM conta.tint_transaccion
        WHERE id_int_comprobante = v_id_int_comprobante;

        IF ABS(v_haber_mb - v_debe_mb) <= 1 AND ABS(v_haber_mb - v_debe_mb) > 0  THEN
            UPDATE conta.tint_transaccion AA SET
            importe_debe_mb = importe_debe_mb + (v_haber_mb - v_debe_mb),
            importe_gasto_mb = importe_gasto_mb + (v_haber_mb - v_debe_mb)
            FROM (
                SELECT id_int_transaccion
                FROM conta.tint_transaccion
                WHERE id_int_comprobante = v_id_int_comprobante
                AND COALESCE(importe_debe_mb, 0) > 0
                ORDER BY id_int_transaccion DESC LIMIT 1
                ) DD
            WHERE DD.id_int_transaccion = AA.id_int_transaccion
            AND AA.id_int_comprobante = v_id_int_comprobante;
        END IF;
        --Fin #60

        --Actualización del Id del comprobante
        update pro.tproyecto set
        id_int_comprobante_1 = v_id_int_comprobante
        where id_proceso_wf_cierre = p_id_proceso_wf;


        -------------------------------
        --Genera el comprobante 2 de 4
        -------------------------------
        v_id_int_comprobante = conta.f_gen_comprobante
                                (
                                    v_rec.id_proyecto,
                                    v_plantilla_cbte[1],
                                    p_id_estado_wf,
                                    p_id_usuario,
                                    p_id_usuario_ai,
                                    p_usuario_ai
                                );

        --Inicio #60
        IF EXISTS(SELECT 1
                FROM conta.tint_transaccion
                WHERE id_int_comprobante = v_id_int_comprobante) THEN
            --Actualización del Id del comprobante
            update pro.tproyecto set
            id_int_comprobante_2 = v_id_int_comprobante
            where id_proceso_wf_cierre = p_id_proceso_wf;

            update conta.tint_comprobante set
            cbte_aitb = 'si',
            tipo_cambio_2 = 0,
            tipo_cambio_3 = 0
            where id_int_comprobante = v_id_int_comprobante;

            --Eliminación de importes en dólares y UFV, y marcado como transacciones de actualización
            update conta.tint_transaccion set
            importe_debe_mt = 0,
            importe_haber_mt = 0,
            importe_recurso_mt = 0,
            importe_gasto_mt = 0,
            importe_debe_ma = 0,
            importe_haber_ma = 0,
            importe_recurso_ma = 0,
            importe_gasto_ma = 0,
            actualizacion = 'si'
            where id_int_comprobante = v_id_int_comprobante;
        ELSE
            DELETE FROM conta.tint_comprobante WHERE id_int_comprobante = v_id_int_comprobante;
        END IF;
        --Fin #60

        --Inicio #18
        --Verifica si hay pendiente aún algún saldo para cerrar el proyecto. Sólo si hay diferencia genera el 3er comprobante
        --Se obtiene el saldo del cierre realizado
        SELECT
        ABS(SUM(tr.importe_debe_mb - tr.importe_haber_mb)) as saldo
        INTO v_saldo_cbtes_cierre
        FROM pro.tproyecto py
        JOIN pro.tproyecto_columna_tcc pc
        ON pc.id_proyecto = py.id_proyecto
        JOIN param.ttipo_cc tcc
        ON tcc.id_tipo_cc = pc.id_tipo_cc
        JOIN param.tcentro_costo cc
        ON cc.id_tipo_cc = tcc.id_tipo_cc
        JOIN conta.tint_transaccion tr
        ON tr.id_centro_costo = cc.id_centro_costo
        JOIN conta.tint_comprobante cbte
        ON cbte.id_int_comprobante = tr.id_int_comprobante
        AND cbte.id_int_comprobante IN (py.id_int_comprobante_1, py.id_int_comprobante_2)
        WHERE py.id_proyecto = v_rec.id_proyecto;

        --Se obtiene el saldo de conta
        SELECT
        ABS(SUM(tr.importe_debe_mb - tr.importe_haber_mb)) AS saldo
        INTO v_saldo_cbtes_conta
        FROM pro.tproyecto py
        JOIN pro.tproyecto_columna_tcc pc
        ON pc.id_proyecto = py.id_proyecto
        JOIN param.ttipo_cc tcc
        ON tcc.id_tipo_cc = pc.id_tipo_cc
        JOIN param.tcentro_costo cc
        ON cc.id_tipo_cc = pc.id_tipo_cc
        JOIN conta.tint_transaccion tr
        ON tr.id_centro_costo = cc.id_centro_costo
        JOIN conta.tint_comprobante cbte
        ON cbte.id_int_comprobante = tr.id_int_comprobante
        AND cbte.estado_reg::text = 'validado'::text
        AND cbte.fecha BETWEEN py.fecha_ini AND py.fecha_fin
        JOIN conta.tcuenta cue
        ON cue.id_cuenta = tr.id_cuenta
        WHERE NOT
        (cue.nro_cuenta IN
            (
                SELECT nro_cuenta
                FROM pro.tcuenta_excluir
            )
        )
        AND py.id_proyecto = v_rec.id_proyecto;

        --Verifica si hay algún saldo para generar el tercer comprobante
        IF COALESCE(v_saldo_cbtes_cierre, 0) - COALESCE(v_saldo_cbtes_conta, 0) <> 0 THEN
            --Genera el tercer comprobante
            -------------------------------
            --Genera el comprobante 3 de 4
            -------------------------------
            v_id_int_comprobante = conta.f_gen_comprobante
                                    (
                                        v_rec.id_proyecto,
                                        v_plantilla_cbte[2],
                                        p_id_estado_wf,
                                        p_id_usuario,
                                        p_id_usuario_ai,
                                        p_usuario_ai
                                    );

            --Inicio #60
            --ENTRE EL DEBE Y HABER SE GENERA DIFERENCIA POR DECIMALES, PORQUE EL CBTE REDONDEA A 2. Y COMO EL HABER LO SUMA EN UNO NO PIERDE DECIMALES, PERO SI EL DEBE
            --ESA DIFERENCIA SE AJUSTARÁ EN UNA TRANSACCIÓN DEL DEBE
            SELECT SUM(importe_haber_mb), SUM(importe_debe_mb)
            INTO v_haber_mb, v_debe_mb
            FROM conta.tint_transaccion
            WHERE id_int_comprobante = v_id_int_comprobante;

            IF ABS(v_haber_mb - v_debe_mb) <= 1 AND ABS(v_haber_mb - v_debe_mb) > 0  THEN
                UPDATE conta.tint_transaccion AA SET
                importe_debe = importe_debe + (v_haber_mb - v_debe_mb),
                importe_gasto = importe_gasto + (v_haber_mb - v_debe_mb),
                importe_debe_mb = importe_debe_mb + (v_haber_mb - v_debe_mb),
                importe_gasto_mb = importe_gasto_mb + (v_haber_mb - v_debe_mb)
                FROM (
                    SELECT id_int_transaccion
                    FROM conta.tint_transaccion
                    WHERE id_int_comprobante = v_id_int_comprobante
                    AND COALESCE(importe_debe_mb, 0) > 0
                    ORDER BY id_int_transaccion DESC LIMIT 1
                    ) DD
                WHERE DD.id_int_transaccion = AA.id_int_transaccion
                AND AA.id_int_comprobante = v_id_int_comprobante;
            END IF;
            --Fin #60

            --Actualización del Id del comprobante
            update pro.tproyecto set
            id_int_comprobante_3 = v_id_int_comprobante
            where id_proceso_wf_cierre = p_id_proceso_wf;

            update conta.tint_comprobante set
            cbte_aitb = 'si',
            tipo_cambio_2 = 0,
            tipo_cambio_3 = 0
            where id_int_comprobante = v_id_int_comprobante;

            --Eliminación de importes en dólares y UFV, y marcado como transacciones de actualización
            update conta.tint_transaccion set
            importe_debe_mt = 0,
            importe_haber_mt = 0,
            importe_recurso_mt = 0,
            importe_gasto_mt = 0,
            importe_debe_ma = 0,
            importe_haber_ma = 0,
            importe_recurso_ma = 0,
            importe_gasto_ma = 0,
            actualizacion = 'si'
            where id_int_comprobante = v_id_int_comprobante;

        END IF;

        --Fin #18



        --Inicio #18: Se comenta el 4to comprobante porque ya no es necesario
        ------------------------------
        --Genera el comprobante 4 de 4 (comprobante temporal que sus transacciones se unen al comprobante 3 y luego este comprobante es eliminado. Esto porque el generador no permite elegir sólo que genere en Bs y UFV)
        ------------------------------
        /*v_id_int_comprobante4 = conta.f_gen_comprobante
                                (
                                    v_rec.id_proyecto,
                                    v_plantilla_cbte[3],
                                    p_id_estado_wf,
                                    p_id_usuario,
                                    p_id_usuario_ai,
                                    p_usuario_ai
                                );


        --Eliminación de importes en dólares y UFV, y marcado como transacciones de actualización
        update conta.tint_transaccion set
        importe_debe_mt = 0,
        importe_haber_mt = 0,
        importe_recurso_mt = 0,
        importe_gasto_mt = 0,
        importe_debe_mb = 0,
        importe_haber_mb = 0,
        importe_recurso_mb = 0,
        importe_gasto_mb = 0,
        importe_debe = 0,
        importe_haber = 0,
        importe_recurso = 0,
        importe_gasto = 0,
        actualizacion = 'si'
        where id_int_comprobante = v_id_int_comprobante4;

        --Une las transacciones al comprobante 3
        update conta.tint_transaccion set
        id_int_comprobante = v_id_int_comprobante
        where id_int_comprobante = v_id_int_comprobante4;

        --Elimina el WF del comprobante 4
        delete from wf.testado_wf where id_proceso_wf in (select id_proceso_wf from conta.tint_comprobante where id_int_comprobante = v_id_int_comprobante4);
        delete from wf.tproceso_wf where id_proceso_wf in (select id_proceso_wf from conta.tint_comprobante where id_int_comprobante = v_id_int_comprobante4);

        --Eliminación del comprobante 4
        delete from conta.tint_comprobante where id_int_comprobante = v_id_int_comprobante4;*/
        --Fin #18

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
