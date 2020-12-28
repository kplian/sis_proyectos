CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_suspension_ime" (    
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_suspension_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_suspension'
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

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_proyecto_suspension    INTEGER;
                
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_suspension_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_REGSUS_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez    
     #FECHA:        28-09-2020 19:25:30
    ***********************************/

    IF (p_transaccion='PRO_REGSUS_INS') THEN
                    
        BEGIN
            --Sentencia de la insercion
            INSERT INTO pro.tproyecto_suspension(
            estado_reg,
            id_proyecto,
            fecha_desde,
            fecha_hasta,
            descripcion,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) VALUES (
            'activo',
            v_parametros.id_proyecto,
            v_parametros.fecha_desde,
            v_parametros.fecha_hasta,
            v_parametros.descripcion,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null            
            ) RETURNING id_proyecto_suspension into v_id_proyecto_suspension;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registros de Suspensiones almacenado(a) con exito (id_proyecto_suspension'||v_id_proyecto_suspension||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_suspension',v_id_proyecto_suspension::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    /*********************************    
     #TRANSACCION:  'PRO_REGSUS_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        28-09-2020 19:25:30
    ***********************************/

    ELSIF (p_transaccion='PRO_REGSUS_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE pro.tproyecto_suspension SET
            id_proyecto = v_parametros.id_proyecto,
            fecha_desde = v_parametros.fecha_desde,
            fecha_hasta = v_parametros.fecha_hasta,
            descripcion = v_parametros.descripcion,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            WHERE id_proyecto_suspension=v_parametros.id_proyecto_suspension;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registros de Suspensiones modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_suspension',v_parametros.id_proyecto_suspension::varchar);
               
            --Devuelve la respuesta
            RETURN v_resp;
            
        END;

    /*********************************    
     #TRANSACCION:  'PRO_REGSUS_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        28-09-2020 19:25:30
    ***********************************/

    ELSIF (p_transaccion='PRO_REGSUS_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM pro.tproyecto_suspension
            WHERE id_proyecto_suspension=v_parametros.id_proyecto_suspension;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Registros de Suspensiones eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_suspension',v_parametros.id_proyecto_suspension::varchar);
              
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
ALTER FUNCTION "pro"."ft_proyecto_suspension_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
