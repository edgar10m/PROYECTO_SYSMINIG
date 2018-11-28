unit ptscnv;

interface
var
   mensaje_error:string;
   function inicia:boolean;
   function set_inicio(ini:integer):boolean;
   function set_final(fin:integer):boolean;
   function chas(viejo,nuevo:string):boolean;
   function procesa(old_source,new_source:string):boolean;
implementation
uses sysutils;
type Tchas=record
   original:string;
   nuevo:string;
end;
var
   w_inicio:integer;   // columna de inicio
   w_final:integer;     // columna final
   w_chas:array of Tchas; // Cambio de String
function inicia:boolean;
begin
   w_inicio:=0;
   w_final:=0;
   setlength(w_chas,0);
end;
function set_inicio(ini:integer):boolean;
begin
   if w_final>0 then begin
      if ini>w_final then begin
         set_inicio:=false;
         exit;
      end;
   end;
   w_inicio:=ini;
   set_inicio:=true;
end;
function set_final(fin:integer):boolean;
begin
   if w_inicio>0 then begin
      if w_inicio>fin then begin
         set_final:=false;
         exit;
      end;
   end;
   w_final:=fin;
   set_final:=true;
end;
function chas(viejo,nuevo:string):boolean;
var k:integer;
begin
   k:=length(w_chas);
   setlength(w_chas,k+1);
   w_chas[k].original:=viejo;
   w_chas[k].nuevo:=nuevo;
   chas:=true;
end;
function procesa(old_source,new_source:string):boolean;
var
   fold: TextFile;
   fnew: TextFile;
   linea,pal,npal:string;
   i,longi:integer;
begin
   if FileExists(old_source)=false then begin
      mensaje_error:='No existe el archivo '+old_source;
      procesa:=false;
      exit;
   end;
   longi:=w_final-w_inicio+1;
   AssignFile(fold,old_source);
   AssignFile(fnew,new_source);
   Rewrite(fnew);
   Reset( Fold );
   readln(fold,linea);
   repeat begin
      pal:=copy(linea,w_inicio,longi);
      npal:=trimright(pal);
      for i:=0 to length(w_chas)-1 do begin
         npal:=stringreplace(npal,w_chas[i].original,w_chas[i].nuevo,[rfreplaceall]);
      end;
      if length(npal)>longi then begin
         mensaje_error:='NO IMPLEMENTADO';
         procesa:=false;
         exit;
      end;
      for i:=0 to longi-length(npal)-1 do
         npal:=npal+' ';
      if w_inicio>1 then
         npal:=copy(linea,1,w_inicio-1)+npal+copy(linea,w_final+1,1000)
      else
         npal:=npal+copy(linea,w_final+1,1000);
      writeln(fnew,npal);
      linea:='';
      readln( Fold, linea );
   end;
   until (EOF( Fold )) and (trim(linea)='');
   closefile(fold);
   closefile(fnew);
   procesa:=true;
end;
end.
