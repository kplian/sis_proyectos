CREATE OR REPLACE FUNCTION "pro"."ft_fase_concepto_ingas_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_concepto_ingas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas'
 AUTOR: 		 (admin)
 FECHA:	        24-05-2018 19:13:39
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				24-05-2018 19:13:39								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase_concepto_ingas	integer;
			    
BEGIN

    v_nombre_funcion = 'pro.ft_fase_concepto_ingas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	if(p_transaccion='PRO_FACOING_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pro.tfase_concepto_ingas(
			id_fase,
			id_concepto_ingas,
			id_unidad_medida,
			--tipo_cambio_mt,
			descripcion,
			--tipo_cambio_mb,
			estado,
			estado_reg,
			cantidad,
			--precio_mb,
			precio,
			--precio_mt,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_fase,
			v_parametros.id_concepto_ingas,
			v_parametros.id_unidad_medida,
			--v_parametros.tipo_cambio_mt,
			v_parametros.descripcion,
			--v_parametros.tipo_cambio_mb,
			'pendiente',
			'activo',
			v_parametros._cantidad,
			--v_parametros.precio_mb,
			v_parametros.precio,
			--v_parametros.precio_mt,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null
							
			
			
			)RETURNING id_fase_concepto_ingas into v_id_fase_concepto_ingas;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase Concepto de Gasto almacenado(a) con exito (id_fase_concepto_ingas'||v_id_fase_concepto_ingas||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas',v_id_fase_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	elsif(p_transaccion='PRO_FACOING_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tfase_concepto_ingas set
			id_fase = v_parametros.id_fase,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_unidad_medida = v_parametros.id_unidad_medida,
			--tipo_cambio_mt = v_parametros.tipo_cambio_mt,
			descripcion = v_parametros.descripcion,
			--tipo_cambio_mb = v_parametros.tipo_cambio_mb,
			cantidad = v_parametros._cantidad,
			--precio_mb = v_parametros.precio_mb,
			precio = v_parametros.precio,
			--precio_mt = v_parametros.precio_mt,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase Concepto de Gasto modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas',v_parametros.id_fase_concepto_ingas::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	elsif(p_transaccion='PRO_FACOING_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tfase_concepto_ingas
            where id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase Concepto de Gasto eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas',v_parametros.id_fase_concepto_ingas::varchar);
              
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
ALTER FUNCTION "pro"."ft_fase_concepto_ingas_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
