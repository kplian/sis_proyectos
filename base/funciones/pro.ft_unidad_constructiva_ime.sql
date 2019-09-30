--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_unidad_constructiva_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_unidad_constructiva_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_constructiva'
 AUTOR:          (egutierrez)
 FECHA:            06-05-2019 14:16:09
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #16                06-05-2019 14:16:09        EGS                    Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tunidad_constructiva'
 #
 ***************************************************************************/

DECLARE

    v_nro_requerimiento                        integer;
    v_parametros                               record;
    v_id_requerimiento                         integer;
    v_resp                                    varchar;
    v_nombre_funcion                        text;
    v_mensaje_error                         text;
    v_id_unidad_constructiva                integer;
    v_id_unidad_constructiva_fk             integer;
    v_desc_ingas                            varchar;
    v_item                                  record;
    v_id                                    record;
    v_id_unidad_constructiva_plantilla_fk   integer;
    v_id_fk                                 integer;
    v_raiz                                  varchar;
    v_padre                                 integer;
    v_codigo                                varchar;
    v_string                                varchar;
    v_string_new                            varchar;
    v_record                                record;
    v_unidad_constructiva_proyecto          integer;

BEGIN

    v_nombre_funcion = 'pro.ft_unidad_constructiva_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'PRO_UNCON_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    if(p_transaccion='PRO_UNCON_INS')then

        begin
            --Verificación del ID de la fase padre
            if v_parametros.id_unidad_constructiva_fk = 'id' then
                v_id_unidad_constructiva_fk = null;
            else
                v_id_unidad_constructiva_fk = v_parametros.id_unidad_constructiva_fk::integer;
            end if;

            v_codigo = '';
            --- Si el nodo no es padre adjuntamos el codigo del padre al codigo del nuevo nodo
            IF v_id_unidad_constructiva_fk::integer is not null THEN
            --Recuperamos el codigo del padre del arbol
                  WITH RECURSIVE arbol  AS(   SELECT
                                                    unconpl.id_unidad_constructiva,
                                                    unconpl.nombre,
                                                    unconpl.codigo,
                                                    unconpl.id_unidad_constructiva_fk
                                                   FROM pro.tunidad_constructiva unconpl
                                                   WHERE unconpl.id_unidad_constructiva = v_parametros.id_unidad_constructiva_fk::integer
                                              UNION ALL
                                                    SELECT
                                                          uncopl.id_unidad_constructiva,
                                                          uncopl.nombre,
                                                          uncopl.codigo,
                                                          uncopl.id_unidad_constructiva_fk

                                                    FROM pro.tunidad_constructiva uncopl
                                                    JOIN arbol al ON al.id_unidad_constructiva_fk =uncopl.id_unidad_constructiva
                                                        )
                    SELECT
                        codigo
                    INTO
                    v_codigo
                    FROM arbol
                    WHERE  id_unidad_constructiva_fk is null
                    order by arbol.id_unidad_constructiva ASC;

            v_parametros.codigo = '['||v_codigo||']-'||v_parametros.codigo;

            END IF;
            v_parametros.codigo =upper(REPLACE(v_parametros.codigo,' ', ''));

            -- antes de insertar verificamos en la rama de la uc no tenga un activo
            IF v_parametros.activo = 'si' THEN
                v_resp = pro.f_verificar_activo_unidad_constructiva_pl(p_administrador,p_id_usuario,p_tabla,'no');
            END IF;

            --Solo el nodo Principal Puede ser creado al Crear El proyecto
            IF v_id_unidad_constructiva_fk::integer is null THEN
                RAISE EXCEPTION 'El Nodo Raiz es el nodo del Proyecto no puede insertar un Nodo Raiz';
            END IF;
            --Los nodos de segundo nivel solo pueden ser creados desde la intefaz de componentes Macros
            SELECT
                uc.id_unidad_constructiva
            INTO
                v_unidad_constructiva_proyecto
            FROM pro.tunidad_constructiva uc
            WHERE uc.id_proyecto = v_parametros.id_proyecto and uc.id_unidad_constructiva_fk is null;
            IF  pxp.f_existe_parametro(p_tabla,'macro')= false THEN
                  IF v_id_unidad_constructiva_fk::integer = v_unidad_constructiva_proyecto THEN
                     RAISE EXCEPTION 'Los Nodos de segundo Nivel solo pueden ser insertados desde la ventana de Subestaciones y Lineas';
                  END IF;
            END IF;


            --Sentencia de la insercion
            insert into pro.tunidad_constructiva(
            estado_reg,
            nombre,
            codigo,
            fecha_reg,
            usuario_ai,
            id_usuario_reg,
            id_usuario_ai,
            id_usuario_mod,
            fecha_mod,
            id_proyecto,
            id_unidad_constructiva_fk,
            activo,
            descripcion,
            id_unidad_constructiva_tipo,
            tipo_configuracion
              ) values(
            'activo',
            v_parametros.nombre,
            v_parametros.codigo,
            now(),
            v_parametros._nombre_usuario_ai,
            p_id_usuario,
            v_parametros._id_usuario_ai,
            null,
            null,
            v_parametros.id_proyecto,
            v_id_unidad_constructiva_fk,
            v_parametros.activo,
            v_parametros.descripcion,
            v_parametros.id_unidad_constructiva_tipo,
            v_parametros.tipo_configuracion
            )RETURNING id_unidad_constructiva into v_id_unidad_constructiva;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidades Constructivas almacenado(a) con exito (id_unidad_constructiva'||v_id_unidad_constructiva||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva',v_id_unidad_constructiva::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_UNCON_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    elsif(p_transaccion='PRO_UNCON_MOD')then

        begin
            v_parametros.codigo =upper(REPLACE(v_parametros.codigo,' ', ''));

            IF v_parametros.id_unidad_constructiva_fk is null THEN
                   --recuperamos el codigo del nodo padre
                    SELECT
                        codigo
                    INTO
                        v_codigo
                    FROM pro.tunidad_constructiva uc
                    WHERE id_unidad_constructiva = v_parametros.id_unidad_constructiva;
                   --Si cambiamos el codigo del nodo padre se cambiara el codigo de todos los nodos hijos
                  IF v_codigo <> v_parametros.codigo THEN
                      FOR v_record IN (
                             WITH RECURSIVE arbol  AS(   SELECT
                                                            unconpl.id_unidad_constructiva,
                                                            unconpl.nombre,
                                                            unconpl.codigo,
                                                            unconpl.id_unidad_constructiva_fk
                                                           FROM pro.tunidad_constructiva unconpl
                                                           WHERE unconpl.id_unidad_constructiva = v_parametros.id_unidad_constructiva
                                                      UNION ALL
                                                            SELECT
                                                                  uncopl.id_unidad_constructiva,
                                                                  uncopl.nombre,
                                                                  uncopl.codigo,
                                                                  uncopl.id_unidad_constructiva_fk

                                                            FROM pro.tunidad_constructiva uncopl
                                                            JOIN arbol al ON al.id_unidad_constructiva =uncopl.id_unidad_constructiva_fk
                                                                )
                            SELECT
                                id_unidad_constructiva,
                                codigo
                            FROM arbol
                            WHERE  id_unidad_constructiva_fk is not null
                            order by arbol.id_unidad_constructiva ASC)LOOP

                            --recuperamos el codigo del nodo padre
                            v_string = '['||v_codigo||']-';
                            --armamos el nuevo codigo del nodo padre
                            v_string_new = '['||v_parametros.codigo||']-';
                            --hacemos el cambio del nuevo codigo
                            v_record.codigo = upper(REPLACE(v_record.codigo,v_string,v_string_new));
                            --actualizamos el nuevo codigo
                            UPDATE pro.tunidad_constructiva SET
                                codigo = v_record.codigo
                            WHERE id_unidad_constructiva = v_record.id_unidad_constructiva;

                        END LOOP;

                END IF;
            ELSE
                 --recuperamos el codigo del padre del nodo
                  WITH RECURSIVE arbol  AS(   SELECT
                                                    unconpl.id_unidad_constructiva,
                                                    unconpl.nombre,
                                                    unconpl.codigo,
                                                    unconpl.id_unidad_constructiva_fk
                                                   FROM pro.tunidad_constructiva unconpl
                                                   WHERE unconpl.id_unidad_constructiva = v_parametros.id_unidad_constructiva
                                              UNION ALL
                                                    SELECT
                                                          uncopl.id_unidad_constructiva,
                                                          uncopl.nombre,
                                                          uncopl.codigo,
                                                          uncopl.id_unidad_constructiva_fk

                                                    FROM pro.tunidad_constructiva uncopl
                                                    JOIN arbol al ON al.id_unidad_constructiva_fk =uncopl.id_unidad_constructiva
                                                        )

                    SELECT
                        codigo
                    INTO
                    v_codigo
                    FROM arbol
                    WHERE  id_unidad_constructiva_fk is null
                    order by arbol.id_unidad_constructiva ASC;

                    v_codigo = '['||v_codigo||']-';

                    -- comparamos que el codigo de la raiz exista en el codigo del nodo
                    IF  v_codigo <>  substring(v_parametros.codigo from 1 for char_length(v_codigo))  THEN

                        RAISE EXCEPTION 'El codigo debe tener El codigo del UC raiz,al modificar';

                    END IF;

            END IF;
            -- antes de insertar verificamos en la rama de la uc no tenga un activo
            IF v_parametros.activo = 'si' THEN
                v_resp = pro.f_verificar_activo_unidad_constructiva_pl(p_administrador,p_id_usuario,p_tabla,'no');
            END IF;
            --Sentencia de la modificacion
            update pro.tunidad_constructiva set
            nombre = v_parametros.nombre,
            codigo = v_parametros.codigo,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai,
            id_proyecto = v_parametros.id_proyecto,
            id_unidad_constructiva_fk = v_parametros.id_unidad_constructiva_fk,
            activo = v_parametros.activo,
            descripcion = v_parametros.descripcion,
            id_unidad_constructiva_tipo = v_parametros.id_unidad_constructiva_tipo,
            tipo_configuracion = v_parametros.tipo_configuracion
            where id_unidad_constructiva=v_parametros.id_unidad_constructiva;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidades Constructivas modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva',v_parametros.id_unidad_constructiva::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************
     #TRANSACCION:  'PRO_UNCON_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    elsif(p_transaccion='PRO_UNCON_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tunidad_constructiva
            where id_unidad_constructiva=v_parametros.id_unidad_constructiva;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidades Constructivas eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva',v_parametros.id_unidad_constructiva::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;


  /*********************************
   #TRANSACCION:  'PRO_UNCONAP_INS'
   #DESCRIPCION:  Insercion de registros de plantilla
   #AUTOR:      EGS
   #FECHA:      16/08/2018
  ***********************************/

  elsif(p_transaccion='PRO_UNCONAP_INS')then

        begin



           --creamos la tabla temporal que guardara las id nuevas relacionando las antiguas para recrear la dependencias de nodos
           CREATE TEMPORARY TABLE temp_id(
                         id_uc integer,
                         id_uc_pl integer
                          ) ON COMMIT DROP;

             FOR v_item IN (
               ---nota :el padre en la consulta siempre esta ordenado antes que los hijos --
                      WITH RECURSIVE arbol  AS(   SELECT
                                                    unconpl.id_unidad_constructiva_plantilla,
                                                    unconpl.nombre,
                                                    unconpl.codigo,
                                                    unconpl.descripcion,
                                                    unconpl.id_unidad_constructiva_plantilla_fk,
                                                    unconpl.activo
                                                   FROM pro.tunidad_constructiva_plantilla unconpl
                                                   WHERE unconpl.id_unidad_constructiva_plantilla = v_parametros.id_unidad_constructiva_plantilla
                                              UNION ALL
                                                    SELECT
                                                          uncopl.id_unidad_constructiva_plantilla,
                                                          uncopl.nombre,
                                                          uncopl.codigo,
                                                          uncopl.descripcion,
                                                          uncopl.id_unidad_constructiva_plantilla_fk,
                                                          uncopl.activo
                                                    FROM pro.tunidad_constructiva_plantilla uncopl
                                                    JOIN arbol al ON al.id_unidad_constructiva_plantilla =uncopl.id_unidad_constructiva_plantilla_fk
                                                        )
                        select * from arbol
                    order by arbol.id_unidad_constructiva_plantilla ASC
              )LOOP
                 --obtenemos el codigo del nodo padre donde se exportara la plantilla
                  WITH RECURSIVE arbol  AS(   SELECT
                                                    unconpl.id_unidad_constructiva,
                                                    unconpl.nombre,
                                                    unconpl.codigo,
                                                    unconpl.id_unidad_constructiva_fk
                                                   FROM pro.tunidad_constructiva unconpl
                                                   WHERE unconpl.id_unidad_constructiva = v_parametros.id_unidad_constructiva
                                              UNION ALL
                                                    SELECT
                                                          uncopl.id_unidad_constructiva,
                                                          uncopl.nombre,
                                                          uncopl.codigo,
                                                          uncopl.id_unidad_constructiva_fk

                                                    FROM pro.tunidad_constructiva uncopl
                                                    JOIN arbol al ON al.id_unidad_constructiva_fk =uncopl.id_unidad_constructiva
                                                        )
                    SELECT
                        codigo
                    INTO
                    v_codigo
                    FROM arbol
                    WHERE  id_unidad_constructiva_fk is null
                    order by arbol.id_unidad_constructiva ASC;

                   insert into pro.tunidad_constructiva(
                        estado_reg,
                        nombre,
                        codigo,
                        fecha_reg,
                        usuario_ai,
                        id_usuario_reg,
                        id_usuario_ai,
                        id_usuario_mod,
                        fecha_mod,
                        id_proyecto,
                        id_unidad_constructiva_fk,
                        activo,
                        descripcion
                        ) values(
                        'activo',
                        v_item.nombre,
                        '['||v_codigo||']-'||v_item.codigo,
                        now(),
                        v_parametros._nombre_usuario_ai,
                        p_id_usuario,
                        v_parametros._id_usuario_ai,
                        null,
                        null,
                        v_parametros.id_proyecto,
                        NULL,
                        v_item.activo,
                        v_item.descripcion
                        )RETURNING id_unidad_constructiva into v_id_unidad_constructiva;
                    --raise exception 'hola';

                    --asociamos la fk al nodo que se anexara el arbol plantilla


                    IF v_item.id_unidad_constructiva_plantilla_fk is null THEN
                            UPDATE pro.tunidad_constructiva SET
                              id_unidad_constructiva_fk = v_parametros.id_unidad_constructiva
                            WHERE id_unidad_constructiva = v_id_unidad_constructiva;
                       v_padre =  v_id_unidad_constructiva ;
                    END IF ;

                    insert into temp_id(
                        id_uc,
                        id_uc_pl
                                    )VALUES(
                        v_id_unidad_constructiva,
                        v_item.id_unidad_constructiva_plantilla
                        );
               END LOOP;

               --Logica para actualizar la relacion padre hijo el arbol
               v_raiz = 'no';
               FOR v_id IN(
                    SELECT
                        id_uc,
                        id_uc_pl
                    FROM temp_id
               )LOOP
                    --Buscamos el id del padre en la plantilla
                    SELECT
                        ucpl.id_unidad_constructiva_plantilla_fk
                    INTO
                        v_id_unidad_constructiva_plantilla_fk
                    FROM pro.tunidad_constructiva_plantilla ucpl
                    WHERE ucpl.id_unidad_constructiva_plantilla = v_id.id_uc_pl;

                        IF v_id_unidad_constructiva_plantilla_fk is not null THEN
                              IF v_parametros.id_unidad_constructiva_plantilla = v_id_unidad_constructiva_plantilla_fk and v_raiz = 'no'  THEN
                                      v_id_fk = v_parametros.id_unidad_constructiva;
                                      delete From pro.tunidad_constructiva  WHERE id_unidad_constructiva = v_padre;
                              ELSE
                            --Buscamos la nueva id del padre en la tabla temporal
                                   SELECT
                                          id_uc
                                    INTO
                                          v_id_fk
                                    FROM temp_id
                                WHERE id_uc_pl = v_id_unidad_constructiva_plantilla_fk;
                              END IF;
                          --Actualizammos las nuevas id
                          UPDATE pro.tunidad_constructiva SET
                              id_unidad_constructiva_fk = v_id_fk
                          WHERE  id_unidad_constructiva = v_id.id_uc ;
                        END IF;

               END LOOP;



      --Definicion de la respuesta
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Centro de Costo desde planilla almacenado(a) con exito');
           --v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_cc',v_id_tipo_cc::varchar);

            --Devuelve la respuesta
            return v_resp;

    end;

        /*********************************
     #TRANSACCION:  'PRO_UNCDELARB_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        egutierrez
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    elsif(p_transaccion='PRO_UNCDELARB_ELI')then

        begin
            --Sentencia de la eliminacion
            --raise exception 'v_parametros %',v_parametros.id_unidad_constructiva;
            --funcion que elimina u arbol a parir de un nodo de inicio
            v_resp = pxp.f_delete_arbol('pro','tunidad_constructiva','id_unidad_constructiva','id_unidad_constructiva_fk',v_parametros.id_unidad_constructiva);

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Unidades Constructivas eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_unidad_constructiva',v_parametros.id_unidad_constructiva::varchar);

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