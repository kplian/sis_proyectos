CREATE OR REPLACE FUNCTION pro.f_inserta_fase_concepto_ingas (
  p_administrador integer,
  p_id_usuario integer,
  p_id_solicitud integer,
  p_id_fase integer,
  p_id_invitacon_det integer
)
RETURNS varchar AS
$body$
/*
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_inserta_fase_concepto_ingas
 DESCRIPCION:   Creacion inserta items(fase_concepto_ingas)
 AUTOR: 		(eddy.gutierrez)
 FECHA:	         24/01/2019
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 ***************************************************************************/
 */
 
DECLARE

    v_nombre_funcion               text;
    v_resp                         varchar;
    v_mensaje                      varchar;
    v_codigo_trans                 varchar;   
    v_parametros                   record;
    v_tabla                        varchar;
    v_id_fase_concepto_ingas       varchar;
    v_id_concepto_ingas            integer;
    v_descripcion                  varchar;
    v_cantidad                     numeric;
    v_precio_unitario              integer;
    v_fecha_reg                    date;
    v_id_funcionario               integer;
    v_id_invitacion_det            integer;
    v_id_fase                      integer;
    v_precio_total                 numeric;
BEGIN
       
     v_nombre_funcion = 'pro.f_inserta_fase_concepto_ingas';
     
        --RAISE EXCEPTION 'p_id_invitacon_det %',p_id_invitacon_det;
            v_id_invitacion_det = p_id_invitacon_det;
            v_id_fase = p_id_fase;
           --si el ingreso de item se hace desde una regularizacion de solicitud de compra
           IF p_id_solicitud is not null or p_id_solicitud <> 0 THEN
                SELECT
                    sold.id_concepto_ingas,
                    sold.descripcion,
                    sold.cantidad,
                    sold.precio_unitario,
                    sold.fecha_reg::date,
                    sol.id_funcionario
                INTO
                    v_id_concepto_ingas,
                    v_descripcion,
                    v_cantidad,
                    v_precio_unitario,
                    v_fecha_reg,
                    v_id_funcionario
                FROM adq.tsolicitud_det sold
                left join adq.tsolicitud sol on sol.id_solicitud = sold.id_solicitud
                WHERE sold.id_solicitud = p_id_solicitud;
               
           END IF;
           
           --si el ingreso es  del item no planificado del detalle de una invitacion
           
           IF v_id_invitacion_det is not null or v_id_invitacion_det <> 0  THEN

              SELECT
                    invd.id_concepto_ingas,
                    invd.descripcion,
                    invd.cantidad_sol,
                    invd.precio,
                    invd.fecha_reg::date,
                    inv.id_funcionario
                INTO
                    v_id_concepto_ingas,
                    v_descripcion,
                    v_cantidad,
                    v_precio_unitario,
                    v_fecha_reg,
                    v_id_funcionario
                FROM pro.tinvitacion_det invd
                left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                WHERE invd.id_invitacion_det = v_id_invitacion_det;
                v_precio_total=v_cantidad*v_precio_unitario;
           END IF;
           
 --RAISE EXCEPTION 'v_id_fase %,v_id_concepto_ingas %,v_descripcion %,v_cantidad %,v_precio_unitario %,v_fecha_reg %,v_id_funcionario %',v_id_fase,v_id_concepto_ingas,v_descripcion,v_cantidad,v_precio_unitario,v_fecha_reg,v_id_funcionario;

         --insertando el  item
            v_descripcion = SUBSTRING (v_descripcion, 1, 500);
            v_codigo_trans = 'PRO_FACOING_INS';

                --crear tabla 
            v_tabla = pxp.f_crear_parametro(ARRAY[      
                                '_nombre_usuario_ai',
                                '_id_usuario_ai',  
                                'id_fase',
                                'id_concepto_ingas',
                                'id_unidad_medida',
                                --'tipo_cambio_mt',
                                'descripcion',
                                --'tipo_cambio_mb',
                                --'estado',
                                'estado_reg',
                                --'cantidad_est',
                                --'precio_mb',
                                'precio',
                                --'precio_mt',
                                'fecha_estimada',
                                'fecha_fin',
                                'id_funcionario',			
                                'precio_real'        
                                                      ],
                            ARRAY[
                                'NULL', ---'_nombre_usuario_ai',
                                '',  -----'_id_usuario_ai',    
                                v_id_fase::varchar,--'id_fase','int4'
                                v_id_concepto_ingas::varchar,--'id_concepto_ingas'
                                '1'::varchar,--'id_unidad_medida'
                                --''::varchar,--'tipo_cambio_mt'
                                v_descripcion::varchar,--'descripcion'
                                --''::varchar,--'tipo_cambio_mb'
                                --''::varchar,--'estado'
                                'activo'::varchar,--'estado_reg'
                                --''::varchar,--'cantidad_est'
                                --''::varchar,--'precio_mb'
                                 COALESCE(v_precio_total,0)::varchar,--'precio'
                                --''::varchar,--'precio_mt'
                                v_fecha_reg::varchar,--'fecha_estimada'
                                ''::varchar,--'fecha_fin'
                                v_id_funcionario::varchar,--'id_funcionario'				
                                ''::varchar--'precio_real'
                                ],
                            ARRAY[
                                'varchar',
                                'integer',
                                'int4',--'id_fase'
                                'int4',--'id_concepto_ingas'
                                'int4',--'id_unidad_medida'
                                --'numeric',--'tipo_cambio_mt'
                                'varchar',--'descripcion'
                                --'numeric',--'tipo_cambio_mb'
                                --'varchar',--'estado'
                                'varchar',--'estado_reg'
                                --'numeric',--'cantidad_est'
                                --'numeric',--'precio_mb'
                                'numeric',--'precio'
                                --'numeric',--'precio_mt'
                                'date',--'fecha_estimada'
                                'date',--'fecha_fin'
                                'int4',--'id_funcionario'				
                                'numeric'--'precio_real'
                               ]
                            );
           
            v_resp = pro.ft_fase_concepto_ingas_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
            v_id_fase_concepto_ingas  = pxp.f_recupera_clave(v_resp,'id_fase_concepto_ingas');
            v_id_fase_concepto_ingas    =  split_part(v_id_fase_concepto_ingas, '{', 2);
            v_id_fase_concepto_ingas    =  split_part(v_id_fase_concepto_ingas, '}', 1);
            update pro.tinvitacion_det set
            id_fase_concepto_ingas = v_id_fase_concepto_ingas::integer
            Where id_invitacion_det = v_id_invitacion_det;
                
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