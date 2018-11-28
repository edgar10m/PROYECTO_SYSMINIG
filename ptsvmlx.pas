unit ptsvmlx;

interface
uses classes,sysutils;
procedure vmlinicio(lis:Tstringlist);
procedure vmlfin(lis:Tstringlist);
procedure vmllinea(x1:integer; y1:integer; x2:integer; y2:integer; linea:string; lis:Tstringlist);
procedure vmlflecha(x1:integer; y1:integer; x2:integer; y2:integer; linea:string; lis:Tstringlist);
procedure vmlcaja(x:integer; y:integer; ancho:integer; alto:integer;
   fondo:string; linea:string; texto:string;ptofont:string;lis:Tstringlist; shadow:string='true');
procedure vmlcajalink(x:integer; y:integer; ancho:integer; alto:integer;
   fondo:string; linea:string; texto:string;ptofont:string;lnk:string;lis:Tstringlist; shadow:string='true');
procedure vmlcirculo(x:integer; y:integer; ancho:integer; alto:integer;
   fondo:string; linea:string; texto:string;ptofont:string;lis:Tstringlist; shadow:string='true');
var vmlcajaalign:string='center';
implementation
procedure vmlinicio(lis:Tstringlist);
begin

   lis.add('<html>');
   lis.add('<head>');
   lis.add('<xml:namespace ns="urn:schemas-microsoft-com:vml" prefix="v"/>');
   lis.add('<style type="text/css">');
   lis.add('v\:* { behavior: url(#default#VML);}');
   lis.add('</style>');
   lis.add('</head>');
   lis.add('<body> <basefont color="black" face="Times New Roman" size="3" link="#FF0000" alink= "#FF0000" vlink= "#000000">');
   lis.add('<?xml:namespace prefix = v />');
   lis.add('<div style="margin-top=12pt; margin-left=18pt">');
   lis.add('<v:group style="width=300pt; height=200pt" coordsize="3000,2000">');

end;
procedure vmlfin(lis:Tstringlist);
begin
   lis.add('</body>');
   lis.add('</html>');
   lis.add('</v:group>');
   lis.add('</div>    ');
end;
procedure vmllinea(x1:integer; y1:integer; x2:integer; y2:integer; linea:string; lis:Tstringlist);
begin
   lis.add('<v:line from="'+inttostr(x1)+','+inttostr(y1)+'" '+
                     'to="'+inttostr(x2)+','+inttostr(y2)+'" '+
                     '  strokecolor = "'+linea+'" '+
                     '/>');
end;
procedure vmlflecha(x1:integer; y1:integer; x2:integer; y2:integer; linea:string; lis:Tstringlist);
var   delta:integer;
begin
   vmllinea(x1,y1,x2,y2,linea,lis);
   if y1=y2 then begin
      delta:=75*((x1-x2) div abs(x1 -x2));
      vmllinea(x2,y2,x2+delta,y2-20,linea,lis);
      vmllinea(x2,y2,x2+delta,y2+20,linea,lis);
   end;
   if x1=x2 then begin
      delta:=75*((y1-y2) div abs(y1 -y2));
      vmllinea(x2,y2,x2-20,y2+delta,linea,lis);
      vmllinea(x2,y2,x2+20,y2+delta,linea,lis);
   end;
end;
procedure vmlcaja(x:integer; y:integer; ancho:integer; alto:integer;
   fondo:string; linea:string; texto:string;ptofont:string;lis:Tstringlist; shadow:string='true');
var vfill:string;
begin
   vfill:='true';
   if uppercase(fondo)='NONE' then
      vfill:='false opacity = 0';
   lis.add('<v:rect style="top='+inttostr(y)+
                        '; left='+inttostr(x)+
                        '; width='+inttostr(ancho)+
                        '; height='+inttostr(alto)+'" '+
                        '  fill = '+vfill+
                        '  fillcolor = "'+fondo+'"'+
                        '  strokecolor = "'+linea+'"'+
                        '  strokeweight = "1pt">');
   if uppercase(shadow)='true' then
      lis.add('<v:shadow on="'+shadow+'" offset="4pt,3pt" color="gray" />');

//   lis.add(' <v:textbox >                                              ');
   lis.add(' <v:textbox style="font-size: '+ptofont+'pt;">                      ');
   lis.add('   <p><'+vmlcajaalign+'><b>'+texto+'</b></'+vmlcajaalign+'></p>     ');
   lis.add(' </v:textbox>                                              ');
   lis.add('</v:rect>                                                  ');

end;
procedure vmlcajalink(x:integer; y:integer; ancho:integer; alto:integer;
   fondo:string; linea:string; texto:string;ptofont:string;lnk:string;lis:Tstringlist; shadow:string='true');
var vfill:string;
begin
   vfill:='true';
   if uppercase(fondo)='NONE' then
      vfill:='false opacity = 0';
   lis.add('<v:rect style="top='+inttostr(y)+
                        '; left='+inttostr(x)+
                        '; width='+inttostr(ancho)+
                        '; height='+inttostr(alto)+'" '+
                        '  fill = '+vfill+
                        '  fillcolor = "'+fondo+'"'+
                        '  strokecolor = "'+linea+'"'+
                        '  strokeweight = "1pt">');
   if uppercase(shadow)='true' then
      lis.add('<v:shadow on="'+shadow+'" offset="4pt,3pt" color="gray" />');

//   lis.add(' <v:textbox >                                              ');
   lis.add(' <v:textbox style="font-size: '+ptofont+'pt;">                      ');
   lis.add('   <p><'+vmlcajaalign+'><b>'+'<A HREF="'+lnk+'">'+texto+'</A>'+'</b></'+vmlcajaalign+'></p>     ');
   lis.add(' </v:textbox>                                              ');
   lis.add('</v:rect>                                                  ');

end;
procedure vmlcirculo(x:integer; y:integer; ancho:integer; alto:integer;
   fondo:string; linea:string; texto:string;ptofont:string;lis:Tstringlist; shadow:string='true');
var vfill:string;
begin
   vfill:='true';
   if uppercase(fondo)='NONE' then
      vfill:='false opacity = 0';
   lis.add('<v:oval style="top='+inttostr(y)+
                        '; left='+inttostr(x)+
                        '; width='+inttostr(ancho)+
                        '; height='+inttostr(alto)+'" '+
                        '  fill = '+vfill+
                        '  fillcolor = "'+fondo+'"'+
                        '  strokecolor = "'+linea+'"'+
                        '  strokeweight = "1pt">');
   if uppercase(shadow)='true' then
      lis.add('<v:shadow on="'+shadow+'" offset="4pt,3pt" color="gray" />');

//   lis.add(' <v:textbox >                                              ');
   lis.add(' <v:textbox style="font-size: '+ptofont+'pt;">                      ');
   lis.add('   <p><center><b>'+texto+'</b></center></p>     ');
   lis.add(' </v:textbox>                                              ');
   lis.add('</v:oval>                                                  ');
end;

end.
