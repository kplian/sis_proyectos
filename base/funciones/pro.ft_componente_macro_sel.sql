--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_componente_macro_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_componente_macro_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcomponente_macro'
 AUTOR:          (admin)
 FECHA:            22-07-2019 14:47:14
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #17                22-07-2019 14:47:14    EGS                  Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcomponente_macro'
 #22 EndeEtr          05/09/2019            EGS                 Se agrega cmp codigo
#27                   16/09/2019            EGS                 Se agrego campo f_desadeanizacion,f_seguridad,f_escala_xfd_montaje,f_escala_xfd_obra_civil,porc_prueba
#34  EndeEtr          03/10/2019            EGS                 Se aumentaron los With para los totalizdores
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;

BEGIN

    v_nombre_funcion = 'pro.ft_componente_macro_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_COMPM_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    if(p_transaccion='PRO_COMPM_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='
             with total(
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
                            ),
            total_macro(
                    id_componente_macro,
                    precio_total_cig
                )AS(
                    SELECT
                        comcig.id_componente_macro,
                        sum(COALESCE(tot.precio_total_det,0))
                    FROM pro.tcomponente_concepto_ingas comcig
                    left join total tot on tot.id_componente_concepto_ingas = comcig.id_componente_concepto_ingas
                    GROUP BY comcig.id_componente_macro
                    )
                   select
                        compm.id_componente_macro,
                        compm.estado_reg,
                        compm.nombre,
                        compm.descripcion,
                        compm.id_proyecto,
                        compm.id_usuario_reg,
                        compm.fecha_reg,
                        compm.id_usuario_ai,
                        compm.usuario_ai,
                        compm.id_usuario_mod,
                        compm.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        compm.codigo,--#22
                        compm.componente_macro_tipo,--#22
                        ct.descripcion as desc_componente_macro_tipo,
                        compm.id_unidad_constructiva,
                        compm.f_desadeanizacion,--#27
                        compm.f_seguridad,--#27
                        compm.f_escala_xfd_montaje,--#27
                        compm.f_escala_xfd_obra_civil,--#27
                        compm.porc_prueba,--#27
                        compm.tension,
                        tm.precio_total_cig
                        from pro.tcomponente_macro compm
                        inner join segu.tusuario usu1 on usu1.id_usuario = compm.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = compm.id_usuario_mod
                        left join param.tcatalogo ct on ct.codigo = compm.componente_macro_tipo
                        left join total_macro tm on tm.id_componente_macro = compm.id_componente_macro
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMPM_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    elsif(p_transaccion='PRO_COMPM_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='
                    with total(
                          id_componente_concepto_ingas,
                          precio_total_det
                    )AS( SELECT
                              comindet.id_componente_concepto_ingas,
                                sum((COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0))+
                                   (COALESCE(comindet.precio_montaje, 0) * COALESCE(comindet.cantidad_est,0))+
                                   --(COALESCE(comindet.precio_obra_civil, 0) * COALESCE(comindet.cantidad_est,0))+
                                   (COALESCE(comindet.precio_prueba, 0) * COALESCE(comindet.cantidad_est,0))
                              )::numeric as precio_total_det                         FROM pro.tcomponente_concepto_ingas_det comindet
                         GROUP BY comindet.id_componente_concepto_ingas
                            ),
            total_macro(
                    id_componente_macro,
                    precio_total_cig
                )AS(
                    SELECT
                        comcig.id_componente_macro,
                        sum(COALESCE(tot.precio_total_det,0))
                    FROM pro.tcomponente_concepto_ingas comcig
                    left join total tot on tot.id_componente_concepto_ingas = comcig.id_componente_concepto_ingas
                    GROUP BY comcig.id_componente_macro
                    )
                    select count(compm.id_componente_macro),
                         sum(COALESCE(tm.precio_total_cig,0))::numeric as total_precio_cig
                        from pro.tcomponente_macro compm
                        inner join segu.tusuario usu1 on usu1.id_usuario = compm.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = compm.id_usuario_mod
                        left join total_macro tm on tm.id_componente_macro = compm.id_componente_macro
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