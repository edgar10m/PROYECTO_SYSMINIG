unit ptsdm;

interface

uses
   Windows, Messages, SysUtils, Classes, forms, Dialogs, Buttons, Stdctrls, winsock, ADODB, variants,
   ImgList, Controls, strutils, comctrls, InvokeRegistry, Rio, SOAPHTTPClient, tlhelp32, ShellAPI,
   dxmdaset, dxBar, HTML_HELP, DB, uConstantes, SynPdf,Graphics;

type
   Tpathbibs = record
      nombre: string;
      clase: string;
      ruta: string;
   end;

type
   Tdescbibs = record
      nombre: string;
      descripcion: string;
   end;

type
   Tdm = class( TDataModule )
      tsblob: TADOTable;
      ADOConnection1: TADOConnection;
      adoq: TADOQuery;
      q1: TADOQuery;
      qmodify: TADOQuery;
      q2: TADOQuery;
      q3: TADOQuery;
      q4: TADOQuery;
      q5: TADOQuery;
      imgclases: TImageList;
      imgs: TImageList;
      htt: THTTPRIO;
      ImageList3: TImageList;
      tabVentanas: TdxMemData;
      tabVentanasFirstName: TStringField;
      tabCias: TdxMemData;
      tabCiasUserCia: TStringField;
      tabCiasUserCia_Desc: TStringField;
      tabCiasUserCia_Abrev: TStringField;
      tabConsultas: TdxMemData;
      tabConsultasFirstName: TStringField;
      ImageList1: TImageList;
      tabVentanasVentanaFechaHora: TStringField;
      tabConsultasFechaHoraCaption: TStringField;
      tsDocBlob: TADOTable;
      tsDocBlobIDDOCTO: TIntegerField;
      tsDocBlobIDREVISION: TIntegerField;
      tsDocBlobTAMNORMAL: TIntegerField;
      tsDocBlobTAMCRC: TIntegerField;
      tsDocBlobARCHIVO: TBlobField;
      spGeneraInventario: TADOStoredProc;
      spInventarioTotal: TADOStoredProc;
    spCalifica: TADOStoredProc;
    spActivos: TADOStoredProc;
    spEjecutaActivos: TADOStoredProc; //JCR201211
      procedure DataModuleCreate( Sender: TObject );
      procedure DataModuleDestroy( Sender: TObject );
   private
      { Private declarations }
      procedure actualiza_version( nver: string; ver: string; sele: string; valida: boolean = true );
   public
      { Public declarations }
      lclases: Tstringlist;
      //function conectar_BDE: boolean; //JCR201208 //no utilizar, solo si existe conexion ODBC y BDEngine
      procedure revisa_version;
      procedure aborta( mensaje: string );
      function desencripta( dato: string ): string; // regresa los passwords
      function encripta( dato: string ): string; // encripta los password
      procedure feed_combo( combo: tcombobox; sele: string );
      function sqlinsert( sele: string ): boolean;
      function sqldelete( sele: string ): boolean;
      function sqlupdate( sele: string ): boolean;
      function sqlselect( tabla: tADOquery; sele: string ): boolean;
      function capacidad( capa: string ): boolean;
      function file2blob( arch: string; var magic: string ): string;
      function blob3memo( clave: string; var memo: TRichedit ): boolean;
      //function blob2memo( clave: string; var memo: Tmemo ): boolean;
      function leeblob( clave: string; var Buffer: PChar ): boolean;
      function magico( buffer: pchar; lon: integer ): string;
      function GetIPFromHost( var HostName, IPaddr, WSAErr: string ): Boolean;
      function datedb( fecha: string; formato: string ): string;
      Function FileSize( FileName: String ): Int64;
      Procedure blob2file( clave: string; archivo: string );
      procedure waitforexec( comando: string; parametros: string );
      procedure RunDosInMemo( DosApp: String; AMemo: TMemo );
      function ejecuta_espera( FileName: String; Visibility: integer ): boolean;
      function pathbib( biblioteca: string; clase: string ): string;
      function descbib( pdescripcion: string ): string;
      function filemagic( arch: string ): string;
      procedure get_utileria( utileria: string; archivo: string; visual:boolean=true; esdirectiva:boolean=true );
      function xlng( mensaje: string ): string;
      function xblobname( bib: string; nombre: string; clase: string ): string;
      Function get_variable( nomvar: string ): string;
      function verifica_base( tabla: string ): boolean;
      function verifica_tabla_tsproperty: boolean;
      function verifica_tabla_tsrela: boolean;
      function verifica_campo( ta: Tadotable; nombre: string; tipo: string; tamano: integer ): boolean;
      //procedure alta_resumen( compo: string; bib: string; clase: string );
      //procedure alta_atributo( compo: string; bib: string; clase: string );
      //function leebfile( compo: string; bib: string; clase: string; var Buffer: PChar ): boolean; //se sustituyo por sPubObtenerBFile(
      //function leebfile2( compo: string; bib: string; var Buffer: PChar ): boolean;
      function sgetoracledir( sParProg, sParBib, sParClase: String; var sDirectoryPath: String): String;

      function sPubObtenerBFile( sParProg, sParBib, sParClase: String ): String;
      function sqlSelectBFile( tabla: tADOquery; sele: string ): boolean;

      function bfile2file( compo: string; bib: string;clase:string; archivo: string ): boolean;
      //function bfile2file( compo: string; bib: string; archivo: string ): boolean;
      //function trae_fuente}( compo: string; bib: string; objeto: Tpersistent; clase: string = '' ): boolean;
      function trae_fuente( sistema: string; compo: string; bib: string; clase: string; objeto: Tpersistent ): boolean;
      function mismo_server: boolean;
      //procedure bfile_directorio;
      procedure muestra_error( mensaje: string );
      procedure checa_directorio( dire: string; ruta: string );
      //---------------- funciones para TSSOLVER  (demonio) ----------------------------------
      function leexdemonio( compo: string; bib: string; clase: string; var Buffer: PChar ): boolean;
      function pingdemonio: boolean;
      function remote_ejecuta_espera( comando: string; Visibility: integer; arch: string; var Buffer: string ): boolean;
      function remote_envia( local: string; remoto: string ): boolean;
      //--------------------------------------------------------------------------------------

      function procrunning( tarea: string ): Boolean; { verdadero si TAREA está corriendo }
      function revisa_campo( nver: string; ver: string; tabla: string; campo: string; tipo: string; longitud: integer; nullable: string ): boolean;
      // JCR201208     procedure BorraUnidadesNetUse();
      procedure PubRegistraVentanaActiva( sParCaption: String );
      procedure PubEliminarVentanaActiva( sParCaption: String );
      procedure PubRegistraConsultaActiva( sParCaption: String; sParFechaHora: String );
      procedure PubEliminarConsultaActiva( sParCaption: String );
      procedure feed_combo1( combo: tcombobox; sele: string );
      procedure feed_combo2( combo: tcombobox; sele: string );
      function activa_tsbibcla: boolean;

      function bInsertarTSDOCBLOB(
         iParIDDOCTO, iParIDREVISION: Integer;
         iParTamNormal, iParTamCRC: Integer; sParArchivo: String ): Boolean;

      function bObtenerTSDOCBLOB(
         iParIDDOCTO, iParIDREVISION: Integer; sParArchivo: String ): Boolean;

      function iObtenerID( sParTabla: String; iParIDDOCTO: Integer ): Integer;

      procedure TaladrarTsrela( ParDrill: TDrill; //DrillDown, DrillUp
         sParSistemaOrigen, sParProg, sParBib, sParClase: String; bParRegistraRepetidos: Boolean );

      procedure TaladrarTsrelaDetalle( ParDrill: TDrill; //DrillDown, DrillUp
         sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN: String;
         sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT: String;
         sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS: String;
         iParLINEAINICIO, iParLINEAFINAL: Integer;
         sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE: String;
         sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE: String;
         bParRegistraRepetidos: Boolean;
         bParRepetido: Boolean; sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido: String;
         sParSistemaOrigen: string );

      function ArmarSelectClases: String;
      function bPubDocumentoExiste( sParNombre, sParProg, sParBib, sParClase: String ): Boolean;

      function bfile_lowsize( compo: string; bib: string; var salida:string ): boolean;

      // ----------- funcion para calcular complejidades  ALK ----------------
      procedure complejidad(comp, cla, bib, sis, rgmlang, complejidad ,dirCBL, dirCMA, res : String);

      // ----- funciones para comprobar, correr y matar un proceso  ALK ------
      function ClearFileName(AExeName: String): TFileName;
      function ProcessExists(AExeName: String): boolean;
      procedure ExecuteAndWait(AExeName: String; uCmdShow: Cardinal);
      function ProcessKill(AExeName: String; Iterative: boolean = TRUE): boolean;
      // ---------------------------------------------------------------------

      procedure ExportAsPdf(const inFileName, outFileName: TFileName); // -- Funcion para generar un pdf a partir de un archivo
      function es_SCRATCH (sParSistema, sParProg, sParBib, sParClase:String):boolean; // --  ALK para comprobar que exista el fuente
      function valida_var_entorno(variable:String):Boolean;  //funcion que valida que exista una varaible de entorno, el parametro es algun nombre que coincida con la variable (ruta, nombre dle programa, etc.)
   end;

var

   g_version: string = '2016102000';//'2016072901'; //'2016072011'; // '2016050401';//'2015082400';//'2015081900';
   //'2015081200';//'2015080700';//'2015080601';//'2015080500';
   //'2015072901';//'2015072801';//'2015072700';//'2014102804';
   //'2014102100';// '2014063000';//'2014062403'; //'2014040802';
   // '2014031900';//'2014030500';//'2014030300';//'2014021900'; //'2014021001';
   //  g_version_tit:string='SysViewSoft Software Configuration Management 5.04.15';
   //  g_version_tit:string='SysViewSoft Software Configuration Management 6.0.1';
   g_version_tit: string = 'Sys-Mining 6.0.1';
   g_caduca: string;
   g_windir: Pchar;
   g_database: string;
   g_pass: string;
   g_q: string;
   g_appname: PAnsiChar = 'Sys-Mining 6.0.1';
   g_usuario: string;
   g_empresa: string;
   g_empresa_abrev: string;
   g_ipaddress: string;
   g_hostname: string;
   g_borrar: Tstringlist; // archivos temporales que se deben borrar
   g_ruta: string; // Directorio donde arranca la aplicacion
   g_ruta_ejecuta: string; // Directorio donde arranca la aplicacion, como respaldo del valor original
   g_ruta_pais: string; // Directorio por pais
   g_tmpdir: string; // Directorio de trabajo
   g_logdir: string;  //Directorio para los log   ALK
   g_is_null: string; // Pregunta por Nulo
   g_pais: string; // Pais para BBVA FPT
   g_oratmpdir: string; //RGM20120906 Busca-Paises
   g_pathbibs: array of Tpathbibs; // rutas de las bibliotecas de componentes
   g_descbibs: array of Tdescbibs; // descripciones de las bibliotecas de componentes
   g_language: string; // lenguage delo producto
   g_graphviz: string; // version de Graphviz
   g_log: Tstringlist; // Guarda el log de los procesos
   g_sistema_actual: string; // Sistema que se está procesando
   g_odbc: string = 'sysviewsoftscm'; // ODBC para la Base de Datos
   //g_odbc2:string='sysviewsoftscm';       // ODBC para la Base de Datos //fercar momentaneo hasta modificar reporteador
   g_user_entrada: string = 'sysview11'; // usuario que lee clave de usuario proceso
   g_user_procesa: string = 'sysview12'; // usuario que procesa
   g_mismoserver: boolean; // valida que cliente y server están en la misma máquina
   g_demonio: boolean;
   g_busca_remoto: boolean; // busqueda en el server mediante tssolver
   g_procesa: boolean; //  Esto es para que no muestre la pantalla, si no tiene información.
   g_control: string; // Para análisis de impacto, diagrama de proceso , diagrama de flujo JCL's
   //g_left: integer = 580;
   //g_top: integer = 95;
   g_Width: integer = 750;
   g_Height: integer = 583;
   //g_MaxWidth: integer = 900;
   //g_MaxHeight: integer = 700;
   g_Wforma: string;
   g_Wforma_Aux: string;
   g_ext: string;
   g_fecha_entrada: string;
   g_tiempo_espera_tssolver: integer;
   g_tiempo_envia: integer;
   g_unidad_libre: string;
   g_Wser: string; // Direccion del servidor
   g_Wcar: string; // Carpeta en el servidor
   g_Wusu: string; // Usuario para conectarse al servidor
   g_Wpas: string;
   g_p: INTEGER = 0;
   g_Y, g_X: integer;
   g_texto, bgral, sDATOS_COMPO, NombreProceso: string;
   HookID: THandle;
   Guard, numbers: integer;
   dm: Tdm;
   iHelpContext: Integer = IDH_TOPIC_T00001;
   g_clase: string;
   g_existe: integer = 0;
   g_ArbolDescri: String = ' ';
   // Para g_ArbolDescri:
   // DATO='$HCCLASE$_$HCBIB$_$HCPROG$'  ->  'CBL_COBLIB_PROGRAMA1' donde HCCLASE='CBL', HCBIB='COBLIB', HCPROG='PROGRAMA1'
   // DATO='$HCCLASE$=$HCPROG_NOEXT$'     ->  'FIL=C:\ARCHIVOS\FILE1'      donde HCCLASE='FIL', HCPROG=' C:\ARCHIVOS\FILE1.DAT'
   // DATO='--$HCPROG_BASENAME$'     ->  '--FILE1.DAT'      donde  HCPROG=' C:\ARCHIVOS\FILE1.DAT'
   // DATO='>$HCCLASE$>>>$HCPROG_BASENAME_NOEXT$'     ->  '>FIL>>>FILE1'      donde HCCLASE='FIL', HCPROG=' C:\ARCHIVOS\FILE1.DAT'
   g_Diagrama: string;
   g_Opcion: String;
   g_producto: String;
   g_procesando: string; // para grabar en TSLOG el nombre del archivo o componente
   g_visual:boolean=true;     // TRUE = es un programa interactivo
implementation
uses
   //isvsserver1,
   ptscomun, ptsmain,
   cxDBEdit, cxBlobEdit; //fercar Blob
{$R *.dfm}

{function UniqueNumber: Integer; //JCR201208
begin
   asm
@@1:    MOV     EDX,1
        XCHG    Guard,EDX
        OR      EDX,EDX
        JNZ     @@2
        MOV     EAX,Numbers
        INC     EAX
        MOV     Numbers,EAX
        MOV     Guard,EDX
        RET

@@2:    PUSH    0
        CALL    Sleep
        JMP     @@1
   end;
end;}//no utilizar, solo si existe conexion ODBC y BDEngine

{function Tdm.conectar_BDE;
//propiedades de los objetos:

object dbverfte: TDatabase
  AliasName = 'sysviewsoftscm'
  DatabaseName = 'dbsvs'
  LoginPrompt = False
  SessionName = 'Default'
end

object qBDE1: TQuery
  DatabaseName = 'dbsvs'
end

var
   Wpass, sErrorNativo, Wbs: string;
begin
   if dm.sqlselect( dm.q1, 'select * from ' + g_user_procesa + '.shdbase' ) then begin
      Wpass := dm.desencripta( dm.q1.fieldbyname( 'base1' ).asstring );
      Wpass := copy( Wpass, 3, 50 );
   end;

   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'BLOB_SIZE' + g_q +
      ' and secuencia = 1 ' ) then
      Wbs := dm.q1.fieldbyname( 'dato' ).AsString
   else
      Wbs := '512';

   Result := False;

   try
      with dbverfte do begin
         Connected := False;
         AliasName := 'sysviewsoftscm';
         LoginPrompt := False;
         DatabaseName := Format( '%s%x', [ dbverfte.Name, UniqueNumber ] );
         //Params.Values[ 'SERVER NAME' ] := g_odbc; // 'SYSVIEWDES';
         Params.Values[ 'USER NAME' ] := g_user_procesa; //'SYSVIEW12';
         Params.Values[ 'PASSWORD' ] := Wpass; //'sysview12';
         Params.Values[ 'BLOB SIZE' ] := Wbs;
         //Params.Values[ 'SQLQRYMODE' ] := 'SERVER';

         Connected := True;

         Result := True;
      end;

   except
      Application.MessageBox( pchar( dm.xlng( 'No se conecto ' + g_odbc + ' ' + g_user_procesa ) ),
         pchar( dm.xlng( 'Mensaje de error' ) ), MB_OK );
   end;
end;}//no utilizar, solo si existe conexion ODBC y BDEngine

procedure Tdm.muestra_error( mensaje: string );
var
   p: pchar;
begin
   if FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER + FORMAT_MESSAGE_FROM_SYSTEM,
      nil, GetLastError( ), 0, p, 0, nil ) <> 0 then begin
      Application.MessageBox( pchar( dm.xlng( mensaje + chr( 13 ) + p ) ),
         pchar( dm.xlng( 'Mensaje de error' ) ), MB_OK );
      //showmessage(mensaje+chr(13)+p);
      LocalFree( integer( p ) );
   end
   else
      Application.MessageBox( pchar( dm.xlng( mensaje ) ),
         pchar( dm.xlng( 'Mensaje de error' ) ), MB_OK );
   //showmessage(mensaje);
end;

function GetDriveSerialNo( Drive: String ): String; // Drive as 'x:' ...
var
   VolSerNum: DWORD;
   Dummy1, Dummy2: DWORD;
begin
   if GetVolumeInformation( pchar( drive + '\' ), NIL, 0, @VolSerNum, Dummy1, Dummy2, NIL, 0 ) then
      Result := Format( '%.4x:%.4x', [ HiWord( VolSerNum ), LoWord( VolSerNum ) ] );
End;

procedure verifica_llave;
var
   seria: string;
   cod, cod2, archi: string;
   fil: Tstringlist;
   llave: string;
   i: integer;
begin
   seria := GetDriveSerialNo( 'c:' );
   fil := Tstringlist.Create;
   for i := 1 to length( seria ) do begin
      cod := cod + rightstr( '000' + ( inttostr( ord( seria[ i ] ) + 29 ) ), 3 );
      cod2 := cod2 + inttostr( ord( seria[ i ] ) - 40 ) + '.';
   end;
   delete( cod2, length( cod2 ), 1 );
   archi := 'c:\windows\sysviewsoftscm.lnc';
   if fileexists( archi ) then begin
      fil.LoadFromFile( archi );
      llave := copy( fil[ 0 ], 5, 500 );
      if cod = llave then begin
         fil.free;
         exit;
      end;
   end;
   llave := copy( inputbox( 'Licencia', 'Llave: ', cod2 ), 5, 500 );
   if llave <> cod then begin
      Application.MessageBox( pchar( dm.xlng( 'Llave incorrecta' ) ),
         pchar( dm.xlng( 'Valida llave' ) ), MB_OK );
      abort;
   end;
   fil.Clear;
   fil.Add( formatdatetime( 'nnss', now ) + llave );
   fil.SaveToFile( archi );
   fil.Free;
end;

function Tdm.mismo_server: boolean;
begin
   mismo_server := ptscomun.mismo_server;
end;

procedure Tdm.checa_directorio( dire: string; ruta: string );
begin
   ptscomun.checa_directorio( dire, ruta );
end;

{
procedure Tdm.bfile_directorio;
begin
   g_mismoserver := mismo_server;
   if dm.sqlselect( dm.q1, 'select * from tsbib order by cbib' ) then begin
      while not dm.q1.Eof do begin
         checa_directorio( dm.q1.fieldbyname( 'cbib' ).AsString, dm.q1.fieldbyname( 'path' ).AsString );
         checa_directorio( 'VER_' + dm.q1.fieldbyname( 'cbib' ).AsString,
            dm.q1.fieldbyname( 'path' ).AsString + '\versiones' );
         // Checa que exista el directorio en ORACLE
         // actualiza los registros TSRELA con biblioteca SCRATCH
         {--- pendiente, no aplica si el componente no existe
         dirprod:=dm.q1.fieldbyname('dirprod').AsString;
         if dirprod<>'' then begin
            dm.sqlupdate('update tsrela set hcbib='+g_q+dm.q1.fieldbyname('cbib').AsString+g_q+
               ' where hcbib='+g_q+'SCRATCH'+g_q+
               ' and   coment='+g_q+dirprod+g_q);
            showmessage('actualizados='+inttostr(dm.qmodify.RowsAffected));
         end;
         //--- pendiente, no aplica si el componente no existe (aqui cierra la llave)
         dm.q1.Next;
      end;
   end;
end;
}

procedure Tdm.actualiza_version( nver: string; ver: string; sele: string; valida: boolean = true );
var
   i: integer;
begin
   if ver < nver then begin
      if ( g_usuario <> 'ADMIN' ) and ( g_usuario <> 'SVS' ) then begin
         aborta( 'ERROR... Su versión no corresponde a la actual' );
      end;
      //if application.MessageBox(pchar('Desea actualizar a la version '+nver+'?'),'Confirme',MB_YESNO)=IDNO then begin
      if application.MessageBox( pchar( 'Desea actualizar a la version ' + nver + '?' + chr( 13 ) + sele ), 'Confirme', MB_YESNO ) = IDNO then begin
         application.Terminate;
         abort;
      end;

      if dm.sqlinsert( sele ) = false then begin
         if valida then begin
            if uppercase( copy( sele, 1, 5 ) ) <> 'DROP ' then
               aborta( 'ERROR... no puede actualizar a la version ' + nver + chr( 13 ) + sele );
         end;
      end;
      if dm.qmodify.RowsAffected > 0 then
         Application.MessageBox( pchar( dm.xlng( sele + chr( 13 ) + inttostr( dm.qmodify.RowsAffected ) + ' registros afectados' ) ),
            pchar( dm.xlng( 'Actualizar versión' ) ), MB_OK );
      if dm.sqlupdate( 'update parametro ' +
         ' set secuencia=' + nver + ' ,dato=' + g_q + g_version_tit + g_q +
         ' where clave=' + g_q + 'VERSIONSHD' + g_q ) = false then
         aborta( 'ERROR... no puede actualizar la secuencia de version' );
   end;
   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Base Conocimiento - Busqueda' + g_q +
      ' and crol=' + g_q + 'CONSULTA' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Base Conocimiento - Busqueda' + g_q + ',' + g_q + 'CONSULTA' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Administracion Caducidad' + g_q +
      ' and crol=' + g_q + 'SVS' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Administracion Caducidad' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   end;

   { if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
       ' where ccapacidad=' + g_q + 'Administracion LimpiaInventario' + g_q +
       ' and crol=' + g_q + 'SVS' + g_q ) = false then begin
       dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
          g_q + 'Administracion LimpiaInventario' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
    end;

    if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
       ' where ccapacidad=' + g_q + 'Administracion LimpiaInventario' + g_q +
       ' and crol=' + g_q + 'ADMIN' + g_q ) = false then begin
       dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
          g_q + 'Administracion LimpiaInventario' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );

    end;
    }
    {  if dm.sqlselect(dm.q1,'select * from tscapacidad '+
         ' where ccapacidad='+g_q+'Administracion Caducidad'+g_q+
         ' and crol='+g_q+'ADMIN'+g_q) then begin
         dm.sqldelete('delete from tscapacidad where ccapacidad='
                      +g_q+'Administracion Caducidad'+g_q+' and crol='+g_q+'ADMIN'+g_q);
      end;
    }
   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Administracion Monitoreo' + g_q +
      ' and crol=' + g_q + 'ADMIN' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Administracion Monitoreo' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Mining - Casos Uso' + g_q +
      ' and crol=' + g_q + 'ADMIN' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Mining - Casos Uso' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Analisis Especificos - Analisis Programas' + g_q +
      ' and crol=' + g_q + 'ADMIN' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Analisis Especificos - Analisis Programas' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Analisis Especificos - Propagacion Variables' + g_q +
      ' and crol=' + g_q + 'ADMIN' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Analisis Especificos - Propagacion Variables' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );
   end;
end;

procedure Tdm.revisa_version;
var
   ver: string;
begin
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'VERSIONSHD' + g_q ) = false then
      aborta( 'ERROR... No existe el parametro de version' );
   ver := dm.q1.fieldbyname( 'secuencia' ).AsString;

   if dm.verifica_base( 'TSUSERPRO' ) = false then begin
      if dm.sqlinsert( 'create table tsuserpro (' +
         ' cuser        varchar(50) NOT NULL,' +
         ' cproyecto    varchar(70) NOT NULL,' +
         ' cprog        varchar(70) NOT NULL,' +
         ' cbib        varchar(50)  NOT NULL,' +
         ' cclase      varchar(10)  NOT NULL)' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede crear TSUSERPRO' ) ),
            pchar( dm.xlng( 'Revisar versión ' ) ), MB_OK );
         application.Terminate;
         abort;
      end;
   end;
   if dm.sqlselect( dm.q1, 'select * from tsroles where crol=' + g_q + 'CONSULTA' + g_q ) = false then begin
      if dm.sqlinsert( 'insert into tsroles (crol,descripcion) values(' +
         g_q + 'CONSULTA' + g_q + ',' + g_q + 'CONSULTA' + g_q + ')' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede crear rol CONSULTA' ) ),
            pchar( dm.xlng( 'Revisar versión ' ) ), MB_OK );
         application.Terminate;
         abort;
      end;
   end;

   if dm.sqlselect( dm.q1, 'select * from tsuser where cuser=' + g_q + 'SVS' + g_q ) = false then begin
      if dm.sqlinsert( 'insert into tsuser (cuser,nombre,password) values(' +
         g_q + 'SVS' + g_q + ',' + g_q + 'INSTALADOR' + g_q + ',' + g_q + dm.encripta( 'SVS' ) + g_q + ')' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede crear el usuario SVS (INSTALADOR)' ) ),
            pchar( dm.xlng( 'Revisar versión' ) ), MB_OK );
         application.Terminate;
         abort;
      end;
   end;

   if dm.sqlselect( dm.q1, 'select * from tsroles where crol=' + g_q + 'SVS' + g_q ) = false then begin
      if dm.sqlinsert( 'insert into tsroles (crol,descripcion,mineria) values(' +
         g_q + 'SVS' + g_q + ',' + g_q + 'INSTALADOR' + g_q + ',' + g_q + '1' + g_q + ')' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede crear rol SVS (INSTALADOR' ) ),
            pchar( dm.xlng( 'Revisar versión ' ) ), MB_OK );
         application.Terminate;
         abort;
      end;
   end;

   if dm.sqlselect( dm.q1, 'select * from tsroluser where cuser=' + g_q + 'SVS' + g_q ) = false then begin
      if dm.sqlinsert( 'insert into tsroluser (cuser,crol) values(' +
         g_q + 'SVS' + g_q + ',' + g_q + 'SVS' + g_q + ')' ) = false then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... no puede crear rol SVS (INSTALADOR' ) ),
            pchar( dm.xlng( 'Revisar versión ' ) ), MB_OK );
         application.Terminate;
         abort;
      end;
   end;

   if dm.sqlselect( dm.q1, 'select * from parametro  where clave=' + g_q + 'ROL_SVS' + g_q + ' and secuencia = 1' ) = false then begin
      if dm.sqlinsert( 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
         g_q + 'ROL_SVS' + g_q + ',1,' +
         g_q + dm.encripta( formatdatetime( 'YYYYMMDD', now + 3650 ) ) + g_q + ',' +
         g_q + 'Fecha de caducidad Sys-Mining' + g_q + ')' ) = false then
         dm.aborta( 'ERROR... no puede dar de alta ROL_ en parametro' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Analisis Especificos - Analisis Programas' + g_q +
      ' and crol=' + g_q + 'ADMIN' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Analisis Especificos - Analisis Programas' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Analisis Especificos - Propagacion Variables' + g_q +
      ' and crol=' + g_q + 'ADMIN' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Analisis Especificos - Propagacion Variables' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Analisis Especificos - Analisis Programas' + g_q +
      ' and crol=' + g_q + 'SVS' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Analisis Especificos - Analisis Programas' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Analisis Especificos - Propagacion Variables' + g_q +
      ' and crol=' + g_q + 'SVS' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Analisis Especificos - Propagacion Variables' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + 'Base Conocimiento - Arbol Principal' + g_q +
      ' and crol=' + g_q + 'CONSULTA' + g_q ) = false then begin
      dm.sqlinsert( 'insert into tscapacidad (ccapacidad,crol) values(' +
         g_q + 'Base Conocimiento - Arbol Principal' + g_q + ',' + g_q + 'CONSULTA' + g_q + ')' );
   end;


   if g_version < ver then
      aborta( 'ERROR... La aplicación corresponde a una versión antigua ' + g_version + ' < ' + ver );
   if g_version = ver then   // Aqui es donde lo saca si la version es igual
      exit;
      //   actualiza_version('200901130',ver,'alter table tsclase add icono blob');
   actualiza_version( '200901150', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'CPY' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'Copy COBOL' + g_q + ',' +
      g_q + 'RGMIBM' + g_q + ')' );
   actualiza_version( '200901151', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'UTI' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'Utileria del Sistema' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200901152', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'TAB' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'Tabla Base de Datos' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200901153', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'INS' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'INSERT a Tabla' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200901154', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'UPD' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'UPDATE a Tabla' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200901155', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'DEL' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'Delete a Tabla' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200901156', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'JOB' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'Disparador JOB' + g_q + ',' +
      g_q + 'RGMJCL' + g_q + ')' );
   actualiza_version( '200901157', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'JCL' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'Proc JCL' + g_q + ',' +
      g_q + 'RGMJCL' + g_q + ')' );
   actualiza_version( '200901158', ver, 'drop table tsversion' );
   actualiza_version( '200901158', ver, 'create table tsversion (cprog        varchar(30) NOT NULL,' +
      'cbib        varchar(30) NOT NULL,' +
      'cclase      varchar(10) NOT NULL,' +
      'fecha       date        NOT NULL,' +
      'cuser       varchar(30) NOT NULL,' +
      'cblob       varchar(25)     NULL,' +
      'magic       varchar(30)     NULL) ' );
   actualiza_version( '200901158', ver, 'create index idx_tsversion_cprog on tsversion(cprog,cbib,cclase)' );
   actualiza_version( '200901190', ver, 'alter table tsutileria add fecha date' );
   actualiza_version( '200901191', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'STE' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'Paso de JCL' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200901191', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'REP' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'Reporte' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200901191', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'FIL' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'Archivo de Datos' + g_q + ',' +
      g_q + '' + g_q + ')' );
   //   actualiza_version('200901192',ver,'alter table tsprog modify cprog varchar(50)');
   //   actualiza_version('200901192',ver,'alter table tsrela modify pcprog varchar(50)');
   //   actualiza_version('200901192',ver,'alter table tsrela modify hcprog varchar(50)');
   //   actualiza_version('200901192',ver,'alter table tsversion modify cprog varchar(50)');
   actualiza_version( '200901193', ver, 'drop table tsrela' );
   actualiza_version( '200901193', ver, 'create table tsrela (pcprog        varchar(50) NOT NULL,' +
      'pcbib        varchar(30) NOT NULL,' +
      'pcclase      varchar(10) NOT NULL,' +
      'hcprog        varchar(50) NOT NULL,' +
      'hcbib        varchar(30) NOT NULL,' +
      'hcclase      varchar(10) NOT NULL,' +
      'modo         varchar(10)     NULL,' +
      'organizacion varchar(10)     NULL,' +
      'externo      varchar(50)     NULL,' +
      'coment       varchar(200)    NULL,' +
      'orden        varchar(10)     NULL,' +
      'primary key (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,orden)) ' );
   actualiza_version( '200901193', ver, 'create index idx_tsrela_padre on tsrela(pcprog,pcbib,pcclase)' );
   actualiza_version( '200901193', ver, 'create index idx_tsrela_hijo on tsrela(hcprog,hcbib,hcclase)' );
   actualiza_version( '200901193', ver, 'alter table tsrela add (constraint tsrela_pcclase_fk foreign key (pcclase) ' +
      'references tsclase (cclase) ' +
      'on delete set null)' );
   actualiza_version( '200901193', ver, 'alter table tsrela add (constraint tsrela_hcclase_fk foreign key (hcclase) ' +
      'references tsclase (cclase) ' +
      'on delete set null)' );
   actualiza_version( '200901200', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'REX' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'Script REXX MVS' + g_q + ',' +
      g_q + 'RGMREX' + g_q + ')' );
   actualiza_version( '200901210', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'CTC' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'Tarjeta de Datos' + g_q + ',' +
      g_q + 'RGMCTC' + g_q + ')' );
   actualiza_version( '200902190', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'DPR' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'PROYECTO DELPHI' + g_q + ',' +
      g_q + 'RGMDPR' + g_q + ')' );
   actualiza_version( '200902190', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'DFM' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'FORMA DELPHI' + g_q + ',' +
      g_q + 'RGMDFM' + g_q + ')' );
   actualiza_version( '200902190', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'PAS' + g_q + ',' +
      g_q + 'ANALIZABLE' + g_q + ',' +
      g_q + 'PROGRAMA DELPHI' + g_q + ',' +
      g_q + 'RGMPAS' + g_q + ')' );
   actualiza_version( '200902190', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'DFX' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'OBJETO FORMA DELPHI' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200902190', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + 'DFY' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'RUTINA PROGRAMA DELPHI' + g_q + ',' +
      g_q + '' + g_q + ')' );
   actualiza_version( '200903042', ver, 'create table tsdocum (' +
      ' cprog        varchar(30),' +
      ' cbib         varchar(30),' +
      ' cclase       varchar(10),' +
      ' titulo       varchar(100),' +
      ' fecha        timestamp,' +
      ' tipo         varchar(20),' +
      ' cuser        varchar(30) NOT NULL,' +
      ' cblob        varchar(25)     NULL,' +
      ' magic        varchar(30)     NULL, ' +
      ' primary key (cprog,cbib,cclase,titulo)) ' );

   actualiza_version( '200904095', ver, 'drop table docdocum' );
   if dm.sqlselect( dm.q1, 'select * from tsclase ' +
      ' where cclase=' + g_q + 'BMS' + g_q ) = false then begin
      actualiza_version( '200904095', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
         g_q + 'BMS' + g_q + ',' +
         g_q + 'ANALIZABLE' + g_q + ',' +
         g_q + 'PANTALLA IBM' + g_q + ',' +
         g_q + '' + g_q + ')' );
   end;

   if dm.sqlselect( dm.q1, 'select * from tsclase ' +
      ' where cclase=' + g_q + 'COM' + g_q ) = false then begin
      actualiza_version( '200908112', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
         g_q + 'COM' + g_q + ',' +
         g_q + 'ANALIZABLE' + g_q + ',' +
         g_q + 'MALLA CONTROL M' + g_q + ',' +
         g_q + 'RGMCOM' + g_q + ')' );
   end;
   actualiza_version( '201103071', ver, 'create table tsbfile (' +
      'cprog    VARCHAR2(70),' +
      'cbib      VARCHAR2(50),' +
      'fuente    bfile,' +
      'primary key (cprog,cbib));' );
   actualiza_version( '201103111', ver, 'alter table tsbib add ' +
      'dirprod    varchar(300)' );
   actualiza_version( '201103112', ver, 'alter table tsclase add ' +
      'estructura    varchar(30)' );
   actualiza_version( '201103131', ver, 'alter table tsclase add ' +
      'objeto        varchar(30)' );
   actualiza_version( '201103132', ver, 'update  tsclase set objeto=' +
      g_q + 'FISICO' + g_q );
   actualiza_version( '201103133', ver, 'alter table tsclase add ' +
      'estadoactual        varchar(30)' );
   actualiza_version( '201103134', ver, 'update  tsclase set estadoactual=' +
      g_q + 'ACTIVO' + g_q );
   actualiza_version( '201103271', ver, 'alter table tsbib modify ' +
      'cbib        varchar(250)' );
   actualiza_version( '201103272', ver, 'alter table tsprog modify ' +
      '(cbib         varchar(250),' +
      ' cprog        varchar(250))' );
   actualiza_version( '201103273', ver, 'alter table tsrela modify ' +
      '(pcbib         varchar(250),' +
      ' pcprog        varchar(250),' +
      ' hcbib         varchar(250),' +
      ' hcprog        varchar(250))' );
   actualiza_version( '201103274', ver, 'alter table tsversion modify ' +
      '(cbib         varchar(250),' +
      ' cprog        varchar(250))' );
   actualiza_version( '201103275', ver, 'alter table tsbfile modify ' +
      '(cbib         varchar(250),' +
      ' cprog        varchar(250))' );
   actualiza_version( '201103276', ver, 'alter table tsdocum modify ' +
      '(cbib         varchar(250),' +
      ' cprog        varchar(250))' );
   actualiza_version( '201103277', ver, 'alter table tsparams modify ' +
      '(cbib         varchar(250),' +
      ' cprog        varchar(250))' );
   actualiza_version( '201103278', ver, 'create table tsproperty (' +
      ' cprog        varchar(250) NOT NULL,' +
      ' cbib        varchar(250)  NOT NULL,' +
      ' cclase      varchar(10)  NOT NULL,' +
      ' lineas_total  integer,' +
      ' lineas_blanco  integer,' +
      ' lineas_comentario  integer,' +
      ' lineas_efectivas  integer,' +
      ' num_comandos  integer,' +
      ' primary key (cprog,cbib,cclase)) ' );

   actualiza_version( '201103279', ver, 'alter table tsuserpro modify ' +
      '(cbib         varchar(250),' +
      ' cprog        varchar(250))' );
   // agrega campos de propietario
   actualiza_version( '201105022', ver, 'alter table tsrela add ' +
      '(ocprog        varchar(250),' +
      ' ocbib         varchar(250),' +
      ' occlase       varchar(10))' );
   actualiza_version( '201105031', ver, 'create index idx_tsrela_opcprog' +
      ' on tsrela(ocprog)' );
   actualiza_version( '201105032', ver, 'alter table tsprog add ' +
      'sistema        varchar(30)' );
   actualiza_version( '201107061', ver, 'alter table tsrela add ' +
      'sistema        varchar(30)', false );
   revisa_campo( '201108230', ver, // Por BBVA archivos REPOTRAN,QGDTCCT,KTRAN
      'tsprog', 'archorigen', 'varchar2', 50, 'Y' );
   actualiza_version( '201108231', ver, // por BBVA, COMs de carga inicial
      'insert into tsprog ' +
      '  select distinct pcprog,pcbib,pcclase,' +
      '    to_date(' + g_q + '01/01/09' + g_q + ',' + g_q + 'DD/MM/YY' + g_q + '),' +
      '    NULL,NULL,' + g_q + '1' + g_q + ',' + g_q + '1' + g_q + ',' + g_q + '1' + g_q + ',NULL,sistema ' +
      '    from tsrela ' +
      '    where pcclase=' + g_q + 'COM' + g_q + ' and pcprog not in ' +
      '      (select cprog from tsprog)' );
   actualiza_version( '201108232', ver, // actualizacion de OWNER
      'update tsrela set occlase=pcclase, ocbib=pcbib, ocprog=pcprog ' +
      '  where (pcprog,pcbib,pcclase) in ' +
      '    (select cprog,cbib,cclase from tsprog)' +
      '  and ocprog is null' );
   actualiza_version( '201108233', ver, // actualizacion de OWNER   CLA
      'update tsrela set occlase=hcclase, ocbib=hcbib, ocprog=hcprog ' +
      '    where pcclase=' + g_q + 'CLA' + g_q );
   actualiza_version( '201108234', ver, // actualizacion de OWNER  STE
      'update tsrela a set (ocprog,ocbib,occlase)=' +
      '  (select distinct pcprog, pcbib, pcclase from tsrela b ' +
      '     where a.pcprog=b.hcprog and a.pcbib=b.hcbib and a.pcclase=b.hcclase)' +
      '  where ocprog is null and pcclase=' + g_q + 'STE' + g_q );
   actualiza_version( '201108235', ver, // actualizacion de OWNER  ETP y ITP
      'update tsrela a set (ocprog,ocbib,occlase)=' +
      '  (select distinct pcprog, pcbib, pcclase from tsrela b ' +
      '     where a.pcprog=b.hcprog and a.pcbib=b.hcbib and a.pcclase=b.hcclase and pcclase=' + g_q + 'JAV' + g_q + ')' +
      '  where ocprog is null' );
   actualiza_version( '201108236', ver, // corrección BBVA registros incorrectos
      'delete tsrela where pcclase=' + g_q + 'JCL' + g_q + ' and occlase is null' );
   actualiza_version( '201108237', ver, // corrección BBVA registros incorrectos
      'delete tsrela where pcclase=' + g_q + 'JOB' + g_q + ' and occlase is null' );
   actualiza_version( '201108238', ver, // actualiza sistema de tsprog
      'update tsprog set sistema=(' +
      '  select distinct pcbib from tsrela ' +
      '    where pcclase=' + g_q + 'CLA' + g_q +
      '    and hcprog=cprog and hcbib=cbib and hcclase=cclase)' );
   actualiza_version( '201108239', ver, // actualiza sistema de tsrela
      'update tsrela set sistema=(' +
      '  select sistema from tsprog' +
      '    where ocprog=cprog and ocbib=cbib and occlase=cclase)' );
   revisa_campo( '201108260', ver,
      'parametro', 'clave', 'varchar2', 50, 'N' );
   revisa_campo( '201108261', ver, // BBVA, envio de correos automatico
      'tsuser', 'correo', 'varchar2', 100, 'Y' );
   revisa_campo( '201108262', ver, // BBVA paquete origen
      'tsversion', 'paquete', 'varchar2', 30, 'Y' );
   revisa_campo( '201108293', ver, // BBVA documentacion de parametros.Será general
      'PARAMETRO', 'DESCRIPCION', 'VARCHAR2', 500, 'Y' );
   actualiza_version( '201109121', ver, 'alter table tssistema add ' +
      'estadoactual        varchar(30)', false );
   actualiza_version( '201109122', ver, // actualiza estadoactual de tssistema
      'update tssistema set estadoactual=' + g_q + 'ACTIVO' + g_q );
   actualiza_version( '201202212', ver, 'create table tsattribute (' +
      ' ocprog        varchar(250) NOT NULL,' +
      ' ocbib        varchar(250)  NOT NULL,' +
      ' occlase      varchar(10)  NOT NULL,' +
      ' cprog        varchar(250) NOT NULL,' +
      ' cbib        varchar(250)  NOT NULL,' +
      ' cclase      varchar(10)  NOT NULL,' +
      ' indice      integer,' +
      ' atributos   varchar(4000),' +
      ' primary key (cprog,cbib,cclase,indice)) ' );

   actualiza_version( '201205021', ver, 'drop table tslogon' );
   actualiza_version( '201205022', ver, 'create table tslogon (' +
      'cuser            varchar(30) NOT NULL,' +
      'fecha_entrada    date   NOT NULL,' +
      'fecha_salida     date    ,' +
      'control_tiempo   date    ,' +
      'primary key (cuser,fecha_entrada))' );
   actualiza_version( '201205023', ver, 'insert into PARAMETRO (clave,secuencia,dato,descripcion) values(' +
      g_q + 'NUMUSU' + g_q + ',1,' + g_q + '100' + g_q + ',' + g_q + 'Numero de usuarios permitidos' + g_q + ')' );

   {   actualiza_version('201205081',ver,'insert into tscapacidad (ccapacidad, crol) values('+
         g_q+'Administracion Caducidad'+g_q+','+ g_q+'ADMIN'+g_q+')'); }

   actualiza_version( '201205082', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Administracion Monitoreo' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );
   actualiza_version( '201205171', ver, 'update parametro set dato=' + g_q + g_version_tit + g_q +
      ' where clave=' + g_q + 'VERSIONSHD' + g_q );

   actualiza_version( '201206131', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'ROL_ADMIN' + g_q + ',1,' +
      g_q + dm.encripta( formatdatetime( 'YYYYMMDD', now + 3650 ) ) + g_q + ',' +
      g_q + '' + g_q + ')' );

   actualiza_version( '201206211', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'TIEMPO_ESPERA_TSSOLVER' + g_q + ',1,' +
      g_q + '1000' + g_q + ',' +
      g_q + 'Tiempo de espera para Tssolver' + g_q + ')' );

   actualiza_version( '201206212', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'TIEMPO_ENVIA' + g_q + ',1,' +
      g_q + '2800' + g_q + ',' +
      g_q + 'Tiempo envia' + g_q + ')' );

   actualiza_version( '201207170', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'ROL_SVS' + g_q + ',1,' +
      g_q + dm.encripta( formatdatetime( 'YYYYMMDD', now + 3650 ) ) + g_q + ',' +
      g_q + 'Fecha de caducidad Sys-Mining' + g_q + ')' );

   ////////Da de alta las capacidades de SVS

   actualiza_version( '201207172', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'cambio de password (todos)' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '201207173', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Parametros' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '201207174', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Roles' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '201207175', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Usuarios' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '201207176', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Capacidades' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '201207177', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Asigna Rol a Usuario' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '201207178', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Menu Principal Sys-Mining' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '201207179', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Administracion Caducidad' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '2012071710', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Administracion Monitoreo' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   actualiza_version( '2012071711', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Mining - Inventario' + g_q + ',' + g_q + 'SVS' + g_q + ')' );
   ////////
   actualiza_version( '2012071712', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'LIBSINFTES' + g_q + ',1,' +
      g_q + 'MEXCCT' + g_q + ',' +
      g_q + 'Lista de librerias que no tienen fuentes' + g_q + ')' );
   actualiza_version( '2012091401', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'BLOB_SIZE' + g_q + ',1,' +
      g_q + '1024' + g_q + ',' +
      g_q + 'Tamaño del buffer ' + g_q + ')' );

   if dm.sqlselect( dm.q1, 'SELECT TABLE_NAME FROM USER_TAB_COLUMNS WHERE COLUMN_NAME=' + g_q + 'DIAGRAMABLOQUE' + g_q ) = false then
      actualiza_version( '2013040202', ver, 'alter table tsclase add ' + 'diagramabloque  varchar(10) NULL' );

   actualiza_version( '2013040202', ver, 'update  tsclase set diagramabloque=' +
      g_q + 'ACTIVO' + g_q + ' where objeto = ' + g_q + 'FISICO' + g_q );

   actualiza_version( '2013040202', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Administracion Limpia Inventario' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );

   actualiza_version( '2013040202', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Administracion Limpia Inventario' + g_q + ',' + g_q + 'SVS' + g_q + ')' );

   actualiza_version( '2013041601', ver, 'INSERT INTO PARAMETRO SELECT ' + g_q +
      'W' + g_q + '||CLAVE, SECUENCIA, ' + g_q + '$' + g_q +
      '||SUBSTR(DATO,2,7), DESCRIPCION FROM PARAMETRO WHERE CLAVE LIKE ' +
      g_q + 'COLOR_%' + g_q );

   if dm.sqlselect( dm.q1, 'select table_name from user_tab_columns where column_name=' + g_q + 'BUSQUEDASELECT' + g_q ) = false then
      actualiza_version( '2013053001', ver, 'alter table tsclase add ' +
         'busquedaselect        varchar(10) NULL' );

   actualiza_version( '2013061801', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'ARBOLDESCRIPCION' + g_q + ',0,' +
      g_q + '0' + g_q + ',' +
      g_q + '1 = En el árbol pinta la clase, la biblioteca y el nombre del componentes, 0 = pinta solo nombre componente ' + g_q + ')' );

   if dm.sqlselect( dm.q1, 'select table_name from user_tab_columns where column_name=' + g_q + 'MODOCARACTERES' + g_q ) = false then
      actualiza_version( '2013073101', ver, 'alter table tsclase add ' +
         '(modocaracteres        varchar(10),' +
         ' caracterespermitidos  varchar(20),' +
         ' modoactualizacion     varchar(10))' );

   actualiza_version( '2013073102', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Crea Indices' + g_q + ',' + g_q + 'ADMIN' + g_q + ')' );

   actualiza_version( '2013073103', ver, 'insert into tscapacidad (ccapacidad, crol) values(' +
      g_q + 'Crea Indices' + g_q + ',' + g_q + 'SVS' + g_q + ')' );

   {  if dm.sqlselect( dm.q1, 'select * from user_tables where table_name='+ g_q + 'TSBIBCLA' + g_q ) = FALSE then begin
        actualiza_version( '2013091701', ver, 'create table tsbibcla '+ '(cbib varchar2(250) not null,'+
           'cclase varchar2(50) not null,'+'oracledir varchar2(50) not null,'+ 'ip varchar2(200),'+
           'path varchar2(200),'+ 'dirprod varchar2(300),'+ 'primary key (cbib,cclase))');
        dm.activa_tsbibcla;
     end;
    }

   if dm.sqlselect( dm.q1, 'select table_name from user_tab_columns where column_name=' + g_q + 'BIBOBJ' + g_q ) = false then
      actualiza_version( '2013091901', ver, 'alter table tsbib add ' + ' bibobj  varchar2(250) NULL' );

   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TSBIBCLA' + g_q ) then begin
      actualiza_version( '2013092001', ver, 'drop table tsbibcla' );
      actualiza_version( '2013092002', ver, 'create table tsbibcla ' +
         '(cbib varchar2(250) not null,' +
         'cclase varchar2(50) not null,' +
         'oracledir varchar2(50) not null,' +
         'ip varchar2(200),' +
         'path varchar2(200),' +
         'dirprod varchar2(300),' +
         'primary key (cbib,cclase))' );
      dm.activa_tsbibcla;
   end
   else begin
      actualiza_version( '2013092002', ver, 'create table tsbibcla ' +
         '(cbib varchar2(250) not null,' +
         'cclase varchar2(50) not null,' +
         'oracledir varchar2(50) not null,' +
         'ip varchar2(200),' +
         'path varchar2(200),' +
         'dirprod varchar2(300),' +
         'primary key (cbib,cclase))' );
      dm.activa_tsbibcla;
   end;

   actualiza_version( '2013102901', ver, 'alter table tsrela add ' +
      'atributos        varchar(4000)' );

   actualiza_version( '2013110701', ver, 'alter table tsrela add ' +
      '(lineainicio       integer, ' +
      ' lineafinal        integer, ' +
      ' ambito            varchar2(10), ' +
      ' icprog       varchar2(250)  NULL,' +
      ' icbib        varchar2(250)  NULL,' +
      ' icclase      varchar2(10)   NULL,' +
      ' polimorfismo varchar2(500)  NULL)' );

   actualiza_version( '2013111901', ver, 'create table tsproductos ' +
      '(cuser varchar2(50) not null,' +
      'ccapacidad varchar2(50) not null,' +
      'cclaseprod varchar2(300),' +
      'primary key (cuser,ccapacidad))' );

   actualiza_version( '2013111902', ver, 'insert into parametro (clave,secuencia,dato,descripcion) values(' +
      g_q + 'CLASESXPRODUCTO' + g_q + ',0,' +
      g_q + 'TRUE' + g_q + ',' +
      g_q + 'Lista de clases a reportar por producto.' + g_q + ')' );

   actualiza_version( '2013120400', ver, 'alter table tsprog drop primary key' );

   actualiza_version( '2013120401', ver, 'alter table tsprog add primary key(cprog,cbib,cclase)' );
   actualiza_version( '2013122601', ver, 'alter table parametro modify clave varchar2(100)' );

   //----  Crear tablas para la administración de documentos.
   actualiza_version( '2014010800', ver, 'CREATE TABLE TSDOCUMENTO(' +
      ' IDDOCTO NUMBER(9) NOT NULL ,' + // PK
      ' NOMBRE VARCHAR2(100) NOT NULL,' + // IDX1 UNIQUE
      ' EXTENSION VARCHAR2(20) NULL,' +
      ' FECHA_ALTA DATE DEFAULT SYSDATE NOT NULL,' +
      ' USUARIO_ALTA VARCHAR2(50) NOT NULL,' +
      ' CPROG VARCHAR2(250) NOT NULL,' + // IDX1 UNIQUE
      ' CBIB VARCHAR2(250) NOT NULL,' + // IDX1 UNIQUE
      ' CCLASE VARCHAR2(10) NOT NULL,' + // IDX1 UNIQUE
      ' DESCRIPCION VARCHAR2(500) NULL,' +
      ' ESTATUS CHAR(1) DEFAULT ' + g_q + 'L' + g_q + 'NOT NULL,' + // L-libre; O-ocupado; E-eliminado
      ' FECHA_ESTATUS DATE NULL,' +
      ' USUARIO_ESTATUS VARCHAR2(50) NULL' +
      ' )' );

   actualiza_version( '2014010801', ver, 'ALTER TABLE TSDOCUMENTO ADD ' +
      ' CONSTRAINT C_TSDOCUMENTO_K PRIMARY KEY ( IDDOCTO )' );

   actualiza_version( '2014010802', ver, 'CREATE UNIQUE INDEX TSDOCUMENTO_IDX01 ON ' +
      ' TSDOCUMENTO( NOMBRE, CPROG, CBIB, CCLASE )' );

   actualiza_version( '2014010802', ver, 'CREATE TABLE TSDOCREVISION( ' +
      'IDDOCTO NUMBER(9) NOT NULL, ' + // PK, FK
      'IDREVISION NUMBER(9) NOT NULL, ' + // PK // incremental por IDDOCTO
      'USUARIO_REV VARCHAR2(50) NOT NULL, ' + // FK
      'ACTIVO CHAR(1) DEFAULT ' + g_q + 'N' + g_q + ' NOT NULL, ' + // S-si; N-no
      'FECHA_INICIO DATE NULL, ' +
      'FECHA_FIN DATE NULL ) ' );

   actualiza_version( '2014010803', ver, 'ALTER TABLE TSDOCREVISION ADD ' +
      'CONSTRAINT C_TSDOCREVISION_K PRIMARY KEY ( IDDOCTO,IDREVISION )' );

   actualiza_version( '2014010804', ver, 'ALTER TABLE TSDOCREVISION ADD ' +
      'CONSTRAINT C_TSDOCREVISION_K1 FOREIGN KEY ( IDDOCTO ) REFERENCES TSDOCUMENTO ( IDDOCTO )' );

   actualiza_version( '2014010805', ver, 'CREATE TABLE TSDOCBLOB( ' +
      'IDDOCTO NUMBER(9) NOT NULL, ' + // PK, FK
      'IDREVISION NUMBER(9) NOT NULL, ' + // PK // incremental por IDDOCTO
      'TAMNORMAL NUMBER(9) NULL, ' + // tamaño normal en bytes
      'TAMCRC NUMBER(9) NULL, ' + // tamaño comprimido (rar) en bytes
      'ARCHIVO BLOB NOT NULL )' );

   actualiza_version( '2014010806', ver, 'ALTER TABLE TSDOCBLOB ADD  ' +
      'CONSTRAINT C_TSDOCBLOB_K PRIMARY KEY ( IDDOCTO, IDREVISION )' );

   actualiza_version( '2014010807', ver, 'ALTER TABLE TSDOCBLOB ADD  ' +
      'CONSTRAINT C_TSDOCBLOB_K1 FOREIGN KEY  ( ' +
      'IDDOCTO, ' +
      'IDREVISION  ' +
      ') REFERENCES TSDOCREVISION ( ' +
      'IDDOCTO, ' +
      'IDREVISION )' );
   //-----FIN   Crear tablas para la administración de documentos.

   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TSSEARCH' + g_q ) then begin
      actualiza_version( '2014010808', ver, 'drop table tssearch' );
   end;
   actualiza_version( '2014012300', ver, 'delete from tsproductos ' );

   actualiza_version( '2014012301', ver, 'alter table tsrela add ' +
      'Xcclase         varchar2(250) NULL' );

   actualiza_version( '2014013100', ver, 'CREATE TABLE TSLOG( ' +
      'cprog       varchar2(250) not null, ' +
      'cbib        varchar2(250) not null, ' +
      'cclase      varchar2(50) not null,  ' +
      'proceso     varchar2(50) not null,  ' +
      'fecha       date not null,  ' +
      'rutina      varchar2(50) null, ' +
      'clave       varchar2(10) null, ' +
      'descripcion varchar2(500) null, ' +
      'estado      varchar2(10) null,  ' +
      'fechaact    date null,          ' +
      'cuser       varchar2(50) null)' );

   actualiza_version( '2014013101', ver, 'ALTER TABLE TSLOG ADD ' +
      'CONSTRAINT C_TSLOG_K PRIMARY KEY ( cprog,cbib,cclase,proceso,fecha )' );

   actualiza_version( '2014021001', ver, 'insert into tsclase (cclase,tipo,descripcion,analizador) values(' +
      g_q + '*' + g_q + ',' +
      g_q + 'NO ANALIZABLE' + g_q + ',' +
      g_q + 'TODAS LAS CLASES ' + g_q + ',' +
      g_q + '' + g_q + ')' );

   actualiza_version( '2014021900', ver, 'alter table tsrela add ' +
      'auxiliar   varchar2(100) NULL' );

   actualiza_version( '2014030300', ver, 'create table tscarga( ' +
      'coficina         varchar2(30) not null, ' +
      'csistema         varchar2(30) not null, ' +
      'cclase           varchar2(50) not null, ' +
      'cbib             varchar2(250) not null, ' +
      'cruta            varchar2(250) not null, ' +
      'activo                 char(1) null, ' +
      'incluye_subdirectorios char(1) null, ' +
      'omite_existentes       char(1) null, ' +
      'analiza_fuente         char(1) null, ' +
      'conserva_extension     char(1) null, ' +
      'revisa_versiones       char(1) null, ' +
      'verifica_clase         char(1) null, ' +
      'nombre_version         char(1) null, ' +
      'procesa_parametros_job char(1) null, ' +
      'parametros_adicionales char(1) null, ' +
      'parametros             varchar2(250) null, ' +
      'mascara                varchar2(50) null, ' +
      'nombre_componente      integer null, ' +
      'estadoactual           varchar2(30) null, ' +
      'primary key(coficina,csistema,cclase,cbib,cruta))' );

   actualiza_version( '2014030500', ver, 'alter table tsrela add( ' +
      'hsistema          varchar2(30) NULL, ' +
      'hparametros       varchar2(250) NULL, ' +
      'hinterfase        varchar2(30) NULL ) ' );

   actualiza_version( '2014031900', ver, 'alter table tsrela modify hparametros varchar(500)' );

   if dm.sqlselect( dm.q1, 'SELECT * FROM ALL_CONSTRAINTS WHERE upper(OWNER) = upper(' +
      g_q + g_user_procesa + g_q + ')' + //aplica solo cuando el usuario y el schema es el mismo
      ' AND CONSTRAINT_TYPE = ' + g_q + 'P' + g_q +
      ' AND upper(TABLE_NAME) = upper(' + g_q + 'TSRELA' + g_q + ')' ) then
      actualiza_version( '2014040800', ver, 'ALTER TABLE TSRELA DROP CONSTRAINT  ' +
         dm.q1.fieldbyname( 'CONSTRAINT_NAME' ).AsString );

   actualiza_version( '2014040801', ver, 'ALTER TABLE TSRELA ADD CONSTRAINT TSRELA_PRIMARY_KEY ' +
      ' PRIMARY KEY( PCPROG, PCBIB, PCCLASE, HCPROG, HCBIB, HCCLASE, ORDEN, OCPROG )' );

   actualiza_version( '2014040802', ver, 'alter table tsrela modify hinterfase varchar(100)' );

   actualiza_version( '2014062401', ver, 'alter table tscarga add (  copys  char(1),' +
      ' reemplazacadena  char(1), reemplaza1  varchar2(50), reemplaza2 varchar2(50))' );

   actualiza_version( '2014062402', ver, 'INSERT INTO PARAMETRO ( CLAVE, SECUENCIA, DATO ) VALUES ( ' +
      g_q + 'LENG_VISUSTIN_DGR_CPY' + g_q + ', 1, ' + g_q + '' + g_q + ' )' );

   actualiza_version( '2014062403', ver, 'INSERT INTO PARAMETRO ( CLAVE, SECUENCIA, DATO ) VALUES (' +
      g_q + 'LENG_VISUSTIN_DGR_CPY' + g_q + ', 1, ' + g_q + '' + g_q + ')' );

   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'INVENTARIO_TOTAL_TMP' + g_q ) = FALSE then begin
      actualiza_version( '2014063000', ver, ' CREATE TABLE INVENTARIO_TOTAL_TMP (' +
         ' SISTEMA          VARCHAR2(100), ' +
         ' DESC_SISTEMA     VARCHAR2(100), ' +
         ' CLASE            VARCHAR2(100), ' +
         ' BIBLIOTECA       VARCHAR2(250), ' +
         ' PIEZA            VARCHAR2(250), ' +
         ' OTRO_SISTEMA     VARCHAR2(100), ' +
         ' UNYSIS_LIBRARY   VARCHAR2(100), ' +
         ' TIPO_COMPONENTE  VARCHAR2(50),  ' +
         ' TIPO_INVENTARIO  VARCHAR2(50)  ' + ') ' );
    end;

    actualiza_version( '2014102100', ver, 'ALTER TABLE TSPROG ADD CONSTRAINT TSSISTEMA_TSPROG_FK ' +
        ' FOREIGN KEY( SISTEMA )' + ' references tssistema (csistema)' );
    actualiza_version( '2014102801', ver, 'alter table tsrela drop primary key');
    actualiza_version( '2014102802', ver, 'drop index TSRELA_PRIMARY_KEY');
    actualiza_version( '2014102803', ver, 'alter table tsrela add primary key '+
        '(pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,orden,ocprog,ocbib,occlase)');
    actualiza_version( '2014102804', ver, 'alter table tsrela modify hparametros varchar2(1500)' );


      {
       if dm.sqlupdate('update parametro set dato='+g_q+g_version_tit+g_q+
          ' where clave='+g_q+'VERSIONSHD'+g_q)=false then
          aborta('ERROR... no puede actualizar el titulo de version');
       }


   // ------------ ALK para las tablas de complejidad de Carlos  ------------------
   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TS_RIESGO' + g_q) = FALSE then begin
       actualiza_version( '2015072700', ver, 'CREATE TABLE TS_RIESGO  (' +
          ' CCLASE VARCHAR2(10),  ' +
          ' VALOR_MAXIMO NUMBER(9,0),  ' +
          ' EVALUACION_RIESGO VARCHAR2(100)' + ' ) ');
    end;

   if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TS_DETA_COMPLEJ' + g_q) = FALSE then begin
      actualiza_version( '2015072701', ver,'CREATE TABLE TS_DETA_COMPLEJ  (' +
          '	CCLASE VARCHAR2(10),  ' +
       	 ' CBIB VARCHAR2(250),  ' +
	       ' CPROG VARCHAR2(250),  ' +
	       ' SISTEMA VARCHAR2(30),  ' +
	       ' RUTINA VARCHAR2(50),  ' +
	       ' N_OPERADORES NUMBER(9,0),  ' +
	       ' N_OPERADORES_U NUMBER(9,0),  ' +
	       ' N_OPERANDOS NUMBER(9,0),  ' +
	       ' N_OPERANDOS_U NUMBER(9,0)) ');

    end;

    if dm.sqlselect( dm.q1, 'select * from user_tables where table_name=' + g_q + 'TS_ESTAD_COMPLEJ' + g_q) = FALSE then begin
       actualiza_version( '2015072702', ver,'CREATE TABLE TS_ESTAD_COMPLEJ  (' +
          ' CCLASE VARCHAR2(10),  ' +
          ' CBIB VARCHAR2(250),  ' +
          ' CPROG VARCHAR2(250),  ' +
          ' SISTEMA VARCHAR2(30),  ' +
          ' N_OPERADORES NUMBER(9,0),  ' +
          ' N_OPERADORES_U NUMBER(9,0),  ' +
          ' N_OPERANDOS NUMBER(9,0),  ' +
          ' N_OPERANDOS_U NUMBER(9,0),  ' +
          ' VOCABULARIO NUMBER(11,2),  ' +
          ' LONGITUD NUMBER(11,2),  ' +
          ' DURACION NUMBER(11,2),  ' +
          ' VOLUMEN NUMBER(11,2),  ' +
          ' DIFICULTAD NUMBER(11,2),  ' +
          ' ESFUERZO NUMBER(11,2),  ' +
          ' TIEMPO NUMBER(11,2),  ' +
          ' ERRORES NUMBER(11,2)) ');
    end;
    actualiza_version( '2015072800', ver,'alter table TS_DETA_COMPLEJ ' +
                          ' add ( N_NODOS NUMBER(9,0),  ' +
                          ' N_ARISTAS NUMBER(9,0),  ' +
	                       ' N_RESULTADO NUMBER(9,0) ' + ') ');

    actualiza_version( '2015072801', ver,'alter table TS_ESTAD_COMPLEJ ' +
                          ' add ( N_NODOS NUMBER(9,0),  ' +
                          ' N_ARISTAS NUMBER(9,0),  ' +
	                       ' N_RESULTADO NUMBER(9,0) ' + ') ');

    actualiza_version( '2015072900', ver, 'alter table TS_RIESGO modify' +
          ' EVALUACION_RIESGO VARCHAR2(100)');
    actualiza_version( '2015072901', ver, 'alter table TS_RIESGO add (' +
          ' VALOR_MINIMO NUMBER(9,0)) ');
    // ------------- fin ALK para calculo de complejidad -------------

    actualiza_version( '2015080500', ver, 'alter table TSCLASE add (' +
          ' COMPLEJIDAD VARCHAR2(10)) ');

    actualiza_version( '2015080600', ver, 'alter table TS_RIESGO drop (' +
          ' VALOR_MAXIMO)');
    actualiza_version( '2015080601', ver, 'alter table TS_RIESGO add (' +
          ' VALOR_MAXIMO NUMBER(9,0))');

    actualiza_version( '2015080700', ver, 'alter table TSPROG add (' +
          ' NOMBFILE VARCHAR(300))');

    actualiza_version( '2015081200', ver, 'alter table tsdocumento modify ('+
          'estatus CHAR(1 BYTE) default '+ g_q + 'D' + g_q +')');

    actualiza_version( '2015081900', ver, 'alter table tsdocumento add ('+
          'ruta VARCHAR(300))');

    actualiza_version( '2015082400', ver, 'alter table tsdocrevision modify ('+
          'activo CHAR(1 BYTE) default '+ g_q + 'E' + g_q +')');

    actualiza_version( '2016042600', ver, 'alter table tsprog add ('+
          'descri VARCHAR2(100))');

    actualiza_version( '2016050400', ver, 'delete TS_ESTAD_COMPLEJ');
    actualiza_version( '2016050401', ver, 'alter table TS_ESTAD_COMPLEJ MODIFY (ERRORES NUMBER(11,3))');

    //----------------     PROPAGACION DE VARIABLES  RGM    ---------------------
    if uppercase(g_user_procesa)<>'SOMS12' then begin
       actualiza_version('2016072001',ver,
         'CREATE TABLE TSVARCBL ( '+
            'CPROG VARCHAR2(250) NOT NULL, '+
            'CBIB VARCHAR2(250) NOT NULL, '+
           'CCLASE VARCHAR2(10) NOT NULL, '+
            'CREG VARCHAR2(50) NOT NULL, '+
            'CCAMPO VARCHAR2(150) NOT NULL, '+
            'NIVEL INTEGER, '+
            'PICTURE VARCHAR2(50), '+
            'USAGE VARCHAR2(20), '+
            'VALUE VARCHAR2(500), '+
            'LINEA INTEGER, '+
            'LONGITUD INTEGER, '+
            'INICIAL INTEGER, '+
            'OCCURS INTEGER, '+
            'TEXTO VARCHAR2(250), '+
            '  PRIMARY KEY (CPROG, CBIB, CCLASE, CREG, CCAMPO) '+
            ') STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645) ');
       actualiza_version('2016072002',ver,'CREATE INDEX I_VARCBL2 ON TSVARCBL (CPROG, CREG, CBIB, NIVEL)');
       actualiza_version('2016072003',ver,'CREATE INDEX IDX_TSVARCBL_RECORD ON TSVARCBL (CREG, CCAMPO)');
       actualiza_version('2016072004',ver,
          'CREATE TABLE TSRELAVCBL ( '+
            'PCPROG VARCHAR2(250) NOT NULL, '+
            'PCBIB VARCHAR2(250) NOT NULL, '+
            'PCCLASE VARCHAR2(10) NOT NULL, '+
            'PCREG VARCHAR2(50) NOT NULL, '+
            'PCCAMPO VARCHAR2(150) NOT NULL, '+
            'HCPROG VARCHAR2(250) NOT NULL, '+
            'HCBIB VARCHAR2(250) NOT NULL, '+
            'HCCLASE VARCHAR2(10) NOT NULL, '+
            'HCREG VARCHAR2(50) NOT NULL, '+
            'HCCAMPO VARCHAR2(150) NOT NULL, '+
            'LINEA INTEGER, '+
            'MODO VARCHAR2(10), '+
            'TEXTO VARCHAR2(250), '+
            'COMANDO VARCHAR2(2500), '+
            'OCPROG VARCHAR2(250) NOT NULL, '+
            'OCBIB VARCHAR2(250) NOT NULL, '+
            'OCCLASE VARCHAR2(10) NOT NULL, '+
            '  PRIMARY KEY (PCPROG,PCBIB,PCCLASE,PCREG,PCCAMPO,HCPROG,HCBIB,HCCLASE,HCREG,HCCAMPO) '+
            ') STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645) ');
       actualiza_version('2016072005',ver,'CREATE INDEX IDX_TSRELAVCBLP ON TSRELAVCBL (PCPROG, PCBIB, PCCLASE, PCREG, PCCAMPO)');
       actualiza_version('2016072006',ver,'CREATE INDEX IDX_TSRELAVCBLH ON TSRELAVCBL (HCPROG, HCBIB, HCCLASE, HCREG, HCCAMPO)');
       actualiza_version('2016072007',ver,'CREATE INDEX IDX_TSRELAVCBL_OWNER ON TSRELAVCBL (OCPROG, OCBIB, OCCLASE)');
       actualiza_version('2016072008',ver,
          'CREATE TABLE TSMAESTRA ( '+
            'CPROG VARCHAR2(250) NOT NULL, '+
            'CBIB VARCHAR2(250) NOT NULL, '+
            'CCLASE VARCHAR2(10) NOT NULL, '+
            'CREG VARCHAR2(50) NOT NULL, '+
            'CCAMPO VARCHAR2(50) NOT NULL, '+
            'ESTADO VARCHAR2(10), '+
            'FECHA DATE, '+
            'INTERFAZ VARCHAR2(2), '+
           'PRIMARY KEY (CPROG, CBIB, CCLASE, CREG, CCAMPO))');
       actualiza_version('2016072009',ver,
           'CREATE TABLE TSAFECTA ( '+
            'CPROG VARCHAR2(250) NOT NULL, '+
            'CBIB VARCHAR2(250) NOT NULL, '+
            'CCLASE VARCHAR2(10) NOT NULL, '+
            'CREG VARCHAR2(50) NOT NULL, '+
            'CCAMPO VARCHAR2(50) NOT NULL, '+
            'PCPROG VARCHAR2(250) NOT NULL, '+
            'PCBIB VARCHAR2(250) NOT NULL, '+
            'PCCLASE VARCHAR2(10) NOT NULL, '+
            'HCPROG VARCHAR2(250) NOT NULL, '+
            'HCBIB VARCHAR2(250) NOT NULL, '+
            'HCCLASE VARCHAR2(10) NOT NULL, '+
            'MODO VARCHAR2(10), '+
            'FECHA DATE, '+
            'UTILERIA VARCHAR2(10), '+
            'ESTADO VARCHAR2(10), '+
            'TCPROG VARCHAR2(250) NOT NULL, '+
            'TCBIB VARCHAR2(250) NOT NULL, '+
            'TCCLASE VARCHAR2(10) NOT NULL, '+
            'OCPROG VARCHAR2(250) NOT NULL, '+
            'OCBIB VARCHAR2(250) NOT NULL, '+
            'OCCLASE VARCHAR2(10) NOT NULL, '+
            'LOGICO VARCHAR2(50), '+
            'ACPROG VARCHAR2(250), '+
            'ACBIB VARCHAR2(250), '+
            'ACCLASE VARCHAR2(10), '+
            'ACREG VARCHAR2(50), '+
            'ACCAMPO VARCHAR2(50), '+
           'PRIMARY KEY (CPROG, CBIB, CCLASE, CREG, CCAMPO, '+
             'PCPROG, PCBIB, PCCLASE, HCPROG, HCBIB, HCCLASE,  '+
             'TCPROG, TCBIB, TCCLASE, '+
             'ACPROG, ACBIB, ACCLASE, ACREG, ACCAMPO))');
       actualiza_version('2016072010',ver,'CREATE INDEX I_AFECTA1 ON TSAFECTA (CCLASE, OCPROG, OCBIB, OCCLASE, CREG, CCAMPO)');
       actualiza_version('2016072011',ver,'CREATE INDEX IDX_TSAFECTA_OWNER ON TSAFECTA (OCPROG, OCBIB, OCCLASE)');
       actualiza_version('2016072901',ver,
         'CREATE TABLE TSARRANCA '+
         '(	CPROG VARCHAR2(250) NOT NULL, '+
         'CBIB VARCHAR2(250) NOT NULL, '+
         'CCLASE VARCHAR2(10) NOT NULL, '+
         'CREG VARCHAR2(50) NOT NULL, '+
         'CCAMPO VARCHAR2(50) NOT NULL, '+
         'ESTADO VARCHAR2(10), '+
         'FECHA DATE, '+
         'INTERFAZ VARCHAR2(2) '+
         ')');
    end;
    actualiza_version('2016102000',ver,
      'CREATE TABLE TSVALESTATICA '+
      '(CLASE       VARCHAR2(10) NOT NULL, '+
      ' REGLA       INTEGER NOT NULL, '+
      ' MENSAJE     VARCHAR2(200), '+
      ' GRADO       VARCHAR2(20), '+
      ' ESTADO      VARCHAR2(8), '+
      ' TIPO        VARCHAR2(20), '+
      ' DESCRIPCION VARCHAR2(2500), '+
      ' PRIMARY KEY (REGLA))');
end;

procedure Tdm.aborta( mensaje: string );
begin
   g_log.SaveToFile( g_tmpdir + '\sysviewlog' + formatdatetime( 'YYYYMMDD-HHNNSS', now ) + '.txt' );
   application.MessageBox( pchar( mensaje ), 'ERROR', MB_OK );
   application.Terminate;
   abort;
end;

function Tdm.desencripta( dato: string ): string;
var
   k, i, j, v: integer;
   v1, v2: integer;
   paso: string;
   llave: string;
begin
   dato := stringreplace( dato, '<QUOTAS>', g_q, [ rfReplaceAll ] );
   j := ord( dato[ length( dato ) ] ) - 32;
   llave := 'SECRETARIADEEDUCACIONPUBLICA';
   for v := length( dato ) - 1 downto 1 do begin
      i := length( dato ) - v;
      v1 := ord( dato[ i ] );
      v2 := ord( llave[ ( v + j ) mod length( llave ) + 1 ] );
      k := v1 - v2 - 16;
      paso := chr( k ) + paso;
   end;
   desencripta := paso;
end;

function Tdm.encripta( dato: string ): string;
var
   k, i, j: integer;
   v1, v2: integer;
   paso: string;
   llave: string;
begin
   j := 0;
   llave := 'SECRETARIADEEDUCACIONPUBLICA';
   for i := 1 to length( dato ) do
      j := j + ord( dato[ i ] );
   j := j mod length( llave ) + 1;
   for i := length( dato ) downto 1 do begin
      v1 := ord( dato[ i ] );
      v2 := ord( llave[ ( i + j ) mod length( llave ) + 1 ] );
      k := v1 + v2 + 16;
      paso := paso + chr( k );
   end;
   paso := paso + chr( j + 32 );
   paso := stringreplace( paso, g_q, '<QUOTAS>', [ rfReplaceAll ] );
   encripta := paso;
end;

procedure Tdm.feed_combo( combo: tcombobox; sele: string );
begin
   combo.clear;
   if sqlselect( DM.qmodify, sele ) then begin
      while not DM.qmodify.Eof do begin
         combo.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
end;

procedure Tdm.feed_combo1( combo: tcombobox; sele: string );
begin
   combo.clear;
   //combo.Items.Add( '-Todos los valores-' );
   combo.Items.Add( 'TODAS LAS CLASES' );
   if sqlselect( DM.qmodify, sele ) then begin
      while not DM.qmodify.Eof do begin
         if DM.qmodify.FieldCount > 0 then
            combo.Items.Add( DM.qmodify.fields[ 0 ].asstring + '  -  ' + DM.qmodify.fields[ 1 ].asstring )
         else
            combo.Items.Add( DM.qmodify.fields[ 0 ].asstring );
         DM.qmodify.Next;
      end;
   end;
end;

{
procedure Tdm.feed_combo1( combo: tcombobox; sele: string );
var
   wClaseDescrip: string;
begin
   combo.clear;
   if sqlselect( DM.qmodify, sele ) then begin
      combo.Items.Add( '-Todas las clases -' );
      while not dm.qmodify.Eof do begin
         if dm.sqlselect( dm.q1, 'select descripcion from tsclase' +
            ' where cclase = ' + g_q + DM.qmodify.fields[ 0 ].asstring + g_q ) then
            wClaseDescrip := DM.qmodify.fields[ 0 ].asstring + '      ' + dm.q1.fieldbyname( 'descripcion' ).AsString
         else
            wClaseDescrip := DM.qmodify.fields[ 0 ].asstring + '      CLASE SIN DESCRIPCION O NO EXISTE EN CATALOGO DE CLASES ';

         combo.Items.Add( wClaseDescrip );
         dm.qmodify.Next;
      end;
   end;
end;
}

procedure Tdm.feed_combo2( combo: tcombobox; sele: string );
var
   qConsulta: TAdoQuery;
begin
   qConsulta := TAdoQuery.Create( nil );
   try
      qConsulta.Connection := dm.ADOConnection1;
      combo.clear;
      if sqlselect( qConsulta, sele ) then begin
         while not qConsulta.Eof do begin
            combo.Items.Add( DM.qmodify.fields[ 0 ].asstring );
            qConsulta.Next;
         end;
      end;
   finally
      qConsulta.Free;
   end;
end;

function Tdm.sqlinsert( sele: string ): boolean;
begin
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;

   if g_database = 'SYBASE' then begin
      if pos( 'constraint', sele ) > 0 then begin
         sqlinsert := true;
         exit;
      end;
      sele := stringreplace( sele, ' blob ', ' long binary ', [ ] );
   end;
   try
      qmodify.sql.Clear;
      qmodify.sql.Add( sele );
      qmodify.ExecSQL;

      sqlinsert := true;
   except
      sqlinsert := false
   end;
end;

function Tdm.sqldelete( sele: string ): boolean;
begin
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;

   try
      qmodify.sql.Clear;
      qmodify.sql.Add( sele );
      qmodify.ExecSQL;
      sqldelete := true;
   except
      sqldelete := false
   end;
end;

function Tdm.sqlupdate( sele: string ): boolean;
begin
   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;

   try
      qmodify.sql.Clear;
      qmodify.sql.Add( sele );
      qmodify.ExecSQL;
      sqlupdate := true;
   except
      sqlupdate := false
   end;
end;

function Tdm.sqlselect( tabla: tADOquery; sele: string ): boolean;
var
   CodigoSQL: integer;
begin
   sqlselect := false;

   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;

   try
      tabla.close;
      tabla.sql.clear;
      tabla.sql.add( sele );
      tabla.open;
      if tabla.EOF then
         sqlselect := False
      else
         sqlselect := true;
   except
      on E: exception do begin
         Application.MessageBox( pchar( 'ERROR SQL: ' + sele + ' - ' + E.Message ),
            pchar( 'Menaje de SQLSELECT' ), MB_OK );
         sqlselect := false;
      end;
   end;
end;

function Tdm.sqlSelectBFile( tabla: tADOquery; sele: string ): boolean;
var
   CodigoSQL: integer;
begin
   sqlSelectBFile := False;

   with ftsmain.dxBarProgress do
      if Visible = ivAlways then begin
         StepIt;
         ftsmain.Refresh
      end;

   try
      tabla.close;
      tabla.sql.clear;
      tabla.sql.add( sele );
      tabla.open;
      if tabla.EOF then
         sqlSelectBFile := False
      else
         sqlSelectBFile := true;
   except
      sqlSelectBFile := false;
   end;
end;

function Tdm.capacidad( capa: string ): boolean;
var
   qq: tADOquery;
begin
   if ( g_usuario = 'ADMIN' ) or ( g_usuario = 'SVS' ) then begin
      if ( g_usuario = 'ADMIN' )
         and ( capa = 'Administracion Caducidad' ) then begin
         capacidad := false;
      end
      else begin
         capacidad := true;
      end;
      exit;
   end;
   qq := TADOquery.Create( self );
   qq.Connection := ADOConnection1;
   if dm.sqlselect( qq, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + capa + g_q +
      ' and cuser' + g_is_null +
      ' and crol' + g_is_null ) then
      capacidad := true
   else if dm.sqlselect( qq, 'select * from tscapacidad ' +
      ' where ccapacidad=' + g_q + capa + g_q +
      ' and cuser=' + g_q + g_usuario + g_q ) then
      capacidad := true
   else if dm.sqlselect( qq, 'select * from tscapacidad,tsroluser ' +
      ' where ccapacidad=' + g_q + capa + g_q +
      ' and tsroluser.cuser=' + g_q + g_usuario + g_q +
      ' and tsroluser.crol=tscapacidad.crol' ) then
      capacidad := true
   else
      capacidad := false;
   qq.Free;
end;

function Tdm.magico( buffer: pchar; lon: integer ): string;
begin
   magico := ptscomun.magico( buffer, lon );
end;

function Tdm.file2blob( arch: string; var magic: string ): string;
var
   nuevo: string;
   st: Tmemorystream;
   tam: integer;
   buffer: pchar;
begin
   if fileexists( arch ) = false then begin
      application.MessageBox( pchar( 'ERROR... El archivo ' + arch + ' no existe' ), 'ERROR', MB_OK );
      file2blob := '';
      exit;
   end;
   nuevo := stringreplace( copy( g_ipaddress, pos( '.', g_ipaddress ) + 1, 11 ), '.', '', [ rfreplaceall ] ) +
      formatdatetime( 'YYMMDDhhmmsszzz', now );
   st := Tmemorystream.Create;
   try
      tsblob.Close;
      tsblob.Open;
      tsblob.Insert;
      tsblob.FieldByName( 'cblob' ).Asstring := nuevo;
      tsblob.FieldByName( 'path' ).Asstring := arch;
      Tblobfield( tsblob.FieldByName( 'blo' ) ).LoadFromFile( arch );
      St.Clear;
      TBlobField( tsblob.FieldByName( 'Blo' ) ).SaveToStream( St );
      st.Seek( 0, soFromBeginning );
      tam := st.size + 1;
      getMem( buffer, tam );
      st.Read( buffer^, tam );
      magic := magico( buffer, tam - 1 );
      tsblob.Post;
   finally
      st.Free;
      freemem( buffer );
      tsblob.Close;
   end;
   file2blob := nuevo;
end;

function Tdm.blob3memo( clave: string; var memo: TRichedit ): boolean;
var
   buffer: pchar;
begin
   blob3memo := false;
   if leeblob( clave, buffer ) then begin
      Memo.SetTextBuf( Buffer );
      freemem( buffer );
      blob3memo := true;
   end;
end;

function Tdm.leeblob( clave: string; var Buffer: PChar ): boolean;
var
   st: Tmemorystream;
   tam: integer;
begin
   leeblob := false;
   st := Tmemorystream.Create;
   try
      ADOQ.Close;
      ADOQ.SQL.CLear;
      ADOQ.SQL.Add( 'Select * from Tsblob where cblob=' + g_q + clave + g_q );
      ADOQ.Open;
      ADOQ.First;
      St.Clear;
      TBlobField( ADOQ.FieldByName( 'Blo' ) ).SaveToStream( St );
      st.Seek( 0, soFromBeginning );
      tam := st.size + 1;
      //      tam:=st.size;
      getMem( buffer, tam );
      st.Read( buffer^, tam );
      buffer[ st.Size ] := chr( 0 );
      leeblob := true;
   finally
      St.Free;
   end;
end;

Procedure Tdm.blob2file( clave: string; archivo: string );
begin
   ptscomun.blob2file( clave, archivo );
end;

function Tdm.GetIPFromHost( var HostName, IPaddr, WSAErr: string ): Boolean;
type
   Name = array[ 0..100 ] of Char;
   PName = ^Name;
var
   HEnt: pHostEnt;
   HName: PName;
   WSAData: TWSAData;
   i: Integer;
begin
   Result := False;
   if WSAStartup( $0101, WSAData ) <> 0 then begin
      WSAErr := 'Winsock is not responding."';
      Exit;
   end;
   IPaddr := '';
   New( HName );
   if GetHostName( HName^, SizeOf( Name ) ) = 0 then begin
      HostName := StrPas( HName^ );
      HEnt := GetHostByName( HName^ );
      for i := 0 to HEnt^.h_length - 1 do
         IPaddr := Concat( IPaddr, IntToStr( Ord( HEnt^.h_addr_list^[ i ] ) ) + '.' );
      SetLength( IPaddr, Length( IPaddr ) - 1 );
      Result := True;
   end
   else begin
      case WSAGetLastError of
         WSANOTINITIALISED: WSAErr := 'WSANotInitialised';
         WSAENETDOWN: WSAErr := 'WSAENetDown';
         WSAEINPROGRESS: WSAErr := 'WSAEInProgress';
      end;
   end;
   Dispose( HName );
   WSACleanup;
end;

function Tdm.datedb( fecha: string; formato: string ): string;
begin
   datedb := ptscomun.datedb( fecha, formato );
end;
// return the exact file size for a file. Return zero if the file is not found.

Function Tdm.FileSize( FileName: String ): Int64;
var
   SearchRec: TSearchRec;
begin
   if FindFirst( FileName, faAnyFile, SearchRec ) = 0 then // if found
      Result := Int64( SearchRec.FindData.nFileSizeHigh ) shl Int64( 32 ) + // calculate the size
      Int64( SearchREc.FindData.nFileSizeLow )
   else
      Result := 0;
   FindClose( SearchRec ); // close the find
end;

procedure Tdm.DataModuleCreate( Sender: TObject );
begin
   g_borrar := Tstringlist.Create;
   g_log := Tstringlist.Create;
   getdir( 0, g_ruta );
   g_ruta_pais := g_ruta;
   g_ruta := g_ruta + '\';
   g_ruta_ejecuta := g_ruta;
end;

procedure Tdm.DataModuleDestroy( Sender: TObject );
var
   i: integer;
   borra_lista:Tstringlist;
   ejebat: string;
begin
   borra_lista:=Tstringlist.Create;
   for i := 0 to g_borrar.Count - 1 do begin
      try
         deletefile( g_borrar[ i ] );
         borra_lista.Add(g_borrar[ i ]);
      except
      end;
   end;
   borra_lista.SaveToFile(g_tmpdir+'/ALKborrar.txt');
   borra_lista.Free;
end;

{procedure Tdm.BorraUnidadesNetUse();  JCR201208
var k,i,p0,p1,UnidadCreada:integer;
    borra_netuse,ListaUnidades,x,UnidadesExistentes:Tstringlist;
    ejebat,t1,t2,t3,t4:string;
begin
   UnidadesExistentes:=Tstringlist.Create;
   x:=Tstringlist.create;
   dm.ejecuta_espera('net use > '+g_tmpdir+'\UnidadesExistentes.txt',SW_HIDE);

   UnidadesExistentes.LoadFromFile(g_tmpdir+'\UnidadesExistentes.txt');
   deletefile(g_tmpdir+'\UnidadesExistentes.txt');
   t3:='';
   for i:=0 to UnidadesExistentes.Count-1 do begin
      t1:=trim(copy(UnidadesExistentes[i],1,800));
      if copy(t1,1,9)='Conectado' then begin
         t2:=stringreplace( t1, 'Conectado', 'Conectado,', [ rfReplaceAll ] );
         t3:=stringreplace( t2, '\\', ',\\', [ rfReplaceAll ] );
//         t3:=stringreplace( t3, '\COMPONENTES', '\COMPONENTES,', [ rfReplaceAll ] );
         t3:=stringreplace( t3, trim(g_Wcar), trim(g_Wcar)+',', [ rfReplaceAll ] );
         x.commatext:=t3;
//         if x[2]='\\192.168.1.198\COMPONENTES' then
         if x[2]=trim(g_Wser)+trim(g_Wcar) then
            t4:=t4+x[1]+' ';
      end else
            continue;
   end;
   t4:=trim(t4);
   t4:=stringreplace( t4, ' ', ',', [ rfReplaceAll ] );
   UnidadesExistentes.free;

   if t4 <> '' then begin
//   if dm.sqlselect(dm.q1,'select * from parametro '+
//                         ' where clave = '+g_q+'U_NETUSE'+g_q+
//                         ' and secuencia = 1') then begin
      ListaUnidades:=Tstringlist.create;
//      ListaUnidades.commatext:=dm.q1.FieldByName('dato').AsString;
      ListaUnidades.commatext:=t4;
      borra_netuse:=Tstringlist.create;
      for k:=0 to ListaUnidades.Count-1 do begin
          borra_netuse.Add('net use '+ListaUnidades[k]+' /delete /Y');
      end;
      borra_netuse.savetofile(g_tmpdir+'\borra_netuse.bat');
      ejebat:=g_tmpdir+'\borra_netuse.bat';
      borra_netuse.Free;
      ListaUnidades.Free;
      ShellExecute(0,'open',PChar(ejebat),'','',SW_hide);
      UnidadCreada:=0;
      while UnidadCreada=0 do begin
         try
            chdir(g_unidad_libre);
         except
            UnidadCreada:=1;
         end;
      end;

      dm.sqldelete('delete from parametro '+
                   ' where clave = '+g_q+'U_NETUSE'+g_q+
                 ' and secuencia = 1');
   end;
end;
}

procedure Tdm.waitforexec( comando: string; parametros: string );
var
   StartupInfo: TStartupinfo;
   ProcessInfo: TProcessInformation;
begin
   FillChar( StartupInfo, SizeOf( TStartupinfo ), 0 );
   StartupInfo.cb := SizeOf( TStartupInfo );
   if CreateProcess( nil, pchar( comando + ' ' + parametros ), nil, nil, False, normal_priority_class,
      nil, pchar( g_ruta ), StartupInfo, ProcessInfo ) then begin
      WaitforSingleObject( Processinfo.hProcess, Infinite );
      CloseHandle( ProcessInfo.hProcess );
      // Do what ever after program is loaded.
   end;
end;

procedure Tdm.RunDosInMemo( DosApp: String; AMemo: TMemo );
const
   ReadBuffer = 2400;
var
   Security: TSecurityAttributes;
   ReadPipe, WritePipe: THandle;
   start: TStartUpInfo;
   ProcessInfo: TProcessInformation;
   Buffer: Pchar;
   BytesRead: DWord;
   Apprunning: DWord;
begin
   With Security do begin
      nlength := SizeOf( TSecurityAttributes );
      binherithandle := true;
      lpsecuritydescriptor := nil;
   end;
   if Createpipe( ReadPipe, WritePipe,
      @Security, 0 ) then begin
      Buffer := AllocMem( ReadBuffer + 1 );
      FillChar( Start, Sizeof( Start ), #0 );
      start.cb := SizeOf( start );
      start.hStdOutput := WritePipe;
      start.hStdInput := ReadPipe;
      start.dwFlags := STARTF_USESTDHANDLES +
         STARTF_USESHOWWINDOW;
      start.wShowWindow := SW_HIDE;

      if CreateProcess( nil,
         PChar( DosApp ),
         @Security,
         @Security,
         true,
         NORMAL_PRIORITY_CLASS,
         nil,
         nil,
         start,
         ProcessInfo )
         then begin
         //     repeat
         Apprunning := WaitForSingleObject
            ( ProcessInfo.hProcess, 100 );
         Application.ProcessMessages;
         //     until (Apprunning <> WAIT_TIMEOUT) ;
         Repeat
            sleep( 2000 );
            BytesRead := 0;
            ReadFile( ReadPipe, Buffer[ 0 ], ReadBuffer, BytesRead, nil );
            Buffer[ BytesRead ] := #0;
            OemToAnsi( Buffer, Buffer );
            AMemo.Text := AMemo.text + String( Buffer );
         until ( BytesRead < ReadBuffer );
      end;
      FreeMem( Buffer );
      CloseHandle( ProcessInfo.hProcess );
      CloseHandle( ProcessInfo.hThread );
      CloseHandle( ReadPipe );
      CloseHandle( WritePipe );
   end;
end;

function Tdm.ejecuta_espera( FileName: String; Visibility: integer ): boolean;
begin
   ejecuta_espera := ptscomun.ejecuta_espera( filename, visibility );
end;

function Tdm.pathbib( biblioteca: string; clase: string ): string;
begin
   pathbib := ptscomun.pathbib( biblioteca, clase );
end;

function Tdm.descbib( pdescripcion: string ): string;
var
   i: integer;
begin
   for i := 0 to length( g_descbibs ) - 1 do begin
      if g_descbibs[ i ].descripcion = pdescripcion then begin
         descbib := g_descbibs[ i ].nombre;
         exit;
      end;
   end;
   if dm.sqlselect( q2, 'select * from tsbib ' +
      ' where descripcion=' + g_q + pdescripcion + g_q ) then begin
      if trim( q2.fieldbyname( 'cbib' ).asstring ) = '' then begin
         descbib := '';
         exit;
      end;
      i := length( g_descbibs );
      setlength( g_descbibs, i + 1 );
      g_descbibs[ i ].nombre := q2.fieldbyname( 'cbib' ).asstring;
      g_descbibs[ i ].descripcion := pdescripcion;
      descbib := g_descbibs[ i ].nombre;
      exit;
   end;
   descbib := '';
end;

function Tdm.filemagic( arch: string ): string;
begin
   filemagic := ptscomun.filemagic( arch );
end;

procedure Tdm.get_utileria( utileria: string; archivo: string; visual:boolean=true; esdirectiva:boolean=true );
begin
   ptscomun.get_utileria( utileria, archivo,visual,esdirectiva );
end;

function Tdm.xlng( mensaje: string ): string;
begin
   xlng := ptscomun.xlng( mensaje );
end;

function Tdm.xblobname( bib: string; nombre: string; clase: string ): string;
begin
   //showmessage(dm.pathbib(bib)+'\'+nombre);
   xblobname := dm.pathbib( bib, clase ) + '\' + ptscomun.cprog2bfile( nombre );
end;

function Tdm.get_variable( nomvar: string ): string;
var
   buffer: pchar;
begin
   GetMem( buffer, 200 );
   GetEnvironmentVariable( PChar( nomvar ), buffer, 200 );
   get_variable := StrPas( buffer );
   FreeMem( buffer, 200 );
end;

function Tdm.verifica_base( tabla: string ): boolean;
var
   lista: Tstringlist;
begin
   verifica_base := dm.sqlselect( dm.q1, 'select count(*) from ' + tabla );
   exit;
   lista := Tstringlist.Create;
   adoconnection1.GetTableNames( lista, false );
   verifica_base := ( lista.IndexOf( tabla ) > -1 );
   lista.Free;
end;

function Tdm.verifica_campo( ta: Tadotable; nombre: string; tipo: string; tamano: integer ): boolean;
var
   campo: Tfield;
   sele: string;
begin
   campo := ta.Fields.FindField( nombre );
   if campo = nil then begin
      sele := 'alter table ' + ta.TableName + ' add ' + nombre + ' ' + tipo;
      if dm.sqlinsert( sele ) = false then begin
         dm.aborta( 'ERROR... verifica_campo ' + sele + ' [' + inttostr( tamano ) + ']' );
      end;
   end
   else if campo.DataSize <> tamano then begin
      sele := 'alter table ' + ta.TableName + ' modify ' + nombre + ' ' + tipo;
      if dm.sqlinsert( sele ) = false then begin
         dm.aborta( 'ERROR... verifica_campo ' + sele + ' [' + inttostr( tamano ) + ']' );
      end;
   end;
   verifica_campo := true;
end;

function Tdm.verifica_tabla_tsproperty: boolean;
var
   lista: Tstringlist;
   tabla: string;
   ta: Tadotable;
begin
   tabla := 'tsproperty';
   lista := Tstringlist.Create;
   adoconnection1.GetTableNames( lista, false );
   if lista.IndexOf( tabla ) = -1 then begin // no existe
      dm.sqlinsert( 'create table ' + tabla + ' (' +
         ' cprog        varchar(70) NOT NULL,' +
         ' cbib        varchar(50)  NOT NULL,' +
         ' cclase      varchar(10)  NOT NULL,' +
         ' lineas_total  integer,' +
         ' lineas_blanco  integer,' +
         ' lineas_comentario  integer,' +
         ' lineas_efectivas  integer,' +
         ' num_comandos  integer,' +
         ' primary key (cprog,cbib,cclase)) ' );
      verifica_tabla_tsproperty := true;
      lista.Free;
      exit;
   end;
   ta := Tadotable.Create( self );
   ta.Connection := adoconnection1;
   ta.TableName := tabla;
   ta.Active := true;
   dm.verifica_campo( ta, 'cprog', 'varchar(70)', 71 );
   dm.verifica_campo( ta, 'cbib', 'varchar(50)', 51 );
   dm.verifica_campo( ta, 'cclase', 'varchar(10)', 11 );
   dm.verifica_campo( ta, 'lineas_total', 'integer', 34 );
   dm.verifica_campo( ta, 'lineas_blanco', 'integer', 34 );
   dm.verifica_campo( ta, 'lineas_comentario', 'integer', 34 );
   dm.verifica_campo( ta, 'lineas_efectivas', 'integer', 34 );
   dm.verifica_campo( ta, 'num_comandos', 'integer', 34 );
   ta.Free;
   lista.Free;
end;

function Tdm.verifica_tabla_tsrela: boolean;
var
   lista: Tstringlist;
   tabla: string;
   ta: Tadotable;
begin
   tabla := 'tsrela';
   lista := Tstringlist.Create;
   adoconnection1.GetTableNames( lista, false );
   if lista.IndexOf( tabla ) = -1 then begin // no existe
      dm.sqlinsert( 'create table ' + tabla + ' (' +
         ' pcprog        varchar(70) NOT NULL,' +
         ' pcbib        varchar(50)  NOT NULL,' +
         ' pcclase      varchar(10)  NOT NULL,' +
         ' hcprog        varchar(70) NOT NULL,' +
         ' hcbib        varchar(50)  NOT NULL,' +
         ' hcclase      varchar(10)  NOT NULL,' +
         ' modo         varchar(10)      NULL,' +
         ' organizacion varchar(10)      NULL,' +
         ' externo      varchar(50)      NULL,' +
         ' coment       varchar(200)     NULL,' +
         ' orden        varchar(10)  NOT NULL,' +
         ' sistema      varchar(30)      NULL,' +
         'primary key (pcprog,pcbib,pcclase,hcprog,hcbib,hcclase,orden)) ' );
      dm.sqlinsert( 'create index idx_tsrela_padre on tsrela(pcprog,pcbib,pcclase)' );
      dm.sqlinsert( 'create index idx_tsrela_hijo on tsrela(hcprog,hcbib,hcclase)' );
      dm.sqlinsert( 'alter table tsrela add (constraint tsrela_pcclase_fk foreign key (pcclase) ' +
         'references tsclase (cclase) ' +
         'on delete set null)' );
      dm.sqlinsert( 'alter table tsrela add (constraint tsrela_hcclase_fk foreign key (hcclase) ' +
         'references tsclase (cclase) ' +
         'on delete set null)' );
      verifica_tabla_tsrela := true;
      lista.Free;
      exit;
   end;
   ta := Tadotable.Create( self );
   ta.Connection := adoconnection1;
   ta.TableName := tabla;
   ta.Active := true;
   dm.verifica_campo( ta, 'pcprog', 'varchar(70)', 71 );
   dm.verifica_campo( ta, 'pcbib', 'varchar(50)', 51 );
   dm.verifica_campo( ta, 'pcclase', 'varchar(10)', 11 );
   dm.verifica_campo( ta, 'hcprog', 'varchar(70)', 71 );
   dm.verifica_campo( ta, 'hcbib', 'varchar(50)', 51 );
   dm.verifica_campo( ta, 'hcclase', 'varchar(10)', 11 );
   dm.verifica_campo( ta, 'modo', 'varchar(10)', 11 );
   dm.verifica_campo( ta, 'organizacion', 'varchar(10)', 11 );
   dm.verifica_campo( ta, 'externo', 'varchar(50)', 51 );
   dm.verifica_campo( ta, 'coment', 'varchar(200)', 201 );
   dm.verifica_campo( ta, 'orden', 'varchar(10)', 11 );
   dm.verifica_campo( ta, 'sistema', 'varchar(30)', 31 );
   ta.Free;
   lista.Free;
end;

function Tdm.remote_envia( local: string; remoto: string ): boolean;
var
   clave, cblob, magic: string;
   i: integer;
begin
   cblob := file2blob( local, magic );
   clave := formatdatetime( 'YYYYMMDDHHNNSSZZZ', now ) + copy( g_usuario, 1, 8 );
   if sqlinsert( 'insert into tssolver (clave,estado,operacion,dato,cuser) values(' +
      g_q + clave + g_q + ',0,' +
      g_q + 'remote_envia' + g_q + ',' +
      g_q + cblob + ',' + remoto + g_q + ',' +
      g_q + g_usuario + g_q + ')' ) then begin
      //      for i:=0 to 2800 do begin     // responde con el archivo en el BLOB
      for i := 0 to g_tiempo_envia do begin
         if sqlselect( q1, 'select cblob from tsblob where cblob=' + g_q + cblob + g_q ) = false then begin
            remote_envia := true;
            exit;
         end;
         sleep( 1000 );
      end;
   end;
   remote_envia := false;
end;

function Tdm.remote_ejecuta_espera(
   comando: string; Visibility: integer; arch: string; var Buffer: string ): boolean;
var
   clave: string;
   i, tam: integer;
   st: Tmemorystream;
   sBFile: String;
   pBuffer: PChar;
begin
   if ( g_demonio = false ) and ( g_busca_remoto = false ) then begin
      dm.ejecuta_espera( comando, Visibility );
      st := Tmemorystream.Create;
      if fileexists( arch ) = false then begin
         remote_ejecuta_espera := false;
         exit;
      end;
      st.LoadFromFile( arch );
      st.Seek( 0, soFromBeginning );
      tam := st.size + 1;
      getMem( pbuffer, tam );
      st.Read( pbuffer^, tam );
      pbuffer[ st.Size ] := chr( 0 );
      buffer := pbuffer;
      freemem( pbuffer );
      st.Free;
      remote_ejecuta_espera := true;
      exit;
   end;
   clave := formatdatetime( 'YYYYMMDDHHNNSSZZZ', now ) + copy( g_usuario, 1, 8 );

   if sqlinsert( 'insert into tssolver (clave,estado,operacion,dato,cuser) values(' +
      g_q + clave + g_q + ',0,' +
      g_q + 'ejecuta' + g_q + ',' +
      g_q + arch + ',' + comando + g_q + ',' +
      g_q + g_usuario + g_q + ')' ) then begin
      for i := 0 to g_tiempo_espera_tssolver do begin // responde con el archivo en el BLOB
         if sqlselect( q1, 'select cprog from tsbfile where cprog=' + g_q + clave + g_q + ' and cbib=' + g_q + g_oratmpdir + g_q ) then begin
            //leebfile( clave, g_oratmpdir, ' ', buffer ); //se sustituye por sPubObtenerBFile

            buffer := sPubObtenerBFile( clave, g_oratmpdir, ' ' );

            sqldelete( 'delete tsbfile where cprog=' + g_q + clave + g_q + ' and cbib=' + g_q + g_oratmpdir + g_q );
            remote_ejecuta_espera := true;
            exit;
         end;
         sleep( 1000 );
      end;
   end;
   {
   if sqlinsert('insert into tssolver (clave,estado,operacion,dato,cuser) values('+
      g_q+clave+g_q+',0,'+
      g_q+'ejecuta_espera'+g_q+','+
      g_q+arch+','+comando+g_q+','+
      g_q+g_usuario+g_q+')') then begin
      for i:=0 to g_tiempo_espera_tssolver do begin     // responde con el archivo en el BLOB
         if sqlselect(q1,'select cblob from tsblob where cblob='+g_q+clave+g_q) then begin
            leeblob(clave,buffer);
            //sqldelete('delete tsblob where cblob='+g_q+clave+g_q) then begin
            remote_ejecuta_espera:=true;
            exit;
         end;
         sleep(1000);
      end;
   end;
   }
   remote_ejecuta_espera := false;
end;

function Tdm.leexdemonio( compo: string; bib: string; clase: string; var Buffer: PChar ): boolean;
var
   clave: string;
   i: integer;
begin
   clave := formatdatetime( 'YYYYMMDDHHNNSSZZZ', now ) + copy( g_usuario, 1, 8 );
   if sqlinsert( 'insert into tssolver (clave,estado,operacion,dato,cuser) values(' +
      g_q + clave + g_q + ',0,' +
      g_q + 'leebfile' + g_q + ',' +
      g_q + compo + ',' + bib + ',' + clase + g_q + ',' +
      g_q + g_usuario + g_q + ')' ) then begin
      for i := 0 to 180 do begin
         if sqlselect( q1, 'select cblob from tsblob where cblob=' + g_q + clave + g_q ) then begin
            leeblob( clave, buffer );
            //sqldelete('delete tsblob where cblob='+g_q+clave+g_q)
            leexdemonio := true;
            exit;
         end;
         sleep( 1000 );
      end;
   end;
   leexdemonio := false;
end;

function Tdm.pingdemonio: boolean;
var
   clave: string;
   i: integer;
begin
   clave := formatdatetime( 'YYYYMMDDHHNNSSZZZ', now ) + copy( g_usuario, 1, 8 );
   if sqlinsert( 'insert into tssolver (clave,estado,operacion,dato,cuser) values(' +
      g_q + clave + g_q + ',0,' +
      g_q + 'pingdemonio' + g_q + ',' +
      g_q + '---' + g_q + ',' +
      g_q + g_usuario + g_q + ')' ) then begin
      for i := 0 to 180 do begin
         if sqlselect( q1, 'select cblob from tsblob where cblob=' + g_q + clave + g_q ) then begin
            sqldelete( 'delete tsblob where cblob=' + g_q + clave + g_q );
            pingdemonio := true;
            exit;
         end;
         sleep( 1000 );
      end;
   end;
   pingdemonio := false;
end;

{function Tdm.leebfile( compo:string; bib:string; var Buffer: PChar):boolean;
// Rutina para traer fuente desde un drive creado con net use, se cambio por BDE JCR201208
var
  // st:Tmemorystream;
   tam:integer;
   slfuente:Tstringlist;
   Wfuente:string;
begin

   if g_demonio then begin  // Utiliza el demonio del lado del Server
      leebfile:=leexdemonio(compo,bib,'',buffer);
      exit;
   end;

   Wfuente:=dm.xblobname(bib,compo);
   if g_mismoserver = false then
      Wfuente:=stringreplace(Wfuente,'C:\COMPONENTES\',g_unidad_libre+'\',[rfreplaceall]);

   if dm.sqlselect(q2,'select cprog from tsbfile '+
      ' where cprog='+g_q+compo+g_q+
      ' and cbib='+g_q+bib+g_q)=false then begin
      sqlinsert('insert into tsbfile (cprog,cbib,fuente) values('+
         g_q+compo+g_q+','+
         g_q+bib+g_q+','+
         'bfilename('+g_q+bib+g_q+','+g_q+compo+g_q+'))');
   end;
   leebfile:=false;

      slfuente:= tstringlist.Create;
      try
         if fileexists(Wfuente) then begin
            slfuente.LoadFromFile(Wfuente);
            if slFuente.Count>0 then begin
               buffer:=slFuente.GetText;
               leebfile:=true
            end else
               showmessage(Wfuente+'  '+' - no existe');
         end else
            showmessage(Wfuente+'  '+' - no existe');
      finally
         slfuente.Free;
      end;
end;
 }

{
//se sustituye por dm.sPubObtenerBFile
function Tdm.leebfile( compo: string; bib: string; clase: string; var Buffer: PChar ): boolean;
var
   st: Tmemorystream;
   tam: integer;
   lBib, lwBib: string;
begin
   lBib := '';
   if copy( bib, 1, 4 ) = 'VER_' then
      lwBib := trim( copy( bib, 5, 10 ) )
   else
      lwBib := bib;

   if dm.sqlselect( dm.q4, 'select oracledir from tsbibcla ' +
      ' where cbib=' + g_q + lwBib + g_q +
      ' and   cclase=' + g_q + clase + g_q ) then
      lBib := dm.q4.fieldbyname( 'oracledir' ).asstring;

   if lBib = '' then begin
      leebfile := false;
      exit;
   end;

   if copy( bib, 1, 4 ) = 'VER_' then
      lbib := 'VER_' + lbib;

   if g_demonio then begin // Utiliza el demonio del lado del Server
      leebfile := leexdemonio( compo, lbib, '', buffer );
      exit;
   end;
   if dm.sqlselect( q2, 'select cprog from tsbfile ' +
      ' where cprog=' + g_q + compo + g_q +
      ' and cbib=' + g_q + lbib + g_q ) = false then begin
      sqlinsert( 'insert into tsbfile (cprog,cbib,fuente) values(' +
         g_q + compo + g_q + ',' +
         g_q + lbib + g_q + ',' +
         'bfilename(' + g_q + lbib + g_q + ',' + g_q + compo + g_q + '))' );
   end;
   leebfile := false;
   st := Tmemorystream.Create;
   try
      dm.qBDE1.Close;
      dm.qBDE1.SQL.CLear;
      dm.qBDE1.SQL.Add( 'Select * from tsbfile ' +
         ' where cprog=' + g_q + compo + g_q +
         ' and   cbib=' + g_q + lbib + g_q );
      try
         dm.sqlselect( q2, 'select cprog from tsbfile ' + // REVISAR BIEN ESTO
            ' where cprog=' + g_q + compo + g_q + ' and cbib=' + g_q + lbib + g_q );
         if not dm.q2.EOF then begin
            try
               dm.qBDE1.Open;
            except
               on E: exception do begin
                  Application.MessageBox( pchar( 'No puede abrir :' + chr( 13 ) + chr( 13 ) +
                     'Componente = ' + compo + ',  Biblioteca = ' + bib ),
                     //JCR201209      Application.MessageBox(pchar('ERROR : '+compo+' '+bib+' - '+E.Message),
                     pchar( 'Mensaje de qBDE1.open' ), MB_OK );

               end;
            end;
         end
         else begin
            exit;
         end;
      except
         exit;
      end;
      dm.qBDE1.First;
      St.Clear;
      TBlobField( dm.qBDE1.FieldByName( 'fuente' ) ).SaveToStream( St );

      st.Seek( 0, soFromBeginning );
      if st.size = 0 then begin
         //         showmessage('Fuente inexistente');
         exit;
      end;
      tam := st.size + 1;
      getMem( buffer, tam );
      st.Read( buffer^, st.size );
      buffer[ st.size ] := chr( 0 );
      leebfile := true;
   finally
      St.Free;
   end;
end;}

{function Tdm.leebfile2( compo: string; bib: string; var Buffer: PChar ): boolean;
var
   st: Tmemorystream;
   tam: integer;
begin
   if g_demonio then begin // Utiliza el demonio del lado del Server
      leebfile2 := leexdemonio( compo, bib, '', buffer );
      exit;
   end;
   if dm.sqlselect( q2, 'select cprog from tsbfile ' +
      ' where cprog=' + g_q + compo + g_q +
      ' and cbib=' + g_q + bib + g_q ) = false then begin
      sqlinsert( 'insert into tsbfile (cprog,cbib,fuente) values(' +
         g_q + compo + g_q + ',' +
         g_q + bib + g_q + ',' +
         'bfilename(' + g_q + bib + g_q + ',' + g_q + compo + g_q + '))' );
   end;
   leebfile2 := false;
   st := Tmemorystream.Create;
   try
      dm.ADOQ.Close;
      dm.ADOQ.SQL.CLear;
      dm.ADOQ.SQL.Add( 'Select * from tsbfile ' +
         ' where cprog=' + g_q + compo + g_q +
         ' and   cbib=' + g_q + bib + g_q );
      try
         if dm.sqlselect( q2, 'select cprog from tsbfile ' + // REVISAR BIEN ESTO
            ' where cprog=' + g_q + compo + g_q + ' and cbib=' + g_q + bib + g_q ) then begin
            ;
            if not dm.q2.EOF then begin
               dm.ADOQ.Open;
            end
            else begin
               exit;
            end;
         end
         else
            exit;
      except
         exit;
      end;
      dm.ADOQ.First;
      St.Clear;
      TBlobField( dm.ADOQ.FieldByName( 'fuente' ) ).SaveToStream( St );
      st.Seek( 0, soFromBeginning );
      if st.size = 0 then begin
         showmessage( 'Fuente inexistente leebfile' );
         exit;
      end;
      tam := st.size + 1;
      getMem( buffer, tam );
      st.Read( buffer^, st.size );
      buffer[ st.size ] := chr( 0 );
      leebfile2 := true;
   finally
      St.Free;
   end;
end;}

function Tdm.bfile2file( compo: string; bib: string;clase:string; archivo: string ): boolean;
var
   st: Tmemorystream;
   tam: integer;
   buffer: pchar;
   biblioteca, directorio:string;
begin
   biblioteca:=sgetoracledir(compo,bib,clase,directorio);
   if g_mismoserver then begin
      copyfile(pchar(directorio+'\'+ptscomun.cprog2bfile(compo)),pchar(archivo),true);
      bfile2file:=true;
      exit;
   end;


   {if g_demonio then begin // Utiliza el demonio del lado del Server
      bfile2file := leexdemonio( compo, bib, '', buffer );
      st := Tmemorystream.Create;
      St.Clear;
      st.Read( buffer, 100000 ); // RGM - Hay que modificar leexdemonio para que regrese el tamaño de lo que leyó
      st.Seek( 0, soFromBeginning );
      st.SaveToFile( archivo );
      exit;
   end;}         //250815

   if dm.sqlselect( q2, 'select cprog from tsbfile ' +
      ' where cprog=' + g_q + ptscomun.cprog2bfile( compo ) + g_q +
      ' and cbib=' + g_q + bib + g_q ) = false then begin
      sqlinsert( 'insert into tsbfile (cprog,cbib,fuente) values(' +
         g_q + ptscomun.cprog2bfile( compo ) + g_q + ',' +
         g_q + bib + g_q + ',' +
         'bfilename(' + g_q + bib + g_q + ',' + g_q + ptscomun.cprog2bfile( compo ) + g_q + '))' );
   end;
   bfile2file := false;
   st := Tmemorystream.Create;
   try
      dm.ADOQ.Close;
      dm.ADOQ.SQL.CLear;
      dm.ADOQ.SQL.Add( 'Select * from tsbfile ' +
         ' where cprog=' + g_q + ptscomun.cprog2bfile( compo ) + g_q +
         ' and   cbib=' + g_q + bib + g_q );
      try
         if dm.sqlselect( q2, 'select cprog from tsbfile ' + // REVISAR BIEN ESTO
            ' where cprog=' + g_q + ptscomun.cprog2bfile( compo ) + g_q + ' and cbib=' + g_q + bib + g_q ) then begin
            if not dm.q2.EOF then begin
               dm.ADOQ.Open;
            end
            else begin
               exit;
            end;
         end
         else
            exit;

         {        dm.sqlselect(q2,'select cprog from tsbfile '+  // REVISAR BIEN ESTO
                    ' where cprog='+g_q+ptscomun.cprog2bfile(compo)+g_q+' and cbib='+g_q+bib+g_q);
                 if dm.q2.recordcount > 0 then begin
                    dm.ADOQ.Open;
                 end else begin
                    exit;
                 end;
         }
      except
         exit;
      end;
      dm.ADOQ.First;
      St.Clear;
      TBlobField( dm.ADOQ.FieldByName( 'fuente' ) ).SaveToStream( St );
      st.Seek( 0, soFromBeginning );
      if st.size = 0 then begin
         showmessage( 'Fuente inexistente bfile2file' );
         exit;
      end;
      st.SaveToFile( archivo );
      bfile2file := true;
   finally
      St.Free;
   end;
end;

function Tdm.bfile_lowsize( compo: string; bib: string; var salida:string ): boolean;
var
  Buffer: PChar;
  MemSize: Integer;
  Stream: TADOBlobStream;
  i:integer;
begin
   bfile_lowsize := false;
   try
      dm.ADOQ.Close;
      dm.ADOQ.SQL.CLear;
      dm.ADOQ.SQL.Add( 'Select * from tsbfile ' +
         ' where cprog=' + g_q +  compo + g_q +
         ' and   cbib=' + g_q + bib + g_q );
      try
               dm.ADOQ.Open;
      except
         dm.ADOConnection1.Connected:=false;
         dm.ADOConnection1.Connected:=true;
         exit;
      end;
      dm.ADOQ.First;
     Stream := TADOBlobStream.Create(dm.ADOQ.FieldByName( 'fuente' ) as TBlobField, bmRead);
     try
       MemSize := Stream.Size;
       Inc(MemSize); {Make room for the buffer's null terminator.}
       Buffer := AllocMem(MemSize);     {Allocate the memory.}
       try
         Stream.Read(Buffer^, MemSize); {Read Notes field into buffer.}
         for i:=0 to MemSize-2 do       // Limpia nulos del fuente, dejando el último que delimita el string
            if Buffer[i]=chr(0) then
               Buffer[i]:=' ';
         salida:=buffer;
       finally
         FreeMem(Buffer, MemSize);
       end;
     finally
       Stream.Free;
     end;
      bfile_lowsize := true;
   finally
   end;
end;

function Tdm.trae_fuente( sistema: string; compo: string; bib: string; clase: string; objeto: Tpersistent ): boolean;
var
   //datos: string;
   buffer: pchar;
   memo: Tmemo;
   rich: Trichedit;
   lista: Tstringlist;
   sBFile: String;

   function es_virtual(clase : String):boolean;
   var
      cons : String;
      es:boolean;
   begin
      es := false;
      cons:= 'select objeto from tsclase where cclase=' + g_q + clase + g_q;
      if sqlselect(q5,cons) then
         if uppercase(q5.fieldbyname( 'objeto' ).AsString) = 'VIRTUAL' then
            es := true;

      Result:=es;
   end;
begin
   if objeto is Tstringlist then begin
      lista := ( objeto as Tstringlist );
      lista.SetText( '' );
   end
   else if objeto is Tmemo then begin
      memo := ( objeto as Tmemo );
      Memo.SetTextBuf( '' );
   end
   else if objeto is Trichedit then begin
      rich := ( objeto as Trichedit );
      rich.SetTextBuf( '' );
   end;

   trae_fuente := false;

   alkleyenda:='';
   if bib = 'SCRATCH' then begin
      alkleyenda:='La biblioteca es SCRATCH';
      exit;
   end;

   if clase = '' then begin
      if sqlselect( q2, 'select distinct cclase from tsprog ' +
         ' where cbib=' + g_q + stringreplace( bib, 'VER_', '', [ ] ) + g_q +
         ' and  cprog=' + g_q + compo + g_q +
         ' and  sistema=' + g_q + sistema + g_q ) = false then begin
         exit;
      end
      else begin
         if es_virtual(clase) then
            alkleyenda:='La clase es Virtual'
         else
            alkleyenda:='La clase es Física';
      end;

      clase := q2.FieldByName( 'cclase' ).AsString;
   end;

   if copy(bib,1,4)<>'VER_' then begin
      if sqlselect(dm.q5,'select cprog from tsprog '+
         ' where cprog='+g_q+compo+g_q+
         ' and   cbib='+g_q+stringreplace( bib, 'VER_', '', [ ] ) + g_q +
         ' and   cclase='+g_q+clase+g_q)=false then begin
         trae_fuente:=false;
         if es_virtual(clase) then
            alkleyenda:='La clase es Virtual'
         else
            alkleyenda:='La clase es Física';
         exit;
      end;
   end;

   {if ( ( g_usuario <> 'ADMIN' ) and ( g_usuario <> 'SVS' ) ) and ( dm.capacidad( 'VIA WEBSERVER' ) ) then begin
      datos := ( htt as IsvsServer ).getTxt( 'svsget,' + clase + ',' + bib + ',' + compo );
      if copy( datos, 1, 7 ) = '<ERROR>' then
         datos := '';
      if objeto is Tstringlist then begin
         lista.SetText( pchar( datos ) );
      end
      else if objeto is Tmemo then begin
         Memo.SetTextBuf( pchar( datos ) );
      end
      else if objeto is Trichedit then begin
         rich.SetTextBuf( pchar( datos ) );
      end
      else
         exit;
      trae_fuente := true;
      exit;
   end;}//verificar funcionalidad

   // default
   sBFile := sPubObtenerBFile( compo, bib, clase );

   if sBFile <> '' then begin
      if objeto is Tstringlist then
         lista.Text := sBFile
      else if objeto is Tmemo then
         memo.Text := sBFile
      else if objeto is Trichedit then
         rich.Text := sBFile;

      trae_fuente := True;
   end;
end;

function Tdm.procrunning( tarea: string ): Boolean;
var
   Proceso: TProcessEntry32;
   ProcessHandle: THandle;
   Sproceso: Boolean;
   Nproceso: String;
begin
   Result := False;
   tarea := uppercase( tarea );
   Proceso.dwSize := SizeOf( TProcessEntry32 );
   ProcessHandle := CreateToolHelp32Snapshot( TH32CS_SNAPPROCESS, 0 );
   if Process32First( ProcessHandle, Proceso ) then begin
      while Process32Next( ProcessHandle, Proceso ) do begin
         Nproceso := uppercase( String( Proceso.szExeFile ) );
         if Nproceso = tarea then begin
            CloseHandle( ProcessHandle );
            Result := True;
            exit;
         end;
      end;
   end;
   CloseHandle( ProcessHandle );
end;

function Tdm.revisa_campo( nver: string; ver: string;
   tabla: string; campo: string; tipo: string; longitud: integer; nullable: string ): boolean;
var
   b_ok: boolean;
   nulo: string;
begin
   if ver >= nver then
      exit;
   if ( g_usuario <> 'ADMIN' ) and ( g_usuario <> 'SVS' ) then begin
      aborta( 'ERROR... Su versión no corresponde a la actual' );
   end;
   if uppercase( nullable ) = 'N' then
      nulo := 'NOT NULL'
   else
      nulo := 'NULL';
   if application.MessageBox( pchar( 'Desea actualizar a la versión ' + nver + '?' + chr( 13 ) +
      tabla + ' ' + campo + ' ' + tipo + '(' + inttostr( longitud ) + ') ' + nulo ), 'Confirme', MB_YESNO ) = IDNO then begin
      application.Terminate;
      abort;
   end;
   if g_database <> 'ORACLE' then begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... Base de datos ' + g_database + ' no compatible' ) ),
         pchar( dm.xlng( 'Revisar datos de la versión' ) ), MB_OK );
      revisa_campo := false;
      exit;
   end;
   b_ok := false;
   if dm.sqlselect( dm.q1, 'select * from all_tab_columns ' +
      ' where owner=' + g_q + uppercase( g_user_procesa ) + g_q +
      ' and table_name=' + g_q + uppercase( tabla ) + g_q +
      ' and   column_name=' + g_q + uppercase( campo ) + g_q ) then begin
      if ( dm.q1.FieldByName( 'data_type' ).AsString <> uppercase( tipo ) ) or
         ( dm.q1.FieldByName( 'data_length' ).AsInteger <> longitud ) or
         ( dm.q1.FieldByName( 'nullable' ).AsString <> uppercase( nullable ) ) then begin
         if dm.q1.FieldByName( 'nullable' ).AsString = uppercase( nullable ) then
            nulo := '';
         b_ok := dm.sqlinsert( 'alter table ' + tabla +
            ' modify ' + campo + ' ' + tipo + '(' + inttostr( longitud ) + ') ' + nulo );
      end
      else
         b_ok := true;
   end
   else begin
      b_ok := dm.sqlinsert( 'alter table ' + tabla +
         ' add ' + campo + ' ' + tipo + '(' + inttostr( longitud ) + ') ' + nulo );
   end;
   if b_ok then begin
      if dm.sqlupdate( 'update parametro ' +
         ' set secuencia=' + nver + ' ,dato=' + g_q + g_version_tit + g_q +
         ' where clave=' + g_q + 'VERSIONSHD' + g_q ) = false then
         aborta( 'ERROR... no puede actualizar la secuencia de version' );
   end
   else begin
      aborta( 'ERROR... no puede actualizar ' + tabla + ' ' + campo );
   end;
   revisa_campo := b_ok;
end;

procedure Tdm.PubRegistraVentanaActiva( sParCaption: String );
begin
   //insertar el caption en la tabla dm.tabVentanas
   with tabVentanas do begin
      if not Active then
         Active := True;

      Append;
      FindField( 'VentanaCaption' ).AsString := sParCaption;
      Post;
   end;
end;

procedure Tdm.PubEliminarVentanaActiva( sParCaption: String );
begin
   //elimina el registro de la tabla dm.tabVentanas, de acuerdo al caption
   with tabVentanas do begin
      if not Active then
         Active := True;

      if tabVentanas.Locate( 'VentanaCaption', sParCaption, [ ] ) then
         Delete;
   end;
end;

procedure Tdm.PubRegistraConsultaActiva( sParCaption: String; sParFechaHora: String );
begin
   //insertar el caption en la tabla dm.tabConsultas
   with tabConsultas do begin
      if not Active then
         Active := True;

      Append;
      FindField( 'ConsultaCaption' ).AsString := sParCaption;
      FindField( 'FechaHoraCaption' ).AsString := sParFechaHora;
      Post;
   end;
end;

procedure Tdm.PubEliminarConsultaActiva( sParCaption: String );
begin
   //elimina el registro de la tabla dm.tabConsulta, de acuerdo al caption
   with tabConsultas do begin
      if not Active then
         Active := True;

      if tabConsultas.Locate( 'ConsultaCaption', sParCaption, [ ] ) then
         Delete;
   end;
end;

function Tdm.activa_tsbibcla: boolean;
var
   oracledir, path: string;
begin
   g_mismoserver := mismo_server;
   if g_mismoserver = false then begin
      //showmessage('... activa_tsbibcla debe ejecutarse en el mismo servidor que la base de datos');
      activa_tsbibcla := false;
      exit;
   end; //detecta en tsprog las bibliotecas activas
   if dm.sqlselect( dm.q1, 'select distinct cbib,cclase from tsprog order by 1,2' ) then begin
      while not dm.q1.Eof do begin
         if dm.sqlselect( dm.q2, 'select * from tsbib ' +
            ' where cbib=' + g_q + dm.q1.fieldbyname( 'cbib' ).AsString + g_q ) then begin

            if dm.sqlselect( dm.q4, 'select * from tsbibcla ' +
               ' where cbib = ' + g_q + dm.q2.fieldbyname( 'cbib' ).AsString + g_q +
               ' and cclase = ' + g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q ) = false then begin
               oracledir := 'D' + formatdatetime( 'YYYYMMDDHHNNSSZZZ', now );
               path := dm.q2.fieldbyname( 'path' ).AsString + '\' + dm.q1.fieldbyname( 'cclase' ).AsString;
               dm.sqlinsert( 'insert into tsbibcla ' + // alta a TSBIBCLA
                  ' (cbib,cclase,oracledir,path) values(' +
                  g_q + dm.q1.fieldbyname( 'cbib' ).AsString + g_q + ',' +
                  g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q + ',' +
                  g_q + oracledir + g_q + ',' +
                  g_q + path + g_q + ')' );
               // crea los directorios
               checa_directorio( oracledir, path );
               renamefile( dm.q2.fieldbyname( 'path' ).AsString + '\versiones', path + '\versiones' ); // mueve versiones
               checa_directorio( 'VER_' + oracledir, path + '\versiones' );
               // mueve los componentes
               if dm.sqlselect( dm.q3, 'select cprog from tsprog ' +
                  ' where cbib=' + g_q + dm.q1.fieldbyname( 'cbib' ).AsString + g_q +
                  ' and   cclase=' + g_q + dm.q1.fieldbyname( 'cclase' ).AsString + g_q ) then begin
                  while not dm.q3.Eof do begin
                     movefile( pchar( dm.q2.fieldbyname( 'path' ).AsString + '\' + dm.q3.fieldbyname( 'cprog' ).AsString ),
                        pchar( path + '\' + dm.q3.fieldbyname( 'cprog' ).AsString ) );
                     dm.q3.Next;
                  end;
               end;
            end;
         end;
         dm.q1.Next;
      end;
   end;
   activa_tsbibcla := true;
end;

function Tdm.sgetoracledir( sParProg, sParBib, sParClase: String; var sDirectoryPath: String): String;
var
   sBiblioteca, sOracleDir: String;
   bExisteBFile: Boolean;
   qBFile: TADOquery;
   sTSBibClaPath: String;
begin
   sgetoracledir := '';
   qBFile := TADOquery.Create( Self );
   qBFile.Connection := ADOConnection1;
   if Copy( sParBib, 1, 4 ) = 'VER_' then
      sBiblioteca := Trim( Copy( sParBib, 5, 100 ) )
   else
      sBiblioteca := sParBib;
   sOracleDir:='';
   if sqlselect( qBFile, 'SELECT ORACLEDIR, PATH FROM TSBIBCLA' +
      ' WHERE CBIB=' + g_q + sBiblioteca + g_q +
      ' AND CCLASE=' + g_q + sParClase + g_q ) then
      sOracleDir := qBFile.FieldByName( 'ORACLEDIR' ).AsString
   else begin
      activa_tsbibcla;
      if sqlselect( qBFile, 'SELECT ORACLEDIR, PATH FROM TSBIBCLA' +
         ' WHERE CBIB=' + g_q + sBiblioteca + g_q +
         ' AND CCLASE=' + g_q + sParClase + g_q ) then
         sOracleDir := qBFile.FieldByName( 'ORACLEDIR' ).AsString;
   end;
   if sOracleDir = '' then begin // porque no trae clase (TMPDIR)             RGM-ALK
      if sBiblioteca<>g_oratmpdir then begin   // si no es TMPDIRoficina la bib no existe
         qbfile.Free;
         exit;
      end;
      sOracleDir := sBiblioteca
   end
   else
      sTSBibClaPath := UpperCase( qBFile.FieldByName( 'PATH' ).AsString );

   if sqlselect( qBFile, 'SELECT DIRECTORY_PATH FROM ALL_DIRECTORIES ' +
      ' WHERE DIRECTORY_NAME=' + g_q + sOracleDir + g_q ) = False then begin
      if alkDocumentacion <> 1 then
         Application.MessageBox( pChar( 'No existe DIRECTORY_NAME' ),
                                 pChar( 'tabla ALL_DIRECTORIES - ORACLE' ), MB_OK );
      qbfile.Free;
      exit;
   end;

   sDirectoryPath := UpperCase( qBFile.FieldByName( 'DIRECTORY_PATH' ).AsString );

   if sTSBibClaPath = '' then
      sTSBibClaPath := sDirectoryPath;

   if sTSBibClaPath <> sDirectoryPath then begin
      Application.MessageBox( pChar( 'Rutas diferentes en TSBIBCLA vs ORACLE' ),
         pChar( 'tablas diferentes' ), MB_OK );
      qbfile.Free;
      exit;
   end;

   if Copy( sParBib, 1, 4 ) = 'VER_' then
      sOracleDir := 'VER_' + sOracleDir;
   qbfile.free;
  sgetoracledir:=sOracleDir;
end;

function Tdm.sPubObtenerBFile( sParProg, sParBib, sParClase: String ): String;
var
   sBiblioteca, sOracleDir: String;
   bExisteBFile: Boolean;
   qBFile: TADOquery;
   dtsBFile: TDataSource;
   cxDBBlobEdit: TcxDBBlobEdit;

   sBibClaPath, sDirectoryPath: String;
   salida:string;
   dirfisico:string;
   buf:Tstringlist;

begin
   sPubObtenerBFile := '';
   sOracleDir := '';

   qBFile := TADOquery.Create( Self );
   dtsBFile := TDataSource.Create( Self );
   try
      qBFile.Connection := ADOConnection1;
      dtsBFile.DataSet := qBFile;

      {
      if Copy( sParBib, 1, 4 ) = 'VER_' then
         sBiblioteca := Trim( Copy( sParBib, 5, 100 ) )
      else
         sBiblioteca := sParBib;

      if sqlselect( qBFile, 'SELECT ORACLEDIR, PATH FROM TSBIBCLA' +
         ' WHERE CBIB=' + g_q + sBiblioteca + g_q +
         ' AND CCLASE=' + g_q + sParClase + g_q ) then
         sOracleDir := qBFile.FieldByName( 'ORACLEDIR' ).AsString
      else begin
         activa_tsbibcla;
         if sqlselect( qBFile, 'SELECT ORACLEDIR, PATH FROM TSBIBCLA' +
            ' WHERE CBIB=' + g_q + sBiblioteca + g_q +
            ' AND CCLASE=' + g_q + sParClase + g_q ) then
            sOracleDir := qBFile.FieldByName( 'ORACLEDIR' ).AsString;
      end;
      {
      if sOracleDir = '' then begin
         //Application.MessageBox( pChar( 'No se existe ORACLEDIR' ),
              // pChar( 'tabla TSBIBCLA' ), MB_OK );
         Exit;
      end
      }
      {
      if sOracleDir = '' then begin // porque no trae clase (TMPDIR)             RGM-ALK
         if sBiblioteca<>g_oratmpdir then    // si no es TMPDIRoficina la bib no existe
            exit;
         sOracleDir := sBiblioteca
      end
      else
         sBibClaPath := UpperCase( qBFile.FieldByName( 'PATH' ).AsString );

      if sqlselect( qBFile, 'SELECT DIRECTORY_PATH FROM ALL_DIRECTORIES ' +
         ' WHERE DIRECTORY_NAME=' + g_q + sOracleDir + g_q ) = False then begin
         Application.MessageBox( pChar( 'No existe DIRECTORY_NAME' ),
         pChar( 'tabla ALL_DIRECTORIES - ORACLE' ), MB_OK );
         Exit;
      end;

      sDirectoryPath := UpperCase( qBFile.FieldByName( 'DIRECTORY_PATH' ).AsString );

      if sBibClaPath = '' then
         sBibClaPath := sDirectoryPath;

      if sBibClaPath <> sDirectoryPath then begin
         Application.MessageBox( pChar( 'Rutas diferentes en ORACLE vs TSBIBCLA' ),
            pChar( 'tablas diferentes' ), MB_OK );
         Exit;
      end;

      if Copy( sParBib, 1, 4 ) = 'VER_' then
         sOracleDir := 'VER_' + sOracleDir;
      }

      sOracleDir:=sgetoracledir(sParProg,sParBib,sParClase,sDirectoryPath);

      if g_mismoserver then begin                                                      //  si está en el mismo servidor que la base
         dirfisico:=sDirectoryPath;
         if Copy( sParBib, 1, 4 ) = 'VER_' then begin
            if sqlselect( qBFile, 'SELECT DIRECTORY_PATH FROM ALL_DIRECTORIES ' +      //  si quiere una version, obtiene la nueva ruta
               ' WHERE DIRECTORY_NAME=' + g_q + sOracleDir + g_q ) = False then begin
               if alkDocumentacion <> 1 then
                  Application.MessageBox( pChar( 'No existe DIRECTORY_NAME' ),
                                          pChar( 'tabla ALL_DIRECTORIES - ORACLE' ), MB_OK );
               Exit;
            end;
            dirfisico := UpperCase( qBFile.FieldByName( 'DIRECTORY_PATH' ).AsString );
         end;
         if fileexists(dirfisico+'\'+ptscomun.cprog2bfile( sParProg )) then begin
            buf:=Tstringlist.Create;
            buf.LoadFromFile(dirfisico+'\'+ptscomun.cprog2bfile( sParProg ));  //cprog2bfile - limpia el nombre de caracteres
            sPubObtenerBFile:=buf.GetText;
            buf.Free;
            exit;
         end
         else begin
            sPubObtenerBfile:='';
            exit;
         end;
      end;
   

      {if g_demonio then begin // Utiliza el demonio del lado del Server
         //leebfile := leexdemonio( compo, lbib, '', sTexto ); //fercar BlobEdit - checar esto
         Exit;
      end;}

      bExisteBFile := sqlselect( qBFile, 'SELECT CPROG FROM TSBFILE' +
         ' WHERE CPROG=' + g_q + ptscomun.cprog2bfile( sParProg ) + g_q +
         ' AND CBIB=' + g_q + sOracleDir + g_q );

      if not bExisteBFile then
         sqlinsert( 'INSERT INTO TSBFILE( CPROG, CBIB, FUENTE ) VALUES (' +
            g_q + ptscomun.cprog2bfile( sParProg ) + g_q + ',' +
            g_q + sOracleDir + g_q + ',' +
            'bfilename(' + g_q + sOracleDir + g_q + ',' + g_q + ptscomun.cprog2bfile( sParProg ) + g_q + '))' );
      {  probable causa del error E_FAIL
      bExisteBFile := sqlSelectBFile( qBFile, 'SELECT CPROG, FUENTE FROM TSBFILE' +
         ' WHERE CPROG=' + g_q + ptscomun.cprog2bfile( sParProg ) + g_q +
         ' AND CBIB=' + g_q + sOracleDir + g_q );
      }
      bExisteBFile := sqlselect( qBFile, 'SELECT CPROG FROM TSBFILE' +
         ' WHERE CPROG=' + g_q + ptscomun.cprog2bfile( sParProg ) + g_q +
         ' AND CBIB=' + g_q + sOracleDir + g_q );

      if bExisteBFile then try
         if bfile_lowsize(ptscomun.cprog2bfile( sParProg ),sOracleDir,salida) then
            sPubObtenerBFile:=salida
         else
            raise Exception.Create('bfile_lowsize');
         {   extrae fuente utilizando componente devexpress. Se revisará para archivos grandes RGM 20140827

         cxDBBlobEdit := TcxDBBlobEdit.Create( Self );
         try
            cxDBBlobEdit.DataBinding.DataField := 'FUENTE';
            cxDBBlobEdit.DataBinding.DataSource := dtsBFile;
            cxDBBlobEdit.Properties.BlobEditKind := bekMemo;

            sPubObtenerBFile := cxDBBlobEdit.Text;
         finally
            cxDBBlobEdit.Free;
            Sleep( 1000 );
         end;
         }
      except
         on E: exception do
            Application.MessageBox( pChar( 'No se puede abrir :' + Chr( 13 ) + Chr( 13 ) +
               'Componente = ' + sParProg + ',  Biblioteca = ' + sParBib ),
               pChar( 'Archivo BFile' ), MB_OK );
      end;
   finally
      qBFile.Close;
      qBFile.Free;
      dtsBFile.Free;
   end;
end;

function Tdm.bInsertarTSDOCBLOB(
   iParIDDOCTO, iParIDREVISION: Integer;
   iParTamNormal, iParTamCRC: Integer; sParArchivo: String ): Boolean;
begin
   Result := False;

   if FileExists( sParArchivo ) = False then begin
      Application.MessageBox(
         pchar( 'ERROR... El archivo ' + sParArchivo + ' no existe' ), 'ERROR', MB_OK );
      Exit;
   end;

   with tsDocBlob do begin
      Open;
      try
         try
            Insert;
            FieldByName( 'IDDOCTO' ).AsInteger := iParIDDOCTO;
            FieldByName( 'IDREVISION' ).AsInteger := iParIDREVISION;
            FieldByName( 'TAMNORMAL' ).AsInteger := iParTamNormal;
            FieldByName( 'TAMCRC' ).AsInteger := iParTamCRC;
            Tblobfield( FieldByName( 'ARCHIVO' ) ).LoadFromFile( sParArchivo );
            Post;
         except
            on E: exception do begin
               Application.MessageBox(
                  pchar( 'ERROR... al guardar el archivo: ' + E.Message ),
                  'ERROR', MB_OK );
               Exit;
            end;
         end;
      finally
         Close;
      end;
   end;

   Result := True;
end;

function Tdm.bObtenerTSDOCBLOB(
   iParIDDOCTO, iParIDREVISION: Integer; sParArchivo: String ): Boolean;
begin
   Result := False;

   with ADOQ do begin
      SQL.CLear;
      SQL.Add(
         'SELECT * ' +
         'FROM TSDOCBLOB ' +
         'WHERE IDDOCTO = ' + IntToStr( iParIDDOCTO ) +
         '   AND IDREVISION =' + IntToStr( iParIDREVISION ) );
      try
         Open;

         if RecordCount <= 0 then
            Exit;

         //TBlobField( FieldByName( 'ARCHIVO' ) ).SaveToFile( g_tmpdir + '\' + sParArchivo );
         TBlobField( FieldByName( 'ARCHIVO' ) ).SaveToFile( sParArchivo);
      finally
         Close;
      end;
   end;

   Result := True;
end;

function Tdm.iObtenerID( sParTabla: String; iParIDDOCTO: Integer ): Integer;
begin
   Result := 0;

   if sParTabla = 'TSDOCUMENTO' then
      if dm.sqlselect( dm.q1,
         'SELECT NVL( MAX( IDDOCTO ), 0 ) MAXIMO FROM ' + sParTabla ) then
         Result := dm.q1.FieldByName( 'MAXIMO' ).AsInteger + 1;

   if sParTabla = 'TSDOCREVISION' then
      if dm.sqlselect( dm.q1,
         'SELECT NVL( MAX( IDREVISION ), 0 ) MAXIMO FROM ' + sParTabla +
         ' WHERE IDDOCTO = ' + IntToStr( iParIDDOCTO ) ) then
         Result := dm.q1.FieldByName( 'MAXIMO' ).AsInteger + 1;
end;

procedure Tdm.TaladrarTsrela( ParDrill: TDrill; //DrillDown, DrillUp
   sParSistemaOrigen, sParProg, sParBib, sParClase: String; bParRegistraRepetidos: Boolean );
//sParSistemaOrigen no tiene funcionalidad, usar si es necesario //JCR
var
   i, j: Integer;
   iNivel: Integer;
   slPadres: TStringList;
   sPadre: String;

   procedure ListarPadres( slParLista: TStringList ); //lista padres
   var
      i: Integer;
      sProgramaPadre: String;
   begin
      sProgramaPadre := '';
      for i := 0 to Length( aGLBTsrela ) - 1 do
         if aGLBTsrela[ i ].sPCPROG <> sProgramaPadre then begin
            if pos( Q + aGLBTsrela[ i ].sPCPROG + Q, slParLista.Text ) = 0 then
               slParLista.Add( Q + aGLBTsrela[ i ].sPCPROG + Q );

            sProgramaPadre := aGLBTsrela[ i ].sPCPROG;
         end;
   end;

   function iObtenerNivelPadre( sParPadre: String ): Integer; //busca el nivel del padre
   var
      i: Integer;
   begin
      Result := 0;
      for i := 0 to length( aGLBTsrela ) - 1 do
         if aGLBTsrela[ i ].sHCPROG = sParPadre then begin
            Result := aGLBTsrela[ i ].iNivel;
            Break;
         end;
   end;

begin
   SetLength( aGLBTsrela, 0 );

   TaladrarTsrelaDetalle( ParDrill,
      sParProg, sParBib, sParClase, sParProg, sParBib, sParClase, '',
      '', '', '', '', '', '', '', '', '', 0, 0, '', '', '', '', '', '', '', '', '', '',
      bParRegistraRepetidos, False, '', '', '', sParSistemaOrigen );

   if ParDrill = DrillDown then begin
      slPadres := TStringlist.Create;
      try
         ListarPadres( slPadres );

         aGLBTsrela[ 0 ].iNivel := 0;
         for i := 0 to slPadres.Count - 1 do begin
            sPadre := StringReplace( slPadres[ i ], '"', '', [ rfReplaceAll ] );
            iNivel := iObtenerNivelPadre( sPadre );

            for j := 0 to Length( aGLBTsrela ) - 1 do
               if aGLBTsrela[ j ].sPCPROG = sPadre then
                  aGLBTsrela[ j ].iNivel := iNivel + 1;
         end;
      finally
         slPadres.Free;
      end;
   end;
end;

procedure Tdm.TaladrarTsrelaDetalle( ParDrill: TDrill; //DrillDown, DrillUp
   sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN: String;
   sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT: String;
   sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS: String;
   iParLINEAINICIO, iParLINEAFINAL: Integer;
   sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE: String;
   sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE: String;
   bParRegistraRepetidos: Boolean;
   bParRepetido: Boolean; sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido: String;
   sParSistemaOrigen: String );
//sParSistemaOrigen no tiene funcionalidad, usar si es necesario //JCR
var
   sConsulta, vSistema: String;
   qConsulta: TAdoQuery;
   iLineaInicio, iLineaFinal: Integer;
   bRepetido: Boolean;
   sCPROGRepetido, sCBIBRepetido, sCCLASERepetido: String;
   iNivel: Integer;
begin
   case ParDrill of
      DrillDown:
         bRepetido := bGlbRepetidoTsrela( sParHCPROG, sParHCBIB, sParHCCLASE );
      DrillUp:
         bRepetido := bGlbRepetidoTsrela( sParPCPROG, sParPCBIB, sParPCCLASE );
   end;

   if not bRepetido then begin //no existe, no repetido
      GlbRegistraArregloTsrela(
         sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN,
         sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT,
         sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS,
         iParLINEAINICIO, iParLINEAFINAL,
         sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE,
         sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE,
         bParRepetido, sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido );

      //vSistema := ''; no tiene funcionalidad, usar si es necesario //JCR
      //if  trim( sParSistema ) <> '' then
          //vSistema := ' AND  SISTEMA = ' +  g_q + sParSistema + g_q ;

      case ParDrill of
         DrillDown:
            sConsulta :=
               ' SELECT *' +
               ' FROM TSRELA' +
               ' WHERE' +
               '    PCPROG = ' + g_q + sParHCPROG + g_q +
               '    AND PCBIB = ' + g_q + sParHCBIB + g_q +
               '    AND PCCLASE = ' + g_q + sParHCCLASE + g_q +
               //vSistema +
         //' ORDER BY ORDEN';
               ' ORDER BY HCPROG, HCBIB, HCCLASE';
         DrillUp:
            sConsulta :=
               ' SELECT *' +
               ' FROM TSRELA' +
               ' WHERE' +
               '    HCPROG = ' + g_q + sParPCPROG + g_q +
               '    AND HCBIB = ' + g_q + sParPCBIB + g_q +
               '    AND HCCLASE = ' + g_q + sParPCCLASE + g_q +
               //vSistema +
               ' ORDER BY PCPROG, PCBIB, PCCLASE --ORDEN';
      end;

      qConsulta := TAdoQuery.Create( nil );
      try
         qConsulta.Connection := dm.ADOConnection1;

         if dm.sqlselect( qConsulta, sConsulta ) then begin
            while not qConsulta.Eof do begin
               if qConsulta.FieldByName( 'LINEAINICIO' ).AsString = '' then
                  iLineaInicio := 0
               else
                  iLineaInicio := qConsulta.FieldByName( 'LINEAINICIO' ).AsInteger;

               if qConsulta.FieldByName( 'LINEAFINAL' ).AsString = '' then
                  iLineaFinal := 0
               else
                  iLineaFinal := qConsulta.FieldByName( 'LINEAFINAL' ).AsInteger;

               TaladrarTsrelaDetalle( ParDrill,
                  qConsulta.FieldByName( 'PCPROG' ).AsString,
                  qConsulta.FieldByName( 'PCBIB' ).AsString,
                  qConsulta.FieldByName( 'PCCLASE' ).AsString,
                  qConsulta.FieldByName( 'HCPROG' ).AsString,
                  qConsulta.FieldByName( 'HCBIB' ).AsString,
                  qConsulta.FieldByName( 'HCCLASE' ).AsString,
                  qConsulta.FieldByName( 'ORDEN' ).AsString,
                  qConsulta.FieldByName( 'MODO' ).AsString,
                  qConsulta.FieldByName( 'ORGANIZACION' ).AsString,
                  qConsulta.FieldByName( 'EXTERNO' ).AsString,
                  qConsulta.FieldByName( 'COMENT' ).AsString,
                  qConsulta.FieldByName( 'OCPROG' ).AsString,
                  qConsulta.FieldByName( 'OCBIB' ).AsString,
                  qConsulta.FieldByName( 'OCCLASE' ).AsString,
                  qConsulta.FieldByName( 'SISTEMA' ).AsString,
                  qConsulta.FieldByName( 'ATRIBUTOS' ).AsString,
                  iLineaInicio,
                  iLineaFinal,
                  qConsulta.FieldByName( 'AMBITO' ).AsString,
                  qConsulta.FieldByName( 'ICPROG' ).AsString,
                  qConsulta.FieldByName( 'ICBIB' ).AsString,
                  qConsulta.FieldByName( 'ICCLASE' ).AsString,
                  qConsulta.FieldByName( 'POLIMORFISMO' ).AsString,
                  qConsulta.FieldByName( 'XCCLASE' ).AsString,
                  qConsulta.FieldByName( 'AUXILIAR' ).AsString,
                  qConsulta.FieldByName( 'HSISTEMA' ).AsString,
                  qConsulta.FieldByName( 'HPARAMETROS' ).AsString,
                  qConsulta.FieldByName( 'HINTERFASE' ).AsString,

                  bParRegistraRepetidos,
                  False, '', '', '', sParSistemaOrigen );

               qConsulta.Next;
            end;
         end;
      finally
         qConsulta.Free;
      end;
   end
   else begin //repetido
      if bParRegistraRepetidos then begin
         case ParDrill of
            DrillDown: begin
                  sCPROGRepetido := sParHCPROG;
                  sCBIBRepetido := sParHCBIB;
                  sCCLASERepetido := sParHCCLASE;
               end;
            DrillUp: begin
                  sCPROGRepetido := sParPCPROG;
                  sCBIBRepetido := sParPCBIB;
                  sCCLASERepetido := sParPCCLASE;
               end;
         end;

         {GlbRegistraBitacora( 'paso123.txt',
            sParPCPROG+ ',' + sParPCBIB+ ',' + sParPCCLASE+ ',' +
            sParHCPROG+ ',' + sParHCBIB+ ',' + sParHCCLASE+ ',' +
            sParORDEN+ ',' +sParOCPROG )}

         GlbRegistraArregloTsrela(                 //mete los datos al arreglo, esten repetidos o no
            sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN,
            sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT,
            sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS,
            iParLINEAINICIO, iParLINEAFINAL,
            sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE,
            sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE,
            True, sCPROGRepetido, sCBIBRepetido, sCCLASERepetido );
      end;
   end;
end;

function Tdm.ArmarSelectClases: String;
var
   lSQL: string;
begin
   lSQL :=
      'WITH ' +
      'TMP_TSCLASE_CCLASE AS  ' +
      '(SELECT CCLASE ' +
      'FROM TSCLASE ' +
      'WHERE ' +
      'ESTADOACTUAL = ' + g_q + 'ACTIVO' + g_q + '), ' +

   'TMP_TSRELA_HCCLASE AS ' +
      '(SELECT DISTINCT HCCLASE CLASE ' +
      'FROM TSRELA A, TMP_TSCLASE_CCLASE B ' +
      'WHERE ' +
      'A.HCCLASE = B.CCLASE ' +
      'AND A.HCBIB <> ' + g_q + 'BD' + g_q + ' ), ' +

   'TMP_TSRELA_PCCLASE AS ' +
      '(SELECT DISTINCT PCCLASE CLASE ' +
      'FROM TSRELA A, TMP_TSCLASE_CCLASE B ' +
      'WHERE ' +
      'A.PCCLASE = B.CCLASE ' +
      'AND A.PCBIB <> ' + g_q + 'BD' + g_q + ' ), ' +

   'TMP_TSRELA_OCCLASE AS ' +
      '(SELECT DISTINCT OCCLASE CLASE ' +
      'FROM TSRELA A, TMP_TSCLASE_CCLASE B  ' +
      'WHERE ' +
      'A.OCCLASE = B.CCLASE ' +
      'AND A.OCBIB <> ' + g_q + 'BD' + g_q + ' ), ' +

   'TMP_UNION AS ' +
      '(SELECT CLASE FROM TMP_TSRELA_HCCLASE ' +
      'UNION ' +
      'SELECT CLASE FROM TMP_TSRELA_PCCLASE ' +
      'UNION ' +
      'SELECT CLASE FROM TMP_TSRELA_OCCLASE ) ' +

   'SELECT CLASE ' +
      'FROM TMP_UNION ' +
      'ORDER BY 1 ';

   ArmarSelectClases := lSQL;
end;

function Tdm.bPubDocumentoExiste( sParNombre, sParProg, sParBib, sParClase: String ): Boolean;
begin
   //valida que no se duplique el docto por: nombre, prog, bib, clase
   Result := sqlselect( q1,
      'SELECT * FROM TSDOCUMENTO ' +
      'WHERE UPPER( NOMBRE ) = UPPER(' + g_q + sParNombre + g_q + ')' +
      ' AND CPROG = ' + g_q + sParProg + g_q +
      ' AND CBIB = ' + g_q + sParBib + g_q +
      ' AND CCLASE = ' + g_q + sParClase + g_q );
end;

//  ----------------- Calculo de complejidades ALK  ---------------------
procedure Tdm.complejidad(comp, cla, bib, sis, rgmlang, complejidad ,dirCBL, dirCMA, res : String);
var
   slFuente, datos1, datos2, inserts, cobol, ejecuta:TStringList;
   entrada, salida, salida2, bib2, dato, bc: String;
   inst, cons, inserta, busca_param, salidacicl, tipo_cbl : String;
   p,a: integer;
begin
   if not dm.sqlselect(dm.q3,'select complejidad from tsclase where cclase= '+g_q + cla + g_q+
                         ' and complejidad = ' +g_q + 'TRUE' + g_q) then begin
      //if ((cla='CBL') or (cla='CMA')) then
         alkComplejidad:='Al parecer no ha especificado en el catalogo de clases la complejidad';
      exit;
   end;

   // ---------- Inicializando lo que se requiere --------------
   slFuente:=TStringList.Create;
   datos1:=TStringList.Create;
   datos2:=TStringList.Create;
   inserts:=TStringList.Create;  //para tener un registro de los inserts que trato de hacer

   // ------------- Archivos de entrada y salida ---------------
   entrada:=comp;
   bib2:=bib;
   bGlbQuitaCaracteres(bib2);
   salida:=g_tmpdir + '\' + entrada +'_'+ bib2 +'_'+ cla+'_'+sis;
   salida2:=g_tmpdir + '\' + entrada +'_'+ bib2 +'_'+ cla+'_'+sis+'_2';
   salidacicl:=salida+'_cicl.txt';
   entrada:= g_tmpdir + '\'+entrada+'.txt';

   //----------- Cmplejidad Halstead ----------------------------
   // ** Traer el fuente para que lo tome como entrada **
   dm.trae_fuente( sis, comp, bib, cla, slFuente );
   if slFuente.Count > 0 then
      slFuente.SaveToFile( entrada )
   else begin
      alkComplejidad:='No existe el fuente';
      exit;
   end;
   g_borrar.Add(entrada);

   // ** colocar el tipo de cobol **
   cobol := TStringList.Create;
   ptscomun.da_tipo_cbl(sis,cla,bib,entrada,cobol);
   if cobol.count<1 then
      tipo_cbl:=''
   else
      tipo_cbl:=cobol[1];
   cobol.Free;

   // ** Mandar a procesar con el binario de Natan **
   // --- guardar en archivo la instruccion que se ejecuta por commponente ---
   ejecuta:=TStringList.Create;
   inst:= complejidad + ' ' +
          entrada + ' ' + salida + ' ' + salida2 + ' "' +
          tipo_cbl + '" ' + cla + ' ' + bib + ' ' + sis;
   ejecuta.Add(inst);
   ejecuta.Add(' ');
   // ------------------------------------------------------------------------

   if FileExists(entrada) then begin
      if not ejecuta_espera(inst , SW_HIDE ) then
         alkComplejidad:= 'No se ejecuto el proceso.';
   end
   else
      Exit;

   slFuente.Clear;

   //---- Borrar los registros anteriores, si los hay ----
   cons:='select * from ts_deta_complej'+
         ' where CPROG = '+g_q + comp + g_q +
         ' and CBIB = '+g_q + bib + g_q+
         ' and CCLASE = '+g_q + cla + g_q+
         ' and SISTEMA = '+g_q + sis + g_q;
   if dm.sqlselect(dm.q5,cons) then begin
      inserta:= 'delete ts_deta_complej'+
         ' where CPROG = '+g_q + comp + g_q +
         ' and CBIB = '+g_q + bib + g_q+
         ' and CCLASE = '+g_q + cla + g_q+
         ' and SISTEMA = '+g_q + sis + g_q;
      dm.sqldelete(inserta);
   end;
   // -----------------------------------------------------
   // ------ Poblar la base de datos ts_deta_complej ------
   salida:=salida + '.txt';
   if FileExists(salida) then begin
      try
         datos1.LoadFromFile(salida);
         for a:=0 to datos1.Count-1 do begin
            datos2.CommaText:=datos1[a];
            if datos2.Count <> 9 then     //si no trae los datos suficientes para llenar la tabla, se salta el renglon
               continue;

            inserta:= 'insert into ts_deta_complej ' +
                       '(CCLASE, CBIB, CPROG, SISTEMA, RUTINA,' +
                       ' N_OPERADORES, N_OPERADORES_U, N_OPERANDOS, ' +
                       ' N_OPERANDOS_U) values (' +
                       g_q + datos2[0] + g_q + ',' +// CCLASE
                       g_q + datos2[1] + g_q + ',' +// CBIB
                       g_q + datos2[2] + g_q + ',' +// CPROG
                       g_q + datos2[3] + g_q + ',' +// SISTEMA
                       g_q + datos2[4] + g_q + ',' +// RUTINA
                       datos2[5] + ',' +// N_OPERADORES
                       datos2[6] + ',' +// N_OPERADORES_U
                       datos2[7] + ',' +// N_OPERANDOS
                       datos2[8] + ')'; // N_OPERANDOS_U

            if dm.sqlinsert(inserta) = false then
               Application.MessageBox( pChar( 'No se pudo insertar :' + Chr( 13 ) + Chr( 13 ) +
                                       inserta ), pChar( 'Error Insertar' ), MB_OK );

            inserts.Add(inserta);
            datos2.Clear;
         end;
      finally
         g_borrar.Add(salida);
         datos1.Clear;
         datos2.Clear;
      end;
   end
   else begin
      alkComplejidad:='No se ejecuto el proceso.';
      exit;
   end;



   //---- Borrar los registros anteriores, si los hay ----
   cons:='select * from ts_estad_complej'+
         ' where CPROG = '+g_q + comp + g_q +
         ' and CBIB = '+g_q + bib + g_q+
         ' and CCLASE = '+g_q + cla + g_q+
         ' and SISTEMA = '+g_q + sis + g_q;
   if dm.sqlselect(dm.q5,cons) then begin
      inserta:= 'delete ts_estad_complej'+
         ' where CPROG = '+g_q + comp + g_q +
         ' and CBIB = '+g_q + bib + g_q+
         ' and CCLASE = '+g_q + cla + g_q+
         ' and SISTEMA = '+g_q + sis + g_q;
      dm.sqldelete(inserta);
   end;
   // -----------------------------------------------------

   //retomar los archivos de salida para poblar la base de datos ts_estad_complej
   salida2:=salida2 + '.txt';
   if FileExists(salida2) then begin
      try
         datos1.LoadFromFile(salida2);
         for a:=0 to datos1.Count-1 do begin
            datos2.CommaText:=datos1[a];
            if datos2.Count <> 16 then     //si no trae los datos suficientes para llenar la tabla, se salta el renglon
               continue;

            // AQUI revisar si ya existe el registro PENDIENTE para nuevo proceso de complejidad ts_estad_complej
            inserta:= 'insert into ts_estad_complej ' +
                       '(CCLASE, CBIB, CPROG,SISTEMA,N_OPERADORES,N_OPERADORES_U,' +
                       'N_OPERANDOS,N_OPERANDOS_U,VOCABULARIO,LONGITUD,DURACION,' +
                       'VOLUMEN,DIFICULTAD,ESFUERZO,TIEMPO,ERRORES) values (' +
                       g_q + datos2[0] + g_q + ',' +// CCLASE
                       g_q + datos2[1] + g_q + ',' +// CBIB
                       g_q + datos2[2] + g_q + ',' +// CPROG
                       g_q + datos2[3] + g_q + ',' +// SISTEMA
                       datos2[4] + ',' +// N_OPERADORES
                       datos2[5] + ',' +// N_OPERADORES_U
                       datos2[6] + ',' +// N_OPERANDOS
                       datos2[7] + ',' +// N_OPERANDOS_U
                       datos2[8] + ',' +// VOCABULARIO
                       datos2[9] + ',' +// LONGITUD
                       datos2[10] + ',' +// DURACION
                       datos2[11] + ',' +// VOLUMEN
                       datos2[12] + ',' +// DIFICULTAD
                       datos2[13] + ',' +// ESFUERZO
                       datos2[14] + ',' +// TIEMPO
                       datos2[15] + ')'; // ERRORES

            if dm.sqlinsert(inserta) = false then
               Application.MessageBox( pChar( 'No se pudo insertar :' + Chr( 13 ) + Chr( 13 ) +
                                       inserta ), pChar( 'Error Insertar' ), MB_OK );

            inserts.Add(inserta);
            datos2.Clear;
         end;
      finally
         datos1.Clear;
         datos2.Clear;
         g_borrar.Add(salida2);
      end;
   end;

   //----------- Complejidad McCabe (ciclomatica) ------------
   if cla= 'CBL' then
      inst := rgmlang +' '+ entrada +' '+g_tmpdir +'\detalles.txt '+ dirCBL + ' ' + res +'>'+ salidacicl;
   if cla= 'CMA' then
      inst := rgmlang +' '+ entrada +' '+g_tmpdir +'\detalles.txt '+ dirCMA + ' ' + res +'>'+ salidacicl;

   ejecuta.Add(inst);
   ejecuta_espera(inst, SW_HIDE);

   if FileExists(salidacicl) then begin
   try
      datos1.LoadFromFile(salidacicl);
      for a:=0 to datos1.Count-1 do begin
         datos2.CommaText:=datos1[a];
         if datos2.Count <> 4 then     //si no trae los datos suficientes para llenar la tabla, se salta el renglon
            continue;

         // AQUI revisar si ya existe el registro PENDIENTE para nuevo proceso de complejidad ts_estad_complej
         if a = datos1.Count-1 then           //si es el ultimo registro, el del componente en ts_deta_complej
            inserta:= 'update ts_estad_complej set ' +
                   'N_NODOS='+ datos2[1] +
                   ', N_ARISTAS=' + datos2[2] +
                   ', N_RESULTADO=' + datos2[3] +
                   ' where CPROG = '+g_q + comp + g_q +
                   ' and CBIB = '+g_q + bib + g_q+
                   ' and CCLASE = '+g_q + cla + g_q+
                   ' and SISTEMA = '+g_q + sis + g_q
         else
            inserta:= 'update ts_deta_complej set ' +
                   'N_NODOS='+ datos2[1] +
                   ', N_ARISTAS=' + datos2[2] +
                   ', N_RESULTADO=' + datos2[3] +
                   ' where CPROG = '+g_q + comp + g_q +
                   ' and CBIB = '+g_q + bib + g_q+
                   ' and CCLASE = '+g_q + cla + g_q+
                   ' and SISTEMA = '+g_q + sis + g_q +
                   ' and rutina = ' +g_q + datos2[0] +g_q;


         if dm.sqlinsert(inserta) = false then
            Application.MessageBox( pChar( 'No se pudo insertar :' + Chr( 13 ) + Chr( 13 ) +
                                   inserta ), pChar( 'Error Insertar' ), MB_OK );

         inserts.Add(inserta);
         datos2.Clear;
      end;
      finally
         datos1.Clear;
         datos2.Clear;
         g_borrar.Add(salidacicl);
      end;
   end
   else begin
      alkComplejidad:='No se ejecuto el proceso.';
      exit;
   end;


   // --------------------  Para finalizar... ----------------------
   inserts.SaveToFile(g_tmpdir+'\ins_compl_'+comp+'.txt');
   g_borrar.Add( g_tmpdir+'\ins_compl_'+comp+'.txt' );
   inserts.Free;

   ejecuta.SaveToFile(g_tmpdir+'\inst_a_ejecutar_'+comp+'.txt');
   g_borrar.Add( g_tmpdir+'\inst_a_ejecutar_'+comp+'.txt' );
   ejecuta.Free;
end;


// ---- funciones para comprobar, ejecutar y matar procesos  ALK  ----
function Tdm.ClearFileName(AExeName: String): TFileName;
{ Sirve para sistemas de arquitectura x64 donde Windows agrega " *32" a los
  procesos que corren con arquitectura x86 }
{ Copia el FileName hasta el espacio en blanco }
var
  i: integer;
begin
  { Marcás el final de la cadena como un espacio vacío }
  i := LastDelimiter(' ', AExeName);
  if (i = 0) then { Si no hay ningún espacio vacío le das el máximo de caracteres }
    i := MaxInt;
  { Copiás desde el inicio hasta el anterior al máximo }
  Result := Copy(AExeName, 0, i - 1);
  { explorer.exe *32 -> el " " aparece en la posición 13, necesitás copiar 12 }
end;

function Tdm.ProcessExists(AExeName: String): boolean;
var
  ContinueLoop: LongBool;
  FSnapshotHandle: THandle;
  FProcess: TProcessEntry32;
  FExeFound: TFileName;
begin
  { Limpias el hacés un genérico para el FileName }
  AExeName := UpperCase(ClearFileName(AExeName));
  Result := False;
  { Creas un Handle para leer procesos }
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  { Creás un buffer de procesos }
  FProcess.dwSize := SizeOf(FProcess);
  { ContinueLoop es un flag que busca el siguiente proceso y, si hay, lo guarda en FProcess }
  ContinueLoop := Process32First(FSnapshotHandle, FProcess);
  while (ContinueLoop) and NOT(Result) do
  begin
    { Almacenás el nombre "genéroco" del proceso encontrado }
    FExeFound := UpperCase(ClearFileName(ExtractFileName(FProcess.szExeFile)));
    Result := (FExeFound = AExeName);
    ContinueLoop := Process32Next(FSnapshotHandle, FProcess);
  end;
  { Cerrás el Handle }
  CloseHandle(FSnapshotHandle);
end;

procedure Tdm.ExecuteAndWait(AExeName: String; uCmdShow: Cardinal);
{ Tiene que ejecutar el programa y esperar que aparezca para
  terminar el proceso }
var
  Path: PAnsiChar;
begin
  if NOT(FileExists(AExeName)) then
    Exit;
  { El PAnsiChar es necesario (al menos en D2010) para llamar a WinExec }
  Path := PAnsiChar(AnsiString(AExeName));
  WinExec(Path, uCmdShow);
  { Puede ser que tarde en llegar el mensaje de Exec así que lo "obligás" }
  Application.ProcessMessages;

  { Para prevenir que tarde, lo buscás hasta que aparece }
  while NOT(ProcessExists(AExeName)) do
    Sleep(250);

  { Recibís/Enviás todos los mensajes }
  Application.ProcessMessages;
end;

function Tdm.ProcessKill(AExeName: String; Iterative: boolean = TRUE): boolean;
const
  TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcess: TProcessEntry32;
  FExeFound: TFileName;
Label NO_ITERATIVE;
begin
  Result := False;
  { Limpias el hacés un genérico para el FileName }
  AExeName := UpperCase(ClearFileName(AExeName));
  { Creas un Handle para leer procesos }
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  { Creás un buffer de procesos }
  FProcess.dwSize := SizeOf(FProcess);
  { ContinueLoop es un flag que busca el siguiente proceso y, si hay, lo guarda en FProcess }
  ContinueLoop := Process32First(FSnapshotHandle, FProcess);
  while (ContinueLoop) do
  begin
    { Almacenás el nombre "genéroco" del proceso encontrado }
    FExeFound := UpperCase(ClearFileName(ExtractFileName(FProcess.szExeFile)));
    if (FExeFound = AExeName) then
    begin
      Result := True;
      { Para matarlo lo debés abrir con el flag de TERMINATE }
      TerminateProcess(OpenProcess(TERMINATE, BOOL(0), FProcess.th32ProcessID),
        0);
      if NOT(Iterative) then { Si no es iterativo sale directamente a cerrar el Handle }
        GoTo NO_ITERATIVE;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcess);
  end;
NO_ITERATIVE :
  CloseHandle(FSnapshotHandle);
end;
// ----------------------------------------------------------------------------

procedure Tdm.ExportAsPdf(const inFileName, outFileName: TFileName); // -- Funcion para generar un pdf a partir de un archivo
var
   Pdf: TPdfDocument;
   aMeta: TMetaFile;
begin
   if not FileExists(inFileName) then   // prueba documentacion ALK
      exit;

   Pdf := TPdfDocument.Create;
   try
      aMeta := TMetaFile.Create;
      aMeta.LoadFromFile(inFileName);
      Pdf.DefaultPageWidth:=(aMeta.Width * 100) div 190;
      Pdf.DefaultPageHeight:=(aMeta.Height * 100) div 190;

      Pdf.AddPage;
      try
          // draw the page content
         Pdf.Canvas.RenderMetaFile(aMeta,1,0,0);
      finally
         aMeta.Free;
      end;
      Pdf.SaveToFile(outFileName);
   finally
      Pdf.free;
   end;
end;

// --------  ALK para comprobar que exista el fuente -----------
function Tdm.es_SCRATCH (sParSistema, sParProg, sParBib, sParClase:String):boolean;
var
   fuente:TStringList;
   es : boolean;
begin
   es := true;
   alkSCRATCH:='';
   alkleyenda:='';
   try
      //  --  Comprueba si la clase es fisica o virtual  --
      if sqlselect(q5,'select objeto from tsclase where cclase=' + g_q + sParClase + g_q) then
         if uppercase(q5.fieldbyname( 'objeto' ).AsString) = 'VIRTUAL' then begin
            // si es virtual y no tiene hijos
            if sqlselect(q4,'select count(*) hcprog from tsrela where '+
                            ' pcclase='+ g_q + sParClase + g_q +
                            ' and pcprog='+ g_q + sParProg + g_q +
                            ' and pcbib='+ g_q + sParBib + g_q +
                            ' and sistema='+ g_q + sParSistema + g_q) then
               if StrToInt(q4.fieldbyname( 'hcprog' ).AsString) = 0 then begin // no tiene hijos
                  es:=false;
                  alkSCRATCH:='La clase no tiene hijos';
               end;
         end
         else if uppercase(q5.fieldbyname( 'objeto' ).AsString) = 'FISICO' then begin
            // si es fisica y no tiene fuente
            fuente := Tstringlist.Create;
            trae_fuente( sParSistema, sParProg, sParBib, sParClase, fuente );
            if ((alkleyenda = 'La biblioteca es SCRATCH') or (fuente.count = 0)) then begin
               es := false;
               alkSCRATCH:='No tiene fuente';
               fuente.Add(sParSistema);
               fuente.Add(sParProg);
               fuente.Add(sParBib);
               fuente.Add(sParClase);
               fuente.SaveToFile(g_tmpdir+'\errorTraeFuente.txt');
               //g_borrar(g_tmpdir+'\errorTraeFuente.txt');
            end;
         end;
   finally
      fuente.Free;
      Result:=es;
   end;
end;
// -------------------------------------------------------------

function Tdm.valida_var_entorno(variable:String):Boolean;
var
   Env : PChar;
   sal : Boolean;
   variables : TStringList;
begin
   Env := GetEnvironmentStrings;
   sal:=False;   // no existe la variable
   variables:=TStringList.Create;

   While Env^ <> #0 do begin
      variables.Add(StrPas(Env));
      if pos(upperCase(variable),upperCase(StrPas(Env))) <> 0 then begin
         sal:=true;   //si existe la variable
         break;
      end;
      Inc(Env, StrLen(Env) + 1);
   end;
   variables.SaveToFile(g_tmpdir+'\variablesEntorno.txt');
   variables.Free;
   Result:=sal;
end;


end.


