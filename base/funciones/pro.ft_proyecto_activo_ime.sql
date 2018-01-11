CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_activo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_activo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_activo'
 AUTOR: 		 (admin)
 FECHA:	        31-08-2017 16:52:19
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
	v_id_proyecto_activo	integer;
			    
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_activo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_PRAF_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-08-2017 16:52:19
	***********************************/

	if(p_transaccion='PRO_PRAF_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pro.tproyecto_activo(
			id_proyecto,
			observaciones,
			estado_reg,
			denominacion,
			descripcion,
			id_clasificacion,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_proyecto,
			v_parametros.observaciones,
			'activo',
			v_parametros.denominacion,
			v_parametros.descripcion,
			v_parametros.id_clasificacion,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_proyecto_activo into v_id_proyecto_activo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición de Activos Fijos almacenado(a) con exito (id_proyecto_activo'||v_id_proyecto_activo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo',v_id_proyecto_activo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_PRAF_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-08-2017 16:52:19
	***********************************/

	elsif(p_transaccion='PRO_PRAF_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tproyecto_activo set
			id_proyecto = v_parametros.id_proyecto,
			observaciones = v_parametros.observaciones,
			denominacion = v_parametros.denominacion,
			descripcion = v_parametros.descripcion,
			id_clasificacion = v_parametros.id_clasificacion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_proyecto_activo=v_parametros.id_proyecto_activo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición de Activos Fijos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo',v_parametros.id_proyecto_activo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_PRAF_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		31-08-2017 16:52:19
	***********************************/

	elsif(p_transaccion='PRO_PRAF_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tproyecto_activo
            where id_proyecto_activo=v_parametros.id_proyecto_activo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición de Activos Fijos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo',v_parametros.id_proyecto_activo::varchar);
              
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
ALTER FUNCTION "pro"."ft_proyecto_activo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
