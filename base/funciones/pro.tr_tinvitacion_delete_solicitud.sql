CREATE OR REPLACE FUNCTION pro.tr_tinvitacion_delete_solicitud (
)
RETURNS trigger AS
$body$
/**************************************************************************
 SISTEMA:        Proyectos
 FUNCION:         pro.tr_tinvitacion_delete_solicitud
 DESCRIPCION:   Funcion que retrocede una invitacion a Vobo cuando su solicitud es eliminada(anulada)
 AUTOR:          (EGS)
 FECHA:          07/02/2019
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:    
 AUTOR:            
 FECHA:        
***************************************************************************/


DECLARE
	v_record_solicitud 		record;
    v_record_invitacion		record;
    v_resp					varchar;
    v_codigo_trans			varchar;
    p_administrador			integer;
	p_id_usuario			integer;
    v_tabla					varchar;
    v_registros				record;	
   	v_id_estado_actual  	integer;
    va_codigo_estado 		varchar[];			
    va_id_tipo_estado		integer[];
    va_disparador   		varchar[];
    va_regla       			varchar[]; 
    va_prioridad             integer[];
   
     p_id_usuario_ai        integer;
     p_usuario_ai           varchar;
     v_detalle              record;
     v_id_solicitud_det     integer;

BEGIN
    v_resp = 'exito';
    --recuperamos deatos de la invitacion
    SELECT
        sol.id_solicitud,
        es.id_estado_wf,
        tesd.codigo as codigo_tipo_estado,
        tpro.codigo as codigo_tipo_proceso
    INTO
        v_record_solicitud
    FROM adq.tsolicitud sol
    left JOIN wf.testado_wf es on es.id_estado_wf = sol.id_estado_wf
    left join wf.ttipo_estado tesd on tesd.id_tipo_estado= es.id_tipo_estado
    left join wf.ttipo_proceso tpro on tpro.id_tipo_proceso = tesd.id_tipo_proceso 
    Where sol.id_estado_wf= new.id_estado_wf; 
    --recuperamos datos de la invitacion
    SELECT
        inv.id_invitacion,
        inv.id_estado_wf,
        es.id_proceso_wf,
        es.id_tipo_estado,
        inv.id_depto,
        inv.pre_solicitud,
        inv.codigo
        
    INTO
        v_registros
    FROM pro.tinvitacion inv 
    left JOIN wf.testado_wf es on es.id_estado_wf = inv.id_estado_wf
    WHERE    inv.id_solicitud = v_record_solicitud.id_solicitud;
    
   IF TG_OP = 'UPDATE' THEN 
              
              --retrocede la invitacion a VoBo si se inactiva una solicitud generada por esta 
              IF v_record_solicitud.codigo_tipo_estado = 'anulado' and v_registros.id_invitacion is not null and v_registros.pre_solicitud ='no' then
                       --raise exception 'entra';
                        SELECT 
                             *
                          into
                            va_id_tipo_estado,
                            va_codigo_estado,
                            va_disparador,
                            va_regla,
                            va_prioridad
                        
                        FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'anterior');
                        
                        
                        --raise exception '--  % ,  % ,% ',v_id_proceso_wf,v_id_estado_wf,va_codigo_estado;
                        
                        
                        IF va_codigo_estado[2] is not null THEN
                        
                         raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
                        
                        END IF;
                        
                         IF va_codigo_estado[1] is  null THEN
                        
                         raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;           
                        END IF;
                        
                        
                      p_id_usuario=1;
                      p_id_usuario_ai = 1;
                      p_usuario_ai = null;
                        
                        -- estado siguiente
                     v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                                       NULL, 
                                                                       v_registros.id_estado_wf, 
                                                                       v_registros.id_proceso_wf,
                                                                       p_id_usuario,
                                                                       p_id_usuario_ai, -- id_usuario_ai
                                                                       p_usuario_ai, -- usuario_ai
                                                                       v_registros.id_depto,
                                                                       'Solicitud de Compra Anulado[Retroceso]');
                        
                        
                        
                       
                    
                    
                        -- actualiza estado en la solicitud a vobo y se rompe la relacion con la solicitud ya que esta fue anulada
                         update pro.tinvitacion pp  set 
                                     id_estado_wf =  v_id_estado_actual,
                                     estado = va_codigo_estado[1],
                                     id_usuario_mod=new.id_usuario_mod,
                                     fecha_mod=now(),
                                     id_usuario_ai = p_id_usuario_ai,
                                     usuario_ai = p_usuario_ai,
                                     id_solicitud = null
                                   where id_invitacion  = v_registros.id_invitacion; 
                          -- se rompe la relacion con el detalle de la solicitud
                          update pro.tinvitacion_det  set 
                                 id_solicitud_det = null
                          where id_invitacion  = v_registros.id_invitacion; 

                  
              END IF;
              --si esta es generada por una invitacion no deja editar nada solo observacion
              IF v_registros.id_invitacion is not null and v_registros.pre_solicitud ='no' THEN
                  IF  OLD.justificacion<> NEW.justificacion or
                      OLD.lugar_entrega<> NEW.lugar_entrega or
                      OLD.dias_plazo_entrega<> NEW.dias_plazo_entrega
                      
                  THEN
                      RAISE EXCEPTION 'No puede editar esta solicitud fue generada por la invitacion  % solo observaciones puede ser editada',v_registros.codigo;
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