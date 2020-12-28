--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_cuenta_excluir_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_cuenta_excluir_ime
 DESCRIPCION:   Funcion para registro de las cuentas contables a excluir en el proceso de cierre de proyectos
 AUTOR: 		(rchumacero)
 FECHA:	        06-01-2020 19:22:43
 COMENTARIOS:
***************************************************************************
 ISSUE  SIS       EMPRESA       FECHA       AUTOR       DESCRIPCION
 #51    PRO       ETR           06/01/2020  RCM         Creación del archivo
 #MDID-9          ETR           30/03/2020  EGS         Se agrega tipo
***************************************************************************
 */

DECLARE

    v_nro_requerimiento    	integer;
    v_parametros           	record;
    v_id_requerimiento     	integer;
    v_resp		            varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_cuenta_excluir	integer;

BEGIN

    v_nombre_funcion = 'pro.ft_cuenta_excluir_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_CUNEXC_INS'
     #DESCRIPCION:	Insercion de registros
     #AUTOR:		rchumacero
     #FECHA:		06-01-2020 19:22:43
    ***********************************/

    if(p_transaccion='PRO_CUNEXC_INS')then

        begin
            --Sentencia de la insercion
            insert into pro.tcuenta_excluir(
                estado_reg,
                nro_cuenta,
                usuario_ai,
                fecha_reg,
                id_usuario_reg,
                id_usuario_ai,
                fecha_mod,
                id_usuario_mod,
                tipo --#MDID-9
            ) values(
                        'activo',
                        v_parametros.nro_cuenta,
                        v_parametros._nombre_usuario_ai,
                        now(),
                        p_id_usuario,
                        v_parametros._id_usuario_ai,
                        null,
                        null,
                        v_parametros.tipo --#MDID-9



                    )RETURNING id_cuenta_excluir into v_id_cuenta_excluir;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Exclusión Cuentas Contables almacenado(a) con exito (id_cuenta_excluir'||v_id_cuenta_excluir||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_excluir',v_id_cuenta_excluir::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'PRO_CUNEXC_MOD'
         #DESCRIPCION:	Modificacion de registros
         #AUTOR:		rchumacero
         #FECHA:		06-01-2020 19:22:43
        ***********************************/

    elsif(p_transaccion='PRO_CUNEXC_MOD')then

        begin
            --Sentencia de la modificacion
            update pro.tcuenta_excluir set
                                           nro_cuenta = v_parametros.nro_cuenta,
                                           fecha_mod = now(),
                                           id_usuario_mod = p_id_usuario,
                                           id_usuario_ai = v_parametros._id_usuario_ai,
                                           usuario_ai = v_parametros._nombre_usuario_ai,
                                           tipo = v_parametros.tipo --#MDID-9

            where id_cuenta_excluir=v_parametros.id_cuenta_excluir;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Exclusión Cuentas Contables modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_excluir',v_parametros.id_cuenta_excluir::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'PRO_CUNEXC_ELI'
         #DESCRIPCION:	Eliminacion de registros
         #AUTOR:		rchumacero
         #FECHA:		06-01-2020 19:22:43
        ***********************************/

    elsif(p_transaccion='PRO_CUNEXC_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tcuenta_excluir
            where id_cuenta_excluir=v_parametros.id_cuenta_excluir;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Exclusión Cuentas Contables eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_cuenta_excluir',v_parametros.id_cuenta_excluir::varchar);

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