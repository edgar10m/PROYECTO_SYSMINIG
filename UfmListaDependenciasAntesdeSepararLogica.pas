unit UfmListaDependencias;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Printers,
   Dialogs, ufmSVSLista, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
   dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, StdCtrls, ExtCtrls, cxGridTableView,
   ImgList, dxPSCore, dxPScxGridLnk, dxBarDBNav, dxmdaset, dxBar, cxGridLevel, cxClasses,
   cxControls, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView, cxGrid, cxPC,
   cxEditRepositoryItems, ADODB, StrUtils, HTML_HELP, dxStatusBar;

type
   rDetalle = record
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
type
   rTotal = record
      clase: string;
      total: integer;
   end;

type
   TfmListaDependencias = class( TfmSVSLista )
      GroupBox1: TGroupBox;
      Shape1: TShape;
      cmbnom: TComboBox;
      Panel5: TPanel;
      Label3: TLabel;
      Label1: TLabel;
      Label2: TLabel;
      lbltotal: TLabel;
      cmbclase: TComboBox;
      cmblibreria: TComboBox;
      cmbmascara: TComboBox;
      lstcomponente: TListBox;
      Splitter1: TSplitter;
      procedure FormCreate( Sender: TObject );
      procedure cmbclaseChange( Sender: TObject );
      procedure cmblibreriaChange( Sender: TObject );
      procedure bClick( Sender: TObject );
      procedure lstcomponenteClick( Sender: TObject );
      procedure lstcomponenteClickSistema( sistema: string );
      procedure cmbmascaraChange( Sender: TObject );
      procedure Acercade1Click( Sender: TObject );
      procedure Salir1Click( Sender: TObject );
      procedure CreaWeb( );
      procedure webBeforeNavigate2( Sender: TObject; const pDisp: IDispatch;
         var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
         var Cancel: WordBool );
      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure webProgressChange( Sender: TObject; Progress,
         ProgressMax: Integer );
      procedure FormDeactivate( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure grdDatosDBTableView1DblClick( Sender: TObject );
      procedure grdDatosDBTableView1FocusedRecordChanged(
         Sender: TcxCustomGridTableView; APrevFocusedRecord,
         AFocusedRecord: TcxCustomGridRecord;
         ANewItemRecordFocusingChanged: Boolean );
   private
      { Private declarations }
      erClase: TcxEditRepository; //framirez
      edClaseTypeImageCombo: TcxEditRepositoryImageComboBoxItem; //framirez
      imClaseTypes: TImageList; //framirez
      clases: Tstringlist; //framirez
      clasesexiste: Tstringlist; //framirez
      aTotal: array of rTotal;
      bitmap: Tbitmap;
      lin, iy: integer;
      b_impresion: boolean;
      Opciones: Tstringlist;

      procedure leecompos( compo: string; bib: string; clase: string );
      function agrega_compo( qq: Tadoquery ): boolean;
   public
      { Public declarations }
      titulo: string;
      procedure arma3( clase: string; bib: string; nombre: string );
   end;

var
   fmListaDependencias: TfmListaDependencias;
   Wprog, Wbib, Wclase: String;
   aDetalle: array of rDetalle;
   f_top: integer;
   f_left: integer;
   WnomLogo: string;
   Wfecha: string;
   W_nomcomponente: string;
   v_compo: string;
   v_bib: string;
   v_clase: string;
   clases: Tstringlist;
   clasesexiste: Tstringlist;
   slCtrExiste: Tstringlist;
   loc1, loc2: Tstringlist;
   excluyemenu: Tstringlist;
   g_nivel: Integer;
   Wciclado: String;

procedure PR_LISTADependencias;
implementation

uses ptsdm, facerca, ptsgral, ptsmain, uListaRutinas, uConstantes;

{$R *.dfm}

procedure PR_LISTADependencias;
begin
   gral.PubMuestraProgresBar( True );
   try
      FmListaDependencias.cmbclase.ItemIndex := FmListaDependencias.cmbclase.Items.IndexOf( '' );
      FmListaDependencias.cmbclaseChange( FmListaDependencias.cmbclase );
      FmListaDependencias.cmblibreria.ItemIndex := FmListaDependencias.cmblibreria.Items.IndexOf( '' );
      FmListaDependencias.cmblibreriaChange( FmListaDependencias.cmblibreria );
      FmListaDependencias.cmbmascara.ItemIndex := FmListaDependencias.cmbmascara.Items.IndexOf( '%' );
      FmListaDependencias.cmbmascaraChange( FmListaDependencias.cmbmascara );
      FmListaDependencias.lstcomponente.ItemIndex := FmListaDependencias.lstcomponente.Items.IndexOf( '' );
      FmListaDependencias.lstcomponenteClick( FmListaDependencias.lstcomponente );
      FmListaDependencias.Show;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TFmListaDependencias.arma3( clase: string; bib: string; nombre: string );
begin
   inherited;

   gral.PubMuestraProgresBar( True );
   bgral := clase + ' ' + bib + ' ' + nombre;
   try
      caption := titulo;
      //tabLista.Caption := titulo;

      GroupBox1.Visible := false;
      if nombre = 'SCRATCH' then
         abort;
      W_nomcomponente := nombre;
      if clase = 'SISTEMA' then begin
         lstcomponenteClickSistema( nombre );
      end
      else begin
         cmbclase.ItemIndex := cmbclase.Items.IndexOf( clase );
         cmbclaseChange( cmbclase );
         cmblibreria.ItemIndex := cmblibreria.Items.IndexOf( bib );
         cmblibreriaChange( cmblibreria );
         //cmbmascara.ItemIndex := cmbmascara.Items.IndexOf( copy( nombre, 1, 2 ) + '%' );
         cmbmascara.ItemIndex := cmbmascara.Items.IndexOf( '%' + ( copy( nombre, 1, 2 ) + '%' ) );
         cmbmascaraChange( cmbmascara );
         lstcomponente.ItemIndex := lstcomponente.Items.IndexOf( nombre );
         lstcomponenteClick( lstcomponente );
      end;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmListaDependencias.Acercade1Click( Sender: TObject );
begin
   inherited;

   PR_ACERCA;
end;

function TfmListaDependencias.agrega_compo( qq: Tadoquery ): boolean;
var
   cc, mensaje: string;
   k, n: integer;
begin
   inherited;
   //qq.RecordCount
   cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
      qq.FieldByName( 'ocprog' ).AsString + '|' +
      qq.FieldByName( 'ocbib' ).AsString + '|' +
      qq.FieldByName( 'occlase' ).AsString + '|' +
      qq.FieldByName( 'pcprog' ).AsString + '|' +
      qq.FieldByName( 'pcbib' ).AsString + '|' +
      qq.FieldByName( 'pcclase' ).AsString + '|' +
      qq.FieldByName( 'hcprog' ).AsString + '|' +
      qq.FieldByName( 'hcbib' ).AsString + '|' +
      qq.FieldByName( 'hcclase' ).AsString;

   slCtrExiste.Add( cc );
   k := length( aDetalle );
   setlength( aDetalle, k + 1 );
   mensaje := 'x=' + inttostr( k ) + '  ' + cc;
   aDetalle[ k ].nivel := g_nivel;
   aDetalle[ k ].nombreo := qq.FieldByName( 'ocprog' ).AsString;
   aDetalle[ k ].bibo := qq.FieldByName( 'ocbib' ).AsString;
   aDetalle[ k ].claseo := qq.FieldByName( 'occlase' ).AsString;
   aDetalle[ k ].nombrep := qq.FieldByName( 'pcprog' ).AsString;
   aDetalle[ k ].bibp := qq.FieldByName( 'pcbib' ).AsString;
   aDetalle[ k ].clasep := qq.FieldByName( 'pcclase' ).AsString;
   aDetalle[ k ].nombre := qq.FieldByName( 'hcprog' ).AsString + trim( Wciclado );
   aDetalle[ k ].bib := qq.FieldByName( 'hcbib' ).AsString;
   aDetalle[ k ].clase := qq.FieldByName( 'hcclase' ).AsString;
   aDetalle[ k ].modo := qq.FieldByName( 'modo' ).AsString;
   aDetalle[ k ].organizacion := qq.FieldByName( 'organizacion' ).AsString;
   aDetalle[ k ].externo := qq.FieldByName( 'externo' ).AsString;
   aDetalle[ k ].coment := qq.FieldByName( 'coment' ).AsString;
   if clasesexiste.IndexOf( aDetalle[ k ].clase ) > -1 then
      aDetalle[ k ].existe := dm.sqlselect( dm.q2, 'select * from tsprog ' +
         ' where cprog=' + g_q + qq.FieldByName( 'hcprog' ).AsString + g_q +
         ' and   cbib=' + g_q + qq.FieldByName( 'hcbib' ).AsString + g_q +
         ' and   cclase=' + g_q + qq.FieldByName( 'hcclase' ).AsString + g_q );
   if qq.FieldByName( 'hcclase' ).AsString = 'FIL' then begin
      n := loc1.IndexOf( qq.FieldByName( 'externo' ).AsString );
      if n > -1 then
         aDetalle[ k ].organizacion := loc2[ n ];
   end;

   agrega_compo := true;
end;

function TfmListaDependencias.ArmarOpciones( b1: Tstringlist ): integer;
var
   slNomCompo: Tstringlist;
begin
   inherited;

   slNomCompo := Tstringlist.Create;
   slNomCompo.CommaText := bgral;

   if slNomCompo.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Lista opciones ' ) ), MB_OK );
      slNomCompo.free;
      exit;
   end;

   gral.EjecutaOpcionB( b1, 'Lista Componentes' );
   slNomCompo.free;
end;

procedure TfmListaDependencias.bClick( Sender: TObject );
var
   arch: string;
   i: integer;
begin
   inherited;

   gral.BorraIconosTmp( );
   arch := g_tmpdir + g_tmpdir + '\LD' + W_nomcomponente + '.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + g_tmpdir + '\LD' + W_nomcomponente + 'IMP.html';
   g_borrar.Add( arch );
   close;
end;

procedure TfmListaDependencias.cmbclaseChange( Sender: TObject );
begin
   inherited;

   gral.ActivaSoloClasesUsadas;
   dm.feed_combo( cmblibreria, 'select distinct cbib from tsprog ' +
      ' where cclase=' + g_q + cmbclase.Text + g_q +
      ' order by cbib' );
end;

procedure TfmListaDependencias.cmblibreriaChange( Sender: TObject );
begin
   inherited;

   screen.Cursor := crsqlwait;
   dm.feed_combo( cmbmascara, 'select distinct substr(hcprog,1,2)||' + g_q + '%' + g_q + ' from tsrela ' +
      ' where hcclase=' + g_q + cmbclase.Text + g_q +
      ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
      ' order by 1' );
   cmbmascara.Items.Insert( 0, '%' );
   lstcomponente.Items.Clear;
   screen.Cursor := crdefault;
end;

procedure TfmListaDependencias.cmbmascaraChange( Sender: TObject );
begin
   inherited;

   gral.PubMuestraProgresBar( TRUE );
   try
      screen.Cursor := crsqlwait;
      lstcomponente.Items.Clear;
      if ( cmbmascara.Text = '%' ) or
         ( cmbmascara.Text = '' ) then begin
         if dm.sqlselect( dm.q1, 'select distinct hcprog from tsrela ' +
            ' where hcclase=' + g_q + cmbclase.Text + g_q +
            ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
            ' order by hcprog' ) then begin
            while not dm.q1.Eof do begin
               lstcomponente.Items.Add( dm.q1.fieldbyname( 'hcprog' ).AsString );
               dm.q1.Next;
            end;
         end;
      end
      else begin
         if dm.sqlselect( dm.q1, 'select distinct hcprog from tsrela ' +
            ' where hcclase=' + g_q + cmbclase.Text + g_q +
            ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
            ' and   hcprog like ' + g_q + cmbmascara.Text + g_q +
            ' order by hcprog' ) then begin
            while not dm.q1.Eof do begin
               lstcomponente.Items.Add( dm.q1.fieldbyname( 'hcprog' ).AsString );
               dm.q1.Next;
            end;
         end;
      end;
      lbltotal.Caption := 'Total: ' + inttostr( dm.q1.RecordCount );
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmListaDependencias.CreaWeb;
var
   i, j: integer;
   sPass: string;
   slDatos: Tstringlist;
   iMiIcon: TIcon;
   AField: TField;
   aClases: array of string;
begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
      slDatos := Tstringlist.create;
      slDatos.Delimiter := ',';
      slDatos.Add( 'nivel:Integer:0,' +
         'clase:String:20,bib:String:250,nombre:String:250,modo:String:20,' +
         'organizacion:String:30,externo:String:50,coment:String:200,' +
         'existe:Boolean:0' );

      tabLista.Caption := sLISTA_DEPENDENCIAS + ' ' + Wclase + ' ' + Wbib + ' ' + Wprog; //framirez

      for i := 0 to length( aDetalle ) - 1 do begin
         if aDetalle[ i ].existe then
            sPass := 'true'
         else
            sPass := 'false';

         slDatos.Add( '"' + IntToStr( aDetalle[ i ].nivel ) + '",' +
            '"' + aDetalle[ i ].clase + '",' +
            '"' + aDetalle[ i ].bib + '",' +
            '"' + aDetalle[ i ].nombre + '",' +
            '"' + aDetalle[ i ].modo + '",' +
            '"' + aDetalle[ i ].organizacion + '",' +
            '"' + aDetalle[ i ].externo + '",' +
            '"' + aDetalle[ i ].coment + '",' +
            '"' + sPass + '"' );

         if not AnsiMatchStr( aDetalle[ i ].clase, aClases ) then begin
            SetLength( aClases, Length( aClases ) + 1 );
            aClases[ Length( aClases ) - 1 ] := aDetalle[ i ].clase;
         end;
      end;

      GlbCreateImageRepository( erClase, imClaseTypes, edClaseTypeImageCombo, g_tmpdir, aClases, false );

      SetLength( aDetalle, 0 );

      if tabDatos.Active then
         tabDatos.Active := False;

      if bGlbPoblarTablaMem( slDatos, tabDatos ) then begin
         tabDatos.ReadOnly := True;

         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         GlbCrearCamposGrid( grdDatosDBTableView1 );

         grdDatosDBTableView1.ApplyBestFit( );

         for i := 0 to grdDatosDBTableView1.ColumnCount - 1 do begin
            if grdDatosDBTableView1.Columns[ i ].Caption = 'nivel' then
               grdDatosDBTableView1.Columns[ i ].ApplyBestFit;

            if grdDatosDBTableView1.Columns[ i ].Caption = 'clase' then begin
               grdDatosDBTableView1.Columns[ i ].RepositoryItem := edClaseTypeImageCombo;
               grdDatosDBTableView1.Columns[ i ].ApplyBestFit;
            end;
         end;

         //necesario para la busqueda
         //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
         GlbCrearCamposGrid( grdEspejoDBTableView1 );
         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         //fin necesario para la busqueda

         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         if Visible = True then
            GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmListaDependencias.FormActivate( Sender: TObject );
begin
   inherited;

   iHelpContext := IDH_TOPIC_T02800;
end;

procedure TfmListaDependencias.FormClose( Sender: TObject;
   var Action: TCloseAction );
var
   arch: string;
   i: integer;
begin
   inherited;

   bitmap.Free;
   edClaseTypeImageCombo.Free;
   imClaseTypes.Free;
   erClase.Free;
end;

procedure TfmListaDependencias.FormCreate( Sender: TObject );
begin
   inherited;

   SetLength( aGLBTsrela, 0 ); //para controlar los repetidos, futuro corto ajustar rutinas de taladreo

   dm.feed_combo( cmbclase, 'select unique pcclase from tsrela , tsclase where cclase = pcclase and estadoactual =' +
      g_q + 'ACTIVO' + g_q + ' and hcbib <> ' + g_q + 'BD' + g_q + ' order by pcclase' );

   clases := Tstringlist.Create;
   clasesexiste := Tstringlist.Create;
   slCtrExiste := Tstringlist.Create;
   loc1 := Tstringlist.Create;
   loc2 := Tstringlist.Create;
   bitmap := Tbitmap.Create;

   if dm.sqlselect( dm.q1, 'select unique hcclase from tsrela , tsclase where cclase = hcclase and estadoactual =' +
      g_q + 'ACTIVO' + g_q + ' order by hcclase' ) then begin

      while not dm.q1.Eof do begin
         clases.Add( dm.q1.fieldbyname( 'hcclase' ).AsString );
         dm.q1.Next;
      end;
   end;

   clasesexiste.AddStrings( clases );
   excluyemenu := Tstringlist.Create;

   if dm.sqlselect( dm.q1, 'select dato from parametro where clave=' + g_q + 'EXCLUYEMENU' + g_q ) then begin
      while not dm.q1.Eof do begin
         excluyemenu.Add( dm.q1.fieldbyname( 'dato' ).AsString );
         dm.q1.Next;
      end;
   end;

   Wfecha := formatdatetime( 'YYYYMMDDHHMMSSZZZZ', now );
   WnomLogo := 'LD' + Wfecha;
   gral.CargaLogo( WnomLogo );
   gral.CargaIconosBasicos( );
   gral.CargaIconosClases( );

   imClaseTypes := TImageList.Create( Self );
   erClase := TcxEditRepository.Create( Self );
   edClaseTypeImageCombo := TcxEditRepositoryImageComboBoxItem.Create( erClase );
   edClaseTypeImageCombo.Properties.Images := imClaseTypes;
end;

procedure TfmListaDependencias.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

procedure TfmListaDependencias.leecompos( compo, bib, clase: string );
var
   qq: Tadoquery;
   nuevo, bexiste: boolean;
   bRepetido: Boolean;
   cc: String;

   Indicex, Indicey, Indicez, Wsale, i1, g_nivel0: integer;

begin
   inherited;

   bRepetido := bGlbRepetidoTsrela( compo, bib, clase );
   //   bRepetido := false;

   if not bRepetido then begin
      GlbRegistraArregloTsrela( compo, bib, clase );

      qq := Tadoquery.Create( self );
      try
         qq.Connection := dm.ADOConnection1;
         if dm.sqlselect( qq, 'select * from tsrela ' +
            ' where pcprog=' + g_q + compo + g_q +
            ' and   pcbib=' + g_q + bib + g_q +
            ' and   pcclase=' + g_q + clase + g_q ) then begin
            while not qq.Eof do begin
               bexiste := false;
               nuevo := false;
               cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
                  qq.FieldByName( 'ocprog' ).AsString + '|' +
                  qq.FieldByName( 'ocbib' ).AsString + '|' +
                  qq.FieldByName( 'occlase' ).AsString + '|' +
                  qq.FieldByName( 'pcprog' ).AsString + '|' +
                  qq.FieldByName( 'pcbib' ).AsString + '|' +
                  qq.FieldByName( 'pcclase' ).AsString + '|' +
                  qq.FieldByName( 'hcprog' ).AsString + '|' +
                  qq.FieldByName( 'hcbib' ).AsString + '|' +
                  qq.FieldByName( 'hcclase' ).AsString;
               if slCtrExiste.IndexOf( cc ) > -1 then
                  bexiste := True
               else
                  bexiste := False;
               if clases.IndexOf( qq.FieldByName( 'hcclase' ).AsString ) > -1 then begin
                  g_nivel := g_nivel + 1;
                  if g_nivel = 1 then begin
                     v_clase := qq.FieldByName( 'hcclase' ).AsString;
                     v_bib := qq.FieldByName( 'hcbib' ).AsString;
                     v_compo := qq.FieldByName( 'hcprog' ).AsString;
                  end;
                  nuevo := agrega_compo( qq );
               end
               else
                  nuevo := true;
               if bexiste then begin
                  Wciclado := '(CICLADO)';
                  g_nivel := g_nivel - 1;
               end
               else begin
                  if qq.FieldByName( 'hcclase' ).AsString = 'LOC' then begin
                     loc1.Insert( 0, uppercase( qq.fieldbyname( 'externo' ).AsString ) );
                     loc2.insert( 0, qq.fieldbyname( 'organizacion' ).AsString );
                  end;
                  if nuevo and ( excluyemenu.IndexOf( qq.fieldbyname( 'hcprog' ).AsString ) = -1 ) then begin
                     Wciclado := '';
                     if qq.FieldByName( 'coment' ).AsString <> 'LIBRARY' then
                        leecompos( qq.FieldByName( 'hcprog' ).AsString,
                           qq.FieldByName( 'hcbib' ).AsString,
                           qq.FieldByName( 'hcclase' ).AsString )
                     else begin
                        g_nivel := g_nivel - 1;
                        qq.Next;
                        Continue;
                     end;
                  end;
               end;
               qq.Next;
            end;
         end;
      finally
         qq.Free;
      end;
   end;
   g_nivel := g_nivel - 1;
   if g_nivel < 0 then
      g_nivel := 1;
end;

procedure TfmListaDependencias.lstcomponenteClick( Sender: TObject );
var
   i, k, a: integer;
   ant: string;
   iTamArreglo: Integer;
begin
   inherited;

   SetLength( aGLBTsrela, 0 );
   g_procesa := true;

   if lstcomponente.ItemIndex = -1 then begin
      g_procesa := false;
      exit;
   end;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      setlength( aDetalle, 0 );
      slCtrExiste.Clear;
      loc1.Clear;
      loc2.Clear;
      g_nivel := 0;

      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where hcprog=' + g_q + lstcomponente.Items[ lstcomponente.itemindex ] + g_q +
         ' and   hcbib=' + g_q + cmblibreria.Text + g_q +
         ' and   hcclase=' + g_q + cmbclase.Text + g_q ) then begin
         agrega_compo( dm.q1 );

         leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
            dm.q1.FieldByName( 'hcbib' ).AsString,
            dm.q1.FieldByName( 'hcclase' ).AsString );

         Wprog := lstcomponente.Items[ lstcomponente.itemindex ];
         Wbib := cmblibreria.Text;
         Wclase := cmbclase.Text;
         bgral := cmbclase.Text + ' ' + cmblibreria.Text + ' ' + lstcomponente.Items[ lstcomponente.itemindex ];

         iTamArreglo := length( aDetalle );
         if iTamArreglo > 0 then begin
            CreaWeb
         end
         else begin
            if FormStyle = fsMDIChild then
               Application.MessageBox( pchar( dm.xlng( 'No existe información.' ) ),
                  pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
         end;
      end;

      setlength( aTotal, 0 );
      ant := '';
      K := 0;
      for i := 0 to length( aDetalle ) - 1 do begin
         for a := 0 to length( aTotal ) - 1 do begin
            if ( aDetalle[ i ].clase = aTotal[ a ].clase ) then begin
               ant := aDetalle[ i ].clase;
               k := a;
               break;
            end;
         end;

         if ant <> aDetalle[ i ].clase then begin
            k := length( aTotal );
            setlength( aTotal, k + 1 );
            aDetalle[ k ].clase := aDetalle[ i ].clase;
            aTotal[ k ].total := 0;
            ant := aDetalle[ i ].clase;
         end;
         inc( aTotal[ k ].total );
      end;
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmListaDependencias.lstcomponenteClickSistema( sistema: string );
var
   i, k: integer;
   ant: string;
   iTamArreglo: Integer;
begin
   inherited;
   SetLength( aGLBTsrela, 0 );
   screen.Cursor := crsqlwait;
   setlength( aDetalle, 0 );
   slCtrExiste.Clear;
   loc1.Clear;
   loc2.Clear;
   if dm.sqlselect( dm.q1, 'select * from tsrela ' +
      ' where sistema =' + g_q + sistema + g_q ) then begin
      agrega_compo( dm.q1 );
      leecompos( dm.q1.FieldByName( 'pcprog' ).AsString,
         dm.q1.FieldByName( 'pcbib' ).AsString,
         dm.q1.FieldByName( 'pcclase' ).AsString );

      iTamArreglo := length( aDetalle );
      if iTamArreglo > 0 then
         CreaWeb
      else begin
         if FormStyle = fsMDIChild then
            Application.MessageBox( pchar( dm.xlng( 'No existe información.' ) ),
               pchar( dm.xlng( 'Lista de Dependencias' ) ), MB_OK );
      end;
   end;

   setlength( aTotal, 0 );
   ant := '';
   K := 0;
   for i := 0 to length( aDetalle ) - 1 do begin
      if ant <> aDetalle[ i ].clase then begin
         k := length( aTotal );
         setlength( aTotal, k + 1 );
         aTotal[ k ].clase := aDetalle[ i ].clase;
         aTotal[ k ].total := 0;
         ant := aDetalle[ i ].clase;
      end;
      inc( aTotal[ k ].total );
   end;
   screen.Cursor := crdefault;
end;

procedure TfmListaDependencias.Salir1Click( Sender: TObject );
var
   arch: string;
begin
   inherited;

   gral.BorraIconosTmp( );
   arch := g_tmpdir + '\LD' + W_nomcomponente + '.html';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\LD' + W_nomcomponente + 'IMP.html';
   g_borrar.Add( arch );
   close;
end;

procedure TfmListaDependencias.webBeforeNavigate2( Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool );
var
   p, l: integer;
   b1: string;
   y: integer;
begin
   inherited;

   p := pos( '#lin', URL );
   if p > 0 then begin
      screen.Cursor := crsqlwait;
      l := Length( URL );
      b1 := copy( URL, p + 4, l - 4 );
      b1 := trim( b1 );
   end;
   if b1 = '' then
      exit;
   bgral := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   bgral := stringreplace( trim( b1 ), '(CICLADO)', '', [ rfReplaceAll ] );
   b1 := stringreplace( trim( b1 ), '(CICLADO)', '', [ rfReplaceAll ] );
   Opciones := gral.ArmarMenuConceptualWeb( b1, 'lista_componentes' );
   y := ArmarOpciones( Opciones );
   gral.PopGral.Popup( g_X, g_Y );
   screen.Cursor := crdefault;
end;

procedure TfmListaDependencias.webProgressChange( Sender: TObject; Progress,
   ProgressMax: Integer );
begin
   inherited;

   gral.PubAvanzaProgresBar;
end;

procedure TfmListaDependencias.grdDatosDBTableView1DblClick(
   Sender: TObject );
var
   sComponente: string;
   p, l: integer;
   y: integer;

begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      sComponente := Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue );

      if sComponente = '' then
         exit;

      bgral := stringreplace( trim( sComponente ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( sComponente, 'lista_componentes' );
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      sComponente := '';
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmListaDependencias.grdDatosDBTableView1FocusedRecordChanged(
   Sender: TcxCustomGridTableView; APrevFocusedRecord,
   AFocusedRecord: TcxCustomGridRecord;
   ANewItemRecordFocusingChanged: Boolean );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

end.

