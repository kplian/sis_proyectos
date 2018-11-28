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
select wf.f_import_ttipo_estado ('insert','vobo','INV','VoBo','no','no','no','todos','','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','sol_compra','INV','sol_compra','no','no','no','todos','','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','finalizado','INV','Finalizado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);

/***********************************F-DAT-EGS-PRO-1-26/11/2018****************************************/
