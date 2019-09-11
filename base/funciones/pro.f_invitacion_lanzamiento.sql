--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_invitacion_lanzamiento (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_id_invitacion integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_invitacion_lanzamiento
 DESCRIPCION:   gestiona la clonacion de los lanzamientos
 AUTOR:         
 FECHA:         
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
	ISSUE			FECHA		AUTHOR			DESCRIPCION
    #15	Etr			31/07/2019	 EGS		    creacion
    #20 EndeEtr     30/08/2019   EGS            Validacion para Relanzamientos
***************************************************************************/

DECLARE

    v_parametros                record;
    v_resp                      varchar;
    v_nombre_funcion            text;
    v_mensaje_error             text;
    v_record                    record;
    v_id_invitacion             integer;
    v_record_coti_det           record;
    v_cantidad_adju             numeric;
    v_codigo_trans              varchar;
    v_tabla                     varchar;

BEGIN

    v_nombre_funcion = 'pro.f_invitacion_lanzamiento';
    v_parametros = pxp.f_get_record(p_tabla);
    --verificamos si el lanzamiento es el de segundo
           SELECT
                inv.id_invitacion
           INTO
                v_id_invitacion
           FROM pro.tinvitacion inv
           WHERE inv.id_invitacion_fk =  v_parametros.id_invitacion_fk and inv.id_invitacion <> p_id_invitacion ;

       IF v_id_invitacion is NULL THEN

            --si es el segundo clonamos el detalle del primer lanzamiento
            FOR v_record IN(
                SELECT
                    invd.id_invitacion_det,
                    invd.observaciones,
                    invd.cantidad_sol,
                    invd.id_unidad_medida,
                    invd.precio,
                    invd.id_fase_concepto_ingas,
                    invd.id_centro_costo,
                    invd.descripcion,
                    invd.id_fase,
                    invd.id_concepto_ingas,
                    invd.id_presolicitud_det,
                    invd.id_solicitud_det,
                    invd.id_unidad_constructiva
                FROM pro.tinvitacion_det invd
                WHERE invd.id_invitacion = v_parametros.id_invitacion_fk )LOOP

                --Se recupera si el detalle tuvo alguna adjudicacion

                   v_cantidad_adju = 0;
                   FOR v_record_coti_det IN (
                      SELECT
                          cotd.cantidad_adju
                      FROM adq.tcotizacion_det cotd
                      WHERE cotd.id_solicitud_det = v_record.id_solicitud_det
                    )LOOP
                      v_cantidad_adju = v_cantidad_adju + v_record_coti_det.cantidad_adju;
                   END LOOP;
                   --si la cantidad sol no es igual a la cantidad adjudicada restamos
                   IF v_record.cantidad_sol > v_cantidad_adju THEN
                      v_record.cantidad_sol = v_record.cantidad_sol - v_cantidad_adju; --Al clonar solo dejamos el saldo despues de la adjudicacion
                   ELSIF v_record.cantidad_sol < v_cantidad_adju THEN
                      RAISE EXCEPTION 'La cantidad adjudicada es mayor a la cantidad lanzada en la invitacion ';
                   END IF;

                INSERT INTO
                              pro.tinvitacion_det
                            (
                              id_usuario_reg,
                              id_usuario_mod,
                              fecha_reg,
                              fecha_mod,
                              estado_reg,
                              id_usuario_ai,
                              usuario_ai,
                              id_invitacion,
                              observaciones,
                              cantidad_sol,
                              id_unidad_medida,
                              precio,
                              id_fase_concepto_ingas,
                              id_centro_costo,
                              descripcion,
                              id_fase,
                              id_concepto_ingas,
                              id_presolicitud_det,
                              id_solicitud_det,
                              id_unidad_constructiva,
                              estado_lanz,
                              id_invitacion_det_fk
                            )
                            VALUES (

                              p_id_usuario,
                              NULL,
                              now(),
                              NULL,
                              'activo',
                              v_parametros._id_usuario_ai,
                              v_parametros._nombre_usuario_ai,
                              p_id_invitacion,
                              v_record.observaciones,
                              v_record.cantidad_sol::numeric(18,2),
                              v_record.id_unidad_medida,
                              v_record.precio,
                              v_record.id_fase_concepto_ingas,
                              v_record.id_centro_costo,
                              v_record.descripcion,
                              v_record.id_fase,
                              v_record.id_concepto_ingas,
                              v_record.id_presolicitud_det,
                              null,
                              v_record.id_unidad_constructiva,
                              'activo',
                              v_record.id_invitacion_det
                            );

                   IF v_cantidad_adju <> 0 THEN
                     UPDATE  pro.tinvitacion_det  SET
                          cantidad_sol = v_cantidad_adju
                     WHERE id_invitacion_det = v_record.id_invitacion_det;

                   ELSE
                     UPDATE  pro.tinvitacion_det  SET
                          estado_lanz = 'inactivo'
                     WHERE id_invitacion_det = v_record.id_invitacion_det;
                   END IF;
            END LOOP;
    ELSE

        --si es el tercer o cuarto , etc lanzamientos
        --creamos tabla temporal
          CREATE TEMPORARY TABLE temp_invitacion(
                                id_invitacion integer,
                                fecha_reg     timestamp
                                ) ON COMMIT DROP;
          --insertamos las invitaciones relacionadas al primer lanzamiento por fecha
          FOR v_record IN(
                SELECT
                    inv.id_invitacion,
                    fecha_reg
           FROM pro.tinvitacion inv
          WHERE inv.id_invitacion_fk = v_parametros.id_invitacion_fk and inv.id_invitacion <> p_id_invitacion
          ORDER BY fecha_reg ASC
           )LOOP

                INSERT INTO temp_invitacion
                    (
                    id_invitacion,
                    fecha_reg
                    )values(
                    v_record.id_invitacion,
                    v_record.fecha_reg
                    );
          END LOOP;

          --#20 Seleccionamos la invitacion con la ultima fecha de creacion
          SELECT
            t.id_invitacion
          INTO
            v_id_invitacion
          FROM temp_invitacion t
          WHERE t.fecha_reg = (SELECT max(t.fecha_reg) FROM temp_invitacion t );
          v_codigo_trans='PRO_ESTIVT_IME';
          v_tabla = pxp.f_crear_parametro(
          ARRAY['id_invitacion'],
          ARRAY[v_id_invitacion::varchar],
          ARRAY['int4']
                            );
          v_resp = pro.ft_invitacion_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);


          --clonamos los detalles relacionados al ultimo lanzamiento        
          FOR v_record IN(
                SELECT 
                    invd.id_invitacion_det,
                    invd.observaciones,
                    invd.cantidad_sol,
                    invd.id_unidad_medida,
                    invd.precio,
                    invd.id_fase_concepto_ingas,
                    invd.id_centro_costo,
                    invd.descripcion,
                    invd.id_fase,
                    invd.id_concepto_ingas,
                    invd.id_presolicitud_det,
                    invd.id_solicitud_det,
                    invd.id_unidad_constructiva
                FROM pro.tinvitacion_det invd
                
                WHERE invd.id_invitacion = v_id_invitacion )LOOP
                              
                --Se recupera si el detalle tuvo alguna adjudicacion
                                 
                   v_cantidad_adju = 0;
                   FOR v_record_coti_det IN (   
                      SELECT 
                          cotd.cantidad_adju      
                      FROM adq.tcotizacion_det cotd
                      WHERE cotd.id_solicitud_det = v_record.id_solicitud_det
                    )LOOP
                      v_cantidad_adju = v_cantidad_adju + COALESCE(v_record_coti_det.cantidad_adju,0);
                   END LOOP; 
                   
                   --si la cantidad sol no es igual a la cantidad adjudicada restamos                 
                   IF v_record.cantidad_sol > v_cantidad_adju THEN   
                      v_record.cantidad_sol = v_record.cantidad_sol - v_cantidad_adju; --Al clonar solo dejamos el saldo despues de la adjudicacion
                   ELSIF v_record.cantidad_sol < v_cantidad_adju THEN
                      RAISE EXCEPTION 'La cantidad adjudicada es mayor a la cantidad lanzada en la invitacion ';
                   END IF;
                INSERT INTO 
                              pro.tinvitacion_det
                            (
                              id_usuario_reg,
                              id_usuario_mod,
                              fecha_reg,
                              fecha_mod,
                              estado_reg,
                              id_usuario_ai,
                              usuario_ai,
                              id_invitacion,
                              observaciones,
                              cantidad_sol,
                              id_unidad_medida,
                              precio,
                              id_fase_concepto_ingas,
                              id_centro_costo,
                              descripcion,
                              id_fase,
                              id_concepto_ingas,
                              id_presolicitud_det,
                              id_solicitud_det,
                              id_unidad_constructiva,
                              estado_lanz,
                              id_invitacion_det_fk
                            )
                            VALUES (

                              p_id_usuario,
                              NULL,
                              now(),
                              NULL,
                              'activo',
                              v_parametros._id_usuario_ai,
                              v_parametros._nombre_usuario_ai,
                              p_id_invitacion,
                              v_record.observaciones,
                              v_record.cantidad_sol::numeric(18,2),
                              v_record.id_unidad_medida,
                              v_record.precio,
                              v_record.id_fase_concepto_ingas,
                              v_record.id_centro_costo,
                              v_record.descripcion,
                              v_record.id_fase,
                              v_record.id_concepto_ingas,
                              v_record.id_presolicitud_det,
                              null,
                              v_record.id_unidad_constructiva,
                              'activo',
                              v_record.id_invitacion_det
                            );
                  
                  --inactivamos los detalles del cual han sido clonado
                  IF v_cantidad_adju <> 0 THEN --Si la adjudicacion es distinto a 0 se actualiza la cantidad adjudicada a la cantidad solicidata
                     UPDATE  pro.tinvitacion_det  SET
                          cantidad_sol = v_cantidad_adju
                     WHERE id_invitacion_det = v_record.id_invitacion_det;
                   
                  ELSE
                     UPDATE  pro.tinvitacion_det  SET
                          estado_lanz = 'inactivo'
                     WHERE id_invitacion_det = v_record.id_invitacion_det;
                  END IF;          
            
            END LOOP;
    END IF;
    
    return 'exito';
    
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