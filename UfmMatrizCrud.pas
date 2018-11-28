unit UfmMatrizCrud;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
   ExtCtrls, ComCtrls, Buttons, strutils, shellapi, Menus, ufmSVSLista, ADODB,
   cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd,
   dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns,
   cxGridTableView, ImgList, dxPSCore, dxPScxGridLnk, dxBarDBNav, dxmdaset,
   dxBar, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
   cxGridCustomTableView, cxGridDBTableView, cxGrid, cxPC, dxStatusBar,
   cxSplitter;

type
   TfmMatrizCrud = class( TfmSVSLista )
    texto: TMemo;
      Panel1: TPanel;
      lbltotal: TLabel;
      cmbtabla: TEdit;
      StaticText1: TStaticText;
      cxSplitter1: TcxSplitter;
      cxSplitter2: TcxSplitter;
      cmbsistema: TComboBox;
      lblSistema: TLabel;
      lvindice: TListView;
      lv: TListView;
    PanelTrasero: TPanel;
    Image1: TImage;
    bmas: TBitBtn;
    BitBtn2: TBitBtn;
      procedure FormCreate( Sender: TObject );
      procedure bsalirClick( Sender: TObject );
      procedure lvClick( Sender: TObject );
      procedure lvindiceClick( Sender: TObject );
      procedure textoDblClick( Sender: TObject );
      procedure textoClick( Sender: TObject );
      procedure cmbtablaKeyPress( Sender: TObject; var Key: Char );
      procedure cmbtablaExit( Sender: TObject );
      procedure cmbtablaClick( Sender: TObject );
      procedure bmasClick( Sender: TObject );
      procedure creaweb( );
      procedure crea_web( );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure webProgressChange( Sender: TObject; Progress,
         ProgressMax: Integer );
      procedure FormDeactivate( Sender: TObject );
      procedure grdDatosDBTableView1DblClick( Sender: TObject );
      procedure grdDatosDBTableView1CellClick( Sender: TcxCustomGridTableView;
         ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
         AShift: TShiftState; var AHandled: Boolean );
      procedure grdDatosDBTableView1FocusedRecordChanged(
         Sender: TcxCustomGridTableView; APrevFocusedRecord,
         AFocusedRecord: TcxCustomGridRecord;
         ANewItemRecordFocusingChanged: Boolean );
      procedure FormActivate( Sender: TObject );
      procedure cmbsistemaChange( Sender: TObject );
    procedure cmbsistemaExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure cmbtablaChange(Sender: TObject);

   private
      bPriCambio: boolean;
      filtro: string;
      cuenta: integer;
      fisicos: Tstringlist;
      xtabla, xclase, xbib, xprogra: string;
      mil: integer;
      it: Tlistitem;
      Opciones: Tstringlist;
      xfisicos: Tstringlist;
      sSistema: string;
      sPriSistema: string;
      procedure agrega( tabla: string; clase: string; bib: string; progra: string; modo: string; sistemas: string ); // it:Tlistitem);
      procedure agrega_fisico( tabla: string; clase: string; bib: string; progra: string; modo: string; sistemas: string );
      procedure lee;
      procedure panel_fantasma(visible:boolean);
   public
      { Public declarations }
      tipo: string;
      Wtabla: string;
      titulo: String;
      indicador : integer;  // para evitar el error cuando la consulta se hace desde el arbol o productos
      function ArmarOpciones( b1: Tstringlist ): Integer;
      procedure arma3( tablas: string; sistemas: string );
      procedure prepara2( tablas: string; sistemas: string );
   end;
var
   fmMatrizCrud: TfmMatrizCrud;

implementation
uses ptsdm, ptsgral, parbol, uListaRutinas, uConstantes;

{$R *.dfm}

procedure TfmMatrizCrud.prepara2( tablas: string; sistemas: string );
begin
   inherited;

   screen.cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      if ( tipo = 'TAB' ) or ( tipo = 'INS' ) or ( tipo = 'DEL' ) or ( tipo = 'UPD' ) or ( tipo = 'SEL' ) then
         filtro := '  hcclase in (' + g_q + 'TAB' + g_q + ',' + g_q + 'INS' + g_q + ',' + g_q + 'SEL' + g_q + ',' +
            g_q + 'DEL' + g_q + ',' + g_q + 'UPD' + g_q + ',' + g_q + 'IDX' + g_q + ') '
      else begin
         filtro := '  hcclase in (' + g_q + 'NVW' + g_q + ',' + g_q + 'NIN' + g_q + ',' + g_q + 'SEL' + g_q + ',' +
            g_q + 'NDL' + g_q + ',' + g_q + 'NUP' + g_q + ') ';

         caption := 'Uso de las Dataview';
         lv.Columns[ 0 ].Caption := 'Dataview';
         lv.Columns[ 4 ].Caption := 'Read';
         lv.Columns[ 5 ].Caption := 'Store';
         lv.Columns[ 6 ].Caption := 'Update';
         lv.Columns[ 7 ].Caption := 'Delete';
      end;
   finally
      cmbtabla.Text := tablas;
      cmbsistema.Text := sistemas;
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.FormCreate( Sender: TObject );
var
   sSQLClases: string;
   iSistema: Integer;
   sNomSistema, sListaSistemas: string;
begin
   inherited;

   caption := titulo;
   screen.cursor := crsqlwait;

   try
      fisicos := Tstringlist.Create;

      if dm.sqlselect( dm.q1, 'select * from tsclase where objeto=' + g_q + 'FISICO' + g_q +
         ' order by cclase' ) then begin
         while not dm.q1.Eof do begin
            fisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
            dm.q1.Next;
         end;
      end;

      xfisicos := Tstringlist.Create; // para controlar el loop en agrega_fisicos
      bPriCambio := false;

      if dm.sqlselect( DM.qmodify, 'Select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
         cmbSistema.Items.Clear;
         cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

         while not DM.qmodify.Eof do begin
            cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
            DM.qmodify.Next;
         end;
      end;

      //---------- para ocultar elementos inferiores y dejar panel fantasma  ---------   ALK
      panel_fantasma(false);
      // -----------------------------------------------------------------------------
      indicador:=0;
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.agrega( tabla: string; clase: string; bib: string;
   progra: string; modo: string; sistemas: string );
begin
   inherited;

   screen.Cursor := crsqlwait;

   try
      if ( trim( tabla ) <> trim( xtabla ) ) or
         ( trim( clase ) <> trim( xclase ) ) or
         ( trim( bib ) <> trim( xbib ) ) or
         ( trim( progra ) <> trim( xprogra ) ) then begin
         if mil > 1000 then begin
            lbltotal.Caption := 'Total  ' + inttostr( dm.q1.RecordCount ) + '  (1 - ' + inttostr( cuenta ) + ')';
            bmas.Visible := true;
            exit;
         end;

         it := lv.Items.Add;
         it.Caption := tabla;
         it.SubItems.Add( clase );
         it.SubItems.Add( bib );
         it.SubItems.Add( progra );
         it.SubItems.Add( ' ' );
         it.SubItems.Add( ' ' );
         it.SubItems.Add( ' ' );
         it.SubItems.Add( ' ' );
         it.SubItems.Add( sistemas );
         xtabla := tabla;
         xclase := clase;
         xbib := bib;
         xprogra := progra;
      end;

      if ( modo = 'TAB' ) or ( modo = 'NVW' ) or ( modo = 'SEL' ) or ( modo = 'IDX' ) then
         it.SubItems[ 3 ] := 'X'
      else if ( modo = 'INS' ) or ( modo = 'NIN' ) then
         it.SubItems[ 4 ] := 'X'
      else if ( modo = 'UPD' ) or ( modo = 'NUP' ) then
         it.SubItems[ 5 ] := 'X'
      else if ( modo = 'DEL' ) or ( modo = 'NDL' ) then
         it.SubItems[ 6 ] := 'X';

      inc( mil );
      inc( cuenta );
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.agrega_fisico( tabla: string; clase: string; bib: string;
   progra: string; modo: string; sistemas: string );
var
   qq: Tadoquery;
   lSistema: string;
begin
   inherited;

   screen.Cursor := crsqlwait;

   try
      if xfisicos.IndexOf( clase + '+' + bib + '+' + progra ) > -1 then
         exit;

      xfisicos.Add( clase + '+' + bib + '+' + progra );

      lSistema := '';

      if Trim( sistemas ) <> '' then
         lSistema := ' and   sistema=' + g_q + sistemas + g_q;

      if fisicos.IndexOf( clase ) = -1 then begin
         qq := Tadoquery.Create( self );
         qq.Connection := dm.ADOConnection1;

         if dm.sqlselect( qq,
            ' select distinct hcprog,hcclase,pcclase,pcbib,pcprog,sistema from tsrela ' +
            ' where hcprog=' + g_q + progra + g_q +
            ' and   hcbib=' + g_q + bib + g_q +
            ' and   hcclase=' + g_q + clase + g_q +
            //lSistema +
            ' and   pcclase<>' + g_q + 'CLA' + g_q + // porque se metio TAB como FISICO
            ' order by hcprog,pcclase,pcbib,pcprog,hcclase' ) then begin

            while not qq.Eof do begin
               agrega_fisico( tabla, qq.fieldbyname( 'pcclase' ).AsString,
                  qq.fieldbyname( 'pcbib' ).AsString,
                  qq.fieldbyname( 'pcprog' ).AsString, modo, qq.fieldbyname( 'sistema' ).AsString, ); // Recursivo

               qq.Next;
            end;

         end;
         qq.Free;
         exit;
      end;

      agrega( tabla, clase, bib, progra, modo, sistemas );
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.lee;
var
   tabla, clase, bib, progra, modo, sistemas: string;
begin
   inherited;

   screen.Cursor := crsqlwait;

   try
      tabla := '';
      mil := 0;

      repeat
         tabla := uppercase( dm.q1.FieldByName( 'hcprog' ).AsString );
         clase := dm.q1.FieldByName( 'pcclase' ).AsString;
         bib := dm.q1.FieldByName( 'pcbib' ).AsString;
         progra := dm.q1.FieldByName( 'pcprog' ).AsString;
         modo := dm.q1.FieldByName( 'hcclase' ).AsString;
         sistemas := dm.q1.FieldByName( 'sistema' ).AsString;

         if clase = 'IDX' then begin
            if dm.sqlselect( dm.q5, 'SELECT distinct pcclase,pcbib,pcprog,sistema ' +
               ' FROM TSRELA WHERE HCCLASE = ' + g_q + clase + g_q +
               ' AND HCBIB=' + g_q + bib + g_q +
               ' AND HCPROG=' + g_q + progra + g_q +
               ' AND PCCLASE = ' + g_q + 'CBL' + g_q +
               ' AND COMENT = ' + g_q + 'FIND' + g_q ) then begin
               while not dm.q5.Eof do begin
                  clase := dm.q5.FieldByName( 'pcclase' ).AsString;
                  bib := dm.q5.FieldByName( 'pcbib' ).AsString;
                  progra := dm.q5.FieldByName( 'pcprog' ).AsString;
                  xfisicos.Clear;
                  agrega_fisico( tabla, clase, bib, progra, modo, dm.q5.FieldByName( 'sistema' ).AsString );
                  dm.q5.next;
               end;
            end;
         end
         else begin
            xfisicos.Clear;
            agrega_fisico( tabla, clase, bib, progra, modo, sistemas ); // Recursivo
         end;

         dm.q1.Next;
      until dm.q1.Eof;

      lbltotal.Caption := 'Total  ' + inttostr( dm.q1.RecordCount );
      //bmas.Visible := false;
   finally
      //dm.q5.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.arma3( tablas: string; sistemas: string );
var
   lSistema, seleccion: string;
   n, i, iCtrTiempo, iProcesa: integer;
   o: integer;
   c, cc: string;
begin
   inherited;

   screen.Cursor := crsqlwait;

   try
      caption := titulo;
      lSistema := '';
      if ( trim( tablas ) = '' ) or ( trim( sistemas ) = '' ) then
         exit;

      lv.Items.Clear;
      tablas := stringreplace( tablas, '*', '%', [ rfreplaceall ] );

      if tablas = '%' then
         seleccion := ' where '
      else begin
         if pos( '%', tablas ) > 0 then
            seleccion := ' where hcprog like ' + g_q + tablas + g_q  + ' AND '
         else
            seleccion := ' where hcprog=' + g_q + tablas + g_q + ' AND ';
      end;


      if sistemas = 'TODOS LOS SISTEMAS' then begin
         //if cmbSistema.ItemIndex < 1 then begin
         iCtrTiempo := iCtrTiempo + 1;
         for n := 1 to cmbSistema.Items.Count - 1 do begin
            c := cmbSistema.items[ n ];
            if n = 1 then
               cc := c
            else
               cc := cc + '?' + c;
         end;

         cc := stringreplace( cc, '?', g_q + ',' + g_q, [ rfreplaceall ] );
         lSistema := ' and sistema in(' + g_q + cc + g_q + ')';
      end
      else if Trim( sistemas ) <> '' then  begin
            lSistema := ' and  sistema = ' + g_q + sistemas + g_q
      end;

      if dm.sqlselect( dm.q1,
         ' select  hcprog,hcclase,pcclase,pcbib,pcprog,sistema from tsrela ' +
         seleccion +  filtro +
         ' and pcclase not in ( ' + g_q + 'CLA' + g_q + ',' + g_q + 'DBA' + g_q + ')' + // CLA porque se metio TAB como FISICO y DBA agregado por ser el esquema de l base de datos
          lSistema  +
         ' group by hcprog,pcclase,pcbib,pcprog,hcclase,sistema' +
         ' order by hcprog,pcclase,pcbib,pcprog,hcclase,sistema' ) then begin
         cuenta := 0;
         lee;
      end;

      crea_web( );
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.bsalirClick( Sender: TObject );
begin
   inherited;

   close;
end;

procedure TfmMatrizCrud.lvClick( Sender: TObject );
var
   ite, nitem: Tlistitem;
   i: integer;
   linea: string;
begin
   inherited;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if lv.ItemIndex = -1 then
         exit;

      for i := 0 to lv.Items.Count - 1 do
         lv.Items[ i ].Checked := lv.Items[ i ].Selected;

      screen.cursor := crsqlwait;
      ite := lv.Items[ lv.itemindex ];

      if ite.SubItems[ 0 ] = 'ETP' then begin
         if dm.sqlselect( dm.q1, 'select * from tsrela ' +
            ' where hcprog=' + g_q + ite.SubItems[ 2 ] + g_q +
            ' and   hcbib=' + g_q + ite.SubItems[ 1 ] + g_q +
            ' and   hcclase=' + g_q + 'ETP' + g_q +
            ' and   pcclase<>' + g_q + 'ETP' + g_q ) then begin
            dm.trae_fuente( dm.q1.fieldbyname( 'sistema' ).AsString,
               dm.q1.fieldbyname( 'pcprog' ).AsString,
               dm.q1.fieldbyname( 'pcbib' ).AsString,
               dm.q1.fieldbyname( 'pcclase' ).AsString, texto );
         end
         else begin
            Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
               pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );
            abort;
         end;
      end
      else
         dm.trae_fuente( ite.SubItems[ 3 ], ite.SubItems[ 2 ], ite.SubItems[ 1 ], ite.SubItems[ 0 ], texto ); // REVISAR AQUI JCR

      lvindice.Items.Clear;

      if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
         texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );

      for i := 0 to texto.Lines.Count - 1 do begin
         linea := texto.Lines[ i ];

         while pos( uppercase( ite.Caption ), uppercase( linea ) ) > 0 do begin
            nitem := lvindice.Items.Add;
            nitem.Caption := inttostr( i + 1 );
            nitem.SubItems.Add( texto.Lines[ i ] );
            linea := copy( linea, pos( uppercase( ite.Caption ), uppercase( linea ) ) + length( ite.Caption ), 500 );
         end;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.lvindiceClick( Sender: TObject );
var
   i, y: integer;
begin
   inherited;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if ( lvindice.ItemIndex = -1 ) then
         exit;

      texto.SetFocus;
      texto.SelStart := 0;
      y := 0;

      for i := 0 to lvindice.Itemindex do
         y := posex( Wtabla, texto.Lines.text, y + 1 );

      texto.SelStart := y - 1;
      texto.SelLength := length( Wtabla );
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.textoDblClick( Sender: TObject );
var
   arch: string;
begin
   inherited;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if trim( texto.Text ) = '' then
         exit;

      screen.Cursor := crsqlwait;

      if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
         texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );

      arch := g_tmpdir + '\f' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.txt';
      texto.Lines.SaveToFile( arch );
      ShellExecute( 0, 'open', pchar( arch ), nil, PChar( g_tmpdir ), SW_SHOW );
      g_borrar.Add( arch );
      arch := g_tmpdir + '\ICONO_TICK.ico';
      g_borrar.Add( arch );
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.textoClick( Sender: TObject );
begin
   inherited;

   texto.setfocus;
end;

procedure TfmMatrizCrud.cmbtablaKeyPress( Sender: TObject; var Key: Char );
begin
   inherited;

   if trim( cmbtabla.Text ) = '' then
      cmbtabla.SetFocus;

   if Key = #13 then begin
      Key := #0; { eat enter key }
      Perform( WM_NEXTDLGCTL, 0, 0 ); { move to next control }
   end
end;

procedure TfmMatrizCrud.cmbtablaExit( Sender: TObject );
begin
   inherited;

   {gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if trim( cmbtabla.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo tabla no puede ir en blanco : ' + chr( 13 ) +
            'Ej. ' + chr( 13 ) + '     - El nombre completo del componente'
            + chr( 13 ) + '     - ABC*'
            + chr( 13 ) + '     - * (Puede tardar en mostrar resultados)' ) ),
            pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );
         cmbtabla.SetFocus;
      end
      else
         arma3( cmbtabla.Text, cmbSistema.text );

   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;   }
end;

procedure TfmMatrizCrud.cmbtablaClick( Sender: TObject );
begin
   inherited;

   cmbtabla.SetFocus;
end;

procedure TfmMatrizCrud.bmasClick( Sender: TObject );
var
   sis, tabla : String;
begin
   inherited;
   screen.Cursor := crsqlwait;


   try
      // ------  validar los combos ---------   ALK
      if trim( cmbsistema.Text ) = '' then begin
         cmbsistema.SetFocus;
         exit;
      end
      else
         sis:=cmbsistema.Text;
      {   <RGM20170506>
      if trim( cmbtabla.Text ) = '' then begin
         tabla:='*';
      end
      else
      }
      if (trim( cmbtabla.Text ) = '') or
         (trim( cmbtabla.Text ) = '*') then begin
         cmbtabla.text:='*';
         //cmbtabla.text:='';
         //cmbtabla.setfocus;
         //exit;
         if Application.MessageBox( pchar('El proceso puede tardar varios minutos.'+ chr( 13 ) +
                                    '¿Desea continuar sin algun filtro en el campo Tabla?' ),
                                    'Aviso', MB_YESNO ) <> IDYES then begin
            cmbtabla.setfocus;
            exit;
         end;
      end;
         tabla:=cmbtabla.Text;
      // -------------------------------------------

     { if dm.procrunning( 'Notepad.exe' ) then
         Application.MessageBox( pchar( dm.xlng( 'Ejecutando!!!!' ) ),
            pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK )
      else
         Application.MessageBox( pchar( dm.xlng( 'No esta Ejecutando!!!!' ) ),
            pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );

      SwitchDesktop( CreateDesktop( 'ClubDelphi', nil, nil, 0, MAXIMUM_ALLOWED, nil ) );
      Sleep( 12000 );
      SwitchDesktop( OpenDesktop( 'Default', 0, False, DESKTOP_SWITCHDESKTOP ) ); }

      //---------- para ocultar elementos inferiores y dejar panel fantasma  ---------   ALK
      //panel_fantasma(true);
      panel_fantasma(false);
      // -----------------------------------------------------------------------------

      indicador:=1;
      arma3( tabla, sis );

      //exit;
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.creaweb;
var
   i, ii, iii: integer;
   sPass: string;
   slDatos, slDatosAux: Tstringlist;

   function bExisteTexto( sParTexto: String ): Boolean;
   var
      i: Integer;
   begin
      Result := False;

      for i := 0 to slDatosAux.Count - 1 do begin
         if sParTexto = slDatosAux[ i ] then begin
            Result := True;
            Break;
         end;
      end;
   end;

   procedure AgruparDuplicados( var slParDatos: TStringList );
   var
      i: Integer;
      slPaso1, slPaso2: TStringList;

      function bExisteDatos(
         sParTabla, sParTipo, sParLibreria, sParComponente, sParSistema: String ): Boolean;
      var
         i: Integer;
         slPaso: TStringList;
      begin
         Result := False;

         slPaso := Tstringlist.create;
         try
            for i := 0 to slParDatos.Count - 1 do begin
               slPaso.CommaText := slParDatos[ i ];

               if ( slPaso[ 0 ] = sParTabla ) and ( slPaso[ 1 ] = sParTipo ) and
                  ( slPaso[ 2 ] = sParLibreria ) and ( slPaso[ 3 ] = sParComponente ) and
                  ( slPaso[ 8 ] = sParSistema ) then begin
                  Result := True;
                  Break;
               end;
            end;
         finally
            slPaso.Free;
         end;
      end;

      procedure ActualizaDatos(
         sParTabla, sParTipo, sParLibreria, sParComponente, sParSistema: String;
         sParSelect, sParInsert, sParUpdate, sParDelete: String );
      var
         i: Integer;
         slPaso: TStringList;
         sCadena: String;
         sSelect, sInsert, sUpdate, sDelete: String;
      begin
         slPaso := Tstringlist.create;
         try
            for i := 0 to slParDatos.Count - 1 do begin
               slPaso.CommaText := slParDatos[ i ];

               if ( slPaso[ 0 ] = sParTabla ) and ( slPaso[ 1 ] = sParTipo ) and
                  ( slPaso[ 2 ] = sParLibreria ) and ( slPaso[ 3 ] = sParComponente ) and
                  ( slPaso[ 8 ] = sParSistema ) then begin

                  sSelect := slPaso[ 4 ];
                  sInsert := slPaso[ 5 ];
                  sUpdate := slPaso[ 6 ];
                  sDelete := slPaso[ 7 ];

                  if LowerCase( Trim( slPaso[ 4 ] ) ) = 'false' then
                     if LowerCase( Trim( sParSelect ) ) <> 'false' then
                        sSelect := 'true';

                  if LowerCase( Trim( slPaso[ 5 ] ) ) = 'false' then
                     if LowerCase( Trim( sParInsert ) ) <> 'false' then
                        sInsert := 'true';

                  if LowerCase( Trim( slPaso[ 6 ] ) ) = 'false' then
                     if LowerCase( Trim( sParUpdate ) ) <> 'false' then
                        sUpdate := 'true';

                  if LowerCase( Trim( slPaso[ 7 ] ) ) = 'false' then
                     if LowerCase( Trim( sParDelete ) ) <> 'false' then
                        sDelete := 'true';

                  sCadena :=
                     Q + sParTabla + Q + ',' +
                     Q + sParTipo + Q + ',' +
                     Q + sParLibreria + Q + ',' +
                     Q + sParComponente + Q + ',' +
                     sSelect + ',' +
                     sInsert + ',' +
                     sUpdate + ',' +
                     sDelete + ',' +
                     Q + sParSistema + Q;

                  slParDatos[ i ] := sCadena;

                  Break;
               end;
            end;
         finally
            slPaso.Free;
         end;
      end;

   begin
      slPaso1 := Tstringlist.create;
      slPaso2 := Tstringlist.create;
      try
         slPaso1.Assign( slParDatos );

         slParDatos.Clear;

         for i := 0 to slPaso1.Count - 1 do begin
            slPaso2.CommaText := slPaso1[ i ];

            if bExisteDatos( slPaso2[ 0 ], slPaso2[ 1 ], slPaso2[ 2 ], slPaso2[ 3 ], slPaso2[ 8 ] ) then
               ActualizaDatos(
                  slPaso2[ 0 ], slPaso2[ 1 ], slPaso2[ 2 ], slPaso2[ 3 ], slPaso2[ 8 ],
                  slPaso2[ 4 ], slPaso2[ 5 ], slPaso2[ 6 ], slPaso2[ 7 ] )
            else
               slParDatos.Add( slPaso1[ i ] );
         end;

      finally
         slPaso1.Free;
         slPaso2.Free;
      end;
   end;

   // ----- Procedimiento para mostrar detalle del primer dato ------
   function muestraPrimerDato ():boolean;
   var
      nitem: Tlistitem;
      i: integer;
      linea: string;
      b1: string;
      m: Tstringlist;
   begin
      gral.PubMuestraProgresBar( True );
      screen.Cursor := crsqlwait;
      m := Tstringlist.Create;
   
      try
         gral.PopGral.Items.Clear;
   
         if not bPriCambio then begin
            muestraPrimerDato:=false;
            Exit;
         end;
   
         b1 := Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) + '|' +
            Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + '|' +
            Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + '|' +
            Trim( grdDatosDBTableView1.Columns[ 9 ].EditValue );
            Wtabla := Trim( grdDatosDBTableView1.Columns[ 1 ].EditValue );
   
         if ( b1 = '' ) or ( b1 = '|||' ) then begin
            muestraPrimerDato:=false;
            exit;
         end;
   
         b1 := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   
         m.CommaText := b1;
   
         if m.count < 3 then begin
            Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
               pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );
            m.free;
            muestraPrimerDato:=false;
            exit;
         end;
   
         if m[ 1 ] = 'ETP' then begin
            if dm.sqlselect( dm.q1, 'select * from tsrela ' +
               ' where hcprog=' + g_q + m[ 3 ] + g_q +
               ' and   hcbib=' + g_q + m[ 2 ] + g_q +
               ' and   hcclase=' + g_q + 'ETP' + g_q +
               ' and   pcclase<>' + g_q + 'ETP' + g_q ) then begin
               dm.trae_fuente( dm.q1.fieldbyname( 'sistema' ).AsString, dm.q1.fieldbyname( 'pcprog' ).AsString,
                  dm.q1.fieldbyname( 'pcbib' ).AsString,
                  dm.q1.fieldbyname( 'pcclase' ).AsString, texto );
            end
            else begin
               Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
                  pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );
               muestraPrimerDato:=false;
               abort;
            end;
         end
         else
            dm.trae_fuente( m[ 3 ],  m[ 0 ], m[ 2 ], m[ 1 ], texto ); // REVISAR AQUI JCR
   
         if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
            texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );
   
         lvindice.Items.Clear;
   
         for i := 0 to texto.Lines.Count - 1 do begin
            linea := texto.Lines[ i ];
   
            while pos( uppercase( Wtabla ), uppercase( linea ) ) > 0 do begin
               nitem := lvindice.Items.Add;
               nitem.Caption := inttostr( i + 1 );
               nitem.SubItems.Add( texto.Lines[ i ] );
               linea := copy( linea, pos( uppercase( Wtabla ), uppercase( linea ) ) + length( m[ 0 ] ), 500 );
            end;
         end;
   
      finally
         m.Free;
         gral.PubMuestraProgresBar( false );
         screen.Cursor := crdefault;
      end;
      muestraPrimerDato:=true;
   end;
   // ---------------------------------------------------------------
begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
      slDatos := Tstringlist.create;
      slDatos.Delimiter := ',';
      slDatosAux := Tstringlist.create;
      slDatos.Add( 'Tabla:String:250,Tipo:String:20,Libreria:String:250,Componente:String:250,Select:Boolean:0,Insert:Boolean:0,Update:Boolean:0,Delete:Boolean:0,Sistema:String:20' );

      for i := 0 to lv.items.Count - 1 do begin
         sPass := '"' + lv.items[ i ].caption + '",';

         for ii := 1 to lv.items.item[ i ].subitems.Count do begin
            if ii = 8 then
               sPass := sPass + '"' + lv.items.item[ i ].subitems[ ii - 1 ]
            else begin
               if ii > 3 then begin
                  if lv.items.item[ i ].subitems[ ii - 1 ] = 'X' then
                     sPass := sPass + '"' + 'true'
                  else
                     sPass := sPass + '"' + 'false';
               end
               else
                  sPass := sPass + '"' + lv.items.item[ i ].subitems[ ii - 1 ];
            end;
            if ii < 8 then
               sPass := sPass + '",'
            else
               sPass := sPass + '"'
         end;

         slDatos.Add( sPass );

         for iii := 0 to slDatos.count - 1 do begin
            if not bExisteTexto( slDatos[ iii ] ) then begin
               slDatosAux.Add( slDatos[ iii ] );
            end;
         end;

         slDatos.Assign( slDatosAux );
      end;

      AgruparDuplicados( slDatos );

      if tabDatos.Active then
         tabDatos.Active := False;

      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
      if bGlbPoblarTablaMem( slDatos, tabDatos ) then begin
         tabDatos.ReadOnly := True;

         GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
         GlbCrearCamposGrid( grdDatosDBTableView1 );

         grdDatosDBTableView1.ApplyBestFit( );
         lbltotal.Caption := 'Total: ' + inttostr( grdDatosDBTableView1.DataController.RecordCount );

         bPriCambio := true;

         //necesario para la busqueda //fercar
         //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
         GlbCrearCamposGrid( grdEspejoDBTableView1 );
         GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
         //fin necesario para la busqueda

         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

         if Visible = True then begin
            if indicador=1 then  // si se presiono el boton
               GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 )
            else begin
               //---------- para ocultar elementos inferiores y dejar panel fantasma  ---------   ALK
               panel_fantasma(true);
               
               GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
            end;
         end;
      end;

      // ------- Procedimiento para que muestre la informacion del primer dato ----
      if not muestraPrimerDato then  // si no pudo mostrar el primer dato, poner un panel
         if alkDocumentacion <> 1 then
            showMessage('Seleccione para obtener informacion');  //cambiar!!!

      // --------------------------------------------------------------------------
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.Crea_Web;
begin
   inherited;

   if lv.Items.Count <> 0 then begin
      panel_fantasma(true);
      CreaWeb
   end
   else begin
      if FormStyle = fsMDIChild then
         Application.MessageBox( pchar( dm.xlng( 'No existe información a procesar.' ) ),
            pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );

      panel_fantasma(false);
   end;
end;

function TfmMatrizCrud.ArmarOpciones( b1: Tstringlist ): Integer;
begin
   inherited;

   gral.EjecutaOpcionB( b1, sLISTA_MATRIZ_CRUD );
end;

procedure TfmMatrizCrud.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   inherited;
   if FormStyle = fsMDIChild then 
      dm.PubEliminarVentanaActiva( Caption );  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,13);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,13);     //borrar elemento del arreglo de productos
   }
   fisicos.Free;
   xfisicos.Free;
end;

procedure TfmMatrizCrud.webProgressChange( Sender: TObject; Progress,
   ProgressMax: Integer );
begin
   inherited;

   gral.PubAvanzaProgresBar;
end;

procedure TfmMatrizCrud.FormDeactivate( Sender: TObject );
begin
   inherited;

   gral.PopGral.Items.Clear;

   if dm.sqlselect( DM.qmodify, 'select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;

end;

procedure TfmMatrizCrud.grdDatosDBTableView1DblClick( Sender: TObject );
var
   sComponente: string;
begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      sComponente := Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 9 ].EditValue );

      if sComponente = '' then
         exit;

      bgral := stringreplace( trim( sComponente ), '|', ' ', [ rfReplaceAll ] );
      Opciones := gral.ArmarMenuConceptualWeb( sComponente, 'lista_componentes' );
      ArmarOpciones( Opciones );
      gral.PopGral.Popup( g_X, g_Y );
      sComponente := '';
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.grdDatosDBTableView1CellClick(
   Sender: TcxCustomGridTableView;
   ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
   AShift: TShiftState; var AHandled: Boolean );
var
   nitem: Tlistitem;
   i: integer;
   linea: string;
   b1: string;
   m: Tstringlist;
begin
   inherited;

   if ACellViewInfo.Item.Index <> 1 then
      Exit;

   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;

   try
      gral.PopGral.Items.Clear;

      if not bPriCambio then
         Exit;

      b1 := Trim( grdDatosDBTableView1.Columns[ 4 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 9 ].EditValue );
         Wtabla := Trim( grdDatosDBTableView1.Columns[ 1 ].EditValue );

      if ( b1 = '' ) or ( b1 = '|||' ) then
         exit;

      b1 := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );

      m.CommaText := b1;

      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );
         m.free;
         exit;
      end;

      if m[ 1 ] = 'ETP' then begin
         if dm.sqlselect( dm.q1, 'select * from tsrela ' +
            ' where hcprog=' + g_q + m[ 3 ] + g_q +
            ' and   hcbib=' + g_q + m[ 2 ] + g_q +
            ' and   hcclase=' + g_q + 'ETP' + g_q +
            ' and   pcclase<>' + g_q + 'ETP' + g_q ) then begin
            dm.trae_fuente( dm.q1.fieldbyname( 'sistema' ).AsString, dm.q1.fieldbyname( 'pcprog' ).AsString,
               dm.q1.fieldbyname( 'pcbib' ).AsString,
               dm.q1.fieldbyname( 'pcclase' ).AsString, texto );
         end
         else begin
            Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
               pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );
            abort;
         end;
      end
      else
         dm.trae_fuente( m[ 3 ],  m[ 0 ], m[ 2 ], m[ 1 ], texto ); // REVISAR AQUI JCR

      if pos( chr( 13 ) + chr( 10 ), texto.Text ) = 0 then // corrige cuando el fuente no tiene CR
         texto.Text := stringreplace( texto.Text, chr( 10 ), chr( 13 ) + chr( 10 ), [ rfreplaceall ] );

      lvindice.Items.Clear;

      for i := 0 to texto.Lines.Count - 1 do begin
         linea := texto.Lines[ i ];

         while pos( uppercase( Wtabla ), uppercase( linea ) ) > 0 do begin
            nitem := lvindice.Items.Add;
            nitem.Caption := inttostr( i + 1 );
            nitem.SubItems.Add( texto.Lines[ i ] );
            linea := copy( linea, pos( uppercase( Wtabla ), uppercase( linea ) ) + length( m[ 0 ] ), 500 );
         end;
      end;

   finally
      m.Free;
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;
end;

procedure TfmMatrizCrud.grdDatosDBTableView1FocusedRecordChanged(
   Sender: TcxCustomGridTableView; APrevFocusedRecord,
   AFocusedRecord: TcxCustomGridRecord;
   ANewItemRecordFocusingChanged: Boolean );
begin
   inherited;

   lvindice.Items.Clear;
   texto.Clear;
end;

procedure TfmMatrizCrud.FormActivate( Sender: TObject );
begin
   inherited;
   if dm.sqlselect( DM.qmodify, 'select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;

end;

procedure TfmMatrizCrud.cmbsistemaChange( Sender: TObject );
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

   //bmas.Enabled:=true;
   panel_fantasma(false);
   cmbtabla.Text:='';
   BitBtn2.Enabled:=true;;
end;



procedure TfmMatrizCrud.cmbsistemaExit(Sender: TObject);
begin
  inherited;
   {gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if trim( cmbSistema.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo Sistema no puede ir en blanco : ' + chr( 13 )
                   + chr( 13 ) + '     - Debe elegir un sistema del combo'
                   + chr( 13 ) + '     - Si elige - Todos los Sistemas -, '
                   + chr( 13 ) + '       el proceso puede tardar varios minutos' ) ),
            pchar( dm.xlng( sLISTA_MATRIZ_CRUD ) ), MB_OK );
         cmbSistema.SetFocus;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;  }
end;

procedure TfmMatrizCrud.FormResize(Sender: TObject);
var
   tam : integer;
begin
   inherited;
   tam:=180;

   if cmbSistema.width < 350 then
      cmbsistema.width:=350
   else
      cmbsistema.width:=Panel1.Width-tam;

end;

procedure TfmMatrizCrud.panel_fantasma(visible:boolean);
begin   
   //---------- para ocultar elementos inferiores y dejar panel fantasma  ---------   ALK
   tabLista.Visible:=visible;
   stbLista.Visible:=visible;
   cxSplitter1.Visible:=visible;
   texto.Visible:=visible;
   lvindice.Visible:=visible;
   cxSplitter2.Visible:=visible;
   lv.Visible:=false;
   
   if gral.bPubVentanaMaximizada = FALSE then begin
      Height := 600;    //para mostrar el grid de resultados  ALK
      //HorzScrollBar.Visible:=visible;
   end;
   // -----------------------------------------------------------------------------
end;

procedure TfmMatrizCrud.BitBtn2Click(Sender: TObject);
begin
   cmbsistema.SetFocus;
   bmas.Enabled:=false;
   panel_fantasma(false);
   cmbsistema.Clear;
   cmbtabla.Text:='';
   BitBtn2.Enabled:=false;
   
   if dm.sqlselect( DM.qmodify, 'select * from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Clear;
      cmbSistema.Items.Add( 'TODOS LOS SISTEMAS' );

      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
end;

procedure TfmMatrizCrud.cmbtablaChange(Sender: TObject);
begin
   inherited;
   if trim(cmbtabla.Text) <> '' then begin
      bmas.Enabled:=true;
      panel_fantasma(false);
   end
   else begin
      bmas.Enabled:=false;
   end;
end;

end.

