CREATE OR REPLACE FUNCTION pro.f_reportes_proyecto_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Proyectos
 FUNCION: 		pro.f_reportes_proyecto_sel
 DESCRIPCION:   Funcion para los diferentes reportes de proyectos
 AUTOR: 		 (EGS)
 FECHA:	        14/12/2018
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
 ISSUE			FECHA:			AUTOR:					DESCRIPCION:
 #5             09/01/2019      EGS                     Se agrego campo para cuantos dias pasaron desde el lanzamiento del item y si esta lanzado o no
 #6   Endeetr   24/01/2019      EGS                     Se modifico transaccion para que tome encuenta items sin un prorrateo en plan de pagos y validaciones para que funcione sin el nivel III y Nivel II
 #9   EndeEtr   26/03/2019      EGS                     Se aumento como un nivel a la fase de los items que se registran n el plan de pago
                                                        Se aumento el numero de tramite en los lanzamientos de items
 #15 ETR        31/07/2019      EGS                     Reportes para invitacion  

***************************************************************************/

DECLARE

    
	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_plan_pago				record;

    v_mes					varchar;
    v_columna				varchar;
    v_gestion				record;
    v_tabla					varchar;
    p_id_proyecto			integer;
    v_consulta				varchar;
    v_consulta_into			varchar;
    v_id					integer;
    v_record_plan			record;
    v_registros				record;
    v_count					integer;
    v_id_fase_concepto_ingas	integer;
    v_consulta_update		varchar;
    v_item					record;
    v_bandera				VARCHAR;
    dias_vigentes			integer;
    v_id_item				integer;
    v_record_fase			record;
    v_precio 			 	numeric;
	v_record_fase_padre		record;
    v_id_item_padre			integer;
    v_id_padre				integer;
    v_id_padre_II			integer;
    v_prorrateo             record;
    v_importe_padre_II      numeric;
    v_id_padre_I            numeric;
    v_record_proyecto       record;
BEGIN

    v_nombre_funcion = 'pro.f_reportes_proyecto_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'PRO_REPPAGO_SEL'
 	#DESCRIPCION:	Reporte de estimado del plan de pagos 
 	#AUTOR:		EGS
 	#FECHA:		14/12/2018
	***********************************/

	if(p_transaccion='PRO_REPPAGO_SEL')then

        begin
          --raise EXception 'v_parametros.id_proyecto %',v_parametros.id_proyecto;

        	 p_id_proyecto = v_parametros.id_proyecto;
             --p_id_proyecto = 74;
            SELECT
                pro.codigo
            into
            v_record_proyecto 
            FROM pro.tproyecto pro               
            WHERE pro.id_proyecto = p_id_proyecto ;
            
            Select 
                count(facoin.id_fase_concepto_ingas)--#6 
            INTO
            	v_count
            From pro.tfase_concepto_ingas facoin
            LEFT JOIN pro.tfase_concepto_ingas_pago facoinpa on facoinpa.id_fase_concepto_ingas = facoin.id_fase_concepto_ingas
            left join param.tconcepto_ingas coingas on coingas.id_concepto_ingas = facoin.id_concepto_ingas
            left join pro.tfase fase on fase.id_fase = facoin.id_fase--#6 
            Where  fase.id_proyecto = p_id_proyecto ;
            
            IF v_count is null or v_count = 0 THEN
            	RAISE EXCEPTION'No existe datos en plan de pago del proyecto';
            END IF;
            /* el nivel I pertenecen la fase de  los items
              el nivel II al padre fase del nivel I 
              el nivel III el padre del nivel II
            */
            	
            v_tabla='CREATE TEMPORARY TABLE plan_pago(
                                      id serial,
                                      id_nivel integer,
                                      id_nivel_I integer,
                                      id_nivel_II integer,
                                      id_nivel_III integer,                                      
                                      nivel integer,
                                      codigo varchar,
                                      id_fase_concepto_ingas integer,
                                      id_fase_concepto_ingas_pago integer,
                                      item varchar,
                                      precio_estimado numeric,
                                      precio_real numeric,
                                      total_prorrateo numeric,                               
                                      mes integer,';
                                      
             For v_gestion in (
                Select 
                    DISTINCT(date_part('year', facoinpa.fecha_pago))as anio
                From pro.tfase_concepto_ingas facoin
                LEFT JOIN pro.tfase_concepto_ingas_pago facoinpa on facoinpa.id_fase_concepto_ingas = facoin.id_fase_concepto_ingas
                left join param.tconcepto_ingas coingas on coingas.id_concepto_ingas = facoin.id_concepto_ingas
               left join pro.tfase fase on fase.id_fase = facoin.id_fase
				Where facoinpa.id_fase_concepto_ingas_pago is not null and fase.id_proyecto = p_id_proyecto
                 ORDER by anio ASC
             )LOOP                       
                              v_tabla =v_tabla ||'enero_'||v_gestion.anio||' numeric , 
                              			 febrero_'||v_gestion.anio||' numeric ,
                              			 marzo_'||v_gestion.anio||' numeric ,
                              			 abril_'||v_gestion.anio||' numeric , 
                              			 mayo_'||v_gestion.anio||' numeric ,
                                         junio_'||v_gestion.anio||' numeric ,
                                         julio_'||v_gestion.anio||' numeric ,
                                         agosto_'||v_gestion.anio||' numeric ,
                                         septiembre_'||v_gestion.anio||' numeric ,
                                         octubre_'||v_gestion.anio||' numeric ,
                                         noviembre_'||v_gestion.anio||' numeric ,
                                         diciembre_'||v_gestion.anio||' numeric,' ;    
                                   
              END LOOP;  
              v_tabla=v_tabla||'anio integer) ON COMMIT DROP';
              --Creación de la tabla temporal
            execute(v_tabla);
            
            v_count = 0;             	        	
        	FOR v_plan_pago in (
            	Select
                fassse.id_fase as id_padre_III,
                fassse.codigo as nombre_padre_III,
                fasse.id_fase as id_padre_II,
                fasse.codigo as nombre_padre_II,
                fase.codigo as codigo_padre_I, 
                fase.id_fase as id_padre_I ,
                facoinpa.id_fase_concepto_ingas_pago,
                facoin.id_fase_concepto_ingas,
                coingas.desc_ingas,
                facoin.precio as precio_real,
                facoin.precio_est as precio_estimado,
                facoinpa.fecha_pago,
                date_part('month',facoinpa.fecha_pago) as mes,
    			date_part('year', facoinpa.fecha_pago)as anio,
                facoinpa.importe,
                facoinpa.fecha_pago_real,
                facoin.codigo
            From pro.tfase_concepto_ingas facoin
            LEFT JOIN pro.tfase_concepto_ingas_pago facoinpa on facoinpa.id_fase_concepto_ingas = facoin.id_fase_concepto_ingas
            left join param.tconcepto_ingas coingas on coingas.id_concepto_ingas = facoin.id_concepto_ingas
            left join pro.tfase fase on fase.id_fase = facoin.id_fase
            left join pro.tfase fasse on fasse.id_fase = fase.id_fase_fk
            left join pro.tfase fassse on fassse.id_fase = fasse.id_fase_fk
            Where  
           --facoinpa.id_fase_concepto_ingas_pago is not null  and 
            fase.id_proyecto = p_id_proyecto 
            ORDER BY fasse.id_fase, fase.codigo  ASC)LOOP
            
                IF v_plan_pago.mes = 1	THEN
                	v_columna = 'enero_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 2	THEN
                	v_columna = 'febrero_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 3	THEN
                	v_columna = 'marzo_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 4	THEN
                	v_columna = 'abril_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 5	THEN
                 	v_columna = 'mayo_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 6	THEN
                	v_columna = 'junio_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 7 	THEN
                	v_columna = 'julio_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 8 	THEN
                	v_columna = 'agosto_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 9 	THEN
                 	v_columna = 'septiembre_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 10 	THEN
                	v_columna = 'octubre_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 11	THEN
                	v_columna = 'noviembre_'||v_plan_pago.anio;
                ELSIF v_plan_pago.mes = 12	THEN
                	v_columna = 'diciembre_'||v_plan_pago.anio;             
                END IF;

              ---se inserta al padre del grupo por nivel como item separador y agrupador  
              IF v_plan_pago.id_padre_III is not null THEN --#6 
             --verificamos si existe el nivel III 
                    Select
                          pla.id_nivel_III
                    into
                    v_id_padre 
                    From plan_pago pla
                    where pla.id_nivel_III = v_plan_pago.id_padre_III ;
                    --insertamos un nivel III si no existe
                     IF  v_id_padre is null then
                         Select
                              fase.id_fase,
                              fase.codigo,
                              fase.nombre,
                              fase.id_fase_fk
                          into
                          v_record_fase_padre
                          from pro.tfase fase
                          where  fase.id_fase = v_plan_pago.id_padre_III ;
                          
                          v_record_fase_padre.codigo = replace(v_record_fase_padre.codigo,'['||v_record_proyecto.codigo||']','');

                          v_consulta_into=' insert into plan_pago(
                                                   id_nivel_III,
                                                   nivel,
                                                   codigo,
                                                   item
                                                          )VALUES(
                                                   '||v_record_fase_padre.id_fase||',
                                                   '||3||',
                                                   '''||v_record_fase_padre.codigo||''',
                                                   '''||v_record_fase_padre.nombre||'''
                                                          )'; 
                         execute(v_consulta_into);
                      
                    END IF;
               END IF;
              
              IF v_plan_pago.id_padre_II is not null THEN --#6
              --verificamos si existe ya insertado el nivel II insertado en la tabla 

                  Select
                        pla.id_nivel_II
                  into
                  v_id_padre_II 
                  From plan_pago pla
                  where pla.id_nivel_II = v_plan_pago.id_padre_II;

                  --insertamos un nivel II si no existe
                IF  v_id_padre_II is null then                   
               
                    --datos de un nivel II
                      Select
                          fase.id_fase,
                          fase.codigo,
                          fase.nombre,
                          fase.id_fase_fk
                      into
                      v_record_fase
                      from pro.tfase fase
                      where  fase.id_fase = v_plan_pago.id_padre_II ;
                     
                     v_record_fase.codigo = replace(v_record_fase.codigo,'['||v_record_proyecto.codigo||']','');

                      ---se inserta el de los nivel 2  
                      v_consulta_into=' insert into plan_pago(
                                               id_nivel_II,
                                               id_nivel_III,
                                               nivel,
                                               codigo,
                                                item
                                                      )VALUES(
                                               '||v_record_fase.id_fase||',
                                               '||COALESCE(v_record_fase.id_fase_fk,0)||',--#6
                                               '||2||',
                                               '''||v_record_fase.codigo||''',
                                               '''||v_record_fase.nombre||'''
                                                      )'; 
                      execute(v_consulta_into);

                  END IF ;
               END IF ;
               
               IF v_plan_pago.id_padre_I is not null THEN --#9
              --verificamos si existe ya insertado el nivel II insertado en la tabla 

                  Select
                        pla.id_nivel_I
                  into
                  v_id_padre_I
                  From plan_pago pla
                  where pla.id_nivel_I = v_plan_pago.id_padre_I;
               IF  v_id_padre_I is null then                   
               
                    --datos de un nivel I
                      Select
                          fase.id_fase,
                          fase.codigo,
                          fase.nombre,
                          fase.id_fase_fk,
                          fasse.id_fase_fk as id_fase_fk_fk
                      into
                      v_record_fase
                      from pro.tfase fase
                      left JOIN pro.tfase fasse on fasse.id_fase = fase.id_fase_fk
                      where  fase.id_fase = v_plan_pago.id_padre_I ;
                      
                      v_record_fase.codigo = replace(v_record_fase.codigo,'['||v_record_proyecto.codigo||']','');

                      ---se inserta el de los nivel 1  
                      v_consulta_into=' insert into plan_pago(
                                               id_nivel_I,
                                               id_nivel_II,
                                               id_nivel_III,
                                               nivel,
                                               codigo,
                                                item
                                                      )VALUES(
                                               '||v_record_fase.id_fase||',
                                               '||COALESCE(v_record_fase.id_fase_fk,0)||',
                                               '||COALESCE(v_record_fase.id_fase_fk_fk,0)||',
                                               '||1||',
                                               '''||v_record_fase.codigo||''',
                                               '''||v_record_fase.nombre||'''
                                                      )'; 
                      execute(v_consulta_into);

                  END IF ;
               END IF ;
               
                
              --verificamos si existe el item en l tabla
              SELECT
              	id_fase_concepto_ingas
              into
                v_id_fase_concepto_ingas
              FROM plan_pago
              where id_fase_concepto_ingas = v_plan_pago.id_fase_concepto_ingas;
              --si no existe se inserta en la tabla temporal
              IF v_id_fase_concepto_ingas is null THEN 
                --si tiene plan de pagos
                IF v_plan_pago.id_fase_concepto_ingas_pago is not null THEN 
             	 v_consulta_into=' insert into plan_pago(
                                         id_nivel,
                                         id_nivel_I,
                                         id_nivel_II,
                                         id_nivel_III,
                                         nivel,
                 						 codigo,
                 						 id_fase_concepto_ingas,
              							 id_fase_concepto_ingas_pago,
                                         item,
                                         '||v_columna||',                               
                                         mes ,
                                         anio,
                                         precio_estimado,
                                         precio_real,
                                         total_prorrateo 
                                                )VALUES(
                                         '||v_plan_pago.id_padre_I||',
                                         '||COALESCE(v_plan_pago.id_padre_I,0)||',
                                         '||COALESCE(v_plan_pago.id_padre_II,0)||',--#6
                                         '||COALESCE(v_plan_pago.id_padre_III,0)||',--#6
                                         '||0||',
                                    	 '''||COALESCE(v_plan_pago.codigo,' ')||''',--#6
                                         '||v_plan_pago.id_fase_concepto_ingas||',
                                         '||v_plan_pago.id_fase_concepto_ingas_pago||',
                                         '''||v_plan_pago.desc_ingas||''',
                                         '||v_plan_pago.importe||',
                                         '||v_plan_pago.mes||',
                                         '||v_plan_pago.anio||',
                                         '||COALESCE(v_plan_pago.precio_estimado,0)||',
                                         '||COALESCE(v_plan_pago.precio_real,0)||',
                                         '||COALESCE(v_plan_pago.importe,0)||'
                                                )'; 
                     execute(v_consulta_into);
                     --actualizamos los importes totalizadores de los padres de nivel II segun columna dinamica 
                     v_consulta_update = 'update  plan_pago set
                                        '||v_columna||' = COALESCE('||v_columna||',0) +COALESCE('||v_plan_pago.importe||',0)
                                      Where  nivel = 1 and id_nivel_I = '||COALESCE(v_plan_pago.id_padre_I,0)||'';
                    execute(v_consulta_update);
                    --actualizamos los importes totalizadores de los padres de nivel II segun columna dinamica 
                     v_consulta_update = 'update  plan_pago set
                                        '||v_columna||' = COALESCE('||v_columna||',0) +COALESCE('||v_plan_pago.importe||',0)
                                      Where  nivel = 2 and id_nivel_II = '||COALESCE(v_plan_pago.id_padre_II,0)||'';
                    execute(v_consulta_update);
                --actualizamos los importes totalizadores de los padres de nivel III segun columna dinamica                     
                    v_consulta_update = 'update  plan_pago set
                                        '||v_columna||' = COALESCE('||v_columna||',0) +COALESCE('||v_plan_pago.importe||',0)
                                      Where  nivel = 3 and id_nivel_III = '||COALESCE(v_plan_pago.id_padre_III,0)||'';
                    execute(v_consulta_update);                    
                    ELSE
                      ---se inserta los items que no tengan plan de pagos
                        	v_consulta_into=' insert into plan_pago(
                                         id_nivel,
                                         id_nivel_I,
                                         id_nivel_II,
                                         id_nivel_III,
                                         nivel,
                                         codigo,
                                    	 id_fase_concepto_ingas,
                                         item,
                                         precio_estimado,
                                         precio_real,
                                         total_prorrateo
                                                )VALUES(
                                         '||v_plan_pago.id_padre_I||',
                                         '||v_plan_pago.id_padre_I||',
                                         '||COALESCE(v_plan_pago.id_padre_II,0)||',
                                         '||COALESCE(v_plan_pago.id_padre_III,0)||',
                                         '||0||',
                                         '''||COALESCE(v_plan_pago.codigo,' ')||''',
                                         '||v_plan_pago.id_fase_concepto_ingas||',
                                         '''||v_plan_pago.desc_ingas||''',
                                         '||COALESCE(v_plan_pago.precio_estimado,0)||',
                                         '||COALESCE(v_plan_pago.precio_real,0)||',
                                         '||COALESCE(v_plan_pago.importe,0)||'
                                                )'; 
                            execute(v_consulta_into);
                   END IF;
              --actualizamos la columna de item ya ensertado
              ELSE

                --insertamos valores en las columnas de meses y acumulamos el prorrateo 
                v_consulta_update = 'update  plan_pago set
               					    '||v_columna||' = '||v_plan_pago.importe||',
                                    total_prorrateo = COALESCE(total_prorrateo,0) + '||COALESCE(v_plan_pago.importe,0)||'
                                  Where id_fase_concepto_ingas = '||v_id_fase_concepto_ingas||'';
               	execute(v_consulta_update);
                --#9 actualizamos los importes totalizadores de los padres de nivel I segun columna dinamica 
                 v_consulta_update = 'update  plan_pago set
                                        '||v_columna||' = COALESCE('||v_columna||',0) +COALESCE('||v_plan_pago.importe||',0)
                                      Where  nivel = 1 and id_nivel_I = '||COALESCE(v_plan_pago.id_padre_I,0)||'';
                 execute(v_consulta_update);
                --actualizamos los importes totalizadores de los padres de nivel II segun columna dinamica 
                 v_consulta_update = 'update  plan_pago set
                                        '||v_columna||' = COALESCE('||v_columna||',0) +COALESCE('||v_plan_pago.importe||',0)
                                      Where  nivel = 2 and id_nivel_II = '||COALESCE(v_plan_pago.id_padre_II,0)||'';
                 execute(v_consulta_update);
                --actualizamos los importes totalizadores de los padres de nivel III segun columna dinamica 
                 v_consulta_update = 'update  plan_pago set
                                        '||v_columna||' = COALESCE('||v_columna||',0) +COALESCE('||v_plan_pago.importe||',0)
                                      Where  nivel = 3 and id_nivel_III = '||COALESCE(v_plan_pago.id_padre_III,0)||'';
                 execute(v_consulta_update);
   
               END IF;
              v_count = v_count + 1; 
            END LOOP;          
            
            --los totales prorrateos de los niveles I,II y III
           
            FOR v_prorrateo in ( 
                SELECT
                    nivel,
                    id_nivel_I, 
                    id_nivel_II,
                    id_nivel_III
                FROM plan_pago
                WHERE nivel in (1,2,3)
            )LOOP             
                FOR v_item IN(
                     SELECT
                        id_nivel_I,
                        id_nivel_II,
                        id_nivel_III,
                        precio_estimado,
                        precio_real,
                        total_prorrateo
                     FROM plan_pago
                     WHERE nivel = 0  
                )LOOP
                    --#9
                     IF v_prorrateo.id_nivel_I = v_item.id_nivel_I and v_prorrateo.nivel = 1  THEN
                            UPDATE plan_pago SET
                            precio_estimado = COALESCE(precio_estimado,0) + COALESCE(v_item.precio_estimado,0),
                            precio_real = COALESCE(precio_real,0) +  COALESCE(v_item.precio_real,0),
                            total_prorrateo = COALESCE(total_prorrateo,0) +  COALESCE(v_item.total_prorrateo,0)
                            WHERE nivel = 1 and id_nivel_I = v_prorrateo.id_nivel_I;
                     END IF;
                     IF v_prorrateo.id_nivel_II = v_item.id_nivel_II and v_prorrateo.nivel = 2  THEN
                            UPDATE plan_pago SET
                            precio_estimado = COALESCE(precio_estimado,0) + COALESCE(v_item.precio_estimado,0),
                            precio_real = COALESCE(precio_real,0) +  COALESCE(v_item.precio_real,0),
                            total_prorrateo = COALESCE(total_prorrateo,0) +  COALESCE(v_item.total_prorrateo,0)
                            WHERE nivel = 2 and id_nivel_II = v_prorrateo.id_nivel_II;
                     END IF;
                     IF v_prorrateo.id_nivel_III = v_item.id_nivel_III and v_prorrateo.nivel = 3 THEN
                            UPDATE plan_pago SET
                            precio_estimado = COALESCE(precio_estimado,0) + COALESCE(v_item.precio_estimado,0),
                            precio_real = COALESCE(precio_real,0) +  COALESCE(v_item.precio_real,0),
                            total_prorrateo = COALESCE(total_prorrateo,0) +  COALESCE(v_item.total_prorrateo,0)
                            WHERE nivel = 3 and id_nivel_III = v_prorrateo.id_nivel_III;
                     END IF;
                
                
                END LOOP;
             
            END LOOP ;
        
            v_consulta='
            	SELECT
                	 id ,
                     nivel,
                     codigo,
                     item ,
                     precio_estimado,
                     precio_real,
                     total_prorrateo,                               
                     mes ,';
             
                    
            For v_gestion in (
                Select 
                    DISTINCT(date_part('year', facoinpa.fecha_pago))as anio
                From pro.tfase_concepto_ingas facoin
                LEFT JOIN pro.tfase_concepto_ingas_pago facoinpa on facoinpa.id_fase_concepto_ingas = facoin.id_fase_concepto_ingas
                left join param.tconcepto_ingas coingas on coingas.id_concepto_ingas = facoin.id_concepto_ingas
                left join pro.tfase fase on fase.id_fase = facoin.id_fase
                Where facoinpa.id_fase_concepto_ingas_pago is not null and fase.id_proyecto = p_id_proyecto 
                 ORDER by anio ASC
             )LOOP                       
                              v_consulta =v_consulta ||'enero_'||v_gestion.anio||'  , 
                              			 febrero_'||v_gestion.anio||' ,
                              			 marzo_'||v_gestion.anio||'  ,
                              			 abril_'||v_gestion.anio||'  , 
                              			 mayo_'||v_gestion.anio||' ,
                                         junio_'||v_gestion.anio||' ,
                                         julio_'||v_gestion.anio||'  ,
                                         agosto_'||v_gestion.anio||' ,
                                         septiembre_'||v_gestion.anio||' ,
                                         octubre_'||v_gestion.anio||'  ,
                                         noviembre_'||v_gestion.anio||' ,
                                         diciembre_'||v_gestion.anio||' ,';
              END LOOP;  
             v_consulta = v_consulta||' anio,
                                        id_nivel,
                                        id_nivel_I, 
                                        id_nivel_II,
                                        id_nivel_III   
                                        FROM plan_pago 
                                        order by id';
         
           
            
           --raise exception '%',v_consulta;
        	
        	RETURN v_consulta ;
		end;
        
              
          /*********************************
          #TRANSACCION:  'PRO_CUE_PLAN_PAGO_SEL'
          #DESCRIPCION:	Reporte de estimado del plan de pagos 
          #AUTOR:		EGS
          #FECHA:		14/12/2018
          ***********************************/
       ELSIF(p_transaccion='PRO_CUEPAGO_SEL')THEN
          BEGIN
          	--raise EXception 'v_parametros.id_proyecto %',v_parametros.id_proyecto;
            p_id_proyecto = v_parametros.id_proyecto;

            --p_id_proyecto = 74;
         	v_consulta='Select 
                DISTINCT(date_part(''year'', facoinpa.fecha_pago))::integer as anio
                From pro.tfase_concepto_ingas facoin
                LEFT JOIN pro.tfase_concepto_ingas_pago facoinpa on facoinpa.id_fase_concepto_ingas = facoin.id_fase_concepto_ingas
                left join param.tconcepto_ingas coingas on coingas.id_concepto_ingas = facoin.id_concepto_ingas
                left join pro.tfase fase on fase.id_fase = facoin.id_fase
                Where facoinpa.id_fase_concepto_ingas_pago is not null and  fase.id_proyecto ='|| p_id_proyecto||'
                
                order by anio asc'; 

          	return v_consulta;

          END;
          
               /*********************************
          #TRANSACCION:  'PRO_LANITEM_SEL'
          #DESCRIPCION:	Reporte de Lanzamientos de Items
          #AUTOR:		EGS
          #FECHA:		20/12/2018
          ***********************************/
       ELSIF(p_transaccion='PRO_LANITEM_SEL')THEN
          BEGIN
          	--raise EXception 'v_parametros.id_proyecto %',v_parametros.id_proyecto;
            p_id_proyecto = v_parametros.id_proyecto;
			
            v_bandera = split_part(pxp.f_get_variable_global('py_compras_dias_venc'), ',', 1);
            --p_id_proyecto = 74;
         	v_consulta='              
                  WITH  doc_invitacion(					
 									id_invitacion_det,
                                    id_fase_concepto_ingas                                                                                                   
                              ) 
                           as (
                                    select 
                                       invd.id_invitacion_det,                                      
                                       invd.id_fase_concepto_ingas
                                  from pro.tinvitacion_det invd
                                  where invd.id_fase_concepto_ingas is not null
                           ),
                estado_tiempo(					
 									id_fase_concepto_ingas,
                                    estado                                                                                                   
                              ) 
                           as (
                              select        
                              facoing.id_fase_concepto_ingas,
                              CASE
                              WHEN	((facoing.fecha_estimada-now()::date)::integer) < 0	THEN
                              		''vencido''::varchar
                              WHEN	0 <= ((facoing.fecha_estimada-now()::date)::integer) and ((facoing.fecha_estimada-now()::date)::integer) <= '||v_bandera||'	THEN
                              		''vigente''::varchar
                              ELSE
                              		''otros''::varchar
                              END AS estado
                              from pro.tfase_concepto_ingas facoing
                           ),
                 mes_gestion(		id_fase_concepto_ingas,
                 					mes_item,
                 					gestion_item
                             )AS(
                             	select 
                                    facoing.id_fase_concepto_ingas,
                                    date_part(''month'',facoing.fecha_estimada) as mes_item,
                                    date_part(''year'', facoing.fecha_estimada)as gestion_item,
                                    date_part(''day'', facoing.fecha_estimada)as dia_item

                                from pro.tfase_concepto_ingas facoing
                            		
                                 ) 
 				select        facoing.id_fase_concepto_ingas,
                              facoing.id_fase,
                              facoing.id_concepto_ingas,
                              facoing.id_unidad_medida,
                              facoing.tipo_cambio_mt,
                              invd.descripcion::varchar,
                              facoing.tipo_cambio_mb,
                              facoing.estado,
                              facoing.estado_reg,
                              facoing.cantidad_est,
                              facoing.precio_mb,
                              facoing.precio,
                              facoing.precio_mt,
                              facoing.id_usuario_ai,
                              facoing.usuario_ai,
                              facoing.fecha_reg,
                              facoing.id_usuario_reg,
                              facoing.id_usuario_mod,
                              facoing.fecha_mod,
                              usu1.cuenta as usr_reg,
                              usu2.cuenta as usr_mod,
                             (COALESCE(facoing.codigo,'''')||''-''||cig.desc_ingas)::VARCHAR as desc_ingas,
                              cig.tipo,
                              fase.codigo as codigo_fase,
                              (COALESCE(fase.codigo,'''')||''-''||fase.nombre)::VARCHAR as nombre_fase,
                              fase.id_proyecto,
                              COALESCE(facoing.fecha_estimada,now()::date) as fecha_estimada,
                              (facoing.fecha_estimada-now()::date)::integer as dias,
                              est.estado::varchar as estado_tiempo,
                              meg.gestion_item::integer,
                              meg.mes_item::integer,
                              fun.desc_funcionario2::varchar as desc_funcionario,
                              CASE                                        --#5 I
                              WHEN inv.id_solicitud is not NULL or inv.id_presolicitud is not NULL THEN    
                                    ''Lanzado''::varchar 
                              ELSE   
                                    ''No Lanzado''::varchar 
                              END as estado_lanzado,
                                CASE                
                              WHEN inv.id_solicitud is not NULL THEN
                             (COALESCE(facoing.fecha_estimada,now()::date)-COALESCE(sol.fecha_reg::date,now()::date))::integer
                              WHEN inv.id_presolicitud is not NULL  THEN
                             (COALESCE(facoing.fecha_estimada,now()::date)-COALESCE(presol.fecha_reg::date,now()::date))::integer   
                              ELSE   
                                    null
                              END as dias_lanzado,        --#5  F                     
                              sol.num_tramite,            --#9
                              facoing.id_funcionario::integer,
                              invd.id_invitacion_det,
                              (''[''||COALESCE(inv.codigo,'''')||'']-''||cigv.desc_ingas)::VARCHAR as desc_ingas_invd
                              from pro.tfase_concepto_ingas facoing
                              inner join segu.tusuario usu1 on usu1.id_usuario = facoing.id_usuario_reg
                              left join segu.tusuario usu2 on usu2.id_usuario = facoing.id_usuario_mod
                              left join param.tconcepto_ingas cig on cig.id_concepto_ingas = facoing.id_concepto_ingas
                              left join pro.tfase fase on fase.id_fase = facoing.id_fase
                              LEFT JOIN estado_tiempo est on est.id_fase_concepto_ingas = facoing.id_fase_concepto_ingas
                              LEFT JOIN mes_gestion meg on meg.id_fase_concepto_ingas = facoing.id_fase_concepto_ingas
                              left join orga.vfuncionario fun on fun.id_funcionario = facoing.id_funcionario
                              left join doc_invitacion  doinv on doinv.id_fase_concepto_ingas= facoing.id_fase_concepto_ingas
                              left join pro.tinvitacion_det invd on invd.id_invitacion_det= doinv.id_invitacion_det
                              left join pro.tinvitacion inv on inv.id_invitacion = invd.id_invitacion
                              left join adq.tsolicitud sol on sol.id_solicitud= inv.id_solicitud  
                              left join adq.tpresolicitud presol on presol.id_presolicitud = inv.id_presolicitud
                              left join param.tconcepto_ingas cigv on cigv.id_concepto_ingas = invd.id_concepto_ingas  
                              where  fase.id_proyecto='||p_id_proyecto;
                              
                             v_consulta=v_consulta||'order by meg.gestion_item ,meg.mes_item ,meg.dia_item,invd.id_invitacion_det ASC '; 

          	return v_consulta;

          END;
          /*********************************
          #TRANSACCION:  'PRO_REPPRESU_SEL'
          #DESCRIPCION:	Reporte de presupuestos
          #AUTOR:		EGS
          #FECHA:		20/12/2018/
          ***********************************/
       ELSIF(p_transaccion='PRO_REPPRESU_SEL')THEN
          BEGIN
          	--raise EXception 'v_parametros.id_proyecto %',v_parametros.id_proyecto;
            p_id_proyecto = v_parametros.id_proyecto;
            ---creamos tabla temporal para estructura de los datos
           	 CREATE TEMPORARY TABLE temp_item(
                                      id serial,
                                      id_padre integer,
                                      id_item integer,
                                      codigo_item varchar,
									  nombre_item varchar ,
                                      precio_item numeric
                                     ) ON COMMIT DROP;
                                     
                                     
             FOR v_item IN (
             WITH RECURSIVE proyectos AS (
                     SELECT
                     proy.id_proyecto,
                     0::integer id_fase,
                     0::integer as id_fase_fk,
                     proy.nombre as nombre_proyecto,                    
                     ''::varchar as nombre_padre,
                     ''::varchar as nombre_fase,
                     ''::varchar as codigo_fase,
                     0::integer as id_fase_concepto_ingas,
                     ''::varchar as desc_ingas,
                     0::numeric as precio
                     FROM pro.tproyecto proy
                     where proy.id_proyecto= p_id_proyecto
                     UNION

                         SELECT
                         fas.id_proyecto,
                         fas.id_fase,
                         fas.id_fase_fk,
                         ''::varchar(150) as nombre_proyecto,
                         fass.nombre as nombre_padre,
                         fas.nombre as nombre_fase,
                         fas.codigo as codigo_fase,
                         fascon.id_fase_concepto_ingas,
                         coin.desc_ingas,
                         fascon.precio
                         FROM pro.tfase fas
                         left JOIN pro.tfase_concepto_ingas fascon on fascon.id_fase=fas.id_fase
                         left join param.tconcepto_ingas coin	on coin.id_concepto_ingas = fascon.id_concepto_ingas
                         left JOIN pro.tfase fass on fass.id_fase=fas.id_fase_fk
                         INNER JOIN proyectos p ON p.id_proyecto = fas.id_proyecto)
                      SELECT
                       *
                      FROM proyectos pr
                      where pr.id_fase_concepto_ingas is not null
                      order by pr.id_fase_fk ASC )LOOP
                      
                     SELECT
                    	temp.id_item
                     into
                     v_id_item
					 from temp_item temp
					 where temp.id_item = v_item.id_fase_fk;
                     
                   
                      
                     IF v_id_item is null and v_item.id_fase <> 0 THEN
                     	
                     
           
                     	--insertando el nivel padre de las fases que contenga item
                        SELECT
                            fase.id_fase,
                            fase.nombre,
                            fase.id_fase_fk ,
                            fase.codigo                      
                        INTO
                            v_record_fase
                        FROM pro.tfase fase
                        WHERE fase.id_fase = v_item.id_fase_fk;
                        ---recolectamos la informacion del padre del padre de las fases de los items
                        SELECT
                            fase.id_fase,
                            fase.nombre,
                            fase.id_fase_fk,
                            fase.codigo                        
                        INTO
                            v_record_fase_padre
                        FROM pro.tfase fase
                        WHERE fase.id_fase = v_record_fase.id_fase_fk;
                        --verificamos si existe en base de datos
                        SELECT
                            temp.id_item
                         into
                         v_id_item_padre
                         from temp_item temp
                         where temp.id_item = v_record_fase_padre.id_fase;
                         
                         ---insertamos si no existe en la tabla temporal
                        IF v_id_item_padre is null THEN
                          with suma	(   id_fase_fk,
                                          precio
                                              )as
                          
                                          (	SELECT	
                                                 fas.id_fase_fk,
                                                 sum (fascon.precio)
                                                 FROM pro.tfase fas
                                                 left JOIN pro.tfase_concepto_ingas fascon on fascon.id_fase=fas.id_fase
                                                 left join param.tconcepto_ingas coin	on coin.id_concepto_ingas = fascon.id_concepto_ingas
                                                 left JOIN pro.tfase fass on fass.id_fase=fas.id_fase_fk                        
                                                GROUP by  fas.id_fase_fk )
                                                
                                   SELECT 
                                       sum(su.precio)
                                   INTO
                                   v_precio
                                   FROM pro.tfase fase
                                   left join suma su on su.id_fase_fk=fase.id_fase
                                   where fase.id_fase_fk = v_record_fase_padre.id_fase; 
                          
                          INSERT INTO temp_item(
                                      id_padre ,
                                      id_item ,
									  nombre_item,
                                      precio_item,
                                      codigo_item 	
                          ) VALUES(
                          	  1,
                              v_record_fase_padre.id_fase,                            
                              v_record_fase_padre.nombre,
                              v_precio,
                              v_record_fase_padre.codigo

                          ) ;
                        
                        END IF;
                     	
                        --sumamos el precio del padre de las fases con items
                     	SELECT
                           sum (fascon.precio)
                           into
                           v_precio
                           FROM pro.tfase fas
                           left JOIN pro.tfase_concepto_ingas fascon on fascon.id_fase=fas.id_fase
                           left join param.tconcepto_ingas coin	on coin.id_concepto_ingas = fascon.id_concepto_ingas
                           left JOIN pro.tfase fass on fass.id_fase=fas.id_fase_fk
                           where fas.id_fase_fk = v_item.id_fase_fk
                           GROUP by  fas.id_fase_fk;
                     	
                        --insertamos el padre de las fases con items
                     	INSERT INTO temp_item(
                                      id_padre ,
                                      id_item ,
									  nombre_item,
                                      precio_item,
                                      codigo_item 	
                          ) VALUES(
                          	  2,
                              v_record_fase.id_fase,                            
                              v_record_fase.nombre,
                              v_precio,
                              v_record_fase.codigo
                          ) ;
                	 ELSIF v_item.id_fase = 0 THEN
                     	---insertando el proyecto como 1 dato de los registros
                     	 	SELECT
                              proy.id_proyecto, 
                              proy.nombre,
                              proy.codigo
                            INTO
                                  v_record_fase
                              FROM pro.tproyecto proy
                              WHERE  proy.id_proyecto = v_item.id_proyecto ;
                              
                              SELECT
                               			sum (fascon.precio)
                               into
                               v_precio
                               FROM pro.tfase fas
                               left JOIN pro.tfase_concepto_ingas fascon on fascon.id_fase=fas.id_fase
                               left join param.tconcepto_ingas coin	on coin.id_concepto_ingas = fascon.id_concepto_ingas
                               left JOIN pro.tfase fass on fass.id_fase=fas.id_fase_fk
                               where fas.id_proyecto = v_item.id_proyecto
                               GROUP by  fas.id_proyecto;
                             
                              INSERT INTO temp_item(
                                      id_padre ,
                                      id_item ,
									  nombre_item,
                                      precio_item,
                                      codigo_item 	
                              ) VALUES(
                                  0,
                                  v_record_fase.id_proyecto,                            
                                  v_record_fase.nombre,
                                  v_precio,
                                  v_record_fase.codigo
                              ) ;
                              
                     	
                     END IF;
                     
                     IF v_item.id_fase <>0 THEN
                     INSERT INTO temp_item(
                                      id_padre ,
                                      id_item ,
									  nombre_item,
                                      precio_item,
                                      codigo_item 	
                          ) VALUES(
                          	  v_item.id_fase_fk,
                              v_item.id_fase_concepto_ingas,                            
                              v_item.desc_ingas,
                              v_item.precio,
                              v_item.codigo_fase
                     		) ;
    				END IF;
             END LOOP; 
             			--devolvemos los registros para su propia captura en el modelo
        	   v_consulta='  SELECT                 
                                  	  id ,
            						  id_padre ,
                                      id_item ,
									  nombre_item,
                                      precio_item,
                                      codigo_item 
                                FROM temp_item 
                                order by id ASC';
          	return v_consulta;


          END;
         /*********************************    
          #TRANSACCION:  'PRO_REPIVT_SEL'
          #DESCRIPCION:	Reporte de invitaciones
          #AUTOR:		eddy.gutierrez	
          #FECHA:		09/07/2019
          #ISSUE:       #15 
          ***********************************/
          
          elsif(p_transaccion='PRO_REPIVT_SEL')then
     				
            begin
               
                
                --Sentencia de la consulta
                v_consulta:=' 
                WITH   anio(
                            id_invitacion,
                                anio	
                            )AS(
                            SELECT
                                inv.id_invitacion,
                                date_part(''year'',inv.fecha)as anio
                            from pro.tinvitacion inv

                            )
                    select
                            ivt.id_invitacion,
                            ivt.id_proyecto,
                            ivt.codigo,
                            ivt.fecha,
                            ivt.descripcion,
                            ivt.fecha_real,
                            ivt.estado_reg,
                            ivt.estado,
                            ivt.id_estado_wf,
                            ivt.nro_tramite,
                            ivt.id_usuario_ai,
                            ivt.usuario_ai,
                            ivt.fecha_reg,
                            ivt.id_usuario_reg,
                            ivt.id_usuario_mod,
                            ivt.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            ivt.id_funcionario,
                            ivt.id_depto,
                            ivt.id_moneda,
                            ivt.tipo,
                            ivt.lugar_entrega,
                            ivt.dias_plazo_entrega,
                            mon.codigo as desc_moneda,
                            fun.desc_funcionario1::VARCHAR as desc_funcionario,
                            dep.nombre::VARCHAR	as desc_depto,
                            ew.id_proceso_wf,
                            an.anio::varchar,
                            ges.id_gestion,
                            ivt.id_categoria_compra,
                            ivt.id_solicitud,
                            ivt.id_presolicitud,
                            ivt.pre_solicitud,
                            ivt.id_grupo,
                            cat.nombre as desc_categoria_compra,
                            gru.nombre as desc_grupo
                            from pro.tinvitacion ivt
                            left join param.tmoneda mon on mon.id_moneda = ivt.id_moneda
                            left join wf.testado_wf ew on ew.id_estado_wf = ivt.id_estado_wf
                            left join segu.tusuario usu1 on usu1.id_usuario = ivt.id_usuario_reg
                            left join orga.vfuncionario fun on fun.id_funcionario = ivt.id_funcionario
                            left join param.tdepto dep on dep.id_depto = ivt.id_depto 
                            left join segu.tusuario usu2 on usu2.id_usuario = ivt.id_usuario_mod                           
                            left join anio an on an.id_invitacion = ivt.id_invitacion
                            left JOIN param.tgestion ges on ges.gestion = an.anio
                            left join adq.tcategoria_compra cat on cat.id_categoria_compra = ivt.id_categoria_compra
                            left JOIN adq.tgrupo gru on gru.id_grupo = ivt.id_grupo

                            where  ';
    			
                --Definicion de la respuesta
                v_consulta:=v_consulta||v_parametros.filtro;
                v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

                --Devuelve la respuesta
                return v_consulta;
    						
            end;	 
         

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
COST 100;
