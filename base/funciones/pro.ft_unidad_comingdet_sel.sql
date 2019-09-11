CREATE OR REPLACE FUNCTION pro.ft_unidad_comingdet_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_unidad_comingdet_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_comingdet'
 AUTOR: 		 (egutierrez)
 FECHA:	        08-08-2019 15:05:44
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				08-08-2019 15:05:44								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_comingdet'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_unidad_comingdet_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_UNCOM_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		egutierrez
 	#FECHA:		08-08-2019 15:05:44
	***********************************/

	if(p_transaccion='PRO_UNCOM_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						uncom.id_unidad_comingdet,
						uncom.id_unidad_constructiva,
						uncom.cantidad_asignada,
						uncom.id_componente_concepto_ingas_det,
						uncom.estado_reg,
						uncom.id_usuario_ai,
						uncom.fecha_reg,
						uncom.usuario_ai,
						uncom.id_usuario_reg,
						uncom.fecha_mod,
						uncom.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        (COALESCE(uc.codigo,'''')||''-''||COALESCE(uc.nombre,''''))::varchar as desc_uc
						from pro.tunidad_comingdet uncom
						inner join segu.tusuario usu1 on usu1.id_usuario = uncom.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uncom.id_usuario_mod
                        left join pro.tunidad_constructiva uc on uc.id_unidad_constructiva = uncom.id_unidad_constructiva
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
            raise notice 'v_consulta %',v_consulta;
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_UNCOM_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		egutierrez
 	#FECHA:		08-08-2019 15:05:44
	***********************************/

	elsif(p_transaccion='PRO_UNCOM_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_unidad_comingdet)
					    from pro.tunidad_comingdet uncom
					    inner join segu.tusuario usu1 on usu1.id_usuario = uncom.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = uncom.id_usuario_mod
                        left join pro.tunidad_constructiva uc on uc.id_unidad_constructiva = uncom.id_unidad_constructiva
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