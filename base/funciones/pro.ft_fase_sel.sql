CREATE OR REPLACE FUNCTION pro.ft_fase_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase'
 AUTOR: 		 (admin)
 FECHA:	        25-10-2017 13:16:54
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				24-05-2018 19:13:39								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tfase_concepto_ingas'	
 #5 endeEtr         09/01/2019          EGS                     se aumento el precio total de las sumas de los items en la fase 
	
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
	v_where				varchar;
	v_filtro			varchar;
    
    v_where2				varchar;
			    
BEGIN

	v_nombre_funcion = 'pro.ft_fase_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	if(p_transaccion='PRO_FASE_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='
                 
                    select
						fase.id_fase,
						fase.id_proyecto,
						fase.id_fase_fk,
						fase.codigo,
						fase.nombre,
						fase.descripcion,
						fase.observaciones,
						fase.fecha_ini,
						fase.fecha_fin,
						fase.estado,
						fase.estado_reg,
						fase.id_usuario_reg,
						fase.usuario_ai,
						fase.fecha_reg,
						fase.id_usuario_ai,
						fase.id_usuario_mod,
						fase.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from pro.tfase fase
						inner join segu.tusuario usu1 on usu1.id_usuario = fase.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fase.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	elsif(p_transaccion='PRO_FASE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_fase)
					    from pro.tfase fase
					    inner join segu.tusuario usu1 on usu1.id_usuario = fase.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fase.id_usuario_mod
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************   
     #TRANSACCION:  'PRO_FASEARB_SEL'
     #DESCRIPCION:  Consulta fases por proyecto de tipo árbol
     #AUTOR:        EGS
     #FECHA:        
    ***********************************/

    elseif(p_transaccion='PRO_FASEARB_SEL')then
                    
        begin
			
			if(coalesce(v_parametros.node,'id') = 'id') then
				v_where = ' fase.id_fase_fk is null ';
                v_where2 = ' facoing.id_fase_concepto_ingas is null ';  
			
            else
            	v_where = ' fase.id_fase_fk = '||v_parametros.node;
            	v_where2 = ' facoing.id_fase = '||v_parametros.node;
			end if;
          
            
           -- raise notice 'EP: %',v_parametros.id_ep;

			v_filtro = ' 0=0 ';
              
            --Consulta
            --se hizo un with para la suma de los precios de los items por fase
            v_consulta:='
              WITH item_fase(
                                id_fase,
                                precio_item
                        )AS(
                            SELECT
                                fas.id_fase,
                                sum(fasco.precio)
                            From pro.tfase_concepto_ingas fasco
                            left join pro.tfase fas on fas.id_fase = fasco.id_fase
                            GROUP by
                            fas.id_fase                      
                        )
                        select					
            			null::integer as id_fase_concepto_ingas,
                        fase.id_fase,
						fase.id_proyecto,
						fase.id_fase_fk,
						fase.descripcion,
						fase.estado_reg,
						fase.fecha_ini,
						fase.nombre,
						fase.codigo,
						fase.estado,
						fase.fecha_fin,
						fase.observaciones,
						fase.id_usuario_reg,
						fase.usuario_ai,
						fase.fecha_reg,
						fase.id_usuario_ai,
						fase.id_usuario_mod,
						fase.fecha_mod,
                        fase.id_proceso_wf,
                        fase.id_estado_wf,
                        fase.nro_tramite,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						case
						when coalesce(fase.id_fase_fk,0) = 0 then ''raiz''::varchar
							else ''hijo''::varchar
						end as tipo_nodo,
                        fase.fecha_ini_real,
                        fase.fecha_fin_real,
                        infa.precio_item::numeric ---#5  	
						from pro.tfase fase
						inner join segu.tusuario usu1 on usu1.id_usuario = fase.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = fase.id_usuario_mod
                        left join item_fase infa on infa.id_fase = fase.id_fase
                       where  '||v_where|| ' and ' || v_parametros.filtro || ' and '||v_filtro;
                        
            raise notice '%',v_consulta;
           
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
