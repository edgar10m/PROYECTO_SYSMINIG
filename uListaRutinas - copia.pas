unit uListaRutinas;

interface

uses
   ADODB, dxmdaset, Classes, uConstantes, cxGrid, Dialogs, DB, SysUtils, cxEdit,
   cxEditRepositoryItems, Controls, Graphics, cxGridDBTableView, cxGridTableView,
   cxCustomData, StrUtils, IdGlobal;

function bGlbPoblarTablaMem(
   sqlParDatosOrigen: TADOQuery; tabParDatosDestino: TdxMemData ): Boolean; overload;

function bGlbPoblarTablaMem(
   slParDatosOrigen: TStringList; tabParDatosDestino: TdxMemData ): Boolean; overload;

function sGlbExportarListaDialogo( exParTipoExport: TTipoExport;
   grdParLista: TcxGrid; sParNombreArchivo: String ): String;

procedure GlbCreateImageRepository(erClase: TcxEditRepository; imClaseTypes: TImageList;
   edClaseTypeImageCombo: TcxEditRepositoryImageComboBoxItem;
   sDir: String; aWho: array of string; bAll: boolean);

procedure GlbTotalCol(dbtView: TcxGridDBTableView; nColView: Integer;
      nCol: Integer; bSum: Boolean);

// se coloca en el primer registro del grid
procedure GlbFocusPrimerItemGrid( ParGrid: TcxGrid; ParGridDBTableView: TcxGridDBTableView );

implementation

function bGlbPoblarTablaMem(
   sqlParDatosOrigen: TADOQuery; tabParDatosDestino: TdxMemData ): Boolean;
var
   i: Integer;
   bReadOnly: Boolean;
begin
   Result := False;

   if not sqlParDatosOrigen.Active then
      Exit;

   try
      bReadOnly := tabParDatosDestino.ReadOnly;

      if tabParDatosDestino.Active then
         tabParDatosDestino.Active := False;

      try
         tabParDatosDestino.ReadOnly := False;
         tabParDatosDestino.LoadFromDataSet( sqlParDatosOrigen );

         for i:= 0 to tabParDatosDestino.FieldCount - 1 do begin
            tabParDatosDestino.Fields[ i ].DisplayLabel :=
               sObtenerEtiquetaCampo( tabParDatosDestino.Fields[ i ].FieldName );
         end;

      finally
         tabParDatosDestino.ReadOnly := bReadOnly;
      end;

      Result := True;
   except
      Result := False;
   end;
end;

function bGlbPoblarTablaMem(
   slParDatosOrigen: TStringList; tabParDatosDestino: TdxMemData ): Boolean;
var
   i, j: Integer;
   sNombre, sTipo, sSize, sPaso: String;
   slCampos, slDatos: TStringList;
   Campo: TField;
   arrayNombre: array of string;
begin
   slCampos := Tstringlist.Create;
   slDatos := Tstringlist.Create;
   try
      try
         slCampos.CommaText := slParDatosOrigen[ 0 ];
         SetLength( arrayNombre, slCampos.Count );

         for i := 0 to slCampos.Count - 1 do begin
            sNombre := Copy( slCampos[ i ], 1, Pos( ':', slCampos[ i ] ) - 1 ); //Nombre
            sPaso := Copy( slCampos[ i ], Pos( ':', slCampos[ i ] ) + 1, Length( slCampos[ i ] ) );
            sTipo := Copy( sPaso, 1, Pos( ':', sPaso ) - 1 ); //Tipo
            sPaso := Copy( sPaso, Pos( ':', sPaso ) + 1, Length( slCampos[ i ] ) );
            sSize := sPaso; //Tamaño
            arrayNombre[ i ] := sNombre;

            sTipo := UpperCase( sTipo );

            if sTipo = UpperCase( 'String' ) then
               if StrToInt(sSize) <= 30 then
                  Campo := DefaultFieldClasses[ ftString ].Create( tabParDatosDestino )
               else
                  Campo := DefaultFieldClasses[ ftMemo ].Create( tabParDatosDestino );

            if sTipo = UpperCase( 'Integer' ) then
               Campo := DefaultFieldClasses[ ftInteger ].Create( tabParDatosDestino );
            if sTipo = UpperCase( 'DateTime' ) then
               Campo := DefaultFieldClasses[ ftDateTime ].Create( tabParDatosDestino );
            if sTipo = UpperCase( 'Boolean' ) then
               Campo := DefaultFieldClasses[ ftBoolean ].Create( tabParDatosDestino );
            if sTipo = UpperCase( 'Float' ) then
               Campo := DefaultFieldClasses[ ftFloat ].Create( tabParDatosDestino );
            if sTipo = UpperCase( 'Date' ) then
               Campo := DefaultFieldClasses[ ftDate ].Create( tabParDatosDestino );

            with Campo do begin
               Name := tabParDatosDestino.Name + sNombre;
               DisplayLabel := sNombre;
               DisplayWidth := 20;
               FieldName := sNombre;

               //para asignar tamaño
               if UpperCase(sTipo) = 'STRING' then
                  TStringField( Campo ).Size := StrToInt( sSize );

               DataSet := tabParDatosDestino;
            end;
         end;
      except
         Result := false;
         MessageDlg( 'Error en el traslado de datos "Titulos"', mtWarning, [ mbOk ], 0 );
         Exit;
      end;

      try
         tabParDatosDestino.Open;

         for i := 1 to slParDatosOrigen.Count - 1 do Begin
            slDatos.CommaText := slParDatosOrigen[ i ];

            tabParDatosDestino.Append;

            for j := 0 to slDatos.Count - 1 do begin
               sPaso := slDatos[ j ];
               sNombre := arrayNombre[ j ];
               tabParDatosDestino.FindField( sNombre ).asString := sPaso;
            end;
         end;

         tabParDatosDestino.Post;
      except
         Result := false;
         MessageDlg( 'Error en el traslado de datos "Campos"', mtWarning, [ mbOk ], 0 );
         Exit;
      end;
      //tabParDatosDestino.Indexes.Add.FieldName := arrayNombre[1];
      //tabParDatosDestino.SortedField := arrayNombre[1];
      Result := true;
   finally
      slDatos.Free;
      slCampos.Free;
   end;
end;

function sGlbExportarListaDialogo( exParTipoExport: TTipoExport;
   grdParLista: TcxGrid; sParNombreArchivo: String ): String;
var
   SaveDialog: TSaveDialog;
begin
   SaveDialog := TSaveDialog.Create( grdParLista );
   try
      with SaveDialog do begin
         InitialDir := GlbObtenerRutaMisDocumentos;

         case exParTipoExport of
            exTexto: begin
                  DefaultExt := '.txt';
                  Filter := 'Listas (*.txt)|*.txt';
               end;
            exExcel: begin
                  DefaultExt := '.xls';
                  Filter := 'Archivos de Excel(*.xl*)|*.xl*';
               end;
            exTodos: begin
                  //DefaultExt := '.*';
                  Filter := 'Todos los archivos (*.*)|*.*';
               end;
         end;

         FileName := sParNombreArchivo + DefaultExt;

         if Execute then
            Result := FileName
         else
            Result := '';
      end;
   finally
      SaveDialog.Free;
   end;
end;

procedure GlbCreateImageRepository(erClase: TcxEditRepository; imClaseTypes: TImageList;
   edClaseTypeImageCombo: TcxEditRepositoryImageComboBoxItem;
   sDir: String; aWho: array of string; bAll: boolean);
var
   i, j: Integer;
   slDirectory: TStringList;
   iMiIcon: TIcon;
   sParte: String;
   aNombreClases: array of string;
   Busqueda: TSearchRec;
   iResultado: Integer;
begin
   try
      slDirectory := TStringList.Create;
      sDir := IncludeTrailingBackslash( sDir );

      for i := 0 to Length(aWho) - 1 do begin
         iResultado :=  FindFirst( sDir + '\' + 'ICONO_'+aWho[ i ]+'.ico', faAnyFile, Busqueda );

         if iResultado <> 0 then
            CopyFileTo(sDir + '\' + 'ICONO_NO.ico', sDir + '\' + 'ICONO_'+aWho[ i ]+'.ico');
      end;

      iResultado :=  FindFirst( sDir + '*.ico', faAnyFile, Busqueda );

      while iResultado = 0 do
         begin
            if bAll then
               slDirectory.Add( Busqueda.Name )
            else
               begin
                  if ( Busqueda.Attr and faArchive = faArchive ) and
                     ( Busqueda.Attr and faDirectory <> faDirectory ) then
                     slDirectory.Add( Busqueda.Name );
                  end;
            iResultado := FindNext( Busqueda );
         end;

      FindClose( Busqueda );
      SetLength( aNombreClases, slDirectory.Count );
      iMiIcon := TIcon.Create;

      for i := 0 to slDirectory.Count - 1 do begin
         sParte := Copy( slDirectory[ i ], Pos( '_', slDirectory[ i ] ) + 1, Length( slDirectory[ i ] ) );
         aNombreClases[ i ] := Copy( sParte, 1, Pos( '.', sParte ) - 1 );


        if AnsiMatchStr(aNombreClases[ i ], aWho) then begin
           iMiIcon.LoadFromFile(sDir + '\' + slDirectory[ i ]);
           imClaseTypes.AddIcon(iMiIcon);
           edClaseTypeImageCombo.Properties.Items.Add;
           j := edClaseTypeImageCombo.Properties.Items.Count - 1;
           edClaseTypeImageCombo.Properties.Items[ j ].Description := aNombreClases[ i ];
           edClaseTypeImageCombo.Properties.Items[ j ].ImageIndex := j;
           edClaseTypeImageCombo.Properties.Items[ j ].Tag := 0;
           edClaseTypeImageCombo.Properties.Items[ j ].Value := aNombreClases[ i ];
        end;
      end;
   finally
      iMiIcon.Free;
      slDirectory.Free;
   end;
end;

procedure GlbTotalCol(dbtView: TcxGridDBTableView; nColView: Integer;
      nCol: Integer; bSum: Boolean);
begin
   with dbtView.DataController.Summary do
      begin
         BeginUpdate;
   try
      with SummaryGroups.Add do
         begin
            TcxGridTableSummaryGroupItemLink(Links.Add).Column := dbtView.Columns[nCol];
            with SummaryItems.Add as TcxGridDBTableSummaryItem do
               begin
                  Column := dbtView.Columns[nColView];
                  Kind := skCount;
                  Format := 'Registros: 0';
                  Position := spFooter;
               end;
        end;

      with FooterSummaryItems.Add as TcxGridDBTableSummaryItem do
         begin
            Column := dbtView.Columns[nColView];

            if bSum then
               begin
                  Kind := skSum;
                  Format := 'Suma: 0';
               end
            else
               begin
                  Kind := skCount;
                  Format := 'Registros: 0';
               end;
         end;
    finally
         EndUpdate;
    end;

    dbtView.DataController.ClearDetails;
  end;
end;

procedure GlbFocusPrimerItemGrid( ParGrid: TcxGrid; ParGridDBTableView: TcxGridDBTableView );
//validar si se crea rutina global para colocarse en el primer registro
begin
   //with grdDatosDBTableView1 do
   with ParGridDBTableView do
      if DataController.DataSetRecordCount > 0 then begin
         //Controller.FocusedRecordIndex := 0;
         //Controller.FocusedColumnIndex := 0;
         Controller.FocusedItemIndex := 0;
      end;

   ParGrid.SetFocus;
end;

end.

