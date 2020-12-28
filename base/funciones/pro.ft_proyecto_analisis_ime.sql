-- FUNCTION: pro.ft_proyecto_analisis_ime(integer, integer, character varying, character varying)

-- DROP FUNCTION pro.ft_proyecto_analisis_ime(integer, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION pro.ft_proyecto_analisis_ime(
	p_administrador integer,
	p_id_usuario integer,
	p_tabla character varying,
	p_transaccion character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_proyecto_analisis_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_analisis'
 AUTOR:          (egutierrez)
 FECHA:            29-09-2020 12:44:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                29-09-2020 12:44:10    egutierrez             Creacion
 #MDID-8               08/10/2020           EGS                 Se agrega WF
 #MDID-10               13/10/2020          EGS                 Se agrega ampo de tipo_cc
 						30.10.2020			MZM					Adicion de funcionalidad para elimnacion de cbtes al cambio de estado previo (borrador)
 ***************************************************************************/

DECLARE

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_proyecto_analisis    INTEGER;
    v_record_proyecto           record;
    v_record                    record;
    v_consulta                  varchar;
    v_id_gestion                integer;
    --variables wf --#MDID-8
    v_id_proceso_macro      integer;
    v_num_tramite           varchar;
    v_codigo_tipo_proceso   varchar;
    v_fecha                 date;
    v_codigo_estado         varchar;
    v_id_proceso_wf         integer;
    v_id_estado_wf          integer;

    -- variables de sig y ant estado de Wf --#MDID-8
    v_id_tipo_estado        integer;
    v_codigo_estado_siguiente    varchar;
    v_id_depto              integer;
    v_obs                   varchar;
    v_acceso_directo        varchar;
    v_clase                 varchar;
    v_codigo_estados        varchar;
    v_id_cuenta_bancaria    integer;
    v_id_depto_lb           integer;
    v_parametros_ad         varchar;
    v_tipo_noti             varchar;
    v_titulo                varchar;
    v_id_estado_actual      integer;
    v_registros_proc        record;
    v_codigo_tipo_pro       varchar;
    v_id_usuario_reg        integer;
    v_id_estado_wf_ant       integer;
    v_id_funcionario        integer;
	v_res_cbte               boolean; 
BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_analisis_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_PROANA_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez
     #FECHA:        29-09-2020 12:44:10
    ***********************************/

    IF (p_transaccion='PRO_PROANA_INS') THEN

        BEGIN
            SELECT
                pr.id_tipo_cc
            Into
                v_record_proyecto
            FROM pro.tproyecto pr
            WHERE pr.id_proyecto = v_parametros.id_proyecto ;

            v_codigo_tipo_proceso = 'DIFING';
            --Recoleccion de datos para el proceso WF #4
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

            --Obtencion de la gestion #4
            v_fecha= now()::date;
            select
                per.id_gestion
            into
                v_id_gestion
            from param.tperiodo per
            where per.fecha_ini <=v_fecha and per.fecha_fin >= v_fecha
            limit 1 offset 0;

            -- inciar el tramite en el sistema de WF   #4
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
                    v_parametros.id_funcionario,
                    null,
                    'Inicio de Analisis de Ingresos Referidos',
                    '' );
            IF v_parametros.porc_diferido > 100 THEN
                RAISE EXCEPTION 'No puede ingresar un porcentaje mayor a 100 (%)',v_parametros.porc_diferido;
            END IF;

            IF v_parametros.porc_diferido < 0 THEN
                RAISE EXCEPTION 'No puede ingresar un porcentaje menor a 0 (%)',v_parametros.porc_diferido;
            END IF;

            IF (
                SELECT
                    1
                FROM pro.tproyecto_analisis p
                WHERE p.id_proyecto = v_parametros.id_proyecto and p.cerrar = 'si') THEN
                RAISE EXCEPTION 'No puede Crear mas registros de analisis de diferidos ya un registro que cierra el analisis';
            END IF;


            --Sentencia de la insercion
            INSERT INTO pro.tproyecto_analisis(
                estado_reg,
                id_proyecto,
                fecha,
                glosa,
                estado,
                id_usuario_reg,
                fecha_reg,
                id_usuario_ai,
                usuario_ai,
                id_usuario_mod,
                fecha_mod,
                id_proveedor,
                porc_diferido,----#MDID-8
                cerrar, ----#MDID-8
                nro_tramite,--#MDID-8
                id_proceso_wf,--#MDID-8
                id_estado_wf,--#MDID-8
                id_tipo_cc --#MDID-10
                ,id_depto_conta
            ) VALUES (
                         'activo',
                         v_parametros.id_proyecto,
                         v_parametros.fecha,
                         v_parametros.glosa,
                         v_codigo_estado,
                         p_id_usuario,
                         now(),
                         v_parametros._id_usuario_ai,
                         v_parametros._nombre_usuario_ai,
                         null,
                         null,
                         v_parametros.id_proveedor,
                         v_parametros.porc_diferido, ----#MDID-8
                         v_parametros.cerrar, ----#MDID-8
                         v_num_tramite,--#MDID-8
                         v_id_proceso_wf,    --#MDID-8
                         v_id_estado_wf,     --#MDID-8
                         v_parametros.id_tipo_cc --#MDID-10
                         ,v_parametros.id_depto

                     ) RETURNING id_proyecto_analisis into v_id_proyecto_analisis;

            v_resp = pro.f_insertar_int_transaccion_tipo_cc(p_administrador,p_id_usuario,v_parametros.id_tipo_cc,v_parametros.fecha,v_id_proyecto_analisis,0);

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Análisis Ingresos Diferidos almacenado(a) con exito (id_proyecto_analisis'||v_id_proyecto_analisis||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis',v_id_proyecto_analisis::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'PRO_PROANA_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        egutierrez
         #FECHA:        29-09-2020 12:44:10
        ***********************************/

    ELSIF (p_transaccion='PRO_PROANA_MOD') THEN

        BEGIN
            SELECT
                pr.id_tipo_cc
            Into
                v_record_proyecto
            FROM pro.tproyecto pr
            WHERE pr.id_proyecto = v_parametros.id_proyecto;

            SELECT
                proa.fecha,
                proa.id_proveedor,
                pr.id_auxiliar
            INTO
                v_record
            FROM pro.tproyecto_analisis proa
                     LEFT JOIN param.tproveedor pr on pr.id_proveedor = proa.id_proveedor
            WHERE proa.id_proyecto_analisis=v_parametros.id_proyecto_analisis;

            IF v_parametros.porc_diferido > 100 THEN
                RAISE EXCEPTION 'No puede ingresar un porcentaje mayor a 100 (%)',v_parametros.porc_diferido;
            END IF;

            IF v_parametros.porc_diferido < 0 THEN
                RAISE EXCEPTION 'No puede ingresar un porcentaje menor a 0 (%)',v_parametros.porc_diferido;
            END IF;
            --Sentencia de la modificacion
            UPDATE pro.tproyecto_analisis SET
                                              id_proyecto = v_parametros.id_proyecto,
                                              fecha = v_parametros.fecha,
                                              glosa = v_parametros.glosa,
                                              id_usuario_mod = p_id_usuario,
                                              fecha_mod = now(),
                                              id_usuario_ai = v_parametros._id_usuario_ai,
                                              usuario_ai = v_parametros._nombre_usuario_ai,
                                              id_proveedor = v_parametros.id_proveedor,
                                              porc_diferido = v_parametros.porc_diferido, ----#MDID-8
                                              cerrar = v_parametros.cerrar ----#MDID-8
                                              ,id_depto_conta=v_parametros.id_depto
            WHERE id_proyecto_analisis=v_parametros.id_proyecto_analisis;
            --Solo insertamos transacciones si se modifica la fecha
            IF (v_record.fecha <> v_parametros.fecha) or (v_record.id_proveedor <> v_parametros.id_proveedor) THEN
                v_resp = pro.f_insertar_int_transaccion_tipo_cc(p_administrador,p_id_usuario,v_record_proyecto.id_tipo_cc,v_parametros.fecha,v_parametros.id_proyecto_analisis,v_record.id_auxiliar);
            END IF;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Análisis Ingresos Diferidos modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis',v_parametros.id_proyecto_analisis::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'PRO_PROANA_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        egutierrez
         #FECHA:        29-09-2020 12:44:10
        ***********************************/

    ELSIF (p_transaccion='PRO_PROANA_ELI') THEN

        BEGIN
            SELECT
                pa.estado
            INTO
                v_record
            FROM pro.tproyecto_analisis pa
            WHERE pa.id_proyecto_analisis=v_parametros.id_proyecto_analisis ;

            IF v_record.estado <> 'borrador' THEN
                RAISE EXCEPTION 'No puede eleminar el registro se encuentra en estado  (%) Solo puede eliminarlo en estado Borrador',v_record.estado;
            END IF;

            --Eliminamos todos los registros detalle relacionados al analisis
            DELETE FROM pro.tproyecto_analisis_det
            WHERE id_proyecto_analisis=v_parametros.id_proyecto_analisis;

            --Sentencia de la eliminacion
            DELETE FROM pro.tproyecto_analisis
            WHERE id_proyecto_analisis=v_parametros.id_proyecto_analisis;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Análisis Ingresos Diferidos eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_analisis',v_parametros.id_proyecto_analisis::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;
        /*********************************
#TRANSACCION:      'PRO_SIGEPROANA_INS'
#DESCRIPCION:      Controla el cambio al siguiente estado
#AUTOR:           EGS
#FECHA:
#ISSUE:           --#MDID-8
***********************************/


    ELSIF (p_transaccion='PRO_SIGEPROANA_INS')THEN

        begin
            --Obtenemos datos basico
            select
                ew.id_proceso_wf,
                c.id_estado_wf,
                c.estado
            into
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado
            from pro.tproyecto_analisis c
                     inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf
            where c.id_proyecto_analisis = v_parametros.id_proyecto_analisis;

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
            if v_codigo_estado_siguiente in ('voboconta') then -- MZM 19.10.2020
                  -- llamar a funcion q genera los cbtes
                  		v_res_cbte =    pro.f_generar_cbte( p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_parametros.id_proyecto_analisis,
                                                         v_parametros.id_proyecto_analisis,
                                                         'pago');
                  
                  	   
            end if;


            ---------------------------------------
            -- REGISTRA EL SIGUIENTE ESTADO DEL WF
            ---------------------------------------
            --Configurar acceso directo para la alarma
            v_acceso_directo = '';
            v_clase = '';
            v_parametros_ad = '';
            v_tipo_noti = 'notificacion';
            v_titulo  = 'VoBo';
            --raise exception 'v_codigo_estado_siguiente %',v_codigo_estado_siguiente;
            if v_codigo_estado_siguiente not in('borrador','finalizado','anulado') then
                v_acceso_directo = '../../../sis_proyectos/vista/proyecto_analisis/ProyectoAnalisis.php';
                v_clase = 'ProyectoAnalisis';
                v_parametros_ad = '{filtro_directo:{campo:"proana.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                v_tipo_noti = 'notificacion';
                v_titulo  = 'VoBo';
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
                    v_titulo );


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

            if pro.f_fun_inicio_proyecto_analisis_wf(
                    v_parametros.id_proyecto_analisis,
                    p_id_usuario,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    v_id_estado_actual,
                    v_id_proceso_wf,
                    v_codigo_estado_siguiente,
                    v_codigo_estado
                ) then

            end if;
            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado id='||v_parametros.id_proyecto_analisis);
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');
            -- Devuelve la respuesta
            return v_resp;
        end;

        /*********************************
        #TRANSACCION:      'PRO_ANTEPROANA_IME'
        #DESCRIPCION:     Retrocede el estado
        #AUTOR:           EGS
        #FECHA:
        #ISSUE:           --#MDID-8
        ***********************************/

    ELSIF(p_transaccion='PRO_ANTEPROANA_IME')THEN

        begin
            --raise exception'entra';
            --Obtenemos datos basicos
            select
                c.id_proyecto_analisis,
                ew.id_proceso_wf,
                c.id_estado_wf,
                c.estado, c.id_int_comprobante_1, c.id_int_comprobante_2, c.id_int_comprobante_3
            into
                v_registros_proc
            from pro.tproyecto_analisis c
                     inner join wf.testado_wf ew on ew.id_estado_wf = c.id_estado_wf
            where c.id_proyecto_analisis = v_parametros.id_proyecto_analisis;

            v_id_proceso_wf = v_registros_proc.id_proceso_wf;
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

                v_acceso_directo = '../../../sis_proyectos/vista/proyecto_analisis/ProyectoAnalisis.php';
                v_clase = 'ProyectoAnalisis';
                v_parametros_ad = '{filtro_directo:{campo:"proana.id_proceso_wf",valor:"'||v_id_proceso_wf::varchar||'"}}';
                v_tipo_noti = 'notificacion';
                v_titulo  = 'Visto Bueno';
            end if;


 			if v_codigo_estado_siguiente in ('borrador') then -- MZM 29.10.2020
                  -- llamar a funcion q elimina los cbtes
                  
                  if (v_registros_proc.id_int_comprobante_1 is not null) then
                  		v_res_cbte =    pro.f_gestionar_cbte_proyecto_analisis_eliminacion( p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_registros_proc.id_int_comprobante_1
                                                         );
                  end if;
                  if (v_registros_proc.id_int_comprobante_2 is not null) then
                  
                  	v_res_cbte =    pro.f_gestionar_cbte_proyecto_analisis_eliminacion( p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_registros_proc.id_int_comprobante_2
                                                         );
            	end if;
                 if (v_registros_proc.id_int_comprobante_3 is not null) then  
                  	   v_res_cbte =    pro.f_gestionar_cbte_proyecto_analisis_eliminacion( p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_registros_proc.id_int_comprobante_3
                                                         );
                 end if;
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
            if not pro.f_fun_regreso_proyecto_analisis_wf(
                    v_parametros.id_proyecto_analisis,
                    p_id_usuario,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    v_id_estado_actual,
                    v_parametros.id_proceso_wf,
                    v_codigo_estado) then

                raise exception 'Error al retroceder estado';

            end if;

            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado de la solicitud de proyecto analisis)');
            v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

            --Devuelve la respuesta
            return v_resp;


        end;

    ELSE

        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;

END;
$BODY$;

ALTER FUNCTION pro.ft_proyecto_analisis_ime(integer, integer, character varying, character varying)
    OWNER TO postgres;
