unit ptsconver;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, FileCtrl, ComCtrls, ExtCtrls, Grids, shellapi,HTML_HELP, htmlhlp,
   DBGrids, DB, ADODB, dxBar, OleCtrls, SHDocVw;

type
   Tftsconver = class( TForm )
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      grbConvertidos: TGroupBox;
      grbOriginales: TGroupBox;
      cdir: TDirectoryListBox;
      carchivo: TFileListBox;
    gdirectivas: TGroupBox;
      Label10: TLabel;
      Label11: TLabel;
      Label12: TLabel;
      dbg: TDBGrid;
      DataSource1: TDataSource;
    directivas: TMemo;
      ttsprog: TADOQuery;
      Splitter2: TSplitter;
      Panel2: TPanel;
      cdrive: TDriveComboBox;
      Splitter3: TSplitter;
    mnuPrincipal: TdxBarManager;
    mnuAyuda: TdxBarButton;
    OpenDialog1: TOpenDialog;
    fuente: TMemo;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    tab: TTabControl;
    web: TWebBrowser;
    Splitter1: TSplitter;
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
    chkreemplaza: TCheckBox;
    GroupBox1: TGroupBox;
    bdirectivas: TBitBtn;
    bguarda: TBitBtn;
    GroupBox2: TGroupBox;
    barchivo: TBitBtn;
    bdir: TBitBtn;
    GroupBox4: TGroupBox;
    bcompara: TBitBtn;
      procedure FormCreate( Sender: TObject );
      procedure cmbclaseChange( Sender: TObject );
      procedure barchivoClick( Sender: TObject );
      procedure cmbsistemaChange( Sender: TObject );
      procedure cmbbibChange( Sender: TObject );
      procedure bdirClick( Sender: TObject );
      procedure cdriveChange( Sender: TObject );
      procedure cdirChange( Sender: TObject );
      procedure carchivoClick( Sender: TObject );
      procedure bcomparaClick( Sender: TObject );
      procedure FormResize( Sender: TObject );
      procedure dbgDblClick( Sender: TObject );
      procedure dbgCellClick( Column: TColumn );
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuAyudaClick(Sender: TObject);
    procedure bdirectivasClick(Sender: TObject);
    procedure bguardaClick(Sender: TObject);
    procedure directivasChange(Sender: TObject);
    procedure webBeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure tabChange(Sender: TObject);
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
      procedure trae_utilerias(tipo:string);
      function procesa( tipo: string; bib: string; nombre: string ):boolean;
      function convierte:boolean;
      procedure cierra_web;
      procedure acumula_rgmlang(nombre:string);
      procedure cierra_rgmlang;
   public
      { Public declarations }
   end;

var
   ftsconver: Tftsconver;

procedure PR_CONVER;

implementation
uses ptsdm,ptscomun, ptsgral;

{$R *.DFM}

procedure PR_CONVER;
begin
   gral.PubMuestraProgresBar( True );
   Application.CreateForm( Tftsconver, ftsconver );
   {try
      ftsconver.Showmodal;
   finally
      ftsconver.Free;
   end;  }
   ftsconver.FormStyle := fsMDIChild;

   if gral.bPubVentanaMaximizada = FALSE then begin
      ftsconver.Width := g_Width;
      ftsconver.Height := g_Height;
   end;
   dm.PubRegistraVentanaActiva( ftsconver.Caption );
   ftsconver.Show;
   gral.PubMuestraProgresBar( False );
end;

procedure Tftsconver.FormCreate( Sender: TObject );
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
end;

procedure Tftsconver.trae_utilerias(tipo:string);
begin
   if uti_compara='' then begin
      uti_compara:=g_tmpdir + '\hta'+formatdatetime('YYYYMMDDHHNNSSZZZ',now)+'.exe';
      dm.get_utileria( 'COMPARACION DE FUENTES', uti_compara );
   end;
   dm.get_utileria('RGMLANG',g_tmpdir+'\hta5678.exe');
   dm.get_utileria('RESERVADAS '+tipo,g_tmpdir+'\reserved');
   directivas.Lines.SaveToFile(g_tmpdir+'\process.dir');
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

function Tftsconver.procesa( tipo: string; bib: string; nombre: string ):boolean;
var
   original, convertido: string;
   b_nuevo: boolean;
   //buffer: pchar;
   sBFile: String;
   respuesta:integer;
   compo:string;
   i,j:integer;
   tempo,aux:String;
begin
   if chkreemplaza.Checked=false then begin
      if fileexists( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ) then begin
         respuesta:=application.MessageBox(pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) +' ya existe, desea reemplazarlo?'),
            'Confirme',MB_YESNOCANCEL);
         if respuesta=IDCANCEL then begin
            procesa:=false;
            exit;
         end;
         if respuesta=IDNO then begin
            procesa:=true;
            exit;
         end;
      end;
   end;
   compo:=tipo+' '+bib+' '+nombre;
   SetCurrentDir( g_tmpdir );

   deletefile( 'scan.txt' );
   original := g_tmpdir+'\ori_'+ptscomun.cprog2bfile(nombre);  // se usará para un copyfile
   convertido := g_tmpdir+'\'+ptscomun.cprog2bfile(nombre);// se usará para un copyfile
   g_borrar.Add(original);
   g_borrar.Add(convertido);
   bf.Clear;

   SetEnvironmentVariable(pchar('ZTIPO'), pchar(cmbclase.Text));
   SetEnvironmentVariable(pchar('ZSISTEMAZ'), pchar(cmbsistema.Text));
   SetEnvironmentVariable(pchar('ZBIBLIOTECAZ'), pchar(cmbbib.Text));
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
      scan.LoadFromFile( 'scan.txt' );
      if pos( 'ERROR', scan.Text ) > 0 then begin
         //application.MessageBox( scan.GetText, 'ERROR', MB_OK );
         progmal.Add('<H3><B><FONT COLOR="red">'+nombre+'</FONT></H3>:'+scan.GetText);
      end
      else begin
         acumula_rgmlang(ptscomun.cprog2bfile(nombre));
         {
         scan.LoadFromFile(convertido);
         scan.Delete(scan.Count-1);    // quitarlo cuando se corrija el rgmlang
         scan.SaveToFile(convertido);
         }
         if bf.Text<>scan.Text then begin
            inc(tot_convertidos);
            convertidos.Add(nombre);
            complementos.add(' Cambios=['+inttostr(n_cambios)+'] Lineas Nuevas=['+inttostr(n_nuevas)+'] Lineas Canceladas=['+inttostr(n_antiguas)+']');
            ww.Add('<a name="'+nombre+'"<H4><B><FONT COLOR="green">'+inttostr(convertidos.count)+'. '+nombre+'</FONT>'+
               '</a><a href="#back'+nombre+'">   ^</a></B>'+complementos[complementos.count-1]+'</H4>');

            aux:= 'fc /N /W '+ original + ' ' + convertido + ' >scan.txt';
            dm.ejecuta_espera(aux, sw_hide );   //Compara dos archivos o conjuntos de archivos y muestra las diferencias entre ellos
            scan.LoadFromFile('scan.txt');
            i:=pos(':',scan[0]);
            tempo:=copy(scan[0],i-1,1000);
            i:=pos(' ',tempo);
            scan.Text:=stringreplace(scan.Text,copy(tempo,1,i-1),'ORIGINAL',[rfreplaceall]);
            tempo:=copy(tempo,i+1,1000);
            i:=pos(':',tempo);
            tempo:=copy(tempo,i-1,1000);
            i:=pos(' ',tempo);
            if i=0 then
               i:=100;
            scan.Text:=stringreplace(scan.Text,copy(tempo,1,i-1),'MODIFICADO',[rfreplaceall]);
            scan[0]:=stringreplace(scan[0],'archivos','componentes',[]);
            scan[0]:=stringreplace(scan[0],'files','components',[]);
            scan.Text:=stringreplace(scan.Text,' ','&nbsp;',[rfreplaceall]);
            scan.Add('<HR>');
            //comparaciones.Add(original+' '+convertido);
            comparaciones.Add(original+' '+cdir.Directory + '\' + ptscomun.cprog2bfile(nombre));
            scan[0]:='<a href=#compara'+inttostr(comparaciones.Count-1)+'>'+scan[0]+'</a>';
            ww.AddStrings(scan);
            copyfile( pchar( convertido ), pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ), false );
            carchivo.Update;

         end
         else
            inc(tot_sincambio);
     end;
   end
   else begin
      //application.MessageBox( 'No pudo ejecutar el convertidor', 'AVISO', MB_OK );
      progmal.Add('<H4>'+nombre+'</H4>:'+'No pudo ejecutar RGMLANG' );
   end;
   //   deletefile(original);
   //   deletefile(convertido);
   fuente.Lines.Clear;
   fuente.Lines.Add( 'con Error   : '+inttostr(progmal.Count)+
      '   Sin Cambio  : '+inttostr(tot_sincambio)+
      '   Actualizados: '+inttostr(convertidos.Count));
   setcurrentdir( g_ruta );
   procesa:=true;
end;


function Tftsconver.convierte:boolean;
begin
   convierte:=procesa( cmbclase.text, cmbbib.Text, ttsprog.fieldbyname( 'componente' ).AsString );
end;
procedure Tftsconver.cierra_web;
var i:integer;
begin
   scan.Clear;
   scan.Add('<HEAD><TITLE>Resumen de Actualizaciones '+
      cmbsistema.text+' '+cmbclase.Text+' '+cmbbib.Text+' '+gdirectivas.Caption+
      '</TITLE></HEAD><BODY>');
   scan.Add('<H2>');
   for i:=0 to directivas.Lines.Count-1 do begin
      if trim(copy(directivas.Lines[i],1,10))<>'' then
         break;
      if trim(directivas.Lines[i])<>'' then
         scan.Add(trim(directivas.Lines[i])+'<BR>');
   end;
   scan.Add('</H2>');
   scan.Add('<H3>Total con Error   : '+inttostr(progmal.Count)+'</H3>');
   for i:=0 to progmal.Count-1 do
      scan.Add(progmal[i]);
   scan.Add('<H3>Total Sin Cambio  : '+inttostr(tot_sincambio)+'</H3>');
   scan.Add('<H3>Total Actualizados: '+inttostr(convertidos.Count)+'</H3>');
   for i:=0 to convertidos.Count-1 do
      scan.Add('<H4><a name="back'+convertidos[i]+'">'+inttostr(i+1)+'. </a>'+
         '<a HREF="#'+convertidos[i]+'">'+convertidos[i]+complementos[i]+'</H4></a>');
   scan.Add('<HR>');
   scan.Add('<FONT FACE="courier new"><P>');
   for i:=0 to ww.Count-1 do
      scan.Add(ww[i]+'<BR>');
   scan.Add('</P></FONT></BODY>');
   scan.SaveToFile(g_tmpdir+'\cnv.html');
   dm.sqlinsert('insert into parametro(clave,secuencia,dato,descripcion) values('+
      g_q+'dirconversalida_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbib.Text+g_q+',0,'+
      g_q+cdir.Directory+g_q+','+
      g_q+'Directorio donde toma las directivas para convertir '+
      cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbib.Text+g_q+')');
   convertidos.clear;
   complementos.clear;
end;
procedure Tftsconver.acumula_rgmlang(nombre:string);
var i,k:integer;
   paso:string;
begin
   n_cambios:=0;
   n_nuevas:=0;
   n_antiguas:=0;
   if fileexists(g_tmpdir+'\ori_'+nombre+'_tot_comando')=false then exit;
   lis.LoadFromFile(g_tmpdir+'\ori_'+nombre+'_tot_comando');
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
procedure Tftsconver.cierra_rgmlang;
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
   resumen.Insert(k+1+length(veces_directivas),'</TABLE><H3><B>Cambios por componente</B></H3><TABLE BORDER=1><TR><TH>Componente</TH><TH>Cambios</TH><TH>Lineas Nuevas</TH><TH>Lineas Anuladas</TH></TR>');
   resumen.add('<B><TR><TD>Totales</TD><TD>'+inttostr(tot_cambios)+'</TD><TD>'+inttostr(tot_nuevas)+'</TD><TD>'+inttostr(tot_antiguas)+'</TD></TR></B>');
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
procedure Tftsconver.barchivoClick( Sender: TObject );
var
   sDirectorio: String;
   sDirectorioC: String;
begin
   if ttsprog.RecordCount=0 then exit;
   if trim(directivas.Text)='' then begin
      showmessage('Faltan Directivas de Actualización');
      exit;
   end;
   try
      trae_utilerias( cmbclase.Text );
   except
      Exit;
   end;

   //screen.Cursor := crsqlwait;
   screen.Cursor := crNo;     // alk para cambiar el cursor
   gral.PubMuestraProgresBar( true );     // alk para barra de espera

   convierte;
   cierra_web;
   cierra_rgmlang;
   tabchange(sender);

   screen.Cursor := crdefault;
   gral.PubMuestraProgresBar( False );
   
   bcompara.Enabled:=True;
end;
procedure Tftsconver.bdirClick( Sender: TObject );
var
   i: integer;
begin
   if ttsprog.RecordCount=0 then exit;
   try
      trae_utilerias( cmbclase.Text );
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
   end;
   cierra_web;
   cierra_rgmlang;
   tabchange(sender);

   screen.Cursor := crdefault;
   gral.PubMuestraProgresBar( False );

   bcompara.Enabled:=True;
end;

procedure Tftsconver.cmbsistemaChange( Sender: TObject );
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
      directivas.Lines.Clear;
      gdirectivas.Caption:='';
      bcompara.Enabled:=False;
   end;

   dbg.Visible:=false;
end;

procedure Tftsconver.cmbclaseChange( Sender: TObject );
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
      directivas.Lines.Clear;
      gdirectivas.Caption:='';
      bcompara.Enabled:=False;
   end;

   dbg.Visible:=false;
end;

procedure Tftsconver.cmbbibChange( Sender: TObject );
begin
   carchivo.Mask := txtmascara.Text;
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
      bcompara.Enabled := false;
   end
   else
      ttsprog.First;
   if dm.sqlselect(dm.q1,'select dato from parametro '+
      ' where clave='+g_q+'dirconversalida_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbib.Text+g_q+
      ' and  secuencia=0') then
      if directoryexists(dm.q1.fieldbyname('dato').AsString) then
         cdir.Directory:=dm.q1.fieldbyname('dato').AsString
      else
         cdir.Directory:=g_tmpdir;

   if cmbbib.Text <> '' then begin
      web.Hide();
      web.Navigate('about:blank');
      web.Show();
      fuente.Lines.Clear;
      directivas.Lines.Clear;
      gdirectivas.Caption:='';
      bcompara.Enabled:=False;
   end;

   bdir.Enabled := ( ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) and  //);
      ( trim( directivas.Text ) <> '' ));   //alk para que no lo active hasta que se tengan las directivas
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) and
      ( trim( directivas.Text ) <> '' ));   //alk para que no lo active hasta que se tengan las directivas
   //bcompara.Enabled := barchivo.Enabled;

   dbg.Visible:=true;
end;


procedure Tftsconver.cdriveChange( Sender: TObject );
begin
   cdir.Drive := cdrive.Drive;
end;

procedure Tftsconver.cdirChange( Sender: TObject );
begin
   carchivo.Directory := cdir.Directory;
end;

procedure Tftsconver.carchivoClick( Sender: TObject );
begin
   if carchivo.ItemIndex > -1 then begin
      fuente.Lines.LoadFromFile( carchivo.filename );
      fuente.Color := carchivo.Color;
   end;
   bcompara.Enabled := ( ( dbg.SelectedField <> nil ) and ( carchivo.itemindex > -1 ) );
end;

procedure Tftsconver.bcomparaClick( Sender: TObject );
var
   anterior, nuevo: string;
begin
   //   PR_COMPARA( archivo.FileName, carchivo.FileName );
   anterior := g_tmpdir + '\ori_' + ttsprog.fieldbyname( 'Componente' ).AsString;
   nuevo := cdir.Directory + '\' + ttsprog.fieldbyname( 'Componente' ).AsString;
   if fileexists( nuevo ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'No existe el convertido en el directorio seleccionado' ) ),
         pchar( dm.xlng( 'Conversión ' ) ), MB_OK );
      exit;
   end;
//   dm.trae_fuente( ttsprog.fieldbyname( 'sistema' ).AsString, ttsprog.fieldbyname( 'Componente' ).AsString,
   dm.trae_fuente( cmbsistema.text, ttsprog.fieldbyname( 'Componente' ).AsString,
                   cmbbib.Text, cmbclase.Text, fuente );
   fuente.Lines.SaveToFile( anterior );
   if ShellExecute( Handle, nil, pchar( uti_compara ), pchar( anterior + ' ' + nuevo ),
      nil, SW_SHOW ) <= 32 then
      //Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la conversion' ) ),
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparacion' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   //dm.ejecuta_espera( g_tmpdir + '\hta890.exe ' + anterior + ' ' + nuevo, sw_hide );
end;


procedure Tftsconver.FormResize( Sender: TObject );
begin //fca
   //   archivo.Height := ( grbOriginales.Height - archivo.Top ) - 5;
   carchivo.Height := ( grbConvertidos.Height - carchivo.Top ) - 5;
end;

procedure Tftsconver.dbgDblClick( Sender: TObject );
begin
   if barchivo.Enabled then
      barchivoclick( sender );
end;

procedure Tftsconver.dbgCellClick( Column: TColumn );
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
   bcompara.Enabled:=False;
end;

procedure Tftsconver.FormClose(Sender: TObject; var Action: TCloseAction);
var res:integer;
begin
   if bguarda.Visible then begin
      res:=application.MessageBox('Cambios pendientes en directivas, desea guardarlos?',
         'Confirme',MB_YESNOCANCEL);
      if res=IDCANCEL then
         exit;
      if res=IDYES then
         bguardaclick(sender);
   end;

   if FormStyle = fsMDIChild then
      dm.PubEliminarVentanaActiva( ftsconver.Caption );  //quitar nombre de lista de abiertos


   Self.Destroy;
end;

function Tftsconver.FormHelp(Command: Word; Data: Integer;
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

procedure Tftsconver.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   iHelpContext:=ActiveControl.HelpContext;
end;

procedure Tftsconver.mnuAyudaClick(Sender: TObject);
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

procedure Tftsconver.bdirectivasClick(Sender: TObject);
var res: integer;
begin
   if bguarda.Visible then begin
      res:=application.MessageBox('Cambios pendientes en directivas, desea guardarlos?',
         'Confirme',MB_YESNOCANCEL);
      if res=IDCANCEL then
         exit;
      if res=IDYES then
         bguardaclick(sender);
   end;
   if dm.sqlselect(dm.q1,'select dato from parametro '+
      ' where clave='+g_q+'dirconver_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbib.Text+g_q+
      ' and  secuencia=0') then
      opendialog1.InitialDir:=dm.q1.fieldbyname('dato').AsString;
   if opendialog1.Execute=false then exit;
   if fileexists(opendialog1.FileName) then
      directivas.Lines.LoadFromFile(opendialog1.FileName)
   else begin
      if application.MessageBox('No existe, desea crearlo?','Aviso',MB_YESNO)=IDNO then
         exit;
      directivas.Lines.Clear;
      gdirectivas.Caption:='';
   end;
   directorio_directivas:=extractfilepath(opendialog1.FileName);
   gdirectivas.Caption:=extractfilename(opendialog1.FileName);
   dm.sqlinsert('insert into parametro(clave,secuencia,dato,descripcion) values('+
      g_q+'dirconver_'+cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbib.Text+g_q+',0,'+
      g_q+directorio_directivas+g_q+','+
      g_q+'Directorio donde toma las directivas para convertir '+
      cmbsistema.Text+'_'+cmbclase.Text+'_'+cmbbib.Text+g_q+')');
   bguarda.Visible:=false;

   bdir.Enabled := ( ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) and  //);
      ( trim( directivas.Text ) <> '' ));   //alk para que no lo active hasta que se tengan las directivas
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) and
      ( trim( directivas.Text ) <> '' ));   //alk para que no lo active hasta que se tengan las directivas
   //bcompara.Enabled := barchivo.Enabled;
   bcompara.Enabled:=False;
end;

procedure Tftsconver.bguardaClick(Sender: TObject);
begin
   directivas.Lines.SaveToFile(directorio_directivas+'\'+gdirectivas.caption);
   bguarda.Visible:=false;
end;

procedure Tftsconver.directivasChange(Sender: TObject);
begin
   bguarda.Visible:=true;
end;

procedure Tftsconver.webBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var k:integer;
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
end;

procedure Tftsconver.tabChange(Sender: TObject);
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

end.

