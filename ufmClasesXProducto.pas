unit ufmClasesXProducto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufmSVSLista, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, cxGridTableView, ImgList, dxPSCore, dxPScxGridLnk,
  dxBarDBNav, dxmdaset, dxBar, dxStatusBar, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView,
  cxGrid, cxPC, cxLookAndFeelPainters, StdCtrls, cxButtons, ExtCtrls,
  Buttons, Menus, cxGridCustomPopupMenu, cxGridPopupMenu;

type
   rDatos = record
      capacidad: string;
      clases: array of string;
   end;

type
  TfmClasesXProducto = class(TfmSVSLista)
    mnuOk: TdxBarButton;
    mnuCancel: TdxBarButton;
    dxBarButton4: TdxBarButton;
    mnuSalvar: TdxBarButton;
    cxGridPopupMenu1: TcxGridPopupMenu;
    PopupMenu1: TPopupMenu;
    MarcarRenglon1: TMenuItem;
    mnuMarkReg: TdxBarButton;
    mnuMarkColumn: TdxBarButton;
    mnuUnMarkRec: TdxBarButton;
    mnuUnMarkColumn: TdxBarButton;
    procedure mnuSalvarClick(Sender: TObject);
    procedure mnuCancelClick(Sender: TObject);
    procedure mnuMarkRegClick(Sender: TObject);
    procedure mnuUnMarkRecClick(Sender: TObject);
    procedure mnuUnMarkColumnClick(Sender: TObject);
    procedure mnuMarkColumnClick(Sender: TObject);
  private
    { Private declarations }
    aDatos: array of rDatos;
    aClases: array of string;
  public
    { Public declarations }
    procedure pubCreaLista( sParUsu: String; sParCaption: String );
  end;

var
  fmClasesXProducto: TfmClasesXProducto;

implementation

uses ptsdm, ptsgral, uListaRutinas;

{$R *.dfm}

{ TfmClasesXProducto }

procedure TfmClasesXProducto.pubCreaLista(sParUsu, sParCaption: String);
var
   i, j, k: integer;
   sPass: string;
   slDatos: Tstringlist;
   g_ext: string;
begin
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   Self.Caption := sParCaption;

   try
      if dm.sqlselect( dm.q1, 'select cclase from  tsclase where estadoactual =' + g_q + 'ACTIVO' + g_q +
            ' and cclase not in ( ' + g_q + 'CLA' + g_q + ',' + g_q + 'DIR' + g_q + ')' +
            ' and cclase in (' +
            'select pcclase cclase from tsrela group by pcclase  union ' +
            '(select  hcclase  cclase from tsrela  group by hcclase union ' +
            ' select  occlase  cclase from tsrela group by occlase)) order by cclase' ) then begin
         i := 1;
         while not dm.q1.Eof do begin
            SetLength( aClases, i );
            aClases[i-1] := dm.q1.fieldbyname( 'cclase' ).AsString;
            inc(i);
            dm.q1.Next;
         end;
      end;

      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
      slDatos := Tstringlist.create;
      slDatos.Delimiter := ',';

      sPass := 'CCAPACIDAD:String:200,';

      for i := 0 to Length( aClases ) - 1 do
         if i <> Length( aClases ) - 1 then
            sPass := sPass+aClases[i]+ ':Boolean:0,'
         else
            sPass := sPass+aClases[i]+ ':Boolean:0';

      slDatos.Add(sPass);

      dm.sqlselect( dm.q1, 'SELECT cclaseprod, ccapacidad FROM TSPRODUCTOS  where cuser = '
                    + g_q + sParUsu + g_q + ' ORDER BY ccapacidad' );

      SetLength( aDatos, dm.q1.RecordCount );

      j := 0;
      dm.q1.First;
      while not dm.q1.Eof do begin
         SetLength( aDatos[j].clases, Length(aClases)+1 );
         aDatos[j].capacidad := dm.q1.FieldByName( 'CCAPACIDAD' ).AsString;
         sPass := dm.q1.FieldByName( 'cclaseprod' ).AsString;

         for i := 0 to Length(aClases) -1 do begin
            if AnsiPos(aClases[i], sPass) <> 0 then
               aDatos[j].clases[i] := 'true'
            else
               aDatos[j].clases[i] := 'false'
         end;

        dm.q1.Next;
        Inc(j);
      end;

      for i := 0 to Length(aDatos) - 1 do begin
         sPass := '"' + aDatos[i].capacidad + '",';

         for j := 0 to Length(aClases) - 1 do
            if aDatos[i].clases[j] = 'true' then
               sPass := sPass + '"' + aDatos[i].clases[j] + '",'
            else
               sPass := sPass + '"false",';

          slDatos.Add( Copy( sPass, 1, Length( sPass ) - 1 ) );
      end;

      if tabDatos.Active then
         tabDatos.Active := False;

      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
      if bGlbPoblarTablaMem( slDatos, tabDatos ) then begin
         tabDatos.ReadOnly := True;

         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         GlbCrearCamposGrid( grdDatosDBTableView1 );

         grdDatosDBTableView1.ApplyBestFit( );

         //necesario para la busqueda
         //en este caso usar grdEspejo para apoyarse en las busquedas y llenar slPublista
         GlbCrearCamposGrid( grdEspejoDBTableView1 );
         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         //fin necesario para la busqueda

         tabDatos.ReadOnly := false;

         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';
         GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;
   finally
      slDatos.Free;
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmClasesXProducto.mnuSalvarClick(Sender: TObject);
var
   i,j: integer;
   sCapacidad, sClaseProd,upd: string;
begin
  inherited;

   try
      if (tabDatos.State = dsEdit) or (tabDatos.State = dsInsert) then
         tabDatos.Post;

      tabDatos.First;

      while not tabDatos.Eof do begin
         sCapacidad := tabDatos.Fields.Fields[1].AsString;
         sClaseProd := '';

         for i := 0 to Length(aClases) - 1 do begin
            if UpperCase( tabDatos.FieldByName(aClases[i]).AsString) = UpperCase( 'true' ) then
               sClaseProd := sClaseProd + aClases[i] + ' '
            else
               sClaseProd := sClaseProd + '    ';
         end;

         upd:= 'update TSPRODUCTOS ' +
                       '  set CCLASEPROD = ' + g_q +sClaseProd  + g_q + ' '+
                       ' where CCAPACIDAD = ' + g_q +sCapacidad+ g_q + ' ';
         if not dm.sqlupdate( upd ) then begin
            Application.MessageBox( pchar( 'No pudo actualizar tsproductos.' ),
                                    pchar( 'Clases por producto' ), MB_OK );
            exit;
         end;

         tabDatos.Next;
      end;
   finally
      GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmClasesXProducto.mnuCancelClick(Sender: TObject);
begin
  inherited;

   if MessageDlg('Se perderan los cambios, estas seguro?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      pubCreaLista( 'ADMIN', 'Catálogo de Productos/Clases' );
end;

procedure TfmClasesXProducto.mnuMarkRegClick(Sender: TObject);
var
   i: integer;
begin
  inherited;

   with grdDatosDBTableView1 do
    begin
      for i := 2 to ColumnCount - 1 do
       Columns[ i ].EditValue := true;
    end;
end;

procedure TfmClasesXProducto.mnuUnMarkRecClick(Sender: TObject);
var
   i: integer;
begin
  inherited;

   with grdDatosDBTableView1 do
    begin
      for i := 2 to ColumnCount - 1 do
       Columns[ i ].EditValue := false;
    end;
end;

procedure TfmClasesXProducto.mnuUnMarkColumnClick(Sender: TObject);
var
   i, j: Integer;
begin
  inherited;

   j := grdDatosDBTableView1.Controller.FocusedColumnIndex;

   with grdDatosDBTableView1 do
    begin
      DataController.DataSource.DataSet.First;

      for i := 0 to DataController.DataSource.DataSet.RecordCount - 1 do begin
         Columns[ j+1 ].EditValue := false;
         DataController.DataSource.DataSet.Next;
      end;

      DataController.DataSource.DataSet.First;
    end;

end;

procedure TfmClasesXProducto.mnuMarkColumnClick(Sender: TObject);
var
   i, j: Integer;
begin
  inherited;

   j := grdDatosDBTableView1.Controller.FocusedColumnIndex;

   with grdDatosDBTableView1 do
    begin
      DataController.DataSource.DataSet.First;

      for i := 0 to DataController.DataSource.DataSet.RecordCount - 1 do begin
         Columns[ j+1 ].EditValue := true;
         DataController.DataSource.DataSet.Next;
      end;

      DataController.DataSource.DataSet.First;
    end;

end;

end.
