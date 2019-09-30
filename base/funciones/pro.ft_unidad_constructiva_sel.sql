--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_unidad_constructiva_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_unidad_constructiva_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_constructiva'
 AUTOR:          (egutierrez)
 FECHA:            06-05-2019 14:16:09
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #16                06-05-2019 14:16:09 EGS                 Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_constructiva'
 #26                12/09/2019              EGS             Se agrgo combo que muestra sus hijos segun un a unidad construtiva
 ***************************************************************************/

DECLARE

    v_consulta                  varchar;
    v_parametros                record;
    v_nombre_funcion            text;
    v_resp                      varchar;
    v_where                     varchar;
    v_where2                    varchar;
    v_filtro                    varchar;
    v_id_unidad_constructiva    varchar;
    v_uc                        record;
BEGIN

    v_nombre_funcion = 'pro.ft_unidad_constructiva_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_UNCON_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    if(p_transaccion='PRO_UNCON_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select
                        uncon.id_unidad_constructiva,
                        uncon.id_proyecto,
                        uncon.estado_reg,
                        uncon.nombre,
                        uncon.codigo,
                        uncon.fecha_reg,
                        uncon.usuario_ai,
                        uncon.id_usuario_reg,
                        uncon.id_usuario_ai,
                        uncon.id_usuario_mod,
                        uncon.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        uncon.descripcion,
                        uncon.id_unidad_constructiva_fk,
                        uncon.activo
                        from pro.tunidad_constructiva uncon
                        inner join segu.tusuario usu1 on usu1.id_usuario = uncon.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = uncon.id_usuario_mod
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PRO_UNCON_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    elsif(p_transaccion='PRO_UNCON_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_unidad_constructiva)
                        from pro.tunidad_constructiva uncon
                        inner join segu.tusuario usu1 on usu1.id_usuario = uncon.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = uncon.id_usuario_mod
                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
      /*********************************
       #TRANSACCION:  'PRO_UNCONARB_SEL'
       #DESCRIPCION:  Consulta fases por proyecto de tipo árbol
       #AUTOR:        EGS
       #FECHA:
      ***********************************/

      elseif(p_transaccion='PRO_UNCONARB_SEL')then

          begin

              if(coalesce(v_parametros.node,'id') = 'id') then
                  v_where = 'uncon.id_unidad_constructiva_fk is null ';
                  v_where2 = 'uncon.id_unidad_constructiva is null ';

              else
                  v_where = ' uncon.id_unidad_constructiva_fk = '||v_parametros.node;
                  v_where2 = ' uncon.id_unidad_constructiva = '||v_parametros.node;
              end if;


             -- raise notice 'EP: %',v_parametros.id_ep;

              v_filtro = ' 0=0 ';

              --Consulta
              --se hizo un with para la suma de los precios de los items por fase
              v_consulta:='
                     select
                        uncon.id_unidad_constructiva,
                        uncon.id_proyecto,
                        uncon.estado_reg,
                        uncon.nombre,
                        uncon.codigo,
                        uncon.fecha_reg,
                        uncon.usuario_ai,
                        uncon.id_usuario_reg,
                        uncon.id_usuario_ai,
                        uncon.id_usuario_mod,
                        uncon.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        uncon.descripcion,
                        uncon.id_unidad_constructiva_fk,
                          case
                          when coalesce(uncon.id_unidad_constructiva_fk,0) = 0 then ''raiz''::varchar
                              else ''hijo''::varchar
                          end as tipo_nodo,
                        uncon.activo,
                        uncon.id_unidad_constructiva_tipo,
                        uct.nombre as desc_unidad_constructiva_tipo,
                        uncon.tipo_configuracion,
                        cat.descripcion as desc_tipo_configuracion,
                        CASE
                          WHEN cm.id_unidad_constructiva is not null THEN
                             cm.tension
                          ELSE
                             uct.tension
                          END as tension,
                        CASE
                          WHEN cm.id_unidad_constructiva is not null THEN
                             ct.descripcion::VARCHAR
                          ELSE
                             ''''::VARCHAR
                          END as desc_componente_macro_tipo
                      from pro.tunidad_constructiva uncon
                        inner join segu.tusuario usu1 on usu1.id_usuario = uncon.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = uncon.id_usuario_mod
                        left join pro.tunidad_constructiva_tipo uct on uct.id_unidad_constructiva_tipo = uncon.id_unidad_constructiva_tipo
                        left join param.tcatalogo cat on cat.codigo = uncon.tipo_configuracion
                        left join pro.tcomponente_macro cm on cm.id_unidad_constructiva = uncon.id_unidad_constructiva
                        left join param.tcatalogo ct on ct.codigo = cm.componente_macro_tipo
                       where  '||v_where|| ' and ' || v_parametros.filtro || ' and '||v_filtro;

              raise notice '%',v_consulta;

              --Devuelve la respuesta
              return v_consulta;

          end;

      /*********************************
       #TRANSACCION:  'PRO_CONINGASUC_SEL'
       #DESCRIPCION:  consulta los concepto de gasto de la unidades consructivas que existen
       #AUTOR:        EGS
       #FECHA:
      ***********************************/

        elsif(p_transaccion='PRO_CONINGASUC_SEL')then

            begin
                --Sentencia de la consulta
                v_consulta:='select DISTINCT (uncon.id_concepto_ingas),
                                     cig.desc_ingas,
                                     cig.tipo
                             from pro.tunidad_constructiva uncon
                             left join param.tconcepto_ingas cig on cig.id_concepto_ingas = uncon.id_concepto_ingas
                             left join pro.tunidad_constructiva_tipo uct on uct.id_unidad_constructiva_tipo = uncon.id_unidad_constructiva_tipo
                             left join param.tcatalogo cat on cat.codigo = ucon.tipo_configuracion
                             where uncon.id_concepto_ingas is not null and ';

                --Definicion de la respuesta
                v_consulta:=v_consulta||v_parametros.filtro;
                v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

                --Devuelve la respuesta
                return v_consulta;

            end;

        /*********************************
         #TRANSACCION:  'PRO_CONINGASUC_CONT'
         #DESCRIPCION:   consulta los concepto de gasto de la unidades consructivas que existen
         #AUTOR:        egutierrez
         #FECHA:        06-05-2019 14:16:09
        ***********************************/

        elsif(p_transaccion='PRO_CONINGASUC_CONT')then

            begin
                --Sentencia de la consulta de conteo de registros
                v_consulta:='SELECT count(DISTINCT(uncon.id_concepto_ingas))
                            from pro.tunidad_constructiva uncon
                            left join param.tconcepto_ingas cig on cig.id_concepto_ingas = uncon.id_concepto_ingas
                            where ';

                --Definicion de la respuesta
                v_consulta:=v_consulta||v_parametros.filtro;

                --Devuelve la respuesta
                return v_consulta;

            end;
                /*********************************
       #TRANSACCION:  'PRO_COINDETUC_SEL'
       #DESCRIPCION:  Consulta los los detalles por debjo de un nodo
       #AUTOR:        EGS
       #FECHA:
      ***********************************/

        elsif(p_transaccion='PRO_COINDETUC_SEL')then

            begin

            IF pxp.f_existe_parametro(p_tabla,'id_fase_concepto_ingas') THEN
                    SELECT
                        facoing.id_unidad_constructiva
                    INTO
                        v_id_unidad_constructiva
                    FROM pro.tfase_concepto_ingas facoing
                    WHERE facoing.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            END IF;

                IF pxp.f_existe_parametro(p_tabla,'id_concepto_ingas')THEN
                v_id_unidad_constructiva = '';
                --listamos que uc tienen como nodos conceptos de gasto
                        FOR v_uc IN(
                        SELECT
                            uc.id_unidad_constructiva
                        FROM pro.tunidad_constructiva uc
                        WHERE uc.id_concepto_ingas = v_parametros.id_concepto_ingas and uc.id_proyecto = v_parametros.id_proyecto
                        )LOOP
                           v_id_unidad_constructiva = v_id_unidad_constructiva||v_uc.id_unidad_constructiva||',';

                        END LOOP;
                        IF v_id_unidad_constructiva = '' THEN
                           v_id_unidad_constructiva = '0,';
                        END IF;
                        v_id_unidad_constructiva = SUBSTRING (v_id_unidad_constructiva,1,length(v_id_unidad_constructiva) - 1);
                       --raise exception  'v_id_unidad_constructiva %',v_id_unidad_constructiva;
                END IF;
            --raise exception 'v_id_unidad_constructiva %',v_id_unidad_constructiva;
                --Sentencia de la consulta
                v_consulta:=' WITH RECURSIVE arbol_p AS (
                               SELECT
                                     t.id_unidad_constructiva,
                                     t.id_unidad_constructiva_fk,
                                     t.codigo,
                                     t.desc_ingas,
                                     t.id_proyecto,
                                     t.activo
                               FROM pro.tunidad_constructiva t
                               where t.id_unidad_constructiva in('||v_id_unidad_constructiva ||')
                                UNION
                                   SELECT
                                    ta.id_unidad_constructiva,
                                    ta.id_unidad_constructiva_fk,
                                    ta.codigo,
                                    ta.desc_ingas,
                                    ta.id_proyecto,
                                    ta.activo
                                   FROM  pro.tunidad_constructiva ta
                                   INNER JOIN arbol_p p ON p.id_unidad_constructiva_fk = ta.id_unidad_constructiva),
                           arbol_h AS (
                               SELECT
                                     t.id_unidad_constructiva,
                                     t.id_unidad_constructiva_fk,
                                     t.codigo,
                                     t.desc_ingas,
                                     t.id_proyecto,
                                     t.activo
                               FROM pro.tunidad_constructiva t
                               where t.id_unidad_constructiva in('||v_id_unidad_constructiva ||')
                                UNION
                                   SELECT
                                    ta.id_unidad_constructiva,
                                    ta.id_unidad_constructiva_fk,
                                    ta.codigo,
                                    ta.desc_ingas,
                                    ta.id_proyecto,
                                    ta.activo
                                   FROM  pro.tunidad_constructiva ta
                                   INNER JOIN arbol_h p ON p.id_unidad_constructiva = ta.id_unidad_constructiva_fk)
                              SELECT
                                  arb.id_unidad_constructiva,
                                  arb.codigo,
                                  arb.desc_ingas,
                                  arb.id_proyecto,
                                  arb.activo
                              FROM arbol_p arb
                                WHERE arb.activo = ''si''
                              UNION
                              SELECT
                                  arb.id_unidad_constructiva,
                                  arb.codigo,
                                  arb.desc_ingas,
                                  arb.id_proyecto,
                                  arb.activo
                              FROM arbol_h arb
                                WHERE arb.activo = ''si''
                              ORDER by id_unidad_constructiva ASC ';

                --Devuelve la respuesta
                return v_consulta;

            end;

        /*********************************
         #TRANSACCION:  'PRO_COINDETUC_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        egutierrez
         #FECHA:        06-05-2019 14:16:09
        ***********************************/

        elsif(p_transaccion='PRO_COINDETUC_CONT')then

            begin
             IF pxp.f_existe_parametro(p_tabla,'id_fase_concepto_ingas')THEN
                    SELECT
                        facoing.id_unidad_constructiva
                    INTO
                        v_id_unidad_constructiva
                    FROM pro.tfase_concepto_ingas facoing
                    WHERE facoing.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            END IF;

                IF pxp.f_existe_parametro(p_tabla,'id_concepto_ingas')THEN
                v_id_unidad_constructiva = '';
                        FOR v_uc IN(
                        SELECT
                            uc.id_unidad_constructiva
                        FROM pro.tunidad_constructiva uc
                        WHERE uc.id_concepto_ingas = v_parametros.id_concepto_ingas and uc.id_proyecto = v_parametros.id_proyecto
                        )LOOP
                           v_id_unidad_constructiva = v_id_unidad_constructiva||v_uc.id_unidad_constructiva::varchar||',';

                        END LOOP;
                        IF v_id_unidad_constructiva <> '' THEN
                            v_id_unidad_constructiva = SUBSTRING (v_id_unidad_constructiva,1,length(v_id_unidad_constructiva) - 1);
                        ELSE
                            --No existen nodos con el concepto de gasto
                            v_id_unidad_constructiva = '0';
                        END IF;
                END IF;

                --Sentencia de la consulta de conteo de registros
                v_consulta:=' WITH RECURSIVE arbol_p AS (
                               SELECT
                                     t.id_unidad_constructiva,
                                     t.id_unidad_constructiva_fk,
                                     t.codigo,
                                     t.desc_ingas,
                                     t.id_proyecto,
                                     t.activo
                               FROM pro.tunidad_constructiva t
                               where t.id_unidad_constructiva in('||v_id_unidad_constructiva ||')
                                UNION
                                   SELECT
                                    ta.id_unidad_constructiva,
                                    ta.id_unidad_constructiva_fk,
                                    ta.codigo,
                                    ta.desc_ingas,
                                    ta.id_proyecto,
                                    ta.activo
                                   FROM  pro.tunidad_constructiva ta
                                   INNER JOIN arbol_p p ON p.id_unidad_constructiva_fk = ta.id_unidad_constructiva),
                           arbol_h AS (
                               SELECT
                                     t.id_unidad_constructiva,
                                     t.id_unidad_constructiva_fk,
                                     t.codigo,
                                     t.desc_ingas,
                                     t.id_proyecto,
                                     t.activo
                               FROM pro.tunidad_constructiva t
                               where t.id_unidad_constructiva in('||v_id_unidad_constructiva ||')
                                UNION
                                   SELECT
                                    ta.id_unidad_constructiva,
                                    ta.id_unidad_constructiva_fk,
                                    ta.codigo,
                                    ta.desc_ingas,
                                    ta.id_proyecto,
                                    ta.activo
                                   FROM  pro.tunidad_constructiva ta
                                   INNER JOIN arbol_h p ON p.id_unidad_constructiva = ta.id_unidad_constructiva_fk)

                                  SELECT
                                     count(id_unidad_constructiva)
                                  FROM arbol_p arb
                                  WHERE arb.activo = ''si''
                                   ';

                --Devuelve la respuesta
                return v_consulta;

            end;
        /*********************************
     #TRANSACCION:  'PRO_UNCONMH_SEL'
     #DESCRIPCION:   Segun un id de unidad construciva lista los hijos por debajo de esa unidad Constructiva
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
     #ISSUE:        #26
    ***********************************/

    elseif(p_transaccion='PRO_UNCONMH_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='WITH RECURSIVE arbol  AS(
                               SELECT
                                  uncon.id_unidad_constructiva,
                                  uncon.id_proyecto,
                                  uncon.estado_reg,
                                  uncon.nombre,
                                  uncon.codigo,
                                  uncon.descripcion,
                                  uncon.id_unidad_constructiva_fk,
                                  uncon.activo
                               from pro.tunidad_constructiva uncon
                             WHERE uncon.id_unidad_constructiva = '||v_parametros.id_unidad_constructiva_macro||'
                                UNION ALL
                               SELECT
                                  unco.id_unidad_constructiva,
                                  unco.id_proyecto,
                                  unco.estado_reg,
                                  unco.nombre,
                                  unco.codigo,
                                  unco.descripcion,
                                  unco.id_unidad_constructiva_fk,
                                  unco.activo
                               from pro.tunidad_constructiva unco
                                JOIN arbol al ON al.id_unidad_constructiva = unco.id_unidad_constructiva_fk
                                )
                                SELECT
                                  ar.id_unidad_constructiva,
                                  ar.id_proyecto,
                                  ar.estado_reg,
                                  ar.nombre,
                                  ar.codigo,
                                  ar.descripcion,
                                  ar.id_unidad_constructiva_fk,
                                  ar.activo
                               from arbol ar
                               Where ar.id_unidad_constructiva <> '||v_parametros.id_unidad_constructiva_macro||'
                               order by ar.id_unidad_constructiva ASC';

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PRO_UNCONMH_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
     #ISSUE:        #26
    ***********************************/

    elsif(p_transaccion='PRO_UNCONMH_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='   WITH RECURSIVE arbol  AS(
                         SELECT
                            uncon.id_unidad_constructiva
                         from pro.tunidad_constructiva uncon
                       WHERE uncon.id_unidad_constructiva = '||v_parametros.id_unidad_constructiva_macro||'
                          UNION ALL
                         SELECT
                            unco.id_unidad_constructiva
                         from pro.tunidad_constructiva unco
                          JOIN arbol al ON al.id_unidad_constructiva = unco.id_unidad_constructiva_fk
                          )
                          SELECT
                            count(ar.id_unidad_constructiva)

                         from arbol ar
                         Where ar.id_unidad_constructiva <> '||v_parametros.id_unidad_constructiva_macro||'';


            --Devuelve la respuesta
            return v_consulta;


        end;


     /*********************************
     #TRANSACCION:  'PRO_UNCONMA_SEL'
     #DESCRIPCION:   Recuperamos la unidad constructiva macro el cual siempre es el de segundo nivel
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
     #ISSUE:        #26
    ***********************************/

    elseif(p_transaccion='PRO_UNCONMA_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='WITH RECURSIVE arbol  AS(   SELECT
                                                            unconpl.id_unidad_constructiva,
                                                            unconpl.nombre,
                                                            unconpl.codigo,
                                                            unconpl.id_unidad_constructiva_fk
                                                           FROM pro.tunidad_constructiva unconpl
                                                           WHERE unconpl.id_unidad_constructiva = '||v_parametros.id_unidad_constructiva_hijo||'
                                                      UNION ALL
                                                            SELECT
                                                                  uncopl.id_unidad_constructiva,
                                                                  uncopl.nombre,
                                                                  uncopl.codigo,
                                                                  uncopl.id_unidad_constructiva_fk

                                                            FROM pro.tunidad_constructiva uncopl
                                                            JOIN arbol al ON al.id_unidad_constructiva_fk =uncopl.id_unidad_constructiva
                                                                )
                            SELECT
                                MIN(id_unidad_constructiva)
                            FROM arbol
                            WHERE  id_unidad_constructiva_fk is not null';

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