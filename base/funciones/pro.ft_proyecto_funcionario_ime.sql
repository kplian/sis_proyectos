CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_funcionario_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_funcionario_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_funcionario'
 AUTOR: 		 (admin)
 FECHA:	        28-09-2017 20:12:19
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
	v_id_proyecto_funcionario	integer;
			    
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_funcionario_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_PROYFU_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		28-09-2017 20:12:19
	***********************************/

	if(p_transaccion='PRO_PROYFU_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into pro.tproyecto_funcionario(
			estado_reg,
			id_proyecto,
			rol,
			id_funcionario,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_proyecto,
			v_parametros.rol,
			v_parametros.id_funcionario,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_proyecto_funcionario into v_id_proyecto_funcionario;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionarios del  Proyecto almacenado(a) con exito (id_proyecto_funcionario'||v_id_proyecto_funcionario||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_funcionario',v_id_proyecto_funcionario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_PROYFU_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		28-09-2017 20:12:19
	***********************************/

	elsif(p_transaccion='PRO_PROYFU_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tproyecto_funcionario set
			id_proyecto = v_parametros.id_proyecto,
			rol = v_parametros.rol,
			id_funcionario = v_parametros.id_funcionario,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_proyecto_funcionario=v_parametros.id_proyecto_funcionario;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionarios del  Proyecto modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_funcionario',v_parametros.id_proyecto_funcionario::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_PROYFU_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		28-09-2017 20:12:19
	***********************************/

	elsif(p_transaccion='PRO_PROYFU_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tproyecto_funcionario
            where id_proyecto_funcionario=v_parametros.id_proyecto_funcionario;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Funcionarios del  Proyecto eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_funcionario',v_parametros.id_proyecto_funcionario::varchar);
              
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
ALTER FUNCTION "pro"."ft_proyecto_funcionario_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
