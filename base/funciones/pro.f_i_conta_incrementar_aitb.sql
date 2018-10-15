CREATE OR REPLACE FUNCTION pro.f_i_conta_incrementar_aitb (
  p_id_usuario integer,
  p_id_proyecto integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_i_conta_incrementar_aitb
 DESCRIPCION:   Funcion que obtiene la actualización por AITB de gestiones pasadas y lo incrementa al valor del activo fijo en BS
 AUTOR: 		RCM
 FECHA:	        04/10/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/
DECLARE

	v_resp		        varchar;
	v_nombre_funcion    text;
    v_rec				record;
    v_rec_af 			record;
    v_monto_bs			numeric;
    v_monto_ufv			numeric;
    v_id_moneda_bs		integer;
    v_id_moneda_ufv		integer;
    v_id_activo_fijo	integer;
    v_id_cat_estado_fun integer;
    v_id_cat_estado_compra integer;
    v_id_depto 			integer;
    v_id_responsable_depto integer;
    v_id_funcionario 	integer;
    v_id_deposito 		integer;
    v_id_oficina		integer;
    v_monto_rescate		numeric;
    v_codigo            varchar;

BEGIN

	v_nombre_funcion = 'pro.f_i_conta_incrementar_aitb';

    ----------------------------------
    -- VALIDACIONES
    ----------------------------------
    --Verificar que el proceso del cierre esté en estado finalizado
    if not exists (select 1 from pro.tproyecto
    		where id_proyecto = p_id_proyecto) then
    	raise exception 'Proyecto inexistente';
    end if;

    --Verificar que el proceso del cierre esté en estado finalizado
    if exists (select 1 from pro.tproyecto
    		where id_proyecto = p_id_proyecto
            and estado_cierre <> 'af') then
    	raise exception 'No se puede generar registros en el Sistema de Activos Fijos, el estado debería estar en ''Activos Fijos''';
    end if;

    -------------------
    --VALORACIÓN
    -------------------
    --Elimina posibles valoraciones anteriores del proyecto
    delete from pro.tproyecto_activo_det_mon
    where id_proyecto_activo_detalle in (select id_proyecto_activo_detalle
                                        from pro.tproyecto_activo_detalle
                                        where id_proyecto_activo in (select id_proyecto_activo
                                                                    from pro.tproyecto_activo
                                                                    where id_proyecto = p_id_proyecto));
    --Se obtiene los montos en bolivianos para incrementar a los activos por CC del proyecto
    insert into pro.tproyecto_activo_det_mon
    (
        id_usuario_reg,
        fecha_reg,
        estado_reg,
        id_proyecto_activo_detalle,
        id_moneda,
        importe_actualiz
    )
    with tprorrateo as (
        select pa.denominacion,
        pa.id_proyecto, pa.id_proyecto_activo, pad.id_proyecto_activo_detalle, pad.id_tipo_cc, tcc.codigo, pad.monto, cip.dif_aitb,
        sum(pad.monto) over (partition by pad.id_tipo_cc) as total
        from pro.vproyecto_cierre_aitb_resumen cip
        inner join pro.tproyecto_activo pa
        on pa.id_proyecto = cip.id_proyecto
        inner join pro.tproyecto_activo_detalle pad
        on pad.id_proyecto_activo = pa.id_proyecto_activo
        and pad.id_tipo_cc = cip.id_tipo_cc
        inner join param.ttipo_cc tcc
        on tcc.id_tipo_cc = pad.id_tipo_cc
    )
    select
    p_id_usuario,
    now() as fecha_reg,
    'activo' as estado_reg,
    pr.id_proyecto_activo_detalle,
    param.f_get_moneda_base() as id_moneda,
    (pr.monto/pr.total) * pr.dif_aitb as importe_actualiz
    from tprorrateo pr
    where pr.id_proyecto = p_id_proyecto;


    --Respuesta
    return 'hecho';


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