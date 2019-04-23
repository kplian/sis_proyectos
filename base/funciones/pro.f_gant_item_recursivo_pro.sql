CREATE OR REPLACE FUNCTION pro.f_gant_item_recursivo_pro (
  p_id_fase integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       pro.f_gant_recursivo_pro
 Descripcion:   inserta recursivamente los hijos de cada nodo de fases               

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:
ISSUE            FECHA            AUTOR                 DESCRIPCION             
  #10   EndeEtr   11/11/2018       EGS                    Creacion
    
***************************************************************************/


DECLARE
v_parametros            record;
v_nombre_funcion        text;
v_resp                  varchar;
v_record_fase           record;
v_hijo                  record;
v_padre                 boolean;
v_nro_padre             integer;
v_id                    integer;
v_id_fk                 integer;
v_item                  BOOLEAN;
v_duplicado             boolean;
v_agrupador             boolean;
v_fase_concepto_ingas   BOOLEAN;
v_record_facoing        record;
v_num                   integer;
v_fecha_ini_real        date;
v_fecha_fin_real        date;
v_soli_pre              varchar;
v_fecha_ini             date;
v_fecha_fin             date;

BEGIN

    v_nombre_funcion = 'pro.f_gant_item_recursivo_pro';
    /*********************************    
     #TRANSACCION:  
     #DESCRIPCION:    Consulta del diagrama gant del PRO
     #AUTOR:        EGS
     #FECHA:        
    ***********************************/
  v_resp = 'exito';
     v_nro_padre = 0;
     --raise exception 'recursivo';
              FOR v_hijo IN ( 
                    SELECT
                        fase.id_fase,
                        fase.id_fase_fk
                    FROM pro.tfase fase
                    WHERE fase.id_fase_fk = p_id_fase 
                    ORDER BY fase.id_fase
                    )LOOP
             
                     v_padre = false;  --sirve como agrupador 
                     --recuperams los datos a insertar
                     SELECT
                          fase.id_fase,
                          fase.nombre as nombre_fase,
                          fase.codigo as codigo_fase,
                          fase.fecha_ini_real,
                          fase.fecha_fin_real,
                          fase.fecha_ini,
                          fase.fecha_fin,
                          fase.descripcion,
                          fase.fecha_reg
                      INTO
                          v_record_fase
                      FROM pro.tfase fase
                      WHERE fase.id_fase = v_hijo.id_fase;
                                                 
                     --si la fechas son null toman la fecha de hoy
                       IF v_record_fase.fecha_ini is null THEN
                           v_record_fase.fecha_ini = now()::DATE;
                       END IF;
                        IF v_record_fase.fecha_ini_real is null THEN
                           v_record_fase.fecha_ini_real = now()::DATE;
                       END IF;
                        IF v_record_fase.fecha_fin is null THEN
                           v_record_fase.fecha_fin = now()::DATE;
                       END IF;
                        IF v_record_fase.fecha_fin_real is null THEN
                           v_record_fase.fecha_fin_real = now()::DATE;
                       END IF;   
                    --verificamos si es padre nodo     
                      IF  (SELECT
                            count(fase.id_fase_fk)
                      FROM    pro.tfase fase
                      WHERE   fase.id_fase_fk = v_hijo.id_fase) <> 0 THEN
                           v_padre = true;
                           v_agrupador = true;                           
                      END IF ;
                      
                      IF  (SELECT
                            count(facoing.id_fase_concepto_ingas)
                           FROM    pro.tfase_concepto_ingas facoing
                           WHERE   facoing.id_fase = v_hijo.id_fase) <> 0 THEN
                           v_padre = true;
                           v_agrupador = true;                    
                       END IF ;
                       v_duplicado = false;                                  
                       v_item = false;                                 
         
         --insertamos el nodo  del proyecto si no existe en la tabla
                INSERT INTO temp_arbol_proyecto(
                                            id_fase,
                                            codigo_fase, 
                                            nombre_fase,
                                            fecha_ini,
                                            fecha_fin,
                                            padre,
                                            descripcion,
                                            fecha_ini_real,
                                            fecha_fin_real,
                                            agrupador,
                                            duplicado,
                                            item

                  ) VALUES(
                      v_record_fase.id_fase,
                      v_record_fase.codigo_fase,
                      v_record_fase.nombre_fase,
                      v_record_fase.fecha_ini,
                       v_record_fase.fecha_fin,
                      v_padre,
                      v_record_fase.descripcion,
                      v_record_fase.fecha_ini_real,
                      v_record_fase.fecha_fin_real,
                      v_agrupador,
                      v_duplicado,
                      v_item
                  ) RETURNING id into v_id;
     
                   --asociamos las id de fase con el nuevo id 
                    insert into temp_id(
                        id_fase,
                        id 
                                    )VALUES(
                         v_record_fase.id_fase,
                         v_id
                                    );    
            --luego los demas nodos tomaran sus respectivas fk 
           
                  SELECT    
                    id
                  INTO
                   v_id_fk
                  FROM    temp_id    
                  WHERE id_fase = v_hijo.id_fase_fk;
                  
              --asociamos la fk  respectivas
                  update temp_arbol_proyecto 
                   set id_fk = v_id_fk
                  Where id = v_id;
               -- si contiene nodos hijos se insertan recursivamente
                   IF  (SELECT
                            count(fase.id_fase_fk)
                   FROM    pro.tfase fase
                   WHERE   fase.id_fase_fk = v_hijo.id_fase) <> 0 THEN
                    v_resp = pro.f_gant_item_recursivo_pro(v_hijo.id_fase);
                   END IF ;
         --##### Ingresamos los concepto de gas como hijos de la fase si existen
               v_fase_concepto_ingas = false;
               IF  (SELECT
                            count(facoing.id_fase_concepto_ingas)
                   FROM    pro.tfase_concepto_ingas facoing
                   WHERE   facoing.id_fase = v_hijo.id_fase) <> 0 THEN
                   v_fase_concepto_ingas = true;                   
               END IF ; 
               IF v_fase_concepto_ingas = true THEN
                FOR  v_record_facoing IN (

                   SELECT   
                            fascon.id_fase_concepto_ingas,
                            fase.nombre as nombre_fase,
                            fascon.codigo as codigo_fase,
                            fascon.fecha_estimada as fecha_ini,
                            fascon.fecha_fin as fecha_fin,
                            now()::date as fecha_ini_real,
                            fase.fecha_fin_real,
                            fascon.descripcion,
                            coin.desc_ingas,
                            fun.desc_funcionario1::varchar as funcionario
                  FROM pro.tfase_concepto_ingas fascon 
                      left JOIN pro.tfase fase on fase.id_fase = fascon.id_fase
                      left join param.tconcepto_ingas coin on coin.id_concepto_ingas = fascon.id_concepto_ingas
                      left join orga.vfuncionario fun on fun.id_funcionario = fascon.id_funcionario
                      WHERE fascon.id_fase = v_hijo.id_fase
                      ORDER BY fascon.id_fase_concepto_ingas
                      )LOOP
                --recuperamos la fehas reales de lanzamiento de las solicitudes y presolicitudes que estan en el campo fecha_real                    
                       SELECT       
                          MIN(inv.fecha_real)
                       INTO
                          v_fecha_ini_real                 
                       FROM pro.tinvitacion_det invd
                       Left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                       WHERE invd.id_fase_concepto_ingas = v_record_facoing.id_fase_concepto_ingas;
                       --fechas que no se utilizan por que ahora se utiliza la duplicacion de items en el gantt                  
                       
                       
                 v_num = 2;
                 FOR i IN 1..v_num LOOP
                      v_padre = false;
                      v_item =true;
                      v_agrupador = false;
                    IF i = 1 THEN
                      v_duplicado = FALSE;
                          IF v_record_facoing.fecha_ini is null THEN
                              v_fecha_ini = now()::DATE;
                          ELSE
                              v_fecha_ini = v_record_facoing.fecha_ini; 
                          END IF;
                          
                          IF v_record_facoing.fecha_fin is null THEN
                              v_fecha_fin = now()::DATE;
                          ELSE
                              v_fecha_fin = v_record_facoing.fecha_fin; 
                          END IF;                                      
                    ELSE
                      v_duplicado = true;
                          IF v_fecha_ini_real is null THEN
                              v_fecha_ini = now()::DATE;
                          ELSE
                              v_fecha_ini = v_fecha_ini_real; 
                          END IF;
                          
                          IF v_fecha_fin_real is null THEN
                              v_fecha_fin = now()::DATE;
                          ELSE
                              v_fecha_fin = v_fecha_fin_real; 
                          END IF; 
                    END IF;
                    

                              --insertamos el nodo del proyecto o el item tabla
                        INSERT INTO temp_arbol_proyecto(
                                                    codigo_fase, 
                                                    nombre_fase,
                                                    fecha_ini,
                                                    fecha_fin,
                                                    fecha_ini_real,
                                                    fecha_fin_real,
                                                    padre,
                                                    descripcion,                                        
                                                    desc_ingas,
                                                    item,
                                                    agrupador,
                                                    duplicado,
                                                    funcionario
                          ) VALUES(
                              v_record_facoing.codigo_fase,
                              v_record_facoing.nombre_fase,
                              v_fecha_ini,
                              v_fecha_fin,
                              v_fecha_ini_real,
                              v_fecha_fin_real,
                              v_padre,
                              v_record_facoing.descripcion,
                              v_record_facoing.desc_ingas,
                              v_item,
                              v_agrupador,
                              v_duplicado,
                              v_record_facoing.funcionario
                          )RETURNING id into v_id;
     
                   --asociamos las id de fase con el nuevo id 
                      insert into temp_id(
                          id_fase,
                          id,
                          duplicado,
                          id_fase_concepto_ingas 
                                      )VALUES(
                             v_hijo.id_fase,
                             v_id,
                             v_duplicado,
                             v_record_facoing.id_fase_concepto_ingas
                                      );
                         SELECT    
                            id
                          INTO
                             v_id_fk
                          FROM    temp_id    
                          WHERE id_fase = v_hijo.id_fase_fk;                         
                          
                          Update temp_arbol_proyecto 
                          set id_fk = v_id_fk
                          Where id = v_id;
                        END LOOP;        
                    END LOOP;
             END IF;
        
  END LOOP;
 return v_resp;
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