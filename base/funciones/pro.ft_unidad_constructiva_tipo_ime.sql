--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_unidad_constructiva_tipo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_unidad_constructiva_tipo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_constructiva_tipo'
 AUTOR:          (egutierrez)
 FECHA:            18-09-2019 19:13:12
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                18-09-2019 19:13:12                                Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_constructiva_tipo'    
 #
 ***************************************************************************/

DECLARE

    v_nro_requerimiento        integer;
    v_parametros               record;
    v_id_requerimiento         integer;
    v_resp                    varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_unidad_constructiva_tipo    integer;
                
BEGIN

    v_nombre_funcion = 'pro.ft_unidad_constructiva_tipo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_UCT_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez    
     #FECHA:        18-09-2019 19:13:12
    ***********************************/

    if(p_transaccion='PRO_UCT_INS')then
                    
        begin
            --Sentencia de la insercion
            insert into pro.tunidad_constructiva_tipo(
            estado_reg,
            componente_macro_tipo,
            tension,
            nombre,
            descripcion,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) values(
            'activo',
            v_parametros.componente_macro_tipo,
            v_parametros.tension,
            v_parametros.nombre,
            v_parametros.descripcion,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null
                            
            
            
            )RETURNING id_unidad_constructiva_tipo into v_id_unidad_constructiva_tipo;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidad Constructiva tipo almacenado(a) con exito (id_unidad_constructiva_tipo'||v_id_unidad_constructiva_tipo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva_tipo',v_id_unidad_constructiva_tipo::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'PRO_UCT_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        18-09-2019 19:13:12
    ***********************************/

    elsif(p_transaccion='PRO_UCT_MOD')then

        begin
            --Sentencia de la modificacion
            update pro.tunidad_constructiva_tipo set
            componente_macro_tipo = v_parametros.componente_macro_tipo,
            tension = v_parametros.tension,
            nombre = v_parametros.nombre,
            descripcion = v_parametros.descripcion,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            where id_unidad_constructiva_tipo=v_parametros.id_unidad_constructiva_tipo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidad Constructiva tipo modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva_tipo',v_parametros.id_unidad_constructiva_tipo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'PRO_UCT_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        18-09-2019 19:13:12
    ***********************************/

    elsif(p_transaccion='PRO_UCT_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tunidad_constructiva_tipo
            where id_unidad_constructiva_tipo=v_parametros.id_unidad_constructiva_tipo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidad Constructiva tipo eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva_tipo',v_parametros.id_unidad_constructiva_tipo::varchar);
              
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