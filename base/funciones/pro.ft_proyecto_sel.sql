CREATE OR REPLACE FUNCTION pro.ft_proyecto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto'
 AUTOR: 		 (admin)
 FECHA:	        28-09-2017 20:12:15
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

	v_nombre_funcion = 'pro.ft_proyecto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_PROY_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		28-09-2017 20:12:15
	***********************************/

	if(p_transaccion='PRO_PROY_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						proy.id_proyecto,
						proy.codigo,
						proy.nombre,
						proy.fecha_ini,
						proy.fecha_fin,
						proy.id_tipo_cc,
						proy.estado_reg,
						proy.usuario_ai,
						proy.fecha_reg,
						proy.id_usuario_reg,
						proy.id_usuario_ai,
						proy.id_usuario_mod,
						proy.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						tcc.codigo as codigo_tcc,
						tcc.descripcion as desc_tcc,
						proy.id_moneda,
						mon.codigo as desc_moneda,
						proy.id_depto_conta,
						dep.codigo as desc_depto,
						proy.id_int_comprobante_1,
						proy.id_int_comprobante_2,
						proy.id_int_comprobante_3,
						proy.id_proceso_wf_cierre,
						proy.id_estado_wf_cierre,
						proy.nro_tramite_cierre,
						proy.estado_cierre,
						proy.id_proceso_wf,
						proy.id_estado_wf,
						proy.nro_tramite,
						proy.estado,
                        proy.fecha_ini_real,
						proy.fecha_fin_real
						from pro.tproyecto proy
						inner join segu.tusuario usu1 on usu1.id_usuario = proy.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = proy.id_usuario_mod
						inner join param.vtipo_cc tcc on tcc.id_tipo_cc = proy.id_tipo_cc
						inner join param.tmoneda mon on mon.id_moneda = proy.id_moneda
						left join param.tdepto dep on dep.id_depto = proy.id_depto_conta
				        where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
raise notice 'ff: %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PROY_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		28-09-2017 20:12:15
	***********************************/

	elsif(p_transaccion='PRO_PROY_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(proy.id_proyecto)
					    from pro.tproyecto proy
					    inner join segu.tusuario usu1 on usu1.id_usuario = proy.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = proy.id_usuario_mod
						inner join param.vtipo_cc tcc on tcc.id_tipo_cc = proy.id_tipo_cc
						inner join param.tmoneda mon on mon.id_moneda = proy.id_moneda
						left join param.tdepto dep on dep.id_depto = proy.id_depto_conta
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PROY_TIPOCC_SEL'
 	#DESCRIPCION:	Devuelve datos del Tipo de centro de costo del proyecto
 	#AUTOR:			RCM
 	#FECHA:			14/08/2018
	***********************************/

	elsif(p_transaccion='PRO_PROY_TIPOCC_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						pro.id_proyecto,
						pro.id_tipo_cc,
						cc.codigo,
						cc.descripcion
						from pro.tproyecto pro
						inner join param.ttipo_cc cc
						on cc.id_tipo_cc = pro.id_tipo_cc
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
