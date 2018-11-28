unit ufmSVSLista;

interface                

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
   StdCtrls, ExtCtrls, ComCtrls, dxBar, cxPC, cxControls, cxStyles, cxCustomData, cxGraphics,
   cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
   cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, dxmdaset, dxBarDBNav, dxPSGlbl,
   dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
   dxPSEdgePatterns, dxPSCore, dxPScxGridLnk, cxExportGrid4Link, StrUtils, cxGridPopupMenu, cxContainer,
   ImgList, cxGridCustomPopupMenu, cxImage, ShellAPI, dxStatusBar;

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
      dtsDatos: TDataSource;
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
      stbLista: TdxStatusBar;
    tabLista: TGroupBox;
    grdEspejo: TcxGrid;
    grdEspejoDBTableView1: TcxGridDBTableView;
    grdEspejoLevel1: TcxGridLevel;
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
    procedure grdDatosDBTableView1DataControllerFilterChanged(
      Sender: TObject);
   private
      { Private declarations }
      sPriTextoBuscar: String;
      slPriBuscar: TStringList;
      iPriAntSigBuscar: Integer;
   public
      { Public declarations }
      slPubLista: TStringList;
   end;

implementation
uses
   uConstantes, uListaRutinas, ptsdm, ptsgral,ptsmain;
{$R *.dfm}

procedure TfmSVSLista.FormCreate( Sender: TObject );
begin
   Height := Height + 1;

   GlbHabilitarOpcionesMenu( mnuPrincipal, False );

   mnuPrincipal.Style := gral.iPubEstiloActivo;
   gral.PubEstiloActivo( stbLista );

   {//se cambio a evento FormShow por causas de documentacion automatica
   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );}

   //Barra Busqueda
   mnuPrincipal.Bars[ 1 ].Visible := False;
   //Barra navegacion
   mnuPrincipal.Bars[ 2 ].Visible := True;
   mnuBarraNavegacion.ImageIndex := 6;

   slPubLista := TStringList.Create;
   slPriBuscar := Tstringlist.Create;
end;

procedure TfmSVSLista.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure TfmSVSLista.FormDestroy( Sender: TObject );
begin
   if FormStyle = fsMDIChild then begin
      dm.PubEliminarVentanaActiva( Caption );

      if gral.iPubVentanasActivas in [ 0, 1 ] then
         gral.PubExpandeMenuVentanas( False );
   end;

   slPubLista.Free;
   slPriBuscar.Free;
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
      //dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( lblEmpresa.Caption );
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Clear;
      //dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( ftsmain.txtUsuario.Text );
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( g_usuario );
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
      //dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( ftsmain.txtUsuario.Text );
      dxComponentPrinterLink1.PrinterPage.PageFooter.LeftTitle.Add( g_usuario );
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
   sNombreArchivo, sCaption: string;
begin
   sCaption := Caption;

   bGlbQuitaCaracteres( sCaption );
   sNombreArchivo := sGlbExportarListaDialogo( exExcel, grdDatos, sCaption );

   if sNombreArchivo = '' then
      Exit;

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

   if ShellExecute( Handle, nil, pchar( sNombreArchivo ), nil, nil, SW_SHOW ) <= 32 then       //abre el csv o el xls segun el caso
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar ' + sNombreArchivo ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
end;

procedure TfmSVSLista.mnuTextoBuscarExit( Sender: TObject );
var
   i: Integer;
   slRecidRenglon: TStringList;
   sRecId: String;
begin
   if Trim( mnuTextoBuscar.Text ) = '' then
      Exit;

   if grdDatosDBTableView1.DataController.RecordCount = 0 then begin
      //nomGridBusqueda.Text:='NO';
      mnuBuscarAnterior.Enabled := False;
      mnuBuscarSiguiente.Enabled := False;
      exit;
   end;

   Screen.Cursor := crSqlWait;
   tabdatos.DisableControls;
   try
      if UpperCase( sPriTextoBuscar ) <> UpperCase( mnuTextoBuscar.Text ) then begin
         sPriTextoBuscar := mnuTextoBuscar.Text;
         slPriBuscar.Clear;
         iPriAntSigBuscar := 0;

         for i := 0 to slPubLista.Count - 1 do
            if pos( UpperCase( mnuTextoBuscar.Text ), UpperCase( slPubLista[ i ] ) ) > 0 then
               slPriBuscar.Add( slPubLista[ i ] );

         if slPriBuscar.Count > 0 then begin
            slRecidRenglon := Tstringlist.Create;
            try
               slRecidRenglon.CommaText := slPriBuscar[ iPriAntSigBuscar ];
               sRecId := slRecidRenglon[ 0 ];

               tabDatos.Locate( 'RecID', sRecId, [ ] );
               GlbExpanderGrupos( grdDatosDBTableView1, True );

               grdDatosDBTableView1.Controller.FocusedColumnIndex := 0;
            finally
               slRecidRenglon.Free;
            end;
         end;
      end;
   finally
      Screen.Cursor := crDefault;
      tabDatos.EnableControls;

      mnuBuscarAnterior.Enabled := True;
      mnuBuscarSiguiente.Enabled := True;
      //grdDatosDBTableView1.Focused := True;
      grdDatos.SetFocus;
   end;
end;

procedure TfmSVSLista.mnuBuscarAnteriorClick( Sender: TObject );
var
   slRecidRenglon: TStringList;
   sRecId: String;
begin
   if slPriBuscar.Count = 0 then
      Exit;

   Screen.Cursor := crSqlWait;
   tabdatos.DisableControls;
   try
      slRecidRenglon := Tstringlist.Create;
      try
         if iPriAntSigBuscar > 0 then begin
            iPriAntSigBuscar := iPriAntSigBuscar - 1;
         end;

         slRecidRenglon.CommaText := slPriBuscar[ iPriAntSigBuscar ];
         sRecId := slRecidRenglon[ 0 ];

         tabDatos.Locate( 'RecID', sRecId, [ ] );
         GlbExpanderGrupos( grdDatosDBTableView1, True );

         grdDatosDBTableView1.Controller.FocusedColumnIndex := 0;

      finally
         slRecidRenglon.Free;
      end;
   finally
      Screen.Cursor := crDefault;
      tabdatos.EnableControls;
      //grdDatosDBTableView1.Focused := True;
      grdDatos.SetFocus;
   end;
end;

procedure TfmSVSLista.mnuBuscarSiguienteClick( Sender: TObject );
var
   slRecidRenglon: TStringList;
   sRecId: String;
begin
   if slPriBuscar.Count = 0 then
      Exit;

   Screen.Cursor := crSqlWait;
   tabdatos.DisableControls;
   try
      slRecidRenglon := Tstringlist.Create;
      try
         if iPriAntSigBuscar < slPriBuscar.Count - 1 then begin
            inc( iPriAntSigBuscar );
         end;
         slRecidRenglon.CommaText := slPriBuscar[ iPriAntSigBuscar ];
         sRecId := slRecidRenglon[ 0 ];

         tabDatos.Locate( 'RecID', sRecId, [ ] );
         GlbExpanderGrupos( grdDatosDBTableView1, True );

         grdDatosDBTableView1.Controller.FocusedColumnIndex := 0;
      finally
         slRecidRenglon.Free;
      end;
   finally
      Screen.Cursor := crDefault;
      tabdatos.EnableControls;
      //grdDatosDBTableView1.Focused := True;
      grdDatos.SetFocus;
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

procedure TfmSVSLista.mnuBuscarClick( Sender: TObject );
begin
   if not mnuPrincipal.Bars[ 1 ].Visible then begin
      mnuPrincipal.Bars[ 1 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 6;
   end;

   mnuTextoBuscar.SetFocus( True );
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

procedure TfmSVSLista.dxBarDBNavFirst1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoFirst;
end;

procedure TfmSVSLista.dxBarDBNavLast1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoLast;
end;

procedure TfmSVSLista.dxBarDBNavNext1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoNext;
end;

procedure TfmSVSLista.dxBarDBNavPrev1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoPrev;
end;

procedure TfmSVSLista.mnuTextoBuscarEnter( Sender: TObject );
begin
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
end;

procedure TfmSVSLista.mnuColAnchoClick( Sender: TObject );
begin
   grdDatosDBTableView1.OptionsView.ColumnAutoWidth := not grdDatosDBTableView1.OptionsView.ColumnAutoWidth;
end;

procedure TfmSVSLista.mnuExpandClick( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.Groups.FullExpand;
   //GlbExpanderGrupos( grdDatosDBTableView1, True ); //propuesta
end;

procedure TfmSVSLista.mnuColapseClick( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.Groups.FullCollapse;
   //GlbExpanderGrupos( grdDatosDBTableView1, False ); //propuesta
end;

procedure TfmSVSLista.mnuLineasClick( Sender: TObject );
begin
   if grdDatosDBTableView1.OptionsView.GridLines = glNone then
      grdDatosDBTableView1.OptionsView.GridLines := glBoth
   else
      grdDatosDBTableView1.OptionsView.GridLines := glNone;
end;

procedure TfmSVSLista.dxBarButton2Click( Sender: TObject );
begin
   grdDatosDBTableView1.ApplyBestFit;
end;

procedure TfmSVSLista.dxBarButton3Click( Sender: TObject );
begin
   grdDatosDBTableView1.OptionsView.CellAutoHeight := not grdDatosDBTableView1.OptionsView.CellAutoHeight;
end;

procedure TfmSVSLista.FormShow(Sender: TObject);
begin
   if FormStyle = fsMDIChild then
      if gral.iPubVentanasActivas > 0 then
         gral.PubExpandeMenuVentanas( True );
end;

procedure TfmSVSLista.grdDatosDBTableView1DataControllerFilterChanged(
  Sender: TObject);
begin
   if tabDatos.Active then
      if grdDatosDBTableView1.DataController.Filter.IsEmpty then
         stbLista.Panels[ 0 ].Text :=
            IntToStr( tabDatos.RecordCount ) + ' Registros'
      else
         stbLista.Panels[ 0 ].Text :=
            IntToStr( tabDatos.RecordCount ) + ' Registros' + ' - ' +
            IntTostr( grdDatosDBTableView1.DataController.FilteredRecordCount ) + ' Filtrados';
end;

end.

