CREATE OR REPLACE FUNCTION "pro"."ft_fase_avance_obs_ime" (
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_avance_obs_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_avance_obs'
 AUTOR: 		 (rchumacero)
 FECHA:	        15-10-2018 19:59:14
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-10-2018 19:59:14								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_avance_obs'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase_avance_obs	integer;

BEGIN

    v_nombre_funcion = 'pro.ft_fase_avance_obs_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_FAAVOB_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-10-2018 19:59:14
	***********************************/

	if(p_transaccion='PRO_FAAVOB_INS')then

        begin
        	--Sentencia de la insercion
        	insert into pro.tfase_avance_obs(
			id_fase,
			fecha,
			observaciones,
			porcentaje,
			estado_reg,
			tipo,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			fecha_mod,
			id_usuario_mod,
			id_proyecto
          	) values(
			v_parametros.id_fase,
			v_parametros.fecha,
			v_parametros.observaciones,
			v_parametros.porcentaje,
			'activo',
			v_parametros.tipo,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null,
			v_parametros.id_proyecto
			)RETURNING id_fase_avance_obs into v_id_fase_avance_obs;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Avance Visual almacenado(a) con exito (id_fase_avance_obs'||v_id_fase_avance_obs||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_avance_obs',v_id_fase_avance_obs::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_FAAVOB_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-10-2018 19:59:14
	***********************************/

	elsif(p_transaccion='PRO_FAAVOB_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tfase_avance_obs set
			id_fase = v_parametros.id_fase,
			fecha = v_parametros.fecha,
			observaciones = v_parametros.observaciones,
			porcentaje = v_parametros.porcentaje,
			tipo = v_parametros.tipo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			id_proyecto = v_parametros.id_proyecto
			where id_fase_avance_obs=v_parametros.id_fase_avance_obs;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Avance Visual modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_avance_obs',v_parametros.id_fase_avance_obs::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_FAAVOB_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-10-2018 19:59:14
	***********************************/

	elsif(p_transaccion='PRO_FAAVOB_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tfase_avance_obs
            where id_fase_avance_obs=v_parametros.id_fase_avance_obs;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Avance Visual eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_avance_obs',v_parametros.id_fase_avance_obs::varchar);

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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pro"."ft_fase_avance_obs_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
