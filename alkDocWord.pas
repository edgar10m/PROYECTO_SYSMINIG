unit alkDocWord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, ADODB, FileCtrl;

// Estructura para almacenar los datos de la consulta de la base de datos   ALK
type
   datos=record
      cla:string;
      bib:string;
      comp:string;
end;

type
  TalkFormDocWord = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    cbSistema: TComboBox;
    cbClase: TComboBox;
    lbruta: TEdit;
    btnRuta: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbEmpresa: TComboBox;
    Label6: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    rgDoc: TRadioGroup;
    SaveDialog: TSaveDialog;
    btnGenerar: TButton;
    procedure btnGenerarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgDocClick(Sender: TObject);
    procedure cbSistemaChange(Sender: TObject);
    procedure cbEmpresaChange(Sender: TObject);
    procedure btnRutaClick(Sender: TObject);
  private
    { Private declarations }
    clases_procesar : TStringList;
    sistema, sPriRutaSalida, empresa : String;
    tipo_doc : integer;
    guarda:array of datos;    //arreglo de la estructura para pasar los datos de la consulta       ALK
    qTSRELA: TAdoQuery;

    procedure obtieneClases( sParArchivo: String );
    function sObtieneRuta( sParArchivo: String ): String;
    function sObtenerSistema( sParArchivo: String ): String;
    procedure estadisticas (lista:TStringList);
  public
    { Public declarations }
    procedure procesa_componentes;
    procedure CrearDocCompo( sParSistema: String );
    procedure procesa_sistema;
    procedure CrearDocSistema( sParSistema: String );
    procedure procesa_negocios;
    procedure CrearDocNegocios( sParSistema: String );
  end;

var
  alkFormDocWord: TalkFormDocWord;

implementation

uses
   alkDocAutoDinamica, uConstantes,ptsdm;
{$R *.dfm}

procedure TalkFormDocWord.btnGenerarClick(Sender: TObject);
begin
   case tipo_doc of
      0: begin
            empresa:=cbEmpresa.Text;
            sistema:=cbSistema.Text;
            sPriRutaSalida:=lbruta.Text+'\';
            if empresa = '' then begin
               ShowMessage('Seleccione una empresa');
               exit;
            end;
            if sistema = '' then begin
               ShowMessage('Seleccione un sistema');
               exit;
            end;
            if sPriRutaSalida = '' then begin
               ShowMessage('Seleccione una ruta');
               exit;
            end;

            procesa_sistema;        // del sistema
         end;
      1: begin
            sistema:=cbSistema.Text;
            sPriRutaSalida:=lbruta.Text+'\';
            if sistema = '' then begin
               ShowMessage('Seleccione un sistema');
               exit;
            end;
            if sPriRutaSalida = '' then begin
               ShowMessage('Seleccione una ruta');
               exit;
            end;

            procesa_negocios;        //procesos de negocio
         end;
      else begin     // default componentes
         sistema:=cbSistema.Text;
         clases_procesar.Add(cbClase.Text);
         sPriRutaSalida:=lbruta.Text+'\';
         if sistema = '' then begin
            ShowMessage('Seleccione un sistema');
            exit;
         end;
         if sPriRutaSalida = '' then begin
            ShowMessage('Seleccione una ruta');
            exit;
         end;
         if cbClase.Text = '' then begin
            ShowMessage('Seleccione una clase');
            exit;
         end;
         procesa_componentes;
      end;
   end;
end;

procedure TalkFormDocWord.procesa_componentes;
var
   sNombreArchivo: String;
begin
   // --------- Pedir documento ini --------------
   {sNombreArchivo := sGlbAbrirDialogo;
   if sNombreArchivo = '' then
      Exit;

   if not FileExists( sNombreArchivo ) then begin
      Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
         'Cargar Configuración', MB_OK );
      Exit;
   end;

   sPriRutaSalida := sObtieneRuta( sNombreArchivo );  //-- Ruta donde se guardaran los documentos --
   if sPriRutaSalida = '' then
      Exit;

   sistema:=sObtenerSistema( sNombreArchivo );    // -- obtener el sistema
   if sistema ='' then exit;

   obtieneClases( sNombreArchivo );     // -- obtener las clases
   if clases_procesar.Count > 0 then
      Application.MessageBox( pChar( 'Configuracion de clases correcta.'),
         'Cargar Clases', MB_OK )
   else begin
      Application.MessageBox( pChar( 'No se cargo la configuracion de clases.'),
         'Cargar Clases', MB_OK );
      exit;
   end;
   }
   // --------------------------------------------
   // -- Una vez con el documento procesarlo con funcion --
   Screen.Cursor := crSQLWait;
   try
      CrearDocCompo( sistema );
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TalkFormDocWord.procesa_sistema;
begin
   // -- Una vez con el documento procesarlo con funcion --
   Screen.Cursor := crSQLWait;
   try
      CrearDocSistema( sistema );
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TalkFormDocWord.procesa_negocios;
var
   sNombreArchivo: String;
begin
   // --------- Pedir documento ini --------------
   {sNombreArchivo := sGlbAbrirDialogo;
   if sNombreArchivo = '' then
      Exit;

   if not FileExists( sNombreArchivo ) then begin
      Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
         'Cargar Configuración', MB_OK );
      Exit;
   end;

   sPriRutaSalida := sObtieneRuta( sNombreArchivo );  //-- Ruta donde se guardaran los documentos --
   if sPriRutaSalida = '' then
      Exit;

   sistema:=sObtenerSistema( sNombreArchivo );    // -- obtener el sistema
   if sistema ='' then exit;

   {obtieneClases( sNombreArchivo );     // -- obtener los componentes
   if clases_procesar.Count > 0 then
      Application.MessageBox( pChar( 'Configuracion de Componentes correcta.'),
         'Cargar Componentes', MB_OK )
   else begin
      Application.MessageBox( pChar( 'No se cargo la configuracion de componentes.'),
         'Cargar Componentes', MB_OK );
      exit;
   end;}

   // --------------------------------------------
   // -- Una vez con el documento procesarlo con funcion --
   Screen.Cursor := crSQLWait;
   try
      CrearDocNegocios( sistema );
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TalkFormDocWord.obtieneClases( sParArchivo: String );
var
   i: Integer;
   iLongitudArreglo: Integer;
   iniArchivo: TMemIniFile;
   slSeccionIni: TStringList;
   sClaseIni, sFormaIni: String;
begin
   iniArchivo := TMemIniFile.Create( sParArchivo );  //registra en aPriClaseForma

   clases_procesar.Sorted:=true;        //para que no se repitan valores

   try
      slSeccionIni := TStringList.Create;
      try
         iniArchivo.ReadSectionValues( 'Clases', slSeccionIni );

         //SetLength( aPriClaseForma, 0 );

         for i := 0 to slSeccionIni.Count - 1 do
            if pos( '//', slSeccionIni[ i ] ) = 0 then //>0 es comentario de linea
               clases_procesar.Add( UpperCase(slSeccionIni[ i ] ));
      finally
         slSeccionIni.Free;
      end;
   finally
      iniArchivo.Free;
   end;
end;

function TalkFormDocWord.sObtieneRuta( sParArchivo: String ): String;
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

function TalkFormDocWord.sObtenerSistema( sParArchivo: String ): String;
var
   iniArchivo: TIniFile;
   sTexto: String;
   sUltimoCaracter: String;
begin
   sTexto := '';
   try
      iniArchivo := TIniFile.Create( sParArchivo );
      try
         sTexto := iniArchivo.ReadString( 'CONFIGURACION', 'Sistema', '' );
      finally
         iniArchivo.Free;
      end;

      sTexto := Trim( sTexto );

      if sTexto = '' then begin
         Application.MessageBox( PChar( 'Parámetro "Sistema" incorrecto. ' + sTexto + Chr( 13 ) + Chr( 13 ) +
            'Asegúrese de tener el parámetro incluido en el archivo de' + Chr( 13 ) +
            'configuración o posiblemente el parámetro esta vacío.' ),
            pchar( 'Aviso' ), MB_OK );
         Exit;
      end;

      //validar que exista el sistema
      if not dm.sqlselect( dm.q1,
               'SELECT CSISTEMA FROM TSSISTEMA' +
               ' WHERE ESTADOACTUAL=' + g_q + 'ACTIVO' + g_q +
               ' AND CSISTEMA=' + g_q + sTexto + g_q) then begin

         Application.MessageBox( PChar( 'El sistema: ' + sTexto + ' No existe.'),
                                 pchar( 'Aviso' ), MB_OK );
         sTexto:='';
         Exit;
      end;
   finally
      Result := sTexto;
   end;
end;

// ------------ Crear log estadisticas, recibe una lista de archivos y genera un log -------------
procedure TalkFormDocWord.estadisticas (lista:TStringList);
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

   log_stadisticas.SaveToFile(g_logdir + '\LogEstadisticas.txt');
   log_stadisticas.Free;
end;
// -----------------------------------------------------------------------------------

procedure TalkFormDocWord.CrearDocCompo( sParSistema: String );
var
   sDirSistema, sClase, sBib, sProg : String;
   DocDinamica : TalkFormDocAutoDinam;
   k,i,cont:integer;
   fecha, doc_plantilla, fecha_aux, consulta : String;
   salva:Tstringlist;
   reprocesa : TStringList;
begin
   // =========================== Documentacion dinamica  ==================================
   try
      if dm.ProcessExists('WINWORD.EXE') then  // quitar todos los procesos word antes de abrir el nuestro
         dm.ProcessKill('WINWORD.EXE', true);

      dm.get_utileria('GENWORD',g_ruta+'htagw.exe');

      fecha:=FormatDateTime('yyyy/mm/dd',now);
      SetLength(guarda, 0);   //limpiar arreglo

      // llenar arreglo de componentes a procesar:
      for i := 0 to clases_procesar.Count - 1 do begin
         consulta:='SELECT HCCLASE, HCBIB, HCPROG' +
               ' FROM TSRELA' +
               ' WHERE' +
               '   HCCLASE = ' + g_q + clases_procesar[i] + g_q +
               '   AND SISTEMA = ' + g_q + sistema + g_q +
               ' GROUP BY HCCLASE, HCBIB, HCPROG' +
               ' ORDER BY HCBIB, HCCLASE';

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
   except
      ShowMessage('ERROR obteniendo clases a procesar');
   end;

   // ----------- Generando documentacion dinamica ---------
   try
      salva:=Tstringlist.Create;

      reprocesa:=TStringList.Create;

      if FileExists(g_logdir + '\LogEstadisticas.txt') then
         DeleteFile(g_logdir + '\LogEstadisticas.txt');

      salva.Add(':inicia');
      salva.Add('del "'+ g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt"');

      for k:=0 to Length( guarda )-1 do begin
         sClase:=guarda[k].cla;
         sBib:=guarda[k].bib;
         sProg:=guarda[k].comp;

         salva.Add(g_ruta+'htagw.exe '+g_odbc+' '+g_user_entrada+' '+
                  sClase+' '+sBib+' '+sistema+' '+sProg+' "'+sPriRutaSalida+'" 2 '+
                  fecha+' "'+g_ruta+'"');

         bGlbQuitaCaracteres(sProg);

         reprocesa.Add(ExtractFilePath(sPriRutaSalida) + sParSistema + '\Componentes\'+sClase+'\' +
                      'DT_' + sParSistema +'_'+ sClase +'_'+sBib+'_'+sProg+'.doc');

         // ---- para tener todos los word en la carpeta temporal -----
         //doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+guarda[0].cla+'.doc';
         doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+sClase+'_'+sProg+'.doc';
         dm.get_utileria( 'WORD_'+guarda[0].cla, doc_plantilla );
         g_borrar.Add(doc_plantilla);
      end;
   finally
      salva.Add('if exist "'+ g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt" goto inicia');

      salva.SaveToFile(g_tmpdir+'\documentos.bat');
      salva.Free;

      //shellexecute(0,'open',pchar(g_tmpdir+'\documentos.bat'),'','',SW_SHOW);
      dm.ejecuta_espera(g_tmpdir+'\documentos.bat',SW_SHOW);
      g_borrar.Add(g_tmpdir+'\documentos.bat');

      estadisticas(reprocesa);
      reprocesa.Free;
   end;
   // --------------------------------------------------------------------------------------
end;

procedure TalkFormDocWord.CrearDocSistema( sParSistema: String );
var
   sDirSistema, sClase, sBib, sProg : String;
   DocDinamica : TalkFormDocAutoDinam;
   k,i,cont:integer;
   fecha, doc_plantilla, fecha_aux, consulta : String;
   salva:Tstringlist;
   reprocesa : TStringList;
begin
   // =========================== Documentacion dinamica  ==================================
   try
      if dm.ProcessExists('WINWORD.EXE') then  // quitar todos los procesos word antes de abrir el nuestro
         dm.ProcessKill('WINWORD.EXE', true);

      dm.get_utileria('GENWORD',g_ruta+'htagw.exe');

      fecha:=FormatDateTime('yyyy/mm/dd',now);
      SetLength(guarda, 0);   //limpiar arreglo

      if not dm.sqlselect(dm.q2,'select distinct pcbib from'+
                          ' tsrela where pcclase='+ g_q +'NEG'+ g_q +
                          ' and sistema='+ g_q +sistema+ g_q) then begin
         ShowMessage('ERROR No se pudo obtener la biblioteca');
         exit
      end;
      SetLength(guarda, 1);   //crear espacio en el arreglo
      guarda[0].cla:='NEG';
      guarda[0].bib:=dm.q2.FieldByName( 'pcbib' ).AsString;
      guarda[0].comp:=empresa;
   except
      ShowMessage('ERROR obteniendo datos a procesar');
   end;

   // ----------- Generando documentacion dinamica ---------
   try
      salva:=Tstringlist.Create;
      reprocesa:=TStringList.Create;

      if FileExists(g_logdir + '\LogEstadisticas.txt') then
         DeleteFile(g_logdir + '\LogEstadisticas.txt');

      salva.Add(':inicia');
      salva.Add('del "'+ g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt"');

      for k:=0 to Length( guarda )-1 do begin
         sClase:=guarda[k].cla;
         sBib:=guarda[k].bib;
         sProg:=guarda[k].comp;

         salva.Add(g_ruta+'htagw.exe "'+g_odbc+'" "'+g_user_entrada+'" "'+
                  sClase+'" "'+sBib+'" "'+sistema+'" "'+sProg+'" "'+sPriRutaSalida+'" 1 '+
                  fecha+' "'+g_ruta+'"');

         bGlbQuitaCaracteres(sProg);

         reprocesa.Add(ExtractFilePath(sPriRutaSalida) + sParSistema + '\Sistema\' +
                      'DT_' + sParSistema +'_'+ sClase +'_'+sBib+'_'+sProg+'.doc');

         // ---- para tener todos los word en la carpeta temporal -----
         doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+sParSistema+'.doc';
         dm.get_utileria( 'WORD_NEG', doc_plantilla );
      end;
   finally
      salva.Add('if exist "'+ g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt" goto inicia');

      salva.SaveToFile(g_tmpdir+'\documentos.bat');
      salva.Free;

      //shellexecute(0,'open',pchar(g_tmpdir+'\documentos.bat'),'','',SW_SHOW);
      dm.ejecuta_espera(g_tmpdir+'\documentos.bat',SW_SHOW);
      estadisticas(reprocesa);
      reprocesa.Free;
   end;
   // --------------------------------------------------------------------------------------
end;


procedure TalkFormDocWord.CrearDocNegocios( sParSistema: String );
var
   sDirSistema, sClase, sBib, sProg : String;
   DocDinamica : TalkFormDocAutoDinam;
   k,i,cont:integer;
   fecha, doc_plantilla, fecha_aux, consulta : String;
   salva:Tstringlist;
   reprocesa : TStringList;
begin
   // =========================== Documentacion dinamica  ==================================
   try
      if dm.ProcessExists('WINWORD.EXE') then  // quitar todos los procesos word antes de abrir el nuestro
         dm.ProcessKill('WINWORD.EXE', true);

      dm.get_utileria('GENWORD',g_ruta+'htagw.exe');

      fecha:=FormatDateTime('yyyy/mm/dd',now);
      SetLength(guarda, 0);   //limpiar arreglo

      // llenar arreglo de componentes a procesar:
      //for i := 0 to clases_procesar.Count - 1 do begin
         consulta:= {'select DISTINCT CCLASE, CBIB, CPROG'+
                    ' from tsprog where cclase='+ g_q + 'NEP' + g_q +
                    ' order by cbib, cprog'; }
         'select DISTINCT PCCLASE, PCBIB, PCPROG from tsrela where' +
               ' pcclase='+ g_q +'NEP' + g_q + ' and hcclase<>'+ g_q +'NEP'+ g_q+
               ' and sistema='+g_q+sParSistema+g_q;

         qTSRELA := TAdoQuery.Create( Self );
         qTSRELA.Connection := dm.ADOConnection1;

         if dm.sqlselect( qTSRELA, consulta ) then begin
            SetLength(guarda, qTSRELA.RecordCount);
            cont:=0;

            while not qTSRELA.Eof do begin
               //guarda todos los datos para despues mandarlos procesar todos juntos por producto
               guarda[cont].cla:=qTSRELA.FieldByName( 'PCCLASE' ).AsString;
               guarda[cont].bib:=qTSRELA.FieldByName( 'PCBIB' ).AsString;
               guarda[cont].comp:=qTSRELA.FieldByName( 'PCPROG' ).AsString;

               qTSRELA.Next;
               cont:=cont+1;
            end;
         end;
      //end;
   except
      ShowMessage('ERROR obteniendo clases a procesar');
   end;

   // ----------- Generando documentacion dinamica ---------
   try
      salva:=Tstringlist.Create;
      reprocesa:=TStringList.Create;

      if FileExists(g_logdir + '\LogEstadisticas.txt') then
         DeleteFile(g_logdir + '\LogEstadisticas.txt');

      salva.Add(':inicia');
      salva.Add('del "'+ g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt"');

      for k:=0 to Length( guarda )-1 do begin
         sClase:=guarda[k].cla;
         sBib:=guarda[k].bib;
         sProg:=guarda[k].comp;

         salva.Add(g_ruta+'htagw.exe '+g_odbc+' '+g_user_entrada+' '+
                  sClase+' '+sBib+' '+sistema+' '+sProg+' "'+sPriRutaSalida+'" 2 '+
                  fecha+' "'+g_ruta+'"');

         bGlbQuitaCaracteres(sProg);

         reprocesa.Add(ExtractFilePath(sPriRutaSalida) + sParSistema + '\PROCESO_NEGOCIO\'+sClase+'\' +
                      'DT_' + sParSistema +'_'+ sClase +'_'+sBib+'_'+sProg+'.doc');

         // ---- para tener todos los word en la carpeta temporal -----
         //doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+guarda[0].cla+'.doc';
         doc_plantilla:= g_tmpdir + '\' + 'Plantilla_Word_'+sClase+'_'+sProg+'.doc';
         dm.get_utileria( 'WORD_'+guarda[0].cla, doc_plantilla );
      end;
   finally
      salva.Add('if exist "'+ g_logdir + '\LogDocAut_' + stringreplace( fecha, '/', ' ', [ rfReplaceAll ] ) + '.txt" goto inicia');

      salva.SaveToFile(g_tmpdir+'\documentos.bat');
      salva.Free;

      //shellexecute(0,'open',pchar(g_tmpdir+'\documentos.bat'),'','',SW_SHOW);
      if fileexists(doc_plantilla) then begin
         dm.ejecuta_espera(g_tmpdir+'\documentos.bat',SW_SHOW);
         estadisticas(reprocesa);
      end;
      reprocesa.Free;
   end;
   // --------------------------------------------------------------------------------------
end;



procedure TalkFormDocWord.FormDestroy(Sender: TObject);
begin
   clases_procesar.Free;
end;

procedure TalkFormDocWord.FormCreate(Sender: TObject);
begin
   clases_procesar := TStringList.Create;     //inicializar lista ordenada
end;

procedure TalkFormDocWord.rgDocClick(Sender: TObject);
var
   consulta: String;
begin
   tipo_doc:=rgDoc.ItemIndex;
   case tipo_doc of
      0: begin
            cbEmpresa.Enabled:=true;
            cbSistema.Enabled:=true;
            cbClase.Enabled:=false;
            lbRuta.Enabled:=true;
            btnRuta.Enabled:=true;
            btnGenerar.Enabled:=false;

            dm.feed_combo( cbEmpresa, 'select dato from parametro where clave=' +
                           g_q + 'EMPRESA-NOMBRE-1' + g_q );
         end;      //sistema
      1: begin
            cbEmpresa.Enabled:=false;
            cbSistema.Enabled:=true;
            cbClase.Enabled:=false;
            lbRuta.Enabled:=true;
            btnRuta.Enabled:=true;
            btnGenerar.Enabled:=false;

            dm.feed_combo( cbSistema, 'select csistema from tssistema order by csistema' );
         end;      //procesos de negocio
      else begin
            cbEmpresa.Enabled:=false;
            cbSistema.Enabled:=true;
            cbClase.Enabled:=true;
            lbRuta.Enabled:=true;
            btnRuta.Enabled:=true;
            btnGenerar.Enabled:=false;

            dm.feed_combo( cbSistema, 'select csistema from tssistema order by csistema' );
         end;     // default componentes
   end;
   cbEmpresa.Text:='';
   cbSistema.Text:='';
   cbClase.Text:='';
   lbRuta.Text:='';
end;

procedure TalkFormDocWord.cbSistemaChange(Sender: TObject);
var
   i : integer;
   con:string;
   cl:TStringList;
begin
   con:='select dato from parametro where clave = '
         + g_q + 'DOC_CLA_'+cbSistema.text + g_q;
   if tipo_doc <> 2 then
      exit;

   if not dm.sqlselect(dm.q1,con) then
      dm.feed_combo( cbclase, 'select distinct cclase from tsprog ' +
                  ' where sistema=' + g_q + cbSistema.text + g_q +
                  'and cclase not in ('+ g_q +'NEP'+ g_q +','+ g_q +'NEG'+ g_q +')' +
                  ' order by cclase' )
   else begin
      cl:=TStringList.Create;
      cbclase.Clear;
      
      cl.CommaText:=dm.q1.FieldByName( 'dato' ).AsString;
      for i:=0 to cl.count-1 do
         cbclase.Items.Add(cl[i]);

      cl.Free;
   end;
end;

procedure TalkFormDocWord.cbEmpresaChange(Sender: TObject);
begin
   dm.feed_combo( cbSistema, 'select csistema from tssistema order by csistema' );
end;

procedure TalkFormDocWord.btnRutaClick(Sender: TObject);
var
   ruta, sRutaMisDocumentos: String;
   SELDIRHELP:integer;
begin
   ruta:='C:';
   SELDIRHELP := 1000;
   if FileCtrl.SelectDirectory(ruta, [sdAllowCreate, sdPerformCreate, sdPrompt],
                               SELDIRHELP) then
      lbruta.Text := ruta;
   btnGenerar.Enabled:=true;
end;

end.
