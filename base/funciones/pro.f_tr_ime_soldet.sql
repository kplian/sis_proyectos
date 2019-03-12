CREATE OR REPLACE FUNCTION pro.f_tr_ime_soldet (
)
RETURNS trigger AS
$body$
/**************************************************************************
 SISTEMA:        Proyectos
 FUNCION:         pro.f_tr_ime_soldet
 DESCRIPCION:   Funcion que no deja la insercion,edicion y eliminacion del detalle de una solicitud generada por una invitacion o consolidada
                por una presolicitud generada por una invitacion
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
   --recuperamos datos de la solicitud 
    SELECT
        sold.id_solicitud
        into
        v_id_solicitud
    FROM adq.tsolicitud_det sold
    WHERE sold.id_solicitud_det = NEW.id_solicitud_det ;
    --buscamos si la solicitud fue generada desde una invitacion si una invitacion 
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
    WHERE inv.id_solicitud = v_id_solicitud;

    -- si el valor de pre_solicitud es :
    -- pre_solicitud = si   :La invitacion genero una presolicitud
    -- pre_solicitud = no   :La invitacion genero una solicitud
    IF TG_OP = 'INSERT' THEN
          IF v_id_solicitud is not null and v_pre_solicitud = 'no' THEN
              RAISE EXCEPTION 'No puede añadir al detalle,esta solicitud fue Generada por la Invitacion % .Elimine la Solicitud y la invitacion volvera a Vobo',v_codigo_inv;       
          END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        IF v_id_solicitud is not null and (v_pre_solicitud = 'no' or v_pre_solicitud='si') THEN
            --raise exception 'v_pre_solicitud % v_id_solicitud %',v_pre_solicitud,v_id_solicitud;
            IF NEW.estado_reg ='inactivo' and v_pre_solicitud = 'no' THEN
                  RAISE EXCEPTION 'No Eliminar el detalle,esta solicitud fue Generada por la Invitacion % .Elimine la Solicitud y la invitacion volvera a Vobo',v_codigo_inv;       
            ELSIF 
                v_pre_solicitud = 'no' and( 
                OLD.id_centro_costo <> NEW.id_centro_costo or
                OLD.id_concepto_ingas<> NEW.id_concepto_ingas or
                OLD.precio_unitario<> NEW.precio_unitario or
                OLD.cantidad<> NEW.cantidad)                  
                THEN
                RAISE EXCEPTION 'No puede editar el detalle solo descripcion,esta solicitud fue Generada por la Invitacion % .Elimine la Solicitud y la invitacion volvera a Vobo',v_codigo_inv;       
            ELSIF 
                v_pre_solicitud = 'si' and (
                OLD.id_centro_costo <> NEW.id_centro_costo or
                OLD.id_concepto_ingas<> NEW.id_concepto_ingas or
                OLD.precio_unitario<> NEW.precio_unitario or
                OLD.cantidad<> NEW.cantidad 
                )                
                THEN
                   --para que el triguer deje editar la cantidad cuando la transsaccion de desconsolidar de la funcion adq.t_presolicitud_ime  cuando se suman
                   --items de mismo cc,concepto de gasto y precio actualiza la cantidad .
                   --la descripcion cambia temporalmente desconsolidarETR como una bandera para que el raise no salte.
                   IF NEW.descripcion <> 'desconsolidarETR' THEN
                        RAISE EXCEPTION 'No puede editar el detalle solo descripcion,este detalle fue consolidada por una presolicitud Generada por la Invitacion % ',v_codigo_inv;       
                   END IF;
            END IF;
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