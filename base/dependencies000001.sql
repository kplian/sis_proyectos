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

/***********************************I-DEP-EGS-PRO-4-04/11/2018****************************************/
ALTER TABLE pro.tinvitacion
  ADD CONSTRAINT tinvitacion_fk__id_solicitud FOREIGN KEY (id_solicitud)
    REFERENCES adq.tsolicitud(id_solicitud)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-EGS-PRO-4-04/11/2018****************************************/

/***********************************I-DEP-RCM-PRO-0-05/12/2018****************************************/
ALTER TABLE pro.tcontrato_pago
  ADD PRIMARY KEY (id_contrato_pago);

ALTER TABLE pro.tcontrato_pago
  ADD CONSTRAINT fk_tcontrato_pago__id_proyecto_contrato FOREIGN KEY (id_proyecto_contrato)
    REFERENCES pro.tproyecto_contrato(id_proyecto_contrato)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tcontrato_pago
  ADD CONSTRAINT fk_tcontrato_pago__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tcuenta_excluir
  ADD CONSTRAINT fk_tcuenta_excluir__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase
  ADD CONSTRAINT fk_tfase__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase
  ADD CONSTRAINT fk_tfase__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf(id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase_avance_obs
  ADD CONSTRAINT fk_tfase_avance_obs__id_fase FOREIGN KEY (id_fase)
    REFERENCES pro.tfase(id_fase)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tfase_avance_obs
  ADD CONSTRAINT fk_tfase_avance_obs__id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion
  ADD CONSTRAINT fk_tinvitacion__id_categoria_compra FOREIGN KEY (id_categoria_compra)
    REFERENCES adq.tcategoria_compra(id_categoria_compra)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion
  ADD CONSTRAINT fk_tinvitacion__id_depto FOREIGN KEY (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion
  ADD CONSTRAINT fk_tinvitacion__id_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES orga.tfuncionario(id_funcionario)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

  ALTER TABLE pro.tinvitacion
  ADD CONSTRAINT fk_tinvitacion__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion_det
  ADD CONSTRAINT fk_tinvitacion_det__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion_det
  ADD CONSTRAINT fk_tinvitacion_det__id_concepto_ingas FOREIGN KEY (id_concepto_ingas)
    REFERENCES param.tconcepto_ingas(id_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tinvitacion_det
  ADD CONSTRAINT fk_tinvitacion_det__id_fase FOREIGN KEY (id_fase)
    REFERENCES pro.tfase(id_fase)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE pro.tinvitacion_det
  ADD CONSTRAINT fk_tinvitacion_det__id_unidad_medida FOREIGN KEY (id_unidad_medida)
    REFERENCES param.tunidad_medida(id_unidad_medida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_contrato
  ADD CONSTRAINT fk_tproyecto_contrato__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_contrato
  ADD CONSTRAINT fk_tproyecto_contrato__id_proveedor FOREIGN KEY (id_proveedor)
    REFERENCES param.tproveedor(id_proveedor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo_det_mon
  ADD CONSTRAINT fk_tproyecto_activo_det_mon__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo_det_mon
  ADD CONSTRAINT fk_tproyecto_activo_det_mon__id_proyecto_activo_detalle FOREIGN KEY (id_proyecto_activo_detalle)
    REFERENCES pro.tproyecto_activo_detalle(id_proyecto_activo_detalle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_clasificacion foreign key (id_clasificacion)
    REFERENCES kaf.tclasificacion(id_clasificacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_depto foreign key (id_depto)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_lugar foreign key (id_lugar)
    REFERENCES param.tlugar(id_lugar)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_centro_costo foreign key (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_ubicacion foreign key (id_ubicacion)
    REFERENCES kaf.tubicacion(id_ubicacion)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_grupo foreign key (id_grupo)
    REFERENCES kaf.tgrupo(id_grupo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_grupo_clasif foreign key (id_grupo_clasif)
    REFERENCES kaf.tgrupo(id_grupo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_unidad_medida foreign key (id_unidad_medida)
    REFERENCES param.tunidad_medida(id_unidad_medida)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto_activo
  ADD CONSTRAINT fk_tproyecto_activo__id_activo_fijo foreign key (id_activo_fijo)
    REFERENCES kaf.tactivo_fijo(id_activo_fijo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_estado_wf FOREIGN KEY (id_estado_wf)
    REFERENCES wf.testado_wf (id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_fase_plantilla FOREIGN KEY (id_fase_plantilla)
    REFERENCES pro.tfase_plantilla (id_fase_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_proceso_wf_cierre FOREIGN KEY (id_proceso_wf_cierre)
    REFERENCES wf.tproceso_wf (id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_estado_wf_cierre FOREIGN KEY (id_estado_wf_cierre)
    REFERENCES wf.testado_wf (id_estado_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_proceso_wf FOREIGN KEY (id_proceso_wf)
    REFERENCES wf.tproceso_wf (id_proceso_wf)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-RCM-PRO-0-05/12/2018****************************************/

/***********************************I-DEP-RCM-PRO-1-19/12/2018****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_haber_det(
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
         (
           SELECT tpartida.id_partida
           FROM pre.tpartida
           WHERE tpartida.codigo::text = '20300'::text AND
                 (tpartida.id_gestion IN (
                                           SELECT tgestion.id_gestion
                                           FROM param.tgestion
                                           WHERE date_trunc('year'::text,
                                             tgestion.fecha_ini::timestamp with
                                             time zone) = date_trunc('year'::
                                             text, py.fecha_fin::timestamp with
                                             time zone)
                 ))
         ) AS id_partida
  FROM pro.tproyecto py
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
       JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~(tcc.codigo::text || '%'
         ::text)
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha <= py.fecha_fin
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto,
           cc.id_centro_costo,
           cue.id_cuenta,
           cue.nro_cuenta,
           cue.nombre_cuenta,
           tcc.codigo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_haber_det__v2(
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
         (
           SELECT tpartida.id_partida
           FROM pre.tpartida
           WHERE tpartida.codigo::text = '20300'::text AND
                 (tpartida.id_gestion IN (
                                           SELECT tgestion.id_gestion
                                           FROM param.tgestion
                                           WHERE date_trunc('year'::text,
                                             tgestion.fecha_ini::timestamp with
                                             time zone) = date_trunc('year'::
                                             text, py.fecha_fin::timestamp with
                                             time zone)
                 ))
         ) AS id_partida
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = pc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha <= py.fecha_fin
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto,
           cc.id_centro_costo,
           cue.id_cuenta,
           cue.nro_cuenta,
           cue.nombre_cuenta,
           tcc.codigo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_1_haber_det_bk(
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
         (
           SELECT tpartida.id_partida
           FROM pre.tpartida
           WHERE tpartida.codigo::text = '20300'::text AND
                 (tpartida.id_gestion IN (
                                           SELECT tgestion.id_gestion
                                           FROM param.tgestion
                                           WHERE date_trunc('year'::text,
                                             tgestion.fecha_ini::timestamp with
                                             time zone) = date_trunc('year'::
                                             text, py.fecha_fin::timestamp with
                                             time zone)
                 ))
         ) AS id_partida
  FROM pro.tproyecto_activo pa
       JOIN pro.tproyecto py ON py.id_proyecto = pa.id_proyecto
       JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
         pa.id_proyecto_activo
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pad.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = pad.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta AND NOT (
         cue.nro_cuenta IN (
                           SELECT tcuenta_excluir.nro_cuenta
                           FROM pro.tcuenta_excluir
       ))
  GROUP BY cue.id_cuenta,
           cue.nro_cuenta,
           cue.nombre_cuenta,
           tcc.codigo,
           pa.id_proyecto,
           cc.id_centro_costo,
           py.fecha_fin
  HAVING (sum(tr.importe_debe) - sum(tr.importe_haber)) > 0::numeric;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det(
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    importe,
    total,
    importe_ufv)
AS
WITH tactivo_prorrateo AS(
    WITH tproy_activo AS (
  SELECT pro.id_proyecto,
         pa_1.id_proyecto_activo,
         pa_1.denominacion,
         pa_1.id_clasificacion,
         pro.id_moneda,
         sum(pad.monto) AS importe
  FROM pro.tproyecto_activo_detalle pad
       JOIN pro.tproyecto_activo pa_1 ON pa_1.id_proyecto_activo =
         pad.id_proyecto_activo
       JOIN pro.tproyecto pro ON pro.id_proyecto = pa_1.id_proyecto
  GROUP BY pro.id_proyecto,
           pa_1.id_proyecto_activo,
           pa_1.denominacion,
           pa_1.id_clasificacion,
           pro.id_moneda)
    SELECT pa.id_proyecto,
           pa.id_proyecto_activo,
           pa.denominacion,
           pa.id_clasificacion,
           pa.id_moneda,
           pa.importe,
           sum(pa.importe) OVER() AS total
    FROM tproy_activo pa), tmayor_ufv AS(
      SELECT py.id_proyecto,
             tcc.id_tipo_cc,
             cc.id_centro_costo,
             cue.id_cuenta,
             cue.nro_cuenta,
             cue.nombre_cuenta,
             tcc.codigo,
             sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe,
             (
               SELECT tpartida.id_partida
               FROM pre.tpartida
               WHERE tpartida.codigo::text = '20300'::text AND
                     (tpartida.id_gestion IN (
                                               SELECT tgestion.id_gestion
                                               FROM param.tgestion
                                               WHERE date_trunc('year'::text,
                                                 tgestion.fecha_ini::timestamp
                                                 with time zone) = date_trunc(
                                                 'year'::text, py.fecha_fin::
                                                 timestamp with time zone)
                     ))
             ) AS id_partida
      FROM pro.tproyecto py
           JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
           JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~(tcc.codigo::text ||
             '%'::text)
           JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
           JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
             cc.id_centro_costo
           JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
             tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
             AND cbte.fecha <= py.fecha_fin
           JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
      WHERE NOT (cue.nro_cuenta IN (
                                   SELECT tcuenta_excluir.nro_cuenta
                                   FROM pro.tcuenta_excluir
            ))
      GROUP BY py.id_proyecto,
               tcc.id_tipo_cc,
               cc.id_centro_costo,
               cue.id_cuenta,
               cue.nro_cuenta,
               cue.nombre_cuenta,
               tcc.codigo)
            SELECT ap.id_proyecto,
                   ap.id_proyecto_activo,
                   ap.denominacion,
                   ap.id_clasificacion,
                   ap.id_moneda,
                   ap.importe,
                   ap.total,
                   COALESCE((
                              SELECT sum(tmayor_ufv.importe) AS sum
                              FROM tmayor_ufv
                              WHERE tmayor_ufv.id_proyecto = ap.id_proyecto
                   ), 0::numeric) *(ap.importe / ap.total) AS importe_ufv
            FROM tactivo_prorrateo ap;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det_2(
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    sum,
    importe_ufv,
    id_centro_costo)
AS
WITH tdatos AS(
  SELECT DISTINCT pa_1.id_proyecto,
         pa_1.id_clasificacion,
         sum(pad_1.monto) OVER(PARTITION BY pa_1.id_clasificacion,
           pa_1.id_proyecto) AS importe,
         sum(pad_1.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
  FROM pro.tproyecto_activo pa_1
       JOIN pro.tproyecto_activo_detalle pad_1 ON pad_1.id_proyecto_activo =
         pa_1.id_proyecto_activo
       JOIN pro.tproyecto pr_1 ON pr_1.id_proyecto = pa_1.id_proyecto),
         tmayor_ufv AS(
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
         JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~(tcc.codigo::text ||
           '%'::text)
         JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
         JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
           cc_1.id_centro_costo
         JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
           tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
           AND cbte.fecha <= py.fecha_fin
         JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta IN (
                                 SELECT tcuenta_excluir.nro_cuenta
                                 FROM pro.tcuenta_excluir
          ))
    GROUP BY py.id_proyecto,
             tcc.id_tipo_cc,
             cc_1.id_centro_costo,
             cue.id_cuenta,
             cue.nro_cuenta,
             cue.nombre_cuenta,
             tcc.codigo)
        SELECT pa.id_proyecto,
               pa.id_clasificacion,
               pad.id_tipo_cc,
               sum(pad.monto) AS sum,
               ((
                  SELECT tmayor_ufv.importe
                  FROM tmayor_ufv
                  WHERE tmayor_ufv.id_proyecto = pa.id_proyecto AND
                        tmayor_ufv.id_tipo_cc = pad.id_tipo_cc
               )) - sum(param.f_convertir_moneda(2, 3, pad.monto, pr.fecha_fin,
                 'O'::character varying, 2)) AS importe_ufv,
               cc.id_centro_costo
        FROM pro.tproyecto_activo pa
             JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
               pa.id_proyecto_activo
             JOIN pro.tproyecto pr ON pr.id_proyecto = pa.id_proyecto
             JOIN tdatos d ON d.id_proyecto = pa.id_proyecto AND
               d.id_clasificacion = pa.id_clasificacion
             JOIN param.tcentro_costo cc ON cc.id_tipo_cc = pad.id_tipo_cc AND (
               cc.id_gestion IN (
                                  SELECT tgestion.id_gestion
                                  FROM param.tgestion
                                  WHERE date_trunc('year'::text,
                                    tgestion.fecha_ini::timestamp with time zone
                                    ) = date_trunc('year'::text, pr.fecha_fin::
                                    timestamp with time zone)
             ))
        GROUP BY pa.id_proyecto,
                 pa.id_clasificacion,
                 pad.id_tipo_cc,
                 cc.id_centro_costo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det_3(
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
WITH t_mayor_ufv AS(
  SELECT py.id_proyecto,
         sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe_ufv_mayor
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc1 ON tcc1.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
         cc_1.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha <= py.fecha_fin
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto), t_prorrateo AS(
      SELECT pa_1.id_proyecto,
             pa_1.id_proyecto_activo,
             pad_1.id_proyecto_activo_detalle,
             pr_1.fecha_fin,
             tcc.id_tipo_cc,
             pad_1.monto,
             pa_1.id_centro_costo,
             pa_1.id_clasificacion,
             sum(pad_1.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad_1 ON pad_1.id_proyecto_activo =
             pa_1.id_proyecto_activo
           JOIN pro.tproyecto pr_1 ON pr_1.id_proyecto = pa_1.id_proyecto
           LEFT JOIN param.tcentro_costo cc ON cc.id_centro_costo =
             pa_1.id_centro_costo
           LEFT JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc)
        SELECT p.id_proyecto,
               p.id_clasificacion,
               p.id_tipo_cc,
               p.id_centro_costo,
               sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::
                 character varying, 2)) AS importe_ufv_original,
               round(sum(m.importe_ufv_mayor *(p.monto / p.total)), 2) AS
                 importe_mayor_prorateado,
               round(sum(m.importe_ufv_mayor *(p.monto / p.total)) - sum(
                 param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::
                 character varying, 2)), 2) AS importe_ufv
        FROM t_prorrateo p
             JOIN t_mayor_ufv m ON m.id_proyecto = p.id_proyecto
        GROUP BY p.id_proyecto,
                 p.id_clasificacion,
                 p.id_tipo_cc,
                 p.id_centro_costo;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_prorrateo(
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    codigo_af_rel,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
WITH t_mayor_ufv AS(
  SELECT py.id_proyecto,
         sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe_ufv_mayor
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc1 ON tcc1.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
         cc_1.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha <= py.fecha_fin
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto), t_prorrateo AS(
      SELECT pa_1.id_proyecto,
             pa_1.id_proyecto_activo,
             pad_1.id_proyecto_activo_detalle,
             pr_1.fecha_fin,
             tcc.id_tipo_cc,
             pad_1.monto,
             pa_1.id_centro_costo,
             pa_1.id_clasificacion,
             pa_1.codigo_af_rel,
             sum(pad_1.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad_1 ON pad_1.id_proyecto_activo =
             pa_1.id_proyecto_activo
           JOIN pro.tproyecto pr_1 ON pr_1.id_proyecto = pa_1.id_proyecto
           LEFT JOIN param.tcentro_costo cc ON cc.id_centro_costo =
             pa_1.id_centro_costo
           LEFT JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc)
        SELECT p.id_proyecto,
               p.id_clasificacion,
               p.id_tipo_cc,
               p.id_centro_costo,
               p.codigo_af_rel,
               sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::
                 character varying, 2)) AS importe_ufv_original,
               round(sum(m.importe_ufv_mayor *(p.monto / p.total)), 2) AS
                 importe_mayor_prorateado,
               round(sum(m.importe_ufv_mayor *(p.monto / p.total)) - sum(
                 param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::
                 character varying, 2)), 2) AS importe_ufv
        FROM t_prorrateo p
             JOIN t_mayor_ufv m ON m.id_proyecto = p.id_proyecto
        GROUP BY p.id_proyecto,
                 p.id_clasificacion,
                 p.id_tipo_cc,
                 p.id_centro_costo,
                 p.codigo_af_rel;

CREATE OR REPLACE VIEW pro.v_cierre_proy_4_haber_det(
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
         (
           SELECT tpartida.id_partida
           FROM pre.tpartida
           WHERE tpartida.codigo::text = '20300'::text AND
                 (tpartida.id_gestion IN (
                                           SELECT tgestion.id_gestion
                                           FROM param.tgestion
                                           WHERE date_trunc('year'::text,
                                             tgestion.fecha_ini::timestamp with
                                             time zone) = date_trunc('year'::
                                             text, py.fecha_fin::timestamp with
                                             time zone)
                 ))
         ) AS id_partida
  FROM pro.tproyecto py
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = py.id_tipo_cc
       JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~(tcc.codigo::text || '%'
         ::text)
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha <= py.fecha_fin
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto,
           cc.id_centro_costo,
           cue.id_cuenta,
           cue.nro_cuenta,
           cue.nombre_cuenta,
           tcc.codigo;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_historico(
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
       JOIN conta.tint_comprobante cbte
       ON  cbte.id_int_comprobante = tr.id_int_comprobante
       AND cbte.estado_reg::text = 'validado'::text
       AND cbte.fecha <= py.fecha_fin
       AND (cbte.id_int_comprobante <> coalesce(py.id_int_comprobante_1,0) and cbte.id_int_comprobante <> coalesce(py.id_int_comprobante_2,0) and cbte.id_int_comprobante <> coalesce(py.id_int_comprobante_3,0))

       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto,
           tcc.id_tipo_cc,
           tcc.codigo;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_historico_cuenta(
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
       JOIN param.ttipo_cc tcc1 ON tcc1.codigo::text ~~(tcc.codigo::text || '%'
         ::text)
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc1.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha <= py.fecha_fin
         AND (cbte.id_int_comprobante <> coalesce(py.id_int_comprobante_1,0) and cbte.id_int_comprobante <> coalesce(py.id_int_comprobante_2,0) and cbte.id_int_comprobante <> coalesce(py.id_int_comprobante_3,0))
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto,
           tr.id_cuenta,
           tr.id_partida,
           tr.id_centro_costo,
           tcc1.id_tipo_cc,
           tcc1.codigo;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_gestion(
    id_proyecto,
    id_tipo_cc,
    cc,
    importe_bs)
AS
WITH tproyecto_tcc AS(
  SELECT DISTINCT py.id_proyecto,
         pad.id_tipo_cc,
         py.fecha_fin,
         py.id_int_comprobante_1,
         py.id_int_comprobante_2,
         py.id_int_comprobante_3
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
         JOIN conta.tcuenta cta ON cta.id_cuenta = tra.id_cuenta AND
           cb.id_int_comprobante <> COALESCE(pcc.id_int_comprobante_1, 0) AND
           cb.id_int_comprobante <> COALESCE(pcc.id_int_comprobante_2, 0) AND
           cb.id_int_comprobante <> COALESCE(pcc.id_int_comprobante_3, 0)
         JOIN pre.tpartida par ON par.id_partida = tra.id_partida AND (
           par.codigo::text = ANY (ARRAY [ '28100'::character varying::text,
           '68201'::character varying::text ]))
    WHERE NOT (cta.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
    GROUP BY pcc.id_proyecto,
             tcc.id_tipo_cc,
             tcc.codigo;


/***********************************F-DEP-RCM-PRO-1-19/12/2018****************************************/
/***********************************I-DEP-EGS-PRO-5-21/12/2018****************************************/
CREATE TRIGGER tr_tinvitacion_delete_presolicitud
  AFTER UPDATE OF estado_reg, id_presolicitud, id_grupo
  ON adq.tpresolicitud FOR EACH ROW
  EXECUTE PROCEDURE pro.tr_tinvitacion_delete_presolicitud();

CREATE TRIGGER tr_tinvitacion_delete_solicitud
  AFTER UPDATE OF id_estado_wf, lugar_entrega, justificacion, dias_plazo_entrega
  ON adq.tsolicitud FOR EACH ROW
  EXECUTE PROCEDURE pro.tr_tinvitacion_delete_solicitud();

/***********************************F-DEP-EGS-PRO-5-21/12/2018****************************************/

/***********************************I-DEP-EGS-PRO-6-08/02/2019****************************************/

CREATE TRIGGER tr_ime_predet
  BEFORE INSERT OR UPDATE OF id_concepto_ingas, id_centro_costo, cantidad, precio OR DELETE
  ON adq.tpresolicitud_det FOR EACH ROW
  EXECUTE PROCEDURE pro.f_tr_ime_predet();

CREATE TRIGGER tr_ime_soldet
  AFTER INSERT OR UPDATE OF estado_reg, id_centro_costo, id_concepto_ingas, precio_unitario, cantidad
  ON adq.tsolicitud_det FOR EACH ROW
  EXECUTE PROCEDURE pro.f_tr_ime_soldet();

CREATE TRIGGER tr_update_invdet_presoldet
  AFTER UPDATE OF id_solicitud_det
  ON adq.tpresolicitud_det FOR EACH ROW
  EXECUTE PROCEDURE pro.f_tr_update_invdet_presoldet();

/***********************************F-DEP-EGS-PRO-6-08/02/2019****************************************/
/***********************************I-DEP-EGS-PRO-7-01/08/2019****************************************/
select pxp.f_insert_testructura_gui ('UCPLA', 'PRO_1');
/***********************************F-DEP-EGS-PRO-7-01/08/2019****************************************/

/***********************************I-DEP-EGS-PRO-8-01/08/2019****************************************/
select pxp.f_insert_testructura_gui ('CFGPRO', 'PRO_1');
select pxp.f_insert_testructura_gui ('CIGPRO', 'CFGPRO');
/***********************************F-DEP-EGS-PRO-8-01/08/2019****************************************/

/***********************************I-DEP-RCM-PRO-18-08/08/2019****************************************/
DROP VIEW pro.v_cbte_cierre_proy_1_haber_det__v2;

CREATE VIEW pro.v_cbte_cierre_proy_1_haber_det__v2(
    id_proyecto,
    id_centro_costo,
    id_cuenta,
    nro_cuenta,
    nombre_cuenta,
    codigo,
    importe,
    id_partida,
    id_moneda)
AS
  SELECT py.id_proyecto,
         cc.id_centro_costo,
         cue.id_cuenta,
         cue.nro_cuenta,
         cue.nombre_cuenta,
         tcc.codigo,
         sum(tr.importe_debe_mt) - sum(tr.importe_haber_mt) AS importe,
         (
           SELECT tpartida.id_partida
           FROM pre.tpartida
           WHERE tpartida.codigo::text = '20300'::text AND
                 (tpartida.id_gestion IN (
                                           SELECT tgestion.id_gestion
                                           FROM param.tgestion
                                           WHERE date_trunc('year'::text,
                                             tgestion.fecha_ini::timestamp with
                                             time zone) = date_trunc('year'::
                                             text, py.fecha_fin::timestamp with
                                             time zone)
                 ))
         ) AS id_partida,
         py.id_moneda
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = pc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto,
           cc.id_centro_costo,
           cue.id_cuenta,
           cue.nro_cuenta,
           cue.nombre_cuenta,
           tcc.codigo,
           py.id_moneda;

ALTER TABLE pro.v_cbte_cierre_proy_1_haber_det__v2
  OWNER TO dbararteaga;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_prorrateo(
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    codigo_af_rel,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
WITH t_mayor_ufv AS(
  SELECT py.id_proyecto,
         sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe_ufv_mayor
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc1 ON tcc1.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
         cc_1.id_centro_costo
       JOIN conta.tint_comprobante cbte
       ON cbte.id_int_comprobante = tr.id_int_comprobante
       AND cbte.estado_reg::text = 'validado'::text
       AND cbte.fecha BETWEEN py.fecha_ini AND py.fecha_fin
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto), t_prorrateo AS(
      SELECT pa_1.id_proyecto,
             pa_1.id_proyecto_activo,
             pad_1.id_proyecto_activo_detalle,
             pr_1.fecha_fin,
             tcc.id_tipo_cc,
             pad_1.monto,
             pa_1.id_centro_costo,
             pa_1.id_clasificacion,
             pa_1.codigo_af_rel,
             sum(pad_1.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad_1 ON pad_1.id_proyecto_activo =
             pa_1.id_proyecto_activo
           JOIN pro.tproyecto pr_1 ON pr_1.id_proyecto = pa_1.id_proyecto
           LEFT JOIN param.tcentro_costo cc ON cc.id_centro_costo =
             pa_1.id_centro_costo
           LEFT JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = cc.id_tipo_cc)
        SELECT p.id_proyecto,
               p.id_clasificacion,
               p.id_tipo_cc,
               p.id_centro_costo,
               p.codigo_af_rel,
               sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::
                 character varying, 2)) AS importe_ufv_original,
               round(sum(m.importe_ufv_mayor *(p.monto / p.total)), 2) AS
                 importe_mayor_prorateado,
               round(sum(m.importe_ufv_mayor *(p.monto / p.total)) - sum(
                 param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::
                 character varying, 2)), 2) AS importe_ufv
        FROM t_prorrateo p
             JOIN t_mayor_ufv m ON m.id_proyecto = p.id_proyecto
        GROUP BY p.id_proyecto,
                 p.id_clasificacion,
                 p.id_tipo_cc,
                 p.id_centro_costo,
                 p.codigo_af_rel;

--nuevo
CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_historico(
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
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
         AND cbte.fecha BETWEEN py.fecha_ini AND  py.fecha_fin
         AND cbte.id_int_comprobante <> COALESCE(
         py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(
         py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(
         py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto,
           tcc.id_tipo_cc,
           tcc.codigo;

CREATE OR REPLACE VIEW pro.vproyecto_cierre_aitb_gestion(
    id_proyecto,
    id_tipo_cc,
    cc,
    importe_bs)
AS
WITH tproyecto_tcc AS(
  SELECT DISTINCT py.id_proyecto,
         pad.id_tipo_cc,
         py.fecha_ini,
         py.fecha_fin,
         py.id_int_comprobante_1,
         py.id_int_comprobante_2,
         py.id_int_comprobante_3
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
         JOIN conta.tint_comprobante cb
         ON cb.id_int_comprobante = tra.id_int_comprobante
         AND cb.estado_reg::text = 'validado'::text
         AND cb.cbte_aitb::text = 'si'::text
         AND cb.fecha BETWEEN pcc.fecha_ini AND  pcc.fecha_fin
         JOIN conta.tcuenta cta ON cta.id_cuenta = tra.id_cuenta AND
           cb.id_int_comprobante <> COALESCE(pcc.id_int_comprobante_1, 0) AND
           cb.id_int_comprobante <> COALESCE(pcc.id_int_comprobante_2, 0) AND
           cb.id_int_comprobante <> COALESCE(pcc.id_int_comprobante_3, 0)
         JOIN pre.tpartida par ON par.id_partida = tra.id_partida AND (
           par.codigo::text = ANY (ARRAY [ '28100'::character varying::text,
           '68201'::character varying::text ]))
    WHERE NOT (cta.nro_cuenta::text IN (
                                         SELECT tcuenta_excluir.nro_cuenta
                                         FROM pro.tcuenta_excluir
          ))
    GROUP BY pcc.id_proyecto,
             tcc.id_tipo_cc,
             tcc.codigo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_debe_detV2(
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    incremento)
AS
WITH tprorrateo AS(
  WITH tval_activo AS (
    SELECT
    pa.id_proyecto_activo, SUM(pad.monto) OVER (PARTITION BY pa.id_proyecto_activo) as parcial, SUM(pad.monto) OVER (PARTITION BY pa.id_proyecto) as total
    FROM pro.tproyecto_activo pa
    INNER JOIN pro.tproyecto_activo_detalle pad
    ON pad.id_proyecto_activo = pa.id_proyecto_activo
  )
  SELECT
  pa.id_proyecto, pa.id_proyecto_activo, pa.denominacion, va.parcial / va.total as peso, pa.id_clasificacion
  FROM pro.tproyecto_activo pa
  INNER JOIN tval_activo va
  ON va.id_proyecto_activo = pa.id_proyecto_activo
), ttotal as (
  SELECT
  py.id_proyecto,
  SUM(tr.importe_debe_mb - tr.importe_haber_mb) as total
  FROM pro.tproyecto py
  JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
  JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
  JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
  JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
  JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante = tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
  AND cbte.fecha BETWEEN py.fecha_ini AND  py.fecha_fin
  AND cbte.id_int_comprobante <> COALESCE(
  py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(
  py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(
  py.id_int_comprobante_3, 0)
  JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
      SELECT tcuenta_excluir.nro_cuenta
      FROM pro.tcuenta_excluir
  ))
  AND tr.importe_debe_mt = 0 AND tr.importe_haber_mt = 0
  AND tr.importe_debe_ma = 0 AND tr.importe_haber_ma = 0
  AND cbte.cbte_aitb = 'si'
  GROUP BY py.id_proyecto
)
SELECT
ta.id_proyecto,
ta.id_proyecto_activo,
ta.denominacion,
ta.id_clasificacion,
param.f_get_moneda_base() AS id_moneda,
ta.peso * tt.total AS incremento
FROM tprorrateo ta
INNER JOIN ttotal tt
ON tt.id_proyecto = ta.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_haber_detV2(
    id_proyecto,
    codigo_tcc,
    id_cuenta,
    id_partida,
    id_centro_costo,
    importe_bs)
AS
SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         SUM(tr.importe_debe_mb - tr.importe_haber_mb) AS importe_bs
FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
         AND cbte.fecha BETWEEN py.fecha_ini AND  py.fecha_fin
         AND cbte.id_int_comprobante <> COALESCE(
         py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(
         py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(
         py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
WHERE NOT (cue.nro_cuenta::text IN (
    SELECT tcuenta_excluir.nro_cuenta
    FROM pro.tcuenta_excluir
))
AND tr.importe_debe_mt = 0 AND tr.importe_haber_mt = 0
AND tr.importe_debe_ma = 0 AND tr.importe_haber_ma = 0
AND cbte.cbte_aitb = 'si'
GROUP BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detV2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz
)
AS
WITH tsaldo AS (
    SELECT
    py.id_proyecto,
    tcc.codigo,
    tr.id_cuenta,
    tr.id_partida,
    tr.id_centro_costo,
    SUM(tr.importe_debe_mb - tr.importe_haber_mb) OVER (PARTITION BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo) as saldo_mb,
    SUM(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(), tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O', 2)) OVER (PARTITION BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo) as conversion_mt_mb,
    SUM(tr.importe_debe_mb - tr.importe_haber_mb) OVER (PARTITION BY py.id_proyecto) as saldo_mb_total,
    SUM(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(), tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O', 2)) OVER (PARTITION BY py.id_proyecto) as conversion_mt_mb_total
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
    JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
    JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
     tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
     AND cbte.fecha BETWEEN py.fecha_ini AND  py.fecha_fin
     AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_3, 0)
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
        SELECT tcuenta_excluir.nro_cuenta
        FROM pro.tcuenta_excluir
    ))
    AND NOT (tr.importe_debe_mt = 0 AND tr.importe_haber_mt = 0
    AND tr.importe_debe_ma = 0 AND tr.importe_haber_ma = 0
    AND cbte.cbte_aitb = 'si')
), tprorrateo AS(
    WITH tval_activo AS (
      SELECT pa.id_proyecto_activo,
      sum(pad.monto) OVER(PARTITION BY pa.id_proyecto_activo) AS parcial,
      sum(pad.monto) OVER(PARTITION BY pa.id_proyecto) AS total
      FROM pro.tproyecto_activo pa
      JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
      WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
    )
    SELECT pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT
pr.id_proyecto, pr.id_proyecto_activo, pr.id_clasificacion, pr.denominacion,
(sa.saldo_mb_total - sa.conversion_mt_mb_total) * pr.peso as importe_actualiz
FROM tsaldo sa
INNER JOIN tprorrateo pr
ON pr.id_proyecto = sa.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detV2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz
)
AS
WITH tsaldo AS (
    SELECT
    py.id_proyecto,
    tcc.codigo,
    tr.id_cuenta,
    tr.id_partida,
    tr.id_centro_costo,
    SUM(tr.importe_debe_mb - tr.importe_haber_mb) OVER (PARTITION BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo) as saldo_mb,
    SUM(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(), tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O', 2)) OVER (PARTITION BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo) as conversion_mt_mb,
    SUM(tr.importe_debe_mb - tr.importe_haber_mb) OVER (PARTITION BY py.id_proyecto) as saldo_mb_total,
    SUM(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(), tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O', 2)) OVER (PARTITION BY py.id_proyecto) as conversion_mt_mb_total
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
    JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
    JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
     tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
     AND cbte.fecha BETWEEN py.fecha_ini AND  py.fecha_fin
     AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_3, 0)
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
        SELECT tcuenta_excluir.nro_cuenta
        FROM pro.tcuenta_excluir
    ))
    AND NOT (tr.importe_debe_mt = 0 AND tr.importe_haber_mt = 0
    AND tr.importe_debe_ma = 0 AND tr.importe_haber_ma = 0
    AND cbte.cbte_aitb = 'si')
), tprorrateo AS(
    WITH tval_activo AS (
      SELECT pa.id_proyecto_activo,
      sum(pad.monto) OVER(PARTITION BY pa.id_proyecto_activo) AS parcial,
      sum(pad.monto) OVER(PARTITION BY pa.id_proyecto) AS total
      FROM pro.tproyecto_activo pa
      JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa.id_proyecto_activo
      WHERE COALESCE(pa.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
    )
    SELECT pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT
pr.id_proyecto, pr.id_proyecto_activo, pr.id_clasificacion, pr.denominacion,
(sa.saldo_mb_total - sa.conversion_mt_mb_total) * pr.peso as importe_actualiz
FROM tsaldo sa
INNER JOIN tprorrateo pr
ON pr.id_proyecto = sa.id_proyecto;
DROP VIEW pro.v_cbte_cierre_proy_3_haber_det;
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_haber_det(
    id_proyecto,
    codigo,
    id_centro_costo,
    saldo_mb
)
AS
SELECT
    py.id_proyecto,
    tcc.codigo,
    tr.id_centro_costo,
    SUM(tr.importe_debe_mb - tr.importe_haber_mb) -
    SUM(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(), tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O', 2)) AS saldo_mb
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
    JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
    JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
     tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
     AND cbte.fecha BETWEEN py.fecha_ini AND  py.fecha_fin
     AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(
     py.id_int_comprobante_3, 0)
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
        SELECT tcuenta_excluir.nro_cuenta
        FROM pro.tcuenta_excluir
    ))
    AND NOT (tr.importe_debe_mt = 0 AND tr.importe_haber_mt = 0
    AND tr.importe_debe_ma = 0 AND tr.importe_haber_ma = 0
    AND cbte.cbte_aitb = 'si')
    GROUP BY py.id_proyecto,
    tcc.codigo,
    tr.id_centro_costo;
/***********************************F-DEP-RCM-PRO-18-08/08/2019****************************************/

/***********************************I-DEP-RCM-PRO-18-19/08/2019****************************************/
 -- object recreation
DROP VIEW pro.v_cbte_cierre_proy_3_haber_det;

CREATE VIEW pro.v_cbte_cierre_proy_3_haber_det(
    id_proyecto,
    codigo,
    id_centro_costo,
    saldo_mb,
    id_cuenta)
AS
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) - sum(
           param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) AS saldo_mb,
           tr.id_cuenta
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text)
  GROUP BY py.id_proyecto,
           tcc.codigo,
           tr.id_centro_costo,
           tr.id_cuenta;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 sum((sa.saldo_mb - sa.conversion_mt_mb) * pr.peso) AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
          GROUP BY pr.id_proyecto,
                   pr.id_proyecto_activo,
                   pr.id_clasificacion,
                   pr.denominacion;
/***********************************F-DEP-RCM-PRO-18-19/08/2019****************************************/

/***********************************I-DEP-RCM-PRO-18-30/08/2019****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
  tcc.codigo,
  tr.id_cuenta,
  tr.id_partida,
  tr.id_centro_costo,
  sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS saldo_mb,
  sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
  tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
  character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
  tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
  sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
  py.id_proyecto) AS saldo_mb_total,
  sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
  tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
  character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
  conversion_mt_mb_total
  FROM pro.tproyecto py
  JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
  JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
  JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
  JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
  JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
  tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
  cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
  cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
  cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
  cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
  JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
     SELECT tcuenta_excluir.nro_cuenta
     FROM pro.tcuenta_excluir
  )) AND
  NOT (tr.importe_debe_mt = 0::numeric AND
  tr.importe_haber_mt = 0::numeric AND
  tr.importe_debe_ma = 0::numeric AND
  tr.importe_haber_ma = 0::numeric AND
  cbte.cbte_aitb::text = 'si'::text)
),
tprorrateo AS(
  WITH tval_activo AS (
    SELECT pa_1.id_proyecto_activo,
    sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
    parcial,
    sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
    FROM pro.tproyecto_activo pa_1
    JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
    pa_1.id_proyecto_activo
    WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
  )
  SELECT pa.id_proyecto,
  pa.id_proyecto_activo,
  pa.denominacion,
  va.parcial / va.total AS peso,
  pa.id_clasificacion
  FROM pro.tproyecto_activo pa
  JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion,
sum((sa.conversion_mt_mb - sa.saldo_mb) * pr.peso) AS
importe_actualiz
FROM tsaldo sa
JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
GROUP BY pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_haber_det_negativo(
    id_proyecto,
    codigo,
    id_centro_costo,
    saldo_mb,
    id_cuenta)
AS
SELECT py.id_proyecto,
tcc.codigo,
tr.id_centro_costo,
sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(), tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::character varying, 2)) - sum(tr.importe_debe_mb - tr.importe_haber_mb) AS saldo_mb,
tr.id_cuenta
FROM pro.tproyecto py
JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
WHERE NOT (cue.nro_cuenta::text IN (
SELECT tcuenta_excluir.nro_cuenta
FROM pro.tcuenta_excluir
)) AND
NOT (tr.importe_debe_mt = 0::numeric AND
tr.importe_haber_mt = 0::numeric AND
tr.importe_debe_ma = 0::numeric AND
tr.importe_haber_ma = 0::numeric AND
cbte.cbte_aitb::text = 'si'::text)
GROUP BY py.id_proyecto,
tcc.codigo,
tr.id_centro_costo,
tr.id_cuenta;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
SELECT pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion,
(sa.conversion_mt_mb_total - sa.saldo_mb_total) * pr.peso AS importe_actualiz
FROM tsaldo sa
JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto;
/***********************************F-DEP-RCM-PRO-18-30/08/2019****************************************/

/***********************************I-DEP-RCM-PRO-18-02/09/2019****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    incremento)
AS
WITH tprorrateo AS(
    WITH tval_activo AS (
  SELECT pa_1.id_proyecto_activo,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
  FROM pro.tproyecto_activo pa_1
       JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
         pa_1.id_proyecto_activo)
    SELECT pa.id_proyecto,
           pa.id_proyecto_activo,
           pa.denominacion,
           va.parcial / va.total AS peso,
           pa.id_clasificacion
    FROM pro.tproyecto_activo pa
         JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo),
           ttotal AS(
      SELECT py.id_proyecto,
             sum(tr.importe_debe_mb - tr.importe_haber_mb) AS total
      FROM pro.tproyecto py
           JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
           JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
           JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
           JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
             cc.id_centro_costo
           JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
             tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
             AND cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
           JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
           JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND par.sw_movimiento = 'flujo'
      WHERE NOT (cue.nro_cuenta::text IN (
                                           SELECT tcuenta_excluir.nro_cuenta
                                           FROM pro.tcuenta_excluir
            )) AND
            tr.importe_debe_mt = 0::numeric AND
            tr.importe_haber_mt = 0::numeric AND
            tr.importe_debe_ma = 0::numeric AND
            tr.importe_haber_ma = 0::numeric AND
            cbte.cbte_aitb::text = 'si'::text
      GROUP BY py.id_proyecto)
          SELECT ta.id_proyecto,
                 ta.id_proyecto_activo,
                 ta.denominacion,
                 ta.id_clasificacion,
                 param.f_get_moneda_base() AS id_moneda,
                 ta.peso * tt.total AS incremento
          FROM tprorrateo ta
               JOIN ttotal tt ON tt.id_proyecto = ta.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_haber_detv2(
    id_proyecto,
    codigo_tcc,
    id_cuenta,
    id_partida,
    id_centro_costo,
    importe_bs)
AS
  SELECT py.id_proyecto,
         tcc.codigo AS codigo_tcc,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) AS importe_bs
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
       JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND par.sw_movimiento = 'flujo'
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text
  GROUP BY py.id_proyecto,
           tcc.codigo,
           tr.id_cuenta,
           tr.id_partida,
           tr.id_centro_costo;
/***********************************F-DEP-RCM-PRO-18-02/09/2019****************************************/
/***********************************I-DEP-EGS-PRO-19-09/09/2019****************************************/

ALTER TABLE pro.tcomponente_macro
  ADD CONSTRAINT tcomponente_macro_fk_id_unidad_construtiva FOREIGN KEY (id_unidad_constructiva)
    REFERENCES pro.tunidad_constructiva(id_unidad_constructiva)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

/***********************************F-DEP-EGS-PRO-19-09/09/2019****************************************/

/***********************************I-DEP-EGS-PRO-20-18/09/2019****************************************/
select pxp.f_insert_testructura_gui ('CATAPRO', 'CFGPRO');
/***********************************F-DEP-EGS-PRO-20-18/09/2019****************************************/

/***********************************I-DEP-EGS-PRO-21-18/09/2019****************************************/
select pxp.f_insert_testructura_gui ('UCT', 'CFGPRO');
/***********************************F-DEP-EGS-PRO-21-18/09/2019****************************************/

/***********************************I-DEP-RCM-PRO-31-24/09/2019****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_haber_detv2(
    id_proyecto,
    codigo_tcc,
    id_cuenta,
    id_partida,
    id_centro_costo,
    importe_bs)
AS
  SELECT py.id_proyecto,
         tcc.codigo AS codigo_tcc,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) AS importe_bs
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
       JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND
         par.sw_movimiento::text = 'flujo'::text
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text
  GROUP BY py.id_proyecto,
           tcc.codigo,
           tr.id_cuenta,
           tr.id_partida,
           tr.id_centro_costo;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    incremento)
AS
WITH tprorrateo AS(
    WITH tval_activo AS (
  SELECT pa_1.id_proyecto_activo,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
  FROM pro.tproyecto_activo pa_1
       JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
         pa_1.id_proyecto_activo)
    SELECT pa.id_proyecto,
           pa.id_proyecto_activo,
           pa.denominacion,
           va.parcial / va.total AS peso,
           pa.id_clasificacion
    FROM pro.tproyecto_activo pa
         JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo),
           ttotal AS(
      SELECT py.id_proyecto,
             sum(tr.importe_debe_mb - tr.importe_haber_mb) AS total
      FROM pro.tproyecto py
           JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
           JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
           JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
           JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
             cc.id_centro_costo
           JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
             tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
             AND cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
           JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
           JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND
             par.sw_movimiento::text = 'flujo'::text
      WHERE NOT (cue.nro_cuenta::text IN (
                                           SELECT tcuenta_excluir.nro_cuenta
                                           FROM pro.tcuenta_excluir
            )) AND
            tr.importe_debe_mt = 0::numeric AND
            tr.importe_haber_mt = 0::numeric AND
            tr.importe_debe_ma = 0::numeric AND
            tr.importe_haber_ma = 0::numeric AND
            cbte.cbte_aitb::text = 'si'::text AND
          cbte.cbte_apertura::text = 'no'::text
      GROUP BY py.id_proyecto)
          SELECT ta.id_proyecto,
                 ta.id_proyecto_activo,
                 ta.denominacion,
                 ta.id_clasificacion,
                 param.f_get_moneda_base() AS id_moneda,
                 ta.peso * tt.total AS incremento
          FROM tprorrateo ta
               JOIN ttotal tt ON tt.id_proyecto = ta.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text  AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 sum((sa.saldo_mb - sa.conversion_mt_mb) * pr.peso) AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
          GROUP BY pr.id_proyecto,
                   pr.id_proyecto_activo,
                   pr.id_clasificacion,
                   pr.denominacion;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_haber_det(
    id_proyecto,
    codigo,
    id_centro_costo,
    saldo_mb,
    id_cuenta)
AS
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) - sum(
           param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) AS saldo_mb,
         tr.id_cuenta
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)
  GROUP BY py.id_proyecto,
           tcc.codigo,
           tr.id_centro_costo,
           tr.id_cuenta;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 (sa.saldo_mb_total - sa.conversion_mt_mb_total) * pr.peso AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 sum((sa.conversion_mt_mb - sa.saldo_mb) * pr.peso) AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
          GROUP BY pr.id_proyecto,
                   pr.id_proyecto_activo,
                   pr.id_clasificacion,
                   pr.denominacion;

                                  CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_haber_det_negativo(
    id_proyecto,
    codigo,
    id_centro_costo,
    saldo_mb,
    id_cuenta)
AS
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_centro_costo,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) - sum(tr.importe_debe_mb - tr.importe_haber_mb
           ) AS saldo_mb,
         tr.id_cuenta
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)
  GROUP BY py.id_proyecto,
           tcc.codigo,
           tr.id_centro_costo,
           tr.id_cuenta;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 (sa.conversion_mt_mb_total - sa.saldo_mb_total) * pr.peso AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    incremento)
AS
WITH tprorrateo AS(
    WITH tval_activo AS (
  SELECT DISTINCT pa_1.id_proyecto_activo,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
  FROM pro.tproyecto_activo pa_1
       JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
         pa_1.id_proyecto_activo)
    SELECT pa.id_proyecto,
           pa.id_proyecto_activo,
           pa.denominacion,
           va.parcial / va.total AS peso,
           pa.id_clasificacion
    FROM pro.tproyecto_activo pa
         JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo),
           ttotal AS(
      SELECT py.id_proyecto,
             sum(tr.importe_debe_mb - tr.importe_haber_mb) AS total
      FROM pro.tproyecto py
           JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
           JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
           JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
           JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
             cc.id_centro_costo
           JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
             tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
             AND cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
           JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
           JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND
             par.sw_movimiento::text = 'flujo'::text
      WHERE NOT (cue.nro_cuenta::text IN (
                                           SELECT tcuenta_excluir.nro_cuenta
                                           FROM pro.tcuenta_excluir
            )) AND
            tr.importe_debe_mt = 0::numeric AND
            tr.importe_haber_mt = 0::numeric AND
            tr.importe_debe_ma = 0::numeric AND
            tr.importe_haber_ma = 0::numeric AND
            cbte.cbte_aitb::text = 'si'::text AND
            cbte.cbte_apertura::text = 'no'::text
      GROUP BY py.id_proyecto)
          SELECT ta.id_proyecto,
                 ta.id_proyecto_activo,
                 ta.denominacion,
                 ta.id_clasificacion,
                 param.f_get_moneda_base() AS id_moneda,
                 ta.peso * tt.total AS incremento
          FROM tprorrateo ta
               JOIN ttotal tt ON tt.id_proyecto = ta.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT DISTINCT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 sum((sa.saldo_mb - sa.conversion_mt_mb) * pr.peso) AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
          GROUP BY pr.id_proyecto,
                   pr.id_proyecto_activo,
                   pr.id_clasificacion,
                   pr.denominacion;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT DISTINCT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 (sa.saldo_mb_total - sa.conversion_mt_mb_total) * pr.peso AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT DISTINCT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 sum((sa.conversion_mt_mb - sa.saldo_mb) * pr.peso) AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
          GROUP BY pr.id_proyecto,
                   pr.id_proyecto_activo,
                   pr.id_clasificacion,
                   pr.denominacion;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT DISTINCT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 (sa.conversion_mt_mb_total - sa.saldo_mb_total) * pr.peso AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto;

/***********************************F-DEP-RCM-PRO-31-24/09/2019****************************************/

/***********************************I-DEP-EGS-PRO-22-01/11/2019****************************************/
ALTER TABLE pro.tcomponente_macro
  DROP CONSTRAINT tcomponente_macro_fk_id_unidad_construtiva RESTRICT;
/***********************************F-DEP-EGS-PRO-22-01/11/2019****************************************/

/***********************************I-DEP-RCM-PRO-0-26/11/2019****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT DISTINCT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT DISTINCT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'
        ::text)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 CASE pr.id_proyecto
                   WHEN 70 THEN sum((sa.saldo_mb - sa.conversion_mt_mb) *
                     pr.peso) + 9.26
                   ELSE sum((sa.saldo_mb - sa.conversion_mt_mb) * pr.peso)
                 END AS importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
          GROUP BY pr.id_proyecto,
                   pr.id_proyecto_activo,
                   pr.id_clasificacion,
                   pr.denominacion;
/***********************************F-DEP-RCM-PRO-0-26/11/2019****************************************/

/***********************************I-DEP-RCM-PRO-50-10/12/2019****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS (
    SELECT DISTINCT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
    FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
    )) AND
    NOT (tr.importe_debe_mt = 0::numeric AND
    tr.importe_haber_mt = 0::numeric AND
    tr.importe_debe_ma = 0::numeric AND
    tr.importe_haber_ma = 0::numeric AND
    cbte.cbte_aitb::text = 'si'::text AND
    cbte.cbte_apertura::text = 'no'::text)
),
tprorrateo AS (
    WITH tval_activo AS (
        SELECT DISTINCT pa_1.id_proyecto_activo,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
        FROM pro.tproyecto_activo pa_1
        JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa_1.id_proyecto_activo
        WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
        AND pa_1.id_almacen IS NULL --#50
    )
    SELECT
    pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion,
sum((sa.saldo_mb - sa.conversion_mt_mb) * pr.peso) AS importe_actualiz
FROM tsaldo sa
JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
GROUP BY pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS (
    SELECT py.id_proyecto,
    tcc.codigo,
    tr.id_cuenta,
    tr.id_partida,
    tr.id_centro_costo,
    sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
    py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
    tr.id_centro_costo) AS saldo_mb,
    sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
    tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
    character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
    tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
    sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
    py.id_proyecto) AS saldo_mb_total,
    sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
    tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
    character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
    conversion_mt_mb_total
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
    JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
    JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
    tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
    cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
    )) AND
    NOT (tr.importe_debe_mt = 0::numeric AND
    tr.importe_haber_mt = 0::numeric AND
    tr.importe_debe_ma = 0::numeric AND
    tr.importe_haber_ma = 0::numeric AND
    cbte.cbte_aitb::text = 'si'::text AND
    cbte.cbte_apertura::text = 'no'::text)
), tprorrateo AS (
    WITH tval_activo AS (
        SELECT DISTINCT pa_1.id_proyecto_activo,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
        parcial,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
        FROM pro.tproyecto_activo pa_1
        JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
        pa_1.id_proyecto_activo
        WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
        AND pa_1.id_almacen IS NULL --#50
    )
    SELECT pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion,
(sa.saldo_mb_total - sa.conversion_mt_mb_total) * pr.peso AS importe_actualiz
FROM tsaldo sa
JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS (
    SELECT py.id_proyecto,
    tcc.codigo,
    tr.id_cuenta,
    tr.id_partida,
    tr.id_centro_costo,
    sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
    py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
    tr.id_centro_costo) AS saldo_mb,
    sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
    tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
    character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
    tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
    sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
    py.id_proyecto) AS saldo_mb_total,
    sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
    tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
    character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
    conversion_mt_mb_total
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
    JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
    JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
    tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
    cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
    )) AND
    NOT (tr.importe_debe_mt = 0::numeric AND
    tr.importe_haber_mt = 0::numeric AND
    tr.importe_debe_ma = 0::numeric AND
    tr.importe_haber_ma = 0::numeric AND
    cbte.cbte_aitb::text = 'si'::text AND
    cbte.cbte_apertura::text = 'no'::text)
), tprorrateo AS (
    WITH tval_activo AS (
        SELECT DISTINCT pa_1.id_proyecto_activo,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
        FROM pro.tproyecto_activo pa_1
        JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa_1.id_proyecto_activo
        WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
        AND pa_1.id_almacen IS NULL
    )
    SELECT pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion,
sum((sa.conversion_mt_mb - sa.saldo_mb) * pr.peso) AS importe_actualiz
FROM tsaldo sa
JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
GROUP BY pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion;



CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS (
    SELECT py.id_proyecto,
    tcc.codigo,
    tr.id_cuenta,
    tr.id_partida,
    tr.id_centro_costo,
    sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
    py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
    tr.id_centro_costo) AS saldo_mb,
    sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
    tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
    character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
    tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
    sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
    py.id_proyecto) AS saldo_mb_total,
    sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
    tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
    character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
    conversion_mt_mb_total
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
    JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
    JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
    tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
    cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
    cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
    )) AND
    NOT (tr.importe_debe_mt = 0::numeric AND
    tr.importe_haber_mt = 0::numeric AND
    tr.importe_debe_ma = 0::numeric AND
    tr.importe_haber_ma = 0::numeric AND
    cbte.cbte_aitb::text = 'si'::text AND
    cbte.cbte_apertura::text = 'no'::text)
), tprorrateo AS (
    WITH tval_activo AS (
        SELECT DISTINCT pa_1.id_proyecto_activo,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
        FROM pro.tproyecto_activo pa_1
        JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo = pa_1.id_proyecto_activo
        WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
        AND pa_1.id_almacen IS NULL
    )
    SELECT pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT pr.id_proyecto,
pr.id_proyecto_activo,
pr.id_clasificacion,
pr.denominacion,
(sa.conversion_mt_mb_total - sa.saldo_mb_total) * pr.peso AS importe_actualiz
FROM tsaldo sa
JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto;



CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_prorrateo(
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    codigo_af_rel,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv,
    id_almacen)
AS
WITH t_mayor_ufv AS (
    SELECT py.id_proyecto,
    sum(tr.importe_debe_ma) - sum(tr.importe_haber_ma) AS importe_ufv_mayor
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc1 ON tcc1.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc_1 ON cc_1.id_tipo_cc = tcc1.id_tipo_cc
    JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc_1.id_centro_costo
    JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
    tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
    cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    WHERE NOT (cue.nro_cuenta::text IN (
                               SELECT tcuenta_excluir.nro_cuenta
                               FROM pro.tcuenta_excluir
    ))
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
    pa_1.id_almacen,
    sum(pad_1.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
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
round(sum(m.importe_ufv_mayor *(p.monto / p.total)), 2) AS importe_mayor_prorateado,
round(sum(m.importe_ufv_mayor *(p.monto / p.total)) - sum(param.f_convertir_moneda(2, 3, p.monto, p.fecha_fin, 'O'::character varying, 2)), 2) AS importe_ufv,
p.id_almacen
FROM t_prorrateo p
JOIN t_mayor_ufv m ON m.id_proyecto = p.id_proyecto
GROUP BY p.id_proyecto,
p.id_clasificacion,
p.id_tipo_cc,
p.id_centro_costo,
p.codigo_af_rel,
p.id_almacen;



CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_debe_det_4(
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
SELECT
p4.id_proyecto,
p4.id_clasificacion,
p4.id_tipo_cc,
p4.id_centro_costo,
p4.importe_ufv_original,
p4.importe_mayor_prorateado,
p4.importe_ufv
FROM pro.v_cbte_cierre_proy_4_prorrateo p4
WHERE COALESCE(p4.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
AND p4.id_almacen IS NULL;



CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_4_gasto_debe_det(
    id_proyecto,
    id_clasificacion,
    id_tipo_cc,
    id_centro_costo,
    importe_ufv_original,
    importe_mayor_prorateado,
    importe_ufv)
AS
SELECT
p4.id_proyecto,
p4.id_clasificacion,
p4.id_tipo_cc,
p4.id_centro_costo,
p4.importe_ufv_original,
p4.importe_mayor_prorateado,
p4.importe_ufv
FROM pro.v_cbte_cierre_proy_4_prorrateo p4
WHERE COALESCE(p4.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
AND p4.id_almacen IS NULL;



/***********************************F-DEP-RCM-PRO-50-10/12/2019****************************************/

/***********************************I-DEP-RCM-PRO-52-06/01/2020****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv2_negativo(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tsaldo AS(
  SELECT DISTINCT py.id_proyecto,
         tcc.codigo,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida,
           tr.id_centro_costo) AS saldo_mb,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto, tcc.codigo,
           tr.id_cuenta, tr.id_partida, tr.id_centro_costo) AS conversion_mt_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) OVER(PARTITION BY
           py.id_proyecto) AS saldo_mb_total,
         sum(param.f_convertir_moneda(py.id_moneda, param.f_get_moneda_base(),
           tr.importe_debe_mt - tr.importe_haber_mt, py.fecha_fin, 'O'::
           character varying, 2)) OVER(PARTITION BY py.id_proyecto) AS
           conversion_mt_mb_total
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        NOT (tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text)), tprorrateo AS(
        WITH tval_activo AS (
      SELECT DISTINCT pa_1.id_proyecto_activo,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS
               parcial,
             sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
      FROM pro.tproyecto_activo pa_1
           JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
             pa_1.id_proyecto_activo
      WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'
        ::text AND
            pa_1.id_almacen IS NULL)
        SELECT pa.id_proyecto,
               pa.id_proyecto_activo,
               pa.denominacion,
               va.parcial / va.total AS peso,
               pa.id_clasificacion
        FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo =
               pa.id_proyecto_activo)
          SELECT pr.id_proyecto,
                 pr.id_proyecto_activo,
                 pr.id_clasificacion,
                 pr.denominacion,
                 sum((sa.conversion_mt_mb - sa.saldo_mb) * pr.peso) AS
                   importe_actualiz
          FROM tsaldo sa
               JOIN tprorrateo pr ON pr.id_proyecto = sa.id_proyecto
          GROUP BY pr.id_proyecto,
                   pr.id_proyecto_activo,
                   pr.id_clasificacion,
                   pr.denominacion;
/***********************************F-DEP-RCM-PRO-52-06/01/2020****************************************/

/***********************************I-DEP-RCM-PRO-60-27/07/2020****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_debe_detv2(
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    incremento)
AS
WITH tprorrateo AS(
    WITH tval_activo AS (
  SELECT DISTINCT pa_1.id_proyecto_activo,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
         sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
  FROM pro.tproyecto_activo pa_1
       JOIN pro.tproyecto_activo_detalle pad ON pad.id_proyecto_activo =
         pa_1.id_proyecto_activo)
    SELECT pa.id_proyecto,
           pa.id_proyecto_activo,
           pa.denominacion,
           va.parcial / va.total AS peso,
           pa.id_clasificacion
    FROM pro.tproyecto_activo pa
         JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo),
           ttotal AS(
      SELECT py.id_proyecto,
             sum(tr.importe_debe_mb - tr.importe_haber_mb) AS total
      FROM pro.tproyecto py
           JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
           JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
           JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
           JOIN conta.tint_transaccion tr ON tr.id_centro_costo =
             cc.id_centro_costo
           JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
             tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
             AND cbte.fecha >= DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_fin))
             AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
             cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
           JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
           JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND
             par.sw_movimiento::text = 'flujo'::text
      WHERE NOT (cue.nro_cuenta::text IN (
                                           SELECT tcuenta_excluir.nro_cuenta
                                           FROM pro.tcuenta_excluir
            )) AND
            tr.importe_debe_mt = 0::numeric AND
            tr.importe_haber_mt = 0::numeric AND
            tr.importe_debe_ma = 0::numeric AND
            tr.importe_haber_ma = 0::numeric AND
            cbte.cbte_aitb::text = 'si'::text AND
            cbte.cbte_apertura::text = 'no'::text
      GROUP BY py.id_proyecto)
          SELECT ta.id_proyecto,
                 ta.id_proyecto_activo,
                 ta.denominacion,
                 ta.id_clasificacion,
                 param.f_get_moneda_base() AS id_moneda,
                 ta.peso * tt.total AS incremento
          FROM tprorrateo ta
               JOIN ttotal tt ON tt.id_proyecto = ta.id_proyecto;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_haber_detv2(
    id_proyecto,
    codigo_tcc,
    id_cuenta,
    id_partida,
    id_centro_costo,
    importe_bs)
AS
  SELECT py.id_proyecto,
         tcc.codigo AS codigo_tcc,
         tr.id_cuenta,
         tr.id_partida,
         tr.id_centro_costo,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) AS importe_bs
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text
         AND cbte.fecha >= DATE_TRUNC('MONTH', COALESCE(py.fecha_rev_aitb, py.fecha_fin))
         AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
       JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND
         par.sw_movimiento::text = 'flujo'::text
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        )) AND
        tr.importe_debe_mt = 0::numeric AND
        tr.importe_haber_mt = 0::numeric AND
        tr.importe_debe_ma = 0::numeric AND
        tr.importe_haber_ma = 0::numeric AND
        cbte.cbte_aitb::text = 'si'::text AND
        cbte.cbte_apertura::text = 'no'::text
  GROUP BY py.id_proyecto,
           tcc.codigo,
           tr.id_cuenta,
           tr.id_partida,
           tr.id_centro_costo;


CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv3(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tmayor_total AS (
  SELECT DISTINCT
  py.id_proyecto,
  SUM(tr.importe_debe_mb) AS debe_mb,
  SUM(tr.importe_haber_mb) AS haber_mb,
  SUM(tr.importe_debe_mb - tr.importe_haber_mb) AS saldo_mb
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
  AND cbte.estado_reg::text = 'validado'::text
  AND cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin
  AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0)
  AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0)
  AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
  JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  JOIN pre.tpartida par ON par.id_partida = tr.id_partida
  WHERE NOT (cue.nro_cuenta::text IN (
         SELECT tcuenta_excluir.nro_cuenta
         FROM pro.tcuenta_excluir
      )
  )
  GROUP BY py.id_proyecto
), tcbte1_cbte2 AS (
    SELECT
    py.id_proyecto, SUM(tr.importe_debe_mb) as saldo_mb
    FROM pro.tproyecto py
    JOIN conta.tint_comprobante cb
    ON cb.id_int_comprobante IN (py.id_int_comprobante_1, py.id_int_comprobante_2)
    JOIN conta.tint_transaccion tr
    ON tr.id_int_comprobante = cb.id_int_comprobante
    GROUP BY py.id_proyecto
), tactivos_proy AS(
    WITH tval_activo AS (
        SELECT DISTINCT
        pa_1.id_proyecto_activo,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
        FROM pro.tproyecto_activo pa_1
        JOIN pro.tproyecto_activo_detalle pad
        ON pad.id_proyecto_activo = pa_1.id_proyecto_activo
        WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
        AND pa_1.id_almacen IS NULL
    )
    SELECT
    pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va
    ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT
pa.id_proyecto, pa.id_proyecto_activo, pa.id_clasificacion, pa.denominacion,
pa.peso * (ABS(my.saldo_mb - cb.saldo_mb)) as importe_actualiz
FROM tactivos_proy pa
JOIN tmayor_total my
ON my.id_proyecto = pa.id_proyecto
JOIN tcbte1_cbte2 cb
ON cb.id_proyecto = my.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_gasto_debe_detV3(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz)
AS
WITH tmayor_total AS (
  SELECT DISTINCT
  py.id_proyecto,
  SUM(tr.importe_debe_mb) AS debe_mb,
  SUM(tr.importe_haber_mb) AS haber_mb,
  SUM(tr.importe_debe_mb - tr.importe_haber_mb) AS saldo_mb
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
  AND cbte.estado_reg::text = 'validado'::text
  AND cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin
  AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0)
  AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0)
  AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
  JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
  JOIN pre.tpartida par ON par.id_partida = tr.id_partida
  WHERE NOT (cue.nro_cuenta::text IN (
         SELECT tcuenta_excluir.nro_cuenta
         FROM pro.tcuenta_excluir
      )
  )
  GROUP BY py.id_proyecto
), tcbte1_cbte2 AS (
    SELECT
    py.id_proyecto, SUM(tr.importe_debe_mb) as saldo_mb
    FROM pro.tproyecto py
    JOIN conta.tint_comprobante cb
    ON cb.id_int_comprobante IN (py.id_int_comprobante_1, py.id_int_comprobante_2)
    JOIN conta.tint_transaccion tr
    ON tr.id_int_comprobante = cb.id_int_comprobante
    GROUP BY py.id_proyecto
), tactivos_proy AS(
    WITH tval_activo AS (
        SELECT DISTINCT
        pa_1.id_proyecto_activo,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto_activo) AS parcial,
        sum(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
        FROM pro.tproyecto_activo pa_1
        JOIN pro.tproyecto_activo_detalle pad
        ON pad.id_proyecto_activo = pa_1.id_proyecto_activo
        WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text = 'GASTO'::text
        AND pa_1.id_almacen IS NULL
    )
    SELECT
    pa.id_proyecto,
    pa.id_proyecto_activo,
    pa.denominacion,
    va.parcial / va.total AS peso,
    pa.id_clasificacion
    FROM pro.tproyecto_activo pa
    JOIN tval_activo va
    ON va.id_proyecto_activo = pa.id_proyecto_activo
)
SELECT
pa.id_proyecto, pa.id_proyecto_activo, pa.id_clasificacion, pa.denominacion,
pa.peso * (my.saldo_mb - cb.saldo_mb) as importe_actualiz
FROM tactivos_proy pa
JOIN tmayor_total my
ON my.id_proyecto = pa.id_proyecto
JOIN tcbte1_cbte2 cb
ON cb.id_proyecto = my.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_haber_det_V2(
    id_proyecto,
    id_centro_costo,
    id_cuenta,
    importe)
AS
WITH tmayor AS (
    SELECT DISTINCT
    py.id_proyecto,
    tr.id_cuenta,
    tr.id_centro_costo,
    SUM(tr.importe_debe_mb) AS debe_mb,
    SUM(tr.importe_haber_mb) AS haber_mb,
    SUM(tr.importe_debe_mb - tr.importe_haber_mb) AS saldo_mb
    FROM pro.tproyecto py
    JOIN pro.tproyecto_columna_tcc pc
    ON pc.id_proyecto = py.id_proyecto
    JOIN param.ttipo_cc tcc
    ON tcc.id_tipo_cc = pc.id_tipo_cc
    JOIN param.tcentro_costo cc
    ON cc.id_tipo_cc = tcc.id_tipo_cc
    JOIN conta.tint_transaccion tr
    ON tr.id_centro_costo = cc.id_centro_costo
    JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
    JOIN conta.tint_comprobante cbte
    ON cbte.id_int_comprobante = tr.id_int_comprobante
    AND cbte.estado_reg::text = 'validado'::text
    AND cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin
    AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0)
    AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0)
    AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
    WHERE cue.nro_cuenta::text NOT IN (
       SELECT tcuenta_excluir.nro_cuenta
       FROM pro.tcuenta_excluir
    )
    GROUP BY py.id_proyecto, tr.id_cuenta, tr.id_centro_costo
    HAVING SUM(tr.importe_debe_mb - tr.importe_haber_mb) > 0
), tcbte1 AS (
    SELECT
    py.id_proyecto,
    tr.id_cuenta,
    tr.id_centro_costo,
    SUM(tr.importe_debe_mb) as debe_mb,
    SUM(tr.importe_haber_mb) as haber_mb
    FROM pro.tproyecto py
    JOIN conta.tint_comprobante cb
    ON cb.id_int_comprobante = py.id_int_comprobante_1
    JOIN conta.tint_transaccion tr
    ON tr.id_int_comprobante = cb.id_int_comprobante
    WHERE tr.importe_haber > 0
    GROUP BY py.id_proyecto, tr.id_cuenta, tr.id_centro_costo
), tcbte2 AS (
    SELECT
    py.id_proyecto,
    tr.id_cuenta,
    tr.id_centro_costo,
    SUM(tr.importe_debe_mb) as debe_mb,
    SUM(tr.importe_haber_mb) as haber_mb
    FROM pro.tproyecto py
    JOIN conta.tint_comprobante cb
    ON cb.id_int_comprobante = py.id_int_comprobante_2
    JOIN conta.tint_transaccion tr
    ON tr.id_int_comprobante = cb.id_int_comprobante
    WHERE tr.importe_haber > 0
    GROUP BY py.id_proyecto, tr.id_cuenta, tr.id_centro_costo
)
SELECT
may.id_proyecto, may.id_centro_costo, may.id_cuenta, may.saldo_mb - cb1.haber_mb - COALESCE(cb2.haber_mb, 0) as importe
FROM tmayor may
JOIN tcbte1 cb1
ON cb1.id_cuenta = may.id_cuenta
AND cb1.id_centro_costo = may.id_centro_costo
LEFT JOIN tcbte2 cb2
ON cb2.id_cuenta = may.id_cuenta
AND cb2.id_centro_costo = may.id_centro_costo;
/***********************************F-DEP-RCM-PRO-60-27/07/2020****************************************/
/***********************************I-DEP-EGS-PRO-1-28/09/2020****************************************/
select pxp.f_insert_testructura_gui ('ANAINGDIF', 'PRO_1');
/***********************************F-DEP-EGS-PRO-1-28/09/2020****************************************/
/***********************************I-DEP-EGS-PRO-1-15/10/2020****************************************/
ALTER TABLE pro.tproyecto_analisis_det
    ADD CONSTRAINT tproyecto_analisis_det_fk FOREIGN KEY (id_proyecto_analisis)
        REFERENCES pro.tproyecto_analisis(id_proyecto_analisis)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE;
ALTER TABLE pro.tproyecto_analisis
    ADD CONSTRAINT tproyecto_analisis_fk FOREIGN KEY (id_proyecto)
        REFERENCES pro.tproyecto(id_proyecto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE;
ALTER TABLE pro.tproyecto_hito
    ADD CONSTRAINT tproyecto_hito_fk FOREIGN KEY (id_proyecto)
        REFERENCES pro.tproyecto(id_proyecto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE;
ALTER TABLE pro.tproyecto_suspension
    ADD CONSTRAINT tproyecto_suspension_fk FOREIGN KEY (id_proyecto)
        REFERENCES pro.tproyecto(id_proyecto)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
        NOT DEFERRABLE;
/***********************************F-DEP-EGS-PRO-1-15/10/2020****************************************/
/***********************************I-DEP-EGS-PRO-2-29/10/2020****************************************/
select pxp.f_insert_testructura_gui ('CUEINC', 'CFGPRO');
/***********************************F-DEP-EGS-PRO-2-29/10/2020****************************************/


/***********************************I-DEP-MZM-PRO-2-29/10/2020****************************************/
ALTER TABLE pro.tproyecto_analisis
  ADD COLUMN id_depto_conta INTEGER;

ALTER TABLE pro.tproyecto_analisis
  ADD COLUMN id_int_comprobante_1 INTEGER;

ALTER TABLE pro.tproyecto_analisis
  ADD COLUMN id_int_comprobante_2 INTEGER;

ALTER TABLE pro.tproyecto_analisis
  ADD COLUMN id_int_comprobante_3 INTEGER;


ALTER TABLE pro.tproyecto_analisis
  ADD CONSTRAINT fk_tproyecto_analisis__id_depto_conta FOREIGN KEY (id_depto_conta)
    REFERENCES param.tdepto(id_depto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE pro.tproyecto_analisis
  ADD CONSTRAINT fk_tproyecto_analisis__id_int_cbte1 FOREIGN KEY (id_int_comprobante_1)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE pro.tproyecto_analisis
  ADD CONSTRAINT fk_tproyecto_analisis__id_int_cbte2 FOREIGN KEY (id_int_comprobante_2)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


ALTER TABLE pro.tproyecto_analisis
  ADD CONSTRAINT fk_tproyecto_analisis__id_int_cbte3 FOREIGN KEY (id_int_comprobante_3)
    REFERENCES conta.tint_comprobante(id_int_comprobante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;


CREATE OR REPLACE VIEW pro.vcbte_proy_diferido(
    id_proyecto_analisis,
    glosa,
    id_moneda,
    nro_tramite,
    fecha,
    id_gestion,
    acreedor,
    id_depto_conta,
    id_centro_costo)
AS
  SELECT proya.id_proyecto_analisis,
         proya.glosa,
         proy.id_moneda,
         proy.nro_tramite,
         proya.fecha,
         (
           SELECT g.id_gestion
           FROM param.tgestion g
           WHERE date_trunc('year' ::text, g.fecha_ini::timestamp with time zone
           ) = date_trunc('year' ::text, proya.fecha::timestamp with time zone)
         ) AS id_gestion,
         prov.desc_proveedor2 AS acreedor,
         proya.id_depto_conta,
         (
           SELECT cc.id_centro_costo
           FROM param.tcentro_costo cc
           WHERE cc.id_tipo_cc = proya.id_tipo_cc AND
                 cc.id_gestion =((
                                   SELECT g.id_gestion
                                   FROM param.tgestion g
                                   WHERE date_trunc('year' ::text,
                                    g.fecha_ini::timestamp with time zone) =
                                     date_trunc('year' ::text,
                                      proya.fecha::timestamp with time zone)
                 ))
         ) AS id_centro_costo
  FROM pro.tproyecto proy
       JOIN pro.tproyecto_analisis proya ON proy.id_proyecto = proya.id_proyecto
       JOIN param.vproveedor prov ON prov.id_proveedor = proya.id_proveedor AND
        proy.diferido::text = 'si' ::text;






CREATE OR REPLACE VIEW pro.vcbte_proy_diferido_det(
    importe_debe,
    importe_haber,
    importe_gasto,
    importe_recurso,
    id_cuenta,
    nro_cuenta,
    nombre_cuenta,
    id_proyecto_analisis,
    id_gestion,
    tipo_cuenta,
    id_centro_costo)
AS
  SELECT sum(intra.importe_debe_mb) AS importe_debe,
         sum(intra.importe_haber_mb) AS importe_haber,
         sum(intra.importe_gasto_mb) AS importe_gasto,
         sum(intra.importe_recurso_mb) AS importe_recurso,
         cue.id_cuenta,
         cue.nro_cuenta,
         cue.nombre_cuenta,
         p.id_proyecto_analisis,
         cue.id_gestion,
         cue.tipo_cuenta,
         intra.id_centro_costo
  FROM pro.tproyecto_analisis_det p
       LEFT JOIN conta.tint_transaccion intra ON intra.id_int_transaccion =
        p.id_int_transaccion
       LEFT JOIN conta.tcuenta cue ON cue.id_cuenta = intra.id_cuenta
  WHERE cue.tipo_cuenta::text = 'activo' ::text
  GROUP BY cue.id_cuenta,
           cue.nro_cuenta,
           cue.nombre_cuenta,
           p.id_proyecto_analisis,
           cue.id_gestion,
           cue.tipo_cuenta,
           intra.id_centro_costo;



CREATE OR REPLACE VIEW pro.vcbte_proy_diferido_ing_det(
    id_proyecto_analisis,
    saldo_ingreso,
    saldo_gasto,
    saldo_activo,
    porc_utilidad,
    id_cuenta_ingreso,
    id_auxiliar,
    saldo_pasivo)
AS
  SELECT pro.id_proyecto_analisis,
         (
           SELECT sum(t.importe_haber_mb) - sum(t.importe_debe_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'ingreso' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_ingreso,
         (
           SELECT sum(t.importe_debe_mb) - sum(t.importe_haber_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'gasto' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_gasto,
         (
           SELECT sum(t.importe_debe_mb) - sum(t.importe_haber_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'activo' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_activo,
         (1::numeric - pro.porc_diferido) ::numeric(3, 2) AS porc_utilidad,
         (
           SELECT CASE
                    WHEN cu.id_gestion =((
                                           SELECT g.id_gestion
                                           FROM param.tgestion g
                                           WHERE pro.fecha >= g.fecha_ini AND
                                                 pro.fecha <= g.fecha_fin
                  )) THEN cu.id_cuenta
                    ELSE conta.f_get_cuenta_ids(cu.id_cuenta, 'siguiente'
                     ::character varying)
                  END AS id_cuenta_ingreso
           FROM conta.tint_transaccion t
                JOIN conta.tint_comprobante c ON c.id_int_comprobante =
                 t.id_int_comprobante
                JOIN conta.tcuenta cu ON cu.id_cuenta = t.id_cuenta AND
                 cu.tipo_cuenta::text = 'ingreso' ::text
                JOIN param.tcentro_costo cc ON cc.id_centro_costo =
                 t.id_centro_costo
                JOIN param.ttipo_cc tc ON tc.id_tipo_cc = cc.id_tipo_cc
                JOIN pro.tproyecto proy ON proy.id_tipo_cc = tc.id_tipo_cc
           WHERE proy.id_proyecto = pro.id_proyecto AND
                 c.estado_reg::text = 'validado' ::text AND
                 c.fecha < pro.fecha
           ORDER BY c.fecha DESC
           LIMIT 1
         ) AS id_cuenta_ingreso,
         (
           SELECT a.id_auxiliar
           FROM conta.tauxiliar a
                JOIN param.vproveedor p ON p.codigo::text =
                 a.codigo_auxiliar::text
           WHERE p.id_proveedor = pro.id_proveedor
         ) AS id_auxiliar,
         (
           SELECT sum(t.importe_haber_mb) - sum(t.importe_debe_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'pasivo' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_pasivo
  FROM pro.tproyecto_analisis pro;



CREATE OR REPLACE VIEW pro.cbte3_ingdif(
    id_proyecto_analisis,
    id_auxiliar,
    id_cuenta_ingreso,
    monto)
AS
  SELECT vcbte_proy_diferido_ing_det.id_proyecto_analisis,
         vcbte_proy_diferido_ing_det.id_auxiliar,
         vcbte_proy_diferido_ing_det.id_cuenta_ingreso,
         CASE
           WHEN (COALESCE(vcbte_proy_diferido_ing_det.saldo_pasivo, 0::numeric)
            - COALESCE(vcbte_proy_diferido_ing_det.saldo_ingreso, 0::numeric)) >
            ((COALESCE(vcbte_proy_diferido_ing_det.saldo_gasto, 0::numeric) +
             COALESCE(vcbte_proy_diferido_ing_det.saldo_activo, 0::numeric)) /
              vcbte_proy_diferido_ing_det.porc_utilidad) THEN (COALESCE(
              vcbte_proy_diferido_ing_det.saldo_gasto, 0::numeric) + COALESCE(
              vcbte_proy_diferido_ing_det.saldo_activo, 0::numeric)) /
               vcbte_proy_diferido_ing_det.porc_utilidad
           ELSE COALESCE(vcbte_proy_diferido_ing_det.saldo_pasivo, 0::numeric) -
            COALESCE(vcbte_proy_diferido_ing_det.saldo_ingreso, 0::numeric)
         END AS monto
  FROM pro.vcbte_proy_diferido_ing_det;
/***********************************F-DEP-MZM-PRO-2-29/10/2020****************************************/


/***********************************I-DEP-MZM-PRO-2-30/10/2020****************************************/

CREATE OR REPLACE VIEW pro.vcbte_proy_diferido_ing_det(
    id_proyecto_analisis,
    saldo_ingreso,
    saldo_gasto,
    saldo_activo,
    porc_utilidad,
    id_cuenta_ingreso,
    id_auxiliar,
    saldo_pasivo)
AS
  SELECT pro.id_proyecto_analisis,
         (
           SELECT sum(t.importe_haber_mb) - sum(t.importe_debe_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'ingreso' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_ingreso,
         (
           SELECT sum(t.importe_debe_mb) - sum(t.importe_haber_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'gasto' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_gasto,
         (
           SELECT sum(t.importe_debe_mb) - sum(t.importe_haber_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'activo' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_activo,
         ((
            SELECT CASE
                     WHEN pro.porc_diferido > 1::numeric THEN 1::numeric -
                      pro.porc_diferido / 100::numeric
                     ELSE 1::numeric - pro.porc_diferido
                   END AS "case"
         )) ::numeric(3,2) AS porc_utilidad,
         (
           SELECT CASE
                    WHEN cu.id_gestion =((
                                           SELECT g.id_gestion
                                           FROM param.tgestion g
                                           WHERE pro.fecha >= g.fecha_ini AND
                                                 pro.fecha <= g.fecha_fin
                  )) THEN cu.id_cuenta
                    ELSE conta.f_get_cuenta_ids(cu.id_cuenta, 'siguiente'
                     ::character varying)
                  END AS id_cuenta_ingreso
           FROM conta.tint_transaccion t
                JOIN conta.tint_comprobante c ON c.id_int_comprobante =
                 t.id_int_comprobante
                JOIN conta.tcuenta cu ON cu.id_cuenta = t.id_cuenta AND
                 cu.tipo_cuenta::text = 'ingreso' ::text
                JOIN param.tcentro_costo cc ON cc.id_centro_costo =
                 t.id_centro_costo
                JOIN param.ttipo_cc tc ON tc.id_tipo_cc = cc.id_tipo_cc
                JOIN pro.tproyecto proy ON proy.id_tipo_cc = tc.id_tipo_cc
           WHERE proy.id_proyecto = pro.id_proyecto AND
                 c.estado_reg::text = 'validado' ::text AND
                 c.fecha < pro.fecha
           ORDER BY c.fecha DESC
           LIMIT 1
         ) AS id_cuenta_ingreso,
         (
           SELECT a.id_auxiliar
           FROM conta.tauxiliar a
                JOIN param.vproveedor p ON p.codigo::text =
                 a.codigo_auxiliar::text
           WHERE p.id_proveedor = pro.id_proveedor
         ) AS id_auxiliar,
         (
           SELECT sum(t.importe_haber_mb) - sum(t.importe_debe_mb)
           FROM pro.tproyecto_analisis_det pd
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 pd.id_int_transaccion
                JOIN conta.tcuenta c ON c.id_cuenta = t.id_cuenta
           WHERE c.tipo_cuenta::text = 'pasivo' ::text AND
                 pd.id_proyecto_analisis = pro.id_proyecto_analisis
         ) AS saldo_pasivo
  FROM pro.tproyecto_analisis pro;
/***********************************F-DEP-MZM-PRO-2-30/10/2020****************************************/

/***********************************I-DEP-RCM-PRO-SIS-2-18/09/2020****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_debe_detv2 (
    id_proyecto,
    id_proyecto_activo,
    denominacion,
    id_clasificacion,
    id_moneda,
    incremento)
AS
 WITH tprorrateo AS (
         WITH tval_activo AS (
SELECT DISTINCT pa_1.id_proyecto_activo,
                    sum(pad.monto) OVER (PARTITION BY pa_1.id_proyecto_activo)
                        AS parcial,
                    sum(pad.monto) OVER (PARTITION BY pa_1.id_proyecto) AS total
FROM pro.tproyecto_activo pa_1
                     JOIN pro.tproyecto_activo_detalle pad ON
                         pad.id_proyecto_activo = pa_1.id_proyecto_activo
                )
    SELECT pa.id_proyecto,
            pa.id_proyecto_activo,
            pa.denominacion,
            va.parcial / va.total AS peso,
            pa.id_clasificacion
    FROM pro.tproyecto_activo pa
             JOIN tval_activo va ON va.id_proyecto_activo = pa.id_proyecto_activo
    ), ttotal AS (
    SELECT py.id_proyecto,
            sum(tr.importe_debe_mb - tr.importe_haber_mb) AS total
    FROM pro.tproyecto py
             JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
             JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
             JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
             JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
             JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
                 tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha >= date_trunc('MONTH'::text, COALESCE(py.fecha_rev_aitb, py.fecha_fin)::timestamp with time zone) AND cbte.fecha <= py.fecha_fin AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
             JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
             JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND
                 par.sw_movimiento::text = 'flujo'::text
    WHERE NOT (cue.nro_cuenta::text IN (
        SELECT tcuenta_excluir.nro_cuenta
        FROM pro.tcuenta_excluir
        )) AND tr.importe_debe_mt = 0::numeric AND tr.importe_haber_mt =
            0::numeric AND tr.importe_debe_ma = 0::numeric AND tr.importe_haber_ma = 0::numeric AND cbte.cbte_aitb::text = 'si'::text AND cbte.cbte_apertura::text = 'no'::text
    GROUP BY py.id_proyecto
    )
    SELECT ta.id_proyecto,
    ta.id_proyecto_activo,
    ta.denominacion,
    ta.id_clasificacion,
    param.f_get_moneda_base() AS id_moneda,
    ta.peso * tt.total AS incremento
    FROM tprorrateo ta
     JOIN ttotal tt ON tt.id_proyecto = ta.id_proyecto;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_2_haber_detv2 (
    id_proyecto,
    codigo_tcc,
    id_cuenta,
    id_partida,
    id_centro_costo,
    importe_bs)
AS
SELECT py.id_proyecto,
    tcc.codigo AS codigo_tcc,
    tr.id_cuenta,
    tr.id_partida,
    tr.id_centro_costo,
    sum(tr.importe_debe_mb - tr.importe_haber_mb) AS importe_bs
FROM pro.tproyecto py
     JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
     JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
     JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
     JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
     JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND cbte.fecha >= date_trunc('MONTH'::text, COALESCE(py.fecha_rev_aitb, py.fecha_fin)::timestamp with time zone) AND cbte.fecha <= py.fecha_fin AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
     JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
     JOIN pre.tpartida par ON par.id_partida = tr.id_partida AND
         par.sw_movimiento::text = 'flujo'::text
WHERE NOT (cue.nro_cuenta::text IN (
    SELECT tcuenta_excluir.nro_cuenta
    FROM pro.tcuenta_excluir
    )) AND tr.importe_debe_mt = 0::numeric AND tr.importe_haber_mt = 0::numeric
        AND tr.importe_debe_ma = 0::numeric AND tr.importe_haber_ma = 0::numeric AND cbte.cbte_aitb::text = 'si'::text AND cbte.cbte_apertura::text = 'no'::text
GROUP BY py.id_proyecto, tcc.codigo, tr.id_cuenta, tr.id_partida, tr.id_centro_costo;
/***********************************F-DEP-RCM-PRO-SIS-2-18/09/2020****************************************/

/***********************************I-DEP-MZM-PRO-SIS-2-18/11/2020****************************************/
CREATE OR REPLACE VIEW pro.cbte3_ingdif(
    id_proyecto_analisis,
    id_auxiliar,
    id_cuenta_ingreso,
    monto)
AS
  SELECT vcbte_proy_diferido_ing_det.id_proyecto_analisis,
         vcbte_proy_diferido_ing_det.id_auxiliar,
         vcbte_proy_diferido_ing_det.id_cuenta_ingreso,
         CASE
           WHEN COALESCE(vcbte_proy_diferido_ing_det.saldo_pasivo, 0::numeric) >
           ((COALESCE(vcbte_proy_diferido_ing_det.saldo_gasto, 0::numeric) +
            COALESCE(vcbte_proy_diferido_ing_det.saldo_activo, 0::numeric)) /
             vcbte_proy_diferido_ing_det.porc_utilidad -(COALESCE(
             vcbte_proy_diferido_ing_det.saldo_gasto, 0::numeric) + COALESCE(
             vcbte_proy_diferido_ing_det.saldo_activo, 0::numeric))) THEN (
             COALESCE(vcbte_proy_diferido_ing_det.saldo_gasto, 0::numeric) +
              COALESCE(vcbte_proy_diferido_ing_det.saldo_activo, 0::numeric)) /
               vcbte_proy_diferido_ing_det.porc_utilidad - COALESCE(
               vcbte_proy_diferido_ing_det.saldo_ingreso, 0::numeric)
           ELSE COALESCE(vcbte_proy_diferido_ing_det.saldo_pasivo, 0::numeric)
         END AS monto
  FROM pro.vcbte_proy_diferido_ing_det;
  
  

CREATE OR REPLACE VIEW pro.vcbte_proy_diferido_det(
    id_proyecto_analisis,
    saldo_activo,
    saldo_pasivo,
    saldo_ingreso,
    saldo_gasto,
    id_centro_costo)
AS
  SELECT p.id_proyecto_analisis,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_activo
           FROM pro.f_get_saldo_analisis_diferido(p.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_activo,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_pasivo
           FROM pro.f_get_saldo_analisis_diferido(p.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_pasivo,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_ingreso
           FROM pro.f_get_saldo_analisis_diferido(p.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_ingreso,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_egreso
           FROM pro.f_get_saldo_analisis_diferido(p.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_gasto,
         (
           SELECT DISTINCT CASE
                             WHEN cc.id_gestion =((
                                                    SELECT g.id_gestion
                                                    FROM param.tgestion g
                                                    WHERE p.fecha >= g.fecha_ini AND
                                                    
                                                          p.fecha <= g.fecha_fin
                  )) THEN cc.id_centro_costo
                             ELSE 
                  (
                    SELECT cn.id_centro_costo
                    FROM param.tcentro_costo cn
                    WHERE cc.id_tipo_cc = cn.id_tipo_cc AND
                          cn.id_ep = cc.id_ep AND
                          cn.id_uo = cc.id_uo AND
                          cn.id_gestion =((
                                            SELECT g.id_gestion
                                            FROM param.tgestion g
                                            WHERE p.fecha >= g.fecha_ini AND
                                                  p.fecha <= g.fecha_fin
                          ))
                  )
                           END AS id_centro_costo
           FROM pro.tproyecto_analisis_det d
                JOIN conta.tint_transaccion t ON t.id_int_transaccion =
                 d.id_int_transaccion
                JOIN param.tcentro_costo cc ON cc.id_centro_costo =
                 t.id_centro_costo
           WHERE d.id_proyecto_analisis = p.id_proyecto_analisis
           LIMIT 1
         ) AS id_centro_costo
  FROM pro.tproyecto_analisis p;
  
  
  CREATE OR REPLACE VIEW pro.vcbte_proy_diferido_ing_det(
    id_proyecto_analisis,
    saldo_ingreso,
    saldo_gasto,
    saldo_activo,
    porc_utilidad,
    id_cuenta_ingreso,
    id_auxiliar,
    saldo_pasivo)
AS
  SELECT pro.id_proyecto_analisis,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_ingreso
           FROM pro.f_get_saldo_analisis_diferido(pro.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_ingreso,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_egreso
           FROM pro.f_get_saldo_analisis_diferido(pro.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_gasto,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_activo
           FROM pro.f_get_saldo_analisis_diferido(pro.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_activo,
         (
           SELECT CASE
                    WHEN pro.porc_diferido > 1::numeric THEN 1::numeric -
                     pro.porc_diferido / 100::numeric
                    ELSE 1::numeric - pro.porc_diferido
                  END AS "case"
         )::numeric(3,2) AS porc_utilidad,
         (
           SELECT CASE
                    WHEN cu.id_gestion =((
                                           SELECT g.id_gestion
                                           FROM param.tgestion g
                                           WHERE pro.fecha >= g.fecha_ini AND
                                                 pro.fecha <= g.fecha_fin
                  )) THEN cu.id_cuenta
                    ELSE conta.f_get_cuenta_ids(cu.id_cuenta, 'siguiente'
                     ::character varying)
                  END AS id_cuenta_ingreso
           FROM conta.tint_transaccion t
                JOIN conta.tint_comprobante c ON c.id_int_comprobante =
                 t.id_int_comprobante
                JOIN conta.tcuenta cu ON cu.id_cuenta = t.id_cuenta AND
                 cu.tipo_cuenta::text = 'ingreso' ::text
                JOIN param.tcentro_costo cc ON cc.id_centro_costo =
                 t.id_centro_costo
                JOIN param.ttipo_cc tc ON tc.id_tipo_cc = cc.id_tipo_cc
                JOIN pro.tproyecto proy ON proy.id_tipo_cc = tc.id_tipo_cc
           WHERE proy.id_proyecto = pro.id_proyecto AND
                 c.estado_reg::text = 'validado' ::text AND
                 c.fecha < pro.fecha
           ORDER BY c.fecha DESC
           LIMIT 1
         ) AS id_cuenta_ingreso,
         (
           SELECT a.id_auxiliar
           FROM conta.tauxiliar a
                JOIN param.vproveedor p ON p.codigo::text =
                 a.codigo_auxiliar::text
           WHERE p.id_proveedor = pro.id_proveedor
         ) AS id_auxiliar,
         (
           SELECT f_get_saldo_analisis_diferido.op_saldo_pasivo
           FROM pro.f_get_saldo_analisis_diferido(pro.id_proyecto_analisis,
            NULL::character varying) f_get_saldo_analisis_diferido(
            op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso)
         ) AS saldo_pasivo
  FROM pro.tproyecto_analisis pro;
/***********************************F-DEP-MZM-PRO-SIS-2-18/11/2020****************************************/  

/***********************************I-DEP-RCM-PRO-SIS-ETR-2261-23/12/2020****************************************/
CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_detv3(
    id_proyecto,
    id_proyecto_activo,
    id_clasificacion,
    denominacion,
    importe_actualiz,
    id_almacen)
AS
WITH tmayor_total AS(
  SELECT DISTINCT py.id_proyecto,
         sum(tr.importe_debe_mb) AS debe_mb,
         sum(tr.importe_haber_mb) AS haber_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) AS saldo_mb
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
       JOIN pre.tpartida par ON par.id_partida = tr.id_partida
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto), tcbte1_cbte2 AS(
      SELECT py.id_proyecto,
             sum(tr.importe_debe_mb) AS saldo_mb
      FROM pro.tproyecto py
           JOIN conta.tint_comprobante cb_1 ON cb_1.id_int_comprobante =
             py.id_int_comprobante_1 OR cb_1.id_int_comprobante =
             py.id_int_comprobante_2
           JOIN conta.tint_transaccion tr ON tr.id_int_comprobante =
             cb_1.id_int_comprobante
      GROUP BY py.id_proyecto), tactivos_proy AS (
          WITH tval_activo AS (
                SELECT DISTINCT
                pa_1_1.id_proyecto_activo,
                pa_1_1.id_almacen,
                SUM(pad.monto) OVER(PARTITION BY pa_1_1.id_proyecto_activo) AS parcial,
                SUM(pad.monto) OVER(PARTITION BY pa_1_1.id_proyecto) AS total
                FROM pro.tproyecto_activo pa_1_1
                JOIN pro.tproyecto_activo_detalle pad
                ON pad.id_proyecto_activo = pa_1_1.id_proyecto_activo
                WHERE COALESCE(pa_1_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
            )
            SELECT pa_1.id_proyecto,
            pa_1.id_proyecto_activo,
            pa_1.denominacion,
            va.parcial / va.total AS peso,
            pa_1.id_clasificacion,
            pa_1.id_almacen
            FROM pro.tproyecto_activo pa_1
            JOIN tval_activo va
            ON va.id_proyecto_activo = pa_1.id_proyecto_activo
            WHERE pa_1.id_almacen IS NULL
        )
        SELECT pa.id_proyecto,
        pa.id_proyecto_activo,
        pa.id_clasificacion,
        pa.denominacion,
        pa.peso * abs(my.saldo_mb - cb.saldo_mb) AS importe_actualiz,
        pa.id_almacen
        FROM tactivos_proy pa
        JOIN tmayor_total my ON my.id_proyecto = pa.id_proyecto
        JOIN tcbte1_cbte2 cb ON cb.id_proyecto = my.id_proyecto
        WHERE pa.id_almacen IS NULL;

CREATE OR REPLACE VIEW pro.v_cbte_cierre_proy_3_debe_det_alm(
    id_proyecto,
    id_almacen,
    denominacion,
    importe_actualiz)
AS
WITH tmayor_total AS(
  SELECT DISTINCT py.id_proyecto,
         sum(tr.importe_debe_mb) AS debe_mb,
         sum(tr.importe_haber_mb) AS haber_mb,
         sum(tr.importe_debe_mb - tr.importe_haber_mb) AS saldo_mb
  FROM pro.tproyecto py
       JOIN pro.tproyecto_columna_tcc pc ON pc.id_proyecto = py.id_proyecto
       JOIN param.ttipo_cc tcc ON tcc.id_tipo_cc = pc.id_tipo_cc
       JOIN param.tcentro_costo cc ON cc.id_tipo_cc = tcc.id_tipo_cc
       JOIN conta.tint_transaccion tr ON tr.id_centro_costo = cc.id_centro_costo
       JOIN conta.tint_comprobante cbte ON cbte.id_int_comprobante =
         tr.id_int_comprobante AND cbte.estado_reg::text = 'validado'::text AND
         cbte.fecha >= py.fecha_ini AND cbte.fecha <= py.fecha_fin AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_1, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_2, 0) AND
         cbte.id_int_comprobante <> COALESCE(py.id_int_comprobante_3, 0)
       JOIN conta.tcuenta cue ON cue.id_cuenta = tr.id_cuenta
       JOIN pre.tpartida par ON par.id_partida = tr.id_partida
  WHERE NOT (cue.nro_cuenta::text IN (
                                       SELECT tcuenta_excluir.nro_cuenta
                                       FROM pro.tcuenta_excluir
        ))
  GROUP BY py.id_proyecto), tcbte1_cbte2 AS(
      SELECT py.id_proyecto,
             sum(tr.importe_debe_mb) AS saldo_mb
      FROM pro.tproyecto py
           JOIN conta.tint_comprobante cb_1 ON cb_1.id_int_comprobante =
             py.id_int_comprobante_1 OR cb_1.id_int_comprobante =
             py.id_int_comprobante_2
           JOIN conta.tint_transaccion tr ON tr.id_int_comprobante =
             cb_1.id_int_comprobante
      GROUP BY py.id_proyecto), tactivos_proy AS (
            WITH tprorrateo AS (
                SELECT DISTINCT
                pa_1.id_proyecto,
                pa_1.id_proyecto_activo,
                pa_1.id_almacen,
                SUM(pad.monto) OVER (PARTITION BY pa_1.id_proyecto_activo) AS parcial,
                SUM(pad.monto) OVER(PARTITION BY pa_1.id_proyecto) AS total
                FROM pro.tproyecto_activo pa_1
                JOIN pro.tproyecto_activo_detalle pad
                ON pad.id_proyecto_activo = pa_1.id_proyecto_activo
                WHERE COALESCE(pa_1.codigo_af_rel, ''::character varying)::text <> 'GASTO'::text
            )
            SELECT
            p.id_proyecto,
            p.id_almacen,
            SUM(p.parcial) AS parcial,
            p.total,
            al.nombre as denominacion,
            SUM(p.parcial) / p.total AS peso
            FROM tprorrateo p
            JOIN alm.talmacen al
            ON al.id_almacen = p.id_almacen
            WHERE p.id_almacen IS NOT NULL
            GROUP BY p.id_almacen, p.total, al.nombre, p.id_proyecto
        )
        SELECT pa.id_proyecto,
        pa.id_almacen,
        pa.denominacion,
        pa.peso * abs(my.saldo_mb - cb.saldo_mb) AS importe_actualiz
        FROM tactivos_proy pa
        JOIN tmayor_total my ON my.id_proyecto = pa.id_proyecto
        JOIN tcbte1_cbte2 cb ON cb.id_proyecto = my.id_proyecto;
/***********************************F-DEP-RCM-PRO-SIS-ETR-2261-23/12/2020****************************************/