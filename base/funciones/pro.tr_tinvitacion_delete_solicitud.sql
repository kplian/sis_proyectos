CREATE OR REPLACE FUNCTION pro.tr_tinvitacion_delete_solicitud (
)
RETURNS trigger AS
$body$
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
    va_prioridad     		integer[];
   
     p_id_usuario_ai integer;
     p_usuario_ai varchar;

BEGIN
	v_resp = 'exito';
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
    
    SELECT
    	inv.id_invitacion,
        inv.id_estado_wf,
        es.id_proceso_wf,
        es.id_tipo_estado,
        inv.id_depto
        
    INTO
    	v_registros
    FROM pro.tinvitacion inv 
    left JOIN wf.testado_wf es on es.id_estado_wf = inv.id_estado_wf
    WHERE	inv.id_solicitud = v_record_solicitud.id_solicitud;
	
	IF v_record_solicitud.codigo_tipo_estado = 'anulado' and v_registros.id_invitacion is not null then
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
              
              
              
             
          
          
              -- actualiza estado en la solicitud
            
              
               update pro.tinvitacion pp  set 
                           id_estado_wf =  v_id_estado_actual,
                           estado = va_codigo_estado[1],
                           id_usuario_mod=new.id_usuario_mod,
                           fecha_mod=now(),
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai,
                           id_solicitud = null
                         where id_invitacion  = v_registros.id_invitacion; 

    	
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
