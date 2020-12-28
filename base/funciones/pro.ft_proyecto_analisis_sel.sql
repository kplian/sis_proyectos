-- FUNCTION: pro.ft_proyecto_analisis_sel(integer, integer, character varying, character varying)

-- DROP FUNCTION pro.ft_proyecto_analisis_sel(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION pro.ft_proyecto_analisis_sel(
	p_administrador integer,
	p_id_usuario integer,
	p_tabla character varying,
	p_transaccion character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
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
 #MDID-10               13/10/2020          EGS                 Se agrega campo tipo_cc
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
                          ( SELECT
                              p.op_saldo_activo
                          from pro.f_get_saldo_analisis_diferido(proana.id_proyecto_analisis,null) p) as saldo_activo,
                          (SELECT
                              p.op_saldo_pasivo
                          from pro.f_get_saldo_analisis_diferido(proana.id_proyecto_analisis,null) p) as saldo_pasivo,

                            (SELECT
                              p.op_saldo_ingreso
                          from pro.f_get_saldo_analisis_diferido(proana.id_proyecto_analisis,null) p) as saldo_ingreso,
                            (SELECT
                              p.op_saldo_egreso
                          from pro.f_get_saldo_analisis_diferido(proana.id_proyecto_analisis,null) p) as saldo_gasto,
                        proana.porc_diferido,--#MDID-8
                        proana.cerrar,--#MDID-8
                        proana.nro_tramite,--#MDID-8
                        proana.id_estado_wf,--#MDID-8
                        proana.id_proceso_wf,--#MDID-8
                        proana.id_tipo_cc,--#MDID-10
                        tc.codigo as desc_tipo_cc --#MDID-10,
                        ,proana.id_depto_conta, dep.codigo, dep.nombre,
                        proana.id_int_comprobante_1,
                        proana.id_int_comprobante_2,
                        proana.id_int_comprobante_3,
                        c1.nro_cbte,c2.nro_cbte, c3.nro_cbte
                        FROM pro.tproyecto_analisis proana
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = proana.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proana.id_usuario_mod
                        LEFT JOIN param.vproveedor pro on pro.id_proveedor = proana.id_proveedor
                        LEFT JOIN param.ttipo_cc tc on tc.id_tipo_cc = proana.id_tipo_cc
                        left join param.tdepto dep on dep.id_depto=proana.id_depto_conta
                        left join conta.tint_comprobante c1 on c1.id_int_comprobante=proana.id_int_comprobante_1
                        left join conta.tint_comprobante c2 on c2.id_int_comprobante=proana.id_int_comprobante_2
                        left join conta.tint_comprobante c3 on c3.id_int_comprobante=proana.id_int_comprobante_3  

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
                         LEFT JOIN param.vproveedor pro on pro.id_proveedor = proana.id_proveedor
                         LEFT JOIN param.ttipo_cc tc on tc.id_tipo_cc = proana.id_tipo_cc
                         left join param.tdepto dep on dep.id_depto=proana.id_depto_conta
                         left join conta.tint_comprobante c1 on c1.id_int_comprobante=proana.id_int_comprobante_1
                         left join conta.tint_comprobante c2 on c2.id_int_comprobante=proana.id_int_comprobante_2
                         left join conta.tint_comprobante c3 on c3.id_int_comprobante=proana.id_int_comprobante_3
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
$BODY$;

ALTER FUNCTION pro.ft_proyecto_analisis_sel(integer, integer, character varying, character varying)
    OWNER TO postgres;