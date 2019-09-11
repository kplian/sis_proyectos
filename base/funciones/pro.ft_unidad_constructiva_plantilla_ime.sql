--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_unidad_constructiva_plantilla_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_unidad_constructiva_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_constructiva'
 AUTOR:          (egutierrez)
 FECHA:            06-05-2019 14:16:09
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                 AUTOR                DESCRIPCION
 #16                06-05-2019 14:16:09     EGS                Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_constructiva'    
 #
 ***************************************************************************/

DECLARE

    v_nro_requerimiento        integer;
    v_parametros               record;
    v_id_requerimiento         integer;
    v_resp                    varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_unidad_constructiva_plantilla        integer;
    v_id_unidad_constructiva_plantilla_fk   integer;
    v_desc_ingas                            varchar;
                
BEGIN

    v_nombre_funcion = 'pro.ft_unidad_constructiva_plantilla_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_UNCONPL_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez    
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    if(p_transaccion='PRO_UNCONPL_INS')then
                    
        begin
            --Verificación del ID de la UCP padre
            
            if v_parametros.id_unidad_constructiva_plantilla_fk = 'id' then
                v_id_unidad_constructiva_plantilla_fk = null;
            else
                
                v_id_unidad_constructiva_plantilla_fk = v_parametros.id_unidad_constructiva_plantilla_fk::integer;
            end if;
            
            -- antes de insertar verificamos en la rama de la uc no tenga un activo
            IF v_parametros.activo = 'si' THEN
                v_resp = pro.f_verificar_activo_unidad_constructiva_pl(p_administrador,p_id_usuario,p_tabla,'si');
            END IF;
            
            --raise exception 'hola';
            v_parametros.codigo =upper(REPLACE(v_parametros.codigo,' ', ''));
            --Sentencia de la insercion
            insert into pro.tunidad_constructiva_plantilla(
            estado_reg,
            nombre,
            codigo,
            fecha_reg,
            usuario_ai,
            id_usuario_reg,
            id_usuario_ai,
            id_usuario_mod,
            fecha_mod,
            id_unidad_constructiva_plantilla_fk,
            activo,
            descripcion
              ) values(
            'activo',
            v_parametros.nombre,
            v_parametros.codigo,
            now(),
            v_parametros._nombre_usuario_ai,
            p_id_usuario,
            v_parametros._id_usuario_ai,
            null,
            null,
            v_id_unidad_constructiva_plantilla_fk,
            v_parametros.activo,
            v_parametros.descripcion                                                
            )RETURNING id_unidad_constructiva_plantilla into v_id_unidad_constructiva_plantilla;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidades Constructivas almacenado(a) con exito (id_unidad_constructiva_plantilla'||v_id_unidad_constructiva_plantilla||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva_plantilla',v_id_unidad_constructiva_plantilla::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'PRO_UNCONPL_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    elsif(p_transaccion='PRO_UNCONPL_MOD')then

        begin
            v_parametros.codigo =upper(REPLACE(v_parametros.codigo,' ', ''));

            IF v_parametros.activo = 'si' THEN
                v_resp = pro.f_verificar_activo_unidad_constructiva_pl(p_administrador,p_id_usuario,p_tabla,'si');
            END IF;
            
            --Sentencia de la modificacion
            update pro.tunidad_constructiva_plantilla set
            nombre = v_parametros.nombre,
            codigo = v_parametros.codigo,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            id_unidad_constructiva_plantilla_fk = v_parametros.id_unidad_constructiva_plantilla_fk,
            activo = v_parametros.activo,
            descripcion = v_parametros.descripcion
            where id_unidad_constructiva_plantilla = v_parametros.id_unidad_constructiva_plantilla;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidades Constructivas modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva_plantilla',v_parametros.id_unidad_constructiva_plantilla::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'PRO_UNCONPL_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez    
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    elsif(p_transaccion='PRO_UNCONPL_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tunidad_constructiva_plantilla
            where id_unidad_constructiva_plantilla = v_parametros.id_unidad_constructiva_plantilla ;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidades Constructivas eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva_plantilla',v_parametros.id_unidad_constructiva_plantilla::varchar);
              
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