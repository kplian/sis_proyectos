CREATE OR REPLACE FUNCTION pro.f_tr_ime_predet (
)
RETURNS trigger AS
$body$
/**************************************************************************
 SISTEMA:        Proyectos
 FUNCION:         pro.f_tr_ime_predet
 DESCRIPCION:   Funcion que no deja la insersion, edicion y eliminacion del detalle de una presolicitud generada por una invitacion
 AUTOR:          (EGS)
 FECHA:          07/02/2019
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE          FECHA:        AUTOR:             DESCRIPCION:    
            
        
***************************************************************************/

DECLARE
  v_id_presolicitud     integer;
  v_id_presolicitud_det integer;
  v_id_solicitud        integer;
  v_item                record;
  v_codigo_inv          varchar;
  v_pre_solicitud       varchar;
BEGIN
    -- si el valor de pre_solicitud es :
    -- pre_solicitud = si   :La invitacion genero una presolicitud
    -- pre_solicitud = no   :La invitacion genero una solicitud
    IF TG_OP = 'INSERT' THEN
          SELECT
                  inv.id_solicitud,
                  inv.id_presolicitud,
                  inv.codigo,
                  inv.pre_solicitud
              into
                  v_id_solicitud,
                  v_id_presolicitud,
                  v_codigo_inv ,
                  v_pre_solicitud
              FROM  pro.tinvitacion inv
              WHERE inv.id_presolicitud = NEW.id_presolicitud;
         IF v_id_presolicitud is not null and v_pre_solicitud = 'si' THEN
            RAISE EXCEPTION 'No puede Añadir al detalle,esta presolicitud fue Generada por la Invitacion % .Elimine la presolicitud y la invitacion volvera a Vobo',v_codigo_inv;
         END IF;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
              --buscamos si la solicitud fue generada desde una invitacion  
              SELECT
                  inv.id_solicitud,
                  inv.id_presolicitud,
                  inv.codigo,
                  inv.pre_solicitud
              into
                  v_id_solicitud,
                  v_id_presolicitud,
                  v_codigo_inv ,
                  v_pre_solicitud
              FROM  pro.tinvitacion inv
              WHERE inv.id_presolicitud = OLD.id_presolicitud;
           --si  el id de presolicitud esta en la invitacion esta se genero de ella 
           IF v_id_presolicitud is not null and v_pre_solicitud = 'si' THEN
              --validamos que no se haga cambios solo en descripcion 
              IF OLD.id_centro_costo <>NEW.id_centro_costo 
              or OLD.id_concepto_ingas<>NEW.id_concepto_ingas 
              or OLD.precio<>NEW.precio 
              or OLD.cantidad<>NEW.cantidad  THEN 
                        RAISE EXCEPTION 'No puede Modificar el detalle,esta presolicitud fue Generada por la Invitacion % .Elimine la presolicitud y la invitacion volvera a Vobo',v_codigo_inv;
              END IF;
            END IF;
           RETURN NEW;
 
    ELSIF TG_OP = 'DELETE' THEN
                --buscamos si la solicitud fue generada desde una invitacion  
              SELECT
                  inv.id_solicitud,
                  inv.id_presolicitud,
                  inv.codigo,
                  inv.pre_solicitud
              into
                  v_id_solicitud,
                  v_id_presolicitud,
                  v_codigo_inv ,
                  v_pre_solicitud
              FROM  pro.tinvitacion inv
              WHERE inv.id_presolicitud = OLD.id_presolicitud;
               --si  el id de presolicitud esta en la invitacion esta se genero de ella 
            IF v_id_presolicitud is not null and v_pre_solicitud = 'si' THEN
                      RAISE EXCEPTION 'No puede Eliminar el detalle,esta presolicitud fue Generada por la Invitacion % .Elimine la presolicitud y la invitacion volvera a Vobo',v_codigo_inv;
            END IF;
          RETURN OLD; 
    END IF;   
    return null;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;