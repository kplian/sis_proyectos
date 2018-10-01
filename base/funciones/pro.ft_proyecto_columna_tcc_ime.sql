CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_columna_tcc_ime" (
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_columna_tcc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_columna_tcc'
 AUTOR: 		 (rchumacero)
 FECHA:	        17-09-2018 15:27:06
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				17-09-2018 15:27:06								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_columna_tcc'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_proyecto_columna_tcc	integer;
	v_id_tipo_cc			integer;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_columna_tcc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_COLTCC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		17-09-2018 15:27:06
	***********************************/

	if(p_transaccion='PRO_COLTCC_INS')then

        begin
        	--Sentencia de la insercion
        	insert into pro.tproyecto_columna_tcc(
			id_proyecto,
			estado_reg,
			id_tipo_cc,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_proyecto,
			'activo',
			v_parametros.id_tipo_cc,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
			)RETURNING id_proyecto_columna_tcc into v_id_proyecto_columna_tcc;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas almacenado(a) con exito (id_proyecto_columna_tcc'||v_id_proyecto_columna_tcc||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_columna_tcc',v_id_proyecto_columna_tcc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COLTCC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		17-09-2018 15:27:06
	***********************************/

	elsif(p_transaccion='PRO_COLTCC_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tproyecto_columna_tcc set
			id_proyecto = v_parametros.id_proyecto,
			id_tipo_cc = v_parametros.id_tipo_cc,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_proyecto_columna_tcc=v_parametros.id_proyecto_columna_tcc;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_columna_tcc',v_parametros.id_proyecto_columna_tcc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COLTCC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		17-09-2018 15:27:06
	***********************************/

	elsif(p_transaccion='PRO_COLTCC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tproyecto_columna_tcc
            where id_proyecto_columna_tcc=v_parametros.id_proyecto_columna_tcc;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_columna_tcc',v_parametros.id_proyecto_columna_tcc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COLTCC_IMP'
 	#DESCRIPCION:	Creación de columnas del proyecto al importar cierre
 	#AUTOR:			RCM
 	#FECHA:			17-09-2018 15:27:06
	***********************************/

	elsif(p_transaccion='PRO_COLTCC_IMP')then

        begin
        	--Obtención ID del tipo CC
			select tcc.id_tipo_cc
			into v_id_tipo_cc
			from param.ttipo_cc tcc
			where tcc.codigo = v_parametros.centro_costo;

			if coalesce(v_id_tipo_cc,0) = 0 then
				raise exception 'Tipo CC no encontrado (%)',v_parametros.centro_costo;
			end if;

        	--Sentencia de la insercion
        	insert into pro.tproyecto_columna_tcc(
			id_proyecto,
			estado_reg,
			id_tipo_cc,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_proyecto,
			'activo',
			v_id_tipo_cc,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
			)RETURNING id_proyecto_columna_tcc into v_id_proyecto_columna_tcc;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas almacenado(a) con exito (id_proyecto_columna_tcc'||v_id_proyecto_columna_tcc||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_columna_tcc',v_id_proyecto_columna_tcc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COLTCCIMP_DEL'
 	#DESCRIPCION:	Elimina todas las columnas de un proyecto
 	#AUTOR:			RCM
 	#FECHA:			21-09-2018
	***********************************/

	elsif(p_transaccion='PRO_COLTCCIMP_DEL')then

        begin

        	if not exists(select 1 from pro.tproyecto
        				where id_proyecto = v_parametros.id_proyecto) then
        		raise exception 'Proyecto inexistente';
        	end if;

        	delete from pro.tproyecto_columna_tcc
        	where id_proyecto = v_parametros.id_proyecto;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Columnas eliminadas (id_proyecto '||v_parametros.id_proyecto||')');

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
ALTER FUNCTION "pro"."ft_proyecto_columna_tcc_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
