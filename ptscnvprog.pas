unit ptscnvprog;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, FileCtrl, ComCtrls, ExtCtrls, Grids, shellapi,HTML_HELP, htmlhlp,
   DBGrids, DB, ADODB, dxBar;

type
   Tftscnvprog = class( TForm )
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      grbConvertidos: TGroupBox;
      cdir: TDirectoryListBox;
      carchivo: TFileListBox;
      GroupBox4: TGroupBox;
      Label10: TLabel;
      Label11: TLabel;
      Label12: TLabel;
      DataSource1: TDataSource;
      fuente: TMemo;
      ttsprog: TADOQuery;
      Splitter1: TSplitter;
      Panel2: TPanel;
      cdrive: TDriveComboBox;
      Splitter3: TSplitter;
    mnuPrincipal: TdxBarManager;
    mnuAyuda: TdxBarButton;
    Splitter2: TSplitter;
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
    grbOriginales: TGroupBox;
    dbg: TDBGrid;
    GroupBox1: TGroupBox;
    barchivo: TBitBtn;
    bdir: TBitBtn;
    GroupBox2: TGroupBox;
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
      procedure Button1Click( Sender: TObject );
      procedure FormResize( Sender: TObject );
      procedure dbgDblClick( Sender: TObject );
      procedure dbgCellClick( Column: TColumn );
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuAyudaClick(Sender: TObject);
   private
      { Private declarations }
      progok, progmal: Tstringlist;
      bf: Tstringlist; // buffer para traer los componentes
      uti_compara:string;
      procedure trae_utilerias( tipo: string );
      function convierte_cbl( tipo: string; bib: string; nombre: string ):boolean;
      procedure convierte_nat( tipo: string; nombre: string );
      procedure convierte_cpy( nombre: string );
      function convierte_jcl( tipo: string; bib: string; nombre: string ):boolean;
      procedure convierte_BAS( tipo: string; bib: string; nombre: string );
      procedure convierte_BFR( tipo: string; bib: string; nombre: string );
      function convierte:boolean;
   public
      { Public declarations }
   end;

var
   ftscnvprog: Tftscnvprog;

procedure PR_CNVPROG;

implementation
uses ptsdm,ptscomun, ptsgral;

{$R *.DFM}

procedure PR_CNVPROG;
begin
   gral.PubMuestraProgresBar( True );
   Application.CreateForm( Tftscnvprog, ftscnvprog );
   {try
      ftscnvprog.Showmodal;
   finally
      ftscnvprog.Free;
   end;   }

   ftscnvprog.FormStyle := fsMDIChild;

   if gral.bPubVentanaMaximizada = FALSE then begin
      ftscnvprog.Width := g_Width;
      ftscnvprog.Height := g_Height;
   end;

   dm.PubRegistraVentanaActiva( ftscnvprog.Caption );

   ftscnvprog.Show;

   gral.PubMuestraProgresBar( False );
end;

procedure Tftscnvprog.FormCreate( Sender: TObject );
begin
   dm.feed_combo( cmbsistema, 'select csistema from tssistema order by csistema' );
   if cmbsistema.Items.Count = 1 then begin
      cmbsistema.ItemIndex := 0;
      cmbsistemaChange(sender);
   end;
   progok := Tstringlist.Create;
   progmal := Tstringlist.Create;
   bf := Tstringlist.Create;
   ttsprog.Connection := dm.ADOConnection1;
end;

function Tftscnvprog.convierte_cbl( tipo: string; bib: string; nombre: string ):boolean;
var
   original, convertido: string;
   b_nuevo: boolean;
   //buffer: pchar;
   sBFile: String;
   respuesta:integer;
   compo:string;
begin
   if fileexists( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ) then begin
      respuesta:=application.MessageBox(pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) +' ya existe, desea reemplazarlo?'),
         'Confirme',MB_YESNOCANCEL);
      if respuesta=IDCANCEL then begin
         convierte_cbl:=false;
         exit;
      end;
      if respuesta=IDNO then begin
         convierte_cbl:=true;
         exit;
      end;
   end;
   compo:=tipo+' '+bib+' '+nombre;
   SetCurrentDir( g_tmpdir );
   deletefile( 'scan.txt' );
   //original := 'ori_' + ptscomun.cprog2bfile(nombre);  // se usará para un copyfile
   original := g_tmpdir+'\'+ptscomun.cprog2bfile(nombre);  // se usará para un copyfile
   convertido := g_tmpdir+'\'+ 'cnv_' + ptscomun.cprog2bfile(nombre);// se usará para un copyfile
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
   if tipo='CBL' then begin
      bf.Insert( 0, '          Programa ' + uppercase( nombre ) + ' convertido por Sys-Mining' +
         formatdatetime( 'YYYY/MM/DD-HH-MM-SS', now ) );
   end;
   bf.SaveToFile( original );
   dm.ejecuta_espera( 'hta5678.exe ' + original + ' ' + convertido + ' >scan.txt', sw_hide );
   if fileexists( 'scan.txt' ) then begin
      fuente.Lines.LoadFromFile( 'scan.txt' );
      if pos( 'ERROR', fuente.Lines.Text ) > 0 then begin
         application.MessageBox( 'Faltan líneas por convertir.', 'AVISO', MB_OK );
         if progmal.IndexOf( compo ) = -1 then
            progmal.Add( compo );
         if progok.IndexOf( compo ) > -1 then
            progok.delete( progok.indexof( compo ) );
      end
      else begin
         copyfile( pchar( convertido ), pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ), false );
         carchivo.Update;
         if progok.IndexOf( compo ) = -1 then
            progok.Add( compo );
         if progmal.IndexOf( compo ) > -1 then
            progmal.delete( progmal.indexof( compo ) );
      end;
   end
   else begin
      application.MessageBox( 'No pudo ejecutar el convertidor', 'AVISO', MB_OK );
      if progmal.IndexOf( compo ) = -1 then
         progmal.Add( compo );
      if progok.IndexOf( compo ) > -1 then
         progok.delete( progok.indexof( compo ) );
   end;
   //   deletefile(original);
   //   deletefile(convertido);
   fuente.Lines.Clear;
   fuente.Lines.Add( '          Convertidos correctamente ['+inttostr(progok.Count)+']:' );
   fuente.lines.AddStrings( progok );
   fuente.Lines.Add( '          Convertidos con errores   ['+inttostr(progmal.Count)+']:' );
   fuente.lines.AddStrings( progmal );

   setcurrentdir( g_ruta );
   convierte_cbl:=true;
end;

function Tftscnvprog.convierte_jcl( tipo: string; bib: string; nombre: string ):boolean;
var
   original, convertido: string;
   b_nuevo: boolean;
   //buffer: pchar;
   sBFile: String;
   compo:string;
   respuesta:integer;
begin
   if fileexists( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ) then begin
      respuesta:=application.MessageBox(pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) +' ya existe, desea reemplazarlo?'),
         'Confirme',MB_YESNOCANCEL);
      if respuesta=IDCANCEL then begin
         convierte_jcl:=false;
         exit;
      end;
      if respuesta=IDNO then begin
         convierte_jcl:=true;
         exit;
      end;
   end;
   SetCurrentDir( g_tmpdir );
   original := g_tmpdir+'\'+'ori_' + nombre;
   convertido := g_tmpdir+'\'+'cnv_' + nombre;
   bf.Clear;
   compo:=tipo+' '+bib+' '+nombre;

   //dm.leebfile( nombre, bib, tipo, buffer ); //se sustituyo por sPubObtenerBFile
   //bf.Add( buffer );
   //freemem( buffer );

   sBFile := dm.sPubObtenerBFile( nombre, bib, tipo );
   bf.Add( sBFile );

   bf.SaveToFile( original );

   deletefile( original + '.res' );
   deletefile( 'salida' );
   dm.ejecuta_espera(
      g_tmpdir + '\hta8764.exe ' + original + ' salida ' + tipo, sw_hide );
   deletefile( original + '.res' );
   deletefile( original + '.sal.res' );
   fileclose( filecreate( 'file_mknod' ) );
   dm.ejecuta_espera(
      g_tmpdir + '\hta8765.exe ' + 'salida ' + convertido, sw_hide );
   deletefile( 'file_mknod' );

   copyfile( pchar( convertido ), pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ), false );
   carchivo.Update;

   // donde llena las listas progok y progmal para jcl??
   if progok.IndexOf( compo ) = -1 then
      progok.Add( compo );
   if progmal.IndexOf( compo ) > -1 then
      progmal.delete( progmal.indexof( compo ) );

   deletefile( original );
   deletefile( convertido );
   fuente.Lines.Clear;
   fuente.Lines.Add( '          Convertidos correctamente ['+inttostr(progok.Count)+']:' );
   fuente.lines.AddStrings( progok );
   fuente.Lines.Add( '          Convertidos con errores   ['+inttostr(progmal.Count)+']:' );
   fuente.lines.AddStrings( progmal );
   setcurrentdir( g_ruta );
   convierte_jcl:=true;
end;

procedure Tftscnvprog.convierte_nat( tipo: string; nombre: string );
var
   nom, nome, rux: string;
   b_nuevo: boolean;
begin
   {xxx
      nom := extractfilename( lowercase( nombre ) );
      nom := copy( nom, 1, length( nom ) - length( extractfileext( nom ) ) );
      nome := nom;
      nom := dm.minusculas( cmbsistema.text + '_' + cmbbib.text + '_' + nom );
      createdir( g_ruta + '\tmp' );
      SetCurrentDir( g_ruta + 'tmp' );
      deletefile( 'fout.sor' );
      deletefile( 'fout.txt' );
      deletefile( 'ferr.txt' );
      if cmbclase.Text = 'NAT' then
      begin
         fuente.Lines.LoadFromFile( nombre );
         fuente.Lines.SaveToFile( nom );
         copyfile( pchar( g_ruta + 'sistema\sort.exe' ), pchar( 'sort.exe' ), false );
         dm.ejecuta_espera( g_ruta + 'sistema\command.com /C ' +
            g_ruta + 'sistema\rgmnatx.exe NAT ' + nom + ' ' + cmbsistema.text + ' '
            + cmbbib.text, sw_hide );
      end
      else
      begin
         application.MessageBox( 'Tipo de Componente no clasificado', 'ERROR', MB_OK );
         exit;
      end;
      if ( fileexists( 'ferr.txt' ) and fileexists( 'fout.sor' ) ) then
      begin
         fuente.Lines.LoadFromFile( 'ferr.txt' );
         if trim( fuente.Lines.Text ) <> '' then
         begin
            application.MessageBox( pchar( 'Error en el convertidor' + chr( 13 ) +
               fuente.Lines.Text ), 'ERROR', MB_OK );
            if progmal.IndexOf( nombre ) = -1 then
               progmal.Add( nombre );
            if progok.IndexOf( nombre ) > -1 then
               progok.delete( progok.indexof( nombre ) );
         end
         else
         begin
            //fuente.Color := ysel.Color; //fca
            rux := g_dirftp + '/convertidos/' + lowercase( cmbsistema.Text ) + '/natlib';
            b_nuevo := not dm.fileexistsunix( rux, nome + '.cbl' );
            if b_nuevo = false then
            begin
               if dm.direxistsunix( rux, 'respaldos' ) = false then
                  dm.ftp.MakeDir( rux + '/respaldos' );
               dm.ftp.Rename( rux + '/' + nome + '.cbl', rux + '/respaldos/' + nome + '.' + formatdatetime( 'YYYYMMDDHHmmss', now ) );
            end;
            dm.ftp.Put( 'fout.sor', rux + '/' + nome + '.cbl' );
            copyfile( pchar( 'fout.sor' ), pchar( cdir.Directory + '\' + nome + '.cbl' ), false );
            carchivo.Update;
            if progok.IndexOf( nombre ) = -1 then
               progok.Add( nombre );
            if progmal.IndexOf( nombre ) > -1 then
               progmal.delete( progmal.indexof( nombre ) );
         end;
      end
      else
      begin
         application.MessageBox( 'No pudo ejecutar el convertidor', 'ERROR', MB_OK );
         if progmal.IndexOf( nombre ) = -1 then
            progmal.Add( nombre );
         if progok.IndexOf( nombre ) > -1 then
            progok.delete( progok.indexof( nombre ) );
      end;
      fuente.Lines.Clear;
      fuente.Lines.Add( '          Convertidos correctamente:' );
      fuente.lines.AddStrings( progok );
      fuente.Lines.Add( '          Convertidos con errores  :' );
      fuente.lines.AddStrings( progmal );
      setcurrentdir( g_ruta );
      xxx}
end;

{procedure Tcnvprog.convierte_cpy( nombre: string );
var
   nom, nome, rux: string;
   b_nuevo: boolean;
begin
   nom := extractfilename( lowercase( nombre ) );
   nom := copy( nom, 1, length( nom ) - length( extractfileext( nom ) ) );
   nome := nom;
   nom := dm.minusculas( cmbsistema.text + '_' + cmbbib.text + '_' + nom );
   //fuente.Color := ysel.Color; //fca
   rux := g_dirftp + '/convertidos/' + lowercase( cmbsistema.Text ) + '/ddl';
   b_nuevo := not dm.fileexistsunix( rux, nome );
   if b_nuevo = false then
   begin
      if dm.direxistsunix( rux, 'respaldos' ) = false then
         dm.ftp.MakeDir( rux + '/respaldos' );
      dm.ftp.Rename( rux + '/' + nome, rux + '/respaldos/' + nome + '.' + formatdatetime( 'YYYYMMDDHHmmss', now ) );
   end;
   dm.ftp.Put( nombre, rux + '/' + nome );
   copyfile( pchar( nombre ), pchar( cdir.Directory + '\' + nome ), false );
   carchivo.Update;
   if progok.IndexOf( nombre ) = -1 then
      progok.Add( nombre );
   if progmal.IndexOf( nombre ) > -1 then
      progmal.delete( progmal.indexof( nombre ) );
   fuente.Lines.Clear;
   fuente.Lines.Add( '          Convertidos correctamente:' );
   fuente.lines.AddStrings( progok );
   fuente.Lines.Add( '          Convertidos con errores  :' );
   fuente.lines.AddStrings( progmal );
   setcurrentdir( g_ruta );
end;}

procedure Tftscnvprog.convierte_cpy( nombre: string );
var
   nom, nome, rux: string;
   b_nuevo: boolean;
begin
   {xxx
      nom := extractfilename( lowercase( nombre ) );
      nom := copy( nom, 1, length( nom ) - length( extractfileext( nom ) ) );
      nome := nom;
      nom := dm.minusculas( cmbsistema.text + '_' + cmbbib.text + '_' + nom );

      createdir( g_ruta + '\tmp' );
      SetCurrentDir( g_ruta + 'tmp' );
      copyfile( pchar( nombre ), pchar( nom ), false );
      deletefile( 'scan.txt' );

      copyfile( pchar( g_ruta + 'sistema\reserved.cbl' ), pchar( 'reserved' ), false );
      copyfile( pchar( g_ruta + 'sistema\cbl.dir' ), pchar( 'process.dir' ), false );
      dm.ejecuta_espera(
         g_ruta + 'sistema\rgmlang.exe ' + nom + ' ' + nome + ' >scan.txt', sw_hide );
      if fileexists( 'scan.txt' ) then
      begin
         fuente.Lines.LoadFromFile( 'scan.txt' );
         if pos( 'ERROR', fuente.Lines.Text ) > 0 then
         begin
            application.MessageBox( 'Error en el convertidor', 'ERROR', MB_OK );
            if progmal.IndexOf( nombre ) = -1 then
               progmal.Add( nombre );
            if progok.IndexOf( nombre ) > -1 then
               progok.delete( progok.indexof( nombre ) );
         end
         else
         begin
      //fuente.Color := ysel.Color; //fca
            rux := g_dirftp + '/convertidos/' + lowercase( cmbsistema.Text ) + '/ddl';
            b_nuevo := not dm.fileexistsunix( rux, nome );
            if b_nuevo = false then
            begin
               if dm.direxistsunix( rux, 'respaldos' ) = false then
                  dm.ftp.MakeDir( rux + '/respaldos' );
               dm.ftp.Rename( rux + '/' + nome, rux + '/respaldos/' + nome + '.' + formatdatetime( 'YYYYMMDDHHmmss', now ) );
            end;
            dm.ftp.Put( nome, rux + '/' + nome );
            copyfile( pchar( nome ), pchar( cdir.Directory + '\' + nome ), false );
            carchivo.Update;
            if progok.IndexOf( nombre ) = -1 then
               progok.Add( nombre );
            if progmal.IndexOf( nombre ) > -1 then
               progmal.delete( progmal.indexof( nombre ) );
         end;
      end
      else
      begin
         application.MessageBox( 'No pudo ejecutar el convertidor', 'ERROR', MB_OK );
         if progmal.IndexOf( nombre ) = -1 then
            progmal.Add( nombre );
         if progok.IndexOf( nombre ) > -1 then
            progok.delete( progok.indexof( nombre ) );
      end;
      fuente.Lines.Clear;
      fuente.Lines.Add( '          Convertidos correctamente:' );
      fuente.lines.AddStrings( progok );
      fuente.Lines.Add( '          Convertidos con errores  :' );
      fuente.lines.AddStrings( progmal );
      setcurrentdir( g_ruta );
      xxx}
end;
{xxx

procedure Tftscnvprog.convierte_jcl( nombre: string );
var
   nom, nome, rux, rutalocal: string;
   b_nuevo: boolean;
   i: integer;
   mens: Tstringlist;
begin
   nom := extractfilename( lowercase( nombre ) );
   nome := nom;
   //fuente.Color := ysel.Color; fca
   rux := g_dirftp + '/convertidos/' + lowercase( cmbsistema.Text ) + '/' + cmbbib.text;
   rutalocal := 'convertidos/' + lowercase( cmbsistema.Text ) + '/' + cmbbib.text;
   b_nuevo := not dm.fileexistsunix( rux, nome );
   if b_nuevo = false then
   begin
      if dm.direxistsunix( rux, 'respaldos' ) = false then
         dm.ftp.MakeDir( rux + '/respaldos' );
      dm.ftp.Rename( rux + '/' + nome, rux + '/respaldos/' + nome + '.' + formatdatetime( 'YYYYMMDDHHmmss', now ) );
   end;
   chdir( g_ruta );
//   dm.ejecuta_espera(
//         g_ruta+'sistema\preanaljcl.exe '+nom+' '+cmbsistema.Text,sw_maximize);
   deletefile('salida' );
   deletefile('xsalida');
   mens := Tstringlist.Create;
   deletefile( nom + '.res' );
   dm.ejecuta_espera(
      g_ruta + 'sistema\preanaljcl.exe ' + nombre + ' salida ' + cmbsistema.Text , sw_hide );

   deletefile( nom + '.res' );
//   mens.LoadFromFile( nom + '.mens' );
//   if mens.Text <> '' then
//      application.MessageBox( pchar( mens.text ), 'Normal Preanaljcl', MB_OK );
//   deletefile( nom + '.mens' );
   deletefile( nom + '.sal.res' );

   dm.ejecuta_espera(g_ruta + 'sistema\jclunix.exe salida xsalida', sw_hide );

  // mens.Clear;
  // mens.LoadFromFile( nom + '.mens' );
  // if mens.Text <> '' then
  //    application.MessageBox( pchar( mens.text ), 'Error', MB_OK );
   deletefile( nom + '.mens' );

   mens.Free;
   deletefile( nom + '.sal.res' );

//   dm.ftp.Put( rutalocal + '\' + nome, rux + '/' + nome );
   dm.ftp.Put( 'xsalida', rux + '/' + nome );
// 20041006  copyfile('xsalida',pchar(carchivo.Directory+'\'+nome+'.cbl'),false);
   copyfile('xsalida',pchar(carchivo.Directory+'\'+nome),false);
   carchivo.Update;
   if progok.IndexOf( nombre ) = -1 then
      progok.Add( nombre );
   if progmal.IndexOf( nombre ) > -1 then
      progmal.delete( progmal.indexof( nombre ) );
   fuente.Lines.Clear;
   fuente.Lines.Add( '   Contador convertidos correctamente:' );
   fuente.lines.AddStrings( progok );
   fuente.Lines.Add( '   Contador convertidos con errores  :' );
   fuente.lines.AddStrings( progmal );
   setcurrentdir( g_ruta );
end;
   xxx}

procedure Tftscnvprog.convierte_BAS( tipo: string; bib: string; nombre: string );
var
   original, convertido, archivo: string;
   b_nuevo: boolean;
   //buffer: pchar;
   sBFile: String;
begin
   SetCurrentDir( g_tmpdir );
   deletefile( 'scan.txt' );
   original := g_tmpdir+'\'+'ori_' + ptscomun.cprog2bfile(nombre);
   convertido := g_tmpdir+'\'+'cnv_' + ptscomun.cprog2bfile(nombre);
   bf.Clear;

   //dm.leebfile( nombre, bib, tipo, buffer ); //se sustituyo por sPubObtenerBFile
   //bf.Add( buffer );
   //freemem( buffer );

   sBFile := dm.sPubObtenerBFile( nombre, bib, tipo );
   bf.Add( sBFile );

   bf.Insert( 0, '          Programa ' + uppercase( nombre ) + ' convertido por Sys-Mining' +
      formatdatetime( 'YYYY/MM/DD-HH-MM-SS', now ) );
   bf.SaveToFile( original );
   // estaba      dm.ejecuta_espera('hta5679.exe '+original+' '+convertido+' >scan.txt', sw_hide );
   // debe de ser rgmlang PRUEBA.TXT nada convVBtoGX.dir reserved.vb > PRUEBA.TMP
   // queda

   ///////  esto fue para Banorte

   /////////   dm.ejecuta_espera('hta5ertido'+' '+ 'process.dir'+' '+'reserved'+' > scan.txt ', sw_hide );
   ///////   archivo:=g_ruta+'DIRECTIVAS\cnv.bat '+original;
   ///////   dm.ejecuta_espera(g_ruta+'\DIRECTIVAS\cnv.bat '+original+' '+'scan.txt', sw_hide );
   ///////   if fileexists(g_ruta+'scan.txt' ) then begin
   ///////      copyfile( pchar(g_ruta+'scan.txt'), pchar(convertido), false );
   ///////      fuente.Lines.LoadFromFile( g_ruta+'\scan.txt' );
   ///////
   ///////   {if fileexists( 'scan.txt' ) then begin
   ///////    fuente.Lines.LoadFromFile( 'scan.txt' );
   ///////     if pos( 'ERROR', fuente.Lines.Text ) > 0 then begin
   ///////         application.MessageBox( 'Faltan líneas por convertir.', 'AVISO', MB_OK );
   ///////         if progmal.IndexOf( nombre ) = -1 then
   ///////            progmal.Add( nombre );
   ///////         if progok.IndexOf( nombre ) > -1 then
   ///////            progok.delete( progok.indexof( nombre ) );
   ///////      end
   ///////    else begin }
   ///////         copyfile( pchar(convertido), pchar(cdir.Directory+'\'+nombre), false );
   ///////         carchivo.Update;
   ///////         if progok.IndexOf( nombre ) = -1 then
   ///////            progok.Add( nombre );
   ///////         if progmal.IndexOf( nombre ) > -1 then
   ///////            progmal.delete( progmal.indexof( nombre ) );
   ///////    //end;
   //////

   dm.ejecuta_espera( 'hta5ertido' + ' ' + 'process.dir' + ' ' + 'reserved' + ' > scan.txt ', sw_hide );

   if fileexists( 'scan.txt' ) then begin
      fuente.Lines.LoadFromFile( 'scan.txt' );
      if pos( 'ERROR', fuente.Lines.Text ) > 0 then begin
         application.MessageBox( 'Faltan líneas por convertir.', 'AVISO', MB_OK );
         if progmal.IndexOf( nombre ) = -1 then
            progmal.Add( nombre );
         if progok.IndexOf( nombre ) > -1 then
            progok.delete( progok.indexof( nombre ) );
      end
      else begin
         copyfile( pchar( convertido ), pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ), false );
         carchivo.Update;
         if progok.IndexOf( nombre ) = -1 then
            progok.Add( nombre );
         if progmal.IndexOf( nombre ) > -1 then
            progmal.delete( progmal.indexof( nombre ) );
      end;
   end
   else begin
      application.MessageBox( 'No pudo ejecutar el convertidor', 'AVISO', MB_OK );
      if progmal.IndexOf( nombre ) = -1 then
         progmal.Add( nombre );
      if progok.IndexOf( nombre ) > -1 then
         progok.delete( progok.indexof( nombre ) );
   end;
   //   deletefile(original);
   //   deletefile(convertido);
   // fuente.Lines.Clear;
   {   fuente.Lines.Add( '          Convertidos correctamente:' );
      fuente.lines.AddStrings( progok );
      fuente.Lines.Add( '          Convertidos con errores  :' );
      fuente.lines.AddStrings( progmal );
   }
   setcurrentdir( g_ruta );
end;

procedure Tftscnvprog.convierte_BFR( tipo: string; bib: string; nombre: string );
var
   original, convertido: string;
   b_nuevo: boolean;
   buffer: pchar;
   sBFile: String;
   compo:string;
begin
   SetCurrentDir( g_tmpdir );
   deletefile( 'scan.txt' );
   original := g_tmpdir+'\'+'ori_' + nombre;
   convertido := g_tmpdir+'\'+'cnv_' + nombre;
   bf.Clear;

   //dm.leebfile( nombre, bib, tipo, buffer ); //se sustituyo por sPubObtenerBFile
   //bf.Add( buffer );
   //freemem( buffer );

   sBFile := dm.sPubObtenerBFile( nombre, bib, tipo );
   bf.Add( sBFile );

   bf.Insert( 0, '          Pantalla ' + uppercase( nombre ) + ' convertida por Sys-Mining' +
      formatdatetime( 'YYYY/MM/DD-HH-MM-SS', now ) );
   bf.SaveToFile( original );
   dm.ejecuta_espera('hta5680.exe '+original+' '+convertido+' >scan.txt', sw_hide );
   //dm.ejecuta_espera( 'hta5679.exe ' + original + ' ' + convertido + ' ' + 'process.dir' + ' ' + 'reserved' + ' > scan.txt ', sw_hide );
   fuente.Lines.LoadFromFile( 'LOGON.txt' );
   if fileexists( 'scan.txt' ) then begin
      fuente.Lines.LoadFromFile( 'scan.txt' );
      if pos( 'ERROR', fuente.Lines.Text ) > 0 then begin
         application.MessageBox( 'Faltan líneas por convertir.', 'AVISO', MB_OK );
         if progmal.IndexOf( nombre ) = -1 then
            progmal.Add( nombre );
         if progok.IndexOf( nombre ) > -1 then
            progok.delete( progok.indexof( nombre ) );
      end
      else begin
         copyfile( pchar( convertido ), pchar( cdir.Directory + '\' + ptscomun.cprog2bfile(nombre) ), false );
         carchivo.Update;
         if progok.IndexOf( nombre ) = -1 then
            progok.Add( nombre );
         if progmal.IndexOf( nombre ) > -1 then
            progmal.delete( progmal.indexof( nombre ) );
      end;
   end
   else begin
      application.MessageBox( 'No pudo ejecutar el convertidor', 'AVISO', MB_OK );
      if progmal.IndexOf( nombre ) = -1 then
         progmal.Add( nombre );
      if progok.IndexOf( nombre ) > -1 then
         progok.delete( progok.indexof( nombre ) );
   end;
   //   deletefile(original);
   //   deletefile(convertido);       //   fuente.Lines.Clear;

   {tm
      fuente.Lines.Add( '          Convertidos correctamente:' );
      fuente.lines.AddStrings( progok );
      fuente.Lines.Add( '          Convertidos con errores  :' );
      fuente.lines.AddStrings( progmal );
   tmp }
   setcurrentdir( g_ruta );
end;

procedure Tftscnvprog.trae_utilerias( tipo: string );
begin
   if tipo = 'CBL' then begin
      dm.get_utileria( 'RESERVADAS_CBL', g_tmpdir + '\reserved' );
      dm.get_utileria( 'CNV CBL', g_tmpdir + '\process.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\hta5678.exe' );
   end
   else if tipo = 'BAS' then begin
      dm.get_utileria( 'RESERVADAS BAS', g_tmpdir + '\reserved' );
      dm.get_utileria( 'CNV BAS', g_tmpdir + '\process.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\hta5679.exe' );
   end
   else if tipo = 'BFR' then begin
      dm.get_utileria( 'RESERVADAS BAS', g_tmpdir + '\reserved' );
      dm.get_utileria( 'CNV BFR', g_tmpdir + '\process.dir' );
      dm.get_utileria( 'RGMLANG', g_tmpdir + '\hta5679.exe' );
   end
   else
      if ( tipo = 'JCL' ) or ( tipo = 'JOB' ) then begin
         dm.get_utileria( 'PREANALJCL', g_tmpdir + '\hta8764.exe' );
         dm.get_utileria( 'JCLUNIX', g_tmpdir + '\hta8765.exe' );
      end;
end;

function Tftscnvprog.convierte:boolean;
begin
   if      (cmbclase.Text = 'CBL') or (cmbclase.Text = 'CPY') then
      convierte:=convierte_cbl( cmbclase.text, cmbbib.Text, ttsprog.fieldbyname( 'componente' ).AsString )
   else if ( cmbclase.Text = 'JOB' ) or ( cmbclase.Text = 'JCL' ) then
      convierte:=convierte_jcl( cmbclase.text, cmbbib.Text, ttsprog.fieldbyname( 'componente' ).AsString )
   else if ( cmbclase.Text = 'BAS' ) then
      convierte_BAS( cmbclase.text, cmbbib.Text, ttsprog.fieldbyname( 'componente' ).AsString )
   else if ( cmbclase.Text = 'BFR' ) then
      convierte_BFR( cmbclase.text, cmbbib.Text, ttsprog.fieldbyname( 'componente' ).AsString )
   else
   begin
      application.MessageBox( 'Tipo de componente no implementado', 'ERROR', MB_OK );
      convierte:=false;
      exit;
   end;
end;
procedure Tftscnvprog.barchivoClick( Sender: TObject );
var
   sDirectorio: String;
   sDirectorioC: String;
begin
   dbg.Visible:=true;
   if ttsprog.RecordCount=0 then exit;
   try
      trae_utilerias( cmbclase.Text );
   except
      Exit;
   end;

   //screen.Cursor := crsqlwait;
   screen.Cursor := crNo;     // alk para cambiar el cursor
   gral.PubMuestraProgresBar( true );     // alk para barra de espera

   convierte;

   screen.Cursor := crdefault;
   gral.PubMuestraProgresBar( False );

   bcompara.Enabled := True;
end;

procedure Tftscnvprog.cmbsistemaChange( Sender: TObject );
begin
   dm.feed_combo( cmbclase, 'select distinct cclase from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' order by cclase' );

   cmbbib.clear;
   barchivo.enabled := false;
   bdir.enabled := false;
   bcompara.Enabled := False;
   ttsprog.Close;

   if cmbsistema.Text <> '' then
      fuente.Lines.Clear;

   dbg.Visible:=false;
end;

procedure Tftscnvprog.cmbclaseChange( Sender: TObject );
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
   bcompara.Enabled := False;
   ttsprog.Close;

   if cmbclase.Text <> '' then
      fuente.Lines.Clear;

   dbg.Visible:=false;
end;

procedure Tftscnvprog.cmbbibChange( Sender: TObject );
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
   bdir.Enabled := ( ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   //bcompara.Enabled := barchivo.Enabled;
   bcompara.Enabled := False;

   if cmbbib.Text <> '' then
      fuente.Lines.Clear;

   dbg.Visible:=true;
end;

procedure Tftscnvprog.bdirClick( Sender: TObject );
var
   i: integer;
begin
   dbg.Visible:=true;
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

   screen.Cursor := crdefault;
   gral.PubMuestraProgresBar( False );

   bcompara.Enabled := True;
end;

procedure Tftscnvprog.cdriveChange( Sender: TObject );
begin
   cdir.Drive := cdrive.Drive;
end;

procedure Tftscnvprog.cdirChange( Sender: TObject );
begin
   carchivo.Directory := cdir.Directory;
end;

procedure Tftscnvprog.carchivoClick( Sender: TObject );
begin
   if carchivo.ItemIndex > -1 then begin
      fuente.Lines.LoadFromFile( carchivo.filename );
      fuente.Color := carchivo.Color;
   end;
   bcompara.Enabled := ( ( dbg.SelectedField <> nil ) and ( carchivo.itemindex > -1 ) );
end;

procedure Tftscnvprog.bcomparaClick( Sender: TObject );
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
   if uti_compara='' then begin
      uti_compara:=g_tmpdir + '\hta'+formatdatetime('YYYYMMDDHHNNSSZZZ',now)+'.exe';
      g_borrar.Add(uti_compara);
      //dm.get_utileria( 'COMPARACION DE FUENTES', g_tmpdir + '\hta890.exe' );
      dm.get_utileria( 'COMPARACION DE FUENTES', uti_compara );
   end;
   if ShellExecute( Handle, nil, pchar( uti_compara ), pchar( anterior + ' ' + nuevo ),
      nil, SW_SHOW ) <= 32 then
      //Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la conversion' ) ),
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparacion' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   //dm.ejecuta_espera( g_tmpdir + '\hta890.exe ' + anterior + ' ' + nuevo, sw_hide );
end;

procedure Tftscnvprog.Button1Click( Sender: TObject );
begin
   Close;
end;

procedure Tftscnvprog.FormResize( Sender: TObject );
begin //fca
   //   archivo.Height := ( grbOriginales.Height - archivo.Top ) - 5;
   carchivo.Height := ( grbConvertidos.Height - carchivo.Top ) - 5;
end;

procedure Tftscnvprog.dbgDblClick( Sender: TObject );
begin
   if barchivo.Enabled then
      barchivoclick( sender );
end;

procedure Tftscnvprog.dbgCellClick( Column: TColumn );
begin
   iHelpContext := IDH_TOPIC_T01804;
   if ttsprog.Active = false then
      exit;
   //dm.trae_fuente( ttsprog.fieldbyname( 'sistema' ).AsString, ttsprog.fieldbyname( 'Componente' ).AsString,
   dm.trae_fuente( cmbSistema.text, ttsprog.fieldbyname( 'Componente' ).AsString,
                   cmbbib.Text, cmbclase.Text, fuente );
   fuente.Color := dbg.Color;
   bcompara.Enabled := False;
end;

procedure Tftscnvprog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //close;
    if FormStyle = fsMDIChild then
      dm.PubEliminarVentanaActiva( ftscnvprog.Caption );  //quitar nombre de lista de abiertos

    self.Destroy;
end;

function Tftscnvprog.FormHelp(Command: Word; Data: Integer;
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

procedure Tftscnvprog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   iHelpContext:=ActiveControl.HelpContext;
   With VertScrollbar do
      if Key = VK_NEXT then
         Position := Position + 10
      else if Key = VK_PRIOR then
         Position := Position - 10
      else
         Position := Position;
end;

procedure Tftscnvprog.mnuAyudaClick(Sender: TObject);
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

end.

