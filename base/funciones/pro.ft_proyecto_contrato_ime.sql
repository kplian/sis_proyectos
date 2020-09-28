--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_proyecto_contrato_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_contrato_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_contrato'
 AUTOR: 		 (admin)
 FECHA:	        29-09-2017 17:05:43
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE       FECHA       AUTHOR          DESCRIPCION
 #MDID-2     28/09/2020  EGS             Se agrgan los capos de fecha_orden_proceder,plazo_dias,monto_anticipo,observaciones
***************************************************************************/

DECLARE

    v_nro_requerimiento    	integer;
    v_parametros           	record;
    v_id_requerimiento     	integer;
    v_resp		            varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_proyecto_contrato	integer;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_contrato_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PROCON_INS'
     #DESCRIPCION:	Insercion de registros
     #AUTOR:		admin
     #FECHA:		29-09-2017 17:05:43
    ***********************************/

    if(p_transaccion='PRO_PROCON_INS')then

        begin
            --Sentencia de la insercion
            insert into pro.tproyecto_contrato(
                nro_contrato,
                nombre,
                id_moneda,
                monto_total,
                fecha_ini,
                id_proyecto,
                cantidad_meses,
                fecha_fin,
                tipo_pagos,
                resumen,
                estado,
                id_proveedor,
                estado_reg,
                id_usuario_ai,
                fecha_reg,
                usuario_ai,
                id_usuario_reg,
                fecha_mod,
                id_usuario_mod,
                fecha_orden_proceder, --#MDID-2
                plazo_dias, --#MDID-2
                monto_anticipo, --#MDID-2
                observaciones --#MDID-2
            ) values(
                        v_parametros.nro_contrato,
                        v_parametros.nombre,
                        v_parametros.id_moneda,
                        v_parametros.monto_total,
                        v_parametros.fecha_ini,
                        v_parametros.id_proyecto,
                        v_parametros.cantidad_meses,
                        v_parametros.fecha_fin,
                        v_parametros.tipo_pagos,
                        v_parametros.resumen,
                        v_parametros.estado,
                        v_parametros.id_proveedor,
                        'activo',
                        v_parametros._id_usuario_ai,
                        now(),
                        v_parametros._nombre_usuario_ai,
                        p_id_usuario,
                        null,
                        null,
                        v_parametros.fecha_orden_proceder, --#MDID-2
                        v_parametros.plazo_dias, --#MDID-2
                        v_parametros.monto_anticipo, --#MDID-2
                        v_parametros.observaciones --#MDID-2



                    )RETURNING id_proyecto_contrato into v_id_proyecto_contrato;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Contratos almacenado(a) con exito (id_proyecto_contrato'||v_id_proyecto_contrato||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_contrato',v_id_proyecto_contrato::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'PRO_PROCON_MOD'
         #DESCRIPCION:	Modificacion de registros
         #AUTOR:		admin
         #FECHA:		29-09-2017 17:05:43
        ***********************************/

    elsif(p_transaccion='PRO_PROCON_MOD')then

        begin
            --Sentencia de la modificacion
            update pro.tproyecto_contrato set
                                              nro_contrato = v_parametros.nro_contrato,
                                              nombre = v_parametros.nombre,
                                              id_moneda = v_parametros.id_moneda,
                                              monto_total = v_parametros.monto_total,
                                              fecha_ini = v_parametros.fecha_ini,
                                              id_proyecto = v_parametros.id_proyecto,
                                              cantidad_meses = v_parametros.cantidad_meses,
                                              fecha_fin = v_parametros.fecha_fin,
                                              tipo_pagos = v_parametros.tipo_pagos,
                                              resumen = v_parametros.resumen,
                                              estado = v_parametros.estado,
                                              id_proveedor = v_parametros.id_proveedor,
                                              fecha_mod = now(),
                                              id_usuario_mod = p_id_usuario,
                                              id_usuario_ai = v_parametros._id_usuario_ai,
                                              usuario_ai = v_parametros._nombre_usuario_ai,
                                              fecha_orden_proceder = v_parametros.fecha_orden_proceder, --#MDID-2
                                              plazo_dias = v_parametros.plazo_dias, --#MDID-2
                                              monto_anticipo = v_parametros.monto_anticipo, --#MDID-2
                                              observaciones = v_parametros.observaciones --#MDID-2
            where id_proyecto_contrato=v_parametros.id_proyecto_contrato;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Contratos modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_contrato',v_parametros.id_proyecto_contrato::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'PRO_PROCON_ELI'
         #DESCRIPCION:	Eliminacion de registros
         #AUTOR:		admin
         #FECHA:		29-09-2017 17:05:43
        ***********************************/

    elsif(p_transaccion='PRO_PROCON_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tproyecto_contrato
            where id_proyecto_contrato=v_parametros.id_proyecto_contrato;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Contratos eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_contrato',v_parametros.id_proyecto_contrato::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

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