CREATE OR REPLACE FUNCTION pro.ft_proyecto_activo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_activo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_activo'
 AUTOR: 		 (admin)
 FECHA:	        31-08-2017 16:52:19
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
	v_columnas 			varchar;
	v_rec 				record;
	v_valores			varchar;
			    
BEGIN

	v_nombre_funcion = 'pro.ft_proyecto_activo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_PRAF_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin	
 	#FECHA:		31-08-2017 16:52:19
	***********************************/

	if(p_transaccion='PRO_PRAF_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						praf.id_proyecto_activo,
						praf.id_proyecto,
						praf.observaciones,
						praf.estado_reg,
						praf.denominacion,
						praf.descripcion,
						praf.id_clasificacion,
						praf.id_usuario_reg,
						praf.fecha_reg,
						praf.usuario_ai,
						praf.id_usuario_ai,
						praf.fecha_mod,
						praf.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						cla.codigo || ''-''||cla.nombre as desc_clasificacion
						from pro.tproyecto_activo praf
						inner join segu.tusuario usu1 on usu1.id_usuario = praf.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = praf.id_usuario_mod
						left join kaf.tclasificacion cla on cla.id_clasificacion = praf.id_clasificacion
				        where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_PRAF_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin	
 	#FECHA:		31-08-2017 16:52:19
	***********************************/

	elsif(p_transaccion='PRO_PRAF_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_proyecto_activo)
					    from pro.tproyecto_activo praf
					    inner join segu.tusuario usu1 on usu1.id_usuario = praf.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = praf.id_usuario_mod
						left join kaf.tclasificacion cla on cla.id_clasificacion = praf.id_clasificacion
					    where ';
			
			--Definicion de la respuesta		    
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;


	/*********************************    
 	#TRANSACCION:  'PRO_PRAFTAB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			RCM
 	#FECHA:			02/10/2017
	***********************************/

	elsif(p_transaccion='PRO_PRAFTAB_SEL')then
     				
    	begin

    		--Crear las columnas del proyecto
    		v_columnas = 'create temp table tt_proyecto_cc (
    			id_proyecto integer,
    			id_proyecto_activo integer,
    			id_clasificacion integer,
    			denominacion varchar(500),
    			descripcion varchar(5000),
    			observaciones varchar(5000),
    			desc_clasificacion text,
    			costo numeric
    			';

    		for v_rec in select
						cc.id_centro_costo, cc.id_gestion, cc.codigo_uo, cc.nombre_uo, cc.gestion,
						cc.codigo_cc, cc.nombre_proyecto, cc.codigo_tcc, cc.descripcion_tcc,
						cc.fecha_inicio, cc.fecha_final, ppa.id_proyecto, cc.id_tipo_cc
						from param.vcentro_costo cc
						inner join param.tep ep
						on ep.id_ep = cc.id_ep
						inner join param.tprograma_proyecto_acttividad ppa
						on ppa.id_prog_pory_acti = ep.id_prog_pory_acti
						where ppa.id_proyecto = v_parametros.id_proyecto_ep
						order by cc.id_tipo_cc loop

                v_columnas = v_columnas || ', cc_'||v_rec.id_tipo_cc::varchar || ' numeric(18,2)';

            end loop;

            v_columnas = v_columnas || ') on commit drop';


            --Creación de la tabla temporal
            execute(v_columnas);

            --Inserta los registos de Proyecto Activo, sin los importes
            insert into tt_proyecto_cc (
            	id_proyecto,
            	id_proyecto_activo,
    			id_clasificacion,
    			denominacion,
    			descripcion,
    			observaciones,
    			desc_clasificacion
    		)
    		select
    		pa.id_proyecto, pa.id_proyecto_activo, pa.id_clasificacion, pa.denominacion, pa.descripcion, pa.observaciones,
    		cla.codigo||'-'||cla.nombre
    		from pro.tproyecto_activo pa
    		left join kaf.tclasificacion cla
    		on cla.id_clasificacion = pa.id_clasificacion
    		where pa.id_proyecto = v_parametros.id_proyecto;

    		--Update para el costo total del activo
    		update tt_proyecto_cc set
    		costo = (select sum(a.monto)
					from pro.tproyecto_activo_detalle a
					where a.id_proyecto_activo = tt_proyecto_cc.id_proyecto_activo);


    		--Updates para los montos por proyecto activo y centro de costo
    		for v_rec in select
						pad.id_proyecto_activo, pad.id_tipo_cc, sum(pad.monto) as monto
						from pro.tproyecto_activo_detalle pad
						inner join pro.tproyecto_activo pac
						on pac.id_proyecto_activo = pad.id_proyecto_activo
						where pac.id_proyecto = v_parametros.id_proyecto
                        group by pad.id_proyecto_activo, pad.id_tipo_cc loop

				v_consulta = 'update tt_proyecto_cc set cc_'||v_rec.id_tipo_cc::varchar||' = '||v_rec.monto||'
							where id_proyecto_activo ='||v_rec.id_proyecto_activo;
				execute(v_consulta);

			end loop;

    		--Obtención del detalle de Proyecto Activo
			v_consulta:='select
						*
						from tt_proyecto_cc
						where ';
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_PRAFTAB_CONT'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			RCM
 	#FECHA:			03/10/2017
	***********************************/

	elsif(p_transaccion='PRO_PRAFTAB_CONT')then
     				
    	begin

    		--Crear las columnas del proyecto
    		v_columnas = 'create temp table tt_proyecto_cc (
    			id_proyecto integer,
    			id_proyecto_activo integer,
    			id_clasificacion integer,
    			denominacion varchar(500),
    			descripcion varchar(5000),
    			observaciones varchar(5000),
    			desc_clasificacion text
    			';

    		for v_rec in select
						cc.id_centro_costo, cc.id_gestion, cc.codigo_uo, cc.nombre_uo, cc.gestion,
						cc.codigo_cc, cc.nombre_proyecto, cc.codigo_tcc, cc.descripcion_tcc,
						cc.fecha_inicio, cc.fecha_final, ppa.id_proyecto, cc.id_tipo_cc
						from param.vcentro_costo cc
						inner join param.tep ep
						on ep.id_ep = cc.id_ep
						inner join param.tprograma_proyecto_acttividad ppa
						on ppa.id_prog_pory_acti = ep.id_prog_pory_acti
						where ppa.id_proyecto = v_parametros.id_proyecto_ep
						order by cc.id_tipo_cc loop

                v_columnas = v_columnas || ', cc_'||v_rec.id_tipo_cc::varchar || ' numeric(18,2)';

            end loop;

            v_columnas = v_columnas || ') on commit drop;';

            --Creación de la tabla temporal
            execute(v_columnas);

            --Inserta los registos de Proyecto Activo, sin los importes
            insert into tt_proyecto_cc (
            	id_proyecto,
            	id_proyecto_activo,
    			id_clasificacion,
    			denominacion,
    			descripcion,
    			observaciones,
    			desc_clasificacion
    		)
    		select
    		pa.id_proyecto, pa.id_proyecto_activo, pa.id_clasificacion, pa.denominacion, pa.descripcion, pa.observaciones,
    		cla.codigo||'-'||cla.nombre
    		from pro.tproyecto_activo pa
    		left join kaf.tclasificacion cla
    		on cla.id_clasificacion = pa.id_clasificacion
    		where pa.id_proyecto = v_parametros.id_proyecto;

    		--Updates para los montos por proyecto activo y centro de costo
    		for v_rec in select
						pad.id_proyecto_activo, pad.id_tipo_cc, sum(pad.monto) as monto
						from pro.tproyecto_activo_detalle pad
						inner join pro.tproyecto_activo pac
						on pac.id_proyecto_activo = pad.id_proyecto_activo
						where pac.id_proyecto = v_parametros.id_proyecto
						group by pad.id_proyecto_activo, pad.id_tipo_cc loop

				v_consulta = 'update tt_proyecto_cc set cc_'||v_rec.id_tipo_cc::varchar||' = '||v_rec.monto||'
							where id_proyecto_activo ='||v_rec.id_proyecto_activo;
				execute(v_consulta);

			end loop;

    		--Obtención del detalle de Proyecto Activo
			v_consulta:='select count(1) as total
						from tt_proyecto_cc
						where ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_PRAFTOT_SEL'
 	#DESCRIPCION:	Devuelve el total de los CC por proyecto, lo utilizado y el saldo
 	#AUTOR:			RCM
 	#FECHA:			02/10/2017
	***********************************/

	elsif(p_transaccion='PRO_PRAFTOT_SEL')then
     				
    	begin

    		------------------------------------
    		--Crear las columnas del proyecto
    		------------------------------------
    		v_columnas = 'create temp table tt_proyecto_cc_tot (
    			id_proyecto_activo integer,
    			total numeric
    			';

    		for v_rec in select
						cc.id_centro_costo, cc.id_gestion, cc.codigo_uo, cc.nombre_uo, cc.gestion,
						cc.codigo_cc, cc.nombre_proyecto, cc.codigo_tcc, cc.descripcion_tcc,
						cc.fecha_inicio, cc.fecha_final, ppa.id_proyecto, cc.id_tipo_cc
						from param.vcentro_costo cc
						inner join param.tep ep
						on ep.id_ep = cc.id_ep
						inner join param.tprograma_proyecto_acttividad ppa
						on ppa.id_prog_pory_acti = ep.id_prog_pory_acti
						where ppa.id_proyecto = v_parametros.id_proyecto_ep
						order by cc.id_tipo_cc loop

                v_columnas = v_columnas || ', cc_'||v_rec.id_tipo_cc::varchar || ' numeric(18,2) default 0';

            end loop;

            v_columnas = v_columnas || ') on commit drop;';


            --Creación de la tabla temporal
            execute(v_columnas);

    		-------------------------------------
    		--(1)Inserción de los totales por CC
    		-------------------------------------
    		v_consulta = 'insert into tt_proyecto_cc_tot(id_proyecto_activo';
    		v_valores = '(-1';
    		for v_rec in select
						tcc.id_tipo_cc, sum(ran.debe_mb) as total
						from conta.trango ran
						inner join param.ttipo_cc tcc
						on tcc.id_tipo_cc = ran.id_tipo_cc
						inner join param.tcentro_costo cc
						on cc.id_tipo_cc = tcc.id_tipo_cc
						inner join param.tep ep
						on ep.id_ep = cc.id_ep
						inner join param.tprograma_proyecto_acttividad ppa
						on ppa.id_prog_pory_acti = ep.id_prog_pory_acti
						where ppa.id_proyecto = v_parametros.id_proyecto_ep
						group by tcc.id_tipo_cc
						order by tcc.id_tipo_cc loop

				v_consulta = v_consulta || ',cc_'||v_rec.id_tipo_cc::varchar;
				v_valores = v_valores || ','||v_rec.total;

			end loop;

			--Completa el sql y ejecuta la instrucción
			v_consulta = v_consulta || ') values '||v_valores||')';
			execute(v_consulta);

			--Update al total consolidado CC
			update tt_proyecto_cc_tot set
			total = (select
						sum(ran.debe_mb) - sum(ran.haber_mb) as total
						from conta.trango ran
						inner join param.ttipo_cc tcc
						on tcc.id_tipo_cc = ran.id_tipo_cc
						inner join param.tcentro_costo cc
						on cc.id_tipo_cc = tcc.id_tipo_cc
						inner join param.tep ep
						on ep.id_ep = cc.id_ep
						inner join param.tprograma_proyecto_acttividad ppa
						on ppa.id_prog_pory_acti = ep.id_prog_pory_acti
						where ppa.id_proyecto = v_parametros.id_proyecto_ep)
			where id_proyecto_activo = -1;

			-------------------------------------
    		--(2)Inserción de lo utilizado por CC
    		-------------------------------------
    		v_consulta = 'insert into tt_proyecto_cc_tot(id_proyecto_activo';
    		v_valores = '(-2';
    		for v_rec in select
						pad.id_tipo_cc, sum(pad.monto) as total
						from pro.tproyecto_activo paf
						inner join pro.tproyecto_activo_detalle pad
						on pad.id_proyecto_activo = paf.id_proyecto_activo
						where paf.id_proyecto = v_parametros.id_proyecto
						group by pad.id_tipo_cc
						order by pad.id_tipo_cc loop

				v_consulta = v_consulta || ',cc_'||v_rec.id_tipo_cc::varchar;
				v_valores = v_valores || ','||v_rec.total;

			end loop;

			--Completa el sql y ejecuta la instrucción
			v_consulta = v_consulta || ') values '||v_valores||')';
			execute(v_consulta);

			--Update al total utilizado consolidado CC
			update tt_proyecto_cc_tot set
			total = (select
					sum(pad.monto) as total
					from pro.tproyecto_activo paf
					inner join pro.tproyecto_activo_detalle pad
					on pad.id_proyecto_activo = paf.id_proyecto_activo
					where paf.id_proyecto = v_parametros.id_proyecto)
			where id_proyecto_activo = -2;


    		--Obtención del detalle de Proyecto Activo
			v_consulta:='select
						*
						from tt_proyecto_cc_tot';
						--where ';
			--Definicion de la respuesta
			--v_consulta:=v_consulta||v_parametros.filtro;
			--v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

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