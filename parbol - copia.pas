unit parbol;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls,
   ImgList, ADODB, ExtCtrls, Menus, StdCtrls, ExtDlgs, shellapi, svsdelphi, InvokeRegistry, Rio,
   SOAPHTTPClient, mgflcob, mgflrpg, ufmMatrizAF, ptsmapanat, Grids, ptsproperty,
   ptsdghtml, ptsversionado, ptsbms, ptsbfr, jpeg, dxBar, cxControls, cxSplitter, ptsattribute,
   pstviewhtml, ptsdiagjcl, ptsscrsec, uConstantes, ufmUMLPaquetes, ufmUMLClases, ufmScheduler,
   ufmAnalisisImpacto, ufmListaCompo, ufmListaDependencias, UfmMatrizCrud, UfmConsCom, UfmRefCruz,
   ufmProcesos, ufmDocumentacion, ufmBloques, ufmListaDrill, ufmMatrizArchLog, ufmDigraSistema;

type
   TMyRec = record
      ocprog: string;
      ocbib: string;
      occlase: string;
      pnombre: string;
      pbiblioteca: string;
      pclase: string;
      hnombre: string;
      hbiblioteca: string;
      hclase: string;
      hijo_falso: boolean;
      registros: integer;
      sistema: string;
      orden: string;
   end;

type
   TGuarda = record
      clave: string;
      dato: string;
   end;

type
   Tfarbol = class( TForm )
      ScrollBox1: TScrollBox;
      OpenPictureDialog1: TOpenPictureDialog;
      popmemo: TPopupMenu;
      Notepad1: TMenuItem;
      tv: TTreeView;
      htt: THTTPRIO;
      Image1: TImage;
      Image2: TImage;
      memo: TRichEdit;
      cxSplitter1: TcxSplitter;
      mnuPrincipal: TdxBarManager;
      mnuConsulta: TdxBarButton;
      mnuAyuda: TdxBarButton;
      procedure FormCreate( Sender: TObject );
      procedure tvMouseDown( Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer );
      procedure tvExpanding( Sender: TObject; Node: TTreeNode;
         var AllowExpansion: Boolean );
      procedure cambia_icono( Sender: TObject );
      procedure tabla_crud( Sender: TObject );
      procedure archivo_fisico( Sender: TObject );
      procedure adabas_crud( Sender: TObject );
      procedure panel_preview( Sender: TObject );
      procedure formadelphi_preview( Sender: TObject );
      procedure natural_mapa_preview( Sender: TObject );
      //procedure diagramaproceso( Sender: TObject );
      procedure propiedades( Sender: TObject );
      procedure atributos( Sender: TObject );
      procedure vista_falsa( Sender: TObject );
      procedure vista_imagenes( sender: Tobject );
      procedure vista_htm( sender: Tobject );
      procedure vista_tsc( sender: Tobject );
      procedure lista_componentes( Sender: TObject );
      procedure lista_dependencias( Sender: TObject );
      procedure Notepad1Click( Sender: TObject );
      procedure popmemoPopup( Sender: TObject );
      procedure versionado( Sender: TObject );
      procedure VerFuente( Sender: TObject );
      procedure fmb_vista_pantalla( Sender: TObject );
      procedure nuevo_proyecto( Sender: TObject );
      procedure metricas_codepro( Sender: TObject );
      procedure dependencias_codepro( Sender: TObject );
      procedure diagramacbl( Sender: Tobject );
      procedure diagramacblx( nodotext: string );
      procedure DiagramaCOBOL( Sender: Tobject );
      procedure DiagramaFlujoWFL( Sender: Tobject );
      procedure DiagramaFlujoALG( Sender: Tobject );
      procedure DiagramaJerarquicoWFL( Sender: Tobject );
      procedure DiagramaJerarquicoALG( Sender: Tobject );
      //procedure diagramacbly( nodotext: string );
      procedure diagramajava( Sender: Tobject );
      procedure diagramajavax( nodotext: string );
      //procedure diagramajavay( nodotext: string );
      procedure dghtmlx( nodotext: string );
      procedure dghtmly( nodotext: string );
      procedure diagramarpg( Sender: Tobject );
      procedure diagramarpgx( nodotext: string );
      //procedure diagramarpgy( nodotext: string );
      procedure diagramanatural( Sender: Tobject );
      procedure diagramanaturalx( nodotext: string );
      procedure referencias_cruzadas( Sender: Tobject );
      procedure comparaconvertido( Sender: Tobject );
      procedure convertirgenexus( Sender: Tobject );
      procedure convertircblunix( Sender: Tobject );
      procedure convertirnatural( Sender: Tobject );
      procedure convertirngl( Sender: Tobject );
      procedure comparanatural_cobol( Sender: Tobject );
      procedure convertirnat_panta( Sender: Tobject );
      procedure comparanatural_cics( Sender: Tobject );
      procedure convertirnat_ddm( Sender: Tobject );
      procedure comparanatural_ddm( Sender: Tobject );
      procedure convertirnat_fdt( Sender: Tobject );
      procedure comparanatural_fdt( Sender: Tobject );
      procedure convertirnat_nmp( Sender: Tobject );
      procedure comparanatural_nmp( Sender: Tobject );
      procedure diagramaase( Sender: Tobject );
      procedure formavb_preview( sender: Tobject );
      procedure bms_preview( Sender: TObject );
      procedure conviertease2cob( sender: Tobject );
      procedure ventana1Click( Sender: TObject );
      procedure tvDragOver( Sender, Source: TObject; X, Y: Integer;
         State: TDragState; var Accept: Boolean );
      procedure borrar_item( Sender: TObject );
      procedure dghtml( sender: Tobject );
      procedure WtvExpanding( Node: TTreeNode );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure mnuConsultaClick( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      procedure mnuAyudaClick( Sender: TObject );
      procedure tvClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure tvMouseMove( Sender: TObject; Shift: TShiftState; X,
         Y: Integer );
   private
      { Private declarations }
      lastHintNode: TTreeNode;
      nodo_actual: Ttreenode;
      fmb_nombre_pantalla: string;
      ftsproperty: array of Tftsproperty;
      ftsattribute: array of Tftsattribute;
      ftsbms: array of Tftsbms;
      ftsrefcruz: array of TfmRefCruz; //framirez
      //    ftsrefcruz: array of Tftsrefcruz;                       //framirez
      ftsversionado: array of Tftsversionado;
      fmgflcob: array of Tfmgflcob;
      fmgflrpg: array of Tfmgflrpg;
      ftsarchivos: array of TfmMatrizAF;
      ftsmapanat: array of Tftsmapanat;
      //fmBuscaCompo: array of TftsBusca;
      ftsdghtml: array of Tftsdghtml;
      //      ftslistacompo: array of Tftslistacompo;                //framirez
      //      ftslistaDependencias: array of TftslistaDependencias;  //framirez
      //      ftstablas: array of Tftstablas;                        //framirez
      fmListaCompo: array of TfmListaCompo; //framirez
      aPriListaDependencias: array of TfmListaDependencias; //framirez
      afmMatrizCrud: array of TfmMatrizCrud;
      ftsviewhtml: array of Tftsviewhtml;
      ftsscrsec: array of Tftsscrsec;

      fmUMLPaquetes: array of TfmUMLPaquetes; //diagrama paquetes
      fmUMLClases: array of TfmUMLClases; //diagrama clases
      fmScheduler: array of TfmScheduler; //diagrama scheduler
      fmAnalisisImpacto: array of TfmAnalisisImpacto; //diagrama analisis impacto
      fmProcesos: array of TfmProcesos; //diagrama procesos
      ftsdiagjcl: array of Tftsdiagjcl; //diagrama flujo JCL
      fmBloques: array of TfmBloques; //diagrama de bloques //isaac
      fmDocumentacion: array of TfmDocumentacion; //documentacion
      fmListaDrill: array of TfmListaDrill; //lista Drill Down/Up
      fmMatrizArchLog: array of TfmMatrizArchLog; //matriz archivo logico
      fmDigraSistema: array of TfmDigraSistema; //diagrama del sistema

      guarda: array of TGuarda;
      clase_analizable: Tstringlist;
      clase_fisico: Tstringlist;
      clase_todas: Tstringlist;
      clase_VB: Tstringlist;
      clase_descripcion: Tstringlist;
      clase_descripcion_todas: Tstringlist;
      sistema_datos: Tstringlist;
      LongPrefi, RangRegs: integer;
      procedure xFormCreate( Sender: TObject );
      procedure nivel_clases( padre: Ttreenode; qq: TADOquery );
      procedure subsistemas( padre: Ttreenode; oficina: string; sistema: string );
      procedure expande( nodo: Ttreenode; nombre: string; bib: string;
         clase: string; veces: integer );
      function agrega_al_menu( titulo: string ): integer;
      procedure aisla_rutina_delphi( nombre: string );
      procedure BuscarTexto( nombre: string );
      procedure aisla_rutina_Visual_Basic( nombre: string );
      procedure aisla_rutina_CLS( nombre: string );
      procedure se_posiciona_en_la_linea( nombre: string );
      procedure SePosicionaLineaInicial( nombre: string; lwLinea: Integer );
      procedure rut_dghtml( nombre: string; bib: string; clase: string; fuente: string; salida: string );
      procedure rut_svsflcob( nombre: string; bib: string; clase: string; fuente: string; salida: string );
      procedure rut_svsflrpg( nombre: string; bib: string; clase: string; fuente: string; salida: string );
      function trae_descripcion( sistema: string; clase: string; biblioteca: string; nombre: string ): string;
      //procedure reglas_negocio( Sender: TObject );

      procedure DiagramaUMLPaquetes( Sender: TObject ); //diagrama paquetes
      procedure DiagramaUMLClases( Sender: TObject ); //diagrama clases
      procedure DiagramaScheduler( Sender: TObject ); //diagrama scheduler
      procedure DiagramaAnalisisImpacto( Sender: TObject ); //diagrama analisis impacto
      procedure DiagramaProcesos( Sender: TObject ); //diagrama procesos
      procedure Diagramajcl( Sender: Tobject ); //diagrama flujo JCL
      procedure DiagramaBloques( Sender: Tobject ); //diagrama bloques //isaac
      procedure Documentacion( Sender: Tobject ); //documentacion
      procedure ListaDrillDown( Sender: Tobject ); //lista Drill Down
      procedure ListaDrillUp( Sender: Tobject ); //lista Drill Up
      procedure MatrizArchLog( Sender: Tobject ); //matriz archivo logico
      procedure DiagramaSistema( Sender: TObject ); //diagrama del sistema
   public
      { Public declarations }
      ftsconscom: TfmConsCom;
      b_conscom: boolean;
      nodo_proyecto: Ttreenode;
      //memo_componente: string; //validar funcionalidad memo_componente
      x1, y1: Integer;
      sGblSis: String;
      procedure agrega_componente( nombre: string; bib: string; clase: string; nodo: Ttreenode = nil;
         pnombre: string = ''; pbib: string = ''; pclase: string = '' );
      function alta_a_proyecto( nombre: string; bib: string; clase: string; proyecto: string ): boolean;
      procedure GenerarDiagrama( lsNomFte: String; lsArchFte: String );
      procedure GenerarDiagramaNvo( lsNomFte: String; lsArchFte: String; parClase, parTipoDiagrama: String );
      procedure leer( );

   end;
var
   farbol: Tfarbol;

procedure PR_ARBOL;

implementation
uses
   ptsdm, psvsfmb, ptspanel, ptsgral, HtmlHlp, HTML_HELP, pbarra, ptsmain;
//isvsserver1,

{$R *.dfm}

procedure PR_ARBOL;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      Application.CreateForm( Tfarbol, farbol );
      if gral.bPubVentanaMaximizada = FALSE then begin
         farbol.Width := g_Width;
         farbol.Height := g_Height;
      end;
      //PR_PANTALLA;

      farbol.Image1.Visible := true;
      farbol.Memo.Visible := false;
      farbol.Show;

      dm.PubRegistraVentanaActiva( farbol.Caption );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure tfarbol.nivel_clases( padre: Ttreenode; qq: TADOquery );
var
   tcla, nodo: Ttreenode;
   reg: ^Tmyrec;
   nombre: string;
begin
   {
   if dm.sqlselect(dm.q4,'select pcprog, count(*) total from tsrela '+   // Clases
                        ' where pcclase='+g_q+'CLA'+g_q+
                        ' and   pcbib='+g_q+qq.fieldbyname('csistema').AsString+g_q+
                        ' group by pcprog '+
                        ' order by pcprog') then begin
   }

   if dm.sqlselect( dm.q4, 'select cclase pcprog, count(*) total from tsprog ' + // Clases
      ' where sistema=' + g_q + qq.fieldbyname( 'csistema' ).AsString + g_q +
      ' group by cclase ' +
      ' order by cclase' ) then begin

      while not dm.q4.Eof do begin
         {
         nombre:='';
         if dm.sqlselect(dm.q5,'select descripcion from tsclase '+
            ' where cclase='+g_q+dm.q4.fieldbyname('pcprog').AsString+g_q) then
            nombre:=dm.q5.fieldbyname('descripcion').asstring;
         }

         if dm.sqlselect( dm.q5, 'select * from tsclase ' +
            ' where cclase=' + g_q + dm.q4.fieldbyname( 'cclase' ).AsString + g_q +
            ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
            ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
            dm.q4.Next;
            continue;
         end;

         nombre := clase_descripcion[ clase_fisico.IndexOf( dm.q4.fieldbyname( 'pcprog' ).AsString ) ];

         tcla := tv.Items.AddChild( padre, dm.q4.fieldbyname( 'pcprog' ).AsString + ' - ' + nombre + ' [' + //-----> DESCRIPCION
            dm.q4.fieldbyname( 'total' ).AsString + ']' );
         new( reg );
         reg.pnombre := qq.fieldbyname( 'csistema' ).AsString;
         reg.pclase := 'SISTEMA';
         reg.hnombre := dm.q4.fieldbyname( 'pcprog' ).AsString;
         reg.hbiblioteca := qq.fieldbyname( 'csistema' ).AsString;
         reg.hclase := 'CLA';
         reg.hijo_falso := false;
         if ( dm.q4.FieldByName( 'total' ).AsInteger > 0 ) and
            ( dm.q4.FieldByName( 'total' ).AsInteger < 500 ) then begin
            reg.hijo_falso := true;
            nodo := tv.Items.AddChild( tcla, 'hijo falso' );
         end;
         tcla.Data := reg;
         tcla.ImageIndex := dm.lclases.IndexOf( reg.hclase );
         tcla.SelectedIndex := 0; // dm.lclases.IndexOf( reg.hclase );
         dm.q4.Next;
      end;
   end;
end;

procedure Tfarbol.subsistemas( padre: Ttreenode; oficina: string; sistema: string );
var
   qq: TADOQuery;
   ss: Ttreenode;
   reg: ^Tmyrec;
   descri: string;
begin
   qq := TADOQuery.Create( self );
   qq.Connection := dm.ADOConnection1;
   if dm.sqlselect( qq,
      'select * from tssistema ' + // Subsistemas
      ' where coficina=' + g_q + oficina + g_q +
      ' and cdepende=' + g_q + sistema + g_q +
      ' and estadoactual=' + g_q + 'ACTIVO' + g_q +
      ' order by csistema' ) then begin
      while not qq.Eof do begin

         if g_ArbolDescri = '1' then begin
            descri := qq.fieldbyname( 'csistema' ).AsString + ' - ' +
               qq.fieldbyname( 'descripcion' ).AsString;
         end
         else begin
            descri := qq.fieldbyname( 'descripcion' ).AsString;
         end;

         ss := tv.Items.AddChild( padre, descri );
         //ss := tv.Items.AddChild( padre, qq.fieldbyname( 'csistema' ).AsString + ' - ' +     //---->  DESCRIPCION
            //qq.fieldbyname( 'descripcion' ).AsString );
         new( reg );
         reg.pnombre := qq.fieldbyname( 'cdepende' ).AsString;
         reg.pclase := 'SISTEMA';
         reg.hnombre := qq.fieldbyname( 'csistema' ).AsString;
         reg.hclase := 'SISTEMA';
         reg.hijo_falso := false;
         ss.Data := reg;
         ss.ImageIndex := dm.lclases.IndexOf( reg.hclase );
         ss.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );;
         //subsistemas(ss,oficina,qq.fieldbyname('csistema').AsString);
         //if sistema_datos.IndexOf(qq.fieldbyname('csistema').AsString)>-1 then
            //nivel_clases(ss,qq);
         qq.Next;
      end;
   end;
   qq.free;
end;

procedure Tfarbol.Documentacion( Sender: Tobject ); //documentacion
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDOCUMENTACION + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmDocumentacion );
      SetLength( fmDocumentacion, iArreglo + 1 );
      fmDocumentacion[ iArreglo ] := TfmDocumentacion.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmDocumentacion[ iArreglo ].Width := g_Width;
         fmDocumentacion[ iArreglo ].Height := g_Height;
      end;

      fmDocumentacion[ iArreglo ].PubGeneraLista( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmDocumentacion[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.ListaDrillDown( Sender: Tobject ); //lista Drill Down
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;

      sTitulo := sLISTA_DRILLDOWN + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmListaDrill );
      SetLength( fmListaDrill, iArreglo + 1 );
      fmListaDrill[ iArreglo ] := TfmListaDrill.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmListaDrill[ iArreglo ].Width := g_Width;
         fmListaDrill[ iArreglo ].Height := g_Height;
      end;

      fmListaDrill[ iArreglo ].PubGeneraLista( DrillDown, Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, sTitulo );
      fmListaDrill[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.ListaDrillUp( Sender: Tobject ); //lista Drill Up
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;

      sTitulo := sLISTA_DRILLUP + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmListaDrill );
      SetLength( fmListaDrill, iArreglo + 1 );
      fmListaDrill[ iArreglo ] := TfmListaDrill.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmListaDrill[ iArreglo ].Width := g_Width;
         fmListaDrill[ iArreglo ].Height := g_Height;
      end;

      fmListaDrill[ iArreglo ].PubGeneraLista( DrillUp, Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, sTitulo );
      fmListaDrill[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.MatrizArchLog( Sender: Tobject ); //matriz archivo logico
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;

      sTitulo := sMATRIZ_ARCHIVO_LOG + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmMatrizArchLog );
      SetLength( fmMatrizArchLog, iArreglo + 1 );
      fmMatrizArchLog[ iArreglo ] := TfmMatrizArchLog.Create( Self );
      fmMatrizArchLog[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmMatrizArchLog[ iArreglo ].Width := g_Width;
         fmMatrizArchLog[ iArreglo ].Height := g_Height;
      end;

      fmMatrizArchLog[ iArreglo ].PubGeneraLista( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmMatrizArchLog[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.versionado( Sender: TObject );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      sGblSis := reg.sistema;
      titulo := 'Versiones ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      k := length( ftsversionado );
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      setlength( ftsversionado, k + 1 );
      ftsversionado[ k ] := Tftsversionado.create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsversionado[ k ].Width := g_Width;
         ftsversionado[ k ].Height := g_Height;
      end;
      ftsversionado[ k ].titulo := titulo;
      ftsversionado[ k ].arma( reg.hnombre, reg.hbiblioteca, reg.hclase, reg.sistema );
      ftsversionado[ k ].show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.VerFuente( Sender: TObject );
var
   reg: ^Tmyrec;
   k: integer;
   arch, arch1: string;
begin
   reg := nodo_actual.data;
   try
      if memo.Lines.Count > 0 then begin
         arch1 := reg.hnombre;
         bGlbQuitaCaracteres( arch1 );
         arch := g_tmpdir + '\' + stringreplace( arch1, '*', 'Reporte', [ rfreplaceall ] ) + '.txt';
         Memo.Lines.SaveToFile( arch );
         ShellExecute( 0, 'open', pchar( arch ), nil, PChar( g_tmpdir ), SW_SHOW );
         g_borrar.Add( arch );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Opción no realizada' + ', el archivo fuente no existe' ) ),
            pchar( 'Ver Fuente ' + dm.xlng( reg.hnombre ) ), MB_OK );
      end;
   finally
   end;
end;

procedure Tfarbol.bms_preview( Sender: TObject );
var
   reg: ^Tmyrec;
   k: integer;
   titulo, panta: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      //titulo := 'Vista Previa ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      titulo := reg.hnombre;
      if gral.bPubVentanaActiva( titulo ) then
         Exit;

      panta := g_tmpdir + '\bms_' + reg.hnombre;
      memo.Lines.SaveToFile( panta );
      g_borrar.Add( panta );
      k := length( ftsbms );
      setlength( ftsbms, k + 1 );
      ftsbms[ k ] := Tftsbms.create( self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsbms[ k ].Width := g_Width;
         ftsbms[ k ].Height := g_Height;
      end;
      //ftsbms[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsbms[ k ].titulo := titulo;
      ftsbms[ k ].arma( panta );
      ftsbms[ k ].show;
      //ftsbms[ k ].Invalidate;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.FormCreate( Sender: TObject );
var
   tp, tt, ts: Ttreenode;
   reg: ^Tmyrec;
   proyecto_ant, lwInSQL: string;
   descri, prodclase, lwSale, Wuser, lwLista: string;
   m: tstringlist;
   j: Integer;
begin
   mnuPrincipal.Style := gral.iPubEstiloActivo;

   leer( );
   Wuser := 'ADMIN';
   g_Wforma := 'arbol';
   if g_language = 'ENGLISH' then begin
      caption := 'Knowledge Base';
   end;
   htt.WSDLLocation := g_ruta + 'IsvsServer.xml';
   clase_fisico := tstringlist.Create; // Arma arreglo de fisicos
   clase_todas := tstringlist.Create; // Arma arreglo todas las clases
   clase_VB := tstringlist.Create;
   clase_descripcion := tstringlist.Create;
   clase_descripcion_todas := tstringlist.Create;
   {

    if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
       ' where objeto=' + g_q + 'FISICO' + g_q +
       ' order by cclase' ) then begin
       while not dm.q1.Eof do begin
          clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
          clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
          dm.q1.Next;
       end;
    end;
    }

   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;

   lwSale := 'FALSE';
   while lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
            ' where objeto = ' + g_q + 'FISICO' + g_q +
            ' and estadoactual = ' + g_q + 'ACTIVO' + g_q +
            ' order by cclase' ) then begin
            while not dm.q1.Eof do begin
               clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
               clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
               dm.q1.Next;
            end;
         end;
         lwSale := 'TRUE';
      end
      else begin
         if dm.sqlselect( dm.q1, 'select * from tsproductos  where  ccapacidad = ' + g_q + g_producto + g_q +
            ' and cuser = ' + g_q + Wuser + g_q ) then begin
            lwLista := dm.q1.fieldbyname( 'cclaseprod' ).AsString;
            m := Tstringlist.Create;
            m.CommaText := lwLista;
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
               while not dm.q2.Eof do begin
                  if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
                     ' where cclase = ' + g_q + dm.q2.fieldbyname( 'hcclase' ).AsString + g_q +
                     ' order by cclase' ) then begin
                     clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
                     clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
                  end;
                  dm.q2.Next;
               end;
            end;
            lwSale := 'TRUE';
         end
         else begin
            ProdClase := 'FALSE';
            CONTINUE;
         end;
      end;
   end;
   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where ( cclase like ' + g_q + 'W%' + g_q + ')' +
      ' and ( cclase not in (  ' + g_q + 'WFL' + g_q + ',' + g_q + 'WSD' + g_q + '))' +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         clase_VB.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;
   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where estadoactual = ' + g_q + 'ACTIVO' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         clase_todas.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         clase_descripcion_todas.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
         dm.q1.Next;
      end;
   end;
   clase_analizable := tstringlist.Create; // Arma arreglo de analizables
   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where tipo=' + g_q + 'ANALIZABLE' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         clase_analizable.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;
   sistema_datos := Tstringlist.create;
   if dm.sqlselect( dm.q1, 'select sistema,count(*) total from tsprog ' +
      ' group by sistema order by sistema' ) then begin
      while not dm.q1.Eof do begin
         sistema_datos.Add( dm.q1.fieldbyname( 'sistema' ).AsString );
         dm.q1.Next;
      end;
   end;

   // recupera longitud del prefijo  de parametro  clave "LongPrefi"
   if dm.sqlselect( dm.q2, 'select * from parametro where clave=' + g_q + 'LONGPREFI' + g_q ) = false then begin
      LongPrefi := 1;
      dm.sqlinsert( 'insert into parametro (CLAVE,SECUENCIA,DATO,DESCRIPCION) ' +
         ' values(' + g_q + 'LONGPREFI' + g_q + ',1,' + g_q + '1' + g_q + ',' +
         g_q + 'Longitud del prefijo, para la base de conocimiento' + g_q + ')' );
   end
   else begin
      LongPrefi := dm.q2.fieldbyname( 'dato' ).AsInteger;
   end;

   //recupera el rango de registros de parametro  clave "RangResgs"
   if dm.sqlselect( dm.q2, 'select * from parametro where clave=' + g_q + 'RANGREGS' + g_q
      + ' and secuencia = 1 ' ) = false then begin
      RangRegs := 100;
      dm.sqlinsert( 'insert into parametro (CLAVE,SECUENCIA,DATO,DESCRIPCION) ' +
         ' values(' + g_q + 'RANGREGS' + g_q + ',1,' + g_q + '100' + g_q + ',' +
         g_q + 'Rango de registros, para la base de conocimiento' + g_q + ')' );
   end
   else
      RangRegs := dm.q2.fieldbyname( 'dato' ).AsInteger;

   //   Application.CreateForm( Tftsconscom, ftsconscom );
   if dm.capacidad( 'Base Conocimiento - Arbol Principal' ) then begin
      if dm.sqlselect( dm.q1, 'select * from tsoficina order by coficina' ) then begin // Oficinas
         tp := tv.Items.AddFirst( nil, g_empresa );
         new( reg );
         reg.hnombre := g_empresa;
         reg.hclase := 'EMPRESA';
         reg.hijo_falso := false;
         tp.Data := reg;
         tp.ImageIndex := dm.lclases.IndexOf( reg.hclase );
         tp.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         while not dm.q1.Eof do begin

            if g_ArbolDescri = '1' then begin
               descri := dm.q1.fieldbyname( 'coficina' ).AsString + ' - ' + //-----> DESCRIPCION
               dm.q1.fieldbyname( 'descripcion' ).AsString;
            end
            else
               descri := dm.q1.fieldbyname( 'descripcion' ).AsString;

            tt := tv.Items.AddChild( tp, descri );

            //tt := tv.Items.AddChild( tp, dm.q1.fieldbyname( 'coficina' ).AsString + ' - ' +   //-----> DESCRIPCION
               //dm.q1.fieldbyname( 'descripcion' ).AsString );
            new( reg );
            reg.pnombre := g_empresa;
            reg.pclase := 'EMPRESA';
            reg.hnombre := dm.q1.fieldbyname( 'coficina' ).AsString;
            reg.hclase := 'OFICINA';
            reg.hijo_falso := true;
            tv.Items.AddChild( tt, 'hijo falso' );
            tt.Data := reg;
            tt.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            tt.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            {
            if dm.sqlselect(dm.q2,'select * from tssistema '+           // Sistemas
               ' where coficina='+g_q+dm.q1.fieldbyname('coficina').AsString+g_q+
               ' and cdepende'+g_is_null+
               ' and estadoactual='+g_q+'ACTIVO'+g_q+
               ' order by csistema') then begin
               while not dm.q2.Eof do begin
                  ts:=tv.Items.AddChild(tt,dm.q2.fieldbyname('csistema').AsString+' - '+
                     dm.q2.fieldbyname('descripcion').AsString);
                  new(reg);
                  reg.pnombre:=dm.q2.fieldbyname('coficina').AsString;
                  reg.pclase:='OFICINA';
                  reg.hnombre:=dm.q2.fieldbyname('csistema').AsString;
                  reg.hclase:='SISTEMA';
                  reg.hijo_falso:=false;
                  ts.Data:=reg;
                  ts.ImageIndex:=dm.lclases.IndexOf(reg.hclase);
                  ts.SelectedIndex:=0;
                  subsistemas(ts,dm.q2.fieldbyname('coficina').AsString,dm.q2.fieldbyname('csistema').AsString);
                  nivel_clases(ts,dm.q2);
                  dm.q2.Next;
               end;
            end;
            }
            dm.q1.Next;
         end;
      end;
   end;

   //   if dm.capacidad('Base Conocimiento - Busqueda') then
   //mbusqueda1.Visible := dm.capacidad( 'Base Conocimiento - Busqueda' );
   nodo_proyecto := tv.Items.Add( nil, 'Mis Proyectos' );
   new( reg );
   reg.hnombre := g_usuario;
   reg.hclase := 'USER';
   reg.hijo_falso := false;
   nodo_proyecto.Data := reg;
   nodo_proyecto.ImageIndex := dm.lclases.IndexOf( reg.hclase );
   nodo_proyecto.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
   if dm.sqlselect( dm.q1, 'select * from tsuserpro ' +
      ' where cuser=' + g_q + g_usuario + g_q +
      ' order by cproyecto,cclase,cbib,cprog' ) then begin
      while not dm.q1.Eof do begin
         if dm.q1.FieldByName( 'cproyecto' ).AsString <> proyecto_ant then begin
            proyecto_ant := dm.q1.FieldByName( 'cproyecto' ).AsString;
            tt := tv.Items.AddChild( nodo_proyecto, proyecto_ant ); //-----> DESCRIPCION
            new( reg );
            reg.hnombre := proyecto_ant;
            reg.hclase := 'USERPRO';
            reg.hijo_falso := false;
            tt.Data := reg;
            tt.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            tt.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         end;
         if dm.q1.fieldbyname( 'cprog' ).AsString <> '.' then begin
            agrega_componente( dm.q1.fieldbyname( 'cprog' ).AsString,
               dm.q1.fieldbyname( 'cbib' ).AsString,
               dm.q1.fieldbyname( 'cclase' ).AsString, tt,
               proyecto_ant, '', 'USERPRO' );
         end;
         dm.q1.Next;
      end;
   end;

   if gral.iPubVentanasActivas > 0 then ///
      gral.PubExpandeMenuVentanas( True );

end;

procedure Tfarbol.xFormCreate( Sender: TObject );
var
   tp, tt, ts: Ttreenode;
   reg: ^Tmyrec;
   proyecto_ant: string;
   lwInSQL: string;
   prodclase, lwSale, Wuser, lwLista: string;
   m: tstringlist;
   j: Integer;
begin
   g_Wforma := 'arbol';
   if g_language = 'ENGLISH' then begin
      caption := 'Knowledge Base';
   end;
   htt.WSDLLocation := g_ruta + 'IsvsServer.xml';
   clase_fisico := tstringlist.Create; // Arma arreglo de fisicos
   clase_descripcion := tstringlist.Create;
   {if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
       ' where objeto=' + g_q + 'FISICO' + g_q +
       ' order by cclase' ) then begin
       while not dm.q1.Eof do begin
          clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
          clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
          dm.q1.Next;
       end;
    end;    }

   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;

   lwSale := 'FALSE';
   while lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
            ' where objeto=' + g_q + 'FISICO' + g_q +
            ' order by cclase' ) then begin
            while not dm.q1.Eof do begin
               clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
               clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
               dm.q1.Next;
            end;
         end;
         lwSale := 'TRUE';
      end
      else begin
         if dm.sqlselect( dm.q1, 'select * from tsproductos  where  ccapacidad = ' + g_q + g_producto + g_q +
            ' and cuser = ' + g_q + Wuser + g_q ) then begin
            lwLista := dm.q1.fieldbyname( 'cclaseprod' ).AsString;
            m := Tstringlist.Create;
            m.CommaText := lwLista;
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
               while not dm.q2.Eof do begin
                  if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
                     ' where cclase = ' + g_q + dm.q2.fieldbyname( 'hcclase' ).AsString + g_q +
                     ' order by cclase' ) then begin
                     clase_fisico.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
                     clase_descripcion.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
                  end;
                  dm.q2.Next;
               end;
            end;
            lwSale := 'TRUE';
         end;
      end;
   end;

   clase_analizable := tstringlist.Create; // Arma arreglo de analizables
   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where tipo=' + g_q + 'ANALIZABLE' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         clase_analizable.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;
   sistema_datos := Tstringlist.create;
   if dm.sqlselect( dm.q1, 'select sistema,count(*) total from tsprog ' +
      ' group by sistema order by sistema' ) then begin
      while not dm.q1.Eof do begin
         sistema_datos.Add( dm.q1.fieldbyname( 'sistema' ).AsString );
         dm.q1.Next;
      end;
   end;
   //   Application.CreateForm( Tftsconscom, ftsconscom );
   if dm.capacidad( 'Base Conocimiento - Arbol Principal' ) then begin
      if dm.sqlselect( dm.q1, 'select * from tsoficina order by coficina' ) then begin // Oficinas
         tp := tv.Items.AddFirst( nil, g_empresa );
         new( reg );
         reg.hnombre := g_empresa;
         reg.hclase := 'EMPRESA';
         reg.hijo_falso := false;
         tp.Data := reg;
         tp.ImageIndex := dm.lclases.IndexOf( reg.hclase );
         tp.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         while not dm.q1.Eof do begin
            tt := tv.Items.AddChild( tp, dm.q1.fieldbyname( 'coficina' ).AsString + ' - ' + //-----> DESCRIPCION
               dm.q1.fieldbyname( 'descripcion' ).AsString );
            new( reg );
            reg.pnombre := g_empresa;
            reg.pclase := 'EMPRESA';
            reg.hnombre := dm.q1.fieldbyname( 'coficina' ).AsString;
            reg.hclase := 'OFICINA';
            reg.hijo_falso := false;
            tt.Data := reg;
            tt.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            tt.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            if dm.sqlselect( dm.q2, 'select * from tssistema ' + // Sistemas
               ' where coficina=' + g_q + dm.q1.fieldbyname( 'coficina' ).AsString + g_q +
               ' and cdepende' + g_is_null +
               ' and estadoactual=' + g_q + 'ACTIVO' + g_q +
               ' order by csistema' ) then begin
               while not dm.q2.Eof do begin
                  ts := tv.Items.AddChild( tt, dm.q2.fieldbyname( 'csistema' ).AsString + ' - ' + //-----> DESCRIPCION
                     dm.q2.fieldbyname( 'descripcion' ).AsString );
                  new( reg );
                  reg.pnombre := dm.q2.fieldbyname( 'coficina' ).AsString;
                  reg.pclase := 'OFICINA';
                  reg.hnombre := dm.q2.fieldbyname( 'csistema' ).AsString;
                  reg.hclase := 'SISTEMA';
                  reg.hijo_falso := false;
                  ts.Data := reg;
                  ts.ImageIndex := dm.lclases.IndexOf( reg.hclase );
                  ts.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
                  subsistemas( ts, dm.q2.fieldbyname( 'coficina' ).AsString, dm.q2.fieldbyname( 'csistema' ).AsString );
                  nivel_clases( ts, dm.q2 );
                  dm.q2.Next;
               end;
            end;
            dm.q1.Next;
         end;
      end;
   end;

   // if dm.capacidad('Base Conocimiento - Busqueda') then
   //mbusqueda1.Visible := dm.capacidad( 'Base Conocimiento - Busqueda' );

   nodo_proyecto := tv.Items.Add( nil, 'Mis Proyectos' );
   new( reg );
   reg.hnombre := g_usuario;
   reg.hclase := 'USER';
   reg.hijo_falso := false;
   nodo_proyecto.Data := reg;
   nodo_proyecto.ImageIndex := dm.lclases.IndexOf( reg.hclase );
   nodo_proyecto.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
   if dm.sqlselect( dm.q1, 'select * from tsuserpro ' +
      ' where cuser=' + g_q + g_usuario + g_q +
      ' order by cproyecto,cclase,cbib,cprog' ) then begin
      while not dm.q1.Eof do begin
         if dm.q1.FieldByName( 'cproyecto' ).AsString <> proyecto_ant then begin
            proyecto_ant := dm.q1.FieldByName( 'cproyecto' ).AsString;
            tt := tv.Items.AddChild( nodo_proyecto, proyecto_ant ); //-----> DESCRIPCION
            new( reg );
            reg.hnombre := proyecto_ant;
            reg.hclase := 'USERPRO';
            reg.hijo_falso := false;
            tt.Data := reg;
            tt.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            tt.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         end;
         if dm.q1.fieldbyname( 'cprog' ).AsString <> '.' then begin
            agrega_componente( dm.q1.fieldbyname( 'cprog' ).AsString,
               dm.q1.fieldbyname( 'cbib' ).AsString,
               dm.q1.fieldbyname( 'cclase' ).AsString, tt,
               proyecto_ant, '', 'USERPRO' );
         end;
         dm.q1.Next;
      end;
   end;

end;

function Tfarbol.agrega_al_menu( titulo: string ): integer;
var
   tt: Tmenuitem;
   k: integer;
begin
   tt := Tmenuitem.Create( gral.PopGral );
   tt.Caption := titulo;
   gral.PopGral.Items.Add( tt );
   k := gral.PopGral.Items.Count - 1;
   gral.PopGral.Items[ k ].Tag := nodo_actual.AbsoluteIndex;
   agrega_al_menu := k;
end;

procedure Tfarbol.fmb_vista_pantalla( Sender: TObject );
begin
   PR_FMB( fmb_nombre_pantalla );
end;

procedure Tfarbol.cambia_icono;
var
   clave, magic, clase: string;
   reg: ^Tmyrec;
   i, k: integer;
   icono: Ticon;
begin
   if openpicturedialog1.Execute = false then
      exit;
   clave := dm.file2blob( openpicturedialog1.FileName, magic );
   reg := nodo_actual.Data;
   dm.sqldelete( 'delete from parametro where clave=' + g_q + 'ICONO_' + reg.hclase + g_q );
   dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
      g_q + 'ICONO_' + reg.hclase + g_q + ',1,' +
      g_q + clave + g_q + ')' );
   k := dm.lclases.IndexOf( reg.hclase );
   icono := Ticon.Create;
   icono.Width := 16;
   icono.Width := 16;
   icono.LoadFromFile( openpicturedialog1.FileName );
   if k > -1 then begin
      dm.imgclases.Delete( k );
      dm.imgclases.InsertIcon( k, icono );
   end
   else begin
      dm.lclases.Add( reg.hclase );
      dm.imgclases.AddIcon( icono );
      clase := reg.hclase;
      for i := 0 to tv.Items.Count - 1 do begin
         reg := tv.Items[ i ].Data;
         if reg <> nil then
            if reg.hclase = clase then
               tv.Items[ i ].ImageIndex := dm.lclases.Count - 1;
      end;
   end;
end;

procedure Tfarbol.panel_preview;
var
   reg: ^Tmyrec;
   panta: string;
begin
   reg := nodo_actual.Data;
   panta := g_tmpdir + '\panel_' + reg.hnombre;
   memo.Lines.SaveToFile( panta );
   //PR_PANEL(dm.pathbib(panta));
   PR_PANEL( panta );
   deletefile( panta );
end;

procedure Tfarbol.formadelphi_preview;
var
   reg: ^Tmyrec;
   panta: string;
begin
   reg := nodo_actual.Data;
   panta := g_tmpdir + '\delphi_' + reg.hnombre;
   memo.Lines.SaveToFile( panta );
   fsvsdelphi.Close;
   PR_PANTALLA;
   fsvsdelphi.arma_pantalla( panta );
   fsvsdelphi.Show;
   deletefile( panta );
end;

procedure Tfarbol.formavb_preview;
var
   reg: ^Tmyrec;
   panta, Titulo: string;
   //k: integer;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try

      reg := nodo_actual.Data;

      Titulo := 'Vista Previa ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      panta := g_tmpdir + '\bfr_' + reg.hnombre;
      memo.Lines.SaveToFile( panta );
      //fsvsdelphi.Close;
      PR_BFR( panta, Titulo );
      deletefile( panta );

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;

end;

procedure Tfarbol.natural_mapa_preview;
var
   reg: ^Tmyrec;
   titulo, archivo: string;
   k: integer;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'Mapa Natural ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      k := length( ftsmapanat );
      setlength( ftsmapanat, k + 1 );
      ftsmapanat[ k ] := Tftsmapanat.Create( self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsmapanat[ k ].Width := g_Width;
         ftsmapanat[ k ].Height := g_Height;
      end;
      //ftsmapanat[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsmapanat[ k ].titulo := titulo;
      ftsmapanat[ k ].Show;
      ftsmapanat[ k ].Tag := k;
      archivo := g_tmpdir + '\' + reg.hnombre;
      memo.Lines.SaveToFile( archivo );
      {
      if dm.capacidad('Acceso local') then begin
         if fileexists(dm.pathbib(reg.hbiblioteca)+'\'+reg.hnombre) then begin
            copyfile(pchar(dm.pathbib(reg.hbiblioteca)+'\'+reg.hnombre),pchar(archivo),false);
         end;
      end
      else begin
         fte:=Tstringlist.Create;
         fte.Text:=(htt as isvsserver).GetTxt('svsget,'+reg.hclase+','+reg.hbiblioteca+','+reg.hnombre);
         if copy(fte.Text,1,7)='<ERROR>' then begin
            showmessage(fte.Text);
            fte.Free;
            exit;
         end;
         fte.SaveToFile(archivo);
         fte.free;
      end;
      }
      g_borrar.Add( archivo );
      ftsmapanat[ k ].arma( archivo );
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.ventana1click( Sender: TObject );
var
   ite: Tmenuitem;
begin
   ite := ( sender as Tmenuitem );
   if ite.Tag >= 17000 then begin // Ver HTML
      ftsviewhtml[ ite.Tag - 17000 ].WindowState := wsnormal;
      ftsviewhtml[ ite.Tag - 17000 ].show;
      ftsviewhtml[ ite.Tag - 17000 ].Invalidate;
   end
   else if ite.Tag >= 16000 then begin // archivos CRUD
      ftsarchivos[ ite.Tag - 16000 ].WindowState := wsnormal;
      ftsarchivos[ ite.Tag - 16000 ].show;
      ftsarchivos[ ite.Tag - 16000 ].Invalidate;
   end
   else if ite.Tag >= 15000 then begin // Atributos pantallas V.B.
      ftsattribute[ ite.Tag - 15000 ].WindowState := wsnormal;
      ftsattribute[ ite.Tag - 15000 ].show;
      ftsattribute[ ite.Tag - 15000 ].Invalidate;
   end
   else if ite.Tag >= 14000 then begin // Diagrama de Proceso
      //ftsdgcompo[ ite.Tag - 14000 ].WindowState := wsnormal;
      //ftsdgcompo[ ite.Tag - 14000 ].show;
      //ftsdgcompo[ ite.Tag - 14000 ].Invalidate;
   end
   else if ite.Tag >= 13000 then begin // Lista Componentes
      //ftslistacompo[ ite.Tag - 13000 ].WindowState := wsnormal; //framirez
      //ftslistacompo[ ite.Tag - 13000 ].show;                    //framirez
      //ftslistacompo[ ite.Tag - 13000 ].Invalidate;              //framirez

      //aPriListaCompo[ ite.Tag - 13000 ].WindowState := wsnormal; //framirez
      //aPriListaCompo[ ite.Tag - 13000 ].show; //framirez
      //aPriListaCompo[ ite.Tag - 13000 ].Invalidate; //framirez
   end
   else if ite.Tag >= 12000 then begin // BMS
      ftsbms[ ite.Tag - 12000 ].WindowState := wsnormal;
      ftsbms[ ite.Tag - 12000 ].show;
      ftsbms[ ite.Tag - 12000 ].Invalidate;
   end
   else if ite.Tag >= 11000 then begin // Versiones
      ftsversionado[ ite.Tag - 11000 ].WindowState := wsnormal;
      ftsversionado[ ite.Tag - 11000 ].show;
      ftsversionado[ ite.Tag - 11000 ].Invalidate;
   end
   else if ite.Tag >= 10000 then begin // Diagramas Html
      ftsdghtml[ ite.Tag - 10000 ].WindowState := wsnormal;
      ftsdghtml[ ite.Tag - 10000 ].show;
      ftsdghtml[ ite.Tag - 10000 ].Invalidate;
   end
   else if ite.Tag >= 9000 then begin // Diagramas RPG
      fmgflrpg[ ite.Tag - 9000 ].WindowState := wsnormal;
      fmgflrpg[ ite.Tag - 9000 ].show;
      fmgflrpg[ ite.Tag - 9000 ].Invalidate;
   end
      //   else if ite.Tag >= 8000 then begin // Busqueda
      //      ftsbusca[ ite.Tag - 8000 ].WindowState := wsnormal;
      //      ftsbusca[ ite.Tag - 8000 ].show;
      //      ftsbusca[ ite.Tag - 8000 ].Invalidate;
      //   end
   else if ite.Tag >= 7000 then begin // Mapa Natural
      ftsproperty[ ite.Tag - 7000 ].WindowState := wsnormal;
      ftsproperty[ ite.Tag - 7000 ].show;
      ftsproperty[ ite.Tag - 7000 ].Invalidate;
   end
   else if ite.Tag >= 6000 then begin // Mapa Natural
      ftsmapanat[ ite.Tag - 6000 ].WindowState := wsnormal;
      ftsmapanat[ ite.Tag - 6000 ].show;
      ftsmapanat[ ite.Tag - 6000 ].Invalidate;
   end
   else if ite.Tag >= 5000 then begin // Tablas CRUD
      //---------------------- framirez -----------------------------
      afmMatrizCrud[ ite.Tag - 5000 ].WindowState := wsnormal;
      afmMatrizCrud[ ite.Tag - 5000 ].show;
      afmMatrizCrud[ ite.Tag - 5000 ].Invalidate;
      //      ftstablas[ ite.Tag - 5000 ].WindowState := wsnormal;
      //      ftstablas[ ite.Tag - 5000 ].show;
      //      ftstablas[ ite.Tag - 5000 ].Invalidate;
      //-------------------------------------------------------------
   end
   else if ite.Tag >= 4000 then begin // Diagramas COBOL
      fmgflcob[ ite.Tag - 4000 ].WindowState := wsnormal;
      fmgflcob[ ite.Tag - 4000 ].show;
      fmgflcob[ ite.Tag - 4000 ].Invalidate;
   end
   else if ite.Tag >= 3000 then begin // Diagrama JCL
      //ftsdiagjcl[ ite.Tag - 3000 ].WindowState := wsnormal;
      //ftsdiagjcl[ ite.Tag - 3000 ].show;
      //ftsdiagjcl[ ite.Tag - 3000 ].Invalidate;
   end
   else if ite.Tag >= 2000 then begin // Documentación
      //ftsdocumenta[ ite.Tag - 2000 ].WindowState := wsnormal;
      //ftsdocumenta[ ite.Tag - 2000 ].show;
      //ftsdocumenta[ ite.Tag - 2000 ].Invalidate;
   end
   else if ite.Tag >= 1000 then begin // Referencias Cruzadas
      ftsrefcruz[ ite.Tag - 1000 ].WindowState := wsnormal;
      ftsrefcruz[ ite.Tag - 1000 ].show;
      ftsrefcruz[ ite.Tag - 1000 ].Invalidate;
   end
   else begin // Analisis de Impacto
      //ftsimpacto[ ite.Tag ].WindowState := wsnormal;
      //ftsimpacto[ ite.Tag ].show;
      //ftsimpacto[ ite.Tag ].Invalidate;
   end;
end;

{procedure Tfarbol.diagramaproceso;
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      gral.CambiaValorObjeto;
      reg := nodo_actual.data;
      titulo := 'Diagrama de Proceso ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsdgcompo );
      setlength( ftsdgcompo, k + 1 );
      ftsdgcompo[ k ] := Tftsdgcompo.Create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsdgcompo[ k ].Width := g_Width;
         ftsdgcompo[ k ].Height := g_Height;
      end;
      //ftsdgcompo[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsdgcompo[ k ].titulo := titulo;
      ftsdgcompo[ k ].arma( reg.hnombre, reg.hbiblioteca, reg.hclase );
      ftsdgcompo[ k ].ArmaDiagramaVisio( reg.hnombre, reg.hbiblioteca, reg.hclase );
      ftsdgcompo[ k ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;
}

procedure Tfarbol.lista_componentes;
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;

      if Nodo.hbiblioteca = 'SCRATCH' then begin
         Application.MessageBox( pchar( 'la biblioteca es ' + Nodo.hbiblioteca ),
            pchar( sLISTA_COMPONENTES ), MB_OK );
         Exit;
      end;

      sTitulo := sLISTA_COMPONENTES + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmListaCompo );
      setlength( fmListaCompo, iArreglo + 1 );
      fmListaCompo[ iArreglo ] := TfmListaCompo.Create( Self );
      fmListaCompo[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmListaCompo[ iArreglo ].Width := g_Width;
         fmListaCompo[ iArreglo ].Height := g_Height;
      end;

      fmListaCompo[ iArreglo ].Caption := sTitulo;
      fmListaCompo[ iArreglo ].PubGeneraLista( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, sTitulo, Nodo.sistema );
      fmListaCompo[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.lista_dependencias;
var
   reg: ^Tmyrec;
   k2: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      g_producto := 'MENÚ CONTEXTUAL-LISTA DEPENDENCIAS DE COMPONENTES';
      if reg.hbiblioteca = 'SCRATCH' then begin
         Application.MessageBox( pchar( dm.xlng( 'la biblioteca es ' + reg.hbiblioteca ) ),
            pchar( dm.xlng( 'Lista Dependencias ' ) ), MB_OK );
         abort;
      end;

      titulo := sLISTA_DEPENDENCIAS + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k2 := length( aPriListaDependencias );
      setlength( aPriListaDependencias, k2 + 1 );

      aPriListaDependencias[ k2 ] := TfmListaDependencias.create( Self );
      aPriListaDependencias[ k2 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         aPriListaDependencias[ k2 ].Width := g_Width;
         aPriListaDependencias[ k2 ].Height := g_Height;
      end;

      aPriListaDependencias[ k2 ].titulo := titulo;
      aPriListaDependencias[ k2 ].caption := titulo;

      aPriListaDependencias[ k2 ].arma3( reg.hclase, reg.hbiblioteca, reg.hnombre, reg.sistema );
      aPriListaDependencias[ k2 ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.propiedades;
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'Propiedades ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsproperty );
      setlength( ftsproperty, k + 1 );
      ftsproperty[ k ] := Tftsproperty.Create( Self );
      ftsproperty[ k ].titulo := titulo;
      ftsproperty[ k ].arma( reg.hnombre, reg.hbiblioteca, reg.hclase, reg.sistema );
      ftsproperty[ k ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.atributos;
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'Atributos ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsattribute );
      setlength( ftsattribute, k + 1 );
      ftsattribute[ k ] := Tftsattribute.Create( Self );
      ftsattribute[ k ].titulo := titulo;
      ftsattribute[ k ].arma_alfa( reg.ocprog, reg.ocbib, reg.occlase, reg.pnombre, reg.pbiblioteca, reg.pclase, reg.hnombre, reg.hbiblioteca, reg.hclase, reg.orden, reg.sistema );
      //ftsattribute[ k ].arma( reg.hnombre, reg.hbiblioteca, reg.hclase );
      ftsattribute[ k ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.vista_falsa;
var
   reg: ^Tmyrec;
begin
   reg := nodo_actual.data;
   if fileexists( reg.hnombre + '.jpg' ) then begin
      image2.Picture.LoadFromFile( reg.hnombre + '.jpg' );
      image2.Visible := true;
      memo.Visible := false;
      image2.BringToFront;
   end;
end;

procedure Tfarbol.vista_imagenes;
var
   reg: ^Tmyrec;
   //k: integer;
   //ventana: Tmenuitem;
   //titulo: string;
   extension: string;
   mux: string;
begin
   reg := nodo_actual.data;
   extension := reg.hclase;
   mux := g_tmpdir + '\' + reg.hnombre + '.' + extension;
   dm.bfile2file( reg.hnombre, reg.hbiblioteca, mux );
   x1 := 0;
   if fileexists( mux ) then begin
      try
         image2.Picture.LoadFromFile( mux );
         image1.Visible := false;
         image2.Visible := true;
         memo.Visible := false;
         image2.BringToFront;
         x1 := 1;
         g_borrar.Add( reg.hnombre + '.' + extension );
      except
         Application.MessageBox( pchar( dm.xlng( 'No es posible visualizar los archivos con .' + extension +
            ' ó el archivo es muy grande' ) ),
            pchar( dm.xlng( 'Vista de Imagenes ' ) ), MB_OK );
         image1.Visible := true;
         image2.Visible := false;
         memo.Clear;
         x1 := 0;
      end;
   end
   else begin
      image1.Visible := true;
      memo.Clear;
      image2.Visible := false;
   end;
end;

procedure Tfarbol.vista_htm;
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;

      if reg.hbiblioteca = 'SCRATCH' then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre ) ),
            pchar( dm.xlng( 'Vista Previa' ) ), MB_OK );
         exit;
      end;

      titulo := 'Vista Previa ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsviewhtml );
      setlength( ftsviewhtml, k + 1 );
      ftsviewhtml[ k ] := Tftsviewhtml.create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsviewhtml[ k ].Width := g_Width;
         ftsviewhtml[ k ].Height := g_Height;
      end;
      //ftslistacompo[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsviewhtml[ k ].titulo := titulo;
      ftsviewhtml[ k ].caption := titulo;
      ftsviewhtml[ k ].arma( reg.hclase, reg.hbiblioteca, reg.hnombre, reg.sistema );
      if fileexists( g_tmpdir + '\' + reg.hnombre + 'L' ) then begin
         ftsviewhtml[ k ].web.Navigate( g_tmpdir + '\' + reg.hnombre + 'L' );
         ftsviewhtml[ k ].Show;
         dm.PubRegistraVentanaActiva( Titulo );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Sin información para la aplicación' ) ),
            pchar( dm.xlng( 'Vista Previa ' ) ), MB_OK );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.vista_tsc;
var
   reg: ^Tmyrec;
   k: integer;
   titulo, lBib: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;

      if reg.hbiblioteca = 'SCRATCH' then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre ) ),
            pchar( dm.xlng( 'Vista Previa' ) ), MB_OK );
         exit;
      end;

      titulo := 'Vista Previa ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsscrsec );
      setlength( ftsscrsec, k + 1 );
      ftsscrsec[ k ] := Tftsscrsec.create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsscrsec[ k ].Width := g_Width;
         ftsscrsec[ k ].Height := g_Height;
      end;
      //ftsscrsec[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsscrsec[ k ].titulo := titulo;
      ftsscrsec[ k ].caption := titulo;
      ftsscrsec[ k ].Show;
      if dm.sqlselect( dm.q5, 'select * from tsrela where hcclase=' + g_q + reg.hclase
         + g_q + ' and hcprog =' + g_q + reg.hnombre + g_q ) then begin
         lBib := dm.pathbib( dm.q5.fieldbyname( 'pcbib' ).AsString, dm.q5.fieldbyname( 'pcclase' ).AsString );
         ftsscrsec[ k ].pinta( lBib + '\' + dm.q5.fieldbyname( 'pcprog' ).AsString );
         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.aisla_rutina_delphi( nombre: string );
var
   i: integer;
begin
   nombre := '.' + copy( nombre, pos( '_', nombre ) + 1, 500 );
   while ( pos( nombre, uppercase( memo.Lines[ 0 ] ) ) < 1 ) and
      ( memo.Lines.Count > 0 ) do
      memo.Lines.delete( 0 );
   i := 1;
   while ( pos( 'PROCEDURE', uppercase( memo.Lines[ i ] ) ) < 1 ) and
      ( pos( 'FUNCTION', uppercase( memo.Lines[ i ] ) ) < 1 ) and
      ( i < memo.Lines.Count - 2 ) do
      inc( i );
   while i < memo.Lines.Count do
      memo.Lines.Delete( i );
end;

procedure Tfarbol.aisla_rutina_Visual_Basic( nombre: string );
var
   i, ii: integer;
   w2: string;
   W: Tstringlist;
   Wbegin, Wend: Integer;
begin
   i := 0;
   W := Tstringlist.create;
   Wbegin := 0;
   Wend := 0;
   while i < memo.Lines.Count - 2 do begin
      w2 := uppercase( memo.Lines[ i ] );
      if ( pos( nombre, w2 ) > 0 ) then begin
         if ( pos( 'PRIVATE ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PRIVATE SUB', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'DECLARE ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC SUB ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'FUNCTION ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC FUNCTION ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'BEGIN ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'SUB ', uppercase( memo.Lines[ i ] ) ) > 0 ) then begin
            if ( pos( 'BEGIN ', uppercase( memo.Lines[ i ] ) ) > 0 ) then
               Wbegin := Wbegin + 1;
            W.add( memo.Lines[ i ] );
            ii := i + 1;
            i := i + memo.Lines.Count + 1;
         end;
      end;
      i := i + 1;
   end;

   if Wbegin > 0 then begin
      while ( Wbegin <> Wend ) do begin
         if ( pos( 'BEGIN', uppercase( memo.Lines[ ii ] ) ) > 0 ) then
            Wbegin := Wbegin + 1;
         if ( pos( 'END', uppercase( memo.Lines[ ii ] ) ) > 0 ) then
            Wend := Wend + 1;
         W.add( memo.Lines[ ii ] );
         ii := ii + 1;
         if ii > memo.Lines.Count - 2 then begin
            Wbegin := Wbegin + 1;
            Wend := Wend + 1;
            break;
         end;
         if ( Wbegin = Wend ) then begin
            Wbegin := Wbegin + 1;
            Wend := Wend + 1;
            break;
         end;
      end;
   end
   else begin
      while
         ( pos( 'END SUB', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         ( pos( 'PRIVATE ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         ( pos( 'PRIVATE SUB', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         ( pos( 'DECLARE ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         ( pos( 'PUBLIC ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         ( pos( 'PUBLIC SUB', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         ( pos( 'FUNCTION ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         ( pos( 'PUBLIC FUNCTION ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
         //( pos( 'BEGIN ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
//( pos( 'SUB ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( ii < memo.Lines.Count - 2 ) do begin
         if ( pos( ' EXIT ', uppercase( memo.Lines[ ii ] ) ) < 1 ) then
            W.add( memo.Lines[ ii ] );
         ii := ii + 1;
      end;
      W.add( memo.Lines[ ii ] );
   end;

   W.savetofile( nombre + '.txt' );
   W2 := g_q + g_tmpdir + '\' + nombre + g_q;
   memo.Lines.LoadFromFile( nombre + '.txt' );
   //memo_componente := ''; //validar funcionalidad memo_componente
   memo.Visible := true;
   {   try
         deletefile( nombre + '.txt' );
      except
      end;
      }
   W.Free;
end;

{procedure Tfarbol.aisla_rutina_Visual_Basic( nombre: string );
var
   i, ii: integer;
   w2: string;
   W: Tstringlist;
begin
   i := 0;
   W := Tstringlist.create;
   while i < memo.Lines.Count - 2 do begin
      w2 := uppercase( memo.Lines[ i ] );
      if ( pos( nombre, w2 ) > 0 ) then begin
         if ( pos( 'PRIVATE ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PRIVATE SUB', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'DECLARE ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC SUB ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'FUNCTION ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC FUNCTION ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'BEGIN ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'SUB ', uppercase( memo.Lines[ i ] ) ) > 0 ) then begin
            W.add( memo.Lines[ i ] );
            ii := i + 1;
            i := i + memo.Lines.Count + 1;
         end;
      end;
      i := i + 1;
   end;
   while
      ( pos( 'PRIVATE ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'PRIVATE SUB', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'DECLARE ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'PUBLIC ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'PUBLIC SUB', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'FUNCTION ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'PUBLIC FUNCTION ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'BEGIN ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'SUB ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( ii < memo.Lines.Count - 2 ) do begin
      if ( pos( ' EXIT ', uppercase( memo.Lines[ ii ] ) ) < 1 ) then
         W.add( memo.Lines[ ii ] );
      ii := ii + 1;
   end;
   W.savetofile( nombre + '.txt' );
   W2 := g_q + g_tmpdir + '\' + nombre + g_q;
   memo.Lines.LoadFromFile( nombre + '.txt' );
   memo_componente := '';
   memo.Visible := true;
   try
      deletefile( nombre + '.txt' );
   except
   end;
   W.Free;
end;
}

procedure Tfarbol.BuscarTexto( nombre: string );
var
   Posicion: longint;
   m, i: integer;
begin
   //revisar funcionalidad ocasiona lentitud
   {
   i := 1;
   while ( pos( nombre, memo.Lines[ i ] ) < 1 ) and
      ( i < memo.Lines.Count - 2 ) do
      inc( i );

   //Saber la posición de una cadena en un TMemo
   Posicion := Pos( nombre, Memo.Text ) - 1;

   //Mover el Cursor (caret) hasta allí
   //Move the caret
   //with Memo do
   //begin
   //  SelStart:=Posicion;
   //  SelLength:=0;
   //  SetFocus;
   //end;

   //Resaltar la cadena en el TMemo:
   //if posicion > 0 then begin
   //   with Memo do begin
   //      SelStart := Posicion;
   //      SelLength := Length( nombre );
   //      memo.SelAttributes.Color := clblue;
   //   end;
   //   memo.Perform( EM_SCROLLCARET, 0, 0 );
   //   m := memo.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
   //   m := i - m - 30;
   //   memo.Perform( EM_LINESCROLL, 0, m );
   //end;

   //else begin
      //Application.MessageBox( pchar( dm.xlng( 'Línea o texto, no encontrados' ) ),
      //   pchar( dm.xlng( 'Buscar ' ) ), MB_OK );
   //end;
   }
end;

procedure Tfarbol.aisla_rutina_CLS( nombre: string );
var
   i, ii, w1: integer;
   w2: string;
   W: Tstringlist;
begin
   i := 0;
   W := Tstringlist.create;
   while i < memo.Lines.Count - 2 do begin
      w2 := uppercase( memo.Lines[ i ] );
      if ( pos( nombre, w2 ) > 0 ) then begin
         if ( pos( 'PROPERTY ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'FUNCTION ', uppercase( memo.Lines[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC SUB ', uppercase( memo.Lines[ i ] ) ) > 0 ) then begin
            W.add( memo.Lines[ i ] );
            ii := i + 1;
            i := i + memo.Lines.Count + 1;
         end;
      end;
      i := i + 1;
   end;
   while
      ( pos( 'PROPERTY ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'FUNCTION ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( pos( 'PUBLIC SUB ', uppercase( memo.Lines[ ii ] ) ) < 1 ) and
      ( ii < memo.Lines.Count - 2 ) do begin
      if ( pos( ' EXIT ', uppercase( memo.Lines[ ii ] ) ) < 1 ) then
         W.add( memo.Lines[ ii ] );
      ii := ii + 1;
   end;
   W.savetofile( nombre + '.txt' );
   W2 := g_q + g_tmpdir + '\' + nombre + g_q;
   memo.Lines.LoadFromFile( nombre + '.txt' );
   //memo_componente := ''; //validar funcionalidad memo_componente
   memo.Visible := true;
   try
      deletefile( nombre + '.txt' );
   except
   end;
   W.Free;
end;

procedure Tfarbol.se_posiciona_en_la_linea( nombre: string );
var
   i, f, l, linea, m: integer;
   texto, Wtexto: string;
begin

   texto := nodo_actual.text;
   i := pos( '[', texto ) + 1;
   f := pos( ']', texto );
   l := f - i;
   if l > 0 then begin
      try
         Wtexto := copy( texto, i, l );
         if gral.EsNumerico( Wtexto ) then
            linea := strtoint( Wtexto )
         else begin
            //            Application.MessageBox(pchar(dm.xlng('El dato entre [  ], debe ser numérico')),
            //                             pchar(dm.xlng('Se posiciona en la línea')), MB_OK );

            linea := 0;
         end;
      except
         linea := 0 // el numero de linea no es numerico
      end;
      // cuando no existe el texto en la linea indicada, busca el texto
//      if pos(nombre,memo.Lines[linea])<1 then begin
//         BuscarTexto(nombre)
//      end else begin
      memo.SelStart := memo.Perform( EM_LINEINDEX, linea - 1, 0 );
      memo.Perform( EM_SCROLLCARET, 0, 0 );
      m := memo.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
      m := linea - m - 30;
      memo.Perform( EM_LINESCROLL, 0, m );
      memo.SelLength := length( memo.Lines[ linea - 1 ] );
      memo.SelAttributes.Color := clblue;
   end;
end;

procedure Tfarbol.SePosicionaLineaInicial( nombre: string; lwLinea: Integer );
var
   i, f, l, linea, m: integer;
   texto, Wtexto: string;
begin
   texto := nodo_actual.text;

   memo.SelStart := memo.Perform( EM_LINEINDEX, lwLinea - 1, 0 );
   memo.Perform( EM_SCROLLCARET, 0, 0 );
   m := memo.Perform( EM_GETFIRSTVISIBLELINE, 0, 0 );
   m := lwLinea - m - 30;
   memo.Perform( EM_LINESCROLL, 0, m );
   memo.SelLength := length( memo.Lines[ lwLinea - 1 ] );
   memo.SelAttributes.Color := clblue;

end;

procedure Tfarbol.diagramacbl( sender: Tobject );
begin
   screen.Cursor := crsqlwait;
   //   if dm.capacidad('Acceso local') then begin
   diagramacblx( nodo_actual.Text );
   {   end
      else begin
         diagramacbly(nodo_actual.Text);
      end;
    }
   screen.Cursor := crdefault;
end;

procedure Tfarbol.DiagramaCOBOL;
var
   Nodo: ^Tmyrec;
   lsNomCompo, lsArchFte: String;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;
   if memo.Lines.Count > 0 then begin
      Nodo := nodo_actual.data;
      lsNomCompo := nodo.hnombre;
      bGlbQuitaCaracteres( lsNomCompo );
      lsArchFte := g_tmpdir + '\' + lsNomCompo + '.cbl';
      Memo.Lines.SaveToFile( lsArchFte );
      GenerarDiagrama( lsNomCompo, lsArchFte );
   end;
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoWFL;
var
   Nodo: ^Tmyrec;
   lsNomCompo, lsArchFte: String;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;
   if memo.Lines.Count > 0 then begin
      Nodo := nodo_actual.data;
      lsNomCompo := nodo.hnombre;
      bGlbQuitaCaracteres( lsNomCompo );
      lsArchFte := g_tmpdir + '\' + lsNomCompo;
      Memo.Lines.SaveToFile( lsArchFte );
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'WFL', 'FLUJO' );
   end;
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaJerarquicoWFL;
var
   Nodo: ^Tmyrec;
   lsNomCompo, lsArchFte: String;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;
   if memo.Lines.Count > 0 then begin
      Nodo := nodo_actual.data;
      lsNomCompo := nodo.hnombre;
      bGlbQuitaCaracteres( lsNomCompo );
      lsArchFte := g_tmpdir + '\' + lsNomCompo;
      Memo.Lines.SaveToFile( lsArchFte );
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'WFL', 'JERARQUICO' );
   end;
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoALG;
var
   Nodo: ^Tmyrec;
   lsNomCompo, lsArchFte: String;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;
   if memo.Lines.Count > 0 then begin
      Nodo := nodo_actual.data;
      lsNomCompo := nodo.hnombre;
      bGlbQuitaCaracteres( lsNomCompo );
      lsArchFte := g_tmpdir + '\' + lsNomCompo;
      Memo.Lines.SaveToFile( lsArchFte );
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'ALG', 'FLUJO' );
   end;
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaJerarquicoALG;
var
   Nodo: ^Tmyrec;
   lsNomCompo, lsArchFte: String;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;
   if memo.Lines.Count > 0 then begin
      Nodo := nodo_actual.data;
      lsNomCompo := nodo.hnombre;
      bGlbQuitaCaracteres( lsNomCompo );
      lsArchFte := g_tmpdir + '\' + lsNomCompo;
      Memo.Lines.SaveToFile( lsArchFte );
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'ALG', 'JERARQUICO' );
   end;
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.GenerarDiagrama( lsNomFte: String; lsArchFte: String );
var
   lslBat: Tstringlist;
   lsArchBat, lsArchSal, lsDir, lsDir1: string;
   sRutaMisDocumentos: String;
begin
   gral.PubMuestraProgresBar( True );
   try
      sRutaMisDocumentos := GlbObtenerRutaMisDocumentos;
      lsDir := sRutaMisDocumentos + '\Informes';
      lsDir1 := Q + sRutaMisDocumentos + '\Informes' + Q;


      if directoryexists( lsDir ) = false then begin
         if forcedirectories( lsDir ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + lsDir ) ),
               pchar( dm.xlng( sDIGRA_COBOL ) ), MB_OK );
            exit;
         end;
      end;
      lsArchBat := g_tmpdir + '\' + lsNomFte + '.VJB';
      lsArchSal := lsDir + '\' + lsNomFte + '.PDF';
      lslBat := Tstringlist.Create;
      lslBat.add( 'Visustin bulk flowchart job' );
      lslBat.add( '[Job]' );
      lslBat.add( 'Language=COBFIX' );
      lslBat.add( 'OutputPath=' + lsDir );
      lslBat.add( 'Split=False' );
      lslBat.add( 'OutputMulti=False' );
      lslBat.add( 'OutputFormat=pdf1' );
      lslBat.add( 'Recursive=False' );
      lslBat.add( ' ' );
      lslBat.add( '[Source]' );
      lslBat.add( lsArchFte );
      lslBat.savetofile( lsArchBat );
      lslBat.Free;

      if dm.ejecuta_espera( 'VISUSTIN' + ' ' + lsarchBat, SW_HIDE ) then begin
         sleep( 100 );
         ShellExecute( 0, 'open', pchar( lsArchSal ), nil, PChar( lsDir1 ), SW_SHOW );
      end
      else
         Application.MessageBox( PChar( 'No se puede generar diagrama' ),
            PChar( 'Diagrama de Flujo COBOL' ), MB_ICONEXCLAMATION );
      g_borrar.add( lsArchBat );
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tfarbol.GenerarDiagramaNvo( lsNomFte: String; lsArchFte: String; parClase, parTipoDiagrama: String );
var
   lslBat: Tstringlist;
   lsArchBat, lsArchSal, lsArchSal2, lsArchSal3, lsDir, lsDir1: string;
   sRutaMisDocumentos: String;
begin
   gral.PubMuestraProgresBar( True );
   try
      sRutaMisDocumentos := GlbObtenerRutaMisDocumentos;
      lsDir := sRutaMisDocumentos + '\Informes';
      lsDir1 := Q + sRutaMisDocumentos + '\Informes' + Q;

      if directoryexists( lsDir ) = false then begin
         if forcedirectories( lsDir ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + lsDir ) ),
               pchar( dm.xlng( sDIGRA_FLUJO_WFL ) ), MB_OK );
            exit;
         end;
      end;

      lsArchSal := g_tmpdir + '\' + lsNomFte + '.sal';
      lsArchSal2 := lsNomFte + '_f.PDF'; //de flujo
      lsArchSal3 := lsNomFte + '_p.PDF'; //jerarquico
      lslBat := Tstringlist.Create;

      lslBat.add( 'ECHO OFF                    ' );
      lslBat.add( 'IF %1.==. GOTO HELP         ' );
      lslBat.add( 'IF NOT EXIST %1 GOTO NOFILE ' );
      lslBat.add( 'ECHO .                    ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO Procesando "%1"...   ' + ' >> ' + lsArchSal );
      if parClase = 'WFL' then begin
         lsArchBat := g_tmpdir + '\gdwfl_' + lsNomFte + '.BAT';
         lslBat.add( 'C:\sysmining\gendiagramawfl  ' + g_tmpdir + '\' + lsNomfte + ' ' + g_tmpdir + '\' + lsNomfte + ' >> ' + lsArchSal );
      end
      else begin
         if parClase = 'ALG' then begin
            lsArchBat := g_tmpdir + '\gdalg_' + lsNomFte + '.BAT';
            lslBat.add( 'C:\sysmining\gendiagramaalgol  ' + g_tmpdir + '\' + lsNomfte + ' ' + g_tmpdir + '\' + lsNomfte + ' >> ' + lsArchSal );
         end;
      end;
      lslBat.add( 'IF errorlevel 1 GOTO ERRORGEN ' );
      lslBat.add( 'dot.exe -Tpdf -Gcharset=latin1 -o ' + g_tmpdir + '\' + lsNomfte + '_f.pdf ' + g_tmpdir + '\' + lsNomfte + '_f.dot' + ' >> ' + lsArchSal );
      lslBat.add( 'dot.exe -Tpdf -o ' + g_tmpdir + '\' + lsNomfte + '_p.pdf ' + g_tmpdir + '\' + lsNomfte + '_p.dot ' + ' >> ' + lsArchSal );
      lslBat.add( 'IF errorlevel 1 GOTO ERRORGJ ' );
      lslBat.add( 'GOTO FIN ' );
      lslBat.add( ':HELP ' );
      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "Genera el archivo de directivas p/la generación de digramas"     ' + ' >> ' + lsArchSal );

      if parClase = 'WFL' then
         lslBat.add( 'ECHO "Ejemplo: gendiagramawfl File_Input FileOutput"                ' + ' >> ' + lsArchSal )
      else begin
         if parClase = 'ALG' then
            lslBat.add( 'ECHO "Ejemplo: gendiagramaalgol File_Input FileOutput"           ' + ' >> ' + lsArchSal );
      end;

      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );
      lslBat.add( 'GOTO FIN ' );
      lslBat.add( ':NOFILE ' );
      lslBat.add( 'ECHO "El archivo %1 no existe"                                         ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO.                                                                  ' + ' >> ' + lsArchSal );
      lslBat.add( 'GOTO FIN ' );
      lslBat.add( ':ERRORGEN ' );
      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );

      if parClase = 'WFL' then
         lslBat.add( 'ECHO "=Fallo la ejecución de gendigramawlf con: %1"                    ' + ' >> ' + lsArchSal )
      else
         lslBat.add( 'ECHO "=Fallo la ejecución de gendigramaalgol con: %1"                    ' + ' >> ' + lsArchSal );

      lslBat.add( 'ECHO "=Verificar error.                           "                    ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );
      lslBat.add( 'GOTO FIN ' );
      lslBat.add( ':ERRORGF ' );
      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "=Fallo la ejecución de GraphViz Flujo con: %1"                   ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "=Verificar error.                           "                    ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );
      lslBat.add( 'GOTO FIN ' );
      lslBat.add( ':ERRORGJ ' );
      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "=Fallo la ejecución de GraphViz jerarquico con: %1"              ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "=Verificar error.                           "                    ' + ' >> ' + lsArchSal );
      lslBat.add( 'ECHO "============================================================="   ' + ' >> ' + lsArchSal );
      lslBat.add( 'GOTO FIN ' );
      lslBat.add( ':FIN ' );
      lslBat.add( 'MOVE ' + g_tmpdir + '\' + lsNomFte + '*.pdf ' + lsdir1  );
      //lslBat.add( 'DEL  ' + g_tmpdir + '\' + lsNomFte + '*.*');
      lslBat.add( 'ECHO "TERMINANDO..." %1                                                ' + ' >> ' + lsArchSal );

      lslBat.savetofile( lsArchBat );
      lslBat.Free;

      if dm.ejecuta_espera( lsArchBat + ' ' + g_tmpdir + '\' + lsNomfte, SW_HIDE ) then begin
         sleep( 100 );
         if parTipoDiagrama = 'FLUJO' then
            ShellExecute( 0, 'open', pchar( lsArchSal2 ), nil, PChar( lsDir ), SW_SHOW )
         else if parTipoDiagrama = 'JERARQUICO' then
            ShellExecute( 0, 'open', pchar( lsArchSal3 ), nil, PChar( lsDir ), SW_SHOW )
      end
      else
         Application.MessageBox( PChar( 'No se puede generar diagrama' ),
            PChar( 'Diagrama de Flujo COBOL' ), MB_ICONEXCLAMATION );
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tfarbol.dghtml( sender: Tobject );
begin
   screen.Cursor := crsqlwait;
   //   if dm.capacidad('Acceso local') then begin
   dghtmlx( nodo_actual.Text );
   {   end
      else begin
         dghtmly(nodo_actual.Text);
      end;
   }
   screen.Cursor := crdefault;
end;

procedure Tfarbol.diagramajava( sender: Tobject );
begin
   screen.Cursor := crsqlwait;
   //   if dm.capacidad('Acceso local') then begin
   diagramajavax( nodo_actual.Text );
   {   end
      else begin
         diagramajavay(nodo_actual.Text);
      end;
    }
   screen.Cursor := crdefault;
end;

procedure Tfarbol.diagramarpg( sender: Tobject );
begin
   screen.Cursor := crsqlwait;
   //   if dm.capacidad('Acceso local') then begin
   diagramarpgx( nodo_actual.Text );
   {   end
      else begin
         diagramarpgy(nodo_actual.Text); // no está implementado con webserver
      end;
    }
   screen.Cursor := crdefault;
end;

procedure Tfarbol.rut_dghtml( nombre: string; bib: string; clase: string; fuente: string; salida: string );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'Diagrama de Flujo ' + clase + ' ' + bib + ' ' + nombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsdghtml );
      setlength( ftsdghtml, k + 1 );
      ftsdghtml[ k ] := Tftsdghtml.create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsdghtml[ k ].Width := g_Width;
         ftsdghtml[ k ].Height := g_Height;
      end;
      //ftsdghtml[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsdghtml[ k ].Caption := titulo;
      ftsdghtml[ k ].titulo := titulo;
      ftsdghtml[ k ].arma( salida, fuente );
      ftsdghtml[ k ].show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.rut_svsflcob( nombre: string; bib: string; clase: string; fuente: string; salida: string );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'Diagrama de Flujo ' + clase + ' ' + bib + ' ' + nombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( fmgflcob );
      setlength( fmgflcob, k + 1 );
      fmgflcob[ k ] := Tfmgflcob.create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         fmgflcob[ k ].Width := g_Width;
         fmgflcob[ k ].Height := g_Height;
      end;
      //fmgflcob[ k ].Constraints.MaxWidth := g_MaxWidth;
      fmgflcob[ k ].caption := titulo;
      fmgflcob[ k ].titulo := titulo;
      fmgflcob[ k ].arma( fuente, salida, nombre );
      fmgflcob[ k ].show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.rut_svsflrpg( nombre: string; bib: string; clase: string; fuente: string; salida: string );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'RPG ' + clase + ' ' + bib + ' ' + nombre;
      k := length( fmgflrpg );
      setlength( fmgflrpg, k + 1 );
      fmgflrpg[ k ] := Tfmgflrpg.create( self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         fmgflrpg[ k ].Width := g_Width;
         fmgflrpg[ k ].Height := g_Height;
      end;
      //fmgflrpg[ k ].Constraints.MaxWidth := g_MaxWidth;
      fmgflrpg[ k ].titulo := titulo;
      fmgflrpg[ k ].arma( fuente, salida, nombre );
      fmgflrpg[ k ].show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.diagramacblx( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux, directivas, reservadas, rgmlang, salida, hora: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff: string;
begin
   reg := nodo_actual.Data;
   if reg.hbiblioteca = 'SCRATCH' then begin
      Application.MessageBox( pchar( dm.xlng( 'Fuente no existe' ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   fte := Tstringlist.Create;
   {
   if memo_componente = reg.hnombre + '_' + reg.hbiblioteca then begin
      fte.AddStrings( memo.Lines );
   end
   else begin
      if dm.trae_fuente( reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Fuente no existe' ) ),
            pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         fte.Free;
         exit;
      end;
   end;}//validar funcionalidad memo_componente

   if dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'Fuente no existe' ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      fte.Free;
      exit;
   end;

   //   fte.LoadFromFile(dm.xblobname(reg.hbiblioteca,reg.hnombre));
   if dm.sqlselect( dm.q1, 'select distinct hcbib, hcclase from tsrela ' +
      ' where pcprog=' + g_q + reg.hnombre + g_q +
      ' and   pcbib=' + g_q + reg.hbiblioteca + g_q +
      ' and   pcclase=' + g_q + reg.hclase + g_q +
      ' and   sistema=' + g_q + reg.sistema + g_q +
      ' and   hcclase=' + g_q + 'CPY' + g_q ) then begin
      for i := 0 to fte.Count - 1 do begin
         if length( fte[ i ] ) < 8 then
            continue;
         if fte[ i ][ 7 ] <> ' ' then
            continue;
         ff := copy( fte[ i ], 7, 66 );
         k := pos( ' COPY ', uppercase( ff ) );
         if k = 0 then
            continue;

         //==================
         if k > 0 then
            continue; // REVISAR CON ROBERTO
         //==================

         ff := trim( copy( ff, k + 6, 100 ) );
         k := pos( ' ', ff );
         if k > 0 then
            ff := copy( ff, 1, k - 1 );
         if length( ff ) = 0 then
            continue;
         if ff[ length( ff ) ] = '.' then
            delete( ff, length( ff ), 1 );
         ff := stringreplace( stringreplace( ff, '''', '', [ rfreplaceall ] ), '"', '', [ rfreplaceall ] );
         ff := lowercase( ff );
         while ( pos( '/', ff ) > 0 ) do
            ff := copy( ff, pos( '/', ff ) + 1, 100 );
         cop := Tstringlist.Create;
         if uppercase( ff ) = 'DEBUGAID' then
            CONTINUE;
         dm.trae_fuente( reg.sistema, uppercase( ff ), dm.q1.fieldbyname( 'hcbib' ).AsString, dm.q1.fieldbyname( 'hcclase' ).AsString, cop );
         //         if fileexists(dm.xblobname(dm.q1.fieldbyname('hcbib').AsString,ff)) then
         //            cop.LoadFromFile(dm.xblobname(dm.q1.fieldbyname('hcbib').AsString,ff));
         for k := cop.Count - 1 downto 0 do
            fte.Insert( i + 1, cop[ k ] );
         fte[ i ] := copy( fte[ i ], 1, 6 ) + '*' + copy( fte[ i ], 8, 100 );
         cop.Free;
      end;
   end;
   mux := g_tmpdir + '\fte' + reg.hnombre + '.src';
   fte.SaveToFile( mux );
   g_borrar.Add( mux );
   salida := g_tmpdir + '\sal.sal';
   deletefile( salida );
   hora := formatdatetime( 'YYYYMMDDhhnnss', now );
   rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   directivas := g_tmpdir + '\hta' + hora + '.dir';
   reservadas := g_tmpdir + '\hta' + hora + '.res';
   ff := g_tmpdir + '\hta' + hora + '.tmp';
   dm.get_utileria( 'RGMLANG', rgmlang );
   dm.get_utileria( 'COBOLFLOW', directivas );
   for i := 0 to fte.Count - 1 do begin // checa si es tandem y adapta las directivas
      if ( copy( fte[ i ], 1, 4 ) = '?ENV' ) or
         ( copy( fte[ i ], 1, 4 ) = '?SQL' ) or
         ( copy( fte[ i ], 1, 5 ) = '?SAVE' ) or
         ( copy( fte[ i ], 1, 8 ) = '?INSPECT' ) or
         ( copy( fte[ i ], 1, 7 ) = '?SEARCH' ) or
         ( copy( fte[ i ], 1, 7 ) = '?NOTRAP' ) or
         ( copy( fte[ i ], 1, 7 ) = '?SETTOG' ) or
         ( copy( fte[ i ], 1, 8 ) = '?HIGHPIN' ) or
         ( copy( fte[ i ], 1, 8 ) = '?LIBRARY' ) or
         ( copy( fte[ i ], 1, 8 ) = '?SYMBOLS' ) or
         ( copy( fte[ i ], 1, 9 ) = '?OPTIMIZE' ) then begin
         fte.LoadFromFile( directivas );
         fte[ 0 ] := stringreplace( fte[ 0 ], 'BC08EC72JB08JE72SL''', 'BC02EC138JB02JE138SL"', [ ] );
         fte[ 1 ] := 'IGNORE    07*\07/\07$\07?\01*\01/\01$\01?\\';
         fte.SaveToFile( directivas );
         break;
      end;
   end;
   dm.get_utileria( 'RESERVADAS CBL', reservadas );
   dm.ejecuta_espera( rgmlang + ' ' +
      mux + ' ' +
      ff + ' ' +
      directivas + ' ' +
      reservadas, SW_HIDE );
   g_borrar.Add( rgmlang );
   g_borrar.Add( directivas );
   g_borrar.Add( reservadas );
   g_borrar.Add( ff );
   //   copyfile('sal.sal',pchar(salida),false);
   fte.LoadFromFile( 'sal.sal' );
   fte.SaveToFile( salida );
   fte.Free;
   //   deletefile('sal.sal');
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   g_borrar.Add( salida );
   rut_svsflcob( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, salida );
   {
   svsflcob:=g_tmpdir+'\hta'+formatdatetime('hhmmss',now)+'.exe';
   dm.get_utileria('SVSFLCOB',svsflcob);
   g_borrar.Add(svsflcob);
   if ShellExecute( 0, 'open', pchar(svsflcob),pchar(mux+' '+
            g_tmpdir+'\sal.sal '+g_tmpdir+' '+nodotext),PChar( g_tmpdir), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
   }
end;

{procedure Tfarbol.diagramacbly( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux: string;
   fte: Tstringlist;
   ff: string;
begin
   reg := nodo_actual.Data;
   ff := g_tmpdir + '\sal.sal';
   mux := g_tmpdir + '\tmp_' + reg.hnombre;
   fte := Tstringlist.Create;
   fte.Text := ( htt as isvsserver ).GetTxt( 'svsget,' + reg.hclase + ',' + reg.hbiblioteca + ',' + reg.hnombre );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( mux );
   fte.Text := ( htt as isvsserver ).GetTxt( 'svscobolflow,' + reg.hclase + ',' + reg.hbiblioteca + ',' + reg.hnombre );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( ff );
   fte.Free;
   rut_svsflcob( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, ff );

   //if ShellExecute( 0, 'open', pchar('svsflcob'),pchar(mux+
   //         ' '+ff+' '+g_tmpdir+' '+nodotext),PChar( g_ruta), SW_SHOW )<=32 then begin
   //   Application.MessageBox( 'No se pudo ejecutar la aplicación diagrama cobol',
   //         'Error', MB_ICONEXCLAMATION );
   //end;
   sleep(10000); // para dar tiempo a que levante SVSFLCOB

   deletefile( mux );
   deletefile( ff );
end;}

procedure Tfarbol.diagramarpgx( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux, directivas, reservadas, rgmlang, salida, hora: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff: string;
begin
   reg := nodo_actual.Data;
   fte := Tstringlist.Create;
   {
   if memo_componente = reg.hnombre + '_' + reg.hbiblioteca then begin
      fte.AddStrings( memo.Lines );
   end
   else begin
      if dm.trae_fuente( reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe: ' + nodotext ) ),
            pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         fte.Free;
         exit;
      end;
   end;}//validar funcionalidad memo_componente

   if dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe: ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      fte.Free;
      exit;
   end;

   mux := g_tmpdir + '\fte' + reg.hnombre + '.src';
   fte.SaveToFile( mux );
   g_borrar.Add( mux );
   salida := g_tmpdir + '\sal.sal';
   deletefile( salida );
   hora := formatdatetime( 'YYYYMMDDhhnnss', now );
   rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   directivas := g_tmpdir + '\hta' + hora + '.dir';
   reservadas := g_tmpdir + '\hta' + hora + '.res';
   ff := g_tmpdir + '\hta' + hora + '.tmp';
   dm.get_utileria( 'RGMLANG', rgmlang );
   dm.get_utileria( 'RPGFLOW', directivas );
   dm.get_utileria( 'RESERVADAS RPG', reservadas );
   dm.ejecuta_espera( rgmlang + ' ' +
      mux + ' ' +
      ff + ' ' +
      directivas + ' ' +
      reservadas, SW_HIDE );
   g_borrar.Add( rgmlang );
   g_borrar.Add( directivas );
   g_borrar.Add( reservadas );
   g_borrar.Add( ff );
   //   copyfile('sal.sal',pchar(salida),false);
   fte.LoadFromFile( 'sal.sal' );
   fte.SaveToFile( salida );
   fte.Free;
   //   deletefile('sal.sal');
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   g_borrar.Add( salida );
   rut_svsflrpg( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, salida );
end;

{procedure Tfarbol.diagramarpgy( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux: string;
   fte: Tstringlist;
   ff: string;
begin
   reg := nodo_actual.Data;
   ff := g_tmpdir + '\sal.sal';
   mux := g_tmpdir + '\tmp_' + reg.hnombre;
   fte := Tstringlist.Create;
   fte.Text := ( htt as isvsserver ).GetTxt( 'svsget,' + reg.hclase + ',' + reg.hbiblioteca + ',' + reg.hnombre );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( mux );
   fte.Text := ( htt as isvsserver ).GetTxt( 'svscobolflow,' + reg.hclase + ',' + reg.hbiblioteca + ',' + reg.hnombre );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( ff );
   fte.Free;
   rut_svsflcob( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, ff );
   deletefile( mux );
   deletefile( ff );
end;}

procedure Tfarbol.dghtmlx( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux, directivas, reservadas, rgmlang, salida, hora: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   if reg.hbiblioteca = 'SCRATCH' then begin
      if dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + nodotext ) ),
            pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      end;
      exit;
   end;

   fte := Tstringlist.Create;
   {
   if memo_componente = reg.hnombre + '_' + reg.hbiblioteca then begin
      fte.AddStrings( memo.Lines );
   end
   else begin
      if dm.trae_fuente( reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + nodotext ) ),
            pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         fte.Free;
         exit;
      end;
   end;}//validar funcionalidad memo_componente

   if dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      fte.Free;
      exit;
   end;

   mux := g_tmpdir + '\fte' + reg.hnombre + '.src';
   {
   majusta.Lines.Clear;             // Para ajustar las lineas y no rebasen de 250 caracteres
   majusta.Lines.AddStrings(fte);
   fte.Clear;
   fte.AddStrings(majusta.Lines);
   }
   fte.SaveToFile( mux );
   //majusta.Lines.SaveToFile(mux);
   g_borrar.Add( mux );
   salida := g_tmpdir + '\sal.sal';
   deletefile( salida );
   hora := formatdatetime( 'YYYYMMDDhhnnss', now );
   rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   directivas := g_tmpdir + '\hta' + hora + '.dir';
   reservadas := g_tmpdir + '\hta' + hora + '.res';
   ff := g_tmpdir + '\hta' + hora + '.tmp';
   dm.get_utileria( 'RGMLANG', rgmlang );
   dm.get_utileria( 'JAV_DGHTML', directivas );
   dm.get_utileria( 'RESERVADAS JAV', reservadas );
   dm.ejecuta_espera( rgmlang + ' ' +
      mux + ' ' +
      ff + ' ' +
      directivas + ' ' +
      //reservadas, SW_SHOW );
      reservadas + ' >' + salida, SW_HIDE );
   g_borrar.Add( rgmlang );
   g_borrar.Add( directivas );
   g_borrar.Add( reservadas );
   g_borrar.Add( ff );
   fte.LoadFromFile( salida );
   fte.SaveToFile( salida );
   fte.Free;
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   g_borrar.Add( salida );
   //rut_svsflcob(reg.hnombre,reg.hbiblioteca,reg.hclase,mux,salida);
   rut_dghtml( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, salida );
   screen.Cursor := crdefault;
   //PR_DGHTML(salida,mux);
end;

procedure Tfarbol.dghtmly( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux: string;
   fte: Tstringlist;
   ff: string;
begin
   showmessage( 'No implementado en modo web service' );
   exit;
end;

procedure Tfarbol.diagramajavax( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux, directivas, reservadas, rgmlang, salida, hora: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff: string;
begin
   reg := nodo_actual.Data;
   fte := Tstringlist.Create;
   {
   if memo_componente = reg.hnombre + '_' + reg.hbiblioteca then begin
      fte.AddStrings( memo.Lines );
   end
   else begin
      if dm.trae_fuente( reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + nodotext ) ),
            pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         fte.Free;
         exit;
      end;
   end;}//validar funcionalidad memo_componente

   if dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, fte ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      fte.Free;
      exit;
   end;

   mux := g_tmpdir + '\fte' + reg.hnombre + '.src';
   fte.SaveToFile( mux );
   g_borrar.Add( mux );
   salida := g_tmpdir + '\sal.sal';
   deletefile( salida );
   hora := formatdatetime( 'YYYYMMDDhhnnss', now );
   rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   directivas := g_tmpdir + '\hta' + hora + '.dir';
   reservadas := g_tmpdir + '\hta' + hora + '.res';
   ff := g_tmpdir + '\hta' + hora + '.tmp';
   dm.get_utileria( 'RGMLANG', rgmlang );
   dm.get_utileria( 'JAVAFLOW', directivas );
   dm.get_utileria( 'RESERVADAS JAV', reservadas );
   dm.ejecuta_espera( rgmlang + ' ' +
      mux + ' ' +
      ff + ' ' +
      directivas + ' ' +
      reservadas, SW_HIDE );
   g_borrar.Add( rgmlang );
   g_borrar.Add( directivas );
   g_borrar.Add( reservadas );
   g_borrar.Add( ff );
   fte.LoadFromFile( 'sal.sal' );
   fte.SaveToFile( salida );
   fte.Free;
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   g_borrar.Add( salida );
   rut_svsflcob( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, salida );
end;

{procedure Tfarbol.diagramajavay( nodotext: string );
var
   reg: ^Tmyrec;
   svsflcob, mux: string;
   fte: Tstringlist;
   ff: string;
begin
   Application.MessageBox( pchar( dm.xlng( 'No implementado en modo web service' ) ),
      pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
   exit;
   reg := nodo_actual.Data;
   ff := g_tmpdir + '\sal.sal';
   mux := g_tmpdir + '\tmp_' + reg.hnombre;
   fte := Tstringlist.Create;
   fte.Text := ( htt as isvsserver ).GetTxt( 'svsget,' + reg.hclase + ',' + reg.hbiblioteca + ',' + reg.hnombre );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( mux );
   fte.Text := ( htt as isvsserver ).GetTxt( 'svscobolflow,' + reg.hclase + ',' + reg.hbiblioteca + ',' + reg.hnombre );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( ff );
   fte.Free;
   rut_svsflcob( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, ff );
   deletefile( mux );
   deletefile( ff );
end;}

procedure Tfarbol.diagramanatural( sender: Tobject );
begin
   diagramanaturalx( nodo_actual.Text );
end;

procedure Tfarbol.diagramanaturalx( nodotext: string );
var
   reg: ^Tmyrec;
   datos, mux: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff, filedot: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   chdir( g_ruta );
   fte := Tstringlist.Create;
   mux := 'fte' + reg.hnombre + '.src';
   copyfile( pchar( dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase ) ), pchar( mux ), false );
   g_borrar.Add( mux );
   dm.get_utileria( 'RGMLANG', 'hta' + mux + '.exe' );
   dm.get_utileria( 'DIRECTIVAS NATURALFLOW', 'hta' + mux + '.dir' );
   dm.get_utileria( 'RESERVADAS NATURALFLOW', 'hta' + mux + '.res' );
   filedot := reg.hnombre + '.dot';
   dm.ejecuta_espera( 'hta' + mux + '.exe ' +
      mux +
      ' nada ' +
      ' hta' + mux + '.dir' +
      ' hta' + mux + '.res > ' + filedot, SW_HIDE );
   g_borrar.Add( 'hta' + mux + '.exe' );
   g_borrar.Add( 'hta' + mux + '.dir' );
   g_borrar.Add( 'hta' + mux + '.res' );
   g_borrar.Add( filedot );
   g_borrar.Add( 'nada' );
   if fileexists( filedot ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   fte.LoadFromFile( filedot );
   datos := fte.commatext;
   datos := stringreplace( datos, 'º', '\n', [ rfreplaceall ] );
   fte.commatext := datos;
   fte.SaveToFile( filedot );
   fte.Free;
   {
   if ShellExecute( 0, 'open', pchar(filedot),nil,PChar( g_ruta), SW_SHOW )<=32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
            'Error', MB_ICONEXCLAMATION );
   end;
   }
   if ShellExecute( 0, nil, pchar( dm.get_variable( 'PROGRAMFILES' ) + '\' + g_graphviz + '\bin\dotty.exe' ),
      pchar( filedot ), PChar( g_ruta ), SW_SHOW ) <= 32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
         'Diagrama de flujo ', MB_ICONEXCLAMATION );
   end;
   screen.Cursor := crdefault;
end;

procedure Tfarbol.diagramaase( sender: Tobject );
var
   reg: ^Tmyrec;
   datos, mux, ncob: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff, filedot: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   chdir( g_tmpdir );
   fte := Tstringlist.Create;
   mux := reg.hnombre + '.ase';
   ncob := reg.hnombre + '.cbl';
   copyfile( pchar( dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase ) ), pchar( mux ), false );
   g_borrar.Add( mux );
   g_borrar.Add( ncob );
   dm.get_utileria( 'RGMASE2COB', 'hta' + mux + '.exe' );
   filedot := reg.hnombre + '.dot';
   dm.ejecuta_espera( 'hta' + mux + '.exe ' +
      mux + ' ' + ncob, SW_HIDE );
   g_borrar.Add( 'hta' + mux + '.exe' );
   g_borrar.Add( filedot );
   g_borrar.Add( 'nada' );
   if fileexists( filedot ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + reg.hnombre ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   if ShellExecute( 0, nil, pchar( dm.get_variable( 'PROGRAMFILES' ) + '\' + g_graphviz + '\bin\dotty.exe' ),
      pchar( filedot ), PChar( g_tmpdir ), SW_SHOW ) <= 32 then begin
      Application.MessageBox( pchar( dm.xlng( 'No se pudo ejecutar la aplicación' ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_ICONEXCLAMATION );
   end;
   screen.Cursor := crdefault;
end;

procedure Tfarbol.conviertease2cob( sender: Tobject );
var
   reg: ^Tmyrec;
   datos, mux, ncob, utile: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff, filedot: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   chdir( g_tmpdir );
   fte := Tstringlist.Create;
   mux := reg.hnombre + '.ase';
   ncob := reg.hnombre + '.cbl';
   copyfile( pchar( dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase ) ), pchar( mux ), false );
   g_borrar.Add( mux );
   g_borrar.Add( ncob );
   utile := 'hta' + mux + '.exe';
   dm.get_utileria( 'RGMASE2COB', utile );
   filedot := reg.hnombre + '.dot';
   dm.ejecuta_espera( utile + ' ' +
      mux + ' ' + ncob, SW_SHOW );
   g_borrar.Add( utile );
   g_borrar.Add( filedot );
   g_borrar.Add( 'nada' );
   if fileexists( filedot ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + reg.hnombre ) ),
         pchar( dm.xlng( 'Convertir' ) ), MB_OK );
      exit;
   end;
   dm.get_utileria( 'COMPARACION DE FUENTES', utile );
   if ShellExecute( 0, nil, pchar( utile ), pchar( mux + ' ' + ncob ), PChar( g_tmpdir ), SW_SHOW ) <= 32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
         'Error', MB_ICONEXCLAMATION );
   end;
   screen.Cursor := crdefault;
end;

procedure Tfarbol.referencias_cruzadas( Sender: Tobject );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := sLISTA_REF_CRUZADAS + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsrefcruz );
      setlength( ftsrefcruz, k + 1 );

      ftsrefcruz[ k ] := TfmRefCruz.Create( Self );
      ftsrefcruz[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsrefcruz[ k ].Width := g_Width;
         ftsrefcruz[ k ].Height := g_Height;
      end;

      if g_language = 'ENGLISH' then
         ftsrefcruz[ k ].titulo := 'Cross Reference ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre
      else
         ftsrefcruz[ k ].titulo := sLISTA_REF_CRUZADAS + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      ftsrefcruz[ k ].arma( reg.hclase, reg.hbiblioteca, reg.hnombre, reg.sistema );

      if g_procesa then begin //  Esto es para que no muestre la pantalla, si no tiene información.
         ftsrefcruz[ k ].Show;
      end
      else begin
         if ftsrefcruz[ k ].FormStyle = fsMDIChild then
            application.MessageBox( pchar( dm.xlng( 'Sin Información para la aplicación.' ) ),
               pchar( dm.xlng( sLISTA_REF_CRUZADAS + ' ' ) ), MB_OK );

         ftsrefcruz[ k ].Close;
      end;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.convertirgenexus( Sender: Tobject ); // SOLO DEMO
var
   reg: ^Tmyrec;
   examdiff, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   examdiff := g_ruta + 'cobol2gx.bat';
   //   dm.get_utileria('COMPARACION DE FUENTES',examdiff);
   //   g_borrar.Add(examdiff);
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   if pos( 'COBOLGX', fuente ) = 0 then begin
      Application.MessageBox( pchar( dm.xlng( 'Librería no catalogada para conversión' ) ),
         pchar( dm.xlng( 'Conversión de componentes' ) ), MB_OK );
      screen.Cursor := crdefault;
      exit;
   end;
   convertido := stringreplace( fuente, 'COBOLGX', 'CNVCBL', [ ] );
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la conversion' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.comparaconvertido( Sender: Tobject );
var
   reg: ^Tmyrec;
   examdiff, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   examdiff := 'hta' + formatdatetime( 'hhmmss', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', examdiff );
   g_borrar.Add( examdiff );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   if pos( 'COBOLGX', fuente ) = 0 then begin
      Application.MessageBox( pchar( dm.xlng( 'Librería no catalogada para conversión' ) ),
         pchar( dm.xlng( 'Conversión de componentes' ) ), MB_OK );
      screen.Cursor := crdefault;
      exit;
   end;
   convertido := stringreplace( fuente, 'COBOLGX', 'CNVCBL', [ ] );
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparacion' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.convertircblunix( Sender: Tobject );
var
   reg: ^Tmyrec;
   rgmlang, directivas, reservadas, fuente, convertido, utile: string;
begin
   reg := nodo_actual.Data;
   rgmlang := g_tmpdir + '\hta15.exe';
   dm.get_utileria( 'RGMLANG', rgmlang );
   g_borrar.Add( rgmlang );
   directivas := g_tmpdir + '\dircbl.dir';
   dm.get_utileria( 'DIRECTIVAS CNVCBLUNX', directivas );
   g_borrar.Add( directivas );
   reservadas := g_tmpdir + '\dirnat.res';
   dm.get_utileria( 'RESERVADAS CNVCBLUNX', reservadas );
   g_borrar.Add( reservadas );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   dm.ejecuta_espera( rgmlang + ' ' + fuente + ' ' + convertido + ' ' + directivas + ' ' + reservadas,
      SW_SHOW );
   utile := g_tmpdir + '\hta16.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', utile );
   if ShellExecute( 0, nil, pchar( utile ), pchar( fuente + ' ' + convertido ), PChar( g_tmpdir ), SW_SHOW ) <= 32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
         'Error', MB_ICONEXCLAMATION );
   end;

end;

procedure Tfarbol.convertirnatural( Sender: Tobject );
var
   reg: ^Tmyrec;
   rgmlang, directivas, reservadas, fuente, convertido: string;
begin
   reg := nodo_actual.Data;
   {
   rgmlang:=g_tmpdir+'\hta11.exe';
   dm.get_utileria('RGMLANG2',rgmlang);
   g_borrar.Add(rgmlang);
   directivas:=g_tmpdir+'\dirnat.dir';
   dm.get_utileria('DIRECTIVAS CNVNATCOB',directivas);
   g_borrar.Add(directivas);
   reservadas:=g_tmpdir+'\dirnat.res';
   dm.get_utileria('RESERVADAS CNVNATCOB',reservadas);
   g_borrar.Add(reservadas);
   fuente:=dm.xblobname(reg.hbiblioteca,reg.hnombre);
   convertido:=g_tmpdir+'\'+reg.hnombre;
   if ShellExecute(Handle, nil,pchar(rgmlang),
      pchar(fuente+' '+convertido+' '+directivas+' '+reservadas),
      nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar la conversion')),
            pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   }
   if ShellExecute( Handle, nil, pchar( g_ruta + '\nat2cob\cnv.bat' ),
      pchar( reg.hnombre + ' ' + reg.hbiblioteca ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la conversión' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );

end;

procedure Tfarbol.convertirngl( Sender: Tobject );
var
   reg: ^Tmyrec;
   rgmlang, directivas, directivas2, fuente, convertido, examdiff: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   rgmlang := g_tmpdir + '\hta11.exe';
   dm.get_utileria( 'RGMLANG', rgmlang );
   g_borrar.Add( rgmlang );
   directivas := g_tmpdir + '\dirngl1.dir';
   dm.get_utileria( 'DIRECTIVAS RGMCNVNATNGLVSAM', directivas );
   g_borrar.Add( directivas );
   directivas2 := g_tmpdir + '\dirnat2.dir';
   dm.get_utileria( 'DIRECTIVAS RGMCNVNATNGLVSAM2', directivas2 );
   g_borrar.Add( directivas2 );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   dm.ejecuta_espera( rgmlang + ' ' + fuente + ' nada ' + directivas, SW_SHOW );
   dm.ejecuta_espera( rgmlang + ' nada ' + convertido + ' ' + directivas2, SW_SHOW );
   examdiff := g_tmpdir + '\hta' + formatdatetime( 'hhmmss', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', examdiff );
   g_borrar.Add( examdiff );
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.comparanatural_cobol( Sender: Tobject );
var
   reg: ^Tmyrec;
   examdiff, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   examdiff := 'hta' + formatdatetime( 'hhmmss', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', examdiff );
   g_borrar.Add( examdiff );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_ruta + '\nat2cob\' + reg.hnombre + '.cob';
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.convertirnat_panta( Sender: Tobject );
var
   reg: ^Tmyrec;
   rgmlang, directivas, reservadas, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   rgmlang := g_tmpdir + '\hta11.exe';
   dm.get_utileria( 'RGMLANG', rgmlang );
   g_borrar.Add( rgmlang );
   directivas := g_tmpdir + '\dirnat.dir';
   dm.get_utileria( 'DIRECTIVAS CNVNATCOB', directivas );
   g_borrar.Add( directivas );
   reservadas := g_tmpdir + '\natural_cnv.res';
   dm.get_utileria( 'RESERVADAS CNVNATCOB', reservadas );
   g_borrar.Add( reservadas );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   if ShellExecute( Handle, nil, pchar( rgmlang ),
      pchar( fuente + ' ' + convertido + ' ' + directivas + ' ' + reservadas ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la conversión' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.convertirnat_ddm( Sender: Tobject );
var
   reg: ^Tmyrec;
   rgmlang, directivas, reservadas, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   rgmlang := g_tmpdir + '\hta11.exe';
   dm.get_utileria( 'RGMLANG', rgmlang );
   g_borrar.Add( rgmlang );
   directivas := g_tmpdir + '\dirnat.dir';
   dm.get_utileria( 'DIRECTIVAS CNVNATDDM', directivas );
   g_borrar.Add( directivas );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   dm.ejecuta_espera( rgmlang + ' ' + fuente + ' nada ' + directivas + ' > ' + convertido, SW_HIDE );
   screen.Cursor := crdefault;
end;

procedure Tfarbol.comparanatural_cics( Sender: Tobject );
var
   reg: ^Tmyrec;
   examdiff, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   examdiff := 'hta' + formatdatetime( 'hhmmss', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', examdiff );
   g_borrar.Add( examdiff );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.comparanatural_ddm( Sender: Tobject );
var
   reg: ^Tmyrec;
   examdiff, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   examdiff := 'hta' + formatdatetime( 'hhmmss', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', examdiff );
   g_borrar.Add( examdiff );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.convertirnat_fdt( Sender: Tobject );
var
   reg: ^Tmyrec;
   rgmlang, directivas, reservadas, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   rgmlang := g_tmpdir + '\hta11.exe';
   dm.get_utileria( 'RGMLANG', rgmlang );
   g_borrar.Add( rgmlang );
   directivas := g_tmpdir + '\dirnat.dir';
   dm.get_utileria( 'DIRECTIVAS CNVNATFPT', directivas );
   g_borrar.Add( directivas );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   dm.ejecuta_espera( rgmlang + ' ' + fuente + ' nada ' + directivas + ' > ' + convertido, SW_HIDE );
   screen.Cursor := crdefault;
end;

procedure Tfarbol.comparanatural_fdt( Sender: Tobject );
var
   reg: ^Tmyrec;
   examdiff, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   examdiff := 'hta' + formatdatetime( 'hhmmss', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', examdiff );
   g_borrar.Add( examdiff );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.convertirnat_nmp( Sender: Tobject );
var
   reg: ^Tmyrec;
   rgmlang, directivas, reservadas, fuente, convertido: string;
   xa, xb: Tstringlist;
   i: integer;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   rgmlang := g_tmpdir + '\hta11.exe';
   dm.get_utileria( 'RGMLANG', rgmlang );
   g_borrar.Add( rgmlang );
   directivas := g_tmpdir + '\dirnat.dir';
   dm.get_utileria( 'DIRECTIVAS CNVNATNMP', directivas );
   g_borrar.Add( directivas );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   dm.ejecuta_espera( rgmlang + ' ' + fuente + ' ' + convertido + ' ' + directivas + ' > ' + convertido + '.cpy', SW_HIDE );
   dm.ejecuta_espera( rgmlang + ' ' + fuente + ' ' + convertido + ' ' + directivas + ' > ' + convertido + '.cpy', SW_HIDE );
   xa := Tstringlist.Create;
   xb := Tstringlist.Create;
   xa.LoadFromFile( convertido + '.cpy' );
   i := 0;
   while i < xa.Count do begin
      if copy( xa[ i ], 1, 1 ) = '2' then begin
         xb.Add( xa[ i ] );
         xa.Delete( i );
      end
      else
         inc( i );
   end;
   xa.AddStrings( xb );
   xa.SaveToFile( convertido + '.txt' );
   xa.Free;
   xb.Free;
   screen.Cursor := crdefault;
end;

procedure Tfarbol.comparanatural_nmp( Sender: Tobject );
var
   reg: ^Tmyrec;
   examdiff, fuente, convertido: string;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.Data;
   examdiff := 'hta' + formatdatetime( 'hhmmss', now ) + '.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', examdiff );
   g_borrar.Add( examdiff );
   fuente := dm.xblobname( reg.hbiblioteca, reg.hnombre, reg.hclase );
   convertido := g_tmpdir + '\' + reg.hnombre;
   if ShellExecute( Handle, nil, pchar( examdiff ), pchar( fuente + ' ' + convertido ),
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede ejecutar la comparación' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   if ShellExecute( Handle, nil, pchar( convertido + '.txt' ), nil,
      nil, SW_SHOW ) <= 32 then
      Application.MessageBox( pchar( dm.xlng( 'No puede mostrar el copy' ) ),
         pchar( dm.xlng( 'Error' ) ), MB_ICONEXCLAMATION );
   screen.Cursor := crdefault;

end;

procedure Tfarbol.metricas_codepro( Sender: TObject ); // sin liberar
var
   reg: ^Tmyrec;
   archivo: string;
begin
   reg := nodo_actual.Data;
   archivo := 'c:\componentes_source\codepro_metricas\' + reg.hnombre + '.html';
   if ShellExecute( 0, nil, pchar( archivo ), nil, nil, SW_SHOW ) <= 32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
         'Error', MB_ICONEXCLAMATION );
   end;
end;

procedure Tfarbol.dependencias_codepro( Sender: TObject ); // sin liberar
var
   reg: ^Tmyrec;
   archivo: string;
begin
   reg := nodo_actual.Data;
   archivo := 'c:\componentes_source\codepro_dependencias\' + reg.hnombre + '.mht';
   if ShellExecute( 0, nil, pchar( archivo ), nil, nil, SW_SHOW ) <= 32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
         'Error', MB_ICONEXCLAMATION );
   end;
end;

procedure Tfarbol.tvMouseDown( Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer );
var
   HT: THitTests;
   reg, reg_padre: ^Tmyrec;
   k, lwLinIni, lwLinFin: integer;
   panta: Tfsvsdelphi;
   nodo_padre: Ttreenode;
   WArchRutina: string;
   i, f, l, linea, m: integer;
   texto, Wtexto: string;
begin
   screen.Cursor := crsqlwait;
   try
      WArchRutina := '';
      HT := tv.GetHitTestInfoAt( X, Y );

      if not ( htOnItem in HT ) then
         exit;

      nodo_actual := tv.GetNodeAt( X, Y );
      g_X := X;
      g_Y := Y;
      nodo_actual.Selected := true;
      gral.PopGral.Items.Clear;
      reg := nodo_actual.Data;

      if ( reg.hclase = 'CLA' ) or ( reg.hclase = 'SUBCLASE' ) or ( reg.hclase = 'USER' ) or
         ( reg.hclase = 'EMPRESA' ) or ( reg.hclase = 'OFICINA' ) or
         ( reg.hclase = 'SISTEMA' ) or ( reg.hclase = 'USERPRO' ) then
         image1.Visible := true;
      /////else
      /////   memo.Visible := true;

      gral.PopGral.Images := dm.ImageList3;
      // if pos('(CICLADO )',reg.hnombre)>0 then exit;

      if reg.hclase = 'EMPRESA' then begin
         if g_language = 'ENGLISH' then
            agrega_al_menu( 'Company : ' + nodo_actual.Text )
         else
            agrega_al_menu( 'Empresa : ' + nodo_actual.Text );

         agrega_al_menu( '-' );
      end

      else if reg.hclase = 'OFICINA' then begin
         if g_language = 'ENGLISH' then
            agrega_al_menu( 'Office : ' + nodo_actual.Text )
         else
            agrega_al_menu( 'Oficina : ' + nodo_actual.Text );
         agrega_al_menu( '-' );
      end

      else if reg.hclase = 'SISTEMA' then begin
         if g_language = 'ENGLISH' then
            agrega_al_menu( 'Application : ' + nodo_actual.Text )
         else
            agrega_al_menu( 'Sistema : ' + nodo_actual.Text );
         agrega_al_menu( '-' );
         if fileexists( 'c:\componentes_source\codepro_metricas\' + reg.hnombre + '.html' ) then begin
            k := agrega_al_menu( 'Métricas CODEPRO' );
            gral.PopGral.Items[ k ].OnClick := metricas_codepro;
         end;
         if fileexists( 'c:\componentes_source\codepro_dependencias\' + reg.hnombre + '.mht' ) then begin
            k := agrega_al_menu( 'Dependencias CODEPRO' );
            gral.PopGral.Items[ k ].OnClick := dependencias_codepro;
         end;
      end

      else if reg.hclase = 'CLA' then begin
         if g_language = 'ENGLISH' then
            agrega_al_menu( 'Class : ' + nodo_actual.Text )
         else
            agrega_al_menu( 'Clase : ' + nodo_actual.Text );
         agrega_al_menu( '-' );
      end

      else if reg.hclase = 'SUBCLASE' then begin
         if g_language = 'ENGLISH' then
            //agrega_al_menu('Subclase : ' + nodo_actual.Text)
            agrega_al_menu( 'Subclase : ' + reg.hnombre )
         else
            //agrega_al_menu('Subclase : ' + nodo_actual.Text);
            agrega_al_menu( 'Subclase : ' + clase_descripcion_todas[ clase_todas.IndexOf( reg.pnombre ) ] );
         agrega_al_menu( '-' );
      end

      else if reg.hclase = 'USER' then begin
         if g_language = 'ENGLISH' then
            agrega_al_menu( 'My Projects : ' + nodo_actual.Text )
         else
            agrega_al_menu( 'Mis Proyectos : ' + nodo_actual.Text );
         agrega_al_menu( '-' );
         k := agrega_al_menu( 'Nuevo Proyecto' );
         gral.PopGral.Items[ k ].OnClick := nuevo_proyecto;
      end

      else if ( reg.pclase = 'USERPRO' ) or
         ( reg.pclase = 'CONSULTA' ) or
         ( ( reg.hclase = 'USERPRO' ) and ( nodo_actual.HasChildren = false ) ) then begin //solo puede borrar proyectos que no tiene hijos
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Delete Item' )
         else
            k := agrega_al_menu( 'Borrar Item' );
         gral.PopGral.Items[ k ].OnClick := borrar_item;
      end

      else if ( reg.pclase = 'CONSULTA' ) or // Esta condición esta para que no truene, cuando piden PopUp de un proyecto que no tiene Hijos
      ( reg.hclase = 'USERPRO' ) then begin
      end

      else begin // Delphi
         if reg.hclase = 'DFX' then begin
         end
         else begin // no es = 'DFX'
            //memo.Lines.Clear;
            if ( reg.hclase = 'WHH' ) then begin // busca cualquier WHH
               //---
               if dm.sqlselect( dm.q1, 'select * from tsrela ' + //si el owner es CSS entonces es un WHH de un CSS
                  ' where hcprog=' + g_q + reg.hnombre + g_q +
                  ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                  ' and   hcclase=' + g_q + reg.hclase + g_q +
                  ' and   sistema=' + g_q + reg.sistema + g_q +
                  ' and   occlase=' + g_q + 'CSS' + g_q ) then begin
                  if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
                     ' where hcprog=' + g_q + reg.hnombre + g_q +
                     ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                     ' and   hcclase=' + g_q + reg.hclase + g_q +
                     ' and   sistema=' + g_q + reg.sistema + g_q +
                     ' and   pcclase =' + g_q + 'CSS' + g_q ) then begin
                     dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
                        dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                     BuscarTexto( reg.hnombre );
                  end;
               end;
            end; // FIN busca cualquier WHH

            if ( clase_fisico.IndexOf( reg.hclase ) = -1 ) then begin // esta es la buena, quitar los otros de ETP,ITP,UTI,PCK
               nodo_padre := nodo_actual;
               repeat
                  nodo_padre := nodo_padre.Parent;
                  if nodo_padre <> nil then
                     reg_padre := nodo_padre.Data
                  else
                     break;
               until ( clase_fisico.indexof( reg_padre.hclase ) > -1 );
               if nodo_padre <> nil then begin
                  // INICIO - ESTO ES UNA PRUEBA PARA JAVA
                  if ( reg_padre.hclase = 'JAV' ) or ( reg_padre.hclase = 'JLA' ) then begin

                     if dm.sqlselect( dm.q1, 'select * from tsrela ' +
                        ' where hcprog=' + g_q + reg.hnombre + g_q +
                        ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                        ' and   hcclase=' + g_q + reg.hclase + g_q +
                        ' and   sistema=' + g_q + reg.sistema + g_q +
                        ' and   externo like  ' + g_q + '%SUPER%' + g_q ) then begin

                        if dm.sqlselect( dm.q2, 'select * from tsrela ' +
                           ' where hcbib=' + g_q + dm.q1.fieldbyname( 'hcbib' ).AsString + g_q +
                           ' and   hcprog=' + g_q + dm.q1.fieldbyname( 'hcprog' ).AsString + g_q +
                           ' and   sistema=' + g_q + dm.q1.fieldbyname( 'sistema' ).AsString + g_q +
                           ' and  externo not like  ' + g_q + '%SUPER%' + g_q ) then begin
                           dm.trae_fuente(
                              dm.q2.fieldbyname( 'sistema' ).AsString,
                              dm.q2.fieldbyname( 'ocprog' ).AsString,
                              dm.q2.fieldbyname( 'ocbib' ).AsString,
                              dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                           SePosicionaLineaInicial( reg.hnombre, strtoint( dm.q2.fieldbyname( 'iniciolinea' ).AsString ) );
                           //se_posiciona_en_la_linea( reg.hnombre );
                        end
                        else begin
                           dm.sqlselect( dm.q2, 'select * from tsrela ' +
                              ' where hcprog=' + g_q + reg.hnombre + g_q +
                              ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                              ' and   hcclase=' + g_q + reg.hclase + g_q +
                              ' and   sistema=' + g_q + reg.sistema + g_q );
                           dm.trae_fuente( reg_padre.sistema, reg_padre.hnombre, reg_padre.hbiblioteca, reg_padre.hclase, memo );
                           SePosicionaLineaInicial( reg.hnombre, strtoint( dm.q2.fieldbyname( 'iniciolinea' ).AsString ) );
                           //se_posiciona_en_la_linea( reg.hnombre );
                        end;

                     end
                     else begin
                        dm.sqlselect( dm.q2, 'select * from tsrela ' +
                           ' where hcprog=' + g_q + reg.hnombre + g_q +
                           ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                           ' and   hcclase=' + g_q + reg.hclase + g_q +
                           ' and   sistema=' + g_q + reg.sistema + g_q );
                        dm.trae_fuente( reg_padre.sistema, reg_padre.hnombre, reg_padre.hbiblioteca, reg_padre.hclase, memo );
                        SePosicionaLineaInicial( reg.hnombre, strtoint( dm.q2.fieldbyname( 'lineainicio' ).AsString ) );
                        //se_posiciona_en_la_linea( reg.hnombre );
                     end;

                     // FIN _PRUEBA.

                  end

                  else begin //hcclase = 'JAV'

                     /////farbol.Memo.Visible := false;
                     /////farbol.Image1.Visible := true;

                     //dm.trae_fuente( reg_padre.hnombre, reg_padre.hbiblioteca, reg_padre.hclase, memo );
                     //farbol.Memo.Visible := false;
                     //farbol.Image1.Visible := true;
                     linea := 0;

                     if dm.sqlselect( dm.q4, 'select * from tsrela ' +
                        ' where hcprog=' + g_q + reg.hnombre + g_q +
                        ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                        ' and   hcclase=' + g_q + reg.hclase + g_q +
                        ' and   sistema=' + g_q + reg.sistema + g_q ) then begin //Busac en tsrela

                        lwLinIni := dm.q4.fieldbyname( 'lineainicio' ).AsInteger;
                        lwLinFin := dm.q4.fieldbyname( 'lineafinal' ).AsInteger;

                        if lwLinIni = null then
                           lwLinIni := 0;
                        if lwLinFin = null then
                           lwLinFin := 0;

                        if ( lwLinIni > 0 )
                           and ( lwLinFin > 0 ) then begin
                           //dm.trae_fuente( reg.pnombre, reg.pbiblioteca, reg.pclase, memo );
                           dm.trae_fuente( reg_padre.sistema, reg_padre.hnombre, reg_padre.hbiblioteca, reg_padre.hclase, memo );
                           WarchRutina := gral.extrae_rutina( reg_padre.hnombre, lwLinIni, lwLinFin, memo.lines );
                           memo.Lines.LoadFromFile( WArchRutina );
                        end
                        else begin
                           //se_posiciona_en_la_linea( reg.hnombre );
                           //BuscarTexto( reg.hnombre );
                           if lwLinIni > 0 then
                              linea := lwLinIni
                           else begin
                              texto := nodo_actual.text;
                              i := pos( '[', texto ) + 1;
                              f := pos( ']', texto );
                              l := f - i;
                              if ( l > 0 ) then begin
                                 try
                                    Wtexto := copy( texto, i, l );
                                    if gral.EsNumerico( Wtexto ) then
                                       linea := strtoint( Wtexto )
                                    else
                                       linea := 0;
                                 except
                                    linea := 0
                                 end;
                              end;
                           end;
                        end;
                        dm.trae_fuente( reg_padre.sistema, reg_padre.hnombre, reg_padre.hbiblioteca, reg_padre.hclase, memo );
                        if memo.Lines.Count = 0 then //Esto es para darle tiempo de traer el fuente
                           dm.trae_fuente( reg_padre.sistema, reg_padre.hnombre, reg_padre.hbiblioteca, reg_padre.hclase, memo );
                        if linea > 0 then begin
                           SePosicionaLineaInicial( reg_padre.hnombre, linea )
                        end;
                     end; //busca en tsrela
                  end; // <> JAV

                  //if nodo_padre <> nil then begin
                  if memo.Lines.Count > 0 then begin
                     farbol.Image1.Visible := false;
                     farbol.Memo.Visible := true;
                  end
                  else begin
                     farbol.Image1.Visible := true;
                     farbol.Memo.Visible := false;
                  end;
               end;
            end
            else if ( reg.hclase = 'ETP' )
               or ( clase_VB.IndexOf( reg.hclase ) > -1 ) then begin // busca cualquier ETP (Hay ETPs hijos de otro ETP)
               //memo.Lines.Clear;
 //---
               if dm.sqlselect( dm.q1, 'select * from tsrela ' + //si el owner es PHP entonces es un ETP de un PHP
                  ' where hcprog=' + g_q + reg.hnombre + g_q +
                  ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                  ' and   hcclase=' + g_q + reg.hclase + g_q +
                  ' and   sistema=' + g_q + reg.sistema + g_q +
                  ' and   occlase in(' + g_q + 'PHP' + g_q + ',' + g_q + 'JSS' + g_q + ',' + g_q + 'JAV' + g_q + ',' + g_q + 'PKC' + g_q + ',' +
                  g_q + 'JSP' + g_q + ')' ) then begin
                  if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
                     ' where hcprog=' + g_q + reg.hnombre + g_q +
                     ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                     ' and   hcclase=' + g_q + reg.hclase + g_q +
                     ' and   sistema=' + g_q + reg.sistema + g_q +
                     ' and   pcclase in(' + g_q + 'PHP' + g_q + ',' + g_q + 'JSS' + g_q + ',' + g_q + 'JAV' + g_q + ',' + g_q + 'PKC' + g_q + ',' +
                     g_q + 'JSP' + g_q + ')' ) then begin
                     dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
                        dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                     se_posiciona_en_la_linea( reg.hnombre );
                  end;
               end
               else begin
                  //--
                  if dm.sqlselect( dm.q1, 'select * from tsrela ' + //si el owner es BAS entonces es un ETP de una forma
                     ' where hcprog=' + g_q + reg.hnombre + g_q +
                     ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                     ' and   hcclase=' + g_q + reg.hclase + g_q +
                     ' and   sistema=' + g_q + reg.sistema + g_q +
                     ' and   occlase=' + g_q + 'BAS' + g_q ) then begin
                     if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
                        ' where hcprog=' + g_q + reg.hnombre + g_q +
                        ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                        ' and   hcclase=' + g_q + reg.hclase + g_q +
                        ' and   sistema=' + g_q + reg.sistema + g_q +
                        ' and   pcclase =' + g_q + 'BAS' + g_q ) then begin
                        dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
                           dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                        aisla_rutina_Visual_Basic( reg.hnombre );
                     end
                     else begin
                        if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
                           ' where hcprog=' + g_q + reg.hnombre + g_q +
                           ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                           ' and   hcclase=' + g_q + reg.hclase + g_q +
                           ' and   sistema=' + g_q + reg.sistema + g_q +
                           ' and   pcclase in(' + g_q + 'BFR' + g_q + ',' + g_q + 'ETP' + g_q + ')' ) then begin
                           dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
                              dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                           aisla_rutina_Visual_Basic( reg.hnombre );
                        end;
                     end;
                  end
                  else begin
                     if dm.sqlselect( dm.q1, 'select * from tsrela ' + //si el owner es BFR entonces es un ETP de una forma
                        ' where hcprog=' + g_q + reg.hnombre + g_q +
                        ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                        ' and   hcclase=' + g_q + reg.hclase + g_q +
                        ' and   sistema=' + g_q + reg.sistema + g_q +
                        ' and   occlase=' + g_q + 'BFR' + g_q ) then begin
                        if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
                           ' where hcprog=' + g_q + reg.hnombre + g_q +
                           ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                           ' and   hcclase=' + g_q + reg.hclase + g_q +
                           ' and   sistema=' + g_q + reg.sistema + g_q +
                           //                        ' and   pcclase in(' + g_q + 'BFR' + g_q + ',' + g_q + 'ETP' + g_q + ')' ) then begin
                           ' and   (pcclase in(' + g_q + 'BFR' + g_q + ',' + g_q + 'WFO' + g_q + ',' + g_q + 'ETP' + g_q + ')' +
                           ' or pcclase like ' + g_q + 'W%' + g_q + ')' ) then begin
                           dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
                              dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                           aisla_rutina_Visual_Basic( reg.hnombre );
                        end
                        else begin
                           if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
                              ' where hcprog=' + g_q + reg.hnombre + g_q +
                              ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                              ' and   hcclase=' + g_q + reg.hclase + g_q +
                              ' and   sistema=' + g_q + reg.sistema + g_q +
                              ' and   pcclase in(' + g_q + 'CLS' + g_q + ',' + g_q + 'ETP' + g_q + ')' ) then begin
                              dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
                                 dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                              aisla_rutina_cls( reg.hnombre );
                           end;
                        end;
                     end
                     else begin
                        if dm.sqlselect( dm.q1, 'select * from tsrela ' + //si el owner es CLS entonces es un ETP de un proceso
                           ' where hcprog=' + g_q + reg.hnombre + g_q +
                           ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                           ' and   hcclase=' + g_q + reg.hclase + g_q +
                           ' and   sistema=' + g_q + reg.sistema + g_q +
                           ' and   occlase=' + g_q + 'CLS' + g_q ) then begin
                           if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
                              ' where hcprog=' + g_q + reg.hnombre + g_q +
                              ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                              ' and   hcclase=' + g_q + reg.hclase + g_q +
                              ' and   sistema=' + g_q + reg.sistema + g_q +
                              ' and   pcclase in(' + g_q + 'CLS' + g_q + ',' + g_q + 'ETP' + g_q + ')' ) then begin
                              dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
                                 dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, memo );
                              aisla_rutina_CLS( reg.hnombre );
                           end;
                        end
                     end;
                  end;
                  if memo.Lines.Count > 0 then begin
                     farbol.Image1.Visible := false;
                     farbol.Memo.Visible := true;
                  end
                  else begin
                     farbol.Image1.Visible := true;
                     farbol.Memo.Visible := false;
                  end;
               end;
            end // ETP   FIN
            else if reg.hclase = 'DFY' then begin
               if dm.sqlselect( dm.q1, 'select * from tsrela ' +
                  ' where hcprog=' + g_q + reg.hnombre + g_q +
                  ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                  ' and   hcclase=' + g_q + reg.hclase + g_q +
                  ' and   sistema=' + g_q + reg.sistema + g_q +
                  ' and   pcclase=' + g_q + 'PAS' + g_q ) then begin
                  if dm.sqlselect( dm.q2, 'select * from tsprog ' +
                     ' where cprog=' + g_q + dm.q1.fieldbyname( 'pcprog' ).AsString + g_q +
                     ' and   cbib=' + g_q + dm.q1.fieldbyname( 'pcbib' ).AsString + g_q +
                     ' and   sistema=' + g_q + dm.q1.fieldbyname( 'sistema' ).AsString + g_q +
                     ' and   cclase=' + g_q + dm.q1.fieldbyname( 'pcclase' ).AsString + g_q ) then begin
                     dm.blob3memo( dm.q2.fieldbyname( 'cblob' ).AsString, memo );
                     aisla_rutina_delphi( reg.hnombre );
                     if memo.Lines.Count > 0 then begin
                        farbol.Image1.Visible := false;
                        farbol.Memo.Visible := true;
                     end
                     else begin
                        farbol.Image1.Visible := true;
                        farbol.Memo.Visible := false;
                     end;
                  end;
               end;
            end
            else if ( reg.hclase = 'PCK' )
               or ( reg.hclase = 'UTI' ) then begin
               nodo_padre := nodo_actual;
               repeat
                  nodo_padre := nodo_padre.Parent;
                  reg_padre := nodo_padre.Data;
               until clase_fisico.indexof( reg_padre.hclase ) > -1;
               dm.trae_fuente( reg_padre.sistema, reg_padre.hnombre, reg_padre.hbiblioteca, reg_padre.hclase, memo );
               se_posiciona_en_la_linea( reg.hnombre );
               if memo.Lines.Count > 0 then begin
                  farbol.Image1.Visible := false;
                  farbol.Memo.Visible := true;
               end
               else begin
                  farbol.Image1.Visible := true;
                  farbol.Memo.Visible := false;
               end;
            end
            else if ( reg.hclase = 'ETP' )
               or ( reg.hclase = 'ITP' ) then begin
               if dm.sqlselect( dm.q1, 'select * from tsrela ' +
                  ' where hcprog=' + g_q + reg.hnombre + g_q +
                  ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                  ' and   hcclase=' + g_q + reg.hclase + g_q +
                  ' and   sistema=' + g_q + reg.sistema + g_q +
                  ' and   occlase=' + g_q + 'JAV' + g_q ) then begin
                  if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la linea
                     ' where hcprog=' + g_q + reg.hnombre + g_q +
                     ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                     ' and   hcclase=' + g_q + reg.hclase + g_q +
                     ' and   sistema=' + g_q + reg.sistema + g_q +
                     ' and   pcclase=' + g_q + 'JAV' + g_q ) then begin
                     //memo.Lines.Clear;
                     dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'pcprog' ).AsString,
                        dm.q2.fieldbyname( 'pcbib' ).AsString, dm.q2.fieldbyname( 'pcclase' ).AsString, memo );
                     se_posiciona_en_la_linea( reg.hnombre );
                     if memo.Lines.Count > 0 then begin
                        farbol.Image1.Visible := false;
                        farbol.Memo.Visible := true;
                     end
                     else begin
                        farbol.Image1.Visible := true;
                        farbol.Memo.Visible := false;
                     end;
                  end;
               end;
            end
            else if clase_fisico.IndexOf( reg.hclase ) > -1 then begin
               // if memo_componente <> reg.hnombre + '_' + reg.hbiblioteca then begin
               //validar funcionalidad memo_componente
               /////memo.Lines.Clear;
               x1 := 0;
               if ( reg.hclase = 'GIF' )
                  or ( reg.hclase = 'JPG' )
                  or ( reg.hclase = 'PNG' ) then begin
                  vista_imagenes( sender );
               end
               else begin
                  if reg.hclase = 'BMS' then
                     ////dm.trae_fuente( reg.ocprog, reg.ocbib, reg.occlase, memo );      ///Ver porque estaba como comentario-------
                     dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, memo );
                  farbol.Image1.Visible := true;
                  farbol.Memo.Visible := false;

                  if dm.sqlselect( dm.q4, 'select * from tsrela ' +
                     ' where hcprog=' + g_q + reg.hnombre + g_q +
                     ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
                     ' and   hcclase=' + g_q + reg.hclase + g_q +
                     ' and   sistema=' + g_q + reg.sistema + g_q ) then begin

                     lwLinIni := dm.q4.fieldbyname( 'lineainicio' ).AsInteger;
                     lwLinFin := dm.q4.fieldbyname( 'lineafinal' ).AsInteger;

                     if lwLinIni = null then
                        lwLinIni := 0;
                     if lwLinFin = null then
                        lwLinFin := 0;
                     if ( lwLinIni > 0 )
                        and ( lwLinFin > 0 ) then begin
                        dm.trae_fuente( reg.sistema, reg.ocprog, reg.ocbib, reg.occlase, memo );
                        WarchRutina := gral.extrae_rutina( reg.ocprog, lwLinIni, lwLinFin, memo.lines ); //????????
                        memo.Lines.LoadFromFile( WArchRutina );
                     end
                     else begin
                        //se_posiciona_en_la_linea( dm.q4.fieldbyname( 'pcprog' ).AsString );
                        //se_posiciona_en_la_linea( reg.ocprog );
                       // BuscarTexto( reg.ocprog );
                        linea := 0;
                        if lwLinIni > 0 then
                           linea := lwLinIni
                        else begin
                           texto := nodo_actual.text;
                           i := pos( '[', texto ) + 1;
                           f := pos( ']', texto );
                           l := f - i;
                           if ( l > 0 ) then begin
                              try
                                 Wtexto := copy( texto, i, l );
                                 if gral.EsNumerico( Wtexto ) then
                                    linea := strtoint( Wtexto )
                                 else
                                    linea := 0;
                              except
                                 linea := 0
                              end;
                           end;
                        end;

                     end;
                     dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, memo );
                     if memo.Lines.Count = 0 then
                        dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, memo );
                     if linea > 0 then begin
                        SePosicionaLineaInicial( reg.hnombre, linea );
                     end;
                  end;

                  if memo.Lines.Count > 0 then begin
                     farbol.Image1.Visible := false;
                     farbol.Memo.Visible := true;
                  end
                  else begin
                     farbol.Image1.Visible := true;
                     farbol.Memo.Visible := false;
                     farbol.image2.Visible := false;
                  end;
                  //memo_componente := reg.hnombre + '_' + reg.hbiblioteca;
                  //validar funcionalidad memo_componente
               end;
            end;
            /////agrega_al_menu(clase_descripcion[clase_fisico.IndexOf(reg.hclase)] + ' - ' + nodo_actual.Text);
            agrega_al_menu( clase_descripcion_todas[ clase_todas.IndexOf( reg.hclase ) ] + ' - ' + nodo_actual.Text );
            agrega_al_menu( '-' );
            /////end;
         end;
      end;
      //---------------
      if x1 = 0 then begin
         if ( memo.Lines.Count > 0 ) then begin
            farbol.Image1.Visible := false;
            farbol.Memo.Visible := true;
         end
         else begin
            farbol.Image1.Visible := true;
            farbol.Memo.Visible := false;
         end;
      end
      else
         x1 := 0;
      //---------------

      if ( reg.hclase = 'NVW' ) or
         ( reg.hclase = 'NIN' ) or
         ( reg.hclase = 'NUP' ) or
         ( reg.hclase = 'NDL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'CRUD ADABAS' )
         else
            k := agrega_al_menu( 'ADABAS CRUD' );
         gral.PopGral.Items[ k ].OnClick := adabas_crud;
         gral.PopGral.Items[ K ].ImageIndex := 5;
      end;

      {
      if dm.sqlselect( dm.q1, 'select * from tsattribute ' +
         ' where cprog=' + g_q + reg.hnombre + g_q +
         ' and   cbib=' + g_q + reg.hbiblioteca + g_q +
         ' and   cclase=' + g_q + reg.hclase + g_q ) then begin
            if g_language = 'ENGLISH' then
               k := agrega_al_menu( 'Attributes' )
            else
               k := agrega_al_menu( 'Atributos' );
            gral.PopGral.Items[ k ].OnClick := atributos;
      end;
      }
      if dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where ocprog=' + g_q + reg.ocprog + g_q +
         ' and   ocbib=' + g_q + reg.ocbib + g_q +
         ' and   occlase=' + g_q + reg.occlase + g_q +
         ' and   pcprog=' + g_q + reg.pnombre + g_q +
         ' and   pcbib=' + g_q + reg.pbiblioteca + g_q +
         ' and   pcclase=' + g_q + reg.pclase + g_q +
         ' and   hcprog=' + g_q + reg.hnombre + g_q +
         ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
         ' and   hcclase=' + g_q + reg.hclase + g_q +
         ' and   orden=' + g_q + reg.orden + g_q +
         ' and   sistema=' + g_q + reg.sistema + g_q +
         ' and   atributos is not null ' )
         or
         dm.sqlselect( dm.q1, 'select * from tsrela ' +
         ' where ocprog=' + g_q + reg.hnombre + g_q +
         ' and   ocbib=' + g_q + reg.hbiblioteca + g_q +
         ' and   occlase=' + g_q + reg.hclase + g_q +
         ' and   pcprog=' + g_q + reg.hclase + g_q +
         ' and   pcbib=' + g_q + reg.sistema + g_q +
         ' and   pcclase=' + g_q + 'CLA' + g_q +
         ' and   hcprog=' + g_q + reg.hnombre + g_q +
         ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
         ' and   hcclase=' + g_q + reg.hclase + g_q +
         ' and   orden=' + g_q + '0001' + g_q +
         ' and   sistema=' + g_q + reg.sistema + g_q +
         ' and   atributos is not null' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Attributes' )
         else
            k := agrega_al_menu( 'Atributos' );
         gral.PopGral.Items[ k ].OnClick := atributos;
      end;
      {
      if ( reg.pclase = 'USERPRO' ) or
         ( reg.pclase = 'CONSULTA' ) or
         ( ( reg.hclase = 'USERPRO' ) and ( nodo_actual.HasChildren = false ) ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Delete Item' )
         else
            k := agrega_al_menu( 'Borrar Item' );
         gral.PopGral.Items[ k ].OnClick := borrar_item;
      end;
       }
      // if dm.capacidad( 'Cambio de iconos Arbol' ) then begin
      if ( g_usuario = 'ADMIN' ) or ( g_usuario = 'SVS' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Change Icon' )
         else
            k := agrega_al_menu( 'Cambio de Icono' );
         gral.PopGral.Items[ k ].OnClick := cambia_icono;
      end;

      if ( reg.hclase <> 'EMPRESA' ) and
         ( reg.hclase <> 'OFICINA' ) and
         ( reg.hclase <> 'USER' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'SISTEMA' ) and
         ( reg.hclase <> 'SUBCLASE' ) and
         ( reg.hclase <> 'CLA' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_AIMPACTO )
         else
            k := agrega_al_menu( sDIGRA_AIMPACTO );
         gral.PopGral.Items[ k ].OnClick := DiagramaAnalisisImpacto;
         gral.PopGral.Items[ K ].ImageIndex := 12;
      end;

      if ( reg.hclase = 'CBL' ) then begin //diagrama bloques //isaac
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_BLOQUES ) //constante sDIGRA_BLOQUES
         else
            k := agrega_al_menu( sDIGRA_BLOQUES );

         gral.PopGral.Items[ k ].OnClick := DiagramaBloques;
         gral.PopGral.Items[ k ].ImageIndex := 17;
      end;

      if ( reg.hclase = 'NAT' ) or
         ( reg.hclase = 'NSP' ) or
         ( reg.hclase = 'NSR' ) or
         ( reg.hclase = 'NHL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         gral.PopGral.Items[ k ].OnClick := diagramanatural;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;
      if reg.hclase = 'CBL' then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         gral.PopGral.Items[ k ].OnClick := diagramacbl;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;
      if ( reg.hclase = 'CBL' ) or ( reg.hclase = 'CPY' ) then begin
         if reg.hclase = 'CBL' then
            k := agrega_al_menu( sDIGRA_FLUJO_CBL );
         if reg.hclase = 'CPY' then
            k := agrega_al_menu( sDIGRA_FLUJO_CPY );

         gral.PopGral.Items[ k ].OnClick := DiagramaCOBOL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'ALG' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_ALG );
         g_clase := reg.hclase;
         gral.PopGral.Items[ k ].OnClick := DiagramaFlujoALG;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'WFL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_WFL );
         g_clase := reg.hclase;
         gral.PopGral.Items[ k ].OnClick := DiagramaFlujoWFL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'WFL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart2' )
         else
            k := agrega_al_menu( sDIGRA_JERARQUICO_WFL );
         g_clase := reg.hclase;
         gral.PopGral.Items[ k ].OnClick := DiagramaJerarquicoWFL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'ALG' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart2' )
         else
            k := agrega_al_menu( sDIGRA_JERARQUICO_ALG );
         g_clase := reg.hclase;
         gral.PopGral.Items[ k ].OnClick := DiagramaJerarquicoALG;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      {
      if reg.hclase = 'JAV' then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         gral.PopGral.Items[ k ].OnClick := dghtml;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;
      }
      if reg.hclase = 'CLP' then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         gral.PopGral.Items[ k ].OnClick := diagramarpg;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      g_clase := '';
      if ( reg.hclase = 'JOB' ) or
         ( reg.hclase = 'JCL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         g_clase := reg.hclase;
         gral.PopGral.Items[ k ].OnClick := Diagramajcl;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'PCK' ) or ( reg.hclase = 'JAV' ) then begin //diagrama paquetes
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_PAQUETES ) //constante sDIGRA_PAQUETES
         else
            k := agrega_al_menu( sDIGRA_PAQUETES );

         gral.PopGral.Items[ k ].OnClick := DiagramaUMLPaquetes;
         gral.PopGral.Items[ K ].ImageIndex := 17;
      end;

      if ( reg.hclase = 'JAV' ) or ( reg.hclase = 'JLA' ) then begin //diagrama clases
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_CLASES )
         else
            k := agrega_al_menu( sDIGRA_CLASES );

         gral.PopGral.Items[ k ].OnClick := DiagramaUMLClases;
         gral.PopGral.Items[ K ].ImageIndex := 17;
      end;

      if ( reg.hclase = 'ASE' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         gral.PopGral.Items[ k ].OnClick := diagramaase;
         gral.PopGral.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase <> 'EMPRESA' ) and
         ( reg.hclase <> 'OFICINA' ) and
         ( reg.hclase <> 'USER' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'CLA' ) and
         ( reg.hclase <> 'SUBCLASE' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_PROCESOS )
         else
            k := agrega_al_menu( sDIGRA_PROCESOS );
         gral.PopGral.Items[ k ].OnClick := DiagramaProcesos;
         gral.PopGral.Items[ K ].ImageIndex := 9;
      end;

      if ( reg.hclase = 'SISTEMA' ) then begin
         k := agrega_al_menu( sDIGRA_SISTEMA );
         gral.PopGral.Items[ k ].OnClick := DiagramaSistema; //diagrama del sistema
      end;

      if ( reg.hclase <> 'SUBCLASE' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'USER' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Documentation' )
         else
            k := agrega_al_menu( 'Documentación' );
         gral.PopGral.Items[ k ].OnClick := Documentacion; //reglas_negocio //documentacion
      end;

      if ( reg.hclase <> '' ) and
         ( reg.hbiblioteca <> '' ) and
         ( reg.hnombre <> '' ) then begin
         k := agrega_al_menu( sLISTA_DRILLDOWN );
         gral.PopGral.Items[ k ].OnClick := ListaDrillDown; //Lista Drill Down
         gral.PopGral.Items[ K ].ImageIndex := 4;
      end;

      if ( reg.hclase <> '' ) and
         ( reg.hbiblioteca <> '' ) and
         ( reg.hnombre <> '' ) then begin
         k := agrega_al_menu( sLISTA_DRILLUP );
         gral.PopGral.Items[ k ].OnClick := ListaDrillUp; //Lista Drill Up
         gral.PopGral.Items[ K ].ImageIndex := 4;
      end;

      if ( clase_analizable.IndexOf( reg.hclase ) > -1 ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Parts List' )
         else
            k := agrega_al_menu( sLISTA_COMPONENTES );
         gral.PopGral.Items[ k ].OnClick := lista_componentes;
         gral.PopGral.Items[ K ].ImageIndex := 4;
      end;

      if ( clase_analizable.IndexOf( reg.hclase ) > -1 ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Parts List' )
         else
            k := agrega_al_menu( sLISTA_DEPENDENCIAS );
         gral.PopGral.Items[ k ].OnClick := lista_dependencias;
         gral.PopGral.Items[ K ].ImageIndex := 4;
      end;

      if ( reg.hclase = 'TAB' ) or
         ( reg.hclase = 'INS' ) or
         ( reg.hclase = 'UPD' ) or
         ( reg.hclase = 'DEL' ) or
         ( reg.hclase = 'IDX' ) or
         ( reg.hclase = 'SEL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'CRUD Table' )
         else
            k := agrega_al_menu( sLISTA_MATRIZ_CRUD );
         gral.PopGral.Items[ k ].OnClick := tabla_crud;
         gral.PopGral.Items[ K ].ImageIndex := 5;
      end;

      if ( reg.hclase = 'FIL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'CRUD File' )
         else
            k := agrega_al_menu( 'Matriz Archivo Físico' );
         gral.PopGral.Items[ k ].OnClick := archivo_fisico;
         gral.PopGral.Items[ K ].ImageIndex := 5;
      end;

      if ( reg.hclase = 'LOC' ) then begin
         k := agrega_al_menu( sMATRIZ_ARCHIVO_LOG );
         gral.PopGral.Items[ k ].OnClick := MatrizArchLog; //matriz archivo logico
         gral.PopGral.Items[ K ].ImageIndex := 5;
      end;

      if clase_analizable.IndexOf( reg.hclase ) > -1 then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Properties' )
         else
            k := agrega_al_menu( 'Propiedades' );
         gral.PopGral.Items[ k ].OnClick := propiedades;
      end;

      if ( reg.hclase <> 'EMPRESA' ) and
         ( reg.hclase <> 'OFICINA' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'USER' ) and
         ( reg.hclase <> 'SUBCLASE' ) then begin
         if ( reg.hbiblioteca <> 'BD' ) and ( reg.hbiblioteca <> 'DISK' ) and ( reg.hbiblioteca <> 'LOC' ) then begin
            if g_language = 'ENGLISH' then
               k := agrega_al_menu( 'Cross Reference' )
            else
               k := agrega_al_menu( sLISTA_REF_CRUZADAS );
            gral.PopGral.Items[ k ].OnClick := referencias_cruzadas;
            gral.PopGral.Items[ K ].ImageIndex := 13;
         end;
      end;

      if ( reg.hclase <> 'EMPRESA' ) and
         ( reg.hclase <> 'OFICINA' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'USER' ) and
         ( reg.hclase <> 'SISTEMA' ) and
         ( reg.hclase <> 'SUBCLASE' ) and
         ( reg.hclase <> 'CLA' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'ver Fuente' )
         else
            k := agrega_al_menu( 'Ver Fuente' );
         //gral.PopGral.Items[ k ].OnClick := NotePad1Click;  24052013
         gral.PopGral.Items[ k ].OnClick := VerFuente;
         gral.PopGral.Items[ K ].ImageIndex := 14;
      end;

      if ( reg.hclase <> 'CLA' ) then begin
         if clase_fisico.IndexOf( reg.hclase ) > -1 then begin
            if g_language = 'ENGLISH' then
               k := agrega_al_menu( 'Versions' )
            else
               k := agrega_al_menu( 'Versiones' );
            gral.PopGral.Items[ k ].OnClick := versionado;
         end;
      end;

      if reg.hclase = 'FMB' then begin // Pantalla de SQLFORMS
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Screen View' )
         else
            k := agrega_al_menu( 'Vista Pantalla' );
         gral.PopGral.Items[ k ].OnClick := fmb_vista_pantalla;
         fmb_nombre_pantalla := dm.pathbib( reg.hbiblioteca, reg.hclase ) + '\' + reg.hnombre + '.txt';
      end;

      if reg.hclase = 'DFM' then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := formadelphi_preview;
      end;

      if reg.hclase = 'BFR' then begin // Forma Visual Basic
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := formavb_preview;
      end;

      if reg.hclase = 'PNL' then begin // Panel IDEAL
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := panel_preview;
      end;

      if reg.hclase = 'BMS' then begin // Pantalla CICS
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := bms_preview;
      end;

      if reg.hclase = 'NMP' then begin // Mapa Natural
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := natural_mapa_preview;
      end;

      if ( reg.hclase = 'PHP' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := vista_falsa
      end;

      if ( reg.hclase = 'GIF' )
         or ( reg.hclase = 'JPG' )
         or ( reg.hclase = 'PNG' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := vista_imagenes;
      end;

      if ( reg.hclase = 'HTM' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := vista_htm;
      end;

      if ( reg.hclase = 'TSC' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         gral.PopGral.Items[ k ].OnClick := vista_tsc;
      end;

      if ( reg.hclase = 'CTR' ) or ( reg.hclase = 'CTM' ) then begin //diagrama scheduler
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_SCHEDULER )
         else
            k := agrega_al_menu( sDIGRA_SCHEDULER );
         gral.PopGral.Items[ k ].OnClick := DiagramaScheduler;
         gral.PopGral.Items[ K ].ImageIndex := 17;
      end;

   finally
      screen.Cursor := crdefault;
   end;

end;

procedure Tfarbol.expande( nodo: Ttreenode; nombre: string; bib: string;
   clase: string; veces: integer );
var
   qq, qq2: TADOQuery;
   nodx, nody, ts: Ttreenode;
   reg: ^Tmyrec;
   bexiste: boolean;
   descri, sistema, lExt, lNom: string;
begin
   reg := nodo.Data;
   reg.hijo_falso := false;
   sistema := reg.sistema;
   if clase = 'OFICINA' then begin
      if dm.sqlselect( dm.q2, 'select * from tssistema ' + // Sistemas
         ' where coficina=' + g_q + nombre + g_q +
         ' and cdepende' + g_is_null +
         ' and estadoactual=' + g_q + 'ACTIVO' + g_q +
         ' order by csistema' ) then begin
         while not dm.q2.Eof do begin
            if g_ArbolDescri = '1' then begin
               descri := dm.q2.fieldbyname( 'csistema' ).AsString + ' - ' +
                  dm.q2.fieldbyname( 'descripcion' ).AsString;
            end
            else
               descri := dm.q2.fieldbyname( 'descripcion' ).AsString;

            ts := tv.Items.AddChild( nodo, descri );

            //ts := tv.Items.AddChild( nodo, dm.q2.fieldbyname( 'csistema' ).AsString + ' - ' +
               //dm.q2.fieldbyname( 'descripcion' ).AsString );
            new( reg );
            reg.pnombre := dm.q2.fieldbyname( 'coficina' ).AsString;
            reg.pclase := 'OFICINA';
            reg.hnombre := dm.q2.fieldbyname( 'csistema' ).AsString;
            reg.hclase := 'SISTEMA';
            reg.hijo_falso := true;
            tv.Items.AddChild( ts, 'hijo falso' );
            ts.Data := reg;
            ts.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            ts.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            dm.q2.Next;
         end;
      end;
      exit;
   end;
   if clase = 'SISTEMA' then begin
      if dm.sqlselect( dm.q1,
         'select * from tssistema ' + // Subsistemas
         ' where cdepende=' + g_q + nombre + g_q +
         ' and estadoactual=' + g_q + 'ACTIVO' + g_q +
         ' order by csistema' ) then begin
         while not dm.q1.Eof do begin
            if g_ArbolDescri = '1' then begin
               descri := dm.q1.fieldbyname( 'csistema' ).AsString + ' - ' +
                  dm.q1.fieldbyname( 'descripcion' ).AsString;
            end
            else
               descri := dm.q1.fieldbyname( 'descripcion' ).AsString;

            ts := tv.Items.AddChild( nodo, descri );
            //ts := tv.Items.AddChild( nodo, dm.q1.fieldbyname( 'csistema' ).AsString + ' - ' +
               //dm.q1.fieldbyname( 'descripcion' ).AsString );
            new( reg );
            reg.pnombre := dm.q1.fieldbyname( 'cdepende' ).AsString;
            reg.pclase := 'SISTEMA';
            reg.hnombre := dm.q1.fieldbyname( 'csistema' ).AsString;
            reg.hclase := 'SISTEMA';
            reg.sistema := dm.q1.fieldbyname( 'csistema' ).AsString;
            reg.hijo_falso := true;
            tv.Items.AddChild( ts, 'hijo falso' );
            ts.Data := reg;
            ts.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            ts.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            dm.q1.Next;
         end;
      end;
      if dm.sqlselect( dm.q1,
         'select cclase, count(*) total from tsprog ' +
         ' where sistema=' + g_q + nombre + g_q +
         ' group by cclase ' +
         ' order by cclase ' ) then begin
         while not dm.q1.Eof do begin

            if dm.sqlselect( dm.q5, 'select * from tsclase ' +
               ' where cclase=' + g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q +
               ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
               ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
               dm.q1.Next;
               continue;
            end;

            if clase_fisico.indexof( dm.q1.fieldbyname( 'cclase' ).AsString ) = -1 then begin
               ts := tv.Items.AddChild( nodo, dm.q1.fieldbyname( 'cclase' ).AsString + ' - ' + '  ' );
               {Application.MessageBox( pchar( dm.xlng( 'Revisar el valor del campo objeto de la clase ' +
                  dm.q1.fieldbyname( 'cclase' ).AsString + ' en el catálogo de clases' ) ),
                  pchar( dm.xlng( 'Avisar al administrador ' ) ), MB_OK );
               }
            end
            else begin

               if g_ArbolDescri = '1' then begin
                  descri := dm.q1.fieldbyname( 'cclase' ).AsString + ' - ' +
                     clase_descripcion[ clase_fisico.indexof( dm.q1.fieldbyname( 'cclase' ).AsString ) ];
               end
               else
                  descri := clase_descripcion[ clase_fisico.indexof( dm.q1.fieldbyname( 'cclase' ).AsString ) ];

               ts := tv.Items.AddChild( nodo, descri );

               //ts := tv.Items.AddChild( nodo, dm.q1.fieldbyname( 'cclase' ).AsString + ' - ' +
                  //clase_descripcion[ clase_fisico.indexof( dm.q1.fieldbyname( 'cclase' ).AsString ) ] );
            end;
            new( reg );
            reg.pnombre := nombre;
            reg.pclase := 'SISTEMA';
            reg.hnombre := dm.q1.fieldbyname( 'cclase' ).AsString;
            reg.hclase := 'CLA';
            reg.registros := dm.q1.fieldbyname( 'total' ).AsInteger;
            reg.sistema := nombre;
            reg.hijo_falso := true;
            tv.Items.AddChild( ts, 'hijo falso' );
            ts.Data := reg;
            ts.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            ts.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            dm.q1.Next;
         end;
      end;
      exit;
   end;
   if clase = 'CLA' then begin
      if reg.registros < RangRegs then begin
         if dm.sqlselect( dm.q1, 'select * from tsprog ' +
            ' where cclase=' + g_q + nombre + g_q +
            ' and   sistema=' + g_q + sistema + g_q +
            ' order by cclase,cbib,cprog' ) then begin
            while not dm.q1.Eof do begin

               if dm.sqlselect( dm.q5, 'select * from tsclase ' +
                  ' where cclase=' + g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q +
                  ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
                  ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
                  dm.q1.Next;
                  continue;
               end;
               descri := trae_descripcion( sistema,
                  dm.q1.fieldbyname( 'cclase' ).AsString,
                  dm.q1.fieldbyname( 'cbib' ).AsString,
                  dm.q1.fieldbyname( 'cprog' ).AsString );
               nodx := tv.Items.AddChild( nodo, descri );
               new( reg );
               reg.ocprog := dm.q1.fieldbyname( 'cprog' ).AsString;
               reg.ocbib := dm.q1.fieldbyname( 'cbib' ).AsString;
               reg.occlase := dm.q1.fieldbyname( 'cclase' ).AsString;
               reg.orden := '0001';
               reg.pnombre := nombre;
               reg.pbiblioteca := sistema;
               reg.pclase := clase;
               reg.hnombre := dm.q1.fieldbyname( 'cprog' ).AsString;
               reg.hbiblioteca := dm.q1.fieldbyname( 'cbib' ).AsString;
               reg.hclase := dm.q1.fieldbyname( 'cclase' ).AsString;
               reg.sistema := sistema;
               reg.hijo_falso := true;
               tv.Items.AddChild( nodx, 'hijo falso' );
               nodx.Data := reg;
               nodx.ImageIndex := dm.lclases.IndexOf( reg.hclase );
               nodx.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
               dm.q1.Next;
            end;
         end;
         exit;
      end;
      if dm.sqlselect( dm.q1, // cuando son más de 100 registros
         //         'select cclase,substr(cprog,1,2) prefi, count(*) total from tsprog '+
         'select cclase,substr(cprog,1,' + inttostr( LongPrefi ) + ') prefi, count(*) total from tsprog ' +
         ' where cclase=' + g_q + nombre + g_q +
         ' and  sistema=' + g_q + sistema + g_q +
         ' group by cclase,substr(cprog,1,' + inttostr( LongPrefi ) + ') ' +
         ' order by cclase,substr(cprog,1,' + inttostr( LongPrefi ) + ') ' ) then begin
         while not dm.q1.Eof do begin

            if dm.sqlselect( dm.q5, 'select * from tsclase ' +
               ' where cclase=' + g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q +
               ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
               ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
               dm.q1.Next;
               continue;
            end;

            ts := tv.Items.AddChild( nodo, nombre + ' - ' + dm.q1.fieldbyname( 'prefi' ).AsString +
               ' (' + inttostr( dm.q1.fieldbyname( 'total' ).AsInteger ) + ')' );
            new( reg );
            reg.pnombre := dm.q1.fieldbyname( 'cclase' ).AsString;
            reg.pclase := 'CLA';
            reg.hnombre := dm.q1.fieldbyname( 'prefi' ).AsString;
            reg.hclase := 'SUBCLASE';
            reg.sistema := sistema;
            reg.registros := dm.q1.fieldbyname( 'total' ).AsInteger;
            reg.hijo_falso := true;
            tv.Items.AddChild( ts, 'hijo falso' );
            ts.Data := reg;
            ts.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            ts.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            dm.q1.Next;
         end;
      end;
      exit;
   end;
   if clase = 'SUBCLASE' then begin
      //    if reg.registros<100 then begin
      if reg.registros < RangRegs then begin
         if dm.sqlselect( dm.q1, 'select * from tsprog ' +
            ' where cclase=' + g_q + reg.pnombre + g_q +
            ' and   sistema=' + g_q + sistema + g_q +
            ' and   cprog like ' + g_q + reg.hnombre + '%' + g_q +
            ' order by cclase,cbib,cprog' ) then begin

            while not dm.q1.Eof do begin

               if dm.sqlselect( dm.q5, 'select * from tsclase ' +
                  ' where cclase=' + g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q +
                  ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
                  ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
                  dm.q1.Next;
                  continue;
               end;

               descri := trae_descripcion( sistema,
                  dm.q1.fieldbyname( 'cclase' ).AsString,
                  dm.q1.fieldbyname( 'cbib' ).AsString,
                  dm.q1.fieldbyname( 'cprog' ).AsString );

               nodx := tv.Items.AddChild( nodo, descri );
               new( reg );
               reg.ocprog := dm.q1.fieldbyname( 'cprog' ).AsString;
               reg.ocbib := dm.q1.fieldbyname( 'cbib' ).AsString;
               reg.occlase := dm.q1.fieldbyname( 'cclase' ).AsString;
               reg.orden := '0001';
               reg.pnombre := nombre;
               reg.pbiblioteca := bib;
               reg.pclase := clase;
               reg.hnombre := dm.q1.fieldbyname( 'cprog' ).AsString;
               reg.hbiblioteca := dm.q1.fieldbyname( 'cbib' ).AsString;
               reg.hclase := dm.q1.fieldbyname( 'cclase' ).AsString;
               reg.sistema := sistema;
               reg.hijo_falso := true;
               tv.Items.AddChild( nodx, 'hijo falso' );
               nodx.Data := reg;
               nodx.ImageIndex := dm.lclases.IndexOf( reg.hclase );
               nodx.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
               dm.q1.Next;
            end;
         end;
         exit;
      end;
      if dm.sqlselect( dm.q1, // cuando son más de 100 registros
         'select cclase,substr(cprog,1,' + inttostr( length( nombre ) + 1 ) + ') prefi, count(*) total from tsprog ' +
         ' where cclase=' + g_q + reg.pnombre + g_q +
         ' and  sistema=' + g_q + sistema + g_q +
         ' and   cprog like ' + g_q + reg.hnombre + '%' + g_q +
         ' group by cclase,substr(cprog,1,' + inttostr( length( nombre ) + 1 ) + ') ' +
         ' order by cclase,substr(cprog,1,' + inttostr( length( nombre ) + 1 ) + ') ' ) then begin
         while not dm.q1.Eof do begin

            if dm.sqlselect( dm.q5, 'select * from tsclase ' +
               ' where cclase=' + g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q +
               ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
               ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
               dm.q1.Next;
               continue;
            end;

            ts := tv.Items.AddChild( nodo, dm.q1.fieldbyname( 'cclase' ).AsString +
               ' - ' + dm.q1.fieldbyname( 'prefi' ).AsString +
               ' (' + inttostr( dm.q1.fieldbyname( 'total' ).AsInteger ) + ')' );
            new( reg );
            reg.pnombre := dm.q1.fieldbyname( 'cclase' ).AsString;
            reg.pclase := 'CLA';
            reg.hnombre := dm.q1.fieldbyname( 'prefi' ).AsString;
            reg.hclase := 'SUBCLASE';
            reg.sistema := sistema;
            reg.registros := dm.q1.fieldbyname( 'total' ).AsInteger;
            reg.hijo_falso := true;
            tv.Items.AddChild( ts, 'hijo falso' );
            ts.Data := reg;
            ts.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            ts.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            dm.q1.Next;
         end;
      end;
      exit;
   end;

   qq := TADOQuery.Create( self );
   qq.Connection := dm.q1.Connection;
   qq2 := TADOQuery.Create( self );
   qq2.Connection := dm.q1.Connection;
   if dm.sqlselect( qq, 'select * from tsrela ' +
      ' where pcprog=' + g_q + nombre + g_q +
      ' and pcbib=' + g_q + bib + g_q +
      ' and pcclase=' + g_q + clase + g_q +
      ' and sistema=' + g_q + sistema + g_q +
      ' order by orden,hcclase,hcbib,hcprog' ) then begin
      while not qq.Eof do begin
         if dm.sqlselect( dm.q5, 'select * from tsclase ' +
            ' where cclase=' + g_q + qq.fieldbyname( 'hcclase' ).AsString + g_q +
            ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
            ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
            qq.Next;
            continue;
         end;

         bexiste := false; // Checa que no se cicle el arbol
         if ( qq.fieldbyname( 'hcclase' ).AsString = clase ) and
            ( qq.fieldbyname( 'sistema' ).AsString = sistema ) and
            ( qq.fieldbyname( 'hcbib' ).AsString = bib ) and
            ( qq.fieldbyname( 'hcprog' ).AsString = nombre ) then
            bexiste := true
         else begin
            nody := nodo;
            while nody.Parent <> nil do begin
               nody := nody.Parent;
               reg := nody.Data;
               if ( reg.pnombre = nombre ) and
                  ( reg.pbiblioteca = bib ) and
                  ( reg.pclase = clase ) and
                  ( reg.sistema = sistema ) then begin
                  bexiste := true;
                  break;
               end;
            end;
         end;

         descri := trae_descripcion( sistema,
            qq.fieldbyname( 'hcclase' ).AsString,
            qq.fieldbyname( 'hcbib' ).AsString,
            qq.fieldbyname( 'hcprog' ).AsString );

         if qq.fieldbyname( 'coment' ).Asstring <> '' then
            descri := descri + ' [' + qq.fieldbyname( 'coment' ).Asstring + ']';
         nodx := tv.Items.AddChild( nodo, descri );
         reg := nodo.Data;
         reg.hijo_falso := false;
         new( reg );
         reg.ocprog := qq.fieldbyname( 'ocprog' ).AsString;
         reg.ocbib := qq.fieldbyname( 'ocbib' ).AsString;
         reg.occlase := qq.fieldbyname( 'occlase' ).AsString;
         reg.orden := qq.fieldbyname( 'orden' ).AsString;
         reg.pnombre := nombre;
         reg.pbiblioteca := bib;
         reg.pclase := clase;
         reg.hnombre := qq.fieldbyname( 'hcprog' ).AsString;
         reg.hbiblioteca := qq.fieldbyname( 'hcbib' ).AsString;
         reg.hclase := qq.fieldbyname( 'hcclase' ).AsString;
         reg.hijo_falso := false;
         reg.sistema := qq.fieldbyname( 'sistema' ).asstring;
         nodx.Data := reg;
         nodx.ImageIndex := dm.lclases.IndexOf( reg.hclase );
         nodx.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
         if bexiste then begin
            nodx.Text := nodx.Text + ' (CICLADO)';
         end
         else begin
            if qq.fieldbyname( 'coment' ).Asstring <> 'LIBRARY' then begin
               if veces > 0 then begin
                  //if qq.fieldbyname( 'coment' ).Asstring <> 'LIBRARY' then
                  expande( nodx, qq.fieldbyname( 'hcprog' ).AsString,
                     qq.fieldbyname( 'hcbib' ).AsString,
                     qq.fieldbyname( 'hcclase' ).AsString, veces - 1 );
               end
               else begin
                  if dm.sqlselect( qq2, 'select count(*) total from tsrela ' +
                     ' where pcprog=' + g_q + qq.fieldbyname( 'hcprog' ).AsString + g_q +
                     ' and pcbib=' + g_q + qq.fieldbyname( 'hcbib' ).AsString + g_q +
                     ' and pcclase=' + g_q + qq.fieldbyname( 'hcclase' ).AsString + g_q +
                     ' and sistema=' + g_q + qq.fieldbyname( 'sistema' ).AsString + g_q ) then begin
                     if ( qq2.FieldByName( 'total' ).AsInteger > 0 ) //and
                     //( qq2.FieldByName( 'total' ).AsInteger < 500 )
                     then begin
                        reg.hijo_falso := true;
                        nody := tv.Items.AddChild( nodx, 'hijo falso' );
                     end;
                  end;
               end;
            end;
         end;
         qq.Next;
      end;
   end;
   qq.free;
   qq2.Free;
end;

procedure Tfarbol.tvExpanding( Sender: TObject; Node: TTreeNode;
   var AllowExpansion: Boolean );
var
   reg: ^Tmyrec;
   Save_Cursor: TCursor;
begin
   reg := node.Data;
   if reg.hijo_falso then begin
      Save_Cursor := Screen.Cursor;
      Screen.Cursor := crHourGlass; { Show hourglass cursor }
      try
         node.DeleteChildren;
         expande( node, reg.hnombre, reg.hbiblioteca, reg.hclase, 1 );
      finally
         Screen.Cursor := Save_Cursor; { Always restore to normal }
      end;
   end;
end;

procedure Tfarbol.WtvExpanding( Node: TTreeNode );
var
   reg: ^Tmyrec;
   Save_Cursor: TCursor;
begin
   reg := node.Data;
   //   if reg.hijo_falso then begin
   Save_Cursor := Screen.Cursor;
   Screen.Cursor := crHourGlass; { Show hourglass cursor }
   try
      node.DeleteChildren;
      expande( node, reg.hnombre, reg.hbiblioteca, reg.hclase, 1 );
   finally
      Screen.Cursor := Save_Cursor; { Always restore to normal }
   end;
   //   end;
end;

procedure Tfarbol.Notepad1Click( Sender: TObject );
var
   nombre: string;
begin
   memo.Visible := true;
   nombre := tv.Selected.Text;
   bGlbQuitaCaracteres( Nombre );
   nombre := g_tmpdir + nombre + '_' + formatdatetime( 'YYYYMMDDHHnnSS', now ) + '.txt';
   memo.Lines.SaveToFile( nombre );
   ShellExecute( Handle, 'open', pchar( nombre ), nil, nil, SW_SHOW );
   g_borrar.Add( nombre );
end;

procedure Tfarbol.popmemoPopup( Sender: TObject );
begin
   if tv.Selected = nil then
      exit;
   inherited;
end;

procedure Tfarbol.tabla_crud( Sender: TObject );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := sLISTA_MATRIZ_CRUD + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( afmMatrizCrud );
      setlength( afmMatrizCrud, k + 1 );

      afmMatrizCrud[ k ] := TfmMatrizCrud.Create( Self );
      afmMatrizCrud[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         afmMatrizCrud[ k ].Width := g_Width;
         afmMatrizCrud[ k ].Height := g_Height;
      end;

      afmMatrizCrud[ k ].titulo := titulo;
      afmMatrizCrud[ k ].tipo := 'TAB';
      afmMatrizCrud[ k ].prepara2( reg.hnombre, reg.sistema );
      afmMatrizCrud[ k ].arma3( reg.hnombre, reg.sistema );
      afmMatrizCrud[ k ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.archivo_fisico( Sender: TObject );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := sMATRIZ_ARCHIVOS_FIS + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      k := length( ftsarchivos );
      setlength( ftsarchivos, k + 1 );
      ftsarchivos[ k ] := TfmMatrizAF.Create( farbol );
      ftsarchivos[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         ftsarchivos[ k ].Width := g_Width;
         ftsarchivos[ k ].Height := g_Height;
      end;
      ftsarchivos[ k ].titulo := titulo;
      ftsarchivos[ k ].tipo := reg.hclase; //'FIL';
      ftsarchivos[ k ].prepara( reg.hnombre, reg.sistema );
      ftsarchivos[ k ].arma( reg.hnombre, reg.sistema );
      ftsarchivos[ k ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.adabas_crud( Sender: TObject );
var
   reg: ^Tmyrec;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );

   try
      reg := nodo_actual.data;
      titulo := sLISTA_MATRIZ_CRUD + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( afmMatrizCrud );
      setlength( afmMatrizCrud, k + 1 );
      afmMatrizCrud[ k ] := TfmMatrizCrud.Create( self );
      afmMatrizCrud[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         afmMatrizCrud[ k ].Width := g_Width;
         afmMatrizCrud[ k ].Height := g_Height;
      end;

      afmMatrizCrud[ k ].titulo := titulo;

      if g_language = 'ENGLISH' then
         afmMatrizCrud[ k ].Caption := g_version_tit + '  -  CRUD Reference - ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre
      else
         afmMatrizCrud[ k ].Caption := g_version_tit + '  -  Matriz CRUD - ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      afmMatrizCrud[ k ].tipo := 'NVW';
      afmMatrizCrud[ k ].prepara2( reg.hnombre, reg.sistema );
      afmMatrizCrud[ k ].arma3( reg.hnombre, reg.sistema );

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.agrega_componente( nombre: string; bib: string; clase: string; nodo: Ttreenode = nil;
   pnombre: string = ''; pbib: string = ''; pclase: string = '' );
var
   nodx: Ttreenode;
   reg: ^Tmyrec;
   descri: string;
begin

   descri := trae_descripcion( '', clase, bib, nombre );

   //nodx := tv.Items.Addchild( nodo, clase + ' ' + bib + ' ' + nombre );
   nodx := tv.Items.Addchild( nodo, descri );

   new( reg );
   reg.ocprog := pnombre;
   reg.ocbib := pbib;
   reg.occlase := pclase;
   reg.orden := '0001';
   reg.pnombre := pnombre;
   reg.pbiblioteca := pbib;
   reg.pclase := pclase;
   reg.hnombre := nombre;
   reg.hbiblioteca := bib;
   reg.hclase := clase;
   reg.hijo_falso := false;
   nodx.Data := reg;
   nodx.ImageIndex := dm.lclases.IndexOf( reg.hclase );
   nodx.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
   expande( nodx, nombre, bib, clase, 2 );
end;

procedure Tfarbol.Diagramajcl( sender: Tobject );
var
   reg: ^Tmyrec;
   k: integer;
   Titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      Titulo := 'Diagrama de Flujo ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( ftsdiagjcl );
      setlength( ftsdiagjcl, k + 1 );
      ftsdiagjcl[ k ] := Tftsdiagjcl.create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsdiagjcl[ k ].Width := g_Width;
         ftsdiagjcl[ k ].Height := g_Height;
      end;
      //ftsdiagjcl[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsdiagjcl[ k ].Titulo := Titulo;
      ftsdiagjcl[ k ].Caption := Titulo;
      ftsdiagjcl[ k ].diagrama_jcl( reg.hnombre, reg.hbiblioteca, reg.hclase, reg.sistema );
      ftsdiagjcl[ k ].show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.tvDragOver( Sender, Source: TObject; X, Y: Integer;
   State: TDragState; var Accept: Boolean );
begin
   accept := ( ( source is Tlistview ) or ( source is Tdrawgrid ) );
end;

procedure Tfarbol.nuevo_proyecto( Sender: TObject );
var
   nodx: Ttreenode;
   reg: ^Tmyrec;
   proyecto: string;
begin
   proyecto := inputbox( 'Capture', 'Nombre del Proyecto', '' );
   if trim( proyecto ) = '' then
      exit;
   proyecto := uppercase( proyecto );
   if dm.sqlselect( dm.q1, 'select * from tsuserpro ' +
      ' where cuser=' + g_q + g_usuario + g_q +
      ' and   cproyecto=' + g_q + proyecto + g_q ) then begin
      Application.MessageBox( pchar( dm.xlng( 'AVISO... El proyecto ya existe' ) ),
         pchar( dm.xlng( 'Nuevo proyecto' ) ), MB_OK );
      exit;
   end;
   nodx := tv.Items.AddChild( nodo_actual, proyecto ); //-----> DESCRIPCION
   new( reg );
   reg.pnombre := g_usuario;
   reg.pbiblioteca := 'USER';
   reg.pclase := '';
   reg.hnombre := proyecto;
   reg.hbiblioteca := 'PROYECTO';
   reg.hclase := 'USERPRO';
   reg.hijo_falso := false;
   nodx.Data := reg;
   nodx.ImageIndex := dm.lclases.IndexOf( reg.hclase );

   nodx.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
   dm.sqlinsert( 'insert into tsuserpro (cuser,cproyecto,cprog,cbib,cclase) values(' +
      g_q + g_usuario + g_q + ',' +
      g_q + proyecto + g_q + ',' +
      g_q + '.' + g_q + ',' +
      g_q + '.' + g_q + ',' +
      g_q + '.' + g_q + ')' );
   if ftsconscom <> nil then begin
      //      dm.feed_combo(ftsconscom.Cmbproyecto,'select distinct cproyecto '+
      //         ' from tsuserpro'+
      //         ' where cuser='+g_q+g_usuario+g_q);
      ftsconscom.FormActivate( sender );
   end;
end;

function Tfarbol.alta_a_proyecto( nombre: string; bib: string; clase: string; proyecto: string ): boolean;
begin
   if dm.sqlselect( dm.q1, 'select * from tsuserpro ' +
      ' where cuser=' + g_q + g_usuario + g_q +
      ' and cproyecto=' + g_q + proyecto + g_q +
      ' and cprog=' + g_q + nombre + g_q +
      ' and cbib=' + g_q + bib + g_q +
      ' and cclase=' + g_q + clase + g_q ) then begin
      Application.MessageBox( pchar( dm.xlng( 'Componente ' + nombre + ' ya está dado de alta en el proyecto' ) ),
         pchar( dm.xlng( 'Alta proyecto' ) ), MB_OK );
      alta_a_proyecto := false;
      exit;
   end;
   dm.sqlinsert( 'insert into tsuserpro (cuser,cproyecto,cprog,cbib,cclase) values(' +
      g_q + g_usuario + g_q + ',' +
      g_q + proyecto + g_q + ',' +
      g_q + nombre + g_q + ',' +
      g_q + bib + g_q + ',' +
      g_q + clase + g_q + ')' );
   alta_a_proyecto := true;
end;

procedure Tfarbol.borrar_item( Sender: TObject );
var
   reg: ^Tmyrec;
   //k: integer;
begin
   screen.Cursor := crsqlwait;
   reg := nodo_actual.data;
   if reg.pclase = 'USERPRO' then begin // elimina componente de proyecto
      dm.sqldelete( 'delete tsuserpro ' +
         ' where cuser=' + g_q + g_usuario + g_q +
         ' and cproyecto=' + g_q + reg.pnombre + g_q +
         ' and cprog=' + g_q + reg.hnombre + g_q +
         ' and cbib=' + g_q + reg.hbiblioteca + g_q +
         ' and cclase=' + g_q + reg.hclase + g_q );
   end;
   if reg.hclase = 'USERPRO' then begin // elimina proyecto
      dm.sqldelete( 'delete tsuserpro ' +
         ' where cuser=' + g_q + g_usuario + g_q +
         ' and cproyecto=' + g_q + reg.hnombre + g_q );
      if ftsconscom <> nil then begin
         ftsconscom.FormActivate( sender );
      end;
   end;
   memo.Lines.Clear;
   nodo_actual.Free;
   screen.Cursor := crdefault;
end;

procedure Tfarbol.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

   gral.PopGral.Items.Clear;
end;

procedure Tfarbol.mnuConsultaClick( Sender: TObject );
var
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   try
      Titulo := sLISTA_CONS_COMPONE + ' - Base de Conocimiento';

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      //      ftsconscom := Tftsconscom.Create( self ); //JJJfarbol );
      ftsconscom := TfmConsCom.Create( self );

      //ftsconscom.FormStyle := fsNormal;
      ftsconscom.Align := alNone; // JJJJalRight;

      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsconscom.Width := g_Width;
         ftsconscom.Height := g_Height;
      end;

      //ftsconscom.Parent := farbol;
      //ftsconscom.titulo := Titulo;
      ftsconscom.caption := Titulo;
      //ftsconscom.BorderIcons := BorderIcons - [biMinimize] - [biMaximize];
      ftsconscom.FormStyle := fsMDIChild; //JJJ
      ftsconscom.Panel1.Visible := true;
      ftsconscom.bproyecto.Visible := true;
      ftsconscom.cmbproyecto.Visible := true;
      ftsconscom.lblproyecto.Visible := true;
      ftsconscom.mnuAgregarParaConsulta.Visible := ivAlways;
      dm.feed_combo( ftsconscom.Cmbproyecto, 'select distinct cproyecto ' +
         ' from tsuserpro' +
         ' where cuser=' + g_q + g_usuario + g_q );
      ftsconscom.buscarText;
      ftsconscom.Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      screen.Cursor := crdefault;
   end;
end;

procedure Tfarbol.FormDestroy( Sender: TObject );
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then
      gral.PubExpandeMenuVentanas( False );

end;

procedure Tfarbol.FormDeactivate( Sender: TObject );
begin

   gral.PopGral.Items.Clear;

end;
{
function Tfarbol.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
    CallHelp := False;
    try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           [Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;
}

procedure Tfarbol.mnuAyudaClick( Sender: TObject );
var
   CallHelp: Boolean;
begin
   CallHelp := False;
   try
      PR_BARRA;
      HtmlHelp( Application.Handle,
         PChar( Format( '%s::/T%5.5d.htm',
         //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
         [ Application.HelpFile, iHelpContext ] ) ), HH_DISPLAY_TOPIC, 0 );
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;
end;

procedure Tfarbol.tvClick( Sender: TObject );
begin
   //iHelpContext:=IDH_TOPIC_T01100;
end;

procedure Tfarbol.FormActivate( Sender: TObject );
begin

   iHelpContext := IDH_TOPIC_T01100
end;

procedure Tfarbol.tvMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
var
   hoverNode: TTreeNode;
   hitTest: THitTests;
   reg: ^Tmyrec;
begin
   hitTest := tv.GetHitTestInfoAt( X, Y );
   if not ( htOnItem in hitTest ) then
      exit;
   try
      hoverNode := tv.GetNodeAt( X, Y );
      reg := hoverNode.Data;
      if ( lastHintNode <> hoverNode ) then begin
         Application.CancelHint;
         if ( hitTest <= [ htOnItem, htOnIcon, htOnLabel, htOnStateIcon ] ) then begin
            lastHintNode := hoverNode;
            tv.Hint := reg.sistema + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
         end;
      end;
   except
   end;
end;

procedure Tfarbol.DiagramaUMLPaquetes;
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_PAQUETES + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmUMLPaquetes );
      SetLength( fmUMLPaquetes, iArreglo + 1 );
      fmUMLPaquetes[ iArreglo ] := TfmUMLPaquetes.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmUMLPaquetes[ iArreglo ].Width := g_Width;
         fmUMLPaquetes[ iArreglo ].Height := g_Height;
      end;

      fmUMLPaquetes[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmUMLPaquetes[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.DiagramaUMLClases;
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_CLASES + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmUMLClases );
      SetLength( fmUMLClases, iArreglo + 1 );
      fmUMLClases[ iArreglo ] := TfmUMLClases.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmUMLClases[ iArreglo ].Width := g_Width;
         fmUMLClases[ iArreglo ].Height := g_Height;
      end;

      fmUMLClases[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmUMLClases[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.DiagramaScheduler; //Diagrama Scheduler
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_SCHEDULER + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmScheduler );
      SetLength( fmScheduler, iArreglo + 1 );
      fmScheduler[ iArreglo ] := TfmScheduler.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmScheduler[ iArreglo ].Width := g_Width;
         fmScheduler[ iArreglo ].Height := g_Height;
      end;

      fmScheduler[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmScheduler[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.DiagramaAnalisisImpacto;
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_AIMPACTO + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmAnalisisImpacto );
      SetLength( fmAnalisisImpacto, iArreglo + 1 );
      fmAnalisisImpacto[ iArreglo ] := TfmAnalisisImpacto.Create( Self );
      fmAnalisisImpacto[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmAnalisisImpacto[ iArreglo ].Width := g_Width;
         fmAnalisisImpacto[ iArreglo ].Height := g_Height;
      end;

      fmAnalisisImpacto[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmAnalisisImpacto[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.DiagramaProcesos;
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_PROCESOS + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmProcesos );
      SetLength( fmProcesos, iArreglo + 1 );
      fmProcesos[ iArreglo ] := TfmProcesos.Create( Self );
      fmProcesos[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmProcesos[ iArreglo ].Width := g_Width;
         fmProcesos[ iArreglo ].Height := g_Height;
      end;

      fmProcesos[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmProcesos[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;
{
function Tfarbol.trae_descripcion(sistema:string;clase:string;biblioteca:string;nombre:string):string;
var
  lExt :string;
begin
  lExt := '';
  if g_ArbolDescri = '1' then  begin   //  arma descri con  CLASE-BIBLIOTECA-PROGRAMA
     trae_descripcion := clase + ' ' + biblioteca + ' ' + nombre;
  end else begin
     if g_ArbolDescri = '2' then  begin  // arma descri  con PROGRAMA-EXTENSION
        if dm.sqlselect( dm.q2, 'select * from parametro ' + ' where clave=' + g_q + 'mask_' + sistema + '_' + clase
           + '_' + biblioteca + g_q ) then begin
              if dm.q2.fieldbyname( 'dato' ).AsString <> '*.*' then
                 lExt := stringreplace( dm.q2.fieldbyname( 'dato' ).AsString , '*', '', [ rfreplaceall ] );
        end;
     end;
        trae_descripcion :=  extractfilename( stringreplace( nombre, '.', '\', [ rfreplaceall ]))+trim(lExt);;  // arma descri  con PROGRAMA
  end;
end;
}

function Tfarbol.trae_descripcion( sistema: string; clase: string; biblioteca: string; nombre: string ): string;
var
   clave: string;
   dat: string;
   cont: integer;
   hcprog, hcprog_basename, hcprog_noext, hcprog_basename_noext, hcprog_ext: string; //alk
   procedure llena_variables( ruta: string ); //alk
   begin
      hcprog := ruta;
      hcprog_noext := copy( hcprog, 1, ( length( hcprog ) -
         length( extractfileext( hcprog ) ) ) );
      hcprog_ext := copy( extractfileext( hcprog ), 2, 1000 );
      hcprog_basename := extractfilename( stringreplace( hcprog, '/', '\', [ rfreplaceall ] ) );
      hcprog_basename_noext := copy( hcprog_basename, 1, ( length( hcprog_basename ) -
         length( extractfileext( hcprog_basename ) ) ) );
   end;
begin
   clave := concat( 'ARBOLDESCRIPCION', '_', clase );

   for cont := 1 to length( guarda ) - 1 do begin
      if clave = guarda[ cont ].clave then begin
         dat := guarda[ cont ].dato;

         dat := stringreplace( dat, '$HCCLASE$', clase, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCBIB$', biblioteca, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCPROG$', nombre, [ rfReplaceAll ] );

         llena_variables( nombre );
         dat := stringreplace( dat, '$HCPROG_EXT$', hcprog_ext, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCPROG_NOEXT$', hcprog_noext, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCPROG_BASENAME$', hcprog_basename, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCPROG_BASENAME_NOEXT$', hcprog_basename_noext, [ rfReplaceAll ] );

         llena_variables( biblioteca );
         dat := stringreplace( dat, '$HCBIB_EXT$', hcprog_ext, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCBIB_NOEXT$', hcprog_noext, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCBIB_BASENAME$', hcprog_basename, [ rfReplaceAll ] );
         dat := stringreplace( dat, '$HCBIB_BASENAME_NOEXT$', hcprog_basename_noext, [ rfReplaceAll ] );

         Result := dat;
         exit;
      end;
   end;
   dat := guarda[ 0 ].dato;
   dat := stringreplace( dat, '$HCCLASE$', clase, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCBIB$', biblioteca, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCPROG$', nombre, [ rfReplaceAll ] );

   llena_variables( nombre );
   dat := stringreplace( dat, '$HCPROG_EXT$', hcprog_ext, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCPROG_NOEXT$', hcprog_noext, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCPROG_BASENAME$', hcprog_basename, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCPROG_BASENAME_NOEXT$', hcprog_basename_noext, [ rfReplaceAll ] );

   llena_variables( biblioteca );
   dat := stringreplace( dat, '$HCBIB_EXT$', hcprog_ext, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCBIB_NOEXT$', hcprog_noext, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCBIB_BASENAME$', hcprog_basename, [ rfReplaceAll ] );
   dat := stringreplace( dat, '$HCBIB_BASENAME_NOEXT$', hcprog_basename_noext, [ rfReplaceAll ] );

   Result := dat;
end;

procedure Tfarbol.leer( ); //ALK                                                                                                                                l
var
   c: integer;
begin
   c := 0;

   if dm.sqlselect( dm.q2, 'select* from parametro' +
      ' where clave like ' + g_q + 'ARBOLDESCRIPCION%' + g_q +
      ' and secuencia=0 ' +
      ' order by clave' ) then begin
      while not dm.q2.Eof do begin
         // if dm.q2.fieldbyname( 'dato' ).AsString <> '*.*' then
         setlength( guarda, ( length( guarda ) + 1 ) );
         guarda[ c ].clave := dm.q2.fieldbyname( 'clave' ).AsString;
         guarda[ c ].dato := dm.q2.fieldbyname( 'dato' ).AsString;
         c := c + 1;
         dm.q2.Next;
         //end;
      end;
   end;
end;

procedure Tfarbol.DiagramaBloques;
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.Data;
      sTitulo := sDIGRA_BLOQUES + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmBloques );
      SetLength( fmBloques, iArreglo + 1 );
      fmBloques[ iArreglo ] := TfmBloques.Create( Self );
      fmBloques[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmBloques[ iArreglo ].Width := g_Width;
         fmBloques[ iArreglo ].Height := g_Height;
      end;

      fmBloques[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmBloques[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.DiagramaSistema;
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.Data;
      //sTitulo := sDIGRA_SISTEMA + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;
      sTitulo := sDIGRA_SISTEMA + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmDigraSistema );
      SetLength( fmDigraSistema, iArreglo + 1 );
      fmDigraSistema[ iArreglo ] := TfmDigraSistema.Create( Self );
      fmDigraSistema[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmDigraSistema[ iArreglo ].Width := g_Width;
         fmDigraSistema[ iArreglo ].Height := g_Height;
      end;

      fmDigraSistema[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, sTitulo );
      fmDigraSistema[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

end.

