unit uConstantes;

interface
uses
   Graphics, Windows, ShlObj, Dialogs, SysUtils, Classes;

const
   //constantes para control de nombres o captions de ventanas
   sDIGRA_PAQUETES = 'Diagrama de paquetes';
   sDIGRA_CLASES = 'Diagrama de clases';
   sDIGRA_SCHEDULER = 'Diagrama Scheduler';
   sDIGRA_AIMPACTO = 'Diagrama de Análisis de impacto';
   //sDIGRA_PROCESOS = 'Diagrama de Procesos';
   sDIGRA_PROCESOS = 'Diagrama de Componentes';   //BMG
   sDIGRA_FLUJO_JCL = 'Diagrama de Flujo JCL';
   sDIGRA_BLOQUES = 'Diagrama de Bloques';
   sDIGRA_COBOL = 'Diagrama de COBOL';
   sDIGRA_SISTEMA = 'Diagrama del Sistema';

   sDOCUMENTACION = 'Documentación';
   sDOCUMENTACION_HIS = 'Historial';

   sMATRIZ_ARCHIVOS_FIS = 'Matriz Archivos';
   sMATRIZ_ARCHIVO_LOG = 'Matriz Archivo Lógico';
   sLISTA_COMPONENTES = 'Lista de Componentes';
   sLISTA_DEPENDENCIAS = 'Lista Dependencias de Componentes';
   sLISTA_MATRIZ_CRUD = 'Matriz CRUD';
   sLISTA_REF_CRUZADAS = 'Referencias Cruzadas';
   sLISTA_CONS_COMPONE = 'Consulta de Componentes';
   sLISTA_DRILLDOWN = 'Drill Down';
   sLISTA_DRILLUP = 'Drill Up';
   sLISTA_INV_COMPO = 'Inventario de Componentes';
   sLISTA_BUSCA_COMPO = 'Búsqueda en Componentes';
   sDOCUMENTACION_SIS = 'Documentación del Sistema';
   sDETALLE_TABLA='Detalle de tabla';

   sDIGRA_FLUJO_CBL = 'Diagrama de Flujo Cobol'; //utilizado por Vsustin - alk diagrama CBL
   sDIGRA_FLUJO_DCL = 'Diagrama de Flujo DCL';  //  ALK  duagramador Martin
   sDIGRA_FLUJO_CPY = 'Diagrama de Flujo Copy'; //utilizado por Vsustin
   sDIGRA_FLUJO_C = 'Diagrama de Flujo C'; //utilizado por Vsustin
   sDIGRA_FLUJO_SHELL = 'Diagrama de Flujo Shell'; //utilizado por Vsustin
   sDIGRA_FLUJO_JAVA = 'Diagrama de Flujo Java'; //utilizado por Vsustin
   sDIGRA_ACTIVIDAD_JAVA = 'Diagrama de Actividad'; //utilizado por Vsustin
   sDIGRA_FLUJO_JCL_2 = 'Diagrama de Flujo JCL'; //utilizado por Vsustin
   sDIGRA_FLUJO_MACRO = 'Diagrama de Flujo de MACROS';   //alk
   sDIGRA_FLUJO_OBY = 'Diagrama de Flujo OBY';  //alk
   sDIGRA_FLUJO_OSQ = 'Diagrama de Flujo OSQ';  //alk
   sDIGRA_FLUJO_WFL = 'Diagrama de Flujo de WFL';
   sDIGRA_FLUJO_ALG = 'Diagrama de Flujo de ALGOL';
   sDIGRA_FLUJO_BSC = 'Diagrama de Flujo de Basic';
   sDIGRA_FLUJO_TMP = 'Diagrama de Flujo de MACROS PATHWAY';
   sDIGRA_FLUJO_TMC = 'Diagrama de Flujo de MACROS TANDEM';

   sDIGRA_JERARQUICO_OSQ = 'Diagrama de Eventos de OSQ';
   sDIGRA_JERARQUICO_WFL = 'Diagrama Jerarquico de WFL';
   sDIGRA_JERARQUICO_ALG = 'Diagrama Jerarquico de ALGOL';
   sDIGRA_JERARQUICO_BSC = 'Diagrama Jerarquico de BSC';
   sDIGRA_JERARQUICO_CBL = 'Diagrama Jerarquico de Cobol';      //alk diagrama CBL

   sPROGRAMA_FUENTE = 'Fte'; //'Programa Fuente'; //se redujo para casos en los que los nombres son muy largos
   sDIGRA_FLUJO = 'Diagrama de Flujo'; //utilizado para Word (nombre de columnas)
   sDIGRA_COM_JCL = 'Diagrama de Flujo con Comentarios';   //para el diagrama JCL de visustin

   sVAL_ESTATICAS = 'Validaciones Estáticas';    // para el menu de los componentes

   //------- Constantes ALK para documentacion automatica estandarizada --------
   sDiagBloques = 'fDgrBloques';
   sDiagAnImpacto = 'fDgrAImpacto';
   sDiagProcesos = 'fDgrProcesos';
   sLisComponentes = 'fLstComponentes';
   sLisDependencias = 'fLstDependencias';
   sLisRefCruzadas = 'fLstRefCruzadas';
   sLisMatrizCRUD = 'fLstMatrizCrud';
   sLisMatrizAF = 'fLstMatrizAF';
   sLisMatrizAL = 'fLstMatrizArchLog';
   sFuente = 'fFuente';
   sDiagFlujo = 'fDgrFlujo';
   sDiagFlujoVis = 'fDgrFlujoVis';
   sDiagJerarquico = 'fDgrJerarquico';
   sDiagActivJava = 'fDgrActJava';
   sDiagSistema='fDgrdeSistema';
   sCodMuerto='fCodigoMuerto';
   sValEstaticas='fValidacionesEstaticas';
   //---------------------------------------------------------------------------

const
   Q = '"';
   sSIN_TITULO = '( Sin Titulo )';
   bREGISTRA_REPETIDOS = True;



type
   TTipoExport = ( exTodos, exDiagrama, exExcel, exVisio, exImgWMF, exPDF, exTexto );
   { TTipoExport - Exportacion:
   para los diagramas los tipos soportados son: exDiagrama, exExcel, exVisio, exImgWMF, exPDF
   para las listas los tipos soportados son: exExcel, exTexto
   }

   TSelDependencia = ( selArriba, selAbajo );

   TBlockAtributos = record // registro en memoria de block´s y atributos
      Programa: String;
      Biblioteca: String;
      Clase: String;
      Sistema: String;
      Renglon: Integer;
      Columna: Integer;
      Ancho: Integer;
      Alto: Integer;
      NFisicoBlock: String;
      NLogicoBlock: String;
      LigaBlockOrigen: String;
      LigaBlockDestino: String;
      TipoBlock: String;
      Color: TColor;
      Texto: String;

      Desplaza: Integer; //opcional
      Nivel: Integer; //opcional
      EntProSal: String; //opcional //Clasifica si es Entrada, Proceso o Salida 'E','P','S' //bloques
   end;

   TDrill = ( DrillDown, DrillUp );

   TTsrela = record // registro en memoria de TSRELA
      sPCPROG: String; //pk
      sPCBIB: String; //pk
      sPCCLASE: String; //pk
      sHCPROG: String; //pk
      sHCBIB: String; //pk
      sHCCLASE: String; //pk
      sORDEN: String; //pk
      sMODO: String;
      sORGANIZACION: String;
      sEXTERNO: String;
      sCOMENT: String;
      sOCPROG: String; //pk
      sOCBIB: String;
      sOCCLASE: String;
      sSISTEMA: String;
      sATRIBUTOS: String;
      iLINEAINICIO: Integer;
      iLINEAFINAL: Integer;
      sAMBITO: String;
      sICPROG: String;
      sICBIB: String;
      sICCLASE: String;
      sPOLIMORFISMO: String;
      sXCCLASE: String;
      sAUXILIAR: String;
      sHSISTEMA: String;
      sHPARAMETROS: String;
      sHINTERFASE: String;

      iNivel: Integer;
      bRepetido: Boolean;
      sCPROGRepetido: String;
      sCBIBRepetido: String;
      sCCLASERepetido: String;
   end;

   // Inicio Diccionario de Datos
type
   TCampoAtributos = record
      //Tabla: String; //longitud 50, sin espacion intermedios
      Campo: String; //nombre fisico , //longitud 50, sin espacio intermedio
      NombreLogico: String; //longitud 50, sin espacion intermedios
      Etiqueta15: String; //longitud 15
      //Etiqueta40: String; //longitud 40
   end;

   TCamposDef = array[ 0..96 ] of TCampoAtributos;

const
   aCAMPOS: TCamposDef = (
      //TSRELA

      // TSDOCUM
      ( Campo: 'CPROG'; NombreLogico: 'Programa'; Etiqueta15: 'Programa' ),
      ( Campo: 'CBIB'; NombreLogico: 'Biblioteca'; Etiqueta15: 'Biblioteca' ),
      ( Campo: 'CCLASE'; NombreLogico: 'Clase'; Etiqueta15: 'Clase' ),
      ( Campo: 'TITULO'; NombreLogico: 'Titulo'; Etiqueta15: 'Titulo docto.' ),
      ( Campo: 'FECHA'; NombreLogico: 'Fecha'; Etiqueta15: 'Fecha elaboró' ),
      ( Campo: 'TIPO'; NombreLogico: 'Tipo'; Etiqueta15: 'Tipo' ),
      ( Campo: 'CUSER'; NombreLogico: 'Usuario'; Etiqueta15: 'Usuario' ),
      ( Campo: 'CBLOB'; NombreLogico: 'CBlob'; Etiqueta15: 'Blob' ),
      ( Campo: 'MAGIC'; NombreLogico: 'Magic'; Etiqueta15: 'Magic' ),
      // Lista componentes y Lista Dependencia de Componentes
      ( Campo: 'nivel'; NombreLogico: 'nivel'; Etiqueta15: 'Nivel' ),
      ( Campo: 'clase'; NombreLogico: 'Clase'; Etiqueta15: 'Clase' ),
      ( Campo: 'bib'; NombreLogico: 'Libreria'; Etiqueta15: 'Librería' ),
      ( Campo: 'nombre'; NombreLogico: 'Componente'; Etiqueta15: 'Componente' ),
      ( Campo: 'modo'; NombreLogico: 'Modo'; Etiqueta15: 'Modo' ),
      ( Campo: 'organizacion'; NombreLogico: 'Organización'; Etiqueta15: 'Organización' ),
      ( Campo: 'externo'; NombreLogico: 'Externo'; Etiqueta15: 'Externo' ),
      ( Campo: 'coment'; NombreLogico: 'Comentario'; Etiqueta15: 'Comentario' ),
      ( Campo: 'existe'; NombreLogico: 'Existe'; Etiqueta15: 'Existe' ),
      ( Campo: 'existe2'; NombreLogico: 'existe2'; Etiqueta15: 'Existe' ),
      ( Campo: 'sistema'; NombreLogico: 'Sistema'; Etiqueta15: 'Sistema' ),
      // TSDOCUMENTO
      ( Campo: 'IDDOCTO'; NombreLogico: 'IDDocto'; Etiqueta15: 'ID Docto.' ),
      ( Campo: 'NOMBRE'; NombreLogico: 'NombreDocto'; Etiqueta15: 'Nombre' ),
      ( Campo: 'EXTENSION'; NombreLogico: 'ExtensionDocto'; Etiqueta15: 'Extensión' ),
      ( Campo: 'FECHA_ALTA'; NombreLogico: 'FechaAlta'; Etiqueta15: 'Fecha de alta' ),
      ( Campo: 'USUARIO_ALTA'; NombreLogico: 'UsuarioAlta'; Etiqueta15: 'Usuario alta' ),
      ( Campo: 'CPROG'; NombreLogico: 'Programa'; Etiqueta15: 'Programa' ),
      ( Campo: 'CBIB'; NombreLogico: 'Biblioteca'; Etiqueta15: 'Biblioteca' ),
      ( Campo: 'CCLASE'; NombreLogico: 'Clase'; Etiqueta15: 'Clase' ),
      ( Campo: 'DESCRIPCION'; NombreLogico: 'Descripcion'; Etiqueta15: 'Descripción' ),
      ( Campo: 'ESTATUS'; NombreLogico: 'Estatus'; Etiqueta15: 'Estatus' ),
      ( Campo: 'FECHA_ESTATUS'; NombreLogico: 'FechaEstatus'; Etiqueta15: 'Fecha del estatus' ),
      ( Campo: 'USUARIO_ESTATUS'; NombreLogico: 'UsuarioEstatus'; Etiqueta15: 'Usuario del estatus' ),
      // TSDOCREVISION
      ( Campo: 'IDDOCTO'; NombreLogico: 'IDDocto'; Etiqueta15: 'ID Docto.' ),
      ( Campo: 'IDREVISION'; NombreLogico: 'IDRevision'; Etiqueta15: 'ID Revisión' ),
      ( Campo: 'USUARIO_REV'; NombreLogico: 'UsuarioRev'; Etiqueta15: 'Usuario rev.' ),
      ( Campo: 'ACTIVO'; NombreLogico: 'Activo'; Etiqueta15: 'Activo' ),
      ( Campo: 'FECHA_INICIO'; NombreLogico: 'FechaInicio'; Etiqueta15: 'Fecha inicio' ),
      ( Campo: 'FECHA_FIN'; NombreLogico: 'FechaFin'; Etiqueta15: 'Fecha fin' ),
      //fmConsComp
      ( Campo: 'Biblioteca'; NombreLogico: 'Biblioteca'; Etiqueta15: 'Biblioteca' ),
      ( Campo: 'Componente'; NombreLogico: 'Componente'; Etiqueta15: 'Componente' ),
      ( Campo: 'Clase'; NombreLogico: 'Clase'; Etiqueta15: 'Clase' ),
      ( Campo: 'Lineas_Blanco'; NombreLogico: 'Lineas_Blanco'; Etiqueta15: 'Líneas en Blanco' ),
      ( Campo: 'Lineas_Total'; NombreLogico: 'Lineas_Total'; Etiqueta15: 'Líneas Totales' ),
      ( Campo: 'Lineas_Comentarios'; NombreLogico: 'Lineas_Comentarios'; Etiqueta15: 'Líneas Comentarios' ),
      ( Campo: 'Lineas_Efectivas'; NombreLogico: 'Lineas_Efectivas'; Etiqueta15: 'Líneas Efectivas' ),
      ( Campo: 'Ultima_Version'; NombreLogico: 'Ultima_Version'; Etiqueta15: 'Ultima Versión' ),
      ( Campo: 'No_Versiones'; NombreLogico: 'No_Versiones'; Etiqueta15: 'Total Versiones' ),
      ( Campo: 'Descripcion'; NombreLogico: 'Descripcion'; Etiqueta15: 'Descripción' ),
      //fmRefCruz
      ( Campo: 'Libreria'; NombreLogico: 'Libreria'; Etiqueta15: 'Librería' ),
      //fmMatrizAF
      ( Campo: 'Libreria2'; NombreLogico: 'Libreria2'; Etiqueta15: 'Librería' ),
      // ufmMatrizArchLog - Matriz Archivo Lógico
      ( Campo: 'ARCHIVO_LOGICO'; NombreLogico: 'ArchivoLogico'; Etiqueta15: 'Archivo Lógico' ),
      ( Campo: 'PROGRAMA'; NombreLogico: 'Programa'; Etiqueta15: 'Programa' ),
      ( Campo: 'USO'; NombreLogico: 'Uso'; Etiqueta15: 'Uso' ),
      ( Campo: 'ORGANIZACION'; NombreLogico: 'Organizacion'; Etiqueta15: 'Organización' ),
      ( Campo: 'MACRO_JCL'; NombreLogico: 'MacroJCL'; Etiqueta15: 'Macro/JCL' ),
      ( Campo: 'ARCHIVO_FISICO'; NombreLogico: 'ArchivoFisico'; Etiqueta15: 'Archivo Físico' ),
      // TSSISTEMA
      ( Campo: 'CSISTEMA'; NombreLogico: 'CSistema'; Etiqueta15: 'Sistema' ),
      ( Campo: 'DESCRIPCION'; NombreLogico: 'Descripcion'; Etiqueta15: 'Descripción' ),
      // para catálogos   ALK
      ( Campo:	'APELLIDOMATERNO'; NombreLogico:	'Apellido_Materno'; Etiqueta15:'Apellido Materno' ),
      ( Campo:	'APELLIDOPATERNO'; NombreLogico:	'Apellido Paterno'; Etiqueta15:'Apellido Paterno' ),
      ( Campo:	'BIB'; NombreLogico:	'Bib'; Etiqueta15:'Biblioteca' ),
      ( Campo:	'BIBLIOTECA'; NombreLogico: 'Biblioteca'; Etiqueta15:'Biblioteca'),
      ( Campo:	'BUSQUEDASELECT'; NombreLogico:'Busqueda_Select'; Etiqueta15:	'Búsqueda Select'	),
      ( Campo:	'CAPACIDADMINERIA'; NombreLogico: 'Capacidad_Mineria'; Etiqueta15: 'Capacidad de Minería'),
      ( Campo:	'CARACTERESPERMITIDOS'; NombreLogico:'Caracteres_Permitidos'; Etiqueta15:'Caracteres Permitidos'	),
      ( Campo:	'CLASE'; NombreLogico:'Clase'; Etiqueta15: 'Clase'),
      ( Campo:	'CLAVEDECAPACIDAD'; NombreLogico: 'Clave_Capacidad'; Etiqueta15: 'Clave de Capacidad'	),
      ( Campo:	'CLAVEDEPARAMETRO'; NombreLogico: 'Clave_Parametro'; Etiqueta15: 'Clave de Parámetro'	),
      ( Campo:	'CLAVEDEROL'; NombreLogico: 'Clave_Rol'; Etiqueta15:'Clave de Rol' ),
      ( Campo:	'CLAVEDEUSUARIO'; NombreLogico:'Clave_Usuario'; Etiqueta15:	'Clave de Usuario' ),
      ( Campo:	'COMPLEJIDAD'; NombreLogico:'Complejidad'; Etiqueta15: 'Complejidad'),
      ( Campo:	'CORREO'; NombreLogico:	'Correo'; Etiqueta15: 'Correo'	),
      ( Campo:	'DATO'; NombreLogico: 'Dato'; Etiqueta15:	'Dato' ),
      ( Campo:	'DIAGRAMABLOQUE'; NombreLogico:	'Diagrama_Bloque'; Etiqueta15:	'Diagrama de Bloque'	),
      ( Campo:	'DIRECCION'; NombreLogico:'Direccion'; Etiqueta15:	'Dirección'	),
      ( Campo:	'DIRECCIONIP'; NombreLogico:'Direccion_ip'; Etiqueta15:'Dirección IP' ),
      ( Campo:	'DIRECTORIOPRODUCCION'; NombreLogico:'Directorio_Produccion'; Etiqueta15: 'Directorio de Producción'	),
      ( Campo:	'ESTADO'; NombreLogico:	'Estado'; Etiqueta15: 'Estado' ),
      ( Campo:	'ESTRUCTURAPRODUCCION'; NombreLogico:'Estructuraproduccion'; Etiqueta15: 'Estructura de Producción'	),
      ( Campo:	'GRADO'; NombreLogico:'Grado'; Etiqueta15: 'Grado' ),
      ( Campo:	'HERRAMIENTAANALISIS'; NombreLogico: 'Herramienta_Analisis'; Etiqueta15: 'Herramienta de Análisis' ),
      ( Campo:	'MENSAJE'; NombreLogico: 'Mensaje'; Etiqueta15:	'Mensaje' ),
      ( Campo:	'MODOACTUALIZACION'; NombreLogico: 'Modo_Actualizacion'; Etiqueta15:	'Modo Actualización'	),
      ( Campo:	'MODOCARACTERES'; NombreLogico: 'Modo_Caracteres'; Etiqueta15:	'Modo Caracteres'	),
      ( Campo:	'OFICINA'; NombreLogico: 'Oficina'; Etiqueta15:	'Oficina' ),
      ( Campo:	'PASSWORD'; NombreLogico:'Password'; Etiqueta15: 'Password' ),
      ( Campo:	'PATH'; NombreLogico: 'Path'; Etiqueta15:	'Path' ),
      ( Campo:	'PROG'; NombreLogico: 'Prog'; Etiqueta15:	'Programa' ),
      ( Campo:	'REGLA'; NombreLogico:	'Regla'; Etiqueta15:	'Regla' ),
      ( Campo:	'ROL'; NombreLogico:	'Rol'; Etiqueta15: 'Rol'	),
      ( Campo:	'SECUENCIA'; NombreLogico:	'Secuencia'; Etiqueta15: 'Secuencia' ),
      ( Campo:	'SISTEMA'; NombreLogico: 'Sistema'; Etiqueta15:'Sistema' ),
      ( Campo:	'SISTEMAPADRE'; NombreLogico:	'Sistema_Padre'; Etiqueta15:	'Sistema Padre' ),
      ( Campo:	'TIPOOBJETO'; NombreLogico: 'Tipo_Objeto'; Etiqueta15: 'Tipo de Objeto' ),
      ( Campo:	'TIPODEOBJETO'; NombreLogico: 'Tipo_Objeto'; Etiqueta15: 'Tipo de Objeto' ),
      ( Campo:	'USUARIO'; NombreLogico: 'Usuario'; Etiqueta15:'Usuario' ),
      ( Campo:	'UTILERIA'; NombreLogico: 'Utileria'; Etiqueta15: 'Utilería' )
      );
   //// Fin Diccionario de Datos

   //// Declaracion de variables
var
   //variables comunes
   sGlbCClase, sGlbCBib, sGlbCProg : String;
   sUsuario : String;   //ALK para tener el usuario
   alkSistema : String;  //para tener el sistema a partir de la recepcion de componentes   ALK
   alkleyenda : String;  //para tener la leyenda de porque no encuentra el fuente ALK
   alkComplejidad : String; //auxiliar para mandar mensaje de error en complejidad   ALK
   alkErrorGral : String;  // para guardar los errores que se generan docAuto outSyst prueba  ALK
   alkSCRATCH : String; // para guardar la leyenda de porque razon no puede generar los productos  ALK
   alkDocumentacion : integer;  // para indicarle a los productos que viene de documentacion;

   alkActivo, alkActivoDoc : integer;  // para saber si se cancelo la generacion de un nuevo diagrama   ALK

   aGLBTsrela: array of TTsrela;

   alkReingDoctoExterna : integer; //´para indicar que se manda informacion para documentacion externa  ALK
   alksReingresaDoctoExterna : String;  // para tener el nombre del documento que se espera   ALK
    Reingresar: TStringList;  // se crea y se libera en ufmDocumentacion

   //variables para diagramas
   iGlbNombreBlock: Integer; // ???_999 auxiliar en el incremento del numero del nombre del block

   iGlbRenglon: Integer; // sirve para asignar el top (Renglon) de los Block's
   iGlbColumna: Integer; // sirve para asignar el Left (Columna) de los Block's
   iGlbAncho: Integer = 90; //80; // default
   iGlbAlto: Integer = 50; //40; // default
   iGlbEspacioEntreColumnas: Integer = 35;//20; // default
   iGlbEspacioEntreRenglones: Integer = 40;//35;//20; // default

   aGlbBlockAtributos: array of TBlockAtributos;

   //variables para el Editor
   sGlbTitulo: String;
   iGlbIDDocto: Integer;
   sGLbNombre: String;
   sGlbCBlob: String; //quitar
   sGlbDocumento: String; //quitar

   // Declaracion de funciones y procedimientos

function GlbObtenerRutaMisDocumentos: String;
function sGlbAbrirDialogo: String;
function sGlbAbrirDialogoRuta(ruta : String): String; //Cuadro de dialogo para abrir un archivo a partir de una ruta especifica
function sGlbGuardarDialogo( extension, Nombre : String ): String;  //Cuadro de dialogo para guardar un archivo
function sObtenerEtiquetaCampo( sParCampoFisico: String ): String;

//registra en aGLBTsrela el resultado de dm.TaladrarTsrela
procedure GlbRegistraArregloTsrela(
   sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN: String;
   sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT: String;
   sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS: String;
   iParLINEAINICIO, iParLINEAFINAL: Integer;
   sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE: String;
   sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE: String;
   bParRepetido: Boolean; sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido: String ); overload;

//registra en aGLBTsrela el programa, bib y clase (padres)
procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String ); overload;

//ALK para registrar relaciones basicas   Diagrama sistema
procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE,
                                    sParHCPROG, sParHCBIB, sParHCCLASE,
                                    sParMODO: String ); overload;

//auxiliar para determinar repetidos y no se cicle en dm.TaladrarTsrela
function bGlbRepetidoTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String ): Boolean;

//exporta el resultado del arreglo aGLBTsrela a un StringList
procedure GlbExportaArregloTsrela( var slParLista: TStringList );

//elimina caracteres especiales de una cadena o texto
function bGlbQuitaCaracteres( var sParTexto: String ): Boolean;

//registra en un archivo especificado el texto indicado, puede utilizarse como log de eventos
procedure GlbRegistraLog( sParArchivo: String; sParTexto: String );

// alk para validar repetidos en formato cadena
function validaRepetido( cadena: String; lista: Tstringlist ): Boolean;
implementation

function GlbObtenerRutaMisDocumentos: String;
var
   bLongBool: Bool;
   sPath: array[ 0..Max_Path ] of Char;
begin
   bLongBool := ShGetSpecialFolderPath( 0, sPath, CSIDL_Personal, False );

   if not bLongBool then
      Result := 'C:'
   else
      Result := sPath;
end;

function sGlbGuardarDialogo( extension, Nombre : String ): String;
var
   SaveDialog: TSaveDialog;
   ext : String;
begin
   SaveDialog := TSaveDialog.Create( nil );
   ext := AnsiLowerCase(extension);  // para poner la extension en minusculas
   try
      with SaveDialog do begin
         InitialDir := GlbObtenerRutaMisDocumentos;

         DefaultExt := ext;
         Filter := 'Todos los archivos (*.*)|*.*';

         bGlbQuitaCaracteres( Nombre );
         FileName := Nombre + ext;

         if Execute then
            Result := FileName
         else
            Result := '';
      end;
   finally
      SaveDialog.Free;
   end;
end;

function sGlbAbrirDialogo: String;
var
   OpenDialog: TOpenDialog;
begin
   OpenDialog := TOpenDialog.Create( nil );
   try
      with OpenDialog do begin
         InitialDir := GlbObtenerRutaMisDocumentos;

         Filter := 'Cualquier archivo (*.*)|*.*';

         if Execute then
            Result := FileName
         else
            Result := '';
      end;
   finally
      OpenDialog.Free;
   end;
end;

function sGlbAbrirDialogoRuta(ruta : String): String;
var
   OpenDialog: TOpenDialog;
begin
   OpenDialog := TOpenDialog.Create( nil );
   try
      with OpenDialog do begin
         InitialDir := ExtractFilePath ( ruta );

         Filter := 'Cualquier archivo (*.*)|*.*';

         if Execute then
            Result := FileName
         else
            Result := '';
      end;
   finally
      OpenDialog.Free;
   end;
end;

function sObtenerEtiquetaCampo( sParCampoFisico: String ): String;
var
   i: Integer;
begin
   //Result := 'Sin Titulo';
   Result := sParCampoFisico;

   for i := 0 to length( aCAMPOS ) - 1 do
      if aCAMPOS[ i ].Campo = sParCampoFisico then begin
         Result := aCAMPOS[ i ].Etiqueta15;
         Break;
      end;
end;

procedure GlbRegistraArregloTsrela(
   sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN: String;
   sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT: String;
   sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS: String;
   iParLINEAINICIO, iParLINEAFINAL: Integer;
   sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE: String;
   sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE: String;
   bParRepetido: Boolean; sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido: String );
var
   iLongitudArreglo: Integer;
   iArreglo: Integer;
begin
   // Registrar en arreglo aGLBTsrela
   iLongitudArreglo := Length( aGLBTsrela );
   iArreglo := iLongitudArreglo;
   iLongitudArreglo := iLongitudArreglo + 1;

   //TRY
   SetLength( aGLBTsrela, iLongitudArreglo ); // SetLength( aGLBTsrela, iLongitudArreglo + 1 );

   aGLBTsrela[ iArreglo ].sPCPROG := sParPCPROG;
   aGLBTsrela[ iArreglo ].sPCBIB := sParPCBIB;
   aGLBTsrela[ iArreglo ].sPCCLASE := sParPCCLASE;
   aGLBTsrela[ iArreglo ].sHCPROG := sParHCPROG;
   aGLBTsrela[ iArreglo ].sHCBIB := sParHCBIB;
   aGLBTsrela[ iArreglo ].sHCCLASE := sParHCCLASE;
   aGLBTsrela[ iArreglo ].sORDEN := sParORDEN;
   aGLBTsrela[ iArreglo ].sMODO := sParMODO;
   aGLBTsrela[ iArreglo ].sORGANIZACION := sParORGANIZACION;
   aGLBTsrela[ iArreglo ].sEXTERNO := sParEXTERNO;
   aGLBTsrela[ iArreglo ].sCOMENT := sParCOMENT;
   aGLBTsrela[ iArreglo ].sOCPROG := sParOCPROG;
   aGLBTsrela[ iArreglo ].sOCBIB := sParOCBIB;
   aGLBTsrela[ iArreglo ].sOCCLASE := sParOCCLASE;
   aGLBTsrela[ iArreglo ].sSISTEMA := sParSISTEMA;
   aGLBTsrela[ iArreglo ].sATRIBUTOS := sParATRIBUTOS;
   aGLBTsrela[ iArreglo ].iLINEAINICIO := iParLINEAINICIO;
   aGLBTsrela[ iArreglo ].iLINEAFINAL := iParLINEAFINAL;
   aGLBTsrela[ iArreglo ].sAMBITO := sParAMBITO;
   aGLBTsrela[ iArreglo ].sICPROG := sParICPROG;
   aGLBTsrela[ iArreglo ].sICBIB := sParICBIB;
   aGLBTsrela[ iArreglo ].sICCLASE := sParICCLASE;
   aGLBTsrela[ iArreglo ].sPOLIMORFISMO := sParPOLIMORFISMO;
   aGLBTsrela[ iArreglo ].sXCCLASE := sParXCCLASE;
   aGLBTsrela[ iArreglo ].sAUXILIAR := sParAUXILIAR;
   aGLBTsrela[ iArreglo ].sHSISTEMA := sParHSISTEMA;
   aGLBTsrela[ iArreglo ].sHPARAMETROS := sParHPARAMETROS;
   aGLBTsrela[ iArreglo ].sHINTERFASE := sParHINTERFASE;

   aGLBTsrela[ iArreglo ].bRepetido := bParRepetido;
   aGLBTsrela[ iArreglo ].sCPROGRepetido := sParCPROGRepetido;
   aGLBTsrela[ iArreglo ].sCBIBRepetido := sParCBIBRepetido;
   aGLBTsrela[ iArreglo ].sCCLASERepetido := sParCCLASERepetido;

end;

procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String );
var
   iLongitudArreglo: Integer;
begin
   // Registrar en arreglo aGLBTsrela
   iLongitudArreglo := Length( aGLBTsrela );
   SetLength( aGLBTsrela, iLongitudArreglo + 1 );

   aGLBTsrela[ iLongitudArreglo ].sPCPROG := sParPCPROG;
   aGLBTsrela[ iLongitudArreglo ].sPCBIB := sParPCBIB;
   aGLBTsrela[ iLongitudArreglo ].sPCCLASE := sParPCCLASE;
end;

// ----------------------  ALK --------------------------------------
procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE,
                                    sParHCPROG, sParHCBIB, sParHCCLASE,
                                    sParMODO: String );
var
   iLongitudArreglo: Integer;
begin
   // Registrar en arreglo aGLBTsrela
   iLongitudArreglo := Length( aGLBTsrela );
   SetLength( aGLBTsrela, iLongitudArreglo + 1 );

   aGLBTsrela[ iLongitudArreglo ].sPCPROG := sParPCPROG;
   aGLBTsrela[ iLongitudArreglo ].sPCBIB := sParPCBIB;
   aGLBTsrela[ iLongitudArreglo ].sPCCLASE := sParPCCLASE;
   aGLBTsrela[ iLongitudArreglo ].sHCPROG := sParHCPROG;
   aGLBTsrela[ iLongitudArreglo ].sHCBIB := sParHCBIB;
   aGLBTsrela[ iLongitudArreglo ].sHCCLASE := sParHCCLASE;
   aGLBTsrela[ iLongitudArreglo ].sMODO := sParMODO;
end;
//  -------------------------------------------------------------------------

function bGlbRepetidoTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String ): Boolean;
var
   i: Integer;
begin
   Result := False;

   for i := 0 to Length( aGLBTsrela ) - 1 do
      if ( aGLBTsrela[ i ].sPCPROG = sParPCPROG ) and
         ( aGLBTsrela[ i ].sPCBIB = sParPCBIB ) and
         ( aGLBTsrela[ i ].sPCCLASE = sParPCCLASE ) then begin
         Result := True;
         Break;
      end;
end;

function validaRepetido( cadena: String; lista: Tstringlist ): Boolean;   // alk para validar repetidos en formato cadena
begin
   Result := False;

   if(lista.indexof(cadena)>-1) then begin
      Result:= True;
      Exit;
   end;

   lista.Add( cadena );
end;

function bGlbQuitaCaracteres( var sParTexto: String ): Boolean;
//elimina o quita caracteres especiales, diferentes a los validos (sVALIDOS).
const
   sVALIDOS = [ ' ', '_', '0'..'9', 'A'..'Z', 'a'..'z' ];
var
   i: Integer;
   bQuito: Boolean;
   sTexto: String;
begin
   bQuito := False;
   sTexto := '';

   for i := 1 to Length( sParTexto ) do
      if sParTexto[ i ] in sVALIDOS then
         sTexto := sTexto + sParTexto[ i ]
      else
         bQuito := True;

   sParTexto := Trim( sTexto );
   Result := bQuito;
end;

procedure GlbExportaArregloTsrela( var slParLista: TStringList );
var
   i: Integer;
begin
   slParLista.Add(
      Q + 'Nivel' + Q + ',' +
      Q + 'PCPROG' + Q + ',' + Q + 'PCBIB' + Q + ',' + Q + 'PCCLASE' + Q + ',' +
      Q + 'HCPROG' + Q + ',' + Q + 'HCBIB' + Q + ',' + Q + 'HCCLASE' + Q + ',' +
      Q + 'ORDEN' + Q + ',' + Q + 'MODO' + Q + ',' + Q + 'ORGANIZACION' + Q + ',' +
      Q + 'EXTERNO' + Q + ',' + Q + 'COMENT' + Q + ',' + Q + 'OCPROG' + Q + ',' +
      Q + 'OCBIB' + Q + ',' + Q + 'OCCLASE' + Q + ',' + Q + 'SISTEMA' + Q + ',' +
      Q + 'ATRIBUTOS' + Q + ',' + Q + 'LINEAINICIO' + Q + ',' + Q + 'LINEAFINAL' + Q + ',' +
      Q + 'AMBITO' + Q + ',' + Q + 'ICPROG' + Q + ',' + Q + 'ICBIB' + Q + ',' +
      Q + 'ICCLASE' + Q + ',' + Q + 'POLIMORFISMO' + Q + ',' + Q + 'XCCLASE' + Q + ',' +
      Q + 'AUXILIAR' + Q + ',' + Q + 'HSISTEMA' + Q + ',' + Q + 'HPARAMETROS' + Q + ',' +
      Q + 'HINTERFASE' + Q + ',' +
      Q + 'Repetido' + Q + ',' + Q + 'CPROGRepetido' + Q + ',' + Q + 'CBIBRepetido' + Q + ',' +
      Q + 'CCLASERepetido' + Q );

   //empieza en 1, 0 no es necesario
   for i := 1 to Length( aGLBTsrela ) - 1 do
      with aGLBTsrela[ i ] do
         slParLista.Add(
            Q + IntToStr( iNivel ) + Q + ',' +
            Q + sPCPROG + Q + ',' + Q + sPCBIB + Q + ',' + Q + sPCCLASE + Q + ',' +
            Q + sHCPROG + Q + ',' + Q + sHCBIB + Q + ',' + Q + sHCCLASE + Q + ',' +
            Q + sORDEN + Q + ',' + Q + sMODO + Q + ',' + Q + sORGANIZACION + Q + ',' +
            Q + sEXTERNO + Q + ',' +
            Q + StringReplace( sCOMENT, Q, '''', [ rfReplaceAll ] ) + Q + ',' +
            Q + sOCPROG + Q + ',' + Q + sOCBIB + Q + ',' + Q + sOCCLASE + Q + ',' +
            Q + sSISTEMA + Q + ',' +
            Q + StringReplace( sATRIBUTOS, Q, '''', [ rfReplaceAll ] ) + Q + ',' +
            Q + IntToStr( iLINEAINICIO ) + Q + ',' + Q + IntToStr( iLINEAFINAL ) + Q + ',' +
            Q + sAMBITO + Q + ',' + Q + sICPROG + Q + ',' + Q + sICBIB + Q + ',' +
            Q + sICCLASE + Q + ',' +
            Q + StringReplace( sPOLIMORFISMO, Q, '''', [ rfReplaceAll ] ) + Q + ',' +
            Q + sXCCLASE + Q + ',' + Q + sAUXILIAR + Q + ',' + Q + sHSISTEMA + Q + ',' +
            Q + StringReplace( sHPARAMETROS, Q, '''', [ rfReplaceAll ] ) + Q + ',' +
            Q + sHINTERFASE + Q + ',' +
            Q + BoolToStr( bRepetido ) + Q + ',' + Q + sCPROGRepetido + Q + ',' +
            Q + sCBIBRepetido + Q + ',' + Q + sCCLASERepetido + Q );
end;

procedure GlbRegistraLog( sParArchivo: String; sParTexto: String );
var
   txfRegistro: TextFile;
   sFechaHoraActual: String;
   sRutaLog: String;

begin
   GetDir( 0, sRutaLog );
   sRutaLog := sRutaLog + '\tmp\';

   if ForceDirectories( sRutaLog ) = False then begin
      Exit;
   end;

   AssignFile( txfRegistro, sRutaLog + sParArchivo );

   if FileExists( sRutaLog + sParArchivo ) then
      Append( txfRegistro )
   else
      Rewrite( txfRegistro );

   sFechaHoraActual := Q + FormatDateTime( 'yyyy/mm/dd" "hh:nn:ss:zzz', Now ) + Q;

   Writeln( txfRegistro,
      sFechaHoraActual + ',' +
      sParTexto );

   CloseFile( txfRegistro );
end;

end.


