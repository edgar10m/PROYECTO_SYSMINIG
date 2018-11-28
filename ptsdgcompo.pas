unit ptsdgcompo;

interface                                                      

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, ExcelXP, OleServer,
   Buttons, ComCtrls, Menus, shellapi, ComObj, ImgList, dxBar, htmlhlp,
   cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBarExtItems, cxGridLevel, HTML_HELP,
   pbarra, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
   cxControls, cxGridCustomView, cxGrid, DgrCombo, DgrSelectors, atDiagram,
   ShlObj;

type
   Tftsdgcompo = class( TForm )
      mnuPrincipal: TdxBarManager;
      mnuExportarExcel: TdxBarButton;
      mnuAyuda: TdxBarButton;
      PageControl1: TPageControl;
      TabSheet1: TTabSheet;
      TabSheet2: TTabSheet;
      web1: TWebBrowser;
      atDiagramdgcompo: TatDiagram;
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
      mnuBuscarAnterior: TdxBarButton;
      mnuBuscarSiguiente: TdxBarButton;
      mnuBuscar: TdxBarButton;
    mnuExportar: TdxBarSubItem;
    mnuExportarWMF: TdxBarButton;
      procedure web1BeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      function ArmarOpciones( b1: Tstringlist ): Integer;
      //procedure Exporta1Click( Sender: TObject );
      procedure BitBtn1Click( Sender: TObject );
      procedure web1DocumentComplete( Sender: TObject; const pDisp: IDispatch;
         var URL: OleVariant );
      procedure Web1PreviewPrint( web1: TWebBrowser );
      procedure FormActivate( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure mnuConsultaClick( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure web1ProgressChange( Sender: TObject; Progress,
         ProgressMax: Integer );
      procedure FormCreate( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      procedure mnuAyudaClick( Sender: TObject );
      procedure mnuImprimirClick( Sender: TObject );
      procedure mnuVistaPreliminarClick( Sender: TObject );
      procedure mnuGuardarClick( Sender: TObject );
      procedure mnuPaginaConfClick( Sender: TObject );
      procedure mnuZoomChange( Sender: TObject );
      procedure atDiagramdgcompoDControlDblClick( Sender: TObject;
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
      procedure mnuExportarExcelClick( Sender: TObject );
      procedure mnuTextoBuscarExit( Sender: TObject );
      procedure mnuBuscarClick( Sender: TObject );
      procedure mnuBuscarAnteriorClick( Sender: TObject );
      procedure mnuBuscarSiguienteClick( Sender: TObject );
      procedure FormKeyDown( Sender: TObject; var Key: Word;
         Shift: TShiftState );
      procedure atDiagramdgcompoSelectDControl( Sender: TObject;
         ADControl: TDiagramControl );
    procedure mnuExportarWMFClick(Sender: TObject);
    procedure atDiagramdgcompoMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

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
      slPubdgcompo: TStringList;
      procedure arma( prog: string; bib: string; clase: string );
      procedure ArmaDiagramaVisio( prog: string; bib: string; clase: string ); //fercar diagram studio
   end;

var
   f_top: integer;
   f_left: integer;
   Wnombre: string;
   b_impresion: boolean;
   ftsdgcompo: Tftsdgcompo;
procedure PR_DGCOMPO( prog: string; bib: string; clase: string );

implementation
uses ptsdm, ptsvmlx, ptsvmlimp9, ptsgral, parbol, uDiagramaRutinas; //, ptsmining;
{$R *.dfm}

procedure PR_DGCOMPO( prog: string; bib: string; clase: string );
begin
   Application.CreateForm( Tftsdgcompo, ftsdgcompo );
   ftsdgcompo.arma( prog, bib, clase );
   ftsdgcompo.ArmaDiagramaVisio( prog, bib, clase );
   try
      ftsdgcompo.Showmodal;
   finally
      ftsdgcompo.Free;
   end;
end;

procedure Tftsdgcompo.arma( prog: string; bib: string; clase: string );
var
   nombre, nombre1: string;
begin
   Exit; //comentar exit si se reuiere funcionalidad anterior
   nombre := stringreplace( prog, '/', '.', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '*', 'x', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '#', 'g', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '?', 'i', [ rfreplaceall ] );
   nombre1 := trim( clase ) + '|' + trim( bib ) + '|' + trim( nombre );
   nombre := g_tmpdir + '\DiagramaProceso' + clase + bib + nombre + '.html';
   vml_impacto( clase, bib, prog, '', 'tsrela', nombre, nombre1 );
   bgral := clase + ' ' + bib + ' ' + prog;
   //memo1.Lines.LoadFromFile( nombre );
   web1.Navigate( nombre );
   wnombre := nombre;
   caption := titulo; //'Diagrama de proceso ' + clase + ' ' + bib + ' ' + prog;
   g_borrar.Add( nombre );
   deletefile( nombre );
end;

function Tftsdgcompo.ArmarOpciones( b1: Tstringlist ): Integer;
begin
   gral.EjecutaOpcionB( b1, 'Diagrama' );
end;

procedure Tftsdgcompo.web1BeforeNavigate2( Sender: TObject;
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
      Opciones := gral.ArmarMenuConceptualWeb( b1, 'diagrama_proceso' );
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

         gral.exporta( Sender );
         screen.Cursor := crdefault;
      end;
   end;
end;
{
procedure Tftsdgcompo.ExportaClick;
var
  ks: string;
begin
  //gral.exportaProc( sender );
  //gral.EjecutaOpcionB( bgral, 'Diagrama de proceso' );
end;
 }

procedure Tftsdgcompo.BitBtn1Click( Sender: TObject );
begin
   b_impresion := true;
   Web1.Navigate( Wnombre );
end;

procedure Tftsdgcompo.web1DocumentComplete( Sender: TObject;
   const pDisp: IDispatch; var URL: OleVariant );
begin
   if b_impresion then begin                                       
      Web1PreviewPrint( web1 );
      Web1.Navigate( Wnombre );
      b_impresion := false;
   end;

   gral.PubMuestraProgresBar( False );
end;

procedure Tftsdgcompo.Web1PreviewPrint( web1: TWebBrowser );
var
   vin, Vout: OleVariant;
begin
   web1.controlinterface.ExecWB( OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vin, Vout );
end;

procedure Tftsdgcompo.FormActivate( Sender: TObject );
var
   l_control: string;
begin
   l_control := stringreplace( caption, 'Diagrama de Proceso ', '', [ rfreplaceall ] );
   g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );
   //g_control := stringreplace( g_control,g_tmpdir + '\DiagramaProceso', '', [ rfreplaceall ] );
   iHelpContext := IDH_TOPIC_T02600;
end;

procedure Tftsdgcompo.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsdgcompo.mnuConsultaClick( Sender: TObject );
begin
   gral.exportaProc( Sender );
end;

procedure Tftsdgcompo.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );
   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );

   slPubdgCompo.Free;
   slPriBuscar.Free;
end;

procedure Tftsdgcompo.web1ProgressChange( Sender: TObject; Progress,
   ProgressMax: Integer );
begin
   gral.PubAvanzaProgresBar;
end;

procedure Tftsdgcompo.FormCreate( Sender: TObject );
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;
   mnuPrincipal.Bars[ 2 ].Visible := False;
   iPriAntSigBuscar := 0;
   slPriBuscar := Tstringlist.Create;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );
end;

procedure Tftsdgcompo.FormDeactivate( Sender: TObject );
begin
   gral.PopGral.Items.Clear;
end;

procedure Tftsdgcompo.mnuAyudaClick( Sender: TObject );
begin
   try
      PR_BARRA;
      //iHelpContext:=IDH_TOPIC_T02600;
      HtmlHelp( Application.Handle,
         PChar( Format( '%s::/T%5.5d.htm',
         //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
         [ Application.HelpFile, iHelpContext ] ) ), HH_DISPLAY_TOPIC, 0 );
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;
end;

procedure Tftsdgcompo.mnuImprimirClick( Sender: TObject );
begin
   atDiagramdgcompo.Print( True );
end;

procedure Tftsdgcompo.mnuVistaPreliminarClick( Sender: TObject );
begin
   atDiagramdgcompo.Preview;
end;

procedure Tftsdgcompo.mnuGuardarClick( Sender: TObject );
var
   nombre: string;
begin
   with SaveDialog do begin
      DefaultExt := '.dgr';
      Filter := 'Diagramas (*.dgr)|*.dgr';
   end;

   nombre := stringreplace( trim( caption ), 'Diagrama de Proceso ', '', [ rfReplaceAll ] );
   nombre := stringreplace( trim( nombre ), ' ', '_', [ rfReplaceAll ] );
   saveDialog.FileName := nombre;
   if SaveDialog.Execute then
      atDiagramdgcompo.SaveToFile( SaveDialog.FileName );
end;

procedure Tftsdgcompo.mnuPaginaConfClick( Sender: TObject );
begin
   atDiagramdgcompo.PageSetupDlg;
end;

procedure Tftsdgcompo.mnuZoomChange( Sender: TObject );
var
   sZoom: String;
begin
   if Trim( mnuZoom.Text ) = '' then
      Exit;

   sZoom := StringReplace( mnuZoom.Text, '%', '', [ ] );

   atDiagramdgcompo.Zoom := StrToInt( sZoom );
end;

procedure Tftsdgcompo.atDiagramdgcompoDControlDblClick(
   Sender: TObject; ADControl: TDiagramControl );
var
   i, y: Integer;
   sNombre: String;
   slNLogicoBlock: TStringList;
begin
   screen.Cursor := crsqlwait;
   slNLogicoBlock := Tstringlist.Create;
   try

      for i := 0 to slPubdgcompo.Count - 1 do begin
         if pos( ADControl.Name, slPubdgcompo[ i ] ) > 0 then begin
            slNLogicoBlock.CommaText := slPubdgcompo[ i ];

            Break;
         end;
      end;

      if slNLogicoBlock.Count > 0 then begin
         sNombre := slNLogicoBlock[ 1 ] + '|' + slNLogicoBlock[ 2 ] + '|' + slNLogicoBlock[ 3 ];

         bgral := sNombre;
         Opciones := gral.ArmarMenuConceptualWeb( bgral, 'diagrama_proceso' );

         y := ArmarOpciones( Opciones );
         gral.PopGral.Popup( g_X, g_Y );
      end;

   finally
      slNLogicoBlock.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsdgcompo.mnuBoldClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramdgcompo.SelectedCount( ) - 1 do begin
      dcControl := atDiagramdgcompo.Selecteds[ i ];

      if fsBold in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsBold ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsBold ];
   end;
end;

procedure Tftsdgcompo.mnuItalicClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramdgcompo.SelectedCount( ) - 1 do begin
      dcControl := atDiagramdgcompo.Selecteds[ i ];

      if fsItalic in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsItalic ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsItalic ];
   end;
end;

procedure Tftsdgcompo.mnuUnderlineClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramdgcompo.SelectedCount( ) - 1 do begin
      dcControl := atDiagramdgcompo.Selecteds[ i ];

      if fsUnderline in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsUnderline ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsUnderline ];
   end;
end;

procedure Tftsdgcompo.mnuStrikeOutClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagramdgcompo.SelectedCount( ) - 1 do begin
      dcControl := atDiagramdgcompo.Selecteds[ i ];

      if fsStrikeOut in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsStrikeOut ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsStrikeOut ];
   end;
end;

procedure Tftsdgcompo.mnuNodosAutomaticosClick( Sender: TObject );
begin
   if atDiagramdgcompo.AutomaticNodes = True then begin
      atDiagramdgcompo.AutomaticNodes := False;
      mnuNodosAutomaticos.ImageIndex := -1;
   end
   else begin
      atDiagramdgcompo.AutomaticNodes := True;
      mnuNodosAutomaticos.ImageIndex := 39;
   end;
end;

procedure Tftsdgcompo.mnuVerReglaIzquierdaClick( Sender: TObject );
begin
   if atDiagramdgcompo.LeftRuler.Visible = True then begin
      atDiagramdgcompo.LeftRuler.Visible := False;
      mnuVerReglaIzquierda.ImageIndex := -1;
   end
   else begin
      atDiagramdgcompo.LeftRuler.Visible := True;
      mnuVerReglaIzquierda.ImageIndex := 39;
   end;
end;

procedure Tftsdgcompo.mnuVerReglaSuperiorClick( Sender: TObject );
begin
   if atDiagramdgcompo.TopRuler.Visible = True then begin
      atDiagramdgcompo.TopRuler.Visible := False;
      mnuVerReglaSuperior.ImageIndex := -1;
   end
   else begin
      atDiagramdgcompo.TopRuler.Visible := True;
      mnuVerReglaSuperior.ImageIndex := 39;
   end;
end;

procedure Tftsdgcompo.mnuVerCuadriculaClick( Sender: TObject );
begin
   if atDiagramdgcompo.SnapGrid.Visible = True then begin
      atDiagramdgcompo.SnapGrid.Visible := False;
      mnuVerCuadricula.ImageIndex := -1;
   end
   else begin
      atDiagramdgcompo.SnapGrid.Visible := True;
      mnuVerCuadricula.ImageIndex := 39;
   end;
end;

procedure Tftsdgcompo.mnuDeshacerClick( Sender: TObject );
var
   sNextRedo: String;
begin
   atDiagramdgcompo.Undo;

   sNextRedo := atDiagramdgcompo.NextRedoAction;
   mnuRehacer.Enabled := sNextRedo <> '';
end;

procedure Tftsdgcompo.mnuRehacerClick( Sender: TObject );
var
   sNextUndo: String;
begin
   atDiagramdgcompo.Redo;

   sNextUndo := atDiagramdgcompo.NextUndoAction;
   mnuDeshacer.Enabled := sNextUndo <> '';
end;

procedure Tftsdgcompo.ArmaDiagramaVisio( prog: string; bib: string; clase: string ); //fercar diagram studio
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
      nombre := g_tmpdir + '\DiagramaProceso' + clase + bib + nombre;
      caption := Titulo;
      iNombre := 0;

      slPubdgcompo := Tstringlist.Create;

      dgr_proceso(
         clase, bib, prog, caption, 'tsrela',
         atDiagramdgcompo, tabComponente, slPubdgcompo, nombre );

      mnuVerReglaIzquierda.ImageIndex := 39;
      mnuVerReglaSuperior.ImageIndex := 39;
      mnuVerCuadricula.ImageIndex := 39;

      atDiagramdgcompo.MoveBlocks( 1, 0, True ); //reacomoda las lineas
      atDiagramdgcompo.ClearUndoStack;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftsdgcompo.mnuExportarExcelClick( Sender: TObject );
begin
   gral.exportaProc( sender )
end;

procedure Tftsdgcompo.mnuTextoBuscarExit( Sender: TObject );
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

         for i := 0 to slPubdgCompo.Count - 1 do begin
            if pos( UpperCase( mnuTextoBuscar.Text ), UpperCase( slPubdgCompo[ i ] ) ) > 0 then begin
               slPriBuscar.Add( slPubdgCompo[ i ] );
            end;
         end;

         if slPriBuscar.Count > 0 then begin
            //sPriTextoBuscar := mnuTextoBuscar.Text;
            slNFisicoBlock := Tstringlist.Create;
            try
               slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
               sNombreFisico := slNFisicoBlock[ 0 ];

               if atDiagramdgCompo.Zoom <> 100 then
                  if mnuZoom.ItemIndex = 3 then
                     mnuZoomChange( Sender )
                  else
                     mnuZoom.ItemIndex := 3;

               atDiagramdgCompo.UnselectAll;
               dcControl := atDiagramdgCompo.FindDControl( sNombreFisico );
               dcControl.Selected := True;

               atDiagramDgCompo.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
               atDiagramdgCompo.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
            finally
               slNFisicoBlock.Free;
            end;
         end;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure Tftsdgcompo.mnuBuscarClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 2 ].Visible then
      mnuPrincipal.Bars[ 2 ].Visible := False
   else begin
      mnuPrincipal.Bars[ 2 ].Visible := True;
      mnuTextoBuscar.SetFocus( True );
   end;
end;

procedure Tftsdgcompo.mnuBuscarAnteriorClick( Sender: TObject );
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

      if atDiagramdgCompo.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagramdgCompo.UnselectAll;
      dcControl := atDiagramdgCompo.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagramdgCompo.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagramdgCompo.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;
end;

procedure Tftsdgcompo.mnuBuscarSiguienteClick( Sender: TObject );
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

      if atDiagramdgCompo.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagramdgCompo.UnselectAll;
      dcControl := atDiagramdgCompo.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagramdgCompo.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagramdgCompo.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;
end;

procedure Tftsdgcompo.FormKeyDown( Sender: TObject; var Key: Word;
   Shift: TShiftState );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if ( ssCtrl in Shift ) and ( Key = VK_HOME ) then begin
      Screen.Cursor := crSqlWait;
      try
         if atDiagramdgCompo.Zoom <> 100 then
            if mnuZoom.ItemIndex = 3 then
               mnuZoomChange( Sender )
            else
               mnuZoom.ItemIndex := 3;

         atDiagramdgCompo.UnselectAll;
         dcControl := atDiagramdgCompo.FindDControl( 'SUBTITULO' );
         dcControl.Selected := True;

         atDiagramdgCompo.HorzScrollBar.Position := 1;
         atDiagramdgCompo.VertScrollBar.Position := 1;

         iPriAntSigBuscar := -1;
      finally
         Screen.Cursor := crDefault;
      end;
   end;

   if ( ssCtrl in Shift ) and ( Key = VK_END ) then begin
      slNFisicoBlock := Tstringlist.Create;
      Screen.Cursor := crSqlWait;
      try
         slNFisicoBlock.CommaText := slPubdgCompo[ slPubdgCompo.count - 1 ];
         sNombreFisico := slNFisicoBlock[ 0 ];

         if atDiagramdgCompo.Zoom <> 100 then
            if mnuZoom.ItemIndex = 3 then
               mnuZoomChange( Sender )
            else
               mnuZoom.ItemIndex := 3;

         atDiagramdgCompo.UnselectAll;
         dcControl := atDiagramdgCompo.FindDControl( sNombreFisico );
         dcControl.Selected := True;

         atDiagramdgCompo.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
         atDiagramdgCompo.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;

         iPriAntSigBuscar := slPriBuscar.Count - 1;
      finally
         Screen.Cursor := crDefault;
         slNFisicoBlock.Free;
      end;
   end;
end;

procedure Tftsdgcompo.atDiagramdgcompoSelectDControl( Sender: TObject;
   ADControl: TDiagramControl );
begin
   GlbNoSelecLink( atDiagramdgCompo, ADControl );
end;

procedure Tftsdgcompo.mnuExportarWMFClick(Sender: TObject);

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
         GlbExportaWMF( atDiagramdgCompo, FileName );
   end;
end;

procedure Tftsdgcompo.atDiagramdgcompoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i: Integer;
   sClassName: String;
   dcControl: TDiagramControl;
begin
   if atDiagramdgCompo.SelectedLinkCount <> 1 then
      Exit;

   dcControl := atDiagramdgCompo.Selecteds[ 0 ];
   sClassName := UpperCase( dcControl.ClassName );

   if sClassName = 'TDIAGRAMSIDELINE' then
      with ( dcControl as TDiagramSideLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then
            atDiagramdgCompo.Undo;

   if sClassName = 'TDIAGRAMLINE' then 
      with ( dcControl as TDiagramLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then
            atDiagramdgCompo.Undo;
end;

end.

