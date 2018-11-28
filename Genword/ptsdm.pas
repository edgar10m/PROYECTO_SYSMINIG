unit ptsdm;

interface

uses
  SysUtils, Classes, ADODB, dialogs, DB;

type
  Tdm = class(TDataModule)
    ADOConnection1: TADOConnection;
    q1: TADOQuery;
    q4: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
      function desencripta( dato: string ): string;
      function sqlselect( tabla: tADOquery; sele: string ): boolean;
      function xlng( mensaje: string ): string;
  end;

var
  dm: Tdm;
  g_ruta:string;
  g_tmpdir:string;
  g_language:string='';
  g_q:string='''';
  g_user_procesa:string;
  g_pass:string;
implementation

{$R *.dfm}
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

function Tdm.sqlselect( tabla: tADOquery; sele: string ): boolean;
var
   CodigoSQL: integer;
begin
   sqlselect := false;
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
         showmessage('ERROR SQL: ' + sele + ' - ' + E.Message );
         sqlselect := false;
      end;
   end;
end;
function Tdm.xlng( mensaje: string ): string;
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

end.
