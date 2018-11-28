unit ptsvmlimp9;

interface
uses classes,ADODB,sysutils;
type  Tclasecolor=record
         clase:string;
         color:string;
      end;
type  Tcompon=record
         clase:string;
         bib:string;
         prog:string;
         ren:integer;
         col:integer;
         desplaza:integer;
      end;
var
  vmllis:Tstringlist;
  vmlfisicos:Tstringlist;
  ren:integer=0;
  desplaza:integer=0;
  ancho:integer=800;
  alto:integer=250; //220;
  es_bbva:boolean=false;
  es_linea:boolean=false;
  vmlcol:array of Tclasecolor;
  vmlcom:array of Tcompon;
  xbas:Tstringlist;
  vmlyy:Tstringlist;
  nu_co,nu_li:integer;
  procedure vml_clasecolor(clase:string; colo:string);
  function  vml_ccolor(clase:string):string;
  procedure vml_impacto(clase:string; bib:string; prog:string;
   subtitulo:string; tabla:string; archivo_html:string; archivo_lista:string='');
implementation
uses ptsdm,ptsvmlx,ptsgral;
procedure vml_clases;
var
   lwInSQL : string;
   prodclase,lwSale, Wuser, lwLista : String;
   m : tstringlist;
   j : Integer;
begin
   vmlfisicos:=Tstringlist.Create;
   //if dm.sqlselect(dm.q1,'select * from tsclase where objeto='+g_q+'FISICO'+g_q+' order by cclase') then begin
{   if dm.sqlselect(dm.q1,'select * from tsclase where diagramabloque='+g_q+'ACTIVO'+g_q+
                         ' and  estadoactual ='+g_q+'ACTIVO'+g_q+' order by cclase') then begin
      while not dm.q1.Eof do begin
         vmlfisicos.Add(dm.q1.fieldbyname('cclase').AsString);
         dm.q1.Next;
      end;
   end;
}
  Wuser := 'ADMIN'; //Temporal  JCR
  if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;

   lwSale := 'FALSE';
   while  lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         if dm.sqlselect(dm.q1,'select * from tsclase where diagramabloque='+g_q+'ACTIVO'+g_q+
                               ' and  estadoactual ='+g_q+'ACTIVO'+g_q+' order by cclase') then begin
            while not dm.q1.Eof do begin
               vmlfisicos.Add(dm.q1.fieldbyname('cclase').AsString);
               dm.q1.Next;
            end;
         end;
         lwSale := 'TRUE';
      end else begin
         if dm.sqlselect( dm.q1, 'select * from tsproductos  where  ccapacidad = ' + g_q + g_producto + g_q +
            ' and cuser = ' + g_q + Wuser + g_q ) then begin
            lwLista := dm.q1.fieldbyname( 'cclaseprod' ).AsString;
            m := Tstringlist.Create;
            m.CommaText := lwLista;
            for j:=0 to m.count-1 do begin
               lwInSQL := trim( lwInSQL)+' '+g_q+trim(m[j])+g_q+' ';
            end;
            m.Free;
            lwInSQL:=Trim(lwInSQL);
            if lwInSQL = '' then begin
               ProdClase := 'FALSE' ;
               CONTINUE;
            end;
            lwInSQL:=stringreplace( lwInSQL,' ',',', [ rfreplaceall ] );

            if dm.sqlselect( dm.q2, 'select distinct hcclase from tsrela ' +
               ' where hcclase in ('+ lwInSQL + ')' + ' order by hcclase' ) then begin
               while not dm.q2.Eof do begin
                  if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
                  ' where cclase = '+g_q+dm.q2.fieldbyname( 'hcclase' ).AsString+g_q+
                  ' order by cclase' ) then begin
                    vmlfisicos.Add(dm.q1.fieldbyname('cclase').AsString);
                  end;
                  dm.q2.Next;
               end;
            end;
            lwSale := 'TRUE';
         end;
      end;
   end;

end;
function vml_repetido(clase:string; bib:string; prog:string; ren:integer; col:integer):integer;
var i,k:integer;
begin
   for i:=0 to length(vmlcom)-1 do begin
      if (vmlcom[i].clase=clase) and
         (vmlcom[i].bib=bib) and
         (vmlcom[i].prog=prog) then begin
         vml_repetido:=i;
         exit;
      end;
   end;
   k:=length(vmlcom);
   setlength(vmlcom,k+1);
   vmlcom[k].clase:=clase;
   vmlcom[k].bib:=bib;
   vmlcom[k].prog:=prog;
   vmlcom[k].ren:=ren;
   vmlcom[k].col:=col;
   vmlcom[k].desplaza:=-1;
   vml_repetido:=-1;
end;
procedure vml_clasecolor(clase:string; colo:string);
var k:integer;
begin
   k:=length(vmlcol);
   setlength(vmlcol,k+1);
   vmlcol[k].clase:=clase;
   vmlcol[k].color:=colo;
end;
function  vml_ccolor(clase:string):string;
var i:integer;
begin
   for i:=0 to length(vmlcol)-1 do
      if vmlcol[i].clase=clase then begin
         vml_ccolor:=vmlcol[i].color;
         exit;
      end;
   vml_ccolor:='#DCDCDC';
end;
procedure vml_expande(clase:string;bib:string;prog:string;
      renglon:integer; columna:integer; tabla:string; xtailflecha:integer; ytailflecha:integer);
var   i,k,despla,xnum_regs:integer;
      tipo,nom,tamano,ancla:string;
      bas:string;
      qq:Tadoquery;
      xclase,xbib,xprog:Tstringlist;
      Wtexto:string;
begin
   tipo:=clase;
//   nom:=bib+' '+prog;
   nom:=prog;
   tamano:='6';
   if clase='STE' then begin
      k:=pos('_',nom);
      nom:=copy(nom,k+1,100);
      k:=pos('_',nom);
      nom:=copy(nom,k+1,100);
      tamano:='8';
   end
   else begin
      {if pos('.',prog)>0 then begin // nombre largo JAVA
         ancho:=900;
         alto:=300;
         bas:=changefileext(changefileext(prog,''),'');
         if bas<>'' then begin
            k:=xbas.IndexOf(bas);
            if k=-1 then begin
               k:=xbas.Count;
               xbas.Add(bas);
            end;
            nom:=bib+' ['+inttostr(k)+']'+copy(prog,length(bas)+1,500);
            nom:=stringreplace(nom,'.','. ',[rfreplaceall]);
         end;
      end
      else begin
         if es_bbva then begin
            tipo:=copy(bib,4,3);
            nom:=prog;
            tamano:='8';
         end;
      end;} //corregir para java
      if es_bbva then begin
         tipo:=copy(bib,4,3);
         nom:=prog;
         tamano:='8';
      end;
   end;
   k:=-1;
   if vmlfisicos.IndexOf(clase)>-1 then begin
      Wtexto:='<A style="color:#000000" HREF =#li0'+trim(prog)+'|'+trim(bib)+'|'+trim(clase)+
      ' TITLE="'+trim(clase)+' '+trim(bib)+' '+trim(prog)+'">'+tipo+' '+nom+'</A>';
      vmlcaja(columna,renglon,ancho,alto,vml_ccolor(clase),'black',Wtexto,tamano,vmllis);
      nu_co:= round(columna/1100)+1;
      nu_li:= round(renglon/350)+5;
      vmlyy.add('D'+' '+trim(clase)+'|'+trim(bib)+'|'+trim(prog)+' '+inttostr(nu_co)+
             ' '+inttostr(nu_li)+' '+vml_ccolor(clase));
      if xtailflecha>0 then begin
          vmllinea(xtailflecha,ytailflecha,xtailflecha,renglon+alto div 2,'black',vmllis);
          vmlflecha(xtailflecha,renglon+alto div 2,columna,renglon+alto div 2,'black',vmllis);
      end;
      xtailflecha:=columna+ancho div 2;
      ytailflecha:=renglon+alto;
      ren:=ren+alto+100;

      k:=vml_repetido(clase,bib,prog,renglon,columna);
      renglon:=renglon+1;
   end;
   if k<>-1 then begin // Ya existe
      if vmlcom[k].desplaza=-1 then begin
         vmlcom[k].desplaza:=desplaza;
         desplaza:=(desplaza+20) mod 180;
      end;
      if es_linea then begin
         despla:=vmlcom[k].desplaza;
         vmllinea(columna+ancho-100,renglon,columna+ancho-100,renglon-50,vml_ccolor(clase),vmllis);
         vmllinea(columna+ancho-100,renglon-50,vmlcom[k].col+ancho+100+despla,renglon-50,vml_ccolor(clase),vmllis);
         vmllinea(vmlcom[k].col+ancho+95+despla,renglon-50,vmlcom[k].col+ancho+95+despla,vmlcom[k].ren+alto-50,vml_ccolor(clase),vmllis);
         vmllinea(vmlcom[k].col+ancho+95+despla,vmlcom[k].ren+alto-50,vmlcom[k].col+ancho,vmlcom[k].ren+alto-50,vml_ccolor(clase),vmllis);
      end
      else begin
         vmlcirculo(columna+ancho+300,renglon,300,200,'white','black',inttostr(k),'6',vmllis);
         vmlflecha(columna+ancho,renglon+alto div 2,columna+ancho+300,renglon+alto div 2,'black',vmllis);
         nu_co:= round((columna+ancho+300)/1100)+1;
         vmlyy.add('D'+' '+'|||||['+trim(inttostr(K))+']'+' '+inttostr(nu_co)+
                   ' '+inttostr(nu_li)+' '+'#FCF8F8');
      end;
   end
   else begin
      qq:=Tadoquery.Create(nil);
      qq.Connection:=dm.ADOConnection1;
      if dm.sqlselect(qq,'select hcprog,hcbib,hcclase from '+tabla+
                         ' where pcprog='+g_q+prog+g_q+
                         ' and   pcbib='+g_q+bib+g_q+
                         ' and   pcclase='+g_q+clase+g_q+
                         ' order by orden') then begin
         xnum_regs:=qq.RecordCount;
         if xnum_regs>500 then begin
            vmlcirculo(columna+ancho+300,renglon,500,200,'red','black',inttostr(xnum_regs)+' regs','6',vmllis);
            vmlflecha(columna+ancho,renglon+alto div 2,columna+ancho+300,renglon+alto div 2,'black',vmllis);
            qq.Free;
            exit;
         end;
         xclase:=Tstringlist.Create;
         xbib:=Tstringlist.Create;
         xprog:=Tstringlist.Create;
         while not qq.Eof do begin
            xclase.Add(qq.fieldbyname('hcclase').AsString);
            xbib.Add(qq.fieldbyname('hcbib').AsString);
            xprog.Add(qq.fieldbyname('hcprog').AsString);
            qq.Next;
         end;
         qq.Free;
         for i:=0 to xclase.Count-1 do begin
            vml_expande(xclase[i],xbib[i],xprog[i],ren,columna+ancho+300,tabla,xtailflecha,ytailflecha);
         end;
         xclase.Free;
         xbib.Free;
         xprog.Free;
      end
      else
         qq.Free;
   end;
end;

procedure vml_impacto(clase:string; bib:string; prog:string;
   subtitulo:string; tabla:string; archivo_html:string; archivo_lista:string);//='');
var i,j,k,m,n,total:integer;
    ant,tipo,nom,bas,nfont,Wnom:string;
    vmlxx:Tstringlist;
    xclave,xcolor,num_yellow:string;
    Wtexto,Wnombre:string;
    Wnomxx:Tstringlist;
begin
 //  g_control:='';
//   gral.ActualizaColorClase();
   xbas:=Tstringlist.Create;
   ren:=0;
   desplaza:=0;
   setlength(vmlcol,0);
   setlength(vmlcom,0);
   vml_clases;
   vmlyy:=Tstringlist.Create;
   if dm.sqlselect(dm.q2,'select * from parametro where clave like '+g_q+'COLOR_%'+g_q)then begin
      while not dm.q2.Eof do begin
         xclave:=copy(dm.q2.fieldbyname('clave').AsString,7,3);
         xcolor:=dm.q2.fieldbyname('dato').AsString;
         vml_clasecolor(xclave,xcolor);
         dm.q2.Next;
      end;
   end;
   vmllis:=Tstringlist.create;
   vmlinicio(vmllis);
   //vmlcaja(0,0,2200,250,'none','white','Sys-Mining','10',vmllis,'false');
   //vmlcaja(0,0,1100,250,'none','white','Sys-Mining','10',vmllis,'false');
   //vmlcirculo(0,100,150,150,'#BE81F7','#BE81F7',' ','6',vmllis,'false');
   //vmlcirculo(112,12,100,100,'#D0A9F5','#D0A9F5',' ','6',vmllis,'false');
   //vmlcirculo(238,0,50,50,'#E3CEF6','#E3CEF6',' ','6',vmllis,'false');
   nom:=prog;
   if pos('.',nom)>0 then
      nom:=stringreplace(nom,'.','. ',[rfreplaceall]);
   //vmlcaja(3000,0,3000,300,'white','white',
   //   'Diagrama de Proceso ( '+clase+' '+bib+' '+nom+' )','8',vmllis,'false');
   if trim(subtitulo)<>'' then
      vmlcaja(6500,0,3000,200,'white','white',subtitulo,'8',vmllis,'false');
   ren:=400;
   if dm.sqlselect(dm.q1,'select * from parametro '+
                         ' where clave='+g_q+'EMPRESA-NOMBRE-1'+g_q) then
      es_bbva:=(copy(dm.q1.FieldByName('dato').AsString,1,4)='BBVA');
   vml_expande(clase,bib,prog,ren,100,tabla,0,0);
   vmlxx:=Tstringlist.Create;
   for i:=0 to length(vmlcom)-1 do begin
      if vmlcom[i].desplaza<>-1 then begin
         vmlcirculo(vmlcom[i].col+ancho,vmlcom[i].ren-125,300,200,'yellow','black',inttostr(i),'6',vmllis);
      end;
      vmlxx.Add(vmlcom[i].clase+' '+vmlcom[i].bib+' '+vmlcom[i].prog);
   end;
   if xbas.Count>0 then begin   // paths abreviados JAVA
      ren:=ren+500;
      vmlcajaalign:='left';
      for i:=0 to xbas.Count-1 do begin
         vmlcaja(100,ren,2000,200,'yellow','black','['+inttostr(i)+'] = '+xbas[i],'6',vmllis,'false');
         ren:=ren+200;
      end;
      vmlcajaalign:='center';
   end;
   ren:=ren+500;
   vmlcaja(100,ren,8800,15,'#BDBDBD','black',' ','10',vmllis,'false');
   ren:=ren+500;

   Wtexto:='<font size=1>'+'<A style="color:#000000" HREF=#li1'+'Exporta'+' TITLE=Exporta a Excel'+'>'+'*RESUMEN*'+'</A></font>';
   vmlcaja(0,ren,2000,200,'white','white',Wtexto,'10',vmllis);

   vmlyy.Add('D'+' '+'*RESUMEN*'+' '+'1'+' '+inttostr(nu_li+2)+' '+'#FFFEFE');

   ren:=ren+500;
   vmlxx.Sort;
   ant:='';
   k:=-900;
   total:=0;
   nfont:='7'; //'8';
   Wnomxx:=Tstringlist.Create;
   for i:=0 to vmlxx.Count-1 do begin
      tipo:=copy(vmlxx[i],1,3);
      nom:=vmlxx[i];
      m:=pos(' ',nom);
      nom:=copy(nom,m+1,100);
      m:=pos(' ',nom);
      nom:=copy(nom,m+1,100);
      if tipo='STE' then begin
         m:=pos('_',nom);
         nom:=copy(nom,m+1,100);
         m:=pos('_',nom);
         nom:=copy(nom,m+1,100);
      end
      else begin
         {if pos('.',nom)>0 then begin // nombre largo JAVA
            ancho:=900;
            alto:=300;
            nfont:='6';
            bas:=changefileext(changefileext(nom,''),'');
            if bas<>'' then begin
               n:=xbas.IndexOf(bas);
               if n=-1 then begin
                  n:=xbas.Count;
                  xbas.Add(bas);
               end;
               nom:='['+inttostr(n)+']'+copy(nom,length(bas)+1,500);
               nom:=stringreplace(nom,'.','. ',[rfreplaceall]);
            end;
         end
         else begin
            if es_bbva then
               tipo:=copy(vmlxx[i],8,3);
         end;} // corregir para java
         if es_bbva then
            tipo:=copy(vmlxx[i],8,3);
      end;
      if ant<>tipo then begin
         if total>0 then
            vmlcaja(k,ren+j,ancho,alto,'gray','black',inttostr(total),'8',vmllis,'false');
            vmlyy.Add('R'+' '+'TOTAL'+inttostr(total)+' '+'#DCDCDC'+' '+'0'+' '+'0');  //gray
         ant:=tipo;
         j:=0;
         k:=k+ancho;
         vmlcaja(k,ren+j,ancho,alto,vml_ccolor(copy(vmlxx[i],1,3)),'black',ant,'8',vmllis,'false');
         vmlyy.Add('R'+' '+ant+' '+vml_ccolor(copy(vmlxx[i],1,3))+' '+'0'+' '+vml_ccolor(copy(vmlxx[i],1,3)));
         j:=j+alto;
         total:=0;
      end;
      Wnombre:=vmlxx[i];
      Wnomxx.CommaText:=Wnombre;

      Wtexto:='<A style="color:#000000" HREF=#li0'+Wnomxx[2]+'|'+Wnomxx[1]+'|'+Wnomxx[0]+
      ' TITLE="'+Wnomxx[0]+' '+Wnomxx[1]+' '+Wnomxx[2]+'">'+nom+'</A>';
      vmlcaja(k,ren+j,ancho,alto,'white','black',Wtexto,nfont,vmllis,'false');
      Wnom:=stringreplace(Wnomxx[0]+' '+Wnomxx[1]+' '+Wnomxx[2],' ','=',[rfreplaceall]);
      vmlyy.Add('R'+' '+'Detalle '+Wnom+' '+'0'+' '+'0'+' '+'0');
      j:=j+alto;
      inc(total);
   end;
   Wnomxx.Free;
   if total>0 then
      vmlcaja(k,ren+j,ancho,alto,'gray','black',inttostr(total),'8',vmllis,'false');
      vmlyy.Add('R'+' '+'TOTAL'+inttostr(total)+' '+'#DCDCDC'+' 0'+' 0'+'#DCDCDC');
   vmlfin(vmllis);
   vmllis.SaveToFile(archivo_html);
   g_borrar.Add(archivo_html);
   vmllis.Free;
   if trim(archivo_lista)<>'' then  begin
      //vmlxx.SaveToFile(stringreplace(archivo_lista,'|','',[rfreplaceall]));
      //g_borrar.add(stringreplace(archivo_lista,'|','',[rfreplaceall]));
      vmlyy.SaveToFile(g_tmpdir+'\DiagramaProceso'+stringreplace(archivo_lista,'|','',[rfreplaceall]));
      g_borrar.add(g_tmpdir+'\DiagramaProceso'+stringreplace(archivo_lista,'|','',[rfreplaceall]));
      g_control:=stringreplace(archivo_lista,g_tmpdir+'\DiagramaProceso','',[rfreplaceall]);
   end;
   vmlxx.Free;
   vmlyy.Free;
   xbas.Free;
end;

end.
