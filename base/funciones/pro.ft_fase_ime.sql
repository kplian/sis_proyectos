CREATE OR REPLACE FUNCTION pro.ft_fase_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_fase_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tfase'
 AUTOR: 		 (admin)
 FECHA:	        25-10-2017 13:16:54
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

ISSUE:           FECHA:	        AUTOR:                              DESCRIPCION:	
 #9   EndeEtr    27/03/2019     EGS                                 Se deshabilito las fechas de inicio y fin     			
 	
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_fase				integer;
	v_id_fase_fk			integer;
	v_codigo_fase			varchar;
    v_rec_fase				record;
    
    v_codigo_tipo_proceso	varchar;
    
    v_codigo_estado			varchar;
    v_codigo_estados		varchar;
    v_id_cuenta_bancaria	integer;
    v_id_depto_lb			integer;
    
	v_id_proceso_macro		integer;
    v_id_gestion			integer;
    v_num_tramite			varchar;
    v_id_funcionario		integer;
	v_id_proceso_wf         integer;
	v_id_estado_wf          integer;
    v_id_tipo_estado		integer;
    v_codigo_estado_siguiente	varchar;
    v_id_depto 				integer;
    v_obs					varchar;
    v_acceso_directo		varchar;
    v_clase					varchar;
    v_parametros_ad			varchar;
    v_tipo_noti				varchar;
    v_titulo  				varchar;
    v_id_estado_actual		integer;
    v_registros_proc		record;
    v_codigo_tipo_pro		varchar;
    v_id_usuario_reg		integer;
    v_id_estado_wf_ant		integer;
    
    v_fecha					date;
    v_rec_proyecto			record;
    v_record_fase			record;
    
    
    
    
    		    
BEGIN

    v_nombre_funcion = 'pro.ft_fase_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	if(p_transaccion='PRO_FASE_INS')then
					
        begin
        --verificamos en que estado esta el proyecto
        	SELECT
            pro.estado
        
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
  			WHERE pro.id_proyecto = v_parametros.id_proyecto;

            IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar el proyecto en estado de  %',v_rec_proyecto.estado;
            END IF;
        	

        	--Verificación del ID de la fase padre
        	if v_parametros.id_fase_fk = 'id' then
        		v_id_fase_fk = null;
        	else
        		v_id_fase_fk = v_parametros.id_fase_fk::integer;
        	end if;
		  
           v_codigo_fase=upper(v_parametros.codigo);
          
          IF EXISTS(
              select 
               1
              from pro.tfase tcc 
              where tcc.codigo = v_codigo_fase
                    and tcc.estado_reg = 'activo') THEN                  
               raise exception 'ya existe el código %',v_codigo_fase;      
            END IF;
            /*
            IF(v_parametros.fecha_ini_real is not null )THEN
                          raise exception 'No Debe Ingresar una fecha real en este estado ';
            ELSIF(v_parametros.fecha_fin_real is not null)THEN
                          raise exception 'No Debe Ingresar una fecha real en este estado ';
            END IF;
            */
                    ----------Recoleccion de datos para el proceso WF 
            v_codigo_tipo_proceso = split_part(pxp.f_get_variable_global('tipo_proceso_macro_proyectos'), ',', 3);
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
        	 	
            --Obtencion de la gestion
             v_fecha= now()::date;
              select
                per.id_gestion
                into
                v_id_gestion
                from param.tperiodo per
                where per.fecha_ini <=v_fecha and per.fecha_fin >= v_fecha
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
                   'Solicitud de Fases',
                   '' );
                   
            --raise exception ' %',v_codigo_estado;
        	--Sentencia de la insercion
        	insert into pro.tfase(
			id_proyecto,
			id_fase_fk,
			descripcion,
			estado_reg,
			--fecha_ini,--#9
			nombre,
			codigo,
            estado,
			--fecha_fin,--#9
			observaciones,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
            fecha_ini_real,
            fecha_fin_real,
            id_proceso_wf,
            id_estado_wf,
            nro_tramite
            
          	) values(
			v_parametros.id_proyecto,
			v_id_fase_fk,
			v_parametros.descripcion,
			'activo',
			--v_parametros.fecha_ini,--#9
			v_parametros.nombre,
			v_codigo_fase,
			v_codigo_estado,
			--v_parametros.fecha_fin,--#9
			v_parametros.observaciones,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.fecha_ini_real,
            v_parametros.fecha_fin_real,
            v_id_proceso_wf,
            v_id_estado_wf,
            v_num_tramite
			)RETURNING id_fase into v_id_fase;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase almacenado(a) con exito (id_fase'||v_id_fase||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase',v_id_fase::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	elsif(p_transaccion='PRO_FASE_MOD')then
    	begin
        	SELECT
            	fase.id_proyecto
            INTO 
            	v_record_fase
            FROM pro.tfase fase
            WHERE fase.id_fase = v_parametros.id_fase;
        
        --verificamos en que estado esta el proyecto
        	SELECT
            pro.estado
        
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
  			WHERE pro.id_proyecto = v_record_fase.id_proyecto;
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
    	----verificamos en que estado esta la fase
    	    SELECT
            fase.estado
            INTO
            v_rec_fase
            FROM pro.tfase fase
  			WHERE fase.id_fase = v_parametros.id_fase;
            
            IF(v_rec_fase.estado <> 'ejecucion')THEN
            		IF(v_parametros.fecha_ini_real is not null )THEN
                    	raise exception 'No Debe Ingresar una fecha real en este estado %',v_rec_fase.estado;
                    ELSIF(v_parametros.fecha_fin_real is not null)THEN
                    	raise exception 'No Debe Ingresar una fecha real en este estado %',v_rec_fase.estado;
                    END IF;
            END IF;  

		
			--Sentencia de la modificacion
			update pro.tfase set
			id_proyecto = v_parametros.id_proyecto,
			id_fase_fk = v_parametros.id_fase_fk,
			descripcion = v_parametros.descripcion,
			--fecha_ini = v_parametros.fecha_ini,--#9
			nombre = v_parametros.nombre,
			codigo = v_parametros.codigo,
			--fecha_fin = v_parametros.fecha_fin,--#9
			observaciones = v_parametros.observaciones,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            fecha_ini_real = v_parametros.fecha_ini_real,
            fecha_fin_real = v_parametros.fecha_fin_real
			where id_fase=v_parametros.id_fase;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase',v_parametros.id_fase::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'PRO_FASE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		25-10-2017 13:16:54
	***********************************/

	elsif(p_transaccion='PRO_FASE_ELI')then

		begin
     	
        	SELECT
            	fase.id_proyecto
            INTO 
            	v_record_fase
            FROM pro.tfase fase
            WHERE fase.id_fase = v_parametros.id_fase;
        
        --verificamos en que estado esta el proyecto
        	SELECT
            pro.estado
        
            INTO
            v_rec_proyecto
            FROM pro.tproyecto pro
  			WHERE pro.id_proyecto = v_record_fase.id_proyecto;
           IF(v_rec_proyecto.estado = 'cierre' or v_rec_proyecto.estado = 'finalizado' )THEN
                raise exception 'No puede Modificar la fase el proyecto esta en estado de  %',v_rec_proyecto.estado;
            END IF;
        	
			--Sentencia de la eliminacion
			delete from pro.tfase
            where id_fase=v_parametros.id_fase;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fase eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_fase',v_parametros.id_fase::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
              
                   /*********************************
          #TRANSACCION:  	'PRO_SIGEFAS_INS'
          #DESCRIPCION:  	Controla el cambio al siguiente estado
          #AUTOR:   		EGS
          #FECHA:   		
          ***********************************/

        	
          elseif(p_transaccion='PRO_SIGEFAS_INS')then
              
              begin

                  /*   PARAMETROS

                  $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
                  $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
                  $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
                  $this->setParametro('id_depto_wf','id_depto_wf','int4');
                  $this->setParametro('obs','obs','text');
                  $this->setParametro('json_procesos','json_procesos','text');
                  */
                 -- raise exception 'entra';
                  
                  
                  --Obtenemos datos basicos
                    
                            
                  select
                  ew.id_proceso_wf,	
                  c.id_estado_wf,
                  c.estado    
                  into
                  v_id_proceso_wf,
                  v_id_estado_wf,
                  v_codigo_estado
                  from pro.tfase c
                  inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf  
                  where c.id_fase = v_parametros.id_fase;
                  
                  --raise exception 'v_parametros.id_fase %',v_parametros.id_fase;
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

                      v_acceso_directo = '../../../sis_proyectos/vista/fase/Fase.php';
                      v_clase = 'Fase';
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
     		

                      if pro.f_fun_inicio_fase_wf(
                              v_parametros.id_fase,
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
                  v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del pago simple id='||v_parametros.id_fase);
                  v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


                  -- Devuelve la respuesta
                  return v_resp;

              end;
              
              /*********************************
          #TRANSACCION:  	'PRO_ANTEFAS_IME'
          #DESCRIPCION: 	Retrocede el estado proyectos
          #AUTOR:   		EGS
          #FECHA:   		
          ***********************************/

          elseif(p_transaccion='PRO_ANTEFAS_IME')then

              begin
				-- raise exception'entra';
                  --Obtenemos datos basicos
                  select
                  c.id_fase,
                  ew.id_proceso_wf,	
                  c.id_estado_wf,
                  c.estado    
                  into
                  v_registros_proc
                  from pro.tfase c
                  inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf  
                  where c.id_fase = v_parametros.id_fase;
                  
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
      	
                      v_acceso_directo = '../../../sis_proyectos/vista/fase/Fase.php';
                      v_clase = 'Fase';
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
                  if not pro.f_fun_regreso_fase_wf(
                                                      v_parametros.id_fase,
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