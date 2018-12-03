/***********************************I-DEP-RCM-PRO-1-12/10/2017****************************************/

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
ALTER TABLE pro.tproyecto_activo_detalle
  ADD CONSTRAINT fk_tproyecto_activo_detalle__id_proyecto_activo FOREIGN KEY (id_proyecto_activo)
    REFERENCES pro.tproyecto_activo(id_proyecto_activo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_contrato
  ADD CONSTRAINT fk_tproyecto_contrato__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
ALTER TABLE pro.tproyecto_contrato
  ADD CONSTRAINT fk_tproyecto_contrato__id_contrato FOREIGN KEY (id_contrato)
    REFERENCES leg.tcontrato(id_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
ALTER TABLE pro.tproyecto_funcionario
  ADD CONSTRAINT "fk_tproyecto_funcionario__id_proyecto" FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-PRO-1-12/10/2017****************************************/


/***********************************I-DEP-RCM-PRO-1-19/10/2017****************************************/

ALTER TABLE pro.tproyecto_activo_detalle
  ADD CONSTRAINT fk_tproyecto_activo_detalle__id_tipo_cc FOREIGN KEY (id_tipo_cc)
    REFERENCES param.ttipo_cc(id_tipo_cc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-PRO-1-19/10/2017****************************************/

/***********************************I-DEP-RCM-PRO-1-15/05/2018****************************************/
ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase
  ADD CONSTRAINT fk_tfase__id_tipo_cc FOREIGN KEY (id_tipo_cc)
    REFERENCES param.ttipo_cc(id_tipo_cc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase_concepto_ingas
  ADD CONSTRAINT fk_tfase_concepto_ingas__id_fase FOREIGN KEY (id_fase)
    REFERENCES pro.tfase(id_fase)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase_concepto_ingas
  ADD CONSTRAINT fk_tfase_concepto_ingas__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase_concepto_ingas
  ADD CONSTRAINT fk_tfase_concepto_ingas__id_unidad_medida FOREIGN KEY (id_unidad_medida)
    REFERENCES param.tunidad_medida(id_unidad_medida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion
  ADD CONSTRAINT fk_tinvitacion__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion_det
  ADD CONSTRAINT fk_tinvitacion_det__id_invitacion FOREIGN KEY (id_invitacion)
    REFERENCES pro.tinvitacion(id_invitacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion_det
  ADD CONSTRAINT fk_tinvitacion_det__id_fase_concepto_ingas FOREIGN KEY (id_fase_concepto_ingas)
    REFERENCES pro.tfase_concepto_ingas(id_fase_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion_solicitud
  ADD CONSTRAINT fk_tinvitacion_solicitud__id_invitacion FOREIGN KEY (id_invitacion)
    REFERENCES pro.tinvitacion(id_invitacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion_solicitud
  ADD CONSTRAINT fk_tinvitacion_solicitud__id_solicitud FOREIGN KEY (id_solicitud)
    REFERENCES adq.tsolicitud(id_solicitud)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-PRO-1-15/05/2018****************************************/

/***********************************I-DEP-RCM-PRO-1-10/08/2018****************************************/
ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_tipo_cc FOREIGN KEY (id_tipo_cc)
    REFERENCES param.ttipo_cc(id_tipo_cc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-PRO-1-10/08/2018****************************************/

/***********************************I-DEP-RCM-PRO-1-15/08/2018****************************************/
ALTER TABLE pro.tfase_plantilla
  ADD CONSTRAINT fk_tfase_plantilla__id_tipo_cc_plantilla FOREIGN KEY (id_tipo_cc_plantilla)
    REFERENCES param.ttipo_cc_plantilla(id_tipo_cc_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
/***********************************F-DEP-RCM-PRO-1-15/08/2018****************************************/

/***********************************I-DEP-RCM-PRO-1-17/09/2018****************************************/
ALTER TABLE pro.tproyecto_columna_tcc
  ADD CONSTRAINT fk_tproyecto_columna_tcc__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_columna_tcc
  ADD CONSTRAINT fk_tproyecto_columna_tcc__id_tipo_cc FOREIGN KEY (id_tipo_cc)
    REFERENCES param.ttipo_cc(id_tipo_cc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-PRO-1-17/09/2018****************************************/

/***********************************I-DEP-RCM-PRO-1-20/09/2018****************************************/

ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_depto_conta FOREIGN KEY (id_depto_conta)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_det(
    id_proyecto,
    codigo,
    id_centro_costo,
    id_clasificacion,
    id_moneda,
    importe)
AS
  SELECT pro.id_proyecto,
         tcc.codigo,
         cc.id_centro_costo,
         pa.id_clasificacion,
         pro.id_moneda,
         sum(pad.monto) AS importe
  FROM pro.tproyecto_activo_detalle pad
       JOIN pro.tproyecto_activo pa ON pa.id_proyecto_activo =
         pad.id_proyecto_activo
       JOIN pro.tproyecto pro ON pro.id_proyecto = pa.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pad.id_tipo_cc
       JOIN param.vcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc AND (
         cc.id_gestion IN (
                            SELECT ges.id_gestion
                            FROM param.tgestion ges
                            WHERE date_trunc('year'::text, ges.fecha_ini::
                              timestamp with time zone) = date_trunc('year'::
                              text, pro.fecha_fin::timestamp with time zone)
       ))
  GROUP BY pro.id_proyecto,
           tcc.codigo,
           cc.id_centro_costo,
           pa.id_clasificacion,
           pro.id_moneda;
/***********************************F-DEP-RCM-PRO-1-20/09/2018****************************************/

/***********************************I-DEP-RCM-PRO-1-25/09/2018****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1
AS
select
proy.id_proyecto,
proy.fecha_fin,
proy.id_depto_conta,
proy.nro_tramite_cierre,
'Cierre Proyecto '||tcc.descripcion||' ('||tcc.codigo||') al '||to_char(proy.fecha_fin,'dd/mm/yyyy') as glosa_cbte,
proy.id_moneda,
(select id_gestion from param.tgestion g where date_trunc('year',g.fecha_ini) = date_trunc('year',proy.fecha_fin)) as id_gestion
from pro.tproyecto proy
inner join param.vtipo_cc tcc
on tcc.id_tipo_cc = proy.id_tipo_cc;
/***********************************F-DEP-RCM-PRO-1-25/09/2018****************************************/

/***********************************I-DEP-EGS-PRO-0-26/11/2018****************************************/

select wf.f_import_ttipo_documento_estado ('insert','AVFIS','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','CRONO','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','DIAUN','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','NOR30','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','PRESU','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','TRALI','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','RESEJ','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','PREPT','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('delete','TRALI','PPY','ejecucion','PPY',NULL,NULL,NULL);
select wf.f_import_ttipo_documento_estado ('insert','STEA','PPY','nuevo','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','LICAM','PPY','ejecucion','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','NOR11','PPY','finalizado','PPY','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','REPFO','PPY','ejecucion','PPY','crear','superior','');


select wf.f_import_ttipo_documento_estado ('insert','AVFISF','PFA','nuevo','PFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','CRONOF','PFA','nuevo','PFA','crear','superior','');
select wf.f_import_ttipo_documento_estado ('insert','PREPTF','PFA','nuevo','PFA','crear','superior','');

/***********************************F-DEP-EGS-PRO-0-26/11/2018****************************************/

/***********************************I-DEP-EGS-PRO-1-03/11/2018****************************************/
DROP VIEW pro.v_cbte_cierre_proy_1_det;
COMMENT ON COLUMN pro.tproyecto.id_depto_conta
IS '';
COMMENT ON COLUMN pro.tproyecto.id_estado_wf
IS 'Estado Wf del proyecto';

COMMENT ON COLUMN pro.tproyecto.nro_tramite
IS 'Nro de trámite del proyecto';

COMMENT ON COLUMN pro.tproyecto.estado
IS 'Estadodel Proyecto';



CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2 (
    id_proyecto,
    fecha_fin,
    id_depto_conta,
    nro_tramite_cierre,
    glosa_cbte,
    id_moneda,
    id_gestion)
AS
 SELECT proy.id_proyecto,
    proy.fecha_fin,
    proy.id_depto_conta,
    proy.nro_tramite_cierre,
    (((('Reversión Actualización por AITB de la gestión , cierre Proyecto '::text || tcc.descripcion::text) || ' ('::text) || tcc.codigo::text) || ') al '::text) || to_char(proy.fecha_fin::timestamp with time zone, 'dd/mm/yyyy'::text) AS glosa_cbte,
    param.f_get_moneda_base() AS id_moneda,
    ( SELECT g.id_gestion
           FROM param.tgestion g
          WHERE date_trunc('year'::text, g.fecha_ini::timestamp with time zone) = date_trunc('year'::text, proy.fecha_fin::timestamp with time zone)) AS id_gestion
   FROM pro.tproyecto proy
     JOIN param.vtipo_cc tcc ON tcc.id_tipo_cc = proy.id_tipo_cc;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4 (
    id_proyecto,
    fecha_fin,
    id_depto_conta,
    nro_tramite_cierre,
    glosa_cbte,
    id_moneda,
    id_gestion)
AS
 SELECT proy.id_proyecto,
    proy.fecha_fin,
    proy.id_depto_conta,
    proy.nro_tramite_cierre,
    (((('Diferencia UFV Cierre- Mayor, cierre Proyecto '::text || tcc.descripcion::text) || ' ('::text) || tcc.codigo::text) || ') al '::text) || to_char(proy.fecha_fin::timestamp with time zone, 'dd/mm/yyyy'::text) AS glosa_cbte,
    3 AS id_moneda,
    ( SELECT g.id_gestion
           FROM param.tgestion g
          WHERE date_trunc('year'::text, g.fecha_ini::timestamp with time zone) = date_trunc('year'::text, proy.fecha_fin::timestamp with time zone)) AS id_gestion
   FROM pro.tproyecto proy
     JOIN param.vtipo_cc tcc ON tcc.id_tipo_cc = proy.id_tipo_cc;
CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_historico_cuenta (
    id_proyecto,
    id_cuenta,
    id_partida,
    id_centro_costo,
    id_tipo_cc,
    codigo,
    importe_bs)
AS
 SELECT py.id_proyecto,
    tr.id_cuenta,
    tr.id_partida,
    tr.id_centro_costo,
    tcc1.id_tipo_cc,
    tcc1.codigo,
    sum(tr.importe_debe_mb) - sum(tr.importe_haber_mb) AS importe_bs
   FROM pro.tproyecto py
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
     JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~ (tcc.codigo::text || '%'::text)
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
     JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
     JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
     JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
           FROM pro.tcuenta_excluir))
  GROUP BY py.id_proyecto, tr.id_cuenta, tr.id_partida, tr.id_centro_costo, tcc1.id_tipo_cc, tcc1.codigo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3 (
    id_proyecto,
    fecha_fin,
    id_depto_conta,
    nro_tramite_cierre,
    glosa_cbte,
    id_moneda,
    id_gestion)
AS
 SELECT proy.id_proyecto,
    proy.fecha_fin,
    proy.id_depto_conta,
    proy.nro_tramite_cierre,
    (((('Reversión Actualización por AITB gestiones pasadas, cierre Proyecto '::text || tcc.descripcion::text) || ' ('::text) || tcc.codigo::text) || ') al '::text) || to_char(proy.fecha_fin::timestamp with time zone, 'dd/mm/yyyy'::text) AS glosa_cbte,
    param.f_get_moneda_base() AS id_moneda,
    ( SELECT g.id_gestion
           FROM param.tgestion g
          WHERE date_trunc('year'::text, g.fecha_ini::timestamp with time zone) = date_trunc('year'::text, proy.fecha_fin::timestamp with time zone)) AS id_gestion
   FROM pro.tproyecto proy
     JOIN param.vtipo_cc tcc ON tcc.id_tipo_cc = proy.id_tipo_cc;



CREATE OR REPLACE VIEW pro.v_cierre_proy_4_haber_det (
    id_proyecto,
    id_centro_costo,
    id_cuenta,
    nro_cuenta,
    nombre_cuenta,
    codigo,
    importe,
    id_partida)
AS
 SELECT py.id_proyecto,
    cc.id_centro_costo,
    cue.id_cuenta,
    cue.nro_cuenta,
    cue.nombre_cuenta,
    tcc.codigo,
    sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe,
    ( SELECT tpartida.id_partida
           FROM pre.tpartida
          WHERE tpartida.codigo::text = '20300'::text AND (tpartida.id_gestion IN ( SELECT tgestion.id_gestion
                   FROM param.tgestion
                  WHERE date_trunc('year'::text, tgestion.fecha_ini::timestamp with time zone) = date_trunc('year'::text, py.fecha_fin::timestamp with time zone)))) AS id_partida
   FROM pro.tproyecto py
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
     JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~ (tcc.codigo::text || '%'::text)
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
     JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
     JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
     JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
           FROM pro.tcuenta_excluir))
  GROUP BY py.id_proyecto, cc.id_centro_costo, cue.id_cuenta, cue.nro_cuenta, cue.nombre_cuenta, tcc.codigo;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_haber_det (
    id_proyecto,
    id_centro_costo,
    id_cuenta,
    nro_cuenta,
    nombre_cuenta,
    codigo,
    importe,
    id_partida)
AS
 SELECT py.id_proyecto,
    cc.id_centro_costo,
    cue.id_cuenta,
    cue.nro_cuenta,
    cue.nombre_cuenta,
    tcc.codigo,
    sum(tr.importe_debe_mt) - sum(tr.importe_haber_mt) AS importe,
    ( SELECT tpartida.id_partida
           FROM pre.tpartida
          WHERE tpartida.codigo::text = '20300'::text AND (tpartida.id_gestion IN ( SELECT tgestion.id_gestion
                   FROM param.tgestion
                  WHERE date_trunc('year'::text, tgestion.fecha_ini::timestamp with time zone) = date_trunc('year'::text, py.fecha_fin::timestamp with time zone)))) AS id_partida
   FROM pro.tproyecto py
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
     JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~ (tcc.codigo::text || '%'::text)
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
     JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
     JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
     JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
           FROM pro.tcuenta_excluir))
  GROUP BY py.id_proyecto, cc.id_centro_costo, cue.id_cuenta, cue.nro_cuenta, cue.nombre_cuenta, tcc.codigo;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_haber_det__v2 (
    id_proyecto,
    id_centro_costo,
    id_cuenta,
    nro_cuenta,
    nombre_cuenta,
    codigo,
    importe,
    id_partida)
AS
 SELECT py.id_proyecto,
    cc.id_centro_costo,
    cue.id_cuenta,
    cue.nro_cuenta,
    cue.nombre_cuenta,
    tcc.codigo,
    sum(tr.importe_debe_mt) - sum(tr.importe_haber_mt) AS importe,
    ( SELECT tpartida.id_partida
           FROM pre.tpartida
          WHERE tpartida.codigo::text = '20300'::text AND (tpartida.id_gestion IN ( SELECT tgestion.id_gestion
                   FROM param.tgestion
                  WHERE date_trunc('year'::text, tgestion.fecha_ini::timestamp with time zone) = date_trunc('year'::text, py.fecha_fin::timestamp with time zone)))) AS id_partida
   FROM pro.tproyecto py
     JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = pc.id_tipo_cc
     JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
     JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
     JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
           FROM pro.tcuenta_excluir))
  GROUP BY py.id_proyecto, cc.id_centro_costo, cue.id_cuenta, cue.nro_cuenta, cue.nombre_cuenta, tcc.codigo;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_historico (
    id_proyecto,
    id_tipo_cc,
    codigo,
    importe_bs)
AS
 SELECT py.id_proyecto,
    tcc.id_tipo_cc,
    tcc.codigo,
    sum(tr.importe_debe_mb) - sum(tr.importe_haber_mb) AS importe_bs
   FROM pro.tproyecto py
     JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
     JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
     JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
     JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
           FROM pro.tcuenta_excluir))
  GROUP BY py.id_proyecto, tcc.id_tipo_cc, tcc.codigo;



CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det_2 (
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    sum,
    importe_ufv,
    id_centro_costo)
AS
 WITH tdatos AS (
         SELECT DISTINCT pa_1.id_proyecto,
            pa_1.id_clasificacion,
            sum(pad_1.monto) OVER (PARTITION BY pa_1.id_clasificacion, pa_1.id_proyecto) AS importe,
            sum(pad_1.monto) OVER (PARTITION BY pa_1.id_proyecto) AS total
           FROM pro.tproyecto_activo pa_1
             JOIN pro.tproyecto_activo_detalle pad_1 ON pad_1.id_proyecto_activo = pa_1.id_proyecto_activo
             JOIN pro.tproyecto pr_1 ON pr_1.id_proyecto = pa_1.id_proyecto
        ), tmayor_ufv AS (
         SELECT py.id_proyecto,
            tcc.id_tipo_cc,
            cc_1.id_centro_costo,
            cue.id_cuenta,
            cue.nro_cuenta,
            cue.nombre_cuenta,
            tcc.codigo,
            sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe
           FROM pro.tproyecto py
             JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
             JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~ (tcc.codigo::text || '%'::text)
             JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
             JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc_1.id_centro_costo
             JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
             JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
          WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
                   FROM pro.tcuenta_excluir))
          GROUP BY py.id_proyecto, tcc.id_tipo_cc, cc_1.id_centro_costo, cue.id_cuenta, cue.nro_cuenta, cue.nombre_cuenta, tcc.codigo
        )
 SELECT pa.id_proyecto,
    pa.id_clasificacion,
    pad.id_tipo_cc,
    sum(pad.monto) AS sum,
    (( SELECT tmayor_ufv.importe
           FROM tmayor_ufv
          WHERE tmayor_ufv.id_proyecto = pa.id_proyecto AND tmayor_ufv.id_tipo_cc = pad.id_tipo_cc)) - sum(param.f_convertir_moneda(2, 3, pad.monto, pr.fecha_fin, 'O'::character varying, 2)) AS importe_ufv,
    cc.id_centro_costo
   FROM pro.tproyecto_activo pa
     JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
     JOIN pro.tproyecto pr ON pr.id_proyecto = pa.id_proyecto
     JOIN tdatos d ON d.id_proyecto = pa.id_proyecto AND d.id_clasificacion = pa.id_clasificacion
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = pad.id_tipo_cc AND (cc.id_gestion IN ( SELECT tgestion.id_gestion
           FROM param.tgestion
          WHERE date_trunc('year'::text, tgestion.fecha_ini::timestamp with time zone) = date_trunc('year'::text, pr.fecha_fin::timestamp with time zone)))
  GROUP BY pa.id_proyecto, pa.id_clasificacion, pad.id_tipo_cc, cc.id_centro_costo;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_debe_det (
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    importe)
AS
 SELECT pro.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    pa.id_clasificacion,
    pro.id_moneda,
    sum(pad.monto) AS importe
   FROM pro.tproyecto_activo_detalle pad
     JOIN pro.tproyecto_activo pa ON pa.id_proyecto_activo = pad.id_proyecto_activo
     JOIN pro.tproyecto pro ON pro.id_proyecto = pa.id_proyecto
  WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
  GROUP BY pro.id_proyecto, pa.id_proyecto_activo, pa.denominacion, pa.id_clasificacion, pro.id_moneda;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_det (
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    importe_actualiz)
AS
 SELECT pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    pa.id_clasificacion,
    param.f_get_moneda_base() AS id_moneda,
    sum(COALESCE(padm.importe_actualiz, 0::numeric)) AS importe_actualiz
   FROM pro.tproyecto_activo pa
     JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
     LEFT JOIN pro.tproyecto_activo_det_mon padm ON padm.id_proyecto_activo_detalle = pad.id_proyecto_activo_detalle
  WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
  GROUP BY pa.id_proyecto, pa.id_proyecto_activo, pa.denominacion, pa.id_clasificacion;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_haber_det_bk (
    id_proyecto,
    id_centro_costo,
    id_cuenta,
    nro_cuenta,
    nombre_cuenta,
    codigo,
    importe,
    id_partida)
AS
 SELECT pa.id_proyecto,
    cc.id_centro_costo,
    cue.id_cuenta,
    cue.nro_cuenta,
    cue.nombre_cuenta,
    tcc.codigo,
    sum(tr.importe_debe_mt) - sum(tr.importe_haber_mt) AS importe,
    ( SELECT tpartida.id_partida
           FROM pre.tpartida
          WHERE tpartida.codigo::text = '20300'::text AND (tpartida.id_gestion IN ( SELECT tgestion.id_gestion
                   FROM param.tgestion
                  WHERE date_trunc('year'::text, tgestion.fecha_ini::timestamp with time zone) = date_trunc('year'::text, py.fecha_fin::timestamp with time zone)))) AS id_partida
   FROM pro.tproyecto_activo pa
     JOIN pro.tproyecto py ON py.id_proyecto = pa.id_proyecto
     JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pad.id_tipo_cc
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = pad.id_tipo_cc
     JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
     JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta AND NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
           FROM pro.tcuenta_excluir))
  GROUP BY cue.id_cuenta, cue.nro_cuenta, cue.nombre_cuenta, tcc.codigo, pa.id_proyecto, cc.id_centro_costo, py.fecha_fin
 HAVING (sum(tr.importe_debe) - sum(tr.importe_haber)) > 0::numeric;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_haber_det (
    id_proyecto,
    id_tipo_cc,
    cc,
    id_cuenta,
    id_partida,
    id_centro_costo,
    importe_bs)
AS
 WITH tproyecto_tcc AS (
         SELECT DISTINCT py.id_proyecto,
            pad.id_tipo_cc,
            py.fecha_fin
           FROM pro.tproyecto py
             JOIN pro.tproyecto_activo pa ON pa.id_proyecto = py.id_proyecto
             JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
        )
 SELECT pcc.id_proyecto,
    tcc.id_tipo_cc,
    tcc.codigo AS cc,
    tra.id_cuenta,
    tra.id_partida,
    tra.id_centro_costo,
    round(sum(tra.importe_debe_mb) - sum(tra.importe_haber_mb), 2) AS importe_bs
   FROM conta.tint_transaccion tra
     JOIN param.tcentro_costo cc ON cc.id_centro_costo = tra.id_centro_costo
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
     JOIN tproyecto_tcc pcc ON pcc.id_tipo_cc = cc.id_tipo_cc
     JOIN conta.tint_comprobante cb ON cb.id_int_comprobante = tra.id_int_comprobante AND cb.estado_reg::text = 'validado'::text AND cb.cbte_aitb::text = 'si'::text AND cb.fecha <= pcc.fecha_fin
     JOIN conta.tcuenta cta ON cta.id_cuenta = tra.id_cuenta
     JOIN pre.tpartida par ON par.id_partida = tra.id_partida AND (par.codigo::text = ANY (ARRAY['28100'::character varying::text, '68201'::character varying::text]))
  GROUP BY pcc.id_proyecto, tcc.id_tipo_cc, tcc.codigo, tra.id_cuenta, tra.id_partida, tra.id_centro_costo;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det_3 (
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
 WITH t_mayor_ufv AS (
         SELECT py.id_proyecto,
            sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe_ufv_mayor
           FROM pro.tproyecto py
             JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
             JOIN param.ttipo_cc tcc1 ON tcc1.id_tipo_cc = pc.id_tipo_cc
             JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
             JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc_1.id_centro_costo
             JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
             JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
          WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
                   FROM pro.tcuenta_excluir))
          GROUP BY py.id_proyecto
        ), t_prorrateo AS (
         SELECT pa_1.id_proyecto,
            pa_1.id_proyecto_activo,
            pad_1.id_proyecto_activo_detalle,
            pr_1.fecha_fin,
            tcc.id_tipo_cc,
            pad_1.monto,
            pa_1.id_centro_costo,
            pa_1.id_clasificacion,
            sum(pad_1.monto) OVER (PARTITION BY pa_1.id_proyecto) AS total
           FROM pro.tproyecto_activo pa_1
             JOIN pro.tproyecto_activo_detalle pad_1 ON pad_1.id_proyecto_activo = pa_1.id_proyecto_activo
             JOIN pro.tproyecto pr_1 ON pr_1.id_proyecto = pa_1.id_proyecto
             LEFT JOIN param.tcentro_costo cc ON cc.id_centro_costo = pa_1.id_centro_costo
             LEFT JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
        )
 SELECT p.id_proyecto,
    p.id_clasificacion,
    p.id_tipo_cc,
    p.id_centro_costo,
    sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::character varying, 2)) AS importe_ufv_original,
    round(sum(m.importe_ufv_mayor * (p.monto / p.total)), 2) AS importe_mayor_prorateado,
    round(sum(m.importe_ufv_mayor * (p.monto / p.total)) - sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::character varying, 2)), 2) AS importe_ufv
   FROM t_prorrateo p
     JOIN t_mayor_ufv m ON m.id_proyecto = p.id_proyecto
  GROUP BY p.id_proyecto, p.id_clasificacion, p.id_tipo_cc, p.id_centro_costo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_gasto_debe_det (
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    importe)
AS
 SELECT pro.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    pa.id_clasificacion,
    pro.id_moneda,
    sum(pad.monto) AS importe
   FROM pro.tproyecto_activo_detalle pad
     JOIN pro.tproyecto_activo pa ON pa.id_proyecto_activo = pad.id_proyecto_activo
     JOIN pro.tproyecto pro ON pro.id_proyecto = pa.id_proyecto
  WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
  GROUP BY pro.id_proyecto, pa.id_proyecto_activo, pa.denominacion, pa.id_clasificacion, pro.id_moneda;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_prorrateo (
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    codigo_af_rel,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
 WITH t_mayor_ufv AS (
         SELECT py.id_proyecto,
            sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe_ufv_mayor
           FROM pro.tproyecto py
             JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
             JOIN param.ttipo_cc tcc1 ON tcc1.id_tipo_cc = pc.id_tipo_cc
             JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
             JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc_1.id_centro_costo
             JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
             JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
          WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
                   FROM pro.tcuenta_excluir))
          GROUP BY py.id_proyecto
        ), t_prorrateo AS (
         SELECT pa_1.id_proyecto,
            pa_1.id_proyecto_activo,
            pad_1.id_proyecto_activo_detalle,
            pr_1.fecha_fin,
            tcc.id_tipo_cc,
            pad_1.monto,
            pa_1.id_centro_costo,
            pa_1.id_clasificacion,
            pa_1.codigo_af_rel,
            sum(pad_1.monto) OVER (PARTITION BY pa_1.id_proyecto) AS total
           FROM pro.tproyecto_activo pa_1
             JOIN pro.tproyecto_activo_detalle pad_1 ON pad_1.id_proyecto_activo = pa_1.id_proyecto_activo
             JOIN pro.tproyecto pr_1 ON pr_1.id_proyecto = pa_1.id_proyecto
             LEFT JOIN param.tcentro_costo cc ON cc.id_centro_costo = pa_1.id_centro_costo
             LEFT JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
        )
 SELECT p.id_proyecto,
    p.id_clasificacion,
    p.id_tipo_cc,
    p.id_centro_costo,
    p.codigo_af_rel,
    sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::character varying, 2)) AS importe_ufv_original,
    round(sum(m.importe_ufv_mayor * (p.monto / p.total)), 2) AS importe_mayor_prorateado,
    round(sum(m.importe_ufv_mayor * (p.monto / p.total)) - sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::character varying, 2)), 2) AS importe_ufv
   FROM t_prorrateo p
     JOIN t_mayor_ufv m ON m.id_proyecto = p.id_proyecto
  GROUP BY p.id_proyecto, p.id_clasificacion, p.id_tipo_cc, p.id_centro_costo, p.codigo_af_rel;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_gestion_cuenta (
    id_proyecto,
    id_cuenta,
    id_partida,
    id_centro_costo,
    id_tipo_cc,
    cc,
    importe_bs)
AS
 WITH tproyecto_tcc AS (
         SELECT DISTINCT py.id_proyecto,
            pad.id_tipo_cc,
            py.fecha_fin
           FROM pro.tproyecto py
             JOIN pro.tproyecto_activo pa ON pa.id_proyecto = py.id_proyecto
             JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
        )
 SELECT pcc.id_proyecto,
    tra.id_cuenta,
    tra.id_partida,
    tra.id_centro_costo,
    tcc.id_tipo_cc,
    tcc.codigo AS cc,
    sum(tra.importe_debe_mb) - sum(tra.importe_haber_mb) AS importe_bs
   FROM conta.tint_transaccion tra
     JOIN param.tcentro_costo cc ON cc.id_centro_costo = tra.id_centro_costo
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
     JOIN tproyecto_tcc pcc ON pcc.id_tipo_cc = cc.id_tipo_cc
     JOIN conta.tint_comprobante cb ON cb.id_int_comprobante = tra.id_int_comprobante AND cb.estado_reg::text = 'validado'::text AND cb.cbte_aitb::text = 'si'::text AND cb.fecha <= pcc.fecha_fin
     JOIN conta.tcuenta cta ON cta.id_cuenta = tra.id_cuenta
     JOIN pre.tpartida par ON par.id_partida = tra.id_partida
  GROUP BY pcc.id_proyecto, tra.id_cuenta, tra.id_partida, tra.id_centro_costo, tcc.id_tipo_cc, tcc.codigo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_det (
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    importe_actualiz)
AS
 SELECT pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    pa.id_clasificacion,
    param.f_get_moneda_base() AS id_moneda,
    sum(COALESCE(padm.importe_actualiz, 0::numeric)) AS importe_actualiz
   FROM pro.tproyecto_activo pa
     JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
     LEFT JOIN pro.tproyecto_activo_det_mon padm ON padm.id_proyecto_activo_detalle = pad.id_proyecto_activo_detalle
  WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
  GROUP BY pa.id_proyecto, pa.id_proyecto_activo, pa.denominacion, pa.id_clasificacion;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_gestion (
    id_proyecto,
    id_tipo_cc,
    cc,
    importe_bs)
AS
 WITH tproyecto_tcc AS (
         SELECT DISTINCT py.id_proyecto,
            pad.id_tipo_cc,
            py.fecha_fin
           FROM pro.tproyecto py
             JOIN pro.tproyecto_activo pa ON pa.id_proyecto = py.id_proyecto
             JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
        )
 SELECT pcc.id_proyecto,
    tcc.id_tipo_cc,
    tcc.codigo AS cc,
    sum(tra.importe_debe_mb) - sum(tra.importe_haber_mb) AS importe_bs
   FROM conta.tint_transaccion tra
     JOIN param.tcentro_costo cc ON cc.id_centro_costo = tra.id_centro_costo
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
     JOIN tproyecto_tcc pcc ON pcc.id_tipo_cc = cc.id_tipo_cc
     JOIN conta.tint_comprobante cb ON cb.id_int_comprobante = tra.id_int_comprobante AND cb.estado_reg::text = 'validado'::text AND cb.cbte_aitb::text = 'si'::text AND cb.fecha <= pcc.fecha_fin
     JOIN conta.tcuenta cta ON cta.id_cuenta = tra.id_cuenta
     JOIN pre.tpartida par ON par.id_partida = tra.id_partida AND (par.codigo::text = ANY (ARRAY['28100'::character varying, '68201'::character varying]::text[]))
  GROUP BY pcc.id_proyecto, tcc.id_tipo_cc, tcc.codigo;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_bs (
    id_proyecto,
    id_tipo_cc,
    codigo,
    importe_bs)
AS
 SELECT pro.id_proyecto,
    tcc.id_tipo_cc,
    tcc.codigo,
    param.f_convertir_moneda(pro.id_moneda, param.f_get_moneda_base(), sum(pad.monto), pro.fecha_fin, 'O'::character varying, NULL::integer) AS importe_bs
   FROM pro.tproyecto_activo_detalle pad
     JOIN pro.tproyecto_activo pa ON pa.id_proyecto_activo = pad.id_proyecto_activo
     JOIN pro.tproyecto pro ON pro.id_proyecto = pa.id_proyecto
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pad.id_tipo_cc
  GROUP BY pro.id_proyecto, tcc.id_tipo_cc, tcc.codigo, pro.id_moneda, pro.fecha_fin;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det (
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    importe,
    total,
    importe_ufv)
AS
 WITH tactivo_prorrateo AS (
         WITH tproy_activo AS (
                 SELECT pro.id_proyecto,
                    pa_1.id_proyecto_activo,
                    pa_1.denominacion,
                    pa_1.id_clasificacion,
                    pro.id_moneda,
                    sum(pad.monto) AS importe
                   FROM pro.tproyecto_activo_detalle pad
                     JOIN pro.tproyecto_activo pa_1 ON pa_1.id_proyecto_activo = pad.id_proyecto_activo
                     JOIN pro.tproyecto pro ON pro.id_proyecto = pa_1.id_proyecto
                  GROUP BY pro.id_proyecto, pa_1.id_proyecto_activo, pa_1.denominacion, pa_1.id_clasificacion, pro.id_moneda
                )
         SELECT pa.id_proyecto,
            pa.id_proyecto_activo,
            pa.denominacion,
            pa.id_clasificacion,
            pa.id_moneda,
            pa.importe,
            sum(pa.importe) OVER () AS total
           FROM tproy_activo pa
        ), tmayor_ufv AS (
         SELECT py.id_proyecto,
            tcc.id_tipo_cc,
            cc.id_centro_costo,
            cue.id_cuenta,
            cue.nro_cuenta,
            cue.nombre_cuenta,
            tcc.codigo,
            sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe,
            ( SELECT tpartida.id_partida
                   FROM pre.tpartida
                  WHERE tpartida.codigo::text = '20300'::text AND (tpartida.id_gestion IN ( SELECT tgestion.id_gestion
                           FROM param.tgestion
                          WHERE date_trunc('year'::text, tgestion.fecha_ini::timestamp with time zone) = date_trunc('year'::text, py.fecha_fin::timestamp with time zone)))) AS id_partida
           FROM pro.tproyecto py
             JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
             JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~ (tcc.codigo::text || '%'::text)
             JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
             JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
             JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha <= py.fecha_fin
             JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
          WHERE NOT (tr.id_cuenta IN ( SELECT tcuenta_excluir.id_cuenta
                   FROM pro.tcuenta_excluir))
          GROUP BY py.id_proyecto, tcc.id_tipo_cc, cc.id_centro_costo, cue.id_cuenta, cue.nro_cuenta, cue.nombre_cuenta, tcc.codigo
        )
 SELECT ap.id_proyecto,
    ap.id_proyecto_activo,
    ap.denominacion,
    ap.id_clasificacion,
    ap.id_moneda,
    ap.importe,
    ap.total,
    COALESCE(( SELECT sum(tmayor_ufv.importe) AS sum
           FROM tmayor_ufv
          WHERE tmayor_ufv.id_proyecto = ap.id_proyecto), 0::numeric) * (ap.importe / ap.total) AS importe_ufv
   FROM tactivo_prorrateo ap;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det_4 (
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
 SELECT v_cbte_cierre_proy_4_prorrateo.id_proyecto,
    v_cbte_cierre_proy_4_prorrateo.id_clasificacion,
    v_cbte_cierre_proy_4_prorrateo.id_tipo_cc,
    v_cbte_cierre_proy_4_prorrateo.id_centro_costo,
    v_cbte_cierre_proy_4_prorrateo.importe_ufv_original,
    v_cbte_cierre_proy_4_prorrateo.importe_mayor_prorateado,
    v_cbte_cierre_proy_4_prorrateo.importe_ufv
   FROM pro.v_cbte_cierre_proy_4_prorrateo
  WHERE COALESCE(v_cbte_cierre_proy_4_prorrateo.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_gasto_debe_det (
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
 SELECT v_cbte_cierre_proy_4_prorrateo.id_proyecto,
    v_cbte_cierre_proy_4_prorrateo.id_clasificacion,
    v_cbte_cierre_proy_4_prorrateo.id_tipo_cc,
    v_cbte_cierre_proy_4_prorrateo.id_centro_costo,
    v_cbte_cierre_proy_4_prorrateo.importe_ufv_original,
    v_cbte_cierre_proy_4_prorrateo.importe_mayor_prorateado,
    v_cbte_cierre_proy_4_prorrateo.importe_ufv
   FROM pro.v_cbte_cierre_proy_4_prorrateo
  WHERE COALESCE(v_cbte_cierre_proy_4_prorrateo.codigo_af_rel, ''::character varying)::text = 'GASTO'::text;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_resumen (
    id_proyecto,
    id_tipo_cc,
    id_centro_costo,
    codigo,
    importe_bs_aitb_hist,
    importe_bs_cierre,
    importe_bs_aitb,
    dif_aitb_bruto,
    dif_aitb)
AS
 SELECT t1.id_proyecto,
    t1.id_tipo_cc,
    cc.id_centro_costo,
    t1.codigo,
    t1.importe_bs AS importe_bs_aitb_hist,
    t2.importe_bs AS importe_bs_cierre,
    t3.importe_bs AS importe_bs_aitb,
    t1.importe_bs - t2.importe_bs AS dif_aitb_bruto,
    t1.importe_bs - t2.importe_bs - t3.importe_bs AS dif_aitb
   FROM pro.vproyecto_cierre_aitb_historico t1
     JOIN pro.vproyecto_cierre_bs t2 ON t2.id_proyecto = t1.id_proyecto AND t2.id_tipo_cc = t1.id_tipo_cc
     JOIN pro.vproyecto_cierre_aitb_gestion t3 ON t3.id_proyecto = t1.id_proyecto AND t3.id_tipo_cc = t1.id_tipo_cc
     JOIN pro.tproyecto py ON py.id_proyecto = t1.id_proyecto
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = t1.id_tipo_cc AND (cc.id_gestion IN ( SELECT tgestion.id_gestion
           FROM param.tgestion
          WHERE date_trunc('year'::text, tgestion.fecha_ini::timestamp with time zone) = date_trunc('year'::text, py.fecha_fin::timestamp with time zone)));

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_debe_det (
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    incremento)
AS
 WITH tprorrateo AS (
         SELECT pa.denominacion,
            pa.id_clasificacion,
            pa.id_proyecto,
            pa.id_proyecto_activo,
            pad.id_proyecto_activo_detalle,
            pad.id_tipo_cc,
            tcc.codigo,
            pad.monto,
            cip.importe_bs_aitb,
            sum(pad.monto) OVER (PARTITION BY pad.id_tipo_cc) AS total
           FROM pro.vproyecto_cierre_aitb_resumen cip
             JOIN pro.tproyecto_activo pa ON pa.id_proyecto = cip.id_proyecto
             JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo AND pad.id_tipo_cc = cip.id_tipo_cc
             JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pad.id_tipo_cc
        )
 SELECT pr.id_proyecto,
    pr.id_proyecto_activo,
    pr.denominacion,
    pr.id_clasificacion,
    param.f_get_moneda_base() AS id_moneda,
    round(sum(pr.monto / pr.total * pr.importe_bs_aitb), 2) AS incremento
   FROM tprorrateo pr
  GROUP BY pr.id_proyecto, pr.id_proyecto_activo, pr.denominacion, pr.id_clasificacion;

/***********************************F-DEP-EGS-PRO-1-03/11/2018****************************************/

/***********************************I-DEP-EGS-PRO-3-03/11/2018****************************************/

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_gestion(
    id_proyecto,
    id_tipo_cc,
    cc,
    importe_bs)
AS
WITH tproyecto_tcc AS(
  SELECT DISTINCT py.id_proyecto,
         pad.id_tipo_cc,
         py.fecha_fin
  FROM pro.tproyecto py
       JOIN pro.tproyecto_activo pa ON pa.id_proyecto = py.id_proyecto
       JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
         pa.id_proyecto_activo)
    SELECT pcc.id_proyecto,
           tcc.id_tipo_cc,
           tcc.codigo AS cc,
           sum(tra.importe_debe_mb) - sum(tra.importe_haber_mb) AS importe_bs
    FROM conta.tint_transaccion tra
         JOIN param.tcentro_costo cc ON cc.id_centro_costo = tra.id_centro_costo
         JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc
         JOIN tproyecto_tcc pcc ON pcc.id_tipo_cc = cc.id_tipo_cc
         JOIN conta.tint_comprobante cb ON cb.id_int_comprobante =
           tra.id_int_comprobante AND cb.estado_reg::text = 'validado'::text AND
           cb.cbte_aitb::text = 'si'::text AND cb.fecha <= pcc.fecha_fin
         JOIN conta.tcuenta cta ON cta.id_cuenta = tra.id_cuenta
         JOIN pre.tpartida par ON par.id_partida = tra.id_partida AND (
           par.codigo::text = ANY (ARRAY [ '28100'::character varying, '68201'::
           character varying ]::text [ ]))
    GROUP BY pcc.id_proyecto,
             tcc.id_tipo_cc,
             tcc.codigo;


/***********************************F-DEP-EGS-PRO-3-03/11/2018****************************************/