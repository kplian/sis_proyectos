CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_activo_det_mon_sel"(
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_activo_det_mon_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_activo_det_mon'
 AUTOR: 		 (rchumacero)
 FECHA:	        05-10-2018 18:01:38
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-10-2018 18:01:38								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_activo_det_mon'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_proyecto_activo_det_mon_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_ADETM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		05-10-2018 18:01:38
	***********************************/

	if(p_transaccion='PRO_ADETM_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						adetm.id_proyecto_activo_det_mon,
						adetm.id_proyecto_activo_detalle,
						adetm.id_moneda,
						adetm.importe_actualiz,
						adetm.estado_reg,
						adetm.id_usuario_ai,
						adetm.fecha_reg,
						adetm.usuario_ai,
						adetm.id_usuario_reg,
						adetm.fecha_mod,
						adetm.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						mon.codigo as desc_moneda,
						tcc.codigo as desc_tcc
						from pro.tproyecto_activo_det_mon adetm
						inner join segu.tusuario usu1 on usu1.id_usuario = adetm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = adetm.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda = adetm.id_moneda
						inner join pro.tproyecto_activo_detalle pad
						on pad.id_proyecto_activo_detalle = adetm.id_proyecto_activo_detalle
						inner join param.ttipo_cc tcc
						on tcc.id_tipo_cc = pad.id_tipo_cc
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_ADETM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		05-10-2018 18:01:38
	***********************************/

	elsif(p_transaccion='PRO_ADETM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proyecto_activo_det_mon)
					    from pro.tproyecto_activo_det_mon adetm
					    inner join segu.tusuario usu1 on usu1.id_usuario = adetm.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = adetm.id_usuario_mod
						inner join param.tmoneda mon on mon.id_moneda = adetm.id_moneda
						inner join pro.tproyecto_activo_detalle pad
						on pad.id_proyecto_activo_detalle = adetm.id_proyecto_activo_detalle
						inner join param.ttipo_cc tcc
						on tcc.id_tipo_cc = pad.id_tipo_cc
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
ALTER FUNCTION "pro"."ft_proyecto_activo_det_mon_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
