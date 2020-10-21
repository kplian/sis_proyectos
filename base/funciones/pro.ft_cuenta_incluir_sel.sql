--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_cuenta_incluir_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_cuenta_incluir_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcuenta_incluir'
 AUTOR:          (egutierrez)
 FECHA:            19-10-2020 14:17:13
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                19-10-2020 14:17:13    egutierrez             Creacion
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;

BEGIN

    v_nombre_funcion = 'pro.ft_cuenta_incluir_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_CUEINC_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        egutierrez
     #FECHA:        19-10-2020 14:17:13
    ***********************************/

    IF (p_transaccion='PRO_CUEINC_SEL') THEN

        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        cueinc.id_cuenta_incluir,
                        cueinc.estado_reg,
                        cueinc.nro_cuenta,
                        cueinc.tipo,
                        cueinc.id_usuario_reg,
                        cueinc.fecha_reg,
                        cueinc.id_usuario_ai,
                        cueinc.usuario_ai,
                        cueinc.id_usuario_mod,
                        cueinc.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod
                        FROM pro.tcuenta_incluir cueinc
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = cueinc.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cueinc.id_usuario_mod
                        WHERE  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

    /*********************************
     #TRANSACCION:  'PRO_CUEINC_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez
     #FECHA:        19-10-2020 14:17:13
    ***********************************/

    ELSIF (p_transaccion='PRO_CUEINC_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(cueinc.id_cuenta_incluir)
                         FROM pro.tcuenta_incluir cueinc
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = cueinc.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cueinc.id_usuario_mod
                         WHERE ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

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