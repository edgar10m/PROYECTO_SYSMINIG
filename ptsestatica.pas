unit ptsestatica;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, FileCtrl, ComCtrls, ExtCtrls, Grids, shellapi,HTML_HELP, htmlhlp,
   DBGrids, DB, ADODB, dxBar, OleCtrls, SHDocVw;

type
   Tftsestatica = class( TForm )
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      grbOriginales: TGroupBox;
    gdirectivas: TGroupBox;
      Label10: TLabel;
      Label11: TLabel;
      Label12: TLabel;
      dbg: TDBGrid;
      DataSource1: TDataSource;
      ttsprog: TADOQuery;
      Splitter2: TSplitter;
    mnuPrincipal: TdxBarManager;
    mnuAyuda: TdxBarButton;
    OpenDialog1: TOpenDialog;
    Splitter5: TSplitter;
    tab: TTabControl;
    web: TWebBrowser;
    fuente: TRichEdit;
    ScrollBox1: TScrollBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    txtmascara: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbib: TComboBox;
    GroupBox1: TGroupBox;
    barchivo: TBitBtn;
    bdir: TBitBtn;
      procedure FormCreate( Sender: TObject );
      procedure cmbclaseChange( Sender: TObject );
      procedure barchivoClick( Sender: TObject );
      procedure cmbsistemaChange( Sender: TObject );
      procedure cmbbibChange( Sender: TObject );
      procedure bdirClick( Sender: TObject );
      procedure dbgDblClick( Sender: TObject );
      procedure dbgCellClick( Column: TColumn );
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuAyudaClick(Sender: TObject);
    procedure webBeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure tabChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
      { Private declarations }
      progok, progmal: Tstringlist;
      bf: Tstringlist; // buffer para traer los componentes
      lis:Tstringlist;
      scan: Tstringlist; // buffer para traer los componentes
      resumen:Tstringlist;
      convertidos,complementos:Tstringlist;
      ww:Tstringlist;     // buffer para el webbrowser
      comparaciones:Tstringlist;
      uti_compara:string;
      directorio_directivas:string;
      tot_convertidos,tot_sincambio:integer;
      tot_cambios,tot_nuevas,tot_antiguas:integer;
      tcambios,tnuevas,tantiguas:array of integer;
      comandos:Tstringlist;
      veces_comandos:array of integer;
      veces_directivas:array of integer;
      cambia:integer;
      n_cambios,n_nuevas,n_antiguas:integer;
      reglas:array of integer;
      tex_reglas:Tstringlist;

      clase, biblioteca, componente, sistema:String;

      procedure trae_utilerias(tipo:string);
      function procesa( tipo: string; bib: string; nombre: string ):boolean;
      function convierte:boolean;
      procedure cierra_web;
      procedure acumula_rgmlang(nombre:string);
      procedure cierra_rgmlang;
      procedure acumula(regla,cuenta:integer);
      function texto_regla(cla:string; regla:integer):string;
   public
      { Public declarations }
      procedure establece_datos(comp:String;cla:String;bib:String;sist:String);
      procedure ejecuta_menu(comp:String;cla:String;bib:String;sist:String);
   end;

var
   ftsestatica: Tftsestatica;

procedure PR_ESTATICA;

implementation
uses ptsdm,ptscomun, ptsgral;

{$R *.DFM}

procedure PR_ESTATICA;
begin
   gral.PubMuestraProgresBar( True );
   Application.CreateForm( Tftsestatica, ftsestatica );
   {try
      ftsestatica.Showmodal;
   finally
      ftsestatica.Free;
   end; }
   ftsestatica.FormStyle := fsMDIChild;

   if gral.bPubVentanaMaximizada = FALSE then begin
      ftsestatica.Width := g_Width;
      ftsestatica.Height := g_Height;
   end;
   dm.PubRegistraVentanaActiva( ftsestatica.Caption );
   ftsestatica.Show;
   gral.PubMuestraProgresBar( False );
end;

procedure Tftsestatica.FormCreate( Sender: TObject );
var i:integer;
begin
   dm.feed_combo( cmbsistema, 'select csistema from tssistema '+
      ' where estadoactual='+g_q+'ACTIVO'+g_q+
      ' order by csistema' );
   if cmbsistema.Items.Count = 1 then begin
      cmbsistema.ItemIndex := 0;
      cmbsistemaChange(sender);
   end;
   progok := Tstringlist.Create;
   progmal := Tstringlist.Create;
   bf := Tstringlist.Create;
   lis:=Tstringlist.Create;
   scan:=Tstringlist.Create;
   convertidos:=Tstringlist.create;
   complementos:=Tstringlist.create;
   ww:=Tstringlist.create;
   comparaciones:=Tstringlist.create;
   comandos:=Tstringlist.Create;
   resumen:=Tstringlist.Create;
   ttsprog.Connection := dm.ADOConnection1;
   tex_reglas:=Tstringlist.Create;
end;

procedure Tftsestatica.ejecuta_menu(comp:String;cla:String;bib:String;sist:String);
var borrar:integer;
begin
   // esta parte llena la lista de la izquierda con el componenete seleccionado
   ttsprog.Close;
   ttsprog.SQL.Clear;
   ttsprog.SQL.Add( 'select cprog componente from tsprog ' +
      ' where sistema=' + g_q + sist + g_q +
      ' and cclase=' + g_q + cla + g_q +
      ' and cbib=' + g_q + bib + g_q +
      ' and cprog= ' + g_q + comp + g_q +
      ' order by cprog' );
   ttsprog.open;
   if ttsprog.Eof then begin
      //   if ttsprog.RecordCount=0 then begin
      Application.MessageBox( pchar( dm.xlng( 'Sin registros' ) ),
         pchar( dm.xlng( 'Conversión ' ) ), MB_OK );
      barchivo.Enabled := false;
      bdir.Enabled := false;
   end
   else
      ttsprog.First;
   bdir.Enabled := ( ( cla <> '' ) and
      ( trim( sist ) <> '' ) and
      ( trim( bib ) <> '' ) );
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cla <> '' ) and
      ( trim( sist ) <> '' ) and
      ( trim( bib ) <> '' ) );

   // llenar los combos
   {cmbsistema.Items.Clear;
   cmbclase.Items.Clear;
   cmbbib.Items.Clear;    }

   cmbsistema.Items.Add(sist);
   cmbclase.Items.Add(cla);
   cmbbib.Items.Add(bib);

   cmbsistema.ItemIndex:=cmbsistema.Items.IndexOf(sist);
   cmbclase.ItemIndex:=cmbclase.Items.IndexOf(cla);
   cmbbib.ItemIndex:=cmbbib.Items.IndexOf(bib);

   //ftsestatica.WindowState:=wsNormal;

   barchivoClick(self);   //ejecutar la validacion para el componente
end;

procedure Tftsestatica.establece_datos(comp:String;cla:String;bib:String;sist:String);
begin
   clase:= cla;
   biblioteca:= bib;
   componente:= comp;
   sistema:= sist;
end;

procedure Tftsestatica.trae_utilerias(tipo:string);
begin
   dm.get_utileria('RGMLANG',g_tmpdir+'\hta5678.exe');
   dm.get_utileria('RESERVADAS '+tipo,g_tmpdir+'\reserved');
   dm.get_utileria('VALIDAESTATICAS',g_tmpdir+'\validaestaticas.exe');
   dm.get_utileria('VALIDACIONES ESTATICAS '+tipo,g_tmpdir+'\process.dir',true,true);
   ptscomun.parametros_extra(sistema,clase,biblioteca,g_tmpdir+'\process.dir'); //--------- Checa si necesita parametros especiales ---------  RGM V82228
   progok.Clear;
   progmal.Clear;
   tot_convertidos:=0;
   tot_sincambio:=0;
   convertidos.Clear;
   ww.Clear;
   comparaciones.Clear;
end;
function GetEnvVarValue(const VarName: string): string;
var
  BufSize: Integer;  // buffer size required for value
begin
  // Get required buffer size (inc. terminal #0)
  BufSize := GetEnvironmentVariable(
    PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    // Read env var value into result string
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName),
      PChar(Result), BufSize);
  end
  else
    // No such environment variable
    Result := '';
end;
procedure Tftsestatica.acumula(regla,cuenta:integer);
var k:integer;
begin
   k:=length(reglas);
   if regla>k then
      setlength(reglas,regla);
   k:=regla-1;
   reglas[k]:=reglas[k]+cuenta;
end;

function Tftsestatica.procesa( tipo: string; bib: string; nombre: string ):boolean;
var
   original, convertido: string;
   b_nuevo: boolean;
   //buffer: pchar;
   sBFile: String;
   respuesta:integer;
   compo:string;
   i,j,m,n:integer;
   tempo:String;
   tincidencias:integer;
   numregla:integer;
   lista:Tstringlist;
begin
   compo:=tipo+' '+bib+' '+nombre;
   SetCurrentDir( g_tmpdir );
   deletefile( g_tmpdir+'\scan.txt' );
   original := g_tmpdir+'\'+ptscomun.cprog2bfile(nombre);  // se usará para un copyfile
   convertido := g_tmpdir+'\cnv_'+ptscomun.cprog2bfile(nombre);// se usará para un copyfile
   if dm.sqlselect(dm.q1,'select regla from tsvalestatica '+
      ' where estado<>'+g_q+'ACTIVO'+g_q+
      ' order by regla') then begin
      lista:=Tstringlist.Create;
      while not dm.q1.Eof do begin
         lista.Add(dm.q1.fieldbyname('regla').AsString);
         dm.q1.Next;
      end;
      lista.SaveToFile(g_tmpdir+'\val_activas.txt');
      g_borrar.Add(g_tmpdir+'\val_activas.txt');
      lista.Free;
      deletefile(g_tmpdir+'\validaestaticas_ok.txt');
      dm.ejecuta_espera(g_tmpdir+'\validaestaticas.exe '+
         g_tmpdir+'\val_activas.txt '+
         g_tmpdir+'\process.dir '+
         g_tmpdir+'\val_activasok.dir',sw_hide);
      if fileexists(g_tmpdir+'\validaestaticas_ok.txt')=false then begin
         if fileexists(g_tmpdir+'\error_validaestaticas. txt') then begin
            lista:=Tstringlist.Create;
            lista.LoadFromFile(g_tmpdir+'\error_validaestaticas. txt');
            showmessage('ERROR... '+lista.Text);
            lista.Free;
         end
         else
            showmessage('ERROR... No filtra reglas activas');
         procesa:=false;
         exit;
      end;
      copyfile(pchar(g_tmpdir+'\val_activasok.dir'),
         pchar(g_tmpdir+'\process.dir'),false);
      g_borrar.Add(g_tmpdir+'\validaestaticas_ok.txt');
      g_borrar.Add(g_tmpdir+'\val_activasok.dir');
   end;
   bf.Clear;
   tincidencias:=0;

   SetEnvironmentVariable(pchar('ZTIPO'), pchar(clase));
   SetEnvironmentVariable(pchar('ZSISTEMAZ'), pchar(sistema));
   SetEnvironmentVariable(pchar('ZBIBLIOTECAZ'), pchar(biblioteca));
   //SetEnvironmentVariable(pchar('ZOFICINAZ'), pchar(cmboficina_text));
   SetEnvironmentVariable(pchar('ZCPROG2BFILEZ'), pchar(ptscomun.cprog2bfile(nombre)));
   SetEnvironmentVariable(pchar('ZPROGRAMAZ'), pchar(nombre));

   //dm.leebfile( nombre, bib, tipo, buffer ); //se sustituye por sPubObtenerBFile
   //bf.Add( buffer );
   //freemem( buffer );

   sBFile := dm.sPubObtenerBFile( nombre, bib, tipo );
   bf.Add( sBFile );
   bf.SaveToFile( original );
   dm.ejecuta_espera( g_tmpdir+'\hta5678.exe ' + original + ' ' + convertido + ' >scan.txt', sw_hide );
   if fileexists( 'scan.txt' ) then begin
      scan.LoadFromFile( g_tmpdir+'\scan.txt' );
      if pos( 'ERROR...', scan.Text ) > 0 then begin
         //application.MessageBox( scan.GetText, 'ERROR', MB_OK );
         progmal.Add('<H3><B><FONT COLOR="red">'+nombre+'</FONT></H3>:'+scan.GetText);
      end
      else begin
         acumula_rgmlang(ptscomun.cprog2bfile(nombre));
         if trim(scan.Text)<>'' then begin
            inc(tot_convertidos);
            convertidos.Add(nombre);
            //ww.Add('<TABLE BORDER=1><TR><TH>Regla</TH><TH>Incidencias</TH></TR>');
            ww.Add(' ');
            m:=ww.Count;
            n:=m;
            ww.Add('</TABLE><TABLE BORDER=1><TR><TH>Regla</TH><TH>Linea</TH><TH>Seccion</TH><TH>Severidad</TH><TH>Tipo</TH><TH>Mensaje</TH></TR>');
            ww.Add('<FONT FACE="Arial"><P>');
            for i:=0 to scan.Count-1 do begin
               if copy(scan[i],1,6)<>'Regla ' then begin   // total de la regla
                  if pos(',0',scan[i])=0 then begin
                     acumula(strtoint(copy(scan[i],1,pos(',',scan[i])-1)),
                        strtoint(copy(scan[i],pos(',',scan[i])+1,100)));
                     scan[i]:='<TR><TD>'+scan[i]+'</TD></TR>';
                     scan[i]:=stringreplace(scan[i],',','</TD><TD>',[]);
                     ww.Insert(m,scan[i]);
                     inc(m);
                  end;
               end
               else begin
                  numregla:=strtoint(copy(scan[i],7,pos(',',scan[i])-7));
                  acumula(numregla,1);
                  tempo:='<a href="#source'+inttostr(ttsprog.RecNo)+'_'+
                     copy(scan[i],pos('LINEA:',scan[i])+6,pos(',PARRAFO:',scan[i])-pos('LINEA:',scan[i])-6)+
                     '">';
                  scan[i]:=stringreplace(scan[i],'Regla ','<TR><TD>',[]);
                  scan[i]:=stringreplace(scan[i],',LINEA:','</TD><TD>'+tempo,[]);
                  scan[i]:=stringreplace(scan[i],',PARRAFO:','</a></TD><TD>',[]);
                  ww.add(scan[i]+texto_regla(clase,numregla)+'</TR>');
                  inc(tincidencias);
               end;
            end;
            ww.add('</TABLE>');
            complementos.add(' Incidencias=['+inttostr(tincidencias)+']');
            ww.insert(n-1,'<a name="'+nombre+'"<H4><B><FONT COLOR="green">'+inttostr(convertidos.count)+'. '+nombre+'</FONT>'+
               '</a><a href="#back'+nombre+'">   ^</a></B>'+complementos[complementos.count-1]+'</H4>');
            ww.Add('<HR>');
         end
         else
            inc(tot_sincambio);
     end;
   end
   else begin
      progmal.Add('<H4>'+nombre+'</H4>:'+'No pudo ejecutar RGMLANG' );
   end;
   fuente.Lines.Clear;
   fuente.Lines.Add( 'con Error   : '+inttostr(progmal.Count)+
      '   Sin Incidencias: '+inttostr(tot_sincambio)+
      '   Con Incidencias: '+inttostr(convertidos.Count));
   setcurrentdir( g_ruta );
   procesa:=true;
end;


function Tftsestatica.convierte:boolean;
begin
   convierte:=procesa( clase, biblioteca, ttsprog.fieldbyname( 'componente' ).AsString );
end;

function Tftsestatica.texto_regla(cla:string; regla:integer):string;
begin
   while tex_reglas.Count<regla do
      tex_reglas.Add('');
   if tex_reglas[regla-1]='' then begin
      if dm.sqlselect(dm.q1,'select * from tsvalestatica '+
         ' where clase='+g_q+cla+g_q+
         ' and   regla='+inttostr(regla)) then
         tex_reglas[regla-1]:='<TD>'+dm.q1.fieldbyname('grado').AsString+'</TD>'+
            '<TD>'+dm.q1.fieldbyname('tipo').AsString+'</TD>'+
            '<TD>'+dm.q1.fieldbyname('mensaje').AsString+'</TD>'
      else
         tex_reglas[regla-1]:='<TD>Desconocido</TD><TD>Desconocido</TD><TD>Regla inexistente</TD>';
   end;
   texto_regla:=tex_reglas[regla-1];
end;

procedure Tftsestatica.cierra_web;
var i:integer;
begin
   scan.Clear;
   scan.Add('<HEAD><TITLE>Resumen de Actualizaciones '+
      sistema+' '+clase+' '+biblioteca+' '+gdirectivas.Caption+
      '</TITLE></HEAD><BODY>');
   scan.Add('<H2>');
   scan.Add('</H2>');
   scan.Add('<H3>Total con Error      : '+inttostr(progmal.Count)+'</H3>');
   for i:=0 to progmal.Count-1 do
      scan.Add(progmal[i]);
   scan.Add('<H3>Total Sin Incidencias: '+inttostr(tot_sincambio)+'</H3>');
   scan.Add('<H3>Total Con Incidencias: '+inttostr(convertidos.Count)+'</H3>');
   scan.add('<TABLE BORDER=1><TR><TH>Regla</TH><TH>Incidencias</TH><TH>Severidad</TH><TH>Tipo</TH><TH>Mensaje</TH></TR>');
   for i:=0 to length(reglas)-1 do begin
      if reglas[i]>0 then begin
         scan.add('<TR><TD>'+inttostr(i+1)+'</TD><TD>'+inttostr(reglas[i])+
            '</TD>'+texto_regla(clase,i+1)+'</TR>');
      end;
   end;
   scan.add('</TABLE>');
   setlength(reglas,0);
   for i:=0 to convertidos.Count-1 do
      scan.Add('<H4><a name="back'+convertidos[i]+'">'+inttostr(i+1)+'. </a>'+
         '<a HREF="#'+convertidos[i]+'">'+convertidos[i]+complementos[i]+'</H4></a>');
   scan.Add('<HR>');
   scan.Add('<FONT FACE="courier new"><P>');
   scan.AddStrings(ww);
   scan.Add('</P></FONT></BODY>');
   scan.SaveToFile(g_tmpdir+'\cnv.html');
   convertidos.clear;
   complementos.clear;
end;

procedure Tftsestatica.acumula_rgmlang(nombre:string);
var i,k:integer;
   paso:string;
begin
   n_cambios:=0;
   n_nuevas:=0;
   n_antiguas:=0;
   if fileexists(g_tmpdir+'\'+nombre+'_tot_comando')=false then exit;
   lis.LoadFromFile(g_tmpdir+'\'+nombre+'_tot_comando');
   if lis.Count=0 then exit;
   n_cambios:=strtoint(lis[0]);
   n_nuevas:=strtoint(lis[1]);
   n_antiguas:=strtoint(lis[2]);
   tot_cambios:=tot_cambios+n_cambios;
   tot_nuevas:=tot_nuevas+n_nuevas;
   tot_antiguas:=tot_antiguas+n_antiguas;
   resumen.Add('<TR><TD>'+nombre+'</TD><TD>'+lis[0]+'</TD><TD>'+lis[1]+'</TD><TD>'+lis[2]+'</TD></TR>');
   cambia:=0;
   for i:=3 to lis.Count-1 do begin
      if (cambia=0) then begin
         if (pos(',',lis[i])<1) then begin
            k:=comandos.IndexOf(copy(lis[i],1,pos('=',lis[i])-1));
            if k>-1 then
               veces_comandos[k]:=veces_comandos[k]+strtoint(trim(copy(lis[i],pos('=',lis[i])+1,100)))
            else begin
               comandos.Add(copy(lis[i],1,pos('=',lis[i])-1));
               setlength(veces_comandos,comandos.Count);
               veces_comandos[comandos.Count-1]:=strtoint(trim(copy(lis[i],pos('=',lis[i])+1,100)));
            end;
         end
         else begin
            cambia:=i;
            setlength(veces_directivas,lis.Count-cambia);
         end;
      end;
      if cambia>0 then begin
         k:=pos(' , ',lis[i]);
         paso:=copy(lis[i],k+3,300);
         k:=pos(' , ',paso);
         veces_directivas[i-cambia]:=veces_directivas[i-cambia]+strtoint(copy(paso,1,k-1));
      end;
   end;
end;

procedure Tftsestatica.cierra_rgmlang;
var i,k:integer;
    paso:string;
begin
   resumen.Insert(0,'<H3><B>Estadisticas de Ejecución</B></H3>');
   resumen.Insert(1,'<TABLE BORDER=1><TR><TH>Comando</TH><TH>Usado</TH></TR>');
   for i:=0 to comandos.Count-1 do
      resumen.Insert(i+2,'<TR><TD>'+comandos[i]+'</TD><TD>'+inttostr(veces_comandos[i])+'</TD></TR>');
   k:=comandos.Count+2;
   resumen.Insert(k,'</TABLE><H3><B>Uso de Directivas</B></H3><TABLE BORDER=1><TR><TH>Linea</TH><TH>Usado</TH><TH>Comando</TH></TR>');
   for i:=cambia to lis.count-1 do begin
      paso:=copy(lis[i],pos(' , ',lis[i])+3,300);
      paso:=copy(paso,pos(' , ',paso)+3,300);
      lis[i]:=stringreplace(paso,' ','&nbsp;',[rfreplaceall]);
   end;
   for i:=0 to length(veces_directivas)-1 do
      resumen.Insert(k+i+1,'<TR><TD>'+inttostr(i+1)+'</TD><TD>'+inttostr(veces_directivas[i])+'</TD><TD>'+lis[i+cambia]+'</TD></TR>');
   resumen.add('</TABLE></BODY>');
   resumen.SaveToFile(g_tmpdir+'\tot_comando.html');
   resumen.Clear;
   comandos.clear;
   setlength(veces_comandos,0);
   setlength(veces_directivas,0);
   tot_cambios:=0;
   tot_nuevas:=0;
   tot_antiguas:=0;
end;

procedure Tftsestatica.barchivoClick( Sender: TObject );
var
   sDirectorio: String;
   sDirectorioC: String;
begin
   if ttsprog.RecordCount=0 then exit;
   // Guardar los datos de los combos en las variables       ALK
   establece_datos(dbg.SelectedField.AsString,cmbclase.text,cmbbib.Text,cmbsistema.text);
   try
      trae_utilerias( clase );
   except
      Exit;
   end;

   //screen.Cursor := crsqlwait;
   screen.Cursor := crNo;     // alk para cambiar el cursor
   gral.PubMuestraProgresBar( true );     // alk para barra de espera
   
   if convierte then begin
      cierra_web;
      cierra_rgmlang;
      tabchange(sender);
   end;

   screen.Cursor := crdefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tftsestatica.bdirClick( Sender: TObject );
var
   i: integer;
begin
   if ttsprog.RecordCount=0 then exit;
   // Guardar los datos de los combos en las variables       ALK
   establece_datos(dbg.SelectedField.AsString,cmbclase.text,cmbbib.Text,cmbsistema.text);
   try
      trae_utilerias( clase );
   except
      Exit;
   end;

   //screen.Cursor := crsqlwait;
   screen.Cursor := crNo;     // alk para cambiar el cursor
   gral.PubMuestraProgresBar( true );     // alk para barra de espera


   Ttsprog.First;
   while not ttsprog.Eof do begin
      if convierte=false then begin
         screen.Cursor := crdefault;
         exit;
      end;
      ttsprog.next;
      // Guardar los datos de los combos en las variables       ALK
      establece_datos(dbg.SelectedField.AsString,cmbclase.text,cmbbib.Text,cmbsistema.text);
   end;
   cierra_web;
   cierra_rgmlang;
   tabchange(sender);

   screen.Cursor := crdefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tftsestatica.cmbsistemaChange( Sender: TObject );
begin
   dm.feed_combo( cmbclase, 'select distinct cclase from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' order by cclase' );
   cmbbib.clear;
   barchivo.enabled := false;
   bdir.enabled := false;
   ttsprog.Close;

   if cmbsistema.Text <> '' then begin
      web.Hide();
      web.Navigate('about:blank');
      web.Show();
      fuente.Lines.Clear;
   end;

   dbg.Visible:=false;
end;

procedure Tftsestatica.cmbclaseChange( Sender: TObject );
var
   lista: Tstringlist;
   bib: string;
begin
   dm.feed_combo( cmbbib, 'select distinct cbib from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and   cclase=' + g_q + cmbclase.text + g_q +
      ' order by cbib' );
   barchivo.enabled := false;
   bdir.enabled := false;
   ttsprog.Close;

   if cmbclase.Text <> '' then begin
      web.Hide();
      web.Navigate('about:blank');
      web.Show();
      fuente.Lines.Clear;
   end;

   dbg.Visible:=false;
end;

procedure Tftsestatica.cmbbibChange( Sender: TObject );
begin
   ttsprog.Close;
   ttsprog.SQL.Clear;
   ttsprog.SQL.Add( 'select cprog Componente from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and cclase=' + g_q + cmbclase.Text + g_q +
      ' and cbib=' + g_q + cmbbib.Text + g_q +
      ' and cprog like ' + g_q + stringreplace( txtmascara.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' order by cprog' );
   ttsprog.open;
   if ttsprog.Eof then begin
      //   if ttsprog.RecordCount=0 then begin
      Application.MessageBox( pchar( dm.xlng( 'Sin registros' ) ),
         pchar( dm.xlng( 'Conversión ' ) ), MB_OK );
      barchivo.Enabled := false;
      bdir.Enabled := false;
   end
   else
      ttsprog.First;
   bdir.Enabled := ( ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );

   if cmbbib.Text <> '' then begin
      web.Hide();
      web.Navigate('about:blank');
      web.Show();
      fuente.Lines.Clear;
   end;

   dbg.Visible:=true;
end;


procedure Tftsestatica.dbgDblClick( Sender: TObject );
begin
   if barchivo.Enabled then
      barchivoclick( sender );
end;

procedure Tftsestatica.dbgCellClick( Column: TColumn );
begin
   iHelpContext := IDH_TOPIC_T01804;
   if ttsprog.Active = false then
      exit;
   //dm.trae_fuente( ttsprog.fieldbyname( 'sistema' ).AsString, ttsprog.fieldbyname( 'Componente' ).AsString,
   dm.trae_fuente( cmbSistema.text, ttsprog.fieldbyname( 'Componente' ).AsString,
                   cmbbib.Text, cmbclase.Text, fuente );
   fuente.Color := dbg.Color;

   web.Hide();
   web.Navigate('about:blank');
   web.Show();
end;

function Tftsestatica.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
            [Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tftsestatica.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   iHelpContext:=ActiveControl.HelpContext;
end;

procedure Tftsestatica.mnuAyudaClick(Sender: TObject);
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [ Application.HelpFile,HTML_HELP.IDH_TOPIC_T01800 ])),HH_DISPLAY_TOPIC, 0);
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tftsestatica.webBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
   k,m:integer;
   aux,url2:string;
begin
   k:=pos('#compara',url);
   if k>0 then begin
      if ShellExecute( Handle, nil, pchar(uti_compara),
         pchar( comparaciones[strtoint(trim(copy(url,k+8,100)))]),
         nil, SW_SHOW ) <= 32 then
         Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparacion' ) ),
            pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
      cancel:=true;
   end;
   k:=pos('#source',url);
   if k>0 then begin
       //url = 'file:///C:/SysMining_fuentes/tmp/cnv.html#source9_129'
      aux:=copy(url,k+7,pos('_',url)-k-7);

      //Copy(s,SysUtils.LastDelimiter('-',s)+1,Length(s));
      if aux = '' then begin
         url2:=copy(url,LastDelimiter('/',url)+1,100);
         k:=pos('#source',url2);
         aux:=copy(url2,k+7,pos('_',url2)-k-7);
      end;
      k:=strtoint(aux);
      ttsprog.RecNo:=k;
      dm.trae_fuente( sistema, ttsprog.fieldbyname( 'Componente' ).AsString,
         biblioteca, clase, fuente );

      url2:=copy(url,LastDelimiter('/',url)+1,100);
      aux:=copy(url2,pos('_',url2)+1,100);
      k:=strtoint(aux);

      fuente.SelStart := fuente.Perform( EM_LINEINDEX, k - 1, 0 );
      fuente.Perform( EM_SCROLLCARET, 0, 0 );
      m := fuente.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
      m := k - m - 10;
      fuente.Perform( EM_LINESCROLL, 0, m );
      fuente.SelLength := length( fuente.Lines[ k - 1 ] );
      fuente.SelAttributes.Color := clblue;
   end;
end;

procedure Tftsestatica.tabChange(Sender: TObject);
begin
   if tab.TabIndex=0 then begin
      if fileexists(g_tmpdir+'\cnv.html') then
         web.Navigate(g_tmpdir+'\cnv.html');
   end
   else begin
      if fileexists(g_tmpdir+'\tot_comando.html') then
         web.Navigate(g_tmpdir+'\tot_comando.html');
   end;
end;

procedure Tftsestatica.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//   gral.PopGral.Items.Clear;

   if FormStyle = fsMDIChild then begin
      dm.PubEliminarVentanaActiva( ftsestatica.Caption );  //quitar nombre de lista de abiertos
   end;

   self.destroy;
end;

end.

