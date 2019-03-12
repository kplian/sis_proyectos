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
 #5                 09/01/2019          EGS                     Se corrigio consulta 
 #7	  endeETR		29/01/2019	        EGS				        se creo las funciones para listar combos procesos de solicitudes de compra y sus detalles 
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
                        ges.id_gestion,
                        ivt.id_categoria_compra,
                        ivt.id_solicitud,
                        ivt.id_presolicitud,
                        ivt.pre_solicitud,
                        ivt.id_grupo,
                        cat.nombre as desc_categoria_compra,
                        gru.nombre as desc_grupo
						from pro.tinvitacion ivt
                        left join param.tmoneda mon on mon.id_moneda = ivt.id_moneda
                        left join wf.testado_wf ew on ew.id_estado_wf = ivt.id_estado_wf
						left join segu.tusuario usu1 on usu1.id_usuario = ivt.id_usuario_reg
                        left join orga.vfuncionario fun on fun.id_funcionario = ivt.id_funcionario
                        left join param.tdepto dep on dep.id_depto = ivt.id_depto --#5
						left join segu.tusuario usu2 on usu2.id_usuario = ivt.id_usuario_mod
                        
                        left join anio an on an.id_invitacion = ivt.id_invitacion
                        left JOIN param.tgestion ges on ges.gestion = an.anio
                        left join adq.tcategoria_compra cat on cat.id_categoria_compra = ivt.id_categoria_compra
                        left JOIN adq.tgrupo gru	on gru.id_grupo = ivt.id_grupo

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
          /*********************************    
          #TRANSACCION:  'PRO_IVTADQ_SEL'
          #DESCRIPCION:	 lista combo de solicitudes de compra para regularizacion
          #AUTOR:		eddy.gutierrez	
          #FECHA:		25/01/2019
          #ISSUE:      #7
          ***********************************/

          elsif(p_transaccion='PRO_IVTADQ_SEL')then
           				
              begin
                  --Sentencia de la consulta
                  v_consulta:=' 
                  WITH solicitud_det(
                        id_solicitud,
                        cantidad_detalle_sol
                        )as(
                        
                        SELECT
                            sol.id_solicitud,
                            count(sold.id_solicitud_det)
                        FROM  adq.tsolicitud_det sold
                        LEFT JOIN adq.tsolicitud sol on sol.id_solicitud =sold.id_solicitud
                        where sold.estado_reg = ''activo''
                        group by sol.id_solicitud
                        ),
                   invitacion_det(
                        id_solicitud,
                        cantidad_detalle_inv
                        )as(
                        
                        SELECT
                            inv.id_solicitud,
                            count(invd.id_invitacion_det)
                        FROM  pro.tinvitacion_det invd
                        LEFT JOIN pro.tinvitacion inv on inv.id_invitacion =invd.id_invitacion
                        group by inv.id_solicitud
                        ) 
                  SELECT
                      sol.id_estado_wf,
                      sol.id_solicitud,
                      sol.fecha_soli,
                      tp.id_tipo_estado,
                      sol.num_tramite,
                      tp.codigo as codigo_estado,
                      COALESCE(sod.cantidad_detalle_sol,0)::integer as cantidad_detalle_sol,
                      COALESCE(ind.cantidad_detalle_inv,0)::integer as cantidad_detalle_inv ,
                      sol.id_moneda,
                      mon.codigo as codigo_moneda
                  FROM adq.tsolicitud sol
                  left join wf.testado_wf eswf on eswf.id_estado_wf = sol.id_estado_wf
                  left join wf.ttipo_estado tp on tp.id_tipo_estado = eswf.id_tipo_estado
                  left join solicitud_det sod on sod.id_solicitud   = sol.id_solicitud
                  left join invitacion_det ind on ind.id_solicitud = sol.id_solicitud 
                  left join param.tmoneda mon on mon.id_moneda = sol.id_moneda 
                  WHERE COALESCE(ind.cantidad_detalle_inv,0)<>COALESCE(sod.cantidad_detalle_sol,0) and sol.estado_reg = ''activo'' and tp.codigo not in (''borrador'',''anulado'',''desierto'') and ';
      			
                  --Definicion de la respuesta
            
                  v_consulta:=v_consulta||v_parametros.filtro;
                  v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
                   
                  --Devuelve la respuesta
                  return v_consulta;
      						
              end;

          /*********************************    
          #TRANSACCION:  'PRO_IVTADQ_CONT'
          #DESCRIPCION:	conteo combo de solicitudes de compra para regularizacion
          #AUTOR:		eddy.gutierrez	
          #FECHA:		25/01/2019
          #ISSUE:      #7
          ***********************************/

          elsif(p_transaccion='PRO_IVTADQ_CONT')then

              begin
                  --Sentencia de la consulta de conteo de registros
                  v_consulta:='
                                 WITH solicitud_det(
                                      id_solicitud,
                                      cantidad_detalle_sol
                                      )as(
                                      
                                      SELECT
                                          sol.id_solicitud,
                                          count(sold.id_solicitud_det)
                                      FROM  adq.tsolicitud_det sold
                                      LEFT JOIN adq.tsolicitud sol on sol.id_solicitud =sold.id_solicitud
                                      where sold.estado_reg = ''activo''
                                      group by sol.id_solicitud
                                      ),
                                 invitacion_det(
                                      id_solicitud,
                                      cantidad_detalle_inv
                                      )as(
                                      
                                      SELECT
                                          inv.id_solicitud,
                                          count(invd.id_invitacion_det)
                                      FROM  pro.tinvitacion_det invd
                                      LEFT JOIN pro.tinvitacion inv on inv.id_invitacion =invd.id_invitacion
                                      group by inv.id_solicitud
                                      ) 
                                SELECT
                                   count(sol.id_solicitud)
                                FROM adq.tsolicitud sol
                                left join wf.testado_wf eswf on eswf.id_estado_wf = sol.id_estado_wf
                                left join wf.ttipo_estado tp on tp.id_tipo_estado = eswf.id_tipo_estado
                                left join pro.tinvitacion inv on inv.id_solicitud = sol.id_solicitud
                                left join solicitud_det sod on sod.id_solicitud   = sol.id_solicitud
                                left join invitacion_det ind on ind.id_solicitud = sol.id_solicitud
                                left join param.tmoneda mon on mon.id_moneda = sol.id_moneda  
                                WHERE  COALESCE(ind.cantidad_detalle_inv,0)<>COALESCE(sod.cantidad_detalle_sol,0) and sol.estado_reg = ''activo'' and tp.codigo not in (''borrador'',''anulado'',''desierto'')and ';
      			
                  --Definicion de la respuesta	
                  
                  v_consulta:=v_consulta||v_parametros.filtro;

                  --Devuelve la respuesta
                  return v_consulta;

              end;
                /*********************************    
          #TRANSACCION:  'PRO_INDADQ_SEL'
          #DESCRIPCION:	 lista un combo con el detalle de las una solicitud de compra 
          #AUTOR:		eddy.gutierrez	
          #FECHA:		25/01/2019
          #ISSUE:      #7
          ***********************************/

          elsif(p_transaccion='PRO_INDADQ_SEL')then
           				
              begin
                  --Sentencia de la consulta
                  v_consulta:=' 
                      SELECT
                          ROW_NUMBER () OVER (ORDER BY  sold.id_solicitud_det)::integer as id,
                          sold.id_solicitud_det,
                          sold.id_solicitud,
                          sold.id_concepto_ingas,
                          coinga.desc_ingas,
                          sold.cantidad,
                          sold.precio_unitario,
                          sold.precio_total,
                          sold.id_centro_costo,
                          sold.descripcion,
                          mon.codigo as codigo_moneda,
                      CASE
                      WHEN sol.id_moneda =  param.f_get_moneda_base() THEN
                           (sold.precio_total/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),sol.fecha_soli::DATE,''O'')):: numeric)):: numeric(18,2)
                      WHEN sol.id_moneda =  param.f_get_moneda_triangulacion() THEN
                           (sold.precio_total*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),sol.fecha_soli::DATE,''O'')):: numeric)):: numeric(18,2)   
                      END as precio_total_conversion,
                      case
                       WHEN sol.id_moneda =  param.f_get_moneda_base() THEN
                        (SELECT mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_triangulacion())::varchar
                      WHEN sol.id_moneda =  param.f_get_moneda_triangulacion() THEN
                       (SELECT  mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_base())::varchar
                      END as codigo_moneda_total_conversion    
                      FROM  adq.tsolicitud_det sold
                      left JOIN param.tconcepto_ingas coinga on coinga.id_concepto_ingas = sold.id_concepto_ingas
                      left join pro.tinvitacion_det invd on invd.id_solicitud_det =  sold.id_solicitud_det
                      left join adq.tsolicitud sol on sol.id_solicitud = sold.id_solicitud
                      left join param.tmoneda mon on mon.id_moneda = sol.id_moneda 
                      where invd.id_solicitud_det is null and sold.estado_reg = ''activo'' and';
      			
                  --Definicion de la respuesta
            
                  v_consulta:=v_consulta||v_parametros.filtro;
                  v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
                   
                  --Devuelve la respuesta
                  return v_consulta;
      						
              end;

          /*********************************    
          #TRANSACCION:  'PRO_INDADQ_CONT'
          #DESCRIPCION:	conteo un combo con el detalle de una solicitud de compra 
          #AUTOR:		eddy.gutierrez	
          #FECHA:		25/01/2019
          #ISSUE:      #7
          ***********************************/

          elsif(p_transaccion='PRO_INDADQ_CONT')then

              begin
                  --Sentencia de la consulta de conteo de registros
                  v_consulta:='     
                                    SELECT
                                     count(sold.id_solicitud_det)
                                    FROM  adq.tsolicitud_det sold
                                    left JOIN param.tconcepto_ingas coinga on coinga.id_concepto_ingas = sold.id_concepto_ingas
                                    left join pro.tinvitacion_det invd on invd.id_solicitud_det =  sold.id_solicitud_det
                                    left join adq.tsolicitud sol on sol.id_solicitud = sold.id_solicitud
                                    left join param.tmoneda mon on mon.id_moneda = sol.id_moneda 
                                WHERE invd.id_solicitud_det is null and sold.estado_reg = ''activo'' and ';
      			
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