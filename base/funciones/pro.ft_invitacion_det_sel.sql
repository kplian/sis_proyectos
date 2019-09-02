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
 #0				22-08-2018 22:32:59							Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tinvitacion_det'	
 #15 ETR            31/07/2019          EGS                 se agrego campos id_solicitud_det, id_invitacion_det_fk y estado_lanz               
 #20                30/08/2019          EGS                 Se agrega el campo id_componente_concepto_ingas_det y la cantidad de adjudicacion
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
    		--#20 Sentencia de la consulta
			v_consulta:='
                    with cotizacion_det(
                          id_solicitud_det,
                          cantidad_adju
                     )AS(
                          SELECT
                              cotd.id_solicitud_det,
                              sum(COALESCE(cotd.cantidad_adju,0))
                          FROM adq.tcotizacion_det cotd
                          GROUP BY cotd.id_solicitud_det

                     )
                    select
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
                        cigg.tipo || '' – '' || cigg.desc_ingas as desc_ingas,
                        facoing.cantidad_est as cantidad_est,
                        facoing.precio as precio_est,
                        ivtd.id_centro_costo,
                        ivtd.descripcion,
                        cec.codigo_cc::varchar,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        ivtd.id_unidad_constructiva,
                        uc.codigo as codigo_uc,
                        ivtd.id_invitacion_det_fk,--#15
                        ivtd.estado_lanz,--#15
                        ivtd.id_solicitud_det, --#15
                        ivtd.id_componente_concepto_ingas_det,--#20
                        cigd.nombre as desc_ingas_det, --#20
                        cotd.cantidad_adju --#20
						from pro.tinvitacion_det ivtd
						inner join segu.tusuario usu1 on usu1.id_usuario = ivtd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ivtd.id_usuario_mod
                        left join pro.tfase_concepto_ingas facoing on facoing.id_fase_concepto_ingas=ivtd.id_fase_concepto_ingas
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
                        left join param.tconcepto_ingas cigg on cigg.id_concepto_ingas = ivtd.id_concepto_ingas
                        left join param.tunidad_medida um on um.id_unidad_medida = ivtd.id_unidad_medida
                        left join pro.tfase fas on fas.id_fase = ivtd.id_fase
                        left join param.vcentro_costo cec on cec.id_centro_costo = ivtd.id_centro_costo
                        left join pro.tunidad_constructiva uc on uc.id_unidad_constructiva = ivtd.id_unidad_constructiva
				        left join pro.tcomponente_concepto_ingas_det comcdet on comcdet.id_componente_concepto_ingas_det = ivtd.id_componente_concepto_ingas_det --#20
                        left join param.tconcepto_ingas_det cigd on cigd.id_concepto_ingas_det = comcdet.id_concepto_ingas_det --#20
                        left join cotizacion_det cotd on cotd.id_solicitud_det = ivtd.id_solicitud_det  --#20
                        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
            raise notice 'v_consulta %',v_consulta;
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
			----#20 Sentencia de la consulta de conteo de registros
			v_consulta:='
                        with cotizacion_det(
                          id_solicitud_det,
                          cantidad_adju
                     )AS(
                          SELECT
                              cotd.id_solicitud_det,
                              sum(COALESCE(cotd.cantidad_adju,0))
                          FROM adq.tcotizacion_det cotd
                          GROUP BY cotd.id_solicitud_det

                     )
                    select count(ivtd.id_invitacion_det)
					    from pro.tinvitacion_det ivtd
					    inner join segu.tusuario usu1 on usu1.id_usuario = ivtd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ivtd.id_usuario_mod
					   	left join pro.tfase_concepto_ingas facoing on facoing.id_fase_concepto_ingas=ivtd.id_fase_concepto_ingas
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
                        left join param.tunidad_medida um on um.id_unidad_medida = ivtd.id_unidad_medida
                        left join pro.tfase fas on fas.id_fase = facoing.id_fase
                        left join cotizacion_det cotd on cotd.id_solicitud_det = ivtd.id_solicitud_det --#20
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