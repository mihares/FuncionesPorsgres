
-- DROP FUNCTION fn_limpiar_texto(text, integer);

CREATE OR REPLACE FUNCTION fn_limpiar_texto(_var_text text, _funcion integer)
  RETURNS text AS
$BODY$
/*variables de las funciones*/
DECLARE _textString text; _htmlEncode text[][];
/*variable de las funciones*/
_cantidadFunciones integer;_funcionesEjecutar integer[];
begin
--funciones
/*
1 eliminar tags html sustituirlo por espacios
2 caracteres a reemplzara
3 sacar acentos
4 caracteres alfanumericos incluidos ñ y Ñ
5 reemplzar los dobles epacios dejar al ultimo
*/
select 5 into _cantidadFunciones;

/*variable*/
 _textString = _var_text; 

--obtener las funciones a ejecutar
select array_agg(a) into _funcionesEjecutar from generate_series(1,_cantidadFunciones) as a where abs(_funcion)&power(2,a-1)::integer!=0;
--verificar si hay funciones
if _funcionesEjecutar is null then
	return _textString;
end if;

/*1 eliminar tags sustituirlo por espacios*/
if 1 = any (_funcionesEjecutar) then
	SELECT regexp_replace(regexp_replace(_textString, E'(?x)<[^>]*?(\s alt \s* = \s* ([\'"]) ([^>]*?) \2) [^>]*? >', E'\3'), E'(?x)(< [^>]*? >)', '', 'g') into _textString;
end if;

/*2 caracteres a reemplzara*/
if 2 = any (_funcionesEjecutar) then
	select array[
	['&quot;',''''],
	['&apos;','"'],
	['&ntilde;','ñ'],
	['&Ntilde;','Ñ'],
	['&amp;','&'],
	['&lt;','<'],
	['&gt;','>'],
	['&nbsp;',' '],
	['&iexcl;','¡'],
	['&cent;','¢'],
	['&pound;','£'],
	['&curren;','¤'],
	['&yen;','¥'],
	['&brvbar;','¦'],
	['&sect;','§'],
	['&uml;','¨'],
	['&copy;','©'],
	['&ordf;','ª'],
	['&laquo;','«'],
	['&not;','¬'], 
	['&shy;','­'],
	['&reg;','®'],
	['&macr;','¯'],
	['&deg;','°'],
	['&plusmn;','±'],
	['&sup2;','²'],
	['&sup3;','³'],
	['&acute;','´'],
	['&micro;','µ'],
	['&para;','¶'],
	['&middot;','·'],
	['&cedil;','¸'],
	['&sup1;','¹'],
	['&ordm;','º'],
	['&raquo;','»'],
	['&frac14;','¼'],
	['&frac12;','½'],
	['&frac34;','¾'],
	['&iquest;','¿'],
	['&times;','×'],
	['&divide;','÷'], 
	['&Agrave;','À'],
	['&Aacute;','Á'],
	['&Acirc;','Â'],
	['&Atilde;','Ã'],
	['&Auml;','Ä'],
	['&Aring;','Å'],
	['&AElig;','Æ'],
	['&Ccedil;','Ç'],
	['&Egrave;','È'],
	['&Eacute;','É'],
	['&Ecirc;','Ê'],
	['&Euml;','Ë'],
	['&Igrave;','Ì'],
	['&Iacute;','Í'],
	['&Icirc;','Î'],
	['&Iuml;','Ï'],
	['&ETH;','Ð'],
	['&Ntilde;','Ñ'],
	['&Ograve;','Ò'],
	['&Oacute;','Ó'],
	['&Ocirc;','Ô'],
	['&Otilde;','Õ'],
	['&Ouml;','Ö'],
	['&Oslash;','Ø'],
	['&Ugrave;','Ù'],
	['&Uacute;','Ú'],
	['&Ucirc;','Û'],
	['&Uuml;','Ü'],
	['&Yacute;','Ý'],
	['&THORN;','Þ'],
	['&szlig;','ß'],
	['&agrave;','à'],
	['&aacute;','á'],
	['&acirc;','â'],
	['&atilde;','ã'],
	['&auml;','ä'],
	['&aring;','å'],
	['&aelig;','æ'],
	['&ccedil;','ç'],
	['&egrave;','è'],
	['&eacute;','é'],
	['&ecirc;','ê'],
	['&euml;','ë'],
	['&igrave;','ì'],
	['&iacute;','í'],
	['&icirc;','î'],
	['&iuml;','ï'],
	['&eth;','ð'],
	['&ntilde;','ñ'],
	['&ograve;','ò'],
	['&oacute;','ó'],
	['&ocirc;','ô'],
	['&otilde;','õ'],
	['&ouml;','ö'],
	['&oslash;','ø'],
	['&ugrave;','ù'], 
	['&uacute;','ú'],
	['&ucirc;','û'],
	['&uuml;','ü'],
	['&yacute;','ý'],
	['&thorn;','þ'],
	['&yuml;','ÿ'],
	['&ndash;','–'],
	['&mdash;','—'],
	['&ldquo;','“'],
	['&rdquo;','”'],
	['&hellip;','…'],
	['&rsquo;','’'], 
	['&lsquo;','‘'],
	['&amp;','&']
	] into _htmlEncode;
	--el & debe ir al ultimo

	/*recorrer*/
	FOR j IN array_lower(_htmlEncode, 1)..array_upper(_htmlEncode, 1) LOOP
		/* reemplazar htmlerntities*/
		IF  strpos(_var_text, _htmlEncode[j][1] ) >0THEN 
			_textString = REPLACE(_textString, _htmlEncode[j][1],_htmlEncode[j][2]) ; 
		END IF ; 
	end loop;
end if;

/*3 sacar acentos*/
if 3 = any (_funcionesEjecutar) then
	select translate(_textString,'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜãẽĩõũỹÃẼĨÕŨỸýÝ','aeiouAEIOUaeiouAEIOUaeiouyAEIOUYyY') into _textString;
end if;

/*4 caracteres alfanumericos incluidos ñ y Ñ*/
if 4 = any (_funcionesEjecutar) then
	select regexp_replace(_textString, '[^A-Za-z0-9\sñÑáéíóúÁÉÍÓÚ]', '','g') into _textString;
end if;

/*5 reemplzar los dobles epacios dejar al ultimo*/
if 5 = any (_funcionesEjecutar) then
	select trim(regexp_replace(_textString, '\s+', ' ','g')) into _textString;
end if;

/*retornar*/
RETURN _textString; 
end
$BODY$
  LANGUAGE plpgsql IMMUTABLE SECURITY DEFINER;
