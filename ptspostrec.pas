unit ptspostrec;
interface
uses Classes,ADODB,Dialogs,sysutils;
type
   Tvars=record
      nombre:string;
      valor:string;
   end;
type
   Tlocs=record
      occlase:string;
      ocbib:string;
      ocprog:string;
      dcclase:string;
      dcbib:string;
      dcprog:string;
      scclase:string;
      scbib:string;
      scprog:string;
      pcclase:string;
      pcbib:string;
      pcprog:string;
      clase:string;
      bib:string;
      prog:string;
      hcclase:string;
      hcbib:string;
      hcprog:string;
      modo:string;
      organizacion:string;
      externo:string;
   end;
var
   vv:array of Tvars;
   n_vv:array of Tvars;
   lk:array of Tvars;
   n_lk:array of Tvars;
   locs:array of Tlocs;
   loc_existente,loc_reemplazado,loc_no_reemplazado:integer;
   lista,repetidos:Tstringlist;
   function subpal(fuente:string; n:integer; separador:string):string;
   function busca_variable(variable:string):integer;
   function busca_logico(variable:string):integer;
   procedure lee_globales;
   procedure lee_locs(dcclase:string; dcbib:string; dcprog:string;
      scclase:string; scbib:string; scprog:string;
      clase:string; bib:string; prog:string);
   function empareja_locs(n:integer; bib:string; prog:string):integer;
   procedure genera_link(z:integer);
   procedure genera_dcl_cbl_fil(sistema:string);

implementation
uses ptsdm;
procedure lee_globales;
var lis:Tstringlist;
   i,j,k:integer;
   paso:string;
begin
   setlength(vv,0);
   setlength(lk,0);
   dm.get_utileria('GLOBAL_DCL',g_tmpdir+'\GLOBAL_DCL');
   lis:=Tstringlist.Create;
   lis.LoadFromFile(g_tmpdir+'\GLOBAL_DCL');
   for i:=0 to lis.Count-1 do begin
      j:=pos('|G|',lis[i]);
      if j>0 then begin
         k:=length(vv);
         setlength(vv,k+1);
         paso:=copy(lis[i],j+3,1000);
         j:=pos('|',paso);
         vv[k].nombre:=copy(paso,1,j-1);
         paso:=copy(paso,j+1,1000);
         j:=pos('|',paso);
         vv[k].valor:=copy(paso,1,j-1);
         continue;
      end;
      j:=pos('|L|',lis[i]);
      if j>0 then begin
         k:=length(lk);
         setlength(lk,k+1);
         paso:=copy(lis[i],j+3,1000);
         j:=pos('|',paso);
         lk[k].nombre:=copy(paso,1,j-1);
         paso:=copy(paso,j+1,1000);
         j:=pos('|',paso);
         lk[k].valor:=copy(paso,1,j-1);
         continue;
      end;
   end;
end;
procedure lee_locs(dcclase:string; dcbib:string; dcprog:string;
   scclase:string; scbib:string; scprog:string;
   clase:string; bib:string; prog:string);
var qq:Tadoquery;
   k:integer;
   padre:string;
begin
   padre:=clase+'_'+bib+'_'+prog;
   if repetidos.IndexOf(padre)>-1 then
      exit;
   repetidos.Add(padre);
   if (clase='DCL') or           // CLASES_PROCEDURALES agregar
      (clase='DCT') or
      (clase='JCL') then begin
      dcclase:=clase;
      dcbib:=bib;
      dcprog:=prog;
   end;
   if clase='STE' then begin
      scclase:=clase;
      scbib:=bib;
      scprog:=prog;
   end;
   qq:=Tadoquery.Create(nil);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsrela '+
      ' where pcprog='+g_q+prog+g_q+
      ' and   pcbib='+g_q+bib+g_q+
      ' and   pcclase='+g_q+clase+g_q) then begin
      while not qq.Eof do begin
         if qq.fieldbyname('hcclase').AsString='LOC' then begin
            k:=length(locs);
            setlength(locs,k+1);
            locs[k].occlase:=qq.fieldbyname('occlase').AsString;
            locs[k].ocbib:=qq.fieldbyname('ocbib').AsString;
            locs[k].ocprog:=qq.fieldbyname('ocprog').AsString;
            locs[k].dcclase:=dcclase;
            locs[k].dcbib:=dcbib;
            locs[k].dcprog:=dcprog;
            locs[k].scclase:=scclase;
            locs[k].scbib:=scbib;
            locs[k].scprog:=scprog;
            locs[k].pcclase:=qq.fieldbyname('pcclase').AsString;
            locs[k].pcbib:=qq.fieldbyname('pcbib').AsString;
            locs[k].pcprog:=qq.fieldbyname('pcprog').AsString;
            locs[k].clase:='LOC';
            locs[k].bib:=qq.fieldbyname('hcbib').AsString;
            locs[k].prog:=qq.fieldbyname('hcprog').AsString;
            locs[k].modo:=qq.fieldbyname('modo').AsString;
            locs[k].organizacion:=qq.fieldbyname('organizacion').AsString;
            locs[k].externo:=qq.fieldbyname('externo').AsString;
            if dm.sqlselect(dm.q5,'select * from tsrela '+
               ' where pcprog='+g_q+locs[k].prog+g_q+
               ' and   pcbib='+g_q+locs[k].bib+g_q+
               ' and   pcclase='+g_q+locs[k].clase+g_q) then begin
               locs[k].hcclase:=dm.q5.fieldbyname('hcclase').AsString;
               locs[k].hcbib:=dm.q5.fieldbyname('hcbib').AsString;
               locs[k].hcprog:=dm.q5.fieldbyname('hcprog').AsString;
            end;
            lista.Add(
               locs[k].occlase+','+
               locs[k].ocbib+','+
               locs[k].ocprog+','+
               locs[k].dcclase+','+
               locs[k].dcbib+','+
               locs[k].dcprog+','+
               locs[k].scclase+','+
               locs[k].scbib+','+
               locs[k].scprog+','+
               locs[k].pcclase+','+
               locs[k].pcbib+','+
               locs[k].pcprog+','+
               locs[k].clase+','+
               locs[k].bib+','+
               locs[k].prog+','+
               locs[k].hcclase+','+
               locs[k].hcbib+','+
               locs[k].hcprog+','+
               locs[k].modo+','+
               locs[k].organizacion+','+
               locs[k].externo);
         end
         else begin
            if (qq.fieldbyname('hcclase').AsString<>clase) or
               (qq.fieldbyname('hcbib').AsString<>bib) or
               (qq.fieldbyname('hcprog').AsString<>prog) then begin
               lee_locs(dcclase,
                  dcbib,
                  dcprog,
                  scclase,
                  scbib,
                  scprog,
                  qq.fieldbyname('hcclase').AsString,
                  qq.fieldbyname('hcbib').AsString,
                  qq.fieldbyname('hcprog').AsString);
            end;
         end;
         qq.Next;
      end;
   end;
   qq.Free;
end;
function empareja_locs(n:integer; bib:string; prog:string):integer;
var i:integer;
begin
   for i:=n to length(locs)-1 do begin
      if (locs[i].prog=prog) and
         (locs[i].bib<>bib) and
         (locs[i].hcprog<>'') then begin
         empareja_locs:=i;
         exit;
      end;
   end;
   if copy(prog,length(prog),1)=':' then  // prepara segunda vuelta, elimina o agrega : al final
      delete(prog,length(prog),1)
   else
      prog:=prog+':';
   for i:=0 to length(locs)-1 do begin
      if (locs[i].prog=prog) and
         (locs[i].bib<>bib) and
         (locs[i].hcprog<>'') then begin
         empareja_locs:=i;
         exit;
      end;
   end;
   empareja_locs:=-1;
end;
function subpal(fuente:string; n:integer; separador:string):string;
var k:integer;
begin
   while n>0 do begin
      k:=pos(separador,fuente);
      if k>0 then begin
         if n=1 then begin
            subpal:=copy(fuente,1,k-1);
            exit;
         end;
         fuente:=copy(fuente,k+1,1000)
      end
      else begin
         if n=1 then begin
            subpal:=fuente;
            exit;
         end
         else begin
            subpal:='';
            exit;
         end;
      end;
      n:=n-1;
   end;
   subpal:='';
end;
function busca_variable(variable:string):integer;
var i:integer;
begin
   for i:=0 to length(vv)-1 do begin
      if vv[i].nombre=variable then begin
         busca_variable:=i;
         exit;
      end;
   end;
   busca_variable:=-1;
end;
function busca_logico(variable:string):integer;
var i:integer;
begin
   for i:=0 to length(lk)-1 do begin
      if lk[i].nombre=variable then begin
         busca_logico:=i;
         exit;
      end;
   end;
   busca_logico:=-1;
end;
procedure genera_link(z:integer);
var k,n:integer;
    variable,prog,locprog:string;
    b_ok,b_cambia:boolean;
begin
   b_ok:=true;
   b_cambia:=true;
   prog:=locs[z].prog;
   locprog:=prog;
   while b_cambia do begin
      b_cambia:=false;
      k:=pos('''',prog);
      while k>0 do begin   // reemplaza variables
         variable:=subpal(prog,2,'''');
         n:=busca_variable(variable);
         if n>-1 then begin
            b_cambia:=true;
            if k=1 then
               prog:=vv[n].valor+copy(prog,k+length(variable)+2,1000)
            else
               prog:=copy(prog,1,k-1)+vv[n].valor+copy(prog,k+length(variable)+2,1000);
         end
         else begin
            b_ok:=false;
            if k=1 then
               prog:=copy(prog,k+length(variable)+2,1000)
            else
               prog:=copy(prog,1,k-1)+copy(prog,k+length(variable)+2,1000);
         end;
         k:=pos('''',prog);
      end;
      k:=pos(':',prog);
      if k>0 then begin    // reemplaza lógico
         variable:=copy(prog,1,k-1);
         n:=busca_logico(variable);
         if n>0 then begin
            b_cambia:=true;
            prog:=lk[n].valor+copy(prog,k+1,1000);
         end;
      end
      else begin
         n:=busca_logico(prog);
         if n>0 then begin
            b_cambia:=true;
            prog:=lk[n].valor;
         end;
      end;
   end;
   if b_ok then begin
      inc(loc_reemplazado);
      dm.sqlinsert('insert into tsrela '+
         '(PCPROG,PCBIB,PCCLASE,HCPROG,HCBIB,'+
         'HCCLASE,'+
         //'MODO,ORGANIZACION,EXTERNO,'+
         'COMENT,ORDEN,SISTEMA,'+
         'OCPROG,OCBIB,OCCLASE)'+
         //',ATRIBUTOS,'+
         //'LINEAINICIO,LINEAFINAL,AMBITO,ICPROG,ICBIB,'+
         //'ICCLASE,POLIMORFISMO,XCCLASE,AUXILIAR,HSISTEMA,'+
         //'HPARAMETROS,HINTERFASE) '+
         ' values('+
         g_q+locs[z].scprog+g_q+','+
         g_q+locs[z].scbib+g_q+','+
         g_q+locs[z].scclase+g_q+','+
         g_q+locprog+g_q+','+
         g_q+'linked_'+locs[z].dcprog+'_'+locs[z].scprog+'_'+locs[z].bib+g_q+','+
         g_q+'LOC'+g_q+','+
         g_q+'linked'+g_q+','+
         g_q+'0000'+g_q+','+
         g_q+dm.q1.fieldbyname('sistema').AsString+g_q+','+
         g_q+locs[z].dcprog+g_q+','+
         g_q+locs[z].dcbib+g_q+','+
         g_q+locs[z].dcclase+g_q+')');
      dm.sqlinsert('insert into tsrela '+
         '(PCPROG,PCBIB,PCCLASE,HCPROG,HCBIB,'+
         'HCCLASE,'+
         'MODO,ORGANIZACION,EXTERNO,'+
         'COMENT,ORDEN,SISTEMA,'+
         'OCPROG,OCBIB,OCCLASE)'+
         //',ATRIBUTOS,'+
         //'LINEAINICIO,LINEAFINAL,AMBITO,ICPROG,ICBIB,'+
         //'ICCLASE,POLIMORFISMO,XCCLASE,AUXILIAR,HSISTEMA,'+
         //'HPARAMETROS,HINTERFASE) '+
         ' values('+
         g_q+locprog+g_q+','+
         g_q+'linked_'+locs[z].dcprog+'_'+locs[z].scprog+'_'+locs[z].bib+g_q+','+
         g_q+'LOC'+g_q+','+
         g_q+prog+g_q+','+
         g_q+'DISK'+g_q+','+
         g_q+'FIL'+g_q+','+
         g_q+locs[z].modo+g_q+','+
         g_q+locs[z].organizacion+g_q+','+
         g_q+locs[z].externo+g_q+','+
         g_q+'linked'+g_q+','+
         g_q+'0000'+g_q+','+
         g_q+dm.q1.fieldbyname('sistema').AsString+g_q+','+
         g_q+locs[z].dcprog+g_q+','+
         g_q+locs[z].dcbib+g_q+','+
         g_q+locs[z].dcclase+g_q+')');
   end
   else
      inc(loc_no_reemplazado);
end;
procedure genera_dcl_cbl_fil(sistema:string);
var k,i,j:integer;
begin
   lista:=Tstringlist.Create;
   repetidos:=Tstringlist.Create;
   lee_globales;
   if dm.sqlselect(dm.q1,'select * from tsprog '+    // procesa DCLs encontrados en TSPROG
      ' where cclase in ('+g_q+'DCL'+g_q+','+g_q+'DCT'+g_q+')'+   // CLASES_PROCEDURALES agregar
      ' and sistema='+g_q+sistema+g_q+
      ' order by sistema,cbib,cprog') then begin
      while not dm.q1.Eof do begin
         dm.sqldelete('delete tsrela '+                 // borra cadenas anteriores
            ' where ocprog='+g_q+dm.q1.fieldbyname('cprog').AsString+g_q+
            ' and   ocbib='+g_q+dm.q1.fieldbyname('cbib').AsString+g_q+
            ' and   occlase='+g_q+dm.q1.fieldbyname('cclase').AsString+g_q+
            ' and   sistema='+g_q+sistema+g_q+
            ' and   coment='+g_q+'linked'+g_q);
         repetidos.clear;
         setlength(locs,0);
         lee_locs(dm.q1.FieldByName('cclase').AsString,
            dm.q1.FieldByName('cbib').AsString,
            dm.q1.FieldByName('cprog').AsString,
            dm.q1.FieldByName('cclase').AsString,
            dm.q1.FieldByName('cbib').AsString,
            dm.q1.FieldByName('cprog').AsString,
            dm.q1.FieldByName('cclase').AsString,
            dm.q1.FieldByName('cbib').AsString,
            dm.q1.FieldByName('cprog').AsString);
         //lista.SaveToFile(g_tmpdir+'\salida.csv');
         for i:=0 to length(locs)-1 do begin
            if trim(locs[i].hcprog)='' then begin
               k:=0;
               for j:=i-1 downto 0 do begin     // revisa que no se haya procesado anteriormente
                  if (trim(locs[j].hcprog)='') and
                     (locs[j].prog=locs[i].prog) then begin
                     k:=-1;
                     break;
                  end;
               end;
               if k=-1 then
                  continue;
               k:=-1;
               k:=empareja_locs(k+1,locs[i].bib,locs[i].prog);
               if k=-1 then
                  genera_link(i)
               else
                  inc(loc_existente); // Ya existe, no hace nada
            end;
         end;
         dm.q1.Next;
      end;
   end;
   showmessage('Existentes     :'+inttostr(loc_existente)+chr(13)+
      'Reemplazados   :'+inttostr(loc_reemplazado)+chr(13)+
      'No reemplazados:'+inttostr(loc_no_reemplazado));
end;



end.
