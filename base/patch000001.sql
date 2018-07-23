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
IS 'Moneda base para el proyecto';

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