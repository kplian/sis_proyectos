--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_componente_concepto_ingas_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_componente_concepto_ingas_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomp_concepto_ingas'
 AUTOR:          (admin)
 FECHA:            22-07-2019 14:49:24
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #17                22-07-2019 14:49:24    EGS                    Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomp_concepto_ingas'
 #28                16/09/2019             EGS                  Carga de factres en concepto detalle
 #34  EndeEtr       03/10/2019             EGS                  Se agrgaron campos tipo_configuracion,id_unidad_medida,conductor
 #35                07/10/2019             EGS                  se agrega validacion q no agrega conceptos repetidos por componente macro
 #39  Endeetr       17/10/2019             EGS                  se agrega conceptos detalle utilizando la transaccion PRO_COMINDET_INS
 #44  EndeEtr       18/11/2019             EGS                  Se agrgan los campos de codigo
 ***************************************************************************/

DECLARE

    v_nro_requerimiento                 integer;
    v_parametros                        record;
    v_id_requerimiento                  integer;
    v_resp                              varchar;
    v_nombre_funcion                    text;
    v_mensaje_error                     text;
    v_id_componente_concepto_ingas      integer;
    v_record                            record;
    v_id_componente_concepto_ingas_det  integer;
    v_valor                             varchar;
    v_id_columna                        integer;
    v_columnas_extra                    varchar;
    v_consulta                          varchar;
    v_filtro                            varchar;
    v_record_mc                         record;
    v_tension                           varchar;
    v_id_concepto_ingas                 integer;
    v_desc_ingas                        varchar;
    v_codigo_trans                      varchar;
    v_tabla                             varchar;
    v_id_componente_concepto_ingas_det_v varchar;
BEGIN

    v_nombre_funcion = 'pro.ft_componente_concepto_ingas_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_COMINGAS_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:49:24
    ***********************************/

    if(p_transaccion='PRO_COMINGAS_INS')then

        begin

            SELECT
            comcig.id_concepto_ingas,
            cig.desc_ingas
            INTO
            v_id_concepto_ingas,
            v_desc_ingas
            FROM pro.tcomponente_concepto_ingas comcig
            LEFT JOIN param.tconcepto_ingas cig on cig.id_concepto_ingas = comcig.id_concepto_ingas
            WHERE comcig.id_componente_macro = v_parametros.id_componente_macro and comcig.id_concepto_ingas = v_parametros.id_concepto_ingas ;

            IF v_id_concepto_ingas is not null THEN --#35
                RAISE EXCEPTION 'Ya existe el Concepto Ingreso/gasto % ',v_desc_ingas;
            END IF;


            --Sentencia de la insercion
            insert into pro.tcomponente_concepto_ingas(
            estado_reg,
            id_concepto_ingas,
            id_componente_macro,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) values(
            'activo',
            v_parametros.id_concepto_ingas,
            v_parametros.id_componente_macro,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null



            )RETURNING id_componente_concepto_ingas into v_id_componente_concepto_ingas;
           --Recreamos la tabla para su facil filtrado con las columnas dinamicas de concepto detalle
            CREATE TEMPORARY TABLE temp_comp_t_concepto_ingas_det(
                                      id_componente_concepto_ingas_det SERIAL,
                                      id_componente_concepto_ingas INTEGER,
                                      tension   varchar,
                                      aislacion varchar,
                                      tipo_configuracion VARCHAR,
                                      conductor VARCHAR,
                                      id_unidad_medida integer,
                                      id_concepto_ingas_det INTEGER
                                     ) ON COMMIT DROP;

             --ingresamos todos los detalles del concepto de gasto
            FOR v_record IN(
              SELECT
                  id_concepto_ingas_det
              FROM param.tconcepto_ingas_det cigd
              WHERE cigd.estado_reg = 'activo' and cigd.agrupador = 'no' and cigd.id_concepto_ingas = v_parametros.id_concepto_ingas
              order By cigd.id_concepto_ingas_det_fk ASC
            )LOOP
                 INSERT INTO temp_comp_t_concepto_ingas_det
                    (
                        id_componente_concepto_ingas,
                        id_concepto_ingas_det
                    )VALUES(
                        v_id_componente_concepto_ingas,
                        v_record.id_concepto_ingas_det
                    )RETURNING id_componente_concepto_ingas_det into v_id_componente_concepto_ingas_det;
                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'tension';

                      SELECT
                      cd.valor
                      into
                      v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_record.id_concepto_ingas_det;

                      UPDATE temp_comp_t_concepto_ingas_det SET
                      tension = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;

                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'aislacion';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_record.id_concepto_ingas_det;

                      UPDATE temp_comp_t_concepto_ingas_det SET
                      aislacion = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;

                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'tipo_configuracion';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_record.id_concepto_ingas_det;

                      UPDATE temp_comp_t_concepto_ingas_det SET
                      tipo_configuracion = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;

                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'conductor';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_record.id_concepto_ingas_det;

                      UPDATE temp_comp_t_concepto_ingas_det SET
                      conductor = v_valor
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;

                      SELECT
                          c.id_columna
                      INTO
                              v_id_columna
                      FROM param.tcolumna c
                      WHERE c.nombre_columna = 'id_unidad_medida';

                     SELECT
                        cd.valor
                        into
                        v_valor
                      FROM param.tcolumna_concepto_ingas_det cd
                      WHERE cd.id_columna = v_id_columna and cd.id_concepto_ingas_det = v_record.id_concepto_ingas_det;

                      UPDATE temp_comp_t_concepto_ingas_det SET
                      id_unidad_medida = v_valor::integer
                      WHERE id_componente_concepto_ingas_det = v_id_componente_concepto_ingas_det;


            END LOOP;


            v_filtro = '0=0 and ';
            IF pxp.f_existe_parametro(p_tabla,'tension') THEN
                IF v_parametros.tension <> '' THEN
                     v_filtro =v_filtro||'(t.tension = '''||v_parametros.tension||''' )and ';
                END IF;
                IF v_parametros.tension = '' THEN
                    SELECT
                        cm.tension
                    INTO
                        v_tension
                    FROM pro.tcomponente_macro cm
                    WHERE cm.id_componente_macro = v_parametros.id_componente_macro ;

                     v_filtro =v_filtro||'(t.tension = '''||v_tension||''' or t.tension = ''todas'' or t.tension is null or t.tension = '''' ) and ';
                     --raise exception 'entra';
                END IF;
            END IF;



            IF pxp.f_existe_parametro(p_tabla,'aislacion') THEN
                IF v_parametros.aislacion <> '' THEN
                    v_filtro =v_filtro||'t.aislacion = '''||v_parametros.aislacion||''' and ';
                END IF;
            END IF;

             v_filtro = v_filtro ||'0=0';
            v_consulta ='
                        SELECT
                            t.id_componente_concepto_ingas,
                            t.id_concepto_ingas_det,
                            t.tension,
                            t.aislacion,
                            t.tipo_configuracion,
                            t.conductor,
                            t.id_unidad_medida
                        FROM temp_comp_t_concepto_ingas_det t
                        where '||v_filtro;


            FOR v_record IN EXECUTE (
                        v_consulta
            )LOOP

              --#27 insertando los datos de factores del componente_macro
              SELECT
                mc.f_desadeanizacion,
                mc.f_seguridad,
                mc.f_escala_xfd_montaje,
                mc.f_escala_xfd_obra_civil,
                mc.porc_prueba
              INTO
                v_record_mc
              FROM pro.tcomponente_macro mc
              WHERE mc.id_componente_macro = v_parametros.id_componente_macro ;
            --#39
            v_codigo_trans='PRO_COMINDET_INS';
            --#39
            v_tabla = pxp.f_crear_parametro(
              ARRAY['estado_reg',
                    'id_concepto_ingas_det',
                    'id_componente_concepto_ingas',
                    'cantidad_est',
                    'precio',
                    'id_usuario_reg',
                    'fecha_reg',
                    '_id_usuario_ai',
                    '_nombre_usuario_ai',
                    'id_usuario_mod',
                    'fecha_mod',
                    'peso',
                    'precio_montaje',
                    'precio_obra_civil',
                    'precio_prueba',
                    'f_desadeanizacion',
                    'f_seguridad',
                    'f_escala_xfd_montaje',
                    'f_escala_xfd_obra_civil',
                    'tension',
                    'aislacion',
                    'conductor',
                    'id_unidad_medida',
                    'tipo_configuracion',
                    'automatico',
                    'porc_prueba',
                    'codigo_inv_sumi',
                    'codigo_inv_montaje',
                    'codigo_inv_oc'
                  ],
            ARRAY['activo'::varchar,--estado_reg
                  v_record.id_concepto_ingas_det::varchar,--id_concepto_ingas_det
                  v_record.id_componente_concepto_ingas::varchar,--id_componente_concepto_ingas
                  ''::varchar,--cantidad_est
                  ''::varchar,--precio
                  p_id_usuario::varchar,--id_usuario_reg
                  now()::varchar,--fecha_reg
                  ''::varchar,--id_usuario_ai
                  'NULL'::varchar,--usuario_ai
                  ''::varchar,--id_usuario_mod
                  ''::varchar,--fecha_mod
                  ''::varchar,--peso
                  ''::varchar,--precio_montaje
                  ''::varchar,--precio_obra_civil
                  ''::varchar,--precio_prueba
                  COALESCE(v_record_mc.f_desadeanizacion::varchar,''),--f_desadeanizacion
                  COALESCE(v_record_mc.f_seguridad::varchar,''),--f_seguridad
                  COALESCE(v_record_mc.f_escala_xfd_montaje::varchar,''),--f_escala_xfd_montaje
                  COALESCE(v_record_mc.f_escala_xfd_obra_civil::varchar,''),--f_escala_xfd_obra_civil
                  COALESCE(v_record.tension::varchar,''),--tension
                  COALESCE(v_record.aislacion::varchar,''),--aislacion
                  COALESCE(v_record.conductor::varchar,''),--conductor
                  COALESCE(v_record.id_unidad_medida::varchar,''),--id_unidad_medida
                  COALESCE(v_record.tipo_configuracion::varchar,''),--tipo_configuracion
                  'si'::varchar,--automatico
                   COALESCE(v_record_mc.porc_prueba::varchar,''),--porc_prueba
                  ''::varchar,--codigo_inv_sumi
                  ''::varchar,--codigo_inv_montaje
                  ''::varchar--codigo_inv_oc
                  ],
            ARRAY['varchar',--'estado_reg'
                  'int4',--'id_concepto_ingas_det'
                  'int4',--'id_componente_concepto_ingas'
                  'numeric',--'cantidad_est'
                  'numeric',--'precio'
                  'int4',--'id_usuario_reg'
                  'timestamp',--'fecha_reg'
                  'int4',--'id_usuario_ai'
                  'varchar',--'usuario_ai'
                  'int4',--id_usuario_mod
                  'timestamp',--fecha_mod
                  'numeric',--peso
                  'numeric',--'precio_montaje'
                  'numeric',--'precio_obra_civil'
                  'numeric',--'precio_prueba'
                  'numeric',--'f_desadeanizacion'
                  'numeric',--'f_seguridad'
                  'numeric',--'f_escala_xfd_montaje'
                  'numeric',--'f_escala_xfd_obra_civil'
                  'varchar',--tension
                  'varchar',--aislacion
                  'varchar',--conductor
                  'int4',--id_unidad_medida
                  'varchar',--tipo_configuracion
                  'varchar',--automatico
                  'numeric',--'porc_prueba'
                  'varchar',--codigo_inv_sumi
                  'varchar',--codigo_inv_montaje
                  'varchar'--codigo_inv_oc
                  ]);
            --#39
            v_resp = pro.ft_componente_concepto_ingas_det_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);
            --#39
            v_id_componente_concepto_ingas_det_v  = pxp.f_recupera_clave(v_resp,'id_componente_concepto_ingas_det');
            v_id_componente_concepto_ingas_det_v    =  split_part(v_id_componente_concepto_ingas_det_v, '{', 2);
            v_id_componente_concepto_ingas_det_v    =  split_part(v_id_componente_concepto_ingas_det_v, '}', 1);


            END LOOP;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Lista Concepto Ingas Componente almacenado(a) con exito (id_comp_concepto_ingas'||v_id_componente_concepto_ingas||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas',v_id_componente_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMINGAS_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:49:24
    ***********************************/

    elsif(p_transaccion='PRO_COMINGAS_MOD')then

        begin
            --Sentencia de la modificacion
            update pro.tcomponente_concepto_ingas set
            id_concepto_ingas = v_parametros.id_concepto_ingas,
            id_componente_macro = v_parametros.id_componente_macro,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            where id_componente_concepto_ingas=v_parametros.id_componente_concepto_ingas;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Lista Concepto Ingas Componente modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas',v_parametros.id_componente_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMINGAS_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:49:24
    ***********************************/

    elsif(p_transaccion='PRO_COMINGAS_ELI')then

        begin
            --Sentencia de la eliminacion
            --Eliminamos todos los conceptos detalle relacionados
            Delete from pro.tcomponente_concepto_ingas_det
            where id_componente_concepto_ingas=v_parametros.id_componente_concepto_ingas;

            delete from pro.tcomponente_concepto_ingas
            where id_componente_concepto_ingas=v_parametros.id_componente_concepto_ingas;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Lista Concepto Ingas Componente eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_concepto_ingas',v_parametros.id_componente_concepto_ingas::varchar);

            --Devuelve la respuesta
            return v_resp;

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