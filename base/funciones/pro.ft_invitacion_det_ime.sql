CREATE OR REPLACE FUNCTION pro.ft_invitacion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_invitacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tinvitacion_det'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        22-08-2018 22:32:59
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				22-08-2018 22:32:59								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tinvitacion_det'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_invitacion_det	integer;
			    
BEGIN

    v_nombre_funcion = 'pro.ft_invitacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_IVTD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		22-08-2018 22:32:59
	***********************************/

	if(p_transaccion='PRO_IVTD_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pro.tinvitacion_det(
			id_fase_concepto_ingas,
			id_invitacion,
			estado_reg,
			observaciones,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            cantidad_sol,
            id_unidad_medida,
            precio,
            id_centro_costo,
            descripcion,
            id_fase,
            id_concepto_ingas
          	) values(
            v_parametros.id_fase_concepto_ingas,
			v_parametros.id_invitacion,
			'activo',
			v_parametros.observaciones,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.cantidad_sol,
			v_parametros.id_unidad_medida,
			v_parametros.precio,
            v_parametros.id_centro_costo,
			v_parametros.descripcion,
            v_parametros.id_fase,
            v_parametros.id_concepto_ingas				
			
			
			)RETURNING id_invitacion_det into v_id_invitacion_det;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion det almacenado(a) con exito (id_invitacion_det'||v_id_invitacion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion_det',v_id_invitacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_IVTD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		22-08-2018 22:32:59
	***********************************/

	elsif(p_transaccion='PRO_IVTD_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tinvitacion_det set
			id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas,
			id_invitacion = v_parametros.id_invitacion,
			observaciones = v_parametros.observaciones,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            cantidad_sol =  v_parametros.cantidad_sol,
            id_unidad_medida = v_parametros.id_unidad_medida,
            precio = v_parametros.precio
            --id_centro_costo =  v_parametros.id_centro_costo
            --descripcion = v_parametros.descripcion
           -- id_fase=v_parametros.id_fase
           --id_concepto_ingas=v_parametros.id_concepto_ingas
			where id_invitacion_det=v_parametros.id_invitacion_det;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion det modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion_det',v_parametros.id_invitacion_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_IVTD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		22-08-2018 22:32:59
	***********************************/

	elsif(p_transaccion='PRO_IVTD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tinvitacion_det
            where id_invitacion_det=v_parametros.id_invitacion_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion det eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion_det',v_parametros.id_invitacion_det::varchar);
              
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
