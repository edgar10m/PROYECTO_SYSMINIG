unit ufmDocumentacion;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSGrid, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit,
   DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
   dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, ImgList, dxPSCore, dxPScxGridLnk,
   dxBarDBNav, dxmdaset, dxBar, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
   cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC, dxStatusBar,
   StdCtrls,alkReingresaDocto;

type
   TfmDocumentacion = class( TfmSVSGrid )
      mnuDocumento: TdxBarSubItem;
      mnuAbrir: TdxBarButton;
      mnuAgregar: TdxBarButton;
      mnuNuevo: TdxBarButton;
      mnuEliminar: TdxBarButton;
      mnuDescargar: TdxBarButton;
      mnuRevisiones: TdxBarButton;
      mnuVerEliminados: TdxBarButton;
      mnActualizar: TdxBarButton;
      mnReingresa: TdxBarButton;
    dxBarEdit1: TdxBarEdit;
    dxBarSubItem1: TdxBarSubItem;
    dxBarContainerItem1: TdxBarContainerItem;

      procedure mnuAbrirClick( Sender: TObject );
      procedure mnuNuevoClick( Sender: TObject );
      procedure mnuAgregarClick( Sender: TObject );
      procedure mnuEliminarClick( Sender: TObject );
      procedure mnuDescargarClick( Sender: TObject );
      procedure mnuRevisionesClick( Sender: TObject );
//      procedure mnuVerEliminadosClick( Sender: TObject );
    procedure mnReingresaClick(Sender: TObject);
    procedure mnActualizarClick(Sender: TObject);
   private
      { Private declarations }
      sPriClase, sPriBib, sPriProg, sPriSistema: String;

      Por_Actualizar: Integer;   //bandera para indicar cuando se debe actualizar y cuando no   ALK

      procedure PriEliminarConstantes( var sParTexto: String );
   public
      { Public declarations }
      procedure PubGeneraLista( sParClase, sParBib, sParProg, sParSistema: String;
         sParCaption: String );
      function bPubPoblarTabla: Boolean;
      procedure PubHabilitarOpcionesMenu( bParHabilitar: Boolean );
      function nueva_version(doc, prog, bib, cla, ruta_nuevo : String) : Boolean;
   end;

implementation

uses
   ptsdm, ufmSVSEditor, uConstantes, uListaRutinas, ptsgral, ufmDocHistorial,
   cxExportGrid4Link, ShellAPI;

{$R *.dfm}

const
   SIN_PROG = 'SIN_PROG';
   SIN_BIB = 'SIN_BIB';
   SIN_CLASE = 'SIN_CLASE';

procedure TfmDocumentacion.PubGeneraLista( sParClase, sParBib, sParProg, sParSistema : String;
   sParCaption: String );
var
   i: Integer;

   function da_item( nombre:String ):integer;
   var
      i: Integer;
   begin
      for i := 0 to mnuPrincipal.ItemCount - 1 do
         if ( LowerCase( mnuPrincipal.Items[ i ].Name ) = nombre ) then
            Result:=i
   end;
begin
   sPriProg := Trim( sParProg );
   sPriBib := Trim( sParBib );
   sPriClase := Trim( sParClase );
   sPriSistema :=Trim( sParSistema );

   if sPriProg = '' then
      sPriProg := SIN_PROG;

   if sPriBib = '' then
      sPriBib := SIN_BIB;

   if sPriClase = '' then
      sPriClase := SIN_CLASE;

   Caption := sParCaption;
   tabLista.Caption := StringReplace( Caption, sDOCUMENTACION, '', [ rfReplaceAll ] ) + ' ';

   //---Funcion para estandarizar las tablas de estado 'L' a estado 'D'  ALK ----
   dm.sqlupdate('update TSDOCUMENTO set estatus='+ g_q +'D'+ g_q +
                ' where estatus ='+ g_q +'L'+ g_q );
   // --- Comprobar que contenga documentos en estatus U para activar boton -----
   {if dm.sqlselect(dm.q4,'select * from TSDOCUMENTO where' +
                   ' estatus =' + g_q +'U'+ g_q+
                   ' and CPROG = ' + g_q + sPriProg + g_q +
                   ' and CBIB = ' + g_q + sPriBib + g_q +
                   ' and CCLASE = ' + g_q + sPriClase + g_q) then
      //activar boton
      mnuPrincipal.Items[da_item('mnReingresa')].Enabled:=TRUE
   else
      //desactivar boton
      mnuPrincipal.Items[da_item('mnReingresa')].Enabled:=FALSE; }
   // --------------------------------------------------------------------------

   if bPubPoblarTabla then begin
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      PubHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

      GlbCrearCamposGrid( grdDatosDBTableView1 );

      //necesario para la busqueda
      //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
      //if grdEspejoDBTableView1.ItemCount <> 0 then
         grdEspejoDBTableView1.DataController.CreateAllItems;
         
      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      //fin necesario para la busqueda

      with grdDatosDBTableView1 do //crear rutina global para ocultar o mostrar, diccionario de datos
         for i := 0 to ColumnCount - 1 do
            if ( Columns[ i ].DataBinding.FieldName = 'IDDOCTO' ) or
               ( Columns[ i ].DataBinding.FieldName = 'CPROG' ) or
               ( Columns[ i ].DataBinding.FieldName = 'CBIB' ) or
               ( Columns[ i ].DataBinding.FieldName = 'CCLASE' ) then
               Columns[ i ].Visible := False;

      grdDatosDBTableView1.ApplyBestFit( );

      GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );

      tabDatos.ReadOnly := True;
   end;
end;

function TfmDocumentacion.bPubPoblarTabla: Boolean;
var
   sEliminados: String;
begin
   Result := False;

   Screen.Cursor := crSqlWait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros

      sEliminados := '';

      {if mnuVerEliminados.Caption = 'Ver eliminados' then
         sEliminados := ' AND ESTATUS <> ' + g_q + 'E' + g_q
      else
         sEliminados := ' AND ESTATUS = ' + g_q + 'E' + g_q; }

      if ((mnReingresa.Caption = 'Cancelar') and
         (Por_Actualizar = 1)) then
         sEliminados := ' AND ESTATUS = ' + g_q + 'U' + g_q;


      dm.sqlselect( dm.q1, 'SELECT * FROM TSDOCUMENTO ' +
         ' WHERE CPROG = ' + g_q + sPriProg + g_q +
         ' AND CBIB = ' + g_q + sPriBib + g_q +
         ' AND CCLASE = ' + g_q + sPriClase + g_q +
         //' AND ESTATUS <> ' + g_q + 'E' + g_q +
         sEliminados +
         ' ORDER BY NOMBRE' );

      if tabDatos.Active then
         tabDatos.Active := False;

      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );

      if bGlbPoblarTablaMem( dm.q1, tabDatos ) then begin
         tabDatos.First;
         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         Result := True;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocumentacion.mnuAbrirClick( Sender: TObject );
var
   iIDDOCTO: Integer;
   sNOMBRE: String;
   sEXTENSION: String;
   sCPROG, sCBIB, sCCLASE: String;
   sDESCRIPCION: String;

   snomalk, sBlbobalk :String;
   inomalk : integer;

   iIDREVISION: Integer;
   sACTIVO: String;

   fmSVSEditor: TfmSVSEditor;
begin
   inherited;

   Screen.Cursor := crSQLWait;
   try
      if not tabDatos.Active then
         Exit;

      if tabDatos.RecordCount = 0 then
         Exit;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCUMENTO ' +
         'WHERE IDDOCTO = ' + tabDatos.FieldByName( 'IDDOCTO' ).AsString ) then begin
         Application.MessageBox( pchar( 'No exite el documento' ), 'Documento', MB_OK );
         Exit;
      end;

      if dm.q1.fieldbyname( 'ESTATUS' ).AsString = 'E' then begin
         Application.MessageBox( pchar( 'Documento con estatus: Eliminado' ), 'Documento', MB_OK );
         Exit;
      end;

      iIDDOCTO := dm.q1.FieldByName( 'IDDOCTO' ).AsInteger;
      sNOMBRE := dm.q1.FieldByName( 'NOMBRE' ).AsString;
      sEXTENSION := UpperCase( dm.q1.FieldByName( 'EXTENSION' ).AsString );
      sCPROG := dm.q1.FieldByName( 'CPROG' ).AsString;
      sCBIB := dm.q1.FieldByName( 'CBIB' ).AsString;
      sCCLASE := dm.q1.FieldByName( 'CCLASE' ).AsString;
      sDESCRIPCION := dm.q1.FieldByName( 'DESCRIPCION' ).AsString;


      inomalk:=pos(UpperCase(sEXTENSION),UpperCase(sNombre));
      snomalk:= copy (sNombre, 0,inomalk-1);

      if sEXTENSION <> '.RTF' then
         sGlbTitulo := snomalk + ' - ' + sCCLASE + ' ' + sCBIB + ' ' + sCPROG +
                    '_' +formatdatetime( 'YYYYMMDDHHNNSSZZZ', now )+sEXTENSION
      else
         sGlbTitulo := sNOMBRE + ' - ' + sCCLASE + ' ' + sCBIB + ' ' + sCPROG;

      PriEliminarConstantes( sGlbTitulo );

      if gral.bPubVentanaActiva( sGlbTitulo ) then
         Exit;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCREVISION ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' +
         '      ( SELECT MAX( R.IDREVISION )' +
         '        FROM TSDOCREVISION R' +
         '        WHERE R.IDDOCTO = TSDOCREVISION.IDDOCTO )' ) then begin
         Application.MessageBox( pchar( 'No exite el documento en revisión' ), 'Documento', MB_OK );
         Exit;
      end;

      iIDREVISION := dm.q1.FieldByName( 'IDREVISION' ).AsInteger;
      sACTIVO := dm.q1.FieldByName( 'ACTIVO' ).AsString; //indica si el docto esta ativo por otro usuario

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCBLOB ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' + IntToStr( iIDREVISION ) ) then begin
         Application.MessageBox( pchar( 'No exite el documento en tsblob' ), 'Documento', MB_OK );
         Exit;
      end;

      if sEXTENSION = '.RTF' then
         sBlbobalk:= g_tmpdir + '\' + sNOMBRE
      else begin
         sBlbobalk:= g_tmpdir + '\' + sGlbTitulo;
         g_borrar.Add(sBlbobalk);     // para eliminar los documentos de la carpeta tmp  ALK
      end;

      if not dm.bObtenerTSDOCBLOB( iIDDOCTO, iIDREVISION, sBlbobalk ) then begin
         Application.MessageBox( pchar( 'No se puede abrir el documento' ), 'Documento', MB_OK );
         Exit;
      end;

      iGlbIDDocto := iIDDOCTO;
      sGlbCClase := sCCLASE;
      sGlbCBib := sCBIB;
      sGlbCProg := sCPROG;
      sGLbNombre := sNOMBRE;

      if sEXTENSION = '.RTF' then begin
         fmSVSEditor := TfmSVSEditor.Create( Self );
         //fmSVSEditor.Show;
         dm.PubRegistraVentanaActiva( sGlbTitulo );
      end
      else begin
         if ShellExecute( Handle, nil, PChar( g_tmpdir + '\' +sGlbTitulo ), nil, nil, SW_SHOW ) <= 32 then
            Application.MessageBox( PChar( 'No se puede abrir ' + sGlbTitulo + chr( 13 ) +
               'No existe programa asociado al tipo de archivo.' + chr( 13 ) + chr( 13 ) +
               'Puede realizar una descarga con la opción de "Descargar"' ),
               PChar( 'Aviso' ), MB_ICONEXCLAMATION );
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocumentacion.mnuNuevoClick( Sender: TObject );
var
   fmSVSEditor: TfmSVSEditor;
   sTitulo: String;
begin
   inherited;

   if not tabDatos.Active then
      Exit;

   iGlbIDDocto := 0;
   sGlbCClase := sPriClase;
   sGlbCBib := sPriBib;
   sGlbCProg := sPriProg;
   sGlbNombre := '';

   sGlbTitulo := sSIN_TITULO + ' - ' + sGlbCClase + ' ' + sGlbCBib + ' ' + sGlbCProg;

   PriEliminarConstantes( sGlbTitulo );

   if gral.bPubVentanaActiva( sGlbTitulo ) then
      Exit;

   fmSVSEditor := TfmSVSEditor.Create( Self );

   dm.PubRegistraVentanaActiva( sGlbTitulo );
end;

procedure TfmDocumentacion.mnuAgregarClick( Sender: TObject );
var
   sNombreArchivo: String;
   Titulo: String;
   cblob, magic, fecha, tipo: String;

   //// TSDOCUMENTO
   iIDDOCTO: Integer; // NUMBER(9) NOT NULL, -- PK
   sNOMBRE: String; // VARCHAR2(100) NOT NULL, -- IDX1 UNIQUE
   sEXTENSION: String; //VARCHAR2(20) NULL,
   //sFECHA_ALTA: String; //DATE DEFAULT SYSDATE NOT NULL,
   sUSUARIO_ALTA: String; //VARCHAR2(50) NOT NULL,
   sCPROG: String; //VARCHAR2(250) NOT NULL, -- IDX1 UNIQUE
   sCBIB: String; //VARCHAR2(250) NOT NULL, -- IDX1 UNIQUE
   sCCLASE: String; //VARCHAR2(10) NOT NULL, -- IDX1 UNIQUE
   sDESCRIPCION: String; //VARCHAR2(500) NULL,
   //sESTATUS: String; //CHAR(1) DEFAULT 'L' NOT NULL, -- L-libre; O-ocupado; E-eliminado
   //sFECHA_ESTATUS: String; //DATE NULL,
   sUSUARIO_ESTATUS: String; //VARCHAR2(50) NULL

   //// TSDOCREVISION
   iIDREVISION: Integer; // NUMBER(9) NOT NULL, -- PK -- incremental por IDDOCTO
   sUSUARIO_REV: String; // VARCHAR2(50) NOT NULL, -- FK
   //sACTIVO: String; // CHAR(1) DEFAULT 'N' NOT NULL, -- S-si; N-no
   //sFECHA_INICIO DATE NULL,
   //sFECHA_FIN DATE NULL

   //// TSDOCBLOB
   iTAMNORMAL: Integer; // NUMBER(9) NULL, -- tamaño normal en bytes
   iTAMCRC: Integer; // NUMBER(9) NULL, -- tamaño comprimido (rar) en bytes

   bErrorTransaccion: Boolean;

   function bInsertarTSDOCUMENTO: Boolean;
   var
      sInsert: String;
   begin
      iIDDOCTO := dm.iObtenerID( 'TSDOCUMENTO', 0 );

      sInsert := 'INSERT INTO TSDOCUMENTO(' +
         'IDDOCTO, NOMBRE, EXTENSION, USUARIO_ALTA,' +
         'CPROG, CBIB, CCLASE, DESCRIPCION, FECHA_ESTATUS, USUARIO_ESTATUS ) VALUES (' +
         IntToStr( iIDDOCTO ) + ',' +
         g_q + sNOMBRE + g_q + ',' +
         g_q + sEXTENSION + g_q + ',' +
         g_q + sUSUARIO_ALTA + g_q + ',' +
         g_q + sCPROG + g_q + ',' +
         g_q + sCBIB + g_q + ',' +
         g_q + sCCLASE + g_q + ',' +
         g_q + sDESCRIPCION + g_q + ',' +
         'SYSDATE,' +
         g_q + sUSUARIO_ESTATUS + g_q + ')';

      if not dm.sqlinsert( sInsert ) then begin
         Application.MessageBox( 'ERROR... no puede insertar en tsdocumento',
            'Agregar ', MB_OK );
         Result := False;
      end
      else
         Result := True;
   end;

   function bInsertarTSDOCREVISION: Boolean;
   var
      sInsert: String;
   begin
      iIDREVISION := dm.iObtenerID( 'TSDOCREVISION', iIDDOCTO );

      sInsert := 'INSERT INTO TSDOCREVISION(' +
         'IDDOCTO, IDREVISION, USUARIO_REV, FECHA_INICIO, FECHA_FIN ) VALUES (' +
         IntToStr( iIDDOCTO ) + ',' +
         IntToStr( iIDREVISION ) + ',' +
         g_q + sUSUARIO_REV + g_q + ',' +
         'SYSDATE,' +
         'SYSDATE ' + ')';

      if not dm.sqlinsert( sInsert ) then begin
         Application.MessageBox( 'ERROR... no puede insertar en tsdocrevision',
            'Agregar ', MB_OK );
         Result := False;
      end
      else
         Result := True;
   end;

begin
   inherited;

   if not tabDatos.Active then
      Exit;

   sNombreArchivo := sGlbAbrirDialogo; //Abre dialogo para obtener la ruta y nombre de archivo
   if sNombreArchivo = '' then
      Exit;

   if not FileExists( sNombreArchivo ) then begin
      Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
         'Agregar', MB_OK );
      Exit;
   end;

   Screen.Cursor := crSqlWait;
   try
      //TSDOCUMENTO
      sNOMBRE := ExtractFileName( sNombreArchivo );
      sEXTENSION := ExtractFileExt( sNombreArchivo );
      if sEXTENSION = '' then
         sEXTENSION := '.';

      sUSUARIO_ALTA := g_usuario;
      sCPROG := sPriProg;
      sCBIB := sPriBib;
      sCCLASE := sPriClase;
      InputQuery( 'Capture', 'Descripción del documento', sDESCRIPCION ); //sustituir por un dialogo con TMemo

      if Trim( sDESCRIPCION ) = '' then
         sDESCRIPCION := '.';

      sUSUARIO_ESTATUS := g_usuario;

      if dm.bPubDocumentoExiste( sNOMBRE, sCPROG, sCBIB, sCCLASE ) then begin
         case Application.MessageBox( Pchar( 'Nombre de documento existente' + chr( 13 ) +
                  '¿Desea cargar ' + sNOMBRE + chr( 13 ) +
                  'como una nueva version del mismo?'),
                  Pchar( 'Documentacion Externa' ), MB_YesNoCancel+MB_IconQuestion ) of
            ID_YES:
            begin
               if nueva_version(sNOMBRE, sCPROG, sCBIB, sCCLASE, sNombreArchivo) then
                  ShowMessage('Hecho');
               Exit;
            end;
            ID_NO:
            begin
               Application.MessageBox( Pchar( 'No se agrego el documento'),
               Pchar( 'Aviso' ), MB_Ok );
               Exit;
            end;
            ID_CANCEL:
            begin
               Exit;
            end;
         end;
      end;

      dm.ADOConnection1.BeginTrans;
      try
         bErrorTransaccion := False;

         if bInsertarTSDOCUMENTO then begin
            //TSDOCREVISION
            sUSUARIO_REV := g_usuario;
            if bInsertarTSDOCREVISION then begin
               //TSDOCBLOB
               iTAMNORMAL := 0;
               iTAMCRC := 0;

               if not dm.bInsertarTSDOCBLOB(
                  iIDDOCTO, iIDREVISION, iTAMNORMAL, iTAMCRC, sNombreArchivo ) then
                  bErrorTransaccion := True;
            end
            else
               bErrorTransaccion := True;
         end
         else
            bErrorTransaccion := True;

      finally
         if bErrorTransaccion then
            dm.ADOConnection1.RollbackTrans
         else
            dm.ADOConnection1.CommitTrans;
      end;

      if bPubPoblarTabla then begin
         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         PubHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocumentacion.mnuEliminarClick( Sender: TObject );
begin
   inherited;

   if not tabDatos.Active then
      Exit;

   if tabDatos.RecordCount = 0 then
      Exit;

   if tabDatos.FieldByName( 'ESTATUS' ).AsString = 'U' then begin
      ShowMessage('Documento en uso, no se puede eliminar');
      Exit;
   end;

   if Application.MessageBox( pchar( '¿Desea eliminar el registro?' ), 'Confirmar',
      MB_ICONQUESTION OR MB_YESNO ) = IDNO then
      Exit;

   Screen.Cursor := crSqlWait;
   try
      if dm.sqlupdate( 'UPDATE TSDOCUMENTO' +
         ' SET ESTATUS=' + g_q + 'E' + g_q + ',' +
         ' FECHA_ESTATUS=' + 'SYSDATE' + ',' +
         ' USUARIO_ESTATUS=' + g_q + g_usuario + g_q +
         ' WHERE IDDOCTO=' + tabDatos.FieldByName( 'IDDOCTO' ).AsString ) = False then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede eleminar en tsdocumento' ) ),
            pchar( dm.xlng( 'Eliminar documentación' ) ), MB_OK );
         Exit;
      end;

      if bPubPoblarTabla then begin
         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         PubHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocumentacion.mnuDescargarClick( Sender: TObject );
var
   iIDDOCTO: Integer;
   sNOMBRE, sEXT, snomalk: String;
   iIDREVISION, inomalk: Integer;

   sNombreArchivo: String;
begin
   inherited;

   Screen.Cursor := crSQLWait;
   try
      if not tabDatos.Active then
         Exit;

      if tabDatos.RecordCount = 0 then
         Exit;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCUMENTO ' +
         'WHERE IDDOCTO = ' + tabDatos.FieldByName( 'IDDOCTO' ).AsString ) then begin
         Application.MessageBox( pchar( 'No exite el documento' ), 'Documento', MB_OK );
         Exit;
      end;

      if dm.q1.fieldbyname( 'ESTATUS' ).AsString = 'E' then begin
         Application.MessageBox( pchar( 'Documento con estatus: Eliminado' ), 'Documento', MB_OK );
         Exit;
      end;

      iIDDOCTO := dm.q1.FieldByName( 'IDDOCTO' ).AsInteger;
      sNOMBRE := dm.q1.FieldByName( 'NOMBRE' ).AsString;
      sEXT := dm.q1.FieldByName( 'EXTENSION' ).AsString;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCREVISION ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' +
         '      ( SELECT MAX( R.IDREVISION )' +
         '        FROM TSDOCREVISION R' +
         '        WHERE R.IDDOCTO = TSDOCREVISION.IDDOCTO )' ) then begin
         Application.MessageBox( pchar( 'No exite el documento en revisión' ), 'Documento', MB_OK );
         Exit;
      end;

      iIDREVISION := dm.q1.FieldByName( 'IDREVISION' ).AsInteger;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCBLOB ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' + IntToStr( iIDREVISION ) ) then begin
         Application.MessageBox( pchar( 'No exite el documento en tsblob' ), 'Documento', MB_OK );
         Exit;
      end;

      inomalk:=pos(UpperCase(sEXT),UpperCase(sNOMBRE));
      snomalk:= copy (sNOMBRE, 0,inomalk-1);

      sNombreArchivo := sGlbExportarListaDialogo( sEXT, grdDatos, snomalk );
      if sNombreArchivo = '' then
         Exit;

      if AnsiPos(UpperCase(sEXT),UpperCase(sNombreArchivo)) = 0 then     // si no le puso extension o se la quito
         sNombreArchivo:=sNombreArchivo+sEXT;

      if not dm.bObtenerTSDOCBLOB( iIDDOCTO, iIDREVISION, sNombreArchivo ) then begin
         Application.MessageBox( pchar( 'No puedo descargar el documento' ), 'Documento', MB_OK );
         Exit;
      end;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocumentacion.mnuRevisionesClick( Sender: TObject );
var
   fmDocHistorial: TfmDocHistorial;
   sTitulo: String;
   sNOMBRE: String;
   iIDDOCTO: Integer;
   sCPROG, sCBIB, sCCLASE: String;
begin
   inherited;

   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      if not tabDatos.Active then
         Exit;

      if tabDatos.RecordCount = 0 then
         Exit;

      iIDDOCTO := tabDatos.FieldByName( 'IDDOCTO' ).AsInteger;
      sNOMBRE := tabDatos.FieldByName( 'NOMBRE' ).AsString;
      sCPROG := tabDatos.FieldByName( 'CPROG' ).AsString;
      sCBIB := tabDatos.FieldByName( 'CBIB' ).AsString;
      sCCLASE := tabDatos.FieldByName( 'CCLASE' ).AsString;

      sTitulo := sDOCUMENTACION_HIS + ' - ' + sNOMBRE + ' - ' + sCCLASE + ' ' + sCBIB + ' ' + sCPROG;

      PriEliminarConstantes( sTitulo );

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      fmDocHistorial := TfmDocHistorial.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmDocHistorial.Width := g_Width;
         fmDocHistorial.Height := g_Height;
      end;

      fmDocHistorial.PubGeneraLista( iIDDOCTO, sTitulo );

      fmDocHistorial.Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDocumentacion.PriEliminarConstantes( var sParTexto: String );
begin
   sParTexto := StringReplace( sParTexto, SIN_PROG, '', [ rfReplaceAll ] );
   sParTexto := StringReplace( sParTexto, SIN_BIB, '', [ rfReplaceAll ] );
   sParTexto := StringReplace( sParTexto, SIN_CLASE, '', [ rfReplaceAll ] );
end;

procedure TfmDocumentacion.PubHabilitarOpcionesMenu( bParHabilitar: Boolean );
begin
   mnuDocumento.Enabled := True;
   mnuAgregar.Enabled := True;
   mnuNuevo.Enabled := True;
   mnuVerEliminados.Enabled := True;

   mnuEliminar.Enabled := bParHabilitar;
   mnuAbrir.Enabled := bParHabilitar;
   mnuDescargar.Enabled := bParHabilitar;
   mnuRevisiones.Enabled := bParHabilitar;
end;


procedure TfmDocumentacion.mnReingresaClick(Sender: TObject);
var
   grid_reing : TalkGridReingresa;
   sel, nombre_sel : String;

   function reingresa_Documento(): Boolean;
   var
      res : Boolean;
      sIDDOCTO,sNOMBRE,sCPROG,sCBIB,sCCLASE : String;
      sFECHA_ESTATUS,sUSUARIO_ESTATUS,sESTATUS,sRUTA :String;
      cons, sAextension, sAnombre : String;
      sNombreArchivo, sInsert, Wfecha : String;
      iIDDOCTO,iIDREVISION, iTAMNORMAL, iTAMCRC: Integer;
   begin
     inherited;
      res := False;

      {if Por_Actualizar <> 1 then
         exit;    }

      if Reingresar.Count < 8 then
         exit;

      sIDDOCTO:=Reingresar[0];
      iIDDOCTO:=StrToInt(sIDDOCTO);
      sNOMBRE:=Reingresar[1];
      sCPROG:=Reingresar[2];
      sCBIB:=Reingresar[3];
      sCCLASE:=Reingresar[4];
      sFECHA_ESTATUS:=Reingresar[5];
      sUSUARIO_ESTATUS:=Reingresar[6];
      sESTATUS:=Reingresar[7];
      sRUTA:=Reingresar[8];

      if sUSUARIO_ESTATUS <> g_usuario then   // Para revisar que el usuario que lo actualiza es el mismo que lo solicito
         exit;

      cons:='select * from TSDOCUMENTO where ' +
            ' CPROG = ' + g_q + sCPROG + g_q +
            ' AND CBIB = ' + g_q + sCBIB + g_q +
            ' AND CCLASE = ' + g_q + sCCLASE + g_q +
            ' AND NOMBRE = ' + g_q + sNOMBRE + g_q +
            ' AND IDDOCTO = ' + g_q + sIDDOCTO + g_q;
      // --  Si existe el documento que el usuario selecciono --
      if not dm.sqlselect(dm.q2, cons) then
         exit;

      //abrir el cuadro de dialogo para que seleccione el archivo a sustituir
      if sRUTA <> '' then
         sNombreArchivo := sGlbAbrirDialogoRuta(sRUTA) //Abre dialogo en la ruta donde esta guardado
      else
         sNombreArchivo := sGlbAbrirDialogo;

      if sNombreArchivo = '' then
         exit;

      if LowerCase(ExtractFileName( sNombreArchivo ))<> LowerCase(sNOMBRE) then begin
         //ShowMessage('El archivo seleccionado no tiene el mismo nombre');
         Application.MessageBox( pChar( 'El archivo seleccionado no tiene el mismo nombre' + chr( 13 ) +
                     'Se esperaba el archivo: ' +  alksReingresaDoctoExterna + chr( 13 ) +
                     'En caso de ser un archivo nuevo, puede utilizar' + chr( 13 ) +
                     'la opcion "Agregar Documento" en la ventana principal' + chr( 13 ) +
                     'de la Documentacion Externa'),
            'Documentacion Externa', MB_OK );
         nombre_sel:='***';
         // ---- Volver a mostrar el cuadro de dialogo?? ----
         exit;
      end;

      if not FileExists( sNombreArchivo ) then begin
         Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
            'Agregar', MB_OK );
         Exit;
      end;

      Screen.Cursor := crSqlWait;
      try
         sAnombre := ExtractFileName( sNombreArchivo );
         sAextension := ExtractFileExt( sNombreArchivo );
         if sAextension = '' then
            sAextension := '.';

         // ------ Actualizar el estatus del documento
         Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
         if not dm.sqlupdate('UPDATE TSDOCUMENTO SET '+
                      ' estatus='+ g_q +'D'+ g_q +
                      ', FECHA_ESTATUS='+ Wfecha +
                      ', USUARIO_ESTATUS='+ g_q + '' + g_q +
                      ', RUTA=' + g_q + '' + g_q +
                      ' WHERE CPROG = ' + g_q + sCPROG + g_q +
                      ' AND CBIB = ' + g_q + sCBIB + g_q +
                      ' AND CCLASE = ' + g_q + sCCLASE + g_q +
                      ' AND NOMBRE = ' + g_q + sNOMBRE + g_q) then
            Application.MessageBox( 'ERROR... no se pudo actualizar en tsdocumento','Actualizar ', MB_OK );

         // ------ Actualizar la version
         iIDREVISION := dm.iObtenerID( 'TSDOCREVISION', iIDDOCTO );

         sInsert := 'INSERT INTO TSDOCREVISION(' +
            'IDDOCTO, IDREVISION, USUARIO_REV, FECHA_INICIO, FECHA_FIN ) VALUES (' +
            IntToStr( iIDDOCTO ) + ',' +
            IntToStr( iIDREVISION ) + ',' +
            g_q + sUSUARIO + g_q + ',' +
            'SYSDATE,' +
            'SYSDATE ' + ')';

         if not dm.sqlinsert( sInsert ) then
            Application.MessageBox( 'ERROR... no pudo actualizar en tsdocrevision','Actualizar ', MB_OK );


         // ------ Actualizar la base de datos para guardar el documento
         iTAMNORMAL := 0;
         iTAMCRC := 0;

         if not dm.bInsertarTSDOCBLOB(iIDDOCTO, iIDREVISION, iTAMNORMAL, iTAMCRC, sNombreArchivo ) then
            Application.MessageBox( 'ERROR... no pudo Actualizar el documento','Actualizar ', MB_OK );


         // ------ Repintar la tabla ------------
         if bPubPoblarTabla then begin
            GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
            PubHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

            GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
            GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
         end;

      finally
         Screen.Cursor := crDefault;
      end;
      res := True;
      Result:=res;
   end;
begin
   inherited;
    grid_reing := TalkGridReingresa.Create(self);

    sel:= 'select IDDOCTO as IdDoc, NOMBRE as Nombre, CPROG as Componente,' +
          ' CBIB as Biblioteca, CCLASE as Clase, FECHA_ESTATUS as Fecha,' +
          ' USUARIO_ESTATUS as Usuario, ESTATUS as Estatus, RUTA as Ruta' +
          ' from TSDOCUMENTO '+
          ' where USUARIO_ESTATUS = ' + g_q + g_usuario + g_q +
          ' AND CPROG = ' + g_q + sPriProg + g_q +
          ' AND CBIB = ' + g_q + sPriBib + g_q +
          ' AND CCLASE = ' + g_q + sPriClase + g_q +
          ' AND ESTATUS = ' + g_q + 'U' + g_q;

    alkReingDoctoExterna:=0;

    grid_reing.llena_grid(sel);

    if alkReingDoctoExterna = 0 then    // si no tiene registros se sale
       Exit;

    Reingresar:=TStringList.Create;

    try
       grid_reing.ShowModal;
    finally
       grid_reing.Free;
    end;

{    if ((alkReingDoctoExterna = 1) and (Reingresar.Count > 0)) then
       grid_reing.valor.Free; }
       nombre_sel:='';  //limpiar para verificar que ingrese el nombre del archivo correcto.

       if reingresa_Documento() then
          ShowMessage('Actualizado con exito')
       else begin
          if nombre_sel <> '***' then     // si fue un error diferente al nombre diferente
             ShowMessage('Error al Actualizar');
       end;

    Reingresar.Free;
end;

procedure TfmDocumentacion.mnActualizarClick(Sender: TObject);
var
   iIDDOCTO: Integer;
   sNOMBRE,sUSUARIO,sCPROG,sCBIB,sCCLASE,Wfecha : String;
   sRuta, sExt, sNomSinExt, sUserUso, sFechaUso : String;
   iIDREVISION, iNomSinExt: Integer;

   sNombreArchivo: String;
begin
  inherited;
   Screen.Cursor := crSQLWait;
   try
      if not tabDatos.Active then
         Exit;

      if tabDatos.RecordCount = 0 then
         Exit;

      // --  obtener datos --
      sUSUARIO := g_usuario;
      sCPROG := sPriProg;
      sCBIB := sPriBib;
      sCCLASE := sPriClase;


      if not dm.sqlselect( dm.q1, 'SELECT * FROM TSDOCUMENTO ' +
         'WHERE IDDOCTO = ' + tabDatos.FieldByName( 'IDDOCTO' ).AsString ) then begin
         Application.MessageBox( pchar( 'No exite el documento' ), 'Documento', MB_OK );
         Exit;
      end;

      if dm.q1.fieldbyname( 'ESTATUS' ).AsString <> 'D' then begin
         sUserUso:=dm.q1.fieldbyname( 'USUARIO_ESTATUS' ).AsString;
         sFechaUso:=dm.q1.fieldbyname( 'FECHA_ESTATUS' ).AsString;

         if dm.q1.fieldbyname( 'ESTATUS' ).AsString = 'U' then
            Application.MessageBox( pchar( 'Documento no Disponible (U)' + chr( 13 ) +
                                   'Solicitado por: '+ sUserUso + chr( 13 ) +
                                   'En la fecha:' + sFechaUso), 'Documento', MB_OK )
         else
            Application.MessageBox( pchar( 'Documento eliminado (E)'), 'Documento', MB_OK );

         Exit;
      end;

      iIDDOCTO := dm.q1.FieldByName( 'IDDOCTO' ).AsInteger;
      sNOMBRE := dm.q1.FieldByName( 'NOMBRE' ).AsString;
      sRuta:=dm.q1.FieldByName( 'RUTA' ).AsString;
      sExt:=dm.q1.FieldByName( 'EXTENSION' ).AsString;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCREVISION ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' +
         '      ( SELECT MAX( R.IDREVISION )' +
         '        FROM TSDOCREVISION R' +
         '        WHERE R.IDDOCTO = TSDOCREVISION.IDDOCTO )' ) then begin
         Application.MessageBox( pchar( 'No exite el documento en revisión' ), 'Documento', MB_OK );
         Exit;
      end;

      iIDREVISION := dm.q1.FieldByName( 'IDREVISION' ).AsInteger;

      if not dm.sqlselect( dm.q1, 'SELECT * ' +
         'FROM TSDOCBLOB ' +
         'WHERE IDDOCTO = ' + IntToStr( iIDDOCTO ) +
         '   AND IDREVISION =' + IntToStr( iIDREVISION ) ) then begin
         Application.MessageBox( pchar( 'No exite el documento en tsblob' ), 'Documento', MB_OK );
         Exit;
      end;

      iNomSinExt:=pos(UpperCase(sExt),UpperCase(sNOMBRE));
      sNomSinExt:= copy (sNOMBRE, 0,iNomSinExt-1);

      //sNombreArchivo := sGlbGuardarDialogo(sExt,sNomSinExt);
      sNombreArchivo := sGlbExportarListaDialogo( sExt, grdDatos, sNomSinExt );
      if sNombreArchivo = '' then
         Exit;

      if AnsiPos(UpperCase(sExt),UpperCase(sNombreArchivo)) = 0 then     // si no le puso extension o se la quito
         sNombreArchivo:=sNombreArchivo+sEXT;

      // -- Guardar la ruta que eligio el usuario para bajar el archivo --
      sRuta:=sNombreArchivo;

      if not dm.bObtenerTSDOCBLOB( iIDDOCTO, iIDREVISION, sNombreArchivo ) then begin
         Application.MessageBox( pchar( 'No puedo descargar el documento' ), 'Documento', MB_OK );
         Exit;
      end;

      Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
      //---  Modificar el status y el usuario que esta ocupando el documento ---
      dm.sqlupdate('UPDATE TSDOCUMENTO SET '+
                   ' estatus='+ g_q +'U'+ g_q +
                   ', FECHA_ESTATUS='+ Wfecha +
                   ', USUARIO_ESTATUS='+ g_q + sUSUARIO + g_q +
                   ', RUTA=' + g_q + sRuta + g_q +
                   ' WHERE CPROG = ' + g_q + sCPROG + g_q +
                   ' AND CBIB = ' + g_q + sCBIB + g_q +
                   ' AND CCLASE = ' + g_q + sCCLASE + g_q +
                   ' AND NOMBRE = ' + g_q + sNOMBRE + g_q +
                   ' AND EXTENSION = ' + g_q + sExt + g_q);

      PubGeneraLista( sCCLASE, sCBIB, sCPROG, sPriSistema, Caption );

   finally
      Screen.Cursor := crDefault;
   end;
end;


function TfmDocumentacion.nueva_version(doc, prog, bib, cla, ruta_nuevo: String) : Boolean;
var
   res : Boolean;
   sESTATUS, sEstRev :String;
   cons, sAextension, sAnombre : String;
   sNombreArchivo, sInsert, Wfecha : String;
   iIDDOCTO,iIDREVISION, iTAMNORMAL, iTAMCRC: Integer;
begin
   res := False;
   cons:='select * from TSDOCUMENTO where ' +
         ' CPROG = ' + g_q + prog + g_q +
         ' AND CBIB = ' + g_q + bib + g_q +
         ' AND CCLASE = ' + g_q + cla + g_q +
         ' AND NOMBRE = ' + g_q + doc + g_q;
   if dm.sqlselect(dm.q2, cons) then begin
      sESTATUS:= dm.q2.FieldByName( 'ESTATUS' ).AsString;
      iIDDOCTO:= dm.q1.FieldByName( 'IDDOCTO' ).AsInteger;
   end;
   // comprobar que no este en uso el documento
   if sESTATUS = 'U' then begin
      ShowMessage ('Documento en uso');
      Exit;
   end;

   // ------ Actualizar el estatus del documento
   Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
   if not dm.sqlupdate('UPDATE TSDOCUMENTO SET '+
                   ' estatus='+ g_q +'D'+ g_q +
                   ', FECHA_ESTATUS='+ Wfecha +
                   ' WHERE CPROG = ' + g_q + prog + g_q +
                   ' AND CBIB = ' + g_q + bib + g_q +
                   ' AND CCLASE = ' + g_q + cla + g_q +
                   ' AND NOMBRE = ' + g_q + doc + g_q) then
      Application.MessageBox( 'ERROR... no se pudo actualizar en tsdocumento','Actualizar ', MB_OK );

   // ------ Actualizar la version
   iIDREVISION := dm.iObtenerID( 'TSDOCREVISION', iIDDOCTO );

   if sESTATUS = 'D' then begin
      sInsert := 'INSERT INTO TSDOCREVISION(' +
         'IDDOCTO, IDREVISION, USUARIO_REV, ACTIVO, FECHA_INICIO, FECHA_FIN ) VALUES (' +
         IntToStr( iIDDOCTO ) + ',' +
         IntToStr( iIDREVISION ) + ',' +
         g_q + g_usuario + g_q + ',' +
         g_q + 'A' + g_q + ',' +
         'SYSDATE,' +
         'SYSDATE ' + ')';
   end
   else
      sInsert := 'INSERT INTO TSDOCREVISION(' +
         'IDDOCTO, IDREVISION, USUARIO_REV, FECHA_INICIO, FECHA_FIN ) VALUES (' +
         IntToStr( iIDDOCTO ) + ',' +
         IntToStr( iIDREVISION ) + ',' +
         g_q + g_usuario + g_q + ',' +
         'SYSDATE,' +
         'SYSDATE ' + ')';

   if not dm.sqlinsert( sInsert ) then
      Application.MessageBox( 'ERROR... no pudo actualizar en tsdocrevision','Actualizar ', MB_OK );

   // ------ Actualizar la base de datos para guardar el documento
   iTAMNORMAL := 0;
   iTAMCRC := 0;

   if not dm.bInsertarTSDOCBLOB(iIDDOCTO, iIDREVISION, iTAMNORMAL, iTAMCRC, ruta_nuevo ) then
      Application.MessageBox( 'ERROR... no pudo Actualizar el documento','Actualizar ', MB_OK );

   if bPubPoblarTabla then begin
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      PubHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
   end;
   res:=true;
end;

end.

