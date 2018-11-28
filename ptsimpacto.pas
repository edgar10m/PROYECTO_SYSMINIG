unit ptsimpacto;

interface                       

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, OleCtrls,
   SHDocVw, StdCtrls, ExtCtrls, Menus, OleServer, ExcelXP, Buttons, dxBar, HTML_HELP, htmlhlp,
   ComCtrls, atDiagram, DgrCombo, DgrSelectors, dxBarExtItems, cxStyles, cxCustomData, cxGraphics,
   cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, cxGridCustomTableView, cxGridTableView,
   cxGridDBTableView, cxGridLevel, cxClasses, cxControls, cxGridCustomView, cxGrid, DB, dxmdaset,
   ShlObj;

type
   Tftsimpacto = class( TForm )
      mnuPrincipal: TdxBarManager;
      mnuExportarExcel: TdxBarButton;
      mnuAyuda: TdxBarButton;
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      TabSheet2: TTabSheet;
      web1: TWebBrowser;
      atDiagramAnalisisImpacto: TatDiagram;
      mnuGuardar: TdxBarButton;
      mnuImprimir: TdxBarButton;
      mnuVistaPreliminar: TdxBarButton;
      mnuPaginaConf: TdxBarButton;
      SaveDialog: TSaveDialog;
      mnuZoom: TdxBarCombo;
      mnuTransparencia: TdxBarControlContainerItem;
      DgrTransparencySelector: TDgrTransparencySelector;
      DgrColorSelector: TDgrColorSelector;
      DgrGradientDirectionSelector: TDgrGradientDirectionSelector;
      DgrBrushStyleSelector: TDgrBrushStyleSelector;
      DgrShadowSelector: TDgrShadowSelector;
      DgrPenStyleSelector: TDgrPenStyleSelector;
      DgrPenColorSelector: TDgrPenColorSelector;
      DgrPenWidthSelector: TDgrPenWidthSelector;
      DgrTextColorSelector: TDgrTextColorSelector;
      mnuObjetoColor: TdxBarControlContainerItem;
      mnuGradiente: TdxBarControlContainerItem;
      mnuCepillarEstilo: TdxBarControlContainerItem;
      mnuSombra: TdxBarControlContainerItem;
      mnuLineaEstilo: TdxBarControlContainerItem;
      mnuLineaColor: TdxBarControlContainerItem;
      mnuLineaAncho: TdxBarControlContainerItem;
      mnuTextoColor: TdxBarControlContainerItem;
      DgrFontSelector: TDgrFontSelector;
      DgrFontSizeSelector1: TDgrFontSizeSelector;
      mnuFontTipo: TdxBarControlContainerItem;
      mnuFontTamanio: TdxBarControlContainerItem;
      mnuBold: TdxBarButton;
      mnuItalic: TdxBarButton;
      mnuUnderline: TdxBarButton;
      mnuStrikeOut: TdxBarButton;
      mnuVer: TdxBarSubItem;
      mnuVerReglaIzquierda: TdxBarButton;
      mnuVerReglaSuperior: TdxBarButton;
      mnuVerCuadricula: TdxBarButton;
      mnuNodosAutomaticos: TdxBarButton;
      TabSheet3: TTabSheet;
      DataSource1: TDataSource;
      cxGrid1DBTableView1: TcxGridDBTableView;
      cxGrid1Level1: TcxGridLevel;
      cxGrid1: TcxGrid;
      cxGrid1DBTableView1RecId: TcxGridDBColumn;
      cxGrid1DBTableView1Programa: TcxGridDBColumn;
      cxGrid1DBTableView1Biblioteca: TcxGridDBColumn;
      cxGrid1DBTableView1Clase: TcxGridDBColumn;
      cxGrid1DBTableView1Renglon: TcxGridDBColumn;
      cxGrid1DBTableView1Columna: TcxGridDBColumn;
      cxGrid1DBTableView1Desplaza: TcxGridDBColumn;
      cxGrid1DBTableView1NFisicoBlock: TcxGridDBColumn;
      cxGrid1DBTableView1NLogicoBlock: TcxGridDBColumn;
      cxGrid1DBTableView1LigaBlockOrigen: TcxGridDBColumn;
      cxGrid1DBTableView1LigaBlockDestino: TcxGridDBColumn;
      cxGrid1DBTableView1TipoBlock: TcxGridDBColumn;
      tabComponente: TdxMemData;
      tabComponentePrograma: TStringField;
      tabComponenteBiblioteca: TStringField;
      tabComponenteClase: TStringField;
      tabComponenteRenglon: TIntegerField;
      tabComponenteColumna: TIntegerField;
      tabComponenteDesplaza: TIntegerField;
      tabComponenteNFisicoBlock: TStringField;
      tabComponenteNLogicoBlock: TStringField;
      tabComponenteLigaBlockOrigen: TStringField;
      tabComponenteLigaBlockDestino: TStringField;
      tabComponenteTipoBlock: TStringField;
      mnuDeshacer: TdxBarButton;
      mnuRehacer: TdxBarButton;
      mnuTextoBuscar: TdxBarCombo;
      mnuBuscar: TdxBarButton;
      mnuBuscarAnterior: TdxBarButton;
      mnuBuscarSiguiente: TdxBarButton;
      mnuExportar: TdxBarSubItem;
      mnuExportarWMF: TdxBarButton;
      procedure web1BeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormActivate( Sender: TObject );
      procedure mnuExportarExcelClick( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure web1ProgressChange( Sender: TObject; Progress,
         ProgressMax: Integer );
      procedure web1DocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      procedure FormCreate( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      //    function FormHelp(Command: Word; Data: Integer;
      //      var CallHelp: Boolean): Boolean;
      procedure mnuAyudaClick( Sender: TObject );
      procedure mnuImprimirClick( Sender: TObject );
      procedure mnuVistaPreliminarClick( Sender: TObject );
      procedure mnuGuardarClick( Sender: TObject );
      procedure mnuPaginaConfClick( Sender: TObject );
      procedure mnuZoomChange( Sender: TObject );
      procedure atDiagramAnalisisImpactoDControlDblClick( Sender: TObject;
         ADControl: TDiagramControl );
      procedure mnuBoldClick( Sender: TObject );
      procedure mnuItalicClick( Sender: TObject );
      procedure mnuUnderlineClick( Sender: TObject );
      procedure mnuStrikeOutClick( Sender: TObject );
      procedure mnuNodosAutomaticosClick( Sender: TObject );
      procedure mnuVerReglaIzquierdaClick( Sender: TObject );
      procedure mnuVerReglaSuperiorClick( Sender: TObject );
      procedure mnuVerCuadriculaClick( Sender: TObject );
      procedure mnuDeshacerClick( Sender: TObject );
      procedure mnuRehacerClick( Sender: TObject );
      procedure mnuTextoBuscarExit( Sender: TObject );
      procedure mnuBuscarClick( Sender: TObject );
      procedure mnuBuscarSiguienteClick( Sender: TObject );
      procedure mnuBuscarAnteriorClick( Sender: TObject );
      procedure FormKeyDown( Sender: TObject; var Key: Word;
         Shift: TShiftState );
      procedure atDiagramAnalisisImpactoSelectDControl( Sender: TObject;
         ADControl: TDiagramControl );
      procedure mnuExportarWMFClick( Sender: TObject );
      procedure atDiagramAnalisisImpactoMouseUp( Sender: TObject;
         Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
   private
      excluyemenu: Tstringlist;
      b_impresion: boolean;
      Opciones: Tstringlist;
      slPriBuscar: TStringList;
      sPriTextoBuscar: String;
      iPriAntSigBuscar: Integer;
      { Private declarations }
   public
      { Public declarations }
      titulo: string;
      slPubAnalisisImpacto: TStringList;
      procedure arma( prog: string; bib: string; clase: string );
      procedure ArmaDiagramaVisio( prog: string; bib: string; clase: string ); //diagram studio
   end;

var
   ftsimpacto: Tftsimpacto;
   Pt: Tpoint;
   f_top: integer;
   f_left: integer;

procedure PR_IMPACTO( prog: string; bib: string; clase: string );
procedure PR_IMPAC( );

implementation
uses ptsdm, ptsvmlx, ptsvmlimp, ptsgral, pbarra, uDiagramaRutinas;
{$R *.dfm}

procedure PR_IMPACTO( prog: string; bib: string; clase: string );
begin
   Application.CreateForm( Tftsimpacto, ftsimpacto );
   ftsimpacto.arma( prog, bib, clase );
   ftsimpacto.ArmaDiagramaVisio( prog, bib, clase ); //diagram studio
   try
      ftsimpacto.Showmodal;
   finally
      ftsimpacto.Free;
   end;
end;

procedure PR_IMPAC;
begin
   Application.CreateForm( Tftsimpacto, ftsimpacto );
   try
      ftsimpacto.Showmodal;
   finally
      ftsimpacto.Free;
   end;
end;

procedure Tftsimpacto.arma( prog: string; bib: string; clase: string );
var
   nombre, nombre1: string;
begin
   Exit; //.comentar exit si se reuiere funcionalidad anterior
   gral.PubMuestraProgresBar( True );
   try
      nombre := stringreplace( prog, '/', '.', [ rfreplaceall ] );
      nombre := stringreplace( nombre, '*', 'x', [ rfreplaceall ] );
      nombre := stringreplace( nombre, '#', 'g', [ rfreplaceall ] );
      nombre := stringreplace( nombre, '?', 'i', [ rfreplaceall ] );
      nombre1 := trim( clase ) + '|' + trim( bib ) + '|' + trim( nombre );
      nombre := g_tmpdir + '\Impacto' + clase + bib + nombre + '.html';
      caption := Titulo; //'Análisis de Impacto ' + clase + ' ' + bib + ' ' + prog;
      vml_impacto( clase, bib, prog, '', 'tsrela', nombre, nombre1 );
      web1.Navigate( nombre );
      deletefile( nombre );
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftsimpacto.ArmaDiagramaVisio( prog: string; bib: string; clase: string );
var
   nombre, nombre1: string;
begin
   gral.PubMuestraProgresBar( True );
   try
      nombre := stringreplace( prog, '/', '.', [ rfreplaceall ] );
      nombre := stringreplace( nombre, '*', 'x', [ rfreplaceall ] );
      nombre := stringreplace( nombre, '#', 'g', [ rfreplaceall ] );
      nombre := stringreplace( nombre, '?', 'i', [ rfreplaceall ] );
      nombre1 := trim( clase ) + '|' + trim( bib ) + '|' + trim( nombre );
      nombre := g_tmpdir + '\Impacto' + clase + bib + nombre;
      caption := Titulo; //'Análisis de Impacto ' + clase + ' ' + bib + ' ' + prog;
      iNombre := 0;

      slPubAnalisisImpacto := Tstringlist.Create;

      dgr_impacto(
         clase, bib, prog, caption, 'tsrela',
         atDiagramAnalisisImpacto, tabComponente, slPubAnalisisImpacto, nombre );

      mnuVerReglaIzquierda.ImageIndex := 39;
      mnuVerReglaSuperior.ImageIndex := 39;
      mnuVerCuadricula.ImageIndex := 39;

      atDiagramAnalisisImpacto.MoveBlocks( 1, 0, True ); //reacomoda las lineas
      atDiagramAnalisisImpacto.ClearUndoStack;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftsimpacto.web1BeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   p, p1, l: integer;
   b1: string;
   x1, y1, y: integer;
begin
   p := pos( '#li0', URL );

   if p > 0 then begin
      l := Length( URL );
      b1 := copy( URL, p + 4, l - 4 );
      b1 := trim( b1 );
      if b1 = '' then
         exit;
      screen.Cursor := crsqlwait;
      bgral := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( b1, 'analisis_impacto' );
      //ListOpciones.Hint:= bgral;
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      screen.Cursor := crdefault;
   end
   else begin
      p1 := pos( '#li1', URL );
      if p1 > 0 then begin
         l := Length( URL );
         b1 := copy( URL, p1 + 4, l - 4 );
         b1 := trim( b1 );
         if b1 = '' then
            exit;
         screen.Cursor := crsqlwait;
         //gral.exporta;
         screen.Cursor := crdefault;
      end;
   end;
end;

function Tftsimpacto.ArmarOpciones( b1: Tstringlist ): integer;
begin
   gral.EjecutaOpcionB( b1, 'Análisis de Impacto' );
end;

procedure Tftsimpacto.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsimpacto.FormActivate( Sender: TObject );
var
   l_control: string;
begin
   l_control := stringreplace( caption, 'Análisis de Impacto ', '', [ rfreplaceall ] );
   g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );

   //g_control := g_tmpdir + '\Impacto' +  stringreplace( g_control, '|', '', [ rfreplaceall ] );
   iHelpContext := IDH_TOPIC_T02400;
end;

procedure Tftsimpacto.mnuExportarExcelClick( Sender: TObject );
begin
   gral.exporta( sender );
end;

procedure Tftsimpacto.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );

   slPubAnalisisImpacto.Free;
   slPriBuscar.Free;
end;

procedure Tftsimpacto.web1ProgressChange( Sender: TObject; Progress,
   ProgressMax: Integer );
begin
   gral.PubAvanzaProgresBar;
end;

procedure Tftsimpacto.web1DocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   gral.PubMuestraProgresBar( False );
end;

procedure Tftsimpacto.FormCreate( Sender: TObject );
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;
   mnuPrincipal.Bars[ 2 ].Visible := False;
   iPriAntSigBuscar := 0;
   slPriBuscar := Tstringlist.Create;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsimpacto.FormDeactivate( Sender: TObject );
begin
   gral.PopGral.Items.Clear;
end;
{
function Tftsimpacto.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
    CallHelp := False;
    iHelpContext:=IDH_TOPIC_T02400;
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

procedure Tftsimpacto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   iHelpContext:=IDH_TOPIC_T02400;
end;
 }

procedure Tftsimpacto.mnuAyudaClick( Sender: TObject );
var
   CallHelp: Boolean;
begin
   //CallHelp := False;
   try
      PR_BARRA;
      //iHelpContext:=IDH_TOPIC_T02400;
      HtmlHelp( Application.Handle,
         PChar( Format( '%s::/T%5.5d.htm',
         //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
         [ Application.HelpFile, iHelpContext ] ) ), HH_DISPLAY_TOPIC, 0 );
      //CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;
end;

procedure Tftsimpacto.mnuImprimirClick( Sender: TObject );
begin
   atDiagramAnalisisImpacto.Print( True );
end;

procedure Tftsimpacto.mnuVistaPreliminarClick( Sender: TObject );
begin
   atDiagramAnalisisImpacto.Preview;
end;

procedure Tftsimpacto.mnuGuardarClick( Sender: TObject );
var
   nombre: string;
begin
   with SaveDialog do begin
      DefaultExt := '.dgr';
      Filter := 'Diagramas (*.dgr)|*.dgr';
   end;

   nombre := stringreplace( trim( caption ), 'Análisis de Impacto ', '', [ rfReplaceAll ] );
   nombre := stringreplace( trim( nombre ), ' ', '_', [ rfReplaceAll ] );
   saveDialog.FileName := nombre;
   if SaveDialog.Execute then
      atDiagramAnalisisImpacto.SaveToFile( SaveDialog.FileName );
end;

procedure Tftsimpacto.mnuPaginaConfClick( Sender: TObject );
begin
   atDiagramAnalisisImpacto.PageSetupDlg;
end;

procedure Tftsimpacto.mnuZoomChange( Sender: TObject );
var
   sZoom: String;
begin
   if Trim( mnuZoom.Text ) = '' then
      Exit;

   sZoom := StringReplace( mnuZoom.Text, '%', '', [ ] );

   atDiagramAnalisisImpacto.Zoom := StrToInt( sZoom );
end;

procedure Tftsimpacto.atDiagramAnalisisImpactoDControlDblClick(
   Sender: TObject; ADControl: TDiagramControl );
var
   i, y: Integer;
   sNombre: String;
   slNLogicoBlock: TStringList;
begin
   screen.Cursor := crsqlwait;
   slNLogicoBlock := Tstringlist.Create;
   try

      for i := 0 to slPubAnalisisImpacto.Count - 1 do begin
         if pos( ADControl.Name, slPubAnalisisImpacto[ i ] ) > 0 then begin
            slNLogicoBlock.CommaText := slPubAnalisisImpacto[ i ];

            Break;
         end;
      end;

      if slNLogicoBlock.Count > 0 then begin
         sNombre := slNLogicoBlock[ 1 ] + '|' + slNLogicoBlock[ 2 ] + '|' + slNLogicoBlock[ 3 ];

         bgral := sNombre;
         Opciones := gral.ArmarMenuConceptualWeb( bgral, 'analisis_impacto' );

         y := ArmarOpciones( Opciones );
         gral.PopGral.Popup( g_X, g_Y );
      end;

      {if tabComponente.Locate( 'NFisicoBlock', ADControl.Name, [ ] ) then begin
         sNombre := tabComponente.FindField( 'NLogicoBlock' ).AsString;

         bgral := sNombre;
         Opciones := gral.ArmarMenuConceptualWeb( bgral, 'analisis_impacto' );

         y := ArmarOpciones( Opciones );
         gral.PopGral.Popup( g_X, g_Y );
      end;}
   finally
      slNLogicoBlock.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsimpacto.mnuBoldClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramAnalisisImpacto.SelectedCount( ) - 1 do begin
      dcControl := atDiagramAnalisisImpacto.Selecteds[ i ];

      if fsBold in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsBold ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsBold ];
   end;
end;

procedure Tftsimpacto.mnuItalicClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramAnalisisImpacto.SelectedCount( ) - 1 do begin
      dcControl := atDiagramAnalisisImpacto.Selecteds[ i ];

      if fsItalic in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsItalic ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsItalic ];
   end;
end;

procedure Tftsimpacto.mnuUnderlineClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramAnalisisImpacto.SelectedCount( ) - 1 do begin
      dcControl := atDiagramAnalisisImpacto.Selecteds[ i ];

      if fsUnderline in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsUnderline ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsUnderline ];
   end;
end;

procedure Tftsimpacto.mnuStrikeOutClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramAnalisisImpacto.SelectedCount( ) - 1 do begin
      dcControl := atDiagramAnalisisImpacto.Selecteds[ i ];

      if fsStrikeOut in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsStrikeOut ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsStrikeOut ];
   end;
end;

procedure Tftsimpacto.mnuNodosAutomaticosClick( Sender: TObject );
begin
   if atDiagramAnalisisImpacto.AutomaticNodes = True then begin
      atDiagramAnalisisImpacto.AutomaticNodes := False;
      mnuNodosAutomaticos.ImageIndex := -1;
   end
   else begin
      atDiagramAnalisisImpacto.AutomaticNodes := True;
      mnuNodosAutomaticos.ImageIndex := 39;
   end;
end;

procedure Tftsimpacto.mnuVerReglaIzquierdaClick( Sender: TObject );
begin
   if atDiagramAnalisisImpacto.LeftRuler.Visible = True then begin
      atDiagramAnalisisImpacto.LeftRuler.Visible := False;
      mnuVerReglaIzquierda.ImageIndex := -1;
   end
   else begin
      atDiagramAnalisisImpacto.LeftRuler.Visible := True;
      mnuVerReglaIzquierda.ImageIndex := 39;
   end;
end;

procedure Tftsimpacto.mnuVerReglaSuperiorClick( Sender: TObject );
begin
   if atDiagramAnalisisImpacto.TopRuler.Visible = True then begin
      atDiagramAnalisisImpacto.TopRuler.Visible := False;
      mnuVerReglaSuperior.ImageIndex := -1;
   end
   else begin
      atDiagramAnalisisImpacto.TopRuler.Visible := True;
      mnuVerReglaSuperior.ImageIndex := 39;
   end;
end;

procedure Tftsimpacto.mnuVerCuadriculaClick( Sender: TObject );
begin
   if atDiagramAnalisisImpacto.SnapGrid.Visible = True then begin
      atDiagramAnalisisImpacto.SnapGrid.Visible := False;
      mnuVerCuadricula.ImageIndex := -1;
   end
   else begin
      atDiagramAnalisisImpacto.SnapGrid.Visible := True;
      mnuVerCuadricula.ImageIndex := 39;
   end;
end;

procedure Tftsimpacto.mnuDeshacerClick( Sender: TObject );
var
   sNextRedo: String;
begin
   atDiagramAnalisisImpacto.Undo;

   sNextRedo := atDiagramAnalisisImpacto.NextRedoAction;
   mnuRehacer.Enabled := sNextRedo <> '';
end;

procedure Tftsimpacto.mnuRehacerClick( Sender: TObject );
var
   sNextUndo: String;
begin
   atDiagramAnalisisImpacto.Redo;

   sNextUndo := atDiagramAnalisisImpacto.NextUndoAction;
   mnuDeshacer.Enabled := sNextUndo <> '';
end;

procedure Tftsimpacto.mnuTextoBuscarExit( Sender: TObject );
var
   i: Integer;
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if Trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   Screen.Cursor := crSqlWait;
   try
      if sPriTextoBuscar <> mnuTextoBuscar.Text then begin
         sPriTextoBuscar := mnuTextoBuscar.Text;
         slPriBuscar.Clear;
         iPriAntSigBuscar := 0;

         for i := 0 to slPubAnalisisImpacto.Count - 1 do begin
            if pos( UpperCase( mnuTextoBuscar.Text ), UpperCase( slPubAnalisisImpacto[ i ] ) ) > 0 then begin
               slPriBuscar.Add( slPubAnalisisImpacto[ i ] );
            end;
         end;

         if slPriBuscar.Count > 0 then begin
            //sPriTextoBuscar := mnuTextoBuscar.Text;
            slNFisicoBlock := Tstringlist.Create;
            try
               slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
               sNombreFisico := slNFisicoBlock[ 0 ];

               if atDiagramAnalisisImpacto.Zoom <> 100 then
                  if mnuZoom.ItemIndex = 3 then
                     mnuZoomChange( Sender )
                  else
                     mnuZoom.ItemIndex := 3;

               atDiagramAnalisisImpacto.UnselectAll;
               dcControl := atDiagramAnalisisImpacto.FindDControl( sNombreFisico );
               dcControl.Selected := True;

               atDiagramAnalisisImpacto.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
               atDiagramAnalisisImpacto.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
            finally
               slNFisicoBlock.Free;
            end;
         end;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure Tftsimpacto.mnuBuscarClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 2 ].Visible then
      mnuPrincipal.Bars[ 2 ].Visible := False
   else begin
      mnuPrincipal.Bars[ 2 ].Visible := True;
      mnuTextoBuscar.SetFocus( True );
   end;
end;

procedure Tftsimpacto.mnuBuscarSiguienteClick( Sender: TObject );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if slPriBuscar.Count = 0 then
      Exit;

   slNFisicoBlock := Tstringlist.Create;
   try
      if iPriAntSigBuscar < slPriBuscar.Count - 1 then
         inc( iPriAntSigBuscar );

      slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
      sNombreFisico := slNFisicoBlock[ 0 ];

      if atDiagramAnalisisImpacto.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagramAnalisisImpacto.UnselectAll;
      dcControl := atDiagramAnalisisImpacto.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagramAnalisisImpacto.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagramAnalisisImpacto.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;
end;

procedure Tftsimpacto.mnuBuscarAnteriorClick( Sender: TObject );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if slPriBuscar.Count = 0 then
      Exit;

   slNFisicoBlock := Tstringlist.Create;
   try
      if iPriAntSigBuscar > 0 then
         iPriAntSigBuscar := iPriAntSigBuscar - 1;

      slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
      sNombreFisico := slNFisicoBlock[ 0 ];

      if atDiagramAnalisisImpacto.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagramAnalisisImpacto.UnselectAll;
      dcControl := atDiagramAnalisisImpacto.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagramAnalisisImpacto.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagramAnalisisImpacto.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;
end;

procedure Tftsimpacto.FormKeyDown( Sender: TObject; var Key: Word;
   Shift: TShiftState );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if ( ssCtrl in Shift ) and ( Key = VK_HOME ) then begin
      Screen.Cursor := crSqlWait;
      try
         if atDiagramAnalisisImpacto.Zoom <> 100 then
            if mnuZoom.ItemIndex = 3 then
               mnuZoomChange( Sender )
            else
               mnuZoom.ItemIndex := 3;

         atDiagramAnalisisImpacto.UnselectAll;
         dcControl := atDiagramAnalisisImpacto.FindDControl( 'SUBTITULO' );
         dcControl.Selected := True;

         atDiagramAnalisisImpacto.HorzScrollBar.Position := 1;
         atDiagramAnalisisImpacto.VertScrollBar.Position := 1;

         iPriAntSigBuscar := -1;
      finally
         Screen.Cursor := crDefault;
      end;
   end;

   if ( ssCtrl in Shift ) and ( Key = VK_END ) then begin
      slNFisicoBlock := Tstringlist.Create;
      Screen.Cursor := crSqlWait;
      try
         slNFisicoBlock.CommaText := slPubAnalisisImpacto[ slPubAnalisisImpacto.count - 1 ];
         sNombreFisico := slNFisicoBlock[ 0 ];

         if atDiagramAnalisisImpacto.Zoom <> 100 then
            if mnuZoom.ItemIndex = 3 then
               mnuZoomChange( Sender )
            else
               mnuZoom.ItemIndex := 3;

         atDiagramAnalisisImpacto.UnselectAll;
         dcControl := atDiagramAnalisisImpacto.FindDControl( sNombreFisico );
         dcControl.Selected := True;

         atDiagramAnalisisImpacto.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
         atDiagramAnalisisImpacto.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;

         iPriAntSigBuscar := slPriBuscar.Count - 1;
      finally
         Screen.Cursor := crDefault;
         slNFisicoBlock.Free;
      end;
   end;
end;

procedure Tftsimpacto.atDiagramAnalisisImpactoSelectDControl(
   Sender: TObject; ADControl: TDiagramControl );
begin
   GlbNoSelecLink( atDiagramAnalisisImpacto, ADControl );
end;

procedure Tftsimpacto.mnuExportarWMFClick( Sender: TObject );

   function ObtenerMisDocumentos: String;
   var
      bLongBool: Bool;
      sPath: array[ 0..Max_Path ] of Char;
   begin
      bLongBool := ShGetSpecialFolderPath( 0, sPath, CSIDL_Personal, False );

      if not bLongBool then
         Result := 'C:'
      else
         Result := sPath;
   end;

var
   sNombreArchivo: String;
   sRutaMisDocumentos: String;

begin
   sNombreArchivo := Caption + '.wmf';
   sRutaMisDocumentos := ObtenerMisDocumentos;

   with SaveDialog do begin
      InitialDir := sRutaMisDocumentos; //g_tmpdir;
      DefaultExt := '.wmf';
      FileName := sNombreArchivo;
      Filter := 'Formato de imagen WMF(*.wmf)|*.wmf';

      if Execute then
         GlbExportaWMF( atDiagramAnalisisImpacto, FileName );
   end;
end;

procedure Tftsimpacto.atDiagramAnalisisImpactoMouseUp( Sender: TObject;
   Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
   i: Integer;
   sClassName: String;
   dcControl: TDiagramControl;
begin
   if atDiagramAnalisisImpacto.SelectedLinkCount <> 1 then
      Exit;

   dcControl := atDiagramAnalisisImpacto.Selecteds[ 0 ];
   sClassName := UpperCase( dcControl.ClassName );

   if sClassName = 'TDIAGRAMSIDELINE' then
      with ( dcControl as TDiagramSideLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then
            atDiagramAnalisisImpacto.Undo;

   if sClassName = 'TDIAGRAMLINE' then 
      with ( dcControl as TDiagramLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then
            atDiagramAnalisisImpacto.Undo;
end;

end.

