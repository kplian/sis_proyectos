CREATE OR REPLACE FUNCTION pro.ft_fase_concepto_ingas_pago_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_concepto_ingas_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_concepto_ingas_pago'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        14-12-2018 13:31:35
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				14-12-2018 13:31:35								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_concepto_ingas_pago'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'pro.ft_fase_concepto_ingas_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FACOINPA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		14-12-2018 13:31:35
	***********************************/

	if(p_transaccion='PRO_FACOINPA_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						facoinpa.id_fase_concepto_ingas_pago,
						facoinpa.id_fase_concepto_ingas,
						facoinpa.importe,
						facoinpa.fecha_pago,
						facoinpa.fecha_pago_real,
						facoinpa.estado_reg,
						facoinpa.id_usuario_ai,
						facoinpa.id_usuario_reg,
						facoinpa.usuario_ai,
						facoinpa.fecha_reg,
						facoinpa.id_usuario_mod,
						facoinpa.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from pro.tfase_concepto_ingas_pago facoinpa
						inner join segu.tusuario usu1 on usu1.id_usuario = facoinpa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = facoinpa.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOINPA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		14-12-2018 13:31:35
	***********************************/

	elsif(p_transaccion='PRO_FACOINPA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_fase_concepto_ingas_pago)
					    from pro.tfase_concepto_ingas_pago facoinpa
					    inner join segu.tusuario usu1 on usu1.id_usuario = facoinpa.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = facoinpa.id_usuario_mod
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
