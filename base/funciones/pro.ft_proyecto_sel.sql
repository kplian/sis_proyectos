--------------- SQL ---------------

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
	Issue 			      Fecha 			    Autor				Descripcion
 	  #3  		        31/12/2018		  EGS					Aumentar Importe Stea
    #10  EndeEtr    02/04/2019      EGS         se agrega totalizadores de la suma de faseconceptoingas y de las invitaciones
    #56             10/03/2020      EGS         Se agrega los campos justificacion, id_lugar ,caracteristica_tecnica
    #60  EndeEtr    27/07/2020      RCM         Adición de fecha de reversión de AITB para cierre de proyectos
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
            --#10  se agrega totalizadores de la suma de faseconceptoingas y de las invitaciones por proyecto
            v_consulta:='
                  WITH total_facoing(   id_proyecto,
                            total_fase_concepto_ingas
                           )as(
                        SELECT
                            fase.id_proyecto,
                            sum(COALESCE(facoing.precio,0))
                        FROM pro.tfase_concepto_ingas facoing
                        LEFT join pro.tfase fase on fase.id_fase = facoing.id_fase
                        GROUP BY fase.id_proyecto
                    ),
                    convertion(
                      id_proyecto,
                      id_moneda_proyecto,
                      id_invitacion,
                      id_moneda_invitacion,
                      precio,
                      cantidad_sol,
                      precio_total_conversion,
                      codigo_moneda_total_conversion
                      )AS(
                         SELECT
                                      inv.id_proyecto,
                                      pro.id_moneda,
                                      inv.id_invitacion,
                                      inv.id_moneda,
                                      invd.precio,
                                      invd.cantidad_sol,

                                     CASE
                                      WHEN pro.id_moneda = inv.id_moneda  THEN
                                           invd.precio*invd.cantidad_sol
                                      WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                                           ((invd.precio*invd.cantidad_sol)*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,''O'')):: numeric)):: numeric(18,2)
                                      WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                                           ((invd.precio*invd.cantidad_sol)/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,''O'')):: numeric)):: numeric(18,2)
                                      END as precio_total_conversion,
                                      case
                                       WHEN pro.id_moneda = inv.id_moneda  THEN
                                          mon.codigo
                                       WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                                        (SELECT mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda =param.f_get_moneda_base())::varchar
                                      WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                                       (SELECT  mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_triangulacion())::varchar
                                      END as codigo_moneda_total_conversion

                                  FROM pro.tinvitacion_det invd
                                  left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                                  left join pro.tproyecto pro on pro.id_proyecto = inv.id_proyecto
                                  left join param.tmoneda mon on mon.id_moneda = pro.id_moneda ),
                      total_invitacion(
                                id_proyecto,
                                total_invitacion
                      )as(
                        SELECT
                          co.id_proyecto,
                          sum(precio_total_conversion)
                      FROM convertion co
                      group by co.id_proyecto
                      )
                    select
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
						proy.fecha_fin_real,
						cbte1.id_proceso_wf as id_proceso_wf_cbte_1,
						cbte2.id_proceso_wf as id_proceso_wf_cbte_2,
						cbte3.id_proceso_wf as id_proceso_wf_cbte_3,
                        proy.importe_max,				--#3 31/12/2018	EGS
                        tfac.total_fase_concepto_ingas::numeric,
                        tinv.total_invitacion::numeric(18,2),
                        proy.justificacion, --#56
                        proy.id_lugar,   --#56
                        proy.caracteristica_tecnica, --#56
                        lug.nombre as lugar,   --#56
                        proy.fecha_rev_aitb --#60
						from pro.tproyecto proy
						inner join segu.tusuario usu1 on usu1.id_usuario = proy.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = proy.id_usuario_mod
						inner join param.vtipo_cc tcc on tcc.id_tipo_cc = proy.id_tipo_cc
						inner join param.tmoneda mon on mon.id_moneda = proy.id_moneda
						left join param.tdepto dep on dep.id_depto = proy.id_depto_conta
						left join conta.tint_comprobante cbte1 on cbte1.id_int_comprobante = proy.id_int_comprobante_1
						left join conta.tint_comprobante cbte2 on cbte2.id_int_comprobante = proy.id_int_comprobante_2
						left join conta.tint_comprobante cbte3 on cbte3.id_int_comprobante = proy.id_int_comprobante_3
                        left join total_facoing tfac on tfac.id_proyecto = proy.id_proyecto
                        left join total_invitacion tinv on tinv.id_proyecto = proy.id_proyecto
                        left join param.tlugar lug on lug.id_lugar = proy.id_lugar --#56
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
						left join conta.tint_comprobante cbte1 on cbte1.id_int_comprobante = proy.id_int_comprobante_1
						left join conta.tint_comprobante cbte2 on cbte2.id_int_comprobante = proy.id_int_comprobante_2
						left join conta.tint_comprobante cbte3 on cbte3.id_int_comprobante = proy.id_int_comprobante_3
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