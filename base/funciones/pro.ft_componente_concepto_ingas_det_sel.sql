--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_componente_concepto_ingas_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_componente_concepto_ingas_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcomp_concepto_ingas_det'
 AUTOR: 		 (admin)
 FECHA:	        22-07-2019 14:50:29
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #17				22-07-2019 14:50:29	EGS					Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tcomp_concepto_ingas_det'
#21 EndeEtr         30/08/2019          EGS                 Se adiciona el id del proyecto al PRO_COMINDET_SEL a la consulta
#25 EndeEtr         10/09/2019          EGS                 Adicion de cmp precio montaje, precio obci y precio pruebas
#26 EndeEtr         12/09/2019          EGS                 Lista la unidad Constructiva del componente macro
#34  EndeEtr          03/10/2019        EGS                 Se aumentaron  totalizdores
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'pro.ft_componente_concepto_ingas_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_COMINDET_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		22-07-2019 14:50:29
	***********************************/

	if(p_transaccion='PRO_COMINDET_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                        comindet.id_componente_concepto_ingas_det,
                        comindet.estado_reg,
                        comindet.id_concepto_ingas_det,
                        comindet.id_componente_concepto_ingas,
                        comindet.cantidad_est,
                        comindet.precio,
                        comindet.id_usuario_reg,
                        comindet.fecha_reg,
                        comindet.id_usuario_ai,
                        comindet.usuario_ai,
                        comindet.id_usuario_mod,
                        comindet.fecha_mod,
                        usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        cigd.nombre as desc_ingas_det,
                        cm.id_unidad_constructiva as id_unidad_constructiva_macro,--26
                        uc.codigo as codigo_uc,
                        cigdfk.nombre as desc_agrupador,
                        comindet.aislacion,
                        comindet.tension,
                        comindet.peso,
                        cm.id_proyecto,--#21
                        cci.id_concepto_ingas, --#21
                        comindet.precio_montaje,  --#25
                        comindet.precio_obra_civil,--#25
                        comindet.precio_prueba, --#25
                        comindet.f_desadeanizacion,--#27
                        comindet.f_seguridad,--#27
                        comindet.f_escala_xfd_montaje,--#27
                        comindet.f_escala_xfd_obra_civil,--#27
                        cm.porc_prueba,
                        comindet.tipo_configuracion,
                        comindet.conductor,
                        comindet.id_unidad_medida,
                        um.codigo as desc_unidad,
                        (COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0))::numeric as precio_total_det --#34
						from pro.tcomponente_concepto_ingas_det comindet
						inner join segu.tusuario usu1 on usu1.id_usuario = comindet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = comindet.id_usuario_mod
                        left join param.tconcepto_ingas_det cigd on cigd.id_concepto_ingas_det = comindet.id_concepto_ingas_det
                        left join param.tconcepto_ingas_det cigdfk on cigdfk.id_concepto_ingas_det = cigd.id_concepto_ingas_det_fk
				        left join pro.tunidad_constructiva uc on uc.id_unidad_constructiva = comindet.id_unidad_constructiva
                        left join pro.tcomponente_concepto_ingas cci on cci.id_componente_concepto_ingas = comindet.id_componente_concepto_ingas  --#21
                        left join pro.tcomponente_macro cm on cm.id_componente_macro = cci.id_componente_macro  --#21
                        left join param.tunidad_medida um on um.id_unidad_medida = comindet.id_unidad_medida
                        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice 'v_consulta %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COMINDET_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		22-07-2019 14:50:29
	***********************************/

	elsif(p_transaccion='PRO_COMINDET_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select
                                count(comindet.id_componente_concepto_ingas_det),
                                sum(COALESCE(comindet.precio, 0) * COALESCE(comindet.cantidad_est,0))::numeric as total_precio_det	 --#34
                        from pro.tcomponente_concepto_ingas_det comindet
					    inner join segu.tusuario usu1 on usu1.id_usuario = comindet.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = comindet.id_usuario_mod
                        left join param.tconcepto_ingas_det cigd on cigd.id_concepto_ingas_det = comindet.id_concepto_ingas_det
                        left join pro.tunidad_constructiva uc on uc.id_unidad_constructiva = comindet.id_unidad_constructiva
					    left join pro.tcomponente_concepto_ingas cci on cci.id_componente_concepto_ingas = comindet.id_componente_concepto_ingas --#21
                        left join pro.tcomponente_macro cm on cm.id_componente_macro = cci.id_componente_macro --#21
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