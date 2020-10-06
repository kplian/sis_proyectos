--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_proyecto_analisis_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_analisis_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_analisis'
 AUTOR:          (egutierrez)
 FECHA:            29-09-2020 12:44:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                29-09-2020 12:44:10    egutierrez             Creacion
 #
 ***************************************************************************/

DECLARE

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_proyecto_analisis    INTEGER;
    v_record_proyecto           record;
    v_record                    record;
    v_consulta                  varchar;
    v_id_gestion                integer;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_analisis_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PROANA_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:10
    ***********************************/

    IF (p_transaccion='PRO_PROANA_INS') THEN

        BEGIN
            SELECT
                pr.id_tipo_cc
            Into
                v_record_proyecto
            FROM pro.tproyecto pr
            WHERE pr.id_proyecto = v_parametros.id_proyecto ;

            --Sentencia de la insercion
            INSERT INTO pro.tproyecto_analisis(
            estado_reg,
            id_proyecto,
            fecha,
            glosa,
            estado,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod,
            id_proveedor
              ) VALUES (
            'activo',
            v_parametros.id_proyecto,
            v_parametros.fecha,
            v_parametros.glosa,
            v_parametros.estado,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null,
            v_parametros.id_proveedor
            ) RETURNING id_proyecto_analisis into v_id_proyecto_analisis;

            v_resp = pro.f_insertar_int_transaccion_tipo_cc(p_administrador,p_id_usuario,v_record_proyecto.id_tipo_cc,v_parametros.fecha,v_id_proyecto_analisis,0);

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Análisis Ingresos Diferidos almacenado(a) con exito (id_proyecto_analisis'||v_id_proyecto_analisis||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis',v_id_proyecto_analisis::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    /*********************************
     #TRANSACCION:  'PRO_PROANA_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:10
    ***********************************/

    ELSIF (p_transaccion='PRO_PROANA_MOD') THEN

        BEGIN
            SELECT
                pr.id_tipo_cc
            Into
                v_record_proyecto
            FROM pro.tproyecto pr
            WHERE pr.id_proyecto = v_parametros.id_proyecto;

            SELECT
            proa.fecha,
            proa.id_proveedor,
            pr.id_auxiliar
            INTO
            v_record
            FROM pro.tproyecto_analisis proa
            LEFT JOIN param.tproveedor pr on pr.id_proveedor = proa.id_proveedor
            WHERE proa.id_proyecto_analisis=v_parametros.id_proyecto_analisis;

            --Sentencia de la modificacion
            UPDATE pro.tproyecto_analisis SET
            id_proyecto = v_parametros.id_proyecto,
            fecha = v_parametros.fecha,
            glosa = v_parametros.glosa,
            estado = v_parametros.estado,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            id_proveedor = v_parametros.id_proveedor
            WHERE id_proyecto_analisis=v_parametros.id_proyecto_analisis;
            --Solo insertamos transacciones si se modifica la fecha
            IF (v_record.fecha <> v_parametros.fecha) or (v_record.id_proveedor <> v_parametros.id_proveedor) THEN
                v_resp = pro.f_insertar_int_transaccion_tipo_cc(p_administrador,p_id_usuario,v_record_proyecto.id_tipo_cc,v_parametros.fecha,v_parametros.id_proyecto_analisis,v_record.id_auxiliar);
            END IF;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Análisis Ingresos Diferidos modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis',v_parametros.id_proyecto_analisis::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    /*********************************
     #TRANSACCION:  'PRO_PROANA_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:10
    ***********************************/

    ELSIF (p_transaccion='PRO_PROANA_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM pro.tproyecto_analisis
            WHERE id_proyecto_analisis=v_parametros.id_proyecto_analisis;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Análisis Ingresos Diferidos eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis',v_parametros.id_proyecto_analisis::varchar);

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