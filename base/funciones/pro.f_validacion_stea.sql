CREATE OR REPLACE FUNCTION pro.f_validacion_stea (
  p_id_proyecto integer,
  p_id_moneda integer,
  p_precio numeric,
  p_fecha date,
  p_precio_ant numeric = NULL::numeric
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:        pro.f_validacion_stea
 DESCRIPCION:    valida que la suma de los detalles de las invitaciones activas en el lanzamiento
                 no sobrepasan al stea convirtiendolos a la misma moneda del proyecto para la validacion y añadiendo
                 el nuevo precio
                  p_id_proyecto: id del proyecto del cual queremos sumar todos los detalles activos en el lanzamiento,
                  p_id_moneda: id de la moneda de la invitacion,
                  p_precio : precio total del detalle (cantidad * precio),
                  p_fecha: fecha de la invitacion
                  p_precio_ant: precio total anterior (cantidad * precio) del detalle antes de modificar con el nuevo precio
                 
                 
 AUTOR:         
 FECHA:         
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #15 ETR            31/07/2019          EGS                creacion   
***************************************************************************/

DECLARE

    v_resp                      varchar;
    v_nombre_funcion            text;
    v_rec_proyecto              record;
    v_precio                    numeric;
    v_total_lanzado             numeric;
    v_codigo_moneda_convertido  varchar;
    v_precio_ant                numeric;
BEGIN

    v_nombre_funcion = 'pro.f_validacion_stea';
     ---recuperando datos del proyecto
            SELECT
                pro.id_proyecto,
                pro.estado,
                pro.importe_max,
                pro.id_moneda,
                mo.codigo as desc_moneda
            INTO
                v_rec_proyecto
            FROM pro.tproyecto pro            
                left join param.tmoneda mo on mo.id_moneda = pro.id_moneda
            WHERE pro.id_proyecto = p_id_proyecto;

    --convertimos todos los detalles de las invitaciones a la moneda del proyecto que esten activos en el lanzamiento
    WITH convertir(

            id_moneda_proyecto,
            desc_moneda_proyeto,
            id_moneda_invitacion,
            desc_moneda_invitacion,
            precio,
            cantidad_sol,
            estado_lanzamiento,           
            precio_convertido,
            codigo_moneda_convertido)AS(

               SELECT
                  pro.id_moneda,
                  mon.codigo,
                  inv.id_moneda,
                  moned.codigo,
                  invd.precio,
                  invd.cantidad_sol,
                  invd.estado_lanz,                 
             CASE
                  WHEN pro.id_moneda = inv.id_moneda  THEN
                       invd.precio*invd.cantidad_sol
                  WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                       ((invd.precio*invd.cantidad_sol)*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,'O')):: numeric)):: numeric(18,2)
                  WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                       ((invd.precio*invd.cantidad_sol)/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,'O')):: numeric)):: numeric(18,2)   
                  END as precio_total_convertido,
                  case
                  WHEN pro.id_moneda = inv.id_moneda  THEN
                       mon.codigo
                  WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                       (SELECT mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_base())::varchar
                  WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                        (SELECT  mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_triangulacion())::varchar
                  END as codigo_moneda_convertido  
              FROM pro.tinvitacion_det invd
                  left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                  left join pro.tproyecto pro on pro.id_proyecto = inv.id_proyecto 
                  left join param.tmoneda mon on mon.id_moneda = pro.id_moneda
                  left join param.tmoneda moned on moned.id_moneda = inv.id_moneda
              WHERE invd.estado_lanz = 'activo' AND pro.id_proyecto = p_id_proyecto)
            
             SELECT
                  sum(COALESCE(precio_convertido,0))::numeric(18,2),
                  codigo_moneda_convertido
             INTO
                v_total_lanzado,
                v_codigo_moneda_convertido
             FROM convertir co 
             group by 
             codigo_moneda_convertido ;
           --convertimos el precio total nuevo decl detalle a la moneda del proyecto
           IF v_rec_proyecto.id_moneda = p_id_moneda THEN
                v_precio = COALESCE(p_precio,0);
           ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_base() THEN               
                v_precio = ((COALESCE(p_precio,0))*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),p_fecha::DATE,'O')):: numeric)):: numeric(18,2);
           ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_triangulacion() THEN
                v_precio = ((COALESCE(p_precio,0))/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),p_fecha::DATE,'O')):: numeric)):: numeric(18,2);   
           END IF;
           --convertimos el precio total de detalle anterior a la moneda del proyecto
           IF p_precio_ant is not null THEN
               --convertimos a la moneda del proyecto
               IF v_rec_proyecto.id_moneda = p_id_moneda THEN
                    v_precio_ant = COALESCE(p_precio_ant,0);
               ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_base() THEN               
                    v_precio_ant = ((COALESCE(p_precio_ant,0))*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),p_fecha::DATE,'O')):: numeric)):: numeric(18,2);
               ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_triangulacion() THEN
                    v_precio_ant = ((COALESCE(p_precio_ant,0))/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),p_fecha::DATE,'O')):: numeric)):: numeric(18,2);   
               END IF;
               --restamos el precio anterior al total del proyecto
               v_total_lanzado = v_total_lanzado::numeric(18,2) - v_precio_ant::numeric(18,2);
           END IF;
           --sumamos el nuevo precio al total el proyecto y verificamos que no sobrepase al Stea 
           IF (v_total_lanzado + v_precio)> v_rec_proyecto.importe_max THEN
                RAISE EXCEPTION 'El total lanzado (%)% mas el nuevo Precio (%)% sobrepasan al STEA (%)%',v_total_lanzado::numeric(18,2),v_codigo_moneda_convertido,v_precio::numeric(18,2),v_rec_proyecto.desc_moneda,v_rec_proyecto.importe_max::numeric(18,2),v_rec_proyecto.desc_moneda;
           END IF;    
    
    return v_resp;
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