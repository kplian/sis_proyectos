CREATE OR REPLACE FUNCTION pro.f_inserta_solicitud_compra (
  p_administrador integer,
  p_id_usuario integer,
  p_id_invitacion integer
)
RETURNS varchar AS
$body$
/*
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_inserta_solicitud_compra
 DESCRIPCION:   Creacion inserta solicitudes de compra que vienen de la invitacion 
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#
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

    v_id_solicitud       	varchar;
  
  	v_item_cat_comp				record;
    v_record_invitacion			record;
    v_total_invitacion_detalle	numeric;
    v_id_categoria_compra		integer;
    v_fecha					    date;
    v_id_gestion				integer;
    v_tipo_concepto				varchar;
    v_record_detalle			record;
    v_precio					numeric;
    v_id_solicitud_det			varchar;
    v_count						integer;
    v_record_solicitud			record;
    
BEGIN

	 v_nombre_funcion = 'pro.f_inserta_solicitud_compra';
	
     --verificar si existe el documento
	 --raise Exception 'invitacion % ',p_id_invitacion;
      --raise exception ' p_id_usuario %', p_id_usuario;
       --raise Exception 'invitacion %',p_administrador;
       	SELECT
        	inv.tipo,
            inv.id_moneda,
            inv.id_funcionario,
            inv.id_depto,
            inv.lugar_entrega,
            inv.descripcion,
            inv.dias_plazo_entrega,
            inv.id_categoria_compra
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
    		--recuperamos el tipo_concepto como este dato ya viene quemado en la vista  de solictud de compra
            IF v_record_invitacion.tipo = 'Bien' THEN
            	v_tipo_concepto ='bien';
            ELSE
            	v_tipo_concepto ='servicio';
            END IF;
            

         --insertando la solicitud de compra de la invitacion el precontrato y el comprometer_87 ya vienen directo de la vista de solicitud de compras

            v_codigo_trans = 'ADQ_SOL_INS';

                --crear tabla 
            v_tabla = pxp.f_crear_parametro(ARRAY[	  
                                '_nombre_usuario_ai',
                                '_id_usuario_ai',  
                                --'estado_reg',
                                --'id_solicitud_ext',
                                --'presu_revertido',
                                --'fecha_apro',
                                --'estado',
                                'id_moneda',
                                'id_gestion',
                                'tipo',
                                --'num_tramite',
                                'justificacion',
                                'id_depto',
                                'lugar_entrega',
                                'extendida',
                                'numero',
                                --'posibles_proveedores',
                                --'id_proceso_wf',
                                --'comite_calificacion',
                                'id_categoria_compra',
                                'id_funcionario',
                                --'id_estado_wf',
                                'fecha_soli',		
                                'id_proceso_macro',		
                                'id_proveedor',
                                'tipo_concepto',	
                                'fecha_inicio',
                                'dias_plazo_entrega',
                                'precontrato',
                                'correo_proveedor',		
                                'nro_po',
                                'fecha_po',
                                'comprometer_87',
                                'observacion'                         
                                                      ],
            				ARRAY[
                            	'NULL', ---'_nombre_usuario_ai',
                                '',  -----'_id_usuario_ai',	
                                --''::varchar,--'estado_reg'
                                --''::varchar,--'id_solicitud_ext'
                                --''::varchar,--'presu_revertido'
                                --''::varchar,--'fecha_apro'
                                --''::varchar,--'estado'
                                v_record_invitacion.id_moneda::varchar,--'id_moneda'
                                v_id_gestion::varchar,--'id_gestion'
                                v_record_invitacion.tipo::varchar,--'tipo'
                                --''::varchar,--'num_tramite'
                                v_record_invitacion.descripcion::varchar,--'justificacion'
                                v_record_invitacion.id_depto::varchar,--'id_depto'
                                v_record_invitacion.lugar_entrega::varchar,--'lugar_entrega'
                                ''::varchar,--'extendida'
                                ''::varchar,--'numero'
                                --''::varchar,--'posibles_proveedores'
                                --''::varchar,--'id_proceso_wf'
                                --''::varchar,--'comite_calificacion'
                                v_record_invitacion.id_categoria_compra::varchar,--'id_categoria_compra'
                                v_record_invitacion.id_funcionario::varchar,--'id_funcionario'
                                --''::varchar,--'id_estado_wf'
                                v_fecha::varchar,--'fecha_soli'		
                                ''::varchar,--'id_proceso_macro'		
                                ''::varchar,--'id_proveedor'
                                v_tipo_concepto::varchar,--'tipo_concepto'	
                                ''::varchar,--'fecha_inicio'
                                v_record_invitacion.dias_plazo_entrega::varchar,--'dias_plazo_entrega'
                                'no_necesita'::varchar,--'precontrato'
                                ''::varchar,--'correo_proveedor'	
                                ''::varchar,--'nro_po'
                                ''::varchar,--'fecha_po'
                                'no'::varchar,--'comprometer_87'
                                ''::varchar--'observacion'
                                ],
                            ARRAY[
                           		'varchar',
                                'integer',
                            	--'varchar',--'estado_reg'
                                --'int4',--'id_solicitud_ext'
                                --'varchar',--'presu_revertido'
                                --'date',--'fecha_apro'
                                --'varchar',--'estado'
                                'int4',--'id_moneda'
                                'int4',--'id_gestion'
                                'varchar',--'tipo'
                                --'varchar',--'num_tramite'
                                'text',--'justificacion'
                                'int4',--'id_depto'
                                'varchar',--'lugar_entrega'
                                'varchar',--'extendida'
                                'varchar',--'numero'
                                --'text',--'posibles_proveedores'
                                --'int4',--'id_proceso_wf'
                                --'text',--'comite_calificacion'
                                'int4',--'id_categoria_compra'
                                'int4',--'id_funcionario'
                                --'int4',--'id_estado_wf'
                                'date',--'fecha_soli'		
                                'int4',--'id_proceso_macro'		
                                'int4',--'id_proveedor'
                                'varchar',--'tipo_concepto'
                                'date',--'fecha_inicio'
                                'integer',--'dias_plazo_entrega'
                                'varchar',--'precontrato'
                                'varchar',--'correo_proveedor'		
                                'varchar',--'nro_po'
                                'date',--'fecha_po'
                                'varchar',--'comprometer_87'
                                'text' --'observacion'
                               ]
                            );
           
            v_resp = adq.f_solicitud_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
          	v_id_solicitud  = pxp.f_recupera_clave(v_resp,'id_solicitud');
            v_id_solicitud	=  split_part(v_id_solicitud, '{', 2);
            v_id_solicitud	=  split_part(v_id_solicitud, '}', 1);
            
            ----insertando los detalles de la solicitud respectivamente
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
        
       
              
              v_codigo_trans_2 = 'ADQ_SOLD_INS';
              --crear tabla 
              
              v_precio = v_record_detalle.precio * v_record_detalle.cantidad_sol;
             /*
             if v_count = 0 then
              raise exception '%',v_record_detalle;
			  end if;
             */
              v_tabla_2 = pxp.f_crear_parametro(ARRAY[
                            
                                 'id_centro_costo', 
                                 'descripcion',
                                 'precio_unitario',
                                 'id_solicitud',
                                 'id_orden_trabajo',
                                 'id_concepto_ingas', 
                                 'precio_total',
                                 'cantidad_sol', 
                                 'precio_ga', 
                                 'precio_sg'
                                  ],
                              ARRAY[	
                                 v_record_detalle.id_centro_costo::varchar , --'id_centro_costo'
                                 v_record_detalle.descripcion::varchar , --'descripcion'
                                 v_record_detalle.precio::varchar , --'precio_unitario'
                                 v_id_solicitud::varchar , --'id_solicitud'
                                 ''::varchar , --'id_orden_trabajo'
                                 v_record_detalle.id_concepto_ingas::varchar , --'id_concepto_ingas'
                                 v_precio::varchar , --'precio_total'
                                 v_record_detalle.cantidad_sol::varchar , --'cantidad_sol'
                                 v_precio::varchar , --'precio_ga'
                                 0::varchar --'precio_sg'
                                  ],
                              ARRAY[
                                  'int4', --'id_centro_costo'
                                  'text', --'descripcion'
                                  'numeric', --'precio_unitario'
                                  'int4', --'id_solicitud'
                                  'int4', --'id_orden_trabajo'
                                  'int4', --'id_concepto_ingas'
                                  'numeric', --'precio_total'
                                  'int4', --'cantidad_sol'
                                  'numeric', --'precio_ga'
                                  'numeric' --'precio_sg'
                                 ]
                              );
			  v_count = v_count + 1;
              v_resp_2 = adq.f_solicitud_det_ime(p_administrador,p_id_usuario,v_tabla_2,v_codigo_trans_2);
              v_id_solicitud_det  = pxp.f_recupera_clave(v_resp_2,'id_solicitud_det');
              v_id_solicitud_det	=  split_part(v_id_solicitud_det, '{', 2);
              v_id_solicitud_det	=  split_part(v_id_solicitud_det, '}', 1);
              v_resp	= 'exito';
			END LOOP;
			
            --Actualizando invitacion cuando se genera una solicitud
            
            UPDATE pro.tinvitacion
            set id_solicitud = v_id_solicitud::INTEGER
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
