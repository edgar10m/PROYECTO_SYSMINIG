unit UfmListaCompo;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Printers,
   Dialogs, ufmSVSLista, cxStyles, cxCustomData, cxGraphics, cxFilter, ADODB, StrUtils,
   cxData, cxDataStorage, cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg,
   dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns,
   StdCtrls, Grids, ExtCtrls, cxGridTableView, ImgList, dxPSCore, dxPScxGridLnk,
   dxBarDBNav, dxmdaset, dxBar, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
   cxGridCustomTableView, cxEditRepositoryItems, cxGridDBTableView, cxGrid, cxPC,
   HTML_HELP, dxStatusBar, Buttons, cxSplitter;

type
   TfmListaCompo = class( TfmSVSLista )
      tabTotales: TdxMemData;
      dtsTotal: TDataSource;
    PanelLista: TPanel;
    Panel5: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbltotal: TLabel;
    Label4: TLabel;
    cmbclase: TComboBox;
    cmblibreria: TComboBox;
    cmbSistema: TComboBox;
    panelFantasma: TPanel;
    Image1: TImage;
    bejecuta: TBitBtn;
    BitBtn2: TBitBtn;
    cmbmascara: TEdit;
    listaComp: TcxGrid;
    cxGridDBTableViewLista: TcxGridDBTableView;
    cxGridLevelLista: TcxGridLevel;
    TabDatosLista: TdxMemData;
    DataLista: TDataSource;
    Splitter1: TcxSplitter;
      procedure FormCreate( Sender: TObject );
      procedure cmbclaseChange( Sender: TObject );
      procedure cmblibreriaChange( Sender: TObject );
      procedure cmbmascaraChange( Sender: TObject );
      procedure Acercade1Click( Sender: TObject );
      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure FormDeactivate( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure grdDatosDBTableViewListaDblClick( Sender: TObject );
      procedure grdDatosDBTableView1FocusedRecordChanged(
         Sender: TcxCustomGridTableView; APrevFocusedRecord,
         AFocusedRecord: TcxCustomGridRecord;
         ANewItemRecordFocusingChanged: Boolean );
      //procedure lstcomponenteClick( Sender: TObject );
      procedure cmbSistemaChange( Sender: TObject );
      procedure cmbSistemaExit( Sender: TObject );
      procedure cmbclaseExit( Sender: TObject );
      procedure cmblibreriaExit( Sender: TObject );
    procedure FormResize(Sender: TObject);
    procedure bejecutaClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure cxGridDBTableViewListaDblClick(Sender: TObject);
   private
      { Private declarations }
      clases: Tstringlist;
      clasesexiste: Tstringlist;
      excluyemenu: Tstringlist;
      Opciones: Tstringlist;
      sPriSistema: string;
      qconsulta: Tadoquery;
      oculta: integer;  //para indicar cuando aparece o desaparece panel fantasma
      sin_control:boolean;  //para indicar cuando tiene que ocultar o mostrar los controles
      procedure panel_fantasma(visible:boolean);
   public
      { Public declarations }
      procedure PubGeneraLista( sParClase, sParBib, sParProg: String;
         sParTitulo: String; sParSistema: String );
      function PubLlenaArregloClases( sParSistema :String ):boolean;
      procedure llena_combos_vacios(sParClase, sParBib, sParProg, sParSistema:String);
      procedure sin_controles(boton:integer);
   end;

var
   Wprog, Wbib, Wclase: String;
   f_top: integer;
   f_left: integer;
   WnomLogo: string;
   Wfecha: string;

implementation

uses
   ptsdm, ptsmain, facerca, ptsgral, QRCtrls, uListaRutinas, TypInfo,
   cxGridDBDataDefinitions, uConstantes,parbol;

{$R *.dfm}

procedure TfmListaCompo.PubGeneraLista( sParClase, sParBib, sParProg: String;
   sParTitulo: String; sParSistema: String );
begin
   gral.PubMuestraProgresBar( True );

   if not pubLlenaArregloClases( sParSistema ) then
      exit;

   if cmbSistema.Text='' then
      llena_combos_vacios(sParClase, sParBib, sParProg, sParSistema);

   try
      if ( sParClase = '' ) or ( sParProg = '' ) then
         Exit;

      if sParProg = 'SCRATCH' then
         Exit;

      //Caption := sParTitulo; //controlar desde el llamado
      tabLista.Caption := sParTitulo;

      GlbQuitarFiltrosGrid( grdDatosDBTableView1 );

      //panel_fantasma(true);  // para ocultar el panel fantasma

      GlbArmarListaCompo( tabDatos,
         sParSistema, sParClase, sParBib, sParProg, Caption, Clases, ExcluyeMenu, ClasesExiste );

      stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';

      //if not tabDatos.Active then begin //'No existe información procesar.'
      if tabDatos.RecordCount = 0 then begin
         if FormStyle = fsMDIChild then begin
            if alkDocumentacion = 0 then
               Application.MessageBox( 'No existe información.', 'Aviso', MB_OK );
         end;
         panel_fantasma(false);
         Exit;
      end;

      panel_fantasma(true);

      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      GlbCrearCamposGrid( grdDatosDBTableView1 );     //borra campos viejos y crea nuevos
      grdDatosDBTableView1.ApplyBestFit( );

      //necesario para la busqueda
      //en este caso usar grdEspejo para apoyarse en las busquedas y llenar slPublista
      GlbCrearCamposGrid( grdEspejoDBTableView1 );
      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      //fin necesario para la busqueda

      if Visible = True then
         GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );      //rutina global para colocarse en el primer registro

      oculta:=1;
      if TabDatosLista.RecordCount < 1 then
         bejecutaClick(self);
   finally
      gral.PubMuestraProgresBar( False );
      oculta:=0;
   end;
end;

procedure TfmListaCompo.FormCreate( Sender: TObject );
var
   sSQLClases: string;
   iSistema: Integer;
   sNomSistema, sListaSistemas: string;
   Wuser, ProdClase, lwLista, lwInSQL, lwSale: string;
   m: tStringlist;
begin
   inherited;
   panel_fantasma(false); // alk para mostrar el panel y ocultar todo lo demas
   sin_control:=true;  // Para indicar que SI debe ocultar los controles

   clases := Tstringlist.Create;
   clasesexiste := Tstringlist.Create;
   excluyemenu := TStringlist.Create;

   // ==============================
   {   if dm.sqlselect( dm.q1, 'select * from tsclase ' +
         ' where estadoactual=' + g_q + 'ACTIVO' + g_q +
         ' order by cclase' ) then begin
         while not dm.q1.Eof do begin
            clases.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
            dm.q1.Next;
         end;
      end;
   }
   // ==============================

   clasesexiste.AddStrings( clases );

   if dm.sqlselect( dm.q1, 'select dato from parametro where clave=' + g_q + 'EXCLUYEMENU' + g_q ) then begin
      while not dm.q1.Eof do begin
         excluyemenu.Add( dm.q1.fieldbyname( 'dato' ).AsString );
         dm.q1.Next;
      end;
   end;
   {
         //========================================================
         if cmbSistema.ItemIndex < 1 then begin
            for iSistema := 1 to cmbSistema.Items.Count - 1 do begin
               sNomSistema := cmbSistema.items[iSistema];
               if iSistema = 1 then
                  sListaSistemas := sNomSistema
               else
                  sListaSistemas := sListaSistemas + '?' + sNomSistema;
            end;
            sListaSistemas := stringreplace(sListaSistemas, '?', g_q + ',' + g_q, [rfreplaceall]);
            sPriSistema := ' and sistema in(' + g_q + sListaSistemas + g_q + ')';
         end
         else
            sPriSistema := ' and sistema = ' + g_q + cmbSistema.Text + g_q;
      //========================================================
    }

    //  -----------------   Llenar el combo de sistema  --------------------------
    if dm.sqlselect( DM.qmodify, 'select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      //cmbSistema.Items.Clear;
      //cmbSistema.Items.Add('-Todos los sistemas -');
      cmbSistema.Items.Add('TODOS LOS SISTEMAS');
      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add(dm.qmodify.fieldbyname( 'csistema' ).AsString);
         DM.qmodify.Next;
      end;
   end;
end;

procedure TfmListaCompo.cmbclaseChange( Sender: TObject );
var
   sis, cla, cons: string;
begin
   inherited;
   panel_fantasma(false);
   cmblibreria.Clear;
   cmblibreria.Enabled:=false;
   cmbmascara.Clear;
   cmbmascara.Enabled:=false;
   bejecuta.Enabled:=false;

   if cmbclase.Text ='' then exit;

   if cmbSistema.Text <> 'TODOS LOS SISTEMAS' then begin
      sis:=  ' where  sistema = ' + g_q + cmbSistema.Text + g_q;
      if cmbclase.Text <> 'TODAS LAS CLASES' then
         cla:=  ' and hcclase=' + g_q + cmbclase.Text + g_q
      else
         cla:= '';
   end
   else begin
      sis:='';
      if cmbclase.Text <> 'TODAS LAS CLASES' then
         cla:=  ' where hcclase=' + g_q + cmbclase.Text + g_q
      else
         cla:= '';
   end;

   cons:='select distinct hcbib from tsrela ' +
      sis + cla + ' order by hcbib';

   dm.feed_combo( cmblibreria, cons );
   cmblibreria.Items.Insert(0,'TODAS LAS BIBLIOTECAS');
   cmblibreria.Enabled:=true;
end;

procedure TfmListaCompo.cmblibreriaChange( Sender: TObject );
begin
   inherited;
   panel_fantasma(false);
   cmbmascara.Clear;
   cmbmascara.Enabled:=false;
   bejecuta.Enabled:=false;

   if cmblibreria.Text='' then exit;

   screen.Cursor := crsqlwait;
   cmbmascara.Enabled:=true;
   //bejecuta.Enabled:=true;

   screen.Cursor := crdefault;
end;

procedure TfmListaCompo.cmbmascaraChange( Sender: TObject );
begin
   inherited;
   {if cmbmascara.Text='' then
      cmbmascara.Text:='*';  }
   if trim(cmbmascara.Text) <> '' then begin
      bejecuta.Enabled:=true;
      panel_fantasma(false);
   end
   else begin
      bejecuta.Enabled:=false;
   end;
end;

procedure TfmListaCompo.Acercade1Click( Sender: TObject );
begin
   inherited;

   PR_ACERCA;
end;

function TfmListaCompo.ArmarOpciones( b1: Tstringlist ): integer;
var
   mm: Tstringlist;
begin
   inherited;

   mm := Tstringlist.Create;
   mm.CommaText := bgral;
   if mm.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Lista opciones ' ) ), MB_OK );
      mm.free;
      exit;
   end;
   gral.EjecutaOpcionB( b1, 'Lista Componentes' );
   mm.free;
end;

procedure TfmListaCompo.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   inherited;

   if FormStyle = fsMDIChild then 
      dm.PubEliminarVentanaActiva( Caption );  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,12);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,12);     //borrar elemento del arreglo de productos
  }
   clases.Free;
   clasesexiste.Free;
   excluyemenu.Free;
end;

procedure TfmListaCompo.FormDeactivate( Sender: TObject );
begin
   inherited;
   gral.PopGral.Items.Clear;
end;

procedure TfmListaCompo.FormActivate( Sender: TObject );
begin
   inherited;
   iHelpContext := IDH_TOPIC_T02800;
   g_producto := 'MENÚ CONTEXTUAL-LISTA DE COMPONENTES';
end;

procedure TfmListaCompo.grdDatosDBTableViewListaDblClick( Sender: TObject );
var
   sComponente: string;
   y: integer;
begin
   inherited;

   screen.Cursor := crsqlwait;
   try
      sComponente := Trim( grdDatosDBTableView1.Columns[ 3 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 2 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 1 ].EditValue ) + '|' +
         Trim( grdDatosDBTableView1.Columns[ 9 ].EditValue );

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

procedure TfmListaCompo.grdDatosDBTableView1FocusedRecordChanged(
   Sender: TcxCustomGridTableView; APrevFocusedRecord,
   AFocusedRecord: TcxCustomGridRecord;
   ANewItemRecordFocusingChanged: Boolean );
begin
   inherited;

   gral.PopGral.Items.Clear;
end;

{procedure TfmListaCompo.lstcomponenteClick( Sender: TObject );
var
   sTitulo: String;
   sClase, sBib, sProg, sSistema: String;
begin
   inherited;
   sSistema := cmbSistema.Text;
   sClase := cmbclase.Text;
   sBib := cmblibreria.Text;
   sProg := lstcomponente.Items[ lstcomponente.itemindex ];
   sTitulo := sLISTA_COMPONENTES + ' ' + sClase + ' ' + sBib + ' ' + sProg;

   if tabDatos.Active then
      tabDatos.Active := False;

   PubGeneraLista( sClase, sBib, sProg, sTitulo, sSistema );
end; }

procedure TfmListaCompo.cmbSistemaChange( Sender: TObject );
var
   sSQLClases: string;
begin
   inherited;
   panel_fantasma(false);
   cmblibreria.Clear;
   cmblibreria.Enabled:=false;
   cmbclase.Clear;
   cmbclase.Enabled:=false;
   cmbmascara.Clear;
   cmbmascara.Enabled:=false;

   bejecuta.Enabled:=false;
   BitBtn2.Enabled:=true;

   if cmbSistema.Text ='' then exit;

   //========================================================
   if cmbSistema.Text <> 'TODOS LOS SISTEMAS' then
      sPriSistema := ' and sistema = ' + g_q + cmbSistema.Text + g_q
   else
      sPriSistema := '';
   //========================================================

   cmbClase.Clear;
   sSQLClases := 'select unique hcclase from tsrela r , tsclase c where cclase = '
         + ' hcclase and estadoactual = ' + g_q + 'ACTIVO' + g_q
         //+ ' and  objeto = ' + g_q + 'FISICO' + g_q
         //+ ' and tipo = ' + g_q + 'ANALIZABLE' + g_q
         + ' and hcbib <> ' + g_q + 'BD' + g_q
         + sPriSistema + ' order by hcclase';

   dm.feed_combo( cmbclase, sSQLClases );
   cmbclase.Items.Insert(0,'TODAS LAS CLASES');

   cmbClase.Enabled:=true;
end;

procedure TfmListaCompo.cmbSistemaExit( Sender: TObject );
begin
   inherited;
   {gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if trim( cmbSistema.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo Sistema no puede ir en blanco : ' + chr( 13 )
            + chr( 13 ) + '     - Debe elegir un sistema del combo' ) ),
            pchar( dm.xlng( sLISTA_COMPONENTES ) ), MB_OK );
         cmbSistema.SetFocus;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;       }
end;

procedure TfmListaCompo.cmbclaseExit( Sender: TObject );
begin
   inherited;
{   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;

   try
      if trim( cmbclase.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo Clase no puede ir en blanco : ' + chr( 13 )
            + chr( 13 ) + '     - Debe elegir una clase del combo' ) ),
            pchar( dm.xlng( sLISTA_COMPONENTES ) ), MB_OK );
         cmbClase.SetFocus;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;    }
end;

procedure TfmListaCompo.cmblibreriaExit( Sender: TObject );
begin
   inherited;
   {gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      if trim( cmbLibreria.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'El campo Clase no puede ir en blanco : ' + chr( 13 )
            + chr( 13 ) + '     - Debe elegir una clase del combo' ) ),
            pchar( dm.xlng( sLISTA_COMPONENTES ) ), MB_OK );
         cmbLibreria.SetFocus;
      end;
   finally
      gral.PubMuestraProgresBar( false );
      screen.Cursor := crdefault;
   end;  }
end;

function TfmListaCompo.pubLlenaArregloClases( sParSistema: string ):boolean;
var
   sSQLClases: string;
   i, j, iSistema: Integer;
   sNomSistema, sListaSistemas: string;
   Wuser, ProdClase, lwLista, lwInSQL, lwSale, cons_aux: string;
   m: tStringlist;
////======
begin
   Wuser := 'ADMIN'; //Temporal

   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;
   lwSale := 'FALSE';

   while lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         cons_aux:= 'select distinct hcclase from tsrela ' +
            ' where sistema in (' + g_q+sParSistema +g_q+ ') and hcclase in (select cclase from tsclase where objeto=' + g_q + 'FISICO' + g_q +
            ' and estadoactual=' + g_q + 'ACTIVO' + g_q + ')' +
            ' order by hcclase';
         if dm.sqlselect( dm.q1, cons_aux ) then begin
            i := 1;
            while not dm.q1.Eof do begin
               clases.add( dm.q1.fieldbyname( 'hcclase' ).AsString );
               i := i + 1;
               dm.q1.Next;
            end;
         end
         else begin
            MessageDlg(PChar('Sin informacion en tsproductos para ' + g_producto),
            mtInformation,[mbOk],0);
            pubLlenaArregloClases:=false;
         end;
         lwSale := 'TRUE';
         pubLlenaArregloClases:=true;
      end
      else begin
         cons_aux:= 'select * from tsproductos  where  ccapacidad = ' + g_q + g_producto + g_q +
            ' and cuser = ' + g_q + Wuser + g_q;
         if dm.sqlselect( dm.q1, cons_aux ) then begin
            lwLista := dm.q1.fieldbyname( 'cclaseprod' ).AsString;
            m := Tstringlist.Create;
            m.CommaText := lwLista;

            for i := 0 to m.Count - 1 do
               clases.Add( m[ i ] ); // arreglo de clases

            for j := 0 to m.count - 1 do begin
               lwInSQL := trim( lwInSQL ) + ' ' + g_q + trim( m[ j ] ) + g_q + ' ';
            end;
            m.Free;
            lwInSQL := Trim( lwInSQL );

            if lwInSQL = '' then begin
               ProdClase := 'FALSE';
               CONTINUE;
            end;
            lwInSQL := stringreplace( lwInSQL, ' ', ',', [ rfreplaceall ] );
            if dm.sqlselect( dm.q2, 'select distinct hcclase from tsrela ' +
               ' where hcclase in (' + lwInSQL + ')' + ' order by hcclase' ) then begin
            end;
            lwSale := 'TRUE';
            pubLlenaArregloClases:=true;
         end
         else begin
            lwSale := 'TRUE';
            MessageDlg(PChar('Sin informacion en tsproductos para ' + g_producto),
            mtInformation,[mbOk],0);
            pubLlenaArregloClases:=false;
         end;
      end;
   end;
   // ==============================
end;

procedure TfmListaCompo.FormResize(Sender: TObject);
var
   tam : integer;
begin
   tam := 180;

   cmbsistema.width:=panel5.Width-tam;
   if cmbsistema.width < 350 then
      cmbsistema.width:=350;
  {else
      cmbsistema.width:=panel5.Width-tam;}

   cmbclase.width:=panel5.Width-tam;
   if cmbclase.width < 350 then
      cmbclase.width:=350;
   {else
      cmbclase.width:=panel5.Width-tam;}

   cmblibreria.width:=panel5.Width-tam;
   if cmblibreria.width < 350 then
      cmblibreria.width:=350;
   {else
      cmblibreria.width:=panel5.Width-tam; }

   {if cmbmascara.width < 350 then
      cmbmascara.width:=350
   else
      cmbmascara.width:=panel5.Width-tam;  }
end;

procedure TfmListaCompo.bejecutaClick(Sender: TObject);
var
   i: integer;
   sPass, cons: string;
   sis, cla, bib, masc : string;
   slDatos: Tstringlist;
   aClases: array of string;
begin
   gral.PubMuestraProgresBar( True );
   slDatos := Tstringlist.create;
   slDatos.Delimiter := ',';
   slDatos.Add('Nombre:String:20,Biblioteca:String:250,Clase:String:250,sistema:String:50' );
   if oculta = 1 then
      panel_fantasma(true)
   else
      panel_fantasma(false);

   try
      screen.Cursor := crsqlwait;
      //lstcomponente.Items.Clear;
      //PanelLista.Visible:=true;

      qconsulta := Tadoquery.Create( nil );
      qconsulta.Connection := dm.ADOConnection1;

      // ---------  ALK para expandir consultas ------------
      if cmbclase.Text <> 'TODAS LAS CLASES' then
         cla:=  ' where hcclase=' + g_q + cmbclase.Text + g_q
      else
         cla:= '';

      if cmblibreria.Text <> 'TODAS LAS BIBLIOTECAS' then begin
         if cla = '' then
            bib:=  ' where  hcbib=' + g_q + cmblibreria.Text + g_q
         else
            bib:=  ' and   hcbib=' + g_q + cmblibreria.Text + g_q;
      end
      else
         bib:= '';

      if cmbSistema.Text <> 'TODOS LOS SISTEMAS' then begin
         if (cla = '') and (bib = '') then
            sis:=  ' where sistema=' + g_q + cmbSistema.Text + g_q
         else
            sis:=  ' and sistema=' + g_q + cmbSistema.Text + g_q;
      end
      else
         sis:='';

      // ---------------------------------------------------

      if ( cmbmascara.Text = '%' ) or ( cmbmascara.Text = '*' ) or
         ( cmbmascara.Text = '' ) then begin
         cons:= 'select distinct hcprog, hcbib, hcclase, sistema' +
                ' from tsrela ' + cla + bib + sis +
                ' order by hcprog ';

         if dm.sqlselect( qconsulta, cons ) then begin
            while not qconsulta.Eof do begin
               slDatos.Add( '"' + qconsulta.fieldbyname( 'hcprog' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcbib' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcclase' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'sistema' ).AsString  + '"');
               qconsulta.Next;
            end;
         end
         else begin
            panel_fantasma(false);
            ShowMessage( 'No existe información procesar.' );
            exit;
         end;

      end
      else begin
         if (cla = '') and (bib = '') and (sis ='') then
            masc:= ' where hcprog like ' + g_q + stringreplace( cmbmascara.Text, '*', '%', [  rfreplaceall] ) + g_q
         else
            masc:= ' and hcprog like ' + g_q + stringreplace( cmbmascara.Text, '*', '%', [  rfreplaceall] ) + g_q;

         cons:= 'select distinct hcprog, hcbib, hcclase, sistema' +
                ' from tsrela ' + cla + bib + sis + masc + ' order by hcprog ';

         if dm.sqlselect( qconsulta, cons ) then begin
            while not qconsulta.Eof do begin
               slDatos.Add( '"' + qconsulta.fieldbyname( 'hcprog' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcbib' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'hcclase' ).AsString  + '",' +
                      '"' + qconsulta.fieldbyname( 'sistema' ).AsString  + '"');
               qconsulta.Next;
            end;
         end
         else begin
            panel_fantasma(false);
            ShowMessage( 'No existe información procesar.' );
            exit;
         end;
      end;

      Splitter1.Visible:=true;
      Splitter1.AlignSplitter:=salLeft;
      PanelLista.Visible:=true;
      PanelLista.Align:=alLeft;


      GlbQuitarFiltrosGrid( cxGridDBTableViewLista );
      if bGlbPoblarTablaMem( slDatos, TabDatosLista ) then begin
         TabDatosLista.ReadOnly := True;

         GlbHabilitarOpcionesMenu( mnuPrincipal, TabDatosLista.RecordCount > 0 );
         GlbCrearCamposGrid( cxGridDBTableViewLista );

         cxGridDBTableViewLista.ApplyBestFit( );
         //GlbFocusPrimerItemGrid( listaComp, cxGridDBTableViewLista );
      end;

      lbltotal.Caption := 'Total: ' + inttostr( qconsulta.RecordCount );
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmListaCompo.BitBtn2Click(Sender: TObject);
begin
  inherited;
   panel_fantasma(false);

   cmblibreria.Clear;
   cmblibreria.Enabled:=false;

   cmbclase.Clear;
   cmbclase.Enabled:=false;

   cmbmascara.Clear;
   cmbmascara.Enabled:=false;

   cmbsistema.Clear;
   if dm.sqlselect( DM.qmodify, 'select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      //cmbSistema.Items.Add('-Todos los sistemas -');
      cmbSistema.Items.Add('TODOS LOS SISTEMAS');
      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add(dm.qmodify.fieldbyname( 'csistema' ).AsString);
         DM.qmodify.Next;
      end;
   end;
   //cmbsistema.Items.Insert(0,'');
   cmbsistema.Focused;

   bejecuta.Enabled:=false;
   BitBtn2.Enabled:=false;
end;

procedure TfmListaCompo.llena_combos_vacios(sParClase, sParBib, sParProg, sParSistema:String);
var
   cons:String;
   slDatos : Tstringlist;
begin
   cmblibreria.Enabled:=true;
   cmbclase.Enabled:=true;
   cmbmascara.Enabled:=true;
   cmbsistema.Enabled:=true;
   bejecuta.Enabled:=true;

   Splitter1.Visible:=false;
   PanelLista.Visible:=false;

   cmblibreria.Clear;
   cmbclase.Clear;
   cmbmascara.Clear;
   cmbsistema.Clear;
   if dm.sqlselect( DM.qmodify, 'select csistema from tssistema where estadoactual = ' + g_q + 'ACTIVO' + g_q ) then begin
      cmbSistema.Items.Add('TODOS LOS SISTEMAS');
      while not DM.qmodify.Eof do begin
         cmbSistema.Items.Add(dm.qmodify.fieldbyname( 'csistema' ).AsString);
         DM.qmodify.Next;
      end;
   end;
   cmbsistema.ItemIndex:=cmbsistema.Items.IndexOf(sParSistema);

   cons := 'select unique hcclase from tsrela r , tsclase c where cclase = '
      + ' hcclase and estadoactual = ' + g_q + 'ACTIVO' + g_q
      //+ ' and tipo = ' + g_q + 'ANALIZABLE' + g_q
      + ' and hcbib <> ' + g_q + 'BD' + g_q
      + sPriSistema + ' order by hcclase';
   dm.feed_combo( cmbclase, cons );
   cmbclase.Items.Insert(0,'TODAS LAS CLASES');
   cmbclase.ItemIndex:= cmbclase.Items.IndexOf(sParClase);

   dm.feed_combo( cmblibreria, 'select distinct hcbib from tsrela ' +
      ' where hcclase=' + g_q + cmbclase.Text + g_q +
      ' and  sistema = ' + g_q + cmbSistema.Text + g_q +
      ' order by hcbib' );
   cmblibreria.Items.Insert(0,'TODAS LAS BIBLIOTECAS');
   cmblibreria.ItemIndex:= cmblibreria.Items.IndexOf(sParBib);

   cmbmascara.Text:=sParProg;

   slDatos := Tstringlist.create;
   slDatos.Delimiter := ',';
   slDatos.Add('Nombre:String:20,Biblioteca:String:250,Clase:String:250,sistema:String:50' );
   slDatos.Add('"' + sParProg + '",' +
               '"' + sParBib + '",' +
               '"' + sParClase + '",' +
               '"' + sParSistema + '"');

   if bGlbPoblarTablaMem( slDatos, TabDatosLista ) then begin
      TabDatosLista.ReadOnly := True;

      GlbHabilitarOpcionesMenu( mnuPrincipal, TabDatosLista.RecordCount > 0 );
      GlbCrearCamposGrid( cxGridDBTableViewLista );

      cxGridDBTableViewLista.ApplyBestFit( );
      //GlbFocusPrimerItemGrid( listaComp, cxGridDBTableViewLista );
   end;
end;


procedure TfmListaCompo.cxGridDBTableViewListaDblClick(Sender: TObject);
var
   sClase, sBib, sProg, sSistema, sTitulo: String;
begin
   inherited;
   screen.Cursor := crsqlwait;
   try
      sSistema := Trim( cxGridDBTableViewLista.Columns[ 4 ].EditValue );
      sClase := Trim( cxGridDBTableViewLista.Columns[ 3 ].EditValue );
      sBib := Trim( cxGridDBTableViewLista.Columns[ 2 ].EditValue );
      sProg := Trim( cxGridDBTableViewLista.Columns[ 1 ].EditValue );

      sTitulo := sLISTA_COMPONENTES + ' ' + sClase + ' ' + sBib + ' ' + sProg;

      if TabDatosLista.Active then
         TabDatosLista.Active := False;

      PubGeneraLista( sClase, sBib, sProg, sTitulo, sSistema);
   finally
      screen.Cursor := crdefault;
   end;
end;


procedure TfmListaCompo.panel_fantasma(visible:boolean);
begin
   // ------------  Procedimiento para mostrar resultados ----------------   ALK
   panelFantasma.Visible:=not visible;   // para dejar ver lo de abajo   ALK
   stbLista.Visible:=visible;   // para ver la barra de estado   ALK
   tabLista.Visible:=visible;

   if sin_control then begin
      Splitter1.Visible:=false;
      PanelLista.Visible:=false;
   end
   else begin
      Splitter1.Visible:=visible;
      Splitter1.AlignSplitter:=salLeft;
      PanelLista.Visible:=visible;
      PanelLista.Align:=alLeft;
   end;

   panelFantasma.Height := 600;

   if gral.bPubVentanaMaximizada = FALSE then
      Height := 600;
   // --------------------------------------------------------------------
end;

procedure TfmListaCompo.sin_controles(boton:integer);
begin
   if boton=1 then begin      // para quitar controles  ALK  (menu emergente)
      sin_control:=true;

      panelFantasma.Visible:=true;   // para no dejar ver lo de abajo   ALK
      panelFantasma.Height := 600;   // al iniciar, debe de tener el panel fantasma

      stbLista.Visible:=true;   // para ver la barra de estado   ALK
      Splitter1.Visible:=false;   // splitter - separador
      PanelLista.Visible:=false;  // para ver tabla de la izquierda
      Panel5.Visible:=false;     // controles
      //tabLista.Visible:=true;   // tabla principal (lista de componentes)
   end
   else begin    // para presentar controles ALK     (menu de mineria)
      sin_control:=false;

      stbLista.Visible:=true;   // para ver la barra de estado   ALK
      {Splitter1.Visible:=true;   // splitter - separador
      Splitter1.AlignSplitter:=salLeft;
      PanelLista.Visible:=true;  // para ver tabla de la izquierda
      PanelLista.Align:=alLeft;}
      Panel5.Visible:=true;     // controles
      //tabLista.Visible:=true;   // tabla principal (lista de componentes)

      panelFantasma.Visible:=true;   // para no dejar ver lo de abajo   ALK
      panelFantasma.Height := 600;   // al iniciar, debe de tener el panel fantasma
   end;

   if gral.bPubVentanaMaximizada = FALSE then
      Height := 600;
   // --------------------------------------------------------------------
end;

end.

