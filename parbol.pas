unit parbol;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls,
   ImgList, ADODB, ExtCtrls, Menus, StdCtrls, ExtDlgs, shellapi, svsdelphi, InvokeRegistry, Rio,
   SOAPHTTPClient, mgflcob, mgflrpg, ufmMatrizAF, ptsmapanat, Grids, ptsproperty,
   ptsdghtml, ptsversionado, ptsbms, ptsbfr, jpeg, dxBar, cxControls, cxSplitter, ptsattribute,
   pstviewhtml, ptsdiagjcl, ptsscrsec, uConstantes, ufmUMLPaquetes, ufmUMLClases, ufmScheduler,
   ufmAnalisisImpacto, ufmListaCompo, ufmListaDependencias, UfmMatrizCrud, UfmConsCom, UfmRefCruz,
   ufmProcesos, ufmDocumentacion, ufmBloques, ufmListaDrill, ufmMatrizArchLog, ufmDigraSistema,ptscomun,
   alkScheduler,alkDetTab,alkConfDiag,ptsestatica;

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
      lineainicio:integer;
      lineafinal:integer;
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
    popupArbol: TPopupMenu;
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
      //procedure DiagramaCOBOL( Sender: Tobject );
      procedure DiagramaVisustin( Sender: Tobject );     //alk funcion para diagramas visustin
      procedure DiagramaFlujoWFL( Sender: Tobject );
      procedure DiagramaFlujoALG( Sender: Tobject );
      procedure DiagramaFlujoMACROS( Sender: Tobject );
      procedure DiagramaFlujoCBL( Sender: Tobject );
      procedure DiagramaFlujoOBY( Sender: Tobject );
      procedure DiagramaFlujoDCL( Sender: Tobject );
      procedure DiagramaFlujoBSC( Sender: Tobject );
      procedure DiagramaFlujoOSQ( Sender: Tobject );
      //procedure DiagramaJerarquicoBSC( Sender: Tobject );
      procedure DiagramaJerarquicoOSQ( Sender: Tobject );
      procedure DiagramaJerarquicoCBL( Sender: Tobject );
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
      procedure detalle_tabla( Sender: TObject );   // ALK para el detalle de las tablas

      procedure WtvExpanding( Node: TTreeNode );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure mnuConsultaClick( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure FormDeactivate( Sender: TObject );
      procedure mnuAyudaClick( Sender: TObject );
//      procedure tvClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure tvMouseMove( Sender: TObject; Shift: TShiftState; X,
         Y: Integer );
      procedure memo_fuente(nodo : TTreeNode);     // alk para mostrar el fuente en el memo

   private
      { Private declarations }
      lastHintNode: TTreeNode;
      nodo_actual, nodo_antes: Ttreenode;
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
      ftsestatica: array of Tftsestatica; // validaciones estaticas

      guarda: array of TGuarda;
      clase_analizable: Tstringlist;
      clase_fisico: Tstringlist;
      clase_todas: Tstringlist;
      clase_VB: Tstringlist;
      clase_descripcion: Tstringlist;
      clase_descripcion_todas: Tstringlist;
      sistema_datos: Tstringlist;
      LongPrefi, RangRegs: integer;
      bc,ec,ignore:string;   // variables para mgflcob  RGM
      numero_registros:integer;

      procedure xFormCreate( Sender: TObject );
      procedure nivel_clases( padre: Ttreenode; qq: TADOquery );
      procedure subsistemas( padre: Ttreenode; oficina: string; sistema: string );
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

      procedure codigoMuerto(Sender: Tobject);  // funcion que manda llamar a la general para el codigo muerto
      procedure validacionesEstaticas(Sender: Tobject);  // funcion para mandar a ejecutar la validacion estatica para CBL
   public
      { Public declarations }
      ftsconscom: TfmConsCom;
      b_conscom: boolean;
      nodo_proyecto: Ttreenode;
      //memo_componente: string; //validar funcionalidad memo_componente
      x1, y1: Integer;
      sGblSis: String;
      //g_sistema: String;
      procedure agrega_componente( nombre: string; bib: string; clase: string; nodo: Ttreenode = nil;
         pnombre: string = ''; pbib: string = ''; pclase: string = '' );
      procedure expande( nodo: Ttreenode; nombre: string; bib: string;
         clase: string; veces: integer );
      function alta_a_proyecto( nombre: string; bib: string; clase: string; proyecto: string ): boolean;
//      procedure GenerarDiagrama( lsNomFte: String; lsArchFte: String );
//      procedure GenerarDiagrama( lsNomFte: String; lsArchFte: String; clase: String);
//      procedure GenerarDiagramaNvo( lsNomFte: String; lsArchFte: String; parClase, parTipoDiagrama: String );
      procedure GenerarDiagramaNvo( lsNomFte, lsArchFte, parClase, parTipoDiagrama: String; tipo : integer; sistema,bib : String); //alk
      procedure leer( );
      procedure borra_elemento_a(nombre:string ; producto : integer); //alk para borrar del arreglo

      function tiene_hijo(nombre: string; bib: string; clase: string; sistema: String):boolean;   // alk para evitar signo mas en arbol cuando no tiene hijos
   end;
var
   farbol: Tfarbol;

procedure PR_ARBOL;

implementation
uses
   ptsdm, psvsfmb, ptspanel, ptsgral, HtmlHlp, HTML_HELP, pbarra, ptsmain,
   uDiagramaRutinas, gifimage;
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
   icont,ierror: integer;  //alk out of system
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

      // ------ ALK para controlar el error out of system resources ------
      try
         fmDocumentacion[ iArreglo ] := TfmDocumentacion.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmDocumentacion[ iArreglo ] := TfmDocumentacion.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------


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
   icont,ierror: integer;  //alk out of system
   numero_registros:integer;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;

      sTitulo := sLISTA_DRILLDOWN + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      if not dm.es_SCRATCH(Nodo.sistema, Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      iArreglo := Length( fmListaDrill );
      SetLength( fmListaDrill, iArreglo + 1 );
      {
      numero_registros:=dm.cuenta_registros('select count(*) '+
         ' FROM TSRELA t '+
         //' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.pCPROG = '+g_q+Nodo.hnombre+g_q+
         '        AND T.pCBIB = '+g_q+Nodo.hbiblioteca+g_q+
         '        AND T.pCCLASE = '+g_q+Nodo.hclase+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.hCPROG = T.pCPROG AND '+
         ' PRIOR T.hCBIB = T.pCBIB AND '+
         ' PRIOR T.hCCLASE = T.pCCLASE');
      if numero_registros>5000 then begin
         showmessage('Involucra más de 5000 registros('+inttostr(numero_registros)+')');
         exit;
      end;
      }
      // ------ ALK para controlar el error out of system resources ------
      try
         fmListaDrill[ iArreglo ] := TfmListaDrill.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmListaDrill[ iArreglo ] := TfmListaDrill.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------


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
   icont,ierror: integer;  //alk out of system
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
      {
      //numero_registros:=dm.cuenta_registros('select count(*) '+
      numero_registros:=dm.cuenta_registros('select hcprog '+
         ' FROM TSRELA t '+
         //' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.hCPROG = '+g_q+Nodo.hnombre+g_q+
         '        AND T.hCBIB = '+g_q+Nodo.hbiblioteca+g_q+
         '        AND T.hCCLASE = '+g_q+Nodo.hclase+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.pCPROG = T.hCPROG AND '+
         ' PRIOR T.pCBIB = T.hCBIB AND '+
         ' PRIOR T.pCCLASE = T.hCCLASE');
      if numero_registros>5000 then begin
         showmessage('Involucra más de 5000 registros('+inttostr(numero_registros)+')');
         exit;
      end;
      }
      // ------ ALK para controlar el error out of system resources ------
      try
         fmListaDrill[ iArreglo ] := TfmListaDrill.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmListaDrill[ iArreglo ] := TfmListaDrill.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------


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

procedure Tfarbol.validacionesEstaticas(Sender: Tobject);
var
   Nodo: ^Tmyrec;
   iArreglo: Integer;
   sTitulo: string;
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;

      sTitulo := sVAL_ESTATICAS + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( ftsestatica );
      SetLength( ftsestatica, iArreglo + 1 );

      // ------ ALK para controlar el error out of system resources ------
      try
         ftsestatica[ iArreglo ] := Tftsestatica.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsestatica[ iArreglo ] := Tftsestatica.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      ftsestatica[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         ftsestatica[ iArreglo ].Width := g_Width;
         ftsestatica[ iArreglo ].Height := g_Height;
      end;

      ftsestatica[ iArreglo ].Caption:= sTitulo;
      ftsestatica[ iArreglo ].establece_datos( Nodo.hnombre, Nodo.hclase, Nodo.hbiblioteca, Nodo.sistema );
      ftsestatica[ iArreglo ].ejecuta_menu( Nodo.hnombre, Nodo.hclase, Nodo.hbiblioteca, Nodo.sistema );
      ftsestatica[ iArreglo ].Show;

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
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;

      sTitulo := sMATRIZ_ARCHIVO_LOG + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      {if not dm.es_SCRATCH(Nodo.sistema, Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end; }

      iArreglo := Length( fmMatrizArchLog );
      SetLength( fmMatrizArchLog, iArreglo + 1 );

      //fmMatrizArchLog[ iArreglo ] := TfmMatrizArchLog.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmMatrizArchLog[ iArreglo ] := TfmMatrizArchLog.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmMatrizArchLog[ iArreglo ] := TfmMatrizArchLog.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
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
   icont,ierror: integer;  //alk out of system
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
      
      // ------ ALK para controlar el error out of system resources ------
      try
         ftsversionado[ k ] := Tftsversionado.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsversionado[ k ] := Tftsversionado.create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      
      
      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsversionado[ k ].Width := g_Width;
         ftsversionado[ k ].Height := g_Height;
      end;
      ftsversionado[ k ].titulo := titulo;

      if not ftsversionado[ k ].valida( reg.hnombre, reg.hbiblioteca, reg.hclase, reg.sistema ) then begin
         ftsversionado[ k ].Close;
         exit;
      end;

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
   icont,ierror: integer;  //alk out of system
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
      
      // ------ ALK para controlar el error out of system resources ------
      try
         ftsbms[ k ] := Tftsbms.create( self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsbms[ k ] := Tftsbms.create( self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      
      {if gral.bPubVentanaMaximizada = FALSE then begin
         ftsbms[ k ].Width := g_Width;
         ftsbms[ k ].Height := g_Height;
      end;  }
      //ftsbms[ k ].Constraints.MaxWidth := g_MaxWidth;
      ftsbms[ k ].titulo := titulo;
      ftsbms[ k ].arma( panta );
      if gral.bPubVentanaMaximizada then begin     //cuando esta maximizada
         ftsbms[ k ].Width := g_Width*2;
         ftsbms[ k ].Height := g_Height*2;
      end
      else begin
         ftsbms[ k ].Width := g_Width;
         ftsbms[ k ].Height := g_Height;
      end;
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
   g_arbol_activo:= 1;
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
            //' and estadoactual = ' + g_q + 'ACTIVO' + g_q +
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
      //' where estadoactual = ' + g_q + 'ACTIVO' + g_q +
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
   tt := Tmenuitem.Create( popupArbol );
   tt.Caption := titulo;
   popupArbol.Items.Add( tt );
   k := popupArbol.Items.Count - 1;
   popupArbol.Items[ k ].Tag := nodo_actual.AbsoluteIndex;
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
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'Mapa Natural ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      k := length( ftsmapanat );
      setlength( ftsmapanat, k + 1 );

      //ftsmapanat[ k ] := Tftsmapanat.Create( self );
      // ------ ALK para controlar el error out of system resources ------
      try
         ftsmapanat[ k ] := Tftsmapanat.Create( self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsmapanat[ k ] := Tftsmapanat.Create( self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

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
   icont,ierror: integer;  //alk out of system
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

      if not dm.es_SCRATCH(Nodo.sistema, Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      iArreglo := Length( fmListaCompo );
      setlength( fmListaCompo, iArreglo + 1 );

      //fmListaCompo[ iArreglo ] := TfmListaCompo.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmListaCompo[ iArreglo ] := TfmListaCompo.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmListaCompo[ iArreglo ] := TfmListaCompo.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      fmListaCompo[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmListaCompo[ iArreglo ].Width := g_Width;
         fmListaCompo[ iArreglo ].Height := g_Height;
      end;

      fmListaCompo[ iArreglo ].Caption := sTitulo;
      fmListaCompo[ iArreglo ].sin_controles(1);  // para que sepa que debe ocultar los paneles de control
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
   lista_dep : TStringList;    //alk
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   lista_dep:=TStringList.Create;   //alk
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

      if not dm.es_SCRATCH(reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      k2 := length( aPriListaDependencias );
      setlength( aPriListaDependencias, k2 + 1 );

      //aPriListaDependencias[ k2 ] := TfmListaDependencias.create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         aPriListaDependencias[ k2 ] := TfmListaDependencias.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     aPriListaDependencias[ k2 ] := TfmListaDependencias.create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      aPriListaDependencias[ k2 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         aPriListaDependencias[ k2 ].Width := g_Width;
         aPriListaDependencias[ k2 ].Height := g_Height;
      end;

      aPriListaDependencias[ k2 ].titulo := titulo;
      aPriListaDependencias[ k2 ].caption := titulo;

      //  modificacion para etp alk
      lista_dep.Add(reg.hclase);       //clase
      lista_dep.Add(reg.hbiblioteca);         //biblioteca
      lista_dep.Add(reg.hnombre);        //programa/mascara
      lista_dep.Add(reg.sistema);     //sistema
      aPriListaDependencias[ k2 ].llenacombos(lista_dep);
      //
      g_producto := 'MENÚ CONTEXTUAL-LISTA DEPENDENCIAS DE COMPONENTES';

      if aPriListaDependencias[ k2 ].error <> '' then begin     // para error en consulta
         aPriListaDependencias[ k2 ].Destroy;
         exit;
      end;

      aPriListaDependencias[ k2 ].sin_controles(1);  // para que sepa que debe ocultar los paneles de control
      try
         aPriListaDependencias[ k2 ].arma3( reg.hclase,reg.hbiblioteca, reg.hnombre, reg.sistema );
      except
         on E: exception do begin
            Application.MessageBox( pchar( 'No se pudo generar el producto ' + E.Message ),
                                    pchar( 'AVISO' ), MB_OK );
         end;
      end;

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
   icont,ierror: integer;  //alk out of system
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

      // ------ ALK para controlar el error out of system resources ------
      try
         ftsproperty[ k ] := Tftsproperty.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsproperty[ k ] := Tftsproperty.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      //ftsproperty[ k ].WindowState := wsMaximized;
      ftsproperty[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsproperty[ k ].Width := g_Width;
         ftsproperty[ k ].Height := g_Height;
      end;

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
   icont,ierror: integer;  //alk out of system
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

      // ------ ALK para controlar el error out of system resources ------
      try
         ftsattribute[ k ] := Tftsattribute.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsattribute[ k ] := Tftsattribute.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------


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
   extension: string;
   mux: string;
   gif:Tgifimage;
   stream:TFilestream;
begin
   reg := nodo_actual.data;
   extension := reg.hclase;
   mux := g_tmpdir + '\' + reg.hnombre + '.' + extension;
   //dm.bfile2file( reg.hnombre, reg.hbiblioteca, mux );
   dm.bfile2file( reg.hnombre, reg.hbiblioteca, reg.hclase, mux );
   x1 := 0;
   if fileexists( mux ) then begin
      try
         //image2.Picture.LoadFromFile( mux );
         if reg.hclase='GIF' then begin
            gif:=Tgifimage.create;
            stream:=Tfilestream.Create(mux,fmOpenRead);
            gif.LoadFromStream(stream);
            stream.Free;
            image2.Picture.Assign(gif);
            gif.free;
         end
         else begin
            image2.Picture.LoadFromFile( mux );
         end;
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
   icont,ierror: integer;  //alk out of system
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

      // ------ ALK para controlar el error out of system resources ------
      try
         ftsviewhtml[ k ] := Tftsviewhtml.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsviewhtml[ k ] := Tftsviewhtml.create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------


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
   icont,ierror: integer;  //alk out of system
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

      //ftsscrsec[ k ] := Tftsscrsec.create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         ftsproperty[ k ] := Tftsproperty.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsproperty[ k ] := Tftsproperty.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

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


//procedure Tfarbol.DiagramaCOBOL;
procedure Tfarbol.DiagramaVisustin;
var
   Nodo: ^Tmyrec;
   lsNomCompo, lsArchFte: String;
   bCreaDgrFlujo: boolean;
   sDirClase, sRutaMisDocumentos : String;
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
      //generar el fuente
      lsArchFte := g_tmpdir + '\' + lsNomCompo + '.txt';
      Memo.Lines.SaveToFile( lsArchFte );
      //Obtener la carpeta de destino: mis documentos       //ALK
      sRutaMisDocumentos := GlbObtenerRutaMisDocumentos;
      sDirClase := sRutaMisDocumentos + '\Informes\';

//      GenerarDiagrama( lsNomCompo, lsArchFte );
//      GenerarDiagrama( lsNomCompo, lsArchFte , nodo.occlase);
      bCreaDgrFlujo := GLbCreaDiagramaFlujo(                             //generar el diagrama (uDiagramaRutinas)
                              nodo.hclase, nodo.hbiblioteca, nodo.hnombre,
                              lsArchFte,    //fuente
                              sDirClase,          //carpeta de salida
                              sDirClase + lsNomCompo + '.pdf' );      //salida pdf

      if (bCreaDgrFlujo) or (FileExists( sDirClase + lsNomCompo + '.pdf' )) then    //si lo creo correctamente o si ya esta el pdf, abrirlo
         ShellExecute( 0, 'open', pchar( lsNomCompo+'.pdf' ), nil, PChar( sDirClase ), SW_SHOW );
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'WFL', 'FLUJO' , 1, nodo.sistema, nodo.hbiblioteca);    //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'WFL', 'JERARQUICO' , 1 , nodo.sistema, nodo.hbiblioteca);  //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaJerarquicoOSQ;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'OSQ', 'JERARQUICO' , 1 , nodo.sistema, nodo.hbiblioteca);  //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoBSC;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'BSC', 'FLUJO' , 1, nodo.sistema, nodo.hbiblioteca);    //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

{procedure Tfarbol.DiagramaJerarquicoBSC;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'BSC', 'JERARQUICO' , 1 , nodo.sistema, nodo.hbiblioteca);  //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;}


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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'ALG', 'FLUJO' , 1 , nodo.sistema, nodo.hbiblioteca);  //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoOSQ;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'OSQ', 'FLUJO' , 1 , nodo.sistema, nodo.hbiblioteca);  //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoCBL;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'CBL', 'FLUJO' , 1 , nodo.sistema, nodo.hbiblioteca);  //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoMACROS;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte,  nodo.hclase , 'FLUJO' , 1 , nodo.sistema, nodo.hbiblioteca);   //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoOBY;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'OBY' , 'FLUJO' , 1 , nodo.sistema, nodo.hbiblioteca);   //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaFlujoDCL;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'DCL', 'FLUJO' , 1, nodo.sistema, nodo.hbiblioteca);    //tipo 1 - arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'ALG', 'JERARQUICO' , 1 , nodo.sistema, nodo.hbiblioteca);//tipo 1 arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tfarbol.DiagramaJerarquicoCBL;
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
      GenerarDiagramaNvo( lsNomCompo, lsArchFte, 'CBL', 'JERARQUICO' , 1 , nodo.sistema, nodo.hbiblioteca); //tipo 1 arbol
   end
   else
      Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 'no existe el fuente' ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

//procedure Tfarbol.GenerarDiagrama( lsNomFte: String; lsArchFte: String );
{ Funcion que unifique, ahora esta en uDiagramaRutinas
procedure Tfarbol.GenerarDiagrama( lsNomFte: String; lsArchFte: String; clase: String);
var
   lslBat: Tstringlist;
   lsArchBat, lsArchSal, lsDir, lsDir1: string;
   sRutaMisDocumentos: String;
   clave_len : String;
begin
   gral.PubMuestraProgresBar( True );
   // ponerle la clave de acuerdo a la clase (lenguaje)
   if clase='CBL' then      //cobol
      clave_len:='COBFIX';
   if (clase='SUX') or (clase='USH')then      //shell
      clave_len:='KSH';
   if (clase='JCL') or (clase='JCL') then      // jcl  /  job
      clave_len:='XSLT';
   if (clase='TDC') or (clase='CCH') or (clase='CUX') or (clase='PUX') or (clase='HUX') then      //c
      clave_len:='C';

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
      lslBat.add( 'Language='+clave_len );
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
end;                                                  }


// --------- Modificacion de funcion para que trabaje tanto con el arbol, como para la doc automatica   ALK
//procedure Tfarbol.GenerarDiagramaNvo( lsNomFte: String; lsArchFte: String; parClase, parTipoDiagrama: String );
procedure Tfarbol.GenerarDiagramaNvo( lsNomFte, lsArchFte, parClase, parTipoDiagrama: String; tipo : integer; sistema,bib : String);
var
   sRutaMisDocumentos, lsDir : string;
   slSepara : TStringList;
   conDiag : TalkFormConfDiag;
   icont,ierror: integer;  //alk out of system
begin
   gral.PubMuestraProgresBar( True );
   try
      if tipo = 1 then begin                      //arbol
         sRutaMisDocumentos := GlbObtenerRutaMisDocumentos;
         lsDir := sRutaMisDocumentos + '\Informes';
         // Enviar los datos a la ventana primero
         // ------ ALK para controlar el error out of system resources ------
         try
           conDiag := TalkFormConfDiag.Create(self);
         except
            on E: exception do begin
               Sleep(100); // doy un tiempo
               ierror:=1;   //hubo un error, lo indico
               for icont:=0 to 500 do begin
                  if ierror=1 then begin      //si hay error, si no pudo generar
                     ierror:=0;  //doy por hecho que lo genera
                     try
                        conDiag := TalkFormConfDiag.Create(self);
                     except
                        on E: exception do
                           ierror:=1;
                     end;
                  end
                  else
                     break;  //si ya no hay error, ya lo genero, salgo del ciclo
               end;  //fin for
            end;
         end;
         // ----------------------------------------------------------------------------
         conDiag.set_data(lsNomFte,bib,parClase,sistema,parTipoDiagrama, lsDir, lsArchFte);
         // ------ llamar a la nueva ventana  ------------
         try
            conDiag.ShowModal;
         finally
            conDiag.Free;
         end;
         //------------------------------------------------------------
      end         // en caso de la documentacion automatica, se va a usar parametros estandard
      else begin           //  doc auto
         // Enviar los datos a la ventana primero
         conDiag := TalkFormConfDiag.Create(self);
         conDiag.set_data_docauto(lsNomFte,bib,parClase,sistema,parTipoDiagrama, lsArchFte);
         // ------ llamar a la nueva ventana  ------------
         try
            //conDiag.ShowModal;   // en vez de mostrar la ventana, realizar el proceso
            conDiag.genera_diagrama;
         finally
            conDiag.Free;
         end;
         //------------------------------------------------------------
      end;
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
   icont,ierror: integer;  //alk out of system
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
      
      // ------ ALK para controlar el error out of system resources ------
      try
        ftsdghtml[ k ] := Tftsdghtml.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsdghtml[ k ] := Tftsdghtml.create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      
      
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
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'Diagrama de Flujo Interactivo ' + clase + ' ' + bib + ' ' + nombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( fmgflcob );
      setlength( fmgflcob, k + 1 );

      //fmgflcob[ k ] := Tfmgflcob.create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmgflcob[ k ] := Tfmgflcob.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmgflcob[ k ] := Tfmgflcob.create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      if gral.bPubVentanaMaximizada = FALSE then begin
         fmgflcob[ k ].Width := g_Width;
         fmgflcob[ k ].Height := g_Height;
      end;
      //fmgflcob[ k ].Constraints.MaxWidth := g_MaxWidth;
      fmgflcob[ k ].caption := titulo;
      fmgflcob[ k ].titulo := titulo;
      fmgflcob[ k ].bc := strtoint(bc);
      fmgflcob[ k ].ec := strtoint(ec);
      fmgflcob[ k ].ignore := strtoint(ignore);
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
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := 'RPG ' + clase + ' ' + bib + ' ' + nombre;
      k := length( fmgflrpg );
      setlength( fmgflrpg, k + 1 );

      //fmgflrpg[ k ] := Tfmgflrpg.create( self );
      // ------ ALK para controlar el error out of system resource ------
      try
         fmgflrpg[ k ] := Tfmgflrpg.create( self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 50 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmgflrpg[ k ] := Tfmgflrpg.create( self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

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
   f: file of Byte;
   fcreado,fmodificado,faccesado,futileria : Tdatetime;

   procedure checa_parametros_extra;
   var
      txtextra:string;
   begin
      txtextra:='';
      bc:='08';
      ec:='72';
      ignore:='07';
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chkextra_' + reg.sistema + '_' + reg.hclase + '_' + reg.hbiblioteca + g_q+
         ' and   dato='+g_q+'TRUE'+g_q) then begin
         if dm.sqlselect(dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'EXTRA_MINING_' + reg.sistema+'_'+ reg.hclase +'_'+reg.hbiblioteca+ g_q) then
            txtextra := dm.q1.fieldbyname('dato').AsString;
      end;
      {
      else
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'EXTRA_MINING_' + reg.hclase + g_q) then
         txtextra := dm.q1.fieldbyname('dato').AsString;
      }
      if trim(txtextra)<>'' then begin
         //bc:='08';
         i:=pos('BC=',txtextra);
         if i>0 then begin
            bc:=copy(txtextra,i+3,1000);
            bc:=copy(bc,1,pos('{B}',bc)-1);
         end;
         //ec:='72';
         i:=pos('EC=',txtextra);
         if i>0 then begin
            ec:=copy(txtextra,i+3,1000);
            ec:=copy(ec,1,pos('{B}',ec)-1);
         end;
         //ignore:='07';
         i:=pos('IGNORE.',txtextra);
         if i>0 then begin
            ignore:=copy(txtextra,i+7,1000);
            ignore:=copy(ignore,1,pos('=',ignore)-1);
         end;
         if length(ignore)=1 then
            ignore:='0'+ignore;
         fte.LoadFromFile( directivas );
         fte[ 0 ] := stringreplace( fte[ 0 ], 'BC08', 'BC'+bc, [ ] );
         fte[ 0 ] := stringreplace( fte[ 0 ], 'EC72', 'EC'+ec, [ ] );
         fte[ 0 ] := stringreplace( fte[ 0 ], 'JB08', 'JB'+bc, [ ] );
         fte[ 0 ] := stringreplace( fte[ 0 ], 'JE72', 'JE'+ec, [ ] );
         fte[ 1 ] := 'IGNORE    '+ignore+'*\'+ignore+'/\'+ignore+'$\'+ignore+'?\\';
         fte.SaveToFile( directivas );
      end;
   end;

begin
   reg := nodo_actual.Data;
   if reg.hbiblioteca = 'SCRATCH' then begin
      Application.MessageBox( pchar( dm.xlng( 'Fuente no existe' ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;

   //----------------- RGM20141112 para mantener archivos intermedios
   hora := formatdatetime( 'YYYYMMDDhhnnss', now );
   rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   directivas := g_tmpdir + '\hta' + hora + '.dir';
   reservadas := g_tmpdir + '\hta' + hora + '.res';
   ff := g_tmpdir + '\hta' + hora + '.tmp';
   dm.get_utileria( 'COBOLFLOW', directivas,true,true );
   fte := Tstringlist.Create;
   // Checa si trae parámetros extra
   checa_parametros_extra;
   mux:=g_tmpdir+'\fte_'+cprog2bfile(reg.sistema+'_'+reg.hnombre+'_'+reg.hbiblioteca+'_'+reg.hclase+'.src');
   salida:=mux+'.sal';
   if fileexists(mux) and fileexists(salida) then begin
      AssignFile(f, salida);
      Reset(f);
      k:=filesize(f);
      CloseFile(f);
      if ptscomun.GetFileTimes(mux,fcreado,fmodificado,faccesado) then begin
         if dm.sqlselect(dm.q1,'select fecha from tsutileria '+
            ' where cutileria='+g_q+'COBOLFLOW'+g_q) then begin
            futileria:=dm.q1.fieldbyname('fecha').AsDateTime;
         end;

         if dm.sqlselect(dm.q1,'select fecha from tsprog '+
            ' where cprog='+g_q+reg.hnombre+g_q+
            ' and   cbib='+g_q+reg.hbiblioteca+g_q+
            ' and   cclase='+g_q+reg.hclase+g_q) then begin

            if (dm.q1.FieldByName('fecha').AsDateTime<fmodificado)
               and (futileria<fmodificado)
               and (k>0) then begin   // si la fecha del componente es menor a la fecha del archivo y el archivo no está vacio
               rut_svsflcob( reg.hnombre, reg.hbiblioteca, reg.hclase, mux, salida ); // presenta el diagrama
               exit;                                                                  // y se sale (no regenera el archivo .sal
            end;
         end;
      end;
   end;
   //---------------------------------------------------------------------------
   fte.Clear;
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
   //mux := g_tmpdir + '\fte' + reg.hnombre + '.src';
   fte.SaveToFile( mux );
   //g_borrar.Add( mux );
   //salida := g_tmpdir + '\sal.sal';
   //salida:=mux + '.sal';
   //salida:=g_tmpdir + '\fte' + reg.hnombre+ '.sal';       //ALK
   //deletefile( salida );

   //rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   //directivas := g_tmpdir + '\hta' + hora + '.dir';
   //reservadas := g_tmpdir + '\hta' + hora + '.res';
   //ff := g_tmpdir + '\hta' + hora + '.tmp';             //archivo temporal

   dm.get_utileria( 'RGMLANG', rgmlang );
   //dm.get_utileria( 'COBOLFLOW', directivas );

   {
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

   }
   ff := g_tmpdir + '\hta' + hora + '.nada';

   dm.get_utileria( 'RESERVADAS CBL', reservadas );

   // Procesar fuente
   dm.ejecuta_espera( rgmlang + ' ' +              //RGMLANG
      mux + ' ' +                                  //archivo fuente
      ff + ' ' +                                   //archivo temporal
      directivas + ' ' +                           //directivas (modificadas para TANDEM)
      //reservadas, SW_HIDE );
      reservadas+ ' >'+salida, SW_HIDE );          //reservadas - Archivo de salida

   // Manda borrar todos los archivos utilizados
   g_borrar.Add( rgmlang );
   g_borrar.Add( directivas );
   g_borrar.Add( reservadas );
   g_borrar.Add( ff );

   fte.Free;
   //   deletefile('sal.sal');
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + nodotext ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   //g_borrar.Add( salida );   RGM20141112 para mantener archivos intermedios

   //Lo manda procesar
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

   //verificar si existe el fuente antes de procesar el diagrama
   if not dm.trae_fuente(reg.sistema,reg.hnombre,reg.hbiblioteca,reg.hclase,memo) then begin
      Application.MessageBox( pchar( dm.xlng( 'AVISO... no existe el fuente') ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;

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
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := sLISTA_REF_CRUZADAS + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      if not dm.es_SCRATCH(reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      k := length( ftsrefcruz );
      setlength( ftsrefcruz, k + 1 );

      //ftsrefcruz[ k ] := TfmRefCruz.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         ftsrefcruz[ k ] := TfmRefCruz.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsrefcruz[ k ] := TfmRefCruz.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      ftsrefcruz[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         ftsrefcruz[ k ].Width := g_Width;
         ftsrefcruz[ k ].Height := g_Height;
      end;

      if g_language = 'ENGLISH' then
         ftsrefcruz[ k ].titulo := 'Cross Reference ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre
      else
         ftsrefcruz[ k ].titulo := sLISTA_REF_CRUZADAS + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if reg.sistema='' then
         ftsrefcruz[ k ].arma( reg.hclase, reg.hbiblioteca, reg.hnombre, reg.hnombre )
      else
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
   clases_listas:TStringList;
begin
   screen.Cursor := crsqlwait;
   clases_listas:=TStringList.Create;
   clases_listas:= gral.clases_p_listas;
   try
      WArchRutina := '';
      HT := tv.GetHitTestInfoAt( X, Y );

      if not ( htOnItem in HT ) then
         exit;

      nodo_actual := tv.GetNodeAt( X, Y );
      g_X := X;
      g_Y := Y;
      nodo_actual.Selected := true;

      //   ------------------------ ALK --------------------------------
      if nodo_actual = nodo_antes then begin
         exit;
      end
      else begin
         popupArbol.Items.Clear;   //si el nodo actual es diferente al anterior no borrar el menu    alk!!
         nodo_antes := nodo_actual;
      end;
      //   -------------------------------------------------------------

      memo_fuente(nodo_actual);
      reg := nodo_actual.Data;

      if ( reg.hclase = 'CLA' ) or ( reg.hclase = 'SUBCLASE' ) or ( reg.hclase = 'USER' ) or
         ( reg.hclase = 'EMPRESA' ) or ( reg.hclase = 'OFICINA' ) or
         ( reg.hclase = 'SISTEMA' ) or ( reg.hclase = 'USERPRO' ) then
         image1.Visible := true;
      /////else
      /////   memo.Visible := true;

      popupArbol.Images := dm.ImageList3;
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
            popupArbol.Items[ k ].OnClick := metricas_codepro;
         end;
         if fileexists( 'c:\componentes_source\codepro_dependencias\' + reg.hnombre + '.mht' ) then begin
            k := agrega_al_menu( 'Dependencias CODEPRO' );
            popupArbol.Items[ k ].OnClick := dependencias_codepro;
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
         popupArbol.Items[ k ].OnClick := nuevo_proyecto;
      end

      else if ( reg.pclase = 'USERPRO' ) or
         ( reg.pclase = 'CONSULTA' ) or
         ( ( reg.hclase = 'USERPRO' ) and ( nodo_actual.HasChildren = false ) ) then begin //solo puede borrar proyectos que no tiene hijos
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Delete Component' )
         else
            k := agrega_al_menu( 'Eliminar componente' );
         popupArbol.Items[ k ].OnClick := borrar_item;
      end

      else if ( reg.pclase = 'CONSULTA' ) or // Esta condición esta para que no truene, cuando piden PopUp de un proyecto que no tiene Hijos
      ( reg.hclase = 'USERPRO' ) then begin
      //end
      end;

      {agrega_al_menu( clase_descripcion_todas[ clase_todas.IndexOf( reg.hclase ) ] + ' - ' + nodo_actual.Text );
      agrega_al_menu( '-' );}

      if ( reg.hclase = 'NVW' ) or
         ( reg.hclase = 'NIN' ) or
         ( reg.hclase = 'NUP' ) or
         ( reg.hclase = 'NDL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'CRUD ADABAS' )
         else
            k := agrega_al_menu( 'ADABAS CRUD' );
         popupArbol.Items[ k ].OnClick := adabas_crud;
         popupArbol.Items[ K ].ImageIndex := 5;
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
            popupArbol.Items[ k ].OnClick := atributos;
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
         popupArbol.Items[ k ].OnClick := atributos;
      end;
      {
      if ( reg.pclase = 'USERPRO' ) or
         ( reg.pclase = 'CONSULTA' ) or
         ( ( reg.hclase = 'USERPRO' ) and ( nodo_actual.HasChildren = false ) ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Delete Item' )
         else
            k := agrega_al_menu( 'Borrar Item' );
         popupArbol.Items[ k ].OnClick := borrar_item;
      end;
       }
      // if dm.capacidad( 'Cambio de iconos Arbol' ) then begin
      if ( g_usuario = 'ADMIN' ) or ( g_usuario = 'SVS' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Change Icon' )
         else
            k := agrega_al_menu( 'Cambio de Icono' );
         popupArbol.Items[ k ].OnClick := cambia_icono;
      end;

      {                       ALK
       Provisional, para que aparezcan Listas de Componentes
       y lista de dependencia de componentes
      }
      //***************************************
      if clases_listas.IndexOf( reg.hclase )= -1 then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Dependency  List' )
         else
            k := agrega_al_menu( sLISTA_DEPENDENCIAS );
         popupArbol.Items[ k ].OnClick := lista_dependencias;
         popupArbol.Items[ K ].ImageIndex := 4;


         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Component list' )
         else
            k := agrega_al_menu( sLISTA_COMPONENTES );
         popupArbol.Items[ k ].OnClick := lista_componentes;
         popupArbol.Items[ K ].ImageIndex := 4;
      end;
      //***************************************

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
         popupArbol.Items[ k ].OnClick := DiagramaAnalisisImpacto;
         popupArbol.Items[ K ].ImageIndex := 12;
      end;

      if ((reg.hclase = 'CBL') or (reg.hclase = 'CMA')) then begin //diagrama bloques //isaac
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_BLOQUES ) //constante sDIGRA_BLOQUES
         else
            k := agrega_al_menu( sDIGRA_BLOQUES );

         popupArbol.Items[ k ].OnClick := DiagramaBloques;
         popupArbol.Items[ k ].ImageIndex := 17;
      end;

      if ( reg.hclase = 'NAT' ) or
         ( reg.hclase = 'NSP' ) or
         ( reg.hclase = 'NSR' ) or
         ( reg.hclase = 'NHL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         popupArbol.Items[ k ].OnClick := diagramanatural;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      if ((reg.hclase = 'CBL') or (reg.hclase = 'CMA')) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo Interactivo' );
         popupArbol.Items[ k ].OnClick := diagramacbl;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      if ((reg.hclase = 'CBL') or (reg.hclase = 'CMA') or ( reg.hclase = 'CPY' )) then begin
         if ((reg.hclase = 'CBL') or (reg.hclase = 'CMA')) then
            k := agrega_al_menu( sDIGRA_FLUJO_CBL );
         if reg.hclase = 'CPY' then
            k := agrega_al_menu( sDIGRA_FLUJO_CPY );

         //popupArbol.Items[ k ].OnClick := DiagramaCOBOL;
         popupArbol.Items[ k ].OnClick :=DiagramaFlujoCBL;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      // -------Agregar codigo muerto----------
      if ((reg.hclase = 'CBL') or (reg.hclase = 'CMA')) and
         dm.capacidad('MENU CONTEXTUAL CODIGO MUERTO') then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Dead code' )
         else
            k := agrega_al_menu( 'Codigo muerto' );
         popupArbol.Items[ k ].OnClick := codigoMuerto;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      // ---------------------------------------

      if reg.hclase = 'OSQ' then begin
         k := agrega_al_menu( sDIGRA_FLUJO_OSQ );

         popupArbol.Items[ k ].OnClick :=DiagramaFlujoOSQ;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      if reg.hclase = 'OSQ' then begin
         k := agrega_al_menu( sDIGRA_JERARQUICO_OSQ );

         popupArbol.Items[ k ].OnClick :=DiagramaJerarquicoOSQ;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'ALG' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_ALG );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaFlujoALG;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'TMP' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_TMP );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaFlujoMACROS;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'TMC' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_TMC );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaFlujoMACROS;       //cambiar alk para
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'OBY' ) then begin                  //ALK oby
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama flujo OBY' );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaFlujoOBY;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'WFL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_WFL );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaFlujoWFL;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'WFL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart2' )
         else
            k := agrega_al_menu( sDIGRA_JERARQUICO_WFL );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaJerarquicoWFL;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'BSC' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_BSC );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaFlujoBSC;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      {if ( reg.hclase = 'BSC' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart2' )
         else
            k := agrega_al_menu( sDIGRA_JERARQUICO_BSC );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaJerarquicoBSC;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;}

      if ( reg.hclase = 'ALG' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart2' )
         else
            k := agrega_al_menu( sDIGRA_JERARQUICO_ALG );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaJerarquicoALG;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'DCL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_DCL );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaFlujoDCL;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      //   -----------  ALK para diagramador CBL -----------------
       if ((reg.hclase = 'CBL') or (reg.hclase = 'CMA')) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart2' )
         else
            k := agrega_al_menu( sDIGRA_JERARQUICO_CBL );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaJerarquicoCBL;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      //   -----------  ALK para diagramador visustin -----------------
      if ( reg.hclase = 'TDC' ) or ( reg.hclase = 'CCH' ) or ( reg.hclase = 'CUX' ) or
          ( reg.hclase = 'PUX' ) or ( reg.hclase = 'HUX' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( sDIGRA_FLUJO_C );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaVisustin;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase = 'SUX' ) or ( reg.hclase = 'USH' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaVisustin;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      //viejo llamado JCL
      g_clase := '';
      if ( reg.hclase = 'JOB' ) or
         ( reg.hclase = 'JCL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := Diagramajcl;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      // Nuevo llamado JCL ALK
      g_clase := '';
      if ( reg.hclase = 'JOB' ) or
         ( reg.hclase = 'JCL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo con comentarios' );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaVisustin;   //Diagramajcl;       //alk cambia a visustin
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      // ------------------------------------------------------
      {
      if reg.hclase = 'JAV' then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         popupArbol.Items[ k ].OnClick := dghtml;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      }
      if reg.hclase = 'CLP' then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         popupArbol.Items[ k ].OnClick := diagramarpg;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;
      g_clase := '';
      if ( reg.hclase = 'PCK' ) or
         ( reg.hclase = 'JLA' ) or
         ( reg.hclase = 'JSP' ) or
         ( reg.hclase = 'JS' ) or
         ( reg.hclase = 'JAV' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo V' );
         g_clase := reg.hclase;
         popupArbol.Items[ k ].OnClick := DiagramaVisustin;
         popupArbol.Items[ K ].ImageIndex := 17;
      end;

      if ( reg.hclase = 'PCK' ) or ( reg.hclase = 'JAV' ) then begin //diagrama paquetes
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_PAQUETES ) //constante sDIGRA_PAQUETES
         else
            k := agrega_al_menu( sDIGRA_PAQUETES );

         popupArbol.Items[ k ].OnClick := DiagramaUMLPaquetes;
         popupArbol.Items[ K ].ImageIndex := 17;
      end;

      if ( reg.hclase = 'JAV' ) or ( reg.hclase = 'JLA' ) then begin //diagrama clases
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_CLASES )
         else
            k := agrega_al_menu( sDIGRA_CLASES );

         popupArbol.Items[ k ].OnClick := DiagramaUMLClases;
         popupArbol.Items[ K ].ImageIndex := 17;
      end;

      if ( reg.hclase = 'ASE' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Flowchart' )
         else
            k := agrega_al_menu( 'Diagrama de Flujo' );
         popupArbol.Items[ k ].OnClick := diagramaase;
         popupArbol.Items[ K ].ImageIndex := 10;
      end;

      if ( reg.hclase <> 'EMPRESA' ) and
         ( reg.hclase <> 'OFICINA' ) and
         ( reg.hclase <> 'USER' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'CLA' ) and
         ( reg.hclase <> 'SUBCLASE' ) and
         ( reg.hclase <> 'CTM' ) and
         ( reg.hclase <> 'CTR' ) and
         ( reg.hclase <> 'FIL' )then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_PROCESOS )
         else
            k := agrega_al_menu( sDIGRA_PROCESOS );
         popupArbol.Items[ k ].OnClick := DiagramaProcesos;
         popupArbol.Items[ K ].ImageIndex := 9;
      end;

      if ( reg.hclase = 'SISTEMA' ) then begin
         k := agrega_al_menu( sDIGRA_SISTEMA );
         popupArbol.Items[ k ].OnClick := DiagramaSistema; //diagrama del sistema
      end;

      if ( reg.hclase <> 'SUBCLASE' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'USER' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Documentation' )
         else
            k := agrega_al_menu( 'Documentación Externa' );
         popupArbol.Items[ k ].OnClick := Documentacion; //reglas_negocio //documentacion
      end;

      if ( reg.hclase <> '' ) and
         ( reg.hbiblioteca <> '' ) and
         ( reg.hnombre <> '' ) and
         dm.capacidad('MENU CONTEXTUAL DRILL DOWN') then begin
         k := agrega_al_menu( sLISTA_DRILLDOWN );
         popupArbol.Items[ k ].OnClick := ListaDrillDown; //Lista Drill Down
         popupArbol.Items[ K ].ImageIndex := 4;
      end;

      if ( reg.hclase <> '' ) and
         ( reg.hbiblioteca <> '' ) and
         ( reg.hnombre <> '' ) and
         dm.capacidad('MENU CONTEXTUAL DRILL UP')  then begin
         k := agrega_al_menu( sLISTA_DRILLUP );
         popupArbol.Items[ k ].OnClick := ListaDrillUp; //Lista Drill Up
         popupArbol.Items[ K ].ImageIndex := 4;
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
         popupArbol.Items[ k ].OnClick := tabla_crud;
         popupArbol.Items[ K ].ImageIndex := 5;
      end;

      if ( reg.hclase = 'TAB' ) or
         ( reg.hclase = 'INS' ) or
         ( reg.hclase = 'UPD' ) or
         ( reg.hclase = 'DEL' ) or
         ( reg.hclase = 'SEL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Detail' )
         else
            k := agrega_al_menu( 'Detalle de tabla' );
         popupArbol.Items[ k ].OnClick := detalle_tabla;
         //popupArbol.Items[ K ].ImageIndex := 5;
      end;

      if ( reg.hclase = 'FIL' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'CRUD File' )
         else
            k := agrega_al_menu( 'Matriz Archivo Físico' );
         popupArbol.Items[ k ].OnClick := archivo_fisico;
         popupArbol.Items[ K ].ImageIndex := 5;
      end;

      {if ( reg.hclase = 'LOC' ) then begin
         k := agrega_al_menu( sMATRIZ_ARCHIVO_LOG );
         popupArbol.Items[ k ].OnClick := MatrizArchLog; //matriz archivo logico
         popupArbol.Items[ K ].ImageIndex := 5;
      end;   }

      if clase_analizable.IndexOf( reg.hclase ) > -1 then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Properties' )
         else
            k := agrega_al_menu( 'Propiedades' );
         popupArbol.Items[ k ].OnClick := propiedades;
      end;

      if ( reg.hclase <> 'EMPRESA' ) and
         ( reg.hclase <> 'OFICINA' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'USER' ) and
         ( reg.hclase <> 'CTM' ) and
         ( reg.hclase <> 'CTR' ) and
         ( reg.hclase <> 'SUBCLASE' ) then begin
         if ( reg.hbiblioteca <> 'BD' ) and
            {( copy(reg.hbiblioteca,1,4) <> 'DISK' ) and }
            ( reg.hbiblioteca <> 'LOC' ) then begin
            if g_language = 'ENGLISH' then
               k := agrega_al_menu( 'Cross Reference' )
            else
               k := agrega_al_menu( sLISTA_REF_CRUZADAS );
            popupArbol.Items[ k ].OnClick := referencias_cruzadas;
            popupArbol.Items[ K ].ImageIndex := 13;
         end;
      end;

      if ( reg.hclase <> 'EMPRESA' ) and
         ( reg.hclase <> 'OFICINA' ) and
         ( reg.hclase <> 'USERPRO' ) and
         ( reg.hclase <> 'USER' ) and
         ( reg.hclase <> 'SISTEMA' ) and
         ( reg.hclase <> 'SUBCLASE' ) and
         ( reg.hclase <> 'CLA' ) and
         ( reg.hclase <> 'FIL' ) and
         ( farbol.memo.Lines.Count > 0 ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'ver Fuente' )
         else
            k := agrega_al_menu( 'Ver Fuente' );
         //popupArbol.Items[ k ].OnClick := NotePad1Click;  24052013
         popupArbol.Items[ k ].OnClick := VerFuente;
         popupArbol.Items[ K ].ImageIndex := 14;
      end;

      if ( reg.hclase <> 'CLA' ) then begin
         if clase_fisico.IndexOf( reg.hclase ) > -1 then begin
            if g_language = 'ENGLISH' then
               k := agrega_al_menu( 'Versions' )
            else
               k := agrega_al_menu( 'Versiones' );
            popupArbol.Items[ k ].OnClick := versionado;
         end;
      end;

      if reg.hclase = 'FMB' then begin // Pantalla de SQLFORMS
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Screen View' )
         else
            k := agrega_al_menu( 'Vista Pantalla' );
         popupArbol.Items[ k ].OnClick := fmb_vista_pantalla;
         fmb_nombre_pantalla := dm.pathbib( reg.hbiblioteca, reg.hclase ) + '\' + reg.hnombre + '.txt';
      end;

      if reg.hclase = 'DFM' then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := formadelphi_preview;
      end;

      if reg.hclase = 'BFR' then begin // Forma Visual Basic
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := formavb_preview;
      end;

      if reg.hclase = 'PNL' then begin // Panel IDEAL
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := panel_preview;
      end;

      if reg.hclase = 'BMS' then begin // Pantalla CICS
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := bms_preview;
      end;

      if reg.hclase = 'NMP' then begin // Mapa Natural
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := natural_mapa_preview;
      end;

      if ( reg.hclase = 'PHP' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := vista_falsa
      end;

      if ( reg.hclase = 'GIF' )
         or ( reg.hclase = 'JPG' )
         or ( reg.hclase = 'PNG' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := vista_imagenes;
      end;

      if ( reg.hclase = 'HTM' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := vista_htm;
      end;

      if ( reg.hclase = 'TSC' ) then begin
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( 'Preview' )
         else
            k := agrega_al_menu( 'Vista Previa' );
         popupArbol.Items[ k ].OnClick := vista_tsc;
      end;

      if ( reg.hclase = 'CTR' ) or ( reg.hclase = 'CTM' ) then begin //diagrama scheduler
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sDIGRA_SCHEDULER )
         else
            k := agrega_al_menu( sDIGRA_SCHEDULER );
         popupArbol.Items[ k ].OnClick := DiagramaScheduler;
         popupArbol.Items[ K ].ImageIndex := 17;
      end;

      if reg.hclase = 'CBL' then begin //diagrama scheduler
         if g_language = 'ENGLISH' then
            k := agrega_al_menu( sVAL_ESTATICAS )
         else
            k := agrega_al_menu( sVAL_ESTATICAS );
         popupArbol.Items[ k ].OnClick := validacionesEstaticas;
         popupArbol.Items[ K ].ImageIndex := 17;
      end;

   finally
      screen.Cursor := crdefault;
   end;
   clases_listas.Free;
end;

// ------------------------ Mostrar el fuente al dar click -------------------------
//procedure Tfarbol.tvClick( Sender: TObject );
procedure Tfarbol.memo_fuente (nodo : TTreeNode);       // nuevo RGM 2015
var
   reg: ^Tmyrec;
   i,j,iaux:integer;
   lis:Tstringlist;
begin
   reg:=nodo.Data;
   memo.Lines.Clear;
   farbol.Image1.Visible := false;
   farbol.Image2.Visible := false;
   farbol.Memo.Visible := true;
   if ( reg.hclase = 'CLA' ) or ( reg.hclase = 'SUBCLASE' ) or ( reg.hclase = 'USER' ) or
      ( reg.hclase = 'EMPRESA' ) or ( reg.hclase = 'OFICINA' ) or
      ( reg.hclase = 'SISTEMA' ) or ( reg.hclase = 'USERPRO' ) then begin
      farbol.image1.Visible := true;
      farbol.Memo.Visible := false;
      screen.Cursor := crdefault;
      exit;
   end;

   iaux:= clase_todas.IndexOf( reg.hclase );
   if iaux = -1 then begin
      application.MessageBox( PChar('La clase '+ reg.hclase +' no está cargada en el catalogo de clases.'),
                              'Aviso clases ', MB_OK );
      exit;
   end;

   agrega_al_menu( clase_descripcion_todas[ iaux ] + ' - ' + nodo_actual.Text );
   agrega_al_menu( '-' );
   if clase_fisico.IndexOf( reg.hclase ) > -1 then begin  // la clase es física
      x1 := 0;
      if ( reg.hclase = 'GIF' ) or
         ( reg.hclase = 'JPG' ) or
         ( reg.hclase = 'PNG' ) then begin
         vista_imagenes( self );
         screen.Cursor := crdefault;
         exit;
      end;
      dm.trae_fuente( reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase, memo );
      screen.Cursor := crdefault;
      exit;
   end
   else begin      // Clases Virtuales
      if (reg.lineainicio>0) and
         (reg.lineafinal>0) then begin
         memo.Lines.Clear;
         if dm.trae_fuente( reg.sistema, reg.ocprog, reg.ocbib, reg.occlase, memo ) then begin
            lis:=tstringlist.Create;
            if reg.lineafinal=999999 then
               reg.lineafinal:=memo.Lines.Count;
            for i:=reg.lineainicio-1 to reg.lineafinal-1 do
               lis.Add(memo.Lines[i]);
            memo.Lines.Clear;
            memo.Lines.AddStrings(lis);
            lis.Free;
         end;
         screen.Cursor := crdefault;
         exit;
      end;
      if (reg.lineainicio>0) then begin
         dm.trae_fuente( reg.sistema, reg.ocprog, reg.ocbib, reg.occlase, memo );
         SePosicionaLineaInicial( reg.hnombre, reg.lineainicio );
         screen.Cursor := crdefault;
         exit;
      end;
      if dm.sqlselect( dm.q4, 'select * from tsrela ' +
         ' where hcprog=' + g_q + reg.hnombre + g_q +
         ' and   hcbib=' + g_q + reg.hbiblioteca + g_q +
         ' and   hcclase=' + g_q + reg.hclase + g_q +
         ' and   sistema=' + g_q + reg.sistema + g_q +
         ' and   lineainicio>0 '+
         ' and   lineafinal>0') then begin
         dm.trae_fuente( reg.sistema,
            dm.q4.fieldbyname('ocprog').AsString,
            dm.q4.fieldbyname('ocbib').AsString,
            dm.q4.fieldbyname('occlase').AsString, memo );
         lis:=tstringlist.Create;
         j:=dm.q4.fieldbyname('lineafinal').AsInteger;
         if j=999999 then j:=memo.Lines.Count;
         for i:=dm.q4.fieldbyname('lineainicio').AsInteger-1 to j-1 do
            lis.Add(memo.Lines[i]);
         memo.Lines.Clear;
         memo.Lines.AddStrings(lis);
         lis.Free;
         screen.Cursor := crdefault;
         exit;
      end;
      // no trae lineainicial ni lineafinal
      screen.Cursor := crdefault;
   end;
end;
// ---------------------------------------------------------------------------------

function Tfarbol.tiene_hijo(nombre: string; bib: string; clase: string; sistema: String):boolean;
var
   cons:String;
begin
   if sistema <> '' then
      cons:= 'select distinct hcprog,hcbib,hcclase from tsrela ' +
             ' where pcprog=' + g_q + nombre + g_q +
             ' and pcclase=' + g_q + clase + g_q +
             ' and pcbib=' + g_q + bib + g_q +
             ' and   sistema=' + g_q + sistema + g_q +
             ' order by hcclase,hcbib,hcprog'
   else
      cons:= 'select distinct hcprog,hcbib,hcclase from tsrela ' +
             ' where pcprog=' + g_q + nombre + g_q +
             ' and pcclase=' + g_q + clase + g_q +
             ' and pcbib=' + g_q + bib + g_q +
             ' order by hcclase,hcbib,hcprog';

   if dm.sqlselect( dm.qmodify, cons ) then
      tiene_hijo:=true
   else
      tiene_hijo:=false;

end;


procedure Tfarbol.expande( nodo: Ttreenode; nombre: string; bib: string;
   clase: string; veces: integer );
var
   qq, qq2: TADOQuery;
   nodx, nody, ts: Ttreenode;
   reg: ^Tmyrec;
   bexiste: boolean;
   descri, sistema, lExt, lNom, cons: string;
   procedure trae_de_tsrela(nombre,sistema:string);
   begin
      if dm.sqlselect( dm.q1, 'select distinct pcprog,pcbib,pcclase from tsrela ' +
         ' where pcclase=' + g_q + nombre + g_q +
         ' and   sistema=' + g_q + sistema + g_q +
         ' order by pcclase,pcbib,pcprog' ) then begin
         while not dm.q1.Eof do begin
            descri := trae_descripcion( sistema,
               dm.q1.fieldbyname( 'pcclase' ).AsString,
               dm.q1.fieldbyname( 'pcbib' ).AsString,
               dm.q1.fieldbyname( 'pcprog' ).AsString );
            nodx := tv.Items.AddChild( nodo, descri );
            new( reg );
            reg.ocprog := dm.q1.fieldbyname( 'pcprog' ).AsString;
            reg.ocbib := dm.q1.fieldbyname( 'pcbib' ).AsString;
            reg.occlase := dm.q1.fieldbyname( 'pcclase' ).AsString;
            reg.orden := '0001';
            reg.pnombre := nombre;
            reg.pbiblioteca := sistema;
            reg.pclase := clase;
            reg.hnombre := dm.q1.fieldbyname( 'pcprog' ).AsString;
            reg.hbiblioteca := dm.q1.fieldbyname( 'pcbib' ).AsString;
            reg.hclase := dm.q1.fieldbyname( 'pcclase' ).AsString;
            reg.sistema := sistema;
            reg.hijo_falso := tiene_hijo(nombre, bib, clase, sistema);//true;
            reg.lineainicio:=1;
            reg.lineafinal:=1;
            tv.Items.AddChild( nodx, 'hijo falso' );
            nodx.Data := reg;
            nodx.ImageIndex := dm.lclases.IndexOf( reg.hclase );
            nodx.SelectedIndex := 0; //dm.lclases.IndexOf( reg.hclase );
            dm.q1.Next;
         end;
      end;
   end;

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
         ' union '+
         ' select pcclase cclase , count(*) total from tsrela '+
         ' where pcclase='+g_q+'PCK'+g_q+
         ' group by pcclase '+
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
      if nombre='PCK' then begin   // paquetes JAVA
         trae_de_tsrela(nombre,sistema);
         exit;
      end;
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

               // --- cambio por funcion para determinar cuando deben de llevar signo de +  ALK ---
               //reg.hijo_falso := tiene_hijo(nombre, bib, clase, sistema);   //true;
               reg.hijo_falso := tiene_hijo(dm.q1.fieldbyname( 'cprog' ).AsString,
                                            dm.q1.fieldbyname( 'cbib' ).AsString,
                                            dm.q1.fieldbyname( 'cclase' ).AsString,
                                            sistema);
               if reg.hijo_falso then
                  tv.Items.AddChild( nodx, 'hijo falso' );
               // ---------------------------------------------------------------------------------

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

   if (sistema='') and (g_sistema<>'') then
      sistema:=g_sistema;

   if sistema <> '' then
      cons:= 'select * from tsrela ' +
             ' where pcprog=' + g_q + nombre + g_q +
             ' and pcbib=' + g_q + bib + g_q +
             ' and pcclase=' + g_q + clase + g_q +
             ' and sistema=' + g_q + sistema + g_q +
             ' order by orden,hcclase,hcbib,hcprog'
   else
      cons:= 'select * from tsrela ' +
             ' where pcprog=' + g_q + nombre + g_q +
             ' and pcbib=' + g_q + bib + g_q +
             ' and pcclase=' + g_q + clase + g_q +
             ' order by orden,hcclase,hcbib,hcprog';


   if dm.sqlselect( qq, cons ) then begin
      while not qq.Eof do begin
         {  RGM20170802
         if dm.sqlselect( dm.q5, 'select * from tsclase ' +
            ' where cclase=' + g_q + qq.fieldbyname( 'hcclase' ).AsString + g_q +
            ' and tipo <> ' + g_q + 'ANALIZABLE' + g_q +
            ' and estadoactual <> ' + g_q + 'ACTIVO' + g_q ) then begin
            qq.Next;
            continue;
         end;
         }
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
            if ptscomun.tiene_letras_o_numeros(qq.fieldbyname( 'coment' ).Asstring) then    //RGM para rayas
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
         reg.lineainicio := qq.fieldbyname( 'lineainicio' ).asinteger;
         reg.lineafinal := qq.fieldbyname( 'lineafinal' ).asinteger;
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
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := sLISTA_MATRIZ_CRUD + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      {if not dm.es_SCRATCH(reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;}

      k := length( afmMatrizCrud );
      setlength( afmMatrizCrud, k + 1 );

      //afmMatrizCrud[ k ] := TfmMatrizCrud.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         afmMatrizCrud[ k ] := TfmMatrizCrud.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     afmMatrizCrud[ k ] := TfmMatrizCrud.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      afmMatrizCrud[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         afmMatrizCrud[ k ].Width := g_Width;
         afmMatrizCrud[ k ].Height := g_Height;
      end;

      afmMatrizCrud[ k ].titulo := titulo;
      afmMatrizCrud[ k ].tipo := reg.hclase;//'TAB';
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
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      titulo := sMATRIZ_ARCHIVOS_FIS + ' ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      {if not dm.es_SCRATCH(reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end; }
      k := length( ftsarchivos );
      setlength( ftsarchivos, k + 1 );

      // ------ ALK para controlar el error out of system resources ------
      try
         ftsarchivos[ k ] := TfmMatrizAF.Create( farbol );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsarchivos[ k ] := TfmMatrizAF.Create( farbol );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      
      
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
      if not dm.es_SCRATCH(reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;
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
   reg.hijo_falso := tiene_hijo(nombre, bib, clase, g_sistema); //false;
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
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      reg := nodo_actual.data;
      Titulo := 'Diagrama de Flujo ' + reg.hclase + ' ' + reg.hbiblioteca + ' ' + reg.hnombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      if not dm.es_SCRATCH(reg.sistema, reg.hnombre, reg.hbiblioteca, reg.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;
      k := length( ftsdiagjcl );
      setlength( ftsdiagjcl, k + 1 );

      //ftsdiagjcl[ k ] := Tftsdiagjcl.create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         ftsdiagjcl[ k ] := Tftsdiagjcl.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsdiagjcl[ k ] := Tftsdiagjcl.create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

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
var
   cons : String;
begin
   cons:= 'select * from tsuserpro ' +
      ' where cuser=' + g_q + g_usuario + g_q +
      ' and cproyecto=' + g_q + proyecto + g_q +
      ' and cprog=' + g_q + nombre + g_q +
      ' and cbib=' + g_q + bib + g_q +
      ' and cclase=' + g_q + clase + g_q;
   if dm.sqlselect( dm.q1, cons ) then begin
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
   popupArbol.Items.Clear;

   if FormStyle = fsMDIChild then
      Action := caFree;

   g_arbol_activo:= 0;
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
      ftsconscom.p_agrega_consulta.Visible := true;
      ftsconscom.bproyecto.Visible := true;
      ftsconscom.cmbproyecto.Visible := true;
      ftsconscom.lblproyecto.Visible := true;
      ftsconscom.mnuAgregarParaConsulta.Visible := ivAlways;
      dm.feed_combo( ftsconscom.Cmbproyecto, 'select distinct cproyecto ' +
         ' from tsuserpro' +
         ' where cuser=' + g_q + g_usuario + g_q );
      ftsconscom.buscarText;
      ftsconscom.Show;

      g_arbol_activo:=1;

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

procedure Tfarbol.FormActivate( Sender: TObject );
begin

   //iHelpContext := IDH_TOPIC_T01100
   iHelpContext :=IDH_TOPIC_1_2
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
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_PAQUETES + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;
      if not dm.es_SCRATCH(Nodo.sistema, Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      iArreglo := Length( fmUMLPaquetes );
      SetLength( fmUMLPaquetes, iArreglo + 1 );

      // ------ ALK para controlar el error out of system resources ------
      try
         fmUMLPaquetes[ iArreglo ] := TfmUMLPaquetes.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmUMLPaquetes[ iArreglo ] := TfmUMLPaquetes.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      

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
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_CLASES + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;
      if not dm.es_SCRATCH(Nodo.sistema, Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      iArreglo := Length( fmUMLClases );
      SetLength( fmUMLClases, iArreglo + 1 );

      // ------ ALK para controlar el error out of system resources ------
      try
         fmUMLClases[ iArreglo ] := TfmUMLClases.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmUMLClases[ iArreglo ] := TfmUMLClases.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      

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
   scheduler : TalkFormScheduler;
   lslFuente : TStringList;
   lsArchFte : String;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      //sTitulo := 'DgrScheduler_' + Nodo.hclase + '_' + Nodo.hbiblioteca + '_' + Nodo.hnombre + '_' + Nodo.sistema;
      sTitulo := Nodo.hclase + '_' + Nodo.hbiblioteca + '_' + Nodo.hnombre + '_' + Nodo.sistema;

      {****** NUEVA FUNCION    ALK   *******}
      //lsArchFte:= 'fte_' + Nodo.hclase + '_' + Nodo.hbiblioteca + '_' + Nodo.hnombre + '_' + Nodo.sistema;
      scheduler:=TalkFormScheduler.Create(self);
      scheduler.get_nombre(sTitulo,Nodo.hclase,Nodo.hnombre,Nodo.sistema);
      lslFuente := Tstringlist.Create;

      if (Nodo.hclase='CTM') then begin
         //Traer el fuente desde base de datos, ya no como utileria
         if (dm.trae_fuente( Nodo.sistema,Nodo.ocprog, Nodo.ocbib, Nodo.occlase, lslFuente )= False) then begin
            Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
                  pchar( dm.xlng( 'AVISO ' ) ), MB_OK );
            lslFuente.Free;
            exit;
         end;
         lslFuente.SaveToFile( g_tmpdir + '\fte_' +sTitulo );
         scheduler.es_CTM;
         scheduler.Free;
      end
      else begin
         //Traer el fuente desde base de datos, ya no como utileria
         if (dm.trae_fuente( Nodo.sistema,Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase, lslFuente )= False) then begin
            Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
                  pchar( dm.xlng( 'AVISO ' ) ), MB_OK );
            lslFuente.Free;
            exit;
         end;
         lslFuente.SaveToFile( g_tmpdir + '\fte_' +sTitulo );
         try
            scheduler.ShowModal;
         finally
            scheduler.Free;
         end;
      end;
      lslFuente.Free;
      {*************************************}

      {
      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmScheduler );
      SetLength( fmScheduler, iArreglo + 1 );

      //fmScheduler[ iArreglo ] := TfmScheduler.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmScheduler[ iArreglo ] := TfmScheduler.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmScheduler[ iArreglo ] := TfmScheduler.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      if gral.bPubVentanaMaximizada = False then begin
         fmScheduler[ iArreglo ].Width := g_Width;
         fmScheduler[ iArreglo ].Height := g_Height;
      end;

      fmScheduler[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, Nodo.sistema, sTitulo );
      fmScheduler[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
      }
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
   icont,ierror: integer;  //alk out of system
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

      //fmAnalisisImpacto[ iArreglo ] := TfmAnalisisImpacto.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmAnalisisImpacto[ iArreglo ] := TfmAnalisisImpacto.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmAnalisisImpacto[ iArreglo ] := TfmAnalisisImpacto.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

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
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.data;
      sTitulo := sDIGRA_PROCESOS + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;
      if not dm.es_SCRATCH(Nodo.sistema, Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;
      iArreglo := Length( fmProcesos );
      SetLength( fmProcesos, iArreglo + 1 );
      {
      numero_registros:=dm.cuenta_registros('select count(*) '+
         ' FROM TSRELA t '+
         //' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.pCPROG = '+g_q+nodo.hnombre+g_q+
         '        AND T.pCBIB = '+g_q+nodo.hbiblioteca+g_q+
         '        AND T.pCCLASE = '+g_q+nodo.hclase+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.hCPROG = T.pCPROG AND '+
         ' PRIOR T.hCBIB = T.pCBIB AND '+
         ' PRIOR T.hCCLASE = T.pCCLASE');
      if numero_registros>5000 then begin
         showmessage('Involucra más de 5000 registros('+inttostr(numero_registros)+')');
         {
         if application.MessageBox(pchar('Involucra más de 5000 registros('+inttostr(numero_registros)+'), desea exportar a formato texto separado por comas?'),'Aviso',MB_YESNO)=IDYES then
            dm.exporta_texto(stitulo,
               'select level,pcprog,pcbib,pcclase,hcprog,hcbib,hcclase '+
               ' FROM TSRELA t '+
               ' START WITH T.pCPROG = '+g_q+nodo.hnombre+g_q+
               '        AND T.pCBIB = '+g_q+nodo.hbiblioteca+g_q+
               '        AND T.pCCLASE = '+g_q+nodo.hclase+g_q+
               ' CONNECT BY NOCYCLE '+
               ' PRIOR T.hCPROG = T.pCPROG AND '+
               ' PRIOR T.hCBIB = T.pCBIB AND '+
               ' PRIOR T.hCCLASE = T.pCCLASE',
               'select hcprog,hcbib,hcclase,count(*) '+
               ' FROM TSRELA t '+
               ' START WITH T.pCPROG = '+g_q+nodo.hnombre+g_q+
               '        AND T.pCBIB = '+g_q+nodo.hbiblioteca+g_q+
               '        AND T.pCCLASE = '+g_q+nodo.hclase+g_q+
               ' CONNECT BY NOCYCLE '+
               ' PRIOR T.hCPROG = T.pCPROG AND '+
               ' PRIOR T.hCBIB = T.pCBIB AND '+
               ' PRIOR T.hCCLASE = T.pCCLASE'+
               ' group by T.hcprog,T.hcbib,T.hcclase');
         exit;
      end;
      }
      //fmProcesos[ iArreglo ] := TfmProcesos.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmProcesos[ iArreglo ] := TfmProcesos.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmProcesos[ iArreglo ] := TfmProcesos.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

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
   function reemplaza_por(dat:string):string;
   var ini,fin:integer;
      s1,s2,s3,v1,v2,v3:string;
   begin
      ini:=pos('$REPLACE(',dat);
      if ini=0 then begin
         reemplaza_por:=dat;
         exit;
      end;
      s1:='';
      if ini>1 then
         s1:=copy(dat,1,ini-1);
      s2:=copy(dat,ini+9,1000);
      fin:=pos(')',s2);
      s3:=copy(s2,fin+1,1000);
      s2:=trim(copy(s2,1,fin-1));
      if copy(s2,1,1)<>'"' then begin
         reemplaza_por:='ERROR...($REPLACE) Textos deben ir entre comillas "';
         exit;
      end;
      delete(s2,1,1);
      fin:=pos('"',s2);
      if fin=0 then begin
         reemplaza_por:='ERROR...($REPLACE) falta comillas " final ''';
         exit;
      end;
      v1:=copy(s2,1,fin-1);
      s2:=trim(copy(s2,fin+1,1000));
      if copy(s2,1,1)<>',' then begin
         reemplaza_por:='ERROR...($REPLACE) falta coma (,)';
         exit;
      end;
      s2:=trim(copy(s2,2,1000));
      if copy(s2,1,1)<>'"' then begin
         reemplaza_por:='ERROR...($REPLACE) Textos deben ir entre comillas "';
         exit;
      end;
      delete(s2,1,1);
      fin:=pos('"',s2);
      if fin=0 then begin
         reemplaza_por:='ERROR...($REPLACE) falta comillas " final ';
         exit;
      end;
      v2:=copy(s2,1,fin-1);
      s2:=trim(copy(s2,fin+1,1000));
      if copy(s2,1,1)<>',' then begin
         reemplaza_por:='ERROR...($REPLACE) falta coma (,)';
         exit;
      end;
      s2:=trim(copy(s2,2,1000));
      if copy(s2,1,1)<>'"' then begin
         reemplaza_por:='ERROR...($REPLACE) Textos deben ir entre comillas "';
         exit;
      end;
      delete(s2,1,1);
      fin:=pos('"',s2);
      if fin=0 then begin
         reemplaza_por:='ERROR...($REPLACE) falta comillas " final ';
         exit;
      end;
      v3:=copy(s2,1,fin-1);
      s2:=stringreplace(v1,v2,v3,[rfreplaceall]);
      reemplaza_por:=s1+s2+s3;
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
         dat:=reemplaza_por(dat);
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
   dat:=reemplaza_por(dat);

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
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Nodo := nodo_actual.Data;
      sTitulo := sDIGRA_BLOQUES + ' ' + Nodo.hclase + ' ' + Nodo.hbiblioteca + ' ' + Nodo.hnombre;

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;
      if not dm.es_SCRATCH(Nodo.sistema, Nodo.hnombre, Nodo.hbiblioteca, Nodo.hclase) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      iArreglo := Length( fmBloques );
      SetLength( fmBloques, iArreglo + 1 );
      {
      numero_registros:=dm.cuenta_registros('select count(*) '+
         ' FROM TSRELA t '+
         //' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.pCPROG = '+g_q+nodo.hnombre+g_q+
         '        AND T.pCBIB = '+g_q+nodo.hbiblioteca+g_q+
         '        AND T.pCCLASE = '+g_q+nodo.hclase+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.hCPROG = T.pCPROG AND '+
         ' PRIOR T.hCBIB = T.pCBIB AND '+
         ' PRIOR T.hCCLASE = T.pCCLASE');
      if numero_registros>5000 then begin
         if application.MessageBox('Involucra más de 5000 registros, desea exportar a formato texto separado por comas?','Aviso',MB_YESNO)=IDYES then
            dm.exporta_texto('Diagrama de Componentes',
               'select level,pcprog,pcbib,pcclase,hcprog,hcbib,hcclase '+
               ' FROM TSRELA t '+
               ' START WITH T.pCPROG = '+g_q+nodo.hnombre+g_q+
               '        AND T.pCBIB = '+g_q+nodo.hbiblioteca+g_q+
               '        AND T.pCCLASE = '+g_q+nodo.hclase+g_q+
               ' CONNECT BY NOCYCLE '+
               ' PRIOR T.hCPROG = T.pCPROG AND '+
               ' PRIOR T.hCBIB = T.pCBIB AND '+
               ' PRIOR T.hCCLASE = T.pCCLASE',
               'select hcprog,hcbib,hcclase,count(*) '+
               ' FROM TSRELA t '+
               ' START WITH T.pCPROG = '+g_q+nodo.hnombre+g_q+
               '        AND T.pCBIB = '+g_q+nodo.hbiblioteca+g_q+
               '        AND T.pCCLASE = '+g_q+nodo.hclase+g_q+
               ' CONNECT BY NOCYCLE '+
               ' PRIOR T.hCPROG = T.pCPROG AND '+
               ' PRIOR T.hCBIB = T.pCBIB AND '+
               ' PRIOR T.hCCLASE = T.pCCLASE'+
               ' group by T.hcprog,T.hcbib,T.hcclase');
         exit;
      end;
      }
      //fmBloques[ iArreglo ] := TfmBloques.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmBloques[ iArreglo ] := TfmBloques.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmBloques[ iArreglo ] := TfmBloques.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      
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
   icont,ierror: integer;  //alk out of system
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

      //fmDigraSistema[ iArreglo ] := TfmDigraSistema.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      ierror:=0;
      try
         fmDigraSistema[ iArreglo ] := TfmDigraSistema.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmDigraSistema[ iArreglo ] := TfmDigraSistema.Create( Self );
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------
      fmDigraSistema[ iArreglo ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmDigraSistema[ iArreglo ].Width := g_Width;
         fmDigraSistema[ iArreglo ].Height := g_Height;
      end;


      deletefile(g_tmpdir + '\SIS_'+Nodo.hnombre+'.ini');

      fmDigraSistema[ iArreglo ].PubGeneraDiagrama( Nodo.hclase, Nodo.hbiblioteca, Nodo.hnombre, sTitulo );
      fmDigraSistema[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tfarbol.detalle_tabla( Sender: TObject );
var
   Nodo: ^Tmyrec;
   cm_compo, cm_bib, cm_sis, cm_cla, titulo : String;
   lslCompo: Tstringlist;
   icont,ierror: integer;  //alk out of system
   det:TalkFormDetTab;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;

   lslCompo := Tstringlist.Create;
   Nodo := nodo_actual.Data;
   //nombre bib clase sistema
   lslCompo.Add(Nodo.hnombre);
   lslCompo.Add(Nodo.hbiblioteca);
   lslCompo.Add(Nodo.hclase);
   lslCompo.Add(Nodo.sistema);

   if lslCompo.Count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta nombre ó biblioteca ó clase ' ) ),
         pchar( dm.xlng( 'Detalle de Tabla' ) ), MB_OK );
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   titulo := sDETALLE_TABLA+' '+lslCompo[0]+' '+lslCompo[1]+' '+lslCompo[2]+' '+lslCompo[3];
   if gral.bPubVentanaActiva( titulo ) then begin
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   try
      //det:=TalkFormDetTab.create(nil);
      // ------ ALK para controlar el error out of system resources ------
      ierror:=0;
      try
         det:=TalkFormDetTab.create(nil);
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     det:=TalkFormDetTab.create(nil);
                  except
                     on E: exception do
                        ierror:=1;
                  end;
               end
               else
                  break;  //si ya no hay error, ya lo genero, salgo del ciclo
            end;  //fin for
         end;
      end;

      if ierror = 1 then begin
         MessageDlg('No se pudo generar el producto, por favor vuelva a intentarlo.',mtInformation,[mbOk],0);
         exit;
      end;
      // ----------------------------------------------------------------

      det.FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         det.Width := g_Width;
         det.Height := g_Height;
      end;

      if not det.arma_tabla(lslCompo,titulo) then
         exit;

      det.Show;

      dm.PubRegistraVentanaActiva( titulo );
   finally
      lslCompo.free;
      //det.Free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tfarbol.codigoMuerto(Sender: Tobject);  // funcion que manda llamar a la general para el codigo muerto
var
   Nodo: ^Tmyrec;
   cm_compo, cm_bib, cm_sis, cm_cla : String;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );

   try
      Nodo := nodo_actual.Data;

      cm_compo:=Nodo.hnombre;
      cm_bib:=Nodo.hbiblioteca;
      cm_sis:=Nodo.sistema;
      cm_cla:=Nodo.hclase;

      ptscomun.codigo_muerto(cm_sis,cm_compo,cm_bib,cm_cla);
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

//  ALK funcion para borrar los elementos que ya no se usan
procedure Tfarbol.borra_elemento_a(nombre:string ; producto : integer);
var
   i : integer;
begin

   if farbol=nil then
      exit;

   case  producto of
   1 :       //lista de dependencias
   begin
      for i := length( aPriListaDependencias )-1 downto 0 do begin
         if aPriListaDependencias[i].Caption = nombre then
            aPriListaDependencias[i]:=nil;
      end;
   end;

   2 :       //analisis de impacto
   begin
      for i := length( fmAnalisisImpacto )-1 downto 0 do begin
         if fmAnalisisImpacto[i].Caption = nombre then
            fmAnalisisImpacto[i]:=nil;
      end;
   end;

   3 :       //diagrama de procesos
   begin
      for i := length( fmProcesos )-1 downto 0 do begin
         if fmProcesos[i].Caption = nombre then
            fmProcesos[i]:=nil;
      end;
   end;

   4 :       //Diagrama Scheduler
   begin
      for i := length( fmScheduler )-1 downto 0 do begin
         if fmScheduler[i].Caption = nombre then
            fmScheduler[i]:=nil;
      end;
   end;

   5 :       //diagrama de bloques
   begin
      for i := length( fmBloques )-1 downto 0 do begin
         if fmBloques[i].Caption = nombre then
            fmBloques[i]:=nil;
      end;
   end;

   6 :       //matriz de archivos logicos
   begin
      for i := length( fmMatrizArchLog )-1 downto 0 do begin
         if fmMatrizArchLog[i].Caption = nombre then
            fmMatrizArchLog[i]:=nil;
      end;
   end;

   7 :       //diagrama de flujo interactivo CBL
   begin
      for i := length( fmgflcob )-1 downto 0 do begin
         if fmgflcob[i].Caption = nombre then
            fmgflcob[i]:=nil;
      end;
   end;

   8 :       //referencias cruzadas
   begin
      for i := length( ftsrefcruz )-1 downto 0 do begin
         if ftsrefcruz[i].Caption = nombre then
            ftsrefcruz[i]:=nil;
      end;
   end;

   9 :       //mapa natural
   begin
      for i := length( ftsmapanat )-1 downto 0 do begin
         if ftsmapanat[i].Caption = nombre then
            ftsmapanat[i]:=nil;
      end;
   end;

   10 :       //
   begin
      for i := length( fmgflrpg )-1 downto 0 do begin
         if fmgflrpg[i].Caption = nombre then
            fmgflrpg[i]:=nil;
      end;
   end;

   11 :       //diagrama jcl
   begin
      for i := length( ftsdiagjcl )-1 downto 0 do begin
         if ftsdiagjcl[i].Caption = nombre then
            ftsdiagjcl[i]:=nil;
      end;
   end;

   12 :       //Lista de componentes
   begin
      for i := length( fmListaCompo )-1 downto 0 do begin
         if fmListaCompo[i].Caption = nombre then begin
            //fmListaCompo[i].Free;
            fmListaCompo[i]:=nil;
         end;
      end;
   end;

   13 :       //Matriz crud
   begin
      for i := length( afmMatrizCrud )-1 downto 0 do begin
         if afmMatrizCrud[i].Caption = nombre then
            afmMatrizCrud[i]:=nil;
      end;
   end;

   14 :       //
   begin
      for i := length( ftsscrsec )-1 downto 0 do begin
         if ftsscrsec[i].Caption = nombre then
            ftsscrsec[i]:=nil;
      end;
   end;

   {  FALTAN estos productos que no estan con el try
ftsproperty
ftsattribute
ftsbms
ftsversionado
ftsarchivos
ftsdghtml
ftsviewhtml
fmUMLPaquetes        diagrama paquetes
fmUMLClases          diagrama clases
fmDocumentacion      documentacion
fmListaDrill         lista Drill Down/Up
fmDigraSistema  }

   end;
end;


end.


