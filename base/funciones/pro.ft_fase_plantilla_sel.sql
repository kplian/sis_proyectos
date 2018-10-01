CREATE OR REPLACE FUNCTION pro.ft_fase_plantilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_plantilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_plantilla'
 AUTOR: 		 (rchumacero)
 FECHA:	        15-08-2018 13:05:07
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-08-2018 13:05:07								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_plantilla'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_fase_plantilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_FASPLA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		rchumacero
 	#FECHA:		15-08-2018 13:05:07
	***********************************/

	if(p_transaccion='PRO_FASPLA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						faspla.id_fase_plantilla,
						faspla.id_fase_plantilla_fk,
						faspla.estado,
						faspla.descripcion,
						faspla.codigo,
						faspla.nombre,
						faspla.estado_reg,
						faspla.observaciones,
						faspla.id_usuario_ai,
						faspla.usuario_ai,
						faspla.fecha_reg,
						faspla.id_usuario_reg,
						faspla.fecha_mod,
						faspla.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from pro.tfase_plantilla faspla
						inner join segu.tusuario usu1 on usu1.id_usuario = faspla.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = faspla.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_FASPLA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		rchumacero
 	#FECHA:		15-08-2018 13:05:07
	***********************************/

	elsif(p_transaccion='PRO_FASPLA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_fase_plantilla)
					    from pro.tfase_plantilla faspla
					    inner join segu.tusuario usu1 on usu1.id_usuario = faspla.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = faspla.id_usuario_mod
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_FAPLARB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			RCM
 	#FECHA:			15-08-2018
	***********************************/

	elsif(p_transaccion='PRO_FAPLARB_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            faspla.id_fase_plantilla,
                            faspla.id_fase_plantilla_fk,
                            faspla.id_tipo_cc_plantilla,
                            faspla.codigo,
                            faspla.nombre,
                            faspla.descripcion,
                            faspla.observaciones,
                            faspla.estado,
                            tcc.codigo as codigo_tipo_cc,
                            tcc.descripcion as desc_tipo_cc,
                            faspla.estado_reg,
                            faspla.usuario_ai,
                            faspla.fecha_reg,
                            faspla.id_usuario_reg,
                            faspla.id_usuario_ai,
                            faspla.id_usuario_mod,
                            faspla.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            case
                            	when faspla.id_fase_plantilla_fk is null then
                                	''raiz''::varchar
                            	else
                                	''hijo''::varchar
                            end as tipo_nodo,
                            ''false''::varchar as checked
						from pro.tfase_plantilla faspla
						inner join segu.tusuario usu1 on usu1.id_usuario = faspla.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = faspla.id_usuario_mod
						left join param.ttipo_cc_plantilla tcc
						on tcc.id_tipo_cc_plantilla = faspla.id_tipo_cc_plantilla
				        where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro || ' ORDER BY faspla.codigo ';
raise notice 'FF: %',v_consulta;
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

ALTER FUNCTION pro.ft_fase_plantilla_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;