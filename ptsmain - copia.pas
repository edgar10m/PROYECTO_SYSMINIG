unit ptsmain;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DB,
   OleCtrls, StdCtrls, jpeg, Menus, SHDocVw, ExtCtrls, dxNavBarCollns, dxNavBarBase, dxNavBar,
   shellapi, dxGDIPlusClasses, cxClasses, cxControls, cxSplitter, dxBarDBNav, dxBar, ImgList,
   cxGraphics, dxStatusBar, cxLookAndFeelPainters, cxButtons, cxLabel, cxMaskEdit, cxContainer,
   cxEdit, cxTextEdit, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
   cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
   cxGrid, dxBarExtItems, cxDropDownEdit, HTML_HELP, htmlhlp, ufmListaCompo, ufmListaDependencias,
   ufmMatrizcrud, DiagramEditor, ptsCreaInd, HtmlHelpViewerEx,ptsestatica;

const
   CONNECTSTRING =
      //dm.ADOConnection1.ConnectionString:='Provider=MSDASQL.1;'+
   'Provider=OraOLEDB.Oracle.1;' +
      'Password=SYSVIEWHELPDESK;Persist Security Info=True;' +
      'User ID=sysview11;Data Source=sysviewsoftscm';

type
   Tftsmain = class( TForm )
      Timer1: TTimer;
      cxSplitter1: TcxSplitter;
      pnlMenu: TPanel;
      mnuPrincipal: TdxBarManager;
      mnuSesion: TdxBarSubItem;
      mnuTerminar: TdxBarButton;
      mnuAyuda: TdxBarSubItem;
      mnuAbout: TdxBarButton;
      mnuIniciar: TdxBarButton;
      stbPrincipal: TdxStatusBar;
      mnuVentanas: TdxBarSubItem;
      munHorizontal: TdxBarButton;
      mnuVertical: TdxBarButton;
      mnuCascada: TdxBarButton;
      mnuMinimizar: TdxBarButton;
      mnuCerrarV: TdxBarButton;
      mnuCatalogos: TdxBarSubItem;
      mnuParametros: TdxBarButton;
      mnuRoles: TdxBarButton;
      mnuUsuarios: TdxBarButton;
      mnuRolUser: TdxBarButton;
      mnuCapacidades: TdxBarButton;
      mnuClases: TdxBarButton;
      mnuOficinas: TdxBarButton;
      mnuSistemas: TdxBarButton;
      mnuBibliotecas: TdxBarButton;
      mnuAdministracion: TdxBarSubItem;
      mnuCaducidad: TdxBarButton;
      mnuMonUser: TdxBarButton;
      mnuUtilerias: TdxBarButton;
      mnuCargaUtil: TdxBarButton;
      mnuCambioPass: TdxBarButton;
      mnuHerramientas: TdxBarSubItem;
      mnuReporteador: TdxBarButton;
      mnuBaseConocimiento2: TdxBarButton;
      Image1: TImage;
      imglogo: TImage;
      ImageList2: TImageList;
      dxNavBar1: TdxNavBar;
      gApplicationMining: TdxNavBarGroup;
      gVentanas: TdxNavBarGroup;
      gFabricaPbasTec: TdxNavBarGroup;
      gConvComp: TdxNavBarGroup;
      gLogin: TdxNavBarGroup;
      mnuBaseConocimiento: TdxNavBarItem;
      mnuBusComponentes: TdxNavBarItem;
      mnuRecComponentes: TdxNavBarItem;
      mnuInvComponentes: TdxNavBarItem;
      mnuLisComponentes: TdxNavBarItem;
      mnuMatrizCrud: TdxNavBarItem;
      mnuMatrizAF: TdxNavBarItem;
      mnuFabPT: TdxNavBarItem;
      mnuConversion: TdxNavBarItem;
      gVentanasControl: TdxNavBarGroupControl;
      grdVentanas: TcxGrid;
      grdVentanasDBTableView1: TcxGridDBTableView;
      grdVentanasDBTableView1VentanaCaption: TcxGridDBColumn;
      grdVentanasLevel1: TcxGridLevel;
      gLoginControl: TdxNavBarGroupControl;
      txtUsuario: TcxTextEdit;
      cxLabel1: TcxLabel;
      cxLabel2: TcxLabel;
      btnAceptar: TcxButton;
      txtPassword: TcxTextEdit;
      dtsVentanas: TDataSource;
      dxBarProgress: TdxBarProgressItem;
      mnuBusComponentes2: TdxBarButton;
      mnuEstilos: TdxBarSubItem;
      mnuWindows: TdxBarButton;
      mnuFlat: TdxBarButton;
      mnuOffice: TdxBarButton;
      dxBarSubItem1: TdxBarSubItem;
      mnuConsulta: TdxBarButton;
      mnuConsComponentes: TdxNavBarItem;
      mnuCasosUso: TdxBarButton;
      dtsCias: TDataSource;
      cxLabel3: TcxLabel;
      txtCia: TcxComboBox;
      mnuSalida: TdxBarButton;
      mnuAyudaGeneral: TdxBarButton;
      mnuAyudaOpc: TdxBarButton;
    mnuActualizaInventario: TdxBarButton;
      DiagramEditor: TDiagramEditor;
      mnuEditorDiagrama: TdxBarButton;
      mnuListaDependencias: TdxNavBarItem;
      gAnalisisEspecificos: TdxNavBarGroup;
      mnuAnalisisProgramas: TdxNavBarItem;
      mnuPropagacionVariables: TdxNavBarItem;
      mnuCreaIndices: TdxBarButton;
      mnuClasesProducto: TdxBarButton;
      mnuTsprogDesc: TdxBarButton;
    mnuDocProductosTipo: TdxNavBarItem;
    gDocumentacion: TdxNavBarGroup;
    //  Bre
    dxBarButtonLisComponentes: TdxBarButton;
    dxBarButtonLisDependencias: TdxBarButton;
    dxBarButtonMatrizCrud: TdxBarButton;
    dxBarButtonMatrizAF: TdxBarButton;
    dxBarButtonRecComponentes: TdxBarButton;
    dxBarButtonInvComponentes: TdxBarButton;
    dxBarSubItem2: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
    dxBarSubItem4: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarSubItem5: TdxBarSubItem;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    mnuCambiosMasivos: TdxNavBarItem;
    gMasivos: TdxNavBarGroup;
    gEstaticas: TdxNavBarGroup;
    mnuEstaticas: TdxNavBarItem;
    mnuMuerto: TdxNavBarItem;
    mnuGeneraDoctos: TdxNavBarItem;
    dxBarSubItem6: TdxBarSubItem;
    dxBarButton6: TdxBarButton;
    hiperliga: TdxBarButton;
    mnuGeneraWord: TdxNavBarItem;
    mnuregestatica: TdxBarSubItem;
    mnuvalestatica: TdxBarButton;
    // ----
      procedure FormCreate( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
      procedure Timer1Timer( Sender: TObject );
      procedure mnuBaseConocimientoClick( Sender: TObject );
      procedure mnuBusComponentesClick( Sender: TObject );
      procedure mnuRecComponentesClick( Sender: TObject );
      procedure mnuInvComponentesClick( Sender: TObject );
      procedure mnuLisComponentesClick( Sender: TObject );
      procedure mnuMatrizCrudClick( Sender: TObject );
      procedure mnuMatrizAFClick( Sender: TObject );
      procedure mnuIniciarClick( Sender: TObject );
      procedure mnuTerminarClick( Sender: TObject );
      procedure mnuAboutClick( Sender: TObject );
      procedure munHorizontalClick( Sender: TObject );
      procedure mnuVerticalClick( Sender: TObject );
      procedure mnuCascadaClick( Sender: TObject );
      procedure mnuMinimizarClick( Sender: TObject );
      procedure mnuCerrarVClick( Sender: TObject );
      procedure mnuParametrosClick( Sender: TObject );
      procedure mnuRolesClick( Sender: TObject );
      procedure mnuUsuariosClick( Sender: TObject );
      procedure mnuRolUserClick( Sender: TObject );
      procedure mnuCapacidadesClick( Sender: TObject );
      procedure mnuClasesClick( Sender: TObject );
      procedure mnuOficinasClick( Sender: TObject );
      procedure mnuSistemasClick( Sender: TObject );
      procedure mnuBibliotecasClick( Sender: TObject );
      procedure mnuCaducidadClick( Sender: TObject );
      procedure mnuMonUserClick( Sender: TObject );
      procedure mnuUtileriasClick( Sender: TObject );
      procedure mnuCargaUtilClick( Sender: TObject );
      procedure mnuCambioPassClick( Sender: TObject );
      procedure mnuReporteadorClick( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure btnAceptarClick( Sender: TObject );
      procedure grdVentanasDBTableView1DblClick( Sender: TObject );
      procedure mnuWindowsClick( Sender: TObject );
      procedure mnuFlatClick( Sender: TObject );
      procedure mnuOfficeClick( Sender: TObject );
      procedure mnuConsultaClick( Sender: TObject );
      procedure mnuConversionClick( Sender: TObject );
      procedure mnuCasosUsoClick( Sender: TObject );
      procedure mnuSalidaClick( Sender: TObject );
      procedure mnuAyudaGeneralClick( Sender: TObject );
      {function FormHelp(Command: Word; Data: Integer;
        var CallHelp: Boolean): Boolean; }
      procedure mnuAyudaOpcClick( Sender: TObject );
      procedure txtCiaClick( Sender: TObject );
      procedure txtUsuarioClick( Sender: TObject );
      procedure txtPasswordClick( Sender: TObject );
      procedure gApplicationMiningClick( Sender: TObject );
      procedure gConvCompClick( Sender: TObject );
      procedure gVentanasClick( Sender: TObject );
      procedure gLoginClick( Sender: TObject );
      procedure pnlMenuClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure Image1Click( Sender: TObject );
      procedure mnuActualizaInventarioClick( Sender: TObject );
      procedure mnuEditorDiagramaClick( Sender: TObject );
      procedure mnuListaDependenciasClick( Sender: TObject );
      procedure FormCloseQuery( Sender: TObject; var CanClose: Boolean );
      procedure mnuAnalisisProgramasClick( Sender: TObject );
      procedure mnuPropagacionVariablesClick( Sender: TObject );
      procedure mnuCreaIndicesClick( Sender: TObject );
      procedure mnuClasesProductoClick( Sender: TObject );
      procedure mnuTsprogDescClick( Sender: TObject );
      procedure mnuDocProductosTipoClick( Sender: TObject );
    procedure cxSplitter1Moved(Sender: TObject);
    procedure dxBarButton1Click(Sender: TObject);
    procedure dxBarButton3Click(Sender: TObject);
    procedure dxBarButton5Click(Sender: TObject);
    procedure mnuCambiosMasivosClick(Sender: TObject);
    procedure gMasivosClick(Sender: TObject);
    procedure mnuEstaticasClick(Sender: TObject);
    procedure mnuMuertoClick(Sender: TObject);
    procedure mnuGeneraDoctosClick(Sender: TObject);
    procedure dxBarButton6Click(Sender: TObject);
    procedure hiperligaClick(Sender: TObject);
    procedure mnuGeneraWordClick(Sender: TObject);
    procedure mnuvalestaticaClick(Sender: TObject);
   private
      { Private declarations }
      procedure detecta_base( sParConexion, sParUsuarioDB: string ); //fercar cias
      procedure detecta_usuarios( sParUsuarioDB: string; bParCreaBD: Boolean ); //fercar cias
      procedure icono_clases;
      procedure VentanasNormales;
      procedure HabilitaMenuInicial( bPriHabilita: Boolean );
      procedure Capacidades;
      procedure detecta_cias; //fercar cias
   public
      { Public declarations }
      procedure cambia_version (v:string);    //alk para la version
   end;

var
   ftsmain: Tftsmain;
function MouseProc( nCode: Integer; wParam, lParam: Longint ): Longint; stdcall;

implementation

{$R *.dfm}
uses
   ptsdm, mgserial, pcatalog, ppasswrd, ptsutileria, facerca, exemod, ptsgral,
   ptsadminctrusu, ptscaducidad, parbol, ptsrecibe, ptsinventario,
   ptscnvprog, pbarra, ptsanaprog, ptspropaga, ufmClasesXProducto, ufmMatrizAF,
   UfmConsCom, uConstantes, ufmInvCompo, ufmDocSistema, ufmBuscaCompo,alkAnCom,ptsconver,
   ptscomun,ptsmuerto, ptsgenera,ptspostrec,alkDocAutoDinamica,alkDocWord,ptsrec;

function detecta_instancia: boolean;
var
   PrevInstance: hWnd;
begin
   PrevInstance := FindWindow( 'TApplication', g_appname );
   if PrevInstance <> 0 then begin
      if IsIconic( PrevInstance ) then
         ShowWindow( PrevInstance, sw_Restore )
      else
         BringWindowToTop( PrevInstance );

      detecta_instancia := true;
   end
   else
      detecta_instancia := false;
end;

function MouseProc( nCode: Integer; wParam, lParam: Longint ): Longint; stdcall;
var
   szClassName: array[ 0..255 ] of Char;
   MausPos: TPoint;

const
   ie_name = 'Internet Explorer_Server';
begin
   //capturar cuando viene del arbol y salir
   if screen.ActiveForm.Name = 'farbol' then begin
      Result := CallNextHookEx( HookID, nCode, wParam, lParam );
      exit;
   end;
 {  if screen.ActiveForm.Name = 'fmMatrizCrud' then begin
      Result := CallNextHookEx( HookID, nCode, wParam, lParam );
      exit;
   end;}                           //prueba RGM-ALK

   GetCursorPos( MausPos );
   g_X := MausPos.x;
   g_Y := MausPos.y;

   if ( nCode < 0 ) then
      Result := CallNextHookEx( HookID, nCode, wParam, lParam )
   else if ( ( wParam = WM_RBUTTONDOWN ) or ( wParam = WM_RBUTTONUP ) ) then begin
      GetClassName( PMOUSEHOOKSTRUCT( lParam )^.HWND, szClassName,
         SizeOf( szClassName ) );
      if lstrcmp( @szClassName[ 0 ], @ie_name[ 1 ] ) = 1 then begin
         Result := HC_SKIP;
         gral.PopGral.Popup( g_X, g_Y );
      end
      else
         Result := CallNextHookEx( HookID, nCode, wParam, lParam );
   end
   else
      Result := CallNextHookEx( HookID, nCode, wParam, lParam );
end;

procedure ShowDatabaseDesc( DBName: string );
//var
   //dbDes: DBDesc;
   //session: TSession;
begin
   g_database := 'ORACLE';
   g_q := '''';
   g_is_null := ' IS NULL';

end;

procedure Tftsmain.cambia_version (v:string);         // ALK de la version
begin
   ftsmain.Caption:='Sys-Mining '+v;
end;

procedure Tftsmain.mnuCreaIndicesClick( Sender: TObject );
begin
   g_producto := 'ADMINISTRACIÓN-CREA INDICES';
   LeeCatBib;
end;

procedure Tftsmain.detecta_cias;
begin
   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TSUSERCIA' + g_q ) then begin
      if dm.sqlselect( dm.q1, 'select * from tsusercia order by usercia_desc' ) then begin
         //insertar en la tabla dm.tabCias y combo txtCias
         with dm.tabCias do begin
            if not Active then
               Active := True;

            while not dm.q1.Eof do begin
               Insert;
               FindField( 'UserCia' ).AsString := dm.q1.FieldByName( 'USERCIA' ).AsString;
               FindField( 'UserCia_Desc' ).AsString := dm.q1.FieldByName( 'USERCIA_DESC' ).AsString;
               FindField( 'UserCia_Abrev' ).AsString := dm.q1.FieldByName( 'USERCIA_ABREV' ).AsString;
               Post;

               txtCia.Properties.Items.Add( dm.q1.FieldByName( 'USERCIA_DESC' ).AsString );

               dm.q1.Next;
            end;
         end;
      end
      else begin
         if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
            g_q + 'EMPRESA-NOMBRE-1' + g_q ) then begin
            g_empresa := dm.q1.fieldbyname( 'dato' ).AsString;

            with dm.tabCias do begin
               if not Active then
                  Active := True;
               Insert;
               FindField( 'UserCia' ).AsString := g_user_entrada;
               FindField( 'UserCia_Desc' ).AsString := g_empresa;
               FindField( 'UserCia_Abrev' ).AsString := g_empresa_abrev;
               Post;

               txtCia.Properties.Items.Add( g_empresa );
            end;
         end;
      end;
   end
   else begin
      if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
         g_q + 'EMPRESA-NOMBRE-1' + g_q ) then begin
         g_empresa := dm.q1.fieldbyname( 'dato' ).AsString;

         with dm.tabCias do begin
            if not Active then
               Active := True;
            Insert;
            FindField( 'UserCia' ).AsString := g_user_entrada;
            FindField( 'UserCia_Desc' ).AsString := g_empresa;
            FindField( 'UserCia_Abrev' ).AsString := g_empresa_abrev;
            Post;

            txtCia.Properties.Items.Add( g_empresa );
         end;
      end;
   end;

   txtCia.ItemIndex:=0;
end;

procedure Tftsmain.detecta_base( sParConexion, sParUsuarioDB: string ); //fercar cias
begin
   if dm.ADOConnection1.Connected then
      dm.ADOConnection1.Connected := false;

   dm.ADOConnection1.ConnectionString := CONNECTSTRING;

   dm.ADOConnection1.ConnectionString :=
      stringreplace( dm.ADOConnection1.ConnectionString, '=sysviewsoftscm', '=' + sParConexion, [ ] );

   dm.ADOConnection1.ConnectionString :=
      stringreplace( dm.ADOConnection1.ConnectionString, '=sysview11;', '=' + sParUsuarioDB + ';', [ ] );

   try
      g_user_procesa := copy( sParUsuarioDB, 1, length( sParUsuarioDB ) - 2 ) +
         inttostr( strtoint( copy( sParUsuarioDB, length( sParUsuarioDB ) - 1, 2 ) ) + 1 );
   except
      g_user_procesa := sParUsuarioDB + '01';
   end;

   ShowDatabaseDesc( g_odbc ); // Con BDE
end;

procedure Tftsmain.detecta_usuarios( sParUsuarioDB: string; bParCreaBD: Boolean ); //fercar cias
var
   pass: string;
begin
   try
      dm.ADOConnection1.Connected := false;
      dm.ADOConnection1.Connected := true;
   except
      on E: exception do begin
         Application.MessageBox( pchar( 'ERROR DE CONEXION: ' + E.Message + chr( 13 ) + chr( 13 ) +
            'VERIFIQUE:' + chr( 13 ) + chr( 13 ) +
            '1. QUE ESTÉ CONECTADO A LA RED.' + chr( 13 ) +
            '2. QUE LOS PARAMETROS TNSNAME Y USUARIO SEAN CORRECTOS.' ),
            pchar( 'Sys-Mining' ), MB_OK );
         Application.Terminate;
         Abort;
      end;
   end;
   if dm.sqlselect( dm.q1, 'select * from ' + g_user_procesa + '.shdbase' ) then begin
      pass := dm.desencripta( dm.q1.fieldbyname( 'base1' ).asstring );

      dm.ADOConnection1.Connected := false;
      dm.ADOConnection1.ConnectionString :=
         stringreplace( dm.ADOConnection1.ConnectionString, sParUsuarioDB, g_user_procesa, [ ] );
      if pos( 'assword=', dm.ADOConnection1.ConnectionString ) > 0 then
         dm.ADOConnection1.ConnectionString :=
            stringreplace( dm.ADOConnection1.ConnectionString, 'SYSVIEWHELPDESK', copy( pass, 3, 50 ), [ ] )
      else
         dm.ADOConnection1.ConnectionString :=
            dm.ADOConnection1.ConnectionString + 'password=' + copy( pass, 3, 50 ) + ';';
      g_pass := copy( pass, 3, 50 );
      dm.ADOConnection1.Connected := true;
      if dm.sqlselect( dm.q1, 'select * from shdbase' ) = false then begin
         application.MessageBox( 'Error en el password de base de la aplicación', 'Login ', MB_OK );
         exit;
      end;
   end
   else begin
      if bParCreaBD then begin
         if Application.MessageBox( 'ERROR... no tiene acceso a la tabla SHDBASE, desea crear la Base de Datos?',
            'Login ', MB_YESNO ) = IDYES then begin
            verifica_llave;
            //PR_CREABASE; //fercar, revisar juanita
         end;
      end
      else begin
         Application.MessageBox( 'ERROR... no tiene acceso a la tabla SHDBASE', 'Login ', MB_OK );
      end;
      Application.Terminate;
      Abort;
   end;
   verifica_llave;
end;

procedure Tftsmain.icono_clases;
var
   i: Integer;
   icono: Ticon;
begin
   dm.lclases := Tstringlist.Create;
   dm.lclases.Add( 'SELEC' );
   if dm.sqlselect( dm.q1, 'select * from parametro where clave like ' + g_q + 'ICONO_%' + g_q ) then begin
      icono := Ticon.Create;
      icono.Width := 16;
      icono.Height := 16;
      i := 0; //fercar 20140224
      while not dm.q1.Eof do begin
         inc( i );
         dm.lclases.Add( copy( dm.q1.fieldbyname( 'clave' ).AsString, 7, 100 ) );
         dm.blob2file(
            dm.q1.fieldbyname( 'dato' ).AsString, g_ruta_ejecuta + 'ICONO_TEMPORAL' + IntToStr( i ) );
         icono.LoadFromFile( g_ruta_ejecuta + 'ICONO_TEMPORAL' + IntToStr( i ) );
         dm.imgclases.AddIcon( icono );
         dm.q1.Next;

         deletefile( g_ruta_ejecuta + 'ICONO_TEMPORAL' + IntToStr( i ) );
      end;
      //deletefile( g_ruta_ejecuta + 'ICONO_TEMPORAL' );
   end;
end;

procedure Tftsmain.FormCreate( Sender: TObject ); //fercar cias
var
   mensaje: string;
   facerc: Tfacerc;
   // INICIO variables temporales //
   crea_drive, borra_drive, ejebat: string;
   crea_netuse, borra_netuse, Wparam: Tstringlist;
   UnidadCreada: integer;
   Wruta_serv: string;
   // FIN variables temporales //
begin

   if paramcount < 2 then begin
      application.MessageBox( pchar( dm.xlng( 'Menos de 2 parámetros: ' + cmdline ) ),
         pchar( dm.xlng( 'Detecta Base' ) ), MB_OK );
      Application.Terminate;
      abort;
   end;
   g_odbc := paramstr( 1 );
   g_user_entrada := paramstr( 2 );

   gConvComp.Visible := False;
   gAnalisisEspecificos.Visible := False;
   /////JCRgVentanas.Visible := False;
   gFabricaPbasTec.Visible := False;
   //gLogin.Visible := False;
   HabilitaMenuInicial( False );

   HookID := SetWindowsHookEx( WH_MOUSE, MouseProc, 0, GetCurrentThreadId( ) );

   dxNavBar1.Align := AlClient;
   dxNavBar1.Visible := True;

   if detecta_instancia then begin
      application.Terminate;
      abort;
   end;

   facerc := Tfacerc.Create( Self );

   //-----  ALK para version
   ftsmain.Caption:='Sys-Mining '+facerc.da_version;
   //------
   if gral.bPubVentanaMaximizada = FALSE then begin
      facerc.Width := g_Width;
      facerc.Height := g_Height;
   end;
   facerc.BitBtn1.Visible := false;

   GetMem( g_windir, 144 );
   GetWindowsDirectory( g_windir, 144 );
   if dm.GetIPFromHost( g_hostname, g_ipaddress, mensaje ) = false then begin
      application.MessageBox( pchar( dm.xlng( mensaje ) ),
         pchar( dm.xlng( 'Host ' ) ), MB_OK );
      application.Terminate;
      abort;
   end;

   verifica_llave;

   stbPrincipal.Panels[ 2 ].Text := LowerCase( g_odbc );
   detecta_base( g_odbc, g_user_entrada );
   detecta_usuarios( g_user_entrada, False );
   detecta_cias;

   stbPrincipal.Panels[ 1 ].Text := LowerCase( g_user_procesa );
   // -----------  ayuda Sysmining -------------------------
   //Application.HelpFile := ExtractFilePath( Application.ExeName ) + 'HelpFile\SM61.chm';
   Application.HelpFile := ExtractFilePath( Application.ExeName ) + 'SysHelp\AyudaPrueba.chm';     // para ayuda  ALK
   // ------------------------------------------------------
   g_mismoserver:=dm.mismo_server;

   if dm.sqlselect(dm.q1,'select * from parametro '+   // para activar opciones convertidor RGM
      ' where clave='+g_q+'MODULO_CONVERSION'+g_q+
      ' and   dato='+g_q+'TRUE'+g_q) then
      gConvComp.Visible := True;
      
   if dm.sqlselect(dm.q1,'select * from parametro '+   // cambios a la sesion de ORACLE RGM
      ' where clave='+g_q+'ALTER_SESSION'+g_q+
      ' order by secuencia') then begin
      while not dm.q1.Eof do begin
         if dm.sqlupdate(dm.q1.fieldbyname('dato').AsString)=FALSE then begin
            application.MessageBox(pchar('ERROR... parametro ALTER_SESSION '+dm.q1.fieldbyname('dato').AsString),'ERROR',MB_OK);
            application.Terminate;
            exit;
         end;
         dm.q1.Next;
      end;
   end;

   //RGM201402g_mismoserver:=dm.mismo_server;
   //iHelpContext:=IDH_TOPIC_T00001;
end;

procedure Tftsmain.FormClose( Sender: TObject; var Action: TCloseAction );
var
   dir : String;

   procedure BorraArchivosTmp(directorio : String);
   var
      Archivos: TSearchRec;
      Dir: String;
   begin
      Dir:=directorio+'\*.*';
      if FindFirst(Dir, faArchive, Archivos) = 0 then begin
         repeat
         if (Archivos.Attr and faArchive) = Archivos.Attr then begin
            DeleteFile(directorio+'\'+Archivos.Name);
         end;
         until FindNext(Archivos) <> 0;
         FindClose(Archivos);
      end;
   end;
begin
   {   //mnuCerrarV.OnClick;

      //jcr   deletefile(g_tmpdir+'\crea_netuse.bat');
      Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
      if g_log.Count > 0 then
         g_log.SaveToFile( g_tmpdir + '\sysviewlog' + formatdatetime( 'YYYYMMDD-HHNNSS', now ) + '.txt' );
      if dm.sqlupdate( 'update tslogon ' +
         ' set fecha_salida=' + Wfecha +
         ' where cuser=' + g_q + g_usuario + g_q + ' and (fecha_salida ' + g_is_null + ')'
         //                   +' and (fecha_entrada='+g_q+g_fecha_entrada+g_q+')'
         ) = false then
         Application.MessageBox( pchar( 'No puede actualizar tslogon(fecha_salida)' ),
            pchar( 'Control Tiempo' ), MB_OK );
      //jcr   deletefile(g_tmpdir+'\borra_netuse.bat');
      ///dm.Free;
      ///free;
      ///ExitProcess( UINT( -1 ) ); }

      // ------- borrar la carpeta temporal  -----------   ALK
      {if DirectoryExists(Trim(g_ruta + 'tmp')) then
        RemoveDir(Trim(g_ruta + 'tmp'));}
      dir := g_ruta + 'tmp';
      BorraArchivosTmp(dir);
      // -----------------------------------------------
end;

procedure Tftsmain.Timer1Timer( Sender: TObject );
var
   Wfecha: string;
begin
   Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );

   if dm.sqlupdate( 'update tslogon ' +
      ' set control_tiempo=' + Wfecha +
      ' where cuser=' + g_q + g_usuario + g_q + ' and (fecha_salida ' + g_is_null + ')' ) = false then
      Application.MessageBox( pchar( 'No puede actualizar tslogon' ),
         pchar( 'Control Tiempo' ), MB_OK );
end;

procedure Tftsmain.VentanasNormales;
var
   i: Integer;
begin
   for i := 0 to MDIChildCount - 1 do
      MDIChildren[ i ].WindowState := wsNormal;
end;

procedure Tftsmain.mnuBaseConocimientoClick( Sender: TObject );
begin
   //iHelpContext := IDH_TOPIC_T01100;
   iHelpContext:= IDH_TOPIC_T00001;   // para ayuda ALK


   g_producto := 'MINING-BASE CONOCIMIENTO';
   g_ArbolDescri := ' ';
   if dm.sqlselect( dm.q1, 'select * from parametro ' +
      ' where clave=' + g_q + 'ARBOLDESCRIPCION' + g_q ) then begin
      g_ArbolDescri := ( dm.q1.fieldbyname( 'dato' ).AsString );
   end;
   if gral.bPubVentanaActiva( 'Base de Conocimiento' ) then
      Exit;
   PR_ARBOL;
end;

procedure Tftsmain.mnuBusComponentesClick( Sender: TObject );
var
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   iHelpContext := IDH_TOPIC_T01200;
   g_producto := 'MINING-BÚSQUEDA';
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );


   try
      g_Wforma := 'mining';
      g_Wforma_aux := '';
      titulo := sLISTA_BUSCA_COMPO;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      //if gral.bPubVentanaActiva( Titulo ) then
         ///Exit;

      //fmBuscaCompo := TfmBuscaCompo.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      ierror := 0;
      try
         fmBuscaCompo := TfmBuscaCompo.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmBuscaCompo := TfmBuscaCompo.Create( Self );
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

      if ierror = 0 then begin
         if gral.bPubVentanaMaximizada = FALSE then begin
            fmBuscaCompo.Width := g_Width;
            //fmBuscaCompo.Height := g_Height;     // se quita para que el tamaño se lo de al crearla    ALK

         end;

         //fmBuscaCompo.titulo := Titulo;
         fmBuscaCompo.Caption := Titulo;
         fmBuscaCompo.Show;

         dm.PubRegistraVentanaActiva( Titulo );

      //-------------------------------------------------------------------------------

         /////JCR TEMPORAL if gral.bPubVentanaActiva( sLISTA_BUSCA_COMPO + ' Anterior' ) then
         if gral.bPubVentanaActiva( sLISTA_BUSCA_COMPO ) then
            Exit;

        // PR_BUSCA;

        /////JCR TEMPORAL dm.PubRegistraVentanaActiva( sLISTA_BUSCA_COMPO + ' Anterior' );
         dm.PubRegistraVentanaActiva( sLISTA_BUSCA_COMPO );

      //------------------------------------------------------------
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsmain.mnuRecComponentesClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T01700;
   g_producto := 'MINING-RECEPCIÓN DE COMPONENTES';
   PR_RECIBE;
end;

procedure Tftsmain.mnuInvComponentesClick( Sender: TObject );
var
   Titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   g_producto := 'MINING-INVENTARIO DE COMPONENTES';
   if dm.sqlselect( dm.q1, 'select count(*) total from tsrela ' ) then begin
      if ( dm.q1.FieldByName( 'total' ).AsInteger = 0 ) then begin
         Application.MessageBox( pchar( 'Tsrela sin información, no es posible generar el Inventario de Componentes.' ),
            pchar( sLISTA_INV_COMPO ), MB_OK );
         Abort;
      end;
   end
   else begin
      Application.MessageBox( pchar( 'No pudo leer Tsrela.' ),
         pchar( sLISTA_INV_COMPO ), MB_OK );
      Abort;
   end;
   iHelpContext := IDH_TOPIC_T01400;
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   try
      Titulo := sLISTA_INV_COMPO;
      g_Wforma := 'mining';
      g_Wforma_aux := 'inventario';

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;


      //fmInvCompo := TfmInvCompo.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      ierror := 0;
      try
         fmInvCompo := TfmInvCompo.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmInvCompo := TfmInvCompo.Create( Self );
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

      if ierror = 0 then begin
         fmInvCompo.FormStyle := fsMDIChild;

         if gral.bPubVentanaMaximizada = False then begin
            fmInvCompo.Width := g_Width;
            fmInvCompo.Height := 550;
         end;

         fmInvCompo.titulo := Titulo;
         fmInvCompo.caption := Titulo;
         fmInvCompo.Show;
         fmInvCompo.TabInicio;

         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsmain.mnuLisComponentesClick( Sender: TObject );
var
   fmListaCompo: TfmListaCompo;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   iHelpContext := IDH_TOPIC_T01500;
   g_producto := 'MINING-LISTA DE COMPONENTES';

   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Titulo := sLISTA_COMPONENTES;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      //fmListaCompo := TfmListaCompo.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      ierror := 0;
      try
         fmListaCompo := TfmListaCompo.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmListaCompo := TfmListaCompo.Create( Self );
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

      if ierror = 0 then begin
         fmListaCompo.FormStyle := fsMDIChild;

         if gral.bPubVentanaMaximizada = False then begin
            fmListaCompo.Width := g_Width;
            fmListaCompo.Height := g_Height;
         end;

         fmListaCompo.Caption := Titulo;
         //fmListaCompo.Splitter1.Visible := True;
         //fmListaCompo.GroupBox1.Visible := True;
         fmListaCompo.Show;

         //if fmListaCompo.FormStyle = fsMDIChild then
         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tftsmain.mnuMatrizCrudClick( Sender: TObject );
var
   //   ftstablas: Tftstablas;         //framirez
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   iHelpContext := IDH_TOPIC_T01600;
   screen.Cursor := crsqlwait;
   g_producto := 'MINING-MATRIZ CRUD';
   gral.PubMuestraProgresBar( True );
   try
      titulo := sLISTA_MATRIZ_CRUD;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      //fmMatrizCrud := TfmMatrizCrud.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      ierror := 0;
      try
         fmMatrizCrud := TfmMatrizCrud.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmMatrizCrud := TfmMatrizCrud.Create( Self );
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

      if ierror = 0 then begin
         fmMatrizCrud.FormStyle := fsMDIChild;

         if gral.bPubVentanaMaximizada = FALSE then begin
            fmMatrizCrud.Width := g_Width;
            fmMatrizCrud.Height := 550;
         end;

         fmMatrizCrud.titulo := titulo;
         fmMatrizCrud.tipo := 'TAB';
         fmMatrizCrud.prepara2( '', '' );
         fmMatrizCrud.arma3( '', '' );
         fmMatrizCrud.Show;

         //if FormStyle = fsMDIChild then
         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsmain.mnuMatrizAFClick( Sender: TObject );
var
   ftsarchivos: TfmMatrizAF;
   titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   iHelpContext := IDH_TOPIC_T01600;
   screen.Cursor := crsqlwait;
   g_producto := 'MINING-MATRIZ ARCHIVOS FÍSICOS';
   gral.PubMuestraProgresBar( True );                                  
   try
      titulo := sMATRIZ_ARCHIVOS_FIS;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      //ftsarchivos := TfmMatrizAF.Create( Self );
      // ------ ALK para controlar el error out of system resources ------
      ierror := 0;
      try
         ftsarchivos := TfmMatrizAF.Create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsarchivos := TfmMatrizAF.Create( Self );
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

      if ierror = 0 then begin
         ftsarchivos.FormStyle := fsMDIChild;

         if gral.bPubVentanaMaximizada = FALSE then begin
            ftsarchivos.Width := g_Width;
            ftsarchivos.Height := 550;
         end;
         ftsarchivos.titulo := titulo;
         ftsarchivos.tipo := 'FIL';
         ftsarchivos.prepara( '', '' );
         ftsarchivos.arma( '', '' );
         ftsarchivos.Show;

         //if FormStyle = fsMDIChild then
         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsmain.mnuIniciarClick( Sender: TObject ); //fercar cias
begin
   //gLogin.Visible := True;
   g_ruta := g_ruta_ejecuta;

   with dm.tabCias do begin
      if RecordCount > 1 then begin
         First;
         txtCia.Enabled := True;
         txtCia.ItemIndex := 0;
         txtCia.SetFocus;
      end
      else begin
         txtCia.Enabled := False;
         txtCia.ItemIndex := 0;
         txtUsuario.SetFocus;
      end;
   end;

   gLogin.Expandable := True;
   gLogin.Expanded := True;
end;

procedure Tftsmain.mnuTerminarClick( Sender: TObject );
var
   Wfecha: string;
begin
   mnuCerrarVClick( Self );

   txtUsuario.Clear;     //Bre
   txtPassword.Clear;   //Bre

   Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
   if dm.sqlupdate( 'update tslogon ' +
      ' set fecha_salida=' + Wfecha +
      ' where cuser=' + g_q + g_usuario + g_q + ' and (fecha_salida ' + g_is_null + ')'
      //           + ' and (fecha_entrada='+g_q+g_fecha_entrada+g_q+')'
      ) = false then
      Application.MessageBox( pchar( 'No puede actualizar tslogon(fecha_salida)' ),
         pchar( 'Control Tiempo' ), MB_OK );

   HabilitaMenuInicial( False );
   /////JCRgral.PubExpandeMenuVentanas(False);

   if dm.ADOConnection1.Connected then
      dm.ADOConnection1.Connected := false;

   {if dm.dbverfte.Connected then
                           dm.dbverfte.Connected := false;}//no utilizar, solo si existe conexion ODBC y BDEngine

   stbPrincipal.Panels[ 0 ].Text := '';
   stbPrincipal.Panels[ 1 ].Text := '';
   stbPrincipal.Panels[ 3 ].Text := '';
   mnuIniciar.Enabled := True;

   gApplicationMining.Visible := false;
   gDocumentacion.Visible := false;
   gConvComp.Visible := false;
   gAnalisisEspecificos.Visible := false;
   gMasivos.Visible := false;
   gEstaticas.Visible := false;
   gVentanas.Visible := false;
   gFabricaPbasTec.Visible := false;
   gLogin.Visible := true;          //(true)

   mnuSesion.Visible := ivAlways;
   mnuAdministracion.Visible := ivNever;
   mnuCatalogos.Visible := ivNever;
   mnuHerramientas.Visible := ivNever;
   mnuVentanas.Visible := ivNever;
   mnuAyuda.Visible := ivAlways;

   mnuIniciar.Visible := ivAlways;       // (ivAlways)
   mnuTerminar.Visible := ivNever;      // (ivAlways)
   mnuBaseConocimiento2.Visible := ivNever;        // (ivNever) - ivAlways
   mnuBusComponentes2.Visible := ivNever;
   mnuConsulta.Visible := ivNever;
   dxBarButtonInvComponentes.Visible := ivNever;
   dxBarButtonLisComponentes.Visible := ivNever;
   dxBarButtonLisDependencias.Visible := ivNever;
   dxBarButtonMatrizCrud.Visible := ivNever;
   dxBarButtonMatrizAF.Visible := ivNever;
   dxBarButtonRecComponentes.Visible := ivNever;
end;

procedure Tftsmain.mnuAboutClick( Sender: TObject );
begin
   PR_ACERCA;
end;

procedure Tftsmain.munHorizontalClick( Sender: TObject );
begin
   VentanasNormales;
   TileMode := tbHorizontal;
   Tile;
end;

procedure Tftsmain.mnuVerticalClick( Sender: TObject );
begin
   VentanasNormales;
   TileMode := tbVertical;
   Tile;
end;

procedure Tftsmain.mnuCascadaClick( Sender: TObject );
begin
   VentanasNormales;
   Cascade;
end;

procedure Tftsmain.mnuMinimizarClick( Sender: TObject );
var
   i: Integer;
begin
   for i := MDIChildCount - 1 downto 0 do
      MDIChildren[ i ].WindowState := wsMinimized;
end;

procedure Tftsmain.mnuCerrarVClick( Sender: TObject );
var
   i: Integer;
begin
   for i := 0 to MDIChildCount - 1 do
      MDIChildren[ i ].Close;

   /////JCRgral.PubExpandeMenuVentanas(False);

   gral.PopGral.Items.Clear;
end;

procedure Tftsmain.mnuParametrosClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02202;
   PR_CATALOG( mnuParametros.Caption, 'select ' +
      'clave       vk__Clave_de_Parametro, ' +
      'secuencia   vk_nSecuencia, ' +
      'dato        v___Dato ' +
      'from parametro ' +
      'where clave=' + g_q + '$1$' + g_q +
      ' and  secuencia=' + g_q + '$2$' + g_q,
      'insert into parametro (clave,secuencia,dato) values(' +
      g_q + '$1$' + g_q + ',' +
      '$2$' + ',' +
      g_q + '$3$' + g_q + ')',
      'update parametro set ' +
      'dato=' + g_q + '$3$' + g_q + ' ' +
      'where clave=' + g_q + '$1$' + g_q +
      ' and  secuencia=' + g_q + '$2$' + g_q,
      'delete parametro where clave=' + g_q + '$1$' + g_q +
      ' and  secuencia=' + g_q + '$2$' + g_q, mnuParametros.ImageIndex );
   ( fcatalog.pan.FindComponent( 'SELE_DATO' ) as tedit ).CharCase := ecnormal;

   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clave no debe quedar vacia' ) );
   fcatalog.regla( '$3$', '<>', '', '', dm.xlng( 'El Dato no debe quedar vacio' ) );
   fcatalog.inicial( 'SELE_SECUENCIA', '0' );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuRolesClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02203;
   g_producto := 'CATÁLOGOS-ROLES';
   PR_CATALOG( mnuRoles.Caption, 'select ' +
      'crol          vk__Clave_de_Rol, ' +
      'descripcion   v___Descripcion, ' +
      'mineria       v_c_Capacidad_Mineria ' +
      'from tsroles ' +
      'where crol=' + g_q + '$1$' + g_q,
      'insert into tsroles (crol,descripcion,mineria) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ')',
      'update tsroles set ' +
      'descripcion=' + g_q + '$2$' + g_q + ',' +
      'mineria=' + g_q + '$3$' + g_q + ' ' +
      'where crol=' + g_q + '$1$' + g_q,
      'delete tsroles where crol=' + g_q + '$1$' + g_q, mnuroles.ImageIndex );
   ( fcatalog.pan.FindComponent( 'SELE_CAPACIDAD_MINERIA' ) as tcombobox ).Items.CommaText := '0,1';
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clave de Rol no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'La descripcion no debe quedar vacia' ) );
   fcatalog.inicial( 'SELE_CAPACIDAD_MINERIA', '0' );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuUsuariosClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02204;
   g_producto := 'CATÁLOGOS-USUARIOS';
   PR_CATALOG( mnuUsuarios.Caption, 'select ' +
      'cuser    vk__Clave_de_Usuario, ' +
      'nombre   v___Nombre, ' +
      'paterno  v___Apellido_Paterno, ' +
      'materno  v___Apellido_Materno, ' +
      'password n___Password ' +
      'from tsuser ' +
      'where cuser=' + g_q + '$1$' + g_q,
      'insert into tsuser (cuser,nombre,paterno,materno,password) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ',' +
      g_q + '$4$' + g_q + ',' +
      g_q + '$5$' + g_q + ')',
      'update tsuser set ' +
      'nombre=' + g_q + '$2$' + g_q + ',' +
      'paterno=' + g_q + '$3$' + g_q + ',' +
      'materno=' + g_q + '$4$' + g_q + ',' +
      'password=' + g_q + '$5$' + g_q + ',' +
      'where cuser=' + g_q + '$1$' + g_q,
      'delete tsuser where cuser=' + g_q + '$1$' + g_q, mnuusuarios.ImageIndex );
   ( fcatalog.pan.FindComponent( 'SELE_PASSWORD' ) as Tedit ).PasswordChar := '*';
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clave de Usuario no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'El Nombre no debe quedar vacio' ) );
   fcatalog.regla( '$5$', '<>', '', '', dm.xlng( 'El Password no debe quedar vacio' ) );
   fcatalog.inicial( 'SELE_PASSWORD', '12345' );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuRolUserClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02205;
   g_producto := 'CATÁLOGOS-ASIGNA ROL AUSUARIOS';
   PR_CATALOG( mnuRolUser.Caption, 'select ' +
      'crol             vkc_Rol, ' +
      'cuser            vkc_Usuario ' +
      'from tsroluser ' +
      'where crol=' + g_q + '$1$' + g_q +
      ' and  cuser=' + g_q + '$2$' + g_q,
      'insert into tsroluser (crol,cuser) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ')',
      'update tsroluser set ' +
      'crol=' + g_q + '$1$' + g_q + ',' +
      'cuser=' + g_q + '$2$' + g_q + ' ' +
      'where crol=' + g_q + '$1$' + g_q +
      ' and  cuser=' + g_q + '$2$' + g_q,
      'delete tsroluser ' +
      'where crol=' + g_q + '$1$' + g_q +
      ' and  cuser=' + g_q + '$2$' + g_q, mnuRolUser.ImageIndex );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_USUARIO' ) as tcombobox, 'select cuser from tsuser order by 1' );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_ROL' ) as tcombobox, 'select crol from tsroles order by 1' );
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clave de Rol no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'La Clave de Usuario no debe quedar vacia' ) );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuCapacidadesClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02206;
   gral.MantenimientoCapacidades( );
   g_producto := 'CATÁLOGOS-CAPACIDADES';
   PR_CATALOG( mnuCapacidades.Caption, 'select ' +
      //ORIGINAL      'ccapacidad       vk__Clave_de_Capacidad, '+
      'ccapacidad       vkc_Clave_de_Capacidad, ' +
      'crol             vkc_Rol, ' +
      'cuser            vkc_Usuario ' +
      'from tscapacidad ' +
      'where ccapacidad=' + g_q + '$1$' + g_q +
      ' and crol=' + g_q + '$2$' + g_q +
      ' and cuser=' + g_q + '$3$' + g_q,
      'insert into tscapacidad (ccapacidad,crol,cuser) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ')',
      'update tscapacidad set ' +
      'crol=' + g_q + '$2$' + g_q + ',' +
      'cuser=' + g_q + '$3$' + g_q + ' ' +
      'where ccapacidad=' + g_q + '$1$' + g_q +
      ' and crol=' + g_q + '$2$' + g_q +
      ' and cuser=' + g_q + '$3$' + g_q,
      'delete tscapacidad where ccapacidad=' + g_q + '$1$' + g_q +
      ' and crol=' + g_q + '$2$' + g_q +
      ' and cuser=' + g_q + '$3$' + g_q, mnuCapacidades.ImageIndex );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_USUARIO' ) as tcombobox, 'select cuser from tsuser order by 1' );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_ROL' ) as tcombobox, 'select crol from tsroles order by 1' );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_CLAVE_DE_CAPACIDAD' ) as tcombobox,
      'select unique ccapacidad from tscapacidad where crol =' + g_q + 'GENERAL' + g_q + 'order by 1' );

   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clave no debe quedar vacia' ) );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuClasesClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02209;
   g_producto := 'CATÁLOGOS-CLASES';
   PR_CATALOG( mnuClases.Caption, 'select ' +
      'cclase             vk__Clase, ' +
      'tipo               v_c_Tipo, ' +
      'descripcion        v___Descripcion, ' +
      'analizador         v_c_Herramienta_de_Analisis, ' +
      'estructura         v_c_Estructura_Produccion, ' +
      'objeto             v_c_Tipo_de_Objeto, ' +
      'estadoactual       v_c_Estado, ' +
      'diagramabloque     v_c_diagrama_bloque, ' +
      'busquedaselect     v_c_busqueda_select, ' +
      'modocaracteres     v_c_modo_caracteres, ' +
      'caracterespermitidos     v___caracteres_permitidos, ' +
      'modoactualizacion     v_c_modo_actualizacion, ' +
      'complejidad        v_c_Complejidad ' +
      ' from tsclase ' +
      ' where cclase=' + g_q + '$1$' + g_q,
      //MODO_CARACTERES CARACTERES_PERMITIDOS MODO_ACTUALIZACION
      //son para automatizar la creación de indices.
      'insert into tsclase (cclase,tipo,descripcion,analizador,estructura,objeto,estadoactual,'
      + 'diagramabloque,busquedaselect,modocaracteres,caracterespermitidos,modoactualizacion, '
      + 'complejidad ) values(' +
      //'insert into tsclase (cclase,tipo,descripcion,analizador,estructura,objeto,estadoactual,diagramabloque) values(' +
      //'insert into tsclase (cclase,tipo,descripcion,analizador,estructura,objeto,estadoactual) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ',' +
      g_q + '$4$' + g_q + ',' +
      g_q + '$5$' + g_q + ',' +
      g_q + '$6$' + g_q + ',' +
      g_q + '$7$' + g_q + ',' +
      g_q + '$8$' + g_q + ',' +
      g_q + '$9$' + g_q + ',' +
      g_q + '$10$' + g_q + ',' +
      g_q + '$11$' + g_q + ',' +
      g_q + '$12$' + g_q + ',' +
      g_q + '$13$' + g_q + ')',
      'update tsclase set ' +
      'tipo=' + g_q + '$2$' + g_q + ',' +
      'descripcion=' + g_q + '$3$' + g_q + ',' +
      'analizador=' + g_q + '$4$' + g_q + ',' +
      'estructura=' + g_q + '$5$' + g_q + ',' +
      'objeto=' + g_q + '$6$' + g_q + ',' +
      'estadoactual=' + g_q + '$7$' + g_q + ',' +
      'diagramabloque=' + g_q + '$8$' + g_q + ',' +
      'busquedaselect=' + g_q + '$9$' + g_q + ',' +
      'modocaracteres=' + g_q + '$10$' + g_q + ',' +
      'caracterespermitidos=' + g_q + '$11$' + g_q + ',' +
      'modoactualizacion=' + g_q + '$12$' + g_q + ',' +
      'complejidad=' + g_q + '$13$' + g_q + ' ' +
      'where cclase=' + g_q + '$1$' + g_q,
      'delete tsclase ' +
      'where  cclase=' + g_q + '$1$' + g_q, mnuClases.ImageIndex );
   ( fcatalog.pan.FindComponent( 'SELE_TIPO' ) as tcombobox ).Items.Add( 'ANALIZABLE' );
   ( fcatalog.pan.FindComponent( 'SELE_TIPO' ) as tcombobox ).Items.Add( 'NO ANALIZABLE' );
   fcatalog.inicial( 'SELE_HERRAMIENTA_DE_ANALISIS',
      'select cutileria from tsutileria order by 1', 'SQL' );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_HERRAMIENTA_DE_ANALISIS' ) as tcombobox,
      'select cutileria from tsutileria order by 1' );
   ( fcatalog.pan.FindComponent( 'SELE_ESTRUCTURA_PRODUCCION' ) as tcombobox ).Items.Add( 'LIBRERIA' );
   ( fcatalog.pan.FindComponent( 'SELE_ESTRUCTURA_PRODUCCION' ) as tcombobox ).Items.Add( 'PATH BASE' );
   ( fcatalog.pan.FindComponent( 'SELE_TIPO_DE_OBJETO' ) as tcombobox ).Items.Add( 'FISICO' );
   ( fcatalog.pan.FindComponent( 'SELE_TIPO_DE_OBJETO' ) as tcombobox ).Items.Add( 'VIRTUAL' );
   ( fcatalog.pan.FindComponent( 'SELE_ESTADO' ) as tcombobox ).Items.Add( 'ACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_ESTADO' ) as tcombobox ).Items.Add( 'INACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_DIAGRAMA_BLOQUE' ) as tcombobox ).Items.Add( 'ACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_DIAGRAMA_BLOQUE' ) as tcombobox ).Items.Add( 'INACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_BUSQUEDA_SELECT' ) as tcombobox ).Items.Add( 'ACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_BUSQUEDA_SELECT' ) as tcombobox ).Items.Add( 'INACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_MODO_CARACTERES' ) as tcombobox ).Items.Add( 'MAYUSCULAS' );
   ( fcatalog.pan.FindComponent( 'SELE_MODO_CARACTERES' ) as tcombobox ).Items.Add( 'MINUSCULAS' );
   ( fcatalog.pan.FindComponent( 'SELE_MODO_CARACTERES' ) as tcombobox ).Items.Add( 'NORMAL' );
   //   ( fcatalog.pan.FindComponent( 'SELE_CARACTERES_PERMITIDOS' ) as tcombobox ).Items.Add( '"-_"' );
   //   ( fcatalog.pan.FindComponent( 'SELE_CARACTERES_PERMITIDOS' ) as tcombobox ).Items.Add( '"$&.%%"' );
   ( fcatalog.pan.FindComponent( 'SELE_MODO_ACTUALIZACION' ) as tcombobox ).Items.Add( 'NEW' );
   ( fcatalog.pan.FindComponent( 'SELE_MODO_ACTUALIZACION' ) as tcombobox ).Items.Add( 'UPDATE' );
   ( fcatalog.pan.FindComponent( 'SELE_COMPLEJIDAD' ) as tcombobox ).Items.Add( 'TRUE' );
   ( fcatalog.pan.FindComponent( 'SELE_COMPLEJIDAD' ) as tcombobox ).Items.Add( 'FALSE' );
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clase no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'El tipo no debe quedar vacio' ) );
   fcatalog.regla( '$3$', '<>', '', '', dm.xlng( 'La Descripcion no debe quedar vacia' ) );
   fcatalog.regla( '$6$', '<>', '', '', dm.xlng( 'El tipo de objeto no debe quedar vacio' ) );
   fcatalog.regla( '$7$', '<>', '', '', dm.xlng( 'El Estado no debe quedar vacio' ) );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuOficinasClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02207;
   g_producto := 'CATÁLOGOS-OFICINAS';
   PR_CATALOG( mnuOficinas.Caption, 'select ' +
      'coficina           vk__Oficina, ' +
      'descripcion        v___Descripcion, ' +
      'direccion          v___Direccion ' +
      'from tsoficina ' +
      'where coficina=' + g_q + '$1$' + g_q,
      'insert into tsoficina (coficina,descripcion,direccion) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ')',
      'update tsoficina set ' +
      ' descripcion=' + g_q + '$2$' + g_q + ',' +
      ' direccion=' + g_q + '$3$' + g_q +
      ' where coficina=' + g_q + '$1$' + g_q,
      ' delete tsoficina ' +
      ' where coficina=' + g_q + '$1$' + g_q, mnuOficinas.ImageIndex );
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Oficina no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'La Descripcion no debe quedar vacia' ) );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuSistemasClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02208;
   g_producto := 'CATÁLOGOS-SISTEMAS';
   PR_CATALOG( mnuSistemas.Caption, 'select ' +
      'csistema              vk__Sistema, ' +
      'coficina              v_c_Oficina, ' +
      'descripcion           v___Descripcion, ' +
      'cdepende              v_c_Sistema_Padre, ' +
      'estadoactual          v_c_Estado ' +
      'from tssistema ' +
      'where csistema=' + g_q + '$1$' + g_q,
      'insert into tssistema (csistema,coficina,descripcion,cdepende,estadoactual) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ',' +
      g_q + '$4$' + g_q + ',' +
      g_q + '$5$' + g_q + ')',
      'update tssistema set ' +
      ' coficina=' + g_q + '$2$' + g_q + ',' +
      ' descripcion=' + g_q + '$3$' + g_q + ',' +
      ' cdepende=' + g_q + '$4$' + g_q + ',' +
      ' estadoactual=' + g_q + '$5$' + g_q +
      ' where csistema=' + g_q + '$1$' + g_q,
      'delete tssistema ' +
      'where csistema=' + g_q + '$1$' + g_q, mnuSistemas.ImageIndex );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_OFICINA' ) as tcombobox,
      'select coficina from tsoficina order by 1' );
   ( fcatalog.pan.FindComponent( 'SELE_SISTEMA' ) as tedit ).CharCase := ecnormal;
   ( fcatalog.pan.FindComponent( 'SELE_ESTADO' ) as tcombobox ).Items.Add( 'ACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_ESTADO' ) as tcombobox ).Items.Add( 'INACTIVO' );
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'El Sistema no debe quedar vacio' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'La Oficina no debe quedar vacia' ) );
   fcatalog.regla( '$3$', '<>', '', '', dm.xlng( 'La Descripcion no debe quedar vacia' ) );
   fcatalog.regla( '$1$', '<>', '$4$', '', dm.xlng( 'El sistema padre no puede ser el mismo' ) );
   fcatalog.regla( '$5$', '<>', '', '', dm.xlng( 'El Estado no debe quedar vacio' ) );
   fcatalog.xonexit( 'SELE_OFICINA', 'feed_combo',
      'SELE_SISTEMA_PADRE,select csistema from tssistema where coficina=' + g_q + '$2$' + g_q +
      ' and csistema<>' + g_q + '$1$' + g_q +
      ' union select ' + g_q + g_q + ' from tssistema ' +
      ' order by 1' );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuBibliotecasClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02210;
   g_producto := 'CATÁLOGOS-BIBLIOTECAS';
   PR_CATALOG( mnuBibliotecas.Caption, 'select ' +
      'cbib             vk__Biblioteca, ' +
      'descripcion      v___Descripcion, ' +
      'ip               v___Direccion_IP, ' +
      'path             v___Path, ' +
      'dirprod          v___Directorio_Produccion ' +
      'from tsbib ' +
      'where cbib=' + g_q + '$1$' + g_q +
      ' and (ip not in (' + g_q + 'OFICINA' + g_q + ',' + g_q + 'SISTEMA' + g_q + ') or ip' + g_is_null + ')',
      'insert into tsbib (cbib,descripcion,ip,path,dirprod) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ',' +
      g_q + '$4$' + g_q + ',' +
      g_q + '$5$' + g_q + ')',
      'update tsbib set ' +
      'descripcion=' + g_q + '$2$' + g_q + ',' +
      'ip=' + g_q + '$3$' + g_q + ',' +
      'path=' + g_q + '$4$' + g_q + ',' +
      'dirprod=' + g_q + '$5$' + g_q + ' ' +
      'where cbib=' + g_q + '$1$' + g_q,
      'delete tsbib ' +
      'where cbib=' + g_q + '$1$' + g_q, mnuBibliotecas.ImageIndex );
   ( fcatalog.pan.FindComponent( 'SELE_DIRECTORIO_PRODUCCION' ) as tedit ).CharCase := ecnormal;
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clave de Biblioteca no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'La Descripcion no debe quedar vacia' ) );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
   //dm.bfile_directorio;
   //RGM201402dm.bibfte('XXX',true);
end;

procedure Tftsmain.mnuCaducidadClick( Sender: TObject );
begin
   g_producto := 'ADMINISTRACIÓN-CADUCIDAD';
   CADUCIDAD;
end;

procedure Tftsmain.mnuMonUserClick( Sender: TObject );
begin
   g_producto := 'ADMINISTRACIÓN-MONITOREO USUARIOS';
   CONTROLUSUARIOS;
end;

procedure Tftsmain.mnuClasesProductoClick( Sender: TObject );
var
   fmClasesXProducto: TfmClasesXProducto;
begin
   g_producto := 'ADMINISTRACIÓN-CLASES POR PRODUCTO';

   fmClasesXProducto := TfmClasesXProducto.Create( Self );
   fmClasesXProducto.pubCreaLista( 'ADMIN', 'Catálogo de Productos/Clases' ); //Dar de alta en uConstantes sClaseProducto
   fmClasesXProducto.Show;
end;

procedure Tftsmain.mnuUtileriasClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02211;
   g_producto := 'CATÁLOGOS-UTILERÍAS';
   PR_CATALOG( mnuUtilerias.Caption, 'select ' +
      'cutileria           vk__Utileria, ' +
      'descripcion         v___Descripcion ' +
      'from tsutileria ' +
      'where cutileria=' + g_q + '$1$' + g_q,
      'insert into tsutileria (cutileria,descripcion) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ')',
      'update tsutileria set ' +
      'descripcion=' + g_q + '$2$' + g_q +
      ' where cutileria=' + g_q + '$1$' + g_q,
      'delete tsutileria ' +
      'where cutileria=' + g_q + '$1$' + g_q, mnuUtilerias.ImageIndex );
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Utileria no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'La Descripcion no debe quedar vacia' ) );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuCargaUtilClick( Sender: TObject );
begin
   g_producto := 'CATÁLOGOS-CARGA DE UTILERÍAS';
   PR_UTILERIA;
end;

procedure Tftsmain.mnuCambioPassClick( Sender: TObject );
begin
   g_producto := 'ADMINISTRACIÓN-CAMBIO PASSWORD';
   PR_PASSWORD;
end;

procedure Tftsmain.HabilitaMenuInicial( bPriHabilita: Boolean );
begin
   gApplicationMining.Expandable := bPriHabilita;
   gApplicationMining.Expanded := bPriHabilita;
   gDocumentacion.Expandable := bPriHabilita;
   gDocumentacion.Expanded := bPriHabilita;
   gConvComp.Expandable := bPriHabilita;
   gConvComp.Expanded := bPriHabilita;
   gAnalisisEspecificos.Expandable := bPriHabilita;
   gAnalisisEspecificos.Expanded := bPriHabilita;
   gMasivos.Expanded := bPriHabilita;
   gMasivos.Expandable := bPriHabilita;
   gEstaticas.Expanded := bPriHabilita;
   gEstaticas.Expandable := bPriHabilita;

   mnuAdministracion.Enabled := bPriHabilita;
   mnuCatalogos.Enabled := bPriHabilita;
   mnuHerramientas.Enabled := bPriHabilita;
   mnuReporteador.Visible := ivalways;
   mnuCasosUso.Visible := ivNever;
   mnuVentanas.Enabled := bPriHabilita;
   mnuBaseConocimiento2.Enabled := bPriHabilita;
   mnuBusComponentes2.Enabled := bPriHabilita;
   mnuConsulta.Enabled := bPriHabilita;

   // Nuevos Accesos directos BMG
   dxBarButtonInvComponentes.Enabled := bPriHabilita;
   dxBarButtonLisComponentes.Enabled := bPriHabilita;
   dxBarButtonlisDependencias.Enabled := bPriHabilita;
   dxbarButtonMatrizCrud.Enabled := bPriHabilita;
   dxBarButtonMatrizAF.Enabled := bPriHabilita;
   dxBarButtonRecComponentes.Enabled := bPriHabilita;
end;
{
procedure Tftsmain.mnuReporteadorClick( Sender: TObject );
var
ndir, repsysview: string;
begin
ndir := g_ruta + '\Reportes';
if directoryexists( ndir ) = false then begin
 if forcedirectories( ndir ) = false then begin
    Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + ndir ) ),
       pchar( dm.xlng( 'Reporteador ' ) ), MB_OK );
    exit;
 end;
end;
if fileexists( ndir + '\MENU.db' ) = false then begin
 dm.get_utileria( 'MENU.DB', ndir + '\MENU.db' );
 g_borrar.Delete( g_borrar.Count - 1 );
end;
if fileexists( ndir + '\MENU.MB' ) = false then begin
 dm.get_utileria( 'MENU.MB', ndir + '\MENU.MB' );
 g_borrar.Delete( g_borrar.Count - 1 );
end;
if fileexists( ndir + '\Default.svs' ) = false then begin
 dm.get_utileria( 'DEFAULT.SVS', ndir + '\Default.svs' );
 g_borrar.Delete( g_borrar.Count - 1 );
end;
chdir( ndir );
repsysview := ndir + '\hta' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.exe';
dm.get_utileria( 'REPSYSVIEW', repsysview );
ShellExecute( 0, 'open', pchar( repsysview ),
 pchar( g_odbc + ' ' + g_user_procesa + ' ' + g_pass ),
 //pchar(g_odbc2+' '+g_user_procesa+' '+g_pass),
 PChar( g_ruta + '\Reportes' ), SW_SHOW );
chdir( g_ruta );
end;
}

procedure Tftsmain.mnuReporteadorClick( Sender: TObject );
var
   ndir, repsysview: string;
begin
   g_producto := 'HERRAMIENTAS-REPORTEADOR';
   ndir := g_ruta + 'Reportes';
   if directoryexists( ndir ) = false then begin
      if forcedirectories( ndir ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + ndir ) ),
            pchar( dm.xlng( 'Reporteador ' ) ), MB_OK );
         exit;
      end;
   end;
   if fileexists( ndir + '\MENU.db' ) = false then begin
      dm.get_utileria( 'MENU.DB', ndir + '\MENU.db' );
      g_borrar.Delete( g_borrar.Count - 1 );
   end;
   if fileexists( ndir + '\MENU.MB' ) = false then begin
      dm.get_utileria( 'MENU.MB', ndir + '\MENU.MB' );
      g_borrar.Delete( g_borrar.Count - 1 );
   end;
   if fileexists( ndir + '\Default.svs' ) = false then begin
      dm.get_utileria( 'DEFAULT.SVS', ndir + '\Default.svs' );
      g_borrar.Delete( g_borrar.Count - 1 );
   end;
   chdir( ndir );
   repsysview := ndir + '\hta' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.exe';
   dm.get_utileria( 'REPSYSVIEW', repsysview );
   ShellExecute( 0, 'open', pchar( repsysview ),
      pchar( g_odbc + ' ' + g_user_procesa + ' ' + g_pass ),
      //pchar(g_odbc2+' '+g_user_procesa+' '+g_pass),
      PChar( g_ruta + 'Reportes' ), SW_SHOW );
   chdir( g_ruta );
end;

procedure Tftsmain.FormDestroy( Sender: TObject );
begin
   HtmlHelp( 0, nil, HH_CLOSE_ALL, 0 );
   if HookID <> 0 then
      UnHookWindowsHookEx( HookID );
end;

procedure Tftsmain.btnAceptarClick( Sender: TObject ); //fercar cias
var
   Wnumusu: integer;
   sUserCia, l_ad, pass, cons: string;

   function sObtenerUserCia( sParUserCiaDesc: string ): string;
   begin
      Result := g_user_entrada;
      icono_clases;
      with dm.tabCias do begin
         if RecordCount <= 1 then begin
            Result := g_user_entrada;
            Exit;
         end;

         if Locate( 'UserCia_Desc', sParUserCiaDesc, [ ] ) then begin
            g_empresa_abrev := FieldByName( 'UserCia_Abrev' ).AsString;
            g_ruta := g_ruta + copy( trim( g_ruta_pais ), 4, 15 ) + '_' + trim( g_empresa_abrev ) + '\';
            Result := FieldByName( 'UserCia' ).AsString;
         end;
      end;
   end;
begin
   gral.PubMuestraProgresBar( True );
   try
      if Trim( txtCia.Text ) = '' then begin
         Application.MessageBox( pchar( dm.xlng( 'Seleccione una compañia' ) ),
            pchar( dm.xlng( 'Login' ) ), MB_OK );
         txtCia.SetFocus;
         Exit;
      end;

      if ( Trim( txtUsuario.Text ) = '' ) or ( Trim( txtPassWord.text ) = '' ) then begin
         Application.MessageBox( pchar( dm.xlng( 'Usuario o Password incorrectos' ) ),
            pchar( dm.xlng( 'Login' ) ), MB_OK );
         txtUsuario.SetFocus;
         Exit;
      end;

      sUsuario:= txtUsuario.Text;   // ALK para tener el usuario general

      sUserCia := sObtenerUserCia( txtCia.Text );
      detecta_base( g_odbc, sUserCia );
      detecta_usuarios( sUserCia, True );

      {if dm.conectar_BDE then
         dm.qBDE1.DatabaseName := dm.dbverfte.DatabaseName
      else begin
         application.Terminate;
         abort;
      end;}//no utilizar, solo si existe conexion ODBC y BDEngine

      //incluir tambien:
      if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'LANGUAGE' + g_q ) then begin
         g_language := dm.q1.fieldbyname( 'dato' ).asstring;
      end;
      if g_language = 'ENGLISH' then begin
         //musuario.Caption := 'Users';
      end;
      // icono_clases;
      // fin incluir
      if dm.sqlselect( dm.q1, 'select * from tsuser where cuser=' + g_q + txtusuario.text + g_q ) then begin

         if dm.sqlselect( dm.q2, 'select * from tsroluser where cuser=' + g_q + txtusuario.text + g_q ) then begin

            if dm.sqlselect( dm.q3, 'select * from parametro where clave=' + g_q +
               'ROL_' + dm.q2.fieldbyname( 'crol' ).AsString + g_q ) then begin
               g_caduca := dm.q3.fieldbyname( 'dato' ).AsString;
               g_caduca := dm.desencripta( g_caduca );
            end;

         end
         else begin
            if ( txtusuario.text <> 'ADMIN' )
               and ( txtusuario.text <> 'SVS' ) then begin
               Application.MessageBox( pchar( dm.xlng( 'Rol: ' + g_q + 'ROL_' + dm.q2.fieldbyname( 'crol' ).AsString + g_q +
                  ' sin fecha de caducidad, consultar al administrador' ) ),
                  pchar( dm.xlng( 'Login' ) ), MB_OK );
               txtUsuario.SetFocus;
               Exit;
            end
            else begin
               g_caduca := formatdatetime( 'YYYYMMDD', now );
            end;
         end;

         if txtpassword.Text = '12345' then
            pass := txtpassword.Text
         else
            pass := dm.encripta( txtpassword.Text );

         if pass <> dm.q1.fieldbyname( 'password' ).AsString then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... Password incorrecto' ) ),
               pchar( dm.xlng( 'Login' ) ), MB_OK );
            txtPassword.SetFocus;
            Exit;
         end
         else begin
            if formatdatetime( 'YYYYMMDD', now ) > g_caduca then begin
               Application.MessageBox( pchar( dm.xlng( 'ERROR... Licencia caducada' ) ),
                  pchar( dm.xlng( 'Validar licencia' ) ), MB_OK );
               txtUsuario.SetFocus;
               exit;
            end;
            if copy( formatdatetime( 'YYYYMMDD', now ), 1, 6 ) = copy( g_caduca, 1, 6 ) then begin
               Application.MessageBox( pchar( dm.xlng( 'WARNING... Licencia caducará el día ' + copy( g_caduca, 7, 2 ) + ' de este mes' ) ),
                  pchar( dm.xlng( 'Validar licencia' ) ), MB_OK );
            end;
            g_usuario := txtusuario.text;
         end;
      end
      else begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... No existe el usuario' ) ),
            pchar( dm.xlng( 'Login' ) ), MB_OK );
         txtUsuario.SetFocus;
         Exit
      end;

      g_demonio := dm.sqlselect( dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'MODO_SERVER' + g_q +
         ' and dato=' + g_q + 'DEMONIO' + g_q );
      if g_demonio then begin
         g_busca_remoto := true;
      end
      else begin
         g_busca_remoto := dm.sqlselect( dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'MODO_SERVER' + g_q +
            ' and   dato=' + g_q + 'BUSCA_REMOTO' + g_q );
      end;

      if g_demonio or g_busca_remoto then begin
         if dm.sqlselect( dm.q1, 'select count(*) from tssolver' ) = false then begin
            application.MessageBox( pchar( dm.xlng( 'ERROR... El demonio TSSOLVER no ha corrido' ) ),
               pchar( dm.xlng( 'tssolver ' ) ), MB_OK );
         end
         else if dm.sqlselect( dm.q1, 'select count(*) from tssolverhist' ) = false then begin
            application.MessageBox( pchar( dm.xlng( 'ERROR... El demonio TSSOLVER no ha corrido' ) ),
               pchar( dm.xlng( 'tssolverhist ' ) ), MB_OK );
         end
         else if dm.pingdemonio = false then begin
            application.MessageBox( pchar( dm.xlng( 'ERROR... El demonio TSSOLVER no está corriendo' ) ),
               pchar( dm.xlng( 'tssolver ' ) ), MB_OK );
         end;
      end;
      g_tmpdir := g_ruta + 'tmp';
      g_logdir := g_ruta + 'log';

      // revisa que existan todos los directorios de tsprog en tsbibcla.
      if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TSBIBCLA' + g_q ) then
         dm.activa_tsbibcla;
      //

      dm.revisa_version;

      if dm.sqlselect( dm.q1, 'select * from tslogon where cuser=' + g_q + g_usuario + g_q + ' and fecha_salida IS NULL' +
         ' and (to_char(sysdate,' + g_q + 'YYYYMMDDHH24MISS' + g_q + ') - to_char(control_tiempo,' + g_q + 'YYYYMMDDHH24MISS' + g_q + ')) > 500'
         ) then begin
         Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
         if dm.sqlupdate( 'update tslogon ' +
            ' set fecha_salida =' + Wfecha +
            ' where cuser=' + g_q + g_usuario + g_q + ' and (fecha_salida ' + g_is_null + ')'
            ) = false then
            Application.MessageBox( pchar( 'No puede actualizar tslogon' ),
               pchar( 'Control Tiempo' ), MB_OK );
      end;

      if ( g_usuario <> 'ADMIN' ) and ( g_usuario <> 'SVS' ) then begin
         if dm.sqlselect( dm.q1, 'select * from tslogon where cuser=' + g_q + g_usuario + g_q +
            ' and fecha_salida IS NULL' + ' and (to_char(sysdate,' + g_q + 'YYYYMMDDHH24MISS' +
            g_q + ') - to_char(control_tiempo,' + g_q + 'YYYYMMDDHH24MISS' + g_q + ')) < 500' ) then begin
            application.MessageBox( pchar( dm.xlng( 'La clave de usuario ya esta en uso, reintentar más tarde' ) ),
               pchar( dm.xlng( 'Login ' ) ), MB_OK );
            Exit;
         end;
      end;
      if dm.sqlselect( dm.q1, 'select * from tslogon where fecha_salida is null' ) then begin
         if dm.sqlselect( dm.q2, 'select * from parametro where clave=' + g_q + 'NUMUSU' + g_q ) then begin
            Wnumusu := strtoint( dm.q2.fieldbyname( 'dato' ).asstring );
         end;
         if dm.q1.recordcount > Wnumusu then begin
            application.MessageBox( pchar( dm.xlng( 'Excede número máximo de usuarios conectados' ) ),
               pchar( dm.xlng( 'Login ' ) ), MB_OK );
            Exit;
         end;
      end;

      gral.CONTROL_ACCESO( );
      //dm.bfile_directorio;
      if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'GRAPHVIZ VERSION' + g_q ) = false then begin
         application.MessageBox( pchar( dm.xlng( 'ERROR... falta el parametro "GRAPHVIZ VERSION" ' ) ),
            pchar( dm.xlng( 'Validar parametros' ) ), MB_OK );
      end
      else
         g_graphviz := dm.q1.fieldbyname( 'dato' ).asstring;
      if trim( g_usuario ) = '' then begin
         application.Terminate;
         abort;
      end;
      if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'VERSIONSHD' + g_q ) then
         caption := dm.q1.fieldbyname( 'dato' ).AsString; //+' - '+g_usuario+' - '+g_odbc;
      if dm.sqlselect( dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'EMPRESA-NOMBRE-1' + g_q ) then begin
         g_empresa := dm.q1.fieldbyname( 'dato' ).AsString;
      end;

      if dm.sqlselect( dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'TIEMPO_ESPERA_TSSOLVER' + g_q ) then begin
         g_tiempo_espera_tssolver := strtoint( dm.q1.fieldbyname( 'dato' ).AsString );
      end;

      if dm.sqlselect( dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'TIEMPO_ENVIA' + g_q ) then begin
         g_tiempo_envia := strtoint( dm.q1.fieldbyname( 'dato' ).AsString );
      end;

      if dm.sqlselect( dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'ARBOLDESCRIPCION' + g_q ) then begin
         l_ad := dm.q1.fieldbyname( 'dato' ).AsString;
         if pos( '$', l_ad ) = 0 then begin
            if dm.sqlupdate( 'update parametro ' +
               ' set secuencia= 0' + ' ,dato=' + g_q + '$HCCLASE$ $HCBIB$ $HCPROG$' + g_q +
               ' ,descripcion=' + g_q + '$HCCLASE$_$HCBIB$_$HCPROG$    ->  CBL_COBLIB_PROGRAMA1 donde HCCLASE=CBL, HCBIB=COBLIB, HCPROG=PROGRAMA1 ' +
               'DATO=$HCCLASE$=$HCPROG_NOEXT$ ->  FIL=C:\ARCHIVOS\FILE1 donde HCCLASE=FIL, HCPROG= C:\ARCHIVOS\FILE1.DAT ' +
               'DATO=--$HCPROG_BASENAME$      ->  --FILE1.DAT donde  HCPROG= C:\ARCHIVOS\FILE1.DAT ' +
               'DATO=>$HCCLASE$>>>$HCPROG_BASENAME_NOEXT$ ->  >FIL>>>FILE1  donde HCCLASE=FIL, HCPROG= C:\ARCHIVOS\FILE1.DAT ' + g_q +
               ' where clave=' + g_q + 'ARBOLDESCRIPCION' + g_q ) = false then
               application.MessageBox( pchar( dm.xlng( '... no puede actualizar la secuencia de version' ) ),
                  pchar( dm.xlng( 'Login ' ) ), MB_OK );
            g_ArbolDescri := '$HCCLASE$ $HCBIB$ $HCPROG$';
         end;
      end;

      if dm.sqlselect( dm.q1, 'select * from tsoficina' ) then
         g_pais := dm.q1.fieldbyname( 'coficina' ).asstring;

      g_tmpdir := g_ruta + 'tmp';
      g_logdir := g_ruta + 'log';
      //g_oratmpdir := 'TMPDIR' + g_pais;
      g_oratmpdir := 'TMPDIR' + g_pais;
      if forcedirectories( g_tmpdir ) = false then begin
         application.MessageBox( pchar( dm.xlng( 'ERROR... no puede crear el directorio ' + g_tmpdir ) ),
            pchar( dm.xlng( 'Crear forma - ftsmain ' ) ), MB_OK );
         abort;
      end;
      if forcedirectories( g_logdir ) = false then begin
         application.MessageBox( pchar( dm.xlng( 'ERROR... no puede crear el directorio ' + g_logdir ) ),
            pchar( dm.xlng( 'Crear directorio - ftsmain ' ) ), MB_OK );
         abort;
      end;

      gLogin.Visible := False;
      stbPrincipal.Panels[ 0 ].Text := LowerCase( g_empresa );
      stbPrincipal.Panels[ 1 ].Text := LowerCase( g_user_procesa );
      stbPrincipal.Panels[ 3 ].Text := LowerCase( g_usuario );

      //gApplicationMining.Visible := True;
      //gDocumentacion.Visible := True;

      HabilitaMenuInicial( True );

      mnuIniciar.Enabled := False;

      /////JCRgVentanas.Visible := False;
      gVentanas.Expanded := False;
      gVentanas.Expandable := True;

      gConvComp.Expanded := False;
      gConvComp.Expandable := True;
      gAnalisisEspecificos.Expanded := False;
      gAnalisisEspecificos.Expandable := True;
      Capacidades;


      // ===== Cambio de Robert para USERDEF y BASEDEF =======      ALK
      ptsrec.reemplaza_basedef_userdef('ptsrecibe');
      // ======= Validacion de directorios oracle  ALK  ======
      //validar para cada uno si existe o no su directorio
      cons:= 'SELECT ORACLEDIR, PATH FROM TSBIBCLA' +
             ' WHERE ORACLEDIR not in (select directory_name from all_directories)';
      if dm.sqlselect(dm.q4,cons) then begin
         while not dm.q4.Eof do begin
            cons:= 'create directory ' + dm.q4.FieldByName('ORACLEDIR').AsString +
                   ' as ' + g_q +dm.q4.FieldByName('PATH').AsString + g_q;
            try
               dm.sqlinsert(cons);
            except
            end;
            dm.q4.Next;
         end;
      end;
      // =====================================================
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftsmain.Capacidades;
var
   i: Integer;
   ListaClases: string;
begin
   // Dar de alta en tscapacidad
   //mnuBusComponentes.visible:=dm.capacidad('Mining - Busca');
   ////mnuRecComponentes.Visible := dm.capacidad( 'Mining - Recepcion Componentes' );
   //mnuInvComponentes.Visible:=dm.capacidad('Mining - Inventario Componentes');
   //Matriz CRUD
   //Lista Componenets
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

   if dm.capacidad( 'MENU IZQUIERDO MINERIA APLICACIONES' ) then
      gApplicationMining.Visible := true
   else
      gApplicationMining.Visible := false;
   if dm.capacidad( 'MENU IZQUIERDO DOCUMENTACION DEL SISTEMA' ) then
      gDocumentacion.Visible := true
   else
      gDocumentacion.Visible := false;
   if dm.capacidad( 'MENU IZQUIERDO CONVERSION DE COMPONENTES' ) then
      gConvComp.Visible := true
   else
      gConvComp.Visible := false;
   if dm.capacidad( 'MENU IZQUIERDO ANALISIS ESPECIFICOS' ) then
      gAnalisisEspecificos.Visible := true
   else
      gAnalisisEspecificos.Visible := false;
   if dm.capacidad( 'MENU IZQUIERDO CAMBIOS MASIVOS' ) then
      gMasivos.Visible := true
   else
      gMasivos.Visible := false;
   if dm.capacidad( 'MENU IZQUIERDO VALIDACIONES ESTATICAS' ) then
      gEstaticas.Visible := true
   else
      gEstaticas.Visible := false;
   if dm.capacidad( 'MENU IZQUIERDO VENTANAS ACTIVAS' ) then
      gVentanas.Visible := true
   else
      gVentanas.Visible := false;
   if dm.capacidad( 'MENU IZQUIERDO FABRICA DE PRUEBAS TECNICAS' ) then
      gFabricaPbasTec.Visible := true
   else
      gFabricaPbasTec.Visible := false;
   //if dm.capacidad( 'MENU IZQUIERDO LOGIN' ) then
      gLogin.Visible := false;          //se vuelve visible al salir del login

   if dm.capacidad( 'MENU PRINCIPAL LOGIN' ) then
      mnuSesion.Visible := ivAlways
   else
      mnuSesion.Visible := ivNever;
   if dm.capacidad( 'MENU PRINCIPAL ADMINISTRACION' ) then
      mnuAdministracion.Visible := ivAlways
   else
      mnuAdministracion.Visible := ivNever;
   if dm.capacidad( 'MENU PRINCIPAL CATALOGOS' ) then
      mnuCatalogos.Visible := ivAlways
   else
      mnuCatalogos.Visible := ivNever;
   if dm.capacidad( 'MENU PRINCIPAL HERRAMIENTAS' ) then
      mnuHerramientas.Visible := ivAlways
   else
      mnuHerramientas.Visible := ivNever;
   if dm.capacidad( 'MENU PRINCIPAL VENTANAS' ) then
      mnuVentanas.Visible := ivAlways
   else
      mnuVentanas.Visible := ivNever;
   if dm.capacidad( 'MENU PRINCIPAL AYUDA' ) then
      mnuAyuda.Visible := ivAlways
   else
      mnuAyuda.Visible := ivNever;

   if dm.capacidad( 'MENU ICONOS ENTRAR' ) then
      mnuIniciar.Visible := ivAlways
   else
      mnuIniciar.Visible := ivNever;       // (ivAlways)
   if dm.capacidad( 'MENU ICONOS SALIR' ) then
      mnuTerminar.Visible := ivAlways
   else
      mnuTerminar.Visible := ivNever;      // (ivAlways)
   if dm.capacidad( 'MENU ICONOS BASE DE CONOCIMIENTOS' ) then
      mnuBaseConocimiento2.Visible := ivAlways
   else
      mnuBaseConocimiento2.Visible := ivNever;        // (ivNever) - ivAlways
   if dm.capacidad( 'MENU ICONOS BUSQUEDA DE COMPONENTES' ) then
      mnuBusComponentes2.Visible := ivAlways
   else
      mnuBusComponentes2.Visible := ivNever;
   if dm.capacidad( 'MENU ICONOS CONSULTA DE COMPONENTES' ) then
      mnuConsulta.Visible := ivAlways
   else
      mnuConsulta.Visible := ivNever;
   if dm.capacidad( 'MENU ICONOS INVENTARIO DE COMPONENTES' ) then
      dxBarButtonInvComponentes.Visible := ivAlways
   else
      dxBarButtonInvComponentes.Visible := ivNever;
   if dm.capacidad( 'MENU ICONOS LISTA DE COMPONENTES' ) then
      dxBarButtonLisComponentes.Visible := ivAlways
   else
      dxBarButtonLisComponentes.Visible := ivNever;
   if dm.capacidad( 'MENU ICONOS LISTA DE DEPENDENCIAS' ) then
      dxBarButtonLisDependencias.Visible := ivAlways
   else
      dxBarButtonLisDependencias.Visible := ivNever;
   if dm.capacidad( 'MENU ICONOS MATRIZ CRUD' ) then
      dxBarButtonMatrizCrud.Visible := ivAlways
   else
      dxBarButtonMatrizCrud.Visible := ivNever;
   if dm.capacidad( 'MENU ICONOS MATRIZ AF' ) then
      dxBarButtonMatrizAF.Visible := ivAlways
   else
      dxBarButtonMatrizAF.Visible := ivNever;
   if dm.capacidad( 'MENU ICONOS RECEPCION DE COMPONENTES' ) then begin
      mnureccomponentes.Visible:=true;
      dxBarButtonRecComponentes.Visible := ivAlways;
   end
   else begin
      mnureccomponentes.Visible:=false;
      dxBarButtonRecComponentes.Visible := ivNever;
   end;
end;

procedure Tftsmain.grdVentanasDBTableView1DblClick( Sender: TObject );
var
   sCaptionVentana: string;
begin
   sCaptionVentana := dm.tabVentanas.FindField( 'VentanaCaption' ).AsString;
   gral.bPubVentanaActiva( sCaptionVentana );
end;

procedure Tftsmain.mnuWindowsClick( Sender: TObject );
var
   i, j: Integer;
begin
   mnuPrincipal.Style := bmsXP;
   stbPrincipal.PaintStyle := stpsXP;
   dxNavBar1.View := 11; //XPExplorerBarView;

   //fercar4 cambiar estilo a formas activas tipo MDIChild
   with ftsmain do
      for i := 0 to MDIChildCount - 1 do
         for j := 0 to MDIChildren[ i ].ComponentCount - 1 do begin
            if MDIChildren[ i ].Components[ j ].ClassType = TdxBarManager then
               ( MDIChildren[ i ].Components[ j ] as TdxBarManager ).Style := mnuPrincipal.Style;

            if MDIChildren[ i ].Components[ j ].ClassType = TdxStatusBar then
               ( MDIChildren[ i ].Components[ j ] as TdxStatusBar ).PaintStyle := stbPrincipal.PaintStyle;
         end;
end;

procedure Tftsmain.mnuFlatClick( Sender: TObject );
var
   i, j: Integer;
begin
   mnuPrincipal.Style := bmsFlat;
   stbPrincipal.PaintStyle := stpsFlat;
   dxNavBar1.View := 9; //UltraFlatExplorerView;

   //cambia estilo a formas activas tipo MDIChild
   with ftsmain do
      for i := 0 to MDIChildCount - 1 do
         for j := 0 to MDIChildren[ i ].ComponentCount - 1 do begin
            if MDIChildren[ i ].Components[ j ].ClassType = TdxBarManager then
               ( MDIChildren[ i ].Components[ j ] as TdxBarManager ).Style := mnuPrincipal.Style;

            if MDIChildren[ i ].Components[ j ].ClassType = TdxStatusBar then
               ( MDIChildren[ i ].Components[ j ] as TdxStatusBar ).PaintStyle := stbPrincipal.PaintStyle;
         end;
end;

procedure Tftsmain.mnuOfficeClick( Sender: TObject );
var
   i, j: Integer;
begin
   mnuPrincipal.Style := bmsOffice11;
   stbPrincipal.PaintStyle := stpsOffice11;
   dxNavBar1.View := 12; //Office11View;

   // cambiar estilo a formas activas tipo MDIChild
   with ftsmain do
      for i := 0 to MDIChildCount - 1 do
         for j := 0 to MDIChildren[ i ].ComponentCount - 1 do begin
            if MDIChildren[ i ].Components[ j ].ClassType = TdxBarManager then
               ( MDIChildren[ i ].Components[ j ] as TdxBarManager ).Style := mnuPrincipal.Style;

            if MDIChildren[ i ].Components[ j ].ClassType = TdxStatusBar then
               ( MDIChildren[ i ].Components[ j ] as TdxStatusBar ).PaintStyle := stbPrincipal.PaintStyle;
         end;
end;

procedure Tftsmain.mnuConsultaClick( Sender: TObject );
var
   icont,ierror: integer;  //alk out of system
begin
   screen.Cursor := crsqlwait;
   g_producto := 'MINING-CONSULTA';
   gral.PubMuestraProgresBar( True );

   try

      if gral.bPubVentanaActiva( sLISTA_CONS_COMPONE ) then
         Exit;

      //ftsconscom := TfmConsCom.Create( self );
      // ------ ALK para controlar el error out of system resources ------
      ierror := 0;
      try
         ftsconscom := TfmConsCom.Create( self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     ftsconscom := TfmConsCom.Create( self );
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

      if ierror = 0 then begin
         ftsconscom.FormStyle := fsMDIChild;

         if gral.bPubVentanaMaximizada = FALSE then begin
            ftsconscom.Width := g_Width;
            //ftsconscom.Height := g_Height;
         end;

        //ftsconscom.titulo := sLISTA_CONS_COMPONE;
         ftsconscom.caption := sLISTA_CONS_COMPONE;
         ftsconscom.Show;

         dm.PubRegistraVentanaActiva( sLISTA_CONS_COMPONE );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsmain.mnuConversionClick( Sender: TObject );
begin
   g_producto := 'CONVERSIÓN DE COMPONENTES';
   PR_CNVPROG;
end;

procedure Tftsmain.mnuCasosUsoClick( Sender: TObject );
var
   ndir, CasoUsoSysView: string;
begin
   g_producto := 'HERRAMIENTAS-CASOS DE USO';
   gral.CreaTablas( );
   ndir := g_ruta + '\Reportes';
   if directoryexists( ndir ) = false then begin
      if forcedirectories( ndir ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... No puede crear directorio ' + ndir ) ),
            pchar( dm.xlng( 'Reporteador/Casos de uso ' ) ), MB_OK );
         exit;
      end;
   end;
   chdir( ndir );
   CasoUsoSysView := ndir + '\hta' + formatdatetime( 'YYYYMMDDHHNNSS', now ) + '.exe';
   dm.get_utileria( 'CUSYSVIEW', CasoUsoSysView );
   ShellExecute( 0, 'open', pchar( CasoUsoSysView ),
      pchar( 'SYSVIEWSOFTSCM' + ' ' + g_user_procesa + ' ' + g_pass ),
      //pchar(g_odbc+' '+g_user_procesa+' '+g_pass),
      PChar( g_ruta + '\Reportes' ), SW_SHOW );
   chdir( g_ruta );
end;

procedure Tftsmain.mnuSalidaClick( Sender: TObject );
begin
   HtmlHelp( 0, nil, HH_CLOSE_ALL, 0 );
   Close;
end;

procedure Tftsmain.mnuAyudaGeneralClick( Sender: TObject );
begin
   HtmlHelp( Application.Handle,
      PChar( Application.HelpFile ),
      HH_DISPLAY_TOC, 0 );

end;
{
function Tftsmain.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,2001])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;
}

procedure Tftsmain.mnuAyudaOpcClick( Sender: TObject );
var
   CallHelp: Boolean;
begin
   CallHelp := False;
   try
      PR_BARRA;
      //iHelpContext:=ActiveControl.HelpContext;
      HtmlHelp( Application.Handle,
         PChar( Format( '%s::/T%5.5d.htm',
         //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
         [ Application.HelpFile, iHelpContext ] ) ), HH_DISPLAY_TOPIC, 0 );
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado', 'Ayuda ', MB_OK );
   end;

end;

procedure Tftsmain.txtCiaClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02001;
end;

procedure Tftsmain.txtUsuarioClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02001;
end;

procedure Tftsmain.txtPasswordClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02001;
end;

procedure Tftsmain.gApplicationMiningClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T01000;
end;

procedure Tftsmain.gConvCompClick( Sender: TObject );
begin
   //   iHelpContext := IDH_TOPIC_T01800;
end;

procedure Tftsmain.gVentanasClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T01900;
end;

procedure Tftsmain.gLoginClick( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T02000;
end;

procedure Tftsmain.pnlMenuClick( Sender: TObject );
begin
   //iHelpContext := IDH_TOPIC_T02200;
end;

procedure Tftsmain.FormActivate( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T00001;
end;

procedure Tftsmain.Image1Click( Sender: TObject );
begin
   iHelpContext := IDH_TOPIC_T00001;
end;

procedure Tftsmain.mnuActualizaInventarioClick( Sender: TObject );
begin
   screen.Cursor := crsqlwait;
   g_producto := 'ADMINISTRACIÓN-LIMPIA INVENTARIOS';
   //Application.MessageBox( 'Actualizará Inventario, el proceso puede tardar unos minutos ', 'Administración ', MB_OK );
   gral.LimpiaInventario;
   //Application.MessageBox( 'Inventario Actualizado', 'Administración ', MB_OK );
   screen.Cursor := crdefault;
end;

procedure Tftsmain.mnuEditorDiagramaClick( Sender: TObject );
begin
   g_producto := 'HERRAMIENTAS-EDITOR DE DIAGRAMAS';
   DiagramEditor.Execute; //fercar diagram studio
end;

procedure Tftsmain.mnuListaDependenciasClick( Sender: TObject );
var
   Titulo: string;
   icont,ierror: integer;  //alk out of system
begin
   iHelpContext := IDH_TOPIC_T01500;
   screen.Cursor := crsqlwait;
   g_producto := 'MINING-LISTA DEPENDENCIA COMPONENTES';
   gral.PubMuestraProgresBar( True );
   try
      g_Wforma := 'mining';
      g_Wforma_aux := '';
      titulo := sLISTA_DEPENDENCIAS;

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      //fmListaDependencias := TfmListaDependencias.create( Self );
      // ------ ALK para controlar el error out of system resources ------
      ierror := 0;
      try
         fmListaDependencias := TfmListaDependencias.create( Self );
      except
         on E: exception do begin
            Sleep(100); // doy un tiempo
            ierror:=1;   //hubo un error, lo indico
            for icont:=0 to 500 do begin
               if ierror=1 then begin      //si hay error, si no pudo generar
                  ierror:=0;  //doy por hecho que lo genera
                  try
                     fmListaDependencias := TfmListaDependencias.create( Self );
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

      if ierror = 0 then begin
         fmListaDependencias.FormStyle := fsMDIChild;

         if gral.bPubVentanaMaximizada = FALSE then begin
            fmListaDependencias.Width := g_Width;
            fmListaDependencias.Height := g_Height;
         end;

         fmListaDependencias.titulo := titulo;
         fmListaDependencias.caption := titulo;

         ufmListaDependencias.PR_LISTADependencias;

         //if FormStyle = fsMDIChild then
         dm.PubRegistraVentanaActiva( Titulo );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      screen.Cursor := crdefault;
   end;
end;

procedure Tftsmain.FormCloseQuery( Sender: TObject; var CanClose: Boolean );
begin
   if application.MessageBox( pchar( '  ¿Desea salir del sistema?' ), 'Confirmar', MB_ICONQUESTION or MB_YESNO ) = IDNO then begin
      CanClose := False;
   end
   else begin
      Wfecha := dm.datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' );
      if dm.sqlupdate( 'update tslogon ' +
         ' set fecha_salida = ' + Wfecha +
         ' where cuser=' + g_q + g_usuario + g_q + ' and (fecha_salida ' + g_is_null + ')' ) = false then
         Application.MessageBox( pchar( 'No puede actualizar tslogon' ),
            pchar( 'Control Tiempo' ), MB_OK );
   end;
end;

procedure Tftsmain.mnuAnalisisProgramasClick( Sender: TObject );
begin
   g_producto := 'ANÁLISIS ESPECÍFICOS-ANÁLISIS PROGRAMAS';
   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TSRELAVCBL' + g_q ) or
      dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'tsrelavcbl' + g_q ) then
      PR_ANAPROG
   else
      Application.MessageBox( pchar( 'Actualizar BD' ), pchar( 'Análisis específicos' ), MB_OK );
end;

procedure Tftsmain.mnuPropagacionVariablesClick( Sender: TObject );
begin
   g_producto := 'ANÁLISIS ESPECÍFICOS-PROPAGACIÓN VARIABLES';
   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TSMAESTRA' + g_q ) or
      dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'tsmaestra' + g_q ) then
      PR_PROPAGA
   else
      Application.MessageBox( pchar( 'Actualizar BD' ), pchar( 'Propagación de variables' ), MB_OK );
end;

procedure Tftsmain.mnuTsprogDescClick( Sender: TObject );
begin
   //iHelpContext:=IDH_TOPIC_T02209;
   //g_producto := 'CATÁLOGOS-CLASES';
   PR_CATALOG( mnuTsprogDesc.Caption, 'select ' +
      'sistema            vk__Sistema, ' +
      'cprog              vk__Prog, ' +
      'cbib               vk__Bib, ' +
      'cclase             vk__Clase, ' +
      'fecha              vk__Fecha, ' +
      'descripcion        v___Descripcion ' +
      ' from tsprog ' +
      ' where sistema=' + g_q + '$1$' + g_q +
      ' and cprog=' + g_q + '$2$' + g_q +
      ' and cbib=' + g_q + '$3$' + g_q +
      ' and cclase =' + g_q + '$4$' + g_q,
      //' and fecha = to_char(' + g_q + '$4$' + g_q + ',' +  g_q + 'YYYYMMDDHH24MISS' + g_q + ')',
      'insert into tsprog (sistema,cprog,cbib,cclase,fecha,descripcion) values(' +
      g_q + '$1$' + g_q + ',' +
      g_q + '$2$' + g_q + ',' +
      g_q + '$3$' + g_q + ',' +
      g_q + '$4$' + g_q + ',' +
      g_q + '$5$' + g_q + ',' +
      g_q + '$6$' + g_q + ')',
      'update tsprog set ' +
      'descripcion=' + g_q + '$6$' + g_q +
      ' where sistema=' + g_q + '$1$' + g_q +
      ' and cclase=' + g_q + '$4$' + g_q +
      ' and cbib=' + g_q + '$3$' + g_q +
      ' and cprog =' + g_q + '$2$' + g_q,
      'delete tsprog where sistema=' + g_q + '$1$' + g_q +
      ' and  cclase=' + g_q + '$4$' + g_q +
      ' and cbib=' + g_q + '$3$' + g_q +
      ' and cprog =' + g_q + '$2$' + g_q, mnuTsprogDesc.ImageIndex );
   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'sistema' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'cprog' ) );
   fcatalog.regla( '$3$', '<>', '', '', dm.xlng( 'cbib' ) );
   fcatalog.regla( '$4$', '<>', '', '', dm.xlng( 'cclase' ) );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;
end;

procedure Tftsmain.mnuDocProductosTipoClick( Sender: TObject );
var
   fmDocSistema: TfmDocSistema;
   Titulo: String;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      Titulo := sDOCUMENTACION_SIS + ' - Productos por Tipo';

      if gral.bPubVentanaActiva( Titulo ) then
         Exit;

      fmDocSistema := TfmDocSistema.Create( Self );

      if gral.bPubVentanaMaximizada = False then begin
         fmDocSistema.Width := g_Width;
         fmDocSistema.Height := g_Height;
      end;

      fmDocSistema.PubGeneraLista( Titulo );
      fmDocSistema.Show;

      dm.PubRegistraVentanaActiva( Titulo );
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure Tftsmain.cxSplitter1Moved(Sender: TObject);
begin
   txtCia.Width := gLoginControl.Width - 15;
   txtUsuario.Width := gLoginControl.Width - 15;
   txtPassword.Width := gLoginControl.Width - 15;
end;

procedure Tftsmain.dxBarButton1Click(Sender: TObject);
begin
   screen.Cursor := crsqlwait;
   gral.JerarquiaClases(1);   // para indicar que se debe ejecutar la ventana de sistemas
   screen.Cursor := crdefault;
end;

procedure Tftsmain.dxBarButton3Click(Sender: TObject);
begin
   //Stored Procedure de Carlos    29 May 15
   if dm.sqlselect( dm.q4, ' select * from user_procedures where OBJECT_NAME = ' + g_q + 'CALIFICA' + g_q ) = FALSE then begin
      Application.MessageBox( PChar( 'No existe el proceso:  CALIFICA' ), 'Actualiza Inventario', MB_OK );
      Exit;
   end;
   if dm.sqlselect( dm.q4, ' select * from user_procedures where OBJECT_NAME = ' + g_q + 'EJECUTA_ACTIVOS' + g_q ) = FALSE then begin
      Application.MessageBox( PChar( 'No existe el proceso:  EJECUTA_ACTIVOS' ), 'Actualiza Inventario', MB_OK );
      Exit;
   end;
   if dm.sqlselect( dm.q4, ' select * from user_procedures where OBJECT_NAME = ' + g_q + 'ACTIVOS' + g_q ) = FALSE then begin
      Application.MessageBox( PChar( 'No existe el proceso:  ACTIVOS' ), 'Actualiza Inventario', MB_OK );
      Exit;
   end;

   try
      Application.MessageBox( 'Comienza proceso de calificar Activos/Inactivos'+ chr( 13 ) +
                              'El proceso puede tardar unos minutos. ', 'Administración ', MB_OK );

      // Estos stored procedures son componentes de ADO, se especifica en el inspector de objetos cual
      // es el que se debe ejecutar.    ALK
      dm.spEjecutaActivos.Prepared := True;
      dm.spEjecutaActivos.ExecProc;   // este mismo manda ejecutar Activos

      dm.spCalifica.Prepared := True;
      dm.spCalifica.ExecProc;

      Application.MessageBox( 'Proceso finalizado', 'Administración ', MB_OK );
   except
      on E: exception do begin
         Application.MessageBox( PChar( 'Calificar Activos/Inactivos: ' + E.Message ), 'ERROR', MB_OK );
         exit;
      end;
   end;

end;

procedure Tftsmain.dxBarButton5Click(Sender: TObject);
var
   sist, cons : String;
   sel_sis : TalkAnCompl;
   rgmlang, complejidad, dirCBL, dirCMA, res : String;  //ALK para complejidad
begin
   //traer la ventana para mostrar todos los sistemas
   sel_sis:=TalkAnCompl.Create(self);
   alkSistema:='';
   sel_sis.llena_sistemas;
   if alkSistema = '' then begin
      try
         sel_sis.ShowModal;
      finally
         sel_sis.Free;
      end;
   end;

   if alkSistema <> '' then begin
      if alkSistema = '-' then
         exit;
      sist:=alkSistema
   end
   else
      ShowMessage('ERROR al traer sistema');


   cons:='select cprog,cbib,cclase,sistema from tsprog where sistema='+ g_q + sist + g_q+
          ' and cclase='+ g_q + 'CBL' + g_q+
          ' or cclase='+ g_q + 'CMA' + g_q;

   if dm.sqlselect(dm.q2,cons) then begin
      try
         screen.Cursor := crsqlwait;
         gral.PubMuestraProgresBar( True );
         alkComplejidad:='';

         // -------- Trayendo utilerias para complejidades ---------
         complejidad := g_tmpdir + '\calcomplejidadprograma' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.exe';
         dirCBL := g_tmpdir + '\procesaCBL' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.dir';
         dirCMA := g_tmpdir + '\procesaCMA' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.dir';
         res := g_tmpdir + '\reservadasCMACBL' + formatdatetime( 'YYYYMMDDhhnnss', now );
         rgmlang := g_tmpdir + '\hta' + formatdatetime( 'YYYYMMDDhhnnss', now ) + '.exe';

         dm.get_utileria( 'COMPLEJIDAD', complejidad );  // traer el ejecutable de Natan
         dm.get_utileria( 'COMPLEJIDAD_DIRECTIVAS_CBL', dirCBL,true,true );
         ptscomun.parametros_extra(dm.q2.FieldByName( 'sistema' ).AsString,
                                   dm.q2.FieldByName( 'cclase' ).AsString,
                                   dm.q2.FieldByName( 'cbib' ).AsString,
                                   dirCBL); //--------- Checa si necesita parametros especiales ---------  RGM
         dm.get_utileria( 'COMPLEJIDAD_DIRECTIVAS_CMA', dirCMA,true,true );
         dm.get_utileria( 'COMPLEJIDAD_RESERVADAS_CMACBL', res );
         ptscomun.parametros_extra(dm.q2.FieldByName( 'sistema' ).AsString,
                                   dm.q2.FieldByName( 'cclase' ).AsString,
                                   dm.q2.FieldByName( 'cbib' ).AsString,
                                   dirCMA); //--------- Checa si necesita parametros especiales ---------  RGM
         dm.get_utileria( 'RGMLANG', rgmlang );

         g_borrar.Add(complejidad);
         g_borrar.Add(dirCBL);
         g_borrar.Add(dirCMA);
         g_borrar.Add(res);
         g_borrar.Add(rgmlang);

         while not dm.q2.Eof do begin
            dm.complejidad(dm.q2.FieldByName( 'cprog' ).AsString,
                        dm.q2.FieldByName( 'cclase' ).AsString,
                        dm.q2.FieldByName( 'cbib' ).AsString,
                        dm.q2.FieldByName( 'sistema' ).AsString,
                        rgmlang, complejidad, dirCBL, dirCMA, res);


            if alkComplejidad <> '' then begin
               ShowMessage(alkComplejidad);
               break;
            end;

            dm.q2.Next;
         end;
      finally
         gral.PubMuestraProgresBar( False );
         screen.Cursor := crdefault;
      end;
   end;
end;

procedure Tftsmain.mnuCambiosMasivosClick(Sender: TObject);
begin
   PR_CONVER;
end;

procedure Tftsmain.gMasivosClick(Sender: TObject);
begin
   //   iHelpContext := ?????;
end;

procedure Tftsmain.mnuEstaticasClick(Sender: TObject);
begin
   PR_ESTATICA;
end;

procedure Tftsmain.mnuMuertoClick(Sender: TObject);
begin
   PR_MUERTO;
end;

procedure Tftsmain.mnuGeneraDoctosClick(Sender: TObject);
begin
   PR_GENERA;
end;

procedure Tftsmain.dxBarButton6Click(Sender: TObject);
var lista,sistema:string;
begin
   lista:='';
   if dm.sqlselect(dm.q1,'select distinct sistema '+
      ' from tsrela '+
      ' where pcclase in ('+g_q+'CBL'+g_q+','+g_q+'DCL'+g_q+','+g_q+'DCT'+g_q+')') then begin
      while not dm.q1.Eof do begin
         lista:=lista+dm.q1.fieldbyname('sistema').AsString+chr(10);
         dm.q1.Next;
      end;
      sistema:=inputbox('Sistema a procesar',lista+'Sistema:','');
      if trim(sistema)='' then exit;
      if dm.sqlselect(dm.q1,'select * from tssistema '+
         ' where csistema='+g_q+sistema+g_q)=false then begin
         showmessage('El sistema '+sistema+' no existe');
         exit;
      end;
   end;
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   try
      genera_dcl_cbl_fil(sistema);
   finally
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftsmain.hiperligaClick(Sender: TObject);
var
   DocDinamica : TalkFormDocAutoDinam;
begin
   gral.PubMuestraProgresBar( True );
   screen.Cursor := crsqlwait;
   //proceso para generar hiperligas del word.
   try
      if dm.ProcessExists('WINWORD.EXE') then
         dm.ProcessKill('WINWORD.EXE', true);
         
      DocDinamica := TalkFormDocAutoDinam.Create(self);

      DocDinamica.desde_menu;
   finally
      DocDinamica.Free;
      screen.Cursor := crdefault;
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure Tftsmain.mnuGeneraWordClick(Sender: TObject);
var
   formGenera: TalkFormDocWord;
begin
   //aqui va la funcion para traer la ventana
   formGenera:=TalkFormDocWord.Create(self);

   try
      formGenera.ShowModal;
   finally
      formGenera.Free;
   end;
end;

procedure Tftsmain.mnuvalestaticaClick(Sender: TObject);
begin
   //iHelpContext := IDH_TOPIC_T02202;
   PR_CATALOG( mnuvalestatica.Caption, 'select ' +
      'clase       vkc_Clase, ' +
      'regla       vk_nRegla, ' +
      'mensaje     v___Mensaje, ' +
      'descripcion   v_m_Descripcion, ' +
      'estado        v_c_Estado, ' +
      'grado        v_c_Grado, ' +
      'tipo        v___Tipo ' +
      'from tsvalestatica ' +
      'where clase='+g_q+'$1$'+g_q+
      ' and regla=' +g_q+'$2$'+g_q,
      'insert into tsvalestatica (clase,regla,mensaje,descripcion,estado,grado,tipo) values(' +
      g_q + '$1$' + g_q + ',' +
      '$2$' + ',' +
      g_q + '$3$' + g_q + ',' +
      g_q + '$4$' + g_q + ',' +
      g_q + '$5$' + g_q + ',' +
      g_q + '$6$' + g_q + ',' +
      g_q + '$7$' + g_q + ')',
      'update tsvalestatica set ' +
      'mensaje=' + g_q + '$3$' + g_q + ', ' +
      'descripcion=' + g_q + '$4$' + g_q + ', ' +
      'estado=' + g_q + '$5$' + g_q + ', ' +
      'grado=' + g_q + '$6$' + g_q + ', ' +
      'tipo=' + g_q + '$7$' + g_q + ' ' +
      'where clase=' + g_q+'$1$'+g_q+
      ' and regla=' + g_q+'$2$'+g_q,
      'delete parametro where clase='+g_q+'$1$'+g_q+' and regla=' + g_q+'$2$'+g_q, mnuvalestatica.ImageIndex );

   fcatalog.regla( '$1$', '<>', '', '', dm.xlng( 'La Clase no debe quedar vacia' ) );
   fcatalog.regla( '$2$', '<>', '', '', dm.xlng( 'El número de regla no debe quedar vacio' ) );
   fcatalog.regla( '$3$', '<>', '', '', dm.xlng( 'El mensaje no debe quedar vacio' ) );
   fcatalog.regla( '$4$', '<>', '', '', dm.xlng( 'La descripción no debe quedar vacia' ) );
   fcatalog.inicial( 'SELE_ESTADO', 'ACTIVO' );
   dm.feed_combo( fcatalog.pan.FindComponent( 'SELE_CLASE' ) as tcombobox,
      'select cclase from tsclase '+
      ' where estadoactual='+g_q+'ACTIVO'+g_q+
      ' order by 1' );
   ( fcatalog.pan.FindComponent( 'SELE_ESTADO' ) as tcombobox ).Items.Add( 'ACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_ESTADO' ) as tcombobox ).Items.Add( 'INACTIVO' );
   ( fcatalog.pan.FindComponent( 'SELE_GRADO' ) as tcombobox ).Items.Add( 'TERRIBLE' );
   ( fcatalog.pan.FindComponent( 'SELE_GRADO' ) as tcombobox ).Items.Add( 'SEVERO' );
   ( fcatalog.pan.FindComponent( 'SELE_GRADO' ) as tcombobox ).Items.Add( 'WARNING' );
   ( fcatalog.pan.FindComponent( 'SELE_GRADO' ) as tcombobox ).Items.Add( 'INFORMATIVO' );
   try
      fcatalog.Showmodal;
   finally
      fcatalog.Free;
   end;

end;

end.

