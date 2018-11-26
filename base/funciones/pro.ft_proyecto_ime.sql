CREATE OR REPLACE FUNCTION pro.ft_proyecto_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto'
 AUTOR: 		 (admin)
 FECHA:	        28-09-2017 20:12:15
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_proyecto			integer;
	v_id_proceso_wf         integer;
	v_id_estado_wf          integer;
	v_codigo_estado         varchar;
	v_id_tipo_estado		integer;
	v_codigo_estado_siguiente varchar;
	v_id_depto 				integer;
	v_obs 					varchar;
	v_acceso_directo        varchar;
	v_clase             	varchar;
    v_parametros_ad         varchar;
    v_tipo_noti           	varchar;
    v_titulo              	varchar;
    v_id_estado_actual		integer;
    v_registros_proc		record;
    v_codigo_tipo_pro 		varchar;
    v_id_funcionario		integer;
    v_id_usuario_reg 		integer;
    v_id_estado_wf_ant		integer;
    v_resp_af				varchar;
    v_rec_proyecto			record;
    
    v_codigo_proyecto		record;
    item					record;
    v_codigo				varchar;
    v_id_fase				varchar[];
    v_id_fase_integer		integer;
    v_record_temp			record;
    v_record_temp_fk		record;
    v_id_fase_fk			VARCHAR;
    
    
    v_codigo_estados		varchar;
    v_id_cuenta_bancaria	integer;
    v_id_depto_lb					integer;
    
    v_codigo_tipo_proceso		varchar;		
	v_id_proceso_macro			 integer;
    v_id_gestion				 integer;
    v_num_tramite				 varchar;
    
    v_codigo_trans				varchar;
    v_tabla						varchar;
    v_fecha						date;
    v_fecha_ini					date;
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_PROY_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		28-09-2017 20:12:15
	***********************************/

	if(p_transaccion='PRO_PROY_INS')then
  			
        begin
       	  SELECT
             proy.codigo
            
             INTO
             v_codigo_proyecto
             FROM pro.tproyecto proy
             WHERE UPPER(proy.codigo) = UPPER(v_parametros.codigo);
          IF v_codigo_proyecto is not null THEN
          	RAISE EXCEPTION 'Este Codigo ya Existe';
          END IF;     
                   
          IF(v_parametros.fecha_ini_real is not null )THEN
                    	raise exception 'No Debe Ingresar una fecha real en este estado ';
          ELSIF(v_parametros.fecha_fin_real is not null)THEN
                    	raise exception 'No Debe Ingresar una fecha real en este estado ';
          END IF;
         
        
        ----------Recoleccion de datos para el proceso WF 
           v_codigo_tipo_proceso = split_part(pxp.f_get_variable_global('tipo_proceso_macro_proyectos'), ',', 2);
            --raise exception 'codigo proceso %',v_codigo_tipo_proceso;
             --obtener id del proceso macro

        	 select
             pm.id_proceso_macro
             into
             v_id_proceso_macro
             from wf.tproceso_macro pm
             left join wf.ttipo_proceso tp on tp.id_proceso_macro  = pm.id_proceso_macro
             where tp.codigo = v_codigo_tipo_proceso;
             
             --raise exception 'id proceso %',v_id_proceso_macro;
             
             If v_id_proceso_macro is NULL THEN
               raise exception 'El proceso macro  de codigo % no esta configurado en el sistema WF',v_codigo_tipo_proceso;
             END IF;
             
            
             v_fecha_ini = now()::date;
         
             --raise exception ' v_fecha_ini %',v_fecha_ini;
              --Obtencion de la gestion
                select
                per.id_gestion
                into
                v_id_gestion
                from param.tperiodo per
                where per.fecha_ini <= v_fecha_ini and per.fecha_fin >= v_fecha_ini
                limit 1 offset 0;
            --raise exception 'id gestion %',v_id_gestion;
             
             --recuperando funcionario
             SELECT 
              fun.id_funcionario
              INTO
              v_id_funcionario
              FROM orga.tfuncionario fun
              LEFT JOIN segu.tusuario usu on usu.id_persona = fun.id_persona
              WHERE usu.id_usuario = p_id_usuario ;
            --raise exception'v_id_funcionario if %',v_id_funcionario;
        /* 
          IF (v_parametros.id_funcionario <> 0) THEN
            	v_id_funcionario = v_parametros.id_funcionario;
            	--raise exception'v_id_funcionario if %',v_id_funcionario;
                
            END IF;*/
      	
        	--raise exception'v_id_funcionario %',pxp.f_existe_parametro(p_tabla,'fecha_real');
            IF	pxp.f_existe_parametro(p_tabla,'fecha_real') = FALSE	THEN
            	--v_parametros.fecha_real = now()::date;
            END IF;
        	
        	
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
                   null,
                   'Solicitud de Proyecto',
                   '' );
          --raise exception '%',v_codigo_estado;
          v_codigo = UPPER(v_parametros.codigo);
        --Sentencia de la insercion
        	insert into pro.tproyecto(
			codigo,
			nombre,
			fecha_ini,
			fecha_fin,
			--id_proyecto_ep,
			estado_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
			id_moneda,
			--id_depto_conta,
            fecha_ini_real,
			fecha_fin_real,
            id_tipo_cc,
            estado,
            id_proceso_wf,
            id_estado_wf,
            nro_tramite,
            id_fase_plantilla
          	) values(
			v_codigo,
			v_parametros.nombre,
			v_parametros.fecha_ini,
			v_parametros.fecha_fin,
			--v_parametros.id_proyecto_ep,
			'activo',
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_moneda,
			--v_parametros.id_depto_conta,
            v_parametros.fecha_ini_real,
			v_parametros.fecha_fin_real,
            v_parametros.id_tipo_cc,
            v_codigo_estado,
            v_id_proceso_wf,
            v_id_estado_wf,
            v_num_tramite,
            v_parametros.id_fase_plantilla
            
			)RETURNING id_proyecto into v_id_proyecto;
          
         ---Insercion de plantilla de fases  
          --tabla temporal para asociar y guardar los ids para recrear el arbol
          CREATE TEMPORARY TABLE temp_id(
                                      id serial,
                                      id_fase_plantilla integer,
                                      id_fase integer
                                     ) ON COMMIT DROP;	

          --recuperando el arbol de fase plantilla
         
           FOR item IN (
             	---nota :el padre en la consulta siempre esta ordenado antes que los hijos --
                
                WITH RECURSIVE arbol  AS(  
                 SELECT
                    fp.id_fase_plantilla,
                    fp.id_fase_plantilla_fk,
                    fp.codigo,
                    fp.nombre,
                    fp.descripcion,
                    fp.observaciones
                 FROM pro.tfase_plantilla fp
                  WHERE fp.id_fase_plantilla = v_parametros.id_fase_plantilla
                  UNION ALL
                   
                 SELECT
                    fp.id_fase_plantilla,
                    fp.id_fase_plantilla_fk,
                    fp.codigo,
                    fp.nombre,
                    fp.descripcion,
                    fp.observaciones
                 FROM pro.tfase_plantilla fp
                  JOIN arbol al ON al.id_fase_plantilla=fp.id_fase_plantilla_fk
                  )
                  select * from arbol
                 order by arbol.id_fase_plantilla ASC )LOOP
                 --no insertamos el padre a la tabla 
                 IF( item.id_fase_plantilla_fk is not null) THEN
                 
                 --recuperamos el id_fase nueva para asociar al fk               
                     SELECT	
                            id,
                            id_fase_plantilla,
                            id_fase
                     INTO
                        v_record_temp_fk
                     FROM	temp_id	
                     WHERE id_fase_plantilla = item.id_fase_plantilla_fk;
                 --asociamos la fk  respectivas
                 IF	v_record_temp_fk is not null THEN
                 	v_id_fase_fk =  v_record_temp_fk.id_fase::VARCHAR;
                 END IF;
                  --insertamos los registros a la fase
            v_codigo_trans = 'PRO_FASE_INS';
            
           IF item.descripcion is null THEN
           	  item.descripcion = '';
           END IF ;
           IF item.observaciones is null THEN
           	  item.observaciones = '';
           END IF ;
           IF v_id_fase_fk is null THEN
           	  v_id_fase_fk = 'id';
           END IF ;
          --RAISE EXCEPTION 'v_id_proyecto % v_id_fase_fk %,item.codigo % ,item.descripcion %,item.observaciones %,v_fecha_ini %',v_id_proyecto,v_id_fase_fk,item.codigo,item.descripcion,item.observaciones,v_fecha_ini;
           item.codigo='['||v_codigo||']'||item.codigo;
           
            v_tabla = pxp.f_crear_parametro(ARRAY[
            					'_nombre_usuario_ai',
                                '_id_usuario_ai',	 
                              	'id_proyecto',
                                'id_fase_fk',
                                'codigo',
                                'nombre',
                                'descripcion',
                                'observaciones',
                                'fecha_ini',
                                'fecha_fin',
                                --'estado',
                                'fecha_ini_real',
                                'fecha_fin_real',
                              --'id_tipo_cc',
                                'estado_reg'
                                ],
            				ARRAY[	
                           		'NULL'::varchar, ---'_nombre_usuario_ai',
                                 ''::varchar,  -----'_id_usuario_ai',
                              	v_id_proyecto::varchar,--'id_proyecto',
                                v_id_fase_fk::varchar,--'id_fase_fk',
                                item.codigo::varchar,--'codigo',
                                item.nombre::varchar,--'nombre',
                                item.descripcion::varchar,--'descripcion',
                                item.observaciones::varchar,--'observaciones',
                                ''::varchar,--'fecha_ini',
                                ''::varchar,--'fecha_fin',
                                --'estado',
                                ''::varchar,--'fecha_ini_real',
                                ''::varchar,--'fecha_fin_real',
                                --'id_tipo_cc',
                                'activo'::varchar--'estado_reg'
                                ],
                            ARRAY[
                            		'varchar',
                                	'integer',
                                    'int4',
                                    'varchar',
                                    'varchar',
                                    'varchar',
                                    'varchar',
                                    'varchar',
                                    'date',
                                    'date',
                                    --'varchar',
                                    'date',
                                    'date',
                                   -- 'integer',
                                    'varchar'
                               ]
                            );
 			
            v_resp = pro.ft_fase_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
            
            --raise exception '%',v_resp;
            
          	v_id_fase = pxp.f_recupera_clave(v_resp,'id_fase');
            v_id_fase_integer	= v_id_fase[1]::integer ;
            
            
            --RAISE EXCEPTION 'v_id_fase %',v_id_fase_integer;
            
		    /*
            insert into pro.tfase(
                              id_proyecto,
                              descripcion,
                              estado_reg,
                              nombre,
                              codigo,
                              estado,
                              observaciones,
                              id_usuario_reg,
                              fecha_reg,
                              id_fase_fk
                              ) values(
                              v_id_proyecto,
                              item.descripcion,
                              'activo',
                              item.nombre,
                              item.codigo,
                              'nuevo',
                              item.observaciones,
                              p_id_usuario,
                              now(),
                              v_id_fase_fk
                              )RETURNING id_fase into v_id_fase;*/
					--asociamos las id de plantillas con las nuevas
                           insert into temp_id(
                                        id_fase_plantilla,
                                        id_fase 
                                    )VALUES(
                                        item.id_fase_plantilla,
                                        v_id_fase_integer
                                    );
      				END IF;                
             END LOOP;		
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proyecto almacenado(a) con exito (id_proyecto'||v_id_proyecto||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto',v_id_proyecto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PROY_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		28-09-2017 20:12:15
	***********************************/

	elsif(p_transaccion='PRO_PROY_MOD')then

		begin
        --verificamos en que estado esta el proyecto
        	SELECT
            pro.estado
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
  			WHERE pro.id_proyecto = v_parametros.id_proyecto;
            
            IF(v_rec_proyecto.estado <> 'ejecucion')THEN
            		IF(v_parametros.fecha_ini_real is not null )THEN
                    	raise exception 'No Debe Ingresar una fecha real en este estado %',v_rec_proyecto.estado;
                    ELSIF(v_parametros.fecha_fin_real is not null)THEN
                    	raise exception 'No Debe Ingresar una fecha real en este estado %',v_rec_proyecto.estado;
                    END IF;
            END IF;   

            SELECT
               proy.codigo,
               proy.id_proyecto
            INTO
            v_codigo_proyecto
            FROM pro.tproyecto proy
            WHERE UPPER(proy.codigo) = UPPER(v_parametros.codigo);
            IF v_codigo_proyecto is not null and v_codigo_proyecto.id_proyecto <> v_parametros.id_proyecto  THEN
              RAISE EXCEPTION 'Este Codigo ya Existe';
            END IF; 
               	
			--Sentencia de la modificacion
			update pro.tproyecto set
			codigo = UPPER(v_parametros.codigo),
			nombre = v_parametros.nombre,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			id_moneda = v_parametros.id_moneda,
			--id_depto_conta = v_parametros.id_depto_conta,
            fecha_ini_real = v_parametros.fecha_ini_real,
			fecha_fin_real = v_parametros.fecha_fin_real,
            id_tipo_cc = v_parametros.id_tipo_cc
			where id_proyecto=v_parametros.id_proyecto;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proyecto modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto',v_parametros.id_proyecto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PROY_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		28-09-2017 20:12:15
	***********************************/

	elsif(p_transaccion='PRO_PROY_ELI')then

		begin
        	IF(SELECT 
            	count(fase.id_fase)
            FROM pro.tfase fase
            WHERE fase.id_proyecto = v_parametros.id_proyecto)<> 0 THEN
            	RAISE EXCEPTION 'Existen Fases Relacionadas al Proyecto';
            END IF;
            
            
			--Sentencia de la eliminacion
			delete from pro.tproyecto
            where id_proyecto=v_parametros.id_proyecto;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proyecto eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto',v_parametros.id_proyecto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
	#TRANSACCION:  	'PRO_SIGESTCIE_INS'
	#DESCRIPCION:  	Controla el cambio al siguiente estado
	#AUTOR:   		RCM
	#FECHA:   		24/09/2018
	***********************************/

  	elseif(p_transaccion='PRO_SIGESTCIE_INS')then

        begin

	        /*   PARAMETROS

	        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
	        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
	        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
	        $this->setParametro('id_depto_wf','id_depto_wf','int4');
	        $this->setParametro('obs','obs','text');
	        $this->setParametro('json_procesos','json_procesos','text');
	        */

	        --Obtenemos datos basicos
			select
			p.id_proceso_wf_cierre,
			p.id_estado_wf_cierre,
			p.estado_cierre
			into
			v_id_proceso_wf,
			v_id_estado_wf,
			v_codigo_estado
			from pro.tproyecto p
			where p.id_proyecto = v_parametros.id_proyecto;

	        --Recupera datos del estado
			select
			ew.id_tipo_estado,
			te.codigo
			into
			v_id_tipo_estado,
			v_codigo_estado
			from wf.testado_wf ew
			inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
			where ew.id_estado_wf = v_parametros.id_estado_wf_act;


			--Obtener datos tipo estado
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

			--Acciones por estado anterior que podrian realizarse
			if v_codigo_estado in ('af') then
				--Obtención del valor por actualización AITB de gestiones pasadas en moneda BOLIVIANOS
				v_resp_af = pro.f_i_conta_incrementar_aitb(p_id_usuario, v_parametros.id_proyecto);
				--Generación de los activos fijos en el sistema de activos fijos
				v_resp_af = pro.f_i_kaf_registrar_activos(p_id_usuario, v_parametros.id_proyecto);
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

				v_acceso_directo = '../../../sis_proyecto/vista/proyecto/ProyectoCierre.php';
				v_clase = 'ProyectoCierre';
				v_parametros_ad = '{filtro_directo:{campo:"pro.id_proceso_wf_cierre",valor:"'||v_id_proceso_wf::varchar||'"}}';
				v_tipo_noti = 'notificacion';
				v_titulo  = 'Visto Bueno';

			end if;

			v_id_estado_actual = wf.f_registra_estado_wf
								(
									v_parametros.id_tipo_estado,
									v_parametros.id_funcionario_wf,
									v_parametros.id_estado_wf_act,
									v_id_proceso_wf,
									p_id_usuario,
									v_parametros._id_usuario_ai,
									v_parametros._nombre_usuario_ai,
									v_id_depto,--depto del estado anterior
									v_obs,
									v_acceso_directo,
									v_clase,
									v_parametros_ad,
									v_tipo_noti,
									v_titulo
								);

			--------------------------------------
			-- Registra los procesos disparados
			--------------------------------------
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

			--------------------------------------------
			--  ACTUALIZA EL NUEVO ESTADO DEL REGISTRO
			--------------------------------------------
			if pro.f_fun_inicio_proyecto_cierre_wf(
					p_id_usuario,
					v_parametros._id_usuario_ai,
					v_parametros._nombre_usuario_ai,
					v_id_estado_actual,
					v_id_proceso_wf,
					v_codigo_estado_siguiente,
					null,
	                null,
	                v_codigo_estado
				) then

			end if;

			-- si hay mas de un estado disponible  preguntamos al usuario
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizó el cambio de estado del registro id_proyecto = '||v_parametros.id_proyecto);
			v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

			-- Devuelve la respuesta
			return v_resp;

     	end;

    /*********************************
	#TRANSACCION:  	'PRO_ANTESTCIE_IME'
	#DESCRIPCION: 	Retrocede el estado del cierre de proyecto
	#AUTOR:   		RCM
	#FECHA:   		24/09/2018
	***********************************/

  	elseif(p_transaccion='PRO_ANTESTCIE_IME')then

        begin

			--Obtenemos datos basicos
			select
			p.id_proyecto,
			p.id_proceso_wf_cierre,
			p.estado_cierre,
			pwf.id_tipo_proceso
			into
			v_registros_proc
			from pro.tproyecto p
			inner join wf.tproceso_wf pwf on  pwf.id_proceso_wf = p.id_proceso_wf_cierre
			where p.id_proceso_wf_cierre = v_parametros.id_proceso_wf;

        	v_id_proceso_wf = v_registros_proc.id_proceso_wf_cierre;

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
				v_acceso_directo = '../../../sis_proyectos/vista/proyecto/ProyectoCierre.php';
				v_clase = 'ProyectoCierre';
				v_parametros_ad = '{filtro_directo:{campo:"pro.id_proceso_wf_cierre",valor:"'||v_id_proceso_wf::varchar||'"}}';
				v_tipo_noti = 'notificacion';
				v_titulo  = 'Visto Bueno';
			end if;

          	--Registra nuevo estado
			v_id_estado_actual = wf.f_registra_estado_wf
								(
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
								    v_titulo
								);

			if not pro.f_fun_regreso_proyecto_cierre_wf(p_id_usuario,
												v_parametros._id_usuario_ai,
												v_parametros._nombre_usuario_ai,
												v_id_estado_actual,
												v_parametros.id_proceso_wf,
												v_codigo_estado) then

				raise exception 'Error al retroceder estado';

			end if;

			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizó el cambio de estado del registro id_proyecto = '||v_registros_proc.id_proyecto);
			v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

          	--Devuelve la respuesta
            return v_resp;

        end;
           /*********************************
          #TRANSACCION:  	'PRO_SIGEPRO_INS'
          #DESCRIPCION:  	Controla el cambio al siguiente estado
          #AUTOR:   		EGS
          #FECHA:   		
          ***********************************/

        	
          elseif(p_transaccion='PRO_SIGEPRO_INS')then
              
              begin

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
                  from pro.tproyecto c
                  inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf  
                  where c.id_proyecto = v_parametros.id_proyecto;
                  
                 -- raise exception 'v_parametros.id_proyecto %',v_parametros.id_proyecto;
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
      			
                  --raise exception ' v_id_tipo_estado %',v_id_tipo_estado;
                  --raise exception ' v_codigo_estados %', v_codigo_estados;
                  --raise exception ' v_parametros.id_estado_wf_act %', v_parametros.id_estado_wf_act;

                  -- obtener datos tipo estado
                  select
                  te.codigo
                  into
                  v_codigo_estado_siguiente
                  from wf.ttipo_estado te
                  where te.id_tipo_estado = v_parametros.id_tipo_estado;
                  
                  --raise exception ' v_codigo_estado_siguiente %', v_codigo_estado_siguiente;

                  if pxp.f_existe_parametro(p_tabla,'id_depto_wf') then
                      v_id_depto = v_parametros.id_depto_wf;
                      --raise exception ' v_id_depto %', v_id_depto;
                  end if;

                  if pxp.f_existe_parametro(p_tabla,'obs') then
                      v_obs=v_parametros.obs;
                      --raise exception ' v_obs %', v_obs;
                  else
                      v_obs='---';
                      
                      --raise exception ' v_obs %', v_obs;
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

                      v_acceso_directo = '../../../sis_proyectos/vista/invitacion/Proyecto.php';
                      v_clase = 'ProyectoPr';
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

                      --raise exception 'v_id_estado_actual %',v_id_estado_actual;
                  --------------------------------------
                  -- Registra los procesos disparados
                  --------------------------------------
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
                      --raise exception ' v_id_depto_lb %', v_id_depto_lb;
                      --raise exception ' v_id_cuenta_bancaria %', v_id_cuenta_bancaria;
                     --raise exception ' v_id_proceso_wf %', v_id_proceso_wf;
                     --raise exception 'v_codigo_estado_siguiente %',v_codigo_estado_siguiente;
                     --raise exception 'v_codigo_estado %',v_codigo_estado;
                    -- raise exception 'v_parametros.id_invitacion %',v_parametros.id_invitacion;
      		

                      if pro.f_fun_inicio_proyecto_wf(
                              v_parametros.id_proyecto,
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



                  -- si hay mas de un estado disponible  preguntamos al usuario
                  v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del pago simple id='||v_parametros.id_proyecto);
                  v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


                  -- Devuelve la respuesta
                  return v_resp;

              end;
              
              /*********************************
          #TRANSACCION:  	'PRO_ANTEPRO_IME'
          #DESCRIPCION: 	Retrocede el estado proyectos
          #AUTOR:   		EGS
          #FECHA:   		
          ***********************************/

          elseif(p_transaccion='PRO_ANTEPRO_IME')then

              begin

                  --Obtenemos datos basicos
                  select
                  c.id_proyecto,
                  ew.id_proceso_wf,	
                  c.id_estado_wf,
                  c.estado    
                  into
                  v_registros_proc
                  from pro.tproyecto c
                  inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf  
                  where c.id_proyecto = v_parametros.id_proyecto;
                  
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
      	
                      v_acceso_directo = '../../../sis_proyectos/vista/proyecto/Proyecto.php';
                      v_clase = 'ProyectoPr';
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
                  if not pro.f_fun_regreso_proyecto_wf(
                                                      v_parametros.id_proyecto,
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
