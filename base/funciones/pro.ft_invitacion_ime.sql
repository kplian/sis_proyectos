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
 #
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
        	
        	IF EXISTS(
              select 
               1
              from pro.tinvitacion inv 
              where inv.codigo = v_parametros.codigo
                    and inv.estado_reg = 'activo') THEN                  
               raise exception 'ya existe el código de la Invitacion %',v_parametros.codigo;      
            END IF;
        	
            
            
             v_codigo_tipo_proceso = split_part(pxp.f_get_variable_global('tipo_proceso_macro_proyectos'), ',', 1);
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
                select
                per.id_gestion
                into
                v_id_gestion
                from param.tperiodo per
                where per.fecha_ini <= v_parametros.fecha and per.fecha_fin >= v_parametros.fecha
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
            
           IF (v_parametros.id_funcionario != 0) THEN
            	v_id_funcionario = v_parametros.id_funcionario;
            	--raise exception'v_id_funcionario if %',v_id_funcionario;
                
            END IF;
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
                   v_parametros.id_depto,
                   'Solicitud de invitacion',
                   '' );
        	--raise exception 'num tramite %',v_num_tramite;
            --raise exception 'id gestion %',v_id_gestion;
            
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
            dias_plazo_entrega
          	) values(
			v_parametros.id_proyecto,
			v_parametros.codigo,
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
            v_parametros.dias_plazo_entrega
							
			
			
			)RETURNING id_invitacion into v_id_invitacion;
			
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
			--Sentencia de la modificacion
			update pro.tinvitacion set
		
			
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
            dias_plazo_entrega=v_parametros.dias_plazo_entrega
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
	#AUTOR:   		RCM
	#FECHA:   		05/01/2018
	***********************************/

  	
  	elseif(p_transaccion='PRO_SIGEIVT_INS')then
        
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



			-- si hay mas de un estado disponible  preguntamos al usuario
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado del pago simple id='||v_parametros.id_invitacion);
			v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');


			-- Devuelve la respuesta
			return v_resp;

     	end;
        
        /*********************************
	#TRANSACCION:  	'PRO_ANTEIVT_IME'
	#DESCRIPCION: 	Retrocede el estado del pago simple
	#AUTOR:   		RCM
	#FECHA:   		06/01/2018
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
