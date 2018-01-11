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