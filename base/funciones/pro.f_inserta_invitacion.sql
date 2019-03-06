CREATE OR REPLACE FUNCTION pro.f_inserta_invitacion (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/*
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_inserta_invitacion
 DESCRIPCION:   Creacion inserta una invitacion
 AUTOR: 		(eddy.gutierrez)
 FECHA:	        24/01/2019
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 ***************************************************************************/
 */
 
DECLARE

    v_nombre_funcion        text;
    v_resp                  varchar;
    v_mensaje               varchar;
    v_codigo_trans          varchar;
    v_codigo_trans_det      varchar;   
    v_parametros            record;
    v_tabla                 varchar;
    v_tabla_det             varchar;
    v_id_invitacion         varchar;
    v_id_invitacion_det     varchar;
    v_record_solicitud      record;
    v_registros             record;
    
    v_id_estado_actual  	integer; 
    va_id_tipo_estado 		integer[];
    va_codigo_estado 		varchar[];
    va_disparador    		varchar[];
    va_regla         		varchar[]; 
    va_prioridad     		integer[];
    p_id_usuario  			integer;
    p_id_usuario_ai 		integer;
    p_usuario_ai 			varchar;
    v_item                  record;
    v_record_facoing        record;
    v_record_solicitud_det  record;
    v_id_gestion            integer;
    v_tipo_cc               record;
    v_existe                boolean;
    v_id_moneda_proyecto    integer;
    v_id_moneda_solicitud   integer;
    v_conversion_moneda_solicitud_total numeric;
BEGIN
       
        v_nombre_funcion = 'pro.f_inserta_invitacion';
        v_parametros = pxp.f_get_record(p_tabla);
        p_id_usuario = v_parametros.p_id_usuario;
    /*********************************
	#TRANSACCION:  	'PRO_IVTREG_IME'
	#DESCRIPCION: 	Retrocede el estado del pago simple
	#AUTOR:   		EGS
	#FECHA:   		
	***********************************/

  	if(p_transaccion='PRO_IVTREG_IME')then
        begin
        
           --si el ingreso de item se hace desde una regularizacion de solicitud de compra
           IF v_parametros.id_solicitud is not null  THEN
                SELECT
                    sol.id_solicitud,
                    sol.fecha_soli,
                    sol.fecha_reg,
                    sol.observacion,
                    sol.id_depto,
                    sol.id_moneda,
                    sol.tipo,
                    sol.lugar_entrega,
                    sol.dias_plazo_entrega,
                    sol.id_categoria_compra,
                    sol.id_funcionario,
                    sol.num_tramite 
                INTO
                    v_record_solicitud
                FROM adq.tsolicitud sol
                WHERE sol.id_solicitud = v_parametros.id_solicitud;
               
           END IF; 
         --Si el Servicio/bien se quiere asociar a los items de la solicitud a un Fase_concepto_ingas
         IF v_parametros.id_fase_concepto_ingas is not NULL THEN
            --validaciones que el fase concepto ingas y la solicitud sean iguales 
            ---Recuperamos los datos de faseconcepto_ingas
                SELECT
                    facoin.fecha_estimada,
                    coingas.tipo,
                    facoin.id_funcionario,
                    fun.desc_funcionario1::VARCHAR as desc_funcionario,
                    facoin.precio,
                    facoin.precio_real,
                    facoin.id_concepto_ingas,
                    coingas.desc_ingas,
                    pro.id_proyecto,
                    pro.id_tipo_cc,
                    pro.id_moneda
                INTO
                    v_record_facoing
                FROM pro.tfase_concepto_ingas facoin
                left join param.tconcepto_ingas coingas on coingas.id_concepto_ingas = facoin.id_concepto_ingas 
                left join orga.vfuncionario fun on fun.id_funcionario = facoin.id_funcionario
                left join pro.tfase fase on fase.id_fase = facoin.id_fase
                left join pro.tproyecto pro on pro.id_proyecto = fase.id_proyecto
                WHERE facoin.id_fase_concepto_ingas = v_parametros.id_fase_concepto_ingas;
            --resuperamos los datos del detalle de la solicitud
             SELECT
                  sold.cantidad,
                  sold.precio_unitario,
                  sold.id_centro_costo,
                  sold.descripcion,
                  sold.id_concepto_ingas,
                  coingas.desc_ingas,
                  sol.tipo,
                  sol.id_funcionario,
                  fun.desc_funcionario1::VARCHAR as desc_funcionario,
                  sold.precio_total,
                  tcc.codigo as codigo_cc,
                  tcc.id_tipo_cc,
                  sol.id_moneda,
                  sol.fecha_soli
               INTO
               v_record_solicitud_det
              FROM adq.tsolicitud_det sold
              left join adq.tsolicitud sol on sol.id_solicitud = sold.id_solicitud
              left join param.tconcepto_ingas coingas on coingas.id_concepto_ingas = sold.id_concepto_ingas 
              left join orga.vfuncionario fun on fun.id_funcionario = sol.id_funcionario
              left join param.tcentro_costo cen on cen.id_centro_costo = sold.id_centro_costo
              left join param.ttipo_cc tcc on tcc.id_tipo_cc = cen.id_tipo_cc
              WHERE  sold.id_solicitud = v_record_solicitud.id_solicitud and sold.id_solicitud_det = v_parametros.id_solicitud_det;
           --conversion y validacion de montos segun moneda de la solicitud y del proyecto
          
         /* sol.id_moneda =  param.f_get_moneda_triangulacion()
           (sold.precio_total/((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),sol.fecha_soli::DATE,'O')):: numeric)):: numeric(18,2)
           (sold.precio_total*((param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),sol.fecha_soli::DATE,'O')):: numeric)):: numeric(18,2) */
              
           --se valida que los datos concuerden con la solicitud     
           IF v_record_solicitud_det.id_concepto_ingas <> v_record_facoing.id_concepto_ingas THEN
            RAISE EXCEPTION ' El Concepto de Gasto % no es igual al Concepto de Gasto % de la Solicitud',v_record_facoing.desc_ingas,v_record_solicitud_det.desc_ingas;
           END IF;
            IF v_record_solicitud_det.tipo <> v_record_facoing.tipo THEN
            RAISE EXCEPTION ' El tipo % no es igual al tipo % de la Solicitud',v_record_facoing.tipo,v_record_solicitud_det.tipo;
           END IF;  
            IF v_record_solicitud_det.id_funcionario <> v_record_facoing.id_funcionario THEN
            RAISE EXCEPTION ' El Funcionario % no es igual al % Funcionario de la Solicitud',v_record_facoing.desc_funcionario,v_record_solicitud_det.desc_funcionario;
           END IF;
           
           v_id_moneda_proyecto = v_record_facoing.id_moneda;
           v_id_moneda_solicitud = v_record_solicitud_det.id_moneda;
           
           IF v_id_moneda_proyecto = v_id_moneda_solicitud   THEN
                   IF COALESCE(v_record_solicitud_det.precio_total,0) <> COALESCE(v_record_facoing.precio,0) THEN
                    RAISE EXCEPTION ' El precio estimado % no es igual al % de la Solicitud',COALESCE(v_record_facoing.precio,0),COALESCE(v_record_solicitud_det.precio_total,0);
                   END IF;    
                    IF COALESCE(v_record_solicitud_det.precio_total,0) <> COALESCE(v_record_facoing.precio_real,0) THEN
                    RAISE EXCEPTION ' El precio actualizado % no es igual al % de la Solicitud',COALESCE(v_record_facoing.precio_real,0),COALESCE(v_record_solicitud_det.precio_total,0);
                   END IF;
           ELSE     
                    IF v_id_moneda_proyecto = param.f_get_moneda_base() and v_id_moneda_solicitud = param.f_get_moneda_triangulacion() THEN                   
                     v_conversion_moneda_solicitud_total =(v_record_solicitud_det.precio_total*(param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_solicitud_det.fecha_soli::DATE,'O')))::numeric(18,2);
                                 IF COALESCE(v_conversion_moneda_solicitud_total,0) <> COALESCE(v_record_facoing.precio,0) THEN
                                  RAISE EXCEPTION ' El precio estimado % no es igual al % de la Solicitud',COALESCE(v_record_facoing.precio,0),COALESCE(v_conversion_moneda_solicitud_total,0);
                                 END IF;    
                                  IF COALESCE(v_conversion_moneda_solicitud_total,0) <> COALESCE(v_record_facoing.precio_real,0) THEN
                                  RAISE EXCEPTION ' El precio actualizado % no es igual al % de la Solicitud',COALESCE(v_record_facoing.precio_real,0),COALESCE(v_conversion_moneda_solicitud_total,0);
                                 END IF;
                                  
                    ELSIF v_id_moneda_proyecto = param.f_get_moneda_triangulacion() and v_id_moneda_solicitud = param.f_get_moneda_base() THEN
                     v_conversion_moneda_solicitud_total = (v_record_solicitud_det.precio_total/(param.f_get_tipo_cambio(param.f_get_moneda_triangulacion(),v_record_solicitud_det.fecha_soli::DATE,'O')))::numeric(18,2);
                                 
                                 IF COALESCE(v_conversion_moneda_solicitud_total,0) <> COALESCE(v_record_facoing.precio,0) THEN
                                  RAISE EXCEPTION ' El precio estimado % no es igual al % de la Solicitud',COALESCE(v_record_facoing.precio,0),COALESCE(v_conversion_moneda_solicitud_total,0);
                                 END IF;    
                                  IF COALESCE(v_conversion_moneda_solicitud_total,0) <> COALESCE(v_record_facoing.precio_real,0) THEN
                                  RAISE EXCEPTION ' El precio actualizado % no es igual al % de la Solicitud',COALESCE(v_record_facoing.precio_real,0),COALESCE(v_conversion_moneda_solicitud_total,0);
                                 END IF;
                    
                    END IF;
           END IF;
                     
         --validamos que el tipo de centro de costos de la solicitud sea un el tipo centro de costos del proyecto
         --recuperamos los tipos centro de costos del proyecto y comparamos si el tipo centro de costo de solicitud este en el tipo centro de costo del proyecto
         v_existe = false;
         FOR v_tipo_cc IN (   
          with recursive arbol_tipo_cc AS (
                                SELECT
                                    tcc.id_tipo_cc,
                                    tcc.id_tipo_cc_fk,
                                    tcc.codigo,
                                    tcc.tipo,
                                    tcc.movimiento,
                                    tcc.descripcion,
                                    tcc.control_techo,
                                    tcc.control_partida
                                FROM param.ttipo_cc tcc
                                WHERE tcc.id_tipo_cc = v_record_facoing.id_tipo_cc
                                UNION
                                SELECT
                                    tcce.id_tipo_cc,
                                    tcce.id_tipo_cc_fk,
                                    tcce.codigo,
                                    tcce.tipo,
                                    tcce.movimiento,
                                    tcce.descripcion,
                                    tcce.control_techo,
                                    tcce.control_partida
                                FROM param.ttipo_cc tcce
                                inner join arbol_tipo_cc ar on ar.id_tipo_cc = tcce.id_tipo_cc_fk
                            )
                            select 
                                arb.id_tipo_cc,
                                arb.id_tipo_cc_fk,
                                arb.codigo,
                                arb.tipo,
                                arb.movimiento,
                                arb.descripcion,
                                arb.control_techo,
                                arb.control_partida
                            from arbol_tipo_cc arb
                            where  arb.movimiento = 'si' 
                            order by arb.id_tipo_cc ASC) LOOP
                            IF v_tipo_cc.id_tipo_cc = v_record_solicitud_det.id_tipo_cc  THEN
                               v_existe = true;
                            END IF;              
              END LOOP;
              --Si el centro de costo no existe 
              IF v_existe = false THEN
               RAISE EXCEPTION 'El Tipo de Centro de Costo % de la solicitud no es un tipo de Centro de Costo del Proyecto',v_record_solicitud_det.codigo_cc;
              END IF ;
         END IF;
                  
        v_id_invitacion = v_parametros.id_invitacion;
        -- sino se asocia con una invitacion se crea una nueva
        IF v_id_invitacion is null THEN
        
            --insertando los datos de la solicitud  para la invitacion regularizada
            v_codigo_trans = 'PRO_IVT_INS';

                --crear tabla 
            v_tabla = pxp.f_crear_parametro(ARRAY[      
                                '_nombre_usuario_ai',
                                '_id_usuario_ai',  
                                'id_proyecto',
                                'codigo',
                                'fecha',
                                'descripcion',
                                'fecha_real',
                                --'estado_reg',
                                --'estado',
                                --'id_estado_wf',
                                --'nro_tramite',
                                'id_funcionario',
                                'id_depto',
                                'id_moneda',
                                'tipo',
                                'lugar_entrega',
                                'dias_plazo_entrega',
                                'id_categoria_compra',		
                                'pre_solicitud',
                                'id_grupo'
                                                      ],
                            ARRAY[
                                'NULL', ---'_nombre_usuario_ai',
                                '',  -----'_id_usuario_ai',    
                                v_parametros.id_proyecto::varchar,--'id_proyecto'
                                v_parametros.codigo::varchar,--'codigo'
                                v_record_solicitud.fecha_soli::varchar,--'fecha'
                                '[Regularizado '||COALESCE(v_record_solicitud.num_tramite,' ')||']'||COALESCE(v_record_solicitud.observacion,' ')::varchar,--'descripcion'
                                v_record_solicitud.fecha_reg::varchar,--'fecha_real'
                                --''::varchar,--'estado_reg'
                                --''::varchar,--'estado'
                                --''::varchar,--'id_estado_wf'
                                --''::varchar,--'nro_tramite'
                                v_record_solicitud.id_funcionario::varchar,--'id_funcionario'
                                v_record_solicitud.id_depto::varchar,--'id_depto'
                                v_record_solicitud.id_moneda::varchar,--'id_moneda'
                                v_record_solicitud.tipo::varchar,--'tipo'
                                v_record_solicitud.lugar_entrega::varchar,--'lugar_entrega'
                                v_record_solicitud.dias_plazo_entrega::varchar,--'dias_plazo_entrega'
                                v_record_solicitud.id_categoria_compra::varchar,--'id_categoria_compra'	
                                'no'::varchar,--'pre_solicitud'
                                ''::varchar--'id_grupo'
                                ],
                            ARRAY[
                                'varchar',
                                'integer', 
                                'int4',--'id_proyecto'
                                'varchar',--'codigo'
                                'date',--'fecha'
                                'varchar',--'descripcion'
                                'date',--'fecha_real'
                                --'varchar',--'estado_reg'
                                --'varchar',--'estado'
                                --'int4',--'id_estado_wf'
                                --'varchar',--'nro_tramite'
                                'int4',--'id_funcionario'
                                'int4',--'id_depto'
                                'int4',--'id_moneda'
                                'varchar',--'tipo'
                                'varchar',--'lugar_entrega'
                                'int4',--'dias_plazo_entrega'
                                'int4',--'id_categoria_compra'		
                                'varchar',--'pre_solicitud'
                                'int4'--'id_grupo'
                               ]
                            );
           
            v_resp = pro.ft_invitacion_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
            v_id_invitacion  = pxp.f_recupera_clave(v_resp,'id_invitacion');
            v_id_invitacion    =  split_part(v_id_invitacion, '{', 2);
            v_id_invitacion    =  split_part(v_id_invitacion, '}', 1);
           --insertamos el detalle de la solicitud 
                      
          END IF ;
          --insertamos el detalle a la invitacion
           FOR v_item IN(
           SELECT
                  sold.cantidad,
                  sold.precio_unitario,
                  sold.id_centro_costo,
                  sold.descripcion,
                  sold.id_concepto_ingas
              FROM adq.tsolicitud_det sold
              WHERE  sold.id_solicitud = v_record_solicitud.id_solicitud and sold.id_solicitud_det = v_parametros.id_solicitud_det         
           )LOOP
           
           v_codigo_trans_det = 'PRO_IVTD_INS';

                --crear tabla 
            v_tabla_det = pxp.f_crear_parametro(ARRAY[      
                                '_nombre_usuario_ai',
                                '_id_usuario_ai',  
                                'id_fase_concepto_ingas',
                                'id_invitacion',
                               --'estado_reg',
                                'observaciones',
                                'cantidad_sol',
                                'id_unidad_medida',
                                'precio',                    		
                                'id_centro_costo',
                                'descripcion',
                                'id_fase',
                                'id_concepto_ingas',
                                'invitacion_det__tipo',
                                'id_solicitud_det',
                                'asociar_invitacion'
                                 ],
                            ARRAY[
                                'NULL', ---'_nombre_usuario_ai',
                                '',  -----'_id_usuario_ai'                                   
                                v_parametros.id_fase_concepto_ingas::VARCHAR,--'id_fase_concepto_ingas'
                                v_id_invitacion::VARCHAR,--'id_invitacion'
                                --''::VARCHAR,--'estado_reg'
                                '[regularizado]'::VARCHAR,--'observaciones'
                                v_item.cantidad::VARCHAR,--'cantidad_sol'
                                ''::VARCHAR,--'id_unidad_medida'
                                v_item.precio_unitario::VARCHAR,--'precio'                   		
                                v_item.id_centro_costo::VARCHAR,--'id_centro_costo'
                                v_item.descripcion::VARCHAR,--'descripcion'
                                v_parametros.id_fase::VARCHAR,--'id_fase'
                                v_item.id_concepto_ingas::VARCHAR, --'id_concepto_ingas'
                                'planif'::varchar, --invitacion_det__tipo       ---si se quiere ingresar  un concepto desde la solicitud a una fase  automatico colocar no_planif
                                 v_parametros.id_solicitud_det::varchar,--'id_solicitud_det'
                                 v_parametros.asociar_invitacion::varchar --'asociar_invitacion'
                                ],
                            ARRAY[
                                'varchar',
                                'integer', 
                                'int4',--'id_fase_concepto_ingas'
                                'int4',--'id_invitacion'
                                --'varchar',--'estado_reg'
                                'varchar',--'observaciones'
                                'numeric',--'cantidad_sol'
                                'int4',--'id_unidad_medida'
                                'numeric',--'precio'                       		
                                'int4',--'id_centro_costo'
                                'text',--'descripcion'
                                'int4',--'id_fase'
                                'int4', --'id_concepto_ingas'
                                'varchar',--invitacion_det__tipo
                                'int4', --'id_solicitud_det'
                                'varchar'--'asociar_invitacion'
                               ]
                            );
           
                v_resp = pro.ft_invitacion_det_ime(p_administrador,p_id_usuario,v_tabla_det,v_codigo_trans_det);
                v_id_invitacion_det  = pxp.f_recupera_clave(v_resp,'id_invitacion_det');
                v_id_invitacion_det    =  split_part(v_id_invitacion_det, '{', 2);
                v_id_invitacion_det    =  split_part(v_id_invitacion_det, '}', 1);
                
               ---actualizar el detalle de la invitacion y asociando al detalle de la solicitud
               UPDATE pro.tinvitacion_det SET
                    id_solicitud_det = v_parametros.id_solicitud_det
               WHERE id_invitacion_det  =v_id_invitacion_det::integer; 

            END LOOP;
            
            --si la invitacion se crea se avanza hasta el estado de sol_compra en el workflow
            IF v_parametros.id_invitacion is null THEN
               -- se realiza que la invitacion avance  dos estados el de borrador y vobo al de sol_compra
                FOR i IN 1..2 LOOP            
                select 
                    cs.id_invitacion,
                    eswf.id_proceso_wf,
                    cs.id_estado_wf,
                    cs.id_depto
                INTO
                v_registros
                	
                from pro.tinvitacion cs
                left join wf.testado_wf eswf on eswf.id_estado_wf = cs.id_estado_wf
                where cs.id_invitacion = v_id_invitacion::INTEGER  ;        

                 SELECT 
                       *
                    into
                      va_id_tipo_estado,
                      va_codigo_estado,
                      va_disparador,
                      va_regla,
                      va_prioridad
                  
                  FROM wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,NULL,'siguiente');
               
                  --raise exception '--  % ,  % ,% ',v_id_proceso_wf,v_id_estado_wf,va_codigo_estado;         
                  
                  IF va_codigo_estado[2] is not null THEN
                  
                   raise exception 'El proceso de WF esta mal parametrizado,  solo admite un estado siguiente para el estado: %', v_registros.estado;
                  
                  END IF;
                  
                   IF va_codigo_estado[1] is  null THEN
                  
                   raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente,  para el estado: %', v_registros.estado;           
                  END IF;
                         
                --p_id_usuario=1;
                p_id_usuario_ai = 1;
                p_usuario_ai = null;
                  
                  -- estado siguiente
               v_id_estado_actual =  wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                                 NULL, 
                                                                 v_registros.id_estado_wf, 
                                                                 v_registros.id_proceso_wf,
                                                                 p_id_usuario,
                                                                 p_id_usuario_ai, -- id_usuario_ai
                                                                 p_usuario_ai, -- usuario_ai
                                                                 v_registros.id_depto,
                                                                 'Invitacion Regularizado');         
                  -- actualiza estado en la solicitud
                   update pro.tinvitacion pp  set 
                               id_estado_wf =  v_id_estado_actual,
                               estado = va_codigo_estado[1],
                               id_usuario_mod=p_id_usuario,
                               fecha_mod=now(),
                               id_usuario_ai = p_id_usuario_ai,
                               usuario_ai = p_usuario_ai,
                               id_solicitud = v_record_solicitud.id_solicitud
                             where id_invitacion  = v_registros.id_invitacion; 

                END LOOP;
            END IF;
          RETURN   v_resp;
        END;
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