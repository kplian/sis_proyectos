--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_reportes_planificacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.f_reportes_planificacion_sel
 DESCRIPCION:   Funcion para los diferentes reportes de proyectos
 AUTOR:          (EGS)
 FECHA:            11/10/2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE            FECHA:            AUTOR:                    DESCRIPCION:

***************************************************************************/

DECLARE

    v_consulta                 VARCHAR;
    v_nro_requerimiento        integer;
    v_parametros               record;
    v_resp                     varchar;
    v_nombre_funcion           text;
    v_mensaje_error            text;
    v_record                   record;
    v_record_coing             record;
    v_record_coingd            record;
    v_agrupador                integer;
    v_id_concepto_ingas    integer;
    v_id_concepto_ingas_det    integer;

BEGIN

    v_nombre_funcion = 'pro.f_reportes_planificacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PlAINI_SEL'
     #DESCRIPCION:    Reporte de planificacion inicial
     #AUTOR:        EGS
     #FECHA:        14/12/2018
    ***********************************/

    if(p_transaccion='PRO_PlAINI_SEL')then

        begin
            --v_parametros.filtro='cm.id_componente_macro = 38 ';
            CREATE TEMPORARY TABLE temp(
              id    SERIAL,
              agrupador  INTEGER,
              es_agrupador VARCHAR,
              id_concepto_ingas_det_fk INTEGER,
              id_componente_concepto_ingas_det INTEGER,
              id_concepto_ingas_det INTEGER,
              desc_coingd   VARCHAR,
              desc_unidad_medida VARCHAR,
              cantidad_est NUMERIC,
              f_desadeanizacion NUMERIC,
              precio NUMERIC,
              f_escala_xfd_montaje NUMERIC,
              precio_montaje NUMERIC,
              f_escala_xfd_obra_civil NUMERIC,
              precio_obra_civil NUMERIC,
              precio_prueba NUMERIC,
              total NUMERIC,
              id_concepto_ingas INTEGER
              ) ON COMMIT DROP;

        v_agrupador = 0;
        v_id_concepto_ingas = 0;
        v_id_concepto_ingas_det=0;
        v_consulta = 'SELECT
              comcig.id_concepto_ingas,
              cigd.id_concepto_ingas_det_fk,
              comind.id_componente_concepto_ingas_det,
              comind.id_concepto_ingas_det,
              cigd.nombre as  desc_coingd,
              comind.id_unidad_medida,
              um.codigo as desc_unidad_medida,
              comind.cantidad_est,
              comind.f_desadeanizacion,
              comind.precio,
              comind.f_escala_xfd_montaje,
              comind.precio_montaje,
              comind.f_escala_xfd_obra_civil,
              comind.precio_obra_civil,
              comind.precio_prueba,
              (COALESCE(comind.cantidad_est,0)*((COALESCE(comind.f_desadeanizacion,0)*COALESCE(comind.precio,0))+(COALESCE(comind.f_escala_xfd_montaje,0)*COALESCE(comind.precio_montaje,0))+(COALESCE(comind.f_escala_xfd_obra_civil,0)*COALESCE(comind.precio_obra_civil,0))+COALESCE(comind.precio_prueba,0))) as total
          FROM pro.tcomponente_concepto_ingas_det comind
          LEFT JOIN pro.tcomponente_concepto_ingas comcig on comcig.id_componente_concepto_ingas =  comind.id_componente_concepto_ingas
          LEFT JOIN pro.tcomponente_macro cm on cm.id_componente_macro = comcig.id_componente_macro
          LEFT JOIN param.tconcepto_ingas_det cigd on cigd.id_concepto_ingas_det = comind.id_concepto_ingas_det
          LEFT JOIN param.tunidad_medida um on um.id_unidad_medida = comind.id_unidad_medida
          WHERE '||v_parametros.filtro||'
          ORDER BY comcig.id_concepto_ingas  ASC, cigd.id_concepto_ingas_det_fk ASC NULLS FIRST ,um.codigo ASC
          ';
        FOR v_record IN EXECUTE(
             v_consulta
        )LOOP
            --si no existe un agrupador se agrupa por concepto
            IF v_record.id_concepto_ingas_det_fk is null THEN
                SELECT
                    cig.id_concepto_ingas,
                    cig.desc_ingas
                INTO
                    v_record_coing
                FROM param.tconcepto_ingas cig
                WHERE cig.id_concepto_ingas = v_record.id_concepto_ingas ;

                --Ingresamos el concepto como agrupador
                IF v_id_concepto_ingas <> v_record_coing.id_concepto_ingas THEN
                    v_agrupador = v_agrupador + 1;
                    INSERT INTO  temp (
                                  agrupador,
                                  es_agrupador,
                                  id_concepto_ingas,
                                  desc_coingd
                                  ) values(
                                  v_agrupador,
                                  'si',
                                  v_record.id_concepto_ingas,
                                  v_record_coing.desc_ingas

                                );
                    v_id_concepto_ingas = v_record_coing.id_concepto_ingas;
                END IF;

            ELSE

                SELECT
                    cigd.id_concepto_ingas_det,
                    cigd.nombre
                INTO
                    v_record_coingd
                FROM param.tconcepto_ingas_det cigd
                WHERE cigd.id_concepto_ingas_det = v_record.id_concepto_ingas_det_fk ;

                --Ingresamos el concepto detalle que es agrupador
                IF v_id_concepto_ingas_det <> v_record_coingd.id_concepto_ingas_det THEN
                    v_agrupador = v_agrupador + 1;
                    INSERT INTO  temp (
                                  agrupador,
                                  es_agrupador,
                                  id_concepto_ingas,
                                  desc_coingd
                                  ) values(
                                  v_agrupador,
                                  'si',
                                  v_record.id_concepto_ingas,
                                  v_record_coingd.nombre

                                );
                    v_id_concepto_ingas_det = v_record_coingd.id_concepto_ingas_det;
                END IF;
            END IF;

                INSERT INTO temp   (
                          agrupador,
                          es_agrupador,
                          id_concepto_ingas,
                          desc_coingd,
                          desc_unidad_medida,
                          cantidad_est,
                          f_desadeanizacion,
                          precio,
                          f_escala_xfd_montaje,
                          precio_montaje,
                          f_escala_xfd_obra_civil,
                          precio_obra_civil,
                          precio_prueba,
                          total
                              ) values(
                          v_agrupador,
                          'no',
                          v_record.id_concepto_ingas,
                          v_record.desc_coingd,
                          v_record.desc_unidad_medida,
                          v_record.cantidad_est,
                          v_record.f_desadeanizacion,
                          v_record.precio,
                          v_record.f_escala_xfd_montaje,
                          v_record.precio_montaje,
                          v_record.f_escala_xfd_obra_civil,
                          v_record.precio_obra_civil,
                          v_record.precio_prueba,
                          v_record.total
                            );

        END LOOP;
           v_consulta ='
           SELECT
                t.agrupador,
                t.es_agrupador,
                t.id_concepto_ingas,
                t.desc_coingd,
                t.desc_unidad_medida,
                t.cantidad_est,
                t.f_desadeanizacion,
                t.precio,
                t.f_escala_xfd_montaje,
                t.precio_montaje,
                t.f_escala_xfd_obra_civil,
                t.precio_obra_civil,
                t.precio_prueba,
                t.total
            FROM temp t
            ORDER BY t.id , t.agrupador ASC';


            RETURN v_consulta ;
        end;

    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

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