CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_activo_detalle_sel"(
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_activo_detalle_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_activo_detalle'
 AUTOR: 		 (admin)
 FECHA:	        10-10-2017 18:02:07
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_proyecto_activo_detalle_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_PRACDE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		10-10-2017 18:02:07
	***********************************/

	if(p_transaccion='PRO_PRACDE_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pracde.id_proyecto_activo_detalle,
						pracde.id_proyecto_activo,
						--pracde.id_comprobante,
						pracde.nro_cuenta,
						pracde.id_tipo_cc,
						pracde.porcentaje,
						pracde.monto,
						pracde.observaciones,
						pracde.estado_reg,
						pracde.id_usuario_ai,
						pracde.fecha_reg,
						pracde.usuario_ai,
						pracde.id_usuario_reg,
						pracde.fecha_mod,
						pracde.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						(select cue.nro_cuenta || '' - '' || cue.nombre_cuenta from conta.tcuenta cue where cue.nro_cuenta = pracde.nro_cuenta order by cue.id_cuenta limit 1) as desc_cuenta,
						--com.fecha,
						--com.nro_tramite,
						--com.glosa1,
						pracde.codigo_partida,
						(select par.codigo || '' - '' || par.nombre_partida from pre.tpartida par where par.codigo = pracde.codigo_partida order by par.id_partida limit 1) as desc_partida
						from pro.tproyecto_activo_detalle pracde
						inner join segu.tusuario usu1 on usu1.id_usuario = pracde.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pracde.id_usuario_mod
						--inner join conta.tint_comprobante com
						--on com.id_int_comprobante = pracde.id_comprobante
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRACDE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		10-10-2017 18:02:07
	***********************************/

	elsif(p_transaccion='PRO_PRACDE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proyecto_activo_detalle)
					    from pro.tproyecto_activo_detalle pracde
					    inner join segu.tusuario usu1 on usu1.id_usuario = pracde.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = pracde.id_usuario_mod
						--inner join conta.tint_comprobante com
						--on com.id_int_comprobante = pracde.id_comprobante
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
ALTER FUNCTION "pro"."ft_proyecto_activo_detalle_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
