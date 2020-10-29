--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_insertar_int_transaccion_tipo_cc (
    p_administrador integer,
    p_id_usuario integer,
    p_id_tipo_cc integer,
    p_fecha date,
    p_id_proyecto_analisis integer,
    p_id_auxiliar_ant integer
)
    RETURNS varchar AS
$body$
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
#MDID-11               29/10/2020           EGS                  Se Modifica para que ahora se incluyan las cuentas en vez de excluir cuentas
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
    v_id_auxiliar               integer;

BEGIN

    v_nombre_funcion = 'pro.f_insertar_int_transaccion_tipo_cc';

    BEGIN

        IF NOT EXISTS ( SELECT 1
                        FROM pro.tcuenta_incluir e
                        Where e.tipo = 'diferido') THEN
            RAISE EXCEPTION 'No existe una cuenta registrada en incluir cuentas contables';
        END IF ;

        SELECT
            pro.id_auxiliar
        INTO
            v_id_auxiliar
        FROM pro.tproyecto_analisis proa
                 LEFT join param.tproveedor pro on pro.id_proveedor = proa.id_proveedor
        WHERE  proa.id_proyecto_analisis = p_id_proyecto_analisis;
        -- Si el Id_auxiliar no cambia entonces no eliminamos los registros del auxiliar
        IF v_id_auxiliar = p_id_auxiliar_ant  THEN
            p_id_auxiliar_ant = 0;
        END IF;
        --si se ingresa un fecha menor al registrado eliminamos las transacciones que sean mayores a la fecha registrada
        -- o eliminamos los registros del auxiliar si es diferente al ingresado
        DELETE FROM   pro.tproyecto_analisis_det
        WHERE id_int_transaccion in (
            SELECT
                pr.id_int_transaccion
            FROM pro.tproyecto_analisis_det pr
                     left join conta.tint_transaccion intra on intra.id_int_transaccion = pr.id_int_transaccion
                     left join conta.tint_comprobante cbt on cbt.id_int_comprobante = intra.id_int_comprobante
            WHERE (cbt.fecha > p_fecha) or (intra.id_auxiliar = p_id_auxiliar_ant)
        );

        --registramos las transacciones menores o iguales a la fecha solicitado
        v_consulta='
            SELECT
                  intra.id_int_transaccion,
                  cbt.fecha,
                  cbt.estado_reg
                 FROM conta.tint_transaccion intra
                  JOIN conta.tint_comprobante cbt on cbt.id_int_comprobante = intra.id_int_comprobante
                  Left join pro.tproyecto_analisis_det pa on pa.id_int_transaccion = intra.id_int_transaccion
                  left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                 WHERE cbt.estado_reg = ''validado''
                  and (intra.id_centro_costo in (with recursive arbol_tipo_cc AS (
                                SELECT
                                    tcc.id_tipo_cc,
                                    tcc.movimiento
                                FROM param.ttipo_cc tcc
                                WHERE tcc.id_tipo_cc = '||p_id_tipo_cc||'
                                UNION
                                SELECT
                                    tcce.id_tipo_cc,
                                    tcce.movimiento
                                FROM param.ttipo_cc tcce
                                inner join arbol_tipo_cc ar on ar.id_tipo_cc = tcce.id_tipo_cc_fk
                            )
                            select
                                cec.id_centro_costo
                            from arbol_tipo_cc arb
                            left join param.tcentro_costo cec on cec.id_tipo_cc = arb.id_tipo_cc
                            where  arb.movimiento = ''si''
                            order by cec.id_centro_costo ASC)
                  or intra.id_auxiliar = '||v_id_auxiliar||'
                  )
                  and cbt.fecha <= '''||p_fecha||'''::date
                  and pa.id_proyecto_analisis_det is NULL
                  and nro_cuenta in (
                            SELECT
                            DISTINCT(e.nro_cuenta)
                            FROM pro.tcuenta_incluir e
                            Where e.tipo = ''diferido''
                  )
                  ' ;

        FOR v_record IN EXECUTE  (
            v_consulta

            )LOOP
                INSERT INTO
                    pro.tproyecto_analisis_det
                (
                    id_usuario_reg,
                    id_proyecto_analisis,
                    id_int_transaccion
                )
                VALUES (
                           p_id_usuario,
                           p_id_proyecto_analisis,
                           v_record.id_int_transaccion
                       );

            END LOOP;

        --Devuelve la respuesta
        RETURN v_resp;

    END;

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