CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_analisis_det_ime" (    
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_analisis_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_analisis_det'
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

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_proyecto_analisis_det    INTEGER;
                
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_analisis_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_PROANADE_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez    
     #FECHA:        29-09-2020 12:44:12
    ***********************************/

    IF (p_transaccion='PRO_PROANADE_INS') THEN
                    
        BEGIN
            --Sentencia de la insercion
            INSERT INTO pro.tproyecto_analisis_det(
            estado_reg,
            id_proyecto_analisis,
            id_int_transaccion,
            estado,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) VALUES (
            'activo',
            v_parametros.id_proyecto_analisis,
            v_parametros.id_int_transaccion,
            v_parametros.estado,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null            
            ) RETURNING id_proyecto_analisis_det into v_id_proyecto_analisis_det;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_proyecto_analisis_det'||v_id_proyecto_analisis_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis_det',v_id_proyecto_analisis_det::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    /*********************************    
     #TRANSACCION:  'PRO_PROANADE_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        29-09-2020 12:44:12
    ***********************************/

    ELSIF (p_transaccion='PRO_PROANADE_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE pro.tproyecto_analisis_det SET
            id_proyecto_analisis = v_parametros.id_proyecto_analisis,
            id_int_transaccion = v_parametros.id_int_transaccion,
            estado = v_parametros.estado,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            WHERE id_proyecto_analisis_det=v_parametros.id_proyecto_analisis_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis_det',v_parametros.id_proyecto_analisis_det::varchar);
               
            --Devuelve la respuesta
            RETURN v_resp;
            
        END;

    /*********************************    
     #TRANSACCION:  'PRO_PROANADE_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        29-09-2020 12:44:12
    ***********************************/

    ELSIF (p_transaccion='PRO_PROANADE_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM pro.tproyecto_analisis_det
            WHERE id_proyecto_analisis_det=v_parametros.id_proyecto_analisis_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis_det',v_parametros.id_proyecto_analisis_det::varchar);
              
            --Devuelve la respuesta
            RETURN v_resp;

        END;
         
    ELSE
     
        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

    END IF;

EXCEPTION
                
    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;
                        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pro"."ft_proyecto_analisis_det_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
