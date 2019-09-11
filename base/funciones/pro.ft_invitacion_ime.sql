CREATE OR REPLACE FUNCTION pro.ft_invitacion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_invitacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tinvitacion'
 AUTOR: 		 (eddy.gutierrez)
 FECHA:	        22-08-2018 22:32:20
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				22-08-2018 22:32:20								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tinvitacion'	
 #5	EndeEtr		17/01/2019          	EGS					    Se mejoro la validacion  para que solo presolicitudes compartan el codigo de invitacion	
 #7	EndeEtr		20/02/2019          	EGS					    Se mejoro la insercion y modificacion del codigo de inv
 #15	Etr	    31/07/2019	            EGS		                se agrego campo id_invitacion_fk
 #20 EndeEtr    30/08/2019              EGS                     verifica en que estado esta la solicitud asociada a la invitacion para poder realizr los 2,3,4,etc lanzamientos
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_invitacion	 		integer;

    v_codigo_tipo_proceso  varchar;
    v_id_proceso_macro			 integer;
    v_id_gestion				 integer;
    v_num_tramite				 varchar;
    v_id_proceso_wf				integer;
    v_id_estado_wf				integer;
    v_codigo_estado				varchar;


    v_codigo_tipo_cobro_simple   integer;
    v_id_tipo_estado				integer;
    v_codigo_estado_siguiente		varchar;
    v_id_depto						integer;
    v_obs							varchar;
    v_acceso_directo				varchar;
     v_clase						varchar;
     v_parametros_ad				varchar;
     v_tipo_noti					varchar;
     v_titulo 						varchar;

     v_id_estado_actual				integer;
     v_registros_proc				record;
     v_codigo_tipo_pro				varchar;
     v_codigo_estados				varchar;


     v_id_cuenta_bancaria			integer;
     v_id_depto_lb					integer;

     v_id_funcionario_ini			integer;
     v_id_funcionario				integer;
     v_id_usuario_reg				integer;
     v_id_estado_wf_ant				integer;
  	 v_rec 							record;
     v_id_usuario					integer;
     v_id_invitacion_det			integer;
     v_record_detalle				record;
     v_record_invitacion			record;
     v_total_precio_invitacion		numeric;
     v_record_categoria_compra		record;
     v_num_inv   					varchar;
     v_id_periodo 					integer;
     v_rec_proyecto					record;
     v_pre_solicitud				varchar;
     v_count_inv_sc                 integer;
     v_id_solicitud                 integer;--#20
     v_estado                       varchar;--#20
     v_id_proceso_compra			integer;--#20
     v_nro_tramite                  varchar;--#20
     v_record                       record;--#20
     v_record_det                   record;--#20
     v_cantidad_adjudicada          numeric;--#20
     v_cantidad_solicitud           numeric;--#20
BEGIN

    v_nombre_funcion = 'pro.ft_invitacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_IVT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		eddy.gutierrez
 	#FECHA:		22-08-2018 22:32:20
	***********************************/

	if(p_transaccion='PRO_IVT_INS')then

        begin
            --el codigo en mayusculas y sin espacios #7
            v_parametros.codigo=trim(upper(v_parametros.codigo));
            v_parametros.codigo=REPLACE(v_parametros.codigo,' ', '');
        	--verificamos en que estado esta el proyecto
        	SELECT
            pro.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
  			WHERE pro.id_proyecto = v_parametros.id_proyecto;

            IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Ingresa una Invitacion el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;

        	---validamos que no se repita el codigo a menos que sea una presolicitud #5
            v_pre_solicitud = split_part(pxp.f_get_variable_global('py_gen_presolicitud'), ',', 1);
        	 select
               inv.codigo
             into
             v_record_invitacion
             from pro.tinvitacion inv
             where trim(upper(inv.codigo)) = trim(upper(v_parametros.codigo)) and inv.estado_reg = 'activo';
            --Verificamos si el primer lanzamiento no se repita el codigo
            IF v_record_invitacion.codigo is not null and v_parametros.pre_solicitud <> v_pre_solicitud and v_parametros.id_invitacion_fk is NULL THEN
               raise exception 'ya existe el código de la Invitacion %',v_parametros.codigo;
            END IF;

             v_codigo_tipo_proceso = split_part(pxp.f_get_variable_global('tipo_proceso_macro_proyectos'), ',', 1);
             --obtener id del proceso macro


        	 select
             pm.id_proceso_macro
             into
             v_id_proceso_macro
             from wf.tproceso_macro pm
             left join wf.ttipo_proceso tp on tp.id_proceso_macro  = pm.id_proceso_macro
             where tp.codigo = v_codigo_tipo_proceso;

             If v_id_proceso_macro is NULL THEN
               raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_tipo_proceso;
             END IF;

              --Obtencion de la gestion
                select
                per.id_gestion
                into
                v_id_gestion
                from param.tperiodo per
                where per.fecha_ini <= now()::date and per.fecha_fin >= now()::date
                limit 1 offset 0;

             --recuperando funcionario
             SELECT
              fun.id_funcionario
              INTO
              v_id_funcionario
              FROM orga.tfuncionario fun
              LEFT JOIN segu.tusuario usu on usu.id_persona = fun.id_persona
              WHERE usu.id_usuario = p_id_usuario ;

           IF (v_parametros.id_funcionario != 0) THEN
            	v_id_funcionario = v_parametros.id_funcionario;

            END IF;
            IF	pxp.f_existe_parametro(p_tabla,'fecha_real') = FALSE	THEN
            	--v_parametros.fecha_real = now()::date;
            END IF;

             select
             	id_periodo
             into
             	v_id_periodo
             from param.tperiodo per
             where per.fecha_ini <= v_parametros.fecha and per.fecha_fin >=  v_parametros.fecha
             limit 1 offset 0;


             -- inciar el tramite en el sistema de WF


            SELECT
                   ps_num_tramite ,
                   ps_id_proceso_wf ,
                   ps_id_estado_wf ,
                   ps_codigo_estado
                into
                   v_num_tramite,
                   v_id_proceso_wf,
                   v_id_estado_wf,
                   v_codigo_estado

            FROM wf.f_inicia_tramite(
                   p_id_usuario,
                   v_parametros._id_usuario_ai,
                   v_parametros._nombre_usuario_ai,
                   v_id_gestion,
                   v_codigo_tipo_proceso,
                   v_id_funcionario,
                   v_parametros.id_depto,
                   'Solicitud de invitacion',
                   '' );

        	--Sentencia de la insercion
        	insert into pro.tinvitacion(
			id_proyecto,
			codigo,
			fecha,
			descripcion,
			--fecha_real,
			estado_reg,
			estado,
			id_estado_wf,
			nro_tramite,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod,
            id_funcionario,
            id_depto,
            id_moneda,
            tipo,
            lugar_entrega,
            dias_plazo_entrega,
            id_categoria_compra,
            pre_solicitud,
            id_grupo,
            id_invitacion_fk --#15
          	) values(
			v_parametros.id_proyecto,
			UPPER(v_parametros.codigo),
			v_parametros.fecha,
			v_parametros.descripcion,
		--	v_parametros.fecha_real,
			'activo',
			v_codigo_estado,
			v_id_estado_wf,
			v_num_tramite,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.id_funcionario,
			v_parametros.id_depto,
			v_parametros.id_moneda,
			v_parametros.tipo,
			v_parametros.lugar_entrega,
            v_parametros.dias_plazo_entrega,
			v_parametros.id_categoria_compra,
            v_parametros.pre_solicitud,
            v_parametros.id_grupo,
            v_parametros.id_invitacion_fk	--#15


			)RETURNING id_invitacion into v_id_invitacion;



            --Actualiza las invitaciones con el mismo codigo para generar una presolicitud
            --con los mismos datos
            IF v_parametros.pre_solicitud = v_pre_solicitud  THEN
                  update pro.tinvitacion set
                  codigo = v_parametros.codigo,
                  --fecha = v_parametros.fecha,
                  descripcion = v_parametros.descripcion,
                  --fecha_real = v_parametros.fecha_real,
                  id_usuario_mod = p_id_usuario,
                  fecha_mod = now(),
                  id_usuario_ai = v_parametros._id_usuario_ai,
                  usuario_ai = v_parametros._nombre_usuario_ai,
                  id_funcionario=v_parametros.id_funcionario,
                  id_depto=v_parametros.id_depto,
                  id_moneda=v_parametros.id_moneda,
                  tipo=v_parametros.tipo,
                  lugar_entrega=v_parametros.lugar_entrega,
                  dias_plazo_entrega=v_parametros.dias_plazo_entrega,
                  id_categoria_compra = v_parametros.id_categoria_compra,
                  pre_solicitud = v_parametros.pre_solicitud,
                  id_grupo = v_parametros.id_grupo

                  where codigo=v_parametros.codigo and id_invitacion <> v_id_invitacion ;

            END IF;

            --Cuando la invitacion es un 2,3,etc lanzamiento se clona todos los detalles del primer lanzamiento a la nueva invitacion
            --como estan se inhabilitan los detalles del primer lanzamiento
            IF v_parametros.id_invitacion_fk is not null THEN   --#15
                v_resp = pro.f_invitacion_lanzamiento(p_administrador,p_id_usuario,p_tabla,v_id_invitacion);
            END IF;




			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion almacenado(a) con exito (id_invitacion'||v_id_invitacion||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion',v_id_invitacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_IVT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		eddy.gutierrez
 	#FECHA:		22-08-2018 22:32:20
	***********************************/

	elsif(p_transaccion='PRO_IVT_MOD')then

		begin
            --el codigo en mayusculas y sin espacios  #7
            v_parametros.codigo=trim(upper(v_parametros.codigo));
            v_parametros.codigo=REPLACE(v_parametros.codigo,' ', '');
        	--verificamos en que estado esta el proyecto
        	SELECT
            pre.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pre
            left join pro.tinvitacion inv on inv.id_proyecto = pre.id_proyecto
  			WHERE inv.id_invitacion = v_parametros.id_invitacion;

            IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar una Invitacion el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;

            ---validamos que no se repita el codigo a menos que sea un presolicitud
            v_pre_solicitud = split_part(pxp.f_get_variable_global('py_gen_presolicitud'), ',', 1);
         	select
               inv.codigo
            into
            v_record_invitacion
            from pro.tinvitacion inv
            where trim(upper(inv.codigo)) = trim(upper(v_parametros.codigo)) and inv.estado_reg = 'activo'and inv.id_invitacion <> v_parametros.id_invitacion;

            IF v_record_invitacion.codigo is not null and v_parametros.pre_solicitud <> v_pre_solicitud and v_parametros.id_invitacion_fk is NULL  THEN
               raise exception 'ya existe el código de la Invitacion %',v_parametros.codigo;
            END IF;

            --si la invitacion es una presolicitud y se comparte el codigo entre invitaciones se modificara todas las invitaciones que comparten el codigo
            --a menos que una invitacion con el mismo codigo ya genero una presolicitud estado(sol_compra)

            IF v_parametros.pre_solicitud = v_pre_solicitud  THEN
                 SELECT
                     count(inv.id_invitacion)
                 INTO
                    v_count_inv_sc
                FROM pro.tinvitacion inv
                WHERE inv.codigo = v_parametros.codigo and inv.estado = 'sol_compra' ;
                IF v_count_inv_sc <> 0 THEN
                    RAISE EXCEPTION 'No puede modificar el Maestro de la INV. una Invitacion con el mismo Codigo ya genero una Presolicitud de Compra.Elimine la presolicitud con el mismo codigo en adquisiciones y la invitacion volvera a Vobo';
                END IF;
                  update pro.tinvitacion set
                  codigo = v_parametros.codigo,
                  --fecha = v_parametros.fecha,
                  descripcion = v_parametros.descripcion,
                  --fecha_real = v_parametros.fecha_real,
                  id_usuario_mod = p_id_usuario,
                  fecha_mod = now(),
                  id_usuario_ai = v_parametros._id_usuario_ai,
                  usuario_ai = v_parametros._nombre_usuario_ai,
                  id_funcionario=v_parametros.id_funcionario,
                  id_depto=v_parametros.id_depto,
                  id_moneda=v_parametros.id_moneda,
                  tipo=v_parametros.tipo,
                  lugar_entrega=v_parametros.lugar_entrega,
                  dias_plazo_entrega=v_parametros.dias_plazo_entrega,
                  id_categoria_compra = v_parametros.id_categoria_compra,
                  pre_solicitud = v_parametros.pre_solicitud,
                  id_grupo = v_parametros.id_grupo
                  where codigo=v_parametros.codigo and id_invitacion <>v_parametros.id_invitacion ;

            END IF;

			--Sentencia de la modificacion
			update pro.tinvitacion set
            codigo = v_parametros.codigo,
			fecha = v_parametros.fecha,
			descripcion = v_parametros.descripcion,
			--fecha_real = v_parametros.fecha_real,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_funcionario=v_parametros.id_funcionario,
            id_depto=v_parametros.id_depto,
            id_moneda=v_parametros.id_moneda,
            tipo=v_parametros.tipo,
            lugar_entrega=v_parametros.lugar_entrega,
            dias_plazo_entrega=v_parametros.dias_plazo_entrega,
            id_categoria_compra = v_parametros.id_categoria_compra,
            pre_solicitud = v_parametros.pre_solicitud,
            id_grupo = v_parametros.id_grupo,
            id_invitacion_fk = v_parametros.id_invitacion_fk --#15

			where id_invitacion=v_parametros.id_invitacion;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion',v_parametros.id_invitacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_IVT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		eddy.gutierrez
 	#FECHA:		22-08-2018 22:32:20
	***********************************/

	elsif(p_transaccion='PRO_IVT_ELI')then

		begin
            v_pre_solicitud = split_part(pxp.f_get_variable_global('py_gen_presolicitud'), ',', 1);

           --verificamos en que estado esta el proyecto
        	SELECT
            pre.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pre
            left join pro.tinvitacion inv on inv.id_proyecto = pre.id_proyecto
  			WHERE inv.id_invitacion = v_parametros.id_invitacion;

            IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Eliminar una Invitacion el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
            /*
            SELECT
                inv.pre_solicitud,
                inv.codigo
               INTO
                    v_record_invitacion
            FROM pro.tinvitacion inv
            WHERE inv.id_invitacion = v_parametros.id_invitacion ;


            IF v_record_invitacion.pre_solicitud = v_pre_solicitud  THEN
                 SELECT
                     count(inv.id_invitacion)
                 INTO
                    v_count_inv_sc
                FROM pro.tinvitacion inv
                WHERE inv.codigo = v_record_invitacion.codigo and inv.estado = 'sol_compra' ;
               IF v_count_inv_sc <> 0 THEN
                      RAISE EXCEPTION 'No puede Eliminar el Maestro de la INV. una Invitacion con el mismo Codigo ya genero una Presolicitud de Compra';
               END IF;
             END IF;   */

			--Sentencia de la eliminacion
			delete from pro.tinvitacion
            where id_invitacion=v_parametros.id_invitacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','invitacion eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_invitacion',v_parametros.id_invitacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
	#TRANSACCION:  	'PRO_SIGEIVT_INS'
	#DESCRIPCION:  	Controla el cambio al siguiente estado
	#AUTOR:   		EGS
	#FECHA:
	***********************************/
  	elseif(p_transaccion='PRO_SIGEIVT_INS')then

        begin

         --raise exception 'invi';
          v_pre_solicitud = split_part(pxp.f_get_variable_global('py_gen_presolicitud'), ',', 1);
        ---recuperamos datos de la invitacion
        	select
            	inv.id_categoria_compra,
                inv.lugar_entrega,
                inv.dias_plazo_entrega,
                inv.fecha,
                inv.codigo,
                inv.pre_solicitud
            into
            	v_record_invitacion
            from pro.tinvitacion inv
            where inv.id_invitacion = v_parametros.id_invitacion;

            IF v_record_invitacion.lugar_entrega is null THEN
            	raise EXCEPTION 'No tiene un lugar entrega en la invitacion';
            END IF;
            IF v_record_invitacion.dias_plazo_entrega is null THEN
            	raise EXCEPTION 'No tiene dias de plazo entrega en la invitacion';
            END IF;

            IF  v_record_invitacion.fecha is null THEN
            	raise EXCEPTION 'No ingreso una fecha en la Invitacion %',v_record_invitacion.codigo;
            END IF;

         ---verificamos que existan detalles en la invitacion
           SELECT
            	count(invd.id_invitacion_det)
            INTO
            	v_id_invitacion_det
            FROM pro.tinvitacion_det invd
            WHERE invd.id_invitacion = v_parametros.id_invitacion;

            IF v_id_invitacion_det = 0 THEN
            	raise EXCEPTION 'No tiene detalle en la invitacion';
            END IF;



        --recuperamos el monto total de la invitacion
           SELECT
                sum( COALESCE(invd.cantidad_sol::NUMERIC,0)* COALESCE(invd.precio::NUMERIC,0))

            INTO
            	v_total_precio_invitacion
            FROM pro.tinvitacion_det invd
            WHERE invd.id_invitacion = v_parametros.id_invitacion;




            ---validamos que los detalles tengan los requisitos nesesarios para una solicitud de compra
         FOR v_record_detalle in (
    			SELECT
						ivtd.id_invitacion_det,
						ivtd.id_fase_concepto_ingas,
						ivtd.id_invitacion,
						ivtd.estado_reg,
						ivtd.observaciones,
						ivtd.id_usuario_reg,
						ivtd.usuario_ai,
						ivtd.fecha_reg,
						ivtd.id_usuario_ai,
						ivtd.fecha_mod,
						ivtd.id_usuario_mod,
                        ivtd.cantidad_sol,
                        ivtd.id_unidad_medida,
                        ivtd.precio,
                        fas.codigo || ' – ' || fas.nombre as desc_fase,
                        cigg.tipo || ' – ' || cigg.desc_ingas as desc_ingas,
                        facoing.cantidad_est as cantidad_est,
                        facoing.precio as precio_est,
                        ivtd.id_centro_costo,
                        ivtd.descripcion,
                        cec.codigo_cc::varchar,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from pro.tinvitacion_det ivtd
						inner join segu.tusuario usu1 on usu1.id_usuario = ivtd.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = ivtd.id_usuario_mod
                        left join pro.tfase_concepto_ingas facoing on facoing.id_fase_concepto_ingas=ivtd.id_fase_concepto_ingas
                        left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
                        left join param.tconcepto_ingas cigg on cigg.id_concepto_ingas = ivtd.id_concepto_ingas
                        left join param.tunidad_medida um on um.id_unidad_medida = ivtd.id_unidad_medida
                        left join pro.tfase fas on fas.id_fase = ivtd.id_fase
                        left join param.vcentro_costo cec on cec.id_centro_costo = ivtd.id_centro_costo
                WHERE ivtd.id_invitacion = v_parametros.id_invitacion )LOOP

               IF v_record_detalle.id_centro_costo is NULL  THEN
               	Raise Exception 'El detalle % de la fase % no tiene un centro de costo registrado',v_record_detalle.desc_ingas,v_record_detalle.desc_fase;
               END IF;
               IF v_record_detalle.precio is NULL  THEN
               	Raise Exception 'El detalle % de la fase % no tiene precio registrado',v_record_detalle.desc_ingas,v_record_detalle.desc_fase;
               END IF;
               IF v_record_detalle.cantidad_sol is NULL THEN
               	Raise Exception 'El detalle % de la fase % no tiene una cantidad registrado',v_record_detalle.desc_ingas,v_record_detalle.desc_fase;
               END IF;

             END LOOP;


            --recuperamos datos de categoria compra
            Select
            	cat.id_categoria_compra,
            	cat.min,
                cat.max,
                cat.nombre
            INTO
             v_record_categoria_compra
            From adq.tcategoria_compra cat
            Where	cat.id_categoria_compra = v_record_invitacion.id_categoria_compra;
            --validamos si el total de los detalles pertenecen a la categoria ya insertada en la invitacion
            --solo cuando generamos una solicitud de compra y no una presolicitud
            IF v_record_invitacion.pre_solicitud <> v_pre_solicitud THEN
              if v_record_categoria_compra.min > v_total_precio_invitacion	or v_total_precio_invitacion > v_record_categoria_compra.max  then
                  Raise exception 'El total del detalle % no pertenence a la Categoria de Compra % asignada a la invitacion',v_total_precio_invitacion,v_record_categoria_compra.nombre;
              end if;
            END IF;
	        /*   PARAMETROS

	        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
	        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
	        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
	        $this->setParametro('id_depto_wf','id_depto_wf','int4');
	        $this->setParametro('obs','obs','text');
	        $this->setParametro('json_procesos','json_procesos','text');
	        */
			--raise exception 'entra';


	        --Obtenemos datos basicos


			select
            ew.id_proceso_wf,
			c.id_estado_wf,
			c.estado
			into
			v_id_proceso_wf,
            v_id_estado_wf,
			v_codigo_estado
			from pro.tinvitacion c
            inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf
			where c.id_invitacion = v_parametros.id_invitacion;

            --raise exception 'v_parametros.id_invitacion %',v_parametros.id_invitacion;
			--raise exception 'v_id_estado_wf %',v_id_estado_wf;
            --raise exception 'v_codigo_estado %',v_codigo_estado;

	        --Recupera datos del estado
			select
			ew.id_tipo_estado,
			te.codigo
			into
			v_id_tipo_estado,
			v_codigo_estados
			from wf.testado_wf ew
			inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
			where ew.id_estado_wf = v_parametros.id_estado_wf_act;

			-- obtener datos tipo estado
			select
			te.codigo
			into
			v_codigo_estado_siguiente
			from wf.ttipo_estado te
			where te.id_tipo_estado = v_parametros.id_tipo_estado;


			if pxp.f_existe_parametro(p_tabla,'id_depto_wf') then
				v_id_depto = v_parametros.id_depto_wf;
			end if;

			if pxp.f_existe_parametro(p_tabla,'obs') then
				v_obs=v_parametros.obs;
			else
				v_obs='---';

			end if;

			--Acciones por estado siguiente que podrian realizarse
			if v_codigo_estado_siguiente in ('') then

			end if;

			---------------------------------------
			-- REGISTRA EL SIGUIENTE ESTADO DEL WF
			---------------------------------------
			--Configurar acceso directo para la alarma
			v_acceso_directo = '';
			v_clase = '';
			v_parametros_ad = '';
			v_tipo_noti = 'notificacion';
			v_titulo  = 'Visto Bueno';

			if v_codigo_estado_siguiente not in('borrador','finalizado','anulado') then

				v_acceso_directo = '../../../sis_proyectos/vista/invitacion/Invitacion.php';
				v_clase = 'Invitacion';
				v_parametros_ad = '{filtro_directo:{campo:"pro.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
				v_tipo_noti = 'notificacion';
				v_titulo  = 'Visto Bueno';

			end if;

			v_id_estado_actual = wf.f_registra_estado_wf(
            									   v_parametros.id_tipo_estado,
			                                       v_parametros.id_funcionario_wf,
			                                       v_parametros.id_estado_wf_act,
			                                       v_id_proceso_wf,
			                                       p_id_usuario,
			                                       v_parametros._id_usuario_ai,
			                                       v_parametros._nombre_usuario_ai,
			                                       v_id_depto,                       --depto del estado anterior
			                                       v_obs,
			                                       v_acceso_directo,
			                                       v_clase,
			                                       v_parametros_ad,
			                                       v_tipo_noti,
			                                       v_titulo);

			--------------------------------------
			-- Registra los procesos disparados
			--------------------------------------
            --raise exception ' %',v_parametros.json_procesos;
			for v_registros_proc in ( select * from json_populate_recordset(null::wf.proceso_disparado_wf, v_parametros.json_procesos::json)) loop



				--Obtencion del codigo tipo proceso
				select
				tp.codigo
				into
				v_codigo_tipo_pro
				from wf.ttipo_proceso tp
				where tp.id_tipo_proceso =  v_registros_proc.id_tipo_proceso_pro;

				--Disparar creacion de procesos seleccionados
				select
				ps_id_proceso_wf,
				ps_id_estado_wf,
				ps_codigo_estado
				into
				v_id_proceso_wf,
				v_id_estado_wf,
				v_codigo_estado
				from wf.f_registra_proceso_disparado_wf(
				p_id_usuario,
				v_parametros._id_usuario_ai,
				v_parametros._nombre_usuario_ai,
				v_id_estado_actual,
				v_registros_proc.id_funcionario_wf_pro,
				v_registros_proc.id_depto_wf_pro,
				v_registros_proc.obs_pro,
				v_codigo_tipo_pro,
				v_codigo_tipo_pro);

			end loop;

			--------------------------------------------------
			--  ACTUALIZA EL NUEVO ESTADO DE LA CUENTA DOCUMENTADA
			----------------------------------------------------
			IF pxp.f_existe_parametro(p_tabla,'id_cuenta_bancaria') THEN
                v_id_cuenta_bancaria =  v_parametros.id_cuenta_bancaria;
            END IF;

            IF pxp.f_existe_parametro(p_tabla,'id_depto_lb') THEN
                v_id_depto_lb =  v_parametros.id_depto_lb;
            END IF;


				if pro.f_fun_inicio_invitacion_wf(
                		v_parametros.id_invitacion,
                		p_id_usuario,
						v_parametros._id_usuario_ai,
						v_parametros._nombre_usuario_ai,
						v_id_estado_actual,
						v_id_proceso_wf,
						v_codigo_estado_siguiente,
						v_id_depto_lb,
		                v_id_cuenta_bancaria,
		                v_codigo_estado
					) then

				end if;
           	--recuperamos datos de la invitacion despues de que pase de estado
             select
                    c.id_invitacion,
                    c.estado,
                    c.id_estado_wf,
                    ew.id_funcionario,
                    c.pre_solicitud,
                    es.codigo as codigo_estado

              into v_rec
              from pro.tinvitacion c
              inner join wf.testado_wf ew on ew.id_estado_wf =  c.id_estado_wf
              left join  wf.ttipo_estado es on es.id_tipo_estado = ew.id_tipo_estado
              where c.id_invitacion = v_parametros.id_invitacion;

             IF	v_rec.codigo_estado = 'sol_compra'  THEN

             	IF v_rec.pre_solicitud = v_pre_solicitud THEN
                   v_resp = pro.f_inserta_pre_solicitud_compra(p_administrador,p_id_usuario,v_parametros.id_invitacion);
                ELSE
                   v_resp = pro.f_inserta_solicitud_compra(p_administrador,p_id_usuario,v_parametros.id_invitacion);

                END IF;
             END IF;



			-- si hay mas de un estado disponible  preguntamos al usuario
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del pago simple id='||v_parametros.id_invitacion);
			v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


			-- Devuelve la respuesta
			return v_resp;

     	end;

        /*********************************
	#TRANSACCION:  	'PRO_ANTEIVT_IME'
	#DESCRIPCION: 	Retrocede el estado del pago simple
	#AUTOR:   		EGS
	#FECHA:
	***********************************/

  	elseif(p_transaccion='PRO_ANTEIVT_IME')then

        begin

			--Obtenemos datos basicos
            select
            c.id_invitacion,
            ew.id_proceso_wf,
			c.id_estado_wf,
			c.estado
			into
			v_registros_proc
			from pro.tinvitacion c
            inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf
			where c.id_invitacion = v_parametros.id_invitacion;

        	v_id_proceso_wf = v_registros_proc.id_proceso_wf;

			--raise EXCEPTION 'v_id_proceso_wf %',v_id_proceso_wf;
            --------------------------------------------------
            --Retrocede al estado inmediatamente anterior
            -------------------------------------------------
           	--recupera estado anterior segun Log del WF
			select
			  ps_id_tipo_estado,
			  ps_id_funcionario,
			  ps_id_usuario_reg,
			  ps_id_depto,
			  ps_codigo_estado,
			  ps_id_estado_wf_ant
			into
			  v_id_tipo_estado,
			  v_id_funcionario,
			  v_id_usuario_reg,
			  v_id_depto,
			  v_codigo_estado,
			  v_id_estado_wf_ant
			from wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);

			--Configurar acceso directo para la alarma
			v_acceso_directo = '';
			v_clase = '';
			v_parametros_ad = '';
			v_tipo_noti = 'notificacion';
			v_titulo  = 'Visto Bueno';

			if v_codigo_estado_siguiente not in('borrador','finalizado','anulado') then

                v_acceso_directo = '../../../sis_proyectos/vista/invitacion/Invitacion.php';
				v_clase = 'Invitacion';
				v_parametros_ad = '{filtro_directo:{campo:"pro.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
				v_tipo_noti = 'notificacion';
				v_titulo  = 'Visto Bueno';
			end if;


          	--Registra nuevo estado
			v_id_estado_actual = wf.f_registra_estado_wf(
			    v_id_tipo_estado,                --  id_tipo_estado al que retrocede
			    v_id_funcionario,                --  funcionario del estado anterior
			    v_parametros.id_estado_wf,       --  estado actual ...
			    v_id_proceso_wf,                 --  id del proceso actual
			    p_id_usuario,                    -- usuario que registra
			    v_parametros._id_usuario_ai,
			    v_parametros._nombre_usuario_ai,
			    v_id_depto,                       --depto del estado anterior
			    '[RETROCESO] '|| v_parametros.obs,
			    v_acceso_directo,
			    v_clase,
			    v_parametros_ad,
			    v_tipo_noti,
			    v_titulo);
			--raise exception 'v_id_estado_actual %', v_id_estado_actual;
			if not pro.f_fun_regreso_invitacion_wf(
            									v_parametros.id_invitacion,
                                                p_id_usuario,
												v_parametros._id_usuario_ai,
												v_parametros._nombre_usuario_ai,
												v_id_estado_actual,
												v_parametros.id_proceso_wf,
												v_codigo_estado) then

				raise exception 'Error al retroceder estado';

			end if;

			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del pago simple)');
			v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

          	--Devuelve la respuesta
            return v_resp;

        end;
   /*********************************
    #TRANSACCION:  'PRO_ESTIVT_IME'
    #DESCRIPCION:	 verifica en que estado esta la solicitud asociada a la invitacion para poder realizr los 2,3,4,etc lanzamientos
    #AUTOR:		eddy.gutierrez
    #FECHA:		21/08/2019
    #ISSUE:     #20
    ***********************************/

    elsif(p_transaccion='PRO_ESTIVT_IME')then

        begin
            v_resp = 'exito';
            --verificamos que la invitacion ha generado una solicitud
            SELECT
              inv.id_solicitud
            INTO
              v_id_solicitud
            FROM pro.tinvitacion inv
            WHERE inv.id_invitacion = v_parametros.id_invitacion;

            IF v_id_solicitud is null THEN
              RAISE EXCEPTION 'No existe una solicitud de compra asociada a la invitacion';
            END IF;
            v_cantidad_solicitud = 0;
            FOR v_record_det IN(
                SELECT
                    sold.cantidad
                FROM adq.tsolicitud_det sold
                WHERE sold.id_solicitud = v_id_solicitud
            )LOOP
                v_cantidad_solicitud = v_cantidad_solicitud + COALESCE(v_record_det.cantidad,0);
            END LOOP;

            --verificamos que la solicitud no este anulada ni en proceso
            SELECT
                trim(lower(sol.estado)),
                sol.num_tramite
            INTO
                v_estado,
                v_nro_tramite
            FROM adq.tsolicitud sol
            WHERE sol.id_solicitud = v_id_solicitud ;


            IF  v_estado <> 'proceso' and v_estado <> 'anulado' and v_estado <> 'finalizado' THEN
                RAISE EXCEPTION 'La solicitud (%) se encuentra en estado de %',v_nro_tramite,v_estado;
            END IF;

            --si esta en proceso verificamos el proceso de compra relacionada
            IF v_estado = 'proceso' THEN
                  --recuperamos el proceso de compra
                  SELECT
                      prc.estado,
                      prc.id_proceso_compra
                  INTO
                      v_estado,
                      v_id_proceso_compra
                  FROM adq.tproceso_compra prc
                  WHERE prc.id_solicitud = v_id_solicitud ;

                  --si existe un proceso de compra
                  IF v_id_proceso_compra is not null THEN

                        --verificamos que sean distintos a los estados de anulado,desierto y proceso
                        IF v_estado <> 'proceso' and v_estado <> 'anulado' and v_estado <> 'desierto' and v_estado <> 'finalizado' THEN
                            RAISE EXCEPTION 'La solicitud (%) se encuentra en proceso de compra en el estado de %',v_nro_tramite,v_estado;
                        END IF;

                        --Si esta en estado de proceso verificamos si los detalles de la solicitud ya esten adjudicadas
                        IF v_estado = 'proceso' THEN

                              v_cantidad_adjudicada = 0;
                              FOR v_record IN(
                                    SELECT
                                        cot.estado,
                                        cot.id_cotizacion
                                    FROM adq.tcotizacion cot
                                    WHERE cot.id_proceso_compra = v_id_proceso_compra

                              )LOOP
                                    --si no estan en estado de anulado y de pago habilitado no se pueden hacer lanzamientos
                                    --IF v_record.estado = 'borrador' or v_record.estado = 'cotizado' or v_record.estado = 'adjudicado'  THEN
                                    IF v_record.estado <> 'anulado' AND v_record.estado <> 'pago_habilitado' THEN
                                        RAISE EXCEPTION 'Alguna Cotizacion esta en estado de % , anulelas o avance en el proceso de cotizacion',v_record.estado;
                                    END IF;
                                    FOR v_record_det IN(
                                        SELECT
                                            cotd.cantidad_adju
                                        FROM adq.tcotizacion_det cotd
                                        WHERE cotd.id_cotizacion =  v_record.id_cotizacion
                                    )LOOP
                                      v_cantidad_adjudicada = v_cantidad_adjudicada + COALESCE(v_record_det.cantidad_adju,0);

                                    END LOOP;

                              END LOOP;
                              --Si todos los detalles ya estan adjudicados ya no lanzan mas invitaciones
                              IF v_cantidad_adjudicada = v_cantidad_solicitud THEN
                                    RAISE EXCEPTION 'Todos Los detalles de la solicitud (%) relacionada a la invitacion ya fueron adjudicadas no puede hacer mas lanzamientos',v_nro_tramite;
                              END IF;

                        END IF;

                   END IF;
             END IF;
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