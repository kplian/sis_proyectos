--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.f_verificar_activo_unidad_constructiva_pl (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_plantilla varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Proyectos
 FUNCION:       pro.f_verificar_activo_unidad_constructiva_pl
 DESCRIPCION:   Verifica que en rama de la unidad constructiva o en la plantilla no exista un activo al insertar o modificar
 AUTOR:         (egutierrez)
 FECHA:         03/07/2019 
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #16                  01/08/2019           EGS                  creacion    
 #
 ***************************************************************************/

DECLARE

    v_consulta              varchar;
    v_parametros            record;
    v_nombre_funcion        text;
    v_resp                  varchar;
    v_record                record;
    v_existe                varchar;
    v_id                    varchar;
    v_id_fk                 varchar;
    v_id_data               integer;
    v_id_data_fk            integer;
    v_tabla                 varchar;     
BEGIN

    v_nombre_funcion = 'pro.f_verificar_activo_unidad_constructiva_pl';
    v_parametros = pxp.f_get_record(p_tabla);
    
    
    IF p_plantilla = 'no' THEN
        v_id    = 'id_unidad_constructiva';
        v_id_fk = 'id_unidad_constructiva_fk';        
        v_id_data_fk = v_parametros.id_unidad_constructiva_fk ;
        v_tabla = 'tunidad_constructiva';
        IF pxp.f_existe_parametro(p_tabla,v_id) THEN
            v_id_data = v_parametros.id_unidad_constructiva ;         
        END IF;

    ELSIF p_plantilla = 'si' THEN
        v_id    = 'id_unidad_constructiva_plantilla';
        v_id_fk = 'id_unidad_constructiva_plantilla_fk';
        v_id_data_fk = v_parametros.id_unidad_constructiva_plantilla_fk ;
        v_tabla = 'tunidad_constructiva_plantilla';
        IF pxp.f_existe_parametro(p_tabla,v_id) THEN
            v_id_data = v_parametros.id_unidad_constructiva_plantilla ;         
        END IF ;   
    END IF;
    --armamos la consulta para obtener los nodos padres
    v_consulta = ' WITH RECURSIVE arbol AS (
                                   SELECT
                                         t.'||v_id||',
                                         t.'||v_id_fk||',
                                         t.codigo,
                                         t.activo
                                   FROM pro.'||v_tabla||' t
                                   where t.'||v_id||' in ('||v_id_data_fk||'::integer)
                                    UNION
                                       SELECT
                                        ta.'||v_id||',
                                        ta.'||v_id_fk||',
                                        ta.codigo,
                                        ta.activo
                                       FROM  pro.'||v_tabla||' ta
                                       INNER JOIN arbol p ON p.'||v_id_fk||' = ta.'||v_id||')
                                  SELECT
                                      '||v_id||',
                                      codigo,
                                      activo                                 
                                  FROM arbol
                                  ORDER by '||v_id||' ASC ';
    
    
    --verificamos q ningun nodo padre sea activo
    FOR v_record in EXECUTE (
                v_consulta 
        )LOOP
              IF v_record.activo = 'si' THEN 
                RAISE EXCEPTION 'Ya existe un nodo Padre que es (activo) en la rama con el codigo %',v_record.codigo;       
              END IF;
    END LOOP;
    IF pxp.f_existe_parametro(p_tabla,v_id) THEN
     
      --armamos la consulta para obtener los nodos hijos 
      v_consulta = ' WITH RECURSIVE arbol AS (
                                   SELECT
                                         t.'||v_id||',
                                         t.'||v_id_fk||',
                                         t.codigo,
                                         t.activo
                                   FROM pro.'||v_tabla||' t
                                   where t.'||v_id||' in ('||v_id_data||'::integer)
                                    UNION
                                       SELECT
                                        ta.'||v_id||',
                                        ta.'||v_id_fk||',
                                        ta.codigo,
                                        ta.activo
                                       FROM  pro.'||v_tabla||' ta
                                       INNER JOIN arbol p ON p.'||v_id||' = ta.'||v_id_fk||')
                                  SELECT
                                      '||v_id||',
                                      codigo,
                                      activo                                 
                                  FROM arbol
                                  WHERE '||v_id||' <> '||v_id_data||'
                                  ORDER by '||v_id||' ASC ';
     
     
         --verificamos q ningun nodo hijo sea activo
         FOR v_record in execute(
                v_consulta 
            )LOOP
                  IF v_record.activo = 'si' THEN 
                    RAISE EXCEPTION 'Ya existe un nodo Hijo que es (activo) en la rama con el codigo %',v_record.codigo;       
                  END IF;
         
         
         END LOOP;
      END IF;
     v_resp = 'exito';
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