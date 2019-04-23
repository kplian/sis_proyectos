CREATE OR REPLACE FUNCTION pro.ft_fase_concepto_ingas_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_concepto_ingas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas'
 AUTOR: 		 (admin)
 FECHA:	        24-05-2018 19:13:39
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE	Fork			FECHA				AUTOR				DESCRIPCION
 #0				 24-05-2018 19:13:39								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase_concepto_ingas'	
 #3					   31/12/2018			EGS						Validacion para qu la suma de los items no sobrepase el importe_max(Stea)
 #5		EndeEtr		   18/01/2019			EGS						Se hace validacion para no  eliminar registros si tiene pagos
 #7		EndeEtr		   29/01/2019			EGS						se valida si el fase_concepto_ingas se encuentra en una invitacion antes de eliminar
 #9     EndeEtr        26/03/2019           EGS                     El codigo en mayusculas y sin espacios
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase_concepto_ingas	integer;
    v_record_fase			record;
    v_rec_proyecto			record;
    v_importe_total			numeric;
    v_pagos                 integer;
	v_record_invitacion_det record;	
    v_record_fase_coningas  record;
    v_codigo                varchar;
    v_total_asignado        numeric;
    v_registro_fase_coningas record;

BEGIN

    v_nombre_funcion = 'pro.ft_fase_concepto_ingas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	if(p_transaccion='PRO_FACOING_INS')then
					
        begin
    
            v_parametros.codigo =  UPPER(v_parametros.codigo);  --#9
            v_parametros.codigo = replace(v_parametros.codigo,' ',''); --#9
            v_parametros.precio = v_parametros.precio_est;
       --verificamos en que estado esta el proyecto
        	SELECT
            pro.estado,
            pro.importe_max,
            pro.id_proyecto,
            mo.codigo as desc_moneda
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
            left join param.tmoneda mo on mo.id_moneda = pro.id_moneda
  			WHERE fase.id_fase = v_parametros.id_fase;
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Ingresar un Servicio/Bien en la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
         --validamos que la suma de los items no sobrepase el importe_max (STEA)
         --#3	31/12/2018	EGS	
           SELECT
                sum(coalesce(facoin.precio,0))
            INTO
                v_importe_total
            FROM pro.tfase_concepto_ingas facoin
            left join pro.tfase fase on fase.id_fase = facoin.id_fase
            WHERE fase.id_proyecto = v_rec_proyecto.id_proyecto;
            
            IF  coalesce(v_importe_total,0) + coalesce(v_parametros.precio,0) > coalesce(v_rec_proyecto.importe_max,0) THEN
            	RAISE EXCEPTION 'La Suma de los Servicios/Bienes (% %)mas el precio nuevo(% %) = % % Superan al Stea(% %) ', coalesce(v_importe_total,0),v_rec_proyecto.desc_moneda, coalesce(v_parametros.precio,0),v_rec_proyecto.desc_moneda,coalesce(v_importe_total,0)+ coalesce(v_parametros.precio,0),v_rec_proyecto.desc_moneda,coalesce(v_rec_proyecto.importe_max,0),v_rec_proyecto.desc_moneda;
            END IF;
          --validamos que el codigo no se repita en el proyecto
          SELECT
            facoing.codigo
            INTO
            v_codigo
            FROM pro.tfase_concepto_ingas facoing
            left join pro.tfase fase on fase.id_fase = facoing.id_fase
  			WHERE facoing.codigo = v_parametros.codigo and fase.id_proyecto = v_rec_proyecto.id_proyecto ;
            IF  v_codigo is not null THEN
            	RAISE EXCEPTION 'El codigo % ya existe en el proyecto',v_codigo;
            END IF;
            --actualizamos las fechas de inicio y maximo de la fase
              select
                    facoing.id_fase,
                    MIN(facoing.fecha_estimada)as fecha_min,
                    MAX(facoing.fecha_fin) as fecha_max
              INTO
                    v_registro_fase_coningas
              from pro.tfase_concepto_ingas facoing
              WHERE facoing.id_fase = v_parametros.id_fase
              GROUP BY facoing.id_fase;

              IF COALESCE(v_registro_fase_coningas.fecha_min,now()::date) >= v_parametros.fecha_estimada::date THEN
                    UPDATE pro.tfase SET
                     fecha_ini = v_parametros.fecha_estimada::date
                    WHERE id_fase = v_parametros.id_fase;
              END IF;
              IF COALESCE(v_registro_fase_coningas.fecha_max,now()::date) <= v_parametros.fecha_fin::date THEN
                    UPDATE pro.tfase SET
                     fecha_fin = v_parametros.fecha_fin::date
                    WHERE id_fase = v_parametros.id_fase;
              END IF;
        	
        	--Sentencia de la insercion
        	insert into pro.tfase_concepto_ingas(
			id_fase,
			id_concepto_ingas,
			id_unidad_medida,
			--tipo_cambio_mt,
			descripcion,
			--tipo_cambio_mb,
			estado,
			estado_reg,
			--cantidad_est,
			--precio_mb,
			precio,
			--precio_mt,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
            fecha_estimada,
            fecha_fin,
            id_funcionario,
            precio_est,
            codigo
          	) values(
			v_parametros.id_fase,
			v_parametros.id_concepto_ingas,
			v_parametros.id_unidad_medida,
			--v_parametros.tipo_cambio_mt,
			v_parametros.descripcion,
			--v_parametros.tipo_cambio_mb,
			'pendiente',
			'activo',
			--v_parametros.cantidad_est,
			--v_parametros.precio_mb,
			v_parametros.precio_est,
			--v_parametros.precio_mt,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.fecha_estimada,
            v_parametros.fecha_fin,
			v_parametros.id_funcionario,
            v_parametros.precio,				
            v_parametros.codigo				
			
			
			)RETURNING id_fase_concepto_ingas into v_id_fase_concepto_ingas;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase Concepto de Gasto almacenado(a) con exito (id_fase_concepto_ingas'||v_id_fase_concepto_ingas||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas',v_id_fase_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	elsif(p_transaccion='PRO_FACOING_MOD')then

		begin
            v_parametros.codigo =  UPPER(v_parametros.codigo); --#9
            v_parametros.codigo = replace(v_parametros.codigo,' ','');--#9
        	--verificamos en que estado esta el proyecto
        	SELECT
            pro.estado,
            pro.importe_max,
            pro.id_proyecto,
            mo.codigo as desc_moneda
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
            left join param.tmoneda mo on mo.id_moneda = pro.id_moneda
  			WHERE fase.id_fase = v_parametros.id_fase;
            
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar los Bienes/Servicion de la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
          --validamos que el codigo no se repita en el proyecto
            SELECT
            facoing.codigo
            INTO
            v_codigo
            FROM pro.tfase_concepto_ingas facoing
            left join pro.tfase fase on fase.id_fase = facoing.id_fase
  			WHERE facoing.codigo = v_parametros.codigo and fase.id_proyecto = v_rec_proyecto.id_proyecto and facoing.id_fase_concepto_ingas <> v_parametros.id_fase_concepto_ingas;
            IF  v_codigo is not null THEN
            	RAISE EXCEPTION 'El codigo % ya existe en el proyecto',v_codigo;
            END IF;
            --validamos que la suma de los items no sobrepase el importe_max (STEA)
         	--#3	31/12/2018	EGS	
            SELECT
                sum(coalesce(facoin.precio,0))
            INTO
                v_importe_total
            FROM pro.tfase_concepto_ingas facoin
            left join pro.tfase fase on fase.id_fase = facoin.id_fase
            WHERE fase.id_proyecto = v_rec_proyecto.id_proyecto
            AND facoin.id_fase_concepto_ingas <> v_parametros.id_fase_concepto_ingas;
            
            IF coalesce(v_importe_total,0) + coalesce(v_parametros.precio,0) > coalesce(v_rec_proyecto.importe_max,0) THEN
            	RAISE EXCEPTION 'La Suma de los Servicios/Bienes (% %)mas el precio modificado(% %) = % % Superan al Stea(% %) ', coalesce(v_importe_total,0),v_rec_proyecto.desc_moneda, coalesce(v_parametros.precio,0),v_rec_proyecto.desc_moneda,coalesce(v_importe_total,0)+ coalesce(v_parametros.precio,0),v_rec_proyecto.desc_moneda,coalesce(v_rec_proyecto.importe_max,0),v_rec_proyecto.desc_moneda;
            END IF;
            IF coalesce(v_importe_total,0) + coalesce(v_parametros.precio_est,0) > coalesce(v_rec_proyecto.importe_max,0) THEN
            	RAISE EXCEPTION 'La Suma de los Servicios/Bienes (% %)mas el precio (Est) modificado(% %) = % % Superan al Stea(% %) ', coalesce(v_importe_total,0),v_rec_proyecto.desc_moneda, coalesce(v_parametros.precio_est,0),v_rec_proyecto.desc_moneda,coalesce(v_importe_total,0)+ coalesce(v_parametros.precio_est,0),v_rec_proyecto.desc_moneda,coalesce(v_rec_proyecto.importe_max,0),v_rec_proyecto.desc_moneda;
            END IF;
            
            ---recuperamos los registros de la fase concepto ingas
            SELECT
                inv.codigo as codigo_inv,
                ind.id_invitacion_det,
                facoin.id_concepto_ingas,
                coin.desc_ingas,
                facoin.id_funcionario,
                fun.desc_funcionario1,
                facoin.fecha_estimada,
                facoin.fecha_fin,
                facoin.descripcion,
                facoin.id_unidad_medida,
                un.codigo as codigo_um,
                facoin.precio,
                facoin.precio_est
            INTO
            v_record_fase_coningas
            FROM pro.tfase_concepto_ingas facoin
            left join pro.tinvitacion_det ind on ind.id_fase_concepto_ingas = facoin.id_fase_concepto_ingas
            left join pro.tinvitacion inv on inv.id_invitacion = ind.id_invitacion
            left join param.tconcepto_ingas coin on coin.id_concepto_ingas =  facoin.id_concepto_ingas
            left join orga.vfuncionario fun on fun.id_funcionario = facoin.id_funcionario
            left join param.tunidad_medida un on un.id_unidad_medida = facoin.id_unidad_medida
            WHERE facoin.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            
            --validamos si tiene una invitacion relacionada
            IF v_record_fase_coningas.id_invitacion_det is not null THEN
                --si tiene una invitacion no puede mofidicar los datos solo el precio real
                IF v_record_fase_coningas.id_concepto_ingas <> v_parametros.id_concepto_ingas THEN
                raise exception 'El concepto gasto: % no puede ser modificado ya que esta en el detalle de la invitacion % .Solo el Precio  puede ser Editado',v_record_fase_coningas.desc_ingas,v_record_fase_coningas.codigo_inv;
                END IF;
                IF v_record_fase_coningas.id_funcionario <> v_parametros.id_funcionario THEN
                raise exception 'El funcionario: % no puede ser modificado ya que esta en el detalle de la invitacion % .Solo el Precio  puede ser Editado',v_record_fase_coningas.desc_funcionario1,v_record_fase_coningas.codigo_inv;
                END IF;
                IF v_record_fase_coningas.fecha_estimada <> v_parametros.fecha_estimada THEN
                raise exception 'La fecha de inicio Estimada: % no puede ser modificado ya que esta en el detalle de la invitacion % .Solo el Precio actualizado puede ser Editado',v_record_fase_coningas.fecha_estimada,v_record_fase_coningas.codigo_inv;
                END IF;
                IF v_record_fase_coningas.fecha_fin <> v_parametros.fecha_fin THEN
                raise exception 'La fecha de fin Estimada % no puede ser modificado ya que esta en el detalle de la invitacion % .Solo el Precio  puede ser Editado',v_record_fase_coningas.fecha_fin,v_record_fase_coningas.codigo_inv;
                END IF;
                IF v_record_fase_coningas.descripcion <> v_parametros.descripcion THEN
                raise exception 'La descripcion: % no puede ser modificado ya que esta en el detalle de la invitacion % .Solo el Precio  puede ser Editado',v_record_fase_coningas.descripcion,v_record_fase_coningas.codigo_inv;
                END IF;
                IF v_record_fase_coningas.id_unidad_medida <> v_parametros.id_unidad_medida THEN
                raise exception 'La unidad de medida % no puede ser modificado ya que esta en el detalle de la invitacion % .Solo el Precio  puede ser Editado',v_record_fase_coningas.codigo_um,v_record_fase_coningas.codigo_inv;
                END IF;
             END IF;
          --validamos que no se modifique el precio con valor menor a los asignados ya en los detalles
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
            
                        
            IF( COALESCE(v_total_asignado,0)  > COALESCE(v_parametros.precio,0)  )THEN
                raise exception 'No puede Modificar con un precio  menor al registrado el Bien/Servicio tiene asignado el monto de % en detalles de invitaciones',v_total_asignado;
            END IF;
            
            --validamos si el concepto tiene pagos si tiene puede solo puede aumentar el precio estimado 
            SELECT
                count(facoinpa.id_fase_concepto_ingas_pago)
            into
            v_pagos
            FROM pro.tfase_concepto_ingas_pago facoinpa
            WHERE facoinpa.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            
            IF(v_pagos <> 0 and v_record_fase_coningas.precio > v_parametros.precio )THEN
                raise exception 'No puede Modificar con un precio  menor al registrado en el Bien/Servicio este tiene % fecha de pago(s).Para modificar elimine las fechas de Pago',v_pagos;
            END IF;

            
			--Sentencia de la modificacion
			update pro.tfase_concepto_ingas set
			id_fase = v_parametros.id_fase,
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_unidad_medida = v_parametros.id_unidad_medida,
			--tipo_cambio_mt = v_parametros.tipo_cambio_mt,
			descripcion = v_parametros.descripcion,
			--tipo_cambio_mb = v_parametros.tipo_cambio_mb,
			--cantidad_est = v_parametros.cantidad_est,
			--precio_mb = v_parametros.precio_mb,
			precio = v_parametros.precio,
			--precio_mt = v_parametros.precio_mt,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
           	fecha_estimada = v_parametros.fecha_estimada,
            fecha_fin = v_parametros.fecha_fin,
            id_funcionario = v_parametros.id_funcionario,
            precio_est = v_parametros.precio_est,
            codigo = v_parametros.codigo

			where id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
            
            --actualizamos las fechas de inicio y maximo de la fase
              select
                    facoing.id_fase,
                    MIN(facoing.fecha_estimada)as fecha_min,
                    MAX(facoing.fecha_fin) as fecha_max
              INTO
                    v_registro_fase_coningas
              from pro.tfase_concepto_ingas facoing
              WHERE facoing.id_fase = v_parametros.id_fase
              GROUP BY facoing.id_fase;

              IF COALESCE(v_registro_fase_coningas.fecha_min,now()::date) >= v_parametros.fecha_estimada::date THEN
                    UPDATE pro.tfase SET
                     fecha_ini = v_parametros.fecha_estimada::date
                    WHERE id_fase = v_parametros.id_fase;
              END IF;
              IF COALESCE(v_registro_fase_coningas.fecha_max,now()::date) <= v_parametros.fecha_fin::date THEN
                    UPDATE pro.tfase SET
                     fecha_fin = v_parametros.fecha_fin::date
                    WHERE id_fase = v_parametros.id_fase;
              END IF;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase Concepto de Gasto modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas',v_parametros.id_fase_concepto_ingas::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FACOING_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		24-05-2018 19:13:39
	***********************************/

	elsif(p_transaccion='PRO_FACOING_ELI')then

		begin
        	--verificamos en que estado esta el proyecto
            SELECT
            facoing.id_fase
            into
            v_record_fase
            FROM pro.tfase_concepto_ingas facoing
            WHERE facoing.id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
            
        	SELECT
            pro.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
            left join pro.tfase fase on fase.id_proyecto = pro.id_proyecto
  			WHERE fase.id_fase = v_record_fase.id_fase;
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Eliminar el Bien/Servicio la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            --#5
            SELECT
                count(facoinpa.id_fase_concepto_ingas_pago)
            into
            v_pagos
            FROM pro.tfase_concepto_ingas_pago facoinpa
            WHERE facoinpa.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            
            IF(v_pagos <> 0 )THEN
                raise exception 'No puede Eliminar el Bien/Servicio tiene % fecha de pago(s)',v_pagos;
            END IF;
            --#5
            -- #7	verificamos que el item no se encuentre en el detalle de una invitacion
            SELECT
                  invd.id_fase_concepto_ingas,
                  invd.id_invitacion,
                  inv.codigo
            INTO
                v_record_invitacion_det
            FROM pro.tinvitacion_det invd
            left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
            WHERE invd.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas; 
        	
            IF v_record_invitacion_det.id_fase_concepto_ingas is not null THEN
                RAISE EXCEPTION 'El Servicio/Bien no púede ser eliminado se encuentra en el detalle de la invitacion %',v_record_invitacion_det.codigo ;
            END IF;
            
             --recuperamos la fase del item a eliminar
              SELECT
                   facoing.id_fase
              INTO
                   v_record_fase_coningas
              FROM pro.tfase_concepto_ingas facoing
              WHERE facoing.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas ;
            
             --#7	
			--Sentencia de la eliminacion
			delete from pro.tfase_concepto_ingas
            where id_fase_concepto_ingas=v_parametros.id_fase_concepto_ingas;
            
             --actualizamos las fechas de la fase
              select
                    facoing.id_fase,
                    MIN(facoing.fecha_estimada)as fecha_min,
                    MAX(facoing.fecha_fin) as fecha_max
              INTO
                    v_registro_fase_coningas
              from pro.tfase_concepto_ingas facoing
              WHERE facoing.id_fase = v_record_fase_coningas.id_fase
              GROUP BY facoing.id_fase;

              UPDATE pro.tfase SET
                     fecha_ini = v_registro_fase_coningas.fecha_min::date
              WHERE id_fase = v_record_fase_coningas.id_fase;
              UPDATE pro.tfase SET
                     fecha_fin = v_registro_fase_coningas.fecha_max::date
              WHERE id_fase = v_record_fase_coningas.id_fase;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase Concepto de Gasto eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase_concepto_ingas',v_parametros.id_fase_concepto_ingas::varchar);
              
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