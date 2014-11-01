

-- DROP FUNCTION fn_formato_fecha(timestamp without time zone, timestamp without time zone, integer);

CREATE OR REPLACE FUNCTION fn_formato_fecha(_fecha timestamp without time zone, _datetime timestamp without time zone DEFAULT NULL::timestamp without time zone, _mostrar integer DEFAULT 6)
  RETURNS text AS
$BODY$
declare _texto text='';
--_segundos integer=0;
_varnumero integer=0;
--_varmod integer=0;
_varinterval interval;
begin
   if(_fecha is not null)then
             
      --verificar si es nulo el datetime
      select case when _datetime is null then CURRENT_TIMESTAMP else _datetime end into _datetime;
      --verificar el mostrar
      select case when (_mostrar<1 or _mostrar>6) then 6 else _mostrar end into _mostrar; 
      --obtener el interval
      select age(_datetime, _fecha) into _varinterval;
      --verificar si es 0 la diferencia
      if(_varinterval>=interval '1 second' or _varinterval<=interval '-1 second' )then
        --ver mensaje
        select case when _varinterval<interval '1 second' then 'Faltan ' else  'Hace ' end into _texto;
        --obtener los años
        select abs(extract(year from _varinterval)) into _varnumero; --se extraen los dias y se transforman en segundos
        --verificar si se muestra o no el valor año
        if(_mostrar>0)then
           select _texto||case when _varnumero>0 then case when _varnumero=1 then _varnumero::text||' Año ' else _varnumero::text||' Años ' end else '' end,case when _varnumero=0 then _mostrar else _mostrar-1 end into _texto,_mostrar;
        end if;
        --obtener los meses
        select abs(extract(month from _varinterval)) into _varnumero; --se extraen los dias y se transforman en segundos
        --verificar si se muestra o no el valor año
        if(_mostrar>0)then
           select _texto||case when _varnumero>0 then case when _varnumero=1 then _varnumero::text||' Mes ' else _varnumero::text||' Meses ' end else '' end,case when _varnumero=0 then _mostrar else _mostrar-1 end into _texto,_mostrar;
        end if;
        --obtener los dias
        select abs(extract(day from _varinterval)) into _varnumero; --se extraen los dias y se transforman en segundos
        --verificar si se muestra o no el valor año
        if(_mostrar>0)then
           select _texto||case when _varnumero>0 then case when _varnumero=1 then _varnumero::text||' Día ' else _varnumero::text||' Días ' end else '' end,case when _varnumero=0 then _mostrar else _mostrar-1 end into _texto,_mostrar;
        end if;
        --obtener los horas
        select abs(extract(hour from _varinterval)) into _varnumero; --se extraen los dias y se transforman en segundos
        --verificar si se muestra o no el valor año
        if(_mostrar>0)then
           select _texto||case when _varnumero>0 then case when _varnumero=1 then _varnumero::text||' Hora ' else _varnumero::text||' Horas ' end else '' end,case when _varnumero=0 then _mostrar else _mostrar-1 end into _texto,_mostrar;
        end if;
        --obtener los minutos
        select abs(extract(minute from _varinterval)) into _varnumero; --se extraen los dias y se transforman en segundos
        --verificar si se muestra o no el valor año
        if(_mostrar>0)then
           select _texto||case when _varnumero>0 then case when _varnumero=1 then _varnumero::text||' Minuto ' else _varnumero::text||' Minutos ' end else '' end,case when _varnumero=0 then _mostrar else _mostrar-1 end into _texto,_mostrar;
        end if;
        --obtener los segundos
        select floor(abs(extract(second from _varinterval)))::integer into _varnumero; --se extraen los dias y se transforman en segundos
        --verificar si se muestra o no el valor año
        if(_mostrar>0)then
           select _texto||case when _varnumero>0 then case when _varnumero=1 then _varnumero::text||' Segundo ' else _varnumero::text||' Segundos ' end else '' end,case when _varnumero=0 then _mostrar else _mostrar-1 end into _texto,_mostrar;
        end if;
      else
         --ver mensaje
         select 'Ahora' into _texto;
      end if;
   end if;
  --return to_char(_fecha, 'DD-MM-YYYY HH24:MI');
  return trim(_texto);
end
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

