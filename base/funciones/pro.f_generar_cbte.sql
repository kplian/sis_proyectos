-- FUNCTION: pro.f_generar_cbte(integer, integer, character varying, integer, integer, character varying)

-- DROP FUNCTION pro.f_generar_cbte(integer, integer, character varying, integer, integer, character varying);

CREATE OR REPLACE FUNCTION pro.f_generar_cbte(
	p_id_usuario integer,
	p_id_usuario_ai integer,
	p_usuario_ai character varying,
	p_id_proyecto integer,
	p_id_proyecto_analisis integer,
	p_tipo character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
/*
 ***************************************************************************************************   
    

    HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0             08/10/2020        MZM KPLIAN      creacion de cbte independiente al wf
*/

DECLARE

    v_nombre_funcion             text;
    v_resp                       varchar;
    v_mensaje                    varchar;
    v_proyecto                   record;
    v_registros                  record;
    v_id_gestion                 integer;
    v_id_int_comprobante         integer;
    v_id_int_comprobante_2       integer;
    v_plani_cbte_independiente   varchar;
    v_id_int_comprobante_obli    integer;
    --14.10
    v_saldo_activo	numeric;
    v_saldo_pasivo	numeric;
    v_saldo_gasto	numeric;
    v_saldo_ingreso	numeric;
    
    v_porc_diferido numeric;
BEGIN

    v_nombre_funcion = 'pro.f_generar_cbte';
    
    IF p_id_proyecto_analisis IS NOT NULL THEN
         select 
                pro.*, 
                proa.fecha, 
                proa.glosa,
                proa.id_proveedor,
                proa.porc_diferido
        into v_proyecto
        from pro.tproyecto pro
        inner join pro.tproyecto_analisis proa
              on pro.id_proyecto = proa.id_proyecto
        
        where proa.id_proyecto_analisis = p_id_proyecto_analisis;
   
   END IF;
    
    
   
    
    
   IF p_tipo = 'pago' THEN -- gerar un cbte de pago especifico por id_obligacion_pago
       
     
          select * 
          into 
          v_registros
          from pro.tproyecto_analisis o
          where  o.id_proyecto_analisis = p_id_proyecto_analisis ;
        
   
   		v_porc_diferido:=v_registros.porc_diferido; 
        IF v_porc_diferido > 1 THEN
            IF v_porc_diferido = 100 THEN
                v_porc_diferido = 1 ;
            ELSE
                v_porc_diferido = (v_porc_diferido/100);
            END IF;
        ELSIF  v_porc_diferido < 1 THEN
            v_porc_diferido = (v_porc_diferido);

        ELSE
            v_porc_diferido = 1;
        END if;  
        	                
                select op_saldo_activo, op_saldo_pasivo, op_saldo_ingreso, op_saldo_egreso 
                into v_saldo_activo, v_saldo_pasivo, v_saldo_ingreso, v_saldo_gasto
                from pro.f_get_saldo_analisis_diferido(p_id_proyecto_analisis, null);
                     
                                                
			if (v_saldo_ingreso!=0 or v_saldo_pasivo!=0) then

             	--si existe saldo en activo== llevar a gasto
		       if (v_saldo_activo!=0 --and v_saldo_ingreso > ((v_saldo_activo+v_saldo_gasto)/(1-v_registros.porc_diferido))
               ) then

          				v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_proyecto_analisis,'PRO-DIFING',NULL,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL, FALSE, v_registros.nro_tramite);

             			update  conta.tint_comprobante set
						glosa1='REGISTRO POR RECONOCIMIENTO DE COSTO A '||  glosa1
                		where id_int_comprobante =  v_id_int_comprobante_obli;
        
        				update pro.tproyecto_analisis
                        set id_int_comprobante_1=v_id_int_comprobante_obli
                        where id_proyecto_analisis=p_id_proyecto_analisis;
        
             	end if;  
                
                -- raise exception 'aaa%, bbb%, ccc%',v_saldo_ingreso,v_saldo_activo, v_saldo_gasto;
                if (v_saldo_ingreso > ((v_saldo_activo+v_saldo_gasto)/(1-v_porc_diferido))) then
                 
                     v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_proyecto_analisis,'PRO-DIFING1',NULL,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL, FALSE,  v_registros.nro_tramite);
                
                		update  conta.tint_comprobante set
						glosa1='REGISTRO POR RECONOCIMIENTO DE INGRESO A '||  glosa1
                		where id_int_comprobante =  v_id_int_comprobante_obli;
        
        				update pro.tproyecto_analisis 
                        set id_int_comprobante_2=v_id_int_comprobante_obli
                        where id_proyecto_analisis=p_id_proyecto_analisis;
                end if;

                --tercer cbte, si es un analisis de cierre toca validar que los procesos que esten relacionados al CC esten cerrados
                --si no hay ingreso, pero si pasivo y tenemos gasto... compensar entonces como si fuera ingreso
                --tb si es q el gasto cubre el ingreso osea es mayor y hay saldo en pasivo... llevar todo al ingreso
                if ((v_saldo_ingreso<((v_saldo_activo+v_saldo_gasto)/(1-v_porc_diferido))) and v_saldo_pasivo>0 ) then

                     v_id_int_comprobante_obli = conta.f_gen_comprobante (v_registros.id_proyecto_analisis,'PRO-DIFING2',NULL,p_id_usuario,p_id_usuario_ai,p_usuario_ai, NULL, FALSE,  v_registros.nro_tramite);

                		update  conta.tint_comprobante set
						glosa1=' REGISTRO DE INGRESO A CUENTA DE RESULTADOS DEL INGRESO DIFERIDO '||  glosa1
                		where id_int_comprobante =  v_id_int_comprobante_obli;
        
        				update pro.tproyecto_analisis 
                        set id_int_comprobante_3=v_id_int_comprobante_obli
                        where id_proyecto_analisis=p_id_proyecto_analisis;
                end if;
                
            end if;
          

            
          
         
    
    END IF;
     
    RETURN   TRUE;

EXCEPTION

    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
            v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
            raise exception '%',v_resp;
END;
$BODY$;

ALTER FUNCTION pro.f_generar_cbte(integer, integer, character varying, integer, integer, character varying)
    OWNER TO postgres;