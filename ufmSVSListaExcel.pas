unit ufmSVSListaExcel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, StrUtils, 
  cxDataStorage, cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, ADODB, cxGridTableView, ImgList, dxPSCore,
  dxPScxGridLnk, dxBarDBNav, dxBar, dxStatusBar, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView,
  cxGrid, cxPC, cxExportGrid4Link, ShellAPI, StdCtrls;

type
  TfmSVSListaExcel = class(TForm)
    cxPageControl1: TcxPageControl;
    tabLista: TcxTabSheet;
    stbLista: TdxStatusBar;
    mnuPrincipal: TdxBarManager;
    mnuLista: TdxBarSubItem;
    mnuGuardar: TdxBarButton;
    mnuImprimir: TdxBarButton;
    mnuVistaPreliminar: TdxBarButton;
    mnuPaginaConf: TdxBarButton;
    mnuSalir: TdxBarButton;
    mnuAyuda: TdxBarButton;
    mnuEdicion: TdxBarSubItem;
    mnuCopiaRenglon: TdxBarButton;
    mnuiMultiSelec: TdxBarButton;
    mnuSeleccionarTodo: TdxBarButton;
    mnuVer: TdxBarSubItem;
    mnuBarraBusqueda: TdxBarButton;
    mnuBarraNavegacion: TdxBarButton;
    mnuTextoBuscar: TdxBarEdit;
    mnuBuscar: TdxBarButton;
    mnuBuscarSiguiente: TdxBarButton;
    mnuBuscarAnterior: TdxBarButton;
    mnuExportar: TdxBarSubItem;
    dxBarDBNavFirst1: TdxBarDBNavButton;
    dxBarDBNavPrev1: TdxBarDBNavButton;
    dxBarDBNavNext1: TdxBarDBNavButton;
    dxBarDBNavLast1: TdxBarDBNavButton;
    mnuExportarExcel: TdxBarButton;
    mnuExportarTextoDelimitado: TdxBarButton;
    dxBarButton1: TdxBarButton;
    mnuTabular: TdxBarSubItem;
    mnuTVista: TdxBarSubItem;
    mnuTEstilo: TdxBarSubItem;
    MenuTAccion: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
    mnuColAncho: TdxBarButton;
    mnuExpand: TdxBarButton;
    mnuColapse: TdxBarButton;
    mnuLineas: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dtsDatos: TDataSource;
    dxBarDBNavigator1: TdxBarDBNavigator;
    dxComponentPrinter: TdxComponentPrinter;
    dxComponentPrinterLink1: TdxGridReportLink;
    ImageList1: TImageList;
    cxStyleRepository2: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    GridTableViewStyleSheetWindowsStandard: TcxGridTableViewStyleSheet;
    adoConnExcel: TADOConnection;
    tblExcel: TADOTable;
    grdDatos: TcxGrid;
    grdDatosDBTableView1: TcxGridDBTableView;
    grdDatosLevel1: TcxGridLevel;
   procedure FormCreate( Sender: TObject );
   procedure FormClose( Sender: TObject; var Action: TCloseAction );
   procedure FormDestroy( Sender: TObject );
   procedure mnuSalirClick( Sender: TObject );
   procedure mnuImprimirClick( Sender: TObject );
   procedure mnuVistaPreliminarClick( Sender: TObject );
   procedure mnuSeleccionarTodoClick( Sender: TObject );
   procedure mnuExportarExcelClick( Sender: TObject );
   procedure mnuTextoBuscarExit( Sender: TObject );
   procedure mnuBuscarAnteriorClick( Sender: TObject );
   procedure mnuBuscarSiguienteClick( Sender: TObject );
   procedure mnuiMultiSelecClick( Sender: TObject );
   procedure mnuCopiaRenglonClick( Sender: TObject );
   procedure mnuExportarTextoDelimitadoClick( Sender: TObject );
   procedure mnuBuscarClick( Sender: TObject );
   procedure mnuBarraBusquedaClick( Sender: TObject );
   procedure mnuBarraNavegacionClick( Sender: TObject );
   procedure mnuPaginaConfClick( Sender: TObject );
   procedure dxBarDBNavLast1Click( Sender: TObject );
   procedure dxBarDBNavFirst1Click( Sender: TObject );
   procedure dxBarDBNavNext1Click( Sender: TObject );
   procedure dxBarDBNavPrev1Click( Sender: TObject );
   procedure mnuTextoBuscarEnter( Sender: TObject );
   procedure mnuColAnchoClick( Sender: TObject );
   procedure mnuExpandClick( Sender: TObject );
   procedure mnuColapseClick( Sender: TObject );
   procedure mnuLineasClick( Sender: TObject );
   procedure dxBarButton2Click( Sender: TObject );
   procedure dxBarButton3Click( Sender: TObject );
   procedure FormShow(Sender: TObject);
  private
      sPriTextoBuscar: String;
      slPriBuscar: TStringList;
      iPriAntSigBuscar: Integer;
   public
      { Public declarations }
      slPubLista: TStringList;
      gridAbuscar:String;
  end;

var
  fmSVSListaExcel: TfmSVSListaExcel;

implementation

uses ptsdm, uListaRutinas, ptsgral, uConstantes,ptsmain;

{$R *.dfm}

{ TfmSVSListaExcel }

procedure TfmSVSListaExcel.dxBarButton2Click(Sender: TObject);
begin
   grdDatosDBTableView1.ApplyBestFit;
end;

procedure TfmSVSListaExcel.dxBarButton3Click(Sender: TObject);
begin
   grdDatosDBTableView1.OptionsView.CellAutoHeight := not grdDatosDBTableView1.OptionsView.CellAutoHeight;
end;

procedure TfmSVSListaExcel.dxBarDBNavFirst1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoFirst;
end;

procedure TfmSVSListaExcel.dxBarDBNavLast1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoLast;
end;

procedure TfmSVSListaExcel.dxBarDBNavNext1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoNext;
end;

procedure TfmSVSListaExcel.dxBarDBNavPrev1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoPrev;
end;

procedure TfmSVSListaExcel.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure TfmSVSListaExcel.FormCreate(Sender: TObject);
begin
   height := height + 1;

   GlbHabilitarOpcionesMenu( mnuPrincipal, False );

   mnuPrincipal.Style := gral.iPubEstiloActivo;
   gral.PubEstiloActivo( stbLista );

   {if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );}

   //Barra Busqueda
   mnuPrincipal.Bars[ 1 ].Visible := False;
   //Barra navegacion
   mnuPrincipal.Bars[ 2 ].Visible := True;
   mnuBarraNavegacion.ImageIndex := 6;

   slPubLista := TStringList.Create;
   slPriBuscar := Tstringlist.Create;
end;

procedure TfmSVSListaExcel.FormDestroy(Sender: TObject);
begin
   if FormStyle = fsMDIChild then begin
      dm.PubEliminarVentanaActiva( Caption );

      if gral.iPubVentanasActivas in [ 0, 1 ] then
         gral.PubExpandeMenuVentanas( False );
   end;

   slPubLista.Free;
   slPriBuscar.Free;
end;

procedure TfmSVSListaExcel.FormShow(Sender: TObject);
begin
   if FormStyle = fsMDIChild then
      if gral.iPubVentanasActivas > 0 then
         gral.PubExpandeMenuVentanas( True );
end;

procedure TfmSVSListaExcel.mnuBarraBusquedaClick(Sender: TObject);
begin
   if mnuPrincipal.Bars[ 1 ].Visible then begin
      mnuPrincipal.Bars[ 1 ].Visible := False;
      mnuBarraBusqueda.ImageIndex := -1;
   end
   else begin
      mnuPrincipal.Bars[ 1 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 6;
      mnuTextoBuscar.SetFocus( True );
   end;
end;

procedure TfmSVSListaExcel.mnuBarraNavegacionClick(Sender: TObject);
begin
   if mnuPrincipal.Bars[ 2 ].Visible then begin
      mnuPrincipal.Bars[ 2 ].Visible := False;
      mnuBarraNavegacion.ImageIndex := -1;
   end
   else begin
      mnuPrincipal.Bars[ 2 ].Visible := True;
      mnuBarraNavegacion.ImageIndex := 6;
   end;
end;

procedure TfmSVSListaExcel.mnuBuscarAnteriorClick(Sender: TObject);
var
   i, j: Integer;
   nRenglon, nColumna, nUltReng, UltColumn: Integer;
   sBusca, sTiene: String;
begin
   if trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      with grdDatosDBTableView1.DataController do
      begin
         nUltReng := FocusedRecordIndex;
         UltColumn := grdDatosDBTableView1.Controller.FocusedItemIndex;

         if nUltReng = -1 then         // alk para evitar que truene cuando no hay panel seleccionado
            exit;

         if grdDatosDBTableView1.Controller.FocusedColumn.Index = 0 then begin
            if nUltReng > 0 then
               FocusedRecordIndex := grdDatosDBTableView1.Controller.FocusedRecord.Index - 1;

            grdDatosDBTableView1.Controller.FocusedItemIndex := grdDatosDBTableView1.ColumnCount -1;
         end
         else
            grdDatosDBTableView1.Controller.FocusedItemIndex := grdDatosDBTableView1.Controller.FocusedItem.Index - 1;

         nRenglon := grdDatosDBTableView1.Controller.FocusedRecord.Index;
         nColumna := grdDatosDBTableView1.Controller.FocusedColumn.Index;

         for i := nRenglon downto 0 do
         begin
            for j := nColumna downto 0 do
            begin
               sBusca := UpperCase( trim( mnuTextoBuscar.Text ) );
               sTiene := UpperCase( trim( grdDatosDBTableView1.Columns[j].EditValue ) );

               if AnsiContainsText( sTiene, sBusca ) then begin
                  FocusedRecordIndex := i;
                  grdDatosDBTableView1.Controller.FocusedColumnIndex := j;
                  nUltReng := grdDatosDBTableView1.Controller.FocusedRecordIndex;
                  UltColumn := grdDatosDBTableView1.Controller.FocusedItemIndex;
                  Exit;
               end
            end;

            FocusedRecordIndex := i - 1;
            nColumna := grdDatosDBTableView1.ColumnCount -1;
            grdDatosDBTableView1.Controller.FocusedItemIndex := nColumna;
         end;

         ShowMessage(mnuTextoBuscar.Text + ' No se encontro');
         grdDatosDBTableView1.Controller.FocusedRecordIndex := nUltReng;
         grdDatosDBTableView1.Controller.FocusedItemIndex := UltColumn;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmSVSListaExcel.mnuBuscarClick(Sender: TObject);
begin
   if not mnuPrincipal.Bars[ 1 ].Visible then begin
      mnuPrincipal.Bars[ 1 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 6;
   end;

   mnuTextoBuscar.SetFocus( True );
end;

procedure TfmSVSListaExcel.mnuBuscarSiguienteClick(Sender: TObject);
var
   i, j: Integer;
   nRenglon, nColumna, nUltReng, UltColumn: Integer;
   sBusca, sTiene: String;
begin
   if trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      with grdDatosDBTableView1.DataController do
      begin
            nUltReng := FocusedRecordIndex;
            UltColumn := grdDatosDBTableView1.Controller.FocusedItemIndex;

         if grdDatosDBTableView1.Controller.FocusedItemIndex = grdDatosDBTableView1.ColumnCount-1 then begin
            grdDatosDBTableView1.Controller.FocusedRecordIndex := grdDatosDBTableView1.Controller.FocusedRecord.Index + 1;
            grdDatosDBTableView1.Controller.FocusedItemIndex := 0;
         end
         else
            grdDatosDBTableView1.Controller.FocusedItemIndex := grdDatosDBTableView1.Controller.FocusedItem.Index + 1;

         nRenglon := grdDatosDBTableView1.Controller.FocusedRecord.Index;
         nColumna := grdDatosDBTableView1.Controller.FocusedColumn.Index;

         for i := nRenglon to RecordCount -1 do
         begin
            for j := nColumna to grdDatosDBTableView1.ColumnCount -1 do
            begin
               sBusca := UpperCase( trim( mnuTextoBuscar.Text ) );
               sTiene := UpperCase( trim( grdDatosDBTableView1.Columns[j].EditValue ) );

               if AnsiContainsText( sTiene, sBusca ) then begin
                  grdDatosDBTableView1.Controller.FocusedRecordIndex := i;
                  grdDatosDBTableView1.Controller.FocusedColumnIndex := j;
                  nUltReng := grdDatosDBTableView1.Controller.FocusedRecordIndex;
                  UltColumn := grdDatosDBTableView1.Controller.FocusedItemIndex;
                  Exit;
               end
            end;

            grdDatosDBTableView1.Controller.FocusedRecordIndex := i + 1;
            nColumna := 0;
            grdDatosDBTableView1.Controller.FocusedItemIndex := 0;
         end;

         ShowMessage(mnuTextoBuscar.Text + ' No se encontro');
         grdDatosDBTableView1.Controller.FocusedRecordIndex := nUltReng;
         grdDatosDBTableView1.Controller.FocusedItemIndex := UltColumn;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmSVSListaExcel.mnuColAnchoClick(Sender: TObject);
begin
   grdDatosDBTableView1.OptionsView.ColumnAutoWidth := not grdDatosDBTableView1.OptionsView.ColumnAutoWidth;
end;

procedure TfmSVSListaExcel.mnuColapseClick(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.Groups.FullCollapse;
end;

procedure TfmSVSListaExcel.mnuCopiaRenglonClick(Sender: TObject);
begin
   grdDatosDBTableView1.CopyToClipboard( False );
end;

procedure TfmSVSListaExcel.mnuExpandClick(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.Groups.FullExpand;
end;

procedure TfmSVSListaExcel.mnuExportarExcelClick(Sender: TObject);
var
   sNombreArchivo, sCaption: string;
begin
   sCaption := Caption;

   bGlbQuitaCaracteres( sCaption );

   //agregar al nombre del archivo la fecha y la hora para diferenciarlo
   sCaption:=sCaption + ' ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now());

   sNombreArchivo := sGlbExportarListaDialogo( exExcel, grdDatos, sCaption );

   if sNombreArchivo = '' then
      Exit;

   //ExportGrid4ToExcel( sNombreArchivo, grdDatos, True, True, True, 'xls' );
   try
      ExportGrid4ToExcel( sNombreArchivo, grdDatos, True, True, True, 'xls' );
   except
      on E: exception do begin
         Application.MessageBox( pchar( 'El contenido que desea exportar excede ' + chr( 13 ) +
                    'los limites para el formato XLS.' + chr( 13 ) + chr( 13 ) +
                    'Se va a exportar a formato CSV'),
                    'AVISO', MB_ICONQUESTION);
         sNombreArchivo:= stringreplace( sNombreArchivo, '.xls', '.csv', [ rfReplaceAll ]);
         ExportGrid4ToText(stringreplace( sNombreArchivo, '.csv', '.txt', [ rfReplaceAll ]) , grdDatos, True, True, ',', '"', '"' );

         if not RenameFile(stringreplace( sNombreArchivo, '.csv', '.txt', [ rfReplaceAll ]),sNombreArchivo) then  // se puecambiar la extension
            if not FileExists( sNombreArchivo ) then  //si no se pudo renombrar y no existe el archivo csv, manda mensaje de error
               Application.MessageBox( pchar( dm.xlng( 'Fallo al generar archivo csv ' + sNombreArchivo ) ),
                     pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
      end;
   end;

   if ShellExecute( Handle, nil, pchar( sNombreArchivo ), nil, nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar ' + sNombreArchivo ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
end;

procedure TfmSVSListaExcel.mnuExportarTextoDelimitadoClick(Sender: TObject);
var
   sNombreArchivo, sCaption: string;
begin
   sCaption := Caption;

   bGlbQuitaCaracteres( sCaption );
   sNombreArchivo := sGlbExportarListaDialogo( exTexto, grdDatos, sCaption );

   if sNombreArchivo = '' then
      Exit;

   ExportGrid4ToText( sNombreArchivo, grdDatos, True, True, ',', '"', '"' );

   if ShellExecute( Handle, nil, pchar( sNombreArchivo ), nil, nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar ' + sNombreArchivo ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
end;

procedure TfmSVSListaExcel.mnuImprimirClick(Sender: TObject);
begin
   try
      grdDatosLevel1.Caption := Caption;
      dxComponentPrinterLink1.Component := grdDatos;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( Caption );
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( g_usuario );
      dxComponentPrinterLink1.Print( True, nil );
   finally
      grdDatosLevel1.Caption := '';
   end;
end;

procedure TfmSVSListaExcel.mnuiMultiSelecClick(Sender: TObject);
begin
   if grdDatosDBTableView1.OptionsSelection.MultiSelect = True then begin
      grdDatosDBTableView1.OptionsSelection.MultiSelect := False;
      mnuiMultiSelec.ImageIndex := -1;
   end
   else begin
      grdDatosDBTableView1.OptionsSelection.MultiSelect := True;
      mnuiMultiSelec.ImageIndex := 6;
   end;
end;

procedure TfmSVSListaExcel.mnuLineasClick(Sender: TObject);
begin
   if grdDatosDBTableView1.OptionsView.GridLines = glNone then
      grdDatosDBTableView1.OptionsView.GridLines := glBoth
   else
      grdDatosDBTableView1.OptionsView.GridLines := glNone;
end;

procedure TfmSVSListaExcel.mnuPaginaConfClick(Sender: TObject);
begin
   dxComponentPrinterLink1.PageSetup;
end;

procedure TfmSVSListaExcel.mnuSalirClick(Sender: TObject);
begin
   Close;
end;

procedure TfmSVSListaExcel.mnuSeleccionarTodoClick(Sender: TObject);
begin
   if not grdDatosDBTableView1.OptionsSelection.MultiSelect then begin
      Application.MessageBox(
         'Para esta acción primero active la opción de "Selección Multiple".',
         'Aviso', MB_OK );
      Exit;
   end;

   grdDatosDBTableView1.DataController.SelectAll;
end;

procedure TfmSVSListaExcel.mnuTextoBuscarEnter(Sender: TObject);
begin
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
end;

procedure TfmSVSListaExcel.mnuTextoBuscarExit(Sender: TObject);
var
   i, j: Integer;
   sBusca, sTiene: String;
begin
   if trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   if grdDatosDBTableView1.DataController.RecordCount = 0 then begin
      //ShowMessage(' Sin registros ');
      mnuBuscarAnterior.Enabled := False;
      mnuBuscarSiguiente.Enabled := False;
      exit;
   end;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      with grdDatosDBTableView1.DataController do
      begin
         DataModeController.SyncMode := true;
         GotoFirst;

         for i := 0 to RecordCount -1 do
         begin
            for j := 0 to grdDatosDBTableView1.ColumnCount -1 do
            begin
               sBusca := UpperCase( trim( mnuTextoBuscar.Text ) );
               sTiene := UpperCase( trim( grdDatosDBTableView1.Columns[j].EditValue ) );

               if AnsiContainsText( sTiene, sBusca ) then begin
                  FocusedRecordIndex := i;
                  grdDatosDBTableView1.Controller.FocusedColumnIndex := j;
                  Exit;
               end
            end;

            GotoNext;
            grdDatosDBTableView1.Controller.FocusedItemIndex := 0;
         end;

         //ShowMessage(mnuTextoBuscar.Text + ' No se encontrado');
      end;

   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
      mnuBuscarAnterior.Enabled := True;
      mnuBuscarSiguiente.Enabled := True;
   end;
end;

procedure TfmSVSListaExcel.mnuVistaPreliminarClick(Sender: TObject);
begin
   try
      grdDatosLevel1.Caption := Caption;
      dxComponentPrinterLink1.Component := grdDatos;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( Caption );
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( g_usuario );
      dxComponentPrinterLink1.Preview( True );
   finally
      grdDatosLevel1.Caption := '';
   end;
end;

end.
