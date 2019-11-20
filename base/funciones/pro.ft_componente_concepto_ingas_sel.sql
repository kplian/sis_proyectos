--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_componente_concepto_ingas_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_componente_concepto_ingas_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcomp_concepto_ingas'
 AUTOR: 		 (admin)
 FECHA:	        22-07-2019 14:49:24
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #17                22-07-2019 14:49:24    EGS                    Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcomp_concepto_ingas'
 #28                  16/09/2019           EGS                   Se agrega campo de pocentaje de prueba
 #34  EndeEtr          03/10/2019            EGS                 Se aumentaron los With para los totalizadores
 #35                    07/10/2019          EGS                  Se agrega lista de conceptos en combos
 #35 EndeEtr           10/10/2019            EGS                 Se agrega los factores la suma producto
 #47 EndeEtr            19/11/2019          EGS                  SSe agrega precio al combo
 ***************************************************************************/

DECLARE

    v_consulta              varchar;
    v_parametros            record;
    v_nombre_funcion        text;
    v_resp                  varchar;
    v_record                record;
    v_conceptos             varchar;
    v_record_cig            record;
    v_consulta_t            varchar;
    v_id_proyecto           INTEGER;
    v_precio_total_det      NUMERIC;
    v_consulta_p            varchar;
BEGIN

    v_nombre_funcion = 'pro.ft_componente_concepto_ingas_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_COMINGAS_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:49:24
    ***********************************/

    if(p_transaccion='PRO_COMINGAS_SEL')then

        begin
            --buscamos los concepto de gasto que son obras civiles
            v_conceptos='';
            FOR v_record IN(
                SELECT
                    ciga.id_concepto_ingas_agrupador
                FROM param.tconcepto_ingas_agrupador ciga
                where ciga.es_obra_civil = 'si'
            )LOOP
               FOR v_record_cig IN(
                  SELECT
                      cig.id_concepto_ingas
                  FROM param.tconcepto_ingas cig
                  WHERE cig.id_concepto_ingas_agrupador = v_record.id_concepto_ingas_agrupador
               )LOOP
                    v_conceptos = v_conceptos||v_record_cig.id_concepto_ingas||',';

               END LOOP;
            END LOOP;

            v_conceptos = SUBSTRING (v_conceptos,1,length(v_conceptos) - 1);
            --creamos una tabla temporal con los conceptos y sumamos las obras civiles de los conceptos que son obras
            --Sentencia de la consulta
            v_consulta:=
            'CREATE TEMP TABLE tmp AS(
              with total(
                          id_componente_concepto_ingas,
                          precio_total_det
                    )AS( SELECT
                              comindet.id_componente_concepto_ingas,
                               sum((COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0)* COALESCE(comindet.f_desadeanizacion,0))+
                                   (COALESCE(comindet.precio_montaje, 0) * COALESCE(comindet.cantidad_est,0)* COALESCE(comindet.f_escala_xfd_montaje,0))+
                                   (COALESCE(comindet.precio_prueba, 0) * COALESCE(comindet.cantidad_est,0))
                              )::numeric as precio_total_det
                         FROM pro.tcomponente_concepto_ingas_det comindet
                         GROUP BY comindet.id_componente_concepto_ingas
                            ),
                     total_oc (
                          id_componente_concepto_ingas,
                          precio_total_det
                    )AS( SELECT
                              comindet.id_componente_concepto_ingas,
                               sum((COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0) * COALESCE(comindet.f_desadeanizacion,0))+
                                   (COALESCE(comindet.precio_montaje, 0) * COALESCE(comindet.cantidad_est,0)* COALESCE(comindet.f_escala_xfd_montaje,0))+
                                   (COALESCE(comindet.precio_obra_civil, 0) * COALESCE(comindet.cantidad_est,0)* COALESCE(comindet.f_escala_xfd_obra_civil,0))+
                                   (COALESCE(comindet.precio_prueba, 0) * COALESCE(comindet.cantidad_est,0))
                              )::numeric as precio_total_det
                         FROM pro.tcomponente_concepto_ingas_det comindet
                         GROUP BY comindet.id_componente_concepto_ingas
                            )
                  select
                        comingas.id_componente_concepto_ingas,
                        comingas.estado_reg,
                        comingas.id_concepto_ingas,
                        comingas.id_componente_macro,
                        comingas.id_usuario_reg,
                        comingas.fecha_reg,
                        comingas.id_usuario_ai,
                        comingas.usuario_ai,
                        comingas.id_usuario_mod,
                        comingas.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        cig.desc_ingas,
                        cm.id_proyecto,
                        cig.tipo,
                        cm.porc_prueba,--#28
                        CASE
                        WHEN comingas.id_concepto_ingas in ('||v_conceptos||') THEN
                        totoc.precio_total_det::numeric
                        ELSE
                        tot.precio_total_det::numeric
                        END as precio_total_det,
                        cm.tension  as tension_macro
                        from pro.tcomponente_concepto_ingas comingas
                        inner join segu.tusuario usu1 on usu1.id_usuario = comingas.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = comingas.id_usuario_mod
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = comingas.id_concepto_ingas
                        left join pro.tcomponente_macro cm on cm.id_componente_macro=comingas.id_componente_macro
                        left join total tot on tot.id_componente_concepto_ingas = comingas.id_componente_concepto_ingas
                        left join total_oc totoc on totoc.id_componente_concepto_ingas = comingas.id_componente_concepto_ingas
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            v_consulta:=v_consulta||')';

            EXECUTE v_consulta;
            --Buscamos el total de las sumas de los suministros solo obras
            SELECT
                mc.id_proyecto
            INTO
                v_id_proyecto
            FROM pro.tcomponente_macro mc
            WHERE mc.id_componente_macro = v_parametros.id_componente_macro ;

            v_consulta_p='with total(
                          id_componente_concepto_ingas,
                          precio_total_det
                    )AS( SELECT comindet.id_componente_concepto_ingas,
                             (sum(COALESCE(comindet.precio_obra_civil, 0) * COALESCE(comindet.cantidad_est, 0)* COALESCE(comindet.f_escala_xfd_obra_civil,0) ))::numeric as precio_total_det
                             FROM pro.tcomponente_concepto_ingas_det comindet
                             LEFT JOIN pro.tcomponente_concepto_ingas comcig on comcig.id_componente_concepto_ingas = comindet.id_componente_concepto_ingas
                             LEFT JOIN param.tconcepto_ingas cig on cig.id_concepto_ingas = comcig.id_concepto_ingas
                             WHERE  cig.id_concepto_ingas not in ('||v_conceptos||') and  comcig.id_componente_macro = '||v_parametros.id_componente_macro||'
                             GROUP BY comindet.id_componente_concepto_ingas
                            )
                        SELECT
                         sum(COALESCE(tot.precio_total_det, 0)) as total_precio_det
                        from pro.tcomponente_concepto_ingas comingas
                        left join total tot on tot.id_componente_concepto_ingas = comingas.id_componente_concepto_ingas ';
             EXECUTE  v_consulta_p into  v_precio_total_det;

            --insertamos el total como un concepto pero el total de las obras civiles en suministro
            INSERT INTO tmp  (
                       id_componente_concepto_ingas,
                        estado_reg,
                        id_concepto_ingas,
                        id_componente_macro,
                        id_usuario_reg,
                        fecha_reg,
                        id_usuario_ai,
                        usuario_ai,
                        id_usuario_mod,
                        fecha_mod,
                        usr_reg,
                        usr_mod,
                        desc_ingas,
                        id_proyecto,
                        tipo,
                        porc_prueba,
                        precio_total_det,
                        tension_macro
                          ) values(
                        0,--id_componente_concepto_ingas,
                        'activo',--estado_reg,
                        0,--id_concepto_ingas,
                        v_parametros.id_componente_macro,--id_componente_macro,
                        1,--id_usuario_reg,
                        now(),--fecha_reg,
                        null,--id_usuario_ai,
                        null,--usuario_ai,
                        null,--id_usuario_mod,
                        null,--fecha_mod,
                        null,--usr_reg,
                        null,--usr_mod,
                        'OBRAS SUMINISTRO',--desc_ingas,
                        v_id_proyecto,--id_proyecto,
                        null,--tipo,
                        null,--porc_prueba,
                        v_precio_total_det,--precio_total_det
                        null--tension

                        );

            v_consulta_t = '
                    select
                        tm.id_componente_concepto_ingas,
                        tm.estado_reg,
                        tm.id_concepto_ingas,
                        tm.id_componente_macro,
                        tm.id_usuario_reg,
                        tm.fecha_reg,
                        tm.id_usuario_ai,
                        tm.usuario_ai,
                        tm.id_usuario_mod,
                        tm.fecha_mod,
                        tm.usr_reg,
                        tm.usr_mod,
                        tm.desc_ingas,
                        tm.id_proyecto,
                        tm.tipo,
                        tm.porc_prueba,
                        tm.precio_total_det,
                        tm.tension_macro
                        from tmp tm';

            --Devuelve la respuesta
            raise notice 'v_consulta %',v_consulta_t;
            return v_consulta_t;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMINGAS_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:49:24
    ***********************************/

    elsif(p_transaccion='PRO_COMINGAS_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='with total(
                          id_componente_concepto_ingas,
                          precio_total_det
                    )AS( SELECT
                              comindet.id_componente_concepto_ingas,
                                sum((COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0)* COALESCE(comindet.f_desadeanizacion,0))+
                                   (COALESCE(comindet.precio_montaje, 0) * COALESCE(comindet.cantidad_est,0) * COALESCE(comindet.f_escala_xfd_montaje,0))+
                                   (COALESCE(comindet.precio_obra_civil, 0) * COALESCE(comindet.cantidad_est,0) * COALESCE(comindet.f_escala_xfd_obra_civil,0))+
                                   (COALESCE(comindet.precio_prueba, 0) * COALESCE(comindet.cantidad_est,0))
                              )::numeric as precio_total_det
                         FROM pro.tcomponente_concepto_ingas_det comindet
                         GROUP BY comindet.id_componente_concepto_ingas
                            )
                         select count(comingas.id_componente_concepto_ingas),
                         sum(COALESCE(tot.precio_total_det, 0)) as total_precio_det
                        from pro.tcomponente_concepto_ingas comingas
                        inner join segu.tusuario usu1 on usu1.id_usuario = comingas.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = comingas.id_usuario_mod
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = comingas.id_concepto_ingas
                        left join pro.tcomponente_macro cm on cm.id_componente_macro=comingas.id_componente_macro
                        left join total tot on tot.id_componente_concepto_ingas = comingas.id_componente_concepto_ingas

                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
        /*********************************
     #TRANSACCION:  'PRO_COMINGASLIS_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        EGS
     #FECHA:        22-07-2019 14:49:24
     #ISSUE:        #35
    ***********************************/

    elsif(p_transaccion='PRO_COMINGASLIS_SEL')then

        begin
        --#47 Se agrega with con los precios consolidados por concepto de gasto en planificacion
            --Sentencia de la consulta
            v_consulta:='with concepto_ingas(
                          id_concepto_ingas
                    )AS( SELECT
                              comcig.id_concepto_ingas
                         FROM pro.tcomponente_concepto_ingas comcig
                         left join pro.tcomponente_macro cm on cm.id_componente_macro=comcig.id_componente_macro
                         WHERE '||v_parametros.filtro||'
                         GROUP BY comcig.id_concepto_ingas
                            ),
                   total_concepto_ingas(
                           id_concepto_ingas,
                           precio
                        )as (
                        SELECT
                            coi.id_concepto_ingas,
                            SUM( COALESCE(coid.precio,0)) as precio
                        FROM pro.tcomponente_concepto_ingas_det coid
                        LEFT JOIN pro.tcomponente_concepto_ingas coi on coi.id_componente_concepto_ingas = coid.id_componente_concepto_ingas
                        left join pro.tcomponente_macro cm on cm.id_componente_macro=coi.id_componente_macro
                         WHERE '||v_parametros.filtro||'
                        GROUP BY coi.id_concepto_ingas
                        )
                  select
                        cig.id_concepto_ingas,
                        cig.desc_ingas,
                        cig.tipo,
                        tot.precio
                        from param.tconcepto_ingas cig
                        inner join concepto_ingas comcig on comcig.id_concepto_ingas = cig.id_concepto_ingas
                        inner join total_concepto_ingas tot on tot.id_concepto_ingas = cig.id_concepto_ingas

                        WHERE cig.tipo = '''||v_parametros.tipo||'''';
            --Devuelve la respuesta
            raise notice 'v_consulta %',v_consulta;
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMINGASLIS_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        EGS
     #FECHA:        22-07-2019 14:49:24
     #ISSUE:        #35
    ***********************************/

    elsif(p_transaccion='PRO_COMINGASLIS_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='with concepto_ingas(
                          id_concepto_ingas
                    )AS( SELECT
                              comcig.id_concepto_ingas
                         FROM pro.tcomponente_concepto_ingas comcig
                         left join pro.tcomponente_macro cm on cm.id_componente_macro=comcig.id_componente_macro
                         WHERE '||v_parametros.filtro||'
                         GROUP BY comcig.id_concepto_ingas
                            )
                  select
                        count(cig.id_concepto_ingas)
                        from param.tconcepto_ingas cig
                        inner join concepto_ingas comcig on comcig.id_concepto_ingas = cig.id_concepto_ingas
                        WHERE cig.tipo = '''||v_parametros.tipo||'''';

            --Definicion de la respuesta
            raise notice 'v_consulta %',v_consulta;

            --Devuelve la respuesta
            return v_consulta;

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
COST 100;