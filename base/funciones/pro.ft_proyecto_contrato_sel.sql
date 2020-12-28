--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_proyecto_contrato_sel (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_contrato_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tproyecto_contrato'
 AUTOR: 		 (admin)
 FECHA:	        29-09-2017 17:05:43
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE       FECHA       AUTHOR          DESCRIPCION
 #MDID-2     28/09/2020  EGS             Se agrgan los capos de fecha_orden_proceder,plazo_dias,monto_anticipo,observaciones
***************************************************************************/

DECLARE

    v_consulta    		varchar;
    v_parametros  		record;
    v_nombre_funcion   	text;
    v_resp				varchar;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_contrato_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PROCON_SEL'
     #DESCRIPCION:	Consulta de datos
     #AUTOR:		admin
     #FECHA:		29-09-2017 17:05:43
    ***********************************/

    if(p_transaccion='PRO_PROCON_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select
						procon.id_proyecto_contrato,
						procon.nro_contrato,
						procon.nombre,
						procon.id_moneda,
						procon.monto_total,
						procon.fecha_ini,
						procon.id_proyecto,
						procon.cantidad_meses,
						procon.fecha_fin,
						procon.tipo_pagos,
						procon.resumen,
						procon.estado,
						procon.id_proveedor,
						procon.estado_reg,
						procon.id_usuario_ai,
						procon.fecha_reg,
						procon.usuario_ai,
						procon.id_usuario_reg,
						procon.fecha_mod,
						procon.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
						prov.desc_proveedor,
						mon.moneda,
                        procon.fecha_orden_proceder, --#MDID-2
                        procon.plazo_dias, --#MDID-2
                        procon.monto_anticipo, --#MDID-2
                        procon.observaciones --#MDID-2
						from pro.tproyecto_contrato procon
						inner join segu.tusuario usu1 on usu1.id_usuario = procon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = procon.id_usuario_mod
						inner join param.vproveedor prov
						on prov.id_proveedor = procon.id_proveedor
						inner join param.tmoneda mon
						on mon.id_moneda = procon.id_moneda
				        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'PRO_PROCON_CONT'
         #DESCRIPCION:	Conteo de registros
         #AUTOR:		admin
         #FECHA:		29-09-2017 17:05:43
        ***********************************/

    elsif(p_transaccion='PRO_PROCON_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(id_proyecto_contrato)
					    from pro.tproyecto_contrato procon
					    inner join segu.tusuario usu1 on usu1.id_usuario = procon.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = procon.id_usuario_mod
						inner join param.vproveedor prov
						on prov.id_proveedor = procon.id_proveedor
						inner join param.tmoneda mon
						on mon.id_moneda = procon.id_moneda
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