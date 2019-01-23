CREATE OR REPLACE FUNCTION pro.f_inserta_pre_solicitud_compra (
  p_administrador integer,
  p_id_usuario integer,
  p_id_invitacion integer
)
RETURNS varchar AS
$body$
/*
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_inserta_pre_solicitud_compra
 DESCRIPCION:   Creacion inserta pre solicitudes de compra que vienen de la invitacion 
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        11/12/2018
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
   #5              21/01/2019          EGS                 Se hace update de del campo de Fecha real
 ***************************************************************************/
 */
 
DECLARE

	v_nombre_funcion   	 	text;
    v_resp    			 	varchar;
    v_resp_2    			varchar;
    v_mensaje 			 	varchar;
	
    v_codigo_trans			varchar;
    v_codigo_trans_2		varchar;
    
    v_parametros           	record;
    v_tabla					varchar;
    v_tabla_2				varchar;

    item					record;

    v_id_presolicitud       	varchar;
  
  	v_item_cat_comp				record;
    v_record_invitacion			record;
    v_total_invitacion_detalle	numeric;
    v_id_categoria_compra		integer;
    v_fecha					    date;
    v_id_gestion				integer;
    v_tipo_concepto				varchar;
    v_record_detalle			record;
    v_precio					numeric;
    v_id_presolicitud_det		varchar;
    v_count						integer;
    v_record_solicitud			record;
    v_record_uo					record;
    v_id_funcionario_supervisor	INTEGER[];
    v_descripcion				varchar;
    	
    
BEGIN

	 v_nombre_funcion = 'pro.f_inserta_pre_solicitud_compra';
	
       	SELECT
        	inv.tipo,
            inv.id_moneda,
            inv.id_funcionario,
            inv.id_depto,
            inv.lugar_entrega,
            inv.descripcion,
            inv.dias_plazo_entrega,
            inv.id_categoria_compra,
            inv.id_grupo      
        INTO
        v_record_invitacion 
        FROM pro.tinvitacion inv
        WHERE  inv.id_invitacion = p_id_invitacion;    
      
       	---recuperamos la suma del total de todos los detalles de la invitacion
     
        	SELECT
            	sum( COALESCE(invd.cantidad_sol::NUMERIC,0)* COALESCE(invd.precio::NUMERIC,0))
            INTO
            	v_total_invitacion_detalle::numeric
            FROM pro.tinvitacion_det invd
            WHERE invd.id_invitacion = p_id_invitacion;
          	

            IF v_total_invitacion_detalle is null THEN 
            	raise EXCEPTION 'No tiene detalle en la invitacion';
            END IF; 
                 
            --Obtencion de la gestion
            v_fecha = NOW()::date;
            select
            per.id_gestion
            into
            v_id_gestion
            from param.tperiodo per
            where per.fecha_ini <= v_fecha and per.fecha_fin >= v_fecha
            limit 1 offset 0;

            --recuperando id_uo
            SELECT UO.id_uo,
                   UO.cargo_individual,
                   UO.codigo,
                   UO.descripcion,
                   UO.nombre_cargo,
                   UO.nombre_unidad,
                   UO.presupuesta
            INTO 
            v_record_uo
            FROM orga.tuo UO
            WHERE UO.estado_reg = 'activo' and
                  UO.id_uo = orga.f_get_uo_presupuesta(NULL, v_record_invitacion.id_funcionario, v_fecha);
           
           SELECT  
                     pxp.aggarray(id_funcionario) 
                      into
                       v_id_funcionario_supervisor
             FROM orga.f_get_aprobadores_x_funcionario(v_fecha, v_record_invitacion.id_funcionario , 'todos', 'si', 'todos', 'ninguno') AS (id_funcionario integer);      
           --NOTA el valor en la primera posicion del array es el gerente  de menor nivel


         	--insertando la presolicitud de compra de la invitacion

            v_codigo_trans = 'ADQ_PRES_INS';

            --crear tabla 
            v_tabla = pxp.f_crear_parametro(ARRAY[	 
    
                     
                              	'id_grupo',
                                'id_funcionario_supervisor',
                                'id_funcionario',
                               -- 'estado_reg',
                                'obs',
                                'id_uo',
                                --'estado',
                                'fecha_soli',
                                'id_depto',
                                'id_gestion'
                                                                              
                                        ],
            				ARRAY[
                            
                           		v_record_invitacion.id_grupo::varchar,--'id_grupo'
                                v_id_funcionario_supervisor[1]::varchar,--'id_funcionario_supervisor'
                                v_record_invitacion.id_funcionario::varchar,--'id_funcionario'
                               --''::varchar,--'estado_reg'
                                ''::varchar,--'obs'
                                v_record_uo.id_uo::varchar,--'id_uo'
                                --''::varchar,--'estado'
                                v_fecha::varchar,--'fecha_soli'
                                v_record_invitacion.id_depto::varchar,--'id_depto'
                                v_id_gestion::varchar --'id_gestion'
                                ],
                            ARRAY[
       
                            	'int4',--'id_grupo'
                                'int4',--'id_funcionario_supervisor'
                                'int4',--'id_funcionario'
                                --'varchar',--'estado_reg'
                                'text',--'obs'
                                'int4',--'id_uo'
                                --'varchar',--'estado'
                                'date',--'fecha_soli'
                                'int4',--'id_depto'
                                'int4'--'id_gestion'
                               ]
                            );
           
            v_resp = adq.ft_presolicitud_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
          	v_id_presolicitud  = pxp.f_recupera_clave(v_resp,'id_presolicitud');
            v_id_presolicitud	=  split_part(v_id_presolicitud, '{', 2);
            v_id_presolicitud	=  split_part(v_id_presolicitud, '}', 1);
           
            ----insertando los detalles de la presolicitud respectivamente
 			v_count = 0;
			FOR v_record_detalle in ( 
    			SELECT
                 invd.precio,
                 invd.cantidad_sol,
				 invd.id_concepto_ingas,
                 invd.id_centro_costo,
                 invd.descripcion
                FROM pro.tinvitacion_det invd
                WHERE invd.id_invitacion = p_id_invitacion )LOOP
        
       		              	
              if v_record_detalle.descripcion is null or v_record_detalle.descripcion = '' then
              	v_descripcion  = ' ';
              end if;
              v_codigo_trans_2 = 'ADQ_PRED_INS';
              --crear tabla 
              
             /*
             if v_count = 0 then
              raise exception '%',v_record_detalle;
			  end if;
             */
              v_tabla_2 = pxp.f_crear_parametro(ARRAY[
                                        
                                  'descripcion',
                                  'cantidad_sol',
                                  'id_centro_costo',
                                  'id_concepto_ingas',
                                  --'estado_reg',
                                  --'estado',
                                  --'id_solicitud_det',
                                  'id_presolicitud',
                                  'precio'

                                  ],
                              ARRAY[
                              	  v_descripcion::varchar,--'descripcion'
                                  v_record_detalle.cantidad_sol::varchar,--'cantidad'
                                  v_record_detalle.id_centro_costo::varchar,--'id_centro_costo'
                                  v_record_detalle.id_concepto_ingas::varchar ,--'id_concepto_ingas'
                                  --''::varchar,--'estado_reg'
                                  --''::varchar,--'estado'
                                  --''::varchar,--'id_solicitud_det'
                                  v_id_presolicitud::varchar,--'id_presolicitud'
                                  v_record_detalle.precio::varchar --'precio'	
                                   ],
                              ARRAY[
                              	  'text',--'descripcion'
                                  'numeric',--'cantidad'
                                  'int4',--'id_centro_costo'
                                  'int4',--'id_concepto_ingas'
                                  --'varchar',--'estado_reg'
                                  --'varchar',--'estado'
                                  --'int4',--'id_solicitud_det'
                                  'int4',--'id_presolicitud'
                                  'numeric'--'precio'	

                                 ]
                              );
			  v_count = v_count + 1;
              v_resp_2 = adq.ft_presolicitud_det_ime(p_administrador,p_id_usuario,v_tabla_2,v_codigo_trans_2);
              v_id_presolicitud_det  = pxp.f_recupera_clave(v_resp_2,'id_presolicitud_det');
              v_id_presolicitud_det	=  split_part(v_id_presolicitud_det, '{', 2);
              v_id_presolicitud_det	=  split_part(v_id_presolicitud_det, '}', 1);
             -- raise EXCEPTION 'v_id_presolicitud_det %',v_id_presolicitud_det;

              v_resp	= 'exito';
			END LOOP;
			
            --Actualizando invitacion cuando se genera una solicitud
            
            UPDATE pro.tinvitacion
            set id_presolicitud = v_id_presolicitud::INTEGER,
                fecha_real = v_fecha-- #5
            where id_invitacion = p_id_invitacion;           
            	
	RETURN   v_resp;

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