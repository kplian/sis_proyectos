--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_unidad_constructiva_tipo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_unidad_constructiva_tipo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_constructiva_tipo'
 AUTOR: 		 (egutierrez)
 FECHA:	        18-09-2019 19:13:12
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				18-09-2019 19:13:12								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_constructiva_tipo'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_unidad_constructiva_tipo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_UCT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		egutierrez
 	#FECHA:		18-09-2019 19:13:12
	***********************************/

	if(p_transaccion='PRO_UCT_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						uct.id_unidad_constructiva_tipo,
						uct.estado_reg,
						uct.componente_macro_tipo,
						uct.tension,
						uct.nombre,
						uct.descripcion,
						uct.id_usuario_reg,
						uct.fecha_reg,
						uct.id_usuario_ai,
						uct.usuario_ai,
						uct.id_usuario_mod,
						uct.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cat.descripcion as 	desc_componente_macro_tipo
						from pro.tunidad_constructiva_tipo uct
						inner join segu.tusuario usu1 on usu1.id_usuario = uct.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uct.id_usuario_mod
                        left join param.tcatalogo cat on cat.codigo = uct.componente_macro_tipo
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_UCT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		egutierrez
 	#FECHA:		18-09-2019 19:13:12
	***********************************/

	elsif(p_transaccion='PRO_UCT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_unidad_constructiva_tipo)
					    from pro.tunidad_constructiva_tipo uct
					    inner join segu.tusuario usu1 on usu1.id_usuario = uct.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uct.id_usuario_mod
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'PRO_UCTCB_SEL'
 	#DESCRIPCION:	Consulta de datos combo
 	#AUTOR:		egutierrez
 	#FECHA:		18-09-2019 19:13:12
	***********************************/

	elsif(p_transaccion='PRO_UCTCB_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						uct.id_unidad_constructiva_tipo,
						uct.estado_reg,
						uct.componente_macro_tipo,
						uct.tension,
						uct.nombre as desc_unidad_constructiva_tipo,
						uct.descripcion,
						cat.descripcion as 	desc_componente_macro_tipo
						from pro.tunidad_constructiva_tipo uct
                        left join param.tcatalogo cat on cat.codigo = uct.componente_macro_tipo
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_UCTCB_CONT'
 	#DESCRIPCION:	Conteo de registros combo
 	#AUTOR:		egutierrez
 	#FECHA:		18-09-2019 19:13:12
	***********************************/

	elsif(p_transaccion='PRO_UCTCB_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(uct.id_unidad_constructiva_tipo)
					    from pro.tunidad_constructiva_tipo uct
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