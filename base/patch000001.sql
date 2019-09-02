/***********************************I-SCP-RCM-PRO-1-31/08/2017****************************************/
create table pro.tproyecto (
	id_proyecto serial,
	codigo varchar(20),
	nombre varchar(150),
	id_proyecto_ep integer,
	fecha_ini date,
	fecha_fin date,
	constraint pk_tproyecto__id_proyecto primary key (id_proyecto)
) inherits (pxp.tbase) without oids;

create table pro.tproyecto_activo (
	id_proyecto_activo serial,
	id_proyecto integer,
	id_clasificacion integer,
	denominacion varchar(500),
	descripcion varchar(5000),
	observaciones varchar(5000),
	constraint pk_tproyecto_activo__id_proyecto_activo primary key (id_proyecto_activo)
) inherits (pxp.tbase) without oids;

create table pro.tproyecto_activo_detalle (
	id_proyecto_activo_detalle serial,
	id_proyecto_activo integer,
	id_centro_costo integer,
	id_comprobante integer, --comprobante directo
	id_cuenta integer,
	num_tramite_origen VARCHAR(200),
	monto numeric(18,2),
	porcentaje numeric(18,2),
	observaciones varchar(5000),
	constraint pk_tproyecto_activo_detalle__id_proyecto_activo_detalle primary key (id_proyecto_activo_detalle)
) inherits (pxp.tbase) without oids;

COMMENT ON COLUMN pro.tproyecto_activo_detalle.num_tramite_origen
IS 'Número de trámite de la transacción contable de origen';

create table pro.tfase (
	id_fase serial,
	id_proyecto integer,
	id_fase_fk integer,
	id_estado_wf integer,
	id_proceso_wf integer,
	nro_tramite varchar(150),
	codigo varchar(20),
	nombre varchar(150),
	descripcion varchar(5000),
	observaciones varchar(5000),
	fecha_ini date,
	fecha_fin date,
	estado varchar(20),
	constraint pk_tfase__id_fase primary key (id_fase)
) inherits (pxp.tbase) without oids;

create table pro.tfase_funcionario (
	id_fase_funcionario serial,
	id_fase integer,
	id_funcionario integer,
	rol varchar(20),
	fecha_ini date,
	fecha_fin date,
	constraint pk_tfase_funcionario__id_fase_funcionario primary key (id_fase_funcionario)
) inherits (pxp.tbase) without oids;

create table pro.tfase_suministro (
	id_fase_suministro serial,
	id_fase integer,
	id_centro_costo integer,
	id_orden_trabajo integer,
	id_pedido_alm integer,
	id_solicitud_compra integer,
	id_cuenta_doc integer,
	id_solicitud_efectivo integer,
	constraint pk_tfase_suministro__id_fase_suministro primary key (id_fase_suministro)
) inherits (pxp.tbase) without oids;

create table pro.tproyecto_funcionario (
	id_proyecto_funcionario serial,
	id_proyecto integer,
	id_funcionario integer,
	rol varchar(20),
	constraint pk_tproyecto_funcionario__id_proyecto_funcionario primary key (id_proyecto_funcionario)
) inherits (pxp.tbase) without oids;
/***********************************F-SCP-RCM-PRO-1-31/08/2017****************************************/

/***********************************I-SCP-RCM-PRO-1-28/09/2017****************************************/
COMMENT ON COLUMN pro.tproyecto.id_proyecto_ep
IS 'Id del proyecto de la Estructura Programática';
/***********************************F-SCP-RCM-PRO-1-28/09/2017****************************************/

/***********************************I-SCP-RCM-PRO-1-29/09/2017****************************************/
create table pro.tproyecto_contrato (
	id_proyecto_contrato serial,
	id_proyecto integer,
	id_proveedor integer,
	id_moneda integer,
	id_contrato integer,
	nro_contrato varchar(50),
	nombre varchar(200),
	estado varchar(20),
	resumen varchar(1000),
	fecha_ini date,
	fecha_fin date,
	cantidad_meses integer,
	monto_total numeric(18,2),
	pagos varchar(15),
	constraint pk_tproyecto_contrato__id_proyecto_contrato primary key (id_proyecto_contrato)
) inherits (pxp.tbase) without oids;
/***********************************F-SCP-RCM-PRO-1-29/09/2017****************************************/

/***********************************I-SCP-RCM-PRO-1-19/10/2017****************************************/
ALTER TABLE pro.tproyecto_activo_detalle
  RENAME COLUMN id_centro_costo TO id_tipo_cc;

COMMENT ON COLUMN pro.tproyecto_activo_detalle.id_tipo_cc
IS 'Tipo del Centro de Costo';

ALTER TABLE pro.tproyecto_activo_detalle
  RENAME COLUMN id_cuenta TO nro_cuenta;

COMMENT ON COLUMN pro.tproyecto_activo_detalle.nro_cuenta
IS 'Número de la cuenta contable';

ALTER TABLE pro.tproyecto_activo_detalle
  ALTER COLUMN nro_cuenta TYPE VARCHAR(20);
/***********************************F-SCP-RCM-PRO-1-19/10/2017****************************************/

/***********************************I-SCP-RCM-PRO-1-30/10/2017****************************************/
ALTER TABLE pro.tproyecto_activo_detalle
  DROP COLUMN num_tramite_origen;
/***********************************F-SCP-RCM-PRO-1-30/10/2017****************************************/

/***********************************I-SCP-RCM-PRO-1-15/05/2018****************************************/
ALTER TABLE pro.tproyecto
  ADD COLUMN id_moneda INTEGER;

COMMENT ON COLUMN pro.tproyecto.id_moneda
IS 'Moneda en la cuál se realizará el cierre del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN monto_total NUMERIC(18,2);

COMMENT ON COLUMN pro.tproyecto.monto_total
IS 'Monto total presupuestado del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN fecha_ini_real DATE;

COMMENT ON COLUMN pro.tproyecto.fecha_ini_real
IS 'Fecha real de inicio del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN fecha_fin_real DATE;

COMMENT ON COLUMN pro.tproyecto.fecha_fin_real
IS 'Fecha real de finalización del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN descripcion VARCHAR(1000);

COMMENT ON COLUMN pro.tproyecto.descripcion
IS 'Descripción del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN id_estado_wf INTEGER;

COMMENT ON COLUMN pro.tproyecto.id_estado_wf
IS 'Identificador del estado del WF';

ALTER TABLE pro.tproyecto
  ADD COLUMN nro_tramite VARCHAR(150);

COMMENT ON COLUMN pro.tproyecto.nro_tramite
IS 'Número identificador del trámite';

ALTER TABLE pro.tproyecto
  ADD COLUMN estado VARCHAR(20);

COMMENT ON COLUMN pro.tproyecto.estado
IS 'Estado del proyecto';

ALTER TABLE pro.tfase
  ADD COLUMN fecha_ini_real DATE;

COMMENT ON COLUMN pro.tfase.fecha_ini_real
IS 'Fecha real de inicio';

ALTER TABLE pro.tfase
  ADD COLUMN fecha_fin_real DATE;

COMMENT ON COLUMN pro.tfase.fecha_fin_real
IS 'Fecha real de finalización';

ALTER TABLE pro.tfase
  ADD COLUMN id_tipo_cc INTEGER;

COMMENT ON COLUMN pro.tfase.id_tipo_cc
IS 'Tipo de Centro de Costo asociado, definido previamente en el árbol TCC';

CREATE TABLE pro.tfase_concepto_ingas (
  id_fase_concepto_ingas SERIAL,
  id_fase INTEGER NOT NULL,
  id_concepto_ingas INTEGER NOT NULL,
  id_unidad_medida INTEGER,
  descripcion VARCHAR(500) NOT NULL,
  cantidad NUMERIC(18,2),
  precio NUMERIC(18,2),
  precio_mb NUMERIC(18,2),
  precio_mt NUMERIC(18,2),
  tipo_cambio_mb NUMERIC(18,2),
  tipo_cambio_mt NUMERIC(18,2),
  estado VARCHAR(20),
  PRIMARY KEY(id_fase_concepto_ingas)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pro.tfase_concepto_ingas.cantidad
IS 'Cantidad estimada del concepto ingas a adquirir';

COMMENT ON COLUMN pro.tfase_concepto_ingas.precio
IS 'Precio estimado para adquirir el concepto de gasto';

COMMENT ON COLUMN pro.tfase_concepto_ingas.precio_mb
IS 'Precio estimado en moneda base';

COMMENT ON COLUMN pro.tfase_concepto_ingas.precio_mt
IS 'Precio estimado en moneda transaccional';

COMMENT ON COLUMN pro.tfase_concepto_ingas.tipo_cambio_mb
IS 'Tipo cambio moneda base';

COMMENT ON COLUMN pro.tfase_concepto_ingas.tipo_cambio_mt
IS 'Tipo cambio moneda transaccional';

COMMENT ON COLUMN pro.tfase_concepto_ingas.estado
IS 'Estado de la fase';

CREATE TABLE pro.tinvitacion (
  id_invitacion SERIAL,
  id_proyecto INTEGER NOT NULL,
  codigo VARCHAR,
  descripcion VARCHAR(200),
  fecha DATE,
  fecha_real DATE,
  id_estado_wf INTEGER,
  estado VARCHAR(20),
  nro_tramite VARCHAR(150),
  PRIMARY KEY(id_invitacion)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pro.tinvitacion.codigo
IS 'Código de la invitación';

COMMENT ON COLUMN pro.tinvitacion.fecha
IS 'Fecha estimada para el lanzamiento de la invitiación';

COMMENT ON COLUMN pro.tinvitacion.fecha_real
IS 'Fecha real del lanzamiento';

CREATE TABLE pro.tinvitacion_det (
  id_invitacion_det SERIAL,
  id_invitacion INTEGER NOT NULL,
  id_fase_concepto_ingas INTEGER NOT NULL,
  observaciones VARCHAR(1000),
  PRIMARY KEY(id_invitacion_det)
) INHERITS (pxp.tbase)

WITH (oids = false);

CREATE TABLE pro.tinvitacion_solicitud (
  id_invitacion_solicitud SERIAL,
  id_invitacion INTEGER NOT NULL,
  id_solicitud INTEGER NOT NULL,
  descripcion VARCHAR(200),
  PRIMARY KEY(id_invitacion_solicitud)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pro.tinvitacion_solicitud.descripcion
IS 'Glosa opcional para detallar si la adquisición es segunda o tercera';

COMMENT ON COLUMN pro.tinvitacion_solicitud.id_solicitud
IS 'Solicitud de compra del sistema de adquisiciones';

/***********************************F-SCP-RCM-PRO-1-15/05/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-10/08/2018****************************************/
ALTER TABLE pro.tproyecto
  DROP COLUMN id_proyecto_ep;

ALTER TABLE pro.tproyecto
  ADD COLUMN id_tipo_cc INTEGER NOT NULL;

COMMENT ON COLUMN pro.tproyecto.id_tipo_cc
IS 'Tipo de Centro de Costo';
/***********************************F-SCP-RCM-PRO-1-10/08/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-15/08/2018****************************************/
CREATE TABLE pro.tfase_plantilla (
  id_fase_plantilla SERIAL,
  id_fase_plantilla_fk INTEGER,
  id_tipo_cc INTEGER,
  id_tipo_cc_plantilla INTEGER,
  codigo VARCHAR(20),
  nombre VARCHAR(150),
  descripcion VARCHAR(5000),
  observaciones VARCHAR(5000),
  estado VARCHAR(20),
  CONSTRAINT pk_tfase_plantilla__id_fase_plantilla PRIMARY KEY(id_fase_plantilla),
  CONSTRAINT fk_tfase_plantilla__id_fase_plantilla_fk FOREIGN KEY (id_fase_plantilla_fk)
    REFERENCES pro.tfase_plantilla(id_fase_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);

COMMENT ON COLUMN pro.tfase_plantilla.id_tipo_cc_plantilla
IS 'Plantilla del Tipo CC';

ALTER TABLE pro.tfase_plantilla
  ADD COLUMN id_tmp INTEGER;

COMMENT ON COLUMN pro.tfase_plantilla.id_tmp
IS 'Id temporal para armar el árbol a partir de la plantilla';

ALTER TABLE pro.tproyecto
  ADD COLUMN id_fase_plantilla INTEGER;
/***********************************F-SCP-RCM-PRO-1-15/08/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-23/08/2018****************************************/
ALTER TABLE pro.tproyecto_activo_detalle
  ADD COLUMN codigo_partida VARCHAR(30);

COMMENT ON COLUMN pro.tproyecto_activo_detalle.codigo_partida
IS 'Código de la partida';

ALTER TABLE pro.tfase_concepto_ingas
  RENAME COLUMN cantidad TO cantidad_est;

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN cantidad_sol NUMERIC(18,0) NOT NULL;

COMMENT ON COLUMN pro.tinvitacion_det.cantidad_sol
IS 'Cantidad a solicitar';

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_concepto_ingas INTEGER NOT NULL;

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_unidad_medida INTEGER NOT NULL;

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN precio NUMERIC(18,2);

COMMENT ON COLUMN pro.tinvitacion_det.precio
IS 'Precio que pueda variar del que se registro en fase concepto ingas';

/***********************************F-SCP-RCM-PRO-1-23/08/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-05/09/2018****************************************/
ALTER TABLE pro.tinvitacion
  ADD COLUMN id_funcionario INTEGER;

COMMENT ON COLUMN pro.tinvitacion.id_funcionario
IS 'Solicitante de la compra';

ALTER TABLE pro.tinvitacion
  ADD COLUMN id_depto INTEGER;

COMMENT ON COLUMN pro.tinvitacion.id_depto
IS 'Departamento de Adquisiciones';

ALTER TABLE pro.tinvitacion
  ADD COLUMN id_moneda INTEGER;

COMMENT ON COLUMN pro.tinvitacion.id_moneda
IS 'Moneda de la solicitud';

ALTER TABLE pro.tinvitacion
  ADD COLUMN tipo VARCHAR(50);

COMMENT ON COLUMN pro.tinvitacion.tipo
IS 'Tipo de la Solicitud a realizar: Bien, Servicio';

ALTER TABLE pro.tinvitacion
  ADD COLUMN dias_plazo_entrega INTEGER;

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_centro_costo INTEGER;

COMMENT ON COLUMN pro.tinvitacion_det.id_centro_costo
IS 'Centro de costo para la solicitud de compra';

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN descripcion TEXT;

COMMENT ON COLUMN pro.tinvitacion_det.descripcion
IS 'Descripcion detallada del Bien/Servicio a contratar';

ALTER TABLE pro.tinvitacion
  ADD COLUMN lugar_entrega VARCHAR(255);

/***********************************F-SCP-RCM-PRO-1-05/09/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-11/09/2018****************************************/
ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_fase INTEGER;

COMMENT ON COLUMN pro.tproyecto.fecha_fin
IS 'Fecha del cierre del proyecto';

create table pro.tproyecto_columna_tcc (
  id_proyecto_columna_tcc serial,
  id_proyecto integer not null,
  id_tipo_cc integer not null,
  constraint pk_tproyecto_columna_tcc__id_proyecto_columna_tcc primary key (id_proyecto_columna_tcc)
) inherits (pxp.tbase) without oids;

ALTER TABLE pro.tproyecto_columna_tcc
  ADD CONSTRAINT tproyecto_columna_tcc_idx
    UNIQUE (id_proyecto,id_tipo_cc);

ALTER TABLE pro.tproyecto
  ADD COLUMN id_depto_conta INTEGER NOT NULL;

COMMENT ON COLUMN pro.tproyecto.id_depto_conta
IS 'Depto. contable para la generación del comprobante contable';


ALTER TABLE pro.tproyecto
  ADD COLUMN id_proceso_wf_cierre INTEGER;

COMMENT ON COLUMN pro.tproyecto.id_proceso_wf_cierre
IS 'Proceso WF para el cierre del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN id_estado_wf_cierre INTEGER;

COMMENT ON COLUMN pro.tproyecto.id_estado_wf_cierre
IS 'Estado Wf del cierre del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN nro_tramite_cierre VARCHAR(150);

COMMENT ON COLUMN pro.tproyecto.nro_tramite_cierre
IS 'Nro de trámite para el cierre del proyecto';

ALTER TABLE pro.tproyecto
  ADD COLUMN estado_cierre VARCHAR(30);

COMMENT ON COLUMN pro.tproyecto.estado_cierre
IS 'Estado para el cierre';


ALTER TABLE pro.tproyecto
  ADD COLUMN id_proceso_wf INTEGER;

COMMENT ON COLUMN pro.tproyecto.id_proceso_wf
IS 'Proceso WF del proyecto';


COMMENT ON COLUMN pro.tproyecto.estado
IS 'Estado del Proyecto';
/***********************************F-SCP-RCM-PRO-1-11/09/2018****************************************/


/***********************************I-SCP-RCM-PRO-1-24/09/2018****************************************/
ALTER TABLE pro.tproyecto
  ADD COLUMN id_int_comprobante_1 integer;

COMMENT ON COLUMN pro.tproyecto.id_int_comprobante_1
IS 'Comprobante para el cierre sin actualización';

ALTER TABLE pro.tproyecto
  ADD COLUMN id_int_comprobante_2 integer;

COMMENT ON COLUMN pro.tproyecto.id_int_comprobante_2
IS 'Comprobante para la actualización del cierre';

ALTER TABLE pro.tproyecto
  ADD COLUMN id_int_comprobante_3 integer;

COMMENT ON COLUMN pro.tproyecto.id_int_comprobante_3
IS 'Comprobante para reversión de la actualizacion';

CREATE TABLE pro.tproyecto_activo_det_mon (
  id_proyecto_activo_det_mon SERIAL,
  id_proyecto_activo_detalle INTEGER NOT NULL,
  id_moneda INTEGER NOT NULL,
  importe_al_cambio NUMERIC NOT NULL,
  importe_actualiz NUMERIC DEFAULT 0,
  PRIMARY KEY(id_proyecto_activo_det_mon)
) INHERITS (pxp.tbase)

WITH (oids = false);

COMMENT ON COLUMN pro.tproyecto_activo_det_mon.importe_al_cambio
IS 'Importe expresado Id moneda al tipo de cambio definido en el proyecto';

COMMENT ON COLUMN pro.tproyecto_activo_det_mon.importe_actualiz
IS 'Sólo para BS, Importe de la actualzación de la gestión hasta la fecha de cierre del proyecto';

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN vida_util_anios INTEGER;

COMMENT ON COLUMN pro.tproyecto_activo.vida_util_anios
IS 'Vida útil en años';

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_unidad_medida INTEGER;

COMMENT ON COLUMN pro.tproyecto_activo.id_unidad_medida
IS 'Unidad de Medida';

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN codigo_af_rel VARCHAR(50);

COMMENT ON COLUMN pro.tproyecto_activo.codigo_af_rel
IS 'Código Activo Fijo relacionado, al cuál se le incrementará este monto';

CREATE TABLE pro.tcuenta_excluir (
  id_cuenta_excluir SERIAL,
  id_cuenta INTEGER NOT NULL,
  PRIMARY KEY(id_cuenta_excluir)
) INHERITS (pxp.tbase)

WITH (oids = false);
/***********************************F-SCP-RCM-PRO-1-24/09/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-03/10/2018****************************************/
ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_activo_fijo INTEGER;
/***********************************F-SCP-RCM-PRO-1-03/10/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-24/10/2018****************************************/
ALTER TABLE pro.tfase
  ADD COLUMN id_funcionario INTEGER;

COMMENT ON COLUMN pro.tfase.id_funcionario
IS 'Funcionario asignado a la tarea';

CREATE TABLE pro.tfase_avance_obs (
  id_fase_avance_obs SERIAL,
  id_proyecto INTEGER,
  id_fase INTEGER,
  fecha DATE,
  porcentaje NUMERIC(18,2),
  observaciones VARCHAR(5000),
  tipo VARCHAR(15),
  CONSTRAINT tfase_avance_obs_idx UNIQUE(tipo, fecha, id_fase),
  CONSTRAINT tfase_avance_obs_pkey PRIMARY KEY(id_fase_avance_obs),
  CONSTRAINT chk_tfase_avance_obs__tipo CHECK ((tipo)::text = ANY ((ARRAY['avance'::character varying, 'avance_visual'::character varying, 'observacion'::character varying])::text[]))
) INHERITS (pxp.tbase)

WITH (oids = false);


/***********************************F-SCP-RCM-PRO-1-24/10/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-20/11/2018****************************************/
CREATE TABLE pro.tproyecto_fase_archivo (
  id_proyecto_fase_archivo SERIAL,
  id_proyecto INTEGER NOT NULL,
  id_fase INTEGER NULL,
  descripcion VARCHAR(500) NOT NULL,
  nombre_archivo VARCHAR(120) NOT NULL,
  PRIMARY KEY(id_proyecto_fase_archivo)
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE pro.tfase_concepto_ingas
  ADD COLUMN fecha_estimada DATE;

COMMENT ON COLUMN pro.tfase_concepto_ingas.fecha_estimada
IS 'Fecha estimada para realizar la invitación para la adquisición';
/***********************************F-SCP-RCM-PRO-1-20/11/2018****************************************/

/***********************************I-SCP-RCM-PRO-0-03/12/2018****************************************/
ALTER TABLE pro.tinvitacion
  ADD COLUMN id_categoria_compra INTEGER;


ALTER TABLE pro.tproyecto
  ALTER COLUMN estado TYPE VARCHAR(30) COLLATE pg_catalog."default";

ALTER TABLE pro.tproyecto
  ADD COLUMN id_int_comprobante_4 INTEGER;

COMMENT ON COLUMN pro.tproyecto.id_int_comprobante_4
IS 'eliminar';

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN cantidad_det NUMERIC(18,2);

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_depto INTEGER;

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN estado VARCHAR(10);

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_lugar INTEGER;

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN ubicacion VARCHAR(255);

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_centro_costo INTEGER;

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_ubicacion INTEGER;

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_grupo INTEGER;

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_grupo_clasif INTEGER;

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN nro_serie VARCHAR(50);

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN marca VARCHAR(200);

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN fecha_ini_dep DATE;

ALTER TABLE pro.tproyecto_activo
  ADD COLUMN id_funcionario INTEGER;

COMMENT ON COLUMN pro.tproyecto_activo.id_funcionario
IS 'Responsable del activo fijo';

ALTER TABLE pro.tproyecto_contrato
  ADD COLUMN tipo_pagos VARCHAR(15);

ALTER TABLE pro.tinvitacion_det
  ALTER COLUMN cantidad_sol TYPE NUMERIC(18,5);

ALTER TABLE pro.tinvitacion_det
  ALTER COLUMN cantidad_sol DROP NOT NULL;

ALTER TABLE pro.tinvitacion_det
  ALTER COLUMN id_unidad_medida DROP NOT NULL;

ALTER TABLE pro.tinvitacion_det
  ALTER COLUMN id_fase_concepto_ingas DROP NOT NULL;

ALTER TABLE pro.tproyecto_activo_detalle
  ALTER COLUMN id_proyecto_activo SET NOT NULL;

ALTER TABLE pro.tproyecto_activo_detalle
  ALTER COLUMN id_tipo_cc SET NOT NULL;

ALTER TABLE pro.tproyecto_activo_detalle
  ALTER COLUMN monto TYPE NUMERIC;

CREATE TABLE pro.tcontrato_pago (
  id_contrato_pago serial,
  id_proyecto_contrato INTEGER,
  id_moneda INTEGER,
  monto NUMERIC(18,2),
  monto_pagado NUMERIC(18,2),
  fecha_plan DATE,
  fecha_pago DATE
) INHERITS (pxp.tbase)
WITH (oids = false);
/***********************************F-SCP-RCM-PRO-0-03/12/2018****************************************/

/***********************************I-SCP-EGS-PRO-0-04/12/2018****************************************/
ALTER TABLE pro.tinvitacion
  ADD COLUMN id_solicitud INTEGER;

COMMENT ON COLUMN pro.tinvitacion.id_solicitud
IS 'id cuando se genera una solicitud de compra';
/***********************************F-SCP-EGS-PRO-0-04/12/2018****************************************/

/***********************************I-SCP-EGS-PRO-1-05/12/2018****************************************/
ALTER TABLE pro.tfase_concepto_ingas
  ADD COLUMN fecha_fin DATE;

COMMENT ON COLUMN pro.tfase_concepto_ingas.fecha_fin
IS 'fecha de finalización estimada, que llegaría a ser la de llegada de suministro y finalización de obra para el caso de construcción.';
/***********************************F-SCP-EGS-PRO-1-05/12/2018****************************************/

/***********************************I-SCP-EGS-PRO-2-11/12/2018****************************************/
ALTER TABLE pro.tinvitacion
  ADD COLUMN id_presolicitud INTEGER;

COMMENT ON COLUMN pro.tinvitacion.id_presolicitud
IS 'id cuando se genera una presolicitu de compra';

ALTER TABLE pro.tinvitacion
  ADD COLUMN pre_solicitud VARCHAR DEFAULT 'no' NOT NULL;

COMMENT ON COLUMN pro.tinvitacion.pre_solicitud
IS 'indica si lanza presolicitud (si) o solicitud(no) ';

ALTER TABLE pro.tinvitacion
  ADD COLUMN id_grupo INTEGER;

COMMENT ON COLUMN pro.tinvitacion.id_grupo
IS 'id del grupo de compras que tendra la presolicitud ';
/***********************************F-SCP-EGS-PRO-2-11/12/2018****************************************/

/***********************************I-SCP-RCM-PRO-0-14/12/2018****************************************/
create table pro.tfase_concepto_ingas_pago (
  id_fase_concepto_ingas_pago serial,
  id_fase_concepto_ingas integer,
  fecha_pago date,
  fecha_pago_real date,
  importe numeric(18,2),
  constraint pk_tfase_concepto_ingas_pago__id_fase_concepto_ingas_pago primary key (id_fase_concepto_ingas_pago)
) inherits (pxp.tbase) without oids;
/***********************************F-SCP-RCM-PRO-0-14/12/2018****************************************/

/***********************************I-SCP-RCM-PRO-1-19/12/2018****************************************/
ALTER TABLE pro.tcuenta_excluir
  ALTER COLUMN id_cuenta DROP NOT NULL;

ALTER TABLE pro.tcuenta_excluir
  ADD COLUMN nro_cuenta VARCHAR(20) NOT NULL;

COMMENT ON COLUMN pro.tcuenta_excluir.nro_cuenta
IS 'Número de cuenta contable que se usa en vez de id_cuenta';
/***********************************F-SCP-RCM-PRO-1-19/12/2018****************************************/

/***********************************I-SCP-EGS-PRO-3-26/12/2018****************************************/
ALTER TABLE pro.tfase_concepto_ingas
  ADD COLUMN id_funcionario INTEGER;

COMMENT ON COLUMN pro.tfase_concepto_ingas.id_funcionario
IS 'Encargado de item/servicio';

ALTER TABLE pro.tfase_concepto_ingas
  ADD COLUMN precio_est NUMERIC(18,2);

COMMENT ON COLUMN pro.tfase_concepto_ingas.precio_est
IS 'Precio estimado para adquirir el concepto de gasto';
/***********************************F-SCP-EGS-PRO-3-26/12/2018****************************************/

/***********************************I-SCP-RCM-PRO-3-27/12/2018****************************************/
ALTER TABLE pro.tproyecto
  ADD COLUMN importe_max NUMERIC(18,2);

COMMENT ON COLUMN pro.tproyecto.importe_max
IS 'Importe máximo aprobado por la AE para la ejecución del Proyecto';
/***********************************F-SCP-RCM-PRO-3-27/12/2018****************************************/
/***********************************I-SCP-EGS-PRO-4-28/01/2019****************************************/

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_solicitud_det INTEGER;

COMMENT ON COLUMN pro.tinvitacion_det.id_solicitud_det
IS 'relaciona el detalle con un detalle de solicitud de compra';

/***********************************F-SCP-EGS-PRO-4-28/01/2019****************************************/
/***********************************I-SCP-EGS-PRO-5-05/02/2019****************************************/

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_presolicitud_det INTEGER;

COMMENT ON COLUMN pro.tinvitacion_det.id_presolicitud_det
IS 'relaciona el detalle de una presolicitud a la invitacion';
/***********************************F-SCP-EGS-PRO-5-05/02/2019****************************************/
/***********************************I-SCP-EGS-PRO-6-26/03/2019****************************************/

ALTER TABLE pro.tfase_concepto_ingas
  ADD COLUMN codigo VARCHAR;
  
/***********************************F-SCP-EGS-PRO-6-26/03/2019****************************************/
/***********************************I-SCP-EGS-PRO-7-09/04/2019****************************************/

ALTER TABLE pro.tfase_concepto_ingas_pago
  ADD COLUMN descripcion VARCHAR;
  
/***********************************F-SCP-EGS-PRO-7-09/04/2019****************************************/
/***********************************I-SCP-EGS-PRO-8-31/07/2019****************************************/

ALTER TABLE pro.tinvitacion
  ADD COLUMN id_invitacion_fk INTEGER;

COMMENT ON COLUMN pro.tinvitacion.id_invitacion_fk
IS 'ID del primer lanzamiento (original)';

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN estado_lanz VARCHAR DEFAULT 'activo'::character varying NOT NULL;

COMMENT ON COLUMN pro.tinvitacion_det.estado_lanz
IS 'Si el detalle esta activo para el lanzamiento(1,2,3,etc)';

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_invitacion_det_fk INTEGER;

COMMENT ON COLUMN pro.tinvitacion_det.id_invitacion_det_fk
IS 'id del detalle original del primer lanzamiento';


CREATE TABLE pro.tunidad_constructiva (
  id_unidad_constructiva SERIAL,
  codigo VARCHAR,
  nombre VARCHAR,
  id_proyecto INTEGER,
  descripcion VARCHAR,
  id_unidad_constructiva_fk INTEGER,
  activo VARCHAR(2) DEFAULT 'no'::character varying NOT NULL,
  CONSTRAINT tunidad_cons_pkey PRIMARY KEY(id_unidad_constructiva),
  CONSTRAINT tunidad_constructiva_codigo_key UNIQUE(codigo),
  CONSTRAINT tunidad_constructiva__id_unidad_constructiva_fk FOREIGN KEY (id_unidad_constructiva_fk)
    REFERENCES pro.tunidad_constructiva(id_unidad_constructiva)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tunidad_constructiva_fk FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);

CREATE TABLE pro.tunidad_constructiva_plantilla (
  id_unidad_constructiva_plantilla SERIAL,
  codigo VARCHAR,
  nombre VARCHAR,
  descripcion VARCHAR,
  id_unidad_constructiva_plantilla_fk INTEGER,
  activo VARCHAR(2) DEFAULT 'no'::character varying NOT NULL,
  CONSTRAINT tunidad_constructiva_plantilla_codigo_key UNIQUE(codigo),
  CONSTRAINT tunidad_constructiva_plantilla_tunidad_cons_pkey PRIMARY KEY(id_unidad_constructiva_plantilla),
  CONSTRAINT tunidad_constructiva_plantilla__id_unidad_constructiva_plant_fk FOREIGN KEY (id_unidad_constructiva_plantilla_fk)
    REFERENCES pro.tunidad_constructiva_plantilla(id_unidad_constructiva_plantilla)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_unidad_constructiva INTEGER;

COMMENT ON COLUMN pro.tinvitacion_det.id_unidad_constructiva
IS 'Id de la unidad Constructiva a detalle puede ser la UC del concepto_ingas o una ramificacion del arbol de esta';

/***********************************F-SCP-EGS-PRO-8-31/07/2019****************************************/
/***********************************I-SCP-EGS-PRO-0-01/08/2019****************************************/
CREATE TABLE pro.tcomponente_macro (
  id_componente_macro SERIAL,
  nombre VARCHAR,
  descripcion VARCHAR,
  id_proyecto INTEGER,
  CONSTRAINT tcomponente_macro_pkey PRIMARY KEY(id_componente_macro),
  CONSTRAINT tcomponente_macro_fk_id_proyecto FOREIGN KEY (id_proyecto)
    REFERENCES pro.tproyecto(id_proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);

CREATE TABLE pro.tcomponente_concepto_ingas (
  id_componente_concepto_ingas SERIAL,
  id_concepto_ingas INTEGER,
  id_componente_macro INTEGER,
  CONSTRAINT tcomp_concepto_ingas_pkey PRIMARY KEY(id_componente_concepto_ingas),
  CONSTRAINT tcomp_concepto_ingas_fk_id_componente_macro FOREIGN KEY (id_componente_macro)
    REFERENCES pro.tcomponente_macro(id_componente_macro)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);

CREATE TABLE pro.tcomponente_concepto_ingas_det (
  id_componente_concepto_ingas_det SERIAL,
  id_concepto_ingas_det INTEGER,
  id_componente_concepto_ingas INTEGER,
  cantidad_est NUMERIC(18,0),
  precio NUMERIC(18,2),
  id_unidad_constructiva INTEGER,
  CONSTRAINT tcomp_concepto_ingas_det_pkey PRIMARY KEY(id_componente_concepto_ingas_det),
  CONSTRAINT tcomponente_concepto_ingas_det_fk_id_componente_concepto_ingas FOREIGN KEY (id_componente_concepto_ingas)
    REFERENCES pro.tcomponente_concepto_ingas(id_componente_concepto_ingas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE,
  CONSTRAINT tcomponente_concepto_ingas_det_fk_id_concepto_ingas FOREIGN KEY (id_concepto_ingas_det)
    REFERENCES param.tconcepto_ingas_det(id_concepto_ingas_det)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);
/***********************************F-SCP-EGS-PRO-8-01/08/2019****************************************/
/***********************************I-SCP-EGS-PRO-9-14/08/2019****************************************/
   ALTER TABLE pro.tcomponente_concepto_ingas_det
  ADD COLUMN aislacion VARCHAR;
  ALTER TABLE pro.tcomponente_concepto_ingas_det
  ADD COLUMN tension VARCHAR;
  ALTER TABLE pro.tcomponente_concepto_ingas_det
  ADD COLUMN peso NUMERIC(18,2);
/***********************************F-SCP-EGS-PRO-9-14/08/2019****************************************/
/***********************************I-SCP-EGS-PRO-10-14/08/2019****************************************/
CREATE TABLE pro.tunidad_comingdet (
  id_unidad_comingdet SERIAL,
  id_unidad_constructiva INTEGER,
  id_componente_concepto_ingas_det INTEGER,
  cantidad_asignada NUMERIC(18,2),
  CONSTRAINT tunidad_coingdet_pkey PRIMARY KEY(id_unidad_comingdet),
  CONSTRAINT tunidad_comingdet_fk FOREIGN KEY (id_componente_concepto_ingas_det)
    REFERENCES pro.tcomponente_concepto_ingas_det(id_componente_concepto_ingas_det)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE
) INHERITS (pxp.tbase)
WITH (oids = false);
/***********************************F-SCP-EGS-PRO-10-14/08/2019****************************************/

/***********************************I-SCP-EGS-PRO-11-30/08/2019****************************************/

ALTER TABLE pro.tinvitacion_det
  ADD COLUMN id_componente_concepto_ingas_det INTEGER;

COMMENT ON COLUMN pro.tinvitacion_det.id_componente_concepto_ingas_det
IS 'id de la lista de detalles aprobados n la planificacion';

/***********************************F-SCP-EGS-PRO-11-30/08/2019****************************************/

