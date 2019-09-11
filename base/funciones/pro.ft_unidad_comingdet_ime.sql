CREATE OR REPLACE FUNCTION pro.ft_unidad_comingdet_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_unidad_comingdet_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_comingdet'
 AUTOR: 		 (egutierrez)
 FECHA:	        08-08-2019 15:05:44
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				08-08-2019 15:05:44								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_comingdet'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros            record;
    v_id_requerimiento      integer;
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_unidad_comingdet   integer;
    v_cantidad_est          numeric;
    v_cantidad_asignada     numeric;

BEGIN

    v_nombre_funcion = 'pro.ft_unidad_comingdet_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_UNCOM_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez
     #FECHA:        08-08-2019 15:05:44
    ***********************************/

    if(p_transaccion='PRO_UNCOM_INS')then

        begin

            SELECT
                ccig.cantidad_est
            INTO
                v_cantidad_est
            FROM pro.tcomponente_concepto_ingas_det ccig
            WHERE ccig.id_componente_concepto_ingas_det = v_parametros.id_componente_concepto_ingas_det;
            IF v_cantidad_est is null or v_cantidad_est = 0 THEN
                RAISE EXCEPTION 'Ingrese una cantidad en el detalle Ingreso/Gasto';
            END IF;

            SELECT
                    SUM(COALESCE(t.cantidad_asignada,0))
            INTO
                v_cantidad_asignada
            FROM pro.tunidad_comingdet t
            WHERE t.id_componente_concepto_ingas_det = v_parametros.id_componente_concepto_ingas_det;

            IF (v_cantidad_asignada + COALESCE(v_parametros.cantidad_asignada,0)) > v_cantidad_est THEN
                RAISE EXCEPTION 'La suma de las cantidades asignadas ( % + % )  a Unidades Constructivas Sobrepasan a la cantidad del detalle (%)',v_cantidad_asignada, COALESCE(v_parametros.cantidad_asignada,0),v_cantidad_est;
            END IF;

            --Sentencia de la insercion
            insert into pro.tunidad_comingdet(
            id_unidad_constructiva,
            cantidad_asignada,
            id_componente_concepto_ingas_det,
            estado_reg,
            id_usuario_ai,
            fecha_reg,
            usuario_ai,
            id_usuario_reg,
            fecha_mod,
            id_usuario_mod
              ) values(
            v_parametros.id_unidad_constructiva,
            v_parametros.cantidad_asignada,
            v_parametros.id_componente_concepto_ingas_det,
            'activo',
            v_parametros._id_usuario_ai,
            now(),
            v_parametros._nombre_usuario_ai,
            p_id_usuario,
            null,
            null



            )RETURNING id_unidad_comingdet into v_id_unidad_comingdet;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidad constructiva almacenado(a) con exito (id_unidad_comingdet'||v_id_unidad_comingdet||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_comingdet',v_id_unidad_comingdet::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_UNCOM_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez
     #FECHA:        08-08-2019 15:05:44
    ***********************************/

    elsif(p_transaccion='PRO_UNCOM_MOD')then

        begin
            SELECT
                ccig.cantidad_est
            INTO
                v_cantidad_est
            FROM pro.tcomponente_concepto_ingas_det ccig
            WHERE ccig.id_componente_concepto_ingas_det = v_parametros.id_componente_concepto_ingas_det;
            IF v_cantidad_est is null or v_cantidad_est = 0 THEN
                RAISE EXCEPTION 'Ingrese una cantidad en el detalle Ingreso/Gasto';
            END IF;

            SELECT
                    SUM(COALESCE(t.cantidad_asignada,0))
            INTO
                v_cantidad_asignada
            FROM pro.tunidad_comingdet t
            WHERE t.id_componente_concepto_ingas_det = v_parametros.id_componente_concepto_ingas_det and id_unidad_comingdet<>v_parametros.id_unidad_comingdet ;

            IF (v_cantidad_asignada + COALESCE(v_parametros.cantidad_asignada,0)) > v_cantidad_est THEN
                RAISE EXCEPTION 'La suma de las cantidades asignadas ( % + % )  a Unidades Constructivas Sobrepasan a la cantidad del detalle (%)',v_cantidad_asignada, COALESCE(v_parametros.cantidad_asignada,0),v_cantidad_est;
            END IF;
            --Sentencia de la modificacion
            update pro.tunidad_comingdet set
            id_unidad_constructiva = v_parametros.id_unidad_constructiva,
            cantidad_asignada = v_parametros.cantidad_asignada,
            id_componente_concepto_ingas_det = v_parametros.id_componente_concepto_ingas_det,
            fecha_mod = now(),
            id_usuario_mod = p_id_usuario,
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            where id_unidad_comingdet=v_parametros.id_unidad_comingdet;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidad constructiva modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_comingdet',v_parametros.id_unidad_comingdet::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_UNCOM_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez
     #FECHA:        08-08-2019 15:05:44
    ***********************************/

    elsif(p_transaccion='PRO_UNCOM_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tunidad_comingdet
            where id_unidad_comingdet=v_parametros.id_unidad_comingdet;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidad constructiva eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_comingdet',v_parametros.id_unidad_comingdet::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

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