CREATE OR REPLACE FUNCTION pro.tr_tinvitacion_delete_presolicitud (
)
RETURNS trigger AS
$body$
/**************************************************************************
 SISTEMA:        Proyectos
 FUNCION:         pro.tr_tinvitacion_delete_presolicitud
 DESCRIPCION:   Funcion que retrocede una invitacion a Vobo cuando su presolicitud es eliminada(inactivo)
               y no deja editar cuando es generado por una invitacion
 AUTOR:          (EGS)
 FECHA:          07/02/2019
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE          FECHA:        AUTOR:             DESCRIPCION:    
            
        
***************************************************************************/

DECLARE
    v_record_presolicitud         record;
    v_record_invitacion        record;
    v_resp                    varchar;
    v_codigo_trans            varchar;
    p_administrador            integer;
    p_id_usuario            integer;
    v_tabla                    varchar;
    v_registros                record;    
       v_id_estado_actual      integer;
    v_codigo_estado         varchar[];            
    v_id_tipo_estado        integer[];
    v_disparador           varchar[];
    v_regla                   varchar[]; 
    v_prioridad             integer[];
   
     p_id_usuario_ai integer;
     p_usuario_ai varchar;

BEGIN
    --raise exception 'entra';
    v_resp = 'exito';
    SELECT
        presol.id_presolicitud,
        presol.estado_reg
    INTO
        v_record_presolicitud
    FROM adq.tpresolicitud presol
    Where presol.id_presolicitud = old.id_presolicitud; 
    --raise exception 'v_record_presolicitud %',v_record_presolicitud;
    
    SELECT
        inv.id_invitacion,
        inv.id_estado_wf,
        es.id_proceso_wf,
        es.id_tipo_estado,
        inv.id_depto,
        inv.estado,
        inv.pre_solicitud,
        inv.codigo
        
    INTO
        v_registros
    FROM pro.tinvitacion inv 
    left JOIN wf.testado_wf es on es.id_estado_wf = inv.id_estado_wf
    WHERE    inv.id_presolicitud = v_record_presolicitud.id_presolicitud;
    --raise exception 'entra %',v_registros;
    IF TG_OP = 'UPDATE' THEN 
    
            --retroce a vobo la invitacion que genero la presolicitud 
            IF v_record_presolicitud.estado_reg = 'inactivo' and v_registros.id_invitacion  is not null and v_registros.pre_solicitud = 'si'  then
                      SELECT 
                           *
                        into
                          v_id_tipo_estado,
                          v_codigo_estado,
                          v_disparador,
                          v_regla,
                          v_prioridad
                      
                      FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'anterior');
                      
                      --raise exception 'v_codigo_estado[1] %',v_codigo_estado[1];     
                      IF v_codigo_estado[2] is not null THEN
                       
                       raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado anterior para el estado: %', v_registros.estado;
                      
                      END IF;
                      
                      --raise exception 'v_codigo_estado[1] %',v_codigo_estado[1];  
                       IF v_codigo_estado[1] = ''  THEN
                               IF v_codigo_estado[1] is NULL then
                              raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado anterior,  para el estado: %', v_registros.estado;           
                              END IF;
                      END IF;
                      
                      
                    p_id_usuario=1;
                    p_id_usuario_ai = null;
                    p_usuario_ai = null;
                    
                    --raise exception 'v_id_tipo_estado[1] %',v_registros.id_depto;  
                      -- estado siguiente
                   v_id_estado_actual =  wf.f_registra_estado_wf(v_id_tipo_estado[1], 
                                                                     NULL, 
                                                                     v_registros.id_estado_wf, 
                                                                     v_registros.id_proceso_wf,
                                                                     p_id_usuario,
                                                                     p_id_usuario_ai, -- id_usuario_ai
                                                                     p_usuario_ai, -- usuario_ai
                                                                     v_registros.id_depto,
                                                                     'Presolicitud anulada[Retroceso]');
                                                                     
                   --raise exception 'v_id_estado_actual %',v_codigo_estado[1];
                                                     
                      -- actualiza estado en la solicitud

                       update pro.tinvitacion pp  set 
                                   id_estado_wf =  v_id_estado_actual,
                                   estado = v_codigo_estado[1],
                                   id_usuario_mod=new.id_usuario_mod,
                                   fecha_mod=now(),
                                   id_usuario_ai = p_id_usuario_ai,
                                   usuario_ai = p_usuario_ai,
                                   id_presolicitud = null
                                 where id_invitacion  = v_registros.id_invitacion;
                        
                        update pro.tinvitacion_det  set 
                               id_presolicitud_det = null
                        where id_invitacion  = v_registros.id_invitacion;   

            END IF;
            IF v_registros.id_invitacion is not null and v_registros.pre_solicitud ='si' THEN
                 
                  IF  OLD.id_grupo<> NEW.id_grupo THEN
                      RAISE EXCEPTION 'No puede editar esta Presolicitud fue generada por la invitacion  % solo observaciones puede ser editada',v_registros.codigo;
                  END IF;
                  RETURN NEW; 
            END IF;
    END IF;
    --raise exception 'entra';

     return null;
                        
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;