CREATE OR REPLACE FUNCTION pro.f_inserta_fase_concepto_ingas (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_id_invitacion_det integer
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
    v_descripcion                  varchar;
    v_precio_total                 numeric;
    v_date                         date;
    v_record_proyecto               record;
    v_record_invitacion             record;
    v_id_invitacion_det             integer;
BEGIN
       
     v_nombre_funcion = 'pro.f_inserta_fase_concepto_ingas';
     v_parametros = pxp.f_get_record(p_tabla);
     v_id_invitacion_det =p_id_invitacion_det;
     SELECT
        pro.id_moneda
     Into
        v_record_proyecto
     FROM pro.tfase fase
     left Join pro.tproyecto pro on pro.id_proyecto = fase.id_proyecto
     WHERE fase.id_fase = v_parametros.id_fase;
     SELECT
          inv.id_funcionario,
          inv.id_moneda,
          inv.fecha
     Into
        v_record_invitacion
     FROM pro.tinvitacion inv
     WHERE inv.id_invitacion = v_parametros.id_invitacion;
           IF param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O') is null THEN
                raise exception 'No tiene un tipo de cambio para la fecha de la invitacion %',v_record_invitacion.fecha::DATE;
           END IF;
           IF v_record_proyecto.id_moneda = v_record_invitacion.id_moneda THEN
                v_precio_total = (COALESCE(v_parametros.precio,0))*(COALESCE(v_parametros.cantidad_sol,0));
           ELSIF v_record_proyecto.id_moneda = param.f_get_moneda_base() THEN               
                v_precio_total = (COALESCE(v_parametros.cantidad_sol,0))*((COALESCE(v_parametros.precio,0))*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O')):: numeric)):: numeric(18,2);
           ELSIF v_record_proyecto.id_moneda = param.f_get_moneda_triangulacion() THEN
                v_precio_total = (COALESCE(v_parametros.cantidad_sol,0))*((COALESCE(v_parametros.precio,0))/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O')):: numeric)):: numeric(18,2);   
           END IF;
     --insertando el  item
            v_descripcion = SUBSTRING (v_descripcion, 1, 500);
            v_codigo_trans = 'PRO_FACOING_INS';
            v_date =now()::date;
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
                                'precio_est',
                                'codigo'        
                                                      ],
                            ARRAY[
                                'NULL', ---'_nombre_usuario_ai',
                                '',  -----'_id_usuario_ai',    
                                v_parametros.id_fase::varchar,--'id_fase','int4'
                                v_parametros.id_concepto_ingas::varchar,--'id_concepto_ingas'
                                '1'::varchar,--'id_unidad_medida'
                                --''::varchar,--'tipo_cambio_mt'
                                v_parametros.descripcion::varchar,--'descripcion'
                                --''::varchar,--'tipo_cambio_mb'
                                --''::varchar,--'estado'
                                'activo'::varchar,--'estado_reg'
                                --''::varchar,--'cantidad_est'
                                --''::varchar,--'precio_mb'
                                 COALESCE(v_precio_total,0)::varchar,--'precio'
                                --''::varchar,--'precio_mt'
                                v_date::varchar,--'fecha_estimada'
                                ''::varchar,--'fecha_fin'
                                v_record_invitacion.id_funcionario::varchar,--'id_funcionario'				
                                COALESCE(v_precio_total,0)::varchar,--'precio_est'
                                v_parametros.codigo::varchar--codigo
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
                                'numeric',--'precio_est'
                                'varchar'--codigo
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