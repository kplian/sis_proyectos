CREATE OR REPLACE FUNCTION pro.ft_invitacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_invitacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tinvitacion'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        22-08-2018 22:32:20
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				22-08-2018 22:32:20								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tinvitacion'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'pro.ft_invitacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_IVT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		22-08-2018 22:32:20
	***********************************/

	if(p_transaccion='PRO_IVT_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:=' 
            WITH   anio(
						id_invitacion,
							anio	
						)AS(
                        SELECT
                            inv.id_invitacion,
                            date_part(''year'',inv.fecha)as anio
                        from pro.tinvitacion inv

		                )
                select
						ivt.id_invitacion,
						ivt.id_proyecto,
						ivt.codigo,
						ivt.fecha,
						ivt.descripcion,
						ivt.fecha_real,
						ivt.estado_reg,
						ivt.estado,
						ivt.id_estado_wf,
						ivt.nro_tramite,
						ivt.id_usuario_ai,
						ivt.usuario_ai,
						ivt.fecha_reg,
						ivt.id_usuario_reg,
						ivt.id_usuario_mod,
						ivt.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        ivt.id_funcionario,
                        ivt.id_depto,
                        ivt.id_moneda,
                        ivt.tipo,
                        ivt.lugar_entrega,
                        ivt.dias_plazo_entrega,
                        mon.codigo as desc_moneda,
                        fun.desc_funcionario1::VARCHAR as desc_funcionario,
                        dep.nombre::VARCHAR	as desc_depto,
                        ew.id_proceso_wf,
                        an.anio::varchar,
                        ges.id_gestion
						from pro.tinvitacion ivt
                        left join param.tmoneda mon on mon.id_moneda = ivt.id_moneda
                        left join wf.testado_wf ew on ew.id_estado_wf = ivt.id_estado_wf
						left join segu.tusuario usu1 on usu1.id_usuario = ivt.id_usuario_reg
                        left join orga.vfuncionario fun on fun.id_funcionario = ivt.id_funcionario
                        left join param.tdepto dep on dep.id_depto = ew.id_depto 
						left join segu.tusuario usu2 on usu2.id_usuario = ivt.id_usuario_mod
                        
                        left join anio an on an.id_invitacion = ivt.id_invitacion
                        left JOIN param.tgestion ges on ges.gestion = an.anio
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_IVT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		22-08-2018 22:32:20
	***********************************/

	elsif(p_transaccion='PRO_IVT_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_invitacion)
					    from pro.tinvitacion ivt
                        left join param.tmoneda mon on mon.id_moneda = ivt.id_moneda
					   left join wf.testado_wf ew on ew.id_estado_wf = ivt.id_estado_wf
						left join segu.tusuario usu1 on usu1.id_usuario = ivt.id_usuario_reg
                        left join orga.vfuncionario fun on fun.id_funcionario = ew.id_funcionario
                        left join param.tdepto dep on dep.id_depto = ew.id_depto 
						left join segu.tusuario usu2 on usu2.id_usuario = ivt.id_usuario_mod
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

ALTER FUNCTION pro.ft_invitacion_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;