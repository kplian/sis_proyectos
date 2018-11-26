CREATE OR REPLACE FUNCTION "pro"."ft_fase_avance_obs_sel"(
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_avance_obs_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_avance_obs'
 AUTOR: 		 (rchumacero)
 FECHA:	        15-10-2018 19:59:14
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-10-2018 19:59:14								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_avance_obs'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_fase_avance_obs_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_FAAVOB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		15-10-2018 19:59:14
	***********************************/

	if(p_transaccion='PRO_FAAVOB_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						fao.id_fase_avance_obs,
						fao.id_fase,
						fao.fecha,
						fao.observaciones,
						fao.porcentaje,
						fao.estado_reg,
						fao.tipo,
						fao.id_usuario_ai,
						fao.id_usuario_reg,
						fao.usuario_ai,
						fao.fecha_reg,
						fao.fecha_mod,
						fao.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						fao.id_proyecto
						from pro.tfase_avance_obs fao
						inner join segu.tusuario usu1 on usu1.id_usuario = fao.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fao.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_FAAVOB_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-10-2018 19:59:14
	***********************************/

	elsif(p_transaccion='PRO_FAAVOB_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_fase_avance_obs)
					    from pro.tfase_avance_obs fao
					    inner join segu.tusuario usu1 on usu1.id_usuario = fao.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fao.id_usuario_mod
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	else

		raise exception 'Transaccion inexistente';

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
ALTER FUNCTION "pro"."ft_fase_avance_obs_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
