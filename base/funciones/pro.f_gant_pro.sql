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


 DESCRIPCION:   
 AUTOR:         
 FECHA:         
***************************************************************************/


DECLARE


v_parametros  		record;
v_nombre_funcion   	text;
v_resp				varchar;

v_nodos				record;
v_fases				record;
v_registros			record;
v_record_fase		record;
v_record_fa			record;
v_record_temp_arbol_proyecto	record;
v_record_temp_arbol_proyecto_hijos	record;
v_hijos				record;
temp_data			record;

p_id_proyecto		integer;
v_orden				varchar;
v_id				integer;
v_id_fk		integer;
v_id_proceso		integer;
v_padre				boolean;
v_id_fase_fk		integer;
v_item				varchar;


BEGIN



    v_nombre_funcion = 'pro.f_gant_pro';
    
    
     v_parametros = pxp.f_get_record(p_tabla);
    
    
    /*********************************    
 	#TRANSACCION:  'PRO_GATNREPRO_SEL'
 	#DESCRIPCION:	Consulta del diagrama gant del PRO
 	#AUTOR:		EGS
 	#FECHA:		
	***********************************/

	IF(p_transaccion='PRO_GATNREPRO_SEL')then
    
    
    BEGIN
    p_id_proyecto = v_parametros.id_proyecto;
    --p_id_proyecto = 1;
	--raise exception 'hola %',v_parametros.id_proyecto;
   
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
                                      padre 		boolean,
                                      descripcion varchar
                                     ) ON COMMIT DROP;	
                                     
     --tabla temporal para asociar y guardar los ids para recrear el arbol
          CREATE TEMPORARY TABLE temp_id(
                                      id integer,
                                      id_fase integer
                                     ) ON COMMIT DROP;	
    
   --importante que este ordenado que los padres esten antes de los hijos para que los ids nuevos esten bien y el arbol tome forma                                  
   FOR v_nodos IN(
   --recuperando todos los nodos o fases del proyecto
   		WITH RECURSIVE proyectos AS (
         SELECT
         proy.id_proyecto,
         0::integer id_fase,
         0::integer as id_fase_fk,
         proy.nombre as nombre_proyecto,
         ''::varchar as codigo_fase,
         ''::varchar as nombre_fase
         
         FROM pro.tproyecto proy
         where proy.id_proyecto=p_id_proyecto
         UNION

             SELECT
             fas.id_proyecto,
             fas.id_fase,
             fas.id_fase_fk,
             ''::varchar(150) as nombre_proyecto,
             fas.codigo as codigo_fase,
             fas.nombre as nombre_fase
             FROM pro.tfase fas
             INNER JOIN proyectos p ON p.id_proyecto = fas.id_proyecto)
          SELECT
           *
          FROM proyectos 

          order by proyectos.id_fase ASC)LOOP 

            --el proyecto se inserta como una fase mas pero es la principal asi que lleva id 1
         	 IF v_nodos.id_fase = 0 THEN
            	SELECT 
                    proy.nombre as nombre_fase,
                    proy.codigo as codigo_fase,
                    proy.fecha_ini_real,
                    proy.fecha_fin_real,
                    proy.fecha_ini,
                    proy.fecha_fin,
                    proy.nombre as descripcion,
                    proy.fecha_reg
                  
                INTO
                	v_record_fase
                FROM pro.tproyecto proy
                WHERE  proy.id_proyecto = v_nodos.id_proyecto ;
               	v_padre = true;	
             ELSE 
             	SELECT
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
               	FROM	pro.tfase fase
               	WHERE   fase.id_fase_fk = v_nodos.id_fase) <> 0 THEN
               		v_padre = true;
            	END IF ;
              
             END IF;
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
             
		 --insertamos el nodo  del proyecto si no existe en la tabla
                INSERT INTO temp_arbol_proyecto(
                                            codigo_fase, 
                                            nombre_fase,
                                            fecha_ini,
                                            fecha_fin,
                                            padre,
                                            descripcion,
                                            fecha_ini_real,
                                            fecha_fin_real 	
                  ) VALUES(
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
                         v_nodos.id_fase,
                           v_id
                                    );	
				
           
             --para agrupar las fases con el proyecto y este sea la raiz del gantt
    		v_padre = false;
            if v_nodos.id_fase_fk is null then
             update temp_arbol_proyecto 
             set id_fk = 1
             Where id = v_id;
             
             --luego los demas nodos tomaran sus respectivas fk 
            elsif  v_nodos.id_fase_fk is not null and v_nodos.id_fase_fk <> 0 then 
                  SELECT	
                    id
                  INTO
                     v_id_fk
                  FROM	temp_id	
                  WHERE id_fase = v_nodos.id_fase_fk;
                  
             --asociamos la fk  respectivas
               IF	v_id_fk is not null THEN
                     update temp_arbol_proyecto 
                     set id_fk = v_id_fk
                      Where id = v_id;
               END IF;
            	
                         
            end if;
   				
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
                                      etapa		varchar,
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
                    dias,
                    dias_real, 
                    descripcion, 
                    id_siguiente,
                    tramite,
                    codigo,
                    id_padre,
                    id_anterior,
                    grupo
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
                   	temp_data.padre
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
 	#DESCRIPCION:	Consulta del diagrama gant del Proyecto con items
 	#AUTOR:		egs	
 	#FECHA:		
	***********************************/

	ELSIF(p_transaccion='PRO_GATNREPIT_SEL')then
    
    BEGIN
    
    p_id_proyecto = v_parametros.id_proyecto;
    --p_id_proyecto = 1;
	--raise exception 'hola %',v_parametros.id_proyecto;
   
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
                                      padre 		boolean,
                                      descripcion varchar,
                                      id_fase_concepto_ingas INTEGER,
                                      desc_ingas	varchar,
                                      nombre_padre	varchar,
                                      fecha_ini_item date,
                                      fecha_fin_item date
                                     ) ON COMMIT DROP;	
                                     
     --tabla temporal para asociar y guardar los ids para recrear el arbol
          CREATE TEMPORARY TABLE temp_id(
                                      id integer,
                                      id_fase integer
                                     ) ON COMMIT DROP;	
    
   --importante que este ordenado que los padres esten antes de los hijos para que los ids nuevos esten bien y el arbol tome forma                                  
   FOR v_nodos IN(
   --recuperando todos los nodos o fases del proyecto
   	WITH RECURSIVE proyectos AS (
         SELECT
         proy.id_proyecto,
         0::integer id_fase,
         0::integer as id_fase_fk,
         proy.nombre as nombre_proyecto,
         ''::varchar as nombre_padre,
         ''::varchar as codigo_fase,
         ''::varchar as nombre_fase,
         0::integer as id_fase_concepto_ingas,
         ''::varchar as desc_ingas,
         proy.fecha_ini,
         proy.fecha_fin
         FROM pro.tproyecto proy
         where proy.id_proyecto= p_id_proyecto
         UNION

             SELECT
             fas.id_proyecto,
             fas.id_fase,
             NULL::integer as id_fase_fk,
             ''::varchar(150) as nombre_proyecto,
             fass.nombre as nombre_padre,
             fas.codigo as codigo_fase,
             fas.nombre as nombre_fase,
             fascon.id_fase_concepto_ingas,
             coin.desc_ingas,
             fascon.fecha_estimada as fecha_ini,
             fascon.fecha_fin
             FROM pro.tfase fas
             left JOIN pro.tfase_concepto_ingas fascon on fascon.id_fase=fas.id_fase
             left join param.tconcepto_ingas coin	on coin.id_concepto_ingas = fascon.id_concepto_ingas
             left JOIN pro.tfase fass on fass.id_fase=fas.id_fase_fk
             INNER JOIN proyectos p ON p.id_proyecto = fas.id_proyecto)
          SELECT
           *
          FROM proyectos pr
          where pr.id_fase_concepto_ingas is not null
          order by pr.id_fase ASC)LOOP 

            --el proyecto se inserta como una fase mas pero es la principal asi que lleva id 1
         	 IF v_nodos.id_fase = 0 THEN
            	SELECT 
                    proy.nombre as nombre_fase,
                    proy.codigo as codigo_fase,
                    proy.fecha_ini_real,
                    proy.fecha_fin_real,
                    proy.fecha_ini,
                    proy.fecha_fin,
                    proy.nombre as descripcion,
                    proy.fecha_reg,
                    ''::varchar as nombre_padre,
                    0::integer as id_fase_concepto_ingas,
                    ''::varchar as desc_ingas,
                  	'01/12/2018'::date as fecha_ini_item,
                   	'01/12/2018'::date as fecha_fin_item
                INTO
                	v_record_fase
                FROM pro.tproyecto proy
                WHERE  proy.id_proyecto = v_nodos.id_proyecto ;
               	v_padre = true;	

             ELSE 
             	---fases
             	SELECT
                	fase.nombre as nombre_fase,
                    fase.codigo as codigo_fase,
                    fase.fecha_ini_real,
                    fase.fecha_fin_real,
                    fase.fecha_ini,
                    fase.fecha_fin,
                    fase.descripcion,
                    fase.fecha_reg,
                    fass.nombre as nombre_padre,
                    fascon.id_fase_concepto_ingas,
                    coin.desc_ingas,
                    fascon.fecha_estimada as fecha_ini_item,
                    fascon.fecha_fin as fecha_fin_item
                INTO
                	v_record_fase
                FROM pro.tfase fase
               	left JOIN pro.tfase_concepto_ingas fascon on fascon.id_fase=fase.id_fase
             	left join param.tconcepto_ingas coin	on coin.id_concepto_ingas = fascon.id_concepto_ingas
             	left JOIN pro.tfase fass on fass.id_fase=fase.id_fase_fk
                WHERE fascon.id_fase_concepto_ingas = v_nodos.id_fase_concepto_ingas;
              --verificamos si es padre nodo 
               IF  (SELECT
                      count(fase.id_fase_fk)
               	FROM	pro.tfase fase
               	WHERE   fase.id_fase_fk = v_nodos.id_fase) <> 0 THEN
               		v_padre = true;
            	END IF ;
              
             END IF;
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
             
		 --insertamos el nodo  del proyecto si no existe en la tabla
                INSERT INTO temp_arbol_proyecto(
                                            codigo_fase, 
                                            nombre_fase,
                                            fecha_ini,
                                            fecha_fin,
                                            padre,
                                            descripcion,
                                            fecha_ini_real,
                                            fecha_fin_real,
                                            nombre_padre,
                                            id_fase_concepto_ingas,
                                            desc_ingas,
                                            fecha_ini_item,
                                            fecha_fin_item 	
                  ) VALUES(
                      v_record_fase.codigo_fase,
                      v_record_fase.nombre_fase,
                      v_record_fase.fecha_ini,
      				  v_record_fase.fecha_fin,
                      v_padre,
                      v_record_fase.descripcion,
                      v_record_fase.fecha_ini_real,
      				  v_record_fase.fecha_fin_real,
                      v_record_fase.nombre_padre,
                      v_record_fase.id_fase_concepto_ingas,
                      v_record_fase.desc_ingas,
                      v_record_fase.fecha_ini_item,
                      v_record_fase.fecha_fin_item
                  ) RETURNING id into v_id;
     
                   --asociamos las id de fase con el nuevo id 
                    insert into temp_id(
                        id_fase,
                        id 
                                    )VALUES(
                         v_nodos.id_fase,
                           v_id
                                    );	
				
           
             --para agrupar las fases con el proyecto y este sea la raiz del gantt
    		v_padre = false;
            if v_nodos.id_fase_fk is null then
             update temp_arbol_proyecto 
             set id_fk = 1
             Where id = v_id;
             
             --luego los demas nodos tomaran sus respectivas fk 
            elsif  v_nodos.id_fase_fk is not null and v_nodos.id_fase_fk <> 0 then 
                  SELECT	
                    id
                  INTO
                     v_id_fk
                  FROM	temp_id	
                  WHERE id_fase = v_nodos.id_fase_fk;
                  
             --asociamos la fk  respectivas
               IF	v_id_fk is not null THEN
                     update temp_arbol_proyecto 
                     set id_fk = v_id_fk
                      Where id = v_id;
               END IF;
            	
                         
            end if;
   				
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
                                      etapa		varchar,
                                      estado_reg varchar,
                                      disparador varchar,
                                      grupo boolean,
                                      nombre_padre varchar,
                                      item varchar,
                                      desc_item varchar,
                                      fecha_ini_item date,
                                      fecha_fin_item date
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
            fecha_fin_real,
            nombre_padre,
            id_fase_concepto_ingas,
            desc_ingas,
            fecha_ini_item,
            fecha_fin_item         	
        from temp_arbol_proyecto 
        ORDER by id  ASC
        )LOOP
        	v_item='no';
        	if temp_data.id_fase_concepto_ingas is not null then
        		v_item = 'si';
			end if;
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
                    dias,
                    dias_real, 
                    descripcion, 
                    id_siguiente,
                    tramite,
                    codigo,
                    id_padre,
                    id_anterior,
                    grupo,
                    nombre_padre,
                    item,
                    desc_item,
                    fecha_ini_item,
                    fecha_fin_item
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
                    temp_data.nombre_padre,
					v_item,
                    temp_data.desc_ingas,
                    temp_data.fecha_ini_item,
                    temp_data.fecha_fin_item
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
                                  grupo,
                                  nombre_padre,
                                  item,
                                  desc_item,
                                  fecha_ini_item,
                                  fecha_fin_item
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
