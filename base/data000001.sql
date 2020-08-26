/***********************************I-DAT-RCM-PRO-1-30/08/2017****************************************/
INSERT INTO segu.tsubsistema ("codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta", "id_subsis_orig")
VALUES (E'PRO', E'Sistema de Proyectos', E'2017-08-30', E'PRO', E'activo', E'proyectos', NULL);

-----------------------------------
--DEFINICION DE INTERFACES
-----------------------------------
select pxp.f_insert_tgui ('PROYECTOS', '', 'PRO_1', 'si',1 , '', 1, '../../../lib/imagenes/alma32x32.png', '', 'PRO');
select pxp.f_insert_tgui ('Cierre', 'Cierre de Proyectos', 'PRO_1.1', 'si', 1, '', 2, '', '', 'PRO');
select pxp.f_insert_tgui ('Proyectos', '', 'PRO_1.1.1', 'si', 1, 'sis_proyectos/vista/proyecto/ProyectoCierre.php', 2, '', 'ProyectoCierre', 'PRO');

select pxp.f_insert_testructura_gui ('PRO_1', 'SISTEMA');
select pxp.f_insert_testructura_gui ('PRO_1.1', 'PRO_1');
select pxp.f_insert_testructura_gui ('PRO_1.1.1', 'PRO_1.1');
/***********************************F-DAT-RCM-PRO-1-30/08/2017****************************************/

/***********************************I-DAT-RCM-PRO-1-28/09/2017****************************************/
select pxp.f_insert_tgui ('Gestión de Proyectos', 'Gestión de proyectos', 'PRO_1.2', 'si', 1, 'sis_proyectos/vista/proyecto/Proyecto.php', 2, '', 'ProyectoPr', 'PRO');
select pxp.f_insert_testructura_gui ('PRO_1.2', 'PRO_1');
/***********************************F-DAT-RCM-PRO-1-28/09/2017****************************************/

/***********************************I-DAT-RCM-PRO-1-15/08/2018****************************************/
select pxp.f_insert_tgui ('Plantilla de Proyectos', 'Plantilla de proyectos', 'PRO_1.3', 'si', 2, 'sis_proyectos/vista/fase_plantilla/FasePlantilla.php', 2, '', 'FasePlantilla', 'PRO');
select pxp.f_insert_testructura_gui ('PRO_1.3', 'PRO_1');
/***********************************F-DAT-RCM-PRO-1-15/08/2018****************************************/

/***********************************I-DAT-RCM-PRO-1-27/08/2018****************************************/
select pxp.f_add_catalog('PRO','tinvitacion_det__tipo','Planificado','planif');
select pxp.f_add_catalog('PRO','tinvitacion_det__tipo','No Planificado','no_planif');
/***********************************F-DAT-RCM-PRO-1-27/08/2018****************************************/

/***********************************I-DAT-RCM-PRO-1-21/11/2018****************************************/
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'py_compras_dias_venc', E'60', E'Cantidad de días para recordatorio de lanzamiento');
/***********************************F-DAT-RCM-PRO-1-21/11/2018****************************************/

/***********************************I-DAT-EGS-PRO-0-26/11/2018****************************************/

INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'tipo_proceso_macro_proyectos', E'INV,PPY,PFA', E' invitaciones,planificacion,fases  codigos de tipo de procesos del sistema de proyectos');
/***********************************F-DAT-EGS-PRO-0-26/11/2018****************************************/

/***********************************I-DAT-EGS-PRO-1-26/11/2018****************************************/

select wf.f_import_tproceso_macro ('insert','PP', 'PRO', 'Planificación Proyectos','');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','PPY',NULL,NULL,'PP','Planificación de Proyectos','pro.tproyecto','id_proyecto','si','','','','PPY',NULL);
select wf.f_import_ttipo_estado ('insert','nuevo','PPY','Nuevo','si','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','ejecucion','PPY','En Ejecución','no','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','cierre','PPY','En Cierre','no','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','PPY','Finalizado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_documento ('delete','DOCRES','PPY',NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_documento ('insert','NOR30','PPY','Norma 30','','','escaneado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','CRONO','PPY','Cronograma','','','escaneado',2.00,'{}');
select wf.f_import_ttipo_documento ('insert','TRALI','PPY','Trazo Linea','','','escaneado',3.00,'{}');
select wf.f_import_ttipo_documento ('insert','DIAUN','PPY','Diagrama Unifilar','','','escaneado',4.00,'{}');
select wf.f_import_ttipo_documento ('insert','PRESU','PPY','Presupuesto','','','escaneado',5.00,'{}');
select wf.f_import_ttipo_documento ('insert','AVFIS','PPY','Avance Fisico','','','escaneado',6.00,'{}');
select wf.f_import_ttipo_documento ('insert','RESEJ','PPY','Resumen Ejecutivo','','','escaneado',7.00,'{}');
select wf.f_import_ttipo_documento ('insert','PREPT','PPY','Presentacion PPT','','','escaneado',8.00,'{}');
select wf.f_import_ttipo_documento ('insert','STEA','PPY','STEA','','','escaneado',8.00,'{}');
select wf.f_import_ttipo_documento ('insert','LICAM','PPY','Licencia Ambiental','','','escaneado',9.00,'{}');
select wf.f_import_ttipo_documento ('insert','REPFO','PPY','Reporte Fotografico','','','escaneado',10.00,'{}');
select wf.f_import_ttipo_documento ('insert','NOR11','PPY','Norma 11','','','escaneado',11.00,'{}');
select wf.f_import_testructura_estado ('insert','nuevo','ejecucion','PPY',1,'');
select wf.f_import_testructura_estado ('insert','ejecucion','cierre','PPY',1,'');
select wf.f_import_testructura_estado ('insert','cierre','finalizado','PPY',1,'');




select wf.f_import_tproceso_macro ('insert','PFA', 'PRO', 'Proyecto Fases','');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','PFA',NULL,NULL,'PFA','Fases','pro.tfase','id_fase','si','','','','PFA',NULL);
select wf.f_import_ttipo_estado ('insert','nuevo','PFA','Nuevo','si','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','ejecucion','PFA','En Ejecución','no','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','PFA','Finalizado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_documento ('delete','ANEXOSPROV','PFA',NULL,NULL,NULL,NULL,NULL,NULL);
select wf.f_import_ttipo_documento ('insert','AVFISF','PFA','Avance Fisico','','','escaneado',1.00,'{}');
select wf.f_import_ttipo_documento ('insert','CRONOF','PFA','Cronograma','','','escaneado',2.00,'{}');
select wf.f_import_ttipo_documento ('insert','PREPTF','PFA','Presentacion PPT','','','escaneado',3.00,'{}');
select wf.f_import_testructura_estado ('insert','nuevo','ejecucion','PFA',1,'');
select wf.f_import_testructura_estado ('insert','ejecucion','finalizado','PFA',1,'');

select wf.f_import_tproceso_macro ('insert','PRO', 'PRO', 'Sistema de Proyectos','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','INV',NULL,NULL,'PRO','Invitaciones','','','si','','','','INV',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','INV','Borrador','si','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','vobo','INV','VoBo','no','no','no','funcion_listado','pro.f_lista_funcionario_wf','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','sol_compra','INV','sol_compra','no','no','no','funcion_listado','pro.f_lista_funcionario_wf','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','INV','Finalizado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','vobo','INV',1,'');
select wf.f_import_testructura_estado ('insert','vobo','sol_compra','INV',1,'');
select wf.f_import_testructura_estado ('insert','sol_compra','finalizado','INV',1,'');
/***********************************F-DAT-EGS-PRO-1-26/11/2018****************************************/

/***********************************I-DAT-RCM-PRO-1-10/12/2018****************************************/
INSERT INTO pxp.variable_global ("variable", "valor", "descripcion")
VALUES
  (E'py_gen_presolicitud', E'si', E'Define si la Invitación de Proyectos generará Presolicitud en vez de Solicitud');
/***********************************F-DAT-RCM-PRO-1-10/12/2018****************************************/

/***********************************I-DAT-EGS-PRO-2-24/12/2018****************************************/

INSERT INTO param.tunidad_medida ("id_usuario_reg", "codigo", "descripcion", "tipo")
VALUES
  (1, E'Tn', E'Tonelada', E'Masa');
/***********************************F-DAT-EGS-PRO-2-24/12/2018****************************************/

/***********************************I-DAT-EGS-PRO-3-01/08/2018****************************************/
select pxp.f_insert_tgui ('Plantilla Unidades Constructivas', 'Plantilla Unidades Constructivas', 'UCPLA', 'si', 5, 'sis_proyectos/vista/unidad_constructiva_plantilla/UnidadConstructivaPlantilla.php', 2, '', 'UnidadConstructivaPlantilla', 'PRO');
/***********************************F-DAT-EGS-PRO-3-01/08/2018****************************************/

/***********************************I-DAT-EGS-PRO-4-01/08/2018****************************************/

select pxp.f_insert_tgui ('Configuraciones', 'Configuraciones', 'CFGPRO', 'si', 1, '', 2, '', '', 'PRO');
select pxp.f_insert_tgui ('Concepto Ingre/Gasto', 'Concepto Ingreso/Gasto', 'CIGPRO', 'si', 1, 'sis_proyectos/vista/componente_concepto_ingas/ConceptoIngasPro.php', 3, '', 'ConceptoIngasPro', 'PRO');

/***********************************F-DAT-EGS-PRO-4-01/08/2018****************************************/

/***********************************I-DAT-EGS-PRO-5-14/08/2019****************************************/
INSERT INTO param.tcolumna ("id_usuario_reg", "estado_reg", "nombre_columna", "tipo_dato")
VALUES
  (1, E'activo', E'aislacion', E'varchar'),
  (1, E'activo', E'tension', E'varchar'),
  (1, E'activo', E'peso', E'numeric');
/***********************************F-DAT-EGS-PRO-5-14/08/2019****************************************/

/***********************************I-DAT-RCM-PRO-18-02/09/2019****************************************/
select conta.f_import_ttipo_relacion_contable ('insert','PRO-CIECB3NEG',NULL,'Cierre Proyectos Cbte 3 saldos negativos','activo','no','si','no','flujo_presupuestaria','recurso_gasto','no','no','no',NULL);
/***********************************F-DAT-RCM-PRO-18-02/09/2019****************************************/
/***********************************I-DAT-EGS-PRO-6-05/09/2019****************************************/
select param.f_import_tcatalogo_tipo ('insert','tcomponente_macro_tipo','PRO','tcomponente_macro');
select param.f_import_tcatalogo ('insert','PRO','Subestacion','tsubestacion','tcomponente_macro_tipo');
select param.f_import_tcatalogo ('insert','PRO','Linea','tlinea','tcomponente_macro_tipo');
/***********************************F-DAT-EGS-PRO-6-05/09/2019****************************************/
/***********************************I-DAT-EGS-PRO-7-18/09/2019****************************************/
select pxp.f_insert_tgui ('Parametros (Catalogos)', 'Parametros (Catalogos)', 'CATAPRO', 'si', 2, 'sis_proyectos/vista/catalogo/CatalogoTipoPro.php', 3, '', 'CatalogoTipoPro', 'PRO');
/***********************************F-DAT-EGS-PRO-7-18/09/2019****************************************/
/***********************************I-DAT-EGS-PRO-8-18/09/2019****************************************/
select param.f_import_tcatalogo_tipo ('insert','ttipo_configuracion','PRO','tunidad_constructiva');
select param.f_import_tcatalogo ('insert','PRO','Doble Terna','doble_terna','ttipo_configuracion');
select param.f_import_tcatalogo ('insert','PRO','Simple Terna','simple_terna','ttipo_configuracion');
select param.f_import_tcatalogo ('insert','PRO','Doble Terna Incompleta','doble_terna_inc','ttipo_configuracion');

select param.f_import_tcatalogo_tipo ('insert','tipo_tension','PRO','tunidad_constructiva');
select param.f_import_tcatalogo ('insert','PRO','69kV','69kV','tipo_tension');
select param.f_import_tcatalogo ('insert','PRO','115kV','115kV','tipo_tension');
select param.f_import_tcatalogo ('insert','PRO','132kV','132kV','tipo_tension');
select param.f_import_tcatalogo ('insert','PRO','230kV','230kV','tipo_tension');
select param.f_import_tcatalogo ('insert','PRO','500kV','500kV','tipo_tension');

select pxp.f_insert_tgui ('Unidades Constructivas Tipo', 'Unidades Constructivas Tipo', 'UCT', 'si', 3, 'sis_proyectos/vista/unidad_constructiva_tipo/UnidadConstructivaTipo.php', 3, '', 'UnidadConstructivaTipo', 'PRO');

/***********************************F-DAT-EGS-PRO-8-18/09/2019****************************************/
/***********************************I-DAT-EGS-PRO-9-26/09/2019****************************************/
INSERT INTO param.tcolumna ("id_usuario_reg", "estado_reg", "nombre_columna", "tipo_dato")
VALUES
  (1, E'activo', E'tipo_configuracion', E'varchar'),
  (1, E'activo', E'id_unidad_medida', E'integer'),
  (1, E'activo', E'conductor', E'varchar');

/***********************************F-DAT-EGS-PRO-9-26/09/2019****************************************/
/***********************************I-DAT-EGS-PRO-10-17/10/2019****************************************/
--Flujo WF de concepto detalle
select wf.f_import_tproceso_macro ('insert','PLADET', 'PRO', 'Proyectos Planificacion Detalle','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','PLADET',NULL,NULL,'PLADET','Planificacion Detalle','','','si','','','','PLADET',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','PLADET','Borrador','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','PLADET','aprobado','no','no','si','listado','','anterior','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','aprobado','PLADET',1,'');
---Actualizacion de variable global
UPDATE pxp.variable_global SET
valor = 'INV,PPY,PFA,PLADET',
descripcion =' invitaciones,planificacion,fases,planificacion detalle  codigos de tipo de procesos del sistema de proyectos'
WHERE variable = 'tipo_proceso_macro_proyectos';
/***********************************F-DAT-EGS-PRO-10-17/10/2019****************************************/

/***********************************I-DAT-RCM-PRO-51-06/01/2020****************************************/
select pxp.f_insert_tgui ('Excluir Cuentas Contables', 'Excluir Cuentas Contables', 'CUEEXC', 'si', 4, 'sis_proyectos/vista/cuenta_excluir/CuentaExcluir.php', 3, '', 'CuentaExcluir', 'PRO');
select pxp.f_insert_testructura_gui ('CUEEXC', 'CFGPRO');
/***********************************F-DAT-RCM-PRO-51-06/01/2020****************************************/

/***********************************I-DAT-RCM-PRO-60-29/07/2020****************************************/
select conta.f_import_tplantilla_comprobante ('insert','PRO-CIE3V2','pro.f_gestionar_cbte_proyecto_cierre_eliminacion','id_proyecto','PRO','{$tabla.glosa_cbte}','pro.f_gestionar_cbte_proyecto_cierre','{$tabla.fecha_fin}','activo','ENDE TRANSMISION S.A.','{$tabla.id_depto_conta}','contable','','pro.v_cbte_cierre_proy_3','DIARIOCON','{$tabla.id_moneda}','{$tabla.id_gestion}','{$tabla.id_proyecto},{$tabla.id_depto_conta}','no','no','no','','','','','{$tabla.nro_tramite_cierre}','','','','','','Comprobante de Redistribución por AITB de gestiones pasadas al cierre del proyecto','','','','','');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PRO-CIE3V2','Debe','debe','no','si','','{$tabla.denominacion}','CIEPRO','','{$tabla.importe_actualiz}','{$tabla.id_clasificacion}','','no','','','','si','','id_proyecto','','Activos','{$tabla.importe_actualiz}',NULL,'simple','','','no','','','','','','','','2','','pro.v_cbte_cierre_proy_3_debe_detV3',NULL,'','CCDEPCON','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PRO-CIE3V2','GASTO','debe','no','si','','{$tabla.denominacion}','PRO-CIEGANT','','{$tabla.importe_actualiz}','{$tabla.id_clasificacion}','','no','','','','si','','id_proyecto','','Importe que no se activa, sino se va al gasto','{$tabla.importe_actualiz}',NULL,'simple','','','no','','','','','','','','2','','pro.v_cbte_cierre_proy_3_gasto_debe_detV3',NULL,'','CCDEPCON','','','todos','','si');
select conta.f_import_tdetalle_plantilla_comprobante ('insert','PRO-CIE3V2','Haber','haber','no','si','','','PRO-CIEREV','{$tabla.id_cuenta}','{$tabla.importe}','','','no','{$tabla.id_centro_costo}','','','si','','id_proyecto','','Reversión actualización','{$tabla.importe}',NULL,'simple','','','no','','','','','','','','2','','pro.v_cbte_cierre_proy_3_haber_det_V2',NULL,'','','','','todos','','si');
/***********************************F-DAT-RCM-PRO-60-29/07/2020****************************************/