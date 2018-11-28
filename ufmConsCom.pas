unit ufmConsCom;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ufmSVSListaExcel, cxStyles, cxCustomData, cxGraphics, cxFilter,
   cxData, cxDataStorage, cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn,
   dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
   dxPSEdgePatterns, ADODB, cxGridTableView, ImgList, dxPSCore,
   dxPScxGridLnk, dxBarDBNav, dxBar, dxStatusBar, cxGridLevel, cxClasses,
   cxControls, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView,
   cxGrid, cxPC, StdCtrls, Buttons, ExtCtrls, HTML_HELP, htmlhlp, shellapi,
   ComCtrls, svsdelphi;

type
   TfmConsCom = class( TfmSVSListaExcel )
    Panel2: TPanel;
      Label3: TLabel;
      Label5: TLabel;
      lbltotal: TLabel;
      Label4: TLabel;
      cmbclase: TComboBox;
      txtfil: TEdit;
      BitBtn1: TBitBtn;
      BitBtn2: TBitBtn;
      cmbSistema: TComboBox;
    p_agrega_consulta: TPanel;
      lblproyecto: TLabel;
      bproyecto: TButton;
      cmbproyecto: TComboBox;
      mnuAgregarParaConsulta: TdxBarButton;
      mnuMas: TdxBarButton;
    bParaConsulta: TButton;
    panelFantasma: TPanel;
    Image1: TImage;
      procedure cmbclaseChange( Sender: TObject );
      procedure bcancelClick( Sender: TObject );
      procedure txtfilClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure cmbproyectoChange( Sender: TObject );
      procedure buscarText;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure Button1Click( Sender: TObject );
      function ArmarOpciones( b1: Tstringlist ): integer;
      function ValidarDatos: Boolean;
      //procedure mnuAgregarParaConsultaClick( Sender: TObject );
      procedure mnuCancelarClick( Sender: TObject );
      procedure mnuMasClick( Sender: TObject );
      procedure BitBtn1Click( Sender: TObject );
      procedure BitBtn2Click( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      function FormHelp( Command: Word; Data: Integer;
         var CallHelp: Boolean ): Boolean;
      procedure FormKeyDown( Sender: TObject; var Key: Word;
         Shift: TShiftState );
      procedure grdDatosClick( Sender: TObject );
      procedure grdDatosDBTableView1DblClick( Sender: TObject );
      procedure cmbSistemaChange( Sender: TObject );
      procedure bproyectoClick( Sender: TObject );
    procedure bParaConsultaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure txtfilChange(Sender: TObject);
    procedure txtfilKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
   private
      { Private declarations }
      bPriCambio: boolean;
      qq, qq1: TADOquery;
      n: integer;
      clase: string;
      Opciones: Tstringlist;
      Wclase: string;
      sSistema: string;
      Wnumreg: integer;
      archivocsv: string;
      procedure panel_fantasma(visible:boolean);    //alk
   public
      { Public declarations }
      estado: boolean;
   end;

var
   a: string;
   ftsconscom: TfmConsCom;

implementation

uses ptsdm, parbol, ptsgral, uListaRutinas, uConstantes, uRutinasExcel;

{$R *.dfm}

{ TfmConsCom }

function TfmConsCom.ArmarOpciones( b1: Tstringlist ): integer;
var
   mm: Tstringlist;
begin
   inherited;

   mm := Tstringlist.Create;
   mm.CommaText := bgral;

   if mm.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( sLISTA_CONS_COMPONE + ' ' ) ), MB_OK );
      mm.free;
      exit;
   end;

   gral.EjecutaOpcionB( b1, sLISTA_CONS_COMPONE );
   mm.free;
end;

procedure TfmConsCom.bcancelClick( Sender: TObject );
begin
   inherited;

   txtfil.Clear;
end;

procedure TfmConsCom.BitBtn1Click( Sender: TObject );
var
   n, i, iCtrTiempo, iProcesa: integer;
   o: integer;
   c, cc: string;
   consulta:string;
begin
   inherited;
   mnuImprimir.Visible := ivNever;

   if ValidarDatos = False then begin
      txtfil.SetFocus;
      Exit;
   end;

   screen.Cursor := crsqlwait;

   // -----------  para quitar panel fantasma --------------  ALK
   //panel_fantasma(true);
   panel_fantasma(false);
   // ------------------------------------------------------

   lbltotal.Caption := 'Total: ';
   iProcesa := 1;
   iCtrTiempo := 0;
   //   lv.Items.Clear;
   Wclase := ' where hcclase=' + g_q + clase + g_q;
   if cmbSistema.ItemIndex < 1 then begin
      iCtrTiempo := iCtrTiempo + 1;
      for n := 1 to cmbSistema.Items.Count - 1 do begin
         c := cmbSistema.items[ n ];
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;

      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      sSistema := ' and x.sistema in(' + g_q + cc + g_q + ')';
   end
   else
      sSistema := ' and x.sistema = ' + g_q + cmbSistema.Text + g_q;

   if txtfil.Text = '' then
      txtfil.Text := '*';
   clase := trim( clase );
   //if clase = '' then begin
   if cmbClase.ItemIndex < 1 then begin
      iCtrTiempo := iCtrTiempo + 1;
      o := cmbclase.items.count;
      for n := 1 to o - 1 do begin
         c := copy( cmbclase.items[ n ], 1, 3 );
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;
      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      Wclase := 'where hcclase in(' + g_q + cc + g_q + ')';
   end;

   if iCtrTiempo > 1 then begin
      if application.MessageBox( pchar( 'El Proceso Tardará varios minutos.' + chr( 13 ) + 'Desea continuar?' ), 'Confirme', MB_YESNO ) = IDNO then
         iProcesa := 0
      else
         iProcesa := 1
   end;

   If iProcesa = 1 Then begin
      // La consulta se hace con respecto a la clase diagrama scheduler ALK
      if (clase = 'CTM') then begin
         consulta:= 'select distinct x.sistema, x.hcprog,x.hcbib ,x.hcclase, '+
            ' x.ocprog,x.ocbib ,x.occlase '+
            ' from tsrela x, tsproperty t ' +
            Wclase + sSistema +
            ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
            ' and x.hcprog = t.cprog and x.hcbib=t.cbib ' +
            'UNION ALL  ' +
            ' select distinct x.sistema, x.hcprog ,x.hcbib ,x.hcclase,'+
            ' x.ocprog,x.ocbib ,x.occlase '+
            ' from tsrela x  ' +
            Wclase + sSistema +
            ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
            ' and x.hcprog not in (select t.cprog from tsproperty t where t.cprog=x.hcprog and t.cbib=x.hcbib and t.cclase=x.hcclase) ' +
            ' order by sistema, hcprog';
      end
      else begin
         consulta:= 'select distinct x.sistema, x.hcprog,x.hcbib ,x.hcclase '+
            ' from tsrela x, tsproperty t ' +
            Wclase + sSistema +
            ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
            ' and x.hcprog = t.cprog and x.hcbib=t.cbib ' +
            'UNION ALL  ' +
            ' select distinct x.sistema, x.hcprog ,x.hcbib ,x.hcclase'+
            ' from tsrela x  ' +
            Wclase + sSistema +
            ' and x.hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
            ' and x.hcprog not in (select t.cprog from tsproperty t where t.cprog=x.hcprog and t.cbib=x.hcbib and t.cclase=x.hcclase) ' +
            ' order by sistema, hcprog';
      end;

      if dm.sqlselect( qq, consulta ) then begin
         Wnumreg := qq.RecordCount;
         panel_fantasma(true);
         lbltotal.Caption := 'Total: ' + inttostr( Wnumreg );
         mnuImprimir.Visible := ivAlways;
         n := 0;
         mnuMasClick( sender );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'No encontro informaciòn ' ) ),
            pchar( dm.xlng( sLISTA_CONS_COMPONE + ' ' ) ), MB_OK );
         panel_fantasma(false);
      end;
   end;
   screen.Cursor := crdefault;
end;

procedure TfmConsCom.BitBtn2Click( Sender: TObject );
var
   j:integer;
begin
   inherited;

   stbLista.Panels[ 0 ].Text := '';
   GlbHabilitarOpcionesMenu( mnuPrincipal, False );
   grdDatosDBTableView1.ClearItems;
   txtfil.Clear;
   mnuImprimir.Visible := ivNever;
   lbltotal.Caption := ' ';

   // -------- para activar el panel fantasma ----------------
   panel_fantasma(false);

   // -------- para dejar los combos como nuevos -------------
   if dm.sqlselect( dm.qmodify, 'Select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
   cmbclase.Items.Clear;
   cmbclase.Enabled:=false;

   txtfil.Text:='';
   cmbSistema.Focused;
   BitBtn1.Enabled:=false;
   BitBtn2.Enabled:=false;
   // --------------------------------------------------------
end;

procedure TfmConsCom.Button1Click( Sender: TObject );
var
   o, n: integer;
   c, cc: string;
begin
   inherited;

   screen.Cursor := crsqlwait;
   lbltotal.Caption := 'Total: ';
   //   lv.Items.Clear;
   Wclase := ' where hcclase=' + g_q + clase + g_q;
   if txtfil.Text = '' then
      txtfil.Text := '*';
   clase := trim( clase );
   if clase = '' then begin
      o := cmbclase.items.count;
      for n := 1 to o - 1 do begin
         c := copy( cmbclase.items[ n ], 1, 3 );
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;
      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      Wclase := 'where hcclase in(' + g_q + cc + g_q + ')';
   end;

   if dm.sqlselect( qq, 'select distinct hcprog,hcbib from tsrela ' +
      Wclase +
      ' and hcprog like ' + g_q + stringreplace( txtfil.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' order by hcprog' ) then begin
      Wnumreg := qq.RecordCount;
      lbltotal.Caption := 'Total: ' + inttostr( Wnumreg );
      n := 0;
      mnuMasClick( sender );
   end;
   screen.Cursor := crdefault;
end;

procedure TfmConsCom.cmbclaseChange( Sender: TObject );
begin
   inherited;

   screen.Cursor := crsqlwait;
   //   lv.Items.Clear;
   screen.Cursor := crdefault;
   clase := copy( cmbclase.Text, 1, 3 );
   if copy( clase, 1, 1 ) = '*' then
      clase := '';

   txtfil.Text:='';
   txtfil.Enabled:=true;
   BitBtn1.Enabled:=true;
   BitBtn2.Enabled:=true;
   panel_fantasma(false);
end;

procedure TfmConsCom.cmbproyectoChange( Sender: TObject );
begin
   inherited;

   bproyecto.Enabled     := ( cmbproyecto.Text <> '' );
   bParaConsulta.Enabled := ( cmbproyecto.Text <> '' );
end;

procedure TfmConsCom.FormActivate( Sender: TObject );
var
   proy: string;
begin
   inherited;

   // buscarText; //esta rutina puede servir en el futuro para una busqueda màs amplia.

   proy := cmbproyecto.Text;
   dm.feed_combo( cmbproyecto, 'select distinct cproyecto ' +
      ' from tsuserpro' +
      ' where cuser=' + g_q + g_usuario + g_q +
      ' order by cproyecto' );
   cmbproyecto.Visible := ( cmbproyecto.items.Count > 0 );
   cmbproyecto.ItemIndex := cmbproyecto.Items.IndexOf( proy );
   bproyecto.Visible := cmbproyecto.Visible;
   bproyecto.Enabled := ( cmbproyecto.Text <> '' );
   bParaConsulta.Visible := cmbproyecto.Visible;
   bParaConsulta.Enabled := ( cmbproyecto.Text <> '' );
   lblproyecto.Visible := cmbproyecto.Visible;
{
   if dm.sqlselect( DM.qmodify, 'Select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( '-Todos los sistemas -' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
 }
   iHelpContext := HTML_HELP.IDH_TOPIC_T01300;
end;

procedure TfmConsCom.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   inherited;
   if FormStyle = fsMDIChild then 
      dm.PubEliminarVentanaActiva( Caption );

   cmbclase.clear;
   txtfil.clear;
   DeleteFile( archivocsv );
   g_arbol_activo := 0;
end;

procedure TfmConsCom.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

function TfmConsCom.FormHelp( Command: Word; Data: Integer;
   var CallHelp: Boolean ): Boolean;
begin
   inherited;

   try
      HtmlHelp( Application.Handle,
         PChar( Format( '%s::/T%5.5d.htm',
         [ Application.HelpFile, iHelpContext ] ) ), HH_DISPLAY_TOPIC, 0 );
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;
end;

procedure TfmConsCom.FormKeyDown( Sender: TObject; var Key: Word;
   Shift: TShiftState );
begin
   inherited;

   iHelpContext := HTML_HELP.IDH_TOPIC_T01300;
end;

procedure TfmConsCom.grdDatosClick( Sender: TObject );
begin
   inherited;

   gral.popgral.Items.Clear;
end;

procedure TfmConsCom.grdDatosDBTableView1DblClick( Sender: TObject );
var
   sComponente: string;
   y: integer;
begin
   //Comprobar que contenga algo el grd antes de querer traer los datos
   if txtfil.Text = '' then
      exit;

   inherited;
   screen.Cursor := crsqlwait;

   try
      //mandar los datos para el menu y para diagrama scheduler clase CTM  ALK
      if (clase='CTM') then begin
         sComponente := Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 1 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 0 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 5 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 6 ].EditValue );
               //comp lib cla sis com_p cla_p lib_p
      end
      else begin
         sComponente := Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 1 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + ' ' +
               Trim( grdDatosDBTableView1.Columns[ 0 ].EditValue );
               //comp lib cla sis
      end;

      if sComponente = '' then
         exit;

      Opciones := gral.ArmarMenuConceptualWeb( sComponente, 'consulta_componentes' );
      y := ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      sComponente := '';
   finally
      screen.Cursor := crdefault;
   end;
end;
{
procedure TfmConsCom.mnuAgregarParaConsultaClick( Sender: TObject );
var
   i: integer;
begin
   inherited;
 }  {      for i := 0 to lv.Items.Count - 1 do begin
            if lv.items[ i ].Selected then begin
               //farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, clase, nil,
               farbol.agrega_componente( lv.Items[ i ].SubItems[ 0 ], lv.Items[ i ].Caption, lv.Items[ i ].SubItems[ 1 ], nil,
                  '', '', 'CONSULTA' );
            end;
         end;
   }
 {  farbol.agrega_componente( Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ),   /////PREGUNTA???????
      Trim( grdDatosDBTableView1.Columns[ 1 ].EditValue ),
      Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ),
      nil, '', '', 'CONSULTA' );
end; }

procedure TfmConsCom.mnuCancelarClick( Sender: TObject );
begin
   inherited;

   txtfil.Clear;
end;

procedure TfmConsCom.mnuMasClick( Sender: TObject );
var
   i, j: integer;
   slDatos: Tstringlist;
   AField: TField;
   sFecha, sVersiones, sDescripcion: String;
   sFileExcel: string;
begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
      slDatos := Tstringlist.create;
      slDatos.Delimiter := ',';
      /////slDatos.Add( 'Sistema,Biblioteca,Componente,Clase,Líneas Blanco,Líneas Total,Líneas Comentarios,Líneas Efectivas,Ultima Versión,No. Versiones,Descripción' );
      if (clase='CTM') then begin
         slDatos.Add( 'Sistema,Biblioteca,Componente,Clase,Depende de Componente,Depende de Clase,Depende de Biblioteca,Ultima Versión,No. Versiones,Descripción' ); //cambio ALK para generar scheduler de CTM con malla del padre correspondiente
      end
      else begin
         slDatos.Add( 'Sistema,Biblioteca,Componente,Clase,Ultima Versión,No. Versiones,Descripción' );
      end;


      qq1 := Tadoquery.Create( self );
      qq1.Connection := dm.ADOConnection1;

      while not qq.Eof do begin
         if dm.sqlselect( qq1, 'Select MAX(Fecha) As Fecha From tsversion where  cprog = ' + g_q + qq.fieldbyname( 'hcprog' ).AsString + g_q +
            ' and cbib = ' + g_q + qq.fieldbyname( 'hcbib' ).AsString + g_q +
            ' and cclase = ' + g_q + qq.fieldbyname( 'hcclase' ).AsString + g_q ) then
            sFecha := qq1.fieldbyname( 'Fecha' ).AsString;

         if dm.sqlselect( qq1, 'Select Count(*) As Versiones From tsversion where cprog = ' + g_q + qq.fieldbyname( 'hcprog' ).AsString + g_q +
            ' and cbib = ' + g_q + qq.fieldbyname( 'hcbib' ).AsString + g_q +
            ' and cclase = ' + g_q + qq.fieldbyname( 'hcclase' ).AsString + g_q ) then
            sVersiones := qq1.fieldbyname( 'Versiones' ).AsString;

         if dm.sqlselect( qq1, 'Select DESCRIPCION From tsprog where cprog = ' + g_q + qq.fieldbyname( 'hcprog' ).AsString + g_q +
            ' and cbib = ' + g_q + qq.fieldbyname( 'hcbib' ).AsString + g_q +
            ' and cclase = ' + g_q + qq.fieldbyname( 'hcclase' ).AsString + g_q ) then
            sDescripcion := qq1.fieldbyname( 'DESCRIPCION' ).AsString;


         //Dependiendo de los titulos se manda llenar la tabla  diagrama scheduler ALk
         //Sistema,Biblioteca,Componente,Clase,Depende de Componente,Depende de Clase,Depende de Biblioteca,Ultima Versión,No. Versiones,Descripción
         if (clase='CTM') then begin
            slDatos.Add( '"' + qq.fieldbyname( 'sistema' ).AsString + '",' +
               '"' + qq.fieldbyname( 'hcbib' ).AsString + '",' +
               '"' + StringReplace( qq.fieldbyname( 'hcprog' ).AsString, '"', '', [ rfReplaceAll ] ) + '",' +
               '"' + qq.fieldbyname( 'hcclase' ).AsString + '",' +
               '"' + StringReplace( qq.fieldbyname( 'ocprog' ).AsString, '"', '', [ rfReplaceAll ] ) + '",' +
               '"' + qq.fieldbyname( 'occlase' ).AsString + '",' +
               '"' + qq.fieldbyname( 'ocbib' ).AsString + '",' +
               '"' + sFecha + '",' + '"' + sVersiones + '",' + '"' + sDescripcion + '"' );
         end
         else begin
            slDatos.Add( '"' + qq.fieldbyname( 'sistema' ).AsString + '",' +
               '"' + qq.fieldbyname( 'hcbib' ).AsString + '",' +
               '"' + StringReplace( qq.fieldbyname( 'hcprog' ).AsString, '"', '', [ rfReplaceAll ] ) + '",' +
               '"' + qq.fieldbyname( 'hcclase' ).AsString + '",' +
               '"' + sFecha + '",' + '"' + sVersiones + '",' + '"' + sDescripcion + '"' );
         end;

         qq.Next;
      end;

      if not qq.Eof then begin
         lbltotal.Caption := 'Total  ' + inttostr( Wnumreg ) + '  (1 - ' + inttostr( n ) + ')';
         mnuMas.Visible := ivAlways;
      end
      else begin
         lbltotal.Caption := 'Total  ' + inttostr( Wnumreg );
         mnuMas.Visible := ivNever;
      end;
      sFileExcel := '\sql' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.csv';

      archivocsv := g_tmpdir + sFileExcel;
      slDatos.SaveToFile( archivocsv );
      slDatos.Clear;

      grdDatosDBTableView1.ClearItems;
      if bGlbPoblarGrid( adoConnExcel, g_tmpdir, sFileExcel, tblExcel ) then begin
         grdDatosDBTableView1.DataController.CreateAllItems;
         GlbHabilitarOpcionesMenu( mnuPrincipal, tblExcel.RecordCount > 0 );
         stbLista.Panels[ 0 ].Text := IntToStr( tblExcel.RecordCount ) + ' Registros';
         GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      end;
      {
            if ShellExecute(Handle, nil,pchar(archivocsv),nil, nil, SW_SHOW) <= 32 then
               Application.MessageBox(pchar(dm.xlng('No puede ejecutar '+archivocsv)),
                                      pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
      }
   finally
      slDatos.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmConsCom.txtfilClick( Sender: TObject );
var
   slClase: String;
begin
   txtfil.SetFocus;
   slclase := Trim( cmbClase.Text );
   {if slClase <> '' then
      bitBtn1.Enabled := True
   else
      bitBtn1.Enabled := False; }
end;

function TfmConsCom.ValidarDatos: Boolean;
var
   slText, slClase: String;
begin
   BitBtn1.Enabled := True;
   slText := trim( txtfil.Text );
   slClase := trim( cmbClase.Text );

   ValidarDatos := True;

   if ( slClase = '' ) then begin
      Application.MessageBox( pchar( dm.xlng( 'Debe seleccionar un valor del combo de clases' ) ),
         pchar( dm.xlng( sLISTA_CONS_COMPONE ) ), MB_OK );
      BitBtn1.Enabled := False;
      cmbClase.SetFocus;
      ValidarDatos := False;
   end;

   If ( slText = '' ) then begin
      {Application.MessageBox( pchar( dm.xlng( 'El campo máscara no puede ir en blanco : ' + chr( 13 ) +
         'Ej. ' + chr( 13 ) + '     - El nombre completo del componente'
         + chr( 13 ) + '     - ABC*'
         + chr( 13 ) + '     - * (Puede tardar en mostrar resultados)' ) ),
         pchar( dm.xlng( sLISTA_CONS_COMPONE ) ), MB_OK );
      BitBtn1.Enabled := False;
      txtfil.SetFocus;
      ValidarDatos := False; }
      slText:='*'
   end;
end;

procedure TfmConsCom.cmbSistemaChange( Sender: TObject );
var
   n: integer;
   c, cc: string;

begin
   inherited;
   if cmbSistema.ItemIndex < 1 then begin
      for n := 1 to cmbSistema.Items.Count - 1 do begin
         c := cmbSistema.items[ n ];
         if n = 1 then
            cc := c
         else
            cc := cc + '?' + c;
      end;
      cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
      sSistema := ' sistema in(' + g_q + cc + g_q + ')';
   end
   else
      sSistema := ' sistema = ' + g_q + cmbSistema.Text + g_q;

   // dm.feed_combo( cmbclase, 'select cclase||' + g_q + ',' + g_q + '||descripcion from tsclase order by cclase' );
   dm.feed_combo1( cmbclase, 'select distinct hcclase , nvl((select descripcion from tsclase t where x.hcclase = t.cclase), ' + g_q + 'SIN DESCRIPCION' + g_q +
      ' ) from (select distinct sistema,hcclase from tsrela ' +
      ' union all select distinct sistema,pcclase from tsrela ) x  where ' + sSistema + ' order by 1' );
   qq := Tadoquery.Create( self );
   qq.Connection := dm.ADOConnection1;

   //farbol.g_sistema:=cmbSistema.Text;  // para dar sistema  ALK
   g_sistema:=cmbSistema.Text;  // para dar sistema  ALK

   cmbclase.Enabled:=true;
   txtfil.Text:='';
   txtfil.Enabled:=false;
   BitBtn1.Enabled:=false;
   panel_fantasma(false);
   BitBtn2.Enabled:=true;
end;

procedure TfmConsCom.buscarText;
begin
   inherited;

   dm.feed_combo( cmbclase, 'select cclase||' + g_q + ',' + g_q + '||descripcion from tsclase order by cclase' );
   qq := Tadoquery.Create( self );
   qq.Connection := dm.ADOConnection1;
end;

procedure TfmConsCom.bproyectoClick( Sender: TObject );
var
   i: integer;
   nodo: Ttreenode;
   Wproy: string;
   iRenglon, iColumna : Integer;
   vComponente, vBiblio, vClase : Variant;
begin
   inherited;
   if cmbproyecto.Text = '' then begin
      Application.MessageBox( 'No hay proyecto seleccionado' , 'Consulta de Componentes' , MB_OK );
      exit;
   end ;

   if g_arbol_activo = 0 then    // si no proviene del arbol  ALK
      exit;

   for i := 0 to farbol.nodo_proyecto.Count - 1 do begin
      if farbol.nodo_proyecto.Item[ i ].Text = cmbproyecto.Text then begin
         nodo := farbol.nodo_proyecto.Item[ i ];
         break;
      end;
   end;

   if grdDatosDBTableView1.Controller.SelectedRowCount < 1 then begin
      Application.MessageBox( 'No hay renglones seleccionados' , 'Consulta de Componentes' , MB_OK );
      Exit;
   end;

   for i := 0 to grdDatosDBTableView1.Controller.SelectedRowCount - 1 do begin
      iRenglon := grdDatosDBTableView1.Controller.SelectedRecords[ i ].RecordIndex;

      iColumna := grdDatosDBTableView1.DataController.GetItemByFieldName( 'COMPONENTE' ).Index;
      vComponente := grdDatosDBTableView1.DataController.Values[ iRenglon, iColumna ];

      iColumna := grdDatosDBTableView1.DataController.GetItemByFieldName( 'BIBLIOTECA' ).Index;
      vBiblio := grdDatosDBTableView1.DataController.Values[ iRenglon, iColumna ];

      iColumna := grdDatosDBTableView1.DataController.GetItemByFieldName( 'CLASE' ).Index;
      vClase := grdDatosDBTableView1.DataController.Values[ iRenglon, iColumna ];

      if farbol.alta_a_proyecto(vComponente,vBiblio,vClase,cmbproyecto.Text) then begin     //inserta el proyecto al usuario en tsuserpro
         try
         //farbol.g_sistema:=cmbSistema.Text;  // para dar sistema  ALK
         g_sistema:=cmbSistema.Text;  // para dar sistema  ALK
         farbol.agrega_componente( vComponente,vBiblio,vClase,nodo,cmbproyecto.text, '', 'USERPRO' );
         screen.Cursor := crsqlwait;
         finally
            screen.Cursor := crdefault;
         end;
      end;
   end;
   Wproy := cmbproyecto.text;
   Application.MessageBox( 'Componente(s) agregado(s) al proyecto', pansichar( Wproy ), MB_OK );
end;

procedure TfmConsCom.bParaConsultaClick(Sender: TObject);
var
   i: integer;
   nodo: Ttreenode;
   Wproy: string;
   iRenglon, iColumna : Integer;
   vComponente, vBiblio, vClase : Variant;

begin
   inherited;

   if grdDatosDBTableView1.Controller.SelectedRowCount < 1 then begin
      Application.MessageBox( 'No hay renglones seleccionados' , 'Consulta de Componentes' , MB_OK );
      Exit;
   end;

   for i := 0 to grdDatosDBTableView1.Controller.SelectedRowCount - 1 do begin
      iRenglon := grdDatosDBTableView1.Controller.SelectedRecords[ i ].RecordIndex;

      iColumna := grdDatosDBTableView1.DataController.GetItemByFieldName( 'COMPONENTE' ).Index;
      vComponente := grdDatosDBTableView1.DataController.Values[ iRenglon, iColumna ];

      iColumna := grdDatosDBTableView1.DataController.GetItemByFieldName( 'BIBLIOTECA' ).Index;
      vBiblio := grdDatosDBTableView1.DataController.Values[ iRenglon, iColumna ];

      iColumna := grdDatosDBTableView1.DataController.GetItemByFieldName( 'CLASE' ).Index;
      vClase := grdDatosDBTableView1.DataController.Values[ iRenglon, iColumna ];

      farbol.agrega_componente(vComponente,vBiblio,vClase,nil,'','','CONSULTA');
   end;
   Wproy := cmbproyecto.text;
   Application.MessageBox( 'Componente(s) agregado(s) al proyecto', pansichar( Wproy ), MB_OK );
end;

procedure TfmConsCom.FormCreate(Sender: TObject);
begin
  inherited;
   if dm.sqlselect( DM.qmodify, 'Select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;

   //Panel2.Focused;
   p_agrega_consulta.Visible:=false;
   if gral.bPubVentanaMaximizada = FALSE then begin
      Width := g_Width;
      //Height := g_Height;
      Height := 550;    //para ocultar el grid de principio  ALK
      HorzScrollBar.Visible:=false;
   end;
end;

procedure TfmConsCom.FormResize(Sender: TObject);
var
   tam : integer;
begin
   inherited;
   tam:=180;

   if cmbSistema.width < 350 then
      cmbsistema.width:=350
   else
      cmbsistema.width:=Panel2.Width-tam;

   if cmbclase.width < 350 then
      cmbclase.width:=350
   else
      cmbclase.width:=Panel2.Width-tam;
end;

procedure TfmConsCom.panel_fantasma(visible:boolean);
begin
   // -----------  para quitar panel fantasma --------------  ALK
   panelfantasma.Visible:=not visible;
   if gral.bPubVentanaMaximizada = FALSE then begin
      //Height := Height + 500;    //para mostrar el grid de resultados  ALK
      HorzScrollBar.Visible:=visible;
   end;
   // ------------------------------------------------------
   if g_arbol_activo = 0 then          // si no proviene del arbol
      p_agrega_consulta.Visible:=false;

end;

procedure TfmConsCom.txtfilChange(Sender: TObject);
begin
   BitBtn1.Enabled:=true;
   BitBtn2.Enabled:=true;
end;

procedure TfmConsCom.txtfilKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if trim(txtfil.Text) = '' then 
      txtfil.Text:='*';
   panel_fantasma(false);
end;

end.
