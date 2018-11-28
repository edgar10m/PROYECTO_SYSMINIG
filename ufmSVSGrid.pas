unit ufmSVSGrid;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
   StdCtrls, ExtCtrls, ComCtrls, dxBar, cxPC, cxControls, cxStyles, cxCustomData, cxGraphics,
   cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxGrid,
   dxmdaset, dxBarDBNav, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
   dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, dxPSCore, dxPScxGridLnk, StrUtils,
   ImgList, cxExportGrid4Link, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
   cxGridDBTableView, dxStatusBar;

type
   TfmSVSGrid = class( TForm )
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
      mnuDatos: TdxBarSubItem;
      mnuOpcionesAmbiente: TdxBarButton;
      stbLista: TdxStatusBar;
    tabLista: TGroupBox;
    grdDatos: TcxGrid;
    grdDatosDBTableView1: TcxGridDBTableView;
    grdDatosLevel1: TcxGridLevel;
    grdEspejo: TcxGrid;
    grdEspejoDBTableView1: TcxGridDBTableView;
    grdEspejoLevel1: TcxGridLevel;
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
      procedure grdDatosDBTableView1DataControllerFilterChanged(
         Sender: TObject );
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
   uConstantes, uListaRutinas, ptsdm, ptsgral;
{$R *.dfm}

procedure TfmSVSGrid.FormCreate( Sender: TObject );
begin
   GlbHabilitarOpcionesMenu( mnuPrincipal, False );

   mnuPrincipal.Style := gral.iPubEstiloActivo;
   gral.PubEstiloActivo( stbLista );

   if gral.iPubVentanasActivas > 0 then
      gral.PubExpandeMenuVentanas( True );

   //Barra Busqueda
   mnuPrincipal.Bars[ 1 ].Visible := False;
   //Barra navegacion
   mnuPrincipal.Bars[ 2 ].Visible := True;
   mnuBarraNavegacion.ImageIndex := 6;

   slPubLista := TStringList.Create;
   slPriBuscar := Tstringlist.Create;
end;

procedure TfmSVSGrid.FormClose( Sender: TObject;
   var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure TfmSVSGrid.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );

   slPubLista.Free;
   slPriBuscar.Free;
end;

procedure TfmSVSGrid.mnuSalirClick( Sender: TObject );
begin
   Close;
end;

procedure TfmSVSGrid.mnuImprimirClick( Sender: TObject );
begin
   try
      grdDatosLevel1.Caption := Caption;

      {dxComponentPrinterLink1.Component := grdDatos;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( Caption );
      dxComponentPrinter.Print( True, nil, nil );}

      dxComponentPrinterLink1.Print( True, nil );
   finally
      grdDatosLevel1.Caption := '';
   end;
end;

procedure TfmSVSGrid.mnuVistaPreliminarClick( Sender: TObject );
begin
   try
      grdDatosLevel1.Caption := Caption;

      {dxComponentPrinterLink1.Component := grdDatos;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Clear;
      dxComponentPrinterLink1.PrinterPage.PageHeader.CenterTitle.Add( Caption );
      dxComponentPrinter.Preview( True, dxComponentPrinterLink1 );}//fernando ramirez

      dxComponentPrinterLink1.Preview( True );
   finally
      grdDatosLevel1.Caption := '';
   end;
end;

procedure TfmSVSGrid.mnuSeleccionarTodoClick( Sender: TObject );
begin
   if not grdDatosDBTableView1.OptionsSelection.MultiSelect then begin
      Application.MessageBox(
         'Para esta acción primero active la opción de "Selección Multiple".',
         'Aviso', MB_OK );
      Exit;
   end;

   grdDatosDBTableView1.DataController.SelectAll;
end;

procedure TfmSVSGrid.mnuExportarExcelClick( Sender: TObject );
var
   sNombreArchivo, sCaption: String;
begin
   sCaption := Caption;
   bGlbQuitaCaracteres( sCaption );

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
   
end;

procedure TfmSVSGrid.mnuTextoBuscarExit( Sender: TObject );
var
   i: Integer;
   slRecidRenglon: TStringList;
   sRecId: String;
begin
   if Trim( mnuTextoBuscar.Text ) = '' then
      Exit;

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

procedure TfmSVSGrid.mnuBuscarAnteriorClick( Sender: TObject );
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

procedure TfmSVSGrid.mnuBuscarSiguienteClick( Sender: TObject );
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

procedure TfmSVSGrid.mnuiMultiSelecClick( Sender: TObject );
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

procedure TfmSVSGrid.mnuCopiaRenglonClick( Sender: TObject );
begin
   grdDatosDBTableView1.CopyToClipboard( False );
end;

procedure TfmSVSGrid.mnuExportarTextoDelimitadoClick( Sender: TObject );
var
   sNombreArchivo, sCaption: String;
begin
   sCaption := Caption;
   bGlbQuitaCaracteres( sCaption );

   sNombreArchivo := sGlbExportarListaDialogo( exTexto, grdDatos, sCaption );

   if sNombreArchivo = '' then
      Exit;

   ExportGrid4ToText( sNombreArchivo, grdDatos, True, True, ',', '"', '"' );
end;

procedure TfmSVSGrid.mnuBuscarClick( Sender: TObject );
begin
   if not mnuPrincipal.Bars[ 1 ].Visible then begin
      mnuPrincipal.Bars[ 1 ].Visible := True;
      mnuBarraBusqueda.ImageIndex := 6;
   end;

   mnuTextoBuscar.SetFocus( True );
end;

procedure TfmSVSGrid.mnuBarraBusquedaClick( Sender: TObject );
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

procedure TfmSVSGrid.mnuBarraNavegacionClick( Sender: TObject );
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

procedure TfmSVSGrid.mnuPaginaConfClick( Sender: TObject );
begin
   dxComponentPrinterLink1.PageSetup;
end;

procedure TfmSVSGrid.dxBarDBNavFirst1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoFirst;
end;

procedure TfmSVSGrid.dxBarDBNavLast1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoLast;
end;

procedure TfmSVSGrid.dxBarDBNavNext1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoNext;
end;

procedure TfmSVSGrid.dxBarDBNavPrev1Click( Sender: TObject );
begin
   grdDatosDBTableView1.DataController.GotoPrev;
end;

procedure TfmSVSGrid.mnuTextoBuscarEnter( Sender: TObject );
begin
   mnuBuscarAnterior.Enabled := False;
   mnuBuscarSiguiente.Enabled := False;
end;

procedure TfmSVSGrid.grdDatosDBTableView1DataControllerFilterChanged(
   Sender: TObject );
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

