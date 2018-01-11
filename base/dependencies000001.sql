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