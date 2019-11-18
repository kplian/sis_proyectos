--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_precio_historico_inv (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.f_precio_historico
 DESCRIPCION:  Funcion de historico de precios
 AUTOR:          (EGS)
 FECHA:            29-09-2017 17:05:43
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;

BEGIN

    v_nombre_funcion = 'pro.f_precio_historico_inv';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PREHINV_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin
     #FECHA:        29-09-2017 17:05:43
    ***********************************/

    if(p_transaccion='PRO_PREHINV_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='SELECT
                            invd.id_invitacion_det,
                            inv.codigo,
                            sold.id_solicitud_det,
                            cotd.precio_unitario_mb::numeric(19,2)
                        FROM adq.tcotizacion_det cotd
                        LEFT JOIN adq.tcotizacion cot on cot.id_cotizacion = cotd.id_cotizacion
                        INNER JOIN adq.tsolicitud_det sold on sold.id_solicitud_det = cotd.id_solicitud_det
                        INNER JOIN pro.tinvitacion_det invd on invd.id_solicitud_det = sold.id_solicitud_det
                        INNER JOIN pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                        INNER JOIN pro.tcomponente_concepto_ingas_det coind on coind.id_componente_concepto_ingas_det = invd.id_componente_concepto_ingas_det
                        WHERE cot.estado = ''adjudicado'' and ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
     #TRANSACCION:  'PRO_PREHINV_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin
     #FECHA:        29-09-2017 17:05:43
    ***********************************/

    elsif(p_transaccion='PRO_PREHINV_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(invd.id_invitacion_det)
                        FROM adq.tcotizacion_det cotd
                        LEFT JOIN adq.tcotizacion cot on cot.id_cotizacion = cotd.id_cotizacion
                        INNER JOIN adq.tsolicitud_det sold on sold.id_solicitud_det = cotd.id_solicitud_det
                        INNER JOIN pro.tinvitacion_det invd on invd.id_solicitud_det = sold.id_solicitud_det
                        INNER JOIN pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                        INNER JOIN pro.tcomponente_concepto_ingas_det coind on coind.id_componente_concepto_ingas_det = invd.id_componente_concepto_ingas_det
                        WHERE cot.estado = ''adjudicado'' and ';

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