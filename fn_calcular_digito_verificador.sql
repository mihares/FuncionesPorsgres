
CREATE OR REPLACE FUNCTION fn_calcular_digito_verificador(
	_documento character varying)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    VOLATILE SECURITY DEFINER 
AS $function$
declare v_total int default 0;
declare v_resto integer;
declare p_basemax integer default 11;

declare k smallint default 2;
declare v_numero_aux smallint;
declare v_numero_al VARCHAR(30) default '';
declare v_caracter CHAR(1);
declare v_digit smallint default 0;
declare i int default 1;
begin
	while  (i < length($1) + 1)
    loop
        v_caracter:= UPPER(SUBSTRing($1,i,1));
        IF ASCII(v_caracter) NOT BETWEEN 48 AND 57 
        then
        	v_numero_al:= v_numero_al || ASCII(v_caracter);
        ELSE
            v_numero_al:= v_numero_al || v_caracter;
        end if;

        i:= i + 1;
    END loop;
    
    i:= LENgth(v_numero_al);
    while (i > 0)loop
        IF ("k" > p_basemax)then
            "k":= 2;
        end if;

        v_numero_aux:= SUBSTRing(v_numero_al,i,1);
        v_total:= v_total + (v_numero_aux * "k");
        "k":= "k" + 1;
        i:= i - 1;
    end loop;

    v_resto:= (v_total % p_basemax);
    IF v_resto > 1 then
        v_digit:= p_basemax - v_resto;
    eND if;

    RETURN v_digit;
end
$function$;
