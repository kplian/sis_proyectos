CREATE OR REPLACE FUNCTION pro.ft_invitacion_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_invitacion_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tinvitacion_det'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        22-08-2018 22:32:59
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				22-08-2018 22:32:59								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tinvitacion_det'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'pro.ft_invitacion_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_IVTD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		22-08-2018 22:32:59
	***********************************/

	if(p_transaccion='PRO_IVTD_SEL')then
  
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						ivtd.id_invitacion_det,
						ivtd.id_fase_concepto_ingas,
						ivtd.id_invitacion,
						ivtd.estado_reg,
						ivtd.observaciones,
						ivtd.id_usuario_reg,
						ivtd.usuario_ai,
						ivtd.fecha_reg,
						ivtd.id_usuario_ai,
						ivtd.fecha_mod,
						ivtd.id_usuario_mod,
                        ivtd.cantidad_sol,
                        ivtd.id_unidad_medida,
                        ivtd.precio,
                        fas.codigo || '' – '' || fas.nombre as desc_fase,
                        cig.tipo || '' – '' || cig.desc_ingas as desc_ingas,
                        facoing.cantidad_est as cantidad_est,
                        facoing.precio as precio_est,
                        ivtd.id_centro_costo,
                        ivtd.descripcion,
                        cec.codigo_cc::varchar,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from pro.tinvitacion_det ivtd
						inner join segu.tusuario usu1 on usu1.id_usuario = ivtd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ivtd.id_usuario_mod
                        left join pro.tfase_concepto_ingas facoing on facoing.id_fase_concepto_ingas=ivtd.id_fase_concepto_ingas
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
                        left join param.tunidad_medida um on um.id_unidad_medida = ivtd.id_unidad_medida
                        left join pro.tfase fas on fas.id_fase = facoing.id_fase
                        left join param.vcentro_costo cec on cec.id_centro_costo = ivtd.id_centro_costo
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_IVTD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		22-08-2018 22:32:59
	***********************************/

	elsif(p_transaccion='PRO_IVTD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_invitacion_det)
					    from pro.tinvitacion_det ivtd
					    inner join segu.tusuario usu1 on usu1.id_usuario = ivtd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ivtd.id_usuario_mod
					   	left join pro.tfase_concepto_ingas facoing on facoing.id_fase_concepto_ingas=ivtd.id_fase_concepto_ingas
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
                        left join param.tunidad_medida um on um.id_unidad_medida = ivtd.id_unidad_medida
                        left join pro.tfase fas on fas.id_fase = facoing.id_fase
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

ALTER FUNCTION pro.ft_invitacion_det_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;