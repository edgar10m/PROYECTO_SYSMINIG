unit ufmSVSLista;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Buttons, StdCtrls,
   ExtCtrls, ComCtrls, dxBar, cxPC, cxControls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
   cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxGrid, dxmdaset, dxBarDBNav, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg,
   dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSCore,
   dxPScxGridLnk, cxExportGrid4Link, StrUtils, uConstantes, uListaRutinas, ImgList, cxGridCustomPopupMenu,
   cxGridPopupMenu, Menus, cxContainer, cxImage, ShellAPI;

type
   TfmSVSLista = class( TForm )
      mnuPrincipal: TdxBarManager;
      mnuLista: TdxBarSubItem;
      mnuGuardar: TdxBarButton;
      mnuImprimir: TdxBarButton;
      mnuVistaPreliminar: TdxBarButton;
      mnuPaginaConf: TdxBarButton;
      mnuEdicion: TdxBarSubItem;
      mnuVer: TdxBarSubItem;
      mnuBuscar: TdxBarButton;
      mnuBuscarAnterior: TdxBarButton;
      mnuBuscarSiguiente: TdxBarButton;
      mnuExportar: TdxBarSubItem;
      mnuExportarExcel: TdxBarButton;
      mnuAyuda: TdxBarButton;
      mnuSeleccionarTodo: TdxBarButton;
      mnuBarraBusqueda: TdxBarButton;
      mnuSalir: TdxBarButton;
      mnuTextoBuscar: TdxBarEdit;
      cxPageControl1: TcxPageControl;
      tabLista: TcxTabSheet;
      grdDatosDBTableView1: TcxGridDBTableView;
      grdDatosLevel1: TcxGridLevel;
      dtsDatos: TDataSource;
      grdDatos: TcxGrid;
      tabDatos: TdxMemData;
      dxBarDBNavigator1: TdxBarDBNavigator;
      dxBarDBNavFirst1: TdxBarDBNavButton;
      dxBarDBNavPrev1: TdxBarDBNavButton;
      dxBarDBNavNext1: TdxBarDBNavButton;
      dxBarDBNavLast1: TdxBarDBNavButton;
      dxComponentPrinter: TdxComponentPrinter;
      mnuCopiaRenglon: TdxBarButton;
      mnuiMultiSelec: TdxBarButton;
      mnuExportarTextoDelimitado: TdxBarButton;
      mnuBarraNavegacion: TdxBarButton;
      dxComponentPrinterLink1: TdxGridReportLink;
      ImageList1: TImageList;
    dxBarButton1: TdxBarButton;
    mnuTabular: TdxBarSubItem;
    mnuTVista: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
    mnuTEstilo: TdxBarSubItem;
    MenuTAccion: TdxBarSubItem;
    mnuColAncho: TdxBarButton;
    mnuExpand: TdxBarButton;
    mnuColapse: TdxBarButton;
    mnuLineas: TdxBarButton;
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
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
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
//------------------------------ framirez -----------------------------------------
    procedure grdDatosDBTableView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdDatosDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure dxBarDBNavLast1Click(Sender: TObject);
    procedure dxBarDBNavFirst1Click(Sender: TObject);
    procedure dxBarDBNavNext1Click(Sender: TObject);
    procedure dxBarDBNavPrev1Click(Sender: TObject);
    procedure mnuTextoBuscarEnter(Sender: TObject);
    procedure mnuColAnchoClick(Sender: TObject);
    procedure mnuExpandClick(Sender: TObject);
    procedure mnuColapseClick(Sender: TObject);
    procedure mnuLineasClick(Sender: TObject);
    procedure dxBarButton2Click(Sender: TObject);
    procedure dxBarButton3Click(Sender: TObject);
//--------------------------------------------------------------------------------
   private
      { Private declarations }
      iPriItemLoc, iPriRegLoc: Integer;
      sPriTextoBuscar: String;
   public
      { Public declarations }
   end;

implementation
uses
   ptsdm, ptsgral, ptsmain;
{$R *.dfm}

procedure TfmSVSLista.FormCreate( Sender: TObject );
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );

   //Barra Busqueda
   mnuPrincipal.Bars[ 1 ].Visible := False;
   //Barra navegacion
   mnuPrincipal.Bars[ 2 ].Visible := True;
   mnuBarraNavegacion.ImageIndex := 6;
end;

procedure TfmSVSLista.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure TfmSVSLista.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );
end;

procedure TfmSVSLista.mnuSalirClick( Sender: TObject );
begin
   Close;
end;

procedure TfmSVSLista.mnuImprimirClick( Sender: TObject );
begin
   try
      grdDatosLevel1.Caption := Caption;
//---------------------- framirez ------------------------------------
      dxComponentPrinterLink1.Component := grdDatos;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( Caption );
//      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( lblEmpresa.Caption );
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( ftsmain.txtUsuario.Text );
//---------------------------------------------------------------------
      dxComponentPrinterLink1.Print( True, nil );
   finally
      grdDatosLevel1.Caption := '';
   end;
end;

procedure TfmSVSLista.mnuVistaPreliminarClick( Sender: TObject );
begin
   try
      grdDatosLevel1.Caption := Caption;
//---------------------- framirez ------------------------------------
      dxComponentPrinterLink1.Component := grdDatos;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( Caption );
//      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( lblEmpresa.Caption );
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( ftsmain.txtUsuario.Text );
//---------------------------------------------------------------------
      dxComponentPrinterLink1.Preview( True );
   finally
      grdDatosLevel1.Caption := '';
   end;
end;

procedure TfmSVSLista.mnuSeleccionarTodoClick( Sender: TObject );
begin
   if not grdDatosDBTableView1.OptionsSelection.MultiSelect then begin
      Application.MessageBox(
         'Para esta acción primero active la opción de "Selección Multiple".',
         'Aviso', MB_OK );
      Exit;
   end;

   grdDatosDBTableView1.DataController.SelectAll;
end;

procedure TfmSVSLista.mnuExportarExcelClick( Sender: TObject );
var
   sNombreArchivo: string;
begin
   sNombreArchivo := sGlbExportarListaDialogo( exExcel, grdDatos, Caption );

   if sNombreArchivo = '' then
      Exit;

   ExportGrid4ToExcel( sNombreArchivo, grdDatos, True, True, True, 'xls' );

   if ShellExecute(Handle, nil,pchar(sNombreArchivo),nil, nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar '+sNombreArchivo)),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
end;

procedure TfmSVSLista.mnuTextoBuscarExit( Sender: TObject );
var
   i, j: Integer;
begin
   if Trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   Screen.Cursor := crSqlWait;
   try
      if UpperCase( sPriTextoBuscar ) <> UpperCase( mnuTextoBuscar.Text ) then begin
         sPriTextoBuscar := mnuTextoBuscar.Text;

         with grdDatosDBTableView1.Controller do begin
            //registra columna y renglon donde esta colocado
            iPriRegLoc := FocusedRecordIndex;
            iPriItemLoc := FocusedItemIndex;

            //se coloca en la primer columna y primer registro
            FocusedRecordIndex := 0;
            FocusedItemIndex := 0;

            //realiza la busqueda
            for i := 0 to ( grdDatosDBTableView1.DataController.RecordCount - 1 ) do begin
               FocusedRecordIndex := i;

               for j := 0 to ( grdDatosDBTableView1.ColumnCount - 1 ) do begin
                  FocusedColumnIndex := j;

                  if AnsiContainsText( FocusedColumn.EditValue, mnuTextoBuscar.Text ) then begin
                     iPriRegLoc := i;
                     iPriItemLoc := j;
                     FocusedRecordIndex := iPriRegLoc;
                     FocusedColumnIndex := iPriItemLoc;

                     Exit;
                  end;
               end;
            end;

            // si no existen concidencias se queda en el registro donde estaba colocado
            FocusedRecordIndex := iPriRegLoc;
            FocusedColumnIndex := iPriItemLoc;
         end;
      end;
   finally
      mnuBuscarAnterior.Visible := ivAlways;
      mnuBuscarSiguiente.Visible := ivAlways;;
      grdDatosDBTableView1.Focused := True;
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmSVSLista.mnuBuscarAnteriorClick( Sender: TObject );
var
   i, j, nRowIni, nColIni: Integer;
begin
   Screen.Cursor := crSqlWait;
   try
      if sPriTextoBuscar = '' then
         Exit;

      with grdDatosDBTableView1.Controller do begin
         if AnsiContainsText( FocusedColumn.EditValue, sPriTextoBuscar ) then
            FocusedItemIndex := FocusedItemIndex - 1;

         nRowIni := FocusedRow.Index;
         nColIni := FocusedItemIndex;

         if nColIni < 0 then begin
            nRowIni := nRowIni - 1;
            nColIni := grdDatosDBTableView1.ColumnCount - 2;
            FocusedItemIndex := nColIni;
         end;

         if nRowIni < 0 then
            nRowIni := 0;

         for i := nRowIni downto 0 do begin
            FocusedRecordIndex := i;

            for j := nColIni downto 0 do begin
               FocusedItemIndex := j;
               if AnsiContainsText( FocusedColumn.EditValue, sPriTextoBuscar ) then begin
                  iPriRegLoc := i;
                  iPriItemLoc := j;
                  FocusedRecordIndex := iPriRegLoc;
                  FocusedItemIndex := iPriItemLoc;
                  grdDatosDBTableView1.Focused := true;
                  Exit;
               end;
            end;

            FocusedItemIndex := grdDatosDBTableView1.ColumnCount - 1;
            nColIni := grdDatosDBTableView1.ColumnCount - 1;
         end;
      end;

      grdDatosDBTableView1.Controller.FocusedRecordIndex := iPriRegLoc;
      grdDatosDBTableView1.Controller.FocusedItemIndex := iPriItemLoc;
   finally
      grdDatosDBTableView1.Focused := true;
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmSVSLista.mnuBuscarSiguienteClick( Sender: TObject );
var
   i, j, nRowIni, nColIni: Integer;
begin
   Screen.Cursor := crSqlWait;
   try
      if sPriTextoBuscar = '' then
         Exit;

      with grdDatosDBTableView1.Controller do begin
         if AnsiContainsText( FocusedColumn.EditValue, sPriTextoBuscar ) then
            FocusedItemIndex := FocusedItemIndex + 1;

         nRowIni := FocusedRow.Index;
         nColIni := FocusedItemIndex;

         for i := nRowIni to ( grdDatosDBTableView1.DataController.RecordCount - 1 ) do begin
            FocusedRecordIndex := i;

            for j := nColIni to ( grdDatosDBTableView1.ColumnCount - 1 ) do begin
               FocusedItemIndex := j;

               if AnsiContainsText( FocusedColumn.EditValue, sPriTextoBuscar ) then begin
                  iPriRegLoc := i;
                  iPriItemLoc := j;
                  FocusedRecordIndex := iPriRegLoc;
                  FocusedItemIndex := iPriItemLoc;
                  grdDatosDBTableView1.Focused := True;
                  Exit;
               end;
            end;

            nColIni := 0;
         end;
      end;

      grdDatosDBTableView1.Controller.FocusedRecordIndex := iPriRegLoc;
      grdDatosDBTableView1.Controller.FocusedItemIndex := iPriItemLoc;
   finally
      grdDatosDBTableView1.Focused := True;
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmSVSLista.mnuiMultiSelecClick( Sender: TObject );
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

procedure TfmSVSLista.mnuCopiaRenglonClick( Sender: TObject );
begin
   grdDatosDBTableView1.CopyToClipboard( False );
end;

procedure TfmSVSLista.mnuExportarTextoDelimitadoClick( Sender: TObject );
var
   sNombreArchivo: string;
begin
   sNombreArchivo := sGlbExportarListaDialogo( exTexto, grdDatos, Caption );

   if sNombreArchivo = '' then
      Exit;

   ExportGrid4ToText( Caption, grdDatos, True, True, ',', '"', '"' );
end;

procedure TfmSVSLista.mnuBuscarClick( Sender: TObject );
begin
//   if not mnuPrincipal.Bars[ 1 ].Visible then begin
//      mnuPrincipal.Bars[ 1 ].Visible := True;
//      mnuBarraBusqueda.ImageIndex := 6;
//   end;

//   mnuTextoBuscar.SetFocus( True );
end;

procedure TfmSVSLista.mnuBarraBusquedaClick( Sender: TObject );
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

procedure TfmSVSLista.mnuBarraNavegacionClick( Sender: TObject );
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

procedure TfmSVSLista.mnuPaginaConfClick( Sender: TObject );
begin
   dxComponentPrinterLink1.PageSetup;
end;

procedure TfmSVSLista.dxBarDBNavFirst1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoFirst;
end;

procedure TfmSVSLista.dxBarDBNavLast1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoLast;
end;

procedure TfmSVSLista.dxBarDBNavNext1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoNext;
end;

procedure TfmSVSLista.dxBarDBNavPrev1Click(Sender: TObject);
begin
   grdDatosDBTableView1.DataController.GotoPrev;
end;

procedure TfmSVSLista.grdDatosDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
    AFocusedRecord.Selected := True;
end;

procedure TfmSVSLista.grdDatosDBTableView1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Shift = [ssCtrl]) and ((Key = VK_HOME) or (Key = VK_END)) then
      TcxGridTableView(TcxGridSite(Sender).GridView).Controller.FocusedRow.Selected := False;
end;

procedure TfmSVSLista.mnuTextoBuscarEnter(Sender: TObject);
begin
   sPriTextoBuscar := '';
   mnuTextoBuscar.Text := '';
   mnuBuscarAnterior.Visible := ivNever;
   mnuBuscarSiguiente.Visible := ivNever;;
end;

procedure TfmSVSLista.mnuColAnchoClick(Sender: TObject);
begin
   grdDatosDBTableView1.OptionsView.ColumnAutoWidth := not grdDatosDBTableView1.OptionsView.ColumnAutoWidth;
end;

procedure TfmSVSLista.mnuExpandClick(Sender: TObject);
begin
  grdDatosDBTableView1.DataController.Groups.FullExpand;
end;

procedure TfmSVSLista.mnuColapseClick(Sender: TObject);
begin
  grdDatosDBTableView1.DataController.Groups.FullCollapse;
end;

procedure TfmSVSLista.mnuLineasClick(Sender: TObject);
begin
  if grdDatosDBTableView1.OptionsView.GridLines = glNone then
    grdDatosDBTableView1.OptionsView.GridLines := glBoth
  else grdDatosDBTableView1.OptionsView.GridLines := glNone;
end;

procedure TfmSVSLista.dxBarButton2Click(Sender: TObject);
begin
   grdDatosDBTableView1.ApplyBestFit;
end;

procedure TfmSVSLista.dxBarButton3Click(Sender: TObject);
begin
   grdDatosDBTableView1.OptionsView.CellAutoHeight := not grdDatosDBTableView1.OptionsView.CellAutoHeight;
end;

end.

