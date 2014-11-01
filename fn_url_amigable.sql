
-- DROP FUNCTION fn_url_amigable(character varying);

CREATE OR REPLACE FUNCTION fn_url_amigable(var_texto character varying)
  RETURNS character varying AS
$BODY$
declare 
   URL varchar default '';
   caracter char(1);
   aux char(1);
   i integer default 1;
   texto varchar(255) default trim(lower(var_texto));
   primercaracter integer default 1;
begin
   --elimminar dobles espacios
   select array_to_string(regexp_split_to_array(texto,E'\\s+'),' ') into texto;
   --recorremos letra por letra
   WHILE (i < length(texto) + 1) LOOP
      --obtenemos el primer caracter
      caracter = SUBSTRing(texto,i,1);
      --verificamos que estee entre a-z
      IF ((ASCII(caracter) NOT BETWEEN 48 AND 57) and (ASCII(caracter) NOT BETWEEN 97 AND 122))then
         --reemplazo los caracteres
         aux = case 
         when caracter = 'ñ' then 'n'
         when caracter = 'á' then 'a'
         when caracter = 'é' then 'e'
         when caracter = 'í' then 'i'
         when caracter = 'ó' then 'o'
         when caracter = 'ú' then 'u'
         when caracter = '-' then '-'
         when caracter = '+' then '-'
         when caracter = ' ' then '-'
         when caracter = '' then '-'
         when caracter = '_' then '-'
         else '' end;
         --verificamos que el exista el primer carcter
         if ((ASCII(aux) NOT BETWEEN 48 AND 57) and (ASCII(aux) NOT BETWEEN 97 AND 122) and primercaracter=1)then
            aux='';
         else
            primercaracter = 0;
         end if;
         
      else
         primercaracter = 0;
         aux=caracter;
      end if;
      URL= URL||aux;
      i = i + 1; 
   END LOOP;
   /*primercaracter = 1;
   loop 
      aux = SUBSTRing(URL,-1,1);
      if ((ASCII(aux) NOT BETWEEN 48 AND 57) and (ASCII(aux) NOT BETWEEN 97 AND 122))then
         URL = SUBSTRing(URL,1,length(URL)-1);
      else
         primercaracter = 0;
      end if;
exit when primercaracter = 0;
END loop;*/
return URL;
end
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
