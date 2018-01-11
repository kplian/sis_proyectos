CREATE OR REPLACE FUNCTION "pro"."ft_contrato_pago_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_contrato_pago_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcontrato_pago'
 AUTOR: 		 (admin)
 FECHA:	        29-09-2017 17:05:48
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

	v_nombre_funcion = 'pro.ft_contrato_pago_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_CONPAG_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		29-09-2017 17:05:48
	***********************************/

	if(p_transaccion='PRO_CONPAG_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						conpag.id_contrato_pago,
						conpag.id_proyecto_contrato,
						conpag.fecha_plan,
						conpag.id_moneda,
						conpag.monto,
						conpag.fecha_pago,
						conpag.monto_pagado,
						conpag.estado_reg,
						conpag.id_usuario_ai,
						conpag.id_usuario_reg,
						conpag.usuario_ai,
						conpag.fecha_reg,
						conpag.id_usuario_mod,
						conpag.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						mon.moneda
						from pro.tcontrato_pago conpag
						inner join segu.tusuario usu1 on usu1.id_usuario = conpag.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conpag.id_usuario_mod
						inner join param.tmoneda mon
						on mon.id_moneda = conpag.id_moneda
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_CONPAG_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		29-09-2017 17:05:48
	***********************************/

	elsif(p_transaccion='PRO_CONPAG_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_contrato_pago)
					    from pro.tcontrato_pago conpag
					    inner join segu.tusuario usu1 on usu1.id_usuario = conpag.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = conpag.id_usuario_mod
						inner join param.tmoneda mon
						on mon.id_moneda = conpag.id_moneda
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
ALTER FUNCTION "pro"."ft_contrato_pago_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
