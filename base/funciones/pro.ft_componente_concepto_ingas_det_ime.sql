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
            peso
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
            v_parametros.peso
			)RETURNING id_componente_concepto_ingas_det into v_id_componente_concepto_ingas_det;
            --#
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
            peso = v_parametros.peso
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
