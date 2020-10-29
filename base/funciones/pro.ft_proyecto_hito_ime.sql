--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_proyecto_hito_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_hito_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_hito'
 AUTOR:          (egutierrez)
 FECHA:            28-09-2020 20:15:06
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                28-09-2020 20:15:06    egutierrez             Creacion
 #MDID-12              16/10/2020          EGS                   Se agrega validaciones de fecha no se repitan en el mismo codigo y gestion

 ***************************************************************************/

DECLARE

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_proyecto_hito         INTEGER;
    v_record                   RECORD;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_hito_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PROHIT_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez
     #FECHA:        28-09-2020 20:15:06
    ***********************************/

    IF (p_transaccion='PRO_PROHIT_INS') THEN

        BEGIN
            v_parametros.codigo = upper(REPLACE(v_parametros.codigo,' ',''));

            SELECT   --#MDID-12
                     date_part('month',t.fecha_plan) as mes,
                     date_part('month',t.fecha_real)as mes_real,
                     date_part('year',t.fecha_plan) as anio,
                     date_part('year',t.fecha_real)as anio_real
            Into
                v_record
            From pro.tproyecto_hito t
            WHERE t.id_proyecto = v_parametros.id_proyecto
              and t.codigo = v_parametros.codigo;

            IF v_record.mes =  date_part('month',v_parametros.fecha_plan)and v_record.anio =  date_part('year',v_parametros.fecha_plan) THEN
                RAISE EXCEPTION 'Ya existe un registro con el codigo % en el mes de la fecha planificada %',v_parametros.codigo,v_parametros.fecha_plan;
            END IF;

            IF v_record.mes_real =  date_part('month',v_parametros.fecha_real)and v_record.anio_real =  date_part('year',v_parametros.fecha_plan) THEN
                RAISE EXCEPTION 'Ya existe un registro con el codigo % en el mes de la fecha real %',v_parametros.codigo,v_parametros.fecha_real;

            END IF;



            --Sentencia de la insercion
            INSERT INTO pro.tproyecto_hito(
                estado_reg,
                id_proyecto,
                descripcion,
                fecha_plan,
                importe_plan,
                fecha_real,
                importe_real,
                observaciones,
                id_usuario_reg,
                fecha_reg,
                id_usuario_ai,
                usuario_ai,
                id_usuario_mod,
                fecha_mod,
                codigo
            ) VALUES (
                         'activo',
                         v_parametros.id_proyecto,
                         v_parametros.descripcion,
                         v_parametros.fecha_plan,
                         v_parametros.importe_plan,
                         v_parametros.fecha_real,
                         v_parametros.importe_real,
                         v_parametros.observaciones,
                         p_id_usuario,
                         now(),
                         v_parametros._id_usuario_ai,
                         v_parametros._nombre_usuario_ai,
                         null,
                         null,
                         v_parametros.codigo
                     ) RETURNING id_proyecto_hito into v_id_proyecto_hito;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Hitos de Negocio Complementario almacenado(a) con exito (id_proyecto_hito'||v_id_proyecto_hito||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_hito',v_id_proyecto_hito::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'PRO_PROHIT_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        egutierrez
         #FECHA:        28-09-2020 20:15:06
        ***********************************/

    ELSIF (p_transaccion='PRO_PROHIT_MOD') THEN

        BEGIN

            v_parametros.codigo = upper(REPLACE(v_parametros.codigo,' ',''));

            SELECT  --#MDID-12
                    date_part('month',t.fecha_plan) as mes,
                    date_part('month',t.fecha_real)as mes_real,
                    date_part('year',t.fecha_plan) as anio,
                    date_part('year',t.fecha_real)as anio_real
            Into
                v_record
            From pro.tproyecto_hito t
            WHERE t.id_proyecto = v_parametros.id_proyecto
              and t.codigo = v_parametros.codigo
              and t.id_proyecto_hito <> v_parametros.id_proyecto_hito;

            IF v_record.mes =  date_part('month',v_parametros.fecha_plan)and v_record.anio =  date_part('year',v_parametros.fecha_plan) THEN
                RAISE EXCEPTION 'Ya existe un registro con el codigo % en el mes de la fecha planificada %',v_parametros.codigo,v_parametros.fecha_plan;
            END IF;

            IF v_record.mes_real =  date_part('month',v_parametros.fecha_real)and v_record.anio_real =  date_part('year',v_parametros.fecha_plan) THEN
                RAISE EXCEPTION 'Ya existe un registro con el codigo % en el mes de la fecha real %',v_parametros.codigo,v_parametros.fecha_real;

            END IF;

            --Sentencia de la modificacion
            UPDATE pro.tproyecto_hito SET
                                          id_proyecto = v_parametros.id_proyecto,
                                          descripcion = v_parametros.descripcion,
                                          fecha_plan = v_parametros.fecha_plan,
                                          importe_plan = v_parametros.importe_plan,
                                          fecha_real = v_parametros.fecha_real,
                                          importe_real = v_parametros.importe_real,
                                          observaciones = v_parametros.observaciones,
                                          id_usuario_mod = p_id_usuario,
                                          fecha_mod = now(),
                                          id_usuario_ai = v_parametros._id_usuario_ai,
                                          usuario_ai = v_parametros._nombre_usuario_ai,
                                          codigo = v_parametros.codigo
            WHERE id_proyecto_hito=v_parametros.id_proyecto_hito;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Hitos de Negocio Complementario modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_hito',v_parametros.id_proyecto_hito::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'PRO_PROHIT_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        egutierrez
         #FECHA:        28-09-2020 20:15:06
        ***********************************/

    ELSIF (p_transaccion='PRO_PROHIT_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM pro.tproyecto_hito
            WHERE id_proyecto_hito=v_parametros.id_proyecto_hito;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Hitos de Negocio Complementario eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_hito',v_parametros.id_proyecto_hito::varchar);

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