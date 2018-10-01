CREATE OR REPLACE FUNCTION pro.ft_fase_plantilla_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_plantilla_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_plantilla'
 AUTOR: 		 (rchumacero)
 FECHA:	        15-08-2018 13:05:07
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-08-2018 13:05:07								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_plantilla'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase_plantilla		integer;
	v_id_fase_plantilla_fk	integer;
	v_estado				varchar;
	v_rec 					record;
	v_id_fk					integer;

BEGIN

    v_nombre_funcion = 'pro.ft_fase_plantilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_FASPLA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-08-2018 13:05:07
	***********************************/
	if(p_transaccion='PRO_FASPLA_INS')then

        begin

        	v_estado = 'borrador';

        	--Verifica el padre
            if v_parametros.id_fase_plantilla_fk = 'id' or v_parametros.id_fase_plantilla_fk = '' then
                v_id_fase_plantilla_fk = null;
            else
                v_id_fase_plantilla_fk = v_parametros.id_fase_plantilla_fk::integer;
            end if;

        	--Sentencia de la insercion
        	insert into pro.tfase_plantilla(
			id_fase_plantilla_fk,
			estado,
			descripcion,
			codigo,
			nombre,
			estado_reg,
			observaciones,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
			id_tipo_cc_plantilla
          	) values(
			v_id_fase_plantilla_fk,
			v_estado,
			v_parametros.descripcion,
			v_parametros.codigo,
			v_parametros.nombre,
			'activo',
			v_parametros.observaciones,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null,
			v_parametros.id_tipo_cc_plantilla
			) RETURNING id_fase_plantilla into v_id_fase_plantilla;

			--Replica el árbol de la plantilla del Tipo CC
			for v_rec in (
						with recursive t(id,id_fk,nombre,n) as (
						    select fp.id_tipo_cc_plantilla, fp.id_tipo_cc_fk, fp.codigo, 1
						    from param.ttipo_cc_plantilla fp
						    where fp.id_tipo_cc_plantilla = v_parametros.id_tipo_cc_plantilla
						    union all
						    select fp.id_tipo_cc_plantilla, fp.id_tipo_cc_fk, fp.codigo, n+1
						    from param.ttipo_cc_plantilla fp, t
						    where fp.id_tipo_cc_fk = t.id
						)
						select t.id, t.id_fk, tccp.codigo, tccp.descripcion
						from t
						inner join param.ttipo_cc_plantilla tccp
						on tccp.id_tipo_cc_plantilla = t.id
					) loop

				--Verificar si es nodo raíz (id_fk nulo)
				if coalesce(v_rec.id_fk,0) = 0 then

					v_id_fase_plantilla_fk = v_id_fase_plantilla;

		        else

		        	select id_fase_plantilla
		        	into v_id_fase_plantilla_fk
		        	from pro.tfase_plantilla
		        	where id_tmp = v_rec.id_fk;

				end if;

				--Sentencia de la insercion
	        	insert into pro.tfase_plantilla(
				id_fase_plantilla_fk,
				estado,
				descripcion,
				codigo,
				nombre,
				estado_reg,
				id_usuario_ai,
				usuario_ai,
				fecha_reg,
				id_usuario_reg,
				fecha_mod,
				id_usuario_mod,
				id_tmp
	          	) values(
				v_id_fase_plantilla_fk,
				v_estado,
				v_rec.descripcion,
				v_rec.codigo,
				v_rec.descripcion,
				'activo',
				v_parametros._id_usuario_ai,
				v_parametros._nombre_usuario_ai,
				now(),
				p_id_usuario,
				null,
				null,
				v_rec.id
				) returning id_fase_plantilla into v_id_fase_plantilla;

			end loop;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla almacenado(a) con exito (id_fase_plantilla'||v_id_fase_plantilla||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_plantilla',v_id_fase_plantilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_FASPLA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-08-2018 13:05:07
	***********************************/

	elsif(p_transaccion='PRO_FASPLA_MOD')then

		begin

			--Verifica el padre
            if v_parametros.id_fase_plantilla_fk = 'id' or v_parametros.id_fase_plantilla_fk = '' then
                v_id_fase_plantilla_fk = null;
            else
                v_id_fase_plantilla_fk = v_parametros.id_fase_plantilla_fk::integer;
            end if;

			--Sentencia de la modificacion
			update pro.tfase_plantilla set
			id_fase_plantilla_fk = v_id_fase_plantilla_fk,
			descripcion = v_parametros.descripcion,
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			observaciones = v_parametros.observaciones,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			id_tipo_cc_plantilla = v_parametros.id_tipo_cc_plantilla
			where id_fase_plantilla=v_parametros.id_fase_plantilla;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_plantilla',v_parametros.id_fase_plantilla::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_FASPLA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-08-2018 13:05:07
	***********************************/

	elsif(p_transaccion='PRO_FASPLA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tfase_plantilla
            where id_fase_plantilla=v_parametros.id_fase_plantilla;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Plantilla eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_plantilla',v_parametros.id_fase_plantilla::varchar);

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

ALTER FUNCTION pro.ft_fase_plantilla_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;