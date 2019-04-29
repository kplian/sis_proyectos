CREATE OR REPLACE FUNCTION pro.ft_invitacion_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_invitacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tinvitacion_det'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        22-08-2018 22:32:59
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				22-08-2018 22:32:59								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tinvitacion_det'	
 #7 endeEtr         29/01/2019          EGS                     Se habilita que se inserte el detalle de una invitacion en estado sol si este es de la regularizacion de proyectos(relacionar solicitud)
                                                                y si es un item no planificado este se inserta en una fase del proyecto
 #9 EndeEtr         26/03/2019          EGS                     La suma de los detalles relacionadas a un fase concepto de gasto no sobrepasan al mismo
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros            record;
    v_id_requerimiento      integer;
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_invitacion_det     integer;
    v_rec_proyecto          record;
    v_record_invitacion     record;
    v_id_gestion            integer;
    v_registros_cig         record;
    v_pre_solicitud         varchar;
    v_id_partida            integer;
    v_id_cuenta             INTEGER;
    v_id_auxiliar           integer;
    v_partidas_grupo        record;
    v_existe_partida        boolean;
    v_record_partida        record;
    v_asociar_invitacion    varchar;
    v_fase_coningas_planificado varchar;
    v_importe_total         numeric;
    v_total_asignado        numeric;
    v_precio                numeric;
    v_record_fase_concepto_ingas    record;            
BEGIN

    v_nombre_funcion = 'pro.ft_invitacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_IVTD_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        22-08-2018 22:32:59
    ***********************************/

    if(p_transaccion='PRO_IVTD_INS')then
                    
        begin
            ---recuperando datos del proyecto
            SELECT
            pre.id_proyecto,
            pre.estado,
            pre.importe_max,
            pre.id_moneda,
            mo.codigo as desc_moneda
               INTO
            v_rec_proyecto
            FROM pro.tproyecto pre
            left join pro.tinvitacion inv on inv.id_proyecto = pre.id_proyecto
            left join param.tmoneda mo on mo.id_moneda = pre.id_moneda
              WHERE inv.id_invitacion = v_parametros.id_invitacion;
            IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Eliminar el detalle de la invitacion el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
           --recuperando datos de la invitacion 
            SELECT
                inv.id_invitacion,
                inv.id_grupo,
                inv.pre_solicitud,
                inv.fecha,
                gr.nombre as nombre_grupo,
                inv.estado,
                inv.id_estado_wf,
                test.codigo as codigo_estado,
                inv.id_moneda
            INTO
            v_record_invitacion
            FROM pro.tinvitacion inv
            left join adq.tgrupo gr on gr.id_grupo = inv.id_grupo
            left join wf.testado_wf eswf on eswf.id_estado_wf = inv.id_estado_wf
            left join wf.ttipo_estado test on test.id_tipo_estado = eswf.id_tipo_estado
            WHERE  inv.id_invitacion = v_parametros.id_invitacion;
            --validacion para que no ingrese nada en estado de solicitud de compra
            -- #7 y si esta ingresa desde la relacion de solicitud de compra se inserta en estado sol_compra
            IF pxp.f_existe_parametro(p_tabla,'asociar_invitacion') THEN
                v_asociar_invitacion = v_parametros.asociar_invitacion;
            ELSE
                v_asociar_invitacion = 'no';
            END IF;
            IF v_record_invitacion.codigo_estado = 'sol_compra' and v_asociar_invitacion <> 'si' THEN
                RAISE EXCEPTION 'No puede Ingresar nada en el detalle la invitacion se encuentra en estado de %',v_record_invitacion.estado;
            END IF;
            -- #7
            
           --si es una presolicitud verificamos si el concepto de gasto se encuentra en las partidas configuradas en el grupo
           v_pre_solicitud = split_part(pxp.f_get_variable_global('py_gen_presolicitud'), ',', 1);
          
             IF v_record_invitacion.pre_solicitud = v_pre_solicitud    THEN
                     
                        
                    --Obtencion de la gestion
                        select
                        per.id_gestion
                        into
                        v_id_gestion
                        from param.tperiodo per
                        where per.fecha_ini <= v_record_invitacion.fecha and per.fecha_fin >= v_record_invitacion.fecha
                        limit 1 offset 0; 
                 
                   --recupera el nombre del concepto de gasto

                    select
                    cig.desc_ingas
                    into
                    v_registros_cig
                    from param.tconcepto_ingas cig
                    where cig.id_concepto_ingas =  v_parametros.id_concepto_ingas;
                 --recueprar la partida de la parametrizacion

                      SELECT
                            ps_id_partida ,
                            ps_id_cuenta,
                            ps_id_auxiliar
                          into
                            v_id_partida,
                            v_id_cuenta,
                            v_id_auxiliar
                         FROM conta.f_get_config_relacion_contable('CUECOMP',v_id_gestion, v_parametros.id_concepto_ingas, v_parametros.id_centro_costo,  'No se encontro relación contable para el conceto de gasto: '||v_registros_cig.desc_ingas||'. <br> Mensaje: ');
                               
                      IF  v_id_partida  is NULL  THEN

                          raise exception 'No se encontro partida para el concepto de gasto y el centro de costos solicitados';

                      END IF;
                      
                   --recuperamos datos de la partida
                    Select
                        par.codigo,
                        par.nombre_partida
                    into
                    v_record_partida
                    From pre.tpartida par
                    Where par.id_partida = v_id_partida; 
                     
                      
                    --recuperando partidas del grupo y validando que la partida del concepto de gasto se encuentre en el grupo
                       v_existe_partida = false; 
                   For v_partidas_grupo IN(
                        Select
                            grp.id_partida
                        From adq.tgrupo_partida  grp
                        Where grp.id_grupo = v_record_invitacion.id_grupo
                    )LOOP
                        IF v_partidas_grupo.id_partida = v_id_partida THEN
                            v_existe_partida = TRUE ;
                        END IF;
                    
                    END LOOP;
                    
                    IF v_existe_partida = false THEN
                         RAISE EXCEPTION 'EN el Grupo % no existe la partida % - %  del concepto de gasto',v_record_invitacion.nombre_grupo,v_record_partida.codigo,v_record_partida.nombre_partida;
                    END IF;
                    
                END IF;
                          
            --#9 validacion que el total de los invitaciones det sea menor o igual al total del faseconcepto ingas
            --#9 convirtiendo la suma de los precios totales de las invitaciones det relacionadas al fase concepto ingas a la moneda del proyecto  
       WITH convertir(  
            id_fase_concepto_ingas,
            id_moneda_invitacion,
            precio,
            cantidad_sol,
            id_moneda_proyecto,
            precio_total_conversion,
            codigo_moneda_total_conversion)AS(
            
               SELECT
                  invd.id_fase_concepto_ingas,
                  inv.id_moneda,
                  invd.precio,
                  invd.cantidad_sol,
                  pro.id_moneda,
             CASE
                  WHEN pro.id_moneda = inv.id_moneda  THEN
                       invd.precio*invd.cantidad_sol
                  WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                       ((invd.precio*invd.cantidad_sol)*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,'O')):: numeric)):: numeric(18,2)
                  WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                       ((invd.precio*invd.cantidad_sol)/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,'O')):: numeric)):: numeric(18,2)   
                  END as precio_total_conversion,
                  case
                  WHEN pro.id_moneda = inv.id_moneda  THEN
                       mon.codigo
                  WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                       (SELECT mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_base())::varchar
                  WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                        (SELECT  mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_triangulacion())::varchar
                  END as codigo_moneda_total_conversion  
              FROM pro.tinvitacion_det invd
                  left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                  left join pro.tproyecto pro on pro.id_proyecto = inv.id_proyecto 
                  left join param.tmoneda mon on mon.id_moneda = pro.id_moneda )
             SELECT
                  sum(COALESCE(precio_total_conversion,0))
             INTO
                v_total_asignado
             FROM convertir co
             WHERE  co.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas
             group By co.id_fase_concepto_ingas;
           --#9 verificamos que la fecha de la invitacion tenga un tipo de cambio
           IF param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O') is null THEN
                raise exception 'No tiene un tipo de cambio para la fecha de la invitacion %',v_record_invitacion.fecha::DATE;
           END IF;
           --#9 convertimos el precio del detalle de la invitacion a la moneda del proyecto
           IF v_rec_proyecto.id_moneda = v_record_invitacion.id_moneda THEN
                v_precio = COALESCE(v_parametros.precio,0);
           ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_base() THEN               
                v_precio = ((COALESCE(v_parametros.precio,0))*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O')):: numeric)):: numeric(18,2);
           ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_triangulacion() THEN
                v_precio = ((COALESCE(v_parametros.precio,0))/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O')):: numeric)):: numeric(18,2);   
           END IF;        
           --#9
           SELECT
                facoing.precio,
                facoing.precio_est,
                cig.desc_ingas
           INTO
                v_record_fase_concepto_ingas
           FROM pro.tfase_concepto_ingas facoing
           left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
           WHERE facoing.id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
           --#9
           /*
           IF v_precio> v_record_fase_concepto_ingas.precio then
                Raise EXCEPTION 'El precio % %  sobrepasan al precio registrado en la fase % %',v_precio,v_rec_proyecto.desc_moneda,v_record_fase_concepto_ingas.precio,v_rec_proyecto.desc_moneda;
           END IF;
           --#9*/
           /*
           IF (v_precio + COALESCE(v_total_asignado,0))> v_record_fase_concepto_ingas.precio then
                Raise EXCEPTION 'La suma de los detalles (%  %) de las invitaciones relacionadas al concepto de gasto (%) + el nuevo precio % % igual(%  %) sobrepasan al precio registrado en la fase % %',COALESCE(v_total_asignado,0),v_rec_proyecto.desc_moneda,v_record_fase_concepto_ingas.desc_ingas,v_precio,v_rec_proyecto.desc_moneda,(v_precio + v_total_asignado),v_rec_proyecto.desc_moneda,v_record_fase_concepto_ingas.precio,v_rec_proyecto.desc_moneda;
           END IF;*/
            --Sentencia de la insercion
            insert into pro.tinvitacion_det(
            id_fase_concepto_ingas,
            id_invitacion,
            estado_reg,
            observaciones,
            id_usuario_reg,
            usuario_ai,
            fecha_reg,
            id_usuario_ai,
            fecha_mod,
            id_usuario_mod,
            cantidad_sol,
            id_unidad_medida,
            precio,
            id_centro_costo,
            descripcion,
            id_fase,
            id_concepto_ingas
              ) values(
            v_parametros.id_fase_concepto_ingas,
            v_parametros.id_invitacion,
            'activo',
            v_parametros.observaciones,
            p_id_usuario,
            v_parametros._nombre_usuario_ai,
            now(),
            v_parametros._id_usuario_ai,
            null,
            null,
            v_parametros.cantidad_sol,
            v_parametros.id_unidad_medida,
            COALESCE(v_parametros.precio,0),
            v_parametros.id_centro_costo,
            v_parametros.descripcion,
            v_parametros.id_fase,
            v_parametros.id_concepto_ingas                
            
            
            )RETURNING id_invitacion_det into v_id_invitacion_det;
            -- #7 si el item es no planificado se inserta en el proyecto y en una fase del proyecto 
            v_fase_coningas_planificado = split_part(pxp.f_get_variable_global('pro_fase_coningas_planificado'), ',', 2);
            IF v_parametros.invitacion_det__tipo = v_fase_coningas_planificado THEN
              v_resp = pro.f_inserta_fase_concepto_ingas(p_administrador,p_id_usuario,p_tabla,v_id_invitacion_det);    

            END IF;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion det almacenado(a) con exito (id_invitacion_det'||v_id_invitacion_det||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion_det',v_id_invitacion_det::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'PRO_IVTD_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        22-08-2018 22:32:59
    ***********************************/

    elsif(p_transaccion='PRO_IVTD_MOD')then

        begin
            SELECT
            pre.id_proyecto,
            pre.estado,
            pre.importe_max,
            pre.id_moneda,
            mo.codigo as desc_moneda
               INTO
            v_rec_proyecto
            FROM pro.tproyecto pre
            left join pro.tinvitacion inv on inv.id_proyecto = pre.id_proyecto
            left join pro.tinvitacion_det invd on invd.id_invitacion = inv.id_invitacion
            left join param.tmoneda mo on mo.id_moneda = pre.id_moneda

              WHERE invd.id_invitacion_det = v_parametros.id_invitacion_det;
            IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Eliminar el Bien/Servicio la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            
            SELECT
                inv.id_invitacion,
                inv.id_grupo,
                inv.pre_solicitud,
                inv.fecha,
                gr.nombre as nombre_grupo,
                inv.estado,
                inv.id_estado_wf,
                test.codigo as codigo_estado,
                inv.id_moneda
            INTO
            v_record_invitacion
            FROM pro.tinvitacion inv
            left join adq.tgrupo gr on gr.id_grupo = inv.id_grupo
            left join wf.testado_wf eswf on eswf.id_estado_wf = inv.id_estado_wf
            left join wf.ttipo_estado test on test.id_tipo_estado = eswf.id_tipo_estado
            WHERE  inv.id_invitacion = v_parametros.id_invitacion;
            --validacion para que no se modifique nada en estado de solicitud de compra 
            IF v_record_invitacion.codigo_estado = 'sol_compra' THEN
                RAISE EXCEPTION 'No puede Ingresar nada en el detalle la invitacion se encuentra en estado de %',v_record_invitacion.estado;
            END IF;
           
           --validamos que la suma de los todos los items en la invitaciones no sobrepase el importe_max (STEA)
            SELECT
                sum(coalesce(invd.precio,0))
            INTO
                v_importe_total
            FROM pro.tinvitacion_det invd
            left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
            WHERE inv.id_proyecto = v_rec_proyecto.id_proyecto
            AND invd.id_invitacion_det <> v_parametros.id_invitacion_det;

            --#9 validacion que el total de los invitaciones det sea menor o igual al total del faseconcepto ingas
            --#9 convirtiendo la suma de los precios totales de las invitaciones det relacionadas al fase concepto ingas a la moneda del proyecto  
       WITH convertir(  
            id_fase_concepto_ingas,
            id_moneda_invitacion,
            precio,
            cantidad_sol,
            id_moneda_proyecto,
            precio_total_conversion,
            codigo_moneda_total_conversion)AS(
            
               SELECT
                  invd.id_fase_concepto_ingas,
                  inv.id_moneda,
                  invd.precio,
                  invd.cantidad_sol,
                  pro.id_moneda,
             CASE
                  WHEN pro.id_moneda = inv.id_moneda  THEN
                       invd.precio*invd.cantidad_sol
                  WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                       ((invd.precio*invd.cantidad_sol)*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,'O')):: numeric)):: numeric(18,2)
                  WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                       ((invd.precio*invd.cantidad_sol)/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),inv.fecha::DATE,'O')):: numeric)):: numeric(18,2)   
                  END as precio_total_conversion,
                  case
                  WHEN pro.id_moneda = inv.id_moneda  THEN
                       mon.codigo
                  WHEN pro.id_moneda =  param.f_get_moneda_base() THEN
                       (SELECT mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_base())::varchar
                  WHEN pro.id_moneda =  param.f_get_moneda_triangulacion() THEN
                        (SELECT  mone.codigo FROM param.tmoneda mone WHERE mone.id_moneda = param.f_get_moneda_triangulacion())::varchar
                  END as codigo_moneda_total_conversion  
              FROM pro.tinvitacion_det invd
                  left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                  left join pro.tproyecto pro on pro.id_proyecto = inv.id_proyecto 
                  left join param.tmoneda mon on mon.id_moneda = pro.id_moneda
              WHERE invd.id_invitacion_det <> v_parametros.id_invitacion_det )
            
             SELECT
                  sum(COALESCE(precio_total_conversion,0))
             INTO
                v_total_asignado
             FROM convertir co
             WHERE  co.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas
             group By co.id_fase_concepto_ingas;
           --#9 verificamos que la fecha de la invitacion tenga un tipo de cambio
           IF param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O') is null THEN
                raise exception 'No tiene un tipo de cambio para la fecha de la invitacion %',v_record_invitacion.fecha::DATE;
           END IF;
           --#9 convertimos el precio del detalle de la invitacion a la moneda del proyecto
           IF v_rec_proyecto.id_moneda = v_record_invitacion.id_moneda THEN
                v_precio = COALESCE(v_parametros.precio,0);
           ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_base() THEN               
                v_precio = ((COALESCE(v_parametros.precio,0))*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O')):: numeric)):: numeric(18,2);
           ELSIF v_rec_proyecto.id_moneda = param.f_get_moneda_triangulacion() THEN
                v_precio = ((COALESCE(v_parametros.precio,0))/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_invitacion.fecha::DATE,'O')):: numeric)):: numeric(18,2);   
           END IF;        
           --#9
           SELECT
                facoing.precio,
                facoing.precio_est,
                cig.desc_ingas
           INTO
                v_record_fase_concepto_ingas
           FROM pro.tfase_concepto_ingas facoing
           left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
           WHERE facoing.id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
           --#9           
           IF v_precio> v_record_fase_concepto_ingas.precio then
                Raise EXCEPTION 'El precio % %  sobrepasan al precio registrado en la fase % %',v_precio,v_rec_proyecto.desc_moneda,v_record_fase_concepto_ingas.precio,v_rec_proyecto.desc_moneda;
           END IF;
           IF (v_precio + COALESCE(v_total_asignado,0))> v_record_fase_concepto_ingas.precio then
                Raise EXCEPTION 'La suma de los detalles (%  %) de las invitaciones relacionadas al concepto de gasto (%) + el nuevo precio % % igual(%  %) sobrepasan al precio registrado en la fase % %', COALESCE(v_total_asignado,0),v_rec_proyecto.desc_moneda,v_record_fase_concepto_ingas.desc_ingas,v_precio,v_rec_proyecto.desc_moneda,(v_precio + v_total_asignado),v_rec_proyecto.desc_moneda,v_record_fase_concepto_ingas.precio,v_rec_proyecto.desc_moneda;
           END IF;
            --Sentencia de la modificacion
            update pro.tinvitacion_det set
            id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas,
            id_invitacion = v_parametros.id_invitacion,
            observaciones = v_parametros.observaciones,
            fecha_mod = now(),
            id_usuario_mod = p_id_usuario,
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            cantidad_sol =  v_parametros.cantidad_sol,
            id_unidad_medida = v_parametros.id_unidad_medida,
            precio = v_parametros.precio
            --id_centro_costo =  v_parametros.id_centro_costo
            --descripcion = v_parametros.descripcion
           -- id_fase=v_parametros.id_fase
           --id_concepto_ingas=v_parametros.id_concepto_ingas
            where id_invitacion_det=v_parametros.id_invitacion_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion det modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion_det',v_parametros.id_invitacion_det::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'PRO_IVTD_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        eddy.gutierrez    
     #FECHA:        22-08-2018 22:32:59
    ***********************************/

    elsif(p_transaccion='PRO_IVTD_ELI')then

        begin
            SELECT
            pre.estado
               INTO
            v_rec_proyecto
            FROM pro.tproyecto pre
            left join pro.tinvitacion inv on inv.id_proyecto = pre.id_proyecto
            left join pro.tinvitacion_det invd on invd.id_invitacion = inv.id_invitacion
              WHERE invd.id_invitacion_det = v_parametros.id_invitacion_det;
            IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Eliminar el Bien/Servicio la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            
               SELECT
                inv.id_invitacion,
                inv.estado,
                inv.id_estado_wf,
                test.codigo as codigo_estado
            INTO
            v_record_invitacion
            FROM pro.tinvitacion_det invd
            left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
            left join wf.testado_wf eswf on eswf.id_estado_wf = inv.id_estado_wf
            left join wf.ttipo_estado test on test.id_tipo_estado = eswf.id_tipo_estado
            WHERE  invd.id_invitacion_det = v_parametros.id_invitacion_det;

            IF v_record_invitacion.codigo_estado = 'sol_compra' THEN
                RAISE EXCEPTION 'No puede eliminar nada en el detalle la invitacion se encuentra en estado de %',v_record_invitacion.estado;
            END IF;
            
            --Sentencia de la eliminacion
            delete from pro.tinvitacion_det
            where id_invitacion_det=v_parametros.id_invitacion_det;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion det eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion_det',v_parametros.id_invitacion_det::varchar);
              
            --Devuelve la respuesta
            return v_resp;

        end;
         
    else
     
        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

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