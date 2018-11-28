unit ufmDocSistema;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSGrid, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit,
   DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxmdaset,
   dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, ImgList, dxPSCore, dxPScxGridLnk,
   dxBarDBNav, dxBar, dxStatusBar, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
   cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC, OleServer,
   ComObj, ADODB, IniFiles, ComCtrls, StdCtrls, ShellAPI;

const
   sLOG_DOC_CLA_PRO = 'DocClasesProd.';
   sLOG_DOC_CLA_PRO_ERR = 'DocClasesProd.Error.';
   sLEYENDA_SIN_DATOS = 'Sin Datos';
   sLEYENDA_SIN_IMAGEN = 'Sin Imagen';

   sLEYENDA_NOT_TAB = 'Sin Datos - Tabla no activa';

// Estructura para almacenar los datos de la consulta de la base de datos   ALK
type
   datos=record
      cla:string;
      bib:string;
      comp:string;
end;


type
   TForma = (
      fNull, //fNull utilizado para formas o productos no identificados
      fDgrBloques, fDgrAImpacto, fDgrProcesos,
      fDgrFlujoCBL, fDgrFlujoCPY, fDgrFlujoC,
      fDgrFlujoShell, fDgrFlujoJava, fDgrActJava,
      fDgrFlujoJCL, fDgrFlujoJCLvis,
      fDgrFlujoTMC, fDgrFlujoTMP, fDgrJerarquicoCBL,
      fDgrFlujoALG, fDgrJerarquicoALG, fDgrJerarquicoBSC,
      fDgrFlujoWFL, fDgrJerarquicoWFL,
      fLstComponentes, fLstDependencias, fLstRefCruzadas,
      fLstMatrizCrud, fLstMatrizAF, fLstMatrizArchLog,
      fFuente, fDgrFlujoOBY, fDgrFlujoDCL, fDgrFlujoBSC,
      fDgrJerarquicoOSQ, fDgrFlujoOSQ, fCodigoMuerto );

   TClaseForma = record //relacion formas y clases a procesar salidas
      sClase: String;
      fClassName: TForma;
   end;

type
   TfmDocSistema = class( TfmSVSGrid )
      mnuGenerarInforme: TdxBarButton;   //alk cargar el ini de diagrama del sistema
      mnuDocumentacion: TdxBarSubItem;
      mnuGenerarSalidas: TdxBarButton;
      mnuCargarConfiguracion: TdxBarButton;


      procedure mnuGenerarInformeClick( Sender: TObject );
      procedure mnuGenerarSalidasClick ( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure mnuCargarConfiguracionClick( Sender: TObject );
   private
      { Private declarations }
      qTSRELA: TAdoQuery;

      wdGoToLine, wdGoToLast: OleVariant;
      bPriCrear: Boolean;
      iPriIntentoCrear: Integer;

      slPriArchivoIni: TStringList; //almacena el contenido total del archivo ini
      sPriArchivoIni: String; //ruta y nombre del archivo de configuracion (*.ini)
      aPriClaseForma: array of TClaseForma; //obtener del archivo de configuracion
      slPriClasesProcesar: TStringList; //obtener del archivo de configuracion
      bPriClasesScratchProcesar: Boolean; //obtener del archivo de configuracion
      slPriClasesScratchProcesar: TStringList; //obtener del archivo de configuracion

      sPriRutaSalida: String;
      sPriArchLog, sPriArchLogErr: String;

      es_el_primero:boolean;

      lista:TStringList;    //para pasar valores a los combos
      sRutaDiagSis : string;   //indica la ruta de donde dejo el diagrama del sistema

      productos, clases : TStringList;  // obtener productos y clases a procesar    ALK
      guarda:array of datos;    //arreglo de la estructura para pasar los datos de la consulta       ALK

      function bPriPoblarTabla: Boolean;
      procedure PriHabilitarOpcionesMenu( bParHabilitar: Boolean );

      //procedure PriGenerarSalidas( sParSistema: String; sParClase, sParBib, sParProg: String; sParDirectorio: String );
      procedure PriGenerarSalidas( sParSistema: String; estructura : array of datos ; sParDirectorio: String );       //ALK
      procedure PriObtenerClasesFormas( sParArchivo: String );
      function bPriProcesarScratch( sParArchivo: String ): Boolean;
      procedure PriObtenerClasesScratch( sParArchivo: String );
      function bPriEsClaseScratchProcesar( sParClase: String ): Boolean;
      function bPriTerminaProceso: Boolean;
      procedure PriObtenerContenidoArchIni( sParArchivo: String; slParContenido: TStringList );
      //function sPriObtenerGpoSistema( sParSistema: String ): String;
      function sPriObtenerRutaSalida( sParArchivo: String ): String;
      procedure LimpiaBulk(ruta:string);
      //procedure PriCrearDoc( sParSistema: String );
   public
      { Public declarations }
      procedure PubGeneraLista( sParTitulo: String );

   end;

implementation

uses
   ptsdm, ptsgral, uConstantes, uListaRutinas, uDiagramaRutinas, cxExportGrid4Link,
   ufmListaCompo, ufmListaDependencias, ufmMatrizCrud, ufmMatrizAF, ufmMatrizArchLog, ufmRefCruz,
   ufmBloques, ufmAnalisisImpacto, ufmProcesos, ufmDigraSistema, ufmSVSDiagrama, parbol,ptsdiagjcl,
   alkDocAutoDinamica,ptsmuerto;

{$R *.dfm}

procedure TfmDocSistema.PubGeneraLista( sParTitulo: String );
begin
   Caption := sParTitulo;
   tabLista.Caption := sParTitulo;

   if bPriPoblarTabla then begin
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      PriHabilitarOpcionesMenu( tabDatos.RecordCount > 0 );

      GlbCrearCamposGrid( grdDatosDBTableView1 );

      //necesario para la busqueda
      //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
      grdEspejoDBTableView1.DataController.CreateAllItems;
      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      //fin necesario para la busqueda

      grdDatosDBTableView1.ApplyBestFit( );
      GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      tabDatos.ReadOnly := True;
   end;
end;

function TfmDocSistema.bPriPoblarTabla: Boolean;
begin
   Result := False;

   Screen.Cursor := crSqlWait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros

      dm.sqlselect( dm.q1,
         'SELECT CSISTEMA, DESCRIPCION FROM TSSISTEMA' +
         ' WHERE ESTADOACTUAL=' + g_q + 'ACTIVO' + g_q +
         ' ORDER BY CSISTEMA' );

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

procedure TfmDocSistema.PriHabilitarOpcionesMenu( bParHabilitar: Boolean );
begin
   mnuDocumentacion.Enabled := bParHabilitar;
   mnuGenerarSalidas.Enabled := bParHabilitar;
   mnuGenerarInforme.Visible:=ivNever;
end;



//  ************* Funciones para el documento detalle *****************
procedure TfmDocSistema.mnuGenerarInformeClick( Sender: TObject );
{var
   sCSISTEMA: String;
   sTitulo,sNombreIni,sGuardar, sRutaGuardar : string;
   fmDigraSistema: TfmDigraSistema;  //para utilizar los metodos y crear el diagrama del sistema alk
}begin{
   inherited;

   if ( Length( aPriClaseForma ) = 0 ) or ( slPriClasesProcesar.Count = 0 ) then begin
      Application.MessageBox( PChar(
         'Configuración de Clases-Productos incorrecta.' + chr( 13 ) + chr( 13 ) +
         'Cargue un archivo de configuración correcto en el' + chr( 13 ) +
         '"Menú Documentación" opción "Cargar Configuración"' ),
         PChar( 'Aviso' ), MB_OK );
      Exit;
   end;

   Screen.Cursor := crSQLWait;
   try
      if not tabDatos.Active then
         Exit;

      if tabDatos.RecordCount = 0 then
         Exit;

      sCSISTEMA := tabDatos.FieldByName( 'CSISTEMA' ).AsString;
   finally
      Screen.Cursor := crDefault;
   end;

   // ________________ generar diagrama de sistema  ________________      ALK

   //tomar el archivo ini de directorio C:\sysmining\tmp
   {sTitulo:= sDiagSistema + ' DSI DA ' + sCSISTEMA;      // se cambia el nombre a peticion de Martha para estandarizar nombres   ALK
   sGuardar:= sPriRutaSalida + sCSISTEMA + '\Diagrama Sistema\' + sTitulo;    //se añade la extension en la funcion fmDigraSistema.GuardaDiagrama
   sRutaGuardar:= sPriRutaSalida + sCSISTEMA + '\Diagrama Sistema';   //ruta donde se guarda lo referente al diagrama del sistema

   try
      stbLista.Panels[ 1 ].Text := 'Generando Diagrama de Sistema, espere ...';
      Refresh;

      fmDigraSistema:=TfmDigraSistema.Create(self);
      fmDigraSistema.FormStyle := fsNormal;
      fmDigraSistema.Visible := False;

      //Verificar que existe la carpeta donde se guarda
      if forcedirectories( sRutaGuardar ) = false then begin
         application.MessageBox( pchar( dm.xlng( 'AVISO... no puede crear el directorio ' + sRutaGuardar ) ),
            pchar( dm.xlng( 'Docuementacion de Sistema' ) ), MB_OK );
         Exit;
      end;

      //Mostrar en el sysmining el diagrama del sistema
      try
         alkActivoDoc:=1;
         fmDigraSistema.PubGeneraDiagrama('SISTEMA','',sCSISTEMA,sTitulo);
      except
         on E: exception do begin
            stbLista.Panels[ 1 ].Text := 'ERROR al generar diagrama de sistema';
            Refresh;
            exit;
         end;
      end;

      //Guardarlo inmediatamente despues de crearlo  aPDF?
      sRutaDiagSis:=fmDigraSistema.GuardaDiagrama( sGuardar, 0 );    //0-DGR / 1-PDF / 2-VSD / otro-WMF
      if sRutaDiagSis = '' then begin
         stbLista.Panels[ 1 ].Text := 'ERROR al generar diagrama de sistema';
         Refresh;
         exit;
      end;
      //Teniendo el archivo listo, vincularlo con el documento word al final del mismo
   finally
      fmDigraSistema.Free;
      g_borrar.Add( 'SIS_' +sCSISTEMA+'.ini' );//borrar el ini que dejo en tmp
      stbLista.Panels[ 1 ].Text := 'Terminado';
      alkActivoDoc:=0;
      Refresh;
   end;   }
      // ________________ fin de diagrama de sistema  ________________      ALK

   //  generar el documento de word
      //PriCrearDoc( sCSISTEMA );
end;

{procedure TfmDocSistema.PriCrearDoc( sParSistema: String );
var
   Documento: OleVariant;
   DocPreview: Variant;
   sDirSistema, sClase, sBib, sProg : String;
   sClaseProcesar, sCadenaScratch, consulta :String;
   DocDinamica : TalkFormDocAutoDinam;
   k,i,cont:integer;
   fecha, doc_plantilla, fecha_aux : String;
   salva:Tstringlist;
   reprocesa : TStringList;// : TextFile;

   procedure estadisticas (lista:TStringList);
   var
      j,bien, mal:integer;
      log_stadisticas:TStringList;
   begin
      log_stadisticas:= TStringList.Create;
      bien:=0;
      mal:=0;

      for j:=0 to lista.Count-1 do begin
         if FileExists(lista[j])then begin;  // si existe el word poner "ok"
            log_stadisticas.Add('OK   '+lista[j]);
            bien:=bien+1;
         end
         else begin
            log_stadisticas.Add('     '+lista[j]);
            mal:=mal+1;
         end;
      end;

      log_stadisticas.Add('');
      log_stadisticas.Add('***********************************************');
      log_stadisticas.Add('  Archivos encontrados: '+ IntToStr(bien));
      log_stadisticas.Add('  Archivos no encontrados: '+ IntToStr(mal));
      log_stadisticas.Add('***********************************************');

      log_stadisticas.SaveToFile(g_tmpdir + '\LogEstadisticas.txt');
      log_stadisticas.Free;
   end;
begin
   // =========================== Documentacion dinamica  ==================================
   try
      if dm.ProcessExists('WINWORD.EXE') then  // quitar todos los procesos word antes de abrir el nuestro
         dm.ProcessKill('WINWORD.EXE', true);

      dm.get_utileria('GENWORD',g_ruta+'htagw.exe');

      //DocDinamica := TalkFormDocAutoDinam.Create(self);
      fecha:=FormatDateTime('yyyy/mm/dd',now);

      // si no se tiene el arreglo, llenarlo:
      if Length (guarda) = 0 then begin
         for i := 0 to slPriClasesProcesar.Count - 1 do begin
            sClaseProcesar := slPriClasesProcesar[ i ];
            sCadenaScratch := ' AND HCBIB NOT LIKE ' + g_q + '%SCRATCH%' + g_q;

            if bPriClasesScratchProcesar then
               if bPriEsClaseScratchProcesar( sClaseProcesar ) then
                  sCadenaScratch := '';

            consulta:='SELECT HCCLASE, HCBIB, HCPROG' +
               ' FROM TSRELA' +
               ' WHERE' +
               '   HCCLASE = ' + g_q + sClaseProcesar + g_q +
               sCadenaScratch +
               '   AND SISTEMA = ' + g_q + sParSistema + g_q +
               ' GROUP BY HCCLASE, HCBIB, HCPROG' +
               ' ORDER BY HCBIB, HCCLASE';                               //agregar que sea de todas las clases  ALK

            qTSRELA := TAdoQuery.Create( Self );
            qTSRELA.Connection := dm.ADOConnection1;

            if dm.sqlselect( qTSRELA, consulta ) then begin
               SetLength(guarda, qTSRELA.RecordCount);
               cont:=0;

               while not qTSRELA.Eof do begin
                  //guarda todos los datos para despues mandarlos procesar todos juntos por producto
                  guarda[cont].cla:=qTSRELA.FieldByName( 'HCCLASE' ).AsString;
                  guarda[cont].bib:=qTSRELA.FieldByName( 'HCBIB' ).AsString;
                  guarda[cont].comp:=qTSRELA.FieldByName( 'HCPROG' ).AsString;

                  qTSRELA.Next;
                  cont:=cont+1;
               end;
            end;
         end;
      end;
   except
      ShowMessage('ERROR obteniendo clases a procesar');
   end;

   // ____________general_________________
   {try
      stbLista.Panels[ 1 ].Text := 'Generando Documentacion general, espere...';
      Refresh;

      // el arreglo recorre la estructura y manda crear el documento uno por uno
      DocDinamica.get_datos(sClase,sBib,sParSistema,sProg, sPriRutaSalida,'1',fecha);

      if dm.ProcessExists('WINWORD.EXE') then
         dm.ProcessKill('WINWORD.EXE', true);

      DocDinamica.crear;
    finally
       stbLista.Panels[ 1 ].Text := 'Finalizado.';
       Refresh;
    end;  }

    //________________especifica_______________
   { try
      salva:=Tstringlist.Create;

      reprocesa:=TStringList.Create;

      if FileExists(g_tmpdir + '\LogEstadisticas.txt') then
         DeleteFile(g_tmpdir + '\LogEstadisticas.txt');

      stbLista.Panels[ 1 ].Text := 'Generando bat, espere...';
      Refresh;

      salva.Add(':inicia');
      salva.Add('del "'+ g_tmpdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt"');

      for k:=0 to Length( guarda )-1 do begin
         sClase:=guarda[k].cla;
         sBib:=guarda[k].bib;
         sProg:=guarda[k].comp;

         salva.Add(g_ruta+'htagw.exe '+g_odbc+' '+g_user_entrada+' '+
                  sClase+' '+sBib+' '+sParsistema+' '+sProg+' "'+sPriRutaSalida+'" 2 '+
                  fecha+' "'+g_ruta+'"');

         bGlbQuitaCaracteres(sProg);

         reprocesa.Add(ExtractFilePath(sPriRutaSalida) + sParSistema + '\Componentes\'+sClase+'\' +
                      'DT_' + sParSistema +'_'+ sClase +'_'+sBib+'_'+sProg+'.doc');

         // ---- para tener todos los word en la carpeta temporal -----
         //doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+guarda[0].cla+'.doc';
         doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+sClase+'_'+sProg+'.doc';
         dm.get_utileria( 'WORD_'+guarda[0].cla, doc_plantilla );
      end;
   finally
      salva.Add('if exist "'+ g_tmpdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt" goto inicia');

      salva.SaveToFile(g_tmpdir+'\documentos.bat');
      salva.Free;

      //shellexecute(0,'open',pchar(g_tmpdir+'\documentos.bat'),'','',SW_SHOW);
      dm.ejecuta_espera(g_tmpdir+'\documentos.bat',SW_SHOW);
      estadisticas(reprocesa);
      reprocesa.Free;

      stbLista.Panels[ 1 ].Text := 'Finalizado';
      Refresh;
   end;
   // --------------------------------------------------------------------------------------
end;}

function TfmDocSistema.bPriEsClaseScratchProcesar( sParClase: String ): Boolean;
var
   i: Integer;
begin
   Result := False;
   for i := 0 to slPriClasesScratchProcesar.Count - 1 do
      if slPriClasesScratchProcesar[ i ] = sParClase then begin
         Result := True;
         Break;
      end;
end;


procedure TfmDocSistema.mnuGenerarSalidasClick( Sender: TObject );
var
   i: Integer;
   sSistema: String;
   sDirSistema: String;
   sCadenaScratch: String;
   sClase, sBib, sProg: String;

   sClaseProcesar: String;
   sFechaHora: String;
   consulta:string;
   cont:integer;
begin
   inherited;

   if ( Length( aPriClaseForma ) = 0 ) or ( slPriClasesProcesar.Count = 0 ) then begin
      Application.MessageBox( PChar(
         'Configuración de Clases-Productos incorrecta.' + chr( 13 ) + chr( 13 ) +
         'Cargue un archivo de configuración correcto en el' + chr( 13 ) +
         '"Menú Documentación" opción "Cargar Configuración"' ),
         PChar( 'Aviso' ), MB_OK );
      Exit;
   end;

   // Comprobar que no existan exceles activos, si los hay avisar que debe cerrar
   if dm.ProcessExists('EXCEL.EXE') then begin
      case Application.MessageBox(pchar( dm.xlng('La Documentacion Automatica debe cerrar' + chr( 13 ) +
                               'todo proceso de Excel que este activo'+ chr( 13 ) + chr( 13 ) +
                               'Se recomienda guardar los archivos que'+ chr( 13 ) +
                               'tenga en uso.'+ chr( 13 ) + chr( 13 ) +
                               '¿Desea que el Sysmining los cierre?'+ chr( 13 ) +
                               'NO SE GUARDARAN LOS CAMBIOS')),pchar( dm.xlng('Documentacion Automatica')),
                               Mb_OkCancel+MB_IconQuestion) of
         ID_OK:
         begin
            // --- Matar los procesos Excel ---
            dm.ProcessKill('EXCEL.EXE', true);
         end;
         ID_CANCEL:      //  --  Si cancela, no hace nada  --
         begin
            Exit;
         end;
      end;
   end;

   sSistema := tabDatos.FieldByName( 'CSISTEMA' ).AsString;

   //sDirSistema := 'C:\' + sSistema + '\';
   sDirSistema := sPriRutaSalida + sSistema + '\';

   if ForceDirectories( sDirSistema ) = False then begin
      Application.MessageBox( PChar( 'No se puede crear el directorio ' + sDirSistema ),
         PChar( 'Aviso' ), MB_OK );
      Exit;
   end;

   sFechaHora := FormatDateTime( 'YYYYMMDDHHNN', now );
   sPriArchLog := sLOG_DOC_CLA_PRO + sSistema + '.' + sFechaHora + '.log';
   sPriArchLogErr := sLOG_DOC_CLA_PRO_ERR + sSistema + '.' + sFechaHora + '.log';

   GlbRegistraLog( sPriArchLog, '[ INICIO PROCESO ]' );
   //registra en el log contenido del archivo .ini como se cargo
   GlbRegistraLog( sPriArchLog, slPriArchivoIni.Text );

   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      qTSRELA := TAdoQuery.Create( Self );
      try
         qTSRELA.Connection := dm.ADOConnection1;

         for i := 0 to slPriClasesProcesar.Count - 1 do begin
            sClaseProcesar := slPriClasesProcesar[ i ];
            //sCadenaScratch := ' AND HCBIB <> ' + g_q + 'SCRATCH' + g_q;
            sCadenaScratch := ' AND HCBIB NOT LIKE ' + g_q + '%SCRATCH%' + g_q;

            if bPriClasesScratchProcesar then
               if bPriEsClaseScratchProcesar( sClaseProcesar ) then
                  sCadenaScratch := '';

            consulta:='SELECT HCCLASE, HCBIB, HCPROG' +
               ' FROM TSRELA' +
               ' WHERE' +
               '   HCCLASE = ' + g_q + sClaseProcesar + g_q +
               sCadenaScratch +
               '   AND SISTEMA = ' + g_q + sSistema + g_q +
//               ' AND HCPROG = ' + g_q + 'P075' + g_q +     //prueba alk QUITAR!!!!!
               //' and hcbib in (select cbib from tsbib)' +
               ' GROUP BY HCCLASE, HCBIB, HCPROG' +
               ' ORDER BY HCBIB, HCCLASE';                               //agregar que sea de todas las clases  ALK
               //' ORDER BY HCPROG';

            if dm.sqlselect( qTSRELA, consulta ) then begin
               SetLength(guarda, qTSRELA.RecordCount);
               cont:=0;

               GlbRegistraLog( sPriArchLog, '[ Inicio ' + sClaseProcesar + ' ]' );
               try
                  while not qTSRELA.Eof do begin
                     if bPriTerminaProceso then
                        Exit;

                     sClase := qTSRELA.FieldByName( 'HCCLASE' ).AsString;
                     sBib := qTSRELA.FieldByName( 'HCBIB' ).AsString;
                     sProg := qTSRELA.FieldByName( 'HCPROG' ).AsString;

                    // GlbRegistraLog(sPriArchLog, 'Inicio [ ' + sClase + ' ' + sBib + ' ' + sProg + ' ]' );

                     stbLista.Panels[ 1 ].Text :='Procesando: ' + sClase + ' ' + sBib + ' ' + sProg + ' ';
                     Refresh;
                     try
                       //guarda todos los datos para despues mandarlos procesar todos juntos por producto
                         guarda[cont].cla:=sClase;
                         guarda[cont].bib:=sBib;
                         guarda[cont].comp:=sProg;
                     finally
                        //GlbRegistraLog(sPriArchLog, 'Fin [ ' + sClase + ' ' + sBib + ' ' + sProg + ' ]' );

                        stbLista.Panels[ 1 ].Text := '';
                        Refresh;
                     end;
                     qTSRELA.Next;
                     cont:=cont+1;
                  end;
               finally
                  //muestradatos(guarda,cont);
                  //lv.Visible:=true;
                  PriGenerarSalidas( sSistema, guarda , sDirSistema );
                  GlbRegistraLog( sPriArchLog, '[ Fin ' + sClaseProcesar + ' ]' );
                  {if ((not es_el_primero) and (not bPriTerminaProceso)) then
                     showmessage('Generar Productos de la Documentación');    //RGM}
                     
                  es_el_primero:=true;

               end;
            end;
         end;

      finally
         qTSRELA.Free;
      end;

   finally
      sGlbLENG_VISUSTIN_DGR_CBL := ''; //limpia la variable

      GlbRegistraLog( sPriArchLog, '[ FIN PROCESO ]' );

      if bPriTerminaProceso then begin
         GlbRegistraLog( sPriArchLog,'Proceso terminado a petición del usuario' );
         Application.MessageBox( 'Proceso terminado a petición del usuario','Aviso', MB_OK );
      end;

      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;


procedure TfmDocSistema.FormCreate( Sender: TObject );
begin
   inherited;

   slPriClasesScratchProcesar := TStringList.Create;
   slPriClasesProcesar := TStringList.Create;
   slPriArchivoIni := TStringList.Create;
end;

procedure TfmDocSistema.FormDestroy( Sender: TObject );
begin
   slPriClasesScratchProcesar.Free;
   slPriClasesProcesar.Free;
   slPriArchivoIni.Free;

   inherited;
end;

//procedure TfmDocSistema.PriGenerarSalidas( sParSistema: String; sParClase, sParBib, sParProg: String; sParDirectorio: String );
procedure TfmDocSistema.PriGenerarSalidas( sParSistema: String; estructura : array of datos ; sParDirectorio: String );       //alk
var
   i, j, k: Integer;
   //listas
   fmListaCompo: TfmListaCompo;
   fmListaDependencias: TfmListaDependencias;
   fmMatrizCrud: TfmMatrizCrud;
   fmMatrizAF: TfmMatrizAF;
   fmMatrizArchLog: TfmMatrizArchLog;
   fmRefCruz: TfmRefCruz;
   //diagramas
   fmBloques: TfmBloques;
   fmAnalisisImpacto: TfmAnalisisImpacto;
   fmProcesos: TfmProcesos;

   farbol : Tfarbol;  //alk para diagramas
   fdiagjcl : Tftsdiagjcl;  //diagrama flujo (NO visustin)

   fCodMuerto : Tftsmuerto;   // codigo muerto   ALK

   sTitulo, sArchSalida: String;
   sDirClase: String;

   slFuente: TStringList;
   sArchivoFte: String;
   sNombreArchWMF, sNombreArchPDF, sNombreArchXLS, sNombreArchTXT: String;
   sNombreArchCSV: String;      //alk para Access violation at address

   iLongitudArreglo: Integer;
   sClaseArreglo: String;
   //FormaArreglo: TForma;
   FormaArreglo: array of TForma;
   forma : TForma;

   bCreaDgrFlujo: Boolean;
   bCreaDgrJerarquico: Boolean;
   lObtuvoFte: Boolean;
   lVecesBuscado: Integer;

   sParClase, sParBib, sParProg : string;
   pendientes,contador:integer;
   errs_datos,errn_datos : boolean;
   imprime, l_control:string;

   salir, cuenta : integer;

   direccion, fteaux : string;   //alk para diagramas

   procedure MuestraPanelProcesado( sParClase, sParBib, sParProg: String; sDescForma: String );
   begin
      if sDescForma <> '' then
         stbLista.Panels[ 1 ].Text :=
            'Procesando: ' + sParClase + ' ' + sParBib + ' ' + sParProg + ' ' + sDescForma
      else
         stbLista.Panels[ 1 ].Text := '';

      Refresh;
   end;

   procedure RegistrarLogForma( sParTitulo, sParArchSalida: String; sParTexto: String );
   begin
      if Trim( sParTexto ) = '' then
         GlbRegistraLog( sPriArchLog, sParTitulo + '; archivo salida: ' + sParArchSalida )
      else
         GlbRegistraLog( sPriArchLog, sParTitulo + '; ' + sParTexto )
   end;

   procedure RegistrarErrorForma( sParTitulo, sParArchSalida, sParError: String );
   begin
      GlbRegistraLog( sPriArchLogErr,
         'Error al procesar: ' + sParTitulo + '; archivo salida: ' + sParArchSalida );

      GlbRegistraLog( sPriArchLogErr, sParError );
   end;
begin
   indica_doc_auto(1);   //para indicar que viene de la documentacion auto en uDiagramaRutinas
   alkDocumentacion:=1;  // para indicar que viene de la documentacion en uConstantes

   sDirClase := sParDirectorio + estructura[0].cla + '\';
   if ForceDirectories( sDirClase ) = False then begin
      Application.MessageBox( PChar( 'No se puede crear el directorio ' + sDirClase ),
         pchar( 'Aviso' ), MB_OK );
      Exit;
   end;
   iLongitudArreglo := Length( aPriClaseForma );
   setlength(FormaArreglo,iLongitudArreglo);
   for i := 0 to iLongitudArreglo - 1 do
      if aPriClaseForma[ i ].sClase = estructura[0].cla then
         FormaArreglo[ i ] := aPriClaseForma[ i ].fClassName;                 //para obtener los productos por clase

   for j:= 0 to Length( FormaArreglo )-1 do begin               //for que recorre el arreglo de productos por clase
      // .......... procedimiento que detiene la corrida si lo quiere el usuario .............
      if bPriTerminaProceso then
         Exit;
      // .....................................................................................

      forma := FormaArreglo[j];      // primera forma de la clase seleccionada
      salir:=1;
      case forma of
         fNull:
            continue;

         fDgrBloques: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  fmBloques := TfmBloques.Create( Self );
                  fmBloques.FormStyle := fsNormal;
                  fmBloques.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Diagrama de Bloques', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Diagrama de bloques en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
               if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then begin
                  GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se puede generar porque: '+ alkSCRATCH);
                  continue;
               end;

               sTitulo := sDiagBloques + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               sArchSalida := sTitulo;
               bGlbQuitaCaracteres( sArchSalida );
               sNombreArchWMF := sDirClase + sArchSalida + '.wmf';
               sNombreArchPDF := sDirClase + sArchSalida + '.pdf';

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               // ------- si no existe ninguno de los dos formatos -------
               if ((not FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_BLOQUES );
                  g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE BLOQUES';
                  try
                     fmBloques.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        GlbExportarDgr_A_WMF( fmBloques.atDiagrama, sNombreArchWMF );
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                     end;

                  finally
                     g_producto := '';
                  end;
               end;

               // ------- si no existe WMF de los dos formatos -------
               if ((FileExists( sNombreArchPDF )) and (not FileExists( sNombreArchWMF ))) then begin  // si no existe el WMF, pero si el PDF
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_BLOQUES );
                  g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE BLOQUES';
                  try
                     fmBloques.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        GlbExportarDgr_A_WMF( fmBloques.atDiagrama, sNombreArchWMF );
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                     end;

                  finally
                     g_producto := '';
                  end;
               end;


               // ------- si no existe PDF de los dos formatos -------
               if ((FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin  // si no existe el PDF, pero si el WMF
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_BLOQUES );
                  g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE BLOQUES';
                  try
                     fmBloques.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + ' No se pudo generar el PDF, intentar con la impresora del sistema');
                     end;

                  finally
                     g_producto := '';
                  end;
               end;



            end;  //fin for de componentes
            fmBloques.Free;     //libero la forma despues de procesar todos los componentes
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;     //  FIN de fDgrBloques


         fDgrAImpacto: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  fmAnalisisImpacto := TfmAnalisisImpacto.Create( Self );
                  fmAnalisisImpacto.FormStyle := fsNormal;
                  fmAnalisisImpacto.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Analisis de impacto', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Analisis de Impacto en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               sTitulo := sDiagAnImpacto + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               sArchSalida := sTitulo;
               bGlbQuitaCaracteres( sArchSalida );
               sNombreArchWMF := sDirClase + sArchSalida + '.wmf';
               sNombreArchPDF := sDirClase + sArchSalida + '.pdf';
               //sNombreArchXLS := sDirClase + sArchSalida + '.xls';
               sNombreArchXLS := sDirClase + sArchSalida + '.csv';
               sNombreArchTXT := sDirClase + sArchSalida + '.txt';
               g_producto := 'MENÚ CONTEXTUAL-ANÁLISIS DE IMPACTO';
               l_control := stringreplace( caption, sDIGRA_AIMPACTO + ' ', '', [ rfreplaceall ] );
               g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               // ------- si no existe ninguno de los dos formatos -------
               if ((not FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_AIMPACTO );
                  try
                     fmAnalisisImpacto.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        GlbExportarDgr_A_WMF( fmAnalisisImpacto.atDiagrama, sNombreArchWMF );
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                     end;
                  finally
                     g_producto := '';
                  end;
               end;

               // ------- si no existe WMF de los dos formatos -------
               if ((FileExists( sNombreArchPDF )) and (not FileExists( sNombreArchWMF ))) then begin  // si no existe el WMF, pero si el PDF
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_AIMPACTO );
                  try
                     fmAnalisisImpacto.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        GlbExportarDgr_A_WMF( fmAnalisisImpacto.atDiagrama, sNombreArchWMF );
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                     end;
                  finally
                     g_producto := '';
                  end;
               end;

               // ------- si no existe PDF de los dos formatos -------
               if ((FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin  // si no existe el PDF, pero si el WMF
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_AIMPACTO );
                  try
                     fmAnalisisImpacto.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el PDF, intentar con la impresora del sistema');
                     end;
                  finally
                     g_producto := '';
                  end;
               end;


               // ------- si no existe el XLS -------
               if not FileExists( sNombreArchXLS ) then begin
                  try
                     gral.sPubArchivoXLS := sNombreArchXLS;
                     try
                        fmAnalisisImpacto.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                        gral.exporta( nil );       //cambio de funcion ALK 080915
                     except
                        try
                           gral.exporta( nil );
                        except
                           on E: exception do begin
                              RegistrarErrorForma(sTitulo, sArchSalida, 'Error al generar xls: ' + E.Message );
                              //--- Verifica que no exista el proceso de EXCEL activo ---
                              if dm.ProcessExists('EXCEL.EXE') then
                                 dm.ProcessKill('EXCEL.EXE', true);
                           end;
                        end;
                     end;
                  finally
                     gral.sPubArchivoXLS := '';
                  end;
               end;

            end;    //   fin del for
            fmAnalisisImpacto.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;     //  FIN de fDgrAImpacto


         fDgrProcesos: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  fmProcesos := TfmProcesos.Create( Self );
                  fmProcesos.FormStyle := fsNormal;
                  fmProcesos.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Diagrama de Procesos', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Diagrama de procesos en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
               if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then begin
                                    GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se puede generar porque: '+ alkSCRATCH);
                  continue;
               end;

               sTitulo := sDiagProcesos + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;

               sArchSalida := sTitulo;
               bGlbQuitaCaracteres( sArchSalida );
               sNombreArchWMF := sDirClase + sArchSalida + '.wmf';
               sNombreArchPDF := sDirClase + sArchSalida + '.pdf';
               //sNombreArchXLS := sDirClase + sArchSalida + '.xls';
               sNombreArchXLS := sDirClase + sArchSalida + '.csv';
               g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE PROCESO';
               l_control := stringreplace( caption, sDiagProcesos + ' ', '', [ rfreplaceall ] );
               g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               // ------- si no existe ninguno de los dos formatos -------
               if ((not FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_PROCESOS );

                  try
                     fmProcesos.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        GlbExportarDgr_A_WMF( fmProcesos.atDiagrama, sNombreArchWMF );
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                     except
                        on E: exception do begin
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                           continue;
                        end;
                     end;
                  finally
                     g_producto := '';
                  end;
               end;

               // ------- si no existe WMF de los dos formatos -------
               if ((FileExists( sNombreArchPDF )) and (not FileExists( sNombreArchWMF ))) then begin  // si no existe el WMF, pero si el PDF
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_PROCESOS );

                  try
                     fmProcesos.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        GlbExportarDgr_A_WMF( fmProcesos.atDiagrama, sNombreArchWMF );
                     except
                        on E: exception do begin
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                           continue;
                        end;
                     end;
                  finally
                     g_producto := '';
                  end;
               end;



               // ------- si no existe PDF de los dos formatos -------
               if ((FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin  // si no existe el PDF, pero si el WMF
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_PROCESOS );

                  try
                     fmProcesos.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                     except
                        on E: exception do begin
                           GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se generó el PDF, intentar con la impresora del sistema');
                           continue;
                        end;
                     end;
                  finally
                     g_producto := '';
                  end;
               end;

               // ------- si no existe formato XLS -------
               if not FileExists( sNombreArchXLS ) then begin
                  try
                     g_control :=sParClase + sParBib + sParProg;
                     bGlbQuitaCaracteres(g_control);
                     gral.sPubArchivoXLS := sNombreArchXLS;
                     fmProcesos.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema, sTitulo );
                     try
                        gral.exportaProc( nil );
                     except
                        on E: exception do begin
                           RegistrarErrorForma(sTitulo, sArchSalida, 'Error al generar xls: ' + E.Message );
                           continue;
                        end;
                     end;
                  finally
                     gral.sPubArchivoXLS := '';
                  end;
               end;


            end;    //fin del for
            fmProcesos.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;     //   FIN de fDgrProcesos


         fLstRefCruzadas: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  fmRefCruz := TfmRefCruz.Create( Self );
                  fmRefCruz.Top := 0;
                  fmRefCruz.FormStyle := fsNormal;
                  fmRefCruz.Visible := False;
                  fmRefCruz.titulo := sTitulo;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Referencias Cruzadas', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Referencias Cruzadas en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
                  sParClase:=estructura[k].cla;
                  sParBib:=estructura[k].bib;
                  sParProg:=estructura[k].comp;

                  //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
                  if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then begin
                     GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se puede generar porque: '+ alkSCRATCH);
                     continue;
                  end;

                  sTitulo := sLisRefCruzadas + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
                  sArchSalida := sTitulo;
                  bGlbQuitaCaracteres( sArchSalida );
                  sNombreArchXLS := sDirClase + sArchSalida + '.xls';
                  sNombreArchTXT := sDirClase + sArchSalida + '.txt';

                  if dm.ProcessExists('EXCEL.EXE') then
                     dm.ProcessKill('EXCEL.EXE', true);

                  //if not FileExists( sNombreArchXLS ) then begin
                  if not FileExists( sDirClase + sArchSalida + '.csv' ) then begin
                     RegistrarLogForma( sTitulo, sArchSalida, '' );
                     MuestraPanelProcesado( sParClase, sParBib, sParProg, sLISTA_REF_CRUZADAS );

                     try
                        g_producto := 'MENÚ CONTEXTUAL-REFERENCIAS CRUZADAS';

                        //fmRefCruz.arma( sParClase, sParBib, sParProg, sParSistema );
                        try
                           fmRefCruz.arma_doc( sParClase, sParBib, sParProg, sParSistema );
                        except
                           on E: exception do
                              continue;
                        end;

                        if fmRefCruz.tabDatos.Active then begin
                           if fmRefCruz.tabDatos.RecordCount >= 1 then begin
                              //------ ALK para el error  Access violation at address -----------
                             { try
                                 ExportGrid4ToExcel(sNombreArchXLS, fmRefCruz.grdDatos, True, True, True, 'xls' );
                              except
                                 on E: exception do begin }
                                    if FileExists( sNombreArchXLS ) then   //si dejo algun archivo vacio, lo borra. Para evitar problemas en el documento de word
                                       DeleteFile(sNombreArchXLS);

                                    //RegistrarErrorForma('Convertir el xls a csv: ' + sTitulo, sArchSalida, E.Message );
                                    MuestraPanelProcesado( sParClase, sParBib, sParProg, 'Archivo CSV' );

                                    sNombreArchCSV := stringreplace( sNombreArchXLS, '.xls', '.csv', [ rfReplaceAll ]);

                                    if not FileExists( sNombreArchCSV ) then
                                       try            //truena a veces y no registra nada
                                          ExportGrid4ToText(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]) , fmRefCruz.grdDatos, True, True, ',', '"', '"' );
                                       except
                                          on E: exception do begin
                                             RegistrarErrorForma('Fallo al convertir el xls a csv: ' + sTitulo, sNombreArchCSV, E.Message );     //Mandarlo como error
                                             continue;
                                          end;
                                       end;

                                    if not RenameFile(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]),sNombreArchCSV) then  // se puecambiar la extension
                                       if FileExists( sNombreArchCSV ) then  //si no se pudo renombrar y no existe el archivo csv, manda mensaje de error
                                          RegistrarLogForma( sTitulo, sNombreArchCSV, '' )     //registrar que lo hizo si ya existia el archivo
                                    else
                                       RegistrarLogForma( sTitulo, sNombreArchCSV, '' );      //registrar que lo hizo si lo renombro correctamente
                                { end;
                              end   }
                              // -------------------------------------------------------
                           end
                           else
                              RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_SIN_DATOS );
                        end
                        else
                           RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_NOT_TAB );
                     finally
                        g_producto := '';
                        RegistrarLogForma( sTitulo, sArchSalida, imprime );
                     end;
                  end;   //fin del if
               fmRefCruz.CleanupInstance;    // prueba tiempo   ALK
            end;  //fin del for
            fmRefCruz.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;        //FIN de fLstRefCruzadas


         fLstDependencias: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  g_producto := 'MENÚ CONTEXTUAL-LISTA DEPENDENCIAS DE COMPONENTES';
                  fmListaDependencias := TfmListaDependencias.Create( Self );
                  fmListaDependencias.Top := 0;
                  fmListaDependencias.FormStyle := fsNormal;
                  fmListaDependencias.Visible := False;
                  fmListaDependencias.titulo := sTitulo;
                  fmListaDependencias.caption := sTitulo;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Lista de Dependencias', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Lista de dependencias en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
               if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then begin
                  GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se puede generar porque: '+ alkSCRATCH);
                  continue;
               end;

               sTitulo := sLisDependencias + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               sArchSalida := sTitulo;
               bGlbQuitaCaracteres( sArchSalida );
               sNombreArchXLS := sDirClase + sArchSalida + '.xls';
               lista:=TStringList.Create;

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if not FileExists( sNombreArchXLS ) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sLISTA_COMPONENTES );

                  g_producto := 'MENÚ CONTEXTUAL-LISTA DEPENDENCIAS DE COMPONENTES';
                  try
                     lista.Add(sParClase);       //clase
                     lista.Add(sParBib);         //biblioteca
                     lista.Add(sParProg);        //programa/mascara
                     lista.Add(sParSistema);     //sistema
                     fmListaDependencias.llenacombos(lista);

                     fmListaDependencias.arma3( sParClase, sParBib, sParProg, sParSistema );

                     //.......................
                     if not fmListaDependencias.tabDatos.Active then       //prueba alk
                        fmListaDependencias.tabDatos.Active := True;
                     //.......................
                     if fmListaDependencias.tabDatos.Active then begin
                        if fmListaDependencias.tabDatos.RecordCount >= 1 then begin
                           Sleep(1000);             //prueba RGM-ALK
                           //------ ALK para el error  Access violation at address -----------
                           {try
                              ExportGrid4ToExcel(sNombreArchXLS, fmListaDependencias.grdDatos, True, True, True, 'xls' );
                           except
                              on E: exception do begin
                            }
                                 if FileExists( sNombreArchXLS ) then   //si dejo algun archivo vacio, lo borra. Para evitar problemas en el documento de word
                                    DeleteFile(sNombreArchXLS);

                                 //RegistrarErrorForma('Convertir el xls a csv: ' + sTitulo, sArchSalida, E.Message );
                                 MuestraPanelProcesado( sParClase, sParBib, sParProg, 'Archivo CSV' );

                                 sNombreArchCSV := stringreplace( sNombreArchXLS, '.xls', '.csv', [ rfReplaceAll ]);

                                 if not FileExists( sNombreArchCSV ) then
                                    try            //truena a veces y no registra nada
                                       ExportGrid4ToText(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]) , fmListaDependencias.grdDatos, True, True, ',', '"', '"' );
                                    except
                                       on E: exception do
                                          RegistrarErrorForma('Fallo al convertir el xls a csv: ' + sTitulo, sNombreArchCSV, E.Message );     //Mandarlo como error
                                    end;

                                 if not RenameFile(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]),sNombreArchCSV) then  // se puecambiar la extension
                                    if FileExists( sNombreArchCSV ) then  //si no se pudo renombrar y no existe el archivo csv, manda mensaje de error
                                       RegistrarLogForma( sTitulo, sNombreArchCSV, '' )     //registrar que lo hizo si ya existia el archivo
                                 else
                                    RegistrarLogForma( sTitulo, sNombreArchCSV, '' );      //registrar que lo hizo si lo renombro correctamente
                             { end;
                           end  }
                           // -------------------------------------------------------
                        end
                        else begin
                           RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_SIN_DATOS );
                        end;
                     end
                     else
                        RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_NOT_TAB );
                  finally
                     lista.Free;
                     g_producto := '';
                  end;
               end;
               fmListaDependencias.CleanupInstance;    // prueba tiempo   ALK
            end;     //fin del for
            fmListaDependencias.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;      //FIN de fLstDependencias

         fLstComponentes: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  g_producto := 'MENÚ CONTEXTUAL-LISTA DE COMPONENTES';
                  fmListaCompo := TfmListaCompo.Create( Self );
                  fmListaCompo.Top := 0;
                  fmListaCompo.FormStyle := fsNormal;
                  fmListaCompo.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Lista de Componentes', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Lista de Componentes en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
               if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then begin
                  GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + 'No se puede generar porque: '+ alkSCRATCH);
                  continue;
               end;

               sTitulo := sLisComponentes + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               sArchSalida := sTitulo;
               bGlbQuitaCaracteres( sArchSalida );
               sNombreArchXLS := sDirClase + sArchSalida + '.xls';

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if not FileExists( sNombreArchXLS ) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sLISTA_DEPENDENCIAS );

                  g_producto := 'MENÚ CONTEXTUAL-LISTA DE COMPONENTES';
                  try
                     fmListaCompo.PubGeneraLista( sParClase, sParBib, sParProg, sTitulo, sParSistema );

                     if fmListaCompo.tabDatos.Active then begin
                        if fmListaCompo.tabDatos.RecordCount >= 1 then begin
                           Sleep(1000);             //prueba RGM-ALK

                           //------ ALK para el error  Access violation at address -----------
                           {try
                              ExportGrid4ToExcel(sNombreArchXLS, fmListaCompo.grdDatos, True, True, True, 'xls' );
                           except
                              on E: exception do begin
                            }
                                 if FileExists( sNombreArchXLS ) then   //si dejo algun archivo vacio, lo borra. Para evitar problemas en el documento de word
                                    DeleteFile(sNombreArchXLS);

                                 //RegistrarErrorForma('Convertir el xls a csv: ' + sTitulo, sArchSalida, E.Message );
                                 MuestraPanelProcesado( sParClase, sParBib, sParProg, 'Archivo CSV' );

                                 sNombreArchCSV := stringreplace( sNombreArchXLS, '.xls', '.csv', [ rfReplaceAll ]);

                                 if not FileExists( sNombreArchCSV ) then
                                    try            //truena a veces y no registra nada
                                       ExportGrid4ToText(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]) , fmListaCompo.grdDatos, True, True, ',', '"', '"' );
                                    except
                                       on E: exception do
                                          RegistrarErrorForma('Fallo al convertir el xls a csv: ' + sTitulo, sNombreArchCSV, E.Message );     //Mandarlo como error
                                    end;

                                 if not RenameFile(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]),sNombreArchCSV) then  // se puecambiar la extension
                                    if FileExists( sNombreArchCSV ) then  //si no se pudo renombrar y no existe el archivo csv, manda mensaje de error
                                       RegistrarLogForma( sTitulo, sNombreArchCSV, '' )     //registrar que lo hizo si ya existia el archivo
                                 else
                                    RegistrarLogForma( sTitulo, sNombreArchCSV, '' );      //registrar que lo hizo si lo renombro correctamente
                             { end;
                           end  }
                           // -------------------------------------------------------
                        end
                        else begin
                           RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_SIN_DATOS );
                        end;
                     end
                     else
                        RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_NOT_TAB );
                  finally
                     g_producto := '';
                  end;
               end;
               fmListaCompo.CleanupInstance;    // prueba tiempo   ALK
            end;     //fin del for
            fmListaCompo.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;      //FIN de fmListaCompo

         fLstMatrizCrud: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  g_producto := 'MENÚ CONTEXTUAL-MATRIZ CRUD';
                  fmMatrizCrud := TfmMatrizCrud.Create( Self );
                  fmMatrizCrud.Top := 0;
                  fmMatrizCrud.FormStyle := fsNormal;
                  fmMatrizCrud.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Matriz CRUD', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Matriz CRUD en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
               {if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then begin
                  GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + ' El componente es SCRATCH y/o no tiene hijos.');
                  continue;
               end;}

               sTitulo := sLisMatrizCRUD + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               sArchSalida := sTitulo;
               bGlbQuitaCaracteres( sArchSalida );
               sNombreArchXLS := sDirClase + sArchSalida + '.xls';

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if not FileExists( sNombreArchXLS ) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sLISTA_MATRIZ_CRUD );

                  g_producto := 'MENÚ CONTEXTUAL-MATRIZ CRUD';
                  try
                     fmMatrizCrud.tipo := sParClase;//'TAB';
                     fmMatrizCrud.prepara2( sParProg, sParSistema );
                     fmMatrizCrud.arma3( sParProg, SParSistema );


                     if fmMatrizCrud.tabDatos.Active then begin
                        if fmMatrizCrud.tabDatos.RecordCount >= 1 then begin
                           Sleep(1000);             //prueba RGM-ALK

                           //------ ALK para el error  Access violation at address -----------
                           {try
                              ExportGrid4ToExcel(sNombreArchXLS, fmMatrizCrud.grdDatos, True, True, True, 'xls' );
                           except
                              on E: exception do begin
                            }
                                 if FileExists( sNombreArchXLS ) then   //si dejo algun archivo vacio, lo borra. Para evitar problemas en el documento de word
                                    DeleteFile(sNombreArchXLS);

                                 //RegistrarErrorForma('Convertir el xls a csv: ' + sTitulo, sArchSalida, E.Message );
                                 MuestraPanelProcesado( sParClase, sParBib, sParProg, 'Archivo CSV' );

                                 sNombreArchCSV := stringreplace( sNombreArchXLS, '.xls', '.csv', [ rfReplaceAll ]);

                                 if not FileExists( sNombreArchCSV ) then
                                    try            //truena a veces y no registra nada
                                       ExportGrid4ToText(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]) , fmMatrizCrud.grdDatos, True, True, ',', '"', '"' );
                                    except
                                       on E: exception do
                                          RegistrarErrorForma('Fallo al convertir el xls a csv: ' + sTitulo, sNombreArchCSV, E.Message );     //Mandarlo como error
                                    end;

                                 if not RenameFile(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]),sNombreArchCSV) then  // se puecambiar la extension
                                    if FileExists( sNombreArchCSV ) then  //si no se pudo renombrar y no existe el archivo csv, manda mensaje de error
                                       RegistrarLogForma( sTitulo, sNombreArchCSV, '' )     //registrar que lo hizo si ya existia el archivo
                                 else
                                    RegistrarLogForma( sTitulo, sNombreArchCSV, '' );      //registrar que lo hizo si lo renombro correctamente
                             { end;
                           end  }
                           // -------------------------------------------------------
                        end
                        else begin
                           RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_SIN_DATOS );
                        end;
                     end
                     else
                        RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_NOT_TAB );
                  finally
                     g_producto := '';
                  end;
               end;
            end;     //fin del for
            fmMatrizCrud.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;      //FIN de fmMatrizCrud

         fLstMatrizAF: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  g_producto := 'MENÚ CONTEXTUAL-MATRIZ ARCHIVO FÍSICO';
                  fmMatrizAF := TfmMatrizAF.Create( Self );
                  fmMatrizAF.Top := 0;
                  fmMatrizAF.FormStyle := fsNormal;
                  fmMatrizAF.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Matriz de Archivos Fisicos', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Matriz de Arch Fisicos en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
               {if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then
                  continue;    }

              sTitulo := sLisMatrizAF + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
              sArchSalida := sTitulo;
              bGlbQuitaCaracteres( sArchSalida );
              sNombreArchXLS := sDirClase + sArchSalida + '.xls';

              if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if not FileExists( sNombreArchXLS ) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sMATRIZ_ARCHIVOS_FIS );

                  g_producto := 'MENÚ CONTEXTUAL-MATRIZ ARCHIVO FÍSICO';
                  try
                     fmMatrizAF.tipo := 'FIL';
                     fmMatrizAF.prepara( sParProg, sParSistema );
                     fmMatrizAF.arma( sParProg, sParSistema );

                     if fmMatrizAF.tabDatos.Active then begin
                        if fmMatrizAF.tabDatos.RecordCount >= 1 then begin
                           Sleep(1000);             //prueba RGM-ALK

                           //------ ALK para el error  Access violation at address -----------
                           {try
                              ExportGrid4ToExcel(sNombreArchXLS, fmMatrizAF.grdDatos, True, True, True, 'xls' );
                           except
                              on E: exception do begin
                            }
                                 if FileExists( sNombreArchXLS ) then   //si dejo algun archivo vacio, lo borra. Para evitar problemas en el documento de word
                                    DeleteFile(sNombreArchXLS);

                                 //RegistrarErrorForma('Convertir el xls a csv: ' + sTitulo, sArchSalida, E.Message );
                                 MuestraPanelProcesado( sParClase, sParBib, sParProg, 'Archivo CSV' );

                                 sNombreArchCSV := stringreplace( sNombreArchXLS, '.xls', '.csv', [ rfReplaceAll ]);

                                 if not FileExists( sNombreArchCSV ) then
                                    try            //truena a veces y no registra nada
                                       ExportGrid4ToText(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]) , fmMatrizAF.grdDatos, True, True, ',', '"', '"' );
                                    except
                                       on E: exception do
                                          RegistrarErrorForma('Fallo al convertir el xls a csv: ' + sTitulo, sNombreArchCSV, E.Message );     //Mandarlo como error
                                    end;

                                 if not RenameFile(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]),sNombreArchCSV) then  // se puecambiar la extension
                                    if FileExists( sNombreArchCSV ) then  //si no se pudo renombrar y no existe el archivo csv, manda mensaje de error
                                       RegistrarLogForma( sTitulo, sNombreArchCSV, '' )     //registrar que lo hizo si ya existia el archivo
                                 else
                                    RegistrarLogForma( sTitulo, sNombreArchCSV, '' );      //registrar que lo hizo si lo renombro correctamente
                             { end;
                           end  }
                           // -------------------------------------------------------
                        end
                        else begin
                           RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_SIN_DATOS );
                        end;
                     end
                     else
                        RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_NOT_TAB );
                  finally
                     g_producto := '';
                  end;
               end;
            end;     //fin del for
            fmMatrizAF.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;      //FIN de fmMatrizAF

         fLstMatrizArchLog: try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  g_producto := 'MENÚ CONTEXTUAL-MATRIZ ARCHIVO FÍSICO';
                  fmMatrizArchLog := TfmMatrizArchLog.Create( Self );
                  fmMatrizArchLog.Top := 0;
                  fmMatrizArchLog.FormStyle := fsNormal;
                  fmMatrizArchLog.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Matriz de Archivos Lógicos', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Matriz de Arch Logicos en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               //  -----  alk para comprobar que tenga fuente, si no no genera el producto ----
               {if not dm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase) then begin
                  GlbRegistraLog( sPriArchLogErr,
                               'AVISO: ' + sTitulo + ' El componente es SCRATCH y/o no tiene hijos.');
                  continue;
               end;                }

              sTitulo := sLisMatrizAL + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
              sArchSalida := sTitulo;
              bGlbQuitaCaracteres( sArchSalida );
              sNombreArchXLS := sDirClase + sArchSalida + '.xls';

              if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if not FileExists( sNombreArchXLS ) then begin
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sMATRIZ_ARCHIVO_LOG );

                  g_producto := 'MENÚ CONTEXTUAL-MATRIZ ARCHIVO FÍSICO';
                  try
                     fmMatrizArchLog.PubGeneraLista( sParClase, sParBib, sParProg, sParSistema, sTitulo );

                     if fmMatrizArchLog.tabDatos.Active then begin
                        if fmMatrizArchLog.tabDatos.RecordCount >= 1 then begin
                           Sleep(1000);             //prueba RGM-ALK

                           //------ ALK para el error  Access violation at address -----------
                           {try
                              ExportGrid4ToExcel(sNombreArchXLS, fmMatrizArchLog.grdDatos, True, True, True, 'xls' );
                           except
                              on E: exception do begin
                            }
                                 if FileExists( sNombreArchXLS ) then   //si dejo algun archivo vacio, lo borra. Para evitar problemas en el documento de word
                                    DeleteFile(sNombreArchXLS);

                                 //RegistrarErrorForma('Convertir el xls a csv: ' + sTitulo, sArchSalida, E.Message );
                                 MuestraPanelProcesado( sParClase, sParBib, sParProg, 'Archivo CSV' );

                                 sNombreArchCSV := stringreplace( sNombreArchXLS, '.xls', '.csv', [ rfReplaceAll ]);

                                 if not FileExists( sNombreArchCSV ) then
                                    try            //truena a veces y no registra nada
                                       ExportGrid4ToText(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]) , fmMatrizArchLog.grdDatos, True, True, ',', '"', '"' );
                                    except
                                       on E: exception do
                                          RegistrarErrorForma('Fallo al convertir el xls a csv: ' + sTitulo, sNombreArchCSV, E.Message );     //Mandarlo como error
                                    end;

                                 if not RenameFile(stringreplace( sNombreArchXLS, '.xls', '.txt', [ rfReplaceAll ]),sNombreArchCSV) then  // se puecambiar la extension
                                    if FileExists( sNombreArchCSV ) then  //si no se pudo renombrar y no existe el archivo csv, manda mensaje de error
                                       RegistrarLogForma( sTitulo, sNombreArchCSV, '' )     //registrar que lo hizo si ya existia el archivo
                                 else
                                    RegistrarLogForma( sTitulo, sNombreArchCSV, '' );      //registrar que lo hizo si lo renombro correctamente
                             { end;
                           end  }
                           // -------------------------------------------------------
                        end
                        else begin
                           RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_SIN_DATOS );
                        end;
                     end
                     else
                        RegistrarLogForma( sTitulo, sArchSalida, sLEYENDA_NOT_TAB );
                  finally
                     g_producto := '';
                     fmMatrizArchLog.tabDatos.ReadOnly := False;
                  end;
               end;
            end;     //fin del for
            fmMatrizArchLog.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;      //FIN de fmMatrizArchLog


         fFuente: try
            slFuente := Tstringlist.Create;
            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

              sTitulo := sFuente + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
              if sParClase = 'JAV' then
                 sTitulo := sFuente + ' ' + sParProg;

              sArchSalida := sTitulo;
              bGlbQuitaCaracteres( sArchSalida );
              sNombreArchTXT := sDirClase + sArchSalida + '.txt';

              if not FileExists( sNombreArchTXT ) then begin
                 RegistrarLogForma( sTitulo, sArchSalida, '' );
                 MuestraPanelProcesado( sParClase, sParBib, sParProg, sPROGRAMA_FUENTE );

                 try
                    lVecesBuscado := 0;
                    lObtuvoFte := FALSE;
                    while lObtuvoFte = FALSE do begin
                       dm.trae_fuente( sParSistema, sParProg, sParBib, sParClase, slFuente );

                       if slFuente.Count > 0 then begin
                          slFuente.SaveToFile( sNombreArchTXT );
                          lObtuvoFte := TRUE;
                       end
                       else begin
                          lVecesBuscado := lVecesBuscado + 1;
                          if lVecesBuscado > 5 then begin
                             GlbRegistraLog( sPriArchLogErr,'AVISO no se obtuvo el fte: ' + sTitulo +' '+ alkleyenda +'; archivo salida: ' + sArchSalida );
                             lObtuvoFte := TRUE;
                          end;
                       end;
                    end;
                 finally
                    slFuente.Clear;
                 end;
              end;   //fin del if
            end;     //fin del for
            slFuente.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;      //FIN de slFuente


         // ************* INICIA DIAGRAMAS DE FLUJO Y JERARQUICOS USANDO VISUSTIN Y/O DIAGRAMADORES *************

         fDgrFlujoCPY, fDgrFlujoC, fDgrFlujoShell, fDgrFlujoJava,
         fDgrFlujoJCLvis: try
            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if sParClase = 'CPY' then
                  sTitulo := sDIGRA_FLUJO_CPY + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if ( sParClase = 'TDC' ) or ( sParClase = 'CUX' ) or
                  ( sParClase = 'PUX' ) or ( sParClase = 'HUX' ) or ( sParClase = 'CCH' )then
                  sTitulo := sDIGRA_FLUJO_C + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if ( sParClase = 'USH' ) or ( sParClase = 'SUX' ) then
                  sTitulo := sDIGRA_FLUJO_SHELL + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'JAV' then
                  sTitulo := sDIGRA_FLUJO_JAVA + ' ' + sParProg;
               if ( sParClase = 'JCL' ) then
                  sTitulo := sDIGRA_COM_JCL + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;

               if sTitulo <> '' then begin
                  //sArchSalida := sTitulo;
                  if ( sParClase = 'JCL' ) then begin
                     sArchSalida := sDiagFlujoVis + ' '+sParClase+' '+sParBib+' '+sParProg;
                  end
                  else begin
                     sArchSalida := sDiagFlujo + ' '+sParClase+' '+sParBib+' '+sParProg;
                  end;

                  bGlbQuitaCaracteres( sArchSalida );
                  sNombreArchPDF := sDirClase + sArchSalida + '.pdf';

                  if not FileExists( sNombreArchPDF ) then begin
                     sArchivoFte := sFuente + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
                     if sParClase = 'JAV' then
                        sArchivoFte := sFuente + ' ' + sParProg;
                     bGlbQuitaCaracteres( sArchivoFte );

                     RegistrarLogForma( sTitulo, sArchSalida, '' );
                     MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_FLUJO );

                     if FileExists( sDirClase + sArchivoFte + '.txt' ) then {//si existe el fte} begin
                        bCreaDgrFlujo := GLbCreaDiagramaFlujo(
                           sParClase, sParBib, sParProg,
                           sDirClase + sArchivoFte + '.txt',
                           sDirClase,
                           sDirClase + sArchSalida + '.pdf' );

                        if not bCreaDgrFlujo then
                           GlbRegistraLog( sPriArchLogErr,'No se pudo crear: ' + sTitulo +
                              '; archivo fte: ' + sArchivoFte + '; archivo salida: ' + sArchSalida );
                     end
                     else
                        //continue;  // si no existe el fuente que siga    ALK
                        GlbRegistraLog( sPriArchLogErr,
                           'AVISO: ' + sTitulo +'; NO EXISTE EL FUENTE: ' + sArchivoFte );
                  end;
               end;

            end;   //fin del for

            //borrar los archivos bulk .log       ALK
            LimpiaBulk(sDirClase);

         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;    //fin de diagramas visustin

         fDgrFlujoWFL, fDgrFlujoALG, fDgrFlujoTMC, fDgrFlujoTMP,
         fDgrFlujoCBL,fDgrFlujoOBY, fDgrFlujoDCL, fDgrFlujoBSC, fDgrFlujoOSQ: try
            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if sParClase = 'CBL' then
                  sTitulo := sDIGRA_FLUJO_CBL + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;   //alk nuevo diagramador
               if sParClase = 'OBY' then
                  sTitulo := sDIGRA_FLUJO_OBY + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;   //alk nueva clase
               if sParClase = 'ALG' then
                  sTitulo := sDIGRA_FLUJO_ALG + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'WFL' then
                  sTitulo := sDIGRA_FLUJO_WFL + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'TMC' then
                  sTitulo := sDIGRA_FLUJO_TMC + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'TMP' then
                  sTitulo := sDIGRA_FLUJO_TMP + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'OSQ' then
                  sTitulo := sDIGRA_FLUJO_OSQ + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;

               if sTitulo <> '' then begin
                  sArchSalida := sDiagFlujo + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;;
                  bGlbQuitaCaracteres( sArchSalida );
                  sNombreArchPDF := sDirClase + sArchSalida + '.pdf';

                  if not FileExists( sNombreArchPDF ) then begin
                     sArchivoFte := sFuente + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
                     bGlbQuitaCaracteres( sArchivoFte );
                     direccion := sDirClase + sArchivoFte +'.txt';
                     fteaux:= sDirClase + '|' + sArchivoFte +'.txt';

                     RegistrarLogForma( sTitulo, sArchSalida, '' );
                     MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_FLUJO );

                     //if FileExists( sDirClase + sArchivoFte + '.txt' ) then  begin
                     if FileExists( direccion ) then begin  {si existe el fte}
                         farbol.GenerarDiagramaNvo( sParProg, fteaux, sParClase, 'FLUJO' , 2 , sParSistema, sParBib);  //tipo 2 - doc auto
                     end
                     else
                        //continue;
                        GlbRegistraLog( sPriArchLogErr,'AVISO: ' + sTitulo +'; NO EXISTE EL FUENTE: ' + sArchivoFte );
                  end;
               end;
            end;   //fin del for
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;    //fin de diagramas flujo diagramador

         fDgrJerarquicoWFL, fDgrJerarquicoALG, fDgrJerarquicoBSC,
         fDgrJerarquicoCBL,fDgrJerarquicoOSQ: try
            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if sParClase = 'ALG' then
                  sTitulo := sDIGRA_JERARQUICO_ALG + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'WFL' then
                  sTitulo := sDIGRA_JERARQUICO_WFL + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'CBL' then
                  sTitulo := sDIGRA_JERARQUICO_CBL + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'OSQ' then
                  sTitulo := sDIGRA_JERARQUICO_OSQ + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               if sParClase = 'BSC' then
                  sTitulo := sDIGRA_JERARQUICO_BSC + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;

               if sTitulo <> '' then begin
                  sArchSalida :=  sDiagJerarquico + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
                  bGlbQuitaCaracteres( sArchSalida );
                  sNombreArchPDF := sDirClase + sArchSalida + '.pdf';

                  if not FileExists( sNombreArchPDF ) then begin
                     sArchivoFte := sFuente + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
                     bGlbQuitaCaracteres( sArchivoFte );
                     direccion := sDirClase + sArchivoFte +'.txt';
                     fteaux:= sDirClase + '|' + sArchivoFte +'.txt';

                     RegistrarLogForma( sTitulo, sArchSalida, '' );
                     MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_FLUJO );

                     //if FileExists( sDirClase + sArchivoFte + '.txt' ) then begin
                     if FileExists( direccion ) then begin    {si existe el fte}
                         farbol.GenerarDiagramaNvo( sParProg, fteaux, sParClase, 'JERARQUICO' , 2 , sParSistema,sParBib);  //tipo 2 - doc auto
                     end
                     else
                        //continue;
                        GlbRegistraLog( sPriArchLogErr,'AVISO: ' + sTitulo +'; NO EXISTE EL FUENTE: ' + sArchivoFte );
                  end;
               end;

            end;   //fin del for
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;    //fin de diagramas jerarquicos

         fDgrActJava: try
            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               if sParClase = 'JAV' then
                  sTitulo := sDiagActivJava + ' ' + sParProg;

               if sTitulo <> '' then begin
                  sArchSalida := sTitulo;
                  bGlbQuitaCaracteres( sArchSalida );
                  sNombreArchPDF := sDirClase + sArchSalida + '.pdf';

                  if not FileExists( sNombreArchPDF ) then begin
                     sArchivoFte := sFuente + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
                     if sParClase = 'JAV' then
                        sArchivoFte := sFuente + ' ' + sParProg;
                     bGlbQuitaCaracteres( sArchivoFte );

                     RegistrarLogForma( sTitulo, sArchSalida, '' );
                     MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_ACTIVIDAD_JAVA );

                     if FileExists( sDirClase + sArchivoFte + '.txt' ) then {si existe el fte} begin
                        bCreaDgrFlujo := GLbCreaDiagramaActividad(
                           sParClase, sParBib, sParProg,
                           sDirClase + sArchivoFte + '.txt',
                           sDirClase,
                           sDirClase + sArchSalida + '.pdf' );

                        if not bCreaDgrFlujo then
                           GlbRegistraLog( sPriArchLogErr,'No se pudo crear: ' + sTitulo +
                              '; archivo fte: ' + sArchivoFte +'; archivo salida: ' + sArchSalida );
                     end
                     else
                        //continue;
                        GlbRegistraLog( sPriArchLogErr, 'AVISO: ' + sTitulo +'; NO EXISTE EL FUENTE: ' + sArchivoFte );
                  end;
               end;


            end;   //fin del for
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;    //fin de diagrama actividad java


         fDgrFlujoJCL: try                  //Diagrama de flujo (NO visustin)
               salir:=1;
            // forzo a crear la forma
               while (salir > 0) and (cuenta < 500) do begin
                  try
                     fdiagjcl := Tftsdiagjcl.Create( Self );
                     fdiagjcl.Top := 0;
                     fdiagjcl.FormStyle := fsNormal;
                     fdiagjcl.Visible := False;
                     salir:=-1;
                     cuenta:=cuenta+1;
                  except
                     on E: exception do begin
                        salir:=1;
                        if cuenta = 499 then begin
                           RegistrarErrorForma( '** No se pudo crear la forma **', 'Diagrama de flujo JCL', E.Message );
                           break;
                           //exit;
                        end;
                     end;
                  end;
               end;   //fin de while
               // añadir al log para saber cuantas veces lo intento antes de crearlo
               if cuenta > 1 then
                  GlbRegistraLog( sPriArchLogErr,
                   'Creando: Diagrama Flujo JCL en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);


            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               sTitulo := sDiagFlujo + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               sArchSalida := sTitulo;
               bGlbQuitaCaracteres( sArchSalida );
               sNombreArchWMF := sDirClase + sArchSalida + '.wmf';
               sNombreArchPDF := sDirClase + sArchSalida + '.pdf';
               g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE FLUJO JCL';
               l_control := stringreplace( caption, 'Diagrama de Flujo ', '', [ rfreplaceall ] );
               g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );

               if dm.ProcessExists('EXCEL.EXE') then
                  dm.ProcessKill('EXCEL.EXE', true);

               // ------- si no existe ninguno de los dos formatos -------
               if ((not FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin
                  fdiagjcl.inicializa_doc;
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_FLUJO );

                  try
                     fdiagjcl.diagrama_jcl(sParProg,sParBib,sParClase, sParSistema);

                     try
                        GlbExportarDgr_A_WMF( fdiagjcl.atDiagramJCL, sNombreArchWMF );
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                        //gral.exportaJCL( fdiagjcl );   // a excel
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                     end;
                  except
                     on E: exception do
                        RegistrarErrorForma('Fallo al crear el diagrama', sArchSalida, E.Message );
                  end;

                  fdiagjcl.atDiagramJCL.Free;   //limpiar el diagrama
                  fdiagjcl.atDiagramJCL:=nil;
                  fdiagjcl.slPriBuscar.Free;
                  fdiagjcl.slPriBuscar:=nil;
                  fdiagjcl.PriDiagramAlign.Free;
                  fdiagjcl.PriDiagramAlign:=nil;
                  fdiagjcl.limpia_memdata;  //libera el MemData que almacena el registro de blocks en ptsdiagjcl
               end;



               // ------- si no existe WMF de los dos formatos -------
               if ((FileExists( sNombreArchPDF )) and (not FileExists( sNombreArchWMF ))) then begin  // si no existe el WMF, pero si el PDF
                  fdiagjcl.inicializa_doc;
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_FLUJO );
                  try
                     fdiagjcl.diagrama_jcl(sParProg,sParBib,sParClase, sParSistema);
                     try
                        GlbExportarDgr_A_WMF( fdiagjcl.atDiagramJCL, sNombreArchWMF );
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,'AVISO: ' + sTitulo + 'No se generó el WMF, intentar con la impresora del sistema');
                     end;
                  except
                     on E: exception do
                        RegistrarErrorForma('Fallo al crear el diagrama', sArchSalida, E.Message );
                  end;
                  fdiagjcl.atDiagramJCL.Free;   //limpiar el diagrama
                  fdiagjcl.atDiagramJCL:=nil;
                  fdiagjcl.slPriBuscar.Free;
                  fdiagjcl.slPriBuscar:=nil;
                  fdiagjcl.PriDiagramAlign.Free;
                  fdiagjcl.PriDiagramAlign:=nil;
                  fdiagjcl.limpia_memdata;  //libera el MemData que almacena el registro de blocks en ptsdiagjcl
               end;



               // ------- si no existe PDF de los dos formatos -------
               if ((FileExists( sNombreArchWMF )) and (not FileExists( sNombreArchPDF ))) then begin  // si no existe el PDF, pero si el WMF
                  fdiagjcl.inicializa_doc;
                  RegistrarLogForma( sTitulo, sArchSalida, '' );
                  MuestraPanelProcesado( sParClase, sParBib, sParProg, sDIGRA_FLUJO );

                  try
                     fdiagjcl.diagrama_jcl(sParProg,sParBib,sParClase, sParSistema);

                     try
                        //GlbExportarDgr_A_PDF( sNombreArchWMF, sNombreArchPDF );
                        dm.ExportAsPdf( sNombreArchWMF, sNombreArchPDF );
                        //gral.exportaJCL( fdiagjcl );   // a excel
                     except
                        on E: exception do
                           GlbRegistraLog( sPriArchLogErr,'AVISO: ' + sTitulo + 'No se generó el PDF, intentar con la impresora del sistema');
                     end;
                  except
                     on E: exception do
                        RegistrarErrorForma('Fallo al crear el diagrama', sArchSalida, E.Message );
                  end;
                  fdiagjcl.atDiagramJCL.Free;   //limpiar el diagrama
                  fdiagjcl.atDiagramJCL:=nil;
                  fdiagjcl.slPriBuscar.Free;
                  fdiagjcl.slPriBuscar:=nil;
                  fdiagjcl.PriDiagramAlign.Free;
                  fdiagjcl.PriDiagramAlign:=nil;
                  fdiagjcl.limpia_memdata;  //libera el MemData que almacena el registro de blocks en ptsdiagjcl
               end;


               end;     //fin del for
            fdiagjcl.Free;
         except
            on E: exception do
               //continue;
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;      //FIN de fdiagjcl

         // ======= codigo muerto ===========
         fCodigoMuerto :try
            // forzo a crear la forma
            while (salir > 0) and (cuenta < 500) do begin
               try
                  fcodMuerto := Tftsmuerto.Create(self);
                  fcodMuerto.Top := 0;
                  fcodMuerto.FormStyle := fsNormal;
                  fcodMuerto.Visible := False;
                  salir:=-1;
                  cuenta:=cuenta+1;
               except
                  on E: exception do begin
                     salir:=1;
                     if cuenta = 499 then begin
                        RegistrarErrorForma( '** No se pudo crear la forma **', 'Codigo Muerto', E.Message );
                        exit;
                     end;
                  end;
               end;
            end;   //fin de while
            // añadir al log para saber cuantas veces lo intento antes de crearlo
            if cuenta > 1 then
               GlbRegistraLog( sPriArchLogErr,
                   'Creando: Codigo Muerto en ' + IntToStr(cuenta) + ' intentos. Clase: '+ estructura[0].cla);

            fcodMuerto.cdir.Directory:= sDirClase;
            //ciclo que recorre los programas y manda al funcion para que lo procese
            for k:=0 to Length( estructura )-1 do begin
               // ...... procedimiento que detiene la corrida si lo quiere el usuario .....
               if bPriTerminaProceso then
                  Exit;
               // .........................................................................
               if sParClase <> estructura[k].cla then
                  fcodMuerto.trae_utilerias( estructura[k].cla );

               sParClase:=estructura[k].cla;
               sParBib:=estructura[k].bib;
               sParProg:=estructura[k].comp;

               sTitulo := sCodMuerto + ' ' + sParClase + ' ' + sParBib + ' ' + sParProg;
               sArchSalida := sTitulo;

               try
                  fcodMuerto.procesa(sParClase,sParBib,sParProg)
               except
                  on E: exception do
                     RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
               end;
               RegistrarLogForma( sTitulo, sArchSalida, imprime );
            end;  //fin del for
            fcodMuerto.Free;
         except
            on E: exception do
               RegistrarErrorForma( sTitulo, sArchSalida, E.Message );
         end;        //FIN de codigo muerto
         // =================================

      end;  //fin del case
      stbLista.Panels[ 1 ].Text := '';
   end;  //fin del for que recorre producto por clase
   indica_doc_auto(0);   //para indicar que ya NO viene de la documentacion auto en uDiagramaRutinas
   alkDocumentacion:=0;  // para indicar que viene de la documentacion en uConstantes
end;


procedure TfmDocSistema.LimpiaBulk(ruta:string);         //Alk para borrar los bulk.log generados por visustin en diag de flujo
var
   borrando:string;
   lista:TstringList;
   tam,i : integer;

   procedure ListarArchivos(ruta2:string; var Lista:TStringList);
   var
     SR: TSearchRec;
   begin
     if FindFirst(ruta2 + '\' + 'bulk*.log', faAnyFile , SR)= 0 then
      repeat
        //DeleteFile(Ruta+'\'+SR.Name);
        Lista.Add(ruta2+'\'+SR.Name);
      until FindNext(SR) <> 0;
   end;

begin
   if not DirectoryExists(ruta) then begin
      ShowMessage('No existe la carpeta');
      exit;
   end;
   lista:=TStringList.Create;
   ListarArchivos(ruta,lista);
   tam:=lista.Count;
   for i:=0 to tam-1 do begin
      borrando:=lista[i];
      DeleteFile(borrando);
   end;
end;

procedure TfmDocSistema.mnuCargarConfiguracionClick( Sender: TObject );
var
   sNombreArchivo: String;
begin
   inherited;

   sPriArchivoIni := '';

   sNombreArchivo := sGlbAbrirDialogo;
   if sNombreArchivo = '' then
      Exit;

   if not FileExists( sNombreArchivo ) then begin
      Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
         'Cargar Configuración', MB_OK );
      Exit;
   end;

   bPriClasesScratchProcesar := bPriProcesarScratch( sNombreArchivo );

   sPriRutaSalida := sPriObtenerRutaSalida( sNombreArchivo );

   if sPriRutaSalida = '' then
      Exit;

   if bPriClasesScratchProcesar then
      PriObtenerClasesScratch( sNombreArchivo ); //registra en slPriClasesScratch

   PriObtenerClasesFormas( sNombreArchivo ); //registra en aPriClaseForma, slPriClasesProcesar

   if ( Length( aPriClaseForma ) > 0 ) and ( slPriClasesProcesar.Count > 0 ) then begin
      sPriArchivoIni := sNombreArchivo;

      PriObtenerContenidoArchIni( sNombreArchivo, slPriArchivoIni );

      Application.MessageBox( PChar(
         'Configuración de Clases-Productos correcta.' ),
         PChar( 'Cargar Configuración' ), MB_OK );
   end
   else
      Application.MessageBox( PChar(
         'Configuración de Clases-Productos incorrecta.' + chr( 13 ) + chr( 13 ) +
         'Cargue un archivo de configuración correcto en el' + chr( 13 ) +
         '"Menú Documentación" opción "Cargar Configuración"' ),
         PChar( 'Cargar Configuración' ), MB_OK );
end;

function TfmDocSistema.bPriProcesarScratch( sParArchivo: String ): Boolean;
var
   iniArchivo: TIniFile;
   sTexto: String;
begin
   Result := False;

   iniArchivo := TIniFile.Create( sParArchivo );
   try
      sTexto := iniArchivo.ReadString( 'CONFIGURACION', 'ProcesarSCRATCH', '' );
   finally
      iniArchivo.Free;
   end;

   if 'TRUE' = UpperCase( sTexto ) then
      Result := True;
end;

procedure TfmDocSistema.PriObtenerClasesScratch( sParArchivo: String );
//registra en slPriClasesScratch
var
   iniArchivo: TMemIniFile;
begin
   slPriClasesScratchProcesar.Clear;

   iniArchivo := TMemIniFile.Create( sParArchivo );
   try
      iniArchivo.ReadSectionValues( 'Clases_SCRATCH', slPriClasesScratchProcesar );
   finally
      iniArchivo.Free;
   end;
end;

procedure TfmDocSistema.PriObtenerClasesFormas( sParArchivo: String );
//registra en aPriClaseForma, slPriClasesProcesar
var
   i: Integer;
   iLongitudArreglo: Integer;
   iniArchivo: TMemIniFile;
   slSeccionIni: TStringList;
   sClaseIni, sFormaIni: String;
   Forma: TForma;

   function bExisteClaseFormaProcesar( sParClase: String; ParForma: TForma ): Boolean;
      // busca si esta en aPriClaseForma
   var
      i: Integer;
   begin
      Result := False;

      for i := 0 to Length( aPriClaseForma ) - 1 do
         if ( aPriClaseForma[ i ].sClase = sParClase ) and
            ( aPriClaseForma[ i ].fClassName = ParForma ) then begin
            Result := True;
            Break;
         end;
   end;

   function bExisteClaseProcesar( sParClase: String ): Boolean;
      // busca si esta en el slPriClasesProcesar
   var
      i: Integer;
   begin
      Result := False;

      for i := 0 to slPriClasesProcesar.Count - 1 do
         if slPriClasesProcesar[ i ] = sParClase then begin
            Result := True;
            Break;
         end;
   end;

begin
   //registra en aPriClaseForma
   iniArchivo := TMemIniFile.Create( sParArchivo );

   //inicializar listas ordenadas
   productos:=TstringList.Create;
   clases:=TstringList.Create;
   //para que no se repitan valores
   productos.Sorted:=true;
   clases.Sorted:=true;

   try
      slSeccionIni := TStringList.Create;
      try
         iniArchivo.ReadSectionValues( 'Clases_Productos', slSeccionIni );

         SetLength( aPriClaseForma, 0 );

         for i := 0 to slSeccionIni.Count - 1 do
            if pos( '//', slSeccionIni[ i ] ) = 0 then //>0 es comentario de linea
               if pos( ',', slSeccionIni[ i ] ) > 0 then begin
                  sClaseIni :=
                     Trim( Copy( slSeccionIni[ i ], 1, pos( ',', slSeccionIni[ i ] ) - 1 ) );
                  sFormaIni :=
                     Trim( Copy( slSeccionIni[ i ], pos( ',', slSeccionIni[ i ] ) + 1, Length( slSeccionIni[ i ] ) ) );

                  sClaseIni := UpperCase( sClaseIni );
                  sFormaIni := UpperCase( sFormaIni );

                  //Ir formando la lista de los productos que va a procesar, y las clases     //ALK
                  productos.Add(sClaseIni);
                  clases.Add(sFormaIni);

                  if sFormaIni = UpperCase( 'fDgrBloques' ) then
                     Forma := fDgrBloques
                  else if sFormaIni = UpperCase( 'fDgrAImpacto' ) then
                     Forma := fDgrAImpacto
                  else if sFormaIni = UpperCase( 'fDgrProcesos' ) then
                     Forma := fDgrProcesos
                  else if sFormaIni = UpperCase( 'fDgrFlujoCBL' ) then
                     Forma := fDgrFlujoCBL
                  else if sFormaIni = UpperCase( 'fDgrFlujoCPY' ) then
                     Forma := fDgrFlujoCPY
                  else if sFormaIni = UpperCase( 'fDgrFlujoOSQ' ) then
                     Forma := fDgrFlujoOSQ
                  else if sFormaIni = UpperCase( 'fDgrFlujoC' ) then
                     Forma := fDgrFlujoC
                  else if sFormaIni = UpperCase( 'fDgrFlujoShell' ) then
                     Forma := fDgrFlujoShell
                  else if sFormaIni = UpperCase( 'fDgrFlujoJava' ) then
                     Forma := fDgrFlujoJava
                  else if sFormaIni = UpperCase( 'fDgrFlujoJCL' ) then
                     Forma := fDgrFlujoJCL
                  else if sFormaIni = UpperCase( 'fDgrFlujoJCLvis' ) then       //flujo de visustin
                     Forma := fDgrFlujoJCLvis
                  else if sFormaIni = UpperCase( 'fDgrActJava' ) then
                     Forma := fDgrActJava
                  else if sFormaIni = UpperCase( 'fDgrFlujoALG' ) then
                     Forma := fDgrFlujoALG
                  else if sFormaIni = UpperCase( 'fDgrFlujoTMC' ) then
                     Forma := fDgrFlujoTMC
                  else if sFormaIni = UpperCase( 'fDgrFlujoTMP' ) then
                     Forma := fDgrFlujoTMP
                  else if sFormaIni = UpperCase( 'fDgrFlujoWFL' ) then
                     Forma := fDgrFlujoWFL
                  else if sFormaIni = UpperCase( 'fDgrJerarquicoALG' ) then
                     Forma := fDgrJerarquicoALG
                  else if sFormaIni = UpperCase( 'fDgrJerarquicoBSC' ) then
                     Forma := fDgrJerarquicoBSC
                  else if sFormaIni = UpperCase( 'fDgrJerarquicoWFL' ) then
                     Forma := fDgrJerarquicoWFL
                  else if sFormaIni = UpperCase( 'fDgrJerarquicoCBL' ) then
                     Forma := fDgrJerarquicoCBL
                  else if sFormaIni = UpperCase( 'fDgrJerarquicoOSQ' ) then
                     Forma := fDgrJerarquicoOSQ
                  else if sFormaIni = UpperCase( 'fLstComponentes' ) then
                     Forma := fLstComponentes
                  else if sFormaIni = UpperCase( 'fLstDependencias' ) then
                     Forma := fLstDependencias
                  else if sFormaIni = UpperCase( 'fLstRefCruzadas' ) then
                     Forma := fLstRefCruzadas
                  else if sFormaIni = UpperCase( 'fLstMatrizCrud' ) then
                     Forma := fLstMatrizCrud
                  else if sFormaIni = UpperCase( 'fLstMatrizAF' ) then
                     Forma := fLstMatrizAF
                  else if sFormaIni = UpperCase( 'fLstMatrizArchLog' ) then
                     Forma := fLstMatrizArchLog
                  else if sFormaIni = UpperCase( 'fFuente' ) then
                     Forma := fFuente
                  else if sFormaIni = UpperCase( 'fCodigoMuerto' ) then
                     Forma := fCodigoMuerto
                  else if sFormaIni = UpperCase( 'fDgrFlujoOBY' ) then
                     Forma := fDgrFlujoOBY
                  else if sFormaIni = UpperCase( 'fDgrFlujoDCL' ) then
                     Forma := fDgrFlujoDCL
                  else if sFormaIni = UpperCase( 'fDgrFlujoBSC' ) then
                     Forma := fDgrFlujoBSC
                  else
                     Forma := fNull;


                  if ( sClaseIni <> '' ) and ( Forma <> fNull ) then begin
                     //validar que no se repitan clase y forma
                     if not bExisteClaseFormaProcesar( sClaseIni, Forma ) then begin
                        // Registrar en arreglo aPriClaseForma
                        iLongitudArreglo := Length( aPriClaseForma );

                        SetLength( aPriClaseForma, iLongitudArreglo + 1 );
                        aPriClaseForma[ iLongitudArreglo ].sClase := sClaseIni;
                        aPriClaseForma[ iLongitudArreglo ].fClassName := Forma;
                     end;
                  end;
               end;
      finally
         slSeccionIni.Free;
      end;
   finally
      iniArchivo.Free;
   end;

   //reegistra en slPriClasesProcesar
   slPriClasesProcesar.Clear;
   for i := 0 to Length( aPriClaseForma ) - 1 do
      if not bExisteClaseProcesar( aPriClaseForma[ i ].sClase ) then
         slPriClasesProcesar.Add( aPriClaseForma[ i ].sClase );
end;

function TfmDocSistema.bPriTerminaProceso: Boolean;
var
   iniArchivo: TIniFile;
   sTerminaProceso: String;
begin
   Result := False;

   if sPriArchivoIni = '' then
      Exit;

   iniArchivo := TIniFile.Create( sPriArchivoIni );
   try
      sTerminaProceso := iniArchivo.ReadString( 'CONFIGURACION', 'TerminarProceso', '' );
   finally
      iniArchivo.Free;
   end;

   if 'TRUE' = UpperCase( Trim( sTerminaProceso ) ) then
      Result := True;
end;

procedure TfmDocSistema.PriObtenerContenidoArchIni( sParArchivo: String; slParContenido: TStringList );
var
   iniArchivo: TMemIniFile;
   slPaso: TStringList;
begin
   slParContenido.Clear;

   slPaso := TStringList.Create;
   try
      iniArchivo := TMemIniFile.Create( sParArchivo );
      try
         slParContenido.Add( '[Configuracion]' );
         iniArchivo.ReadSectionValues( 'Configuracion', slPaso );
         slParContenido.AddStrings( slPaso );

         slParContenido.Add( '[Clases_SCRATCH]' );
         iniArchivo.ReadSectionValues( 'Clases_SCRATCH', slPaso );
         slParContenido.AddStrings( slPaso );

         slParContenido.Add( '[Clases_Productos]' );
         iniArchivo.ReadSectionValues( 'Clases_Productos', slPaso );
         slParContenido.AddStrings( slPaso );
      finally
         iniArchivo.Free;
      end;
   finally
      slPaso.Free;
   end;
end;

function TfmDocSistema.sPriObtenerRutaSalida( sParArchivo: String ): String;
var
   iniArchivo: TIniFile;
   sTexto: String;
   sUltimoCaracter: String;
begin
   sTexto := '';
   try
      iniArchivo := TIniFile.Create( sParArchivo );
      try
         sTexto := iniArchivo.ReadString( 'CONFIGURACION', 'RutaSalida', '' );
      finally
         iniArchivo.Free;
      end;

      sTexto := Trim( sTexto );

      if sTexto = '' then begin
         Application.MessageBox( PChar( 'Parámetro "RutaSalida" incorrecto. ' + sTexto + Chr( 13 ) + Chr( 13 ) +
            'Asegúrese de tener el parámetro incluido en el archivo de' + Chr( 13 ) +
            'configuración o posiblemente el parámetro esta vacío.' ),
            pchar( 'Aviso' ), MB_OK );
         Exit;
      end;

      sUltimoCaracter := Copy( sTexto, Length( sTexto ), 1 );
      if sUltimoCaracter <> '\' then
         sTexto := sTexto + '\';

      if ForceDirectories( sTexto ) = False then begin
         sTexto := '';

         Application.MessageBox( PChar( 'No se puede crear el directorio. ' + sTexto + Chr( 13 ) + Chr( 13 ) +
            'Asegúrese de tener permisos de escritura en su equipo o' + Chr( 13 ) +
            'posiblemente la ruta es incorrecta. Verifique en el archivo' + Chr( 13 ) +
            'de configuración que el parámetro "RutaSalida" sea correcto.' ),
            pchar( 'Aviso' ), MB_OK );
      end;
   finally
      Result := sTexto;
   end;
end;

{
procedure TfmDocSistema.mnuIniDiagramaSistemaClick( Sender: TObject );  //alk ini diag sist
var
   sNombreArchivo: String;
begin
   inherited;

   sPriArchivoIni := '';

   sNombreArchivo := sGlbAbrirDialogo;
   if sNombreArchivo = '' then
      Exit;

   if not FileExists( sNombreArchivo ) then begin
      Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
         'Cargar Configuración', MB_OK );
      Exit;
   end;

   iniDiagSis:=1;
end;     }


end.


