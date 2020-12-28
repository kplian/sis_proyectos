--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_analisis_diferido_sel (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.f_analisis_diferido_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_concepto_ingas_pago'
 AUTOR:          (eddy.gutierrez)
 FECHA:            14-12-2018 13:31:35
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                14-12-2018 13:31:35                                Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_concepto_ingas_pago'
 #MDID-11               29/10/2020          EGGS                Se sacan los saldos de los movimientos comtables
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_registros           record;
    v_saldo_activo        numeric;
    v_saldo_pasivo        numeric;
    v_saldo_ingreso        numeric;
    v_saldo_egreso        numeric;

BEGIN

    v_nombre_funcion = 'pro.f_analisis_diferido_sel';
    v_parametros = pxp.f_get_record(p_tabla);

/*********************************
     #TRANSACCION:  'PRO_ANADIF_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        eddy.gutierrez
     #FECHA:        14-12-2018 13:31:35
    ***********************************/

    if(p_transaccion='PRO_ANADIF_SEL')then

        begin

            CREATE TEMPORARY TABLE temp_id(
                                              id_proyecto_analisis integer,
                                              saldo_activo NUMERIC not null  DEFAULT 0,
                                              saldo_pasivo NUMERIC not null  DEFAULT 0,
                                              saldo_ingreso NUMERIC not null  DEFAULT 0,
                                              saldo_egreso NUMERIC not null  DEFAULT 0,
                                              saldo_activo_cbt NUMERIC not null  DEFAULT 0,
                                              saldo_pasivo_cbt NUMERIC not null  DEFAULT 0,
                                              saldo_ingreso_cbt NUMERIC not null  DEFAULT 0,
                                              saldo_egreso_cbt NUMERIC not null  DEFAULT 0,
                                              saldo_activo_cbtII NUMERIC not null  DEFAULT 0,
                                              saldo_pasivo_cbtII NUMERIC not null  DEFAULT 0,
                                              saldo_ingreso_cbtII NUMERIC not null  DEFAULT 0,
                                              saldo_egreso_cbtII NUMERIC not null  DEFAULT 0,
                                              saldo_activo_cbtIII NUMERIC not null  DEFAULT 0,
                                              saldo_pasivo_cbtIII NUMERIC not null  DEFAULT 0,
                                              saldo_ingreso_cbtIII NUMERIC not null  DEFAULT 0,
                                              saldo_egreso_cbtIII NUMERIC not null  DEFAULT 0
            ) ON COMMIT DROP;
            --insertamos los datos iniciales
            SELECT
                op_saldo_activo,
                op_saldo_pasivo,
                op_saldo_ingreso,
                op_saldo_egreso
            INTO
                v_saldo_activo,
                v_saldo_pasivo,
                v_saldo_ingreso,
                v_saldo_egreso

            from pro.f_get_saldo_analisis_diferido(v_parametros.id_proyecto_analisis,null);

            insert into temp_id(
                id_proyecto_analisis,
                saldo_activo,
                saldo_pasivo,
                saldo_ingreso,
                saldo_egreso

            )values(
                       v_parametros.id_proyecto_analisis,
                       v_saldo_activo,
                       v_saldo_pasivo,
                       v_saldo_ingreso,
                       v_saldo_egreso
                   );

            SELECT
                op_saldo_activo,
                op_saldo_pasivo,
                op_saldo_ingreso,
                op_saldo_egreso
            INTO
                v_saldo_activo,
                v_saldo_pasivo,
                v_saldo_ingreso,
                v_saldo_egreso

            from pro.f_get_saldo_analisis_diferido(v_parametros.id_proyecto_analisis,'cbt');
            UPDATE temp_id SET
                               saldo_activo_cbt = v_saldo_activo ,
                               saldo_pasivo_cbt = v_saldo_pasivo,
                               saldo_ingreso_cbt = v_saldo_ingreso,
                               saldo_egreso_cbt = v_saldo_egreso
            WHERE id_proyecto_analisis = v_parametros.id_proyecto_analisis;

            SELECT
                op_saldo_activo,
                op_saldo_pasivo,
                op_saldo_ingreso,
                op_saldo_egreso
            INTO
                v_saldo_activo,
                v_saldo_pasivo,
                v_saldo_ingreso,
                v_saldo_egreso

            from pro.f_get_saldo_analisis_diferido(v_parametros.id_proyecto_analisis,'cbtII');
            UPDATE temp_id SET
                               saldo_activo_cbtII = v_saldo_activo ,
                               saldo_pasivo_cbtII = v_saldo_pasivo,
                               saldo_ingreso_cbtII = v_saldo_ingreso,
                               saldo_egreso_cbtII = v_saldo_egreso
            WHERE id_proyecto_analisis = v_parametros.id_proyecto_analisis;

            SELECT
                op_saldo_activo,
                op_saldo_pasivo,
                op_saldo_ingreso,
                op_saldo_egreso
            INTO
                v_saldo_activo,
                v_saldo_pasivo,
                v_saldo_ingreso,
                v_saldo_egreso

            from pro.f_get_saldo_analisis_diferido(v_parametros.id_proyecto_analisis,'cbtIII');
            UPDATE temp_id SET
                               saldo_activo_cbtIII = v_saldo_activo ,
                               saldo_pasivo_cbtIII = v_saldo_pasivo,
                               saldo_ingreso_cbtIII = v_saldo_ingreso,
                               saldo_egreso_cbtIII = v_saldo_egreso
            WHERE id_proyecto_analisis = v_parametros.id_proyecto_analisis;


            --Sentencia de la consulta
            v_consulta:='
                  SELECT
                      id_proyecto_analisis,
                      saldo_activo ,
                      saldo_pasivo ,
                      saldo_ingreso ,
                      saldo_egreso ,
                      saldo_activo_cbt ,
                      saldo_pasivo_cbt ,
                      saldo_ingreso_cbt ,
                      saldo_egreso_cbt ,
                      saldo_activo_cbtII ,
                      saldo_pasivo_cbtII ,
                      saldo_ingreso_cbtII ,
                      saldo_egreso_cbtII ,
                      saldo_activo_cbtIII ,
                      saldo_pasivo_cbtIII ,
                      saldo_ingreso_cbtIII ,
                      saldo_egreso_cbtIII
                    FROM  temp_id p
                    WHERE  p.id_proyecto_analisis = '||v_parametros.id_proyecto_analisis||' ';

            --RAISE EXCEPTION 'v_consulta %',v_consulta;

            --Definicion de la respuesta
            --Devuelve la respuesta
            FOR v_registros in execute (
                v_consulta
                ) LOOP
                    RETURN NEXT v_registros;
                END LOOP;

        end;


    else

        raise exception 'Transaccion inexistente';

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
    COST 100 ROWS 1000;