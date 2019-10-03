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

 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;

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
            --Sentencia de la consulta
            v_consulta:='with total(
                          id_componente_concepto_ingas,
                          precio_total_det
                    )AS( SELECT
                              comindet.id_componente_concepto_ingas,
                               sum((COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0))+
                                   (COALESCE(comindet.precio_montaje, 0) * COALESCE(comindet.cantidad_est,0))+
                                   --(COALESCE(comindet.precio_obra_civil, 0) * COALESCE(comindet.cantidad_est,0))+
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
                        tot.precio_total_det::numeric
                        from pro.tcomponente_concepto_ingas comingas
                        inner join segu.tusuario usu1 on usu1.id_usuario = comingas.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = comingas.id_usuario_mod
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = comingas.id_concepto_ingas
                        left join pro.tcomponente_macro cm on cm.id_componente_macro=comingas.id_componente_macro
                        left join total tot on tot.id_componente_concepto_ingas = comingas.id_componente_concepto_ingas
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            raise notice 'v_consulta %',v_consulta;
            return v_consulta;

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
                                sum((COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0))+
                                   (COALESCE(comindet.precio_montaje, 0) * COALESCE(comindet.cantidad_est,0))+
                                   --(COALESCE(comindet.precio_obra_civil, 0) * COALESCE(comindet.cantidad_est,0))+
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