unit ufmDigraSistema;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSDiagrama, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBar, dxBarExtItems, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
   DgrCombo, StdCtrls, DgrSelectors, atDiagram, ComCtrls, uConstantes, ImgList, IniFiles,
   FlowchartBlocks,ADODB,StrUtils,
   alkNuevoDiag, DiagramExtra;     //alk form para configurar diagrama nuevo de sistema

const
   sBLOCK_CONST = '_DSIS';

type
   TguardaPadres = record     //para guardar los nodos mas altos de la primera consultaDS
      id : integer;
      hprog : string;
      hbib: string;
      hclase: string;
      x : integer;
      y : integer;
   end;

type
   TguardaHijos = record   // para guardar los que seran los nodos del arbol
      id : integer;
      id_p : integer;
      pcprog : string;
      pcbib : string;
      pcclase : string;
      hcprog : string;
      hcbib : string;
      hcclase : string;
      modo : string;
      x : integer;
      y : integer;
   end;

type                   //para tener el numero de clases por nivel que se tiene en el diagrama de sistema
   guardaClases = record
      nivel : integer;
      clase : string;
      numero : integer;     //numero de apariciones por nivel por clase
end;

type              //estructura para que funcione la funcion de la lista de dependencias
   Txx = record
      nivel: integer;
      claseo: string;
      bibo: string;
      nombreo: string;
      clasep: string;
      bibp: string;
      nombrep: string;
      clase: string;
      bib: string;
      nombre: string;
      modo: string;
      organizacion: string;
      externo: string;
      coment: string;
      existe: boolean;
      uso: integer;
      sistema: string;
   end;

type
   TfmDigraSistema = class( TfmSVSDiagrama )
      mnuAbrir: TdxBarButton;
      mnuGenerar: TdxBarButton;
      mnuCargarConfiguracion: TdxBarButton;
    ConfigDiag: TdxBarButton;
    dxBarCombo1: TdxBarCombo;
    dxBarButton1: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    TDArc: TdxBarEdit;
    TDBezier: TdxBarButton;
    mnuTDArc: TdxBarButton;
    mnuTDBezler: TdxBarButton;
    mnuTDLine: TdxBarButton;
    mnuTDPolyLine: TdxBarButton;
    mnuTDSideLine: TdxBarButton;
    dxBarStatic2: TdxBarStatic;
      procedure mnuAbrirClick( Sender: TObject );
      procedure mnuCargarConfiguracionClick( sParProg: String);
      procedure FormCreate( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
      procedure mnuGenerarClick(sParProg: String );
      procedure mnuGenerarClick_ALK(sParProg: String );   //funcion ALK
      procedure atDiagramaDControlDblClick( Sender: TObject;
         ADControl: TDiagramControl );
    procedure ConfigDiagClick(Sender: TObject);
    procedure mnuTDArcClick(Sender: TObject);
    procedure mnuTDBezlerClick(Sender: TObject);
    procedure mnuTDLineClick(Sender: TObject);
    procedure mnuTDPolyLineClick(Sender: TObject);
    procedure mnuTDSideLineClick(Sender: TObject);
   private
      { Private declarations }
      sPriClase, sPriBib, sPriProg, sPriTitulo: String;       //generales
      sPriSistema: String;

      Opciones: Tstringlist;

      slPriArchivoIni: TStringList; //almacena el contenido total del archivo ini
      sPriArchivoIni: String; //ruta y nombre del archivo de configuracion (*.ini)
      bPriClasesScratchProcesar: Boolean; //obtener del archivo de configuracion
      sPriCadenaScratch: String;
      es_cla:array of guardaClases;      //ALK para almacenar las clases en drilldown
      nivel:integer;   //alk para clases
      clases,procesadas: TstringList;   //alk
      es_nuevo : integer; // para indicar cuando vine de origen

      // ------ para la funcion de la lista de dependencias -------      ALK
      x: array of Txx;
      xx,loc1, loc2,excluyemenu: Tstringlist;
      v_compo,v_bib,v_clase,v_sistema,Wciclado: string;
      aPriClases: array of string;

      function agrega_compo( qq: Tadoquery ; g_nivel:integer ): boolean;
      procedure leecompos( compo: string; bib: string; clase: string; sistema: string; g_nivel: integer );
      //--------------------------------------------------------------

      procedure GlbArmaDgrSistema( atParDiagrama: TatDiagram;
         sParClase, sParBib, sParProg: String; sParSubtitulo: String );
      function bPriProcesarScratch( sParArchivo: String ): Boolean;
      function bPriTerminaProceso: Boolean;
      procedure PriObtenerClases( sParArchivo: String );
      procedure PriObtenerContenidoArchIni( sParArchivo: String; slParContenido: TStringList );

      procedure LogicaArmadoDgrSistema( atParDiagrama: TatDiagram;
         sParClase, sParBib, sParProg: String );

      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure prepara_colores();   //ALK
      procedure une_hijos(sistema, programa, biblioteca, clase : String; origen : integer);   //ALK
      procedure hace_links(tipo_linea : integer);    //ALK
      function define_linea(h_clase,h_modo,p_clase:String;origen,destino,tipo:String):integer;  //alk
      procedure leeclases( clase,sistema:  string);    //ALK
   public
      { Public declarations }
      slPriClases: TStringList; //obtener del archivo de configuracion

      function GuardaDiagrama( ruta : string ; tipo : integer): string;    //para mandar guardar desde ufmdocsistema
      procedure configuraIni_DocSistema(sNombreArchivoDS : string);      //   ALK para configurar ini desde documentacion
      procedure PubGeneraDiagrama( sParClase, sParBib, sParProg: String;
         sParCaption: String );
      //function multipadres(clase,sistema:string):TStringList;  //ALK para que alkNuevoDiagrama reciba la lista de clases

      procedure jerarquia_clases( sistema: string );   //Para ejecutar la funcion de lisdep desde ptsmain    ALK
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas;//, ADODB;

{$R *.dfm}

procedure TfmDigraSistema.PubGeneraDiagrama( sParClase, sParBib, sParProg: String;
   sParCaption: String );
var
   i: Integer;
begin
   if not ( sParClase = 'SISTEMA' ) then begin
      Application.MessageBox( 'No se puede generar el Diagrama' + Chr( 13 ) +
         'para este tipo de nodo', 'Aviso', MB_OK );
      Exit;
   end;

   sPriClase := sParClase;
   sPriBib := sParBib;
   sPriProg := sParProg;
   sPriTitulo := sParCaption;
   sPriSistema := sPriProg;

   Caption := sParCaption;

   GlbNuevoDiagrama( atDiagrama );
   mnuCargarConfiguracionClick(sParProg);    //ya no se va a cargar una configuracion con un ini
   mnuGenerarClick(sParProg);     //funcion de fer

   // -----   ALK  ----------------
   {iGlbRenglon := 50;
   iGlbColumna := 20;
   iGlbEspacioEntreColumnas := 20;
   iGlbEspacioEntreRenglones := 20;
   iGlbAncho:=90;
   iGlbAlto:=50;
   prepara_colores;  //para llenar el arreglo con los colores por clase segun tabla parametro

   mnuGenerarClick_ALK(sParProg);}  //funcion ALK
   // ------------------------------
end;

procedure RegistraBlockDgrSistema(
   sParClase, sParBib, sParProg: String;
   iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
   sParNFisicoBlock, sParNLogicoBlock: String;
   sParTipoBlock: String;
   sParLigaBlockOrigen, sParLigaBlockDestino: String;
   tParColor: TColor;
   sParTexto: String );
var
   iLongitudArreglo: Integer;
begin
   // Registrar en arreglo aGlbBlockAtributos
   iLongitudArreglo := Length( aGlbBlockAtributos );
   SetLength( aGlbBlockAtributos, iLongitudArreglo + 1 );

   aGlbBlockAtributos[ iLongitudArreglo ].Clase := sParClase;
   aGlbBlockAtributos[ iLongitudArreglo ].Biblioteca := sParBib;
   aGlbBlockAtributos[ iLongitudArreglo ].Programa := sParProg;
   aGlbBlockAtributos[ iLongitudArreglo ].Renglon := iParRenglon;
   aGlbBlockAtributos[ iLongitudArreglo ].Columna := iParColumna;
   aGlbBlockAtributos[ iLongitudArreglo ].Alto := iParAlto;
   aGlbBlockAtributos[ iLongitudArreglo ].Ancho := iParAncho;
   aGlbBlockAtributos[ iLongitudArreglo ].NFisicoBlock := sParNFisicoBlock;
   aGlbBlockAtributos[ iLongitudArreglo ].NLogicoBlock := sParNLogicoBlock;
   aGlbBlockAtributos[ iLongitudArreglo ].LigaBlockOrigen := sParLigaBlockOrigen;
   aGlbBlockAtributos[ iLongitudArreglo ].LigaBlockDestino := sParLigaBlockDestino;
   aGlbBlockAtributos[ iLongitudArreglo ].TipoBlock := sParTipoBlock;
   aGlbBlockAtributos[ iLongitudArreglo ].Color := tParColor;
   aGlbBlockAtributos[ iLongitudArreglo ].Texto := sParTexto;
end;

// -----------------------  ALK  -----------------------------
procedure TfmDigraSistema.une_hijos(sistema, programa, biblioteca, clase : String; origen : integer);
var
   consulta_h:string;
begin
   //ZeroMemory(@aGLBTsrela, SizeOf(aGLBTsrela));  //limpiar el arreglo

   consulta_h:='select * from tsrela' +
               ' where pcclase=' + g_q + clase + g_q +
               ' and pcbib=' + g_q + biblioteca + g_q +
               ' and pcprog=' + g_q +programa + g_q+
               ' and sistema=' + g_q +sistema + g_q;

   if dm.sqlselect(dm.q1,consulta_h) then begin
      while not dm.q1.Eof do begin
         if origen = 0 then      //si es la consulta normal, la directa
            GlbRegistraArregloTsrela(dm.q1.FieldByName( 'pcprog' ).AsString,
                                     dm.q1.FieldByName( 'pcbib' ).AsString,
                                     dm.q1.FieldByName( 'pcclase' ).AsString,
                                     dm.q1.FieldByName( 'hcprog' ).AsString,
                                     dm.q1.FieldByName( 'hcbib' ).AsString,
                                     dm.q1.FieldByName( 'hcclase' ).AsString,
                                     dm.q1.FieldByName( 'modo' ).AsString)
         else       //si hay que encontrar a los hijos indirectos
            GlbRegistraArregloTsrela(programa, biblioteca, clase,
                                     dm.q1.FieldByName( 'hcprog' ).AsString,
                                     dm.q1.FieldByName( 'hcbib' ).AsString,
                                     dm.q1.FieldByName( 'hcclase' ).AsString,
                                     dm.q1.FieldByName( 'modo' ).AsString);
         dm.q1.Next;
      end;
   end;
end;
//----------------------------------------------------

procedure TfmDigraSistema.LogicaArmadoDgrSistema( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String );
var
   sNombreBlockOrigen, sNombreBlockDestino: String;  //fisico
   sNombreLogBlockOrigen, sNombreLogBlockDestino: String;  //logico
   sBlockOrigen, sBlockDestino: String;
   i, j,indica, indica_f,sal,h: Integer;
   sClase, sBib, sProg: String;
   a_prog, a_bib, a_cla : String;   //alk
   sTexto: String;
   wColor: TColor;
   consulta:String;
   padres: array of TguardaPadres;

   function bExisteClase( sParClaseBuscar: String ): Boolean;
   begin
      Result := dm.sqlselect( dm.q1,
         'SELECT CCLASE FROM TSCLASE WHERE CCLASE = ' + g_q + sParClaseBuscar + g_q );
   end;

   procedure RegistrarBlocks_X_Clase(
      sParSistema, sParClaseBlock: String; iParColumna, iParRenglon: Integer );
   var
      qTSRELA: TAdoQuery;
   begin
      qTSRELA := TAdoQuery.Create( nil );
      try
         qTSRELA.Connection := dm.ADOConnection1;

         consulta:= 'SELECT HCCLASE, HCBIB, HCPROG' +
            ' FROM TSRELA' +
            ' WHERE' +
            '    SISTEMA = ' + g_q + sParSistema + g_q +
            '    AND HCCLASE = ' + g_q + sParClaseBlock + g_q +
            sPriCadenaScratch +
            ' GROUP BY HCCLASE, HCBIB, HCPROG' +
            ' ORDER BY HCBIB, HCPROG';

         {consulta:= 'select pcprog,pcbib,pcclase,hcbib,hcprog,hcclase from tsrela ' +
            ' where pcclase=' + g_q + sParClaseBlock + g_q;   }

         if dm.sqlselect( qTSRELA, consulta ) then begin
            iGlbRenglon := iParRenglon;
            iGlbColumna := iParColumna;

            while not qTSRELA.Eof do begin
               sClase := qTSRELA.FieldByName( 'HCCLASE' ).AsString;
               sBib := qTSRELA.FieldByName( 'HCBIB' ).AsString;
               sProg := qTSRELA.FieldByName( 'HCPROG' ).AsString;
               sTexto := sClase + ' ' + sBib + ' ' + sProg;
               wColor := dgr_ccolor( sClase );

               inc( iGlbNombreBlock );     //aumentar 1
               sNombreBlockOrigen := '_' + IntToStr( iGlbNombreBlock ) + sBLOCK_CONST;

               RegistraBlockDgrSistema(
                  sClase, sBib, sProg,
                  iGlbColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
                  sNombreBlockOrigen, sClase + '|' + sBib + '|' + sProg,
                  'FlowActionBlock',
                  '', '', wColor, sTexto );

               iGlbColumna := iGlbColumna + iGlbAncho + iGlbEspacioEntreColumnas;

               qTSRELA.Next;
            end;
         end;
      finally
         qTSRELA.Free;
      end;
   end;

begin
   SetLength( dgrcol, 0 );
   if dm.sqlselect(
      dm.q2, 'SELECT * FROM PARAMETRO WHERE CLAVE LIKE ' + g_q + 'WCOLOR_%' + g_q ) then
      while not dm.q2.Eof do begin
         dgr_clasecolor(
            Copy( dm.q2.fieldbyname( 'CLAVE' ).AsString, 8, 3 ),
            dm.q2.FieldByName( 'DATO' ).AsString );
         dm.q2.Next;
      end;

   sTexto := sParProg + ' ' + sParBib + ' ' + sParClase;

   inc( iGlbNombreBlock );
   sNombreBlockOrigen := '_' + IntToStr( iGlbNombreBlock ) + sBLOCK_CONST;

   RegistraBlockDgrSistema(
      sParClase, sParBib, sParProg,
      iGlbColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
      sNombreBlockOrigen, sParClase + '|' + sParBib + '|' + sParProg,
      'FlowTerminalBlock',
      '', '', $00CCFFFF, sTexto );

   for i := 0 to slPriClases.count - 1 do
      if bExisteClase( slPriClases[ i ] ) then begin
         iGlbRenglon := iGlbRenglon + iGlbAlto + ( iGlbEspacioEntreRenglones * 4 );
         iGlbColumna := 20;
         RegistrarBlocks_X_Clase( sParProg, slPriClases[ i ], iGlbColumna, iGlbRenglon );
      end;

   //crea los block's
   for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      GlbBlockFlow( atParDiagrama,
         aGlbBlockAtributos[ i ].TipoBlock,
         aGlbBlockAtributos[ i ].NFisicoBlock,
         aGlbBlockAtributos[ i ].Columna,
         aGlbBlockAtributos[ i ].Renglon,
         aGlbBlockAtributos[ i ].Ancho,
         aGlbBlockAtributos[ i ].Alto,
         aGlbBlockAtributos[ i ].Color,
         clBlack,
         aGlbBlockAtributos[ i ].Texto );
   end;

   hace_links(0);
   {Tipos de linea:
      * Arc 0 -default
      * Bezler 1
      * Line 2
      * PolyLine  3
      * SideLine  4 }

end;
// para hacer funcionar los tipos de linea
procedure TfmDigraSistema.hace_links(tipo_linea : integer);    //ALK
var
   sNombreBlockOrigen, sNombreBlockDestino: String;  //fisico
   sNombreLogBlockOrigen, sNombreLogBlockDestino: String;  //logico
   sBlockOrigen, sBlockDestino: String;
   i, j,indica, indica_f,sal,h: Integer;
   sClase, sBib, sProg: String;
   a_prog, a_bib, a_cla : String;   //alk
   sTexto: String;
   wColor: TColor;
   consulta, stipo_linea:String;
   padres: array of TguardaPadres;


   function sBuscarBlock( sParClaseDes, sParBibDes, sParProgDes: String ): String;
   var
      i: Integer;
   begin
      Result := '';

      for i := 0 to Length( aGlbBlockAtributos ) - 1 do
         if ( aGlbBlockAtributos[ i ].Clase = sParClaseDes ) and
            ( aGlbBlockAtributos[ i ].Biblioteca = sParBibDes ) and
            ( aGlbBlockAtributos[ i ].Programa = sParProgDes ) then begin
            Result := aGlbBlockAtributos[ i ].NFisicoBlock;
            Break;
         end;
   end;

   //alk para mandar nombre fisico y logico del bloque
   procedure sBuscarBlock_2( sParClaseDes, sParBibDes, sParProgDes: String;
                            var fisico, logico : String );
   var
      i: Integer;
   begin

      for i := 0 to Length( aGlbBlockAtributos ) - 1 do
         if ( aGlbBlockAtributos[ i ].Clase = sParClaseDes ) and
            ( aGlbBlockAtributos[ i ].Biblioteca = sParBibDes ) and
            ( aGlbBlockAtributos[ i ].Programa = sParProgDes ) then begin
            fisico := aGlbBlockAtributos[ i ].NFisicoBlock;
            logico := aGlbBlockAtributos[ i ].NLogicoBlock;
            Break;
         end;
   end;

   function bClaseProcesar( sParClaseProcesar: String ): Boolean;
   var
      i: Integer;
   begin
      Result := False;

      for i := 0 to slPriClases.Count - 1 do
         if slPriClases[ i ] = sParClaseProcesar then begin
            Result := True;
            Break;
         end;
   end;

begin
   stipo_linea:='';
   ZeroMemory(@aGLBTsrela, SizeOf(aGLBTsrela));  //limpiar el arreglo
   
   //establecer tipo de linea de acuerdo a indice
   case tipo_linea of
      1 : stipo_linea:= 'TDiagramBezier';
      2 : stipo_linea:= 'TDiagramLine';
      3 : stipo_linea:= 'TDiagramPolyLine';
      4 : stipo_linea:= 'TDiagramSideLine';
      else stipo_linea:= 'TDiagramArc';
   end;

   //hace los links de hijos directos pero con direccion las flechas
   for i := 0 to Length( aGlbBlockAtributos ) - 1 do begin
      if bPriTerminaProceso then begin
         Application.MessageBox( 'Proceso terminado a petición del usuario',
            'Aviso', MB_OK );
         Exit;
      end;

      with aGlbBlockAtributos[ i ] do
         if bClaseProcesar( Clase ) then begin
            indica:=0;      //marcar que no unio bloques
            ZeroMemory(@aGLBTsrela, SizeOf(aGLBTsrela));  //limpiar el arreglo
            une_hijos(sPriSistema, Programa, Biblioteca, Clase, 0);

            for j := 0 to Length( aGLBTsrela ) - 1 do begin
               sNombreBlockOrigen:= '';
               sNombreBlockDestino:= '';
               sNombreLogBlockOrigen:= '';
               sNombreLogBlockDestino:= '';
               if bClaseProcesar( aGLBTsrela[ j ].sPCCLASE ) then begin
                  sBuscarBlock_2(aGLBTsrela[ j ].sPCCLASE, aGLBTsrela[ j ].sPCBIB, aGLBTsrela[ j ].sPCPROG,
                               sNombreBlockOrigen, sNombreLogBlockOrigen );

                  sBuscarBlock_2(aGLBTsrela[ j ].sHCCLASE, aGLBTsrela[ j ].sHCBIB, aGLBTsrela[ j ].sHCPROG,
                               sNombreBlockDestino, sNombreLogBlockDestino );

                  if (sNombreBlockOrigen <> '') and (sNombreBlockDestino <> '')   then
                     if sNombreBlockOrigen <> sNombreLogBlockOrigen then begin
                        //mandar a funcion que determina el origen y final de la linea de acuerdo a la clase
                        indica:=define_linea(aGLBTsrela[ j ].sHCCLASE,aGLBTsrela[ j ].sMODO,aGLBTsrela[ j ].sPCCLASE,
                                             sNombreBlockOrigen,sNombreBlockDestino,stipo_linea);
                     end;
               end;
            end;


            { **************************************************************************
              *  A peticion de martin se quita esta parte porque argumenta que los    *
              *  hijos no deben de marcarse si es que son indirectos                   *
              **************************************************************************
            // si no tiene hijos directos, busca en el siguiente nivel
            if (indica = 0) and (slPriClases.IndexOf(Clase)<slPriClases.Count-1) then begin   //si no hizo ninguna conexion entre blocks
               // Pasar los resultados de aGLBTsrela al arreglo padres para hacer el drilldown y encontrar a los hijos indirectos
               setlength( padres, Length(aGLBTsrela));
               for j:=0 to Length(aGLBTsrela)-1 do begin
                  padres[j].hprog:= aGLBTsrela[ j ].sPCPROG;
                  padres[j].hbib:= aGLBTsrela[ j ].sPCBIB;
                  padres[j].hclase:= aGLBTsrela[ j ].sPCCLASE;
               end;
               //------------------------------------

               // -- inicia recorrer bloque por bloque para hijos indirectos ----
               for h:=0 to Length(padres)-1 do begin
                  a_prog := padres[h].hprog;     //bloque que se evalua
                  a_bib := padres[h].hbib;
                  a_cla := padres[h].hclase;
                  indica:=0;
                  sal:=0;
                  ZeroMemory(@aGLBTsrela, SizeOf(aGLBTsrela));  //limpiar el arreglo
                  une_hijos(sPriSistema, a_prog,a_bib, a_cla, 1); //obtener los hijos directos
                  while (sal < 10) and (indica = 0) do begin
                     sal:=sal+1;   //para que no cicle
                     //obtener los hijos de los hijos
                     indica_f:=Length(aGLBTsrela);
                     for j:=0 to indica_f-1 do
                        une_hijos(sPriSistema, aGLBTsrela[ j ].sHCPROG, aGLBTsrela[ j ].sHCBIB, aGLBTsrela[ j ].sHCCLASE, 1);
                     //------------------------------

                        for j := 0 to Length( aGLBTsrela ) - 1 do begin
                           sNombreBlockOrigen:= '';
                           sNombreBlockDestino:= '';
                           sNombreLogBlockOrigen:= '';
                           sNombreLogBlockDestino:= '';
                           if bClaseProcesar( a_cla ) then begin
                              sBuscarBlock_2(a_cla, a_bib, a_prog,     //el padre siempre es el block que se esta trabajando
                                        sNombreBlockOrigen, sNombreLogBlockOrigen );

                              sBuscarBlock_2(aGLBTsrela[ j ].sHCCLASE, aGLBTsrela[ j ].sHCBIB, aGLBTsrela[ j ].sHCPROG,
                                        sNombreBlockDestino, sNombreLogBlockDestino );

                              if (sNombreBlockOrigen <> '') and (sNombreBlockDestino <> '')   then
                                 if sNombreBlockOrigen <> sNombreLogBlockOrigen then begin

                                    //Comprobar la clase para saber hacia donde va la flecha
                                    indica:=define_linea(aGLBTsrela[ j ].sHCCLASE,aGLBTsrela[ j ].sMODO,aGLBTsrela[ j ].sPCCLASE,
                                                         sNombreBlockOrigen,sNombreBlockDestino,stipo_linea);

                                 end;
                           end;
                        end;   //fin del for que recorre hijos de hijos

                  end;  //fin del while
               end;  //fin de ciclo que recorre padres
               //-----------------------------------
            end;  //fin del if de indica
            }
         end;
   end;
end;



function TfmDigraSistema.define_linea(h_clase,h_modo,p_clase:String;
                                      origen,destino,tipo:String):integer;  //alk
var
   indica:integer;
begin
   //Comprobar la clase para saber hacia donde va la flecha
   if (h_clase='FIL') or (h_clase='LOC') or
      (h_clase='INS') or (h_clase='TAB') or
      (h_clase='DEL') or (h_clase='UPD') then begin

      if ((h_clase='FIL') and (h_modo='NEW')) or   //pad - hij
         ((h_clase='LOC') and (h_modo='O')) or
         (h_clase='INS') then begin
         if p_clase = h_clase then
            GlbLinkPoints(atDiagrama, origen, destino,
                          3, 2, tipo, asSolidArrow, psSolid )
         else
            GlbLinkPoints(atDiagrama, origen, destino,
                          1, 0, tipo, asSolidArrow, psSolid );
         indica:=1; //si unio por lo menos uno
      end
      else if ((h_clase='FIL') and (h_modo='SHR')) or     //hij-pad
              ((h_clase='FIL') and (h_modo='OLD')) or
              ((h_clase='LOC') and (h_modo='I')) or
              (h_clase='TAB') then begin
         if p_clase = h_clase then
            GlbLinkPoints(atDiagrama, destino, origen,
                          2, 3, tipo, asSolidArrow, psSolid )
         else
            GlbLinkPoints(atDiagrama, destino, origen,
                          0, 1, tipo, asSolidArrow, psSolid );
        indica:=1; //si unio por lo menos uno
      end
      else if ((h_clase='FIL') and (h_modo='MOD')) or     //hij-pad-hij
              ((h_clase='LOC') and (h_modo='I-O')) or
              ((h_clase='LOC') and (h_modo='A')) or
              (h_clase='DEL') or (h_clase='UPD') then begin
         if p_clase = h_clase then begin
            GlbLinkPoints(atDiagrama, origen, destino,           //pad-hij
                          3, 2, tipo, asSolidArrow, psSolid );
            GlbLinkPoints(atDiagrama, destino, origen,           //todas las demas clases  pad-hij
                          2, 3, tipo, asSolidArrow, psSolid );
         end
         else begin
            GlbLinkPoints(atDiagrama, origen, destino,           //pad-hij
                          1, 0, tipo, asSolidArrow, psSolid );
            GlbLinkPoints(atDiagrama, destino, origen,           //todas las demas clases  pad-hij
                          0, 1, tipo, asSolidArrow, psSolid );
         end;
         indica:=1; //si unio por lo menos uno
      end
      else if ((h_clase='FIL') or (h_clase='LOC')) and    //hij-pad
              (h_modo='') then begin
         if p_clase = h_clase then begin
            GlbLinkPoints(atDiagrama, destino, origen,
                          2, 3, tipo, asSolidArrow, psSolid );
         end
         else begin
            GlbLinkPoints(atDiagrama, destino, origen,
                          0, 1, tipo, asSolidArrow, psSolid );
         end;
         indica:=1; //si unio por lo menos uno
      end;

   end
   else begin     //todas las demas clases  pad-hij
      if p_clase = h_clase then begin
         GlbLinkPoints(atDiagrama, origen, destino,
                       3, 2, tipo, asSolidArrow, psSolid );
      end
      else begin
         GlbLinkPoints(atDiagrama, origen, destino,
                       1, 0, tipo, asSolidArrow, psSolid );
      end;
      indica:=1; //si unio por lo menos uno
   end;

   Result:=indica;
end;
//-------------------------------------------

procedure TfmDigraSistema.GlbArmaDgrSistema( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String; sParSubtitulo: String );
var
   i: Integer;
begin
   if atParDiagrama = nil then
      Exit;

   GlbNuevoDiagrama( atParDiagrama );

   iGlbNombreBlock := 0;
   SetLength( aGlbBlockAtributos, 0 );

   //crea subtitulo en atParDiagrama
   GlbDiagramaSubTitulo( atParDiagrama, sParSubtitulo );

   //logica de llenado de aGlbBlockAtributos y asignacion de renglones y columnas.
   //sParProg es el sistema
   sPriSistema := sParProg;

   iGlbRenglon := 50;
   iGlbColumna := 20;
   iGlbEspacioEntreColumnas := 35;
   iGlbEspacioEntreRenglones := 35;

   LogicaArmadoDgrSistema( atParDiagrama, sParClase, sParBib, sParProg );
   //reacomoda las lineas
   atParDiagrama.MoveBlocks( 1, 0, True );
   atParDiagrama.ClearUndoStack;
   //activa todas las paginas
   atParDiagrama.AutoScroll := False;
   atParDiagrama.AutoScroll := True;
end;

procedure TfmDigraSistema.mnuAbrirClick( Sender: TObject );
var
   sNombreArchivo: String;

   i: Integer;
   sNFisicoBlock, sClase, sBib, sProg: String;
   iColumna, iRenglon: Integer;
   slContenido: TStringList;

   bDgrSistema: Boolean;
begin
   inherited;

   sNombreArchivo := sGlbAbrirDialogo;
   if sNombreArchivo = '' then
      Exit;

   if not FileExists( sNombreArchivo ) then begin
      Application.MessageBox( pChar( 'ERROR... no existe el archivo ' + sNombreArchivo ),
         'Agregar', MB_OK );
      Exit;
   end;

   //limpia slPubDiagrama
   atDiagrama.LoadFromFile( sNombreArchivo );

   //valida que sea un diagrama del sistema
   bDgrSistema := False;
   for i := 0 to atDiagrama.BlockCount - 1 do
      if pos( sBLOCK_CONST, atDiagrama.Blocks[ i ].Name ) > 0 then begin
         bDgrSistema := True;
         Break;
      end;

   if not bDgrSistema then begin
      Application.MessageBox( sDIGRA_SISTEMA + ' incorrecto.', 'Abrir Diagrama', MB_OK );
      GlbNuevoDiagrama( atDiagrama );
      Exit;
   end;

   //carga en slPubDiagrama, para popup emergente y busqueda, (futura rutina pendiente)
   slPubDiagrama.Clear;
   slContenido := TStringList.Create;
   try
      for i := 0 to atDiagrama.BlockCount - 1 do
         with slPubDiagrama, atDiagrama.Blocks[ i ] do
            if UpperCase( ClassName ) = UpperCase( 'TFlowActionBlock' ) then begin
               sNFisicoBlock := Name;
               sClase := '';
               sBib := '';
               sProg := '';

               try
                  iColumna := Trunc( ( atDiagrama.Blocks[ i ] as TFlowActionBlock ).Left );
               except
                  iColumna := 50;
               end;

               try
                  iRenglon := Trunc( ( atDiagrama.Blocks[ i ] as TFlowActionBlock ).Top );
               except
                  iRenglon := 50;
               end;

               slContenido.CommaText := Strings.Text;

               if slContenido.Count >= 3 then begin
                  sClase := slContenido[ 0 ];
                  sBib := slContenido[ 1 ];
                  sProg := slContenido[ 2 ];
               end
               else if slContenido.Count = 2 then begin
                  sClase := slContenido[ 0 ];
                  sBib := slContenido[ 1 ];
               end
               else if slContenido.Count = 1 then
                  sClase := slContenido[ 0 ];

               Add( sNFisicoBlock + ',' +
                  sClase + ',' + sBib + ',' + sProg + ',' +
                  IntToStr( iColumna ) + ',' + IntToStr( iRenglon ) );
            end;
   finally
      slContenido.Free;
   end;
end;

function TfmDigraSistema.bPriProcesarScratch( sParArchivo: String ): Boolean;
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

function TfmDigraSistema.bPriTerminaProceso: Boolean;
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

procedure TfmDigraSistema.mnuCargarConfiguracionClick(sParProg: String);
var
   sNombreArchivo,consulta_param: String;

   procedure limpia_clases(Clases:TStringList);   // ALK para quitar las clases con //
   var
      i:integer;
      limpio:TstringList;
   begin
      limpio:=TStringList.Create;
      for i:=0 to Clases.Count -1 do
         if pos('//',Clases[i]) = 0 then
            limpio.Add(Clases[i]);

      slPriClases.Free;
      slPriClases:=limpio;
   end;
begin
   inherited;
   sPriArchivoIni := '';

   consulta_param:='select dato from parametro where clave ='+ g_q +
                'DIAGSIS_'+sUsuario+'_'+sPriSistema + g_q ;    //consulta para revisar que exista o no la configuracin previa

   if dm.sqlselect(dm.q1,consulta_param) then begin      //si hay una configuracion previa
      slPriClases.Clear;
      slPriClases.CommaText:=dm.q1.fieldbyname( 'dato' ).asstring;

      if Application.MessageBox( pChar( 'Ya existe una configuracion guardada anteriormente  '+ chr( 13 ) +
                              'que tomas las clases: ' + slPriClases.CommaText + chr( 13 )  + chr( 13 ) +
                              'Si presiona SI se hara el diagrama con configuracion actual '+ chr( 13 ) +
                              'Si presiona NO debe seleccionar nueva configuracion de clases'),
                              'Configuración de Diagrama de Sistema', MB_YESNO )=IDNO then
         ConfigDiagClick(self);   //Funcion que carga la nueva ventana de configuracion  ALK
   end
   else begin
      if Application.MessageBox( pChar( 'Debe seleccionar las clases para configuar el  '+ chr( 13 ) +
                              'diagrama del sistema ' + sParProg  + chr( 13 )  + chr( 13 ) +
                              ' ¿Desea configurarlo ahora?'),
                              'Cargar Configuración', MB_YESNO )=IDNO then
         exit
      else begin
         ConfigDiagClick(self);   //Funcion que carga la nueva ventana de configuracion  ALK
      end;
   end;   //fin de if de consulta
end;


procedure TfmDigraSistema.PriObtenerClases( sParArchivo: String );
//registra en slPriClases
var
   iniArchivo: TMemIniFile;
begin
   slPriClases.Clear;

   iniArchivo := TMemIniFile.Create( sParArchivo );
   try
      iniArchivo.ReadSectionValues( 'Clases', slPriClases );
   finally
      iniArchivo.Free;
   end;
end;

procedure TfmDigraSistema.FormCreate( Sender: TObject );
begin
   inherited;
   alkActivoDoc:=0;  //para la documentacion
   slPriClases := TStringList.Create;
   slPriArchivoIni := TStringList.Create;
end;

procedure TfmDigraSistema.FormDestroy( Sender: TObject );
begin
   slPriClases.Free;
   slPriArchivoIni.Free;

   inherited;
end;

procedure TfmDigraSistema.PriObtenerContenidoArchIni( sParArchivo: String; slParContenido: TStringList );
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

         slParContenido.Add( '[Clases]' );
         iniArchivo.ReadSectionValues( 'Clases_SCRATCH', slPaso );
         slParContenido.AddStrings( slPaso );
      finally
         iniArchivo.Free;
      end;
   finally
      slPaso.Free;
   end;
end;
//  -----------------  Funcion ALK para generar el diagrama del sistema  -------------
procedure TfmDigraSistema.mnuGenerarClick_ALK( sParProg: String );
var
   consultaDS: string;
   aPadres : array of TguardaPadres;
   aHijos : array of TguardaHijos;
   cont,i,num_h : integer;
   renglon_y, columna_x,col_x, col_y : integer;
   sClase, sBib, sProg: String;
   sTexto, sNombreBlockOrigen: String;

   function da_id(hcprog, hcbib, hcclase, pcprog, pcbib, pcclase:String): integer;
   var
      p,id:integer;
   begin
      id:=-1;
      for p:=0 to Length(aHijos)-1 do begin
         if (aHijos[p].hcprog = hcprog) and
            (aHijos[p].hcbib = hcbib) and
            (aHijos[p].hcclase = hcclase) and
            (aHijos[p].pcprog = pcprog) and
            (aHijos[p].pcbib = pcbib) and
            (aHijos[p].pcclase = pcclase) then begin
            id:=p;  //ya con este id se puede obtener el id  y el renglon
            break;
         end;
      end;
      Result:=id;
   end;

   //----------Funcion drill down para el diagrama  (recursiva)----------------
   procedure drill_dwn_arbol(pprog,pbib,pcla:string; id,reng_y:integer);
   var
      consultadd : string;    //consulta del drill down
      c,j,id_hijo :integer;
   begin
      renglon_y:=reng_y;
      consultadd:= 'select hcprog, hcbib, hcclase, pcprog, pcbib, pcclase, modo' +
                   ' from tsrela where pcclase=' + g_q + pcla + g_q +
                   ' and pcbib=' + g_q + pbib + g_q +
                   ' and pcprog=' + g_q +pprog + g_q;
      if dm.sqlselect(dm.q2,consultadd) then begin
         c:=Length(aHijos);  //posicion en el arreglo
         renglon_y:= renglon_y+1; //comenzando un nuevo renglon
         columna_x:= 0;  //empiza en 0 porque es un nuevo renglon

         SetLength(aHijos, Length(aHijos)+dm.q2.RecordCount);
         while not dm.q2.Eof do begin
            columna_x:= columna_x+1;   //si hay datos, agrego columna

            aHijos[c].id:=c;    //para relacionar, indice de padre
            aHijos[c].id_p:=id;  //indica con quien se relaciona (padre), indice de hijo
            aHijos[c].pcprog:= dm.q2.FieldByName( 'pcprog' ).AsString;
            aHijos[c].pcbib:= dm.q2.FieldByName( 'pcbib' ).AsString;
            aHijos[c].pcclase:= dm.q2.FieldByName( 'pcclase' ).AsString;
            aHijos[c].hcprog:= dm.q2.FieldByName( 'hcprog' ).AsString;
            aHijos[c].hcbib:= dm.q2.FieldByName( 'hcbib' ).AsString;
            aHijos[c].hcclase:= dm.q2.FieldByName( 'hcclase' ).AsString;
            aHijos[c].modo:= dm.q2.FieldByName( 'modo' ).AsString;
            aHijos[c].x:= columna_x;
            aHijos[c].y:= renglon_y;

            c:=c+1;
            dm.q2.Next;
         end;

         dm.q2.First;   //volver al primer elemento para hacer la recursividad
         while not dm.q2.Eof do begin
            id_hijo:=da_id(dm.q2.FieldByName( 'hcprog' ).AsString,      //obtener el id que sera del padre
                           dm.q2.FieldByName( 'hcbib' ).AsString,
                           dm.q2.FieldByName( 'hcclase' ).AsString,
                           dm.q2.FieldByName( 'pcprog' ).AsString,
                           dm.q2.FieldByName( 'pcbib' ).AsString,
                           dm.q2.FieldByName( 'pcclase' ).AsString);

            if id_hijo <> -1 then
               drill_dwn_arbol (dm.q2.FieldByName( 'hcprog' ).AsString,
                                dm.q2.FieldByName( 'hcbib' ).AsString,
                                dm.q2.FieldByName( 'hcclase' ).AsString,
                                aHijos[id_hijo].id,
                                aHijos[id_hijo].y);

            dm.q2.Next;
         end;
      end;
   end;

begin
   if slPriClases.Count = 0 then begin
      Application.MessageBox( PChar(
      'Configuración de Clases incorrecta.' + chr( 13 ) + chr( 13 ) +
         'Cargue la utileria CONFIG_DIAGRAMA_SISTEMA_' + sParProg + chr( 13 ) +
         'Con el archivo .ini correspondiente' + chr( 13 )),
         PChar('Utileria CONFIG_DIAGRAMA_SISTEMA_' + sParProg), MB_OK );
      Exit;
   end;

   gral.PubMuestraProgresBar( True );

   try
      consultaDS:= 'select distinct hcclase,hcbib,hcprog from tsrela'  +          //Para obtener los componentes mas altos
         ' where pcclase=' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sParProg + g_q +   // -- and (hcprog,hcbib,hcclase) not in INACTIVOS    más adelante
         ' minus'  +
         ' select distinct hcclase,hcbib,hcprog from tsrela' +
         ' where pcclase<>' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sParProg + g_q +
         ' order by 1,2,3';

      if dm.sqlselect(dm.q1,consultaDS) then begin
         renglon_y:= 0;  //empiza en 0 para no tener renglones y columnas de mas
         columna_x:= 0;

         SetLength(aPadres, dm.q1.RecordCount);
         cont:=0;
         while not dm.q1.Eof do begin
            columna_x:= columna_x+1;   //si hay datos, agrego columna
            renglon_y:=1;  // todos los padres estan en el renglon 1

            aPadres[cont].id:=cont+1;   //lleva el conteo del numero de elemento que es empezando por 1,2, ...
            aPadres[cont].hprog:= dm.q1.FieldByName( 'hcprog' ).AsString;
            aPadres[cont].hbib:= dm.q1.FieldByName( 'hcbib' ).AsString;
            aPadres[cont].hclase:= dm.q1.FieldByName( 'hcclase' ).AsString;
            aPadres[cont].x:= columna_x;
            aPadres[cont].y:= renglon_y;

            cont:=cont+1;
            dm.q1.Next;
         end;

         //Mandar a hacer el Drill Down de cada uno de los elementos contenidos en aPadres y
         // hacer los bloques de los padres
         for i:=0 to cont-1 do begin
            sClase:=aPadres[i].hclase;
            sBib:= aPadres[i].hbib;
            sProg:= aPadres[i].hprog;
            sNombreBlockOrigen := '_' + IntToStr(aPadres[i].id)+'_'+IntToStr(aPadres[i].x)+'_'+IntToStr(aPadres[i].y) + sBLOCK_CONST;
            sTexto := sClase + ' ' + sBib + ' ' + sProg;
            col_x:=(aPadres[i].x * iGlbColumna) + iGlbAncho + iGlbEspacioEntreColumnas;
            col_y:= (aPadres[i].y * iGlbRenglon) + iGlbAlto + ( iGlbEspacioEntreRenglones * 4 );

            RegistraBlockDgrSistema(sClase, sBib, sProg,
                                    col_x, col_y,     //columna, renglon
                                    iGlbAncho, iGlbAlto,
                                    sNombreBlockOrigen,     //nombre blok (unico)
                                    sClase + '|' + sBib + '|' + sProg,   //nombre logico
                                    'FlowActionBlock',
                                    '', '',
                                    dgr_ccolor( sClase ),
                                    sTexto );

            drill_dwn_arbol (aPadres[i].hprog,aPadres[i].hbib,aPadres[i].hclase,aPadres[i].id,aPadres[i].y);
            num_h:=Length( aHijos );    //provisional
         end;
      end; // fin del if de la consulta

      // Empieza procedimientos para crear los bloques
      for i:=0 to Length(aHijos)-1 do begin   // mandar a hacer los bloques del arreglo de hijos
         sClase:=aHijos[i].hcclase;
         sBib:= aHijos[i].hcbib;
         sProg:= aHijos[i].hcprog;
         sNombreBlockOrigen := '_' + IntToStr(aHijos[i].id)+'_'+IntToStr(aHijos[i].x)+'_'+IntToStr(aHijos[i].y) + sBLOCK_CONST;
         sTexto := sClase + ' ' + sBib + ' ' + sProg;
         col_x:=(aHijos[i].x * iGlbColumna) + iGlbAncho + iGlbEspacioEntreColumnas;
         col_y:= (aHijos[i].y * iGlbRenglon) + iGlbAlto + ( iGlbEspacioEntreRenglones * 4 );

         RegistraBlockDgrSistema(sClase, sBib, sProg,
                                 col_x, col_y,     //columna, renglon
                                 iGlbAncho, iGlbAlto,
                                 sNombreBlockOrigen,     //nombre blok (unico)
                                 sClase + '|' + sBib + '|' + sProg,   //nombre logico
                                 'FlowActionBlock',
                                 '', '',
                                 dgr_ccolor( sClase ),
                                 sTexto );
      end;

      //Prepara el diagrama para ya pintar  ALK
      GlbNuevoDiagrama( atDiagrama );

      iGlbNombreBlock := 0;
      //SetLength( aGlbBlockAtributos, 0 );

      //crea subtitulo en atParDiagrama
      GlbDiagramaSubTitulo( atDiagrama, sPriTitulo );
      //crea los block's
      for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
         GlbBlockFlow( atDiagrama,
            aGlbBlockAtributos[ i ].TipoBlock,
            aGlbBlockAtributos[ i ].NFisicoBlock,
            aGlbBlockAtributos[ i ].Columna,
            aGlbBlockAtributos[ i ].Renglon,
            aGlbBlockAtributos[ i ].Ancho,
            aGlbBlockAtributos[ i ].Alto,
            aGlbBlockAtributos[ i ].Color,
            clBlack,
            aGlbBlockAtributos[ i ].Texto );
      end;

      //Hacer las ligas entre los bloques
      hace_links(0);

      //reacomoda las lineas
      atDiagrama.MoveBlocks( 1, 0, True );
      atDiagrama.ClearUndoStack;
      //activa todas las paginas
      atDiagrama.AutoScroll := False;
      atDiagrama.AutoScroll := True;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmDigraSistema.prepara_colores();
begin
   if dm.sqlselect(dm.q2, 'SELECT * FROM PARAMETRO WHERE CLAVE LIKE ' + g_q + 'WCOLOR_%' + g_q ) then
      while not dm.q2.Eof do begin
         dgr_clasecolor(
            Copy( dm.q2.fieldbyname( 'CLAVE' ).AsString, 8, 3 ),
            dm.q2.FieldByName( 'DATO' ).AsString );
         dm.q2.Next;
      end;
end;

//  ------------------------------------------------------------------------------

procedure TfmDigraSistema.mnuGenerarClick( sParProg: String );
var
   i: Integer;
begin
   inherited;

   if slPriClases.Count = 0 then begin
      Application.MessageBox( PChar(
      'Configuración de Clases incorrecta.' + chr( 13 ) + chr( 13 ) +
      'Seleccione "Configurar Diagrama"' + chr( 13 ) +
      'En la barra de menús de Documentacion del Sistema' + chr( 13 )),
      PChar('Configuracion de Diagrama'), MB_OK );

      Exit;
   end;

   gral.PubMuestraProgresBar( True );
   try
      GlbArmaDgrSistema( atDiagrama, sPriClase, sPriBib, sPriProg, sPriTitulo );


      //guarda en slPubDiagrama informacion para uso posterior
      for i := 0 to Length( aGlbBlockAtributos ) - 1 do
         with slPubDiagrama, aGlbBlockAtributos[ i ] do
            if ( TipoBlock = 'FlowActionBlock' ) then
               Add( NFisicoBlock + ',' +
                  Clase + ',' + Biblioteca + ',' + Programa + ',' +
                  IntToStr( Columna ) + ',' + IntToStr( Renglon ) + ',' +
                  LigaBlockOrigen + ',' + LigaBlockDestino );
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmDigraSistema.atDiagramaDControlDblClick( Sender: TObject;
   ADControl: TDiagramControl );
var
   i, y: Integer;
   sNombre: String;
   slNLogicoBlock: TStringList;
begin
   inherited;

   screen.Cursor := crsqlwait;
   slNLogicoBlock := Tstringlist.Create;
   try
      for i := 0 to slPubDiagrama.Count - 1 do begin
         if pos( ADControl.Name, slPubDiagrama[ i ] ) > 0 then begin
            slNLogicoBlock.CommaText := slPubDiagrama[ i ];

            Break;
         end;
      end;

      if slNLogicoBlock.Count > 0 then begin
         sNombre :=
            slNLogicoBlock[ 3 ] + '|' + slNLogicoBlock[ 2 ] + '|' + slNLogicoBlock[ 1 ] + '|' + sPriSistema;

         bgral := sNombre;
         Opciones := gral.ArmarMenuConceptualWeb( bgral, 'analisis_impacto' );

         y := ArmarOpciones( Opciones );
         gral.PopGral.Popup( g_X, g_Y );
      end;
   finally
      slNLogicoBlock.Free;
      screen.Cursor := crdefault;
   end;
end;

function TfmDigraSistema.ArmarOpciones( b1: Tstringlist ): integer;
begin
   gral.EjecutaOpcionB( b1, 'Análisis de Impacto' );
end;

//  ---------------- Metodos ALK para docSistema ---------------------------
function TfmDigraSistema.GuardaDiagrama( ruta : string ; tipo : integer): string;     //para mandar guardar desde ufmdocsistema
var
   ruta_aux:string;
begin
   Screen.Cursor := crSqlWait;
   //ruta:='';
   if atDiagrama.BlockCount > 0 then begin
      try
         case tipo of      //0-DGR / 1-PDF / 2-VSD / otro-WMF
            0:
            begin
               ruta:=ruta + '.dgr';
               atDiagrama.SaveToFile( ruta );
            end;
            1:
            begin
               ruta_aux:=ruta + '.wmf';
               GlbExportarDgr_A_WMF( atDiagrama, ruta_aux );
               ruta:=ruta + '.pdf';
               //GlbExportarDgr_A_PDF( ruta_aux, ruta );
               dm.ExportAsPdf( ruta_aux, ruta );
            end;
            2:
            begin
               ruta_aux:=ruta + '.wmf';
               GlbExportarDgr_A_WMF( atDiagrama, ruta_aux );
               ruta:=ruta + '.vsd';
               GlbExportarDgr_A_VSD( ruta_aux, ruta );
            end;
            else begin
               ruta:=ruta + '.wmf';
               GlbExportarDgr_A_WMF( atDiagrama, ruta );
            end;
         end;
      finally
         Screen.Cursor := crDefault;
         Result:=ruta;
      end;
   end
   else begin
      Screen.Cursor := crDefault;
      Result:=ruta;
   end;
end;

procedure TfmDigraSistema.configuraIni_DocSistema(sNombreArchivoDS : string);
begin
   bPriClasesScratchProcesar := bPriProcesarScratch( sNombreArchivoDS );
   sPriCadenaScratch := ' AND HCBIB NOT LIKE ' + g_q + '%SCRATCH%' + g_q;
   if bPriClasesScratchProcesar then
      sPriCadenaScratch := '';
   PriObtenerClases( sNombreArchivoDS ); //registra en slPriClases

   if slPriClases.Count > 0 then begin
      sPriArchivoIni := sNombreArchivoDS;

      PriObtenerContenidoArchIni( sNombreArchivoDS, slPriArchivoIni );
   end
   else
      Application.MessageBox( PChar(
      'Configuración de Clases incorrecta.' + chr( 13 ) + chr( 13 ) +
         'Cargue la utileria CONFIG_DIAGRAMA_SISTEMA' + chr( 13 ) +
         'Con el archivo .ini correspondiente' + chr( 13 )),
         PChar('Utileria CONFIG_DIAGRAMA_SISTEMA'), MB_OK );

end;


procedure TfmDigraSistema.ConfigDiagClick(Sender: TObject);
var
   consulta,consulta_param:string;
   nuevo_diag: TalkNuevoDiagrama;
   i, multipadre:integer;
begin
   {xx := Tstringlist.Create;
   loc1 := Tstringlist.Create;
   loc2 := Tstringlist.Create;
   jerarquia_clases(sPriSistema);  }
   alkActivo:=0;

   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );
   try
      clases:=TStringList.Create;
      procesadas:=TStringList.Create; //auxiliar para leeclases

      slPriClases.Clear;
      if fileexists(g_tmpdir+'\clases_tmp.txt') then
         slPriClases.LoadFromFile(g_tmpdir+'\clases_tmp.txt');

      deletefile(g_tmpdir+'\clases_tmp.txt');
      nuevo_diag:=TalkNuevoDiagrama.Create(self);

      //Agrupar las clase mas altas como nivel 1 ordenadas de la que tiene menor aparicion a la mayor
      consulta:= 'select hcclase, count(*) from ('  +
            'select distinct hcclase,hcbib,hcprog from tsrela'  +          //Para obtener los componentes mas altos
            ' where pcclase = ' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sPriSistema + g_q +
            ' minus'  +
            ' select distinct hcclase,hcbib,hcprog from tsrela' +
            ' where pcclase <> ' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sPriSistema + g_q +
            ' ) group by hcclase order by 2';

      if dm.sqlselect(dm.q1,consulta) then
         if dm.q1.RecordCount > 1 then begin //si va a ser un diagrama multipadres
            while not dm.q1.Eof do begin
               if clases.IndexOf(dm.q1.fieldbyname( 'hcclase' ).AsString)=-1 then
                  clases.Add(dm.q1.FieldByName( 'hcclase' ).AsString);
               dm.q1.Next;
            end;
            multipadre:=1;   //hay multipadres
            nuevo_diag.radio(clases,slPriClases,sPriSistema);
            slPriClases.Clear;
         end
         else begin
            leeclases(dm.q1.fieldbyname( 'hcclase' ).AsString, sPriSistema);
            multipadre:=0;   //no hay multipadres
            nuevo_diag.check(clases,slPriClases);
         end;

      try
         nuevo_diag.ShowModal;
      finally
         nuevo_diag.Free;
      end;

      if (alkActivo=1) or (alkActivoDoc=1) then begin       // si se hicieron cambios en la configuracion
         slPriClases.Clear;
         if fileexists(g_tmpdir+'\clases_tmp.txt') then
            slPriClases.LoadFromFile(g_tmpdir+'\clases_tmp.txt');

         //Actualizar dato en tabla parametro
         consulta_param:='select dato from parametro where clave ='+ g_q +
                         'DIAGSIS_'+sUsuario+'_'+sPriSistema + g_q ;
         if dm.sqlselect(dm.q1,consulta_param) then begin //si ya existe, actualizar
            if not dm.sqlupdate( 'update parametro ' +
                                 ' set dato=' + g_q + slPriClases.CommaText + g_q +
                                 ' where clave=' + g_q + 'DIAGSIS_'+sUsuario+'_'+sPriSistema + g_q ) then
               Application.MessageBox( pchar( 'No se pudo actualizar configuracion de Diagrama' ),
                                       pchar( 'Diagrama de sistema'  ), MB_OK );
         end
         else begin
            if not dm.sqlinsert('insert into parametro (clave, dato) values ('
                                + g_q + 'DIAGSIS_'+sUsuario+'_'+sPriSistema + g_q + ','
                                + g_q + slPriClases.CommaText + g_q + ')') then
               Application.MessageBox( pchar( 'No se pudo guardar la configuracion de Diagrama' ),
                                       pchar( 'Diagrama de sistema'  ), MB_OK );
         end;

         //Hacer el diagrama con la configuracion guardada o la nueva configuracion
         //if atDiagrama.BlockCount>0 then begin
            GlbNuevoDiagrama( atDiagrama );
            GlbArmaDgrSistema( atDiagrama, sPriClase, sPriBib, sPriProg, sPriTitulo );

            //guarda en slPubDiagrama informacion para uso posterior
            for i := 0 to Length( aGlbBlockAtributos ) - 1 do
               with slPubDiagrama, aGlbBlockAtributos[ i ] do
                  if ( TipoBlock = 'FlowActionBlock' ) then
                     Add( NFisicoBlock + ',' +
                        Clase + ',' + Biblioteca + ',' + Programa + ',' +
                        IntToStr( Columna ) + ',' + IntToStr( Renglon ) + ',' +
                        LigaBlockOrigen + ',' + LigaBlockDestino );
      end;
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;


procedure TfmDigraSistema.leeclases( clase, sistema:  string);    //ALK
var
   nombre,cons:string;
begin
   nombre:='JER_' + sistema + '_' + clase;
   cons:='select dato from parametro where clave= '+ g_q + nombre + g_q;
   if dm.sqlselect(dm.q1,cons) then
      clases.CommaText:= dm.q1.FieldByName( 'dato' ).AsString
   else
      Application.MessageBox( 'No se ha cargado la jerarquia de clases.'+ chr( 13 ) + chr( 13 ) +
                              'Para cargar la configuracion vaya al menu "Administracion"'+ chr( 13 ) +
                              'en la opcion "Jerarquia de clases".', 'Jerarquia de clases ', MB_OK );
end;


procedure TfmDigraSistema.mnuTDArcClick(Sender: TObject);
var
   i : integer;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );

   try
      for i:=atDiagrama.LinkCount -1 downto 0 do
         atDiagrama.Links[i].Destroy;

      hace_links(0);
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;


procedure TfmDigraSistema.mnuTDBezlerClick(Sender: TObject);
var
   i : integer;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );

   try
      for i:=atDiagrama.LinkCount -1 downto 0 do
         atDiagrama.Links[i].Destroy;

      hace_links(1);
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDigraSistema.mnuTDLineClick(Sender: TObject);
var
   i : integer;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );

   try
      for i:=atDiagrama.LinkCount -1 downto 0 do
         atDiagrama.Links[i].Destroy;

      hace_links(2);
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDigraSistema.mnuTDPolyLineClick(Sender: TObject);
var
   i : integer;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );

   try
      for i:=atDiagrama.LinkCount -1 downto 0 do
         atDiagrama.Links[i].Destroy;

      hace_links(3);
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmDigraSistema.mnuTDSideLineClick(Sender: TObject);
var
   i : integer;
begin
   Screen.Cursor := crSQLWait;
   gral.PubMuestraProgresBar( True );

   try
      for i:=atDiagrama.LinkCount -1 downto 0 do
         atDiagrama.Links[i].Destroy;

      hace_links(4);
   finally
      gral.PubMuestraProgresBar( False );
      Screen.Cursor := crDefault;
   end;
end;

//  -------  procedimientos traidos desde la lista de dependencias para la jerarquia de clases -----

function TfmDigraSistema.agrega_compo( qq: Tadoquery ; g_nivel:integer): boolean;
var
   cc, mensaje: string;
   k, n: integer;
begin
   cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
      qq.FieldByName( 'ocprog' ).AsString + '|' +
      qq.FieldByName( 'ocbib' ).AsString + '|' +
      qq.FieldByName( 'occlase' ).AsString + '|' +
      qq.FieldByName( 'pcprog' ).AsString + '|' +
      qq.FieldByName( 'pcbib' ).AsString + '|' +
      qq.FieldByName( 'pcclase' ).AsString + '|' +
      qq.FieldByName( 'hcprog' ).AsString + '|' +
      qq.FieldByName( 'hcbib' ).AsString + '|' +
      qq.FieldByName( 'hcclase' ).AsString;

   if(xx.indexof(cc)>-1) then begin          //si encuentra el dato, manda falso  RGM
      agrega_compo:=false;
      exit;
   end;

   xx.Add( cc );
   k := length( x );
   setlength( x, k + 1 );
   mensaje := 'x=' + inttostr( k ) + '  ' + cc;
   x[ k ].nivel := g_nivel;
   x[ k ].nombreo := qq.FieldByName( 'ocprog' ).AsString;
   x[ k ].bibo := qq.FieldByName( 'ocbib' ).AsString;
   x[ k ].claseo := qq.FieldByName( 'occlase' ).AsString;
   x[ k ].nombrep := qq.FieldByName( 'pcprog' ).AsString;
   x[ k ].bibp := qq.FieldByName( 'pcbib' ).AsString;
   x[ k ].clasep := qq.FieldByName( 'pcclase' ).AsString;
   x[ k ].nombre := qq.FieldByName( 'hcprog' ).AsString + trim( Wciclado );
   x[ k ].bib := qq.FieldByName( 'hcbib' ).AsString;
   x[ k ].clase := qq.FieldByName( 'hcclase' ).AsString;
   x[ k ].modo := qq.FieldByName( 'modo' ).AsString;
   x[ k ].organizacion := qq.FieldByName( 'organizacion' ).AsString;
   x[ k ].externo := qq.FieldByName( 'externo' ).AsString;
   x[ k ].coment := qq.FieldByName( 'coment' ).AsString;

   agrega_compo := true;
end;


procedure TfmDigraSistema.leecompos( compo, bib, clase, sistema: string; g_nivel : integer );
var
   qq: Tadoquery;
   nuevo, bexiste,bRepetido: boolean;
   cc,sClase, sSistema: String;
   i, ii, jj,Indicex, Indicey, Indicez, Wsale, i1, g_nivel0: integer;
begin
   bRepetido := bGlbRepetidoTsrela( compo, bib, clase );
   if not bRepetido then begin
      GlbRegistraArregloTsrela( compo, bib, clase );
      qq := Tadoquery.Create( self );
      try
         qq.Connection := dm.ADOConnection1;
         if dm.sqlselect( qq, 'select * from tsrela ' +
            ' where pcprog=' + g_q + compo + g_q +
            ' and   pcbib=' + g_q + bib + g_q +
            ' and   pcclase=' + g_q + clase + g_q ) then begin
            while not qq.Eof do begin
               bexiste := false;
               nuevo := false;
               ii := 0;
               IF ii >= 0 then begin
                  cc := v_compo + '|' + v_bib + '|' + v_clase + '|' +
                     qq.FieldByName( 'ocprog' ).AsString + '|' +
                     qq.FieldByName( 'ocbib' ).AsString + '|' +
                     qq.FieldByName( 'occlase' ).AsString + '|' +
                     qq.FieldByName( 'pcprog' ).AsString + '|' +
                     qq.FieldByName( 'pcbib' ).AsString + '|' +
                     qq.FieldByName( 'pcclase' ).AsString + '|' +
                     qq.FieldByName( 'hcprog' ).AsString + '|' +
                     qq.FieldByName( 'hcbib' ).AsString + '|' +
                     qq.FieldByName( 'hcclase' ).AsString;
                  if xx.IndexOf( cc ) > -1 then
                     bexiste := True
                  else
                     bexiste := False;

                     if g_nivel = 1 then begin
                        v_clase := qq.FieldByName( 'hcclase' ).AsString;
                        v_bib := qq.FieldByName( 'hcbib' ).AsString;
                        v_compo := qq.FieldByName( 'hcprog' ).AsString;
                        v_sistema := qq.FieldByName( 'sistema' ).AsString;
                     end;
                     nuevo := agrega_compo( qq ,g_nivel);
                     leecompos( qq.FieldByName( 'hcprog' ).AsString,
                              qq.FieldByName( 'hcbib' ).AsString,
                              qq.FieldByName( 'hcclase' ).AsString,
                              qq.FieldByName( 'sistema' ).AsString,
                              g_nivel+1 );
               end;
               qq.Next;
            end;
         end;
      finally
         qq.Free;
      end;
   end;
end;


procedure TfmDigraSistema.jerarquia_clases( sistema: string );
var
   i, k, j: integer;
   ant,consultaDS, consulta2,cc: string;
   g_nivel: Integer;

   procedure guarda_cla(clase:String);
   var
      long,i:integer;
      cons,nombre:String;
   begin
      long:=length(x);
      clases:=TStringList.Create;
      if long>0 then
         for i:=0 to long-1 do begin
            if clases.IndexOf(x[i].clase) = -1 then
               clases.Add(x[i].clase);
         end;

      nombre:='JER_' + sistema + '_' + clase;
      cons:='select dato from parametro where clave= '+ g_q + nombre + g_q;
      if dm.sqlselect(dm.q2,cons) then begin
         cons:='update parametro set dato='+ g_q + clases.CommaText + g_q +
               ' where clave= '+ g_q + nombre + g_q;
         dm.sqlupdate(cons);
      end
      else begin
         cons:='insert into parametro (clave, dato)'+
               ' values('+ g_q + nombre + g_q+ ','+
               g_q + clases.CommaText + g_q + ')';
         dm.sqlupdate(cons);
      end;

       //clases.SaveToFile(g_tmpdir+'\'+clase+'_padre.txt');
      clases.free;
   end;

begin
   xx := Tstringlist.Create;
   loc1 := Tstringlist.Create;
   loc2 := Tstringlist.Create;
   SetLength( aGLBTsrela, 0 );
   screen.Cursor := crsqlwait;
   setlength( x, 0 );
   xx.Clear;
   loc1.Clear;
   loc2.Clear;
   g_nivel:=0;

   //Agrupar las clase mas altas como nivel 1 ordenadas de la que tiene menor aparicion a la mayor
   consultaDS:= 'select hcclase, count(*) from ('  +
         'select distinct hcclase,hcbib,hcprog from tsrela'  +          //Para obtener los componentes mas altos
         ' where pcclase = ' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sistema + g_q +
         ' minus'  +
         ' select distinct hcclase,hcbib,hcprog from tsrela' +
         ' where pcclase <> ' + g_q + 'CLA' + g_q + ' and sistema=' + g_q + sistema + g_q +
         ' ) group by hcclase order by 2';


   if dm.sqlselect( dm.q5,  consultaDS ) then begin
      while not dm.q5.Eof do begin
         consultaDS:='select distinct hcclase,hcbib,hcprog from tsrela'  +
                  ' where hcclase =' + g_q + dm.q5.FieldByName( 'hcclase' ).AsString + g_q +
                  ' and sistema=' + g_q + sistema + g_q;
         //Desde aqui va lo de los multipadres, crear un registro por cada padre
         if dm.sqlselect( dm.q3,  consultaDS ) then begin
            while not dm.q3.Eof do begin
               consulta2:= 'select * from tsrela ' +
                        ' where hcprog =' + g_q + dm.q3.FieldByName( 'hcprog' ).AsString + g_q +
                        ' and   hcbib =' + g_q + dm.q3.FieldByName( 'hcbib' ).AsString + g_q +
                        ' and   hcclase =' + g_q + dm.q3.FieldByName( 'hcclase' ).AsString + g_q;
               if dm.sqlselect( dm.q1, consulta2 ) then
                  agrega_compo( dm.q1 ,g_nivel);
                  g_nivel:=g_nivel+1;

               consulta2:= 'select * from tsrela ' +
                        ' where pcprog =' + g_q + dm.q3.FieldByName( 'hcprog' ).AsString + g_q +
                        ' and   pcbib =' + g_q + dm.q3.FieldByName( 'hcbib' ).AsString + g_q +
                        ' and   pcclase =' + g_q + dm.q3.FieldByName( 'hcclase' ).AsString + g_q;
               if dm.sqlselect( dm.q1, consulta2 ) then begin
                  while not dm.q1.Eof do begin
                     agrega_compo( dm.q1 ,g_nivel);
                     leecompos( dm.q1.FieldByName( 'hcprog' ).AsString,
                        dm.q1.FieldByName( 'hcbib' ).AsString,
                        dm.q1.FieldByName( 'hcclase' ).AsString,
                        dm.q1.FieldByName( 'sistema' ).AsString,
                        g_nivel+1 );
                     dm.q1.Next;
                  end;  //fin de while q1
               end;  //fin if q1
               g_nivel:=g_nivel-1;
               dm.q3.Next;
            end;  //fin del while q3
         end; // fin del if q3
         //reiniciar todos los valores para evaluar a un nuevo padre
         guarda_cla(dm.q5.FieldByName( 'hcclase' ).AsString);   //clase padre
         xx.Clear;
         loc1.Clear;
         loc2.Clear;
         g_nivel:=0;
         ZeroMemory(@aGLBTsrela, SizeOf(aGLBTsrela));
         ZeroMemory(@x, SizeOf(x));
         dm.q5.Next;
      end;  //fin multipadres while  q5
   end; //fin del if multipadres q5
   screen.Cursor := crdefault;
end;

//  ------------------------------------------------------------------------------------------------

end.

