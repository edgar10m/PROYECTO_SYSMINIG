unit uListaRutinas;

interface

uses
   ADODB, dxmdaset, Classes, uConstantes, cxGrid, Dialogs, DB, SysUtils, cxEdit,
   cxEditRepositoryItems, Controls, Graphics, cxGridDBTableView, cxGridTableView,
   cxCustomData, StrUtils, IdGlobal, cxExportGrid4Link, dxBar;

type //lista compo
   Txx = record
      icono: string;
      clase: string;
      bib: string;
      nombre: string;
      modo: string;
      organizacion: string;
      externo: string;
      coment: string;
      existe: boolean;
      hay: string;
      sistema: string;
   end;

   Txx_d = record //lista dependencias
      nivel: integer;
      claseo: string;
      bibo: string;
      nombreo: string;
      clasep: string;
      bibp: string;
      nombrep: string;
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

   Ttotal_d = record //lista dependencias
      clase: string;
      total: integer;
   end;

var
   x: array of Txx; //lista compo
   xx: Tstringlist; //lista compo
   loc1, loc2: Tstringlist; //lista compo
   lista_selects:TStringList;   // alk para registro de consultas que se realizan en la lista.

function bGlbPoblarTablaMem(
   sqlParDatosOrigen: TADOQuery; tabParDatosDestino: TdxMemData ): Boolean; overload;

function bGlbPoblarTablaMem(
   slParDatosOrigen: TStringList; tabParDatosDestino: TdxMemData ): Boolean; overload;

function sGlbExportarListaDialogo( exParTipoExport: TTipoExport;
   grdParLista: TcxGrid; sParNombreArchivo: String ): String;   overload

function sGlbExportarListaDialogo( extension : String;
   grdParLista: TcxGrid; sParNombreArchivo: String ): String; overload

procedure GlbCreateImageRepository( erClase: TcxEditRepository; imClaseTypes: TImageList;
   edClaseTypeImageCombo: TcxEditRepositoryImageComboBoxItem;
   sDir: String; aWho: array of string; bAll: boolean );

procedure GlbTotalCol( dbtView: TcxGridDBTableView; nColView: Integer;
   nCol: Integer; bSum: Boolean );

// se coloca en el primer registro del grid
procedure GlbFocusPrimerItemGrid( ParGrid: TcxGrid; ParGridDBTableView: TcxGridDBTableView );
// crea campo RecId en el GridDBTableView indicado, muestra consecutivo de registros y
// si se requiere es visible el campo
procedure GlbCrearRecID( ParGridDBTableView: TcxGridDBTableView; bParVisible: Boolean ); overload;
procedure GlbCrearRecID( ParGridDBTableView: TcxGridDBTableView; bParVisible: Boolean; nombre : String ); overload;
//carga un StringList con el contenido de la lista
procedure GlbCargarLista(
   ParGrid: TcxGrid; ParGridDBTableView: TcxGridDBTableView; slParLista: TStringList );
//expander o contraer grupos de un GridDBTableView
procedure GlbExpanderGrupos( ParGridDBTableView: TcxGridDBTableView; bParExpander: Boolean );
//habilita y deshabilita opciones de menu comunes
procedure GlbHabilitarOpcionesMenu( ParMenu: TdxBarManager; bParHabilitar: Boolean );
//crea campos en el GridDBTableView indicado
procedure GlbCrearCamposGrid( ParGridDBTableView: TcxGridDBTableView );
//quitar Filtros de un GridDBTableView indicado
procedure GlbQuitarFiltrosGrid( ParGridDBTableView: TcxGridDBTableView );

procedure GlbArmarListaCompo( tabParDatos: TdxMemData;
   sParSistema, sParClase, sParBib, sParProg: String; sParTitulo: String;
   slParClases, slParExcluyeMenu, slParClasesExiste: TStringList );

implementation
uses
   ptsdm;

function bGlbPoblarTablaMem(
   sqlParDatosOrigen: TADOQuery; tabParDatosDestino: TdxMemData ): Boolean;
var
   i: Integer;
   bReadOnly: Boolean;
begin
   tabParDatosDestino.DisableControls;
   try
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

            for i := 0 to tabParDatosDestino.FieldCount - 1 do begin
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
   finally
      tabParDatosDestino.EnableControls;
   end;
end;

function bGlbPoblarTablaMem(
   slParDatosOrigen: TStringList; tabParDatosDestino: TdxMemData ): Boolean;
var
   i, j: Integer;
   sNombre, sTitulo, sTipo, sSize, sPaso: String;
   slCampos, slDatos: TStringList;
   Campo: TField;
   arrayNombre: array of string;
   bReadOnly: Boolean;
   contenido : integer;
   separa_titulos : TStringList;

   function limpiaRepetidos(pal:string):string;
   var
      limpia,aux:TstringList;
      i:integer;
      espacio:string;
   begin
      limpia:=TStringList.Create;
      aux:=TStringList.Create;
      limpia.Delimiter:=' ';
      limpia.DelimitedText:=pal;
      pal:='';
      aux.Sorted:=true;
      for i:=0 to limpia.Count-1 do
         aux.Add(limpia[i]);
      espacio:='';
      for i:=0 to aux.Count-1 do begin
         pal:=pal + espacio + aux[i];
         espacio:=' ';
      end;
      limpia.Free;
      aux.Free;
      Result:=pal;
   end;

   function bExisteCampoFisico(
      tabParTablaMem: TdxMemData; sParNombre: String ): Boolean;
   var
      i: Integer;
      bExisteCampo: Boolean;
   begin
      bExisteCampo := False;

      for i := 0 to tabParTablaMem.Fields.Count - 1 do
         if LowerCase( tabParTablaMem.Fields[ i ].Name ) = LowerCase( sParNombre ) then begin
            bExisteCampo := True;
            Break;
         end;

      Result := bExisteCampo;
   end;
begin
   contenido:=0;    //alk para evitar error en el traslado de datos

   tabParDatosDestino.DisableControls;
   try
      if tabParDatosDestino.Active then
         tabParDatosDestino.Active := False;

      bReadOnly := tabParDatosDestino.ReadOnly;

      slCampos := Tstringlist.Create;
      slDatos := Tstringlist.Create;
      try
         tabParDatosDestino.ReadOnly := False;
         try
            slCampos.CommaText := slParDatosOrigen[ 0 ];

            slCampos.SaveToFile(g_tmpdir+'\titulos.txt');     //ALK borrar
            contenido:=slCampos.Count;  //alk para error en el traslado de campos

            SetLength( arrayNombre, slCampos.Count );

            // alk para separar las palabras y evitar errores cuando trae nombre con  ':'
            separa_titulos:=TStringList.Create;
            separa_titulos.Delimiter:=':';
            // --------------------------------------------------------------------------

            for i := 0 to slCampos.Count - 1 do begin
               //  ---- alk para evitar el error cuando el titulo trae ':' --------
               separa_titulos.Clear;
               separa_titulos.DelimitedText:=slCampos[ i ];

               sSize := separa_titulos[separa_titulos.Count-1];
               sTipo := separa_titulos[separa_titulos.Count-2];
               if separa_titulos.Count > 3 then begin
                  sNombre:='';
                  for j:=0  to separa_titulos.Count-3 do
                     sNombre := sNombre + separa_titulos[j] + ':';
                  sNombre:= copy(sNombre,0,length(sNombre)-1);
               end
               else
                  sNombre := separa_titulos[separa_titulos.Count-3];
               // -----------------------------------------------------------------
               {sNombre := Copy( slCampos[ i ], 1, Pos( ':', slCampos[ i ] ) - 1 ); //Nombre
               sPaso := Copy( slCampos[ i ], Pos( ':', slCampos[ i ] ) + 1, Length( slCampos[ i ] ) );
               sTipo := Copy( sPaso, 1, Pos( ':', sPaso ) - 1 ); //Tipo
               sPaso := Copy( sPaso, Pos( ':', sPaso ) + 1, Length( slCampos[ i ] ) );
               sSize := sPaso; }//Tamaño

               sTitulo := sNombre;
               bGlbQuitaCaracteres( sNombre );
               arrayNombre[ i ] := sNombre;

               sTipo := UpperCase( sTipo );

               if not bExisteCampoFisico(
                  tabParDatosDestino, tabParDatosDestino.Name + sNombre ) then begin
                  if sTipo = UpperCase( 'String' ) then
                     if StrToInt( sSize ) <= 30 then
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
                     DisplayLabel := sTitulo;

                     if StrToInt( sSize ) < 20 then
                        DisplayWidth := StrToInt( sSize )
                     else
                        DisplayWidth := 20;

                     FieldName := sNombre;

                     //para asignar tamaño
                     if UpperCase( sTipo ) = 'STRING' then
                        TStringField( Campo ).Size := StrToInt( sSize );

                     DataSet := tabParDatosDestino;
                  end;
               end;
            end;
            separa_titulos.Free;
         except
            Result := false;
            if alkDocumentacion <> 1 then  // para evitar que salga en documentacion
               MessageDlg( 'Error en el traslado de datos "Titulos"', mtWarning, [ mbOk ], 0 );
            separa_titulos.Free;
            Exit;
         end;

         try
            tabParDatosDestino.Open;

            for i := 1 to slParDatosOrigen.Count - 1 do Begin
               slDatos.CommaText := slParDatosOrigen[ i ];
               tabParDatosDestino.Append;

               if (slDatos.Count <> contenido) then
                  continue;

               for j := 0 to slDatos.Count - 1 do begin
                  sNombre := arrayNombre[ j ];
                  sPaso := slDatos[ j ];

                  if (UpperCase(sPaso)<>'TRUE') and (UpperCase(sPaso)<>'FALSE') then
                     sPaso := limpiaRepetidos( sPaso );                          //alk

                  if sPaso <> '' then
                     tabParDatosDestino.FindField( sNombre ).AsVariant := sPaso;
               end;
            end;

            if tabParDatosDestino.State in [ dsInsert ] then
               tabParDatosDestino.Post;

            for i := 0 to tabParDatosDestino.FieldCount - 1 do begin
               tabParDatosDestino.Fields[ i ].DisplayLabel :=
                  sObtenerEtiquetaCampo( tabParDatosDestino.Fields[ i ].FieldName );
            end;
         except
            Result := False;
            if alkDocumentacion <> 1 then
               MessageDlg( 'Error en el traslado de datos "Campos"', mtWarning, [ mbOk ], 0 );
            Exit;
         end;

         Result := true;
      finally
         tabParDatosDestino.ReadOnly := bReadOnly;
         slDatos.Free;
         slCampos.Free;
      end;
   finally
      tabParDatosDestino.EnableControls;

      tabParDatosDestino.SaveToTextFile(g_tmpdir + '\tabdatosBorrar.txt');
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

         bGlbQuitaCaracteres( sParNombreArchivo );

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

// -- alk para descargar sin que le quite el punto "documentacion externa"
function sGlbExportarListaDialogo( extension : String;
   grdParLista: TcxGrid; sParNombreArchivo: String ): String;
var
   SaveDialog: TSaveDialog;
begin
   SaveDialog := TSaveDialog.Create( grdParLista );
   try
      with SaveDialog do begin
         InitialDir := GlbObtenerRutaMisDocumentos;
         Filter := 'Todos los archivos (*.*)|*.*';

         //bGlbQuitaCaracteres( sParNombreArchivo );
         FileName := sParNombreArchivo + extension;

         if Execute then
            Result := FileName
         else
            Result := '';
      end;
   finally
      SaveDialog.Free;
   end;
end;

procedure GlbCreateImageRepository( erClase: TcxEditRepository; imClaseTypes: TImageList;
   edClaseTypeImageCombo: TcxEditRepositoryImageComboBoxItem;
   sDir: String; aWho: array of string; bAll: boolean );
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
   try

      slDirectory := TStringList.Create;
      sDir := IncludeTrailingBackslash( sDir );

      for i := 0 to Length( aWho ) - 1 do begin
         iResultado := FindFirst( sDir + '\' + 'ICONO_' + aWho[ i ] + '.ico', faAnyFile, Busqueda );

         if iResultado <> 0 then
            CopyFileTo( sDir + '\' + 'ICONO_NO.ico', sDir + '\' + 'ICONO_' + aWho[ i ] + '.ico' );
      end;

      iResultado := FindFirst( sDir + '*.ico', faAnyFile, Busqueda );

      while iResultado = 0 do begin
         if bAll then
            slDirectory.Add( Busqueda.Name )
         else begin
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

         if AnsiMatchStr( aNombreClases[ i ], aWho ) then begin
            iMiIcon.LoadFromFile( sDir + '\' + slDirectory[ i ] );
            imClaseTypes.AddIcon( iMiIcon );
            edClaseTypeImageCombo.Properties.Items.Add;
            j := edClaseTypeImageCombo.Properties.Items.Count - 1;
            edClaseTypeImageCombo.Properties.Items[ j ].Description := aNombreClases[ i ];
            edClaseTypeImageCombo.Properties.Items[ j ].ImageIndex := j;
            edClaseTypeImageCombo.Properties.Items[ j ].Tag := 0;
            edClaseTypeImageCombo.Properties.Items[ j ].Value := aNombreClases[ i ];
         end;
      end;
   except
      on E: exception do
         alkErrorGral:=E.Message;   // prueba documentacion ALK
   end;
   finally
      iMiIcon.Free;
      slDirectory.Free;
   end;
end;

procedure GlbTotalCol( dbtView: TcxGridDBTableView; nColView: Integer;
   nCol: Integer; bSum: Boolean );
begin
   with dbtView.DataController.Summary do begin
      BeginUpdate;
      try
         with SummaryGroups.Add do begin
            TcxGridTableSummaryGroupItemLink( Links.Add ).Column := dbtView.Columns[ nCol ];
            with SummaryItems.Add as TcxGridDBTableSummaryItem do begin
               Column := dbtView.Columns[ nColView ];
               Kind := skCount;
               Format := 'Registros: 0';
               Position := spFooter;
            end;
         end;

         with FooterSummaryItems.Add as TcxGridDBTableSummaryItem do begin
            Column := dbtView.Columns[ nColView ];

            if bSum then begin
               Kind := skSum;
               Format := '0';
            end
            else begin
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
//rutina global para colocarse en el primer registro
begin
   with ParGridDBTableView do begin
      ParGridDBTableView.DataController.DataSource.DataSet.First;

      if DataController.DataSetRecordCount > 0 then
         Controller.FocusedItemIndex := 0;
   end;

   ParGrid.SetFocus;
end;

procedure GlbCrearRecID( ParGridDBTableView: TcxGridDBTableView; bParVisible: Boolean );
var
   i: Integer;
   sNombreCampoRecId: String;
   bExisteRecId: Boolean;
begin
   bExisteRecId := False;
   sNombreCampoRecId := LowerCase( ParGridDBTableView.Name + 'RecId' );

   //Elimina item RecId del Grid
   for i := 0 to ParGridDBTableView.ItemCount - 1 do
      if LowerCase( ParGridDBTableView.Items[ i ].Name ) = sNombreCampoRecId then begin
         //ParGridDBTableView.Items[ i ].Free;
         ParGridDBTableView.Items[ i ].Visible := bParVisible;
         bExisteRecId := True;
         Break;
      end;

   //Crea item RecId en el Grid
   if bExisteRecId = False then
      with ParGridDBTableView.CreateColumn do begin
         Name := sNombreCampoRecId;
         DataBinding.FieldName := 'RecId';
         Caption := 'RecId';
         Index := 0;
         Visible := bParVisible;
      end;
end;

procedure GlbCrearRecID( ParGridDBTableView: TcxGridDBTableView; bParVisible: Boolean; nombre : String );
var
   i: Integer;
   sNombreCampoRecId: String;
   bExisteRecId: Boolean;
begin
   bExisteRecId := False;
   sNombreCampoRecId := LowerCase( ParGridDBTableView.Name + 'RecId' );

   //Elimina item RecId del Grid
   for i := 0 to ParGridDBTableView.ItemCount - 1 do
      if LowerCase( ParGridDBTableView.Items[ i ].Name ) = sNombreCampoRecId then begin
         //ParGridDBTableView.Items[ i ].Free;
         ParGridDBTableView.Items[ i ].Visible := bParVisible;
         bExisteRecId := True;
         Break;
      end;

   //Crea item RecId en el Grid
   if bExisteRecId = False then
      with ParGridDBTableView.CreateColumn do begin
         Name := sNombreCampoRecId;
         DataBinding.FieldName := 'RecId';
         Caption := nombre;
         Index := 0;
         Visible := bParVisible;
      end;
end;

procedure GlbCargarLista(
   ParGrid: TcxGrid; ParGridDBTableView: TcxGridDBTableView; slParLista: TStringList );
var
   i: Integer;
   sArchivoPaso: String;
   cxGrid: TcxGrid;
   cxGridDBTableView: TcxGridDBTableView;
 begin
   sArchivoPaso := g_tmpdir + '\StingListBusqueda.txt';

   ParGridDBTableView.DataController.DataSource.DataSet.DisableControls;
   try
      GlbCrearRecID( ParGridDBTableView, True );

      ExportGrid4ToText( sArchivoPaso, ParGrid, True, True, ',', '"', '"' );

      if FileExists( sArchivoPaso ) then begin
         slParLista.LoadFromFile( sArchivoPaso );

         if slParLista.Count > 0 then
            slParLista.Delete( 0 ); //elimina titulos de los campos
      end;
   finally
      ParGridDBTableView.DataController.DataSource.DataSet.EnableControls;
      DeleteFile( sArchivoPaso );
   end;
end;

procedure GlbExpanderGrupos( ParGridDBTableView: TcxGridDBTableView; bParExpander: Boolean );
begin
   if bParExpander then
      ParGridDBTableView.ViewData.Expand( True )
   else
      ParGridDBTableView.ViewData.Collapse( True );
end;

procedure GlbHabilitarOpcionesMenu( ParMenu: TdxBarManager; bParHabilitar: Boolean );
var
   i: Integer;
begin
   for i := 0 to ParMenu.ItemCount - 1 do
      if ( LowerCase( ParMenu.Items[ i ].Name ) <> 'mnusalir' ) and
         ( LowerCase( ParMenu.Items[ i ].Name ) <> 'mnulista' ) then
         ParMenu.Items[ i ].Enabled := bParHabilitar;
end;

procedure GlbCrearCamposGrid( ParGridDBTableView: TcxGridDBTableView );
var
   i: Integer;
begin
   //elimina campos del grid
   for i := ParGridDBTableView.ItemCount - 1 downto 0 do
      ParGridDBTableView.Items[ i ].Free;

   //crea campos en el grid
   //if ParGridDBTableView.ItemCount <> 0 then
      ParGridDBTableView.DataController.CreateAllItems;
end;

procedure GlbQuitarFiltrosGrid( ParGridDBTableView: TcxGridDBTableView );
begin
   ParGridDBTableView.DataController.Filter.Clear;
end;

//////////////////////////////////////////////////////////////////////////

procedure PoblarLstCompo( tabParDatos: TdxMemData );
var
   i: integer;
   sPass: string;
   slDatos: Tstringlist;
   aClases: array of string;
begin
   slDatos := Tstringlist.create;
   slDatos.Delimiter := ',';
   slDatos.Add(
      'clase:String:20,bib:String:250,nombre:String:250,modo:String:20,organizacion:String:20,' +
      'externo:String:50,coment:String:200,existe:Boolean:0,sistema:String:50' );

   for i := 0 to length( x ) - 1 do begin
      if x[ i ].existe then
         sPass := 'true'
      else
         sPass := 'false';

      slDatos.Add( '"' + x[ i ].clase + '",' +
         '"' + x[ i ].bib + '",' +
         //'"' + x[ i ].nombre + '",' +
         '"' + StringReplace( x[ i ].nombre, '"', '', [ rfReplaceAll ] ) + '",' + //aqui JCR
         '"' + x[ i ].modo + '",' +
         '"' + x[ i ].organizacion + '",' +
         '"' + x[ i ].externo + '",' +
         '"' + x[ i ].coment + '",' +
         '"' + sPass + '",' +
         '"' + x[ i ].sistema + '"' );

      if not AnsiMatchStr( x[ i ].clase, aClases ) then begin
         SetLength( aClases, Length( aClases ) + 1 );
         aClases[ Length( aClases ) - 1 ] := x[ i ].clase;
      end;
   end;

   SetLength( x, 0 );

   if tabParDatos.Active then
      tabParDatos.Active := False;

   if bGlbPoblarTablaMem( slDatos, tabParDatos ) then begin
      tabParDatos.ReadOnly := True;
   end;
end;

function agrega_compo( qq: Tadoquery; slParClasesExiste: TStringList ): boolean;
var
   cc: String;
   i, k, n: integer;
begin
   cc := qq.FieldByName( 'hcprog' ).AsString + '|' +
      qq.FieldByName( 'hcbib' ).AsString + '|' +
      qq.FieldByName( 'hcclase' ).AsString;

   if qq.FieldByName( 'hcclase' ).AsString = 'FIL' then begin
      // Si está en un paso con IDCAMS lo descarta, suponniendo que lo está borrando Liverpool
      if dm.sqlselect( dm.q4, 'select * from tsrela ' +
         ' where pcprog=' + g_q + qq.fieldbyname( 'pcprog' ).AsString + g_q +
         ' and   pcbib=' + g_q + qq.fieldbyname( 'pcbib' ).AsString + g_q +
         ' and   pcclase=' + g_q + qq.fieldbyname( 'pcclase' ).AsString + g_q +
         ' and   hcprog=' + g_q + 'IDCAMS' + g_q +
         ' and   hcbib=' + g_q + 'SYSTEM' + g_q +
         ' and   hcclase=' + g_q + 'UTI' + g_q ) then begin
         agrega_compo := false;
         exit;
      end;
   end;

   if xx.IndexOf( cc ) > -1 then begin
      agrega_compo := false;
      Exit;
   end;

   xx.Add( cc );
   k := length( x );
   SetLength( x, k + 1 );
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
   x[ k ].sistema := qq.FieldByName( 'sistema' ).AsString;
   if slParClasesExiste.IndexOf( x[ k ].clase ) > -1 then
      x[ k ].existe := dm.sqlselect( dm.q2, 'select * from tsprog ' +
         ' where cprog=' + g_q + qq.FieldByName( 'hcprog' ).AsString + g_q +
         ' and   cbib=' + g_q + qq.FieldByName( 'hcbib' ).AsString + g_q +
         ' and   cclase=' + g_q + qq.FieldByName( 'hcclase' ).AsString + g_q +
         ' and   sistema=' + g_q + qq.FieldByName( 'sistema' ).AsString + g_q );
   if qq.FieldByName( 'hcclase' ).AsString = 'FIL' then begin
      n := loc1.IndexOf( qq.FieldByName( 'externo' ).AsString );
      if n > -1 then
         x[ k ].organizacion := loc2[ n ];
   end;

   agrega_compo := true;
end;

procedure leecompos( compo: string; bib: string; clase: string; sistema: string;
   slParClases, slParExcluyeMenu, slParClasesExiste: TStringList );
var
   qq: Tadoquery;
   nuevo: boolean;
   cons:string;
begin
   qq := Tadoquery.Create( nil );
   qq.Connection := dm.ADOConnection1;
   cons:= 'select * from tsrela ' +
      ' where pcprog=' + g_q + compo + g_q +
      ' and   pcbib=' + g_q + bib + g_q +
      ' and   pcclase=' + g_q + clase + g_q +
      //' and   sistema=' + g_q + sistema + g_q +
      ' order by orden ';
   lista_selects.Add(cons);
   if dm.sqlselect( qq, cons ) then begin // agregado RGM Liverpool
      while not qq.Eof do begin
         if slParClases.IndexOf( qq.FieldByName( 'hcclase' ).AsString ) > -1 then
            nuevo := agrega_compo( qq, slParClasesExiste )
         else
            nuevo := true;
         if nuevo and ( slParExcluyeMenu.IndexOf( qq.fieldbyname( 'hcprog' ).AsString ) = -1 ) then
            if ( qq.FieldByName( 'coment' ).AsString <> 'LIBRARY' ) then
               leecompos( qq.FieldByName( 'hcprog' ).AsString,
                  qq.FieldByName( 'hcbib' ).AsString,
                  qq.FieldByName( 'hcclase' ).AsString,
                  qq.FieldByName( 'sistema' ).AsString,
                  slParClases, slParExcluyeMenu, slParClasesExiste );
         if qq.FieldByName( 'hcclase' ).AsString = 'LOC' then begin
            loc1.Insert( 0, uppercase( qq.fieldbyname( 'externo' ).AsString ) );
            loc2.insert( 0, qq.fieldbyname( 'organizacion' ).AsString );
         end;
         qq.Next;
      end;
   end;
   qq.Free;
end;

procedure LogicaArmadoLstCompo( tabParDatos: TdxMemData;
   sParSistema, sParClase, sParBib, sParProg: String;
   slParClases, slParExcluyeMenu, slParClasesExiste: TStringList );
var
   sConsulta: String;
begin
   if sParClase = 'SISTEMA' then
      sConsulta :=
         ' SELECT *' +
         ' FROM TSRELA' +
         ' WHERE' +
         '    SISTEMA = ' + g_q + sParProg + g_q
   else
      sConsulta :=
         ' SELECT *' +
         ' FROM TSRELA' +
         ' WHERE' +
         '    HCPROG = ' + g_q + sParProg + g_q +
         '    AND HCBIB = ' + g_q + sParBib + g_q +
         '    AND HCCLASE = ' + g_q + sParClase + g_q;
   //'    AND SISTEMA = ' + g_q + sParSistema + g_q ;

   lista_selects.Add(sConsulta);
   if dm.sqlselect( dm.q1, sConsulta ) then begin

      while not dm.q1.Eof do begin
         agrega_compo( dm.q1, slParClasesExiste );
         leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
            dm.q1.FieldByName( 'hcbib' ).AsString,
            dm.q1.FieldByName( 'hcclase' ).AsString,
            dm.q1.fieldByname( 'sistema' ).AsString,
            slParClases, slParExcluyeMenu, slParClasesExiste );

         dm.q1.Next;
      end;
      if length( x ) > 0 then
         PoblarLstCompo( tabParDatos )
      else begin
         ShowMessage( 'No existe información procesar.' );
      end;
   end;
end;

procedure GlbArmarListaCompo( tabParDatos: TdxMemData;
   sParSistema, sParClase, sParBib, sParProg: String; sParTitulo: String;
   slParClases, slParExcluyeMenu, slParClasesExiste: TStringList );
begin
   SetLength( x, 0 );
   xx := Tstringlist.Create;
   loc1 := Tstringlist.Create;
   loc2 := Tstringlist.Create;
   lista_selects:=TStringList.Create;

   try
      LogicaArmadoLstCompo( tabParDatos,
         sParSistema, sParClase, sParBib, sParProg,
         slParClases, slParExcluyeMenu, slParClasesExiste );

   finally
      xx.Free;
      loc1.Free;
      loc2.Free;
      //lista_selects.SaveToFile(g_tmpdir+'/ALKselectLista_'+sParProg+'.txt');
      lista_selects.Free;
   end;
end;

end.

