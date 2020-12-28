--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_proyecto_analisis_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_analisis_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_analisis_det'
 AUTOR:          (egutierrez)
 FECHA:            29-09-2020 12:44:12
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                29-09-2020 12:44:12    egutierrez             Creacion
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
    v_record              record;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_analisis_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PROANADE_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:12
    ***********************************/

    IF (p_transaccion='PRO_PROANADE_SEL') THEN

        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                          proanade.id_proyecto_analisis_det,
                          proanade.estado_reg,
                          proanade.id_proyecto_analisis,
                          proanade.id_int_transaccion,
                          proanade.estado,
                          proanade.id_usuario_reg,
                          proanade.fecha_reg,
                          proanade.id_usuario_ai,
                          proanade.usuario_ai,
                          proanade.id_usuario_mod,
                          proanade.fecha_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,
                          cbt.nro_tramite as  nro_tramite_cbte,
                          cbt.fecha as fecha_cbte,
                          cbt.glosa1 as glosa_cbte,
                          intra.importe_debe_mb,
                          intra.importe_haber_mb,
                          CASE par.sw_movimiento
                          WHEN ''flujo'' THEN
                            ''(F)''||par.codigo || '' - '' || par.nombre_partida
                          ELSE
                            par.codigo ||'' - '' || par.nombre_partida
                          END  as desc_partida,

                          cc.codigo_cc as desc_centro_costo,
                          cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
                          aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
                          cue.tipo_cuenta
                          FROM pro.tproyecto_analisis_det proanade
                          JOIN segu.tusuario usu1 ON usu1.id_usuario = proanade.id_usuario_reg
                          LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proanade.id_usuario_mod
                          left join conta.tint_transaccion intra on intra.id_int_transaccion = proanade.id_int_transaccion
                          left join conta.tint_comprobante cbt on cbt.id_int_comprobante = intra.id_int_comprobante
                          inner join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                          left join pre.tpartida par on par.id_partida = intra.id_partida
                          left join conta.tauxiliar aux on aux.id_auxiliar = intra.id_auxiliar
                          left join pre.vpresupuesto_cc cc on cc.id_centro_costo = intra.id_centro_costo

                        WHERE  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

    /*********************************
     #TRANSACCION:  'PRO_PROANADE_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:12
    ***********************************/

    ELSIF (p_transaccion='PRO_PROANADE_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(proanade.id_proyecto_analisis_det)
                         FROM pro.tproyecto_analisis_det proanade
                          JOIN segu.tusuario usu1 ON usu1.id_usuario = proanade.id_usuario_reg
                          LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proanade.id_usuario_mod
                          left join conta.tint_transaccion intra on intra.id_int_transaccion = proanade.id_int_transaccion
                          left join conta.tint_comprobante cbt on cbt.id_int_comprobante = intra.id_int_comprobante
                          inner join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                          left join pre.tpartida par on par.id_partida = intra.id_partida
                          left join conta.tauxiliar aux on aux.id_auxiliar = intra.id_auxiliar
                          left join pre.vpresupuesto_cc cc on cc.id_centro_costo = intra.id_centro_costo
                         WHERE ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;
            /*********************************
         #TRANSACCION:  'PRO_PROINTRA_SEL'
         #DESCRIPCION:    Consulta de datos
         #AUTOR:        egutierrez
         #FECHA:        29-09-2020 12:44:12
        ***********************************/
        ELSIF (p_transaccion='PRO_PROINTRA_SEL') THEN

        BEGIN
            SELECT
                p.fecha,
                pv.id_auxiliar,
                pro.id_tipo_cc
            into
            v_record
            FROM pro.tproyecto_analisis p
            LEFT JOIN pro.tproyecto pro on pro.id_proyecto = p.id_proyecto
            LEFT JOIN param.tproveedor pv on pv.id_proveedor = p.id_proveedor
            WHERE p.id_proyecto_analisis = v_parametros.id_proyecto_analisis;
            --Sentencia de la consulta de conteo de registros
            v_consulta:='
            SELECT
                  intra.id_int_transaccion,
                  cbt.nro_tramite as  nro_tramite_cbte,
                  cbt.fecha as fecha_cbte,
                  cbt.glosa1 as glosa_cbte,
                  intra.importe_debe_mb,
                  intra.importe_haber_mb,
                  CASE par.sw_movimiento
                  WHEN ''flujo'' THEN
                    ''(F)''||par.codigo || '' - '' || par.nombre_partida
                  ELSE
                    par.codigo ||'' - '' || par.nombre_partida
                  END  as desc_partida,

                  cc.codigo_cc as desc_centro_costo,
                  cue.nro_cuenta || '' - '' || cue.nombre_cuenta as desc_cuenta,
                  aux.codigo_auxiliar || '' - '' || aux.nombre_auxiliar as desc_auxiliar,
                  cue.tipo_cuenta
                 FROM conta.tint_transaccion intra
                  JOIN conta.tint_comprobante cbt on cbt.id_int_comprobante = intra.id_int_comprobante
                  Left join pro.tproyecto_analisis_det pa on pa.id_int_transaccion = intra.id_int_transaccion
                  left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                  left join pre.tpartida par on par.id_partida = intra.id_partida
                  left join conta.tauxiliar aux on aux.id_auxiliar = intra.id_auxiliar
                  left join pre.vpresupuesto_cc cc on cc.id_centro_costo = intra.id_centro_costo
             WHERE cbt.estado_reg = ''validado''
                  and (intra.id_centro_costo in (with recursive arbol_tipo_cc AS (
                                SELECT
                                    tcc.id_tipo_cc,
                                    tcc.movimiento
                                FROM param.ttipo_cc tcc
                                WHERE tcc.id_tipo_cc = '||v_record.id_tipo_cc||'
                                UNION
                                SELECT
                                    tcce.id_tipo_cc,
                                    tcce.movimiento
                                FROM param.ttipo_cc tcce
                                inner join arbol_tipo_cc ar on ar.id_tipo_cc = tcce.id_tipo_cc_fk
                            )
                            select
                                cec.id_centro_costo
                            from arbol_tipo_cc arb
                            left join param.tcentro_costo cec on cec.id_tipo_cc = arb.id_tipo_cc
                            where  arb.movimiento = ''si''
                            order by cec.id_centro_costo ASC)
                  or intra.id_auxiliar = '||v_record.id_auxiliar||'
                  )
                  and cbt.fecha <= '''||v_record.fecha||'''::date
                  and pa.id_proyecto_analisis_det is NULL
                  and nro_cuenta not in (
                            SELECT
                            e.nro_cuenta
                            FROM pro.tcuenta_excluir e
                            Where e.tipo = ''diferido''
                  )
                  and cue.tipo_cuenta = '''||v_parametros.tipo_cuenta||''' ';

                  RETURN v_consulta;
         END;
            --Definicion de la respuesta
         /*********************************
         #TRANSACCION:  'PRO_PROINTRA_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        egutierrez
         #FECHA:        29-09-2020 12:44:10
        ***********************************/

        ELSIF (p_transaccion='PRO_PROINTRA_CONT') THEN

            BEGIN
                SELECT
                    p.fecha,
                    pv.id_auxiliar,
                    pro.id_tipo_cc
                into
                v_record
                FROM pro.tproyecto_analisis p
                LEFT JOIN pro.tproyecto pro on pro.id_proyecto = p.id_proyecto
                LEFT JOIN param.tproveedor pv on pv.id_proveedor = p.id_proveedor
                WHERE p.id_proyecto_analisis = v_parametros.id_proyecto_analisis;
                --Sentencia de la consulta de conteo de registros
                v_consulta:='

                SELECT COUNT(intra.id_int_transaccion)
                FROM conta.tint_transaccion intra
                  JOIN conta.tint_comprobante cbt on cbt.id_int_comprobante = intra.id_int_comprobante
                  Left join pro.tproyecto_analisis_det pa on pa.id_int_transaccion = intra.id_int_transaccion
                  left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                  left join pre.tpartida par on par.id_partida = intra.id_partida
                  left join conta.tauxiliar aux on aux.id_auxiliar = intra.id_auxiliar
                  left join pre.vpresupuesto_cc cc on cc.id_centro_costo = intra.id_centro_costo
                 WHERE cbt.estado_reg = ''validado''
                  and (intra.id_centro_costo in (with recursive arbol_tipo_cc AS (
                                SELECT
                                    tcc.id_tipo_cc,
                                    tcc.movimiento
                                FROM param.ttipo_cc tcc
                                WHERE tcc.id_tipo_cc = '||v_record.id_tipo_cc||'
                                UNION
                                SELECT
                                    tcce.id_tipo_cc,
                                    tcce.movimiento
                                FROM param.ttipo_cc tcce
                                inner join arbol_tipo_cc ar on ar.id_tipo_cc = tcce.id_tipo_cc_fk
                            )
                            select
                                cec.id_centro_costo
                            from arbol_tipo_cc arb
                            left join param.tcentro_costo cec on cec.id_tipo_cc = arb.id_tipo_cc
                            where  arb.movimiento = ''si''
                            order by cec.id_centro_costo ASC)
                  or intra.id_auxiliar = '||v_record.id_auxiliar||'
                  )
                  and cbt.fecha <= '''||v_record.fecha||'''::date
                  and pa.id_proyecto_analisis_det is NULL
                  and nro_cuenta not in (
                            SELECT
                            e.nro_cuenta
                            FROM pro.tcuenta_excluir e
                            Where e.tipo = ''diferido''
                  )
                  and cue.tipo_cuenta = '''||v_parametros.tipo_cuenta||'''';



            --Devuelve la respuesta
            RETURN v_consulta;

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
            RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;