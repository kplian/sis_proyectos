CREATE OR REPLACE FUNCTION pro.ft_proyecto_columna_tcc_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_columna_tcc_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_columna_tcc'
 AUTOR: 		 (rchumacero)
 FECHA:	        17-09-2018 15:27:06
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				17-09-2018 15:27:06								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_columna_tcc'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_proyecto_columna_tcc_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_COLTCC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		17-09-2018 15:27:06
	***********************************/

	if(p_transaccion='PRO_COLTCC_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						coltcc.id_proyecto_columna_tcc,
						coltcc.id_proyecto,
						coltcc.estado_reg,
						coltcc.id_tipo_cc,
						coltcc.usuario_ai,
						coltcc.fecha_reg,
						coltcc.id_usuario_reg,
						coltcc.id_usuario_ai,
						coltcc.fecha_mod,
						coltcc.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tcc.codigo as codigo_cc
						from pro.tproyecto_columna_tcc coltcc
						inner join segu.tusuario usu1 on usu1.id_usuario = coltcc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = coltcc.id_usuario_mod
						inner join param.ttipo_cc tcc
						on tcc.id_tipo_cc = coltcc.id_tipo_cc
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by coltcc.id_tipo_cc ';--limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COLTCC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		17-09-2018 15:27:06
	***********************************/

	elsif(p_transaccion='PRO_COLTCC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proyecto_columna_tcc)
					    from pro.tproyecto_columna_tcc coltcc
					    inner join segu.tusuario usu1 on usu1.id_usuario = coltcc.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = coltcc.id_usuario_mod
						inner join param.ttipo_cc tcc
						on tcc.id_tipo_cc = coltcc.id_tipo_cc
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;