unit ptslistacompo;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, Grids, ADODB, printers,
   OleServer, ComObj, ExcelXP, Menus, OleCtrls, SHDocVw, dxBar, HTML_HELP,
   Excel97;

type
   Txx = record
      clase: string;
      bib: string;
      nombre: string;
      modo: string;
      organizacion: string;
      externo: string;
      coment: string;
      existe: boolean;
      uso: integer;
   end;
type
   Ttotal = record
      clase: string;
      total: integer;
   end;
type
   Tftslistacompo = class( TForm )
      PrintDialog1: TPrintDialog;
      SaveDialog1: TSaveDialog;
      ExcelApplication1: TExcelApplication;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Splitter1: TSplitter;
    dg: TDrawGrid;
    GroupBox1: TGroupBox;
    cmbnom: TComboBox;
    Panel5: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbltotal: TLabel;
    cmbclase: TComboBox;
    cmblibreria: TComboBox;
    cmbmascara: TComboBox;
    lstcomponente: TListBox;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    chkref: TCheckBox;
    btodas: TBitBtn;
    bunix: TBitBtn;
    bexportatodo: TBitBtn;
    Panel3: TPanel;
    dgt: TDrawGrid;
    web: TWebBrowser;
    mnuPrincipal: TdxBarManager;
    mnuExporta: TdxBarButton;          
    mnuImprime: TdxBarButton;
    bexportar: TBitBtn;
      procedure FormCreate( Sender: TObject );
      procedure cmbclaseChange( Sender: TObject );
      procedure cmblibreriaChange( Sender: TObject );
      procedure dgtDrawCell( Sender: TObject; ACol, ARow: Integer;
         Rect: TRect; State: TGridDrawState );
      procedure bimprimirClick( Sender: TObject );
      procedure bClick( Sender: TObject );
      procedure lstcomponenteClick( Sender: TObject );
      procedure lstcomponenteClickSistema( sistema: string );
      procedure cmbmascaraChange( Sender: TObject );
      procedure Acercade1Click( Sender: TObject );
      procedure Salir1Click( Sender: TObject );
      procedure bexportarClick( Sender: TObject );
      procedure bexportarExcelClick( Sender: TObject );
      procedure CreaWeb( );
      procedure webBeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      procedure webDocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      function ArmarOpciones(b1:Tstringlist):integer;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
    procedure FormDestroy(Sender: TObject);
    procedure webProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure mnuExportaClick(Sender: TObject);
    procedure mnuImprimeClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

   private
      { Private declarations }
      clases: Tstringlist;
      clasesexiste: Tstringlist;
      xx: Tstringlist;
      loc1, loc2: Tstringlist;
      tt: array of Ttotal;
      bitmap: Tbitmap;
      lin, iy: integer;
      dgClase, dgLibreria, dgcomponente, dgModo, dgOrganizacion, dgExterno,
         dgComentario, dgExiste, dgusadopor, dgtotal: string;
      excluyemenu: Tstringlist;
      b_impresion: boolean;
      Opciones: Tstringlist;
      procedure leecompos( compo: string; bib: string; clase: string );
      function agrega_compo( qq: Tadoquery ): boolean;
      procedure pinta( Rect: TRect; columna: integer; texto: string );
      procedure titulos;
      procedure totales;
      procedure WebPreviewPrint( web: TWebBrowser );

   public
      { Public declarations }
      titulo: string;
      procedure arma( clase: string; bib: string; nombre: string );
   end;

var
   ftslistacompo: Tftslistacompo;
   Wprog, Wbib, Wclase: String;
   x: array of Txx;
   f_top: integer;
   f_left: integer;
   WnomLogo: string;
   Wfecha: string;
   W_nomcomponente: string;

procedure PR_LISTACOMPO;
procedure PR_LISTA( clase: string; bib: string; nombre: string );

implementation
uses ptsdm, ptsmain, facerca, ptsgral, QRCtrls;
{$R *.dfm}

procedure PR_LISTACOMPO;
begin
   gral.PubMuestraProgresBar( True );
   try
      ftslistacompo.cmbclase.ItemIndex := ftslistacompo.cmbclase.Items.IndexOf( '' );
      ftslistacompo.cmbclaseChange( ftslistacompo.cmbclase );
      ftslistacompo.cmblibreria.ItemIndex := ftslistacompo.cmblibreria.Items.IndexOf( '' );
      ftslistacompo.cmblibreriaChange( ftslistacompo.cmblibreria );
      ftslistacompo.cmbmascara.ItemIndex := ftslistacompo.cmbmascara.Items.IndexOf( '%' );
      ftslistacompo.cmbmascaraChange( ftslistacompo.cmbmascara );
      ftslistacompo.lstcomponente.ItemIndex := ftslistacompo.lstcomponente.Items.IndexOf( '' );
      ftslistacompo.lstcomponenteClick( ftslistacompo.lstcomponente );
      ftslistacompo.Show;
  finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure PR_LISTA( clase: string; bib: string; nombre: string );
begin
   gral.PubMuestraProgresBar( True );
   Application.CreateForm( Tftslistacompo, ftslistacompo );
   try
      ftslistacompo.GroupBox1.Visible := false;
      ftslistacompo.cmbclase.ItemIndex := ftslistacompo.cmbclase.Items.IndexOf( clase );
      ftslistacompo.cmbclaseChange( ftslistacompo.cmbclase );
      ftslistacompo.cmblibreria.ItemIndex := ftslistacompo.cmblibreria.Items.IndexOf( bib );
      ftslistacompo.cmblibreriaChange( ftslistacompo.cmblibreria );
      ftslistacompo.cmbmascara.ItemIndex := ftslistacompo.cmbmascara.Items.IndexOf( copy( nombre, 1, 2 ) + '%' );
      ftslistacompo.cmbmascaraChange( ftslistacompo.cmbmascara );
      ftslistacompo.lstcomponente.ItemIndex := ftslistacompo.lstcomponente.Items.IndexOf( nombre );
      ftslistacompo.lstcomponenteClick( ftslistacompo.lstcomponente );
      ftslistacompo.ShowModal;
   finally
      gral.PubMuestraProgresBar( False );
      ftslistacompo.Free;
   end;
end;

procedure Tftslistacompo.arma( clase: string; bib: string; nombre: string );
var
   lNomMasc : String;
begin
   gral.PubMuestraProgresBar( True );
   bgral := clase+' '+bib+' '+nombre;
   try
      caption := titulo;
      GroupBox1.Visible := false;
      if nombre = 'SCRATCH' then
         abort;
      W_nomcomponente := nombre;
      if clase = 'SISTEMA' then begin
          lstcomponenteClickSistema( nombre );
      end
      else begin
          cmbclase.ItemIndex := cmbclase.Items.IndexOf( clase );
          cmbclaseChange( cmbclase );
          cmblibreria.ItemIndex := cmblibreria.Items.IndexOf( bib );
          cmblibreriaChange( cmblibreria );
          cmbmascara.ItemIndex := cmbmascara.Items.IndexOf( '%' + (copy( nombre, 1, 2 ) + '%' ));
          cmbmascaraChange( cmbmascara );
          lstcomponente.ItemIndex := lstcomponente.Items.IndexOf( nombre );
          lstcomponenteClick( lstcomponente );
      end;

//   GroupBox1.Visible := false;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftslistacompo.FormCreate( Sender: TObject );
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;
   if g_language = 'ENGLISH' then begin
      pagecontrol1.Pages[ 0 ].Caption := 'List';
      pagecontrol1.Pages[ 0 ].Visible := false;
      groupbox1.Caption := 'Select';
      label3.Caption := 'Class';
      label1.Caption := 'Library';
      label2.Caption := 'Component';
      //bimprimir.Caption := 'Print';
      bexportar.Caption := 'Export';
      //bexportarExcel.Caption := 'Excel';
      //bsalir.Hint := 'Exit';
      //analisisdeimpacto1.Caption := 'Impact Analysis';
      dgClase := 'Class';
      dgLibreria := 'Library';
      dgcomponente := 'Component';
      dgModo := 'Mode';
      dgOrganizacion := 'Organization';
      dgExterno := 'External';
      dgComentario := 'Comment';
      dgExiste := 'Exists';
      //dgusadopor := 'Used by';
      dgtotal := 'Total';
   end
   else begin
      dgClase := 'Clase';
      dgLibreria := 'Libreria';
      dgcomponente := 'Componente';
      dgModo := 'Modo';
      dgOrganizacion := 'Organización';
      dgExterno := 'Externo';
      dgComentario := 'Comentario';
      dgExiste := 'Existe';
      //dgusadopor := 'Usado por';
      dgtotal := 'Total';
   end;

   //dm.feed_combo( cmbclase, 'select cclase from tsclase where estadoactual=' +
   //   g_q + 'ACTIVO' + g_q + 'order by cclase' );

    dm.feed_combo( cmbclase, 'select unique hcclase from tsrela , tsclase where cclase = hcclase and estadoactual =' +
        g_q + 'ACTIVO' + g_q + ' and hcbib <> '+g_q+'BD'+g_q+' order by hcclase');

   clases := Tstringlist.Create;
   clasesexiste := Tstringlist.Create;
   xx := Tstringlist.Create;
   loc1 := Tstringlist.Create;
   loc2 := Tstringlist.Create;
   bitmap := Tbitmap.Create;

    if dm.sqlselect( dm.q1, 'select * from tsclase ' +
      ' where estadoactual=' + g_q + 'ACTIVO' + g_q +
      ' order by cclase' ) then begin


 //  if dm.sqlselect( dm.q1, 'select unique hcclase from tsrela , tsclase where cclase = hcclase and estadoactual =' +
 //        g_q + 'ACTIVO' + g_q + ' and hcbib <> '+g_q+'BD'+g_q+' order by hcclase') then begin

      while not dm.q1.Eof do begin
         clases.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;

   clasesexiste.AddStrings( clases );
{
   clases.Add( 'FIL' );
   clases.Add( 'TAB' );
   clases.Add( 'INS' );
   clases.Add( 'DEL' );
   clases.Add( 'UPD' );
   clases.Add( 'UTI' );
   clases.Add( 'STE' );
   clases.Add( 'PNL' ); // panel de IDEAL
   clases.Add( 'DVW' ); // Dataview de IDEAL-DATACOM
 }
   //dgt.Color := $00E1C8D3; //jcr
   dgt.DefaultDrawing := false; //jcr
   dgt.colcount := 3;
   dgt.rowcount := 1;
   dgt.DefaultRowHeight := 20;

   dgt.ColWidths[ 0 ] := 20;
   dgt.ColWidths[ 1 ] := 50;
   dgt.ColWidths[ 2 ] := 50;

   excluyemenu := Tstringlist.Create;
   if dm.sqlselect( dm.q1, 'select dato from parametro where clave=' + g_q + 'EXCLUYEMENU' + g_q ) then begin
      while not dm.q1.Eof do begin
         excluyemenu.Add( dm.q1.fieldbyname( 'dato' ).AsString );
         dm.q1.Next;
      end;
   end;
   Wfecha := formatdatetime( 'YYYYMMDDHHMMSSZZZZ', now );
   gral.CargaRutinasjs( );
   WnomLogo := 'LC' + Wfecha;
   gral.CargaLogo( WnomLogo );
   gral.CargaIconosBasicos( );
   gral.CargaIconosClases( );

  if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );   
end;

procedure Tftslistacompo.cmbclaseChange( Sender: TObject );
begin
   gral.ActivaSoloClasesUsadas;
   dm.feed_combo( cmblibreria, 'select distinct cbib from tsprog ' +
      ' where cclase=' + g_q + cmbclase.Text + g_q +
      ' order by cbib' );
end;

procedure Tftslistacompo.cmblibreriaChange( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   dm.feed_combo( cmbmascara, 'select distinct substr(hcprog,1,2)||' + g_q + '%' + g_q + ' from tsrela ' +
      ' where hcclase=' + g_q + cmbclase.Text + g_q +
      ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
      ' order by 1' );
   cmbmascara.Items.Insert( 0, '%' );
   lstcomponente.Items.Clear;
   screen.Cursor := crdefault;
end;

function Tftslistacompo.agrega_compo( qq: Tadoquery ): boolean;
var
   cc, mensaje: string;
   i, k, n: integer;
begin
   cc := qq.FieldByName( 'hcprog' ).AsString + '|' +
      qq.FieldByName( 'hcbib' ).AsString + '|' +
      qq.FieldByName( 'hcclase' ).AsString;
   if qq.FieldByName('hcclase').AsString='FIL' then begin  // Si está en un paso con IDCAMS lo descarta, suponniendo que lo está borrando Liverpool
      if dm.sqlselect(dm.q4,'select * from tsrela '+
         ' where pcprog='+g_q+qq.fieldbyname('pcprog').AsString+g_q+
         ' and   pcbib='+g_q+qq.fieldbyname('pcbib').AsString+g_q+
         ' and   pcclase='+g_q+qq.fieldbyname('pcclase').AsString+g_q+
         ' and   hcprog='+g_q+'IDCAMS'+g_q+
         ' and   hcbib='+g_q+'SYSTEM'+g_q+
         ' and   hcclase='+g_q+'UTI'+g_q) then begin
         agrega_compo := false;
         exit;
      end;
   end;
   if xx.IndexOf( cc ) > -1 then begin
      agrega_compo := false;
      exit;
   end;
   xx.Add( cc );
   k := length( x );
   mensaje := 'x='+inttostr(k);
   //g_log.Add( mensaje );
   //g_log.SaveToFile( g_tmpdir + '\sysviewlog');
   setlength( x, k + 1 );
   for n := 0 to k - 1 do begin // ordena componentes
      if x[ n ].clase < qq.FieldByName( 'hcclase' ).AsString then
         continue;
      if x[ n ].clase > qq.FieldByName( 'hcclase' ).AsString then begin
         for i := k - 1 downto n do
            x[ i + 1 ] := x[ i ];
         k := n;
         break;
      end;
      if x[ n ].bib < qq.FieldByName( 'hcbib' ).AsString then
         continue;
      if x[ n ].bib > qq.FieldByName( 'hcbib' ).AsString then begin
         for i := k - 1 downto n do
            x[ i + 1 ] := x[ i ];
         k := n;
         break;
      end;
      if x[ n ].nombre < qq.FieldByName( 'hcprog' ).AsString then
         continue;
      if x[ n ].nombre > qq.FieldByName( 'hcprog' ).AsString then begin
         for i := k - 1 downto n do
            x[ i + 1 ] := x[ i ];
         k := n;
         break;
      end;
   end;
   x[ k ].nombre := qq.FieldByName( 'hcprog' ).AsString;
   x[ k ].bib := qq.FieldByName( 'hcbib' ).AsString;
   x[ k ].clase := qq.FieldByName( 'hcclase' ).AsString;
   x[ k ].modo := qq.FieldByName( 'modo' ).AsString;
   x[ k ].organizacion := qq.FieldByName( 'organizacion' ).AsString;
   x[ k ].externo := qq.FieldByName( 'externo' ).AsString;
   x[ k ].coment := qq.FieldByName( 'coment' ).AsString;
   if clasesexiste.IndexOf( x[ k ].clase ) > -1 then
      x[ k ].existe := dm.sqlselect( dm.q2, 'select * from tsprog ' +
         ' where cprog=' + g_q + qq.FieldByName( 'hcprog' ).AsString + g_q +
         ' and   cbib=' + g_q + qq.FieldByName( 'hcbib' ).AsString + g_q +
         ' and   cclase=' + g_q + qq.FieldByName( 'hcclase' ).AsString + g_q );
   if qq.FieldByName( 'hcclase' ).AsString = 'FIL' then begin
      n := loc1.IndexOf( qq.FieldByName( 'externo' ).AsString );
      if n > -1 then
         x[ k ].organizacion := loc2[ n ];
   end;
   if length( x ) > 0 then begin
      mnuExporta.Visible :=  ivAlways;
      mnuImprime.Visible :=  ivAlways;
   end else begin
      mnuExporta.Visible :=  ivNever;
      mnuImprime.Visible :=  ivnever;
   end;
   agrega_compo := true;
end;

procedure Tftslistacompo.leecompos( compo: string; bib: string; clase: string );
var
   qq: Tadoquery;
   nuevo: boolean;
begin
   qq := Tadoquery.Create( self );
   qq.Connection := dm.ADOConnection1;
   if dm.sqlselect( qq, 'select * from tsrela ' +
      ' where pcprog=' + g_q + compo + g_q +
      ' and   pcbib=' + g_q + bib + g_q +
      ' and   pcclase=' + g_q + clase + g_q+
      ' order by orden ') then begin           // agregado RGM Liverpool
      while not qq.Eof do begin
         if clases.IndexOf( qq.FieldByName( 'hcclase' ).AsString ) > -1 then
            nuevo := agrega_compo( qq )
         else
            nuevo := true;
         if nuevo and ( excluyemenu.IndexOf( qq.fieldbyname( 'hcprog' ).AsString ) = -1 ) then
            leecompos( qq.FieldByName( 'hcprog' ).AsString,
               qq.FieldByName( 'hcbib' ).AsString,
               qq.FieldByName( 'hcclase' ).AsString );
         if qq.FieldByName( 'hcclase' ).AsString = 'LOC' then begin
            loc1.Insert( 0, uppercase( qq.fieldbyname( 'externo' ).AsString ) );
            loc2.insert( 0, qq.fieldbyname( 'organizacion' ).AsString );
         end;
         qq.Next;
      end;
   end;
   qq.Free;
end;

procedure Tftslistacompo.pinta( Rect: TRect; columna: integer; texto: string );
var
   Alineacion: TAlignment; // Alineación que le vamos a dar al texto
   iAnchoTexto: Integer; // Ancho del texto a imprimir en pixels
begin
   // Si es la columna es uso alineamos a la derecha
   if columna = 9 then
      Alineacion := taRightJustify
   else
      Alineacion := taLeftJustify;
end;

procedure Tftslistacompo.dgtDrawCell( Sender: TObject; ACol, ARow: Integer;
   Rect: TRect; State: TGridDrawState );
begin
   if arow > dgt.RowCount - 1 then
      exit;
   if acol > dgt.ColCount - 1 then
      exit;
   if arow = 0 then begin
      dgt.canvas.brush.color := $00FFD3A8 ;// $00C5DEE2;//$00E9E0E6; //$00B77B96;
      dgt.canvas.Font.color :=  $00151515;
      if acol = 1 then
         dgt.canvas.textrect( rect, rect.left, rect.top, dgClase );
      if acol = 2 then
         dgt.canvas.textrect( rect, rect.left, rect.top, dgTotal );
   end;
   if arow > 0 then begin
      if acol mod 2 = 1 then
         dgt.Canvas.brush.color := $00FCFCFC//$00FFD3A8 //$00C5DEE2 //$00E9E0E6//$00CBA0B4
      else
         dgt.Canvas.brush.color := $00FCFCFC;//$00C5DEE2;//$00E1C8D3;
      case acol of
         0: begin
               bitmap.Canvas.FillRect( bitmap.Canvas.ClipRect );
               dm.imgclases.GetBitmap( dm.lclases.IndexOf( tt[ arow - 1 ].clase ), bitmap );
               dgt.Canvas.Draw( rect.left, rect.top, bitmap );
            end;
         1: dgt.canvas.TextRect( rect, rect.left, rect.Top, tt[ arow - 1 ].clase );
         //   2:dgt.canvas.TextRect( rect, rect.left, rect.Top, inttostr(tt[arow-1].total));
         2: dgt.canvas.TextRect( rect, Rect.Right - ( dgt.canvas.TextWidth( inttostr( tt[ arow - 1 ].total ) ) ) - 2, Rect.Top + 2, inttostr( tt[ arow - 1 ].total ) );
      end;
   end;
end;

procedure Tftslistacompo.titulos;
var
   mitad, ancho: integer;
   ARect: TRect;
   texto: string;
begin
   mitad := printer.PageWidth div 2;
   ARect := Rect( 0, 0, ftsmain.imglogo.Picture.Bitmap.Width * 5, ftsmain.imglogo.Picture.bitmap.Height * 5 );
   printer.Canvas.StretchDraw( arect, ftsmain.imglogo.Picture.bitmap );
   printer.canvas.TextOut( 4200, 50, dm.xlng( 'Página:' + inttostr( lin div 50 + 1 ) + ' / ' + inttostr( length( x ) div 50 + 1 ) ) );
   printer.canvas.Font.Size := 16;
   printer.canvas.Font.Style := [ fsbold ];
   ancho := printer.canvas.TextWidth( g_empresa );
   printer.Canvas.TextOut( mitad - ( ancho div 2 ), 50, g_empresa );
   printer.canvas.Font.Size := 8;
   printer.canvas.Font.Style := [ ];
   texto := dm.xlng( 'Reporte de Componentes de ' + cmbclase.text + ' - ' + cmblibreria.Text + ' - ' + lstcomponente.items[ lstcomponente.itemindex ] );
   ancho := printer.canvas.TextWidth( texto );
   printer.Canvas.Rectangle( mitad - ( ancho div 2 ) - 5, 280, mitad + ( ancho div 2 ) + 5, 395 );
   printer.Canvas.TextOut( mitad - ( ancho div 2 ), 290, texto );
   printer.canvas.textout( 4200, 290, formatdatetime( 'YYYY/MM/DD', now ) );
   printer.canvas.textout( 300, 400, dgClase );
   printer.canvas.textout( 500, 400, dgLibreria );
   printer.canvas.textout( 1000, 400, dgComponente );
   printer.canvas.textout( 2670, 400, dgModo );
   printer.canvas.textout( 2970, 400, dgOrganizacion );
   printer.canvas.textout( 3170, 400, dgExterno );
   printer.canvas.textout( 3520, 400, dgExiste );
   //printer.canvas.textout( 3720, 400, dgUsadopor );
   printer.canvas.textout( 3980, 400, dgComentario );
   printer.canvas.textout( 50, 6300, 'svw-ftslistacompo-1' );
   printer.Canvas.textout( 4200, 6300, 'SysViewSoftSCM' );
end;

procedure Tftslistacompo.totales;
var
   i, j, k: integer;
begin
   printer.Canvas.MoveTo( 300, 500 );
   printer.canvas.lineto( 300, iy + 100 );
   printer.Canvas.MoveTo( 500, 500 );
   printer.canvas.lineto( 500, iy + 100 );
   printer.Canvas.MoveTo( 1000, 500 );
   printer.canvas.lineto( 1000, iy + 100 );
   printer.Canvas.MoveTo( 2670, 500 );
   printer.canvas.lineto( 2670, iy + 100 );
   printer.Canvas.MoveTo( 2970, 500 );
   printer.canvas.lineto( 2970, iy + 100 );
   printer.Canvas.MoveTo( 3170, 500 );
   printer.canvas.lineto( 3170, iy + 100 );
   printer.Canvas.MoveTo( 3570, 500 );
   printer.canvas.lineto( 3570, iy + 100 );
   printer.Canvas.MoveTo( 3670, 500 );
   printer.canvas.lineto( 3670, iy + 100 );
   printer.Canvas.MoveTo( 3980, 500 );
   printer.canvas.lineto( 3980, iy + 100 );
   printer.Canvas.MoveTo( printer.PageWidth - 2, 500 );
   printer.canvas.lineto( printer.PageWidth - 2, iy + 100 );
   printer.canvas.MoveTo( 100, iy + 100 );
   printer.Canvas.Lineto( printer.PageWidth - 2, iy + 100 );
   iy := iy + 200;
   k := 0;
   for i := 0 to length( tt ) div 8 do begin
      for j := 0 to 7 do begin
         while k < length( tt ) do begin
            printer.canvas.Rectangle( j * 500 + 100, iy, j * 500 + 350, iy + 100 );
            printer.canvas.Rectangle( j * 500 + 350, iy, j * 500 + 600, iy + 100 );
            printer.Canvas.TextOut( j * 500 + 150, iy + 5, tt[ k ].clase );
            printer.canvas.textout( j * 500 + 450, iy + 5, inttostr( tt[ k ].total ) );
            k := k + 1;
            break;
         end;
      end;
      iy := iy + 100;
   end;
end;

procedure Tftslistacompo.bimprimirClick( Sender: TObject );
var
   Warchivo: string;
begin
   b_impresion := true;
   Warchivo := g_tmpdir + '\LC' + W_nomcomponente + 'IMP.html';
   Web.Navigate( Warchivo );
end;

procedure Tftslistacompo.bClick( Sender: TObject );
var
   arch: string;
   i: integer;
begin
   gral.BorraIconosTmp( );
   gral.BorraRutinasjs( );
   arch := g_tmpdir + g_tmpdir + '\LC' + W_nomcomponente + '.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + g_tmpdir + '\LC' + W_nomcomponente + 'IMP.html';
   g_borrar.Add( arch );
   close;
end;

procedure Tftslistacompo.lstcomponenteClick( Sender: TObject );
var
   i, k: integer;
   ant: string;
begin
   g_procesa := true;

   if lstcomponente.ItemIndex = -1 then begin
      g_procesa := false;
      exit;
   end;
    
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      setlength( x, 0 );
      xx.Clear;
      loc1.Clear;
      loc2.Clear;
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + lstcomponente.Items[ lstcomponente.itemindex ] + g_q +
         ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
         ' and   hcclase=' + g_q + cmbclase.Text + g_q ) then begin
         agrega_compo( dm.q1 );
         leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
            dm.q1.FieldByName( 'hcbib' ).AsString,
            dm.q1.FieldByName( 'hcclase' ).AsString );

         Wprog := lstcomponente.Items[ lstcomponente.itemindex ];
         Wbib := cmblibreria.Text;
         Wclase := cmbclase.Text;
         bgral:= cmbclase.Text+' '+cmblibreria.Text+' '+lstcomponente.Items[ lstcomponente.itemindex ];
         if length( x ) > 0 then
            CreaWeb 
         else begin
            Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
               pchar( dm.xlng( 'Lista de componentes' ) ), MB_OK );
         end;
      end;
      dgt.RowCount := 1;
      setlength( tt, 0 );
      ant := '';
      K := 0;
      for i := 0 to length( x ) - 1 do begin
         if ant <> x[ i ].clase then begin
            k := length( tt );
            setlength( tt, k + 1 );
            tt[ k ].clase := x[ i ].clase;
            tt[ k ].total := 0;
            ant := x[ i ].clase;
            dgt.RowCount := dgt.RowCount + 1;
         end;
         inc( tt[ k ].total );
      end;
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;

end;

procedure Tftslistacompo.lstcomponenteClickSistema( sistema: string );
var
   i, k: integer;
   ant: string;
begin
   screen.Cursor := crsqlwait;
   setlength( x, 0 );
   xx.Clear;
   loc1.Clear;
   loc2.Clear;
   if dm.sqlselect( dm.q1, 'select * from tsrela ' +
      ' where sistema =' + g_q + sistema + g_q ) then begin
      agrega_compo( dm.q1 );
      leecompos( dm.q1.FieldByName( 'pcprog' ).AsString,
         dm.q1.FieldByName( 'pcbib' ).AsString,
         dm.q1.FieldByName( 'pcclase' ).AsString );

         if length( x ) > 0 then
            CreaWeb 
         else begin
            Application.MessageBox( pchar( dm.xlng( 'No existe información procesar.' ) ),
               pchar( dm.xlng( 'Lista de componentes' ) ), MB_OK );
         end;
   end;
   dgt.RowCount := 1;
   setlength( tt, 0 );
   ant := '';
   K := 0;
   for i := 0 to length( x ) - 1 do begin
      if ant <> x[ i ].clase then begin
         k := length( tt );
         setlength( tt, k + 1 );
         tt[ k ].clase := x[ i ].clase;
         tt[ k ].total := 0;
         ant := x[ i ].clase;
         dgt.RowCount := dgt.RowCount + 1;
      end;
      inc( tt[ k ].total );
   end;
   screen.Cursor := crdefault;
end;

procedure Tftslistacompo.cmbmascaraChange( Sender: TObject );
begin
   gral.PubMuestraProgresBar( TRUE );
   try
      screen.Cursor := crsqlwait;
      lstcomponente.Items.Clear;
      if (cmbmascara.Text = '%') or
         (cmbmascara.Text = '') then begin
         if dm.sqlselect( dm.q1, 'select distinct hcprog from tsrela ' +
          ' where hcclase=' + g_q + cmbclase.Text + g_q +
          ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
          ' order by hcprog' ) then begin
          while not dm.q1.Eof do begin
             lstcomponente.Items.Add( dm.q1.fieldbyname( 'hcprog' ).AsString );
             dm.q1.Next;
          end;
       end;
      end
      else begin
         if dm.sqlselect( dm.q1, 'select distinct hcprog from tsrela ' +
            ' where hcclase=' + g_q + cmbclase.Text + g_q +
            ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
            ' and   hcprog like ' + g_q + cmbmascara.Text + g_q +
            ' order by hcprog' ) then begin
            while not dm.q1.Eof do begin
               lstcomponente.Items.Add( dm.q1.fieldbyname( 'hcprog' ).AsString );
               dm.q1.Next;
            end;
         end;
      end;
      lbltotal.Caption := 'Total: ' + inttostr( dm.q1.RecordCount );
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftslistacompo.Acercade1Click( Sender: TObject );
begin
   PR_ACERCA;

end;

procedure Tftslistacompo.Salir1Click( Sender: TObject );
var
   arch: string;
begin
   gral.BorraIconosTmp( );
   gral.BorraRutinasjs( );
   arch := g_tmpdir + '\LC' + W_nomcomponente + '.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\LC' + W_nomcomponente + 'IMP.html';
   g_borrar.Add( arch );
   close;
end;

procedure Tftslistacompo.bexportarClick( Sender: TObject );
var
   i: integer;
   lis: Tstringlist;
   exis, salida: string;
begin
   salida := cmbclase.Text + '_' + cmblibreria.Text + '_' + lstcomponente.Items[ lstcomponente.itemindex ] +
      formatdatetime( 'YYYYMMDDHHMISS', now ) + '.csv';
   savedialog1.FileName := salida;
   if savedialog1.Execute = false then
      exit;
   if fileexists( savedialog1.FileName ) then begin
      if application.MessageBox( 'El archivo existe, desea reemplazarlo?',
         'Confirme', MB_YESNO ) = IDNO then
         exit;
   end;
   lis := Tstringlist.Create;
   for i := 0 to length( x ) - 1 do begin
      if x[ i ].existe then
         exis := '1'
      else
         exis := '0';
      lis.Add( x[ i ].clase + ',' +
         x[ i ].bib + ',' +
         x[ i ].nombre + ',' +
         x[ i ].modo + ',' +
         x[ i ].organizacion + ',' +
         x[ i ].externo + ',' +
         x[ i ].coment + ',' +
         exis + ',' +
         inttostr( x[ i ].uso ) );
   end;
   lis.SaveToFile( savedialog1.FileName );
   lis.Free;
end;

procedure Tftslistacompo.bexportarExcelClick( Sender: TObject );
var
   i, ii: integer;
   exis, salida: string;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;

begin
   i := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   
   Hoja.Cells.Item[ 1, 2 ] := g_empresa;
   Hoja.Cells.Item[ 1, 2 ].font.size := 8;
   Hoja.Cells.Item[ 2, 2 ] := 'Lista de Componentes:'+bgral;
   Hoja.Cells.Item[ 2, 2 ].font.size := 8;
   Hoja.Cells.Item[ i, 1 ] := ' ';
   Hoja.Cells.Item[ i, 2 ] := 'Clase';
   Hoja.Cells.Item[ i, 3 ] := 'Libreria';
   Hoja.Cells.Item[ i, 4 ] := 'Componente';
   Hoja.Cells.Item[ i, 5 ] := 'Modo';
   Hoja.Cells.Item[ i, 6 ] := 'Organización';
   Hoja.Cells.Item[ i, 7 ] := 'Externo';
   Hoja.Cells.Item[ i, 8 ] := 'Comentario';
   Hoja.Cells.Item[ i, 9 ] := 'Existe';
   //Hoja.Cells.Item[ i, 10 ] := 'Usado Por';
   Hoja.Cells.Item[ 2, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 3 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 4 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 5 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 6 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 7 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 8 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 9 ].Font.Bold := True;
   //Hoja.Cells.Item[ i, 10 ].Font.Bold := True;
   salida := ' ';
   i := i + 1;
   while salida = ' ' Do begin
      for ii := 0 to length( x ) - 1 do begin
         if x[ ii ].existe then
            exis := '1'
         else
            exis := '0';
         i := i + 1;
         Hoja.Cells.Item[ i, 1 ] := ' ';
         Hoja.Cells.Item[ i, 2 ] := x[ ii ].clase;
         Hoja.Cells.Item[ i, 3 ] := x[ ii ].bib;
         Hoja.Cells.Item[ i, 4 ] := x[ ii ].nombre;
         Hoja.Cells.Item[ i, 5 ] := x[ ii ].modo;
         Hoja.Cells.Item[ i, 6 ] := x[ ii ].organizacion;
         Hoja.Cells.Item[ i, 7 ] := x[ ii ].externo;
         Hoja.Cells.Item[ i, 8 ] := x[ ii ].coment;
         Hoja.Cells.Item[ i, 9 ] := exis;
         //Hoja.Cells.Item[ i, 10 ] := inttostr( x[ ii ].uso );
      end;
      salida := 'salir';
   end; //while
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftslistacompo.CreaWeb( );
var
   ii: integer;
   xcolor, Wtexto, nom1, nom, icono, Warchivo: string;
   x0, x1: Tstringlist;
begin
   screen.Cursor := crsqlwait;
   x0 := Tstringlist.create;
   x1 := Tstringlist.create;
   x0.Add( '<HTML>' );
   x1.Add( '<HTML>' );
   x0.Add( '<HEAD>' );
   x1.Add( '<HEAD>' );

    // PARA RESALTAR LA LINEA.
   x0.ADD( '<script language="JavaScript" type="text/javascript">' );
   x0.ADD( ' function ResaltarFila(id_tabla){' );
   x0.ADD( '  if (id_tabla == undefined)' );
   x0.ADD( 'var filas = document.getElementsByTagName("tr");' );
   x0.ADD( '  else{' );
   x0.ADD( 'var tabla = document.getElementById(id_tabla);' );
   x0.ADD( 'var filas = tabla.getElementsByTagName("tr");' );
   x0.ADD( '}' );
   x0.ADD( 'for(var i in filas) { ' );
   x0.ADD( 'filas[i].onmouseover = function() { ' );
   x0.ADD( 'this.className = "resaltar";' );
   x0.ADD( '}' );
   x0.ADD( 'filas[i].onmouseout = function() { ' );
   x0.ADD( 'this.className = null; ' );
   x0.ADD( '  }' );
   x0.ADD( ' }' );
   x0.ADD( '}' );
   x0.ADD( '</script>' );

   x0.ADD( '<style type="text/css">' );
   x0.ADD( 'tr.resaltar {' );
   x0.ADD( 'background-color: #E6E6E6;' );
   x0.ADD( '}' );
   x0.ADD( '</style>' );

   // FIN RESALTAR LA LINEA

   x0.Add( '</HEAD>' );
   x1.Add( '</HEAD>' );
   x0.Add( '<TITLE>Sys-Mining</TITLE>' );
   x1.Add( '<TITLE>Sys-Mining</TITLE>' );
   x0.Add( '<BODY Text="#000000" link="#000000" alink= "#FF0000" vlink= "#000000">' );
   x1.Add( '<BODY Text="#000000" link="#000000">' );

   x0.Add( '<div ALIGN=MIDDLE ><img width="100" height="30" src="' + WnomLogo + g_ext + '" ALIGN=right>' );
   x1.Add( '<div ALIGN=MIDDLE ><img width="100" height="30" src="' + WnomLogo + g_ext + '" ALIGN=right>' );

   x0.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );
   x1.Add( '<font size=1>'+'<b>'+g_empresa+'</b>'+'<font>' );
   Wtexto := 'LISTA DE COMPONENTES: ' + Wclase + ' ' + Wbib + ' ' + Wprog;
   W_nomcomponente := Wprog;
   x0.Add( '<p><font size=1>'+'<b>'+Wtexto+'</b>'+'</font></p>' );
   x1.Add( '<p><font size=1>'+'<b>'+Wtexto+'</b>'+'</font></p>' );




   x0.Add( '<TABLE id="tabla_ListaComp" cellspacing="2" BORDER="3">' );
   x1.Add( '<TABLE id="tabla_ListaComp" cellspacing="2" BORDER="3">' );
   x0.Add( '<TR>' );
   x1.Add( '<TR>' );

   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Clase</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Clase</font></TH>' );
   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Libreria</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Libreria</font></TH>' );
   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Componente</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Componente</font></TH>' );
   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Modo</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Modo</font></TH>' );
   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Organización</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Organización</font></TH>' );
   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Externo</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Externo</font></TH>' );
   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Comentario</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Comentario</font></TH>' );
   x0.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Existente</font></TH>' );
   x1.add( '<TH bgcolor="#A9D0F5" NOWRAP><FONT FACE="verdana" size="2">Existente</font></TH>' );
   //x0.add( '<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2">Usado Por</font></TH>' );
   //x1.add( '<TH bgcolor="#BCA9F5" NOWRAP><FONT FACE="verdana" size="2">Usado Por</font></TH>' );

   x0.add( '</TR>' );
   x1.add( '</TR>' );
   x0.add( '<TR>' );
   x1.add( '<TR>' );
   xcolor := '"#E6E6E6"';
   for ii := 0 to length( x ) - 1 do begin
      nom := x[ ii ].clase;
      icono := copy( nom, 1, 3 );
      icono := g_tmpdir + '\ICONO_' + trim( icono ) + '.ico';

      x0.add( '<TD NOWRAP ALIGN=center VALIGN=center><FONT FACE="verdana" size="1"><IMG width="14" height="14" SRC="'
         + icono + '">' + x[ ii ].clase + '</font></TD>' );
      x1.add( '<TD NOWRAP ALIGN=center VALIGN=center><FONT FACE="verdana" size="1"><IMG width="14" height="14" SRC="'
         + icono + '">' + x[ ii ].clase + '</font></TD>' );

      x0.add( '<TD NOWRAP ALIGN=left VALIGN=center><FONT FACE="verdana" size="1">' + x[ ii ].bib + '</font></TD>' );
      x1.add( '<TD NOWRAP ALIGN=left VALIGN=center><FONT FACE="verdana" size="1">' + x[ ii ].bib + '</font></TD>' );

      nom := x[ ii ].nombre;
      nom1 := gral.TextoFracc( nom, 1, 50 );
      x0.add( '<TD><FONT FACE="verdana" size="1">'
         + '<A HREF=#lin' + trim( nom ) + '|' + x[ ii ].bib + '|' + x[ ii ].clase //+' TITLE="Analisis de Impacto"
         + '>'
         + trim( stringreplace( nom1, '?', ' ', [ rfReplaceAll ] ) ) + '</A></font></TD>' );
      x1.add( '<TD width=15 ALIGN=left VALIGN=center><FONT FACE="verdana" size="1">'
         + trim( stringreplace( nom1, '?', ' ', [ rfReplaceAll ] ) ) + '</font></TD>' );

      nom := x[ ii ].modo;
      if nom = '' then begin
         x0.add( '<TD>&nbsp;</TD>' );
         x1.add( '<TD>&nbsp;</TD>' );
      end
      else begin
         x0.add( '<TD NOWRAP ALIGN=center VALIGN=center><FONT FACE="verdana" size="1">' + x[ ii ].modo + '</font></TD>' );
         x1.add( '<TD NOWRAP ALIGN=center VALIGN=center><FONT FACE="verdana" size="1">' + x[ ii ].modo + '</font></TD>' );
      end;

      nom := x[ ii ].organizacion;
      if nom = '' then begin
         x0.add( '<TD>&nbsp;</TD>' );
         x1.add( '<TD>&nbsp;</TD>' );
      end
      else begin
         x0.add( '<TD NOWRAP ALIGN=center VALIGN=center><FONT FACE="verdana" size="1">'
            + x[ ii ].organizacion + '</font></TD>' );
         x1.add( '<TD NOWRAP ALIGN=center VALIGN=center><FONT FACE="verdana" size="1">'
            + x[ ii ].organizacion + '</font></TD>' );
      end;
      nom := x[ ii ].externo;
      if nom = '' then begin
         x0.add( '<TD>&nbsp;</TD>' );
         x1.add( '<TD>&nbsp;</TD>' );
      end
      else begin
         x0.add( '<TD NOWRAP ALIGN=left VALIGN=center><FONT FACE="verdana" size="1">' + x[ ii ].externo + '</font></TD>' );
         x1.add( '<TD NOWRAP ALIGN=left VALIGN=center><FONT FACE="verdana" size="1">' + x[ ii ].externo + '</font></TD>' );
      end;

      nom := x[ ii ].coment;
      if nom = '' then begin
         x0.add( '<TD>&nbsp;</TD>' );
         x1.add( '<TD>&nbsp;</TD>' );
      end
      else begin
         nom := x[ ii ].coment;
         nom1 := gral.TextoFracc( nom, 1, 20 );
         x0.add( '<TD width=15 ALIGN=left VALIGN=top><FONT FACE="verdana" size="1">'
            + trim( stringreplace( nom1, '?', ' ', [ rfReplaceAll ] ) ) + '</font></TD>' );
         x1.add( '<TD width=15 ALIGN=left VALIGN=top><FONT FACE="verdana" size="1">'
            + trim( stringreplace( nom1, '?', ' ', [ rfReplaceAll ] ) ) + '</font></TD>' );
      end;
      if x[ ii ].existe then begin
         x0.add( '<TD ALIGN=center><IMG width="14" height="14" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
         x1.add( '<TD  ALIGN=center><IMG width="14" height="14" SRC="' + g_tmpdir + '\ICONO_TICK.ico"></TD>' );
      end
      else begin
         x0.add( '<TD ALIGN=center><IMG width="14" height="14" SRC="' + g_tmpdir + '\ICONO_NO.ico"></TD>' );
         x1.add( '<TD ALIGN=center><IMG width="14" height="14" SRC="' + g_tmpdir + '\ICONO_NO.ico"></TD>' );
      end;
      //nom := x[ ii ].nombre;
      //x0.add( '<TD NOWRAP ALIGN=right VALIGN=center><FONT FACE="verdana" size="1">'
         //+ '<A HREF=#lin' + trim( nom ) + '|' + x[ ii ].bib + '|' + x[ ii ].clase // TITLE="Analisis de Impacto"
         //+ '>' + inttostr( x[ ii ].uso ) + '</A></font></TD>' );
      //x1.add( '<TD NOWRAP ALIGN=right VALIGN=center><FONT FACE="verdana" size="1">'
         //+ inttostr( x[ ii ].uso ) + '</font></TD>' );

      x0.Add( '</TR>' );
      x1.Add( '</TR>' );
   end;
   x0.Add( '</TABLE>' );
   x1.Add( '</TABLE>' );
   x0.Add( '<script language="JavaScript" type="text/javascript">' );
   x0.Add( 'ResaltarFila("tabla_ListaComp");' );
   x0.Add( '</script>' );
   x0.ADD( '</div>' );
   x1.ADD( '</div>' );
   x0.Add( '</BODY>' );
   x1.Add( '</BODY>' );
   x0.Add( '</HTML>' );
   x1.Add( '</HTML>' );

   Warchivo := g_tmpdir + '\LC' + W_nomcomponente + 'IMP.html';
   x1.savetofile( Warchivo );
   g_borrar.Add( Warchivo );
   Warchivo := g_tmpdir + '\LC' + W_nomcomponente + '.html';
   x0.savetofile( Warchivo );
   g_borrar.Add( Warchivo );
   screen.Cursor := crdefault;

   if fileexists( Warchivo ) then begin
      if g_Wforma_aux = '' then begin
         try
            web.Navigate( Warchivo );
         except
            g_Wforma_Aux := '';
         end;
      end;
   end;
   x0.free;
   x1.free;
end;

procedure Tftslistacompo.webBeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   p, l: integer;
   b1: string;
   x, y: integer;
begin
   p := pos( '#lin', URL );
   if p > 0 then begin
      screen.Cursor := crsqlwait;
      l := Length( URL );
      b1 := copy( URL, p + 4, l - 4 );
      b1 := trim( b1 );
   end;
   if b1 = '' then
      exit;
   bgral := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   Opciones := gral.ArmarMenuConceptualWeb( b1, 'lista_componentes' );
   y:=ArmarOpciones(Opciones);
   gral.PopGral.Popup(g_X, g_Y);
   screen.Cursor := crdefault;
end;

procedure Tftslistacompo.webDocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
var
   Warchivo: string;
begin
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crdefault;
   try
      if b_impresion then begin
         WebPreviewPrint( web );
         Warchivo := g_tmpdir + '\LC' + W_nomcomponente + '.html';
         Web.Navigate( Warchivo );
         b_impresion := false;
      end;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftslistacompo.WebPreviewPrint( web: TWebBrowser );
var
   vin, Vout: OleVariant;
begin
   web.ControlInterface.ExecWB( OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vin, Vout );
end;

{procedure Tftslistacompo.ArmarOpciones( b1: Tstringlist; x, y: integer );
var
   p, j: integer;
   b2: Tstringlist;
   t, NomProg: string;
   Rect: TRect;
   Control: TWinControl;
   Index: Integer;
   State: TOwnerDrawState;
begin
   NomProg := gral.GetModName( );
   gral.PopGral.Items.Clear;
   p := b1.Count;
   b2 := Tstringlist.Create;
   for j := 0 to p - 1 do begin
      b2.CommaText := b1[ j ];
      t := '  ' + stringreplace( b2[ 0 ], '|', ' ', [ rfReplaceAll ] );
      ListOpciones.Items.add( t );
   end;
   ListOpciones.Visible := true;
   b2.Free;
end;
 }
function Tftslistacompo.ArmarOpciones(b1:Tstringlist):integer;
 var
     titulo    : string;
     mm      : Tstringlist;
begin
   mm:=Tstringlist.Create;
   mm.CommaText:=bgral;
   if mm.count < 3 then begin
      Application.MessageBox(pchar(dm.xlng('Falta Nombre ó biblioteca ó clase')),
                             pchar(dm.xlng('Lista opciones ')), MB_OK );
      mm.free;
      exit;
   end;
   //titulo:=Nombre_proc+'  '+mm[0]+' '+mm[1]+' '+mm[2];
   gral.EjecutaOpcionB (b1,'Lista Componentes');
   mm.free;
end;

procedure Tftslistacompo.FormClose( Sender: TObject; var Action: TCloseAction );
var
   arch: string;
   i: integer;
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

   gral.BorraIconosTmp( );
   gral.BorraRutinasjs( );
   arch := g_tmpdir + g_tmpdir + '\LC' + W_nomcomponente + '.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + g_tmpdir + '\LC' + W_nomcomponente + 'IMP.html';
   g_borrar.Add( arch );
   //close;

end;

procedure Tftslistacompo.FormDestroy(Sender: TObject);
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;

procedure Tftslistacompo.webProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
   gral.PubAvanzaProgresBar;  
end;

procedure Tftslistacompo.mnuExportaClick(Sender: TObject);
var
   i, ii: integer;
   exis, salida: string;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;

begin
   i := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;

   Hoja.Cells.Item[ 1, 2 ] := g_empresa;
   Hoja.Cells.Item[ 1, 2 ].font.size := 10;
   Hoja.Cells.Item[ 2, 2 ] := 'Lista de Componentes : '+ bgral;
   Hoja.Cells.Item[ 2, 2 ].font.size := 10;
   Hoja.Cells.Item[ i, 1 ] := ' ';
   Hoja.Cells.Item[ i, 2 ] := 'Clase';
   Hoja.Cells.Item[ i, 3 ] := 'Libreria';
   Hoja.Cells.Item[ i, 4 ] := 'Componente';
   Hoja.Cells.Item[ i, 5 ] := 'Modo';
   Hoja.Cells.Item[ i, 6 ] := 'Organización';
   Hoja.Cells.Item[ i, 7 ] := 'Externo';
   Hoja.Cells.Item[ i, 8 ] := 'Comentario';
   Hoja.Cells.Item[ i, 9 ] := 'Existe';
   //Hoja.Cells.Item[ i, 10 ] := 'Usado Por';
   Hoja.Cells.Item[ 1, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 1 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 2 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 3 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 4 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 5 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 6 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 7 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 8 ].Font.Bold := True;
   Hoja.Cells.Item[ i, 9 ].Font.Bold := True;
   //Hoja.Cells.Item[ i, 10 ].Font.Bold := True;
   salida := ' ';
   i := i + 1;
   while salida = ' ' Do begin
      for ii := 0 to length( x ) - 1 do begin
         if x[ ii ].existe then
            exis := '1'
         else
            exis := '0';
         i := i + 1;
         Hoja.Cells.Item[ i, 1 ] := ' ';
         Hoja.Cells.Item[ i, 2 ] := x[ ii ].clase;
         Hoja.Cells.Item[ i, 3 ] := x[ ii ].bib;
         Hoja.Cells.Item[ i, 4 ] := x[ ii ].nombre;
         Hoja.Cells.Item[ i, 5 ] := x[ ii ].modo;
         Hoja.Cells.Item[ i, 6 ] := x[ ii ].organizacion;
         Hoja.Cells.Item[ i, 7 ] := x[ ii ].externo;
         Hoja.Cells.Item[ i, 8 ] := x[ ii ].coment;
         Hoja.Cells.Item[ i, 9 ] := exis;
         //Hoja.Cells.Item[ i, 10 ] := inttostr( x[ ii ].uso );
      end;
      salida := 'salir';
   end; //while
   ExcelApplication1.Visible[ 1 ] := true;
end;

procedure Tftslistacompo.mnuImprimeClick(Sender: TObject);
var
   Warchivo: string;
begin
   b_impresion := true;
   Warchivo := g_tmpdir + '\LC' + W_nomcomponente + 'IMP.html';
   Web.Navigate( Warchivo );
end;

procedure Tftslistacompo.FormDeactivate(Sender: TObject);
begin
   gral.PopGral.Items.Clear;
end;

procedure Tftslistacompo.FormActivate(Sender: TObject);
begin
    iHelpContext:=IDH_TOPIC_T02800;
    g_producto := 'MENÚ CONTEXTUAL-LISTA DE COMPONENTES';
end;

end.

