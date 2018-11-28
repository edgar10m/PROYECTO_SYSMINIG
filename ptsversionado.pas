unit ptsversionado;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ComCtrls, ExtCtrls, OleCtrls, SHDocVw, shellapi, strutils, HTML_HELP,
   Menus, dxBar;
type
   Tpares = record
      prg1: string;
      prg2: string;
   end;
type
   Tftsversionado = class( TForm )
      web1: TWebBrowser;
      split1: TSplitter;
      skel: TMemo;
      MainMenu1: TMainMenu;
      Archivo1: TMenuItem;
      IndiceIzquierdo1: TMenuItem;
      IndiceSuperior1: TMenuItem;
      Ventanas1: TMenuItem;
      Verticales1: TMenuItem;
      Horizontales1: TMenuItem;
      Salir1: TMenuItem;
      Panel1: TPanel;
      split2: TSplitter;
      rich2: TRichEdit;
      rich: TRichEdit;
      PopupMenu1: TPopupMenu;
      Compara1: TMenuItem;
    mnuPrincipal: TdxBarManager;
    mnuCompara: TdxBarButton;
      procedure web1BeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure web1DocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      procedure Salir1Click( Sender: TObject );
      procedure IndiceIzquierdo1Click( Sender: TObject );
      procedure IndiceSuperior1Click( Sender: TObject );
      procedure Verticales1Click( Sender: TObject );
      procedure Horizontales1Click( Sender: TObject );
      procedure Compara1Click( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure web1ProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure FormCreate(Sender: TObject);
    procedure mnuComparaClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

   private
      { Private declarations }
      ht: Tstringlist;
      rr: array of Tpares;
      prg1, prg2: string; // programas actuales en las richedit
      b_compara: boolean;
      comparador: string;
      guias:String;
      procedure compara( sistema: string; nombre: string; biblioteca: string; clase: string;
         {guias: string; }v1: string; v2: string );
   public
      { Public declarations }
      titulo: string;
      procedure arma( nombre: string; biblioteca: string; clase: string; sistema: string );
      function valida( nombre: string; biblioteca: string; clase: string; sistema: string ):boolean;
   end;

var
   ftsversionado: Tftsversionado;


implementation
uses ptsdm, ptsvmlx, parbol, ptsgral;
{$R *.dfm}

procedure Tftsversionado.compara( sistema, nombre: string; biblioteca: string; clase: string;
   {guias: string; }v1: string; v2: string );
var
   n1, n2: string;
begin
   n1 := g_tmpdir + '\' + nombre + '.' + v1;
   n2 := g_tmpdir + '\' + nombre + '.' + v2;
   dm.trae_fuente( sistema, nombre + '.' + v1, 'VER_' + biblioteca, clase, ht );
   ht.SaveToFile( n1 );
   dm.trae_fuente( sistema, nombre + '.' + v2, 'VER_' + biblioteca, clase, ht );
   ht.SaveToFile( n2 );
   dm.ejecuta_espera( 'echo [Versionado] ' + n1 + ' ' + n2 + ' >>' + guias, SW_HIDE );
   dm.ejecuta_espera( 'fc /n /w ' + n1 + ' ' + n2 + ' >>' + guias, SW_HIDE );
end;

function Tftsversionado.valida( nombre: string; biblioteca: string; clase: string; sistema: string ):boolean;
var
   i, j, k, ver, blk1, blk2, a1, a2, b1: integer;
   {guias,} programa, versiones, linea, pre, v1, v2, x1, x2: string;

begin
   screen.Cursor := crsqlwait;

   ht := Tstringlist.Create;
   if dm.sqlselect( dm.q1, 'select cblob from tsversion ' +
      ' where cprog=' + g_q + nombre + g_q +
      ' and   cbib=' + g_q + biblioteca + g_q +
      ' and   cclase=' + g_q + clase + g_q +
      ' order by fecha desc' ) then begin
      v1 := dm.q1.fieldbyname( 'cblob' ).AsString;
      if dm.q1.RecordCount = 1 then begin
         Application.MessageBox( pchar( dm.xlng( 'Sólo existe una versión del componente ' + nombre + ' (' + v1 + ')' ) ),
            pchar( dm.xlng( 'Versiones del componente ' ) ), MB_OK );
         screen.Cursor := crdefault;
         valida:=false;
         exit;
      end;

      dm.q1.Next;
      guias := g_tmpdir + '\fc' + formatdatetime( 'YYYYMMDDHHNNSS', now );
      deletefile( guias );
      g_borrar.Add( guias );
      while not dm.q1.Eof do begin
         v2 := dm.q1.fieldbyname( 'cblob' ).AsString;
         compara( sistema, nombre, biblioteca, clase, {guias,} v1, v2 );
         v1 := v2;
         dm.q1.Next;
      end;
   end;
   ht.Clear;

   if guias = '' then begin
      Application.MessageBox( pchar( dm.xlng( 'Componente no existe' ) ),
         pchar( dm.xlng( 'Versionado ' ) ), MB_OK );
      screen.Cursor := crdefault;
      valida:=false;
      exit;
   end;

   valida:=true;
end;

procedure Tftsversionado.arma( nombre: string; biblioteca: string; clase: string; sistema: string );
var
   i, j, k, ver, blk1, blk2, a1, a2, b1: integer;
   x, mm: Tstringlist;
   {guias, }programa, versiones, linea, pre, v1, v2, x1, x2: string;
begin
   screen.Cursor := crsqlwait;
   caption := titulo;

   mm := Tstringlist.Create;
   x := Tstringlist.Create;
   //ht := Tstringlist.Create;

   {   if dm.sqlselect( dm.q1, 'select cblob from tsversion ' +
      ' where cprog=' + g_q + nombre + g_q +
      ' and   cbib=' + g_q + biblioteca + g_q +
      ' and   cclase=' + g_q + clase + g_q +
      ' order by fecha desc' ) then begin
      v1 := dm.q1.fieldbyname( 'cblob' ).AsString;
      if dm.q1.RecordCount = 1 then begin
         Application.MessageBox( pchar( dm.xlng( 'Sólo existe una versión del componente ' + nombre + ' (' + v1 + ')' ) ),
            pchar( dm.xlng( 'Versiones del componente ' ) ), MB_OK );
         screen.Cursor := crdefault;
         exit;
      end;
      dm.q1.Next;
      guias := g_tmpdir + '\fc' + formatdatetime( 'YYYYMMDDHHNNSS', now );
      deletefile( guias );
      g_borrar.Add( guias );
      while not dm.q1.Eof do begin
         v2 := dm.q1.fieldbyname( 'cblob' ).AsString;
         compara( sistema, nombre, biblioteca, clase, guias, v1, v2 );
         v1 := v2;
         dm.q1.Next;
      end;
   end;
   ht.Clear;
   mm := Tstringlist.Create;
   x := Tstringlist.Create;
   if guias = '' then begin
      Application.MessageBox( pchar( dm.xlng( 'Componente no existe' ) ),
         pchar( dm.xlng( 'Versionado ' ) ), MB_OK );
      screen.Cursor := crdefault;
      exit;
   end;    }

   if guias='' then
      guias := g_tmpdir + '\fc' + formatdatetime( 'YYYYMMDDHHNNSS', now );
      
   mm.LoadFromFile( guias );
   x.CommaText := mm[ 0 ];
   programa := extractfilename( x[ 1 ] );
   programa := copy( programa, 1, length( programa ) - length( extractfileext( programa ) ) );
   //caption := 'Versionado componente ' + programa;
   ver := 0;
   for j := 0 to skel.Lines.Count - 1 do begin
      if copy( skel.Lines[ j ], 1, 1 ) <> 'G' then begin
         ht.Add( stringreplace( skel.Lines[ j ], '%programa', programa, [ ] ) );
      end;
      if copy( skel.Lines[ j ], 1, 2 ) = 'G0' then begin
         for i := 0 to mm.Count - 1 do begin
            if copy( mm[ i ], 1, 13 ) = '[Versionado] ' then begin
               x.CommaText := mm[ i ];
               prg1 := x[ 1 ];
               prg2 := x[ 2 ];
               k := length( rr );
               setlength( rr, k + 1 );
               rr[ k ].prg1 := prg1;
               rr[ k ].prg2 := prg2;
               x1 := extractfileext( x[ 1 ] );
               delete( x1, 1, 1 );
               x1 := copy( x1, 1, 4 ) + '/' + copy( x1, 5, 2 ) + '/' + copy( x1, 7, 2 ) + ' ' +
                  copy( x1, 9, 2 ) + ':' + copy( x1, 11, 2 ) + ':' + copy( x1, 13, 2 );
               x2 := extractfileext( x[ 2 ] );
               delete( x2, 1, 1 );
               x2 := copy( x2, 1, 4 ) + '/' + copy( x2, 5, 2 ) + '/' + copy( x2, 7, 2 ) + ' ' +
                  copy( x2, 9, 2 ) + ':' + copy( x2, 11, 2 ) + ':' + copy( x2, 13, 2 );
               versiones := x2 + ' --> ' + x1;
               linea := copy( skel.Lines[ j ], 3, 500 );
               linea := stringreplace( linea, '%numver', inttostr( ver ), [ ] );
               linea := stringreplace( linea, '%%versiones', versiones, [ ] );
               ht.Add( Linea );
               mm[ i + 1 ] := '<a name="version' + inttostr( ver ) + '">' +
               '<center><p>' + versiones + '</p></center>' +
                  '<a href=#indice>Ir al Indice</a>';
               inc( ver );
            end;
         end;
      end;
      if copy( skel.Lines[ j ], 1, 2 ) = 'G1' then
         break;
   end;
   k := -1;
   for i := 0 to mm.Count - 1 do begin
      if copy( mm[ i ], 1, 13 ) = '[Versionado] ' then begin
         x.CommaText := mm[ i ];
         prg1 := lowercase( x[ 1 ] );
         prg2 := lowercase( x[ 2 ] );
         inc( k );
      end
      else if copy( mm[ i ], 1, 2 ) = '<a' then begin
         ht.Add( mm[ i ] );
      end
      else if copy( mm[ i ], 1, 5 ) = '*****' then begin
         linea := lowercase( trim( copy( mm[ i ], 7, 500 ) ) );
         if linea = prg1 then begin
            blk1 := ht.Count;
            ht.Add( ' ' );
            pre := '';
            a1 := 0;
         end
         else if linea = prg2 then begin
            blk2 := ht.Count;
            ht.Add( ' ' );
            pre := '<a href=#linea' + inttostr( a1 ) + '.' + inttostr( a2 );
            b1 := a1;
            a1 := 0;
         end
         else begin
            pre := pre + '.' + inttostr( a1 ) + '.' + inttostr( a2 ) + '.' + inttostr( k );
            ht[ blk1 ] := pre + '>' + extractfileext( prg1 ) + ' Linea ' + inttostr( b1 ) + '</a>' +
               '<font face=courier color="green">';
            ht[ blk2 ] := '</font>' + pre + '>' + extractfileext( prg2 ) + ' Linea ' + inttostr( a1 ) + '</a>' +
               '<font face=courier color="red">';
            ht.Add( '</font><hr>' );
         end;
      end
      else if uppercase( copy( mm[ i ], 1, 5 ) ) = 'ERROR' then begin
         ht.Add( '<center><p><font face=arial color="red">' + mm[ i ] + '</font></p></center>' );
      end
      else if uppercase( copy( mm[ i ], 1, 6 ) ) = 'FC: NO' then begin
         ht.Add( '<center><p><font face=arial color="red">' + copy( mm[ i ], 5, 100 ) + '</font></p></center>' );
      end
      else begin
         j := pos( ':', mm[ i ] );
         if j > 0 then begin
            if a1 = 0 then begin
               a1 := strtoint( trim( copy( mm[ i ], 1, j - 1 ) ) );
            end;
            a2 := strtoint( trim( copy( mm[ i ], 1, j - 1 ) ) );
            ht.Add( copy( mm[ i ], j + 2, 1000 ) );
         end;
      end;
   end;
   ht.Add( '</pre>' );
   ht.Add( '</body>' );
   ht.Add( '</html>' );
   ht.SaveToFile( guias + '.htm' );
   web1.Navigate( guias + '.htm' );
   g_borrar.Add( guias + '.htm' );
   prg1 := '';
   prg2 := '';
   mm.Free;
   x.Free;
   screen.Cursor := crdefault;
end;

procedure Tftsversionado.web1BeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   i, k, m, n, len: integer;
   x: Tstringlist;
begin
   k := pos( '#linea', URL );

   if k > 0 then begin
      x := Tstringlist.Create;
      x.CommaText := stringreplace( copy( URL, k + 6, 100 ), '.', ',', [ rfreplaceall ] );
      k := strtoint( x[ 4 ] );
      rich.SelAttributes.Color := clblack;
      rich.Lines.LoadFromFile( rr[ k ].prg1 );
      prg1 := rr[ k ].prg1;
      rich2.SelAttributes.Color := clblack;
      rich2.Lines.LoadFromFile( rr[ k ].prg2 );
      prg2 := rr[ k ].prg2;
      k := strtoint( x[ 0 ] ) - 1;
      n := strtoint( x[ 1 ] ) - 1;
      len := 0;
      for i := k to n do
         len := len + length( rich.Lines[ i ] ) + 2;
      Rich.SelStart := Rich.Perform( EM_LINEINDEX, k, 0 );
      rich.Perform( EM_SCROLLCARET, 0, 0 );
      m := rich.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
      if k - m > 15 then
         rich.Perform( EM_LINESCROLL, 0, 15 );
      rich.SelLength := len;
      rich.SelAttributes.Color := clgreen;
      rich.SelAttributes.Style := [ fsbold ];

      k := strtoint( x[ 2 ] ) - 1;
      n := strtoint( x[ 3 ] ) - 1;
      len := 0;
      for i := k to n do
         len := len + length( rich2.Lines[ i ] ) + 2;
      Rich2.SelStart := Rich2.Perform( EM_LINEINDEX, k, 0 );
      rich2.Perform( EM_SCROLLCARET, 0, 0 );
      m := rich2.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
      if k - m > 15 then
         rich2.Perform( EM_LINESCROLL, 0, 15 );
      rich2.SelLength := len;
      rich2.SelAttributes.Color := clred;
      rich2.SelAttributes.Style := [ fsbold ];

      mnuCompara.Enabled:=true;         //alk   para habilitar el boton
      mnuCompara.Hint:='';          //alk

      cancel := true;
   end
   else begin
      k := pos( '#version', URL );        //#version0
      if k > 0 then begin
         k := StrToInt(copy( URL, k + 8, 100 ));
         prg1 := rr[ k ].prg1;
         prg2 := rr[ k ].prg2;

         mnuCompara.Enabled:=true;         //alk   para habilitar el boton
         mnuCompara.Hint:='';          //alk
      end;
   end;
end;

procedure Tftsversionado.web1DocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   web1.Refresh;
   gral.PubMuestraProgresBar( False );
end;

procedure Tftsversionado.Salir1Click( Sender: TObject );
begin
   Close;
end;

procedure Tftsversionado.IndiceIzquierdo1Click( Sender: TObject );
begin
   split1.Align := alleft;
   web1.Align := alleft;
   web1.Width := 500;
end;

procedure Tftsversionado.IndiceSuperior1Click( Sender: TObject );
begin
   web1.Align := altop;
   split1.Align := altop;
   web1.Height := 250;
end;

procedure Tftsversionado.Verticales1Click( Sender: TObject );
begin
   split2.Align := alleft;
   rich2.Align := alleft;
   rich2.Width := 500;
end;

procedure Tftsversionado.Horizontales1Click( Sender: TObject );
begin
   rich2.Align := albottom;
   split2.Align := albottom;
   rich2.Height := 250;
end;

procedure Tftsversionado.Compara1Click( Sender: TObject );
begin
   if b_compara = false then begin
      comparador := g_tmpdir + '\htacmp123.exe';
      dm.get_utileria( 'COMPARACION DE FUENTES', comparador );
      g_borrar.Add( comparador );
      b_compara := true;
   end;
   if ShellExecute( Handle, nil, pchar( comparador ), pchar( prg1 + ' ' + prg2 ), nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
end;

procedure Tftsversionado.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftsversionado.web1ProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
   gral.PubAvanzaProgresBar;
end;

procedure Tftsversionado.FormCreate(Sender: TObject);
begin
  if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsversionado.mnuComparaClick(Sender: TObject);
begin
   if b_compara = false then begin
      comparador := g_tmpdir + '\htacmp123.exe';
      dm.get_utileria( 'COMPARACION DE FUENTES', comparador );
      g_borrar.Add( comparador );
      b_compara := true;
   end;
   if ShellExecute( Handle, nil, pchar( comparador ), pchar( prg1 + ' ' + prg2 ), nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
end;

procedure Tftsversionado.FormActivate(Sender: TObject);
begin
   iHelpContext:=IDH_TOPIC_T02903;
   g_producto := 'MENÚ CONTEXTUAL-VERSIONES';
end;

end.

