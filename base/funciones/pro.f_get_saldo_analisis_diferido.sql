--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_get_saldo_analisis_diferido (
    p_id_proyecto_analisis integer,
    p_tipo_cbt varchar,
    out op_saldo_activo numeric,
    out op_saldo_pasivo numeric,
    out op_saldo_ingreso numeric,
    out op_saldo_egreso numeric
)
    RETURNS record AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Proyectos
 FUNCION:       pro.f_get_saldo_analisis_diferido
 DESCRIPCION:   Obtiene el saldo segun cbt
 AUTOR:         (EGS)
 FECHA:         21/10/2020
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE

    v_nombre_funcion    text;
    v_resp              varchar;
    v_saldo_activo      numeric;
    v_saldo_pasivo      numeric;
    v_saldo_ingreso     numeric;
    v_saldo_egreso      numeric;
    v_porc_diferido     NUMERIC;

BEGIN

    v_nombre_funcion = 'pro.f_get_saldo_analisis_diferido';

    SELECT
        proana.porc_diferido
    INTO
        v_porc_diferido
    FROM  pro.tproyecto_analisis proana
    WHERE proana.id_proyecto_analisis = p_id_proyecto_analisis ;

    IF v_porc_diferido > 1 THEN
        IF v_porc_diferido = 100 THEN
            v_porc_diferido = 1 ;
        ELSE
            v_porc_diferido = (1- (v_porc_diferido/100));
        END IF;
    ELSIF  v_porc_diferido < 1 THEN
        v_porc_diferido = (1-v_porc_diferido);

    ELSE
        v_porc_diferido = 1;
    END if;


    SELECT
        COALESCE((SELECT
                      (sum(intra.importe_debe_mb)- sum(intra.importe_haber_mb))
                  FROM pro.tproyecto_analisis_det p
                           left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                           left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                  WHERE cue.tipo_cuenta ='activo' and p.id_proyecto_analisis = proana.id_proyecto_analisis),0) as saldo_activo,
        COALESCE((SELECT
                      (sum(intra.importe_haber_mb)-sum(intra.importe_debe_mb))
                  FROM pro.tproyecto_analisis_det p
                           left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                           left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                  WHERE cue.tipo_cuenta ='pasivo' and p.id_proyecto_analisis =  proana.id_proyecto_analisis),0) as saldo_pasivo,

        COALESCE((SELECT
                      (sum(intra.importe_haber_mb)- sum(intra.importe_debe_mb))
                  FROM pro.tproyecto_analisis_det p
                           left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                           left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                  WHERE cue.tipo_cuenta ='ingreso' and p.id_proyecto_analisis =  proana.id_proyecto_analisis),0) as saldo_ingreso,
        COALESCE((SELECT
                      (sum(intra.importe_debe_mb)- sum(intra.importe_haber_mb))
                  FROM pro.tproyecto_analisis_det p
                           left join conta.tint_transaccion intra on intra.id_int_transaccion = p.id_int_transaccion
                           left join conta.tcuenta cue on cue.id_cuenta = intra.id_cuenta
                  WHERE cue.tipo_cuenta ='gasto' and p.id_proyecto_analisis =  proana.id_proyecto_analisis),0) as saldo_gasto
    INTO
        v_saldo_activo,
        v_saldo_pasivo,
        v_saldo_ingreso,
        v_saldo_egreso
    FROM pro.tproyecto_analisis proana
             JOIN segu.tusuario usu1 ON usu1.id_usuario = proana.id_usuario_reg
             LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = proana.id_usuario_mod
             LEFT JOIN param.vproveedor pro on pro.id_proveedor = proana.id_proveedor
             LEFT JOIN param.ttipo_cc tc on tc.id_tipo_cc = proana.id_tipo_cc
    WHERE  proana.id_proyecto_analisis = p_id_proyecto_analisis ;

    IF p_tipo_cbt = 'cbt' THEN
        IF v_saldo_activo > 0 THEN
            op_saldo_activo = 0;
            op_saldo_pasivo = 0;
            op_saldo_ingreso = 0;
            op_saldo_egreso = v_saldo_activo + v_saldo_egreso;
        ELSE
            op_saldo_activo = 0;
            op_saldo_pasivo = 0;
            op_saldo_ingreso = 0;
            op_saldo_egreso = 0;

        END IF;

    ELSIF p_tipo_cbt = 'cbtII' THEN
        IF v_saldo_ingreso > ((v_saldo_egreso + v_saldo_activo)/ COALESCE(v_porc_diferido,1)) THEN
            op_saldo_activo = 0;
            op_saldo_pasivo = v_saldo_ingreso - ((v_saldo_activo+v_saldo_egreso)/ COALESCE(v_porc_diferido,1));
            op_saldo_ingreso = (v_saldo_activo+v_saldo_egreso)/COALESCE(v_porc_diferido,1);
            op_saldo_egreso = 0;
        ELSE
            op_saldo_activo = 0;
            op_saldo_pasivo = 0;
            op_saldo_ingreso = 0;
            op_saldo_egreso = 0;
        END IF;
    ELSIF p_tipo_cbt = 'cbtIII' THEN
        IF ( v_saldo_ingreso <((v_saldo_activo+v_saldo_egreso)/COALESCE(v_porc_diferido,1))) THEN

            IF v_saldo_pasivo > 0 THEN
                IF (v_saldo_pasivo - ((v_saldo_activo+v_saldo_egreso)/ COALESCE(v_porc_diferido,1)  - (v_saldo_activo+v_saldo_egreso))) >= 0 THEN
                    op_saldo_activo = 0;
                    op_saldo_pasivo = v_saldo_pasivo - ((v_saldo_activo+v_saldo_egreso)/ COALESCE(v_porc_diferido,1)  - (v_saldo_activo+v_saldo_egreso));
                    op_saldo_ingreso = (v_saldo_activo+v_saldo_egreso)/COALESCE(v_porc_diferido,1);
                    op_saldo_egreso = 0;
                ELSE
                    op_saldo_activo = 0;
                    op_saldo_pasivo = 0 ;
                    op_saldo_ingreso = saldo_ingreso+v_saldo_pasivo;
                    op_saldo_egreso = 0;

                END IF;

            ELSE
                op_saldo_activo = 0;
                op_saldo_pasivo = 0;
                op_saldo_ingreso = 0;
                op_saldo_egreso = 0;
            END IF;
        ELSE
            op_saldo_activo = 0;
            op_saldo_pasivo = 0;
            op_saldo_ingreso = 0;
            op_saldo_egreso = 0;
        END IF;


    ELSE
        --Salida si el p_tipo_cbt es null
        op_saldo_activo = coalesce(v_saldo_activo,0);
        op_saldo_pasivo = coalesce(v_saldo_pasivo,0);
        op_saldo_ingreso = coalesce(v_saldo_ingreso,0);
        op_saldo_egreso = coalesce(v_saldo_egreso,0);


    END IF;




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