--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_componente_macro_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_componente_macro_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomponente_macro'
 AUTOR:          (admin)
 FECHA:            22-07-2019 14:47:14
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #17                22-07-2019 14:47:14     EGS                 Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomponente_macro'
 #22 EndeEtr          05/09/2019            EGS                 Se agrga cmp codigo y se inserta unidades construcivas por componente macro
 #27                 16/09/2019            EGS                  Se agrego campo f_desadeanizacion,f_seguridad,f_escala_xfd_montaje,f_escala_xfd_obra_civil,porc_prueba
 #35                    07/10/2019          EGS                 Codigo en mayusculas
 ***************************************************************************/

DECLARE

    v_nro_requerimiento         integer;
    v_parametros                record;
    v_id_requerimiento          integer;
    v_resp                      varchar;
    v_nombre_funcion            text;
    v_mensaje_error             text;
    v_id_componente_macro       integer;
    v_id_unidad_constructiva_fk integer;
    v_codigo_trans              varchar;
    v_tabla                     varchar;
    v_id_unidad_constructiva    varchar;
    v_des_uc                    VARCHAR;
    v_record_uc                 record;
    v_recor_comcig              record;
    v_recor_comcig_det          record;
    v_record_cm                 record;
    v_count                     integer;
    v_codigo                    varchar;
BEGIN

    v_nombre_funcion = 'pro.ft_componente_macro_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_COMPM_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    if(p_transaccion='PRO_COMPM_INS')then

        begin
            --Sentencia de la insercion
            insert into pro.tcomponente_macro(
            estado_reg,
            nombre,
            descripcion,
            id_proyecto,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod,
            codigo,--#22
            componente_macro_tipo,--#22
            f_desadeanizacion,--#27
            f_seguridad,--#27
            f_escala_xfd_montaje,--#27
            f_escala_xfd_obra_civil,--#27
            porc_prueba,--#27
            tension
              ) values(
            'activo',
            v_parametros.nombre,
            v_parametros.descripcion,
            v_parametros.id_proyecto,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null,
            UPPER(v_parametros.codigo),--#22 --#35
            v_parametros.componente_macro_tipo, --#22
            v_parametros.f_desadeanizacion,--#27
            v_parametros.f_seguridad,--#27
            v_parametros.f_escala_xfd_montaje,--#27
            v_parametros.f_escala_xfd_obra_civil,--#27
            v_parametros.porc_prueba,--#27
            v_parametros.tension
            )RETURNING id_componente_macro into v_id_componente_macro;
            --#22 Crea la Unidad Constructiva base del proyecto
            SELECT
                uc.id_unidad_constructiva
            INTO
                v_id_unidad_constructiva_fk
            FROM pro.tunidad_constructiva uc
            WHERE uc.id_unidad_constructiva_fk is NULL and uc.id_proyecto = v_parametros.id_proyecto;


            v_codigo_trans='PRO_UNCON_INS';
            v_tabla = pxp.f_crear_parametro(
              ARRAY['id_usuario_reg',
                  'nombre',
                  'id_proyecto',
                  'id_unidad_constructiva_fk',
                  'codigo',
                  'activo',
                  'descripcion',
                  '_nombre_usuario_ai',
                  '_id_usuario_ai',
                  'macro',
                  'id_unidad_constructiva_tipo',
                  'tipo_configuracion'
                  ],
            ARRAY[p_id_usuario::varchar,--id_usuario_reg
                  v_parametros.nombre::varchar,--nombre
                  v_parametros.id_proyecto::varchar,--id_proyecto
                  v_id_unidad_constructiva_fk::varchar,--id_unidad_constructiva_fk
                  v_parametros.codigo::varchar,--codigo
                  'no'::varchar,--activo
                  ''::varchar,--descripcion
                  'NULL'::varchar,--_nombre_usuario_ai
                  ''::varchar,--_id_usuario_ai
                  'si'::varchar,--macro
                  'NULL'::varchar,--id_unidad_constructiva_tipo
                  'NULL'::varchar--tipo_configuracion
                  ],
            ARRAY['int4',--id_usuario_reg
                  'varchar',--nombre
                  'int4',--id_proyecto
                  'varchar',--id_unidad_constructiva_fk
                  'varchar',--codigo
                  'varchar',--activo
                  'varchar',--descripcion
                  'varchar',--_nombre_usuario_ai
                  'integer',--_id_usuario_ai
                  'varchar',--macro
                  'integer',--id_unidad_constructiva_tipo
                  'varchar'--tipo_configuracion
                  ]);
            v_resp = pro.ft_unidad_constructiva_ime(p_administrador,p_id_usuario,v_tabla,v_codigo_trans);

            v_id_unidad_constructiva  = pxp.f_recupera_clave(v_resp,'id_unidad_constructiva');
            v_id_unidad_constructiva    =  split_part(v_id_unidad_constructiva, '{', 2);
            v_id_unidad_constructiva    =  split_part(v_id_unidad_constructiva, '}', 1);

            UPDATE pro.tcomponente_macro SET
            id_unidad_constructiva = v_id_unidad_constructiva::INTEGER
            WHERE id_componente_macro = v_id_componente_macro;

            /*
            INSERT INTO  pro.tunidad_constructiva (
                           id_usuario_reg,
                           nombre,
                           id_proyecto,
                           id_unidad_constructiva_fk
                          ) values(
                           p_id_usuario,
                           v_parametros.nombre,
                           v_parametros.id_proyecto,
                           v_id_unidad_constructiva_fk
                           ); */


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Componente Macro almacenado(a) con exito (id_componente_macro'||v_id_componente_macro||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_macro',v_id_componente_macro::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMPM_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    elsif(p_transaccion='PRO_COMPM_MOD')then

        begin
            IF v_parametros.id_unidad_constructiva is not null THEN

                SELECT
                    pro.codigo
                INTO
                    v_codigo
                FROM pro.tunidad_constructiva uc
                LEFT JOIN pro.tproyecto pro on pro.id_proyecto = uc.id_proyecto
                WHERE uc.id_unidad_constructiva = v_parametros.id_unidad_constructiva;

                IF v_codigo is not null THEN
                   v_parametros.codigo ='['||v_codigo||']-'||v_parametros.codigo;
                END IF;


                UPDATE pro.tunidad_constructiva SET
                    nombre = v_parametros.nombre,
                    codigo = v_parametros.codigo
                WHERE id_unidad_constructiva = v_parametros.id_unidad_constructiva;
            END IF;

             --#28recuperamos los valores antiguos del componente macro
            SELECT
                mc.f_desadeanizacion,
                mc.f_seguridad,
                mc.f_escala_xfd_montaje,
                mc.f_escala_xfd_obra_civil,
                mc.tension,
                mc.porc_prueba
            INTO
                v_record_cm
            FROM pro.tcomponente_macro mc
            WHERE mc.id_componente_macro=v_parametros.id_componente_macro ;
            --verificamos qu no se crearon hijos en la unidad construtiva para q no puedan cambiar la tension

            WITH RECURSIVE arbol  AS(
                 SELECT
                    uc.id_unidad_constructiva,
                    uc.codigo
                 FROM pro.tunidad_constructiva uc
                  WHERE uc.id_unidad_constructiva = v_parametros.id_unidad_constructiva
                  UNION ALL

                 SELECT
                    uc.id_unidad_constructiva,
                    uc.codigo
                 FROM pro.tunidad_constructiva uc
                  JOIN arbol al ON al.id_unidad_constructiva = uc.id_unidad_constructiva_fk
                  )
                  SELECT
                   count(id_unidad_constructiva)
                  INTO v_count
                  FROM arbol
                  WHERE id_unidad_constructiva <> v_parametros.id_unidad_constructiva;

             IF v_record_cm.tension <> v_parametros.tension THEN
                IF v_count <> 0 THEN
                   RAISE EXCEPTION 'No puede modificar la Tension. La UC relacionada ya tiene UC hijos';
                END IF;
             END IF;
            --Sentencia de la modificacion
            update pro.tcomponente_macro set
            nombre = v_parametros.nombre,
            descripcion = v_parametros.descripcion,
            id_proyecto = v_parametros.id_proyecto,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            codigo = UPPER(v_parametros.codigo),--#22 --#35
            componente_macro_tipo = v_parametros.componente_macro_tipo,--#22
            id_unidad_constructiva = v_parametros.id_unidad_constructiva,
            f_desadeanizacion = v_parametros.f_desadeanizacion,--#27
            f_seguridad = v_parametros.f_seguridad,--#27
            f_escala_xfd_montaje = v_parametros.f_escala_xfd_montaje,--#27
            f_escala_xfd_obra_civil = v_parametros.f_escala_xfd_obra_civil,--#27
            porc_prueba = v_parametros.porc_prueba,--#27
            tension = v_parametros.tension
            where id_componente_macro=v_parametros.id_componente_macro;
            --#28 Modificamos los factores en los detalles deacuerdo a las actualizaciones

            --recuperamos las listas de concepto de gasto
            FOR v_recor_comcig IN(
                SELECT
                    comcig.id_componente_concepto_ingas
                FROM pro.tcomponente_concepto_ingas comcig
                WHERE comcig.id_componente_macro = v_parametros.id_componente_macro
            )LOOP
                    --Recuperamos la lisata de concepto de gasto detalle
                    FOR v_recor_comcig_det IN(
                        SELECT
                            comcigd.id_componente_concepto_ingas_det,
                            comcigd.f_desadeanizacion,
                            comcigd.f_seguridad,
                            comcigd.f_escala_xfd_montaje,
                            comcigd.f_escala_xfd_obra_civil,
                            comcigd.porc_prueba
                        FROM pro.tcomponente_concepto_ingas_det comcigd
                        WHERE comcigd.id_componente_concepto_ingas = v_recor_comcig.id_componente_concepto_ingas

                    )LOOP
                        --solo actualizamos los datos iguales o nulos a los campos del componentes macro
                        IF v_recor_comcig_det.f_desadeanizacion IS null or v_recor_comcig_det.f_desadeanizacion = v_record_cm.f_desadeanizacion   THEN
                            UPDATE pro.tcomponente_concepto_ingas_det  SET
                                 f_desadeanizacion = v_parametros.f_desadeanizacion
                            WHERE  id_componente_concepto_ingas_det = v_recor_comcig_det.id_componente_concepto_ingas_det;
                        END IF;
                        IF v_recor_comcig_det.f_seguridad IS null or v_recor_comcig_det.f_seguridad = v_record_cm.f_seguridad THEN
                            UPDATE pro.tcomponente_concepto_ingas_det  SET
                                  f_seguridad  = v_parametros.f_seguridad
                            WHERE  id_componente_concepto_ingas_det = v_recor_comcig_det.id_componente_concepto_ingas_det;
                        END IF;
                        IF v_recor_comcig_det.f_escala_xfd_montaje IS null or v_recor_comcig_det.f_escala_xfd_montaje = v_record_cm.f_escala_xfd_montaje THEN
                            UPDATE pro.tcomponente_concepto_ingas_det  SET
                                  f_escala_xfd_montaje  = v_parametros.f_escala_xfd_montaje
                            WHERE  id_componente_concepto_ingas_det = v_recor_comcig_det.id_componente_concepto_ingas_det;
                        END IF;
                        IF v_recor_comcig_det.f_escala_xfd_obra_civil IS null or v_recor_comcig_det.f_escala_xfd_obra_civil = v_record_cm.f_escala_xfd_obra_civil THEN
                            UPDATE pro.tcomponente_concepto_ingas_det  SET
                                  f_escala_xfd_obra_civil = v_parametros.f_escala_xfd_obra_civil
                            WHERE  id_componente_concepto_ingas_det = v_recor_comcig_det.id_componente_concepto_ingas_det;
                        END IF;
                        IF v_recor_comcig_det.porc_prueba IS null or v_recor_comcig_det.porc_prueba = v_record_cm.porc_prueba THEN
                            UPDATE pro.tcomponente_concepto_ingas_det  SET
                                  porc_prueba = v_parametros.porc_prueba
                            WHERE  id_componente_concepto_ingas_det = v_recor_comcig_det.id_componente_concepto_ingas_det;
                        END IF;
                    END LOOP;

            END LOOP;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Componente Macro modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_macro',v_parametros.id_componente_macro::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_COMPM_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    elsif(p_transaccion='PRO_COMPM_ELI')then

        begin
            --no se eliminan si esta relacionado a una unidad constructiva #26
            SELECT
                cm.id_unidad_constructiva
            INTO
               v_id_unidad_constructiva::integer
            FROM pro.tcomponente_macro cm
            WHERE id_componente_macro = v_parametros.id_componente_macro  ;

            SELECT
               cu.id_unidad_constructiva,
               COALESCE(cu.codigo,'') as desc_uc
            INTO
                v_record_uc
            FROM pro.tunidad_constructiva cu
            WHERE cu.id_unidad_constructiva = v_id_unidad_constructiva::INTEGER;

            IF v_record_uc.id_unidad_constructiva is not null THEN
                RAISE EXCEPTION 'Existe una Unidad Constructiva Asociada (%) Eliminela para Poder Continuar',v_record_uc.desc_uc;
            END IF;
            --Sentencia de la eliminacion
            delete from pro.tcomponente_macro
            where id_componente_macro=v_parametros.id_componente_macro;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Componente Macro eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_macro',v_parametros.id_componente_macro::varchar);

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