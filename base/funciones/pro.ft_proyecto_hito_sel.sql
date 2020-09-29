CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_hito_sel"(    
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_hito_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_hito'
 AUTOR:          (egutierrez)
 FECHA:            28-09-2020 20:15:06
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                28-09-2020 20:15:06    egutierrez             Creacion    
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
                
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_hito_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_PROHIT_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        egutierrez    
     #FECHA:        28-09-2020 20:15:06
    ***********************************/

    IF (p_transaccion='PRO_PROHIT_SEL') THEN
                     
        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        prohit.id_proyecto_hito,
                        prohit.estado_reg,
                        prohit.id_proyecto,
                        prohit.descripcion,
                        prohit.fecha_plan,
                        prohit.importe_plan,
                        prohit.fecha_real,
                        prohit.importe_real,
                        prohit.observaciones,
                        prohit.id_usuario_reg,
                        prohit.fecha_reg,
                        prohit.id_usuario_ai,
                        prohit.usuario_ai,
                        prohit.id_usuario_mod,
                        prohit.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod    
                        FROM pro.tproyecto_hito prohit
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = prohit.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = prohit.id_usuario_mod
                        WHERE  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;
                        
        END;

    /*********************************    
     #TRANSACCION:  'PRO_PROHIT_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez    
     #FECHA:        28-09-2020 20:15:06
    ***********************************/

    ELSIF (p_transaccion='PRO_PROHIT_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_proyecto_hito)
                         FROM pro.tproyecto_hito prohit
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = prohit.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = prohit.id_usuario_mod
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
ALTER FUNCTION "pro"."ft_proyecto_hito_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
