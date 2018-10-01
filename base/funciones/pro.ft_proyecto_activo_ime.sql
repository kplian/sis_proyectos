CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_activo_ime" (
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_activo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_activo'
 AUTOR: 		 (admin)
 FECHA:	        31-08-2017 16:52:19
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
	v_id_proyecto_activo	integer;
	v_rec 					record;
	v_id_depto 				integer;
	v_id_centro_costo		integer;
	v_id_clasificacion		integer;
	v_id_gestion 			integer;
	v_id_ubicacion			integer;
	v_id_grupo_ae			integer;
	v_id_grupo_clasif		integer;
	v_nro_serie				varchar;
	v_marca					varchar;
	v_wf 					varchar;
	v_id_unidad_medida		integer;
	v_codigo_af_rel 		varchar;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_activo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_PRAF_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		31-08-2017 16:52:19
	***********************************/

	if(p_transaccion='PRO_PRAF_INS')then

        begin

        	--Verifica si se inició el WF del cierre
        	PERFORM pro.f_iniciar_wf_proyecto_cierre(p_id_usuario, v_parametros._id_usuario_ai, v_parametros._nombre_usuario_ai, v_parametros.id_proyecto);

        	--Preparación de variables
			select
	        coalesce(v_parametros.id_proyecto,null) as id_proyecto,
			coalesce(v_parametros.observaciones,null) as observaciones,
			coalesce(v_parametros.denominacion,null) as denominacion,
			coalesce(v_parametros.descripcion,null) as descripcion,
			coalesce(v_parametros.id_clasificacion,null) as id_clasificacion,
			coalesce(v_parametros._nombre_usuario_ai,null) as _nombre_usuario_ai,
			coalesce(v_parametros._id_usuario_ai,null) as _id_usuario_ai,
			coalesce(v_parametros.cantidad_det,null) as cantidad_det,
			coalesce(v_parametros.id_depto,null) as id_depto,
			coalesce(v_parametros.estado,null) as estado,
			coalesce(v_parametros.ubicacion,null) as ubicacion,
			coalesce(v_parametros.id_centro_costo,null) as id_centro_costo,
			coalesce(v_parametros.id_ubicacion,null) as id_ubicacion,
			coalesce(v_parametros.id_grupo,null) as id_grupo,
			coalesce(v_parametros.id_grupo_clasif,null) as id_grupo_clasif,
			coalesce(v_parametros.nro_serie,null) as nro_serie,
			coalesce(v_parametros.marca,null) as marca,
			coalesce(v_parametros.fecha_ini_dep,null) as fecha_ini_dep,
			coalesce(v_parametros.vida_util_anios,null) as vida_util_anios,
			coalesce(v_parametros.id_unidad_medida,null) as id_unidad_medida,
			coalesce(v_parametros.codigo_af_rel,null) as codigo_af_rel
	        into v_rec;

	        --Inserción del movimiento
	        v_id_proyecto_activo = pro.f_insercion_proyecto_activo(p_id_usuario, hstore(v_rec));

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición de Activos Fijos almacenado(a) con exito (id_proyecto_activo'||v_id_proyecto_activo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo',v_id_proyecto_activo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRAF_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		31-08-2017 16:52:19
	***********************************/

	elsif(p_transaccion='PRO_PRAF_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tproyecto_activo set
			id_proyecto = v_parametros.id_proyecto,
			observaciones = v_parametros.observaciones,
			denominacion = v_parametros.denominacion,
			descripcion = v_parametros.descripcion,
			id_clasificacion = v_parametros.id_clasificacion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			cantidad_det = v_parametros.cantidad_det,
			id_depto = v_parametros.id_depto,
			estado = v_parametros.estado,
			--id_lugar = v_parametros.id_lugar,
			ubicacion = v_parametros.ubicacion,
			id_centro_costo = v_parametros.id_centro_costo,
			id_ubicacion = v_parametros.id_ubicacion,
			id_grupo = v_parametros.id_grupo,
			id_grupo_clasif = v_parametros.id_grupo_clasif,
			nro_serie = v_parametros.nro_serie,
			marca = v_parametros.marca,
			fecha_ini_dep = v_parametros.fecha_ini_dep,
			vida_util_anios = v_parametros.vida_util_anios,
			id_unidad_medida = v_parametros.id_unidad_medida,
			codigo_af_rel = v_parametros.codigo_af_rel
			where id_proyecto_activo=v_parametros.id_proyecto_activo;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición de Activos Fijos modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo',v_parametros.id_proyecto_activo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRAF_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		31-08-2017 16:52:19
	***********************************/
	elsif(p_transaccion='PRO_PRAF_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tproyecto_activo
            where id_proyecto_activo=v_parametros.id_proyecto_activo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición de Activos Fijos eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo',v_parametros.id_proyecto_activo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRAF_XLS'
 	#DESCRIPCION:	Generar proyecto activo desde excel
 	#AUTOR:			RCM
 	#FECHA:			14/09/2018
	***********************************/
	elsif(p_transaccion='PRO_PRAF_XLS')then

		begin

			--Obtiene la gestión del cierre del proyecto
			select id_gestion
			into v_id_gestion
			from param.tgestion
			where date_trunc('year',fecha_ini) in (select date_trunc('year',fecha_fin)
													from pro.tproyecto
													where id_proyecto = v_parametros.id_proyecto);

			--id_depto
			select
			dep.id_depto
			into v_id_depto
			from param.tdepto dep
			inner join segu.tsubsistema sub
			on sub.id_subsistema = dep.id_subsistema
			where sub.codigo = 'KAF'
			and dep.codigo = 'AF';

			if coalesce(v_id_depto,0) = 0 then
				raise exception 'No se encuentra registrado Dpto. de Activos Fijos en el sistema. Comuníquese con el administrador del Sistema de Activos Fijos para coordinar su registro';
			end if;


			--Obtiene el id_clasificacion
			select
			id_clasificacion
			into v_id_clasificacion
			from kaf.tclasificacion
			where codigo_completo_tmp = trim(v_parametros.clasificacion);

            if coalesce(v_id_clasificacion,0) = 0 then
            	raise exception 'Clasificación no encontrada para el activo: %', v_parametros.denominacion;
            end if;

			--Centro costo
			select cc.id_centro_costo
			into v_id_centro_costo
			from param.ttipo_cc tcc
			inner join param.tcentro_costo cc
			on cc.id_tipo_cc = tcc.id_tipo_cc
			where tcc.codigo = v_parametros.centro_costo
			and cc.id_gestion = v_id_gestion;

			if coalesce(v_id_centro_costo,0) = 0 then
				raise exception 'Centro de Costo no definido para el activo: %', v_parametros.denominacion;
			end if;

			--id_ubicacion (local)
			select id_ubicacion
			into v_id_ubicacion
			from kaf.tubicacion
			where codigo = v_parametros.local;

			if coalesce(v_id_ubicacion,0) = 0 then
				raise exception 'Local no definido para el activo: %', v_parametros.denominacion;
			end if;

			--id_grupo
			select id_grupo
			into v_id_grupo_ae
			from kaf.tgrupo
			where tipo = 'grupo'
			and codigo = v_parametros.grupo_ae or codigo = '0' || v_parametros.grupo_ae;

			if coalesce(v_id_grupo_ae,0) = 0 then
				raise exception 'Grupo AE no definido para el activo: %', v_parametros.denominacion;
			end if;

			--id_grupo_clasif
			select id_grupo
			into v_id_grupo_clasif
			from kaf.tgrupo
			where tipo = 'clasificacion'
			and codigo = v_parametros.clasificacion_ae or codigo = '0' || v_parametros.clasificacion_ae;

			if coalesce(v_id_grupo_clasif,0) = 0 then
				raise exception 'Clasificación AE no definido para el activo: %', v_parametros.denominacion;
			end if;

			--nro_serie
			v_nro_serie = null;
			if pxp.f_existe_parametro(p_tabla, 'nro_serie') then
				v_nro_serie = v_parametros.nro_serie;
			end if;

			--marca
			v_marca = null;
			if pxp.f_existe_parametro(p_tabla, 'marca') then
				v_marca = v_parametros.marca;
			end if;

			--Unidad de medida
			select id_unidad_medida
			into v_id_unidad_medida
			from param.tunidad_medida
			where codigo = v_parametros.unidad;

			if coalesce(v_id_unidad_medida,0) = 0 then
				raise exception 'Unidad de Medida no definida para el activo: %', v_parametros.denominacion;
			end if;

			--codigo_activo_rel
			v_codigo_af_rel = null;
			if pxp.f_existe_parametro(p_tabla, 'codigo_activo_rel') then
				v_codigo_af_rel = v_parametros.codigo_activo_rel;
			end if;

			--Preparación del record para la inserción
			select
	        coalesce(v_parametros.id_proyecto,null) as id_proyecto,
			coalesce(v_parametros.denominacion,null) as denominacion,
			coalesce(v_parametros.descripcion,null) as descripcion,
			coalesce(v_parametros.cantidad_det,null) as cantidad_det,
			coalesce(v_parametros.ubicacion,null) as ubicacion,
			v_id_clasificacion id_clasificacion,
			v_id_depto as id_depto,
			v_id_centro_costo as id_centro_costo,
			v_id_ubicacion as id_ubicacion,
			v_id_grupo_ae as id_grupo,
			v_id_grupo_clasif as id_grupo_clasif,
			coalesce(v_parametros._nombre_usuario_ai,null) as _nombre_usuario_ai,
			coalesce(v_parametros._id_usuario_ai,null) as _id_usuario_ai,
			v_nro_serie as nro_serie,
			coalesce(v_parametros.observaciones,null) as observaciones,
			v_marca as marca,
			coalesce(v_parametros.fecha_ini_dep,null) as fecha_ini_dep,
			coalesce(v_parametros.vida_util_anios,null) as vida_util_anios,
			coalesce(v_id_unidad_medida,null) as id_unidad_medida,
			coalesce(v_codigo_af_rel,null) as codigo_af_rel
	        into v_rec;

	        --Inserción del movimiento
	        v_id_proyecto_activo = pro.f_insercion_proyecto_activo(p_id_usuario, hstore(v_rec));

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Definición de Activos Fijos almacenado(a) con exito (id_proyecto_activo'||v_id_proyecto_activo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo',v_id_proyecto_activo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRAFIMP_ELI'
 	#DESCRIPCION:	Elimina los registros del proyecto_activo_detalle y proyecto_activo de un proyecto
 	#AUTOR:			RCM
 	#FECHA:			21/09/2018
	***********************************/
	elsif(p_transaccion='PRO_PRAFIMP_ELI')then

		begin

			if not exists(select 1 from pro.tproyecto
        				where id_proyecto = v_parametros.id_proyecto) then
        		raise exception 'Proyecto inexistente';
        	end if;

        	--Verifica si se inició el WF del cierre
        	PERFORM pro.f_iniciar_wf_proyecto_cierre(p_id_usuario, v_parametros._id_usuario_ai, v_parametros._nombre_usuario_ai, v_parametros.id_proyecto);

			--Sentencia de la eliminacion
			delete from pro.tproyecto_activo_detalle
            where id_proyecto_activo in (select id_proyecto_activo
            							from pro.tproyecto_activo
            							where id_proyecto=v_parametros.id_proyecto);

            delete from pro.tproyecto_activo where id_proyecto=v_parametros.id_proyecto;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Proyecto Activo y Detalle eliminados');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto',v_parametros.id_proyecto::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_WFCIE_INS'
 	#DESCRIPCION:	Creación del WF para el cierre del proyecto
 	#AUTOR:			RCM
 	#FECHA:			21/09/2018
	***********************************/
	elsif(p_transaccion='PRO_WFCIE_INS')then

		begin
			--Verifica si se inició el WF del cierre
        	v_wf = pro.f_iniciar_wf_proyecto_cierre(p_id_usuario, v_parametros._id_usuario_ai, v_parametros._nombre_usuario_ai,v_parametros.id_proyecto);

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Creación de WF del cierre verificada/creada');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto',v_parametros.id_proyecto::varchar);

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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "pro"."ft_proyecto_activo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
