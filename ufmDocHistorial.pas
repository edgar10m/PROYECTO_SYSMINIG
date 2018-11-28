unit ufmDocHistorial;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSGrid, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit,
   DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
   dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, ImgList, dxPSCore, dxPScxGridLnk,
   dxBarDBNav, dxmdaset, dxBar, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
   cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC, dxStatusBar,
  StdCtrls;

type
   TfmDocHistorial = class( TfmSVSGrid )
      mnuDocumento: TdxBarSubItem;
      mnuDescargar: TdxBarButton;
      procedure mnuDescargarClick( Sender: TObject );
      //procedure FormActivate( Sender: TObject );  BMG
   private
      { Private declarations }
      iPriIDDOCTO: Integer;

      function bPriPoblarTabla: Boolean;
      procedure PriHabilitarOpcionesMenu( bParHabilitar: Boolean );

      procedure Proceso;   //BMG
   public
      { Public declarations }

      procedure PubGeneraLista( iParIDDOCTO: Integer; sParCaption: String );
   end;

implementation

uses
   ptsdm, uConstantes, uListaRutinas;

{$R *.dfm}

procedure TfmDocHistorial.PubGeneraLista( iParIDDOCTO: Integer; sParCaption: String );
//var
  // i: Integer;
begin
   iPriIDDOCTO := iParIDDOCTO;

   Caption := sParCaption;

   tabLista.Caption := StringReplace( Caption, sDOCUMENTACION_HIS + ' - ', '', [ rfReplaceAll ] ) + ' ';

   // ----- cambio BMG -----
   //FormActivate( Self );
   proceso;
   // ----------------------

   {if bPriPoblarTabla then begin
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      PriHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

      GlbCrearCamposGrid( grdDatosDBTableView1 );

      //necesario para la busqueda
      //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
      grdEspejoDBTableView1.DataController.CreateAllItems;
      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      //fin necesario para la busqueda

      with grdDatosDBTableView1 do //crear rutina global para ocultar o mostrar, diccionario de datos
         for i := 0 to ColumnCount - 1 do
            if ( Columns[ i ].DataBinding.FieldName = 'IDDOCTO' ) then
               Columns[ i ].Visible := False;

      grdDatosDBTableView1.ApplyBestFit( );

      GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );

      tabDatos.ReadOnly := True;
   end;}
end;

function TfmDocHistorial.bPriPoblarTabla: Boolean;
var
   cons : String;
begin
   Result := False;

   Screen.Cursor := crSqlWait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros

      cons:= 'SELECT iddocto, idrevision, usuario_rev, fecha_inicio, fecha_fin' +
         ' FROM TSDOCREVISION ' +
         ' WHERE IDDOCTO = ' + IntToStr( iPriIDDOCTO ) +
         ' ORDER BY IDREVISION';

      dm.sqlselect( dm.q1, cons );

      //GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
      if bGlbPoblarTablaMem( dm.q1, tabDatos ) then begin
         tabDatos.First;
         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         Result := True;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocHistorial.mnuDescargarClick( Sender: TObject );
var
   iIDDOCTO: Integer;
   sNOMBRE,sExt: String;
   iIDREVISION,iNomSinExt: Integer;
   sFECHA_INICIO: String;

   sNombreArchivo,sNomSinExt: String;
begin
   inherited;

   Screen.Cursor := crSQLWait;
   try
      if not tabDatos.Active then
         Exit;

      if tabDatos.RecordCount = 0 then
         Exit;

      iIDDOCTO := tabDatos.FieldByName( 'IDDOCTO' ).AsInteger;
      iIDREVISION := tabDatos.FieldByName( 'IDREVISION' ).AsInteger;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCUMENTO ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) ) then begin
         Application.MessageBox( pchar( 'No exite el documento' ), 'Documento', MB_OK );
         Exit;
      end;

      {if dm.q1.fieldbyname( 'ESTATUS' ).AsString = 'E' then begin
         Application.MessageBox( pchar( 'Documento con estatus: Eliminado' ), 'Documento', MB_OK );
         Exit;
      end;}

      sNOMBRE := dm.q1.FieldByName( 'NOMBRE' ).AsString;
      sExt:= dm.q1.FieldByName( 'EXTENSION' ).AsString;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCREVISION ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' + IntToStr( iIDREVISION ) ) then begin
         Application.MessageBox( pchar( 'No exite el documento en revisión' ), 'Documento', MB_OK );
         Exit;
      end;

      sFECHA_INICIO := FormatDateTime( 'yyyymmddhhmm', dm.q1.FieldByName( 'FECHA_INICIO' ).AsDateTime );

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCBLOB ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' + IntToStr( iIDREVISION ) ) then begin
         Application.MessageBox( pchar( 'No exite el documento en tsblob' ), 'Documento', MB_OK );
         Exit;
      end;

      iNomSinExt:=pos(UpperCase(sExt),UpperCase(sNOMBRE));
      sNomSinExt:= copy (sNOMBRE, 0,iNomSinExt-1);

      sNombreArchivo := sGlbGuardarDialogo(sExt,sFECHA_INICIO+'_'+sNomSinExt);
      if sNombreArchivo = '' then
         Exit;

      if not dm.bObtenerTSDOCBLOB( iIDDOCTO, iIDREVISION, sNombreArchivo ) then begin
         Application.MessageBox( pchar( 'No puedo descargar el documento' ), 'Documento', MB_OK );
         Exit;
      end;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocHistorial.PriHabilitarOpcionesMenu( bParHabilitar: Boolean );
begin
   mnuDocumento.Enabled := True;

   mnuDescargar.Enabled := bParHabilitar;
end;

//procedure TfmDocHistorial.FormActivate( Sender: TObject );         BMG
procedure TfmDocHistorial.Proceso;        // Cambio de BMG
var
   i: Integer;
begin
   inherited;

   if iPriIDDOCTO <= 0 then
      Exit;

   if bPriPoblarTabla then begin
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      PriHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

      GlbCrearCamposGrid( grdDatosDBTableView1 );

      //necesario para la busqueda
      //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
      grdEspejoDBTableView1.DataController.CreateAllItems;
      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      //fin necesario para la busqueda

      with grdDatosDBTableView1 do //crear rutina global para ocultar o mostrar, diccionario de datos
         for i := 0 to ColumnCount - 1 do
            if ( Columns[ i ].DataBinding.FieldName = 'IDDOCTO' ) then
               Columns[ i ].Visible := False;

      grdDatosDBTableView1.ApplyBestFit( );

      GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );

      tabDatos.ReadOnly := True;
   end;
end;

end.

