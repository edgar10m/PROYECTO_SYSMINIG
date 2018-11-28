unit ufmSVSDiagrama;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
   ExtCtrls, Menus, OleServer, ExcelXP, Buttons, dxBar, HTML_HELP, htmlhlp, ComCtrls, atDiagram,
   DgrCombo, DgrSelectors, dxBarExtItems, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
   cxDataStorage, cxEdit, cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
   cxGridLevel, cxClasses, cxControls, cxGridCustomView, cxGrid, DB, dxmdaset, ShlObj, uConstantes,
   DiagramActns;

type
   TfmSVSDiagrama = class( TForm )
      mnuPrincipal: TdxBarManager;
      mnuExportarExcel: TdxBarButton;
      mnuAyuda: TdxBarButton;
      PageControl1: TPageControl;
      TabSheet2: TTabSheet;
      atDiagrama: TatDiagram;
      mnuGuardar: TdxBarButton;
      mnuImprimir: TdxBarButton;
      mnuVistaPreliminar: TdxBarButton;
      mnuPaginaConf: TdxBarButton;
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
      DgrFontSizeSelector: TDgrFontSizeSelector;
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
      mnuBuscar: TdxBarButton;
      mnuBuscarAnterior: TdxBarButton;
      mnuBuscarSiguiente: TdxBarButton;
      mnuExportar: TdxBarSubItem;
      mnuExportarWMF: TdxBarButton;
      mnuBarraEdicion: TdxBarButton;
      mnuArchivo: TdxBarSubItem;
      mnuEdicion: TdxBarSubItem;
      mnuSeleccionarTodo: TdxBarButton;
      mnuBarraBusqueda: TdxBarButton;
      mnuSalir: TdxBarButton;
      mnuBarraAlineacion: TdxBarButton;
      mnuCopyImg: TdxBarButton;
      mnuAlinearBordesIzquierdo: TdxBarButton;
      mnuAlinearBordesDerechos: TdxBarButton;
      mnuAlinearCentrosHorizontales: TdxBarButton;
      mnuAlinearBordesSuperiores: TdxBarButton;
      mnuAlinearBordesInferiores: TdxBarButton;
      mnuAlinearCentrosVerticales: TdxBarButton;
      mnuHacerMismoAncho: TdxBarButton;
      mnuHacerMismaAltura: TdxBarButton;
      mnuHacerMismoTamano: TdxBarButton;
      mnuEspacioIgualHorizontal: TdxBarButton;
      mnuIncrementarEspacioHorizontal: TdxBarButton;
      mnuDisminuirEspacioHorizontal: TdxBarButton;
      mnuEspacioIgualVertical: TdxBarButton;
      mnuIncrementarEspacioVertical: TdxBarButton;
      mnuDisminuirEspacioVertical: TdxBarButton;
      mnuCopiarBusqueda: TdxBarButton;
      mnuTextoBuscar: TdxBarEdit;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDestroy( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      procedure mnuAyudaClick( Sender: TObject );
      procedure mnuImprimirClick( Sender: TObject );
      procedure mnuVistaPreliminarClick( Sender: TObject );
      procedure mnuGuardarClick( Sender: TObject );
      procedure mnuPaginaConfClick( Sender: TObject );
      procedure mnuZoomChange( Sender: TObject );
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
      procedure mnuBuscarClick( Sender: TObject );
      procedure mnuBuscarSiguienteClick( Sender: TObject );
      procedure mnuBuscarAnteriorClick( Sender: TObject );
      procedure FormKeyDown( Sender: TObject; var Key: Word;
         Shift: TShiftState );
      procedure atDiagramaSelectDControl( Sender: TObject;
         ADControl: TDiagramControl );
      procedure mnuExportarWMFClick( Sender: TObject );
      procedure mnuBarraEdicionClick( Sender: TObject );
      procedure mnuSeleccionarTodoClick( Sender: TObject );
      procedure mnuBarraBusquedaClick( Sender: TObject );
      procedure mnuSalirClick( Sender: TObject );
      procedure atDiagramaMouseUp( Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer );
      procedure mnuCopyImgClick( Sender: TObject );
      procedure mnuBarraAlineacionClick( Sender: TObject );
      procedure mnuAlinearBordesIzquierdoClick( Sender: TObject );
      procedure mnuAlinearBordesDerechosClick( Sender: TObject );
      procedure mnuAlinearCentrosHorizontalesClick( Sender: TObject );
      procedure mnuAlinearBordesSuperioresClick( Sender: TObject );
      procedure mnuAlinearBordesInferioresClick( Sender: TObject );
      procedure mnuAlinearCentrosVerticalesClick( Sender: TObject );
      procedure mnuHacerMismoAnchoClick( Sender: TObject );
      procedure mnuHacerMismaAlturaClick( Sender: TObject );
      procedure mnuHacerMismoTamanoClick( Sender: TObject );
      procedure mnuEspacioIgualHorizontalClick( Sender: TObject );
      procedure mnuIncrementarEspacioHorizontalClick( Sender: TObject );
      procedure mnuDisminuirEspacioHorizontalClick( Sender: TObject );
      procedure mnuEspacioIgualVerticalClick( Sender: TObject );
      procedure mnuIncrementarEspacioVerticalClick( Sender: TObject );
      procedure mnuDisminuirEspacioVerticalClick( Sender: TObject );
      procedure mnuCopiarBusquedaClick( Sender: TObject );
      procedure mnuTextoBuscarExit( Sender: TObject );
   private
      { Private declarations }
      slPriBuscar: TStringList;
      sPriTextoBuscar: String;
      iPriAntSigBuscar: Integer;
      PriDiagramAlign: TDiagramAlign;
      //iPriSourceLinkPointAnchorIndex: Integer;
      //iPriTargetLinkPointAnchorIndex: Integer;

      procedure PriMostrarBarraEdicion( bParMostrar: Boolean );
      procedure PriAlinear( ParAlineacion: TBlocksAlignment );
   public
      { Public declarations }
      slPubDiagrama: TStringList;
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas, ClipBrd;

{$R *.dfm}

procedure TfmSVSDiagrama.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure TfmSVSDiagrama.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );

   slPubDiagrama.Free;
   slPriBuscar.Free;
   PriDiagramAlign.Free;
end;

procedure TfmSVSDiagrama.FormCreate( Sender: TObject );
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );

   //Barra edicion
   PriMostrarBarraEdicion( False );
   //Barra Busqueda
   mnuPrincipal.Bars[ 2 ].Visible := False;
   //Barra Alineacion
   mnuPrincipal.Bars[ 3 ].Visible := False;

   slPubDiagrama := Tstringlist.Create;
   slPriBuscar := Tstringlist.Create;
   PriDiagramAlign := TDiagramAlign.Create( Self );
   PriDiagramAlign.Diagram := atDiagrama;

   iPriAntSigBuscar := 0;
   GlbNuevoDiagrama( atDiagrama );

   if atDiagrama.LeftRuler.Visible = True then
      mnuVerReglaIzquierda.ImageIndex := 39
   else
      mnuVerReglaIzquierda.ImageIndex := -1;

   if atDiagrama.TopRuler.Visible = True then
      mnuVerReglaSuperior.ImageIndex := 39
   else
      mnuVerReglaSuperior.ImageIndex := -1;

   if atDiagrama.SnapGrid.Visible = True then
      mnuVerCuadricula.ImageIndex := 39
   else
      mnuVerCuadricula.ImageIndex := -1;
end;

procedure TfmSVSDiagrama.FormDeactivate( Sender: TObject );
begin
   gral.PopGral.Items.Clear;
end;

procedure TfmSVSDiagrama.mnuAyudaClick( Sender: TObject );
begin
   try
      HtmlHelp( Application.Handle,
         PChar( Format( '%s::/T%5.5d.htm',
         [ Application.HelpFile, iHelpContext ] ) ), HH_DISPLAY_TOPIC, 0 );
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;
end;

procedure TfmSVSDiagrama.mnuImprimirClick( Sender: TObject );
begin
   atDiagrama.Print( True );
end;

procedure TfmSVSDiagrama.mnuVistaPreliminarClick( Sender: TObject );
begin
   atDiagrama.Preview;
end;

procedure TfmSVSDiagrama.mnuGuardarClick( Sender: TObject );
var
   sNombreArchivo: string;
begin
   sNombreArchivo := sGlbExportarDiagramaDialogo( exDiagrama, atDiagrama, Caption );

   if sNombreArchivo = '' then
      Exit;

   atDiagrama.SaveToFile( sNombreArchivo );
end;

procedure TfmSVSDiagrama.mnuPaginaConfClick( Sender: TObject );
begin
   atDiagrama.PageSetupDlg;
end;

procedure TfmSVSDiagrama.mnuZoomChange( Sender: TObject );
var
   sZoom: String;
begin
   if Trim( mnuZoom.Text ) = '' then
      Exit;

   sZoom := StringReplace( mnuZoom.Text, '%', '', [ ] );

   atDiagrama.Zoom := StrToInt( sZoom );
end;

procedure TfmSVSDiagrama.mnuBoldClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagrama.SelectedCount( ) - 1 do begin
      dcControl := atDiagrama.Selecteds[ i ];

      if fsBold in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsBold ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsBold ];
   end;
end;

procedure TfmSVSDiagrama.mnuItalicClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagrama.SelectedCount( ) - 1 do begin
      dcControl := atDiagrama.Selecteds[ i ];

      if fsItalic in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsItalic ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsItalic ];
   end;
end;

procedure TfmSVSDiagrama.mnuUnderlineClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagrama.SelectedCount( ) - 1 do begin
      dcControl := atDiagrama.Selecteds[ i ];

      if fsUnderline in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsUnderline ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsUnderline ];
   end;
end;

procedure TfmSVSDiagrama.mnuStrikeOutClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
begin
   for i := 0 to atDiagrama.SelectedCount( ) - 1 do begin
      dcControl := atDiagrama.Selecteds[ i ];

      if fsStrikeOut in dcControl.Font.Style then
         dcControl.Font.Style := dcControl.Font.Style - [ fsStrikeOut ]
      else
         dcControl.Font.Style := dcControl.Font.Style + [ fsStrikeOut ];
   end;
end;

procedure TfmSVSDiagrama.mnuNodosAutomaticosClick( Sender: TObject );
begin
   if atDiagrama.AutomaticNodes = True then begin
      atDiagrama.AutomaticNodes := False;
      mnuNodosAutomaticos.ImageIndex := -1;
   end
   else begin
      atDiagrama.AutomaticNodes := True;
      mnuNodosAutomaticos.ImageIndex := 39;
   end;
end;

procedure TfmSVSDiagrama.mnuVerReglaIzquierdaClick( Sender: TObject );
begin
   if atDiagrama.LeftRuler.Visible = True then begin
      atDiagrama.LeftRuler.Visible := False;
      mnuVerReglaIzquierda.ImageIndex := -1;
   end
   else begin
      atDiagrama.LeftRuler.Visible := True;
      mnuVerReglaIzquierda.ImageIndex := 39;
   end;
end;

procedure TfmSVSDiagrama.mnuVerReglaSuperiorClick( Sender: TObject );
begin
   if atDiagrama.TopRuler.Visible = True then begin
      atDiagrama.TopRuler.Visible := False;
      mnuVerReglaSuperior.ImageIndex := -1;
   end
   else begin
      atDiagrama.TopRuler.Visible := True;
      mnuVerReglaSuperior.ImageIndex := 39;
   end;
end;

procedure TfmSVSDiagrama.mnuVerCuadriculaClick( Sender: TObject );
begin
   if atDiagrama.SnapGrid.Visible = True then begin
      atDiagrama.SnapGrid.Visible := False;
      mnuVerCuadricula.ImageIndex := -1;
   end
   else begin
      atDiagrama.SnapGrid.Visible := True;
      mnuVerCuadricula.ImageIndex := 39;
   end;
end;

procedure TfmSVSDiagrama.mnuDeshacerClick( Sender: TObject );
var
   sNextRedo: String;
begin
   atDiagrama.Undo;

   sNextRedo := atDiagrama.NextRedoAction;
   mnuRehacer.Enabled := sNextRedo <> '';
end;

procedure TfmSVSDiagrama.mnuRehacerClick( Sender: TObject );
var
   sNextUndo: String;
begin
   atDiagrama.Redo;

   sNextUndo := atDiagrama.NextUndoAction;
   mnuDeshacer.Enabled := sNextUndo <> '';
end;

procedure TfmSVSDiagrama.mnuBuscarClick( Sender: TObject );
begin
   if not mnuPrincipal.Bars[ 2 ].Visible then begin
      mnuPrincipal.Bars[ 2 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 39;
   end;

   mnuTextoBuscar.SetFocus( True );
end;

procedure TfmSVSDiagrama.mnuBuscarSiguienteClick( Sender: TObject );
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

      if atDiagrama.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagrama.UnselectAll;
      dcControl := atDiagrama.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagrama.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagrama.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;
end;

procedure TfmSVSDiagrama.mnuBuscarAnteriorClick( Sender: TObject );
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

      if atDiagrama.Zoom <> 100 then
         if mnuZoom.ItemIndex = 3 then
            mnuZoomChange( Sender )
         else
            mnuZoom.ItemIndex := 3;

      atDiagrama.UnselectAll;
      dcControl := atDiagrama.FindDControl( sNombreFisico );
      dcControl.Selected := True;

      atDiagrama.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
      atDiagrama.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
   finally
      slNFisicoBlock.Free;
   end;
end;

procedure TfmSVSDiagrama.FormKeyDown( Sender: TObject; var Key: Word;
   Shift: TShiftState );
var
   sNombreFisico: String;
   slNFisicoBlock: TStringList;
   dcControl: TDiagramControl;
begin
   if ( ssCtrl in Shift ) and ( Key = VK_HOME ) then begin
      Screen.Cursor := crSqlWait;
      try
         if atDiagrama.Zoom <> 100 then
            if mnuZoom.ItemIndex = 3 then
               mnuZoomChange( Sender )
            else
               mnuZoom.ItemIndex := 3;

         atDiagrama.UnselectAll;
         dcControl := atDiagrama.FindDControl( 'SUBTITULO' );
         dcControl.Selected := True;

         atDiagrama.HorzScrollBar.Position := 1;
         atDiagrama.VertScrollBar.Position := 1;

         iPriAntSigBuscar := -1;
      finally
         Screen.Cursor := crDefault;
      end;
   end;

   if ( ssCtrl in Shift ) and ( Key = VK_END ) then begin
      slNFisicoBlock := Tstringlist.Create;
      Screen.Cursor := crSqlWait;
      try
         slNFisicoBlock.CommaText := slPubDiagrama[ slPubDiagrama.count - 1 ];
         sNombreFisico := slNFisicoBlock[ 0 ];

         if atDiagrama.Zoom <> 100 then
            if mnuZoom.ItemIndex = 3 then
               mnuZoomChange( Sender )
            else
               mnuZoom.ItemIndex := 3;

         atDiagrama.UnselectAll;
         dcControl := atDiagrama.FindDControl( sNombreFisico );
         dcControl.Selected := True;

         atDiagrama.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
         atDiagrama.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;

         iPriAntSigBuscar := slPriBuscar.Count - 1;
      finally
         Screen.Cursor := crDefault;
         slNFisicoBlock.Free;
      end;
   end;
end;

procedure TfmSVSDiagrama.atDiagramaSelectDControl(
   Sender: TObject; ADControl: TDiagramControl );
{var
   i: Integer;
   sClassName: String;}

begin
   GlbNoSelecLink( atDiagrama, ADControl );

   {if atDiagrama.SelectedLinkCount <> 1 then
      Exit;

   sClassName := UpperCase( ADControl.ClassName );

   if sClassName = 'TDIAGRAMSIDELINE' then
      with ( ADControl as TDiagramSideLine ) do begin
         iPriSourceLinkPointAnchorIndex := SourceLinkPoint.AnchorIndex;
         iPriTargetLinkPointAnchorIndex := TargetLinkPoint.AnchorIndex;
      end;

   if sClassName = 'TDIAGRAMLINE' then
      with ( ADControl as TDiagramLine ) do begin
         iPriSourceLinkPointAnchorIndex := SourceLinkPoint.AnchorIndex;
         iPriTargetLinkPointAnchorIndex := TargetLinkPoint.AnchorIndex;
      end;}
end;

procedure TfmSVSDiagrama.mnuExportarWMFClick( Sender: TObject );
var
   sNombreArchivo: string;
begin
   sNombreArchivo := sGlbExportarDiagramaDialogo( exImagen, atDiagrama, Caption );

   if sNombreArchivo = '' then
      Exit;

   GlbExportaWMF( atDiagrama, sNombreArchivo );
end;

procedure TfmSVSDiagrama.mnuBarraEdicionClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 1 ].Visible then
      PriMostrarBarraEdicion( False )
   else
      PriMostrarBarraEdicion( True );
end;

procedure TfmSVSDiagrama.PriMostrarBarraEdicion( bParMostrar: Boolean );
begin
   mnuPrincipal.Bars[ 1 ].Visible := bParMostrar;

   if bParMostrar then
      mnuBarraEdicion.ImageIndex := 39
   else
      mnuBarraEdicion.ImageIndex := -1;

   DgrColorSelector.Visible := bParMostrar;
   DgrGradientDirectionSelector.Visible := bParMostrar;
   DgrBrushStyleSelector.Visible := bParMostrar;
   DgrShadowSelector.Visible := bParMostrar;
   DgrPenStyleSelector.Visible := bParMostrar;
   DgrPenColorSelector.Visible := bParMostrar;
   DgrTransparencySelector.Visible := bParMostrar;
   DgrPenWidthSelector.Visible := bParMostrar;
   DgrTextColorSelector.Visible := bParMostrar;
   DgrFontSelector.Visible := bParMostrar;
   DgrFontSizeSelector.Visible := bParMostrar;
end;

procedure TfmSVSDiagrama.mnuSeleccionarTodoClick( Sender: TObject );
var
   i: Integer;
   iTotalLink: Integer;
begin
   atDiagrama.SelectAll;

   //Quita la seleccion de lineas
   iTotalLink := atDiagrama.LinkCount;

   if iTotalLink = 0 then
      Exit;

   for i := 0 to iTotalLink - 1 do
      atDiagrama.Links[ i ].Selected := False;
end;

procedure TfmSVSDiagrama.mnuBarraBusquedaClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 2 ].Visible then begin
      mnuPrincipal.Bars[ 2 ].Visible := False;
      mnuBarraBusqueda.ImageIndex := -1;
   end
   else begin
      mnuPrincipal.Bars[ 2 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 39;
      mnuTextoBuscar.SetFocus( True );
   end;
end;

procedure TfmSVSDiagrama.mnuSalirClick( Sender: TObject );
begin
   Close;
end;

procedure TfmSVSDiagrama.atDiagramaMouseUp( Sender: TObject;
   Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
   sClassName: String;
   dcControl: TDiagramControl;
begin
   if atDiagrama.SelectedLinkCount <> 1 then
      Exit;

   dcControl := atDiagrama.Selecteds[ 0 ];
   sClassName := UpperCase( dcControl.ClassName );

   if sClassName = 'TDIAGRAMSIDELINE' then
      with ( dcControl as TDiagramSideLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then begin
            atDiagrama.Undo;
            //SourceLinkPoint.AnchorIndex := iPriSourceLinkPointAnchorIndex;
            //TargetLinkPoint.AnchorIndex := iPriTargetLinkPointAnchorIndex;
         end;

   if sClassName = 'TDIAGRAMLINE' then
      with ( dcControl as TDiagramLine ) do
         if ( SourceLinkPoint.AnchorIndex < 0 ) or
            ( TargetLinkPoint.AnchorIndex < 0 ) then begin
            atDiagrama.Undo;
            //SourceLinkPoint.AnchorIndex := iPriSourceLinkPointAnchorIndex;
            //TargetLinkPoint.AnchorIndex := iPriTargetLinkPointAnchorIndex;
         end;
end;

procedure TfmSVSDiagrama.mnuCopyImgClick( Sender: TObject );
begin
   //atDiagrama.CopyBitmapToClipboard( esStandard );
   atDiagrama.CopyBitmapToClipboard;
end;

procedure TfmSVSDiagrama.mnuBarraAlineacionClick( Sender: TObject );
begin
   if mnuPrincipal.Bars[ 3 ].Visible then begin
      mnuPrincipal.Bars[ 3 ].Visible := False;
      mnuBarraAlineacion.ImageIndex := -1;
   end
   else begin
      mnuPrincipal.Bars[ 3 ].Visible := True;
      mnuBarraAlineacion.ImageIndex := 39;
   end;
end;

procedure TfmSVSDiagrama.PriAlinear( ParAlineacion: TBlocksAlignment );
begin
   with PriDiagramAlign do begin
      BlockAlignment := ParAlineacion;
      Execute;
   end;
end;

procedure TfmSVSDiagrama.mnuAlinearBordesIzquierdoClick( Sender: TObject );
begin
   PriAlinear( baLeft );
end;

procedure TfmSVSDiagrama.mnuAlinearBordesDerechosClick( Sender: TObject );
begin
   PriAlinear( baRight );
end;

procedure TfmSVSDiagrama.mnuAlinearCentrosHorizontalesClick(
   Sender: TObject );
begin
   PriAlinear( baHorzCenter );
end;

procedure TfmSVSDiagrama.mnuAlinearBordesSuperioresClick( Sender: TObject );
begin
   PriAlinear( baTop );
end;

procedure TfmSVSDiagrama.mnuAlinearBordesInferioresClick( Sender: TObject );
begin
   PriAlinear( baBottom );
end;

procedure TfmSVSDiagrama.mnuAlinearCentrosVerticalesClick( Sender: TObject );
begin
   PriAlinear( baVertCenter );
end;

procedure TfmSVSDiagrama.mnuHacerMismoAnchoClick( Sender: TObject );
begin
   PriAlinear( baSameWidth );
end;

procedure TfmSVSDiagrama.mnuHacerMismaAlturaClick( Sender: TObject );
begin
   PriAlinear( baSameHeight );
end;

procedure TfmSVSDiagrama.mnuHacerMismoTamanoClick( Sender: TObject );
begin
   PriAlinear( baSameSize );
end;

procedure TfmSVSDiagrama.mnuEspacioIgualHorizontalClick( Sender: TObject );
begin
   PriAlinear( baSameSpaceHorz );
end;

procedure TfmSVSDiagrama.mnuIncrementarEspacioHorizontalClick(
   Sender: TObject );
begin
   PriAlinear( baIncHorzSpace );
end;

procedure TfmSVSDiagrama.mnuDisminuirEspacioHorizontalClick(
   Sender: TObject );
begin
   PriAlinear( baDecHorzSpace );
end;

procedure TfmSVSDiagrama.mnuEspacioIgualVerticalClick( Sender: TObject );
begin
   PriAlinear( baSameSpaceVert );
end;

procedure TfmSVSDiagrama.mnuIncrementarEspacioVerticalClick(
   Sender: TObject );
begin
   PriAlinear( baIncrVertSpace );
end;

procedure TfmSVSDiagrama.mnuDisminuirEspacioVerticalClick( Sender: TObject );
begin
   PriAlinear( baDecVertSpace );
end;

procedure TfmSVSDiagrama.mnuCopiarBusquedaClick( Sender: TObject );
var
   i: Integer;
   dcControl: TDiagramControl;
   sCadena: String;
begin
   if atDiagrama.SelectedCount( ) < 1 then begin
      Application.MessageBox( 'Seleccione un Block.', 'Aviso', MB_OK );
      Exit;
   end;

   if atDiagrama.SelectedCount( ) > 1 then begin
      Application.MessageBox( 'Para esta acción NO debe seleccionar más de un Block.', 'Aviso', MB_OK );
      Exit;
   end;

   for i := 0 to atDiagrama.SelectedCount( ) - 1 do
      dcControl := atDiagrama.Selecteds[ i ];

   Clipboard.AsText := dcControl.TextCells.Items[ 0 ].Text;
   sCadena := Clipboard.AsText;

   mnuTextoBuscar.Text := Trim( sCadena );
end;

procedure TfmSVSDiagrama.mnuTextoBuscarExit( Sender: TObject );
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
      if UpperCase( sPriTextoBuscar ) <> UpperCase( mnuTextoBuscar.Text ) then begin
         sPriTextoBuscar := mnuTextoBuscar.Text;
         slPriBuscar.Clear;
         iPriAntSigBuscar := 0;

         for i := 0 to slPubDiagrama.Count - 1 do begin
            if pos( UpperCase( mnuTextoBuscar.Text ), UpperCase( slPubDiagrama[ i ] ) ) > 0 then begin
               slPriBuscar.Add( slPubDiagrama[ i ] );
            end;
         end;

         if slPriBuscar.Count > 0 then begin
            slNFisicoBlock := Tstringlist.Create;
            try
               slNFisicoBlock.CommaText := slPriBuscar[ iPriAntSigBuscar ];
               sNombreFisico := slNFisicoBlock[ 0 ];

               if atDiagrama.Zoom <> 100 then
                  if mnuZoom.ItemIndex = 3 then
                     mnuZoomChange( Sender )
                  else
                     mnuZoom.ItemIndex := 3;

               atDiagrama.UnselectAll;
               dcControl := atDiagrama.FindDControl( sNombreFisico );
               dcControl.Selected := True;

               atDiagrama.HorzScrollBar.Position := StrToInt( slNFisicoBlock[ 4 ] ) - 20;
               atDiagrama.VertScrollBar.Position := StrToInt( slNFisicoBlock[ 5 ] ) - 20;
            finally
               slNFisicoBlock.Free;
            end;
         end;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

end.

