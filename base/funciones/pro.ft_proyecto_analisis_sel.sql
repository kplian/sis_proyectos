--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_proyecto_analisis_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_analisis_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_analisis'
 AUTOR:          (egutierrez)
 FECHA:            29-09-2020 12:44:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                29-09-2020 12:44:10    egutierrez             Creacion
 #MDID-8               08/10/2020           EGS                 Se agrega WF
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
    v_filtro              VARCHAR;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_analisis_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PROANA_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:10
    ***********************************/

    IF (p_transaccion='PRO_PROANA_SEL') THEN

        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        proana.id_proyecto_analisis,
                        proana.estado_reg,
                        proana.id_proyecto,
                        proana.fecha,
                        proana.glosa,
                        proana.estado,
                        proana.id_usuario_reg,
                        proana.fecha_reg,
                        proana.id_usuario_ai,
                        proana.usuario_ai,
                        proana.id_usuario_mod,
                        proana.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        proana.id_proveedor,
                        pro.desc_proveedor,
                          (SELECT
                            (sum(intra.importe_debe_mb)- sum(intra.importe_haber_mb))
                            FROM pro.tproyecto_analisis_det p
                            left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                            left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                            WHERE cue.tipo_cuenta =''activo'' and p.id_proyecto_analisis = proana.id_proyecto_analisis) as saldo_activo,
                          (SELECT
                            (sum(intra.importe_haber_mb)-sum(intra.importe_debe_mb))
                            FROM pro.tproyecto_analisis_det p
                            left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                            left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                            WHERE cue.tipo_cuenta =''pasivo'' and p.id_proyecto_analisis =  proana.id_proyecto_analisis) as saldo_pasivo,

                            (SELECT
                            (sum(intra.importe_haber_mb)- sum(intra.importe_debe_mb))
                            FROM pro.tproyecto_analisis_det p
                            left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                            left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                            WHERE cue.tipo_cuenta =''ingreso'' and p.id_proyecto_analisis =  proana.id_proyecto_analisis) as saldo_ingreso,
                            (SELECT
                            (sum(intra.importe_debe_mb)- sum(intra.importe_haber_mb))
                            FROM pro.tproyecto_analisis_det p
                            left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                            left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                            WHERE cue.tipo_cuenta =''gasto'' and p.id_proyecto_analisis =  proana.id_proyecto_analisis) as saldo_gasto,
                        proana.porc_diferido,--#MDID-8
                        proana.cerrar,--#MDID-8
                        proana.nro_tramite,--#MDID-8
                        proana.id_estado_wf,--#MDID-8
                        proana.id_proceso_wf--#MDID-8
                        FROM pro.tproyecto_analisis proana
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = proana.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proana.id_usuario_mod
                        LEFT JOIN param.vproveedor pro on pro.id_proveedor = proana.id_proveedor
                        WHERE  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

    /*********************************
     #TRANSACCION:  'PRO_PROANA_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:10
    ***********************************/

    ELSIF (p_transaccion='PRO_PROANA_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_proyecto_analisis)
                         FROM pro.tproyecto_analisis proana
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = proana.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proana.id_usuario_mod
                         WHERE ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;
    /*********************************
     #TRANSACCION:  'PRO_PROVEANA_SEL'
     #DESCRIPCION:    Seleccion de registros de proveedor de proyectos por el analisis diferidos
     #AUTOR:        egutierrez
     #FECHA:        30-10-2020
    ***********************************/

    ELSIF (p_transaccion='PRO_PROVEANA_SEL') THEN

        BEGIN
            v_filtro = v_parametros.id_proyecto ||'and ';
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT
                            DISTINCT(COALESCE(proana.id_proveedor,0))::integer as id_proveedor,
                            count(proana.id_proyecto_analisis)::integer as total_registros
                         FROM pro.tproyecto_analisis proana
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = proana.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proana.id_usuario_mod
                         WHERE ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
             v_consulta:=v_consulta||'  Group by proana.id_proveedor';



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