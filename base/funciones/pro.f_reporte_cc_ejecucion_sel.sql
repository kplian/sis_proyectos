--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_reporte_cc_ejecucion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_reporte_cc_ejecucion_sel
 DESCRIPCION:   Funcion par reporte de centro de costos
 AUTOR: 		 (EGS)
 FECHA:	        14/05/2020
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE			FECHA:			AUTOR:					DESCRIPCION:

***************************************************************************/

DECLARE

	v_parametros           	record;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_consulta       		varchar;
    v_id_tipo_cc			integer;
    v_registro    			record;
    v_record				record;
    v_rec					record;
    v_gestion				date;
    v_codigo_mb				varchar;


BEGIN

    v_nombre_funcion = 'pro.f_reporte_cc_ejecucion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_REPCCEJEC_SEL'
 	#DESCRIPCION:	Reporte de centro de costo de ejecuciion del proyecto
 	#AUTOR:		EGS
 	#FECHA:		14/05/2020
	***********************************/

	if(p_transaccion='PRO_REPCCEJEC_SEL')then

        begin

        	SELECT
            	p.id_tipo_cc
            INTO
            	v_id_tipo_cc
            FROM pro.tproyecto p
         	WHERE p.id_proyecto = v_parametros.id_proyecto;

         CREATE TEMPORARY TABLE temporal_tcc(
                                      gestion integer,
                                      monto_mb numeric(19,2),
                                      monto_anticipo numeric(19,2),
                                      monto_anticipo_mb numeric(19,2),
                                      monto_desc_anticipo numeric(19,2),
                                      monto_desc_anticipo_mb numeric(19,2)
                                     ) ON COMMIT DROP;


        FOR v_registro IN(
			SELECT
            	g.gestion::integer
            FROM param.tgestion g

        )LOOP
        		SELECT
                    sum(COALESCE(pe.monto_mb,0)) as monto_mb,
                    sum(COALESCE(pe.monto_anticipo,0)) as monto_anticipo,
                    sum(COALESCE(pe.monto_anticipo_mb,0)) as monto_anticipo_mb,
                    sum(COALESCE(pe.monto_desc_anticipo,0)) as monto_desc_anticipo,
                    sum(COALESCE(pe.monto_desc_anticipo_mb,0)) as monto_desc_anticipo_mb
                INTO
                	v_record
                FROM pre.tpartida_ejecucion pe
                    inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
                    inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_raiz ra on ra.id_tipo_cc = cc.id_tipo_cc
                    inner join param.vtipo_cc_techo te on te.id_tipo_cc = cc.id_tipo_cc
                    inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                    inner join param.tep ep on ep.id_ep = tcc.id_ep
                    inner join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti
                    inner join pre.tpartida par on par.id_partida = pe.id_partida
                    left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen=pe.valor_id_origen and pep.columna_origen=pe.columna_origen
                WHERE
                    te.id_tipo_cc_techo = v_id_tipo_cc and
                    pe.tipo_movimiento = 'ejecutado' and
                    (EXTRACT (year from pe.fecha))::INTEGER =  v_registro.gestion::INTEGER;

                    insert into temporal_tcc(
                        gestion ,
                        monto_mb ,
                        monto_anticipo ,
                        monto_anticipo_mb ,
                        monto_desc_anticipo ,
                        monto_desc_anticipo_mb
                                    )VALUES(
                        v_registro.gestion,
                        COALESCE(v_record.monto_mb,0) ,
                        COALESCE(v_record.monto_anticipo,0),
                        COALESCE(v_record.monto_anticipo_mb,0) ,
                        COALESCE(v_record.monto_desc_anticipo,0) ,
                        COALESCE(v_record.monto_desc_anticipo_mb,0)

                           );


        END LOOP;
        FOR v_rec in (
          						SELECT
                                  t.gestion ,
                                  t.monto_mb ,
                                  t.monto_anticipo ,
                                  t.monto_anticipo_mb ,
                                  t.monto_desc_anticipo ,
                                  t.monto_desc_anticipo_mb,
                                  (select codigo
                                   from param.tmoneda
                                   where tipo_moneda='base')::varchar as desc_moneda_base
                                FROM temporal_tcc t
                                WHERE t.monto_mb <> 0) LOOP
               RETURN NEXT v_rec;
             END LOOP;
		end;

    /*********************************
 	#TRANSACCION:  'PRO_RETOTCC_SEL'
 	#DESCRIPCION:	Reporte de centro de costo de ejecuciion del proyecto
 	#AUTOR:		EGS
 	#FECHA:		14/05/2020
	***********************************/

	ELSIF(p_transaccion='PRO_RETOTCC_SEL')then

    		SELECT
            	p.id_tipo_cc
            INTO
            	v_id_tipo_cc
            FROM pro.tproyecto p
         	WHERE p.id_proyecto = v_parametros.id_proyecto;
		FOR v_rec in (
          				select
                            sum(COALESCE(pe.monto_mb,0)) as total_monto_mb,
                            sum(COALESCE(pe.monto_anticipo,0)) as total_monto_anticipo,
                            sum(COALESCE(pe.monto_anticipo_mb,0)) as total_monto_anticipo_mb,
                            sum(COALESCE(pe.monto_desc_anticipo,0)) as total_monto_desc_anticipo,
                            sum(COALESCE(pe.monto_desc_anticipo_mb,0)) as total_monto_desc_anticipo_mb,
                            (select codigo
                             from param.tmoneda
            				where tipo_moneda='base')::varchar as desc_moneda_base
                          from pre.tpartida_ejecucion pe
                          inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
                          inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                          inner join param.vtipo_cc_raiz ra on ra.id_tipo_cc = cc.id_tipo_cc
                          inner join param.vtipo_cc_techo te on te.id_tipo_cc = cc.id_tipo_cc
                          inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                          inner join param.tep ep on ep.id_ep = tcc.id_ep
                          inner join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti
                          inner join pre.tpartida par on par.id_partida = pe.id_partida
                          left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen=pe.valor_id_origen and pep.columna_origen=pe.columna_origen
                          Where
                          te.id_tipo_cc_techo = v_id_tipo_cc and
                          pe.tipo_movimiento = 'ejecutado') LOOP
               RETURN NEXT v_rec;
        END LOOP;

        /*********************************
 	#TRANSACCION:  'PRO_RECCGEST_SEL'
 	#DESCRIPCION:	Reporte de centro de costo de ejecuciion del proyecto
 	#AUTOR:		EGS
 	#FECHA:		14/05/2020
	***********************************/

	ELSIF(p_transaccion='PRO_RECCGEST_SEL')then

    		SELECT
            	p.id_tipo_cc
            INTO
            	v_id_tipo_cc
            FROM pro.tproyecto p
         	WHERE p.id_proyecto = v_parametros.id_proyecto;


		v_gestion = now()::date;
		FOR v_rec in (
          				select
                            sum(COALESCE(pe.monto_mb,0)) as gestion_monto_mb,
                            sum(COALESCE(pe.monto_anticipo,0)) as gestion_monto_anticipo,
                            sum(COALESCE(pe.monto_anticipo_mb,0)) as gestion_monto_anticipo_mb,
                            sum(COALESCE(pe.monto_desc_anticipo,0)) as gestion_monto_desc_anticipo,
                            sum(COALESCE(pe.monto_desc_anticipo_mb,0)) as gestion_monto_desc_anticipo_mb,
                            (select codigo
                             from param.tmoneda
            				where tipo_moneda='base')::varchar as desc_moneda_base
                          from pre.tpartida_ejecucion pe
                          inner join param.tcentro_costo cc on cc.id_centro_costo = pe.id_presupuesto
                          inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cc.id_tipo_cc
                          inner join param.vtipo_cc_raiz ra on ra.id_tipo_cc = cc.id_tipo_cc
                          inner join param.vtipo_cc_techo te on te.id_tipo_cc = cc.id_tipo_cc
                          inner join pre.tpresupuesto p on p.id_presupuesto = pe.id_presupuesto
                          inner join param.tep ep on ep.id_ep = tcc.id_ep
                          inner join param.tprograma_proyecto_acttividad pra on pra.id_prog_pory_acti=ep.id_prog_pory_acti
                          inner join pre.tpartida par on par.id_partida = pe.id_partida
                          left join pre.vpartida_ejecucion_proveedor pep on pep.valor_id_origen=pe.valor_id_origen and pep.columna_origen=pe.columna_origen
                          Where
                          te.id_tipo_cc_techo = v_id_tipo_cc and
                          pe.tipo_movimiento = 'formulado' and
                          (EXTRACT (year from pe.fecha))::INTEGER = (EXTRACT (year from v_gestion))::INTEGER
                          ) LOOP
               RETURN NEXT v_rec;
        END LOOP;
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
COST 100 ROWS 1000;