CREATE OR REPLACE FUNCTION pro.ft_fase_concepto_ingas_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_concepto_ingas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas'
 AUTOR: 		 (admin)
 FECHA:	        24-05-2018 19:13:39
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE	Fork			FECHA				AUTOR				DESCRIPCION
 #0				 24-05-2018 19:13:39								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas'	
 #3					   31/12/2018			EGS						Validacion para qu la suma de los items no sobrepase el importe_max(Stea)
 #5		EndeEtr		   18/01/2019			EGS						Se hace validacion para no  eliminar registros si tiene pagos
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase_concepto_ingas	integer;
    v_record_fase			record;
    v_rec_proyecto			record;
    v_importe_total			numeric;
    v_pagos                 integer;
			    
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
    
        
        --verificamos en que estado esta el proyecto
        	SELECT
            pro.estado,
            pro.importe_max,
            pro.id_proyecto
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
  			WHERE fase.id_fase = v_parametros.id_fase;
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Ingresar un Servicio/Bien en la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
         --validamos que la suma de los items no sobrepase el importe_max (STEA)
         --#3	31/12/2018	EGS	
           SELECT
                sum(coalesce(facoin.precio,0))
            INTO
                v_importe_total
            FROM pro.tfase_concepto_ingas facoin
            left join pro.tfase fase on fase.id_fase = facoin.id_fase
            WHERE fase.id_proyecto = v_rec_proyecto.id_proyecto;
            
            IF v_importe_total + coalesce(v_parametros.precio,0) > v_rec_proyecto.importe_max THEN
            	RAISE EXCEPTION 'La Suma de los Servicios/Bienes (%)mas el precio nuevo(%) = % Superan al Stea(%) ', v_importe_total, coalesce(v_parametros.precio,0),v_importe_total+ coalesce(v_parametros.precio,0),v_rec_proyecto.importe_max;
            END IF;
        	
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
			--cantidad_est,
			--precio_mb,
			precio,
			--precio_mt,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
            fecha_estimada,
            fecha_fin,
            id_funcionario,
            precio_real
          	) values(
			v_parametros.id_fase,
			v_parametros.id_concepto_ingas,
			v_parametros.id_unidad_medida,
			--v_parametros.tipo_cambio_mt,
			v_parametros.descripcion,
			--v_parametros.tipo_cambio_mb,
			'pendiente',
			'activo',
			--v_parametros.cantidad_est,
			--v_parametros.precio_mb,
			v_parametros.precio,
			--v_parametros.precio_mt,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.fecha_estimada,
            v_parametros.fecha_fin,
			v_parametros.id_funcionario,
            v_parametros.precio_real				
			
			
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
        	--verificamos en que estado esta el proyecto
        	SELECT
            pro.estado,
            pro.importe_max,
            pro.id_proyecto
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
  			WHERE fase.id_fase = v_parametros.id_fase;
            
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar los Bienes/Servicion de la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            
            --validamos que la suma de los items no sobrepase el importe_max (STEA)
         	--#3	31/12/2018	EGS	
            SELECT
                sum(coalesce(facoin.precio,0))
            INTO
                v_importe_total
            FROM pro.tfase_concepto_ingas facoin
            left join pro.tfase fase on fase.id_fase = facoin.id_fase
            WHERE fase.id_proyecto = v_rec_proyecto.id_proyecto
            AND facoin.id_fase_concepto_ingas <> v_parametros.id_fase_concepto_ingas;
            
            IF v_importe_total + coalesce(v_parametros.precio,0) > v_rec_proyecto.importe_max THEN
            	RAISE EXCEPTION 'La Suma de los Servicios/Bienes (%)mas el precio modificado(%)= % Superan al Stea(%) ',v_importe_total ,coalesce(v_parametros.precio,0),v_importe_total+ coalesce(v_parametros.precio,0),v_rec_proyecto.importe_max;
            END IF;
            
			--Sentencia de la modificacion
			update pro.tfase_concepto_ingas set
			id_fase = v_parametros.id_fase,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_unidad_medida = v_parametros.id_unidad_medida,
			--tipo_cambio_mt = v_parametros.tipo_cambio_mt,
			descripcion = v_parametros.descripcion,
			--tipo_cambio_mb = v_parametros.tipo_cambio_mb,
			--cantidad_est = v_parametros.cantidad_est,
			--precio_mb = v_parametros.precio_mb,
			precio = v_parametros.precio,
			--precio_mt = v_parametros.precio_mt,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
           	fecha_estimada = v_parametros.fecha_estimada,
            fecha_fin = v_parametros.fecha_fin,
            id_funcionario = v_parametros.id_funcionario,
            precio_real = v_parametros.precio_real

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
        	--verificamos en que estado esta el proyecto
            SELECT
            facoing.id_fase
            into
            v_record_fase
            FROM pro.tfase_concepto_ingas facoing
            WHERE facoing.id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
            
        	SELECT
            pro.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
  			WHERE fase.id_fase = v_record_fase.id_fase;
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Eliminar el Bien/Servicio la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            --#5
            SELECT
                count(facoinpa.id_fase_concepto_ingas_pago)
            into
            v_pagos
            FROM pro.tfase_concepto_ingas_pago facoinpa
            WHERE facoinpa.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            
            IF(v_pagos <> 0 )THEN
                raise exception 'No puede Eliminar el Bien/Servicio cuenta con % pago(s)',v_pagos;
            END IF;
            --#5
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
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;