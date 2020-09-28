CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_suspension_sel"(    
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_suspension_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_suspension'
 AUTOR:          (egutierrez)
 FECHA:            28-09-2020 19:25:30
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                28-09-2020 19:25:30    egutierrez             Creacion    
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
                
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_suspension_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_REGSUS_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        egutierrez    
     #FECHA:        28-09-2020 19:25:30
    ***********************************/

    IF (p_transaccion='PRO_REGSUS_SEL') THEN
                     
        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        regsus.id_proyecto_suspension,
                        regsus.estado_reg,
                        regsus.id_proyecto,
                        regsus.fecha_desde,
                        regsus.fecha_hasta,
                        regsus.descripcion,
                        regsus.id_usuario_reg,
                        regsus.fecha_reg,
                        regsus.id_usuario_ai,
                        regsus.usuario_ai,
                        regsus.id_usuario_mod,
                        regsus.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod    
                        FROM pro.tproyecto_suspension regsus
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = regsus.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = regsus.id_usuario_mod
                        WHERE  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;
                        
        END;

    /*********************************    
     #TRANSACCION:  'PRO_REGSUS_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez    
     #FECHA:        28-09-2020 19:25:30
    ***********************************/

    ELSIF (p_transaccion='PRO_REGSUS_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_proyecto_suspension)
                         FROM pro.tproyecto_suspension regsus
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = regsus.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = regsus.id_usuario_mod
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pro"."ft_proyecto_suspension_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
