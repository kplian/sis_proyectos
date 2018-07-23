CREATE OR REPLACE FUNCTION "pro"."ft_fase_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase'
 AUTOR: 		 (admin)
 FECHA:	        25-10-2017 13:16:54
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase				integer;
	v_id_fase_fk			integer;
			    
BEGIN

    v_nombre_funcion = 'pro.ft_fase_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	if(p_transaccion='PRO_FASE_INS')then
					
        begin

        	--Verificación del ID de la fase padre
        	if v_parametros.id_fase_fk = 'id' or coalesce(v_parametros.id_fase_fk,'')='' then
        		v_id_fase_fk = null;
        	else
        		v_id_fase_fk = v_parametros.id_fase_fk::integer;
        	end if;

        	--Sentencia de la insercion
        	insert into pro.tfase(
			id_proyecto,
			id_fase_fk,
			nombre,
			codigo,
			descripcion,
			observaciones,
			fecha_ini,
			fecha_fin,
			estado,
			id_tipo_cc,
			estado_reg,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_proyecto,
			v_id_fase_fk,
			v_parametros.nombre,
			v_parametros.codigo,
			v_parametros.descripcion,
			v_parametros.observaciones,
			v_parametros.fecha_ini,
			v_parametros.fecha_fin,
			v_parametros.estado,
			v_parametros.id_tipo_cc,
			'activo',
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null
			)RETURNING id_fase into v_id_fase;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase almacenado(a) con exito (id_fase'||v_id_fase||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase',v_id_fase::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	elsif(p_transaccion='PRO_FASE_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tfase set
			id_proyecto = v_parametros.id_proyecto,
			id_fase_fk = v_parametros.id_fase_fk,
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			descripcion = v_parametros.descripcion,
			observaciones = v_parametros.observaciones,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			estado = v_parametros.estado,
			id_tipo_cc = v_parametros.id_tipo_cc,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_fase=v_parametros.id_fase;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase',v_parametros.id_fase::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	elsif(p_transaccion='PRO_FASE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tfase
            where id_fase=v_parametros.id_fase;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase',v_parametros.id_fase::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pro"."ft_fase_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
