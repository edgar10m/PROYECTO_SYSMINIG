unit ptscomun;
interface
uses Classes, ShellAPI, SysUtils, Controls, ADODB, DB, Forms, windows, dialogs;
function xlng( mensaje: string ): string;
function magico( buffer: pchar; lon: integer ): string;
function filemagic( arch: string ): string;
function mismo_server: boolean;
procedure checa_directorio( dire: string; ruta: string; visual: boolean = true );
function ejecuta_espera( FileName: String; Visibility: integer ): boolean;
function pathbib( biblioteca: string; clase: string ): string;
Procedure blob2file( clave: string; archivo: string );
procedure get_utileria( utileria: string; archivo: string; visual: boolean = true; esdirectiva:boolean=true );
function datedb( fecha: string; formato: string ): string;
procedure inserta_tslog( cmbclase_text, cmbbiblioteca_text, nom, rutina, clave, descripcion, estado, origen: string );
function cprog2bfile( nombre: string ): string;
function bfile2cprog( nombre: string ): string;
function GetFileTimes(FileName : string;
   var Created : TDateTime;
   var Modified : TDateTime;
   var Accessed : TDateTime) : boolean;      //RGM para diagrama interactivo CBL

function tiene_letras_o_numeros(dato:string):boolean;   //RGM para rayas en el arbol
procedure codigo_muerto(sistema,prog,bib,clase:string);  // RGM para el codigo muerto
procedure CrearArchivoTexto(titulo,contenido:String);  //para crear un archivo   ALK
procedure parametros_extra(sis,cla,bib,archivo:string);
procedure muestra_mensaje(texto,caption:string; aborta:boolean=false;
   clase:string='XXX';bib:string='SCRATCH'; nom:string='SCRATCH';
   rutina:string='SCRATCH';clave:string='XXX';estado:string='ERROR';origen:string='XXX');
procedure da_tipo_cbl(sis,cla,bib,archivo:string; var resultado: TStringList); //---para dar el tipo de cobol ALK---
function get_copylib(sistema:string):string;
function cuenta_caracteres(pal:string; sub:char):integer;

implementation
uses ptsdm;

function xlng( mensaje: string ): string;
begin
   if g_language = 'ENGLISH' then begin
      mensaje := stringreplace( mensaje, 'Opcion inconsistente en el titulo de los TAB',
         'Option and TAB title are inconsistent', [ ] );
      mensaje := stringreplace( mensaje, 'ERROR... Password incorrecto',
         'ERROR... bad Password', [ ] );
      mensaje := stringreplace( mensaje, 'No hay resultados',
         'No records selected', [ ] );
      mensaje := stringreplace( mensaje, 'ERROR... el registro ya existe',
         'ERROR... record exists', [ ] );
      mensaje := stringreplace( mensaje, 'ERROR... no puede dar el INSERT',
         'ERROR... can not INSERT', [ ] );
      mensaje := stringreplace( mensaje, 'ERROR... no puede dar el UPDATE',
         'ERROR... can not UPDATE', [ ] );
      mensaje := stringreplace( mensaje, 'ERROR... no puede dar el DELETE',
         'ERROR... can not DELETE', [ ] );
      mensaje := stringreplace( mensaje, 'La Clave de Usuario no debe quedar vacia',
         'User key can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Nombre no debe quedar vacio',
         'Name can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Password no debe quedar vacio',
         'Password can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Clave de Rol no debe quedar vacia',
         'Roll key can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Descripcion no debe quedar vacia',
         'Description can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Clave no debe quedar vacia',
         'Key can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Dato no debe quedar vacio',
         'Data can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Clase no debe quedar vacia',
         'Key Class can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El tipo no debe quedar vacio',
         'Type can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Sistema no debe quedar vacio',
         'Application can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Oficina no debe quedar vacia',
         'Office can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El sistema padre no puede ser el mismo',
         'Parent Application can not be the same', [ ] );
      mensaje := stringreplace( mensaje, 'La Utileria no debe quedar vacia',
         'Utility can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Clave de Biblioteca no debe quedar vacia',
         'Library can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Categoría no debe quedar vacia',
         'Category can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Clave de Análisis de Performance no debe quedar vacia',
         'APA Key can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Concepto no debe quedar vacio',
         'Concept can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Subconcepto no debe quedar vacio',
         'Subconcept can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Minimo no debe quedar vacio',
         'Minimum can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Maximo no debe quedar vacio',
         'Maximum can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Tipo de Folio no debe quedar vacio',
         'Folio Type can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Numero de Folio no debe quedar vaci',
         'Folio Number can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Entorno no debe quedar vacio',
         'Environment can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Proyecto no debe quedar vacio',
         'Project can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'La Entidad no debe quedar vacia',
         'Entity can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'El Programa no debe quedar vacio',
         'Program can not be empty', [ ] );
      mensaje := stringreplace( mensaje, 'Llave incorrecta',
         'Bad key', [ ] );
      mensaje := stringreplace( mensaje, 'No está cargada la utileria',
         'Utility not loaded:', [ ] );
      mensaje := stringreplace( mensaje, 'Licencia incorrecta',
         'Bad license', [ ] );
      mensaje := stringreplace( mensaje, 'password no confirmado',
         'Password not confirmed', [ ] );
      mensaje := stringreplace( mensaje, 'no puede actualizar password',
         'Password can not be updated', [ ] );
      mensaje := stringreplace( mensaje, 'No puede crear directorio',
         'Can not create directory:', [ ] );
      mensaje := stringreplace( mensaje, 'no tiene definido PATH en catálogo de bibliotecas',
         'No PATH defined for Library', [ ] );
      mensaje := stringreplace( mensaje, 'no existe el directorio',
         'Directory do not exists:', [ ] );
      mensaje := stringreplace( mensaje, 'no existe el archivo',
         'File do not exists:', [ ] );
      mensaje := stringreplace( mensaje, 'No se dio de alta ningún componente',
         'Any component was added', [ ] );
      mensaje := stringreplace( mensaje, 'no puede actualizar registro a tsprog',
         'Can not update tsprog record', [ ] );
      mensaje := stringreplace( mensaje, 'no puede agregar registro a tsprog',
         'Can not insert to tsprog', [ ] );
      mensaje := stringreplace( mensaje, 'no puede agregar registro a tsversion',
         'Can not insert to tsversion', [ ] );
      mensaje := stringreplace( mensaje, 'no puede integrar a',
         'Can not add to', [ ] );
      mensaje := stringreplace( mensaje, 'no puede borrar BLOB anterior',
         'can not delete previous BLOB', [ ] );
      mensaje := stringreplace( mensaje, 'Utileria cargada correctamente',
         'Utility loaded correctly', [ ] );
      mensaje := stringreplace( mensaje, 'No puede ejecutar la comparacion',
         'Can not compare', [ ] );
      mensaje := stringreplace( mensaje, 'No tiene definida la Herramienta de',
         'Utility not defined:', [ ] );
      mensaje := stringreplace( mensaje, 'Elimina el componente de la Base de Conocimiento',
         'Delete from Knowledge Base', [ ] );
      mensaje := stringreplace( mensaje, 'Reporte de Componentes de',
         'List of Components for', [ ] );
      mensaje := stringreplace( mensaje, 'ELIMINAR',
         'DELETE', [ ] );
      mensaje := stringreplace( mensaje, 'Compara con:',
         'Compare with:', [ ] );
      mensaje := stringreplace( mensaje, 'Desea limpiar el area de captura?',
         'Do you want to clean it?', [ ] );
      mensaje := stringreplace( mensaje, 'Desea borrar este registro?',
         'Do you want to delete it?', [ ] );
      mensaje := stringreplace( mensaje, 'Desea darla de alta?',
         'Do you want to add it?', [ ] );
      mensaje := stringreplace( mensaje, 'es igual a las versiones',
         'is identical to versions', [ ] );
      mensaje := stringreplace( mensaje, 'no puede actualizar',
         'can not update', [ ] );
      mensaje := stringreplace( mensaje, 'archivos procesados en',
         'files processed in', [ ] );
      mensaje := stringreplace( mensaje, 'el componente aparece más de una vez',
         'component has duplicates', [ ] );
      mensaje := stringreplace( mensaje, 'no soportado', 'unsupported', [ ] );
      mensaje := stringreplace( mensaje, 'El componente',
         'Component', [ ] );
      mensaje := stringreplace( mensaje, 'Pagina:',
         'Page:', [ ] );
      mensaje := stringreplace( mensaje, 'Registros:',
         'Records:', [ ] );
      mensaje := stringreplace( mensaje, 'Titulo del Anexo',
         'Attachment title', [ ] );
      mensaje := stringreplace( mensaje, 'Titulo del documento',
         'Document title', [ ] );
      mensaje := stringreplace( mensaje, 'Inventario de',
         'Inventory of', [ ] );
      mensaje := stringreplace( mensaje, 'no puede insertar en',
         'can not insert', [ ] );
      mensaje := stringreplace( mensaje, 'no puede borrar en',
         'can not delete', [ ] );
      mensaje := stringreplace( mensaje, 'no puede actualizar en',
         'can not update', [ ] );
      mensaje := stringreplace( mensaje, 'BIBLIOTECA',
         'LIBRARY', [ ] );
      mensaje := stringreplace( mensaje, 'DESCRIPCION',
         'DESCRIPTION', [ ] );
      mensaje := stringreplace( mensaje, 'DIRECCION IP',
         'IP ADDRESS', [ ] );
      mensaje := stringreplace( mensaje, 'CLAVE DE USUARIO',
         'USER ID', [ ] );
      mensaje := stringreplace( mensaje, 'NOMBRE',
         'FIRST NAME', [ ] );
      mensaje := stringreplace( mensaje, 'APELLIDO PATERNO',
         'LAST NAME', [ ] );
      mensaje := stringreplace( mensaje, 'APELLIDO MATERNO',
         'LAST NAME 2', [ ] );
      mensaje := stringreplace( mensaje, 'CLAVE DE ROL',
         'ROLL ID', [ ] );
      mensaje := stringreplace( mensaje, 'CAPACIDAD MINERIA',
         'CAPACITY', [ ] );
      mensaje := stringreplace( mensaje, 'CLAVE DE PARAMETRO',
         'PARAMETER ID', [ ] );
      mensaje := stringreplace( mensaje, 'SECUENCIA',
         'SEQUENCE', [ ] );
      mensaje := stringreplace( mensaje, 'DATO',
         'DATA', [ ] );
      mensaje := stringreplace( mensaje, 'Documentación',
         'Documentation', [ ] );
      mensaje := stringreplace( mensaje, 'Confirmar',
         'Confirm', [ ] );
      mensaje := stringreplace( mensaje, 'Guardar',
         'Save', [ ] );
      mensaje := stringreplace( mensaje, 'Actualizar',
         'Update', [ ] );
   end;
   xlng := mensaje;
end;

function magico( buffer: pchar; lon: integer ): string;
var
   i, j: integer;
   b: array[ 1..5 ] of integer;
   mag, m: string;
begin
   for i := 1 to 5 do
      b[ i ] := 0;
   for i := 0 to lon - 1 do begin
      for j := 1 to 5 do begin
         b[ j ] := b[ j ] + ord( buffer[ i ] ) * j + b[ ( j mod 5 ) + 1 ] mod 10;
         b[ j ] := b[ j ] mod 1000000000;
      end;
   end;
   mag := '';
   for j := 1 to 5 do begin
      b[ j ] := b[ j ] mod 1000000;
      m := inttostr( b[ j ] );
      m := copy( '000000', 1, 6 - length( m ) ) + m;
      mag := mag + m;
   end;
   magico := mag;
end;

function filemagic( arch: string ): string;
var
   fil: Tstringlist;
begin
   if fileexists( arch ) = false then begin
      application.MessageBox( pchar( 'ERROR... El archivo ' + arch + ' no existe' ), 'ERROR', MB_OK );
      filemagic := '';
      exit;
   end;
   fil := Tstringlist.Create;
   fil.LoadFromFile( arch );
   filemagic := magico( pchar( fil.Text ), length( fil.Text ) );
   fil.Free;
end;

function ejecuta_espera( FileName: String; Visibility: integer ): boolean;
var
   zAppName: array[ 0..2048 ] of char;
   zCurDir: array[ 0..255 ] of char;
   WorkDir: String;
   StartupInfo: TStartupInfo;
   ProcessInfo: TProcessInformation;
   resultado: longword;
begin
   filename := getenvironmentVariable( 'ComSpec' ) + ' /C ' + filename;
   StrPCopy( zAppName, FileName );
   GetDir( 0, WorkDir );
   StrPCopy( zCurDir, WorkDir );
   FillChar( StartupInfo, Sizeof( StartupInfo ), #0 );
   StartupInfo.cb := Sizeof( StartupInfo );
   StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
   StartupInfo.wShowWindow := Visibility;
   if not CreateProcess( nil, zAppName,
      nil,
      nil,
      false,
      CREATE_NEW_CONSOLE or
      NORMAL_PRIORITY_CLASS,
      nil,
      nil,
      StartupInfo,
      ProcessInfo ) then begin
      CloseHandle( ProcessInfo.hProcess );
      Result := false;
   end
   else begin
      WaitforSingleObject( ProcessInfo.hProcess, INFINITE );
      GetExitCodeProcess( ProcessInfo.hProcess, Resultado );
      CloseHandle( ProcessInfo.hProcess );
      result := true;
   end;
end;

procedure inserta_tslog( cmbclase_text, cmbbiblioteca_text, nom, rutina, clave, descripcion, estado, origen: string );
var
   repite: integer;
begin
   repite := 2;
   while repite > 0 do begin
      if dm.sqlinsert( 'insert into tslog (cprog,cbib,cclase,proceso,fecha,rutina,clave,descripcion,estado,cuser) values(' +
         g_q + nom + g_q + ',' +
         g_q + cmbbiblioteca_text + g_q + ',' +
         g_q + cmbclase_text + g_q + ',' +
         g_q + copy( origen, 1, 50 ) + g_q + ',' +
         datedb( formatdatetime( 'YYYY/MM/DD HH:NN:SS', now ), 'YYYY/MM/DD HH24:MI:SS' ) + ',' +
         g_q + rutina + g_q + ',' +
         g_q + clave + g_q + ',' +
         g_q + copy( descripcion, 1, 500 ) + g_q + ',' +
         g_q + estado + g_q + ',' +
         g_q + g_usuario + g_q + ')' ) then
         repite := 0
      else begin
         repite := repite - 1;
         sleep( 1000 );
      end;
   end;
end;

function pathbib( biblioteca: string; clase: string ): string;
var
   i: integer;
begin
   for i := 0 to length( g_pathbibs ) - 1 do begin
      if ( g_pathbibs[ i ].nombre = biblioteca ) and
         ( g_pathbibs[ i ].clase = clase ) then begin
         pathbib := g_pathbibs[ i ].ruta;
         exit;
      end;
   end;
   if dm.sqlselect( dm.q2, 'select * from tsbibcla ' +
      ' where cbib=' + g_q + biblioteca + g_q +
      ' and   cclase=' + g_q + clase + g_q ) then begin
      if trim( dm.q2.fieldbyname( 'path' ).asstring ) = '' then begin
         pathbib := '';
         exit;
      end;
      i := length( g_pathbibs );
      setlength( g_pathbibs, i + 1 );
      g_pathbibs[ i ].nombre := biblioteca;
      g_pathbibs[ i ].clase := clase;
      g_pathbibs[ i ].ruta := dm.q2.fieldbyname( 'path' ).asstring;
      pathbib := g_pathbibs[ i ].ruta;
      exit;
   end;
   pathbib := '';
end;

Procedure blob2file( clave: string; archivo: string );
begin
   try
      dm.ADOQ.Close;
      dm.ADOQ.SQL.CLear;
      dm.ADOQ.SQL.Add( 'Select * from Tsblob where cblob=' + g_q + clave + g_q );
      dm.ADOQ.Open;
      dm.ADOQ.First;
      TBlobField( dm.ADOQ.FieldByName( 'Blo' ) ).savetofile( archivo );
      dm.ADOQ.close;
   except
   end;
end;

function mismo_server: boolean;
var
   nserver, ncliente: string;
begin
   nserver := '?';
   if dm.sqlselect( dm.q1, 'select SYS_CONTEXT(' + g_q + 'USERENV' + g_q + ', ' +
      g_q + 'SERVER_HOST' + g_q + ') nombre from dual' ) then begin
      nserver := uppercase( dm.q1.fieldbyname( 'nombre' ).asstring );
   end;
   if dm.sqlselect( dm.q1, 'select SYS_CONTEXT(' + g_q + 'USERENV' + g_q + ', ' +
      g_q + 'TERMINAL' + g_q + ') nombre from dual' ) then begin // podria ser 'HOST'
      ncliente := uppercase( dm.q1.fieldbyname( 'nombre' ).asstring );
   end;
   mismo_server := ( nserver = ncliente );
end;

procedure checa_directorio( dire: string; ruta: string; visual: boolean = true );
var
   b_direxiste: boolean;
   dirprod: string;
begin
   b_direxiste := false;
   if g_mismoserver = false then
      g_mismoserver := mismo_server;
   if dm.sqlselect( dm.q5, 'select * from all_directories ' +
      ' where directory_name=' + g_q + dire + g_q ) then begin
      if ruta <> dm.q5.FieldByName( 'directory_path' ).AsString then begin
         if ( ( g_usuario = 'ADMIN' ) or ( g_usuario = 'SVS' ) ) and g_mismoserver then begin
            if visual then begin
               if application.MessageBox( pchar( 'Diferencia en path de la biblioteca ' +
                  dire + chr( 13 ) + ruta + chr( 13 ) +
                  dm.q5.FieldByName( 'directory_path' ).AsString + chr( 13 ) +
                  'Desea cambiar la ruta del directorio ORACLE?' ),
                  'Confirme', MB_YESNO ) = IDYES then begin
                  if dm.sqldelete( 'drop directory ' + dire ) = false then begin
                     Application.MessageBox( pchar( dm.xlng( 'ERROR... no tiene permiso DROP ANY DIRECTORY' ) ),
                        pchar( dm.xlng( 'Validar directorio ' ) ), MB_OK );
                     application.Terminate;
                     abort;
                  end;
               end
               else begin
                  Application.MessageBox( pchar( dm.xlng( 'ERROR... DM1001 Inconsistencia entre TSBIB y directorio ORACLE' ) ),
                     pchar( dm.xlng( 'Validar directorio ' ) ), MB_OK );
                  exit;
               end;
            end
            else begin
               Application.MessageBox( pchar( dm.xlng( 'ERROR... DM1002 Inconsistencia entre TSBIB y directorio ORACLE' ) ),
                  pchar( dm.xlng( 'Validar directorio ' ) ), MB_OK );
               exit;
            end;
         end
         else begin
            inserta_tslog( 'XXX', 'SCRATCH', 'SCRATCH', 'get_utileria', 'F022', 'Diferencia en path de la biblioteca ' +
               dire + ruta +
               dm.q5.FieldByName( 'directory_path' ).AsString, 'FATAL', g_usuario );
            abort;
         end;
      end
      else
         b_direxiste := true;
   end;
   if g_mismoserver then begin
      // checa que exista el directorio
      if directoryexists( ruta ) = false then begin
         if visual then begin
            if ( g_usuario = 'ADMIN' ) or ( g_usuario = 'SVS' ) then begin
               if application.MessageBox( pchar( 'El directorio físico de ' + chr( 13 ) +
                  dire + ' -> ' + ruta + ' no existe.' + chr( 13 ) +
                  'Desea crearlo?' ), 'Validar directorio', MB_YESNO ) = IDYES then begin
                  if forcedirectories( ruta ) = false then begin
                     dm.muestra_error( 'ERROR... DM1005 No puede crear el directorio ' + ruta );
                  end;
               end
            end
            else begin
               Application.MessageBox( pchar( dm.xlng( 'WARNING... DM6001 El directorio físico de ' + chr( 13 ) +
                  dire + ' -> ' + ruta + ' no existe.' ) ),
                  pchar( dm.xlng( 'Validar directorio' ) ), MB_OK );
            end;
         end
         else begin
            inserta_tslog( 'XXX', 'SCRATCH', 'SCRATCH', 'get_utileria', 'F023', 'El directorio físico de ' +
               dire + ' -> ' + ruta + ' no existe.', 'FATAL', g_usuario );
            abort;
         end;
      end;
      if b_direxiste = false then begin
         if visual then begin
            if dm.sqlinsert( 'create directory ' + dire + ' as ' + g_q + ruta + g_q ) = false then begin
               Application.MessageBox( pchar( dm.xlng( 'ERROR... DM1003 no tiene permiso CREATE ANY DIRECTORY ' + chr( 13 ) +
                  '  ' + dire + ' ' + ruta ) ), pchar( dm.xlng( 'Validar directorio ' ) ), MB_OK );
               application.Terminate;
               abort;
            end;
         end
         else begin
            inserta_tslog( 'XXX', 'SCRATCH', 'SCRATCH', 'get_utileria', 'F024', dm.xlng( 'ERROR... DM1003 no tiene permiso CREATE ANY DIRECTORY ' +
               '  ' + dire + ' ' + ruta ), 'FATAL', g_usuario );
            abort;
         end;
      end;
   end;
end;

procedure get_utileria( utileria: string; archivo: string; visual: boolean = true; esdirectiva:boolean=true );
var
   nblob: string;
   dato: string;
   revisa: Tstringlist;
   i, j: integer;
begin
   if dm.sqlselect( dm.q1, 'select * from tsutileria ' +
      ' where cutileria=' + g_q + utileria + g_q +
      ' and cblob is not null' ) then begin
      nblob := dm.q1.fieldbyname( 'cblob' ).AsString;
      blob2file( nblob, archivo );
      g_borrar.Add( archivo );
      if (copy( utileria, 1, 11 ) = 'DIRECTIVAS ') or (esdirectiva) then begin
         revisa := Tstringlist.Create;
         revisa.LoadFromFile( archivo );
         for i := 0 to revisa.Count - 1 do begin
            if copy( trim( revisa[ i ] ), 1, 6 ) = 'GUTIL ' then begin
               dato := copy( trim( revisa[ i ] ), 11, 100 );
               j := pos( '\\', dato );
               if ( j < 1 ) or ( copy( dato, 1, 1 ) <> 'r' ) then begin
                  if visual then begin
                     Application.MessageBox( pchar( dm.xlng( 'Aviso ... GUTIL requiere una utileria(falta \\ o r) "' + dato + '"' ) ),
                        pchar( dm.xlng( 'Trae utilería' ) ), MB_OK );
                     screen.Cursor := crdefault;
                  end
                  else begin
                     inserta_tslog( 'XXX', 'SCRATCH', 'SCRATCH', 'get_utileria', 'F021', 'ERROR... GUTIL requiere una utileria(falta \\)  ' + dato, 'FATAL', g_usuario );
                  end;
                  revisa.Free;
                  abort;
               end;
               dato := copy( dato, 2, j - 2 );
               get_utileria( dato, g_ruta + 'tmp\GUTIL_' + stringreplace( dato, ' ', '_', [ rfreplaceall ] ) );
            end;
         end;
         revisa.Free;
      end;
   end
   else begin
      if visual then begin
         Application.MessageBox( pchar( dm.xlng( 'Aviso ... No está cargada la utilería "' + utileria + '"' ) ),
            pchar( dm.xlng( 'Trae utilería' ) ), MB_OK );
         screen.Cursor := crdefault;
      end
      else begin
         inserta_tslog( 'XXX', 'SCRATCH', 'SCRATCH', 'get_utileria', 'F021', 'ERROR... no está cargada la utileria ' + utileria, 'FATAL', g_usuario );
      end;
      abort;
   end;
end;

function datedb( fecha: string; formato: string ): string;
begin
   if g_database = 'ORACLE' then
      datedb := 'TO_DATE(' + g_q + fecha + g_q + ',' + g_q + formato + g_q + ')'
   else
      datedb := g_q + fecha + g_q;
end;

function cprog2bfile( nombre: string ): string;
begin
   nombre := stringreplace( nombre, '_', '___', [ rfreplaceall ] );         
   nombre := stringreplace( nombre, '%', '__a', [ rfreplaceall ] );
   nombre := stringreplace( nombre, ':', '__b', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '/', '__c', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '\', '__d', [ rfreplaceall ] );
   nombre := stringreplace( nombre, ' ', '__e', [ rfreplaceall ] );
   cprog2bfile := nombre;
end;

function bfile2cprog( nombre: string ): string;
begin
   nombre := stringreplace( nombre, '___', '_', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '__a', '%', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '__b', ':', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '__c', '/', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '__d', '\', [ rfreplaceall ] );
   nombre := stringreplace( nombre, '__e', ' ', [ rfreplaceall ] );
   bfile2cprog := nombre;
end;

//------------------ RGM para diagrama de flujo CBL ---------------------
// ================================================================
// Return the three dates (Created,Modified,Accessed)
// of a given filename. Returns FALSE if file cannot
// be found or permissions denied. Results are returned
// in TdateTime VAR parameters
// ================================================================
// ================================================================
// Devuelve las tres fechas (Creación, modificación y último acceso)
// de un fichero que se pasa como parámetro.
// Devuelve FALSO si el fichero no se ha podido acceder, sea porque
// no existe o porque no se tienen permisos. Las fechas se devuelven
// en tres parámetros de ipo DateTime
// ================================================================
function GetFileTimes(FileName : string;
   var Created : TDateTime;
   var Modified : TDateTime;
   var Accessed : TDateTime) : boolean;
var
   FileHandle : integer;
   Retvar : boolean;
   FTimeC,FTimeA,FTimeM : TFileTime;
   LTime : TFileTime;
   STime : TSystemTime;
begin
   // Abrir el fichero
   FileHandle := FileOpen(FileName,fmShareDenyNone);
   // inicializar
   Created := 0.0;
   Modified := 0.0;
   Accessed := 0.0;
   // Ha tenido acceso al fichero?
   if FileHandle < 0 then
      RetVar := false
   else begin
      // Obtener las fechas
      RetVar := true;
      GetFileTime(FileHandle,@FTimeC,@FTimeA,@FTimeM);
      // Cerrar
      FileClose(FileHandle);
      // Creado
      FileTimeToLocalFileTime(FTimeC,LTime);
      if FileTimeToSystemTime(LTime,STime) then begin
         Created := EncodeDate(STime.wYear,STime.wMonth,STime.wDay);
         Created := Created + EncodeTime(STime.wHour,STime.wMinute,STime.wSecond,
            STime.wMilliSeconds);
      end;
      // Accedido
      FileTimeToLocalFileTime(FTimeA,LTime);
      if FileTimeToSystemTime(LTime,STime) then begin
         Accessed := EncodeDate(STime.wYear,STime.wMonth,STime.wDay);
         Accessed := Accessed + EncodeTime(STime.wHour,STime.wMinute,STime.wSecond,
            STime.wMilliSeconds);
     end;
      // Modificado
      FileTimeToLocalFileTime(FTimeM,LTime);
      if FileTimeToSystemTime(LTime,STime) then begin
         Modified := EncodeDate(STime.wYear,STime.wMonth,STime.wDay);
         Modified := Modified + EncodeTime(STime.wHour,STime.wMinute,STime.wSecond,
            STime.wMilliSeconds);
      end;
   end;
   Result := RetVar;
end;
// ------------------------------------------------------------------------------

function tiene_letras_o_numeros(dato:string):boolean;
var i:integer;
begin
   for i:=1 to length(dato) do
      if dato[i] in  ['A'..'Z', 'a'..'z', '0'..'9'] then begin
         tiene_letras_o_numeros:=true;
         exit;
      end;
   tiene_letras_o_numeros:= false;
end;

procedure codigo_muerto(sistema,prog,bib,clase:string);
var lis:Tstringlist;
    nombre:string;
    rgmlang,compara,tabla_salida,tabla_variables,lineas_muertas,hora,ultimo:string;
begin
   nombre:=ptscomun.cprog2bfile(prog);
   lis:=Tstringlist.Create;
   dm.trae_fuente(sistema,prog,bib,clase,lis);
   lis.Text:=uppercase(lis.Text);
   lis.SaveToFile(g_tmpdir+'\'+nombre);
   hora:=formatdatetime('YYYYMMDDHHNNSSZZZ',now);
   rgmlang:=g_tmpdir+'\'+'htadead'+hora+'.exe';
   dm.get_utileria('RGMLANG',rgmlang);
   dm.get_utileria('CODIGO MUERTO '+clase,g_tmpdir+'\'+'codigo_muerto.dir',true,true);
   parametros_extra(sistema,clase,bib,g_tmpdir+'\'+'codigo_muerto.dir');
   dm.get_utileria('RESERVADAS MUERTO '+clase,g_tmpdir+'\'+'codigo_muerto.res');
   deletefile(pchar(g_tmpdir+'\'+prog+'_QUITAR_RUTINA'));
   deletefile(pchar(g_tmpdir+'\'+prog+'_QUITAR_VARIABLE'));
   chdir(g_tmpdir);
   if dm.ejecuta_espera(rgmlang+' '+nombre+' '+nombre+'_A codigo_muerto.dir codigo_muerto.res >resultado.lis',SW_HIDE)=false then begin
      application.MessageBox('ERROR... No puede procesar el código muerto ','ERROR',MB_OK);
      lis.Free;
      exit;
   end;
   {
   tabla_salida:=g_tmpdir+'\'+nombre+'_TABLA_SALIDA';
   copyfile(pchar(tabla_salida+'.csv'),pchar(tabla_salida+hora+'.csv'),false);
   ShellExecute(0,'open',PChar(tabla_salida+hora+'.csv'),'','',SW_SHOW);
   g_borrar.Add(tabla_salida+hora+'.csv');
   tabla_variables:=g_tmpdir+'\'+nombre+'_TABLA_VARIABLES';
   copyfile(pchar(tabla_variables+'.csv'),pchar(tabla_variables+hora+'.csv'),false);
   ShellExecute(0,'open',PChar(tabla_variables+hora+'.csv'),'','',SW_SHOW);
   g_borrar.Add(tabla_variables+hora+'.csv');
   lineas_muertas:=g_tmpdir+'\'+nombre+'_LINEAS_MUERTAS';
   copyfile(pchar(lineas_muertas+'.csv'),pchar(lineas_muertas+hora+'.csv'),false);
   ShellExecute(0,'open',PChar(lineas_muertas+hora+'.csv'),'','',SW_SHOW);
   g_borrar.Add(lineas_muertas+hora+'.csv');
   }
   tabla_salida:=g_tmpdir+'\'+nombre+'_RESULTADOS_CODIGO_MUERTO';
   copyfile(pchar(tabla_salida+'.csv'),pchar(tabla_salida+hora+'.csv'),false);
   ShellExecute(0,'open',PChar(tabla_salida+hora+'.csv'),'','',SW_SHOW);
   g_borrar.Add(tabla_salida+hora+'.csv');
   g_borrar.Add(tabla_salida+'.csv');

   compara:=g_tmpdir+'\'+'compara'+hora+'.exe';
   dm.get_utileria( 'COMPARACION DE FUENTES', compara );
   lis.LoadFromFile(g_tmpdir+'\'+nombre+'_ULTIMO');
   ultimo:=lis[0];
   {
         lis.LoadFromFile(ultimo);
         lis.Delete(lis.Count-1);    // quitarlo cuando se corrija el rgmlang
         lis.SaveToFile(ultimo);
   }
   ShellExecute(0,'open',PChar(compara),pchar(nombre+' '+ultimo+' /b'),pchar(g_tmpdir),SW_SHOW);
   lis.Free;
end;

procedure CrearArchivoTexto(titulo,contenido:String);  //para crear un archivo   ALK
var
  F: TextFile;
begin
  AssignFile( F, titulo );
  Rewrite( F );
  WriteLn( F, contenido );
  CloseFile( F );
end;

procedure parametros_extra(sis,cla,bib,archivo:string); //--------- Checa si necesita parametros especiales ---------
var extra:string;    // ENVIRE.BC=01{B}ENVIRE.EC=136{B}IGNORE.1=*{B}CONST.ENVIRE=YES{B}CONST.IGNORE=YES
     paso:string;
     comando,param,valor,antes:string;
     i,j,k,m:integer;
     lis:Tstringlist;
     jb,je:boolean;
     b_const_envire,b_const_ignore:boolean;
     const_linea:string;
     const_pos:integer;
begin
   extra:='';
   if dm.sqlselect(dm.q1, 'select * from parametro ' +
      ' where clave=' + g_q + 'chkextra_' + sis + '_' + cla + '_' + bib + g_q+
      ' and dato='+g_q+'TRUE'+g_q) then begin
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'EXTRA_MINING_' + sis+'_'+ cla +'_'+bib+ g_q) then
         extra := trim(dm.q1.fieldbyname('dato').AsString)
      else
         if dm.sqlselect(dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'EXTRA_MINING_' + cla + g_q) then
            extra := trim(dm.q1.fieldbyname('dato').AsString);
      if extra='' then
         muestra_mensaje('chkextra=TRUE pero no tiene el parámetro EXTRA_MINING',
         'ERROR',true,cla,bib,archivo,'parametros_extra','F031','ERROR',g_usuario); // aplica abort
      b_const_envire:=(0<pos('CONST.ENVIRE=YES',extra));
      b_const_ignore:=(0<pos('CONST.IGNORE=YES',extra));
      lis:=Tstringlist.Create;
      lis.LoadFromFile(archivo);
      while extra<>'' do begin
         if (param='BC') and (jb=false) then begin
            param:='JB';
         end
         else begin
            if (param='EC') and (je=false) then begin
               param:='JE';
            end
            else begin

               i:=pos('{B}',extra);
               if i>0 then begin
                  paso:=copy(extra,1,i-1);
                  delete(extra,1,i+2);
               end
               else begin
                  paso:=extra;
                  extra:='';
               end;
               j:=pos('.',paso);
               if j>0 then begin
                  comando:=copy(paso,1,j-1);
                  paso:=copy(paso,j+1,1000);
               end
               else
                  muestra_mensaje('falta punto en parametro EXTRA_MINING:'+extra,
                                  'ERROR',true,cla,bib,archivo,'parametros_extra','F032','ERROR',g_usuario); // aplica abort
               j:=pos('=',paso);
               if j>0 then begin
                  param:=copy(paso,1,j-1);
                  valor:=copy(paso,j+1,1000);
                  if param='JB' then jb:=true;
                        if param='JE' then je:=true;

               end
               else
                  muestra_mensaje('falta operador = en parametro EXTRA_MINING:'+extra,
                                  'ERROR',true,cla,bib,archivo,'parametros_extra','F033','ERROR',g_usuario); // aplica abort
            end;
         end;

         for j:=0 to lis.Count-1 do begin
            if b_const_envire then begin
               if (comando='ENVIRE') and (copy(lis[j],1,6)='CONST ') then begin
                  const_pos:=pos('\ENVIRE',lis[j]);
                  if const_pos>0 then begin
                     const_linea:=lis[j];
                     lis[j]:=copy(const_linea,const_pos+1,1000);
                  end;
               end;
            end;
            if b_const_ignore then begin
               if (comando='IGNORE') and (copy(lis[j],1,6)='CONST ') then begin
                  const_pos:=pos('\IGNORE',lis[j]);
                  if const_pos>0 then begin
                     const_linea:=lis[j];
                     lis[j]:=copy(const_linea,const_pos+1,1000);
                  end;
               end;
            end;
            if copy(lis[j],1,6)=comando then begin
               if comando='ENVIRE' then begin
                  k:=pos(param,lis[j]);
                  for m:=k+3 to 1000 do begin
                     if (copy(lis[j],m,2)='BC') or
                        (copy(lis[j],m,2)='EC') or
                        (copy(lis[j],m,2)='JB') or
                        (copy(lis[j],m,2)='JE') or
                        (copy(lis[j],m,2)='WH') or
                        (copy(lis[j],m,2)='SL') or
                        (copy(lis[j],m,2)='ES') or
                        (copy(lis[j],m,2)='CL') or
                        (copy(lis[j],m,2)='M1') or
                        (copy(lis[j],m,2)='M2') or
                        (copy(lis[j],m,2)='M3') or
                        (copy(lis[j],m,2)='M4') or
                        (copy(lis[j],m,2)='UC') or
                        (copy(lis[j],m,2)='\\') then
                        break;
                  end;
                  lis[j]:=stringreplace(lis[j],copy(lis[j],k,m-k),param+valor,[]);
                  if b_const_envire then begin
                     if const_pos>0 then begin
                        lis[j]:=copy(const_linea,1,const_pos)+lis[j];
                        const_pos:=0;
                     end;
                  end;
               end
               else
               if comando='IGNORE' then begin
                  antes:='';
                  for m:=10 to 100 do begin
                     if (lis[j][m+1] in ['0'..'9'])=false then break;
                     antes:=antes+copy(lis[j],m+1,1);
                  end;
                  lis[j]:=stringreplace(lis[j],antes,param,[rfreplaceall]);
                  //lis[j]:='IGNORE    '+copy(format('%02d',[strtoint(param)+1000]),3,2)+valor+'\\';
                  if b_const_ignore then begin
                     if const_pos>0 then begin
                        lis[j]:=copy(const_linea,1,const_pos)+lis[j];
                        const_pos:=0;
                     end;
                  end;
               end
               else
                  muestra_mensaje('comando no reconocido en parámetro EXTRA_MINING',
                  'ERROR',true,cla,bib,archivo,'parametros_extra','F034','ERROR',g_usuario); // aplica abort
               //break;
            end;
         end;
      end;
      lis.SaveToFile(archivo);
      lis.Free;
   end;
end;

procedure muestra_mensaje(texto,caption:string; aborta:boolean=false;
   clase:string='XXX';bib:string='SCRATCH'; nom:string='SCRATCH';
   rutina:string='SCRATCH';clave:string='XXX';estado:string='ERROR';origen:string='XXX');
begin
   if g_visual then begin
      Application.MessageBox( pchar( dm.xlng( texto ) ),
         pchar( dm.xlng( caption ) ), MB_OK );
      if aborta then
         screen.Cursor := crdefault;
   end
   else begin
      inserta_tslog( clase,bib, nom, rutina, clave, texto, estado, origen );
   end;
   if aborta then
      abort;
end;

procedure da_tipo_cbl(sis,cla,bib,archivo:string; var resultado: TStringList); //---para dar el tipo de cobol ---
var     // ENVIRE.BC=01{B}ENVIRE.EC=136{B}IGNORE.1=*
   extra,paso,comando,param,valor,antes:string;
   i,j,k,m:integer;
   lis:Tstringlist;
begin
   extra:='';
   if dm.sqlselect(dm.q1, 'select * from parametro ' +
      ' where clave=' + g_q + 'chkextra_' + sis + '_' + cla + '_' + bib + g_q+
      ' and dato='+g_q+'TRUE'+g_q) then begin
      if dm.sqlselect(dm.q1, 'select * from parametro ' +
         ' where clave=' + g_q + 'EXTRA_MINING_' + sis+'_'+ cla +'_'+bib+ g_q) then
         extra := trim(dm.q1.fieldbyname('dato').AsString)
      else
         if dm.sqlselect(dm.q1, 'select * from parametro ' +
            ' where clave=' + g_q + 'EXTRA_MINING_' + cla + g_q) then
            extra := trim(dm.q1.fieldbyname('dato').AsString);
      if extra='' then
         muestra_mensaje('chkextra=TRUE pero no tiene el parámetro EXTRA_MINING',
         'ERROR',true,cla,bib,archivo,'parametros_extra','F031','ERROR',g_usuario); // aplica abort
      lis:=Tstringlist.Create;
      lis.LoadFromFile(archivo);
      if extra <> '' then begin
         i:=pos('{B}',extra);
         if i>0 then begin
            paso:=copy(extra,1,i-1);
            delete(extra,1,i+2);
         end
         else begin
            paso:=extra;
            extra:='';
         end;
         j:=pos('.',paso);
         if j>0 then begin
            comando:=copy(paso,1,j-1);
            paso:=copy(paso,j+1,1000);
         end
         else
            muestra_mensaje('falta punto en parametro EXTRA_MINING:'+extra,
            'ERROR',true,cla,bib,archivo,'parametros_extra','F032','ERROR',g_usuario); // aplica abort
         j:=pos('=',paso);
         if j>0 then begin
            param:=copy(paso,1,j-1);
            valor:=copy(paso,j+1,1000);
         end
         else
            muestra_mensaje('falta operador = en parametro EXTRA_MINING:'+extra,
            'ERROR',true,cla,bib,archivo,'parametros_extra','F033','ERROR',g_usuario); // aplica abort
      end;
      resultado.Add(param);     //tipo de cobol    (Diagramador)
      resultado.Add(extra);     //parametro completo    (complejidad)
      //lis.SaveToFile(archivo);
      lis.Free;
   end;
end;

function get_copylib(sistema:string):string;
var copylib:string;
begin
   copylib:='';
   if dm.sqlselect(dm.q1, 'select hcbib,count(*) cuenta from tsrela ' +
      ' where hcclase=' + g_q + 'CPY' + g_q +
      ' and sistema=' + g_q + sistema + g_q +
      ' group by hcbib order by cuenta desc') then begin
      while not dm.q1.Eof do begin
         if dm.sqlselect(dm.q2, 'select path from tsbib '+
            ' where cbib=' + g_q + dm.q1.FieldByName('hcbib').AsString + g_q) then begin
            copylib:=copylib+dm.q2.FieldByName('path').AsString + '\CPY;';
         end;
         dm.q1.Next;
      end;
   end;
   get_copylib:=copylib;
end;
function cuenta_caracteres(pal:string; sub:char):integer;
var
   i:Integer;
   n:Integer;
begin
   n:=0;
   for i:=1 to Length(pal) do
      if pal[i]= sub then
         n:=n+1;
   cuenta_caracteres:=n;
end;

end.

