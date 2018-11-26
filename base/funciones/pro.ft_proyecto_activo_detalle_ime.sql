CREATE OR REPLACE FUNCTION "pro"."ft_proyecto_activo_detalle_ime" (
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_proyecto_activo_detalle_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tproyecto_activo_detalle'
 AUTOR: 		 (admin)
 FECHA:	        10-10-2017 18:02:07
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
	v_id_proyecto_activo_detalle	integer;
	v_rec 					record;
	v_id_proyecto 			integer;
	v_monto 				numeric;
	v_cuenta_utilizado		numeric;
	v_cuenta_saldo			numeric;
	v_id_tipo_cc			numeric;

BEGIN

    v_nombre_funcion = 'pro.ft_proyecto_activo_detalle_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_PRACDE_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		10-10-2017 18:02:07
	***********************************/

	if(p_transaccion='PRO_PRACDE_INS')then

        begin

        	--Obtención id_proyecto
        	select id_proyecto
        	into v_id_proyecto
        	from pro.tproyecto_activo
        	where id_proyecto_activo = v_parametros.id_proyecto_activo;

        	if v_id_proyecto is null then
        		raise exception 'Proyecto inexistente';
        	end if;

        	--Obtención del saldo del CC
        	select * into v_rec from pro.f_get_saldo_cc_proy(v_id_proyecto,v_parametros.id_tipo_cc);

        	if v_rec.o_utilizado + v_parametros.monto > v_rec.o_saldo then
        		raise exception 'Saldo insuficiente';
        	end if;

    		--Insert
        	insert into pro.tproyecto_activo_detalle(
			id_proyecto_activo,
			--id_comprobante,
			id_tipo_cc,
			nro_cuenta,
			porcentaje,
			observaciones,
			monto,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
			codigo_partida
          	) values(
			v_parametros.id_proyecto_activo,
			--v_parametros.id_comprobante,
			v_parametros.id_tipo_cc,
			v_parametros.nro_cuenta,
			v_parametros.porcentaje,
			v_parametros.observaciones,
			v_parametros.monto,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null,
			v_parametros.codigo_partida
			) RETURNING id_proyecto_activo_detalle into v_id_proyecto_activo_detalle;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_proyecto_activo_detalle'||v_id_proyecto_activo_detalle||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo_detalle',v_id_proyecto_activo_detalle::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRACDE_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		10-10-2017 18:02:07
	***********************************/

	elsif(p_transaccion='PRO_PRACDE_MOD')then

		begin

			--Obtención id_proyecto
        	select id_proyecto
        	into v_id_proyecto
        	from pro.tproyecto_activo
        	where id_proyecto_activo = v_parametros.id_proyecto_activo;

        	if v_id_proyecto is null then
        		raise exception 'Proyecto inexistente';
        	end if;

        	--Obtención del saldo del CC
        	select * into v_rec from pro.f_get_saldo_cc_proy(v_id_proyecto,v_parametros.id_tipo_cc);

        	--Obtención del monto actual antes del update
        	select monto
        	into v_monto
        	from pro.tproyecto_activo_detalle
        	where id_proyecto_activo_detalle = v_parametros.id_proyecto_activo_detalle;

        	if v_rec.o_utilizado - v_monto + v_parametros.monto > v_rec.o_saldo then
        		raise exception 'Saldo insuficiente';
        	end if;

			--Sentencia de la modificacion
			update pro.tproyecto_activo_detalle set
			id_proyecto_activo = v_parametros.id_proyecto_activo,
			--id_comprobante = v_parametros.id_comprobante,
			id_tipo_cc = v_parametros.id_tipo_cc,
			nro_cuenta = v_parametros.nro_cuenta,
			porcentaje = v_parametros.porcentaje,
			observaciones = v_parametros.observaciones,
			monto = v_parametros.monto,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
			codigo_partida = v_parametros.codigo_partida
			where id_proyecto_activo_detalle=v_parametros.id_proyecto_activo_detalle;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo_detalle',v_parametros.id_proyecto_activo_detalle::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRACDE_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin
 	#FECHA:		10-10-2017 18:02:07
	***********************************/

	elsif(p_transaccion='PRO_PRACDE_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from pro.tproyecto_activo_detalle
            where id_proyecto_activo_detalle=v_parametros.id_proyecto_activo_detalle;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo_detalle',v_parametros.id_proyecto_activo_detalle::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_CUESAL_LIS'
 	#DESCRIPCION:	Obtención del saldo de la Cuenta contable por Tipo CC, nro_cuenta e id_comprobante(opcional)
 	#AUTOR:			RCM
 	#FECHA:			30/10/2017
	***********************************/

	elsif(p_transaccion='PRO_CUESAL_LIS')then

        begin

        	--Inicialización de variables
        	v_cuenta_utilizado = 0;
        	v_cuenta_saldo = 0;

        	--Obtención del saldo de la cuenta utilizado en el sistema de proyectos
        	if pxp.f_existe_parametro(p_tabla,'id_comprobante') then

        		--Obtención del saldo de contabilidad
	    		select * into v_rec from conta.f_saldo_nro_cuenta_tipo_cc(
	    			v_parametros.nro_cuenta,
	    			v_parametros.id_tipo_cc,
	    			'balance',
	    			v_parametros.id_comprobante
	    		);

	    		--Verificación de la operación a realizar (nuevo, editar)
        		if v_parametros.operacion = 'nuevo' then
        			select sum(pracde.monto)
	        		into v_cuenta_utilizado
	        		from pro.tproyecto_activo_detalle pracde
	        		where pracde.id_tipo_cc = v_parametros.id_tipo_cc
	        		and pracde.id_comprobante = v_parametros.id_comprobante
	        		and pracde.nro_cuenta = v_parametros.nro_cuenta;
        		else
        			select sum(pracde.monto)
	        		into v_cuenta_utilizado
	        		from pro.tproyecto_activo_detalle pracde
	        		where pracde.id_tipo_cc = v_parametros.id_tipo_cc
	        		and pracde.id_comprobante = v_parametros.id_comprobante
	        		and pracde.nro_cuenta = v_parametros.nro_cuenta
	        		and pracde.id_proyecto_activo_detalle <> v_parametros.id_proyecto_activo_detalle;
        		end if;

        	else

        		--Obtención del saldo de contabilidad
	    		select * into v_rec from conta.f_saldo_nro_cuenta_tipo_cc(
	    			v_parametros.nro_cuenta,
	    			v_parametros.id_tipo_cc,
	    			'balance'
	    		);

        		--Verificación de la operación a realizar (nuevo, editar)
        		if v_parametros.operacion = 'nuevo' then
        			select sum(pracde.monto)
	        		into v_cuenta_utilizado
	        		from pro.tproyecto_activo_detalle pracde
	        		where pracde.id_tipo_cc = v_parametros.id_tipo_cc
	        		and pracde.nro_cuenta = v_parametros.nro_cuenta;
        		else
        			select sum(pracde.monto)
	        		into v_cuenta_utilizado
	        		from pro.tproyecto_activo_detalle pracde
	        		where pracde.id_tipo_cc = v_parametros.id_tipo_cc
	        		and pracde.nro_cuenta = v_parametros.nro_cuenta
	        		and pracde.id_proyecto_activo_detalle <> v_parametros.id_proyecto_activo_detalle;
        		end if;

        	end if;

        	--Cálculo del saldo
        	v_cuenta_saldo = v_rec.ps_saldo_mb - v_cuenta_utilizado;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Saldo de cuenta obtenido');
            v_resp = pxp.f_agrega_clave(v_resp,'cuenta_total',v_rec.ps_saldo_mb::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'cuenta_utilizado',v_cuenta_utilizado::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'cuenta_saldo',v_cuenta_saldo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_PRACDE_IMP'
 	#DESCRIPCION:	Insercion de detalle de valoración del activo fijo
 	#AUTOR:			RCM
 	#FECHA:			17/09/2018
	***********************************/

	elsif(p_transaccion='PRO_PRACDE_IMP')then

        begin

        	--Obtención id_proyecto
        	select id_proyecto
        	into v_id_proyecto
        	from pro.tproyecto_activo
        	where id_proyecto_activo = v_parametros.id_proyecto_activo;

        	if v_id_proyecto is null then
        		raise exception 'Proyecto inexistente';
        	end if;

        	--Obtención del tipo de centro de costo
			select tcc.id_tipo_cc
			into v_id_tipo_cc
			from param.ttipo_cc tcc
			where tcc.codigo = trim(v_parametros.centro_costo);

			if v_id_tipo_cc is null then
        		raise exception 'Centro de Costo no definido (%)',v_parametros.centro_costo;
        	end if;

			v_monto = v_parametros.monto::numeric;

    		--Insert
        	insert into pro.tproyecto_activo_detalle(
			id_proyecto_activo,
			id_tipo_cc,
			monto,
			estado_reg,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_proyecto_activo,
			v_id_tipo_cc,
			v_monto,
			'activo',
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null
			) RETURNING id_proyecto_activo_detalle into v_id_proyecto_activo_detalle;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Detalle almacenado(a) con exito (id_proyecto_activo_detalle'||v_id_proyecto_activo_detalle||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proyecto_activo_detalle',v_id_proyecto_activo_detalle::varchar);

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
ALTER FUNCTION "pro"."ft_proyecto_activo_detalle_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
