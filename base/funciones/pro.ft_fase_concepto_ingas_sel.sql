CREATE OR REPLACE FUNCTION pro.ft_fase_concepto_ingas_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
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
 #5 endeEtr         09/01/2019          EGS                     se aumento totalizadores en count total_precio y total_precio_real
 #7	  endeETR		29/01/2019	        EGS				        Se agrego los campos de id_invitacion_det ,id_solicitud_det y codigo_inv
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_item				record;
    v_bandera			VARCHAR;
    dias_vigentes		integer;
			    
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
			v_consulta:='
                    with total_prorrateo(
                        id_fase_concepto_ingas,
                        total_prorrateo
                    )as(
                        SELECT
                            facoinpa.id_fase_concepto_ingas,
                            sum(facoinpa.importe)
                        FROM pro.tfase_concepto_ingas_pago facoinpa
                        GROUP by facoinpa.id_fase_concepto_ingas
                    
                    )                   
                    select
						facoing.id_fase_concepto_ingas,
						facoing.id_fase,
						facoing.id_concepto_ingas,
						facoing.id_unidad_medida,
						facoing.tipo_cambio_mt,
						facoing.descripcion,
						facoing.tipo_cambio_mb,
						facoing.estado,
						facoing.estado_reg,
						facoing.cantidad_est,
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
                        fase.codigo as codigo_fase,
                        fase.nombre as nombre_fase,
                        fase.id_proyecto,
                        ''hoja''::varchar as tipo_nodo,
						coalesce(facoing.precio*facoing.cantidad_est) as precio_total,
                        facoing.fecha_estimada,
                        facoing.fecha_fin,
                        pro.estado as estado_proyecto,
                        facoing.id_funcionario,
                        fun.desc_funcionario1::VARCHAR as desc_funcionario,
                        facoing.precio_real,
                        total_prorrateo,
                        invd.id_invitacion_det, --#7
                        invd.id_solicitud_det,  --#7                      
                        inv.codigo as codigo_inv --#7
						from pro.tfase_concepto_ingas facoing
						inner join segu.tusuario usu1 on usu1.id_usuario = facoing.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = facoing.id_usuario_mod
						inner join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
						inner join param.tunidad_medida ume on ume.id_unidad_medida = facoing.id_unidad_medida
                        left join pro.tfase fase on fase.id_fase = facoing.id_fase
                        left join orga.vfuncionario fun on fun.id_funcionario = facoing.id_funcionario
                        left join pro.tproyecto pro on pro.id_proyecto = fase.id_proyecto
                        left join total_prorrateo tpro on tpro.id_fase_concepto_ingas =  facoing.id_fase_concepto_ingas
                        left join pro.tinvitacion_det invd on invd.id_fase_concepto_ingas= facoing.id_fase_concepto_ingas
                        left join pro.tinvitacion inv on inv.id_invitacion= invd.id_invitacion                    
				        where  ';
			--raise exception 'v_consulta %',v_consulta;
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
			v_consulta:='select count(facoing.id_fase_concepto_ingas),
                        Sum(facoing.precio)::numeric as total_precio,-- #5
                        Sum(facoing.precio_real)::numeric as total_precio_real-- #5
					    from pro.tfase_concepto_ingas facoing
					    inner join segu.tusuario usu1 on usu1.id_usuario = facoing.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = facoing.id_usuario_mod
						inner join param.tconcepto_ingas cig
						on cig.id_concepto_ingas = facoing.id_concepto_ingas
						inner join param.tunidad_medida ume on ume.id_unidad_medida = facoing.id_unidad_medida
                        left join pro.tfase fase on fase.id_fase = facoing.id_fase
                        left join pro.tinvitacion_det invd on invd.id_fase_concepto_ingas= facoing.id_fase_concepto_ingas
                        left join pro.tinvitacion inv on inv.id_invitacion= invd.id_invitacion                      
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
          /*********************************    
          #TRANSACCION:  'PRO_FACOINGPRO_SEL'
          #DESCRIPCION:	Consulta de datos de conceptos programados
          #AUTOR:		EGS	
          #FECHA:		24-05-2018 19:13:39
          ***********************************/

          ElSIF(p_transaccion='PRO_FACOINGPRO_SEL')then
           				
              begin 	
              	   
              	v_bandera = split_part(pxp.f_get_variable_global('py_compras_dias_venc'), ',', 1);
              
                  --raise exception 'entra';
                  --Sentencia de la consulta
                  v_consulta:='              
                  WITH  doc_invitacion(					
 									id_invitacion_det,
                                    id_fase_concepto_ingas                                                                                                   
                              ) 
                           as (
                                    select 
                                       invd.id_invitacion_det,                                      
                                       invd.id_fase_concepto_ingas
                                  from pro.tinvitacion_det invd
                                  where invd.id_fase_concepto_ingas is not null
                           ),
                estado_tiempo(					
 									id_fase_concepto_ingas,
                                    estado                                                                                                   
                              ) 
                           as (
                              select        
                              facoing.id_fase_concepto_ingas,
                              CASE
                              WHEN	((facoing.fecha_estimada-now()::date)::integer) < 0	THEN
                              		''vencido''::varchar
                              WHEN	0 <= ((facoing.fecha_estimada-now()::date)::integer) and ((facoing.fecha_estimada-now()::date)::integer) <= '||v_bandera::integer||'	THEN
                              		''vigente''::varchar
                              ELSE
                              		''otros''::varchar
                              END AS estado
                              from pro.tfase_concepto_ingas facoing
                           )  
 				select        facoing.id_fase_concepto_ingas,
                              facoing.id_fase,
                              facoing.id_concepto_ingas,
                              facoing.id_unidad_medida,
                              facoing.tipo_cambio_mt,
                              facoing.descripcion,
                              facoing.tipo_cambio_mb,
                              facoing.estado,
                              facoing.estado_reg,
                              facoing.cantidad_est,
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
                              fase.codigo as codigo_fase,
                              fase.nombre as nombre_fase,
                              fase.id_proyecto,
                              facoing.fecha_estimada,
                              doc.id_invitacion_det,
                              (facoing.fecha_estimada-now()::date)::integer as dias,
                              est.estado::varchar as estado_tiempo
                              from pro.tfase_concepto_ingas facoing
                              inner join segu.tusuario usu1 on usu1.id_usuario = facoing.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = facoing.id_usuario_mod
                              left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
                              left join pro.tfase fase on fase.id_fase = facoing.id_fase
                              LEFT JOIN doc_invitacion doc on doc.id_fase_concepto_ingas = facoing.id_fase_concepto_ingas
                              LEFT JOIN estado_tiempo est on est.id_fase_concepto_ingas = facoing.id_fase_concepto_ingas
                              where doc.id_invitacion_det is NULL and ';
                  --raise exception 'v_consulta %',v_consulta;
                  --Definicion de la respuesta
                  v_consulta:=v_consulta||v_parametros.filtro;
                  v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
      		
                  --Devuelve la respuesta
                  return v_consulta;
      						
              end;

          /*********************************    
          #TRANSACCION:  'PRO_FACOINGPRO_CONT'
          #DESCRIPCION:	Conteo de registros  de conceptos programados
          #AUTOR:		EGS	
          #FECHA:		24-05-2018 19:13:39
          ***********************************/

          elsif(p_transaccion='PRO_FACOINGPRO_CONT')then

              begin
                  --Sentencia de la consulta de conteo de registros
                  v_consulta:='
                  WITH  doc_invitacion(					
 									id_invitacion_det,
                                    id_fase_concepto_ingas                                                                                                   
                              ) 
                           as (
                                    select 
                                       invd.id_invitacion_det,                                      
                                       invd.id_fase_concepto_ingas
                                  from pro.tinvitacion_det invd
                                  where invd.id_fase_concepto_ingas is not null
                           ),
                estado_tiempo(					
 									id_fase_concepto_ingas,
                                    estado                                                                                                   
                              ) 
                           as (
                              select        
                              facoing.id_fase_concepto_ingas,
                              CASE
                              WHEN	((facoing.fecha_estimada-now()::date)::integer) < 0	THEN
                              		''vencido''::varchar
                              WHEN	0 <= ((facoing.fecha_estimada-now()::date)::integer) and ((facoing.fecha_estimada-now()::date)::integer) <= 60	THEN
                              		''vigente''::varchar
                              ELSE
                              		''otros''::varchar
                              END AS estado
                              from pro.tfase_concepto_ingas facoing
                           )  
                  select count(facoing.id_fase_concepto_ingas)
                              from pro.tfase_concepto_ingas facoing
                              inner join segu.tusuario usu1 on usu1.id_usuario = facoing.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = facoing.id_usuario_mod
                              inner join param.tconcepto_ingas cig
                              on cig.id_concepto_ingas = facoing.id_concepto_ingas
                              inner join param.tunidad_medida ume on ume.id_unidad_medida = facoing.id_unidad_medida
                              left join pro.tfase fase on fase.id_fase = facoing.id_fase 
                              LEFT JOIN doc_invitacion doc on doc.id_fase_concepto_ingas = facoing.id_fase_concepto_ingas
                              LEFT JOIN estado_tiempo est on est.id_fase_concepto_ingas = facoing.id_fase_concepto_ingas
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