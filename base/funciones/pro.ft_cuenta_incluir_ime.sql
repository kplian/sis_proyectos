--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_cuenta_incluir_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_cuenta_incluir_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcuenta_incluir'
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

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_cuenta_incluir    INTEGER;

BEGIN

    v_nombre_funcion = 'pro.ft_cuenta_incluir_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_CUEINC_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez
     #FECHA:        19-10-2020 14:17:13
    ***********************************/

    IF (p_transaccion='PRO_CUEINC_INS') THEN

        BEGIN
            --Sentencia de la insercion
            INSERT INTO pro.tcuenta_incluir(
            estado_reg,
            nro_cuenta,
            tipo,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) VALUES (
            'activo',
            v_parametros.nro_cuenta,
            v_parametros.tipo,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null
            ) RETURNING id_cuenta_incluir into v_id_cuenta_incluir;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuentas a Incluir almacenado(a) con exito (id_cuenta_incluir'||v_id_cuenta_incluir||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_incluir',v_id_cuenta_incluir::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    /*********************************
     #TRANSACCION:  'PRO_CUEINC_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez
     #FECHA:        19-10-2020 14:17:13
    ***********************************/

    ELSIF (p_transaccion='PRO_CUEINC_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE pro.tcuenta_incluir SET
            nro_cuenta = v_parametros.nro_cuenta,
            tipo = v_parametros.tipo,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            WHERE id_cuenta_incluir=v_parametros.id_cuenta_incluir;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuentas a Incluir modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_incluir',v_parametros.id_cuenta_incluir::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    /*********************************
     #TRANSACCION:  'PRO_CUEINC_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez
     #FECHA:        19-10-2020 14:17:13
    ***********************************/

    ELSIF (p_transaccion='PRO_CUEINC_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM pro.tcuenta_incluir
            WHERE id_cuenta_incluir=v_parametros.id_cuenta_incluir;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Cuentas a Incluir eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_incluir',v_parametros.id_cuenta_incluir::varchar);

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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;