CREATE OR REPLACE FUNCTION pro.ft_componente_concepto_ingas_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.ft_componente_concepto_ingas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomp_concepto_ingas'
 AUTOR: 		 (admin)
 FECHA:	        22-07-2019 14:49:24
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #17				22-07-2019 14:49:24	EGS					Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomp_concepto_ingas'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_componente_concepto_ingas	integer;
    v_record                record;
    v_id_componente_concepto_ingas_det  integer;
    v_valor                 varchar;
    v_id_columna            integer;

BEGIN

    v_nombre_funcion = 'pro.ft_componente_concepto_ingas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_COMINGAS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin
 	#FECHA:		22-07-2019 14:49:24
	***********************************/

	if(p_transaccion='PRO_COMINGAS_INS')then

        begin
        	--Sentencia de la insercion
        	insert into pro.tcomponente_concepto_ingas(
			estado_reg,
			id_concepto_ingas,
			id_componente_macro,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_concepto_ingas,
			v_parametros.id_componente_macro,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_componente_concepto_ingas into v_id_componente_concepto_ingas;

            --ingresamos todos los detalles del concepto de gasto

            FOR v_record IN(
            SELECT
                id_concepto_ingas_det
            FROM param.tconcepto_ingas_det cigd
            WHERE cigd.estado_reg = 'activo' and cigd.agrupador = 'no' and cigd.id_concepto_ingas = v_parametros.id_concepto_ingas
            order By cigd.id_concepto_ingas_det_fk ASC
            )LOOP
                 INSERT INTO pro.tcomponente_concepto_ingas_det
                    (
                        id_componente_concepto_ingas,
                        id_concepto_ingas_det,
                        id_usuario_reg
                    )VALUES(
                        v_id_componente_concepto_ingas,
                        v_record.id_concepto_ingas_det,
                        p_id_usuario
                    )RETURNING id_componente_concepto_ingas_det into v_id_componente_concepto_ingas_det;
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
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_record.id_concepto_ingas_det;

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
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_record.id_concepto_ingas_det;

                      UPDATE pro.tcomponente_concepto_ingas_det SET
                      aislacion = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;




            END LOOP;


			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Lista Concepto Ingas Componente almacenado(a) con exito (id_comp_concepto_ingas'||v_id_componente_concepto_ingas||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas',v_id_componente_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'PRO_COMINGAS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin
 	#FECHA:		22-07-2019 14:49:24
	***********************************/

	elsif(p_transaccion='PRO_COMINGAS_MOD')then

		begin
			--Sentencia de la modificacion
			update pro.tcomponente_concepto_ingas set
			id_concepto_ingas = v_parametros.id_concepto_ingas,
			id_componente_macro = v_parametros.id_componente_macro,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_componente_concepto_ingas=v_parametros.id_componente_concepto_ingas;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Lista Concepto Ingas Componente modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas',v_parametros.id_componente_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMINGAS_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:49:24
    ***********************************/

    elsif(p_transaccion='PRO_COMINGAS_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tcomponente_concepto_ingas
            where id_componente_concepto_ingas=v_parametros.id_componente_concepto_ingas;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Lista Concepto Ingas Componente eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas',v_parametros.id_componente_concepto_ingas::varchar);

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