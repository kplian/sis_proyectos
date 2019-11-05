--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_inserta_orden_trabajo (
  p_administrador integer,
  p_id_usuario integer,
  p_id_unidad_constructiva integer
)
RETURNS varchar AS
$body$
/*
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.f_inserta_orden_trabajo
 DESCRIPCION:   Creacion inserta ordenes de trabajo para una solicitud o presolicitud
 AUTOR:          (eddy.gutierrez)
 FECHA:
 COMENTARIOS:
***************************************************************************
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
   #0                 24/10/2019          EGS                  CREACION
 ***************************************************************************/
 */

DECLARE

    v_nombre_funcion            text;
    v_resp                      varchar;
    v_mensaje                   varchar;
    v_codigo_trans              varchar;
    v_parametros                record;
    v_tabla                     varchar;
    v_sequence                  integer;
    v_codigo_ot                 varchar;
    v_id_orden_trabajo          varchar[];


BEGIN

     v_nombre_funcion = 'pro.f_inserta_orden_trabajo';
            SELECT
                uc.codigo
            INTO
                v_codigo_ot
            FROM pro.tunidad_constructiva uc
            WHERE uc.id_unidad_constructiva = p_id_unidad_constructiva;

             v_codigo_trans = 'CONTA_ODT_INS';

             --recuperamos el id
             SELECT last_value
             INTO v_sequence
             FROM conta.torden_trabajo_id_orden_trabajo_seq;
             --no usamos next value por que aplica el aumento del id en el moment que recuperamos el valor de la id
            --SELECT nextval('conta.torden_trabajo_id_orden_trabajo_seq') into v_sequence;
             v_sequence=v_sequence+1;
             v_codigo_ot= 'OT-'||v_sequence::varchar;

              --crear tabla
              v_tabla = pxp.f_crear_parametro(ARRAY[

                                  'fecha_final',
                                  'fecha_inicio',
                                  'desc_orden',
                                  'motivo_orden',
                                  'codigo',
                                  'tipo',
                                  'movimiento',
                                  'id_orden_trabajo_fk'
                                  ],
                              ARRAY[
                                  ''::varchar,--fecha_final
                                  now()::varchar,--fecha_inicio
                                  v_codigo_ot::varchar,--desc_orden
                                  ''::varchar,--motivo_orden
                                  v_codigo_ot::varchar,--codigo
                                  'estadistica'::varchar,--tipo
                                  'si'::varchar,--movimiento
                                  ''::varchar--id_orden_trabajo_fk
                                  ],
                              ARRAY[
                                  'date',--fecha_final
                                  'date',--fecha_inicio
                                  'varchar',--desc_orden
                                  'varchar',--motivo_orden
                                  'varchar',--codigo
                                  'varchar',--tipo
                                  'varchar',--movimiento
                                  'int4'--id_orden_trabajo_fk
                                 ]
                              );


              v_resp = conta.f_orden_trabajo_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
              v_id_orden_trabajo  = pxp.f_recupera_clave(v_resp,'id_orden_trabajo');

              UPDATE pro.tunidad_constructiva SET
                        id_orden_trabajo = v_id_orden_trabajo[1]::INTEGER
              WHERE  id_unidad_constructiva = p_id_unidad_constructiva;

     RETURN   v_resp;

EXCEPTION

    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
            v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
            raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;