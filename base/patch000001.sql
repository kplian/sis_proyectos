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