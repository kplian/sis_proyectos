CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_activo_det_mon_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_activo_det_mon_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_activo_det_mon'
 AUTOR: 		 (rchumacero)
 FECHA:	        05-10-2018 18:01:38
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-10-2018 18:01:38								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_activo_det_mon'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_proyecto_activo_det_mon	integer;
			    
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_activo_det_mon_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_ADETM_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		05-10-2018 18:01:38
	***********************************/

	if(p_transaccion='PRO_ADETM_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pro.tproyecto_activo_det_mon(
			id_proyecto_activo_detalle,
			id_moneda,
			importe_actualiz,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_proyecto_activo_detalle,
			v_parametros.id_moneda,
			v_parametros.importe_actualiz,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_proyecto_activo_det_mon into v_id_proyecto_activo_det_mon;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Incremento Actualización almacenado(a) con exito (id_proyecto_activo_det_mon'||v_id_proyecto_activo_det_mon||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo_det_mon',v_id_proyecto_activo_det_mon::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_ADETM_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		05-10-2018 18:01:38
	***********************************/

	elsif(p_transaccion='PRO_ADETM_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tproyecto_activo_det_mon set
			id_proyecto_activo_detalle = v_parametros.id_proyecto_activo_detalle,
			id_moneda = v_parametros.id_moneda,
			importe_actualiz = v_parametros.importe_actualiz,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_proyecto_activo_det_mon=v_parametros.id_proyecto_activo_det_mon;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Incremento Actualización modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo_det_mon',v_parametros.id_proyecto_activo_det_mon::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_ADETM_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rchumacero	
 	#FECHA:		05-10-2018 18:01:38
	***********************************/

	elsif(p_transaccion='PRO_ADETM_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tproyecto_activo_det_mon
            where id_proyecto_activo_det_mon=v_parametros.id_proyecto_activo_det_mon;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Incremento Actualización eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo_det_mon',v_parametros.id_proyecto_activo_det_mon::varchar);
              
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
ALTER FUNCTION "pro"."ft_proyecto_activo_det_mon_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
