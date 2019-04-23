CREATE OR REPLACE FUNCTION pro.f_gant_recursivo_pro (
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
v_parametros  		record;
v_nombre_funcion   	text;
v_resp				varchar;
v_record_fase      record;
v_hijo             record;
v_padre            boolean;
v_nro_padre        integer;
v_id                integer;
v_id_fk                integer;

BEGIN

    v_nombre_funcion = 'pro.f_gant_recursivo_pro';
    /*********************************    
     #TRANSACCION:  'PRO_GATNREPRO_SEL'
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
                    WHERE fase.id_fase_fk = p_id_fase )LOOP
             
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
                      END IF ;         
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
                                            fecha_fin_real
                  ) VALUES(
                      v_record_fase.id_fase,
                      v_record_fase.codigo_fase,
                      v_record_fase.nombre_fase,
                      v_record_fase.fecha_ini,
                       v_record_fase.fecha_fin,
                      v_padre,
                      v_record_fase.descripcion,
                      v_record_fase.fecha_ini_real,
                      v_record_fase.fecha_fin_real
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
                  FROM	temp_id	
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
                    v_resp = pro.f_gant_recursivo_pro(v_hijo.id_fase);
                   END IF ;   
    
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