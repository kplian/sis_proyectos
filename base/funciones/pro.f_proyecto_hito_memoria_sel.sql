--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_proyecto_hito_memoria_sel (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       pro.f_proyecto_hito_memoria

 DESCRIPCION:
 AUTOR:
 FECHA:
 COMENTARIOS:

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:
  #1                14/10/2020                EGS                    Creacion
 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/


DECLARE


    v_parametros                record;
    v_nombre_funcion            text;
    v_resp                      varchar;
    v_consulta            VARCHAR;
    v_array                VARCHAR[];
    v_mes                   varchar;
    v_importe_real          varchar;
    v_importe_plan          varchar;
    v_registros             record;
    v_record                RECORD;
    v_id                    integer;
    v_id_real               integer;

BEGIN



    v_nombre_funcion = 'pro.f_proyecto_hito_memoria';


    v_parametros = pxp.f_get_record(p_tabla);


    /*********************************
      #TRANSACCION:  'PRO_PROHITMEN_SEL'
      #DESCRIPCION:    Consulta de datos
      #AUTOR:        egutierrez
      #FECHA:        28-09-2020 20:15:06
     ***********************************/

    IF (p_transaccion='PRO_PROHITMEN_SEL') THEN

        BEGIN

            CREATE TEMPORARY TABLE temp_id(
                                              id serial,
                                              codigo VARCHAR,
                                              importe varchar,
                                              enero varchar,
                                              febrero varchar,
                                              marzo varchar,
                                              abril varchar,
                                              mayo varchar,
                                              junio varchar,
                                              julio varchar,
                                              agosto varchar,
                                              septiembre varchar,
                                              octubre varchar,
                                              noviembre varchar,
                                              diciembre varchar
            ) ON COMMIT DROP;




            FOR v_record IN(
                SELECT
                    DISTINCT(t.codigo)
                FROM pro.tproyecto_hito t
                WHERE date_part('year',t.fecha_plan) = v_parametros.gestion and t.id_proyecto = v_parametros.id_proyecto
                ORDER BY t.codigo ASC
            )LOOP
                    INSERT INTO temp_id(
                        codigo,
                        importe
                    )VALUES(

                               v_record.codigo,
                               'Importe Plan'

                           )RETURNING id into v_id;

                    INSERT INTO temp_id(
                        codigo,
                        importe
                    )VALUES(

                               v_record.codigo,
                               'Importe Real'

                           )RETURNING id into v_id_real;

                    v_mes = 'enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre';

                    v_array = string_to_array(v_mes,',');

                    For i in 1 ..array_length(v_array, 1) loop
                            --en dat[i] ir teniendo cada elemento

                            SELECT
                                t.importe_plan
                            INTO
                                v_importe_plan
                            FROM pro.tproyecto_hito t
                            where date_part('month',t.fecha_plan) = i
                              and date_part('year',t.fecha_plan) = v_parametros.gestion
                              and t.id_proyecto = v_parametros.id_proyecto
                              and t.codigo = v_record.codigo;


                            SELECT
                                t.importe_real
                            INTO
                                v_importe_real
                            FROM pro.tproyecto_hito t
                            where date_part('month',t.fecha_real) = i
                              and date_part('year',t.fecha_plan) = v_parametros.gestion
                              and t.id_proyecto = v_parametros.id_proyecto
                              and t.codigo = v_record.codigo;

                            v_consulta ='UPDATE temp_id SET
                                    '||v_array[i]||' = '||COALESCE(v_importe_plan,'''''')||'
                                  WHERE id = '||v_id||'; ';

                            execute (v_consulta);
                            v_consulta='UPDATE temp_id SET
                                    '||v_array[i]||' = '||COALESCE(v_importe_real,'''''')||'
                                  WHERE id = '||v_id_real||'; ';
                            execute (v_consulta);

                        End loop;



                END LOOP;

            v_consulta='SELECT
                        t.id,
                        t.codigo,
                        t.importe,
                        t.enero,
                        t.febrero,
                        t.marzo,
                        t.abril,
                        t.mayo,
                        t.junio,
                        t.julio,
                        t.agosto,
                        t.septiembre,
                        t.octubre,
                        t.noviembre,
                        t.diciembre
                        FROM temp_id t ';
            If pxp.f_existe_parametro(p_tabla, 'groupBy') THEN

                IF v_parametros.groupBy = 'codigo' THEN
                    v_consulta:=v_consulta||' order by t.codigo ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;

                ELSE

                    v_consulta:=v_consulta||' order by ' ||v_parametros.groupBy|| ' ' ||v_parametros.groupDir|| ', ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
                END IF;
            Else
                v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' OFFSET ' || v_parametros.puntero;
            End If;

            --Devuelve la respuesta
            FOR v_registros in execute (
                v_consulta
                ) LOOP
                    RETURN NEXT v_registros;
                END LOOP;

        END;


    ELSE

        RAISE EXCEPTION 'Transaccion inexistente';

    END IF;

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