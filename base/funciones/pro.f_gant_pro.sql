CREATE OR REPLACE FUNCTION pro.f_gant_pro (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       pro.f_gant_pro
                
 DESCRIPCION:   recolecta los datos de las fases del proyecto para la creacion del gantt en tipo arbol exclusivo para la vista de proyectos
 AUTOR:       
 FECHA:        
 COMENTARIOS: 

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:
  #1				11/11/2018				EGS					Creacion
  #10 EndeEtr       05/04/2019              EGS                 Se reformulo la logica para que los datos retornen en el orden del arbol por id

 DESCRIPCION:   
 AUTOR:         
 FECHA:         
***************************************************************************/


DECLARE


v_parametros                record;
v_nombre_funcion            text;
v_resp                      varchar;

v_nodos                     record;
v_fases                     record;
v_registros                 record;
v_record_fase               record;
v_record_fa                 record;
v_record_temp_arbol_proyecto    record;
v_record_temp_arbol_proyecto_hijos    record;
v_hijos                     record;
temp_data                   record;

p_id_proyecto               integer;
v_orden                     record;
v_id                        integer;
v_id_fk                     integer;
v_id_proceso                integer;
v_padre                     boolean;
v_id_fase_fk                integer;
v_item                      BOOLEAN;
v_duplicado                 boolean;
v_agrupador                 boolean;
v_num                       integer;
v_count                     integer;
v_id_fase_concepto_ingas    integer;
v_record_proyecto           record;
v_id_fase                   integer;



BEGIN



    v_nombre_funcion = 'pro.f_gant_pro';
    
    
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************    
     #TRANSACCION:  'PRO_GATNREPRO_SEL'
     #DESCRIPCION:    Consulta del diagrama gant del PRO para modificar aqui modificar tambien pro.f_gant_recursivo_pro
     #AUTOR:        EGS
     #FECHA:        
    ***********************************/

    IF(p_transaccion='PRO_GATNREPRO_SEL')then
    
    
    BEGIN
    p_id_proyecto = v_parametros.id_proyecto;
    --p_id_proyecto = 1;
  
   -- 1) Crea una tabla temporal con los datos que se utilizaran 
   CREATE TEMPORARY TABLE temp_arbol_proyecto(
                                      id serial,
                                      id_fk integer,
                                      id_fase integer,
                                      id_fase_fk integer,
                                      codigo_fase varchar, 
                                      nombre_fase VARCHAR,
                                      fecha_ini timestamp,
                                      fecha_fin     timestamp,
                                      fecha_ini_real timestamp,
                                      fecha_fin_real     timestamp,
                                      padre         boolean,
                                      descripcion varchar
                                     ) ON COMMIT DROP;    
                                     
     --tabla temporal para asociar y guardar los ids para recrear el arbol
          CREATE TEMPORARY TABLE temp_id(
                                      id integer,
                                      id_fase integer
                                     ) ON COMMIT DROP;    
   
   --Insertamos el proyecto como primer dato
                   SELECT 
                    proy.nombre,
                    proy.codigo,
                    proy.fecha_ini_real,
                    proy.fecha_fin_real,
                    proy.fecha_ini,
                    proy.fecha_fin,
                    proy.nombre as descripcion,
                    proy.fecha_reg                
                INTO
                    v_record_proyecto
                FROM pro.tproyecto proy
                WHERE  proy.id_proyecto = p_id_proyecto ;
                   v_padre = true;    
                    --insertamos el proyecto en la tabla como primer dato
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
                      0,
                      v_record_proyecto.codigo,
                      v_record_proyecto.nombre,
                      v_record_proyecto.fecha_ini,
                        v_record_proyecto.fecha_fin,
                      v_padre,
                      v_record_proyecto.descripcion,
                      v_record_proyecto.fecha_ini_real,
                       v_record_proyecto.fecha_fin_real
                  ) RETURNING id into v_id;
                  
                   --asociamos las id del proyecto con el nuevo id 
                    insert into temp_id(
                        id_fase,
                        id 
                                    )VALUES(
                        0,
                        v_id
                           );
   --Recuperamos las fases que si tengas fk
   FOR v_nodos IN(
   --recuperando los nodos padre de las fases del proyecto
         SELECT 
                fase.id_fase,
                fase.id_fase_fk
         FROM pro.tfase fase
         WHERE fase.id_fase_fk is null and fase.id_proyecto = p_id_proyecto 
         ORDER BY fase.id_fase_fk, fase.codigo ASC )LOOP 
            v_padre = false ;
    --insertamos el nodo 
                      
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
                      WHERE fase.id_fase = v_nodos.id_fase;
                    --verificamos si es padre nodo 
                     IF  (SELECT
                            count(fase.id_fase_fk)
                      FROM    pro.tfase fase
                      WHERE   fase.id_fase_fk = v_nodos.id_fase) <> 0 THEN
                           v_padre = true;    
                     END IF ;
                                         
                    --insertamos el nodo padre 
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
                   --asociamos como padre del nodo al primer registro que se hizo que es el proyecto   
                  IF v_nodos.id_fase_fk is null THEN
                       update temp_arbol_proyecto 
                       set id_fk = 1
                       Where id = v_id;
                  END IF;
                  --verificamos si es padre si es padre recursivamente insertamos los hijos 
                  IF  (SELECT
                            count(fase.id_fase_fk)
                  FROM    pro.tfase fase
                     WHERE   fase.id_fase_fk = v_nodos.id_fase) <> 0 THEN
                         v_id_fase =v_nodos.id_fase;
                         v_resp = pro.f_gant_recursivo_pro(v_id_fase::integer); 
                  END IF ;
    END LOOP;

    --creamos la tabla temporal con la estructura del gantt del sistema wf añadiendo algunos parametros q solo estan en el gantt del proyecto
     CREATE TEMPORARY TABLE temp_gant_pro (
                                      id SERIAL,
                                      id_fk integer,
                                      id_proceso_wf integer,
                                      id_estado_wf integer,
                                      tipo varchar, 
                                      nombre VARCHAR, 
                                      fecha_ini TIMESTAMP, 
                                      fecha_fin TIMESTAMP,
                                      fecha_ini_real TIMESTAMP, 
                                      fecha_fin_real TIMESTAMP,
                                      dias  INTEGER,
                                      dias_real INTEGER, 
                                      descripcion VARCHAR, 
                                      id_siguiente integer,
                                      tramite varchar,
                                      codigo varchar,
                                      id_funcionario integer,
                                      funcionario text,
                                      id_usuario INTEGER,
                                      cuenta varchar,
                                      id_depto integer,
                                      depto varchar,
                                      nombre_usuario_ai varchar,
                                      id_padre integer,
                                      arbol varchar,
                                      id_obs integer,
                                      id_anterior integer,
                                      etapa        varchar,
                                      estado_reg varchar,
                                      disparador varchar,
                                      grupo boolean
                                     ) ON COMMIT DROP;
    
    --insertamos los datos necesarios en la tabla que se usara para representar el gantt    
        FOR temp_data in (
        SELECT
              id,
            id_fk,
            codigo_fase, 
            nombre_fase,
            fecha_ini,
            fecha_fin,
            (fecha_fin::date - fecha_ini::date)::integer as dias,
            (fecha_fin_real::date - fecha_ini_real::date)::integer as dias_real,
            padre,
            descripcion,
            fecha_ini_real,
            fecha_fin_real     
        from temp_arbol_proyecto 
        ORDER by id  ASC
        )LOOP

             --raise exception '% ',temp_data;
            INSERT INTO      
           temp_gant_pro (
                       id,
                    id_proceso_wf,
                    id_estado_wf,
                    tipo, 
                    nombre, 
                    fecha_ini, 
                    fecha_fin,
                    fecha_ini_real, 
                    fecha_fin_real,
                    dias,
                    dias_real, 
                    descripcion, 
                    id_siguiente,
                    tramite,
                    codigo,
                    id_padre,
                    id_anterior,
                    grupo,
                    id_fk
                   )
                   VALUES(
                   temp_data.id,
                    null,
                    NULL,--id_estado_wf,
                    NULL,--'proceso', 
                    temp_data.nombre_fase,--nombre, 
                    temp_data.fecha_ini,--fecha_ini, 
                    temp_data.fecha_fin,--fecha_fin,
                    temp_data.fecha_ini_real,--fecha_ini, 
                    temp_data.fecha_fin_real,--fecha_fin,
                    temp_data.dias,
                       temp_data.dias_real, 
                       temp_data.descripcion,--descripcion,
                    NULL,-- id_siguiente,
                    NULL,--nro_tramite,
                    temp_data.codigo_fase,--codigo,
                    temp_data.id_fk,--id_padre,
                       temp_data.id_fk,--p_id_anterior
                       temp_data.padre,
                    temp_data.id_fk
                   ) RETURNING id into v_id_proceso;
        
        
        END LOOP;
            --devolvemos los registros para su propia captura en el modelo
             FOR v_registros in (SELECT                                   
                                  id ,
                                  id_proceso_wf ,
                                  id_estado_wf ,
                                  tipo , 
                                  nombre , 
                                  fecha_ini , 
                                  fecha_fin ,
                                  fecha_ini_real , 
                                  fecha_fin_real ,
                                  dias,
                                  dias_real,  
                                  descripcion , 
                                  id_siguiente ,
                                  tramite ,
                                  codigo ,
                                  COALESCE(id_funcionario,0) ,
                                  funcionario ,
                                  COALESCE(id_usuario,0),
                                  cuenta ,
                                  COALESCE(id_depto,0),
                                  depto,
                                  COALESCE(nombre_usuario_ai,''),
                                  arbol,
                                  id_padre,
                                  id_obs,
                                  id_anterior,
                                  etapa,
                                  estado_reg,
                                  disparador,
                                  grupo
                                FROM temp_gant_pro 
                                order by id ASC) LOOP
               RETURN NEXT v_registros;
             END LOOP;
          END;
        
        /*********************************    
     #TRANSACCION:  'PRO_GATNREPIT_SEL'
     #DESCRIPCION:    Consulta del diagrama gant del Proyecto con items
     #AUTOR:        egs    
     #FECHA:        
    ***********************************/

    ELSIF(p_transaccion='PRO_GATNREPIT_SEL')then
    
    BEGIN
    
    p_id_proyecto = v_parametros.id_proyecto;
    --p_id_proyecto = 1;
    --raise exception 'hola %',v_parametros.id_proyecto;
   
   -- 1) Crea una tabla temporal con los datos que se utilizaran 
        
   CREATE TEMPORARY TABLE temp_arbol_proyecto(
                                      id                 serial,
                                      id_fk             integer,
                                      id_fase           INTEGER,
                                      id_padre            INTEGER,
                                      codigo_fase         varchar, 
                                      nombre_fase         VARCHAR,
                                      fecha_ini         timestamp,
                                      fecha_fin         timestamp,
                                      fecha_ini_real     timestamp,
                                      fecha_fin_real    timestamp,
                                      padre             boolean,
                                      descripcion         varchar,
                                      desc_ingas        varchar,
                                      item                boolean,
                                      agrupador            BOOLEAN,
                                      duplicado            boolean,         ---true si es copia del item solo que con las fechas reales
                                      funcionario       varchar
                                     ) ON COMMIT DROP;    
                                     
     --tabla temporal para asociar y guardar los ids para recrear el arbol
          CREATE TEMPORARY TABLE temp_id(
                                      id integer,
                                      id_fase integer,
                                      duplicado boolean,
                                      id_fase_concepto_ingas integer
                                     ) ON COMMIT DROP; 
                                     
                                     
     --Insertamos el proyecto como primer dato
                   SELECT 
                    proy.nombre,
                    proy.codigo,
                    proy.fecha_ini_real,
                    proy.fecha_fin_real,
                    proy.fecha_ini,
                    proy.fecha_fin,
                    proy.nombre as descripcion,
                    proy.fecha_reg                
                INTO
                    v_record_proyecto
                FROM pro.tproyecto proy
                WHERE  proy.id_proyecto = p_id_proyecto ;
                   v_padre = true;
                   v_agrupador = true;
                   v_duplicado = false;
                   v_item = false;    
                    --insertamos el proyecto en la tabla como primer dato
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
                      0,
                      v_record_proyecto.codigo,
                      v_record_proyecto.nombre,
                      v_record_proyecto.fecha_ini,
                      v_record_proyecto.fecha_fin,
                      v_padre,
                      v_record_proyecto.descripcion,
                      v_record_proyecto.fecha_ini_real,
                      v_record_proyecto.fecha_fin_real,
                      v_agrupador,
                      v_duplicado,
                      v_item
                  ) RETURNING id into v_id;
                  
                   --asociamos las id del proyecto con el nuevo id 
                    insert into temp_id(
                        id_fase,
                        id 
                                    )VALUES(
                        0,
                        v_id
                           );
   FOR v_nodos IN(
        --recuperando los nodos padre de las fases del proyecto
         SELECT 
                fase.id_fase,
                fase.id_fase_fk
         FROM pro.tfase fase
         WHERE fase.id_fase_fk is null and fase.id_proyecto = p_id_proyecto 
         ORDER BY fase.id_fase_fk, fase.codigo ASC
    
    )LOOP 
             
                --insertamos el nodo padre
                        SELECT
                            fase.id_fase,
                            fase.nombre as nombre_fase,
                            fase.codigo as codigo_fase,
                            fase.fecha_ini,
                            fase.fecha_fin,
                            fase.fecha_ini_real,
                            fase.fecha_fin_real,
                            fase.descripcion

                        INTO
                             v_record_fase
                        FROM pro.tfase fase
                        WHERE fase.id_fase = v_nodos.id_fase;
                        
                      --verificamos si es padre nodo 
                       IF  (SELECT
                              count(fase.id_fase_fk)
                        FROM    pro.tfase fase
                        WHERE   fase.id_fase_fk = v_nodos.id_fase) <> 0 THEN
                             v_padre = true;
                             v_agrupador = true;
                       END IF ;
                       v_duplicado = false;                                  
                       v_item = false;
                        --si las fechas son null colocamos la fecha de hoy    
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
                        INSERT INTO temp_arbol_proyecto(
                                                    id_fase,
                                                    codigo_fase, 
                                                    nombre_fase,
                                                    fecha_ini,
                                                    fecha_fin,
                                                    fecha_ini_real,
                                                    fecha_fin_real,
                                                    padre,
                                                    descripcion,                                        
                                                    agrupador,
                                                    duplicado,
                                                    item
                          ) VALUES(
                              v_record_fase.id_fase,
                              v_record_fase.codigo_fase,
                              v_record_fase.nombre_fase,
                              v_record_fase.fecha_ini,
                              v_record_fase.fecha_fin,
                              v_record_fase.fecha_ini_real,
                              v_record_fase.fecha_fin_real,
                              v_padre,
                              v_record_fase.descripcion,
                              v_agrupador,
                              v_duplicado,
                              v_item
                          )RETURNING id into v_id;
             
                           --asociamos las id de fase con el nuevo id  
                  insert into temp_id(
                            id_fase,
                            id 
                                        )VALUES(
                             v_record_fase.id_fase,
                             v_id
                                        ); 
                   --asociamos como padre del nodo al primer registro que se hizo que es el proyecto   
                  IF v_nodos.id_fase_fk is null THEN
                       update temp_arbol_proyecto 
                       set id_fk = 1
                       Where id = v_id;
                  END IF;
                  --verificamos si es padre si es padre recursivamente insertamos los hijos 
                  IF  (SELECT
                            count(fase.id_fase_fk)
                     FROM    pro.tfase fase
                     WHERE   fase.id_fase_fk = v_nodos.id_fase) <> 0 THEN
                         v_id_fase =v_nodos.id_fase;
                         v_resp = pro.f_gant_item_recursivo_pro(v_id_fase::integer); 
                  END IF ; 
    END LOOP;

    --creamos la tabla temporal con la estructura del gantt del sistema wf añadiendo algunos parametros q solo estan en el gantt del proyecto
     CREATE TEMPORARY TABLE temp_gant_pro (
                                      id SERIAL,
                                      id_proceso_wf integer,
                                      id_estado_wf integer,
                                      tipo varchar, 
                                      nombre VARCHAR, 
                                      fecha_ini TIMESTAMP, 
                                      fecha_fin TIMESTAMP,
                                      fecha_ini_real TIMESTAMP, 
                                      fecha_fin_real TIMESTAMP,
                                      descripcion VARCHAR, 
                                      id_siguiente integer,
                                      tramite varchar,
                                      codigo varchar,
                                      id_funcionario integer,
                                      funcionario text,
                                      id_usuario INTEGER,
                                      cuenta varchar,
                                      id_depto integer,
                                      depto varchar,
                                      nombre_usuario_ai varchar,
                                      id_padre integer,
                                      arbol varchar,
                                      id_obs integer,
                                      id_anterior integer,
                                      etapa        varchar,
                                      estado_reg varchar,
                                      disparador varchar,
                                      agrupador boolean,
                                      item varchar,
                                      desc_item varchar,
                                      duplicado BOOLEAN
                                     ) ON COMMIT DROP;
    
    --insertamos los datos necesarios en la tabla que se usara para representar el gantt    
        
        FOR temp_data in (
        SELECT
              id,
            id_fk,
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
            duplicado,funcionario
        from temp_arbol_proyecto 
        ORDER by id  ASC
        )LOOP
            
             --raise exception '% ',v_dias;
            INSERT INTO      
           temp_gant_pro (
                       id,
                    id_proceso_wf,
                    id_estado_wf,
                    tipo, 
                    nombre, 
                    fecha_ini, 
                    fecha_fin,
                    fecha_ini_real, 
                    fecha_fin_real,
                    descripcion, 
                    id_siguiente,
                    tramite,
                    codigo,
                    id_padre,
                    id_anterior,
                    agrupador,
                    item,
                    desc_item,
                    duplicado,
                    funcionario
                   )
                   VALUES(
                   temp_data.id,
                    null,
                    NULL,--id_estado_wf,
                    NULL,--'proceso', 
                    temp_data.nombre_fase,--nombre, 
                    temp_data.fecha_ini,--fecha_ini, 
                    temp_data.fecha_fin,--fecha_fin,
                    temp_data.fecha_ini_real,--fecha_ini, 
                    temp_data.fecha_fin_real,--fecha_fin,
                       temp_data.descripcion,--descripcion,
                    NULL,-- id_siguiente,
                    NULL,--nro_tramite,
                    temp_data.codigo_fase,--codigo,
                    temp_data.id_fk,--id_padre,
                       temp_data.id_fk,--p_id_anterior
                       temp_data.agrupador,
                    temp_data.item,
                    temp_data.desc_ingas,
                    temp_data.duplicado,
                    temp_data.funcionario::text
                   ) RETURNING id into v_id_proceso;
        
        
        END LOOP;
            --devolvemos los registros para su propia captura en el modelo
             FOR v_registros in (SELECT                                   
                                  id ,
                                  id_proceso_wf ,
                                  id_estado_wf ,
                                  tipo , 
                                  nombre , 
                                  fecha_ini , 
                                  fecha_fin ,
                                  fecha_ini_real , 
                                  fecha_fin_real ,
                                  descripcion , 
                                  id_siguiente ,
                                  tramite ,
                                  codigo ,
                                  COALESCE(id_funcionario,0) ,
                                  funcionario ,
                                  COALESCE(id_usuario,0),
                                  cuenta ,
                                  COALESCE(id_depto,0),
                                  depto,
                                  COALESCE(nombre_usuario_ai,''),
                                  arbol,
                                  id_padre,
                                  id_obs,
                                  id_anterior,
                                  etapa,
                                  estado_reg,
                                  disparador,
                                  agrupador,
                                  item,
                                  desc_item,
                                  duplicado
                                FROM temp_gant_pro 
                                order by id ASC) LOOP
               RETURN NEXT v_registros;
             END LOOP;
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
COST 100 ROWS 1000;