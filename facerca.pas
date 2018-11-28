unit facerca;
interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ExtCtrls, jpeg, StdCtrls, Buttons;

type
   Tfacerc = class( TForm )
      BitBtn1: TBitBtn;
      Label3: TLabel;
      lblnomempresa: TLabel;
      lblODBC: TLabel;
      Label2: TLabel;
      lblSysMining: TLabel;
      Label1: TLabel;
      lbluser: TLabel;
      lblcontrolexe: TLabel;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      Label7: TLabel;
      Image1: TImage;
      Image2: TImage;
    lbversion: TLabel;
      procedure BitBtn1Click( Sender: TObject );
      procedure FormCreate( Sender: TObject );
   private
      { Private declarations }
   public
      version:string;

      procedure pone_version (nombre,v,fecha:string);
      function da_version():string;  //para el ptsmain
      { Public declarations }
   end;

var
   facerc: Tfacerc;
procedure PR_ACERCA;

implementation

{$R *.DFM}
uses ptsdm;

procedure PR_ACERCA;
begin
   Application.CreateForm( Tfacerc, facerc );
   try
      facerc.Showmodal;
   finally
      facerc.Free;
   end;
end;

procedure Tfacerc.pone_version (nombre,v,fecha:string);
begin
   version:=v;
   lbversion.Caption:=v;
   lblcontrolexe.caption:= nombre+'.'+ fecha +'.'+v;
   Application.Title:= 'Sys-Mining '+v;
end;

function Tfacerc.da_version():string;  //para el ptsmain
begin
   da_version:=version;
end;

procedure Tfacerc.BitBtn1Click( Sender: TObject );
begin
   Close;
end;

procedure Tfacerc.FormCreate( Sender: TObject );
var
   lis: string;
begin
   lis := copy( g_version_tit, pos( 'Management', g_version_tit ) + 11, 100 );
   // lversion.caption:='Versión '+lis;
   lblnomempresa.Caption := g_empresa;
   lblODBC.Caption := g_odbc;
   lblsysmining.Caption := 'Sys-Mining';
   lbluser.Caption := g_usuario;
   // lblcontrolexe.caption:='JCR.20120801.12:34'; Pruebas Bancomer
   //   lblcontrolexe.caption:='JCR.20120803.13:19';   //En esta versión:
   //                                                 -	Si 2 o más analistas hacen una búsqueda, se realizan concurrentemente.
   //                                                 -	Se elimina el uso de TSBLOB, todo se realiza a través de TSBFILE
   //                                                 -	Se reduce el tiempo de proceso.
   //   lblcontrolexe.caption:='JCR.20120814.13:04  ';   //En esta versión:
   //                                                 -	Busqueda con filtros
   //                                                 -	Búsqueda con palabras en la misma linea
   //                                                 -	Búsqueda  - Correcciones en los filtros
   //                                                 -  Trae_fuente -  se reemplaza el ADOQ
   //   lblcontrolexe.caption:='JCR.20120815.10:35  ';   //En esta versión:
   //                                                 -	Datos del servidor fijo BANCOMER (TEMPORAL)
                                                      //pendiente borrar unidades creadas con net use.
   //  lblcontrolexe.caption:='JCR.20120817.12:03  ';   //En esta versión:
   //                                                 -	Filtra componentes con mascara Ej.(AB*).
   //                                                   //en prueba borrar unidades creadas con net use.
   //  lblcontrolexe.caption:='JCR.20120822.10:55  ';   //En esta versión:
   //                                                 -	Borra unidades creadas con net use.
   //                                                 -  FormDeactivate.
   //  lblcontrolexe.caption:='JCR.20120827.17:33  ';   //En esta versión:
   //                                                 -	Se quito la rutina de  unidades creadas con net use.
   //                                                 -  Trae el fuente con BDE.
   //    lblcontrolexe.caption:='JCR.20120829.12:39  ';   //En esta versión:
   //                                                 -	Cambio en parametros, para traer el BDE, se usa sysviewsoftscm
   //                                                 -
   //
   //    lblcontrolexe.caption:='JCR.20120830.16:48  ';   //En esta versión:
   //                                                 -	Busqueda simultanea, tsindex03(actualizado)
   //    lblcontrolexe.caption:='JCR.20120831.12:03  ';   //En esta versión:
   //                                                 -	Correccion en Busca (Pruebas directas en Bancomer).
   //      lblcontrolexe.caption:='JCR.20120907.11:39  ';   //En esta versión:
   //                                                 -	Busca en México, Chile, Perú, Colombia, Puerto Rico y Estados Unidos.
   //                                                 -  Lista de Componentes, quite la columna de usado por.
   //
   //      lblcontrolexe.caption:='JCR.20120920.11:15  ';   //En esta versión:
   //                                                 -	Query, salida a excel.
   // lblcontrolexe.caption:='JCR.20121112.12:19  ';     //En esta versión:
   //                                                 -	Nueva Imagen.
   //  lblcontrolexe.caption:='JCR.20121204.17:56  ';     //En esta versión:
   //                                                 -	Versiòn con elecciòn de paìs o compañìa.
   // lblcontrolexe.caption:='JCR.20130110.16:16  ';     //En esta versión:
   //                                                 -	Versiòn con ayuda.
   // lblcontrolexe.caption:='JCR.20130307.15:34  ';       // Versión con modificaciones en la recepción (RGM)20/02/2013 11:27 a.m.
                                                        //  para convertidor de programas (RGM)  Miércoles 06/03/2013 07:38 p.m.

   //lblcontrolexe.caption:='JCR.20130401.16:50  ';      //- Cambios solicitados por Roberto en ptsdm.pas, sustitución de ptsrecibe.pas y ptsrecibe.dfm (Recepción de Componentes)[BANORTE]. (Solicitado el 2013/03/31)
                                                       //- Matriz de archivos Físicos. (Versión adaptada para JOB´s y JCL´s)
                                                       //- Búsqueda (PRIMERA Versión-->Abre una ventana, para editar el select)
                                                       //- Diagrama de Proceso (Campo control para diagramas), (especificadas por correo por Roberto el 20130311,  adecuaciones terminadas el 20130312 y liberadas en esta versión).
                                                       //- Inventario de Componentes (Cuando sea necesario limpiar los archivos del inventario creados al día, adicione la opción de "Limpiar Inventario", en el menú de administración, y así cuando cualquier usuario pida el Inventario, este estará actualizado con la información más reciente).
                                                       //- sysviewlogYYYYMMDD-HHNNSS.txt ya no se creará en c:\ ---- Se creará en c:\svw5\tmp

   //lblcontrolexe.caption:='JCR.20130409.16:00  ';    //- Libere versión con  :
                                                       //   Matriz  de Archivos Fisicos
                                                       //	 Nuevo Diagramador.
                                                       //	 Nueva  Busqueda
                                                       //	 Vista Previa de pantallas Visual Basic

   //lblcontrolexe.caption:='JCR.20130426.16:30  ';      //- Libere versión con  :
                                                       //   Lista dependencias de Componentes
                                                       //   Creación de archivo de Lista Dependencias de Componentes
                                                       //	 Actualizaciones en la vista previa de pantallas Visual Basic.
                                                       //	 Separación de funciones y eventos Visual Basic.
                                                       //   En el diagrama de procesos y analisis de impacto, ya no muestra el nombre
                                                       //  de la biblioteca, para ver completo el nombre del componentes.
   //lblcontrolexe.caption:='JCR.20130625.16:30  ';      //- Libere versión con  :
                                                       //   Formato de diagramas nuevo (Análisis de Impacto, Diagrama de Proceso, Diagrama de Flujo de JCL).
                                                        //   .....
   //lblcontrolexe.caption:='JCR.20131121.16:30  ';      //- Libere versión con  :
                                                        //   Nuevo manejo de directorios (RGM)
                                                       //   Nueva modalidad de documentación (fercar)
                                                        //   Nueva forma de configurar la presentación de componentes en el árbol (Alejandra)
                                                        //
                                                        //.....

   //lblcontrolexe.caption:='JCR.20131211.11:30  ';      //- Libere versión con  :
                                                        //   Diagrama de Bloque (Issac)
                                                       //   Cambios para editael fuente (fercar)
                                                        //   Catálogo de productos, inventario (jcr)
                                                        //
                                                        //.....
   //lblcontrolexe.caption:='JCR.20140103.11:42  ';       //-  Libere versión con  :
                                                        //   Diagrama de Bloque (Issac)---Modificado
                                                       //   Lista de Componentes con  grid  ---Fernando Ramirez
                                                        //   Documentación (fercar)
                                                        //.....
   //lblcontrolexe.caption:='JCR.20140108.17:34  ';       //-  Libere versión con  :
                                                        //   Administración de docuemntos
                                                       //   Consulta de componentes (nueva imagen))
                                                        //
                                                        //.....
   //lblcontrolexe.caption:='JCR.20140124.17:34  ';       //-  Versión para DEMO a BANAMEX
                                                        //
                                                        //.....

   //lblcontrolexe.caption:='JCR.20140219.10:57  ';       //- Nueva versión del inventario
                                                        //- Cambios en la forma general de las listas y diagramas
                                                        //- Rutinas independientes de carga
                                                        //- Nuevo campo en tsrela-Auxiliar
                                                        //  (Este nuevo campo tendrá la función de almacenar el dato
                                                        //   correspondiente al diagrama que se muestre)
                                                        //.....
   //lblcontrolexe.caption:='JCR.20140303.12:13  ';       //-  Matriz de atchivos lógicos
                                                        //-  Inicio de la separación de la lógica del negocio
                                                        //-  Generación de diagrama de flujo de COBOL
                                                        //.....
   //lblcontrolexe.caption:='JCR.20140305.13:40  ';       //-  Nuevos campos en tsrela
                                                        //-  Cambios en la recepción de componentes
                                                        //.....
   //lblcontrolexe.caption:='JCR.20140403.15:44  ';       //-  Nuevos campos en tsrela
                                                        //-  Cambios en la recepción de componentes   (Borra librerias, adaptaciones en los parametros)
                                                        //-  Documentación automática de sistema.
                                                        //-  Diagrama de Sistema
                                                        //-  Cambios en el Inventario de Componentes
                                                        //-  Diagramación de COBOL Y Copy´s de COBOL
                                                        //-  Consulta de componentes se puede elegir un sistema o todos.
                                                        //.....
   //lblcontrolexe.caption:='JCR.20140408.17:30  ';     //-  Cambios en tsrela  en la PK-se adiciono OCPROG
                                                        //.....
   //lblcontrolexe.caption := 'JCR.20140530.10:25.VN01' ; //-  Quita "  del nombre de componente, pues daba problemas con los stringlist.
                                                        //-  Correcciones en Referncias cruzadas para exportar a excel.
                                                        //..... VN Version Nueva....Con separacion de Sistemas.
   //lblcontrolexe.caption := 'JCR.20140612.1:30.VN03' ; //-  Cambios para separar por sistema
                                                        //-  Documentación automatica
                                                        //-  Cambios en la Recepción
   //lblcontrolexe.caption := 'JCR.20140618.17:46.VN04' ; //-  Con correciones especificadas en el cuadro de pendentes de esta fecha.
   //lblcontrolexe.caption := 'JCR.20140626.11:23.VN06' ; //-  Con correciones especificadas en el cuadro de pendentes de esta fecha.

   //lblcontrolexe.caption := 'JCR.20140627.16:50.VN07' ; //-  Búsqueda con sistema y clase.
   //lblcontrolexe.caption := 'JCR.20140630.05:38.VN08' ; //-  Inventario con Stored Prodedure
   //lblcontrolexe.caption := 'JCR.20140707.10:38.VN08' ; //-  Cambios en la búsqueda, tsindex03
   //lblcontrolexe.caption := 'JCR.20140709.07:46.VN08' ; //-  Documentación automática  con Diagramas WFL Y ALGOL
   //lblcontrolexe.caption := 'JCR.20140710.16:56.VN08' ; //-  Documentación automática  con Diagramas MOCROS
   // ============================ ALK =========================================
   //lblcontrolexe.caption := 'ALK.20140806.02:10.1' ; //* Documentación automática correccion de detalles: Matriz de Archivos fisicos
                                                          //* Mostrar fuentes desde diferentes diagramas del sysmining
   //lblcontrolexe.caption := 'ALK.20140812.10:23.2' ; //- Generar diagramas ALG,WFL,MACRO sin usar el bat
                                                        //- Colocar en utilerias los exe generadores de diagramas

   //lblcontrolexe.caption := 'ALK.20140902.04:10.VN08' ;  //* Modificacion para que tome query en busqueda de componenetes aunque tenga saltos de linea
                                                         //* Llamado de fuentes por tamaño (diferente metodo para fuentes grandes/pequeños)
                                                         //* Lista de dependencias- menu de opciones actualizado,llamado a diagrama de analisis de impacto
                                                         // para componentes (CICLADO) corregido.
   //lblcontrolexe.caption := 'ALK.20140904.09:42.VN08' ;  //* Modificacion Referencias Cruzadas en parametros para ver fuente
   //lblcontrolexe.caption := 'ALK.20140908.09:42.VN08' ;  //* Modificacion a diagrama de bloques para añadir filtro
                                                         //* Adaptacion para hacer la minería sobre componentes que ya están en producción RGM
   //lblcontrolexe.caption := 'ALK.20140910.09:34.VN08' ;  //* Modificacion a Referencias Cruzadas y Lista de dependencias para que manden llamar a la funcion
                                                   // que quita de la lista de ventanas abiertas a las ventanas que ya se cerraron
                                                   // * Modificacion en ptsgral,una funcion que borra del arreglo que se genera el elemento que se le manda
                                                   // para tratar de solucionar el Out of System Resources (solo para lista de dependencias)
                                                   //* Modificacion para desaparecer mensaje en documentacion automatica "Archivo no se puede abrir"
   //lblcontrolexe.caption := 'ALK.20140912.04:07.VN08' ; //* Modificacion de metodo utilizado para generar diagrama de bloques, adaptado a la logica que usa carlos en Stored Prodedure
   //lblcontrolexe.caption := 'ALK.20140915.09:40.VN08'; //* Modificacion en ufmListaDependencias, asi como en parbol para que genere las listas de dependencias para ETP (provisional)
                                                       //* Cambio de forma y codigo completo de ufmMatrizAF
   //lblcontrolexe.caption := 'ALK.20140917.09:26.VN08';  //* Nuevamente se cambia completo el pas de ufmMatrizAF    RGM
   //lblcontrolexe.caption := 'ALK.20140917.13:41.VN08'; //* Modificacion para mostrar diagrama de bloques con CPY's (revision)  ALK
                                                       //* Modificacion para que muestre diagrama de componentes por sistema
                                                       //* Modificacion para que corte cuando encuentre LIBRARY en diagrama de componentes
                                                       //* Modificacion para la forma de mostrar niveles por diagrama de dependencias     RGM
   //lblcontrolexe.caption := 'ALK.20140918.14:42.VN08'; //* Modificacion ptsdiagjcl para que aparezca lista de opciones en diagrama de flujo
   //lblcontrolexe.caption := 'ALK.20140918.23:15.VN08'; //* Quito comentari para que aparezca sistema en ufmlistadependencias
   //lblcontrolexe.caption := 'ALK.20140919.09:38.VN08'; //* Solucionado el detalle de que no generaba diagrama de flujo, un dedazo cambio el nombre
   //lblcontrolexe.caption := 'ALK.20140920.01:18.VN08'; //* Integracion de codigo para generar el diagrama del sistema a partir de la documentacion automatica al pedir generar el informe
   //lblcontrolexe.caption := 'ALK.20140922.09:23.VN08'; //* Se coloca el nombre del archivo con fecha y hora exacta para generar la lista de excel para grids
   //lblcontrolexe.caption := 'ALK.20140922.11:55.VN08'; //* Limite de registros para exportar a excel 65,000, se condiciona en uRutinas Excel
   //lblcontrolexe.caption := 'ALK.20140923.18:34.VN08'; //* Cambio en el formato del documento word de la documentacion automatica para que incluya el diagrama del sistema
   //lblcontrolexe.caption := 'ALK.20140924.16:02.VN08'; //* Cambio Robert para generacion de diagramas grandes flujo/jerarquico para CBL
                                                       //* Correccion de detalles finales para diagrama de sistrema desde documentacion automatica
   //lblcontrolexe.caption := 'ALK.20140926.17:18.VN08'; //* Integracion del diagramador de martin para CBL, cambio de funcion utilizada para generacion de diagramas desde documentacion automatica, ahora es Tfarbol.GenerarDiagramaNvo
   //lblcontrolexe.caption := 'ALK.20140929.16:23.VN08'; //* Modificacion en ufmScheduler para que muestre al dar doble click el menu de productos
   //lblcontrolexe.caption := 'ALK.20140930.16:23.VN08'; //* Modificacion para que muestre la lista de dependencia de componentes CTM
   //lblcontrolexe.caption := 'ALK.20140930.23:30.VN08';  //* Regresar el diagrama de flujo interactivo en parbol
   //lblcontrolexe.caption := 'ALK.20141001.11:04.VN08';  //* Detalle de scheduler para que aparezca como Diagrama Scheduler resuelto
   //lblcontrolexe.caption := 'ALK.20141002.16:52.VN08'; //* Sustitucion de mgflcob .pas/.dgr para el export del diagrama interactivo de cobol RGM
                                                       // * Captura de errores y sustitucion por mensajes mas personalizados
   //lblcontrolexe.caption := 'ALK.20141003.12:16.VN08'; //* Modificacion para que no mande error en el nodo final de los diagramas. punto 85
   //lblcontrolexe.caption := 'ALK.20141003.16:23.VN08'; //* Archivos que genera cuando rebasa de 500,000 lineas. Le agregué mnemónicos de 3 letras al principio de cada línea en parbol para cobolflow RGM
   //lblcontrolexe.caption := 'ALK.20141006.12:51.VN08'; //* Se controla el error al crear los productos y meterlos a un arreglo. en ptsgral, por el momento solo son las lista de dependencias y el analisis de impacto
   //lblcontrolexe.caption := 'ALK.20141006.13:48.VN08'; //* Correccion Robert de diagrama interactivo cobol
   //lblcontrolexe.caption := 'ALK.20141009.10:30.VN08'; //* Correccion Robert ALG
   //lblcontrolexe.caption := 'ALK.20141009.15:41.VN08'; //* Correccion de nombres para que jale los diagramas al documento de doc auto (busca "alk aqui va el cambio para los link en diagramas")
   //lblcontrolexe.caption := 'ALK.20141013.12:46.VN08';  //* Cambio de instruccion para hacer los diagramas de flujo de CBL vertical
   //lblcontrolexe.caption := 'ALK.20141014.10:40.VN08';  //* Integracion de diagramas visustin para clases: OBY,JCL,JOB,TDC,SUX,USH,CCH,CUX,PUX,HUX para arbol y para doc aut.
   //lblcontrolexe.caption := 'ALK.20141015.16:27.VN08';  //* Modificacion para la demo Z/OS RGM
   //lblcontrolexe.caption := 'ALK.20141015.18:38.VN08';  //* Modificacion a documento word para ligar diagramas flujo JOB, JCL
   //lblcontrolexe.caption := 'ALK.20141020.09:18.VN08';  //* Funciones para evitar los errores en el create de los productos cuando se navega por el sysmining en arbol y en ptsgral
   //lblcontrolexe.caption := 'ALK.20141020.10:36.VN08'; //* Modificacion para los puntos 101 y 103 BMG
   //lblcontrolexe.caption := 'ALK.20141020.13:15.VN08'; //* Modificacion para los diagramas de flujo JCL version online y version visustin
   //lblcontrolexe.caption := 'ALK.20141020.17:12.VN08';  //* correccion en la funcion que borra los productos del arreglo del arbol.
   //lblcontrolexe.caption := 'ALK.20141021.13:56.VN08';  //* Cambio en las rutinas de cambio de combo para ufmlista de componentes //cambio ALK!!
   //lblcontrolexe.caption := 'ALK.20141021.16:04.VN08';  //* Modificacion punto 39 BMG
   //lblcontrolexe.caption := 'AOM.20141022.12:10.VN08';  //* Cambio de popup independiente para el arbol, queda pendiente el free para las funciones que borran los proocudotos de los arreglos del arbol y gral
   // **************  Nueva version de nomenclatura para que coincida  *************************
   //lblcontrolexe.caption := 'AOM.20141022.16:43.V602';
   // *************  Nueva version de nomenclatura 7.cont_mes.dia  ****************************** mes 0-octubre
   //lblcontrolexe.caption := 'AOM.20141023.12:46.V7023';    //* Menu para clases NEP y NEG en pgral, modificacion punto 42 Brenda
   //lblcontrolexe.caption := 'AOM.20141028.14:36.V7028';   //* Punto 140 BMG y punto 161 ALK se añade la opcion en pgral para flujo de TDC y cambio de funcion para flujo del CBL en gral; agregado sistema TANDEM para diagramador CBL
   //lblcontrolexe.caption := 'AOM.20141028.16:40.V7028';   //* Punto 162 y 156
   //lblcontrolexe.caption := 'AOM.20141030.16:28.V7030';   //* Modificacion brenda punto 126 ufmDiagraSistema pas y dfm y ufmdocsistema
   //lblcontrolexe.caption := 'AOM.20141030.11:09.V7103';  //* Puntos 168, ajuste del 152 RGM y punto 43 BMG

   // ************* Version con el uso de la funcion version *************************************
   //pone_version('V7103','20141103.11:27'); //* Cambio de forma para poner version en forma general y etiquetas ALK (ptsmain, facerca)
   //pone_version('V7103','20141103.15:37'); //* Modificacion a funcion GenerarDiagramaNvo en parbol para sistema tandem en scb22 para que tome del campo dato de la tabla parametros el indicador BC y a partir de ahi determine si es T o F en el diagramador
   //pone_version('V7104','20141104.10:39'); //* Modificacion punto 151 en ptsrecibe y ptsrec nuevos  RGM
   //pone_version('V7104','20141104.11:33'); //* Complemento punto 140 ALK cambio de nombre de diagrama de procesos a diagrama de componentes
   //pone_version('V7105','20141105.10:38'); //*Complemento del punto 151 RGM ptsrec nuevo.  Añadir listas dep y comp en ptsgral para clase TSE   ALK
   //pone_version('V7105','20141105.16:42');  //* Punto 174 BRE cambio completo de ufmSVSDiagrama pas y dfm
   //pone_version('V7106','20141106.16:39');  //* Añadida clase CTM a las excepciones del menu contextual de ptsgral para las listas ALK

   //pone_version('V7107','20141107.17:43');  //* Version beta para corregir out of system resources para sysmining (falta en documentacion) ALK parbol, ptsgral  -  Cambio en ufmBuscaCompo BMG

   //pone_version('V7110','20141110.13:28');  //* Modificacion de BMG para punto 143, cambio al FormActivate  del ufmDocHistorial  (pendiente de revision)
   //pone_version('V7110','20141110.14:26');  //* Modificacion ALK funcion clases_p_listas para las clases de las listas dep y comp en ptsgral y parbol  ALK
   //pone_version('V7111','20141111.09:24');  //* Cambio en ptscnvprog.pas y ptscnvprog.dfm, para generar nuevo binario para proyecto "Reducción de MIPS".  RGM
   //pone_version('V7112','20141112.13:00');  //* Cambio para diagrama interactivo CBL, en ptsgral, parbol, ptscomun  RGM
   //pone_version('V7112','20141112.16:49');  //* Cambio pendiente para acelerar la vista del fuente en el arbol. Nueva funcion memo_fuente  ALK
   //pone_version('V7113','20141113.16:03');   //* Cambio para punto 137, ufmDocSistema y uConstantes modificado, inclusion de fDgrFlujoOBY - ALK
                                             //* Punto 169 tomar el archivo ini de la utileria para diagrama sistema ufmDiagraSistema - ufmDocSistema  (CONFIG_DIAGRAMA_SISTEMA_'sistema')  ALK
   //pone_version('V7114','20141114.09:47');   //* Cambio completo de mgflcob y mgfrcob RGM
   //pone_version('V7114','20141114.14:17');   //* Cambio en parbol y ptsgral para añadir el ciclo cuando falla out of system  ALK
   //pone_version('V7116','20141116.23:34');   //* Nuevos pas y dfm para mgflcob y nuevo pas para mgfrcob  RGM
   //pone_version('V7118','20141118.10:11');   //* Se elimina cambio de color de la forma porque genera error de recursos.  MGFLCOB - RGM
   //pone_version('V7118','20141118.12:01');   //* Despliega rápidamente cuando los objetos ya están creados.   mgfrcob  RGM
   //pone_version('V7120','20141120.10:41');   //* Cambios en ptsgral y parbol para funcion diagramacblx  RGM
   //pone_version('V7120','20141120.16:39');   //* Cambios en ptsgral y parbol para funcion diagramacblx segunda version RGM
                                             //* Cambio a Referencias cruzadas, se utiliza metodo Drill Down, tiempo para generar aumenta considerablemente y cuando son enormes, no permite exportar a Excel  ALK
   //pone_version('V7120','20141120.20:54');   //* Cambio a Referencias cruzadas, se usara solo una consulta pidiendo los componentes que tengan en el owner el nombre del componente  -  ALK
   //pone_version('V7121','20141121.14:15');   //* Cambio a consultas para Ref Cruz, utilizando las consultas:     ALK
                                             //-filas   select distinct hcprog,hcbib,hcclase,orden from tsrela  where ocprog='prog' and ocbib='bib' and occlase='cla';
                                             //-filas CLA   select cprog,cbib,cclase,sistema from tsprog where cclase='cla' and sistema='sis' order by cclase,cbib,cprog;
                                             //-columnas y columnas CLA    select distinct ocprog,ocbib,occlase,orden from tsrela  where hcprog='prog' and hcbib='bib' and hcclase='cla';
   //pone_version('V7121','20141121.14:14');  //* Nuevo pas para mgflcob   RGM      - Se elimina el poner en gris las líneas de comentario cuando despliega el texto de las rutina. En equipos de recursos limitados genera el error de out of resources.
   //pone_version('V7124','20141124.11:15');  //* Modificacion para error cuando lo que se desea exportar a excel excede los limites, access violation. Para navegacion a mano, falta documentacion    ALK
   //pone_version('V7124','20141124.16:00');   //* Modificacion en parbol y ptsgral para funcion bms_preview (vista previa BMS) para que muestre correctamente la ventana si esta maximizada o no  ALK
   //pone_version('V7125','20141125.00:48');  //* Modificaciones en parbol y ptsgral, Verifica fecha de utilería contra la fecha de modificación del archivo para actualizar archivos intermedios. Se corrige error cuando no existe el parámetro EXTRA_MINING    RGM
                                            //* Modificacion al codigo para exportar a excel en los ufmSVS, cuando existe ya un csv con el mismo nombre, ya no lo convierte y lo abre.   ALK
   //pone_version('V7125','20141125.11:45'); //* Modificacion a parbol funcion expande y nueva funcion en ptscomun para eliminar las rayas que aparecen en el arbol  RGM
   //pone_version('V7125','20141125.15:29');  //* Modificacion de mgcodigo.pas y dfm mgflcob.pas y mgflrpg.pas para error out of system en el memo de colores
                                            //* Modificacion en documentacion automatica para que genere tanto los diagramas de flujo como los digramas de flujo con conmentario (visustin), nuevas clases: fDgrFlujoJCL y fDgrFlujoJCLvis   ALK
   //pone_version('V7127','20141127.12:30');  //* Modificaciones en documentacion automatica para error Access violation at address en instruccion ExportGrid4ToExcel, genera correctamente csv y lo linkea al word.  ALK
                                            //* Corrijo instruccion en ufminvcompo para que no pierda el foco al exportar grid de datos o de detalle a excel: grdDatos2 o grdDatos    ALK
   //pone_version('V7127','20141127.19:50');  //* Modificacion a documentacion automatica para estandarizar los nombres, a peticion de Martin   ALK
                                            //* Modificacion de log de errores para que presente solo el numero final de intentos para los errores en documentacion automatica
   //pone_version('V7128','20141128.12:50');  //* Modificacion en uDiagramaRutinas para el CPYrecursivo porque se enloopeaba y mandaba error de base de datos, posible causa de error en documentacion
   //pone_version('V7128','20141128.17:36');  //* Modificaciones a ptsversionado para que desabilite el boton hasta que tenga dos archivos que comparar   ALK-RGM
   //pone_version('V7204','20141204.14:16');   // * VERSION DE PRUEBA ALK PARA TODOS LOS PRODUCTOS EXCEPTO FLUJO Y JERARQUICO     ALK
   //pone_version('V7208','20141208.20:05');   // * VERSION DE PRUEBA 2 PARA TODOS LOS PRODUCTOS, EXCEPTO DIAGRAMA DE FLUJO JCL-JOB   ALK
   //pone_version('V7209','20141209.13:54');   // * VERSION ESTABLE PARA TODOS LOS PRODUCTOS.   ALK
   //pone_version('V7210','20141210.13:53');   // * Agrego codigo para que genere con graphviz los diagramas JCL de flujo   ALK
   //pone_version('V7215','20141215.15:03');   // * Cambio en ufmMatrizArchLog linea 210 para que ponga un '-' en vez de un salto de linea (char 13) en el campo Macro_jcl porque generaba problema en el programa externo csv2xls   ALk
   //pone_version('V7216','20141216.13:42');   // * Arreglo de panel para documentacion externa (falto quitarle el tab y ponerle el tgroupbox) ALK
   //pone_version('V7216','20141216.17:25');   // * Estandarizo el nombre del diagrama de sistema que arroja la documentacion a peticion de MArtha queda asi: fDgrdeSistema DSI DA 'sistema'.dgr   ALK
   //pone_version('V7226','20141226.10:15');   // *Cambio en diagrama interectivo cobol, para los parametros.   RGM

   // --------------  2015 --------------
   //pone_version('V7305','20150105.14:09');   // * Error en el traslado de titulos corregido
   //pone_version('V7306','20150106.11:19');   // * Correccion de observaciones Natan, limpieza de renglones vacios en referencias cruzadas y correccion de funcion diagrama de flujo interactivo para productos.   ALK
   //pone_version('V7307','20150107.11:02');   // * Para referencias cruzadas se hace la consulta1 segun la clase (sugerencia de Carlos para CTM)  ALK
   //pone_version('V7307','20150107.12:00');   //* Correccion de funcion doble click para referencias cruzadas   ALK
   //pone_version('V7307','20150107.13:15');   //* Correccion de Robert para comparacion en ptscnvprog  RGM
   //pone_version('V7307','20150107.18:03');   //* Correccion ptsdiagjcl para que ponga nombre y exporte correctamente ALK
   //pone_version('V7308','20150108.12:23');   //* Correccion de funcion para generar diagrama con comentarios JOB desde el arbol     ALK
                                             //* Asignacion de objetos a la barra de objetos para los productos analisis de impacto, diag componentes, diag bloques   ALK
   //pone_version('V7309','20150109.10:45');   //* Correccion de la barra de objetos para hacerla funcional
                                             //* generacion de pdf en documentacion automatica para bloques, a.impacto y procesos, ligando al documento los pdf en lugar de los wmf   ALK
   //pone_version('V7309','20150109.16:27');   //* Implementacion de la funcion LimpiaBulk en documentacion automatica para que limpie los archivos bulk*.log que genera el visustin   ALK
   //pone_version('V7310','20150110.22:06');  //* Cambio en la consulta del diagrama del sistema peticion de Carlos      ALK
   //pone_version('V7313','20150113.09:35');  //*Modificacion en los if de la generacion del diagrama de bloques para que tome los que vienen en modo null como de entrada     ALK
   //pone_version('V7315','20150115.13:59');  //* Modificaion en funcion DiagramaVisustin en el arbol para que abra el archivo que genera el visustin si ya existe (martin),   ALK
                                            // * para documentacion automatica, se modifica fDgrFlujoJCL para que genere el pdf (isaac)    ALK
   //pone_version('V7315','20150115.17:59');  //Primera version de diagrama de sistema ALK
   //pone_version('V7316','20150116.10:30');   //* Solucionado el problema del boton cancelar cuando borra el grid en consulta de componentes y dar doble click sobre el grid. (punto 212) ALK
   //pone_version('V7319','20150119.13:14');   //* Punto 211, se agrega consulta para referencias de sistema y se agrega un next para la consulta de lista de dependencia de componentes para el sistema   ALK
   //pone_version('V7320','20150120.15:32');   //*Se regresa a la version anterior de las referencias cruzadas (multiples consultas), pero con nuevas consultas.   ALK
   //pone_version('V7321','20150121.10:32');   //* Nuevo cambio para referencias cruzadas, con funcion nueva (alk) pero cambia consulta utilizada.    ALK
   //pone_version('V7323','20150123.16:12');   //* Hacer funcionar la barra de formato para diagrama de sistema
                                             //* Cambio de funcion para encontrar hijos indirectos, condiciones para flechas en clase FIL, LOC y tablas.      ALK
   //pone_version('V7326','20150126.08:55');   //* Binario prueba con boton para configurar diagrama del sistema    ALK
   //pone_version('V7326','20150126.12:38');   //* Cambio en diagrama del sistema para que los bloque se conecten de manera mas entendible
   //pone_version('V7328','20150128.12:28');   //* Cambio a Referencias Cruzadas para quitar la condicion de poner solo columnas si la segunda consulta no arroja nada.
                                             //* Diagrama de sistema:
                                                   //- Nuevos botones para cambio de tipo de linea
                                                   //- Nueva funcion para formulario de configuracion de diagrama (alkNuevoDiag)
                                                   //- Cambio en estructura de funciones para generar el diagrma, se separan procesos para poder configurar las lineas
   //pone_version('V7330','20150130.10:12');   //* Cambio en funcion de lista de dependencias para diagrama de sistema     ALK
   //pone_version('V7404','20150204.10:55');   //* Cambio en como se enlistan las clases para la configuracion del diagrama de sistema
                                             //* Nueva condicion tope para que las lineas no tarden tanto en diagrama de sistema
                                             //* Agregar lineas de codigo para que se genere el popup en diagrama de sistema     ALK
   //pone_version('V7406','20150206.12:36');   //* Implementado el guardar en la base de datos la configuracion del diagrama, con la clave "DIAGSIS_usuario_sistema"    ALK
                                             //* Se colocan radio button para seleccionar o deseleccionar todas las clases.
                                             //* Se condiciona cuando ya existe la configuracion en la base de datos
   //pone_version('V7418','20150218.15:18');   //* Modificacion para multipadres, nueva funcion para incluirlos en alknuevodiagrama, cambio nuevamente a las funciones leeclases (ufmDiagraSistema, alkNuevoDiagrama) para que busque por componentes, no por clase
   //pone_version('V7419','20150219.15:48');   //* Corregido popup para referencias cruzadas y lista de depnedencias para SISTEMA
                                             //* Corregido la pestaña del docHistorial, ya no manda error.
   //pone_version('V7425','20150225.18:39');   //* Nueva version de diagrama de sisetema, la jerarquia de clases se carga con nueva funcion y se manda ejecutar cuando se cargan/actualizan los componentes desde recepcion de componentes
                                             // Se modifico funciones en ufmDigraSistema, alkNuevoDiag y ptsgral. En la base de datos se guarda la configuracion por sistema-clase con la clave: 'JER_sis_cla' y de ahi lo retoma para mostrar
                                             // el orden de las clases. OJO  solo funciona para sistemas que arrojan un solo sistema con la consulta: select distinct sistema from tsrela;   ALK
   //pone_version('V7426','20150226.15:15');   //* Ultimas adecuaciones para que actualice los sistemas para diagrama de sistemas desde la carga de componentes o desde la opcion Jerarquia de Clases desde menu administracion. Funcionando ya para todos los sismtemas   ALK
   //pone_version('V7502','20150302.15:30');   //* Coloco el bloque para evitar error out of system en parbol-digraSistema, ptsmain-fmInvCompo, fmBuscaComp, fmMatrizCrud, ftsarchivos, ftsconscom, fmListaDependencias, fmInvCompo, fmListaCompo
   //pone_version('V7504','20150304.10:41');   //* Faltaba inicializar variable con 0 para los productos agregados en out of system
   //pone_version('V7504','20150304.18:07');   //* Modificacion de los iconos generales en el ptsmain, implementacion de variable para determinar cuando se vuelve a generar el diagrama de sistema despues de presionar configuracion o cuando viene de documentacion.     ALK
                                             //* La variable "ruta" en la funcion que guarda el diagrama de sistema se limpiaba antes de guardarlo y no guardaba el diagrama, ya esta corregido   ALK
   //pone_version('V7509','20150309.11:35');   //* Se agrega Diagrama Jerarquico CBL para ptsgral
   //pone_version('V7510','20150310.13:30');   //* Solicitud de Robert copy(m[ 1 ],1,4)  <> 'DISK' y copy(reg.hbiblioteca,1,4) <> 'DISK' en la opcion de referencias cruzadas en parbol y ptsgral     ALK
   //pone_version('V7510','20150316.21:30');   //* Binario para evaluacion de los puntos:  49,203,202,163,59,157
   //pone_version('V7523','20150323.07:40');   //* Correccion para busqueda de componentes
   //pone_version('V7526','20150326.16:50');   //* en la ventana de configuracion del diagrama de sistema, le quito los botones minimizar y maximizar,  detalles de los popup, quito opciones que no deben ir
   //pone_version('V7527','20150327.11:20');   //* Agregar referencias cruzadas a los popup en clase FIL, boton generar en diagrama de sistema bloqueado hasta que seleccione una opcion
   //pone_version('V7529','20150329.22:35');   //* SE coloca try/except para cuando no puede generar la lista de dependencias del sistema (out of memory) solo mande los que tenga almacenados al momento. Sistema C740 040   ALK
   //pone_version('V7615','20150515.18:05');  // * Se corrigen los siguientes puntos: diagrama de visustin JCL ya aparece en el word y ya se genera, estaba mal el nombre, al terminar de procesar el word ya manda la palabra Terminado en la barra de mensaje    ALK
   //pone_version('V7618','20150518.14:30');  // * Se agrega opcion de exportacion a pdf en diagrama JCL, esta en construccion el diagram scheduler   ALK
   //pone_version('V7618','20150518.16:20');  // * Correccion en busqueda de componentes linea 408 aprox cambio de la instruccion guarda_buffer(3,ht); se cambia el 3 por el 1.    Falta crear la variable $LIBRARY, para saber en qué librería lo encontró   RGM
   //pone_version('V7619','20150519.15:05');  // * Correccion de Splitter en busqueda de componentes.
                                            // * Implementacion del ejecutable para generacion de Scheduler
   //pone_version('V7622','20150522.21:00');  // * Integracion de diagrama especifico para diagrama scheduler   ALK

   //pone_version('V7629','20150529.19:20');  //cambio de la utileria de malla por el fuente para arbol y para CTR en gral. Para CTM en gral queda pendiente el cambio para colocar los padres en el grid
   //pone_version('V7701','20150601.16:45');  // Scheduler con malla tomada del fuente y nuevo proceso de Carlos Stored Procedure para clases activas e inactivas.
   //pone_version('V7702','20150602.17:20');  // Scheduler con malla tomada del fuente completo, modificacion para consulta de componentes, traer el padre para la clase CTM, pendientes los demas productos   ALK
   //pone_version('V7710','20150610.19:35');  //Cambio de formato wmf a pdf para los diagramas JCL que no sean de visustin   ALK
   //pone_version('V7715','20150615.20:50');  // Cambio en documentacion automatica para productos: fmBloques, fmAnalisisImpacto, fmProcesos, fDgrFlujoJCL. Ahora comprueba que exista WMF, PDF y en su caso XLS y los crea por separado
   //pone_version('V7722','20150622.20:10');  // Integracion de columnas de la tabla ts_estad_complej creada por Carlos en la tabla de propiedades, son 8 columnas las que se agregaron.   ALK
   //pone_version('V7729','20150629.13:50');  // Integracion de utileria COMPLEJIDAD para ejecutable de Natan calculo de complejidad, falta retomar los datos de salida y guardarlos en la base de datos.  ALK
   //pone_version('V7813','20150713.12:35');  // Integracion de codigo en ptsdm para crear las tablas de Carlos de complejidad si es que no existen, modificacion en la rutina de ptsmain para generar y cargar los datos a las tablas desde el sysmining.  ALK
   //pone_version('V7814','20150714.23:45'); // Cambio en diagrama de bloques para que genere con la clase CMA, tambien se agrego a la lista de productos del popup los diagramas para la clase CMA
   //pone_version('V7817','20150717.10:55'); // Nuevas leyendas en documentacion al obtener fuente cuando es scratch y cuando es virtual. Cambio en la ventana para ejecutar diagrama de Natan, queda pendiente la funcionalidad. Cambio en la consulta de calculo de complejidad para incluir la clase CMA   ALK
   //pone_version('V7820','20150720.17:10'); // Nuevo binario para generar Scheduler CTR, cambio de ventana e implementacion de lectura de archivo de error. ALK
   //pone_version('V7822','20150722.09:30'); // Correccion de mensaje de error y un detalle para diagrama scheduler CTM, validar si esta nil   ALK
   //pone_version('V7822','20150722.10:20'); // Nuevo nombre a utilerias SCHEDULER
   //pone_version('V7827','20150727.09:30'); //Añadida complejidad ciclomatica
   //pone_version('V7827','20150727.11:10'); //
   //pone_version('V7828','20150728.13:25'); // Cambio de parametros para scheduler CTM, modificacion de posicion de la funcion donde se actualizan las versiones de la base de datos (Tdm.revisa_version)   ALK
   //pone_version('V7830','20150730.07:25'); // Se añade un documento de salida con los insert para la complejidad de McCabe de Natan
   //pone_version('V7830','20150730.12:55'); // Se añade un DELETE al componente antes de las complejidades para actualizarlo   ALK
   //pone_version('V7831','20150731.13:40'); // Correccion del alto en la documentacion automatica, ya funciona nuevamente detener el proceso desde el ini  ALK
   //pone_version('V7906','20150806.12:10'); // Cambio en la base de datos, se agrega campo complejidad a la tabla tsclase, tambien se modifica el catalogo de clases para esta nueva modificacion
                                           // Cambio en la organizacion de actualiza_version para que no truene en bases de datos muy viejas
                                           // Funcion de complejidad en ptsdm para que sea general, recibe los datos del componente y lo procesa
                                           // Implementacion de la funcion de complejidad tanto para menu de administracion como para carga de componentes
                                           // Nueva utileria para procesar componentes cobol:  TANDEM_VOLUMEN_DEFAULT  (preguntar que es lo que se carga ahi)
   //pone_version('V7911','20150811.10:10'); // Cambio en la rutina GlbBlockFlow en uDiagramaRutinas para cambiar el tamaño de letra de acuerdo a la cantidad de letras que lleva la figura del diagrama
                                           // Mensaje para recodar cargar la complejidad en la tabla de clases a partir del catalogo de clases del menu administracion
                                           // nueva version de base de datos, cambio de Robert
                                           // Cambio en la consulta del diagrama de flujo de JCL, Robert modifico el taladra Tsrela por una funcion propia
   //pone_version('V7917','20150817.11:10'); // Cambio en ufmDocumentacion para solucionar conflicto con el boton de ver eliminados (Ver eliminados/Regresar) ALK
   //pone_version('V7918','20150818.00:15'); // Cambio en la funcion para abrir archivos en ufmDocuementacion para evitar el error cuando son archivos rtf
   //pone_version('V7919','20150819.13:20'); // Nueva funcion para codigo muerto en ptscomun RGM
                                           // Nueva funcion para boton actualizar en ufmDocumentacion   ALK
   //pone_version('V7921','20150821.21:30'); // Habilitadas las funciones para reingresar y actualizar un documento en documentacion externa  con iconos!!  ALK
                                           // Cambio en ptsgral para traer el fuente del owner para las CTM que son hijas de CTM
   //pone_version('V7925','20150825.14:10'); // Se elimina el boton "Ver Eliminados" de ufmDocumentacion  ALK
                                           // Se va a utilizar la columna activo de la tabla tsdocrevision para guardar el estatus del documento antes de una nueva version
                                           // En el boton descargar de la ventana de versiones, se agrega un punto en el documento para que lo guarde correctamente
                                           // Despliega los image (jpg, gif)   RGM
   //pone_version('V7926','20150826.10:00'); // Se agrega condicion para no poder borrar un documento en uso ufmDocuentacion   ALK
   //pone_version('V71008','20150908.16:05'); // Cambio en la funcion gral.exporta, para generar un csv, probado con documentacion y en batch  ALk
   //pone_version('V71009','20150909.12:10'); // Cambio en funciones gral.exporta y gral.esportaProc para generar un csv, ya funciona tanto en batch como en documentacion  ALK
   //pone_version('V71010','20150910.13:50'); //Cambio en la estructura de como sale el analisis de impacto y el diagrama de componentes, ahora trae nombre, como anteriormente se mandaba
   //pone_version('V71018','20150918.13:00'); // nueva funcion ptsdm ExportAsPdf para sustituir GlbExportarDgr_A_PDF  en la documentacion automatica   ALK
   //pone_version('V71024','20150924.14:00'); // Cambio en la foma en como se presenta diagrama de bloques, ahora ya no aparece la clase, sino todo completo   ALK
                                            // Se quita el letrero que aparece al procesar documentacion automatica despues de la primera clase (a probar!!)   ALK
   //pone_version('V71030','20150930.10:30'); // cambio de Roberto en parbol para mostrar fuente de clases virtuales   ALK
   //pone_version('V71105','20151005.12:15'); //Cambio en documentacion automatica funcion es_SCRATCH para comprobar que tenga fuente o no generar sus productos, cambio en funcion trae_fuente, se añade funcion es_virtual para saber cuando la clase es fisica o virtual   ALK
   //pone_version('V71107','20151007.09:00'); // Validacion de fuente para productos tanto en arbol como en gral
                                            // Nueva aclaracion de Carlos, debe ser una clase fisica y tener fuente para generar los productos.
   //pone_version('V71114','20151014.12:00'); // Funcion para mostrar detalles de las tablas concluida para arbol y productos, faltan detalles como separar en columnas la columna de detalles   ALK
   //pone_version('V71118','20151018.09:15'); //Complemento de la funcion que ya separa el campo coment en 4 columnas, cambio en la programacion de como genera la tabla para que lo tome de un strinlist y no de la consulta, ya funciona para DEMO   ALK
   //pone_version('V71121','20151021.13:50'); // Cambio en inventario de componentes para que muestre el grid optimizado y muestre la informacion del primer sistema que contiene.
   //pone_version('V71123','20151023.11:10'); // Cambio en el nombre del id, a campo_id, nueva funcion GlbCrearRecID para que el campo lleve el nombre que se desea, ahora la tabla de detalle de TAB tambine contiene el table space   ALK
   //pone_version('V71126','20151026.14:00'); // Validacion de si existe o no el indice al solicitar la busqueda de componenetes   ALK
   //pone_version('V71127','20151027.14:00'); // correccion de algunos detalles para las funciones arma_tabla y procesa_x_bib  tambien se cancela la vista del documento log_indexa.txt a peticion de martha para la opcion crea indices  ALK
   //pone_version('V71129','20151029.11:40'); // se agrega menu conceptual al proeducto detalle de tabla, se agrega coumna de biblioteca de campo y llave primaria pentiente modificar la funcion que trae la longitud del campo   ALK
   //pone_version('V71130','20151030.12:30');  // nueva funcion sGlbExportarListaDialogo para que tome el nombre y la extension y mande el cuadro de dialogo  ALK
   //pone_version('V71202','20151102.20:00');  // se quita columna tablespace, se agrega columna descripcion, se agrega la programacion para cuando no tiene espacio entre los parentesis la longitud.  ALK
   //pone_version('V71203','20151103.09:00');  // se soluciona el detalle de los menus por que al quitar la columna de table space se recorrieron los indices   ALK
   //pone_version('V71204','20151104.13:30');  // Se corrigen errores de presentacion en las columnas como la captura de la longitud, la presentacion de la llave primaria y la presentacion de la columna extras, se agrega detalle de tabla para SEL UPD DEL INS   ALK
   //pone_version('V71205','20151105.13:30');  //Cambio de las consultas para detalle de tabla, ahora todas llevan la clase TAB aunque sean DEL, INS, UPD o SEL
   //pone_version('V71210','20151110.14:00');  // Menu conceptual para busqueda de componenetes, queda pendiente multibibliotecas.  ALK
   //pone_version('V71212','20151112.11:00');  //se soluciona los nombres con acento para documentacion externa   ALK
   //pone_version('V71217','20151117.14:00');  // Se cambia mensaje de documento incongruente al regresar un documento apartado en documentacion externa
                                             // se agrega la extension en caso de que el usuario la borre por accedente al descargar o actualizar la documentacion externa    ALK
                                             // se quita la columna de estatus para el historial de la documentacion externa.   ALK
   //pone_version('V71220','20151120.11:20');  //  Menu conceptual para grid de busqueda de componentes cuando no se especifica query     ALK
   //pone_version('V71225','20151125.08:00');  // Cambio solicitado por Robert para descargar utilerias para procesar SQL's en ptsrec   ALK
   //pone_version('V71225','20151125.10:16');  // Correccion del error de no existe fuente (Martin), correccion de perdida de foco para busqueda de componentes (carlos)   ALK
   //pone_version('V71226','20151126.12:30');  // Modificacion en funcion de complejidad para obtener las utilerias solo una vez antes del ciclo   ALK
   //pone_version('V71227','20151127.08:00');  // Cambios sugeridos para ptsrec de Robert para problema del TANDEM _VOLUME_DEFAULT y la carga correcta de los coboles   RGM
   //pone_version('V71230','20151130.12:30');  // Correccion para diagramas JOB y JCL de flujo, se ciclaba, se agrega comprobacion   ALK
   //pone_version('V71230','20151130.12:30');  // Cambio en la pantalla busqueda de componentes para evitar el error de "no existe fuente" cuando se filtra
                                             // Nueva ventana "Cambios masivos automaticos"    RGM
   //pone_version('V71309','20151209.21:20');  // Se cambio la opcion "Cambios masivos automaticos" a un nuevo menu "Cambios masivos"   ALK
                                             //  Nuevo formato de ventana busqueda de componentes para que se expanda cuando se maximiza la ventana   ALK
   //pone_version('V71310','20151210.15:00');  //Cambio de cambios masivos RGM     nuevo tamaño de menu principal  ALK
   //pone_version('V71311','20151211.10:00');  // Cambio en el tamaño de los combos de busqueda de componentes  ALK
   //pone_version('V71314','20151214.09:30');  // los combos de la ventana de busqueda de componentes se ajustan al tamaño, la tabla resultado de la consulta sin query ya aparece en el tamaño apropiado    ALK
   //pone_version('V71316','20151216.10:00');  // Solucion a desapaciricion de combos en busqueda, (cambio de funcion al evento resize del form); se quita validacion de SCRATCH de la matriz crud para arbol y productos. SE comentaria funcion que mandaba error en el foco cuando se hace la busqueda con query en busqueda de componentes     ALK
                                             // Cambio de formulario y codigo solicitado por Robert para cambios masivos
   //pone_version('V81406','20160106.10:00');  //* Consulta de componentes: -agregar mascara (*) - tamaño de combos automatico  - en funcionamiento el boton cancelar  - ocultar grid cuando no se usa
                                             //* Busqueda de componentes: - Tamaño de la ventana al crear mas chica para mostrar los combos
                                             //* Matriz CRUD: - Cambio de diseño de la pantalla para estandarizar  - Uso de boton para evitar mensajes ciclicos y poder consultar nuevamente - agregar tabla (*)  - ocultar grid cuando no se usa   - tamaño de combos automatico
   //pone_version('V81411','20160111.13:00');  // * Validacion de combos en busqueda de componentes, reportado por Carlos   ALK
                                             // * Ventana mas grande en busqueda de componentes y consulta de componentes
                                             // * Mostrar datos del primer componente en Matriz CRUD
                                             // * Funcionando MAtriz CRUD tanto en main como desde el arbol
                                             // * Cuando el resultado no arroja nada, deja el panel y manda mensaje (Matriz CRUD y Busqueda de componentes)
   //pone_version('V81415','20160115.13:30');  // * Matriz de archivos fisicos, cambios a estandarizar
   //pone_version('V81420','20160120.10:30');  // * Estandarizacion para productos: busqueda de comp, consulta de comp, inventario de comp, matriz crud, matriz de af. Queda pendiente funcionalidad de las matrices. Especificaciones en excel   ALK
                                             // *quito condicion de SCRATCH para matriz AF y matriz CRUD para arbol y gral
   //pone_version('V81427','20160127.13:30');  // * Modificacion completa de lista de componentes y  lista de dependencias   ALK

   //pone_version('V81428','20160128.11:30');  // *Cambio de localizacion de paneles de matrices AF CRUD   ALK
   //pone_version('V81504','20160204.11:30');  // * Se cambian las consultas para procedimiento de diagrama de bloques, (owner en lugar del padre)
                                             // * Cambio de lista de componentes, se agrega grid para mostrar los componentes y filtros mas abiertos, para ampliar la busqueda   ALK

   //pone_version('V81505','20160205.14:00');  // * No es oficial, faltan muchos detalles de la lista de dependencias, pero ya funciona lo mas basico  ALK
   //pone_version('V81518','20160218.09:00');  // *arreglado los detalles de la lista de componentes y las listas del sistema.
                                             // * etiquetas de todos l@s... cambiadas a mayuscula
                                             //* ventana de propiedades con sus respectivos botones de maximizar, minimizar, etc.
   //pone_version('V81523','20160223.11:30');  //* Documentacion automatica con nuevos exits (terminar proceso true)
                                             //* Docu auto arreglada listas y matrices.

   //pone_version('V81604','20160304.12:00');  //* Version temporal solo tiene la parte de las matrices, le quito la funcion para ver si es SCRATCH    ALK
   //pone_version('V81607','20160307.13:00');  //* Popup sin la opcion "Matriz de archivos logicos"  a peticion de Martin/Roberto/Carlos     ALK
   //pone_version('V81616','20160316.12:30');  //* Se agrega validaciones estaticas al menu  ptsstatica a peticion de Robert      ALK
   //pone_version('V81628','20160328.09:30');  //* Se agregan cambios para directivas CBL y CMA  funcion parametros_extra  RGM
   //pone_version('V81628','20160328.09:30');  //* Agrego funcion para diagrama de flujo DCL en arbol y en productos, falta documentacion automatica
   //pone_version('V81706','20160406.14:00');  // * Nueva condicion para los archivos LOC en diagrama de bloques, ahora el modo lo muestra como Input, output, I-O o null
                                             // * Robert corrige los nombres "sucios" en la busqueda de componentes para que se puedan mostrar los fuentes correctamente
                                             // * Corrijo proceso bGlbPoblarTablaMem en uListaRutina para que no haya error en los titulos cuando traen ':'   ALK
                                             // * Desarrollo INCOMPLETO de la nueva ventana para configurar los diagramadores de Martin alkConfigDiag  ---  falta!!!!!!!
                                             // * Nueva funcion para determinar tipo de cobol da_tipo_cbl en ptscomun, 0 tipo; 1 parametro completo   se utiliza en diagramador cobol y complejidad      ALK
                                             // * Implementacion de nueva funcion da_tipo_cbl para complejidad
   //pone_version('V81708','20160408.22:30');  // * Agrego detalle de inserts de complejidad por cada componente cargado   ALK
                                             // * Agrego detalle de corrida de programa de Natan
   //pone_version('V81711','20160411.14:30');  // * Diagramador, estatus 80% -  falta documentacion y probar split.   ALK
   //pone_version('V81713','20160413.12:30');  // * Diagramdor para DCL online y doc automatica completo      ALK
   //pone_version('V81714','20160414.13:30');  // * Diagrama de bloques corregido detalle para LOC de salida (columna derecha)  ALK
                                             // * SE agrega nuevo modo para loc   A  append
                                             // * Corrijo diagramador para split, que genere todos los diagramas aunque no tengan numeracion
                                             // * Nuevo diagramador de Basic     DiagramaFlujoBSC
   //pone_version('V81718','20160418.13:00');  // * Le agrego diagrama jerarquico de CBL a la documentacion automatica, le agrego instruccion CleanupInstance a ref cruzadas y ambas listas para procurar que el tiempo se reduzca en doc autom   ALK
   //pone_version('V81720','20160420.09:00');  // * Cambios a codigo muerto sugeridos por Roberto
                                             // * Modificacion a documento de Word para documentacion automatica  pendiente    ALK
   //pone_version('V81725','20160425.12:00');  // * Se retiran lineas de ptscomun y ptsconvert  solicitadas por Robert
                                             // * funciones para documento de word con otro formato, etiquetas en documento maestro, aun en construccion.
   //pone_version('V81803','20160503.12:30');  // *  Cambios al procedimiento parametros_extra para probar comlejidad  RGM
                                             // * Mas cambios para codigo muerto, se agrega opcion en menu general y se modifica rutina en ptsmuerto   RGM
   //pone_version('V81805','20160505.12:30');  // * CAmbio para ingresar pantallas nuevas de Robert Generador de documentos    RGM
   //pone_version('V81809','20160509.08:30');  // *  Cambio en funcion para integrar con etiqueta imagenes en los documentos de word en la documentacion dinamica
   //pone_version('V81813','20160513.13:00');  // *  Cambios que solicita Robert para agregar  ptspostrec.pas    RGM
   //pone_version('V81817','20160517.08:30');  // * Cambio en diagrama de bloques para que incluye los FDV en las entradas.  ALK
                                             // * Cambio en ptsrec solicitada por Robert  RGM

   //pone_version('V81818','20160518.14:00');  // * Agrego en menu herramientas/ crear hiperliga para ingresar un docuemtno y que sysmining le agrege las hiperligas   ALK
   //pone_version('V81819','20160519.13:00');  // *  Cambio en la forma de generar la tabla de lista de dependencias en word
   //pone_version('V81823','20160523.14:00');  // * Cambio en forma de tomar el servidor de word, nuev etiqueta SVSOUTPUT y $descripcion$   ALK
   //pone_version('V81827','20160527.12:00');  // * Cambio en la forma de generar documentos, se agrega libreria GENWORD con binario generado a partir de codigo alkdocautodinamica, se cambia el proceso para funcionar con un bat y que reprocese automaticamente.   ALK RGM
   //pone_version('V81830','20160530.12:30');  // *  cmabio para que no valide en los hiperlinks, se agrega la parte de logestadisticas ALK
   //pone_version('V81831','20160531.10:30');  // * Pequeño cambio para que no mande error n la generacion de word independiente por menu herramientas  ALK
   //pone_version('V81901','20160601.14:00');  // * Validacion en la generacion de diagramas de que el proceso de identificacion de cobol funcione  ALK
                                              // * Cambio para que continue el proceso de hiperligas
   //pone_version('V81902','20160602.07:30');  // * Cambios para codigo muerto que solicito Robert   ALK
   //pone_version('V81903','20160603.07:30');  // *  Cambios para identificar tipo de cobol en diagramas, complejidad y alta de atributos    ALK
   //pone_version('V81903','20160603.13:30');  // *  Cambio en la forma en como genera las plantillas para el word. genera todos en el tmp de sysmining, en .doc   ALK
   //pone_version('V81904','20160604.00:30');  // * Cambio en la funcion "cambia_ruta" para que devuelva una sola cadena, se sugiere a Martha cambiar el formato de la plantilla FIL por que los nombres no permiten que trabaje adecuadamente la funcion de ExtractPath    ALK
   //pone_version('V81906','20160606.14:00');  // * Cambio para evitar el error de truene cuando el nombre viene sucio (FIL)  RGM  ALK
   //pone_version('V81907','20160607.10:00');  // * Cambio en la funcion que genera el link, ya tiene la carpeta correcta para traer el documeto   ALK
   //pone_version('V81909','20160609.12:00');  // * Nueva ventana para la generacion de documentos Word, purueba de generacion de productos NEP y NEG desde documentacion automatica   ALK
   //pone_version('V81910','20160610.14:00');  // * Limpio el nombre del link para que no tenga espacios y encuentre el archivo  ALK
   //pone_version('V81913','20160613.11:00');  // *  Cambio para que funcione matriz crud con ins, upd, sel, del  ALK
   //pone_version('V81914','20160614.11:00');  // * Cambio para la matriz de archivos fisicos   RGM
   //pone_version('V81915','20160615.08:00');  // * Cambio de Robert para matriz af y ptspostrec para clase jcl
   //pone_version('V81917','20160617.11:30');  // * Cambio de forma de configurar la generacion de word, a traves de una ventana y con combos  ALK
   //pone_version('V81919','20160619.13:30');  // *  Cambio en forma de llenar combo clases en docword y alto para que no procese un documento con errores    ALK
   //pone_version('V81920','20160620.13:00');  // * Cambio en la lista para la generacion del log de estadisticas y cambio en las propiedades del form docword para que salga del tamaño y posicion adecuados  ALK
   //pone_version('V81921','20160621.13:30');  // * Se quita el comentario para que borre los documentos de tmp, alto correcto cuando hay errores.
   //pone_version('V81922','20160622.13:40');  // * Modificacion de la forma en como se obtienen los documentos desde la generacion de documentos, se agrega consulta para biblioteca y se coloca NEG    ALK
   //pone_version('V81923','20160623.13:40');  // * Ciclo para generar tabla ALK
   //pone_version('V81927','20160627.14:10');  // * Generacion de diagramas OSQ   ALK
   //pone_version('V81929','20160629.13:00');  // *  Listo borrado de archivos temporales para diagramadores, falta borrado de archivos temporales para los split     ALK
   //pone_version('V82004','20160704.09:00');  // * Cambios de Robert en utilerias y en ptsrecibe   ALK
   //pone_version('V82012','20160712.13:30');  // *  Consideraciones para que no aparezcan mensajes en la documentacion automatica que la detengan,
   //pone_version('V82014','20160714.14:30');  // * Correccion de ptsrecibe peticion de Robert.
   //pone_version('V82018','20160718.09:10');  // * Mensaje de error cuando no existe fuente para complejidad   ALK
   //pone_version('V82020','20160720.08:30');  // * Correccion en lista de dependencias para la leyenda "CICLADO". Se mueve de lugar para que mande correctamente la leyenda.  ALK
   //pone_version('V82021','20160721.21:30');   // * Cambio en refcruzadas, para quitar del nombre del componentes las comas, de esta manera se evita nuevamente el error de traslado de titulos  ALK
                                              // * cambio en detalle de tabla, cconsultas RGM y condiciones ALK
   //pone_version('V82025','20160725.10:30');   // * Cambio en detalle de tabla, se agregan condiciones faltantes para cuando no existe NULL   ALK
   //pone_version('V82026','20160726.09:00');   // * Se quita proceso de jerarquia de clases despues de la carga a peticion de Martha   ALK
   //pone_version('V82027','20160727.13:00');   // * Agrego que mande a log de error cuando un componente es scratch o no tenga hijos para que no parezca que no lo ejecuto en documentacion automatica.   ALK
   //pone_version('V82027','20160727.13:00');   // * Quito mensajes de aviso cuando no hay informacion en el detalle de tablas     ALK
   //pone_version('V82109','20160809.10:00');   // * Se modifica la forma de mandar los parametros al ejecutable para la generacion del documento word  ALK
   //pone_version('V82111','20160811.09:30');   //* Se cambia la forma de generar la lista de dependencias, se manda a un archivo para evitar el out of memory   ALK
                                               // * Cambio en el proceso del documento de word, el funciona se debia inicializar en true      ALK
   //pone_version('V82112','20160812.12:30');   //* Cambio en los permisos de acuerdo al rol del usuario registrado     ALK
   //pone_version('V82115','20160815.14:00');   //* Cambio en la forma de generar el nombre del documento, ahora limpia la biblioteca, para estandarizar nombres   ALK
   //pone_version('V82116','20160816.13:30');   //* Cambio para Analisis de impacto funcion TaladrarAImpacto     alk
   //pone_version('V82118','20160818.13:30');   //*  Cambio para [user/base]def    de Robert     ALK
                                              // *  Implementacion de nueva carpeta (log) para los log y limpieza de la carpeta tmp     ALK
   //pone_version('V82126','20160826.20:00');   // * Nuevo producto en documentacion automatica  "Codigo muerto"
                                              // * Validacin y creacion de directorios oracle para evitar errores al traer fuente, al instalar nueva base de datos   ALK
   //pone_version('V82130','20160830.23:00');   // * Cambio en el limite de bloques que acepta el analisis de impacto, ahora es por parametro LIMBLOQ      ALK
   // pendiente probar la nueva lista de dependencias en docu autom
   //pone_version('RGM','V82214','20160914.11:00');   // * alkDocAutoDinamica.pas se quitó el componente Wordxp para que use Word2000, no presentaba <SVSIMAGE>
   //pone_version('RGM','V82215','20160922.00:00');   // * Recepción de componentes no se ocultaba para el rol CONSULTA. Se condicionaron en el menú izquierdo y en el icono de arriba. ptsmain.pas
   //pone_version('RGM','V82216','20160926.10:30');   // * PostProceso DCL. Se solicita parámetro SISTEMA para limitar los recálculos. ptsmain.pas, ptspostrec.pas
   //pone_version('RGM','V82217','20160927.14:00');   // * Generar Documentación. Se corrigió el sistema. No se incluyó en el query. alkdocword.pas
   //pone_version('RGM','V82218','20160927.15:00');   // * Validaciones Estáticas. cuando tiene ERROR en el texto no arma la tabla. se cambió por ERROR... ptestatica.pas
   //pone_version('RGM','V82219','20160930.13:10');   // * Detalle de tablas. querys que se deshabilitaron para Tablespace estaba incompleto alkDetTab.pas
                                                    // * Dependencias de componentes. Le daba free a una variable en FORMDESTROY. Lo moví a FORMCLOSE UfmListaDependencias.pas
   //pone_version('RGM','V82220','20161001.23:00');   // * Búsqueda. Fallaba cuando buscaba por todas las bibliotecas. ufmBuscaCompo.pas
                                                    // * Análisis de Impacto. Cuando buscaba una tabla no incluía los INS,DEL,UPD. uDiagramaRutinas.pas
   //pone_version('RGM','V82221','20161003.13:00');   // * Validación Estática. Se le deja el nombre del programa al archivo en tmp para validación de program-id. ptestatica.pas
   //pone_version('RGM','V82222','20161004.01:00');   // * * Detalle de Tablas. Truena cuando no tiene información para mostrar. Corregido. alkDetTab.pas
   //pone_version('RGM','V82223','20161004.10:25');   // * Reporteador. Estaba deshabilitado. Se habilita. ptsmain.pas
   //pone_version('RGM','V82224','20161011.14:00');   // * Código Muerto. Se corrigieron directivas y el reporte resumen de la ventana derecha. ptsmuerto.pas, cbl_muerto.dir
                                                    // * RGMLANG. Se corrigió en las lineas de continuación que tenían un string sin cerrar. rgmlang.exe
   //pone_version('RGM','V82225','20161025.10:00');   // * Validación estática. Catálogo de reglas, adecuación del reporte final, archivo de reglas activas. ptsestatica.pas
   //pone_version('RGM','V82226','20161108.19:00');   // * Diagrama Scheduler. Tronaba al traer el fuente del CTM (parámetro 6 que no existe). ptsgral.pas L5661
   //pone_version('RGM','V82227','20161110.13:00');   // * Diagrama Scheduler. Faltaba llamar al ocprog del CTM para que ejecutara alkscheduler. ptsgral.pas
   //pone_version('RGM','V82228','20161122.14:40');   // * Validación estática. Chequeo de parámetros adicionales COBOL. ptsestatica.pas
   //pone_version('RGM','V82229','20170110.12:30');   // * Validación estática. Se agregó parámetro a GET_UTILERIA para que aplique GUTIL a directivas. ptsestatica.pas
   //pone_version('RGM','V82230','20170113.13:30');   // * Arbol. Cuando la clase está cargada pero con estadoactual=INACTIVA no encuentra descripcion. Se filtró para que en recepción valida clases activas. parbol.pas,ptsrecibe.pas
   //pone_version('RGM','V82231','20170213.11:46');   // * LOGIN. Cuando sea SOMS12 (Liverpool) no creará las tablas de propagación de variables. ptsmain.pas
   //pone_version('RGM','V82232','20170217.15:00');   // * ARBOL. Se ciclaba cuando linea final =999999. parbol.pas
   //pone_version('RGM','V82233','20170306.18:00');   // * ARBOL. Agregada función $REPLACE("$HCPROG$","banamex","DEMO") al parámetro ARBOLDESCRIPCION. parbol.pas
   //pone_version('RGM','V82234','20170306.19:30');   // * Analisis de Impacto. Se pone el circulo rojo con total de registros que rebasaron límite definido por parámetro LIMBLOQ (default 150). uDiagramaRutinas.pas
   //pone_version('RGM','V82235','20170315.20:30');   // * Validaciones estaticas. Filtro para que sólo valide reglas activas. ptsestatica.pas
   //pone_version('RGM','V82236','20170404.12:45');   // * Busqueda. Se adecuó para Java(minúsculas, comandos). ptsbusca.pas,tsindex3.c,tsscan.c
   //pone_version('RGM','V82237','20170424.23:45');   // * Recepción de componentes. Se simplificó la rutina de conciliación para componentes clase XXX y/o SCRATCH en biblioteca. Pendiente parámetro para clases y bibliotecas alternas ptsrec.pas
   //pone_version('RGM','V82238','20170504.23:38');   // * Análisis de Impacto. Cuando el diagrama utiliza más de 2000 registros da opción para exportar a texto separado por comas. ufmAnalisisImpacto.pas
   //pone_version('RGM','V82239','20170507.09:36');   // * Liverpool SOMS. Cambios varios
   //pone_version('RGM','V82240','20170507.15:00');   // * Liverpool SOMS. Cambiar el EXIT por ABOR en opción Diagrama de Componentes,Quitar Diagrama de Componente y referencias cruzadas en CTR
   //pone_version('RGM','V82241','20170507.16:20');   // * Liverpool SOMS. avisa que el diagrama es muy grande y se sale
   //pone_version('RGM','V82242','20170508.03:25');   // * Liverpool SOMS. avisa que el diagrama es muy grande para exportar a PDF y genera CSV. quita diagrama de componentes para CTM ufmprocesos.pas, ufmanalisisimpacto.pas
   //pone_version('RGM','V82243','20170517.03:25');   // * Liverpool SOMS. Se agrega parámetro para tipo de lineas, se deja como default 1 ufmscheduler.pas
   //pone_version('RGM','V82244','20170524.01:27');   // * Liverpool SOMS. Se corrige parámetro mal definido y se agrega chdir a tmp antes de generar scheduler ufmscheduler.pas
   //pone_version('RGM','V82245','20170803.01:29');   // * ENAMI. Se elimina un filtro al momento de expandir un nodo, sólo expandía las clases que estuvieran activas y ANALIZABLES farbol.pas
   //pone_version('RGM','V82246','20170807.18:00');   // * ENAMI. Se corrige un query para empatar clases XXX ptsrec.pas
   //pone_version('AOM','V82247','20180131.19:30');   // *Agrego condicion de apuntador de screen.ActiveForm en procedimiento MouseProc para evitar el truene por perder el apuntador. ALK
   //pone_version('AOM','V82248','20180207.15:00');   // * se modifica en ptsrec, la ruta reemplaza_alternos, en las consultas se agrega el campo polimorfismo para que la sub-rutina mismo_hcbib no tenga problema al buscar en el campo polimorfismo     ALK
                                                    // * Agrego condicional en ptsconver rutina cmbbibChange   RGM
   //pone_version('AOM','V82249','20180213.13:40');   // * Se modifican los parametros para ejecutar los archivos de Natan en diagrama Scheduler   ALK
   //pone_version('AOM','V82250','20180223.11:00');   // * Se agrega la opcion de validaciones estaticas para los menus emergentes del arbol y los productos, asi como las funciones apropieadas en ptsestatica   ALK
                                                    // * Se modifica lista de componentes y lista de dependencias para validar la consulta: "select * from tsproductos  where  ccapacidad = g_producto and cuser = g_user" para que no se quede ciclado en
                                                    //   rutina pubLlenaArregloClases en ufmlistacompo y en el create de ufmlistadependencias   ALK
   //pone_version('AOM','V82251','20180305.17:30');   // * Validación de combos para inabilidar combos cuando se realice un cambio de parametros en lista de componentes, lista de dependencias y busqueda de componentes   ALK
                                                    // * nueva funcion "sin_controles" en lista de componentes y lista de dependencias para ocultar los controles y la lista izquierda al ser llamado desde arbol o productos, cuando se llama de menu de mineria queda intacto    ALK
   //pone_version('AOM','V82252','20180322.10:30');   // * Correccion en diagrama de Componentes para asemejarlo a lista de dependencia de componentes (cambio de consulta, filtro nuevo)   ALK
   //pone_version('AOM','V82253','20180404.14:30');   // * Cambios en Matriz CRUD para permitir elegir todos los registros con '*' y se añade mensaje de advertencia en Matriz CRUD y Matriz de Arch Fis cuando se hace una busqueda completa  ALK
   //pone_version('AOM','V82253','20180405.16:00');   // * Corrijo un TStringList no referenciado cuando se manda llamar analisis de impacto desde productos ¡¡¡CHECAR!!! antes de regresar el archivo_selects    ALK
   //pone_version('AOM','V82253','20180411.16:30');   // * Corrijo un TStringList no referenciado cuando se manda llamar analisis de impacto desde productos ¡¡¡CHECAR!!! antes de regresar el archivo_selects    ALK
   //pone_version('AOM','V82254','20180418.14:10');   // * Busqueda de componentes se agrega funcion para que funcione la busqueda, aun esta pendiente !!!  ALK
   //pone_version('AOM','V82254','20180419.17:10');   // * Busqueda de componentes: ya funciona el boton buscar y ya muestra el resultado de la busqueda en Web2 y a su vez, agrego codigo para que muestre el primer resultado de Web2 en edit del componente que esta seleccionado    ALK
                                                    // * Funcionalidades de los botones de Matriz de AF corregidos, enabled true/false correctamente   ALK

   //pone_version('AOM','V82255','20180427.14:30');   // * Corregido pendientes de inventario de componentes 1. Ampliar anchura de tabla superior 2. Modificado el titulo que aparece sobre tabla inferior 3. Modificar titulos de columnas de tabla inferior (de mayusculas a tipo oracion)
                                                    // * 4. Mostrar de manera predeterminada el primer resultado de la tabla superior en la tabla inferior, para cada una de las opciones (existentes, faltantes, sin uso ...) 5. Se cambia icono de busqueda en ufmSVSLista     ALK
                                                    // * AUN ESTA PENDIENTE FUNCIONALIDAD DE BOTON DE BUSQUEDA EN INVENTARIO, SE ESTA PASANDO DE FUNCIONES GENERALES A FUNCIONES PARTICULARES
   //pone_version('AOM','V82255','20180502.11:30');   // * Inventario de componentes: cambio en el formato de la cabecera de la tabla inferior (color y tamaño de letra)    ALK
   //pone_version('AOM','V82256','20180515.17:00');   //  * Se estandariza la pantalla de consulta de componentes. Se estandariza activacion/desactivacion de boton cancelar para ambas listas, matrices crud y AF y consulta de componentes.    ALK
   //pone_version('AOM','V82257','20180614.11:00');   // * Busqueda en pantalla inventario de componentes  ALK
   //pone_version('AOM','V82257','20180619.12:40');   // * Busqueda en pantalla de búsqueda de componentes ALK
   //pone_version('AOM','V82257','20180629.12:40');   // *  Correccion en pantalla de parámetros, se colocan asteriscos en los campos obligatorios RGM ALK; se quita la parte obligatorio de la mascara en consulta de componentes ALK
   //pone_version('AOM','V82257','20180710.15:45');   // * Cambio en el Form del Browse para catálogos (pbrowse -> alkBrowse), nuevo form con componente grid. Actualización de diccionario de datos en uConstantes para etiquetas en los titulos del Browse ALK
   //pone_version('AOM','V82257','20180717.15:00');   // *  Cambio al llenar el combo de capacidades en catalogo de capacidades, ahora se llena de acuerdo al usuario que se loguea
   //pone_version('AOM','V82257','20180725.11:00');   // *  Se corrige el error de que aparezca un signo de mas en los nodos finales en el arbol, nueva funcion     ALK
   //pone_version('AOM','V82257','20180731.16:30');   // * Se agregan "hijos" al nodo que se agrega en Mis proyectos.
   //pone_version('AOM','V82258','20180806.10:00');   // * Estandarizacion de mini logos negros, logo de SVS de panel fantasma centrado, estandarizacion de vista de pantallas emergentes (falta el color del marco de la ventana)   ALK
   //pone_version('AOM','V82258','20180806.17:00');   // * cambio de iconos grandes generales, detalles de ventanas emergentes.   ALK
   //pone_version('AOM','V82258','20180808.10:00');   // * se introduce variable cierra_ventana para evitar errores
   //pone_version('AOM','V82258','20180809.02:00');   // * Se corrigen detalles de funcionalidad y estetica para presentacion de Peru. Falta modificar el scroll vertical para las ventanas de Robert y agregarlas a la lista de ventanas activas para que no se dupliquen   ALK
   //pone_version('AOM','V82258','20180810.02:10');   // * Se corrigen detalles aun de las ventanas de Robert con respecto a que aparezcan en la lista de ventanas y algunos detalles de estetica ALK
   //pone_version('AOM','V82259','20180816.09:40');   // * Detalles respecto a funcionalidad, se colocan lineas para limpiar paneles, splitter para recorrer y ver completos los componentes, estandarizacion de botones y cambio en la funcion de cerrar todas las ventanas.   ALK
   //pone_version('AOM','V82259','20180816.17:00');   // * Coloco barra de proceso y cursor a crNo que no permite navegar fuera de las ventanas de Robert que ahora se presentan como hijas hasta que terminen de procesar lo que se les pidio   ALK
   //pone_version('AOM','V82259','20180823.15:00');   // * Splitter y nuevos groupbox para recepcion de componentes en grids de versiones y compoententes    ALK
   //pone_version('AOM','V82259','20180824.17:00');   // * Group box para 4 de las 5 ventanas que ahora son hijas y cambio de caption en los botones para un mejor entendimiento     ALK
   //pone_version('AOM','V82259','20180828.13:00');   // * Se comentan lineas para registro de consultas que se hacen archivo_selects en lista de dependencias y lista de componentes (lista rutinas)    ALK
   //pone_version('AOM','V82259','20180831.10:00');   // * Se coloca como hija la ventana (fptpar) Parametros en VD-VR  y se colocan splitters y ScrollBars.     * Se quita la opcion "Ver Fuente" del menu emergente en clase FIL     ALK
   //pone_version('AOM','V82259','20180903.15:00');   // * Corregido el detalle de que no encuentra alguna clase cuando quiere mostrar el fuente en el arbol, ahora avisa con un mensaje    ALK
   //pone_version('AOM','V82259','20180906.16:00');   // * Se agrega limpieza de lista repetidos en lista de dependencias   ALK
   //pone_version('AOM','V82259','20180907.16:50');   // * Error Access Violation salia cuando se ejecutaba consulta de componentes y luego se colocaba un sistema, ese error botaba por que se pretendia guardar una variable en parbol siendo que la forma no se habia creado, se soluciona colocando la variable global en ptsdm - indicio de error Access Violation     ALK
   //pone_version('AOM','V82259','20180911.18:30');   // * Detalle en el panel de carga de proyecto en consulta de coponentes, no debe de aparecer cuando no se abre del arbol    ALK
   //pone_version('AOM','V82259','20180912.17:00');   // * Se corrige detalle de listas particulares a generales en versionado, al separar en funciones valida y arma, quedaron unas listas de forma particular, que no estaban inicializadas   ALK
                                                    // * Pantalla PR_GENERA se convierte a hija tambien y se modifica su distribucion para hacerla mas parecida a las demas pantallas   ALK
                                                    // * Cambio de iconos en pantallas de diagramas analisis impacto, bloques, flujo interactivo, diagrama de procesos ALK


   pone_version('AOM','V82259','20180914.16:00');   // * Se soluciona el detalle con codigo muerto de que mostraba como diferencias los saltos de linea entrre el codigo orignal  eo procesado por Robert     ALK

end;

end.



