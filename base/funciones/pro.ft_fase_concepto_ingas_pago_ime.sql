CREATE OR REPLACE FUNCTION pro.ft_fase_concepto_ingas_pago_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_concepto_ingas_pago_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas_pago'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        14-12-2018 13:31:35
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				14-12-2018 13:31:35								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas_pago'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase_concepto_ingas_pago	integer;
    v_rec_proyecto					record;
    v_precio_total					numeric;
    v_importe_total					numeric;
	v_fecha_inicio					DATE;
    v_fecha_fin						DATE;
    v_record_fase_conin_pago  		record;
    v_mes							integer;
    v_gestion						integer;
    v_total							numeric;
    v_mes_li						varchar;
BEGIN

    v_nombre_funcion = 'pro.ft_fase_concepto_ingas_pago_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FACOINPA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		14-12-2018 13:31:35
	***********************************/

	if(p_transaccion='PRO_FACOINPA_INS')then
					
        begin
        	 --verificamos en que estado esta el proyecto
        	SELECT
            pro.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
            left join pro.tfase_concepto_ingas faco on faco.id_fase = fase.id_fase
  			WHERE faco.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
          
        	 IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Ingresar un Plan de Pagos en la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            
            SELECT 
            	facoin.fecha_estimada,
                facoin.fecha_fin,
                facoin.precio
            INTO
            	v_fecha_inicio,
                v_fecha_fin,
            	v_precio_total            	
            FROM pro.tfase_concepto_ingas facoin 
            WHERE facoin.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            
           	IF(v_precio_total is null )THEN
                raise exception 'No puede Ingresar un Plan de Pagos sin un precio total del Bien/Servicio';
            END IF;
            
            IF(v_fecha_inicio is null or v_fecha_fin is null  )THEN
                raise exception 'No ingreso una de la fechas del Bien/Servicio';
            END IF;
            
            SELECT 
                COALESCE(sum(facoinpa.importe),0)
            INTO
            	v_importe_total            	
            FROM pro.tfase_concepto_ingas_pago facoinpa
            LEFT JOIN pro.tfase_concepto_ingas facoin on facoin.id_fase_concepto_ingas = facoinpa.id_fase_concepto_ingas 
            WHERE facoin.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
        	
            IF v_importe_total is null THEN
            	v_importe_total=0;
            END IF;
            --raise exception 'v_precio_total %  v_importe_total %  v_parametros.importe%',v_precio_total ,v_importe_total, v_parametros.importe ;

            v_total = v_importe_total + v_parametros.importe ;
            IF v_precio_total < v_total THEN
                raise exception 'No puede Ingresar un Plan de Pagos la suma de los importes ( % ) superan al Precio Total del Bien/Servicio(%)',v_total,v_precio_total;
            END IF;
            
            IF  v_fecha_inicio > v_parametros.fecha_pago     THEN
                raise exception 'La fecha de Pago es antes a la fecha de incio estimada del Bien/Servicio';
            ELSIF v_parametros.fecha_pago > v_fecha_fin THEN
                raise exception 'La fecha de Pago es despues a la fecha de fin estimada del Bien/Servicio';
            END IF;
            
             FOR v_record_fase_conin_pago IN
             	(    SELECT
                                facoinpa.id_fase_concepto_ingas_pago,
                                date_part('month',facoinpa.fecha_pago)as mes,
                                date_part('year', facoinpa.fecha_pago)as gestion
                            FROM pro.tfase_concepto_ingas_pago facoinpa
                            WHERE  facoinpa.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas )LOOP
                           v_mes = date_part('month',v_parametros.fecha_pago);
                           v_gestion =  date_part('year', v_parametros.fecha_pago);
                           
                             IF v_mes = 1	THEN
                                v_mes_li = 'Enero';
                            ELSIF v_mes = 2	THEN
                                v_mes_li = 'Febrero';
                            ELSIF v_mes = 3	THEN
                                v_mes_li = 'Marzo';
                            ELSIF v_mes = 4	THEN
                                v_mes_li = 'Abril';
                            ELSIF v_mes = 5	THEN
                                v_mes_li = 'Mayo';
                            ELSIF v_mes = 6	THEN
                                v_mes_li = 'Junio';
                            ELSIF v_mes = 7 	THEN
                                v_mes_li = 'Julio';
                            ELSIF v_mes = 8 	THEN
                                v_mes_li = 'Agosto';
                            ELSIF v_mes = 9 	THEN
                                v_mes_li = 'Septiembre';
                            ELSIF v_mes = 10 	THEN
                                v_mes_li = 'Octubre';
                            ELSIF v_mes = 11	THEN
                                v_mes_li = 'Noviembre';
                            ELSIF v_mes = 12	THEN
                                v_mes_li = 'Diciembre';             
                            END IF;
                           
                           
                           
                           IF v_mes = v_record_fase_conin_pago.mes and v_gestion = v_record_fase_conin_pago.gestion THEN
                           		RAISE EXCEPTION 'El mes de % de la Gestion % ya esta ingresado como mes de un Pago',v_mes_li,v_gestion;
                           END IF;
                            
             END LOOP;
            
            
            		
            --Sentencia de la insercion
        	insert into pro.tfase_concepto_ingas_pago(
			id_fase_concepto_ingas,
			importe,
			fecha_pago,
			fecha_pago_real,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod,
            descripcion --#
          	) values(
			v_parametros.id_fase_concepto_ingas,
			v_parametros.importe,
			v_parametros.fecha_pago,
			v_parametros.fecha_pago_real,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null,
            v_parametros.descripcion --#
							
			
			
			)RETURNING id_fase_concepto_ingas_pago into v_id_fase_concepto_ingas_pago;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estimacion Plan de Pagos almacenado(a) con exito (id_fase_concepto_ingas_pago'||v_id_fase_concepto_ingas_pago||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas_pago',v_id_fase_concepto_ingas_pago::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOINPA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		14-12-2018 13:31:35
	***********************************/

	elsif(p_transaccion='PRO_FACOINPA_MOD')then

		begin
        
        	SELECT
            pro.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
            left join pro.tfase_concepto_ingas faco on faco.id_fase = fase.id_fase
  			WHERE faco.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
          
        	 IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar un plan de pago en la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            
            SELECT 
            	facoin.fecha_estimada,
                facoin.fecha_fin,
                facoin.precio
            INTO
            	v_fecha_inicio,
                v_fecha_fin,
            	v_precio_total            	
            FROM pro.tfase_concepto_ingas facoin 
            WHERE facoin.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            
           	IF(v_precio_total is null )THEN
                raise exception 'No puede Ingresar un Plan de Pagos sin un precio total del Bien/Servicio';
            END IF;
            
            IF(v_fecha_inicio is null or v_fecha_fin is null  )THEN
                raise exception 'No ingreso una de la fechas del Bien/Servicio';
            END IF; 
            SELECT 
                 COALESCE(sum(facoinpa.importe),0)
            INTO
            	v_importe_total            	
            FROM pro.tfase_concepto_ingas_pago facoinpa
            LEFT JOIN pro.tfase_concepto_ingas facoin on facoin.id_fase_concepto_ingas = facoinpa.id_fase_concepto_ingas 
            WHERE facoin.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas and facoinpa.id_fase_concepto_ingas_pago <>v_parametros.id_fase_concepto_ingas_pago;
        	
            --raise exception 'v_precio_total %  v_importe_total %',v_precio_total ,v_importe_total ;
            v_total= v_importe_total + v_parametros.importe;
            IF v_precio_total < v_total  THEN
                raise exception 'No puede Editar el importe del Plan de Pagos la suma de los importes (%) superan al Precio Total del Bien/Servicio(%)',v_total,v_precio_total;
            END IF;
            
              IF  v_fecha_inicio > v_parametros.fecha_pago     THEN
                raise exception 'La fecha de Pago es antes a la fecha de incio estimada del Bien/Servicio';
            ELSIF v_parametros.fecha_pago > v_fecha_fin THEN
                raise exception 'La fecha de Pago es despues a la fecha de fin estimada del Bien/Servicio';

            END IF;
            
            
			--Sentencia de la modificacion
			update pro.tfase_concepto_ingas_pago set
			id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas,
			importe = v_parametros.importe,
			fecha_pago = v_parametros.fecha_pago,
			fecha_pago_real = v_parametros.fecha_pago_real,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            descripcion = v_parametros.descripcion --#
			where id_fase_concepto_ingas_pago=v_parametros.id_fase_concepto_ingas_pago;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estimacion Plan de Pagos modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas_pago',v_parametros.id_fase_concepto_ingas_pago::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOINPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		eddy.gutierrez	
 	#FECHA:		14-12-2018 13:31:35
	***********************************/

	elsif(p_transaccion='PRO_FACOINPA_ELI')then

		begin
        	SELECT
            pro.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
            left join pro.tfase_concepto_ingas faco on faco.id_fase = fase.id_fase
            left join pro.tfase_concepto_ingas_pago facopa on facopa.id_fase_concepto_ingas = faco.id_concepto_ingas
  			WHERE facopa.id_fase_concepto_ingas_pago = v_parametros.id_fase_concepto_ingas_pago;
          
        	 IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar un plan de pago en la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
        	
			--Sentencia de la eliminacion
			delete from pro.tfase_concepto_ingas_pago
            where id_fase_concepto_ingas_pago=v_parametros.id_fase_concepto_ingas_pago;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Estimacion Plan de Pagos eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas_pago',v_parametros.id_fase_concepto_ingas_pago::varchar);
              
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