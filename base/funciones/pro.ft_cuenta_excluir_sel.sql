CREATE OR REPLACE FUNCTION "pro"."ft_cuenta_excluir_sel"(
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_cuenta_excluir_sel
 DESCRIPCION:   Funcion para registro de las cuentas contables a excluir en el proceso de cierre de proyectos
 AUTOR: 		 (rchumacero)
 FECHA:	        06-01-2020 19:22:43
 COMENTARIOS:

***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 #51    PRO       ETR           06/01/2020  RCM         Creación del archivo
***************************************************************************
*/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_cuenta_excluir_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_CUNEXC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		06-01-2020 19:22:43
	***********************************/

	if(p_transaccion='PRO_CUNEXC_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						cunexc.id_cuenta_excluir,
						cunexc.id_cuenta,
						cunexc.estado_reg,
						cunexc.nro_cuenta,
						cunexc.usuario_ai,
						cunexc.fecha_reg,
						cunexc.id_usuario_reg,
						cunexc.id_usuario_ai,
						cunexc.fecha_mod,
						cunexc.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from pro.tcuenta_excluir cunexc
						inner join segu.tusuario usu1 on usu1.id_usuario = cunexc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cunexc.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_CUNEXC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		06-01-2020 19:22:43
	***********************************/

	elsif(p_transaccion='PRO_CUNEXC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_cuenta_excluir)
					    from pro.tcuenta_excluir cunexc
					    inner join segu.tusuario usu1 on usu1.id_usuario = cunexc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = cunexc.id_usuario_mod
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
ALTER FUNCTION "pro"."ft_cuenta_excluir_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
