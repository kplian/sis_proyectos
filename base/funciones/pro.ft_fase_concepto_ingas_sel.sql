CREATE OR REPLACE FUNCTION "pro"."ft_fase_concepto_ingas_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_concepto_ingas_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_concepto_ingas'
 AUTOR: 		 (admin)
 FECHA:	        24-05-2018 19:13:39
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				24-05-2018 19:13:39								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_concepto_ingas'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'pro.ft_fase_concepto_ingas_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	if(p_transaccion='PRO_FACOING_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						facoing.id_fase_concepto_ingas,
						facoing.id_fase,
						facoing.id_concepto_ingas,
						facoing.id_unidad_medida,
						facoing.tipo_cambio_mt,
						facoing.descripcion,
						facoing.tipo_cambio_mb,
						facoing.estado,
						facoing.estado_reg,
						facoing.cantidad,
						facoing.precio_mb,
						facoing.precio,
						facoing.precio_mt,
						facoing.id_usuario_ai,
						facoing.usuario_ai,
						facoing.fecha_reg,
						facoing.id_usuario_reg,
						facoing.id_usuario_mod,
						facoing.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						cig.desc_ingas,
						cig.tipo,
						ume.codigo as desc_unidad_medida,
						coalesce(facoing.precio*facoing.cantidad) as precio_total
						from pro.tfase_concepto_ingas facoing
						inner join segu.tusuario usu1 on usu1.id_usuario = facoing.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = facoing.id_usuario_mod
						inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
						inner join param.tunidad_medida ume on ume.id_unidad_medida = facoing.id_unidad_medida
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	elsif(p_transaccion='PRO_FACOING_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_fase_concepto_ingas)
					    from pro.tfase_concepto_ingas facoing
					    inner join segu.tusuario usu1 on usu1.id_usuario = facoing.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = facoing.id_usuario_mod
						inner join param.tconcepto_ingas cig
						on cig.id_concepto_ingas = facoing.id_concepto_ingas
						inner join param.tunidad_medida ume
						on ume.id_unidad_medida = facoing.id_unidad_medida
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
ALTER FUNCTION "pro"."ft_fase_concepto_ingas_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
