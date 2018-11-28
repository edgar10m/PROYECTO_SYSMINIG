unit ptsgral;

interface
uses
   classes, ADODB, InvokeRegistry, ImgList, Controls, Menus, Rio, SOAPHTTPClient, DB, StdCtrls,
   Windows, Messages, Variants, Forms, Dialogs, Buttons, winsock, strutils, comctrls, shellapi,
   svsdelphi, ExcelXP, ComObj, OleServer, Graphics, OleCtrls, SHDocVw, jpeg, ExtCtrls, ExtDlgs,
   tlhelp32, mgflcob, mgflrpg, ufmMatrizAF, ptsmapanat, Grids, ptsproperty, ptsdghtml,
   ptsversionado, ptspanel, parbol, ptsbms, ptsinventario, ptsdiagjcl, ptsattribute, dxBar,
   HTML_HELP, Excel97, pstviewhtml, uConstantes, ufmAnalisisImpacto, ufmProcesos, ptsscrsec,
   ufmBloques, ufmListaDependencias, ufmListaCompo, ufmMatrizCrud, UfmRefCruz,
   ufmDocumentacion, dxStatusBar, ufmMatrizArchLog, uDiagramaRutinas,ufmListaDrill, ptscomun,
   alkScheduler,ufmScheduler,alkDetTab,ptsestatica, Excel2000;

type
   Tclasecolor = record
      clase: string;
      color: string;
   end;
type
   Tcompon = record
      clase: string;
      bib: string;
      prog: string;
      ren: integer;
      col: integer;
      desplaza: integer;
   end;
type
   Tgral = class( TForm )
      jquery: TMemo;
      jquery_fixer: TMemo;
      q6: TADOQuery;
      Memo: TMemo;
      htt: THTTPRIO;
      MainMenu1: TMainMenu;
      Ventana1: TMenuItem;
      Ayuda1: TMenuItem;
      Salir: TMenuItem;
      Procesos: TImageList;
      Memo1: TMemo;
      ExcelApplication1: TExcelApplication;
      ColorDialog1: TColorDialog;
      PopGral: TPopupMenu;
      ventanas1: TPopupMenu;
      MBuscaAyuda: TMemo;
      PopGral00: TPopupMenu;
      Item: TMenuItem;
      SubItem: TMenuItem;
      Productos: TMemo;
      procedure poparchivoPopup( Sender: TObject );

   private
      { Private declarations }
      fmb_nombre_pantalla: string;
      //Aftsimpacto: array of Tftsimpacto;
      //Aftsdgcompo: array of Tftsdgcompo;
      //Aftsdocumenta: array of Tftsdocumenta;
      fmDocumentacion: array of TfmDocumentacion;
      fmAnalisisImpacto: array of TfmAnalisisImpacto; //diagrama analisis impacto
      fmProcesos: array of TfmProcesos; //diagrama procesos
      fmScheduler: array of TfmScheduler; //scheduler
      fmBloques: array of TfmBloques; //diagrama de bloques //isaac
      fmMatrizArchLog: array of TfmMatrizArchLog; //Matriz de  archvios lógicos
      Aftsarchivos: array of TfmMatrizAF;
      Afmgflcob: array of Tfmgflcob;
      Aftsbms: array of Tftsbms;
      //      Aftsrefcruz: array of Tftsrefcruz;                      //framirez
      Aftsrefcruz: array of TfmRefCruz; //framirez
      Aftsdocumenta: array of TfmDocumentacion;
      Aftsproperty: array of Tftsproperty;
      Aftsattribute: array of Tftsattribute;
      Aftsmapanat: array of Tftsmapanat;
      Aftsversionado: array of Tftsversionado;
      Afmgflrpg: array of Tfmgflrpg;
      Aftsdghtml: array of Tftsdghtml;
      Aftsdiagjcl: array of Tftsdiagjcl;
      //      Aftslistacompo: array of Tftslistacompo;                   //framirez
      //      AftslistaDependencias: array of TftslistaDependencias;     //framirez
      //      Aftstablas: array of Tftstablas;                          //framirez
      fmListaCompo: array of TfmListaCompo; //framirez
      AfmListaDependencias: array of TfmListaDependencias; //framirez
      afmMatrizCrud: array of TfmMatrizCrud; //framirez
      Aftsgral: array of Tgral;
      Aftsviewhtml: array of Tftsviewhtml;
      Aftsscrsec: array of Tftsscrsec;
      fmListaDrill : array of TfmListaDrill;   //ALK
      ftsestatica: array of Tftsestatica; // validaciones estaticas

      //AfmMatrizArchLog: array of TfmMatrizArchLog; //matriz archivo logico
      Opciones: Tstringlist;
   public
      { Public declarations }
   //memo_componente: string; //validar funcionalidad memo_componente
      clase_fisico, clase_descripcion,
         clase_todas, clase_descripcion_todas,
         clase_analizable: Tstringlist;
      WInicio: Tstringlist;
      WFin: Tstringlist;
      E_texto, E_gral,
         subtitulo: string;
      bPriExisteFrm: Boolean;
      sPubArchivoXLS: String; //aqui juanita

      pReg_ocprog: string;
      pReg_ocbib: string;
      pReg_occlase: string;
      pReg_pnombre: string;
      pReg_pbiblioteca: string;
      pReg_pclase: string;
      pReg_hnombre: string;
      pReg_hbiblioteca: string;
      pReg_hclase: string;
      pReg_hijo_falso: boolean;
      pReg_registros: integer;
      pReg_sistema: string;
      pReg_orden: string;

      bc,ec,ignore:string;   // variables para mgflcob

      procedure CreaTablas( );
      procedure CargaRutinasjs( );
      procedure CargaLogo( WnomLogo: string );
      procedure CargaIconosBasicos( );
      procedure CargaIconosClases( );
      function TextoFracc( texto: string; pos: integer; lon: integer ): string;
      procedure BorraLogo( Wnomlogo: string );
      procedure BorraRutinasjs( );
      procedure BorraIconosTmp( );
      procedure BorraIconosBasicos( );
      function sql1select( tabla: tADOquery; sele: string ): boolean;
      function ValidaAntesAgregar( opcion: string; Xclase: string; Xbiblioteca: string; Xnombre: string ): boolean;
      function ArmarMenuConceptualWeb( b1: string; nomproc: string ): Tstringlist;
      function ArmarMenuGpoCompWeb( b1: tstringlist; nomproc: string ): tstringlist;
      function ArmarOpcionSubMenu( b1: Tstringlist; Objeto: integer ): integer;

      procedure analisis_impacto( Sender: TObject );
      procedure diagramaproceso( Sender: TObject );
      procedure tabla_crud( Sender: TObject );
      procedure archivos_fisicos( Sender: TObject );
      procedure archivos_logicos( Sender: TObject );
      //procedure diagramacobol( Sender: TObject );
      procedure diagramaVisustin( Sender: TObject );     //alk para diagramar visustin, antes diagramacobol
      procedure diagramacbl( Sender: TObject );
      procedure diagramacblx( );
      //procedure diagramacbly( );
      function rut_svsflcob( nombre: string; bib: string; clase: string; fuente: string; salida: string; texto: string ): string;
      procedure referencias_cruzadas( Sender: TObject );
      //Procedure reglas_negocio(Sender: TObject);
      procedure Documentacion( Sender: Tobject ); //documentacion
      procedure lista_componentes( Sender: TObject );
      procedure vista_htm( Sender: TObject );
      procedure vista_tsc( Sender: TObject );
      procedure lista_Dependencias( Sender: TObject );
      procedure propiedades( Sender: TObject );
      procedure atributos( Sender: TObject );
      procedure formadelphi_preview( Sender: TObject );
      procedure formavb_preview( Sender: TObject );
      procedure panel_preview( Sender: TObject );
      procedure natural_mapa_preview( Sender: TObject );
      procedure diagramanatural( Sender: TObject );
      procedure diagramanaturalx( );
      procedure versionado( Sender: TObject );
      procedure fmb_vista_pantalla( Sender: TObject );
      procedure diagramarpg( Sender: TObject );
      procedure diagramarpgx( );
      procedure diagramaFlujoCBL( Sender: TObject );   //alk para diagramador nuevo CBL
      procedure diagramaFlujoWFL( Sender: TObject );
      procedure diagramaFlujoAlgol( Sender: TObject );
      procedure diagramaFlujoTMC( Sender: TObject );
      procedure diagramaFlujoTMP( Sender: TObject );
      procedure diagramaFlujoDCL( Sender: TObject );
      procedure diagramaFlujoBSC( Sender: TObject );
      procedure diagramaFlujoOSQ( Sender: TObject );
      procedure diagramaJerarquicoOSQ( Sender: TObject );
      procedure diagramaJerarquicoAlgol( Sender: TObject );
      procedure diagramaJerarquicoWFL( Sender: TObject );
      procedure diagramaJerarquicoCBL( Sender: TObject );
      //procedure diagramaJerarquicoBSC( Sender: TObject );
      procedure diagramaGenDiagramas( sParProducto, sParTipoDiagrama: String );
      procedure detalle_tabla( Sender: TObject );

      procedure codigoMuerto( Sender: TObject );   // funcion para el codigo muerto
      procedure validEstaticas( Sender: TObject );   // funcion para validaciones estaticas
      function rut_dghtml( nombre: string; bib: string; clase: string;
         fuente: string; salida: string; texto: string ): string;
      function rut_svsflrpg( nombre: string; bib: string; clase: string;
         fuente: string; salida: string; texto: string ): string;
      procedure dghtml( Sender: TObject );
      procedure dghtmlx( );
      procedure dghtmly( );
      procedure adabas_crud( Sender: TObject );
      procedure diagramajcl( Sender: TObject );
      procedure diagramaase( Sender: TObject );
      procedure bms_preview( Sender: TObject );
      procedure Ver_Fuente( Sender: TObject );
      procedure ListaDrillDown( Sender: Tobject ); //lista Drill Down    ALK
      procedure ListaDrillUp( Sender: Tobject ); //lista Drill Up     ALK
      procedure arma_fuente( sistema: string; compo: string; bib: string; clase: string; Wnom_pro: string );
      function GetModName: string;
      procedure EjecutaOpcionB( b1: Tstringlist; tex: string );
      procedure EjecutaOpcionGpoComp( b1: Tstringlist; tex: string );
      procedure EjecutaOpcionSubMenu( b1s: Tstringlist; tex: string; objeto: integer );
      procedure exporta( Sender: TObject );
      procedure exportaProc( Sender: TObject );
      procedure exportaJCL( Sender: TObject );
      function CambiaColor( ): string;
      procedure CambiaColorClase( Sender: TObject );
      procedure para_ver_pantalla( sistema: string; compo: string; bib: string; clase: string );
      procedure ActualizaColorClase( );
      procedure MantenimientoCapacidades( );
      procedure ArmaArregloAnalizables( );
      function HexToInt( HexNum: string ): LongInt;
      procedure CambiaValorObjeto( );
      procedure ActivaSoloClasesUsadas( );
      procedure SQL_ActivaClases( Wclase: string );
      function CONTROL_ACCESO( ): boolean;
      function EsNumerico( const S: string ): Boolean;
      procedure LimpiaInventario( );
      procedure JerarquiaClases( tipo : integer );
      procedure GetImagen00( );
      procedure LetrasDeUnidades( TS: TStringList );
      procedure BuscaUnidadLibre( );
      function bPubVentanaActiva( sParCaption: string ): Boolean;
      procedure PubMuestraProgresBar( bParVisible: Boolean );
      procedure PubAvanzaProgresBar;
      function iPubEstiloActivo: TdxBarManagerStyle;
      procedure PubEstiloActivo( var PardxStatusBar: TdxStatusBar );
      function iPubVentanasActivas: Integer;
      procedure PubExpandeMenuVentanas( bParExpande: Boolean );
      function bPubVentanaMaximizada: Boolean;
      function bPubConsultaActiva( sParCaption: string; sParFechaHora: string ): Boolean;
      procedure CargaAyudaBusca;
      procedure BorraAyudaBusca;
      procedure aisla_rutina_Visual_Basic_PopUp( nombre: string; FteTodo: Tstringlist );
      procedure CompElegido( Sender: TObject );
      procedure Scheduler( Sender: TObject );
      procedure DiagramaBloques( Sender: TObject );
      function extrae_rutina( Nombre: string; LineaInicio: Integer; LineaFinal: Integer; memo: Tstrings ): string;
      procedure CapacidadXProducto;

      function clases_p_listas():TStringList;  //para que de las clases que deben de llevar las listas dep y comp para arbol/gral
      procedure borra_elemento(nombre:string; producto : integer); //funcion ALK para borrar de la lista, por el momento solo es para lista dependencias

   end;

var
   gral: Tgral;
   ren: integer = 0;
   desplaza: integer = 0;
   es_bbva: boolean = false;
   es_linea: boolean = false;
   xbas: Tstringlist;
   Warmo_arreglos: integer = 0;
   ControEleccion: Integer;
   l_b3: Tstringlist;
   JX: Integer;

implementation
uses
   ptsdm, psvsfmb, sysutils, ptsbfr, ptsmain, HtmlHlp,ufmDigraSistema,alkJerCla;
//isvsserver1,

{$R *.dfm}

function Tgral.CONTROL_ACCESO( ): boolean;
var
   Wfech: string;
begin
   if dm.sqlselect( dm.q1, 'select * from tslogon where cuser=' + g_q + g_usuario + g_q + ' and fecha_salida IS NULL' ) = false then begin
      Wfech := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
      g_fecha_entrada := Wfech;
      if dm.sqlinsert( 'insert into tslogon (cuser,fecha_entrada,fecha_salida,control_tiempo) values(' +
         g_q + g_usuario + g_q + ',' + Wfech + ',NULL,NULL)' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede insertar en  tslogon' ) ),
            pchar( dm.xlng( 'Control Acceso de usuarios' ) ), MB_OK );
         application.Terminate;
         abort;
      end;
   end;
   CONTROL_ACCESO := TRUE
end;

procedure Tgral.CreaTablas( );
begin
   {// Para  prototipo de casos de uso (temporal)
      if dm.verifica_base('cucasouso')=false then begin
         if dm.sqlinsert('create table cucasouso('+
            ' CCASOUSO    VARCHAR2(100) NOT NULL,'+
            ' VERSION     VARCHAR2(100) NOT NULL,'+
            ' NOMBRE      VARCHAR2(100) NOT NULL,'+
            ' DESCRIPCION VARCHAR2(500),'+
            ' FECHA       DATE NOT NULL,'+
            ' CREADOPOR   VARCHAR2(100) NOT NULL,'+
            ' CSISTEMA    VARCHAR2(30) NOT NULL,'+
            ' CPROG       VARCHAR2(250) NOT NULL,'+
            ' CBIB        VARCHAR2(250)NOT NULL,'+
            ' CCLASE      VARCHAR2(10) NOT NULL,'+
            ' RUTAIMAGEN  VARCHAR2(100))') = false then begin
            showmessage('ERROR... no puede crear cucasouso');
            application.Terminate;
            abort;
         end;
      end;}
end;

procedure Tgral.CargaRutinasjs( );
begin
   {   jquery.Lines.SaveToFile( g_tmpdir + '\jquery.js' );
      jquery_fixer.Lines.SaveToFile( g_tmpdir + '\jquery.fixer.js' );
      BorraRutinasjs;
   }
end;

procedure Tgral.CargaAyudaBusca( );
begin
   MBuscaAyuda.Lines.SaveToFile( g_tmpdir + '\AyudaBusca.html' );
   BorraAyudaBusca;
end;

procedure Tgral.BorraAyudaBusca( );
var
   arch: string;
begin
   arch := g_tmpdir + '\AyudaBusca.html';
   g_borrar.Add( arch );
end;

procedure Tgral.BorraRutinasjs( );
var
   arch: string;
begin
   arch := g_tmpdir + '\jquery.js';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\jquery.fixer.js';
   g_borrar.Add( arch );
end;

procedure Tgral.CargaLogo( WnomLogo: string );
begin
   g_ext := '';
   if dm.sqlselect( dm.q1, 'select descripcion from tsutileria' +
      ' where cutileria = ' + g_q + 'LOGO_EMPRESA' + g_q ) then begin
      g_ext := copy( dm.q1.fieldbyname( 'descripcion' ).AsString,
         pos( '.', dm.q1.fieldbyname( 'descripcion' ).AsString ),
         pos( '.', dm.q1.fieldbyname( 'descripcion' ).AsString ) + 3 );
   end;
   dm.get_utileria( 'LOGO_EMPRESA', g_tmpdir + '\' + WnomLogo + g_ext );
end;

procedure Tgral.BorraLogo( WnomLogo: string );
var
   arch: string;
begin
   arch := g_tmpdir + '\' + WnomLogo + g_ext;
   g_borrar.Add( arch );
end;

procedure Tgral.CargaIconosBasicos( );
begin
   dm.get_utileria( 'ICONO_TICK', g_tmpdir + '\ICONO_TICK.ico' );
   dm.get_utileria( 'ICONO_NO', g_tmpdir + '\ICONO_NO.ico' );
   BorraIconosBasicos;
end;

{
procedure Tgral.CargaIconosBasicos( );
var
   imagen: Ticon;
begin
   tyr
      dm.Imgs.GetIcon( 3, imagen );
      dm.imgs.i
   finally
      imagen.free;
   end
   //dm.get_utileria( 'ICONO_TICK', g_tmpdir + '\ICONO_TICK.ico' );
   //dm.get_utileria( 'ICONO_NO', g_tmpdir + '\ICONO_NO.ico' );
   BorraIconosBasicos;
end;
 }

procedure Tgral.BorraIconosBasicos( );
var
   arch: string;
begin
   arch := g_tmpdir + '\ICONO_TICK.ico';
   g_borrar.Add( arch );
   arch := g_tmpdir + '\ICONO_NO.ico';
   g_borrar.Add( arch );
end;

procedure Tgral.CargaIconosClases( );
begin
   if sql1select( q6, 'select * from parametro where clave like ' + g_q + 'ICONO_%' + g_q ) then begin
      while not q6.Eof do begin
         dm.blob2file( q6.fieldbyname( 'dato' ).AsString, g_tmpdir + '\' + q6.fieldbyname( 'clave' ).AsString + '.ico' );
         g_borrar.Add(g_tmpdir + '\' + q6.fieldbyname( 'clave' ).AsString + '.ico' );
         q6.Next;
      end;
      BorraIconosTmp;
   end;
end;

procedure Tgral.BorraIconosTmp( );
var
   arch: string;
begin //Adiciona a la lista de Borra de ..\tmp...
   if sql1select( q6, 'select * from parametro where clave like ' + g_q + 'ICONO_%' + g_q ) then begin
      while not q6.Eof do begin
         arch := g_tmpdir + '\' + q6.fieldbyname( 'clave' ).AsString + '.ico';
         g_borrar.Add( arch );
         q6.Next;
      end;
   end;
end;

function Tgral.TextoFracc( texto: string; pos: integer; lon: integer ): string;
begin
   TextoFracc := copy( trim( texto ), pos, lon ) + '?' +
      copy( trim( texto ), ( lon * 1 + 1 ), lon ) + '?' +
      copy( trim( texto ), ( lon * 2 + 1 ), lon ) + '?' +
      copy( trim( texto ), ( lon * 3 + 1 ), lon ) + '?' +
      copy( trim( texto ), ( lon * 4 + 1 ), lon ) + '?' +
      copy( trim( texto ), ( lon * 5 + 1 ), lon ) + '?' +
      copy( trim( texto ), ( lon * 6 + 1 ), lon ) + '?' +
      copy( trim( texto ), ( lon * 7 + 1 ), lon ) + '?' +
      copy( trim( texto ), ( lon * 8 + 1 ), lon );
end;

function Tgral.sql1select( tabla: tADOquery; sele: string ): boolean;
begin
   try
      tabla.close;
      tabla.sql.clear;
      tabla.sql.add( sele );
      tabla.open;
      if tabla.EOF then
         sql1select := False
      else
         sql1select := true;
   except
      on E: exception do begin
         Application.MessageBox( pchar( 'ERROR SQL: ' + sele + ' - ' + E.Message ),
            pchar( 'Menaje1 de SQLSELECT' ), MB_OK );
         sql1select := false;
      end;
   end;
end;

function Tgral.ValidaAntesAgregar( opcion: string; Xclase: string; Xbiblioteca: string; Xnombre: string ): boolean;
begin
   if ( opcion = sLISTA_REF_CRUZADAS )
      or ( opcion = sLISTA_COMPONENTES ) then begin
      if dm.sqlselect( dm.q1, 'select hcprog,hcbib,hcclase,orden from tsrela ' +
         ' where pcprog=' + g_q + Xnombre + g_q +
         ' and pcbib=' + g_q + Xbiblioteca + g_q +
         ' and pcclase=' + g_q + Xclase + g_q +
         ' and hcclase<>' + g_q + 'STE' + g_q +
         ' union ' +
         ' select hcprog,hcbib,hcclase,orden from tsrela ' +
         ' where (pcprog,pcbib,pcclase) in ' +
         '   (select hcprog,hcbib,hcclase from tsrela ' +
         '    where pcprog=' + g_q + Xnombre + g_q +
         '    and pcbib=' + g_q + Xbiblioteca + g_q +
         '    and pcclase=' + g_q + Xclase + g_q +
         '    and hcclase=' + g_q + 'STE' + g_q + ')' +
         ' order by orden' ) then begin
         //if dm.q1.recordcount > 0 then begin
         ValidaAntesAgregar := true;
         exit;
         //end;
      end;
   end;
   ValidaAntesAgregar := false;
end;

function Tgral.ArmarMenuConceptualWeb( b1: string; nomproc: string ): Tstringlist;
var
   panta: Tfsvsdelphi;
   m: Tstringlist;
   k: Tstringlist;
   aux,arma_alk: string;
   aux_i :integer;
   clases_listas : TStringList;  // para las clases de las listas dep y comp ALK
begin
   ArmaArregloAnalizables( );
   // Al dar de alta una opción debe cuidarse el orden alfabét
   //_____________________________________________________________
   bgral := stringreplace( trim( b1 ), '|', ' ', [ rfReplaceAll ] );
   bgral := stringreplace( trim( bgral ), '¿', ' ', [ rfReplaceAll ] );
   m := Tstringlist.Create;
   k := Tstringlist.Create;
   clases_listas := Tstringlist.Create;  //alk
   m.CommaText := bgral; //nombre bib clase sistema
   if ( m.Count < 3 ) then begin
      Application.MessageBox( pchar( 'Falta nombre ó biblioteca ó clase ' ),
         pchar( 'Armar menú conceptual' ), MB_OK );
      ArmarMenuConceptualWeb := k;
      m.Free;
      exit;
   end;
   //  desglosando string para encontrar el error ALK
   aux_i:=clase_todas.IndexOf( m[ 2 ] );
   if aux_i = -1 then begin
      ShowMessage('Clase inactiva, revisar en la base de datos tabla tsclase');
      exit;
   end;

   aux:=  clase_descripcion_todas[ clase_todas.IndexOf( m[ 2 ] ) ];
   arma_alk:=arma_alk+aux;
   aux:= '|-|' + m[ 2 ] + '|' + m[ 1 ] + '|' + m[ 0 ] + ',' ;
   arma_alk:=arma_alk+aux;
   aux:= inttostr( k.count - 1 );
   arma_alk:=arma_alk+aux;
   aux:= stringreplace(arma_alk , ' ', '|', [ rfReplaceAll ] );
   arma_alk:= aux+ '|' + m[ 3 ];                // El error era que no existe un indice m[3]

   if clase_todas.IndexOf( m[ 2 ] ) > -1 then begin
      k.add( arma_alk );
      k.add( '-,-' + ',' + inttostr( k.count - 1 ) );
   end;

   clases_listas := clases_p_listas;

   if ( m[ 2 ] = 'NVW' ) or
      ( m[ 2 ] = 'NIN' ) or
      ( m[ 2 ] = 'NUP' ) or
      ( m[ 2 ] = 'NDL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'CRUD|ADABAS,adabas_crud' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'ADABAS|CRUD,adabas_crud' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( g_usuario = 'ADMIN' ) or ( g_usuario = 'SVS' ) then begin
      if m[ 2 ] <> 'USERPRO' then begin
         if nomproc = 'analisis_impacto' then begin
            if g_language = 'ENGLISH' then
               k.add( 'Color,CambiaColorClase' + ',' + inttostr( k.count - 1 ) )
            else
               k.add( 'Cambia|Color|Clase,CambiaColorClase' + ',' + inttostr( k.count - 1 ) );
         end;
      end;
   end;

   if dm.sqlselect( dm.q1, 'select * from tsrela ' +
      ' where hcprog=' + g_q + m[ 0 ] + g_q +
      ' and   hcbib=' + g_q + m[ 1 ] + g_q +
      ' and   hcclase=' + g_q + m[ 2 ] + g_q +
      ' and   atributos is not null ' )
      or
      dm.sqlselect( dm.q1, 'select * from tsrela ' +
      ' where ocprog=' + g_q + m[ 0 ] + g_q +
      ' and   ocbib=' + g_q + m[ 1 ] + g_q +
      ' and   occlase=' + g_q + m[ 2 ] + g_q +
      ' and   pcclase=' + g_q + 'CLA' + g_q +
      ' and   hcprog=' + g_q + m[ 0 ] + g_q +
      ' and   hcbib=' + g_q + m[ 1 ] + g_q +
      ' and   hcclase=' + g_q + m[ 2 ] + g_q +
      ' and   orden=' + g_q + '0001' + g_q +
      ' and   atributos is not null' ) then begin
      pReg_ocprog := dm.q1.fieldbyname( 'ocprog' ).AsString;
      pReg_ocbib := dm.q1.fieldbyname( 'ocbib' ).AsString;
      pReg_occlase := dm.q1.fieldbyname( 'occlase' ).AsString;
      pReg_pnombre := dm.q1.fieldbyname( 'pcprog' ).AsString;
      pReg_pbiblioteca := dm.q1.fieldbyname( 'pcbib' ).AsString;
      pReg_pclase := dm.q1.fieldbyname( 'pcclase' ).AsString;
      pReg_hnombre := dm.q1.fieldbyname( 'hcprog' ).AsString;
      pReg_hbiblioteca := dm.q1.fieldbyname( 'hcbib' ).AsString;
      pReg_hclase := dm.q1.fieldbyname( 'hcclase' ).AsString;
      pReg_sistema := dm.q1.fieldbyname( 'sistema' ).AsString;
      pReg_orden := dm.q1.fieldbyname( 'orden' ).AsString;

      if g_language = 'ENGLISH' then
         k.add( 'Attributes,atributos' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Atributos,atributos' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] <> 'USERPRO' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Impact|Analysis,analisis_impacto' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Análisis|de|Impacto,analisis_impacto' + ',' + inttostr( k.count - 1 ) );
   end;

   if ((m[ 2 ] = 'CBL') or (m[ 2 ] = 'CMA')) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Diagrama|de|Bloques,diagrama_bloques' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Bloques,diagrama_bloques' + ',' + inttostr( k.count - 1 ) );
   end;

   // ----------------  Para codigo muerto  -------------------
   if ((m[ 2 ] = 'CBL') or (m[ 2 ] = 'CMA')) and
      dm.capacidad('MENU CONTEXTUAL CODIGO MUERTO')then begin
      if g_language = 'ENGLISH' then
         k.add( 'Dead|code,codigo_muerto' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Codigo|muerto,codigo_muerto' + ',' + inttostr( k.count - 1 ) );
   end;
   // ---------------------------------------------------------

   // ----------------  Para validaciones estaticas  -------------------
   if m[ 2 ] = 'CBL' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Validaciones|estáticas,validaciones_estaticas' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Validaciones|estáticas,validaciones_estaticas' + ',' + inttostr( k.count - 1 ) );
   end;
   // ---------------------------------------------------------

   // --------- ALK para clases NEP y NEG -------------
   {if ( m[ 2 ] = 'NEG' ) or
      ( m[ 2 ] = 'NEP' ) or
      ( m[ 2 ] = 'CBL' ) then begin}
   if (m[2] <> '') and
      dm.capacidad('MENU CONTEXTUAL DRILL DOWN')  then begin
      if g_language = 'ENGLISH' then begin
         k.add( 'Drill|Down,ListaDrillDown' + ',' + inttostr( k.count - 1 ) );
      end
      else begin
         k.add( 'Drill|Down,ListaDrillDown' + ',' + inttostr( k.count - 1 ) );
      end;
   end;
   if (m[2] <> '') and
      dm.capacidad('MENU CONTEXTUAL DRILL UP')  then begin
      if g_language = 'ENGLISH' then begin
         k.add( 'Drill|Up,ListaDrillUp' + ',' + inttostr( k.count - 1 ) );
      end
      else begin
         k.add( 'Drill|Up,ListaDrillUp' + ',' + inttostr( k.count - 1 ) );
      end;
   end;
   {if ( m[ 2 ] = 'NEP' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Impact|Analysis,analisis_impact' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Análisis|de|Impacto,analisis_impact' + ',' + inttostr( k.count - 1 ) );
   end;  }
   // -------------------------------------------------

   if ( m[ 2 ] = 'NAT' ) or
      ( m[ 2 ] = 'NSP' ) or
      ( m[ 2 ] = 'NSR' ) or
      ( m[ 2 ] = 'NHL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramanatural' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo,diagramanatural' + ',' + inttostr( k.count - 1 ) );
   end;

   if ((m[ 2 ] = 'CBL') or (m[ 2 ] = 'CMA')) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramacbl' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|interactivo,diagramacbl' + ',' + inttostr( k.count - 1 ) );     //cambio ALK
   end;
   if ((m[ 2 ] = 'CBL') or (m[ 2 ] = 'CMA')) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoCBL' + ',' + inttostr( k.count - 1 ) )   //k.add( 'Flowchart,diagramaVisustin' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|COBOL,diagramaFlujoCBL' + ',' + inttostr( k.count - 1 ) );  //k.add( 'Diagrama|de|Flujo|COBOL,diagramaVisustin' + ',' + inttostr( k.count - 1 ) );
   end;
   if ((m[ 2 ] = 'CBL') or (m[ 2 ] = 'CMA')) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoCBL' + ',' + inttostr( k.count - 1 ) )   //k.add( 'Flowchart,diagramaVisustin' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|Jerárquico|COBOL,diagramaJerarquicoCBL' + ',' + inttostr( k.count - 1 ) );  //k.add( 'Diagrama|de|Flujo|COBOL,diagramaVisustin' + ',' + inttostr( k.count - 1 ) );
   end;
   if m[ 2 ] = 'OSQ' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoOSQ' + ',' + inttostr( k.count - 1 ) )   //k.add( 'Flowchart,diagramaVisustin' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|OSQ,diagramaFlujoOSQ' + ',' + inttostr( k.count - 1 ) );  //k.add( 'Diagrama|de|Flujo|COBOL,diagramaVisustin' + ',' + inttostr( k.count - 1 ) );
   end;
   if m[ 2 ] = 'OSQ' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaJerarquicoOSQ' + ',' + inttostr( k.count - 1 ) )   //k.add( 'Flowchart,diagramaVisustin' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|eventos|OSQ,diagramaJerarquicoOSQ' + ',' + inttostr( k.count - 1 ) );  //k.add( 'Diagrama|de|Flujo|COBOL,diagramaVisustin' + ',' + inttostr( k.count - 1 ) );
   end;
   if m[ 2 ] = 'CPY' then begin
      //k.add( 'Diagrama|de|Flujo|Copy|COBOL,diagramaVisustin' + ',' + inttostr( k.count - 1 ) );
      k.add( 'Diagrama|de|Flujo|Copy|CPY,diagramaFlujoCBL' + ',' + inttostr( k.count - 1 ) );
   end;
   if m[ 2 ] = 'DCL' then begin
      k.add( 'Diagrama|de|Flujo|DCL,diagramaFlujoDCL' + ',' + inttostr( k.count - 1 ) );
   end;
   //  ALK para el diagrama de flujo TDC
   if m[ 2 ] = 'TDC' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaVisustin' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|C,diagramaVisustin' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] = 'CLP' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramarpg' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo,diagramarpg' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'JOB' ) or
      ( m[ 2 ] = 'JCL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramajcl' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo,diagramajcl' + ',' + inttostr( k.count - 1 ) );
   end;

   //alk para diagrama visustin
   if ( m[ 2 ] = 'JOB' ) or
      ( m[ 2 ] = 'JCL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,DiagramaVisustin' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|con|comentarios,diagramaVisustin' + ',' + inttostr( k.count - 1 ) );
   end;
   //----------------------------

   if ( m[ 2 ] = 'WFL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoWFL' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|WFL,diagramaFlujoWFL' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'WFL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaJerarquicoWFL' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|Jerarquico|WFL,diagramaJerarquicoWFL' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'BSC' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoBSC' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|BSC,diagramaFlujoBSC' + ',' + inttostr( k.count - 1 ) );
   end;

   {if ( m[ 2 ] = 'BSC' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaJerarquicoBSC' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|Jerarquico|BSC,diagramaJerarquicoBSC' + ',' + inttostr( k.count - 1 ) );
   end;}

   if ( m[ 2 ] = 'ALG' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoAlgol' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|ALGOL,diagramaFlujoAlgol' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'ALG' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaJerarquicoAlgol' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|Jerarquico|ALGOL,diagramaJerarquicoAlgol' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'TMC' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoTMC' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|MACRO|TANDEM,diagramaFlujoTMC' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'TMP' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaFlujoTMP' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo|MACROS|PATHWAY,diagramaFlujoTMP' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'ASE' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Flowchart,diagramaase' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Flujo,diagramaase' + ',' + inttostr( k.count - 1 ) );
   end;

   if (m[2] <> 'FIL') and
      (m[2] <> 'CTM') and
      (m[2] <> 'CTR') then
      if g_language = 'ENGLISH' then
         k.add( 'Process Flowchart,diagramaproceso' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|de|Componentes,diagramaproceso' + ',' + inttostr( k.count - 1 ) );        //antes diagrama de proceso

   if g_language = 'ENGLISH' then
      k.add( 'Documentation,Documentacion' + ',' + inttostr( k.count - 1 ) )
         //k.add( 'Documentation,reglas_negocio' + ',' + inttostr( k.count - 1 ) )
   else
      k.add( 'Documentación|externa,Documentacion' + ',' + inttostr( k.count - 1 ) );
   //k.add( 'Documentación,reglas_negocio' + ',' + inttostr( k.count - 1 ) );

   // -------------- Cambio ALK para que aparezcan las listas ------------------
   //if clase_analizable.IndexOf( m[ 2 ] ) > -1 then begin
  { if (clase_analizable.IndexOf( m[ 2 ] ) > -1) or (m[ 2 ] = 'ETP') or (m[ 2 ] = 'TSE')
       or (m[ 2 ] = 'CTM') then begin    //provisional para que aparezca menu completo   ALK
      if g_language = 'ENGLISH' then
         k.add( 'Parts|List,lista_componentes' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Lista|de|Componentes,lista_componentes' + ',' + inttostr( k.count - 1 ) );
   end;   }
   //if clase_analizable.IndexOf( m[ 2 ] ) > -1 then begin
   {if (clase_analizable.IndexOf( m[ 2 ] ) > -1) or (m[ 2 ] = 'ETP') or (m[ 2 ] = 'TSE')
       or (m[ 2 ] = 'CTM') then begin }      //provisional para que aparezca menu completo  ALK
   if clases_listas.IndexOf(m[2])= -1 then begin
      if g_language = 'ENGLISH' then begin
         k.add( 'Parts|List,lista_dependencias' + ',' + inttostr( k.count - 1 ) );
         k.add( 'Parts|List,lista_componentes' + ',' + inttostr( k.count - 1 ) );
      end
      else begin
         k.add( 'Lista|Dependencias|de|Componentes,lista_dependencias' + ',' + inttostr( k.count - 1 ) );
         k.add( 'Lista|de|Componentes,lista_componentes' + ',' + inttostr( k.count - 1 ) );
      end;
   end;
   // ------------------------------------------------------------------------------------

   if ( m[ 2 ] = 'TAB' ) or
      ( m[ 2 ] = 'INS' ) or
      ( m[ 2 ] = 'UPD' ) or
      ( m[ 2 ] = 'DEL' ) or
      ( m[ 2 ] = 'IDX' ) or
      ( m[ 2 ] = 'SEL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'CRUD|Table,tabla_crud' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Matriz|CRUD,tabla_crud' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'FIL' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'CRUD|Files,archivos_fisicos' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Matriz|Archivos|Físicos,archivos_fisicos' + ',' + inttostr( k.count - 1 ) );
   end;

   {if ( m[ 2 ] = 'LOC' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'CRUD|Files,archivos_logicos' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Matriz|Archivos|Lógicos,archivos_logicos' + ',' + inttostr( k.count - 1 ) );
   end;  }

   if g_language = 'ENGLISH' then
      k.add( 'Properties,propiedades' + ',' + inttostr( k.count - 1 ) )
   else
      k.add( 'Propiedades,propiedades' + ',' + inttostr( k.count - 1 ) );

   //   if ( nomproc <> 'referencias_cruzadas' )    JCR
   //      and ( nomproc <> 'tabla_crud' ) then begin // esto es porque esta armando el menu para referencias cruzadas


   if ( m[ 1 ] <> 'BD' ) and
      {( copy(m[ 1 ],1,4)  <> 'DISK' ) and }
      ( m[ 1 ] <> 'LOCAL' ) and
      ( m[2] <> 'CTM') and
      ( m[2] <> 'CTR') then begin
      if g_language = 'ENGLISH' then
         k.add( 'Cross|Reference,referencias_cruzadas' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Referencias|Cruzadas,referencias_cruzadas' + ',' + inttostr( k.count - 1 ) );
   end;
   //   end;   JCR

   if m[ 2 ] = 'DFM' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Preview,formadelphi_preview' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Referencias|Cruzadas,referencias_cruzadas' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] = 'PNL' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Preview,panel_preview' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Vista|Previa,panel_preview' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] = 'HTM' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Preview,vista_htm' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Vista|Previa,vista_htm' + ',' + inttostr( k.count - 1 ) );
   end;

   k.add( 'Ver|Fuente,Ver_Fuente' + ',' + inttostr( k.count - 1 ) );

   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where objeto=' + g_q + 'FISICO' + g_q +
      ' and cclase=' + g_q + m[ 2 ] + g_q +
      ' order by cclase' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Versions,versionado' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Versiones,versionado' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] = 'TSC' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Preview,vista_tsc' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Vista|Previa,vista_tsc' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] = 'NMP' then begin // Mapa Natural
      if g_language = 'ENGLISH' then
         k.add( 'Preview,natural_mapa_preview' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Vista|Previa,natural_mapa_preview' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] = 'BMS' then begin // Pantalla CICS
      if g_language = 'ENGLISH' then
         k.add( 'Preview,bms_preview' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Vista|Previa,bms_preview' + ',' + inttostr( k.count - 1 ) );
   end;

   if m[ 2 ] = 'FMB' then begin // Pantalla de SQLFORMS
      if g_language = 'ENGLISH' then
         k.add( 'Screen|View,fmb_vista_pantalla' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Vista|Pantalla,fmb_vista_pantalla' + ',' + inttostr( k.count - 1 ) );
      fmb_nombre_pantalla := dm.pathbib( m[ 1 ], m[ 2 ] ) + '\' + m[ 0 ] + '.txt';
   end;

   if m[ 2 ] = 'BFR' then begin
      if g_language = 'ENGLISH' then
         k.add( 'Preview,formavb_preview' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Vista|Previa,formavb_preview' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'CTR' ) or ( m[ 2 ] = 'CTM' ) then begin
      if g_language = 'ENGLISH' then
         k.add( 'Scheduler,scheduler' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Diagrama|Scheduler,scheduler' + ',' + inttostr( k.count - 1 ) );
   end;

   if ( m[ 2 ] = 'TAB' ) or
      ( m[ 2 ] = 'INS' ) or
      ( m[ 2 ] = 'UPD' ) or
      ( m[ 2 ] = 'DEL' ) or
      ( m[ 2 ] = 'SEL' ) then begin    //detalle campos de la tabla
      if g_language = 'ENGLISH' then
         k.add( 'Detail,detalle_tabla' + ',' + inttostr( k.count - 1 ) )
      else
         k.add( 'Detalle|de|Tabla,detalle_tabla' + ',' + inttostr( k.count - 1 ) );
   end;

   ArmarMenuConceptualWeb := k;
   clases_listas.Free;
end;

procedure Tgral.EjecutaOpcionB( b1: Tstringlist; tex: string );
var
   i, p, j: integer;
   b2: Tstringlist;
   t, NomProg: string;
   tt: Tmenuitem;
   k: integer;
   ks: string;
begin
   if b1 = nil then exit;
   
   g_texto := tex;
   p := b1.Count;
   b2 := Tstringlist.Create;
   gral.PopGral.Items.Clear;
   for j := 0 to p - 1 do begin
      b2.clear;
      b2.CommaText := b1[ j ];
      tt := Tmenuitem.Create( gral.PopGral );
      tt.Caption := stringreplace( b2[ 0 ], '|', ' ', [ rfReplaceAll ] );
      NombreProceso := stringreplace( b2[ 1 ], '|', ' ', [ rfReplaceAll ] );
      t := '  ' + stringreplace( b2[ 0 ], '|', ' ', [ rfReplaceAll ] );
      gral.PopGral.Items.Add( tt );
      k := gral.PopGral.Items.Count - 1;
      gral.PopGral.Images := dm.ImageList3;
      if Nombreproceso = 'formadelphi_preview' then begin
         gral.PopGral.Items[ k ].OnClick := formadelphi_preview;
         continue;
      end;
      if Nombreproceso = 'formavb_preview' then begin
         gral.PopGral.Items[ k ].OnClick := formavb_preview;
         continue;
      end;
      if Nombreproceso = 'panel_preview' then begin
         gral.PopGral.Items[ k ].OnClick := panel_preview;
         continue;
      end;
      if Nombreproceso = 'natural_mapa_preview' then begin
         gral.PopGral.Items[ k ].OnClick := natural_mapa_preview;
         continue;
      end;
      if Nombreproceso = 'diagramanatural' then begin
         gral.PopGral.Items[ k ].OnClick := diagramanatural;
         continue;
      end;
      if Nombreproceso = 'analisis_impacto' then begin
         gral.PopGral.Items[ k ].OnClick := analisis_impacto;
         gral.PopGral.Items[ K ].ImageIndex := 12;
         continue;
      end;
      if Nombreproceso = 'diagramaproceso' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaproceso;
         gral.PopGral.Items[ K ].ImageIndex := 9;
         continue;
      end;
      if Nombreproceso = 'referencias_cruzadas' then begin
         gral.PopGral.Items[ k ].OnClick := referencias_cruzadas;
         gral.PopGral.Items[ K ].ImageIndex := 13;
         continue;
      end;
      if Nombreproceso = 'Documentacion' then begin
         gral.PopGral.Items[ k ].OnClick := Documentacion;
         continue;
      end;
      //if Nombreproceso='reglas_negocio'       then begin gral.PopGral.Items[k].OnClick:=reglas_negocio;        continue; end;
      if Nombreproceso = 'versionado' then begin
         gral.PopGral.Items[ k ].OnClick := versionado;
         continue;
      end;
      if Nombreproceso = 'fmb_vista_pantalla' then begin
         gral.PopGral.Items[ k ].OnClick := fmb_vista_pantalla;
         continue;
      end;
      if Nombreproceso = 'vista_htm' then begin
         gral.PopGral.Items[ k ].OnClick := vista_htm;
         continue;
      end;
      if Nombreproceso = 'vista_tsc' then begin
         gral.PopGral.Items[ k ].OnClick := vista_tsc;
         continue;
      end;
      if Nombreproceso = 'bms_preview' then begin
         gral.PopGral.Items[ k ].OnClick := bms_preview;
         continue;
      end;
      if Nombreproceso = 'diagramacbl' then begin
         gral.PopGral.Items[ k ].OnClick := diagramacbl;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaVisustin' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaVisustin;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      //alk para diagramador nuevo CBL
      if Nombreproceso = 'diagramaFlujoCBL' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoCBL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaJerarquicoCBL' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaJerarquicoCBL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaFlujoOSQ' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoOSQ;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaJerarquicoOSQ' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaJerarquicoOSQ;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaFlujoDCL' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoDCL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaFlujoWFL' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoWFL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaJerarquicoWFL' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaJerarquicoWFL;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaFlujoBSC' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoBSC;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      {if Nombreproceso = 'diagramaJerarquicoBSC' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaJerarquicoBSC;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;}
      if Nombreproceso = 'diagramaFlujoAlgol' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoAlgol;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;

      if Nombreproceso = 'diagramaFlujoTMC' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoTMC;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'diagramaFlujoTMP' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaFlujoTMP;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;

      if Nombreproceso = 'diagramaJerarquicoAlgol' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaJerarquicoAlgol;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;

      if Nombreproceso = 'dghtml' then begin
         gral.PopGral.Items[ k ].OnClick := dghtml;
         continue;
      end;
      if Nombreproceso = 'diagramarpg' then begin
         gral.PopGral.Items[ k ].OnClick := diagramarpg;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'tabla_crud' then begin
         gral.PopGral.Items[ k ].OnClick := tabla_crud;
         gral.PopGral.Items[ K ].ImageIndex := 5;
         continue;
      end;
      if Nombreproceso = 'archivos_fisicos' then begin
         gral.PopGral.Items[ k ].OnClick := archivos_fisicos;
         gral.PopGral.Items[ K ].ImageIndex := 5;
         continue;
      end;
      {if Nombreproceso = 'archivos_logicos' then begin
         gral.PopGral.Items[ k ].OnClick := archivos_logicos;
         gral.PopGral.Items[ K ].ImageIndex := 5;
         continue;
      end;  }
      if Nombreproceso = 'adabas_crud' then begin
         gral.PopGral.Items[ k ].OnClick := adabas_crud;
         gral.PopGral.Items[ K ].ImageIndex := 5;
         continue;
      end;
      if Nombreproceso = 'diagramajcl' then begin
         gral.PopGral.Items[ k ].OnClick := diagramajcl;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;

      if Nombreproceso = 'diagramaase' then begin
         gral.PopGral.Items[ k ].OnClick := diagramaase;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'lista_componentes' then begin
         gral.PopGral.Items[ k ].OnClick := lista_componentes;
         gral.PopGral.Items[ K ].ImageIndex := 4;
         Continue;
      end;
      if Nombreproceso = 'lista_dependencias' then begin
         gral.PopGral.Items[ k ].OnClick := lista_dependencias;
         gral.PopGral.Items[ K ].ImageIndex := 4;
         Continue;
      end;
      if Nombreproceso = 'propiedades' then begin
         gral.PopGral.Items[ k ].OnClick := propiedades;
         continue;
      end;
      if Nombreproceso = 'atributos' then begin
         gral.PopGral.Items[ k ].OnClick := atributos;
         continue;
      end;
      if Nombreproceso = 'Ver_Fuente' then begin
         gral.PopGral.Items[ k ].OnClick := Ver_Fuente;
         gral.PopGral.Items[ K ].ImageIndex := 14;
         continue;
      end;
      if Nombreproceso = 'exporta' then begin
         gral.PopGral.Items[ k ].OnClick := exporta;
         continue;
      end;
      if Nombreproceso = 'exportaProc' then begin
         gral.PopGral.Items[ k ].OnClick := exportaProc;
         continue;
      end;
      if Nombreproceso = 'exportaJCL' then begin
         gral.PopGral.Items[ k ].OnClick := exportaJCL;
         continue;
      end;
      if Nombreproceso = 'CambiaColorClase' then begin
         gral.PopGral.Items[ k ].OnClick := CambiaColorClase;
         gral.PopGral.Items[ K ].ImageIndex := 11;
         continue;
      end;
      if Nombreproceso = 'scheduler' then begin
         gral.PopGral.Items[ k ].OnClick := scheduler;
         gral.PopGral.Items[ K ].ImageIndex := 17;
         continue;
      end;
      if Nombreproceso = 'detalle_tabla' then begin
         gral.PopGral.Items[ k ].OnClick := detalle_tabla;
         //gral.PopGral.Items[ K ].ImageIndex := 17;
         continue;
      end;
      if Nombreproceso = 'diagrama_bloques' then begin
         gral.PopGral.Items[ k ].OnClick := DiagramaBloques;
         gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'codigo_muerto' then begin
         gral.PopGral.Items[ k ].OnClick := codigoMuerto;
         //gral.PopGral.Items[ K ].ImageIndex := 10;
         continue;
      end;
      if Nombreproceso = 'validaciones_estaticas' then begin
         gral.PopGral.Items[ k ].OnClick := validEstaticas;
         continue;
      end;
      if Nombreproceso = 'ListaDrillDown' then begin
         gral.PopGral.Items[ k ].OnClick := ListaDrillDown;
         gral.PopGral.Items[ K ].ImageIndex := 4;
         continue;
      end;
      if Nombreproceso = 'ListaDrillUp' then begin
         gral.PopGral.Items[ k ].OnClick := ListaDrillUp;
         gral.PopGral.Items[ K ].ImageIndex := 4;
         continue;
      end;
   end;
   b2.Free;
end;

procedure Tgral.analisis_impacto( Sender: TObject );
var
   m: Tstringlist;
   k1: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   iHelpContext := 2400;
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta clase ó biblioteca ó nombre' ),
            pchar( sDIGRA_AIMPACTO ), MB_OK );
         exit;
      end;
      titulo := sDIGRA_AIMPACTO + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k1 := length( fmAnalisisImpacto );
      setlength( fmAnalisisImpacto, k1 + 1 );
      {
      numero_registros:=dm.cuenta_registros('select count(*) '+
         ' FROM TSRELA t '+
         ' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.hCPROG = '+g_q+m[0]+g_q+
         '        AND T.hCBIB = '+g_q+m[1]+g_q+
         '        AND T.hCCLASE = '+g_q+m[2]+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.pCPROG = T.hCPROG AND '+
         ' PRIOR T.pCBIB = T.hCBIB AND '+
         ' PRIOR T.pCCLASE = T.hCCLASE');
      if numero_registros>5000 then begin
         showmessage('Involucra más de 5000 registros('+inttostr(numero_registros)+')');
      }
      // ------ ALK para controlar el error out of system resources ------
      try
         fmAnalisisImpacto[ k1 ] := TfmAnalisisImpacto.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmAnalisisImpacto[ k1 ] := TfmAnalisisImpacto.Create( Self );
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

      fmAnalisisImpacto[ k1 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmAnalisisImpacto[ k1 ].Width := g_Width;
         fmAnalisisImpacto[ k1 ].Height := g_Height;
      end;

      fmAnalisisImpacto[ k1 ].PubGeneraDiagrama( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ], titulo );
      fmAnalisisImpacto[ k1 ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.diagramaproceso( Sender: TObject );
var
   m: Tstringlist;
   k1: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
   numero_registros:integer;
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //clase bib componente
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta nombre ó biblioteca ó clase' ),
            pchar( sDIGRA_PROCESOS ), MB_OK );
         exit;
      end;
      titulo := sDIGRA_PROCESOS + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;
      {
      numero_registros:=dm.cuenta_registros('select count(*) '+
         ' FROM TSRELA t '+
         //' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.pCPROG = '+g_q+m[0]+g_q+
         '        AND T.pCBIB = '+g_q+m[1]+g_q+
         '        AND T.pCCLASE = '+g_q+m[2]+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.hCPROG = T.pCPROG AND '+
         ' PRIOR T.hCBIB = T.pCBIB AND '+
         ' PRIOR T.hCCLASE = T.pCCLASE');
      if numero_registros>5000 then begin
         showmessage('Involucra más de 5000 registros('+inttostr(numero_registros)+')');
         exit;
      end;
      }
      k1 := length( fmProcesos );
      setlength( fmProcesos, k1 + 1 );

      //fmProcesos[ k1 ] := TfmProcesos.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmProcesos[ k1 ] := TfmProcesos.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmProcesos[ k1 ] := TfmProcesos.Create( Self );
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

      fmProcesos[ k1 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmProcesos[ k1 ].Width := g_Width;
         fmProcesos[ k1 ].Height := g_Height;
      end;

      fmProcesos[ k1 ].PubGeneraDiagrama( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ], titulo );
      fmProcesos[ k1 ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.tabla_crud( Sender: TObject );
var
   m: Tstringlist;
   k1: integer;
   TCnombre: string;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta nombre ó biblioteca ó clase' ),
            pchar( sLISTA_MATRIZ_CRUD ), MB_OK );
         exit;
      end;
      titulo := sLISTA_MATRIZ_CRUD + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      {if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;    }

      k1 := length( afmMatrizCrud );
      setlength( afmMatrizCrud, k1 + 1 );

      //afmMatrizCrud[ k1 ] := TfmMatrizCrud.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         afmMatrizCrud[ k1 ] := TfmMatrizCrud.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     afmMatrizCrud[ k1 ] := TfmMatrizCrud.Create( Self );
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

      afmMatrizCrud[ k1 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         afmMatrizCrud[ k1 ].Width := g_Width;
         afmMatrizCrud[ k1 ].Height := g_Height;
      end;

      TCNombre := '';
      TCNombre := m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      afmMatrizCrud[ k1 ].tipo := m[ 2 ];//'TAB';
      afmMatrizCrud[ k1 ].prepara2( m[ 0 ], m[ 3 ] );
      afmMatrizCrud[ k1 ].titulo := titulo;
      afmMatrizCrud[ k1 ].arma3( m[ 0 ], m[ 3 ] );
      afmMatrizCrud[ k1 ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.archivos_fisicos( Sender: TObject );
var
   m: Tstringlist;
   k1: integer;
   TCnombre: string;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta nombre ó biblioteca ó clase' ),
            pchar( sMATRIZ_ARCHIVOS_FIS ), MB_OK );
         exit;
      end;
      titulo := sMATRIZ_ARCHIVOS_FIS + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      {if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;}

      k1 := length( Aftsarchivos );
      setlength( Aftsarchivos, k1 + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsarchivos[ k1 ] := TfmMatrizAF.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsarchivos[ k1 ] := TfmMatrizAF.Create( Self );
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
      
      
      Aftsarchivos[ k1 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         Aftsarchivos[ k1 ].Width := g_Width;
         Aftsarchivos[ k1 ].Height := g_Height;
      end;

      TCNombre := '';
      TCNombre := m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      Aftsarchivos[ k1 ].tipo := m[ 2 ];
      Aftsarchivos[ k1 ].prepara( m[ 0 ], m[ 3 ] );
      Aftsarchivos[ k1 ].titulo := titulo;
      Aftsarchivos[ k1 ].arma( m[ 0 ], m[ 3 ] );
      Aftsarchivos[ k1 ].Show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.archivos_logicos( Sender: TObject );
var
   m: Tstringlist;
   k1: integer;
   sTitulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta nombre ó biblioteca ó clase' ),
            pchar( sMATRIZ_ARCHIVO_LOG ), MB_OK );
         exit;
      end;
      sTitulo := sMATRIZ_ARCHIVO_LOG + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      {if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;  }

      k1 := length( fmMatrizArchLog );
      setlength( fmMatrizArchLog, k1 + 1 );

      //fmMatrizArchLog[ k1 ] := TfmMatrizArchLog.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmMatrizArchLog[ k1 ] := TfmMatrizArchLog.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmMatrizArchLog[ k1 ] := TfmMatrizArchLog.Create( Self );
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

      fmMatrizArchLog[ k1 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmMatrizArchLog[ k1 ].Width := g_Width;
         fmMatrizArchLog[ k1 ].Height := g_Height;
      end;

      fmMatrizArchLog[ k1 ].PubGeneraLista( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ], sTitulo );
      fmMatrizArchLog[ k1 ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.diagramacbl( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   diagramacblx;
   screen.Cursor := crdefault;
end;

//procedure Tgral.diagramacobol( Sender: TObject );
procedure Tgral.diagramaVisustin( Sender: TObject );          //alk
var
   lsNomCompo, lsArchFte: String;
   lslFuente, lslCompo: Tstringlist;
   i: integer;
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

   lslCompo := Tstringlist.Create;
   lslCompo.CommaText := bgral; //nombre bib clase
   if lslCompo.Count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta nombre ó biblioteca ó clase ' ) ),
         pchar( dm.xlng( 'Diagrama de flujo COBOL' ) ), MB_OK );
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   if lslcompo[ 1 ] = 'SCRATCH' then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
         pchar( dm.xlng( 'Diagrama de flujo COBOL' ) ), MB_OK );
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   lslFuente := Tstringlist.Create;
   if dm.trae_fuente( lslCompo[ 3 ], lslCompo[ 0 ], lslCompo[ 1 ], lslCompo[ 2 ], lslFuente ) = False then begin      //sis, comp, bib,cla
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
         pchar( dm.xlng( 'Diagrama de flujo COBOL ' ) ), MB_OK );
      lslFuente.Free;
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;
   lsNomCompo := lslCompo[ 0 ];
   bGlbQuitaCaracteres( lsNomCompo );
   //Obtener fuente
   lsArchFte := g_tmpdir + '\' + lsNomCompo + '.txt';
   lslFuente.SaveToFile( lsArchFte );
   //Obtener la carpeta de destino: mis documentos       //ALK
   sRutaMisDocumentos := GlbObtenerRutaMisDocumentos;
   sDirClase := sRutaMisDocumentos + '\Informes\';
//   farbol.GenerarDiagrama( lsNomCompo, lsArchFte );
//   farbol.GenerarDiagrama( lsNomCompo, lsArchFte, lslCompo[ 2 ]); //ultimo parametro clase
   bCreaDgrFlujo := GLbCreaDiagramaFlujo(                             //generar el diagrama (uDiagramaRutinas)
                              lslCompo[ 2 ], lslCompo[ 1 ],lslCompo[ 0 ],
                              lsArchFte,    //fuente
                              sDirClase,          //carpeta de salida
                              sDirClase + lsNomCompo + '.pdf' );      //salida pdf
   if bCreaDgrFlujo then    //si lo creo correctamente, abrirlo
         ShellExecute( 0, 'open', pchar( lsNomCompo+'.pdf' ), nil, PChar( sDirClase ), SW_SHOW );

   lslCompo.Free;
   lslFuente.Free;
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tgral.diagramacblx( );
var
   mux, directivas, reservadas, rgmlang, salida, hora: string;
   fte, cop, m: Tstringlist;
   i, k: integer;
   ff: string;
   f: file of Byte;
   fcreado,fmodificado,faccesado,futileria:Tdatetime;

   procedure checa_parametros_extra;
   var
      txtextra:string;
   begin
      txtextra:='';
      bc:='08';
      ec:='72';
      ignore:='07';
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'chkextra_' + m[3] + '_' + m[2] + '_' + m[1] + g_q+
         ' and   dato='+g_q+'TRUE'+g_q) then begin
         if dm.sqlselect(dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'EXTRA_MINING_' +  m[3] +'_'+ m[2] +'_'+m[1] + g_q) then
            txtextra := dm.q1.fieldbyname('dato').AsString;
      end;
      {
      else
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'EXTRA_MINING_' + m[2] + g_q) then
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
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase sistema
   if m.Count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta nombre ó biblioteca ó clase ' ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      m.free;
      exit;
   end;

   if m[ 1 ] = 'SCRATCH' then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      m.free;
      exit;
   end;

   //----------------- RGM20141112 para mantener archivos intermedios
   hora := formatdatetime( 'YYYYMMDDhhnnss', now );
   rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   directivas := g_tmpdir + '\hta' + hora + '.dir';
   reservadas := g_tmpdir + '\hta' + hora + '.res';
   ff := g_tmpdir + '\hta' + hora + '.tmp'; 
   dm.get_utileria( 'COBOLFLOW', directivas );
   fte := Tstringlist.Create;
   // Checa si trae parámetros extra
   checa_parametros_extra;
   mux:=g_tmpdir+'\fte_'+ptscomun.cprog2bfile(m[3]+'_'+m[0]+'_'+m[1]+'_'+m[2]+'.src');
   salida:=mux+'.sal';
   if (fileexists(mux)) and (fileexists(salida)) then begin
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
            ' where cprog='+g_q+m[0]+g_q+
            ' and   cbib='+g_q+m[1]+g_q+
            ' and   cclase='+g_q+m[2]+g_q) then begin
            if (dm.q1.FieldByName('fecha').AsDateTime<fmodificado)
               and (futileria<fmodificado)
               and (k>0) then begin   // si la fecha del componente es menor a la fecha del archivo y el archivo no está vacio
               rut_svsflcob( m[0], m[1], m[2], mux, salida, E_texto); // presenta el diagrama
               exit;                                                                  // y se sale (no regenera el archivo .sal
            end;
         end;
      end;
   end;

   //---------------------------------------------------------------------------

   fte.Clear;
   {
   if memo_componente = m[ 0 ] + '_' + m[ 1 ] then begin
      fte.AddStrings( memo.Lines );
   end
   else begin
      if dm.trae_fuente( m[ 0 ], m[ 1 ],  m[ 2 ], fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
            pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
         fte.Free;
         exit;
      end;
   end;}//validar funcionalidad memo_componente

   if dm.trae_fuente( m[ 3 ], m[ 0 ], m[ 1 ], m[ 2 ], fte ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      fte.Free;
      exit;
   end;

   if dm.sqlselect( dm.q1, 'select distinct hcbib, hcclase from tsrela ' +
      ' where pcprog=' + g_q + m[ 0 ] + g_q +
      ' and   pcbib=' + g_q + m[ 1 ] + g_q +
      ' and   pcclase=' + g_q + m[ 2 ] + g_q +
      ' and   hcclase=' + g_q + 'CPY' + g_q +
      ' and   sistema=' + g_q + m[ 3 ] + g_q ) then begin
      for i := 0 to fte.Count - 1 do begin
         if length( fte[ i ] ) < 8 then
            continue;
         if fte[ i ][ 7 ] <> ' ' then
            continue;
         ff := copy( fte[ i ], 7, 66 );
         k := pos( ' COPY ', uppercase( ff ) );

         //==================
         if k > 0 then
            continue; //  REVISAR CON ROBERTO
         //==================

         if k = 0 then
            continue;
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
         dm.trae_fuente( m[ 3 ], uppercase( ff ), dm.q1.fieldbyname( 'hcbib' ).AsString, dm.q1.fieldbyname( 'hcclase' ).AsString, cop );
         for k := cop.Count - 1 downto 0 do
            fte.Insert( i + 1, cop[ k ] );
         fte[ i ] := copy( fte[ i ], 1, 6 ) + '*' + copy( fte[ i ], 8, 100 );
         cop.Free;
      end;
   end;
   //mux := g_tmpdir + '\fte' + m[ 0 ] + '.src';
   fte.SaveToFile( mux );
   //g_borrar.Add( mux );
   //salida := g_tmpdir + '\sal.sal';
   //SysUtils.deletefile( salida );

   {hora := formatdatetime( 'YYYYMMDDhhnnss', now );
   rgmlang := g_tmpdir + '\hta' + hora + '.exe';
   directivas := g_tmpdir + '\hta' + hora + '.dir';
   reservadas := g_tmpdir + '\hta' + hora + '.res';
   ff := g_tmpdir + '\hta' + hora + '.tmp';}

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
         g_borrar.Add( directivas );
         break;
      end;
   end;
   }
   ff := g_tmpdir + '\hta' + hora + '.nada';
   dm.get_utileria( 'RESERVADAS CBL', reservadas );

   dm.ejecuta_espera( rgmlang + ' ' +
      mux + ' ' +
      ff + ' ' +
      directivas + ' ' +
      reservadas+ ' >'+salida, SW_HIDE );          //reservadas - Archivo de salida

   g_borrar.Add( rgmlang );
   g_borrar.Add( directivas );
   g_borrar.Add( reservadas );
   g_borrar.Add( ff );

   {fte.LoadFromFile( 'sal.sal' );
   fte.SaveToFile( salida );
    }
   //g_borrar.Add( salida );      RGM20141112 para mantener archivos intermedios
   fte.Free;
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + m[ 0 ] + ' ' + m[ 1 ] + ' ' + m[ 2 ] ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      exit;
   end;
   rut_svsflcob( m[ 0 ], m[ 1 ], m[ 2 ], mux, salida, E_texto );
   m.free;
end;

{procedure Tgral.diagramacbly( );
var
   mux: string;
   fte, m: Tstringlist;
   ff: string;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.Count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta nombre ó biblioteca ó clase ' ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      m.free;
      exit;
   end;
   ff := g_tmpdir + '\sal.sal';
   mux := g_tmpdir + '\tmp_' + m[ 2 ];
   fte := Tstringlist.Create; //Clase Bib Nombre
   fte.Text := ( htt as isvsserver ).GetTxt( 'svsget,' + m[ 2 ] + ',' + m[ 1 ] + ',' + m[ 0 ] );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( mux );
   fte.Text := ( htt as isvsserver ).GetTxt( 'svscobolflow,' + m[ 2 ] + ',' + m[ 1 ] + ',' + m[ 0 ] );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( ff );
   fte.Free;
   rut_svsflcob( m[ 2 ], m[ 1 ], m[ 0 ], mux, ff, E_texto );
   deletefile( mux );
   deletefile( ff );
   m.free;
end;}
procedure Tgral.diagramaFlujoCBL;
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_CBL, 'FLUJO' );
end;

procedure tgral.diagramaJerarquicoCBL( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_JERARQUICO_CBL, 'JERARQUICO' );
end;

procedure Tgral.diagramaFlujoOSQ( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_OSQ, 'FLUJO' );
end;

procedure tgral.diagramaJerarquicoOSQ( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_JERARQUICO_OSQ, 'JERARQUICO' );
end;

procedure Tgral.diagramaFlujoDCL;
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_DCL, 'FLUJO' );
end;

procedure Tgral.diagramaFlujoWFL;
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_WFL, 'FLUJO' );
end;

procedure tgral.diagramaJerarquicoWFL( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_JERARQUICO_WFL, 'JERARQUICO' );
end;

procedure Tgral.diagramaFlujoBSC;
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_BSC, 'FLUJO' );
end;

{procedure tgral.diagramaJerarquicoBSC( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_JERARQUICO_BSC, 'JERARQUICO' );
end; }

procedure tgral.diagramaFlujoAlgol( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_ALG, 'FLUJO' );
end;

procedure tgral.diagramaFlujoTMC( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_TMC, 'FLUJO' );
end;

procedure tgral.diagramaFlujoTMP( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_FLUJO_TMP, 'FLUJO' );
end;

procedure tgral.diagramaJerarquicoAlgol( Sender: TObject );
begin
   diagramaGenDiagramas( sDIGRA_JERARQUICO_ALG, 'JERARQUICO' );
end;

function Tgral.rut_svsflcob( nombre: string; bib: string; clase: string;
   fuente: string; salida: string; texto: string ): string;
var
   k: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   PubMuestraProgresBar( True );
   try
      titulo := 'Diagrama de Flujo ' + clase + ' ' + bib + ' ' + nombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( Afmgflcob );
      setlength( Afmgflcob, k + 1 );

      //Afmgflcob[ k ] := Tfmgflcob.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         Afmgflcob[ k ] := Tfmgflcob.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Afmgflcob[ k ] := Tfmgflcob.Create( Self );
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
         Afmgflcob[ k ].Width := g_Width;
         Afmgflcob[ k ].Height := g_Height;
      end;
      //Afmgflcob[ k ].Constraints.MaxWidth := g_MaxWidth;
      Afmgflcob[ k ].caption := titulo;
      Afmgflcob[ k ].titulo := titulo;
      Afmgflcob[ k ].bc := strtoint(bc);
      Afmgflcob[ k ].ec := strtoint(ec);
      Afmgflcob[ k ].ignore := strtoint(ignore);
      Afmgflcob[ k ].arma( fuente, salida, nombre );
      Afmgflcob[ k ].show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.referencias_cruzadas( Sender: TObject );
var
   k: integer;
   m: Tstringlist;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( sLISTA_REF_CRUZADAS + ' ' ) ), MB_OK );
         m.free;
         exit;
      end;

      titulo := sLISTA_REF_CRUZADAS + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;
      k := length( Aftsrefcruz );
      setlength( Aftsrefcruz, k + 1 );

      //Aftsrefcruz[ k ] := TfmRefCruz.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsrefcruz[ k ] := TfmRefCruz.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsrefcruz[ k ] := TfmRefCruz.Create( Self );
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

      Aftsrefcruz[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         Aftsrefcruz[ k ].Width := g_Width;
         Aftsrefcruz[ k ].Height := g_Height;
      end;

      Aftsrefcruz[ k ].titulo := titulo;
      Aftsrefcruz[ k ].arma( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ] );

      if g_procesa then begin //  Esto es para que no muestre la pantalla, si no tiene información.
         Aftsrefcruz[ k ].Show;
      end
      else begin
         if Aftsrefcruz[ k ].FormStyle = fsMDIChild then
            application.MessageBox( pchar( dm.xlng( 'Sin Información para la aplicación.' ) ),
               pchar( dm.xlng( sLISTA_REF_CRUZADAS + ' ' ) ), MB_OK );

         Aftsrefcruz[ k ].Close;
      end;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

function Tgral.GetModName: string;
var
   fName: string;
   nsize: cardinal;
begin
   nsize := 128;
   SetLength( fName, nsize );
   SetLength( fName,
      GetModuleFileName(
      hinstance,
      pchar( fName ),
      nsize ) );
   Result := fName;
end;

{Procedure Tgral.reglas_negocio(Sender: TObject);
var
   m: Tstringlist;
   k: integer;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase

      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Documentación ' ) ), MB_OK );
         exit;
      end;
      titulo := 'Documentación ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( titulo ) then
         Exit;

      k := length( Aftsdocumenta );
      setlength( Aftsdocumenta, k + 1 );
      Aftsdocumenta[ k ] := Tftsdocumenta.Create( Self );
      if gral.bPubVentanaMaximizada = FALSE then begin
         Aftsdocumenta[ k ].Width := g_Width;
         Aftsdocumenta[ k ].Height := g_Height;
      end;
      //Aftsdocumenta[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsdocumenta[ k ].titulo := titulo;
      Aftsdocumenta[ k ].arma( m[ 0 ], m[ 1 ], m[ 2 ] );
      Aftsdocumenta[ k ].show;

      dm.PubRegistraVentanaActiva( titulo );
   finally
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
      m.free;
   end;
end;}

procedure Tgral.Documentacion( Sender: Tobject ); //documentacion
var
   m: Tstringlist;
   k1: integer;
   sTitulo: string;
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //clase bib componente
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta nombre ó biblioteca ó clase' ),
            pchar( sDOCUMENTACION ), MB_OK );
         exit;
      end;
      sTitulo := sDOCUMENTACION + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      k1 := length( fmDocumentacion );
      setlength( fmDocumentacion, k1 + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         fmDocumentacion[ k1 ] := TfmDocumentacion.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmDocumentacion[ k1 ] := TfmDocumentacion.Create( Self );
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
         fmDocumentacion[ k1 ].Width := g_Width;
         fmDocumentacion[ k1 ].Height := g_Height;
      end;

      fmDocumentacion[ k1 ].PubGeneraLista( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ], sTitulo );
      fmDocumentacion[ k1 ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      Screen.Cursor := crdefault;
   end;
end;

procedure Tgral.vista_htm( Sender: TObject );
var
   m: Tstringlist;
   k: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Vista Previa ' ) ), MB_OK );
         exit;
      end;
      titulo := 'Vista Previa ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if ( m[ 1 ] = 'SCRATCH' ) then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ] ) ),
            pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         Exit;
      end;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      //clase, bib, clase
      k := length( Aftsviewhtml );
      setlength( Aftsviewhtml, k + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsviewhtml[ k ] := Tftsviewhtml.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsviewhtml[ k ] := Tftsviewhtml.create( Self );
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
         Aftsviewhtml[ k ].Width := g_Width;
         Aftsviewhtml[ k ].Height := g_Height;
      end;
      //Aftslistacompo[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsviewhtml[ k ].titulo := titulo;
      Aftsviewhtml[ k ].caption := titulo;
      Aftsviewhtml[ k ].arma( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ] );
      if g_existe = 0 then begin
         Aftsviewhtml[ k ].web.Navigate( g_tmpdir + '\' + m[ 0 ] + 'L' );
         Aftsviewhtml[ k ].Show;
         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
      m.free;
   end;
end;

procedure Tgral.vista_tsc( Sender: TObject );
var
   m: Tstringlist;
   k: integer;
   titulo, lBib: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Vista Previa ' ) ), MB_OK );
         exit;
      end;
      titulo := 'Vista Previa ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if ( m[ 1 ] = 'SCRATCH' ) then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ] ) ),
            pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
         Exit;
      end;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      //clase, bib, clase
      k := length( Aftsscrsec );
      setlength( Aftsscrsec, k + 1 );

      //Aftsscrsec[ k ] := Tftsscrsec.create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsscrsec[ k ] := Tftsscrsec.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsscrsec[ k ] := Tftsscrsec.create( Self );
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
         Aftsscrsec[ k ].Width := g_Width;
         Aftsscrsec[ k ].Height := g_Height;
      end;
      //Aftslistacompo[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsscrsec[ k ].titulo := titulo;
      Aftsscrsec[ k ].caption := titulo;
      Aftsscrsec[ k ].Show;
      if dm.sqlselect( dm.q5, 'select * from tsrela where hcclase=' + g_q + m[ 2 ]
         + g_q + ' and hcprog =' + g_q + m[ 0 ] + g_q + ' and sistema =' + g_q + m[ 3 ] + g_q ) then begin
         lBib := dm.pathbib( dm.q5.fieldbyname( 'pcbib' ).AsString, dm.q5.fieldbyname( 'pcclase' ).AsString );
         Aftsscrsec[ k ].pinta( lBib + '\' + dm.q5.fieldbyname( 'pcprog' ).AsString );
         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
      m.free;
   end;
end;

procedure Tgral.lista_componentes( Sender: TObject );
var
   m: Tstringlist;
   k: integer;
   sTitulo: string;
   icont,ierror: integer;  //alk out of system
begin
   Screen.Cursor := crSQLWait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( sLISTA_COMPONENTES + ' ' ) ), MB_OK );
         Exit;
      end;
      if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;
      if m[ 1 ] = 'SCRATCH' then begin
         Application.MessageBox( pchar( 'la biblioteca es ' + m[ 1 ] ),
            pchar( sLISTA_COMPONENTES ), MB_OK );
         Exit;
      end;

      sTitulo := sLISTA_COMPONENTES + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( sTitulo ) then
         Exit;

      k := Length( fmListaCompo );
      SetLength( fmListaCompo, k + 1 );

      //fmListaCompo[ k ] := TfmListaCompo.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmListaCompo[ k ] := TfmListaCompo.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmListaCompo[ k ] := TfmListaCompo.Create( Self );
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

      fmListaCompo[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmListaCompo[ k ].Width := g_Width;
         fmListaCompo[ k ].Height := g_Height;
      end;

      fmListaCompo[ k ].Caption := sTitulo;
      fmListaCompo[ k ].sin_controles(1);  // para que sepa que debe ocultar los paneles de control
      fmListaCompo[ k ].PubGeneraLista( m[ 2 ], m[ 1 ], m[ 0 ], sTitulo, m[ 3 ] );

      fmListaCompo[ k ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.lista_dependencias( Sender: TObject );
var
   m: Tstringlist;
   k: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( sLISTA_DEPENDENCIAS + ' ' ) ), MB_OK );
         exit;
      end;
      if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;
      if m[ 1 ] = 'SCRATCH' then begin
         Application.MessageBox( pchar( dm.xlng( 'la biblioteca es ' + m[ 1 ] ) ),
            pchar( dm.xlng( 'Lista Dependencias ' ) ), MB_OK );
         abort;
      end;

      titulo := sLISTA_DEPENDENCIAS + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( AfmListaDependencias );
      setlength( AfmListaDependencias, k + 1 );

      // ------ ALK para controlar el error out of system resources ------
      try
         AfmListaDependencias[ k ] := TfmListaDependencias.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     AfmListaDependencias[ k ] := TfmListaDependencias.create( Self );
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

      AfmListaDependencias[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = FALSE then begin
         AfmListaDependencias[ k ].Width := g_Width;
         AfmListaDependencias[ k ].Height := g_Height;
      end;

      AfmListaDependencias[ k ].titulo := titulo;
      AfmListaDependencias[ k ].caption := titulo;

      if AfmListaDependencias[ k ].error <> '' then begin     // para error en consulta
         AfmListaDependencias[ k ].Destroy;
         exit;
      end;

      AfmListaDependencias[ k ].sin_controles(1);  // para que sepa que debe ocultar los paneles de control
      try
         AfmListaDependencias[ k ].arma3( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ] );
      except
         on E: exception do begin
            Application.MessageBox( pchar( 'No se pudo generar el producto ' + E.Message ),
                                    pchar( 'AVISO' ), MB_OK );
         end;
      end;

      if ( m[ 1 ] = 'SCRATCH' ) or ( g_procesa = false ) then begin
         Exit;
      end;

      try
         AfmListaDependencias[ k ].Show;
         dm.PubRegistraVentanaActiva( Titulo );
      except
      end;
   finally
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
      m.free;
   end;
end;

procedure Tgral.propiedades( Sender: TObject );
var
   m: Tstringlist;
   k: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Propiedades ' ) ), MB_OK );
         exit;
      end;
      titulo := 'Propiedades ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( Aftsproperty );
      setlength( Aftsproperty, k + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsproperty[ k ] := Tftsproperty.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsproperty[ k ] := Tftsproperty.Create( Self );
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
      
      
      Aftsproperty[ k ].titulo := titulo;
      Aftsproperty[ k ].arma( m[ 0 ], m[ 1 ], m[ 2 ], m[ 3 ] );
      Aftsproperty[ k ].Show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.atributos( Sender: TObject );
var
   m: Tstringlist;
   k: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Atributos ' ) ), MB_OK );
         exit;
      end;
      titulo := 'Atributos ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( Aftsattribute );
      setlength( Aftsattribute, k + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsattribute[ k ] := Tftsattribute.Create( self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsattribute[ k ] := Tftsattribute.Create( self );
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
      
      
      Aftsattribute[ k ].titulo := titulo;
      //      Aftsattribute[ k ].arma( m[ 0 ], m[ 1 ], m[ 2 ] );
      Aftsattribute[ k ].arma_alfa( pReg_ocprog, pReg_ocbib, pReg_occlase, pReg_pnombre,
         pReg_pbiblioteca, pReg_pclase, pReg_hnombre, pReg_hbiblioteca,
         pReg_hclase, pReg_orden, pReg_sistema );
      Aftsattribute[ k ].Show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.formadelphi_preview( Sender: TObject );
var
   panta: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   panta := g_tmpdir + '\delphi_' + m[ 0 ];
   memo.Lines.SaveToFile( panta );
   fsvsdelphi.Close;
   PR_PANTALLA;
   fsvsdelphi.arma_pantalla( panta );
   fsvsdelphi.Show;
   deletefile( panta );
   m.Free;
end;

procedure Tgral.formavb_preview;
var
   panta: string;
   m: Tstringlist;
   titulo: string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      m := Tstringlist.Create;
      m.CommaText := bgral; //nombre bib clase
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      if dm.trae_fuente( m[ 3 ], m[ 0 ], m[ 1 ], m[ 2 ], Memo ) then begin
         panta := g_tmpdir + '\bfr_' + m[ 0 ];
         memo.Lines.SaveToFile( panta );
         //fsvsdelphi.Close;
         Titulo := 'Vista Previa ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
         PR_BFR( panta, Titulo );
         deletefile( panta );
         dm.PubRegistraVentanaActiva( Titulo );
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
            pchar( dm.xlng( 'Vista Previa ' ) ), MB_OK );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      m.free;
      screen.Cursor := crdefault;
   end;

end;

procedure Tgral.panel_preview( Sender: TObject );
var
   panta: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   panta := g_tmpdir + '\panel_' + m[ 0 ];
   memo.Lines.SaveToFile( panta );
   PR_PANEL( panta );
   deletefile( panta );
   //panel_preview := '0,0';
   m.Free;
end;

procedure Tgral.natural_mapa_preview( Sender: TObject );
var
   titulo, archivo: string;
   k: integer;
   m: Tstringlist;
   icont,ierror: integer;  //alk out of system
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Preview Mapa Natural ' ) ), MB_OK );
      m.free;
      exit;
   end;

   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      titulo := 'Mapa Natural ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      k := length( Aftsmapanat );
      setlength( Aftsmapanat, k + 1 );

      //Aftsmapanat[ k ] := Tftsmapanat.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsmapanat[ k ] := Tftsmapanat.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsmapanat[ k ] := Tftsmapanat.Create( Self );
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
         Aftsmapanat[ k ].Width := g_Width;
         Aftsmapanat[ k ].Height := g_Height;
      end;
      //Aftsmapanat[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsmapanat[ k ].titulo := titulo;
      Aftsmapanat[ k ].arma( archivo );
      Aftsmapanat[ k ].Show;
      Aftsmapanat[ k ].Tag := k;
      archivo := g_tmpdir + '\' + m[ 0 ];
      memo.Lines.SaveToFile( archivo );
      g_borrar.Add( archivo );
      m.Free;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.diagramanatural( Sender: TObject );
begin
   diagramanaturalx;
   //   diagramanatural := '0,0';
end;

procedure Tgral.diagramanaturalx( );
var
   datos, mux: string;
   fte: Tstringlist;
   filedot: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.count < 2 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Diagrama Natural ' ) ), MB_OK );
      m.free;
      exit;
   end;
   screen.Cursor := crsqlwait;
   chdir( g_ruta );
   fte := Tstringlist.Create;
   mux := 'fte' + m[ 0 ] + '.src';
   copyfile( pchar( dm.xblobname( m[ 1 ], m[ 0 ], m[ 2 ] ) ), pchar( mux ), false );
   g_borrar.Add( mux );
   dm.get_utileria( 'RGMLANG', 'hta' + mux + '.exe' );
   dm.get_utileria( 'DIRECTIVAS NATURALFLOW', 'hta' + mux + '.dir' );
   dm.get_utileria( 'RESERVADAS NATURALFLOW', 'hta' + mux + '.res' );
   filedot := m[ 0 ] + '.dot';
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
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + bgral ) ),
         pchar( dm.xlng( 'Diagrama de flujo' ) ), MB_OK );
      exit;
   end;
   fte.LoadFromFile( filedot );
   datos := fte.commatext;
   datos := stringreplace( datos, 'º', '\n', [ rfreplaceall ] );
   fte.commatext := datos;
   fte.SaveToFile( filedot );
   fte.Free;
   if ShellExecute( 0, nil, pchar( dm.get_variable( 'PROGRAMFILES' ) + '\' + g_graphviz + '\bin\dotty.exe' ),
      pchar( filedot ), PChar( g_ruta ), SW_SHOW ) <= 32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
         'Error', MB_ICONEXCLAMATION );
   end;
   screen.Cursor := crdefault;
   m.Free;
end;

procedure Tgral.versionado( Sender: TObject );
var
   k: integer;
   titulo: string;
   m: Tstringlist;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase sistema
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Versiones ' ) ), MB_OK );
         exit;
      end;
      titulo := 'Versiones ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( Aftsversionado );
      setlength( Aftsversionado, k + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsversionado[ k ] := Tftsversionado.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsversionado[ k ] := Tftsversionado.Create( Self );
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
         Aftsversionado[ k ].Width := g_Width;
         Aftsversionado[ k ].Height := g_Height;
      end;
      //Aftsversionado[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsversionado[ k ].titulo := titulo;

      if not Aftsversionado[ k ].valida( m[ 0 ], m[ 1 ], m[ 2 ], m[ 3 ] ) then begin
         Aftsversionado[ k ].Close;
         exit;
      end;

      Aftsversionado[ k ].arma( m[ 0 ], m[ 1 ], m[ 2 ], m[ 3 ] );
      Aftsversionado[ k ].show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.fmb_vista_pantalla( Sender: TObject );
begin
   PR_FMB( fmb_nombre_pantalla );
end;

procedure Tgral.diagramarpg( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   diagramarpgx;
   screen.Cursor := crdefault;
end;

procedure Tgral.diagramarpgx( );
var
   mux, directivas, reservadas, rgmlang, salida, hora: string;
   fte: Tstringlist;
   ff: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Diagrama RPG ' ) ), MB_OK );
      m.free;
      exit;
   end;
   fte := Tstringlist.Create;
   {
   if memo_componente = m[ 0 ] + '_' + m[ 1 ] then begin
      fte.AddStrings( memo.Lines );
   end
   else begin
      if dm.trae_fuente( m[ 0 ], m[ 1 ], m[ 2 ], fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
            pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
         fte.Free;
         exit;
      end;
   end;}//validar funcionalidad memo_componente

   if dm.trae_fuente( m[ 3 ], m[ 0 ], m[ 1 ], m[ 2 ], fte ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      fte.Free;
      exit;
   end;

   mux := g_tmpdir + '\fte' + m[ 0 ] + '.src';
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
   fte.LoadFromFile( 'sal.sal' );
   fte.SaveToFile( salida );
   fte.Free;
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + bgral ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      exit;
   end;
   g_borrar.Add( salida );
   rut_svsflrpg( m[ 0 ], m[ 1 ], m[ 2 ], mux, salida, E_texto );
   m.Free;
end;

{procedure Tgral.diagramarpgy( );
var
   mux: string;
   fte: Tstringlist;
   ff: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Diagrama RPG ' ) ), MB_OK );
      m.free;
      exit;
   end;
   ff := g_tmpdir + '\sal.sal';
   mux := g_tmpdir + '\tmp_' + m[ 0 ];
   fte := Tstringlist.Create;
   fte.Text := ( htt as isvsserver ).GetTxt( 'svsget,' + m[ 2 ] + ',' + m[ 1 ] + ',' + m[ 0 ] );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( mux );
   fte.Text := ( htt as isvsserver ).GetTxt( 'svscobolflow,' + m[ 2 ] + ',' + m[ 1 ] + ',' + m[ 0 ] );
   if copy( fte.Text, 1, 7 ) = '<ERROR>' then begin
      showmessage( fte.Text );
      fte.Free;
      exit;
   end;
   fte.SaveToFile( ff );
   fte.Free;
   rut_svsflcob( m[ 0 ], m[ 1 ], m[ 2 ], mux, ff, E_texto );
   deletefile( mux );
   deletefile( ff );
   m.Free;
end;}

function Tgral.rut_svsflrpg( nombre: string; bib: string; clase: string;
   fuente: string; salida: string; texto: string ): string;
var
   k: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True ); //fercar3
   try
      titulo := 'RPG ' + clase + ' ' + bib + ' ' + nombre;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k := length( Afmgflrpg );
      setlength( Afmgflrpg, k + 1 );

      //Afmgflrpg[ k ] := Tfmgflrpg.Create( self );
      // ------ ALK para controlar el error out of system resources ------
      try
         Afmgflrpg[ k ] := Tfmgflrpg.Create( self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Afmgflrpg[ k ] := Tfmgflrpg.Create( self );
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
         Afmgflrpg[ k ].Width := g_Width;
         Afmgflrpg[ k ].Height := g_Height;
      end;
      //Afmgflrpg[ k ].Constraints.MaxWidth := g_MaxWidth;
      Afmgflrpg[ k ].arma( fuente, salida, nombre );
      Afmgflrpg[ k ].show;
      rut_svsflrpg := inttostr( k ) + ',' + '9000';
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.dghtml( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   dghtmlx;
   screen.Cursor := crdefault;
end;

procedure Tgral.dghtmlx( );
var
   mux, directivas, reservadas, rgmlang, salida, hora: string;
   fte: Tstringlist;
   k: integer;
   ff: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //clase bib nombre
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Diagrama  ' ) ), MB_OK );
      m.free;
      exit;
   end;
   screen.Cursor := crsqlwait;

   fte := Tstringlist.Create;
   {
   //bib   nombre
   if memo_componente = m[ 2 ] + '_' + m[ 1 ] then begin
      fte.AddStrings( memo.Lines );
   end
   else begin
      if dm.trae_fuente( m[ 2 ], m[ 1 ], m[ 0 ], fte ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + bgral ) ),
            pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
         fte.Free;
         exit;
      end;
   end;}//validar funcionalidad memo_componente

   if dm.trae_fuente( m[ 3 ], m[ 2 ], m[ 1 ], m[ 0 ], fte ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' + bgral ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      fte.Free;
      exit;
   end;

   mux := g_tmpdir + '\fte' + m[ 2 ] + '.src';
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
   dm.get_utileria( 'JAV_DGHTML', directivas );
   dm.get_utileria( 'RESERVADAS JAV', reservadas );
   dm.ejecuta_espera( rgmlang + ' ' +
      mux + ' ' +
      ff + ' ' +
      directivas + ' ' +
      reservadas + ' >' + salida, SW_HIDE );
   g_borrar.Add( rgmlang );
   g_borrar.Add( directivas );
   g_borrar.Add( reservadas );
   g_borrar.Add( ff );
   fte.LoadFromFile( salida );
   fte.SaveToFile( salida );
   fte.Free;
   if fileexists( salida ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + bgral ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      exit;
   end;
   g_borrar.Add( salida );
   rut_dghtml( m[ 2 ], m[ 1 ], m[ 0 ], mux, salida, E_texto );
   screen.Cursor := crdefault;
end;

procedure Tgral.dghtmly( );
var
   mux: string;
begin
   Application.MessageBox( pchar( dm.xlng( 'No implementado en modo web service' ) ),
      pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
   exit;
end;

function Tgral.rut_dghtml( nombre: string; bib: string; clase: string;
   fuente: string; salida: string; texto: string ): string;
var
   k: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   PubMuestraProgresBar( True );
   try
      titulo := 'Diagrama de Flujo ' + clase + ' ' + bib + ' ' + nombre;
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;
      k := length( Aftsdghtml );
      setlength( Aftsdghtml, k + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsdghtml[ k ] := Tftsdghtml.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsdghtml[ k ] := Tftsdghtml.Create( Self );
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
         Aftsdghtml[ k ].Width := g_Width;
         Aftsdghtml[ k ].Height := g_Height;
      end;
      //Aftsdghtml[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsdghtml[ k ].Caption := titulo;
      Aftsdghtml[ k ].titulo := titulo;
      Aftsdghtml[ k ].arma( salida, fuente );
      Aftsdghtml[ k ].show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.adabas_crud( Sender: TObject );
var
   k: integer;
   titulo: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //clase bib nombre
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( sLISTA_MATRIZ_CRUD + ' CRUD (ADABAS) ' ) ), MB_OK );
      m.free;
      exit;
   end;

   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      titulo := 'Dataview ' + m[ 0 ] + ' ' + m[ 1 ] + ' ' + m[ 2 ];

      k := length( afmMatrizCrud );
      setlength( afmMatrizCrud, k + 1 );
      afmMatrizCrud[ k ] := TfmMatrizCrud.Create( self );
      afmMatrizCrud[ k ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         afmMatrizCrud[ k ].Width := g_Width;
         afmMatrizCrud[ k ].Height := g_Height;
      end;

      afmMatrizCrud[ k ].titulo := titulo;
      afmMatrizCrud[ k ].tipo := 'NVW';
      afmMatrizCrud[ k ].prepara2( m[ 2 ], m[ 3 ] );
      afmMatrizCrud[ k ].arma3( m[ 2 ], m[ 3 ] );

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
      m.Free;
   end;
   //adabas_crud := inttostr( k ) + ',' + '5000';
end;

procedure Tgral.diagramajcl( Sender: TObject );
var
   k: integer;
   titulo: string;
   m: Tstringlist;
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.count < 3 then begin
         Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
            pchar( dm.xlng( 'Diagrama JCL ' ) ), MB_OK );
         exit;
      end;
      titulo := 'Diagrama de Flujo ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      k := length( Aftsdiagjcl );
      setlength( Aftsdiagjcl, k + 1 );

      //Aftsdiagjcl[ k ] := Tftsdiagjcl.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsdiagjcl[ k ] := Tftsdiagjcl.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsdiagjcl[ k ] := Tftsdiagjcl.Create( Self );
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
         Aftsdiagjcl[ k ].Width := g_Width;
         Aftsdiagjcl[ k ].Height := g_Height;
      end;
      //Aftsdiagjcl[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsdiagjcl[ k ].titulo := titulo;
      Aftsdiagjcl[ k ].Caption := titulo;
      Aftsdiagjcl[ k ].diagrama_jcl( m[ 0 ], m[ 1 ], m[ 2 ], m[ 3 ], );
      Aftsdiagjcl[ k ].show;
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.Free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.diagramaase( Sender: TObject );
var
   datos, mux, ncob: string;
   fte, cop: Tstringlist;
   i, k: integer;
   ff, filedot: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      m.free;
      exit;
   end;
   screen.Cursor := crsqlwait;
   chdir( g_tmpdir );
   fte := Tstringlist.Create;
   mux := m[ 0 ] + '.ase';
   ncob := m[ 0 ] + '.cbl';
   copyfile( pchar( dm.xblobname( m[ 1 ], m[ 0 ], m[ 2 ] ) ), pchar( mux ), false );
   g_borrar.Add( mux );
   g_borrar.Add( ncob );
   dm.get_utileria( 'RGMASE2COB', 'hta' + mux + '.exe' );
   filedot := m[ 0 ] + '.dot';
   dm.ejecuta_espera( 'hta' + mux + '.exe ' +
      mux + ' ' + ncob, SW_HIDE );
   g_borrar.Add( 'hta' + mux + '.exe' );
   g_borrar.Add( filedot );
   g_borrar.Add( 'nada' );
   if fileexists( filedot ) = false then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... no pudo analizar ' + m[ 0 ] ) ),
         pchar( dm.xlng( 'Diagrama de flujo ' ) ), MB_OK );
      exit;
   end;
   if ShellExecute( 0, nil, pchar( dm.get_variable( 'PROGRAMFILES' ) + '\' +
      g_graphviz + '\bin\dotty.exe' ), pchar( filedot ), PChar( g_tmpdir ),
      SW_SHOW ) <= 32 then begin
      Application.MessageBox( 'No se pudo ejecutar la aplicación',
         'Error', MB_ICONEXCLAMATION );
   end;
   screen.Cursor := crdefault;
   //diagramaase := '0,0';
   m.free;
end;

procedure Tgral.Ver_Fuente( Sender: TObject );
var
   k, RutinaPrg: integer;
   titulo: string;
   m, FteTodo: Tstringlist;
begin
   m := Tstringlist.Create;
   FteTodo := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase sistema
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Ver fuente ' ) ), MB_OK );
      m.free;
      exit;
   end;
   RutinaPrg := 0;
   ////==========
       // Aisla la rutina, para poderla ver desde la opcion de PopUp (Visual Basic...)

   if dm.sqlselect( dm.q1, 'select * from tsrela ' + //si el owner es BAS entonces es un ETP de una forma
      ' where hcprog=' + g_q + m[ 0 ] + g_q +
      ' and   hcbib=' + g_q + m[ 1 ] + g_q +
      ' and   hcclase=' + g_q + m[ 2 ] + g_q +
      ' and   sistema=' + g_q + m[ 3 ] + g_q +
      ' and   occlase=' + g_q + 'BAS' + g_q ) then begin
      if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
         ' where hcprog=' + g_q + m[ 0 ] + g_q +
         ' and   hcbib=' + g_q + m[ 1 ] + g_q +
         ' and   hcclase=' + g_q + m[ 2 ] + g_q +
         ' and   sistema=' + g_q + m[ 3 ] + g_q +
         ' and   pcclase =' +
         g_q + 'BAS' + g_q ) then begin
         dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
            dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, FteTodo );
         aisla_rutina_Visual_Basic_PopUp( m[ 0 ], FteTodo );
         RutinaPrg := 1;
      end
      else begin
         if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
            ' where hcprog=' + g_q + m[ 0 ] + g_q +
            ' and   hcbib=' + g_q + m[ 1 ] + g_q +
            ' and   hcclase=' + g_q + m[ 2 ] + g_q +
            ' and   sistema=' + g_q + m[ 3 ] + g_q +
            ' and   pcclase in(' + g_q + 'BFR' + g_q + ',' + g_q + 'ETP' + g_q + ')' ) then begin
            dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
               dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, FteTodo );
            aisla_rutina_Visual_Basic_PopUp( m[ 0 ], FteTodo );
            RutinaPrg := 1;
         end;
      end;
   end
   else begin
      if dm.sqlselect( dm.q1, 'select * from tsrela ' + //si el owner es BFR entonces es un ETP de una forma
         ' where hcprog=' + g_q + m[ 0 ] + g_q +
         ' and   hcbib=' + g_q + m[ 1 ] + g_q +
         ' and   hcclase=' + g_q + m[ 2 ] + g_q +
         ' and   sistema=' + g_q + m[ 3 ] + g_q +
         ' and   occlase=' + g_q + 'BFR' + g_q ) then begin
         if dm.sqlselect( dm.q2, 'select * from tsrela ' + // Localiza el fuente de la rutina
            ' where hcprog=' + g_q + m[ 0 ] + g_q +
            ' and   hcbib=' + g_q + m[ 1 ] + g_q +
            ' and   hcclase=' + g_q + m[ 2 ] + g_q +
            ' and   sistema=' + g_q + m[ 3 ] + g_q +
            ' and   (pcclase in(' + g_q + 'BFR' + g_q + ',' + g_q + 'WFO' + g_q + ',' + g_q + 'ETP' + g_q + ')' +
            ' or pcclase like ' + g_q + 'W%' + g_q + ')' ) then begin
            dm.trae_fuente( dm.q2.fieldbyname( 'sistema' ).AsString, dm.q2.fieldbyname( 'ocprog' ).AsString,
               dm.q2.fieldbyname( 'ocbib' ).AsString, dm.q2.fieldbyname( 'occlase' ).AsString, FteTodo );
            aisla_rutina_Visual_Basic_PopUp( m[ 0 ], FteTodo );
            RutinaPrg := 1;
         end;
      end;
   end;
   ////==========
   if RutinaPrg = 0 then begin
      titulo := 'Ver Fuente ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
      k := length( Aftsgral );
      setlength( Aftsgral, k + 1 );
      {
        0-componente
        1-biblioteca
        2-clase
        3-sistema
       }
      //arma( m[ 3 ], m[ 0 ], m[ 1 ], m[ 2 ], E_texto );
      //arma( m[ 0 ], m[ 1 ], m[ 2 ], m[ 3 ], E_texto );
      // arma (sistema, componente, biblioteca, clase)
      arma_fuente( m[ 3 ], m[ 0 ], m[ 1 ],m[ 2 ], E_texto );
      //Ver_Fuente := inttostr( k ) + ',' + '12000';
   end;
   FteTodo.Free;
   m.Free;
end;

procedure Tgral.bms_preview( Sender: TObject );
var
   k: integer;
   titulo, panta: string;
   m: Tstringlist;
   icont,ierror: integer;  //alk out of system
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta Nombre ó biblioteca ó clase' ) ),
         pchar( dm.xlng( 'Vista Previa ' ) ), MB_OK );
      m.free;
      exit;
   end;

   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      //titulo := 'Vista Previa (BMS) ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
      titulo := m[ 0 ];
      if gral.bPubVentanaActiva( titulo ) then
         Exit;
      para_ver_pantalla( m[ 3 ], m[ 0 ], m[ 1 ], m[ 2 ] );
      panta := g_tmpdir + '\bms_' + m[ 0 ];
      memo1.Lines.SaveToFile( panta );
      g_borrar.Add( panta );
      k := length( Aftsbms );
      setlength( Aftsbms, k + 1 );
      
      // ------ ALK para controlar el error out of system resources ------
      try
         Aftsbms[ k ] := Tftsbms.Create( self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     Aftsbms[ k ] := Tftsbms.Create( self );
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
         Aftsbms[ k ].Width := g_Width;
         Aftsbms[ k ].Height := g_Height;
      end; }
      //Aftsbms[ k ].Constraints.MaxWidth := g_MaxWidth;
      Aftsbms[ k ].titulo := titulo;
      {   if g_language = 'ENGLISH' then
            Aftsbms[ k ].Caption := g_version_tit + '  -  Screen View - ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ]
         else
            Aftsbms[ k ].Caption := g_version_tit + '  -  Vista Pantalla - ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];
      }
      Aftsbms[ k ].arma( panta );

      if gral.bPubVentanaMaximizada then begin     //cuando esta maximizada
         Aftsbms[ k ].Width := g_Width*2;
         Aftsbms[ k ].Height := g_Height*2;
      end
      else begin
         Aftsbms[ k ].Width := g_Width;
         Aftsbms[ k ].Height := g_Height;
      end;
      
      // bms_preview := inttostr( k ) + ',' + '12000';
      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      m.free;
      screen.Cursor := crdefault;
   end;
end;

procedure tgral.arma_fuente( sistema, compo: string; bib: string; clase: string; Wnom_pro: string );
var
   WArchRutina: string;
begin
   if dm.trae_fuente( sistema, compo, bib, clase, Memo1 ) then begin
      bGlbQuitaCaracteres( compo );
      WArchRutina := g_tmpdir + '\' + trim( compo ) + '.txt';

      if dm.sqlselect( dm.q4, 'select * from tsrela ' +
         ' where hcprog=' + g_q + compo + g_q +
         ' and   hcbib=' + g_q + bib + g_q +
         ' and   hcclase=' + g_q + clase + g_q +
         ' and   sistema=' + g_q + sistema + g_q +
         ' and   ((lineainicio is not null ) and (lineainicio > 0 )) ' +
         ' and   ((lineafinal  is not null ) and (lineafinal  > 0 ))' ) then begin
         WArchRutina := extrae_rutina( compo, dm.q4.fieldbyname( 'lineainicio' ).AsInteger, dm.q4.fieldbyname( 'lineafinal' ).AsInteger, memo.lines );
         memo.Lines.LoadFromFile( WArchRutina );
      end
      else
         Memo1.Lines.SaveToFile( WArchRutina );

      ShellExecute( 0, 'open', pchar( WArchRutina ), nil, PChar( g_tmpdir ), SW_SHOW );
      g_borrar.Add( WArchRutina );
   end
   else begin
      Application.MessageBox( pchar( dm.xlng( 'Opción no realizada' + ', el archivo fuente no existe' ) ),
         pchar( dm.xlng( Wnom_pro ) ), MB_OK );
   end;
end;

procedure tgral.para_ver_pantalla( sistema: string; compo: string; bib: string; clase: string );
var
   arch: string;
begin
   {
   if memo_componente <> compo + '_' + bib then begin
      memo1.Lines.Clear;
      if dm.trae_fuente( compo, bib, clase, memo1 ) then begin
         memo_componente := compo + '_' + bib;
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
            pchar( dm.xlng( 'Vista previa ' ) ), MB_OK );
      end;
   end; }//validar funcionalidad memo_componente

   if not dm.trae_fuente( sistema, compo, bib, clase, memo1 ) then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe' ) ),
         pchar( dm.xlng( 'Vista previa ' ) ), MB_OK );
   end;
end;

procedure tgral.exporta( Sender: TObject );    //funcion ALK 080915
type
   Tmatriz = array of Array of String;
var
   contenido,nuevo_cont,columnas,renglones,aux,coord : TStringList;
   i,j : integer;
   l_control, comp, col, reng, renglon: string;
   matriz: Tmatriz;

   function busca_lugar(col,ren : integer):String;
   var
      c,r : integer;
      coor:TStringList;
      arroja:String;
   begin
      coor:=TStringList.Create;

      for c:=0 to columnas.Count -1 do
         if StrToInt(columnas[c]) = col then begin
            coor.Add(IntToStr(c));
            break;
         end;

      for r:=0 to renglones.Count -1 do
         if StrToInt(renglones[r]) = ren then begin
            coor.Add(IntToStr(r));
            break;
         end;

      arroja:= coor.CommaText;
      coor.Free;
      Result:= arroja;
   end;

   procedure BubbleSort( var list: TStringList );
   var
      i, j: Integer;
      temp: string;
   begin
      for i := 0 to list.Count - 1 do begin
         for j := 0 to list.Count - 1 do begin
            if j= list.Count - 1 then
               continue;
            if StrToInt(list[j]) > StrToInt(list[j+1]) then begin
               temp := list[j+1];
               list[j+1] := list[j];
               list[j] := temp;
            end;
         end;
      end;
   end;
begin
   contenido:= TStringList.Create;

   try
      // -- trar la informacion que tiene el archivo --
      l_control := stringreplace( g_control, ' ', '', [ rfreplaceall ] );
      bGlbQuitaCaracteres( l_control );
      contenido.LoadFromFile( g_tmpdir + '\Impacto' + l_control );
      g_borrar.Add( g_tmpdir + '\Impacto' + l_control );
      { -----------------------------------------------
         De este archivo sabemos que:
            [0] - Letra
            [1] - Datos del componente
            [2] - columna
            [3] - fila
            [4] - color
        ----------------------------------------------- }

      //-- como las coordenadas estan en renglon-columna debo obtener las equivalencias --
      columnas:= TStringList.Create;
      renglones:= TStringList.Create;
      aux:= TStringList.Create;
      // para no permitir duplicados
      columnas.Sorted:=True;
      renglones.Sorted:=True;
      for i:=0 to contenido.Count-1 do begin
         aux.Clear;
         aux.CommaText:=contenido[i];    //obtener el renglon
         //obtener la coordenada
         columnas.Add(aux[2]);
         renglones.Add(aux[3]);
      end;
      columnas.Sorted:=False;
      renglones.Sorted:=False;
      // --- Ordenar la lista ---
      BubbleSort( columnas );
      BubbleSort( renglones );

      //-- Cambiar en el arreglo de contenido la coordenada --
      coord:=TStringList.Create;
      nuevo_cont:=TStringList.Create;
      for i:=0 to contenido.Count-1 do begin
         aux.Clear;
         aux.CommaText:=contenido[i];    //obtener el renglon
         coord.CommaText:=busca_lugar(StrToInt(aux[2]),StrToInt(aux[3]));  //procesar la cordenada para obtener la nueva coordenada
         // -- va a contener componente,columna, renglon --
         nuevo_cont.Add( '"' + aux[1] + '","' + coord[0] + '","' + coord[1] + '"');
      end;

      nuevo_cont.SaveToFile(g_tmpdir + '\Impactotmp' + l_control);
      g_borrar.Add( g_tmpdir + '\Impactotmp' + l_control );

      //traer la informacion del archivo para formar la matriz
      contenido.Clear;
      contenido.LoadFromFile( g_tmpdir + '\Impactotmp' + l_control );
      SetLength(matriz,columnas.Count,renglones.Count);

      for i:=0 to contenido.Count-1 do begin
         aux.Clear;
         aux.CommaText:=contenido[i];    //obtener el renglon
         comp:=stringreplace( aux[0], '|', ' ', [ rfreplaceall ] );

         col:=stringreplace( aux[1], '"', '', [ rfreplaceall ] );
         reng:=stringreplace( aux[2], '"', '', [ rfreplaceall ] );

         matriz[StrToInt(col),StrToInt(reng)]:=stringreplace( comp, '"', '', [ rfreplaceall ] );
      end;

      // -- pasar renglon por renglon al stringlist --
      nuevo_cont.Clear;
      // -- Agregar datos --
      nuevo_cont.add(trim( g_empresa ));
      nuevo_cont.add('Análisis de Impacto ( ' + stringreplace( g_control, '|', ' ', [ rfreplaceall ] ) + ' )');
      nuevo_cont.add(' ');
      for j:=0 to renglones.Count - 1 do begin
         renglon:= '"' + matriz[0,j] + '","';
         for i:=1 to columnas.Count - 2 do begin
            renglon:= renglon + matriz[i,j]+'","';
         end;
         renglon:= renglon + matriz[columnas.Count-1,j] + '"';

         nuevo_cont.add(renglon);
      end;

      if sPubArchivoXLS <> '' then            //si viene de documentacion automatica
         nuevo_cont.SaveToFile(sPubArchivoXLS)
      else begin
         nuevo_cont.SaveToFile(g_tmpdir + '\ImpactoCSV' + l_control+ '.csv');
         g_borrar.Add( g_tmpdir + '\ImpactoCSV' + l_control+ '.csv' );
         // -- abrir el archivo --
         if Fileexists(g_tmpdir + '\ImpactoCSV' + l_control+ '.csv') then
            ShellExecute( 0, 'open', pchar( g_tmpdir + '\ImpactoCSV' + l_control+ '.csv' ), nil, PChar( g_tmpdir ), SW_SHOW );
      end;
         
   finally
      contenido.Free;
      aux.Free;
      columnas.Free;
      renglones.Free;
      coord.Free;
      nuevo_cont.Free;
   end;
end;



procedure tgral.exportaJCL( Sender: TObject );
var
   i, ii, j, m, n, total, Wlin, Wcol, Wcolor: integer;
   ant, tipo, bas, nfont: string;
   vmlxx, vmlyy: Tstringlist;
   control1, control2: string;
   clase, bib, nom, W1, W2, W0, W3, Wcom: string;
   WW, Wconectar: string;
   Libro: _WORKBOOK;
   Hoja: _WORKSHEET;
   l_control: string;
begin
   ren := 0;
   j := 5;
   Libro := ExcelApplication1.Workbooks.Add( Null, 0 );
   Hoja := Libro.Sheets[ 1 ] as _WORKSHEET;
   screen.Cursor := crsqlwait;
   Hoja.Cells.Item[ 2, 1 ] := trim( g_empresa );
   Hoja.Cells.Item[ 2, 1 ].font.size := 12;
   Hoja.Cells.Item[ 2, 1 ].Font.Bold := True;
   ///Hoja.Cells.Item[ 3, 1 ] := 'Diagrama de Flujo ( ' + stringreplace( bgral, '|', '  ', [ rfreplaceall ] ) + ' )';
   Hoja.Cells.Item[ 3, 1 ] := 'Diagrama de Flujo ( ' + stringreplace( g_control, '|', '  ', [ rfreplaceall ] ) + ' )';
   Hoja.Cells.Item[ 3, 1 ].font.size := 12;

   if trim( subtitulo ) <> '' then
      Hoja.Cells.Item[ 3, 1 ] := subtitulo;
   Hoja.Cells.Item[ 3, 1 ].font.size := 10;
   ren := 400;
   if dm.sqlselect( dm.q1, 'select * from parametro ' +
      ' where clave=' + g_q + 'EMPRESA-NOMBRE-1' + g_q ) then
      es_bbva := ( copy( dm.q1.FieldByName( 'dato' ).AsString, 1, 4 ) = 'BBVA' );

   vmlxx := Tstringlist.Create;
   ///vmlxx.LoadFromFile( g_control );
   l_control := stringreplace( g_control, ' ', '', [ rfreplaceall ] );
   //vmlxx.LoadFromFile( g_tmpdir + '\Diagrama de Flujo ' + stringreplace( l_control, '|', '', [ rfreplaceall ] ) );

   bGlbQuitaCaracteres( l_control );
   vmlxx.LoadFromFile( g_tmpdir + '\Diagrama de Flujo ' + l_control );

   ii := 1;
   vmlyy := Tstringlist.Create;
   for i := 0 to vmlxx.count - 1 do begin
      vmlyy.clear;
      W0 := vmlxx[ i ];
      vmlyy.CommaText := W0;
      //primera parte del analisis de impacto
      if ( vmlyy[ 0 ] ) = 'D' then begin
         W2 := vmlyy[ 4 ];
         W3 := stringreplace( W2, '#', '', [ rfreplaceall ] );
         W3 := stringreplace( W3, '$', '', [ rfreplaceall ] );
         Wcolor := HexToInt( W3 );
         Wlin := strtoint( vmlyy[ 3 ] );
         Wcol := strtoint( vmlyy[ 2 ] );
         //         Wcom := stringreplace( trim( vmlyy[ 1 ] ), '|', ' ', [ rfreplaceall ] );
         Wcom := stringreplace( trim( vmlyy[ 5 ] ), '|', ' ', [ rfreplaceall ] );
         if ( Wcom = 'FIL' ) or
            ( Wcom = 'BD' ) then
            Wcom := stringreplace( trim( vmlyy[ 1 ] ), '|', ' ', [ rfreplaceall ] );

         if pos( '|', vmlyy[ 1 ] ) > 0 then
            Wlin := 5 + trunc( Wlin / 4 )
         else begin
            if W3 = '00FDFDFD' then
               Wconectar := '-->'
            else begin
               Wconectar := '<--';
            end;
            Wlin := 5 + trunc( ( Wlin + 1 ) / 4 );
         end;
         WW := Hoja.Cells.Item[ Wlin, Wcol ];
         if WW <> '' then
            Wcom := WW + Wconectar + Wcom;
         //Wcom := stringreplace( trim( vmlyy[ 1 ] ), '|', ' ', [ rfreplaceall ] );
         Hoja.Cells.Item[ Wlin, Wcol ] := Wcom;
         if pos( '|', vmlyy[ 1 ] ) > 0 then
            Hoja.Cells.Item[ Wlin, Wcol ].Interior.Color := Wcolor;

         Hoja.Cells.Item[ Wlin, Wcol ] := Wcom;
         ///Hoja.Cells.Item[ Wlin, Wcol ].Interior.Color := Wcolor;
         j := Wlin + 3;
         continue;
      end;
      //segunda parte del analisis de impacto
      W2 := vmlyy[ 2 ];
      W1 := vmlyy[ 1 ];
      control1 := copy( W1, 1, 5 );
      control2 := copy( W1, 6, 18 );
      if trim( control2 ) = '0' then
         continue;
      if control1 = 'TOTAL' then begin
         W3 := stringreplace( W2, '#', '', [ rfreplaceall ] );
         Wcolor := HexToInt( W3 );
         Hoja.Cells.Item[ j, ii ] := trim( control2 );
         Hoja.Cells.Item[ j, ii ].HorizontalAlignment := xlCenter;
         Hoja.Cells.Item[ j, ii ].font.size := 9;
         Hoja.Cells.Item[ j, ii ].Interior.Color := Wcolor;
         Hoja.Cells.Item[ j, ii ].Font.Bold := True;
         j := Wlin + 3;
         ii := ii + 1;
      end
      else begin

         if j = Wlin + 3 then begin
            Hoja.Cells.Item[ j, ii ] := W1;
            W3 := stringreplace( W2, '#', '', [ rfreplaceall ] );
            Wcolor := HexToInt( W3 );
            Hoja.Cells.Item[ j, ii ].HorizontalAlignment := xlCenter;
            Hoja.Cells.Item[ j, ii ].Interior.Color := Wcolor;
            Hoja.Cells.Item[ j, ii ].Font.Bold := True;
         end
         else begin
            Hoja.Cells.Item[ j, ii ] := stringreplace( W2, '=', ' ', [ rfreplaceall ] );
            Hoja.Cells.Item[ j, ii ].font.size := 9;
         end;
         j := j + 1;
      end;
   end;
   screen.Cursor := crdefault;
   ExcelApplication1.Visible[ 1 ] := true;
   g_borrar.Add( g_tmpdir + '\JCL' + stringreplace( g_control, '|', '', [ rfreplaceall ] ) );
   vmlxx.Free;
   vmlyy.Free;
end;

procedure tgral.exportaProc( Sender: TObject );
type
   Tmatriz = array of Array of String;
var
   contenido,nuevo_cont,columnas,renglones,aux,coord : TStringList;
   i,j : integer;
   l_control, comp, col, reng, renglon: string;
   matriz: Tmatriz;

   function busca_lugar(col,ren : integer):String;
   var
      c,r : integer;
      coor:TStringList;
      arroja:String;
   begin
      coor:=TStringList.Create;

      for c:=0 to columnas.Count -1 do
         if StrToInt(columnas[c]) = col then begin
            coor.Add(IntToStr(c));
            break;
         end;

      for r:=0 to renglones.Count -1 do
         if StrToInt(renglones[r]) = ren then begin
            coor.Add(IntToStr(r));
            break;
         end;

      arroja:= coor.CommaText;
      coor.Free;
      Result:= arroja;
   end;

   procedure BubbleSort( var list: TStringList );
   var
      i, j: Integer;
      temp: string;
   begin
      for i := 0 to list.Count - 1 do begin
         for j := 0 to list.Count - 1 do begin
            if j= list.Count - 1 then
               continue;
            if StrToInt(list[j]) > StrToInt(list[j+1]) then begin
               temp := list[j+1];
               list[j+1] := list[j];
               list[j] := temp;
            end;
         end;
      end;
   end;
begin
   contenido:= TStringList.Create;

   try
      // -- trar la informacion que tiene el archivo --
      g_control := stringreplace( g_control, g_tmpdir + '\DiagramaProceso', '', [ rfreplaceall ] );
      l_control := stringreplace( g_control, ' ', '', [ rfreplaceall ] );

      if FileExists( g_tmpdir + '\DiagramaProceso' + stringreplace( l_control, '|', '', [ rfreplaceall ] ) ) then
         contenido.LoadFromFile( g_tmpdir + '\DiagramaProceso' + stringreplace( l_control, '|', '', [ rfreplaceall ] ) )
      else
         exit;
      { -----------------------------------------------
         De este archivo sabemos que:
            [0] - Letra
            [1] - Datos del componente
            [2] - columna
            [3] - fila
            [4] - color
        ----------------------------------------------- }

      //-- como las coordenadas estan en renglon-columna debo obtener las equivalencias --
      columnas:= TStringList.Create;
      renglones:= TStringList.Create;
      aux:= TStringList.Create;
      // para no permitir duplicados
      columnas.Sorted:=True;
      renglones.Sorted:=True;
      for i:=0 to contenido.Count-1 do begin
         aux.Clear;
         aux.CommaText:=contenido[i];    //obtener el renglon
         //obtener la coordenada
         columnas.Add(aux[2]);
         renglones.Add(aux[3]);
      end;
      columnas.Sorted:=False;
      renglones.Sorted:=False;
      // --- Ordenar la lista ---
      BubbleSort( columnas );
      BubbleSort( renglones );

      //-- Cambiar en el arreglo de contenido la coordenada --
      coord:=TStringList.Create;
      nuevo_cont:=TStringList.Create;
      for i:=0 to contenido.Count-1 do begin
         aux.Clear;
         aux.CommaText:=contenido[i];    //obtener el renglon
         coord.CommaText:=busca_lugar(StrToInt(aux[2]),StrToInt(aux[3]));  //procesar la cordenada para obtener la nueva coordenada
         // -- va a contener componente,columna, renglon --
         nuevo_cont.Add( '"' + aux[1] + '","' + coord[0] + '","' + coord[1] + '"');
      end;

      nuevo_cont.SaveToFile(g_tmpdir + '\DiagramaProcesoTMP' + stringreplace( l_control, '|', '', [ rfreplaceall ] ));
      g_borrar.Add( g_tmpdir + '\DiagramaProcesoTMP' + stringreplace( l_control, '|', '', [ rfreplaceall ] ) );

      //traer la informacion del archivo para formar la matriz
      contenido.Clear;
      contenido.LoadFromFile( g_tmpdir + '\DiagramaProcesoTMP' + stringreplace( l_control, '|', '', [ rfreplaceall ] ) );
      SetLength(matriz,columnas.Count,renglones.Count);

      for i:=0 to contenido.Count-1 do begin
         aux.Clear;
         aux.CommaText:=contenido[i];    //obtener el renglon
         comp:=stringreplace( aux[0], '|', ' ', [ rfreplaceall ] );

         col:=stringreplace( aux[1], '"', '', [ rfreplaceall ] );
         reng:=stringreplace( aux[2], '"', '', [ rfreplaceall ] );

         matriz[StrToInt(col),StrToInt(reng)]:=stringreplace( comp, '"', '', [ rfreplaceall ] );
      end;

      // -- pasar renglon por renglon al stringlist --
      nuevo_cont.Clear;
      // -- Agregar datos --
      nuevo_cont.add(trim( g_empresa ));
      nuevo_cont.add('Diagrama de Proceso ( ' + stringreplace( g_control, '|', ' ', [ rfreplaceall ] ) + ' )');
      nuevo_cont.add(' ');
      for j:=0 to renglones.Count - 1 do begin
         renglon:= '"' + matriz[0,j] + '","';
         for i:=1 to columnas.Count - 2 do begin
            renglon:= renglon + matriz[i,j]+'","';
         end;
         renglon:= renglon + matriz[columnas.Count-1,j] + '"';

         nuevo_cont.add(renglon);
      end;

      if sPubArchivoXLS <> '' then            //si viene de documentacion automatica
         nuevo_cont.SaveToFile(sPubArchivoXLS)
      else begin
         nuevo_cont.SaveToFile(g_tmpdir + '\DiagramaProcesoCSV' + stringreplace( l_control, '|', '', [ rfreplaceall ] )+ '.csv');
         if Fileexists(g_tmpdir + '\DiagramaProcesoCSV' + stringreplace( l_control, '|', '', [ rfreplaceall ] )+ '.csv') then
            ShellExecute( 0, 'open', pchar( g_tmpdir + '\DiagramaProcesoCSV' + stringreplace( l_control, '|', '', [ rfreplaceall ] )+ '.csv' ), nil, PChar( g_tmpdir ), SW_SHOW );
      end

   finally
      g_borrar.Add( g_tmpdir + '\DiagramaProcesoCSV' + stringreplace( l_control, '|', '', [ rfreplaceall ] )+ '.csv' );
      g_borrar.Add( g_tmpdir + '\DiagramaProceso' + stringreplace( l_control, '|', '', [ rfreplaceall ] ) );
      contenido.Free;
      aux.Free;
      columnas.Free;
      renglones.Free;
      coord.Free;
      nuevo_cont.Free;
   end;
end;


procedure tgral.CambiaColorClase( Sender: TObject );
var
   Wcolor: string;
   W1color: string;
   m: Tstringlist;
begin
   m := Tstringlist.Create;
   m.CommaText := bgral; //nombre bib clase
   if m.count < 2 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta la clase' ) ),
         pchar( dm.xlng( 'Cambia el color de la clase' ) ), MB_OK );
      m.free;
      exit;
   end;
   Wcolor := CambiaColor;
   if dm.sqlselect( dm.q2, 'select * from parametro where clave = ' + g_q + 'WCOLOR_' + m[ 2 ] + g_q ) then begin
      W1color := dm.q2.fieldbyname( 'dato' ).AsString;
      if dm.sqlupdate( 'update parametro set dato=' + g_q + '$' + Wcolor + g_q +
         ' where clave=' + g_q + 'WCOLOR_' + m[ 2 ] + g_q ) = false then begin
         Application.MessageBox( pchar( dm.xlng( ' No fue posible actualizar la clave ' + 'WCOLOR_' + m[ 2 ] ) ),
            pchar( dm.xlng( 'Cambia color de la Clase ' ) ), MB_OK );
         m.free;
         exit;
      end;
   end
   else begin
      Application.MessageBox( pchar( dm.xlng( 'La clave ' + 'WCOLOR_' + m[ 2 ] + ', no existe en la tabla parametro, se dará de alta.' ) ),
         pchar( dm.xlng( 'Cambia color de la Clase ' ) ), MB_OK );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'WCOLOR_' + m[ 2 ] + g_q + ',' + '1' + ',' + g_q + '$' + Wcolor + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar ' + 'WCOLOR_' + m[ 2 ] );
   end;
   m.free;
end;

function tgral.CambiaColor( ): string;
begin
   ColorDialog1.Execute;
   Result := IntToHex( GetRValue( ColorDialog1.Color ), 2 ) +
      IntToHex( GetGValue( ColorDialog1.Color ), 2 ) +
      IntToHex( GetBValue( ColorDialog1.Color ), 2 );
end;

procedure Tgral.poparchivoPopup( Sender: TObject );
var
   ite: Tmenuitem;
begin
   ite := ( sender as Tmenuitem );
   if ite.Tag >= 17000 then begin // vista HTML
      Aftsviewhtml[ ite.Tag - 17000 ].WindowState := wsnormal;
      Aftsviewhtml[ ite.Tag - 17000 ].show;
      Aftsviewhtml[ ite.Tag - 17000 ].Invalidate;
   end
   else if ite.Tag >= 16000 then begin // archivos
      Aftsarchivos[ ite.Tag - 16000 ].WindowState := wsnormal;
      Aftsarchivos[ ite.Tag - 16000 ].show;
      Aftsarchivos[ ite.Tag - 16000 ].Invalidate;
   end
   else if ite.Tag >= 15000 then begin // pantalla V.B.
      Aftsattribute[ ite.Tag - 15000 ].WindowState := wsnormal;
      Aftsattribute[ ite.Tag - 15000 ].show;
      Aftsattribute[ ite.Tag - 15000 ].Invalidate;
   end
   else if ite.Tag >= 12000 then begin // BMS
      Aftsbms[ ite.Tag - 12000 ].WindowState := wsnormal;
      Aftsbms[ ite.Tag - 12000 ].show;
      Aftsbms[ ite.Tag - 12000 ].Invalidate;
   end
   else if ite.Tag >= 11000 then begin // Versiones
      Aftsversionado[ ite.Tag - 11000 ].WindowState := wsnormal;
      Aftsversionado[ ite.Tag - 11000 ].show;
      Aftsversionado[ ite.Tag - 11000 ].Invalidate;
   end
   else if ite.Tag >= 10000 then begin // Diagramas Html
      Aftsdghtml[ ite.Tag - 10000 ].WindowState := wsnormal;
      Aftsdghtml[ ite.Tag - 10000 ].show;
      Aftsdghtml[ ite.Tag - 10000 ].Invalidate;
   end
   else if ite.Tag >= 9000 then begin // Diagramas RPG
      Afmgflrpg[ ite.Tag - 9000 ].WindowState := wsnormal;
      Afmgflrpg[ ite.Tag - 9000 ].show;
      Afmgflrpg[ ite.Tag - 9000 ].Invalidate;
   end
   else if ite.Tag >= 7000 then begin // Mapa Natural
      Aftsproperty[ ite.Tag - 7000 ].WindowState := wsnormal;
      Aftsproperty[ ite.Tag - 7000 ].show;
      Aftsproperty[ ite.Tag - 7000 ].Invalidate;
   end
   else if ite.Tag >= 6000 then begin // Mapa Natural
      Aftsmapanat[ ite.Tag - 6000 ].WindowState := wsnormal;
      Aftsmapanat[ ite.Tag - 6000 ].show;
      Aftsmapanat[ ite.Tag - 6000 ].Invalidate;
   end
   else if ite.Tag >= 5000 then begin // Tablas CRUD
      //      Aftstablas[ ite.Tag - 5000 ].WindowState := wsnormal;      //framirez
      //      Aftstablas[ ite.Tag - 5000 ].show;                         //framirez
      //      Aftstablas[ ite.Tag - 5000 ].Invalidate;                   //framirez
      afmMatrizCrud[ ite.Tag - 5000 ].WindowState := wsnormal; //framirez
      afmMatrizCrud[ ite.Tag - 5000 ].show; //framirez
      afmMatrizCrud[ ite.Tag - 5000 ].Invalidate; //framirez
   end
   else if ite.Tag >= 4000 then begin // Diagramas COBOL
      Afmgflcob[ ite.Tag - 4000 ].WindowState := wsnormal;
      Afmgflcob[ ite.Tag - 4000 ].show;
      Afmgflcob[ ite.Tag - 4000 ].Invalidate;
   end
   else if ite.Tag >= 3000 then begin // Diagrama JCL
      Aftsdiagjcl[ ite.Tag - 3000 ].WindowState := wsnormal;
      Aftsdiagjcl[ ite.Tag - 3000 ].show;
      Aftsdiagjcl[ ite.Tag - 3000 ].Invalidate;
   end
   else if ite.Tag >= 2000 then begin // Documentación
      //Aftsdocumenta[ ite.Tag - 2000 ].WindowState := wsnormal;
      //Aftsdocumenta[ ite.Tag - 2000 ].show;
      //Aftsdocumenta[ ite.Tag - 2000 ].Invalidate;
   end
   else if ite.Tag >= 1000 then begin // Referencias Cruzadas
      Aftsrefcruz[ ite.Tag - 1000 ].WindowState := wsnormal;
      Aftsrefcruz[ ite.Tag - 1000 ].show;
      Aftsrefcruz[ ite.Tag - 1000 ].Invalidate;
   end
   else begin // Analisis de Impacto
      //Aftsimpacto[ ite.Tag ].WindowState := wsnormal;
      //Aftsimpacto[ ite.Tag ].show;
      //Aftsimpacto[ ite.Tag ].Invalidate;
   end;
end;

procedure Tgral.ActualizaColorClase( );
begin
   if sql1select( q6, 'select * from parametro where clave like ' + g_q + 'COLOR_%' + g_q ) = false then begin
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'COLOR_ASE' + g_q + ',' + '1' + ',' + g_q + '#FFA07A' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_ASE' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_BMS' + g_q + ',' + '1' + ',' + g_q + '#FFB6C1' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_BMS' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_CBL' + g_q + ',' + '1' + ',' + g_q + '#DB7093' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_CBL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_CCT' + g_q + ',' + '1' + ',' + g_q + '#FFA500' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_CCT' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_CLA' + g_q + ',' + '1' + ',' + g_q + '#FFDAB9' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_CLA' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_CLP' + g_q + ',' + '1' + ',' + g_q + '#F0E68C' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_CLP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_COM' + g_q + ',' + '1' + ',' + g_q + '#D8BFD8' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_COM' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_CPY' + g_q + ',' + '1' + ',' + g_q + '#D8BFD8' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_CPY' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_CSS' + g_q + ',' + '1' + ',' + g_q + '#9ACD32' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_CSS' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_CTC' + g_q + ',' + '1' + ',' + g_q + '#66CDAA' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_CTC' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_DCL' + g_q + ',' + '1' + ',' + g_q + '#AFEEEE' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_DCL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_DEL' + g_q + ',' + '1' + ',' + g_q + '#7FFFD4' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_DEL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_DOO' + g_q + ',' + '1' + ',' + g_q + '#B0C4DE' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_DOO' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_DSS' + g_q + ',' + '1' + ',' + g_q + '#F5A9A9' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_DSS' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_DVW' + g_q + ',' + '1' + ',' + g_q + '#B0E0E6' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_DVW' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_ETP' + g_q + ',' + '1' + ',' + g_q + '#ADD8E6' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_ETP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_FIL' + g_q + ',' + '1' + ',' + g_q + '#87CEFA' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_FIL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_GIF' + g_q + ',' + '1' + ',' + g_q + '#99FF99' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_GIF' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_HTM' + g_q + ',' + '1' + ',' + g_q + '#7FFFD4' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_HTM' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_IDL' + g_q + ',' + '1' + ',' + g_q + '#FFE4C4' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_IDL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_INS' + g_q + ',' + '1' + ',' + g_q + '#ADFF2F' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_INS' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_IRP' + g_q + ',' + '1' + ',' + g_q + '#F0E68C' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_IRP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_ITP' + g_q + ',' + '1' + ',' + g_q + '#ADD8E6' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_ITP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JAC' + g_q + ',' + '1' + ',' + g_q + '#90EE90' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JAC' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JAV' + g_q + ',' + '1' + ',' + g_q + '#B0C4DE' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JAV' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JCL' + g_q + ',' + '1' + ',' + g_q + '#66CDAA' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JCL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JDF' + g_q + ',' + '1' + ',' + g_q + '#48D1CC' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JDF' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JOB' + g_q + ',' + '1' + ',' + g_q + '#FFE4B5' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JOB' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JPG' + g_q + ',' + '1' + ',' + g_q + '#98FB98' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JPG' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JSP' + g_q + ',' + '1' + ',' + g_q + '#FFC0CB' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JSP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JSS' + g_q + ',' + '1' + ',' + g_q + '#DDA0DD' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JSS' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JTN' + g_q + ',' + '1' + ',' + g_q + '#B0E0E6' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JTN' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_JXM' + g_q + ',' + '1' + ',' + g_q + '#87CEEB' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_JXM' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_LOC' + g_q + ',' + '1' + ',' + g_q + '#D8BFD8' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_LOC' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NAT' + g_q + ',' + '1' + ',' + g_q + '#9ACD32' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NAT' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NCP' + g_q + ',' + '1' + ',' + g_q + '#FAEBD7' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NCP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NDL' + g_q + ',' + '1' + ',' + g_q + '#7FFFD4' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NDL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NDM' + g_q + ',' + '1' + ',' + g_q + '#FFE4C4' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NDM' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NEG' + g_q + ',' + '1' + ',' + g_q + '#F0E68C' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NEG' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NEP' + g_q + ',' + '1' + ',' + g_q + '#E6E6FA' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NEP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NFP' + g_q + ',' + '1' + ',' + g_q + '#ADD8E6' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NFP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NGL' + g_q + ',' + '1' + ',' + g_q + '#E0FFFF' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NGL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NIN' + g_q + ',' + '1' + ',' + g_q + '#FFB6C1' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NIN' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NLC' + g_q + ',' + '1' + ',' + g_q + '#87CEFA' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NLC' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NMP' + g_q + ',' + '1' + ',' + g_q + '#B0C4DE' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NMP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NPA' + g_q + ',' + '1' + ',' + g_q + '#66CDAA' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NPA' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NSP' + g_q + ',' + '1' + ',' + g_q + '#48D1CC' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NSP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NSR' + g_q + ',' + '1' + ',' + g_q + '#FFE4B5' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NSR' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NUP' + g_q + ',' + '1' + ',' + g_q + '#FFDEAD' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NUP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_NVW' + g_q + ',' + '1' + ',' + g_q + '#EEE8AA' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_NVW' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_PCK' + g_q + ',' + '1' + ',' + g_q + '#98FB98' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_PCK' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_PDF' + g_q + ',' + '1' + ',' + g_q + '#AFEEEE' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_PDF' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_PNG' + g_q + ',' + '1' + ',' + g_q + '#FFDAB9' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_PNG' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_PNL' + g_q + ',' + '1' + ',' + g_q + '#FFC0CB' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_PNL' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_RCM' + g_q + ',' + '1' + ',' + g_q + '#B0E0E6' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_RCM' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_RCP' + g_q + ',' + '1' + ',' + g_q + '#87CEEB' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_RCP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_RDS' + g_q + ',' + '1' + ',' + g_q + '#D8BFD8' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_RDS' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_REP' + g_q + ',' + '1' + ',' + g_q + '#40E0D0' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_REP' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_RLF' + g_q + ',' + '1' + ',' + g_q + '#F5DEB3' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_RLF' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_RPF' + g_q + ',' + '1' + ',' + g_q + '#9ACD32' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_RPF' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_RPG' + g_q + ',' + '1' + ',' + g_q + '#FFA07A' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_RPG' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_STE' + g_q + ',' + '1' + ',' + g_q + '#FFB6C1' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_STE' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_TAB' + g_q + ',' + '1' + ',' + g_q + '#DB7093' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_TAB' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_TDC' + g_q + ',' + '1' + ',' + g_q + '#FFA500' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_TDC' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_TLD' + g_q + ',' + '1' + ',' + g_q + '#FFDAB9' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_TLD' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_UPD' + g_q + ',' + '1' + ',' + g_q + '#F0E68C' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_UPD' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' + g_q + 'COLOR_UTI' + g_q + ',' + '1' + ',' + g_q + '#D8BFD8' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede insertar COLOR_UTI' );
   end;
end;

procedure Tgral.MantenimientoCapacidades( );
begin

   if sql1select( q6, 'select * from tscapacidad where crol = ' + g_q + 'ADMIN' + g_q +
      ' and  ccapacidad = ' + g_q + 'Conversion de Componentes' + g_q ) = FALSE then begin
      if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
         g_q + 'Conversion de Componentes' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' ) = FALSE then
         dm.aborta( 'ERROR... no puede crear Capacidad ADMIN-.Conversion de Componentes' );
   end;

   if sql1select( q6, 'select * from tscapacidad where crol = ' + g_q + 'SVS' + g_q +
      ' and  ccapacidad = ' + g_q + 'Conversion de Componentes' + g_q ) = FALSE then begin
      if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
         g_q + 'Conversion de Componentes' + g_q + ',' + g_q + 'SVS' + g_q + ')' ) = FALSE then
         dm.aborta( 'ERROR... no puede crear Capacidad SVS-.Conversion de Componentes' );
   end;

   if sql1select( q6, 'select * from tscapacidad where crol = ' + g_q + 'GENERAL' + g_q ) then
      exit;

   if dm.sqlinsert( 'insert into tsroles (crol,descripcion,mineria) values(' +
      g_q + 'GENERAL' + g_q + ',' +
      g_q + 'CAPACIDADES GENERALES' + g_q + ',' +
      g_q + '1' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede insertar rol de GENERAL' );
   if dm.sqlinsert( 'insert into tsuser (cuser,nombre,password) values(' +
      g_q + 'GENERAL' + g_q + ',' +
      g_q + 'CAPACIDADES GENERALES' + g_q + ',' +
      g_q + dm.encripta( 'general' ) + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear usuario GENERAL' );
   if dm.sqlinsert( 'insert into tsroluser (cuser, crol) values(' +
      g_q + 'GENERAL' + g_q + ',' +
      g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear rol de general' );

   // Capcidades con rol-GENERAL
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Base Conocimiento - Arbol Principal' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Base Conocimiento - Arbol Principal' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Base Conocimiento - Busqueda' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Base Conocimiento - Busqueda' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Cambio de iconos Arbol' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Cambio de iconos Arbol' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'cambio de password (todos)' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.cambio de password (todos)' );
   //?   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
   //?      g_q+'CBL - Convertir a GENEXUS'+g_q+','+g_q+'GENERAL'+g_q+')')=false then
   //?      dm.aborta('ERROR... no puede crear Capacidad GENERAL-.CBL - Convertir a GENEXUS');
   //?   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
   //?      g_q+'CBL - Convertir a UNIX'+g_q+','+g_q+'GENERAL'+g_q+')')=false then
   //?      dm.aborta('ERROR... no puede crear Capacidad GENERAL-.CBL - Convertir a UNIX');
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Conversion de Componentes' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Conversion de Componentes' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Documenta - Actualizar documentos' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Documenta - Actualizar documentos' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Documenta - Borrar documentos' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Documenta - Borrar documentos' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Alta Utileria' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Alta Utileria' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Sys-Mining' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Sys-Mining' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Asigna Rol a Usuario' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Asigna Rol a Usuario' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Capacidades' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Capacidades' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Carga Esquema' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Carga Esquema' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Carga Utileria' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Carga Utileria' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Clases' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Clases' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Compara Esquema' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Compara Esquema' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal FPT' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal FPT' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Oficinas' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Oficinas' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Parametros' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Parametros' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Roles' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Roles' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Sistemas' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Sistemas' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Usuarios' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Menu Principal Usuarios' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Catalogos' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Mining - Catalogos' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Inventario' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Mining - Inventario' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Recepcion Componentes' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Mining - Recepcion Componentes' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Reporteador' + g_q + ',' + g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Capacidad GENERAL-.Mining - Reporteador' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Administracion Caducidad' + g_q + ',' +
      g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Caducidad de admin' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Administracion Monitoreo' + g_q + ',' +
      g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Monitoreo de admin' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Busca' + g_q + ',' +
      g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Mining - Busca' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Proceso Negocio' + g_q + ',' +
      g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Mining - Proceso Negocio' );
   if dm.sqlinsert( 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Casos Uso' + g_q + ',' +
      g_q + 'GENERAL' + g_q + ')' ) = false then
      dm.aborta( 'ERROR... no puede crear Mining - Casos Uso' );
   //?   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
   //?      g_q+'NAT - Convertir a Cobol'+g_q+','+g_q+'GENERAL'+g_q+')')=false then
   //?      dm.aborta('ERROR... no puede crear Capacidad GENERAL-.NAT - Convertir a Cobol');
   //?   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
   //?      g_q+'NDM - Convertir a DB2'+g_q+','+g_q+'GENERAL'+g_q+')')=false then
   //?      dm.aborta('ERROR... no puede crear Capacidad GENERAL-.NDM - Convertir a DB2');
   //?   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
   //?      g_q+'NFP - Convertir a DB2'+g_q+','+g_q+'GENERAL'+g_q+')')=false then
   //?      dm.aborta('ERROR... no puede crear Capacidad GENERAL-.NFP - Convertir a DB2');
   //?   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
   //?      g_q+'NGL - Convertir a Cobol'+g_q+','+g_q+'GENERAL'+g_q+')')=false then
   //?      dm.aborta('ERROR... no puede crear Capacidad GENERAL-.NGL - Convertir a Cobol');
   //?   if dm.sqlinsert('insert into tscapacidad (ccapacidad, crol) values('+
   //?      g_q+'NMP - Convertir a CICS BMS'+g_q+','+g_q+'GENERAL'+g_q+')')=false then
   //?      dm.aborta('ERROR... no puede crear Capacidad GENERAL-.NMP - Convertir a CICS BMS');
end;

procedure Tgral.ArmaArregloAnalizables( );
var
   lwInSQL: string;
   prodclase, lwSale, Wuser, lwLista: string;
   m: tstringlist;
   j: Integer;

begin
   clase_fisico := tstringlist.Create; // Arma arreglo de fisicos
   clase_descripcion := tstringlist.Create;
   clase_analizable := tstringlist.Create; // Arma arreglo de analizables
   clase_todas := tstringlist.Create; // Arma arreglo de todas las clases
   clase_descripcion_todas := tstringlist.Create;
   {
    if dm.sqlselect(dm.q1,'select cclase,descripcion from tsclase '+
       ' where objeto='+g_q+'FISICO'+g_q+
       ' order by cclase') then begin
       while not dm.q1.Eof do begin
          clase_fisico.Add(dm.q1.fieldbyname('cclase').AsString);
          clase_descripcion.Add(dm.q1.fieldbyname('descripcion').AsString);
          dm.q1.Next;
       end;
    end;
    }
   Wuser := 'ADMIN'; //Temporal  JCR
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
         end
         else begin
            ProdClase := 'FALSE';
            CONTINUE;
         end;

      end;
   end;
   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where tipo=' + g_q + 'ANALIZABLE' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         clase_analizable.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         dm.q1.Next;
      end;
   end;
   if dm.sqlselect( dm.q1, 'select cclase,descripcion from tsclase ' +
      ' where estadoactual=' + g_q + 'ACTIVO' + g_q +
      ' order by cclase' ) then begin
      while not dm.q1.Eof do begin
         clase_todas.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         clase_descripcion_todas.Add( dm.q1.fieldbyname( 'descripcion' ).AsString );
         dm.q1.Next;
      end;
   end;
   Warmo_arreglos := 1;
end;

function Tgral.HexToInt( HexNum: string ): LongInt;
begin
   Result := StrToInt( '$' + HexNum );
end;

procedure Tgral.CambiaValorObjeto;
begin
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'OBJVIR' + g_q ) = false then begin
      if dm.sqlupdate( 'update tsclase set objeto=' + g_q + 'VIRTUAL' + g_q +
         ' where cclase in (' + g_q + 'DEL' + g_q + ',' + g_q + 'ETP' + g_q + ',' + g_q + 'FIL' + g_q +
         ',' + g_q + 'INS' + g_q + ',' + g_q + 'LOC' + g_q + ',' + g_q + 'REP' + g_q +
         ',' + g_q + 'UTI' + g_q + ',' + g_q + 'UPD' + g_q + ')' +
         ' or cclase like ' + g_q + 'W%' + g_q ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede actualizar tsclase-objeto' ) ),
            pchar( dm.xlng( 'Cambiar valor del objeto (Físico-Virtual) ' ) ), MB_OK );
         exit;
      end
      else begin
         dm.sqlupdate( 'update tsclase set objeto=' + g_q + 'FISICO' + g_q + ' where cclase in (' + g_q + 'STP' + g_q + ')' );
         if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
            g_q + 'OBJVIR' + g_q + ',1,' + g_q + ' ' + g_q + ',' + g_q + 'Control CLASE-OBJETO' + g_q + ')' ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... no inserto registro en la tabla parametro(OBJVIR)' ) ),
               pchar( dm.xlng( 'Cambiar valor del objeto (Físico-Virtual) ' ) ), MB_OK );
            application.Terminate;
            abort;
         end;
      end;
   end;
end;

procedure Tgral.ActivaSoloClasesUsadas;
begin
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'CLACTI' + g_q ) = false then begin
      dm.sqlupdate( 'update tsclase set estadoactual=' + g_q + 'INACTIVO' + g_q );
      SQL_ActivaClases( 'pcclase' );
      SQL_ActivaClases( 'hcclase' );
      SQL_ActivaClases( 'occlase' );
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
         g_q + 'CLACTI' + g_q + ',1,' + g_q + ' ' + g_q + ',' + g_q + 'ACTIVA SOLO CLASES USADAS' + g_q + ')' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no inserto registro en la tabla parametro (CLACTI)' ) ),
            pchar( dm.xlng( 'Activar Clases usadas' ) ), MB_OK );
         application.Terminate;
         abort;
      end;
   end;
end;

procedure Tgral.SQL_ActivaClases( Wclase: string );
var
   Wsql, Wdato: string;
begin
   Wsql := 'select unique ' + Wclase + ' from tsrela';
   if dm.sqlselect( dm.q1, Wsql ) then begin
      while not dm.q1.Eof do begin
         Wdato := dm.q1.fieldbyname( Wclase ).asstring;
         Wsql := 'update tsclase set estadoactual=' + g_q + 'ACTIVO' + g_q +
            ' where cclase =' + g_q + Wdato + g_q;
         if dm.sqlupdate( Wsql ) = false then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede actualizar tsclase-estadoactual' ) ),
               pchar( dm.xlng( 'Activar Clases usadas' ) ), MB_OK );
            exit;
         end;
         dm.q1.Next;
      end;
   end;
end;

function Tgral.EsNumerico( const S: string ): Boolean;
var
   P: PChar;
begin
   P := PChar( S );
   Result := False;
   while P^ <> #0 do begin
      if not ( P^ in [ '0'..'9' ] ) then
         Exit;
      Inc( P );
   end;
   Result := True;
end;

procedure Tgral.JerarquiaClases( tipo : integer);
var
   fmDigraSistema : TfmDigraSistema;
   jerCla : TalkFormJerCla;
   sist : String;
   no_sist : integer;
   sists:TStringList;
begin
   screen.Cursor := crsqlwait;

   //Para actualizar la jerarquia de clases para el diagrama de sistema
   if (tipo = 1) or (alkSistema='') then begin  //si la pide desde el menu administrar o viene vacia la variable del sistema
      if dm.sqlselect(dm.q1,'select csistema from tssistema;') then begin
      //if dm.sqlselect(dm.q1,'select distinct sistema from tsrela') then begin
         no_sist:=dm.q1.RecordCount;
         if no_sist = 1 then
            sist:=  dm.q1.FieldByName( 'csistema' ).AsString
            //sist:=  dm.q1.FieldByName( 'sistema' ).AsString
         else begin
            sists:=TStringList.Create;
            while not dm.q1.Eof do begin
               sists.Add(dm.q1.FieldByName( 'csistema' ).AsString);
               //sists.Add(dm.q1.FieldByName( 'sistema' ).AsString);
               dm.q1.Next;
            end;
            //traer la ventana para mostrar todos los sistemas
            jerCla:=TalkFormJerCla.Create(self);
            jerCla.llena_sistemas(sists);
            try
               jerCla.ShowModal;
            finally
               jerCla.Free;
            end;
            if alkSistema <> '' then
               sist:=alkSistema
            else
               ShowMessage('ERROR al traer sistema');
         end;
      end;
   end
   else
      sist:=alkSistema;

   Application.MessageBox( PChar('Actualizará Jerarquia de Clases para' + chr( 13 ) +
                           ' Diagrama de Sistema del sistema ' + sist + '.' + chr( 13 ) + chr( 13 ) +
                           ' El proceso puede tardar unos minutos '),
                           PChar('Administración'), MB_OK );

   try     //ALK  diagrama de sistema
      fmDigraSistema:=TfmDigraSistema.Create(self);
      fmDigraSistema.FormStyle := fsNormal;
      fmDigraSistema.Visible := False;
      fmDigraSistema.jerarquia_clases(sist);
      fmDigraSistema.Free;
      Application.MessageBox( 'Jerarquia de clases Actualizadas', 'Administración ', MB_OK );
   except
      on E: exception do begin
         Application.MessageBox( PChar( 'ERROR al cargar Jerarquia de clases. ' + E.Message ), 'Diagrama de Sistema', MB_OK );
         exit;
      end;
   end;
   screen.Cursor := crdefault;
end;

procedure Tgral.LimpiaInventario( );
var
   fmDigraSistema : TfmDigraSistema;
begin
   screen.Cursor := crsqlwait;

   if dm.sqlselect( dm.q4, ' select * from user_procedures where OBJECT_NAME = ' + g_q + 'INVENTARIO_TOTAL' + g_q ) = FALSE then begin
      Application.MessageBox( PChar( 'No existe el proceso:  INVENTARIO_TOTAL ' ), 'Actualiza Inventario', MB_OK );
      Exit;
   end;
   if dm.sqlselect( dm.q4, ' select * from user_procedures where OBJECT_NAME = ' + g_q + 'GENERA_INVENTARIO' + g_q ) = FALSE then begin
      Application.MessageBox( PChar( 'No existe el proceso:  GENERA_INVENTARIO' ), 'Actualiza Inventario', MB_OK );
      Exit;
   end;
   try
      Application.MessageBox( 'Se actualizara el Inventario de componentes.'+ chr( 13 ) +
                              'El proceso puede tardar unos minutos. ', 'Administración ', MB_OK );
      dm.spInventarioTotal.Prepared := True;
      dm.spInventarioTotal.ExecProc;

      Application.MessageBox( 'Inventario Actualizado', 'Administración ', MB_OK );
   except
      on E: exception do begin
         Application.MessageBox( PChar( 'Al actualizar archivo de Inventario. ' + E.Message ), 'ERROR', MB_OK );
         exit;
      end;
   end;

   // -------- EJECUTA PROCESO DE JERARQUIA DE CLASES ALK -----------
   //para indicar que tome el sistema del combo de la ventana de recepcion
   //JerarquiaClases(0);   //se quita a peticion de Martha 260716

   // -------- EJECUTA PROCESO DE CLASES ACTIVAS/INACTIVAS ----------
   ftsmain.dxBarButton3Click(self);

   screen.Cursor := crdefault;
end;

procedure Tgral.GetImagen00( );
var
   arch: string;
begin
   if dm.sqlselect( dm.q1, 'select descripcion from tsutileria' +
      ' where cutileria = ' + g_q + 'IMAGEN_LUPA' + g_q ) then begin
      dm.get_utileria( 'IMAGEN_LUPA', g_tmpdir + '\IMAGEN_LUPA.PNG' );
      if dm.sqlselect( dm.q1, 'select descripcion from tsutileria' +
         ' where cutileria = ' + g_q + 'SysMiningAUX00' + g_q ) then begin
         dm.get_utileria( 'SysMiningAUX00', g_tmpdir + '\SysMiningAUX00.HTML' );
      end;
      arch := g_tmpdir + '\SysMiningAUX00.HTML';
      g_borrar.Add( arch );
      arch := g_tmpdir + '\IMAGEN_LUPA.PNG';
      g_borrar.Add( arch );
   end;
end;

procedure Tgral.LetrasDeUnidades( TS: TStringList );
var
   Unidades: DWord;
   i: Byte;
begin
   Unidades := GetLogicalDrives;
   for i := 1 to 32 do begin
      if Unidades shr i and 1 = 1 then
         TS.Add( Chr( 65 + i ) + ':' );
   end;
end;

procedure Tgral.BuscaUnidadLibre( );
var
   slUnidades, slPosUni: Tstringlist;
   i, ii: integer;
   Unidades, UniLibre: string;
begin
   slPosUni := tstringlist.Create;
   Unidades := 'A:,B:,C:,D:,E:,F:,G:,H:,I:,J:,K:,L:,M:,N:,O:,P:,Q:,R:,S:,T:,U:,W:,X:,Y:,Z:';
   slPosUni.CommaText := Unidades;
   slUnidades := tstringlist.Create;
   try
      LetrasDeUnidades( slUnidades );
      for i := 0 to slPosUni.Count - 1 do begin
         for ii := 0 to slUnidades.count - 1 do begin
            if slPosUni[ i ] = UPPERCASE( slUnidades[ ii ] ) then begin
               UniLibre := '';
               break;
            end
            else
               UniLibre := slPosUni[ i ]
         end;
         if UniLibre <> '' then begin
            g_unidad_libre := UniLibre;
            break;
         end;
      end;
   finally
      slUnidades.Free;
      slPosUni.Free;
   end;
end;

function Tgral.bPubVentanaActiva( sParCaption: string ): Boolean;
var
   i: Integer;
   bPriExisteFrm: Boolean;
   sPass: string;
begin
   //buscar si existe una ventana activa de acuerdo al caption de la forma a buscar
   bPriExisteFrm := False;

   with ftsmain do
      for i := 0 to MDIChildCount - 1 do begin
         sPass := UpperCase( MDIChildren[ i ].Caption );
         //showmessage(UpperCase( MDIChildren[ i ].Caption )+'    '+ UpperCase( sParCaption ));
         if UpperCase( MDIChildren[ i ].Caption ) = UpperCase( sParCaption ) then begin
            bPriExisteFrm := True;
            MDIChildren[ i ].BringToFront;
            Break;
         end;
      end;

   bPubVentanaActiva := bPriExisteFrm;
end;

function Tgral.iPubVentanasActivas: Integer;
begin
   //numero de ventana activa
   iPubVentanasActivas := ftsmain.MDIChildCount;
end;

procedure Tgral.PubExpandeMenuVentanas( bParExpande: Boolean );
begin
   ftsmain.gVentanas.Expandable := bParExpande;
   ftsmain.gVentanas.Expanded := bParExpande;
   /////JCRftsmain.gVentanas.Visible := bParExpande;
end;

procedure Tgral.PubMuestraProgresBar( bParVisible: Boolean );
var
   i,j: integer;
begin
   with ftsmain do begin
      if bParVisible then begin
         dxBarProgress.Visible := ivAlways;
         dxBarProgress.Position := 0;
      end
      else
         dxBarProgress.Visible := ivNever;

      j:=0;
      for i := 0 to MDIChildCount - 1 do         // para que si esta maximizada, no las minimice   ALK
         if MDIChildren[ i ].WindowState = wsMaximized then begin
            j:=1;
            break;
         end;
         
      if j=0 then
         arregla_cascada();    // alk para que arregle todo en cascada
   end;
end;

procedure Tgral.PubAvanzaProgresBar;
begin
   ftsmain.dxBarProgress.StepIt;
end;

function Tgral.iPubEstiloActivo: TdxBarManagerStyle;
begin
   iPubEstiloActivo := ftsmain.mnuPrincipal.Style
end;

procedure Tgral.PubEstiloActivo( var PardxStatusBar: TdxStatusBar );
// en su momento incorporar mas elementos
begin
   PardxStatusBar.PaintStyle := ftsmain.stbPrincipal.PaintStyle;
end;

function Tgral.bPubVentanaMaximizada: Boolean;
var
   i: Integer;
   bPriVenMax: Boolean;
begin
   bPriVenMax := False;

   with ftsmain do
      for i := 0 to MDIChildCount - 1 do begin
         if MDIChildren[ i ].WindowState = wsMaximized then begin
            bPriVenMax := True;
            Break;
         end;
      end;

   bPubVentanaMaximizada := bPriVenMax;
end;

function Tgral.bPubConsultaActiva( sParCaption: string; sParFechaHora: string ): Boolean;
var
   i: Integer;
   bPriExisteSQL: Boolean;
begin
   //buscar si existe una consulta activa de acuerdo al caption de la forma a buscar
   bPriExisteSQL := False;
   with dm.tabConsultas do
      for
         i := 0 to RecordCount - 1 do begin
         //showmessage(UpperCase( MDIChildren[ i ].Caption )+'    '+ UpperCase( sParCaption ));
         if UpperCase( sParCaption ) = UpperCase( dm.tabConsultas.FieldByName( 'ConsultaCaption' ).AsString ) then begin
            bPriExisteSQL := True;

            //MDIChildren[ i ].BringToFront;
            Break;
         end;
      end;
   bPubConsultaActiva := bPriExisteSQL;
end;

procedure Tgral.aisla_rutina_Visual_Basic_PopUp( nombre: string; FteTodo: Tstringlist );

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
   while i < FteTodo.Count - 2 do begin
      w2 := uppercase( FteTodo[ i ] );
      if ( pos( nombre, w2 ) > 0 ) then begin
         if ( pos( 'PRIVATE ', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'PRIVATE SUB', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'DECLARE ', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC ', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC SUB ', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'FUNCTION ', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'PUBLIC FUNCTION ', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'BEGIN ', uppercase( FteTodo[ i ] ) ) > 0 ) or
            ( pos( 'SUB ', uppercase( FteTodo[ i ] ) ) > 0 ) then begin
            if ( pos( 'BEGIN ', uppercase( FteTodo[ i ] ) ) > 0 ) then
               Wbegin := Wbegin + 1;
            W.add( FteTodo[ i ] );
            ii := i + 1;
            i := i + FteTodo.Count + 1;
         end;
      end;
      try
         i := i + 1;
      except
      end;
   end;

   if Wbegin > 0 then begin
      while ( Wbegin <> Wend ) do begin
         if ( pos( 'BEGIN', uppercase( FteTodo[ ii ] ) ) > 0 ) then
            Wbegin := Wbegin + 1;
         if ( pos( 'END', uppercase( FteTodo[ ii ] ) ) > 0 ) then
            Wend := Wend + 1;
         W.add( FteTodo[ ii ] );
         ii := ii + 1;
         if ii > FteTodo.Count - 2 then begin
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
         ( pos( 'END SUB', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         ( pos( 'PRIVATE ', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         ( pos( 'PRIVATE SUB', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         ( pos( 'DECLARE', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         ( pos( 'PUBLIC', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         ( pos( 'PUBLICSUB', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         ( pos( 'FUNCTION', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         ( pos( 'PUBLIC FUNCTION', uppercase( FteTodo[ ii ] ) ) < 1 ) and
         //( pos( 'BEGIN ', uppercase( FteTodo[ ii ] ) ) < 1 ) and
//( pos( 'SUB ', uppercase( FteTodo[ ii ] ) ) < 1 ) and
      ( ii < FteTodo.Count - 2 ) do begin
         if ( pos( ' EXIT ', uppercase( FteTodo[ ii ] ) ) < 1 ) then
            W.add( FteTodo[ ii ] );
         ii := ii + 1;
      end;
      W.add( FteTodo[ ii ] );
   end;

   W2 := g_tmpdir + '\' + nombre + '.txt';
   W.savetofile( W2 );
   ShellExecute( 0, 'open', pchar( W2 ), nil, PChar( g_tmpdir ), SW_SHOW );
   { try    /// ponerlo en otro lugar del programa, porque borra el archivo antes de que se edite.
       deletefile( g_tmpdir + '\'+nombre + '.txt' );
    except
    end;}
   W.Free;
end;

function Tgral.ArmarMenuGpoCompWeb( b1: tstringlist; nomproc: string ): tstringlist;
var
   panta: Tfsvsdelphi;
   m: Tstringlist;
   k: Tstringlist;
   i: Integer;
begin
   m := Tstringlist.Create;
   k := Tstringlist.Create;

   for i := 0 to b1.count - 1 do begin
      bgral := stringreplace( trim( b1[ i ] ), '_', '|', [ rfReplaceAll ] );
      bgral := stringreplace( trim( bgral ), '¿', ' ', [ rfReplaceAll ] );
      m.CommaText := bgral; //nombre bib clase
      k.add( bgral + ',' + stringreplace( trim( bgral ), '|', '_', [ rfReplaceAll ] ) + ',' + inttostr( k.count - 1 ) );

   end;
   ArmarMenuGpoCompWeb := k;
end;

procedure Tgral.EjecutaOpcionGpoComp( b1: Tstringlist; tex: string );
var
   ii, i, p, p1, j, j1, i2: integer;
   b2, b3, b4, Opciones: Tstringlist;
   t, NomProg: string;
   k, y: integer;
   Wcomponente, ks: string;
   tt, SubmenuItem, Item: TMenuItem;
begin
   g_texto := tex;
   p := b1.Count;
   b2 := Tstringlist.Create;
   b3 := Tstringlist.Create;
   l_b3 := Tstringlist.Create;
   gral.PopGral00.Items.Clear;
   ControEleccion := 0;
   ii := 0;
   i2 := 0;
   for j := 0 to p - 1 do begin
      bgral := '';
      b2.clear;
      b2.CommaText := b1[ j ];
      tt := Tmenuitem.Create( gral.PopGral00 );
      tt.Caption := stringreplace( b2[ 0 ], '|', ' ', [ rfReplaceAll ] );
      tt.OnClick := CompElegido;
      gral.PopGral00.Items.Add( tt );

      b4 := Tstringlist.Create;
      b4.CommaText := stringreplace( b2[ 0 ], '|', ' ', [ rfReplaceAll ] );
      bgral := b4[ 2 ] + '|' + b4[ 1 ] + '|' + b4[ 0 ];
      b4.free;

      Opciones := gral.ArmarMenuConceptualWeb( bgral, 'diagramajcl' );
      p1 := Opciones.count;
      b3 := Tstringlist.Create;

      for j1 := 0 to p1 - 1 do begin
         b3.clear;
         b3.CommaText := opciones[ j1 ];

         SubmenuItem := TMenuItem.Create( tt );

         NombreProceso := stringreplace( b3[ 1 ], '|', ' ', [ rfReplaceAll ] );
         SubmenuItem.Caption := stringreplace( b3[ 0 ], '|', ' ', [ rfReplaceAll ] );

         tt.Add( SubmenuItem );

         k := tt.Count - 1;
         gral.PopGral00.Images := dm.ImageList3;
         {
           b4:=Tstringlist.Create;
           b4.CommaText:=tt.Caption;
           bgral := b4[2]+' '+b4[1]+' '+b4[0];
           b4.free;
          }
         if Nombreproceso = 'formadelphi_preview' then begin
            tt.Items[ k ].OnClick := formadelphi_preview;
            continue;
         end;
         if Nombreproceso = 'formavb_preview' then begin
            tt.Items[ k ].OnClick := formavb_preview;
            continue;
         end;
         if Nombreproceso = 'panel_preview' then begin
            tt.Items[ k ].OnClick := panel_preview;
            continue;
         end;
         if Nombreproceso = 'natural_mapa_preview' then begin
            tt.Items[ k ].OnClick := natural_mapa_preview;
            continue;
         end;
         if Nombreproceso = 'diagramanatural' then begin
            tt.Items[ k ].OnClick := diagramanatural;
            continue;
         end;
         if Nombreproceso = 'analisis_impacto' then begin
            tt.Items[ k ].OnClick := analisis_impacto;
            tt.Items[ k ].ImageIndex := 12;
            continue;
         end;
         if Nombreproceso = 'diagramaproceso' then begin
            tt.Items[ k ].OnClick := diagramaproceso;
            tt.Items[ k ].ImageIndex := 9;
            continue;
         end;
         if Nombreproceso = 'referencias_cruzadas' then begin
            tt.Items[ k ].OnClick := referencias_cruzadas;
            tt.Items[ k ].ImageIndex := 13;
            continue;
         end;
         if Nombreproceso = 'Documentacion' then begin
            tt.Items[ k ].OnClick := Documentacion;
            continue;
         end;
         //if Nombreproceso='reglas_negocio'       then begin tt.Items[k].OnClick:=reglas_negocio;        continue; end;
         if Nombreproceso = 'versionado' then begin
            tt.Items[ k ].OnClick := versionado;
            continue;
         end;
         if Nombreproceso = 'fmb_vista_pantalla' then begin
            tt.Items[ k ].OnClick := fmb_vista_pantalla;
            continue;
         end;
         if Nombreproceso = 'vista_htm' then begin
            tt.Items[ k ].OnClick := vista_htm;
            continue;
         end;
         if Nombreproceso = 'bms_preview' then begin
            tt.Items[ k ].OnClick := bms_preview;
            continue;
         end;
         if Nombreproceso = 'diagramacbl' then begin
            tt.Items[ k ].OnClick := diagramacbl;
            tt.Items[ k ].ImageIndex := 10;
            continue;
         end;
         if Nombreproceso = 'diagramaVisustin' then begin
            tt.Items[ k ].OnClick := diagramaVisustin;
            tt.Items[ k ].ImageIndex := 10;
            continue;
         end;
         if Nombreproceso = 'dghtml' then begin
            tt.Items[ k ].OnClick := dghtml;
            continue;
         end;
         if Nombreproceso = 'diagramarpg' then begin
            tt.Items[ k ].OnClick := diagramarpg;
            continue;
         end;
         if Nombreproceso = 'tabla_crud' then begin
            tt.Items[ k ].OnClick := tabla_crud;
            tt.Items[ k ].ImageIndex := 5;
            continue;
         end;
         if Nombreproceso = 'archivos_fisicos' then begin
            tt.Items[ k ].OnClick := archivos_fisicos;
            tt.Items[ k ].ImageIndex := 5;
            continue;
         end;
         {if Nombreproceso = 'archivos_logicos' then begin
            tt.Items[ k ].OnClick := archivos_logicos;
            tt.Items[ k ].ImageIndex := 5;
            continue;
         end;  }
         if Nombreproceso = 'adabas_crud' then begin
            tt.Items[ k ].OnClick := adabas_crud;
            tt.Items[ k ].ImageIndex := 5;
            continue;
         end;
         if Nombreproceso = 'diagramajcl' then begin
            tt.Items[ k ].OnClick := diagramajcl;
            continue;
         end;
         if Nombreproceso = 'diagramaase' then begin
            tt.Items[ k ].OnClick := diagramaase;
            continue;
         end;
         if Nombreproceso = 'lista_componentes' then begin
            tt.Items[ k ].OnClick := lista_componentes;
            tt.Items[ k ].ImageIndex := 4;
            Continue;
         end;
         if Nombreproceso = 'lista_dependencias' then begin
            tt.Items[ k ].OnClick := lista_dependencias;
            tt.Items[ k ].ImageIndex := 4;
            Continue;
         end;
         if Nombreproceso = 'propiedades' then begin
            tt.Items[ k ].OnClick := propiedades;
            continue;
         end;
         if Nombreproceso = 'atributos' then begin
            tt.Items[ k ].OnClick := atributos;
            continue;
         end;
         if Nombreproceso = 'Ver_Fuente' then begin
            tt.Items[ k ].OnClick := Ver_Fuente;
            tt.Items[ k ].ImageIndex := 14;
            continue;
         end;
         if Nombreproceso = 'exporta' then begin
            tt.Items[ k ].OnClick := exporta;
            continue;
         end;
         if Nombreproceso = 'exportaProc' then begin
            tt.Items[ k ].OnClick := exportaProc;
            continue;
         end;
         if Nombreproceso = 'exportaJCL' then begin
            tt.Items[ k ].OnClick := exportaJCL;
            continue;
         end;
         if Nombreproceso = 'CambiaColorClase' then begin
            tt.Items[ k ].OnClick := CambiaColorClase;
            tt.Items[ k ].ImageIndex := 11;
            continue;
         end;
         if Nombreproceso = 'Diagrama Scheduler' then begin
            tt.Items[ k ].OnClick := scheduler;
            tt.Items[ K ].ImageIndex := 17;
            continue;
         end;
         if Nombreproceso = 'diagrama_bloques' then begin
            tt.Items[ k ].OnClick := DiagramaBloques;
            continue;
         end;
      end;
      b3.Free;
   end;

   b2.free;
end;

procedure Tgral.CompElegido( Sender: TObject );
var
   SubmenuItem, Item: TMenuItem;
begin
   SubmenuItem := Sender as TMenuItem;
   // delete old items (leave at least one to keep the submenu)
  // while SubmenuItem.Count > 1 do
   //      SubmenuItem.Items[SubmenuItem.Count - 1].Free;
end;

procedure Tgral.EjecutaOpcionSubMenu( b1s: Tstringlist; tex: string; objeto: integer );
begin
end;

function Tgral.ArmarOpcionSubMenu( b1: Tstringlist; Objeto: integer ): integer;
begin
end;

//  --------------  ALK
procedure Tgral.ListaDrillDown( Sender: Tobject ); //lista Drill Down
var
   iArreglo: Integer;
   sTitulo: string;
   m: Tstringlist;
   icont,ierror: integer;  //alk out of system
   numero_registros:integer;
begin
   m := Tstringlist.Create;
   Screen.Cursor := crSQLWait;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta clase ó biblioteca ó nombre' ),
            pchar( sLISTA_DRILLDOWN ), MB_OK );
         exit;
      end;

      sTitulo := sLISTA_DRILLDOWN + ' ' + m[ 2 ]+ ' ' + m[ 1 ]+ ' ' + m[ 0 ];

      if bPubVentanaActiva( sTitulo ) then
         Exit;

      if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
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
         ' START WITH T.pCPROG = '+g_q+m[0]+g_q+
         '        AND T.pCBIB = '+g_q+m[1]+g_q+
         '        AND T.pCCLASE = '+g_q+m[2]+g_q+
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


      if bPubVentanaMaximizada = False then begin
         fmListaDrill[ iArreglo ].Width := g_Width;
         fmListaDrill[ iArreglo ].Height := g_Height;
      end;

      fmListaDrill[ iArreglo ].PubGeneraLista( DrillDown, m[ 2 ], m[ 1 ], m[ 0 ], sTitulo );
      fmListaDrill[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tgral.ListaDrillUp( Sender: Tobject ); //lista Drill Up
var
   iArreglo: Integer;
   sTitulo: string;
   m: Tstringlist;
   icont,ierror: integer;  //alk out of system
   numero_registros:integer;
begin
   m := Tstringlist.Create;
   Screen.Cursor := crSQLWait;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta clase ó biblioteca ó nombre' ),
            pchar( sLISTA_DRILLDOWN ), MB_OK );
         exit;
      end;

      sTitulo := sLISTA_DRILLUP + ' ' + m[ 2 ]+ ' ' + m[ 1 ]+ ' ' + m[ 0 ];

      if bPubVentanaActiva( sTitulo ) then
         Exit;

      iArreglo := Length( fmListaDrill );
      SetLength( fmListaDrill, iArreglo + 1 );
      {
      numero_registros:=dm.cuenta_registros('select count(*) '+
         ' FROM TSRELA t '+
         //' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.hCPROG = '+g_q+m[0]+g_q+
         '        AND T.hCBIB = '+g_q+m[1]+g_q+
         '        AND T.hCCLASE = '+g_q+m[2]+g_q+
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

      fmListaDrill[ iArreglo ].PubGeneraLista( DrillUp,  m[ 2 ], m[ 1 ], m[ 0 ], sTitulo );
      fmListaDrill[ iArreglo ].Show;

      dm.PubRegistraVentanaActiva( sTitulo );
   finally
      PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

// -----------------------------------

procedure Tgral.Scheduler( Sender: TObject );
var
   m: Tstringlist;
   k1: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
   scheduler : TalkFormScheduler;
   lslFuente : TStringList;
begin
   iHelpContext := 2400;
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta clase ó biblioteca ó nombre' ),
            pchar( sDIGRA_SCHEDULER ), MB_OK );
         exit;
      end;
      //titulo := 'DgrScheduler_' + m[ 2 ] + '_' + m[ 1 ] + '_' + m[ 0 ]+ '_' + m[ 3 ];
      titulo := m[ 2 ] + '_' + m[ 1 ] + '_' + m[ 0 ]+ '_' + m[ 3 ];

      {****** NUEVA FUNCION    ALK   *******}
      scheduler:=TalkFormScheduler.Create(self);
      scheduler.get_nombre(titulo,m[ 2 ],m[ 0 ],m[3]);
      lslFuente := Tstringlist.Create;
      if (m[ 2 ] = 'CTM') then begin
         if dm.sqlselect(dm.q1,'select distinct ocprog,ocbib,occlase from tsrela '+
            ' where hcprog='+g_q+m[0]+g_q+
            ' and   hcbib='+g_q+m[1]+g_q+
            ' and   hcclase='+g_q+m[2]+g_q+
            ' and   occlase in ('+g_q+'CTM'+g_q+','+g_q+'CTR'+g_q+') '+
            ' order by occlase') then begin
            //Traer el fuente desde base de datos, ya no como utileria
            //if (dm.trae_fuente( m[3],m[4], m[6], m[5], lslFuente )= False) then begin
            //if (dm.trae_fuente( m[3],m[0], m[1], m[2], lslFuente )= False) then begin
            //<20161110.13:00> Trae al propietario para encontrar el fuente del scheduler
            if (dm.trae_fuente( m[3],dm.q1.fieldbyname('ocprog').AsString,
               dm.q1.fieldbyname('ocbib').AsString,
               dm.q1.fieldbyname('occlase').AsString, lslFuente )= False) then begin
               Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
                     pchar( dm.xlng( 'AVISO ' ) ), MB_OK );
               lslFuente.Free;
               exit;
            end;
         end
         else begin
            Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
                  pchar( dm.xlng( 'AVISO ' ) ), MB_OK );
            lslFuente.Free;
            exit;
         end;
         lslFuente.SaveToFile( g_tmpdir + '\fte_' +titulo );
         scheduler.es_CTM;
         scheduler.Free;
      end
      else begin
         //Traer el fuente desde base de datos, ya no como utileria
         if (dm.trae_fuente( m[3], m[ 0 ],  m[ 1 ], m[ 2 ], lslFuente )= False) then begin
            Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
                  pchar( dm.xlng( 'AVISO ' ) ), MB_OK );
            lslFuente.Free;
            exit;
         end;
         lslFuente.SaveToFile( g_tmpdir + '\fte_' +titulo );
         try
            scheduler.ShowModal;
         finally
            scheduler.Free;
         end;
      end;
      lslFuente.Free;
      {*************************************}



      {
      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k1 := length( fmScheduler );
      setlength( fmScheduler, k1 + 1 );
      //fmScheduler[ k1 ] := TfmScheduler.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmScheduler[ k1 ] := TfmScheduler.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmScheduler[ k1 ] := TfmScheduler.Create( Self );
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
         fmScheduler[ k1 ].Width := g_Width;
         fmScheduler[ k1 ].Height := g_Height;
      end;

      fmScheduler[ k1 ].PubGeneraDiagrama( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ], titulo );
      fmScheduler[ k1 ].Show;
      dm.PubRegistraVentanaActiva( Titulo );
      }
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tgral.DiagramaBloques( Sender: TObject );
var
   m: Tstringlist;
   k1: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   iHelpContext := 2400;
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta clase ó biblioteca ó nombre' ),
            pchar( sDIGRA_BLOQUES ), MB_OK );
         exit;
      end;
      titulo := sDIGRA_BLOQUES + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      if not dm.es_SCRATCH(m[3], m[0], m[1], m[2]) then begin
         Application.MessageBox( pchar( dm.xlng( 'No se puede generar porque: '+ chr( 13 ) +
                                                 alkSCRATCH ) ),
         pchar( dm.xlng( 'Aviso' ) ), MB_OK );
         exit;
      end;

      k1 := length( fmBloques );
      setlength( fmBloques, k1 + 1 );

      //fmBloques[ k1 ] := TfmBloques.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      try
         fmBloques[ k1 ] := TfmBloques.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmBloques[ k1 ] := TfmBloques.Create( Self );
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

      fmBloques[ k1 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         fmBloques[ k1 ].Width := g_Width;
         fmBloques[ k1 ].Height := g_Height;
      end;

      fmBloques[ k1 ].PubGeneraDiagrama( m[ 2 ], m[ 1 ], m[ 0 ], m[ 3 ], titulo );
      fmBloques[ k1 ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

function Tgral.extrae_rutina( Nombre: string; LineaInicio: Integer; LineaFinal: Integer; memo: Tstrings ): string;
var
   i, ii: integer;
   w2: string;
   W: Tstringlist;
begin
   i := 0;
   W := Tstringlist.create;
   if LineaFinal > memo.Count then
      LineaFinal := memo.Count;

   if LineaFinal = 0 then
      LineaFinal := LineaInicio + 1;

   for i := LineaInicio - 1 to LineaFinal - 1 do begin
      W.Add( memo.Strings[ i ] );
   end;
   bGlbQuitaCaracteres( Nombre );
   W2 := g_tmpdir + '\' + Nombre + '_' + IntToStr( LineaInicio ) + '_' + IntToStr( LineaFinal ) + '.txt';
   W.savetofile( W2 );
   //ShellExecute( 0, 'open', pchar( W2 ), nil, PChar( g_tmpdir ), SW_SHOW );
   W.Free;
   Result := W2;
end;

procedure tgral.CapacidadXProducto;
var
   i: Integer;
   ListaClases: string;
begin
   if dm.sqlselect( dm.q1, 'select count(*) total from tsproductos ' ) then begin
      if ( dm.q1.FieldByName( 'total' ).AsInteger = 0 ) then begin

         if dm.sqlselect( dm.q1, 'select cclase from  tsclase where estadoactual =' + g_q + 'ACTIVO' + g_q +
            //                               ' and objeto = '+g_q+'FISICO'+g_q+
            ' and cclase not in ( ' + g_q + 'CLA' + g_q + ',' + g_q + 'DIR' + g_q + ')' +
            ' and cclase in (' +
            'select pcclase cclase from tsrela group by pcclase  union ' +
            '(select  hcclase  cclase from tsrela  group by hcclase union ' +
            ' select  occlase  cclase from tsrela group by occlase)) order by cclase' ) then begin
            ListaClases := '';
            while not dm.q1.Eof do begin
               if dm.q1.fieldbyname( 'cclase' ).AsString <> 'CLA' then
                  ListaClases := trim( ListaClases + dm.q1.fieldbyname( 'cclase' ).AsString ) + ' ';
               dm.q1.Next;
            end;
         end;
         i := 0;
         while i < gral.Productos.Lines.Count - 2 do begin
            if ( gral.Productos.Lines[ i ] = 'MENÚ CONTEXTUAL-DIAGRAMA DE PROCESO' )
               or ( gral.Productos.Lines[ i ] = 'MINING-BASE CONOCIMIENTO' ) then
               dm.sqlinsert( 'insert into tsproductos ' + ' (cuser,ccapacidad,cclaseprod) values(' +
                  g_q + g_usuario + g_q + ',' + g_q + gral.Productos.Lines[ i ] + g_q + ',' + g_q + '' + g_q + ')' )
            else
               dm.sqlinsert( 'insert into tsproductos ' + ' (cuser,ccapacidad,cclaseprod) values(' +
                  g_q + g_usuario + g_q + ',' + g_q + gral.Productos.Lines[ i ] + g_q + ',' + g_q + ListaClases + g_q + ')' );
            inc( i );
         end;
      end;
   end;
end;

procedure tgral.diagramaGenDiagramas( sParProducto, sParTipoDiagrama: String );
var
   lsNomCompo, lsArchFte, lsClase: String;
   lslFuente, lslCompo: Tstringlist;
   i: integer;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;

   lslCompo := Tstringlist.Create;
   lslCompo.CommaText := bgral; //nombre bib clase
   if lslCompo.Count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta nombre ó biblioteca ó clase ' ) ),
         pchar( dm.xlng( sParProducto + ' ' + lslCompo[ 3 ] ) ), MB_OK );
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   lsClase := lslCompo[ 3 ];
   if lslcompo[ 1 ] = 'SCRATCH' then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
         pchar( dm.xlng( sParProducto + ' ' + lsClase ) ), MB_OK );
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   lslFuente := Tstringlist.Create;
   if dm.trae_fuente( lslCompo[ 3 ], lslCompo[ 0 ], lslCompo[ 1 ], lslCompo[ 2 ], lslFuente ) = False then begin
      Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
         pchar( dm.xlng( sParProducto + ' ' + lslCompo[ 3 ] ) ), MB_OK );
      lslFuente.Free;
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   lsNomCompo := lslCompo[ 0 ];
   bGlbQuitaCaracteres( lsNomCompo );
   lsArchFte := g_tmpdir + '\' + lsNomCompo;
   lslFuente.SaveToFile( lsArchFte );
   farbol.GenerarDiagramaNvo( lsNomCompo, lsArchFte, lslCompo[ 2 ], sParTipoDiagrama , 1, lslCompo[ 3 ],lslCompo[ 1 ]);

   lslCompo.Free;
   lslFuente.Free;
   Screen.Cursor := crDefault;
   gral.PubMuestraProgresBar( False );
end;

procedure Tgral.detalle_tabla( Sender: TObject );
var
   cm_compo, cm_bib, cm_sis, cm_cla, titulo : String;
   lslCompo: Tstringlist;
   icont,ierror: integer;  //alk out of system
   det:TalkFormDetTab;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;

   lslCompo := Tstringlist.Create;
   lslCompo.CommaText := bgral; //nombre bib clase
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

procedure Tgral.codigoMuerto( Sender: TObject );   // funcion para el codigo muerto
var
   cm_compo, cm_bib, cm_sis, cm_cla : String;
   lslCompo: Tstringlist;
begin
   gral.PubMuestraProgresBar( True );
   Screen.Cursor := crSQLWait;

   lslCompo := Tstringlist.Create;
   lslCompo.CommaText := bgral; //nombre bib clase
   if lslCompo.Count < 3 then begin
      Application.MessageBox( pchar( dm.xlng( 'Falta nombre ó biblioteca ó clase ' ) ),
         pchar( dm.xlng( 'Codigo Muerto' ) ), MB_OK );
      lslCompo.free;
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
      exit;
   end;

   try
      cm_compo:=lslCompo[ 0 ];
      cm_bib:=lslCompo[ 1 ];
      cm_sis:=lslCompo[ 3 ];
      cm_cla:=lslCompo[ 2 ];

      ptscomun.codigo_muerto(cm_sis,cm_compo,cm_bib,cm_cla);
   finally
      Screen.Cursor := crDefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tgral.validEstaticas( Sender: TObject );   // funcion para validaciones estaticas
var
   m: Tstringlist;
   k1: integer;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   //iHelpContext := 2400;
   screen.Cursor := crsqlwait;
   m := Tstringlist.Create;
   PubMuestraProgresBar( True );
   try
      m.CommaText := bgral; //nombre bib clase
      if m.Count < 3 then begin
         Application.MessageBox( pchar( 'Falta clase ó biblioteca ó nombre' ),
            pchar( sVAL_ESTATICAS ), MB_OK );
         exit;
      end;
      titulo := sVAL_ESTATICAS + ' ' + m[ 2 ] + ' ' + m[ 1 ] + ' ' + m[ 0 ];

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      k1 := length( ftsestatica );
      setlength( ftsestatica, k1 + 1 );

      // ------ ALK para controlar el error out of system resources ------
      try
         ftsestatica[ k1 ] := Tftsestatica.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsestatica[ k1 ] := Tftsestatica.Create( Self );
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

      ftsestatica[ k1 ].FormStyle := fsMDIChild;

      if gral.bPubVentanaMaximizada = False then begin
         ftsestatica[ k1 ].Width := g_Width;
         ftsestatica[ k1 ].Height := g_Height;
      end;

      ftsestatica[ k1 ].Caption:= titulo;
      ftsestatica[ k1 ].establece_datos( m[ 0 ], m[ 2 ], m[ 1 ], m[ 3 ] );
      ftsestatica[ k1 ].ejecuta_menu( m[ 0 ], m[ 2 ], m[ 1 ], m[ 3 ] );
      ftsestatica[ k1 ].Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      m.free;
      PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

// ALK  para que de las clases que NO deben de llevar las listas dep y comp para arbol/gral
function Tgral.clases_p_listas():TStringList;
var
   clases:TStringList;
begin
   clases:=TStringList.Create;
   clases.Add('CTR');
   clases.Add('CTM');
   clases.Add('LOC');
   clases.Add('TAB');
   clases.Add('TSC');
   clases.Add('LIB');
   clases.Add('UTI');
   clases.Add('XXX');
   clases.Add('BMS');
   clases.Add('NIN');
   clases.Add('NSS');
   clases.Add('REP');
   clases.Add('NUB');
   clases.Add('NDL');
   clases.Add('JPG');
   clases.Add('GIF');
   clases.Add('SWF');
   clases.Add('CAD');
   clases.Add('XSD');
   clases.Add('USERPRO'); // proyecto de Mis proyectos
   clases.Add('USER');  // nodo de Mis proyectos
   clases_p_listas:=clases;
end;

//  ALK funcion para borrar los elementos que ya no se usan
procedure Tgral.borra_elemento(nombre:string ; producto : integer);
var
   i : integer;
begin
   case  producto of
   1 :       //lista de dependencias
   begin
      for i := length( AfmListaDependencias )-1 downto 0 do begin
         if AfmListaDependencias[i].Caption = nombre then
            AfmListaDependencias[i]:=nil;
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
      for i := length( Afmgflcob )-1 downto 0 do begin
         if Afmgflcob[i].Caption = nombre then
            Afmgflcob[i]:=nil;
      end;
   end;

   8 :       //referencias cruzadas
   begin
      for i := length( Aftsrefcruz )-1 downto 0 do begin
         if Aftsrefcruz[i].Caption = nombre then
            Aftsrefcruz[i]:=nil;
      end;
   end;

   9 :       //mapa natural
   begin
      for i := length( Aftsmapanat )-1 downto 0 do begin
         if Aftsmapanat[i].Caption = nombre then
            Aftsmapanat[i]:=nil;
      end;
   end;

   10 :       //
   begin
      for i := length( Afmgflrpg )-1 downto 0 do begin
         if Afmgflrpg[i].Caption = nombre then
            Afmgflrpg[i]:=nil;
      end;
   end;

   11 :       //diagrama jcl
   begin
      for i := length( Aftsdiagjcl )-1 downto 0 do begin
         if Aftsdiagjcl[i].Caption = nombre then
            Aftsdiagjcl[i]:=nil;
      end;
   end;

   12 :       //Lista de componentes
   begin
      for i := length( fmListaCompo )-1 downto 0 do begin
         if fmListaCompo[i].Caption = nombre then
            fmListaCompo[i]:=nil;
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
      for i := length( Aftsscrsec )-1 downto 0 do begin
         if Aftsscrsec[i].Caption = nombre then
            Aftsscrsec[i]:=nil;
      end;
   end;

   {  FALTAN estos productos que no estan con el try
fmDocumentacion
Aftsgral
Aftsviewhtml
Aftsdghtml
Aftsversionado
Aftsdocumenta
Aftsproperty
Aftsattribute
Aftsbms
Aftsarchivos }

   end;
end;


end.

