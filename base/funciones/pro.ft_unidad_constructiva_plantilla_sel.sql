--------------- SQL ---------------

CREATE OR REPLACE FUNCTION pro.ft_unidad_constructiva_plantilla_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_unidad_constructiva_plantilla_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_constructiva'
 AUTOR:          (egutierrez)
 FECHA:            06-05-2019 14:16:09
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #16                   06-05-2019 14:16:09 EGS                  Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'pro.tunidad_constructiva'    
 #
 ***************************************************************************/

DECLARE

    v_consulta            varchar;
    v_parametros          record;
    v_nombre_funcion       text;
    v_resp                varchar;
    v_where                varchar;
    v_where2                varchar; 
    v_filtro                varchar;           
BEGIN

    v_nombre_funcion = 'pro.ft_unidad_constructiva_plantilla_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_UNCONPL_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        egutierrez    
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    if(p_transaccion='PRO_UNCONPL_SEL')then
                     
        begin
            --Sentencia de la consulta
            v_consulta:='select
                        unconpl.id_unidad_constructiva_plantilla,
                        unconpl.estado_reg,
                        unconpl.nombre,
                        unconpl.codigo,
                        unconpl.fecha_reg,
                        unconpl.usuario_ai,
                        unconpl.id_usuario_reg,
                        unconpl.id_usuario_ai,
                        unconpl.id_usuario_mod,
                        unconpl.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        unconpl.descripcion,
                        unconpl.id_unidad_constructiva_plantilla_fk,
                        unconpl.activo  
                        from pro.tunidad_constructiva_plantilla unconpl
                        inner join segu.tusuario usu1 on usu1.id_usuario = unconpl.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = unconpl.id_usuario_mod
                        where  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;
                        
        end;

    /*********************************    
     #TRANSACCION:  'PRO_UNCONPL_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        egutierrez    
     #FECHA:        06-05-2019 14:16:09
    ***********************************/

    elsif(p_transaccion='PRO_UNCONPL_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(unconpl.id_unidad_constructiva_plantilla)
                        from pro.tunidad_constructiva_plantilla unconpl
                        inner join segu.tusuario usu1 on usu1.id_usuario = unconpl.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = unconpl.id_usuario_mod
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;
      /*********************************   
       #TRANSACCION:  'PRO_UNCONPLARB_SEL'
       #DESCRIPCION:  Consulta fases por proyecto de tipo árbol
       #AUTOR:        EGS
       #FECHA:        
      ***********************************/

      elseif(p_transaccion='PRO_UNCONPLARB_SEL')then
                      
          begin
              
              if(coalesce(v_parametros.node,'id') = 'id') then
                  v_where = 'unconpl.id_unidad_constructiva_plantilla_fk is null ';
                  v_where2 = 'unconpl.id_unidad_constructiva_plantilla is null ';  
              
              else
                  v_where = ' unconpl.id_unidad_constructiva_plantilla_fk = '||v_parametros.node;
                  v_where2 = ' unconpl.id_unidad_constructiva_plantilla = '||v_parametros.node;
              end if;
            
              
             -- raise notice 'EP: %',v_parametros.id_ep;

              v_filtro = ' 0=0 ';
                
              --Consulta
              --se hizo un with para la suma de los precios de los items por fase
              v_consulta:='                
                     select
                        unconpl.id_unidad_constructiva_plantilla,
                        unconpl.estado_reg,
                        unconpl.nombre,
                        unconpl.codigo,
                        unconpl.fecha_reg,
                        unconpl.usuario_ai,
                        unconpl.id_usuario_reg,
                        unconpl.id_usuario_ai,
                        unconpl.id_usuario_mod,
                        unconpl.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        unconpl.descripcion,
                        unconpl.id_unidad_constructiva_plantilla_fk,    
                          case
                          when coalesce(unconpl.id_unidad_constructiva_plantilla_fk,0) = 0 then ''raiz''::varchar
                              else ''hijo''::varchar
                          end as tipo_nodo,
                        unconpl.activo                        
                      from pro.tunidad_constructiva_plantilla unconpl
                        inner join segu.tusuario usu1 on usu1.id_usuario = unconpl.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = unconpl.id_usuario_mod
                      where  '||v_where|| ' and ' || v_parametros.filtro || ' and '||v_filtro;
                          
              raise notice '%',v_consulta;
             
              --Devuelve la respuesta
              return v_consulta;
                         
          end;
                    
    else
                         
        raise exception 'Transaccion inexistente';
                             
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