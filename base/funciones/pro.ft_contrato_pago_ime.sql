CREATE OR REPLACE FUNCTION "pro"."ft_contrato_pago_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_contrato_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcontrato_pago'
 AUTOR: 		 (admin)
 FECHA:	        29-09-2017 17:05:48
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
	v_id_contrato_pago	integer;
			    
BEGIN

    v_nombre_funcion = 'pro.ft_contrato_pago_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_CONPAG_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-09-2017 17:05:48
	***********************************/

	if(p_transaccion='PRO_CONPAG_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pro.tcontrato_pago(
			id_proyecto_contrato,
			fecha_plan,
			id_moneda,
			monto,
			fecha_pago,
			monto_pagado,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_proyecto_contrato,
			v_parametros.fecha_plan,
			v_parametros.id_moneda,
			v_parametros.monto,
			v_parametros.fecha_pago,
			v_parametros.monto_pagado,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null
							
			
			
			)RETURNING id_contrato_pago into v_id_contrato_pago;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Pagos almacenado(a) con exito (id_contrato_pago'||v_id_contrato_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_contrato_pago',v_id_contrato_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_CONPAG_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-09-2017 17:05:48
	***********************************/

	elsif(p_transaccion='PRO_CONPAG_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tcontrato_pago set
			id_proyecto_contrato = v_parametros.id_proyecto_contrato,
			fecha_plan = v_parametros.fecha_plan,
			id_moneda = v_parametros.id_moneda,
			monto = v_parametros.monto,
			fecha_pago = v_parametros.fecha_pago,
			monto_pagado = v_parametros.monto_pagado,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_contrato_pago=v_parametros.id_contrato_pago;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Pagos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_contrato_pago',v_parametros.id_contrato_pago::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_CONPAG_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-09-2017 17:05:48
	***********************************/

	elsif(p_transaccion='PRO_CONPAG_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tcontrato_pago
            where id_contrato_pago=v_parametros.id_contrato_pago;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Pagos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_contrato_pago',v_parametros.id_contrato_pago::varchar);
              
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
ALTER FUNCTION "pro"."ft_contrato_pago_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
