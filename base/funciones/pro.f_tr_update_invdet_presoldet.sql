CREATE OR REPLACE FUNCTION pro.f_tr_update_invdet_presoldet (
)
RETURNS trigger AS
$body$
/**************************************************************************
 SISTEMA:        Proyectos
 FUNCION:         pro.tr_update_invdet_presoldet
 DESCRIPCION:   funcion que actualiza la invitacion cuando el detalle de la presolicitud se consolida a una solicitud 

 AUTOR:          (EGS)
 FECHA:          07/02/2019
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE          FECHA:        AUTOR:             DESCRIPCION:    
            
        
***************************************************************************/

DECLARE
  v_id_invitacion    integer;
  v_record_solicitud    record;
BEGIN
    IF TG_OP = 'UPDATE' THEN 
          --recuperamos el registros de la solicitud
          SELECT
              sol.id_solicitud
              into
              v_record_solicitud
          FROM adq.tsolicitud sol
          LEFT JOIN adq.tsolicitud_det sold on sold.id_solicitud = sol.id_solicitud
          WHERE sold.id_solicitud_det = NEW.id_solicitud_det;
          
          --verificamos que la presolicitud este asociada a una invitacion 
          SELECT
              inv.id_invitacion
              into
              v_id_invitacion
          FROM pro.tinvitacion inv
          WHERE inv.id_presolicitud = NEW.id_presolicitud;
          --si existe invitacion actualizamos 
          IF v_id_invitacion is not null THEN
              UPDATE pro.tinvitacion SET
              id_solicitud = v_record_solicitud.id_solicitud
              WHERE id_invitacion = v_id_invitacion;
              
              UPDATE pro.tinvitacion_det SET
              id_solicitud_det= NEW.id_solicitud_det
              WHERE id_presolicitud_det = NEW.id_presolicitud_det;
          END IF;
    END IF;
    return null;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;