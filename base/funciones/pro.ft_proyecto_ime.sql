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
        	--Sentencia de la insercion
        	insert into pro.tproyecto(
			codigo,
			nombre,
			fecha_ini,
			fecha_fin,
			id_proyecto_ep,
			estado_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod,
			id_moneda,
			id_depto_conta
          	) values(
			v_parametros.codigo,
			v_parametros.nombre,
			v_parametros.fecha_ini,
			v_parametros.fecha_fin,
			v_parametros.id_proyecto_ep,
			'activo',
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null,
			v_parametros.id_moneda,
			v_parametros.id_depto_conta
			)RETURNING id_proyecto into v_id_proyecto;

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
			--Sentencia de la modificacion
			update pro.tproyecto set
			codigo = v_parametros.codigo,
			nombre = v_parametros.nombre,
			fecha_ini = v_parametros.fecha_ini,
			fecha_fin = v_parametros.fecha_fin,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			id_moneda = v_parametros.id_moneda,
			id_depto_conta = v_parametros.id_depto_conta
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