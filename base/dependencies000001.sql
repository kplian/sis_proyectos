/***********************************I-DEP-RCM-PRO-1-12/10/2017****************************************/
ALTER TABLE pro.tproyecto
  ADD CONSTRAINT fk_tproyecto__id_proyecto_ep FOREIGN KEY (id_proyecto_ep)
    REFERENCES param.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
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
ALTER TABLE pro.tproyecto_activo_detalle
  ADD CONSTRAINT fk_tproyecto_activo_detalle__id_centro_costo FOREIGN KEY (id_centro_costo)
    REFERENCES param.tcentro_costo(id_centro_costo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
ALTER TABLE pro.tproyecto_activo_detalle
  ADD CONSTRAINT fk_tproyecto_activo_detalle__id_cuenta FOREIGN KEY (id_cuenta)
    REFERENCES conta.tcuenta(id_cuenta)
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
  DROP CONSTRAINT fk_tproyecto_activo_detalle__id_centro_costo RESTRICT;

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
  ADD CONSTRAINT fk_tproyecto__id_moneda FOREIGN KEY (id_moneda)
    REFERENCES param.tmoneda(id_moneda)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

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