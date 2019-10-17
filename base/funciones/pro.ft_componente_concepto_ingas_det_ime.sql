--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_componente_concepto_ingas_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_componente_concepto_ingas_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomp_concepto_ingas_det'
 AUTOR: 		 (admin)
 FECHA:	        22-07-2019 14:50:29
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #17				22-07-2019 14:50:29	EGS					Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomp_concepto_ingas_det'
 #25 EndeEtr         10/09/2019         EGS                 Adicion de cmp precio montaje, precio obci y precio pruebas
 #27                16/09/2019          EGS                 Se agrego campo f_desadeanizacion,f_seguridad,f_escala_xfd_montaje,f_escala_xfd_obra_civil,porc_prueba
 #34 EndeEtr        03/10/2019          EGS                 Se mejro la logica
 #39 EndeEtr        17/10/2019          EGS                 Se actualizan los datos si son automaticos y se agrega proceso wf
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_componente_concepto_ingas_det	integer;
    v_valor                 varchar;
    v_id_columna            integer;
    v_columna               record;
    --variable wf
    v_codigo_tipo_proceso   varchar;
    v_id_proceso_macro		integer;
    v_id_gestion			integer;
    v_num_tramite			varchar;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_id_funcionario        integer;
    v_id_periodo            integer;
    v_fecha                 date;

BEGIN

    v_nombre_funcion = 'pro.ft_componente_concepto_ingas_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_COMINDET_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		22-07-2019 14:50:29
	***********************************/

	if(p_transaccion='PRO_COMINDET_INS')then

        begin
            --#39
             v_codigo_tipo_proceso = split_part(pxp.f_get_variable_global('tipo_proceso_macro_proyectos'), ',', 4);

             ----#39obtener id del proceso macro
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

              ----#39Obtencion de la gestion
                select
                per.id_gestion
                into
                v_id_gestion
                from param.tperiodo per
                where per.fecha_ini <= now()::date and per.fecha_fin >= now()::date
                limit 1 offset 0;

             ----#39recuperando funcionario
             SELECT
              fun.id_funcionario
              INTO
              v_id_funcionario
              FROM orga.tfuncionario fun
              LEFT JOIN segu.tusuario usu on usu.id_persona = fun.id_persona
              WHERE usu.id_usuario = p_id_usuario ;
             v_fecha = now()::date;
             select
             	id_periodo
             into
             	v_id_periodo
             from param.tperiodo per
             where per.fecha_ini <= v_fecha and per.fecha_fin >=  v_fecha
             limit 1 offset 0;


             ----#39 inciar el tramite en el sistema de WF


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
                   'Planificacion Detalle',
                   '' );


        	--Sentencia de la insercion
        	insert into pro.tcomponente_concepto_ingas_det(
			estado_reg,
			id_concepto_ingas_det,
			id_componente_concepto_ingas,
			cantidad_est,
			precio,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod,
            peso,
            precio_montaje,--#25
            precio_obra_civil,--#25
            precio_prueba,--#25
            f_desadeanizacion,--#27
            f_seguridad,--#27
            f_escala_xfd_montaje,--#27
            f_escala_xfd_obra_civil,
            nro_tramite,
            id_proceso_wf,
            id_estado_wf,
            estado
          	) values(
			'activo',
			v_parametros.id_concepto_ingas_det,
			v_parametros.id_componente_concepto_ingas,
			v_parametros.cantidad_est,
			v_parametros.precio,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
            NULL,
            NULL,
            v_parametros.peso,
            v_parametros.precio_montaje,--#25
            v_parametros.precio_obra_civil,--#25
            v_parametros.precio_prueba,--#25
            v_parametros.f_desadeanizacion,--#27
            v_parametros.f_seguridad,--#27
            v_parametros.f_escala_xfd_montaje,--#27
            v_parametros.f_escala_xfd_obra_civil,--#27
            v_num_tramite,--#39
            v_id_proceso_wf,--#39
            v_id_estado_wf,--#39
            v_codigo_estado--#39
			)RETURNING id_componente_concepto_ingas_det into v_id_componente_concepto_ingas_det;
            ---si se agrega desde el componente concepto los parametros ya estan definido
            IF pxp.f_existe_parametro(p_tabla,'automatico') THEN

                 IF v_parametros.automatico = 'si' THEN
                     UPDATE  pro.tcomponente_concepto_ingas_det SET
                        tension= v_parametros.tension,
                        aislacion=v_parametros.aislacion,
                        conductor=v_parametros.conductor,
                        id_unidad_medida=v_parametros.id_unidad_medida,
                        tipo_configuracion = v_parametros.tipo_configuracion
                     WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;
                 END IF;

            ELSE
            --si se agregan desde el concepto detalle se buscan los parametros
                    ---Actualizamos El campo de Tension
                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'tension';

                      SELECT
                      cd.valor
                      into
                      v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_parametros.id_concepto_ingas_det;

                      UPDATE pro.tcomponente_concepto_ingas_det SET
                      tension = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;

                      ---Actualizamos El campo de Aislacion

                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'aislacion';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_parametros.id_concepto_ingas_det;

                      UPDATE pro.tcomponente_concepto_ingas_det SET
                      aislacion = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;
                      ---Actualizamos El campo de tipo_configuracion
                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'tipo_configuracion';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_parametros.id_concepto_ingas_det;

                      UPDATE pro.tcomponente_concepto_ingas_det SET
                      tipo_configuracion = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;

                      ---Actualizamos El campo de conductor
                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'conductor';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_parametros.id_concepto_ingas_det;

                      UPDATE pro.tcomponente_concepto_ingas_det SET
                      conductor = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;

                      ---Actualizamos El campo de id_unidad_medida
                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'id_unidad_medida';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_parametros.id_concepto_ingas_det;

                      UPDATE pro.tcomponente_concepto_ingas_det SET
                      id_unidad_medida = v_valor::integer
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;


            END IF;


			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto ingas detalle del componente almacenado(a) con exito (id_componente_concepto_ingas_det'||v_id_componente_concepto_ingas_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas_det',v_id_componente_concepto_ingas_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COMINDET_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		22-07-2019 14:50:29
	***********************************/

	elsif(p_transaccion='PRO_COMINDET_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tcomponente_concepto_ingas_det set
			id_concepto_ingas_det = v_parametros.id_concepto_ingas_det,
			id_componente_concepto_ingas = v_parametros.id_componente_concepto_ingas,
			cantidad_est = v_parametros.cantidad_est,
			precio = v_parametros.precio,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            peso = v_parametros.peso,
            precio_montaje = v_parametros.precio_montaje,--#25
            precio_obra_civil = v_parametros.precio_obra_civil,--#25
            precio_prueba = v_parametros.precio_prueba,--#25
            f_desadeanizacion = v_parametros.f_desadeanizacion,--#27
            f_seguridad = v_parametros.f_seguridad,--#27
            f_escala_xfd_montaje = v_parametros.f_escala_xfd_montaje,--#27
            f_escala_xfd_obra_civil = v_parametros.f_escala_xfd_obra_civil--#27
            where id_componente_concepto_ingas_det=v_parametros.id_componente_concepto_ingas_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto ingas detalle del componente modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas_det',v_parametros.id_componente_concepto_ingas_det::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMINDET_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:50:29
    ***********************************/

    elsif(p_transaccion='PRO_COMINDET_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tcomponente_concepto_ingas_det
            where id_componente_concepto_ingas_det=v_parametros.id_componente_concepto_ingas_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Concepto ingas detalle del componente eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas_det',v_parametros.id_componente_concepto_ingas_det::varchar);

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