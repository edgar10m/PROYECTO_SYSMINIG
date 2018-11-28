unit uDiagramaRutinas;

interface

uses
   atDiagram,
   FlowchartBlocks, //flowchart objects
   //ElectricBlocks, //electric objects
   ArrowBlocks, //arrow objects
   //ElectricBlocks2, //additional electric objects
   DFDBlocks, //data flow blocks
   UMLBlocks, //UML blocks
   ufmBloques,        //quitar ALK ufmbloques;
   SysUtils, Classes, Graphics, Dialogs, ADODB, dxmdaset, uConstantes, Windows, ComObj;

const
   sDEFAULT_LENG_VISUSTIN_DGR_CBL = 'COBFIX';
   sDEFAULT_LENG_VISUSTIN_DGR_CPY = 'COBFIX';

// ALK para diagrama de bloques //
type
   aCPY = record
      sistema : string;
      prog : string;
      clase : string;
      bib: string;
end;
//  _________________________  //

type
   Tclasecolor = record
      clase: string;
      color: string;
      wColor: TColor;
   end;

   Tcompon = record
      clase: string;
      bib: string;
      prog: string;
      sistema: string;
      ren: integer;
      col: integer;
      desplaza: integer;
      NombreBlock: String;
   end;

var
   dgrcol: array of Tclasecolor;
   dgrcom: array of Tcompon;
   dgrfisicos: Tstringlist;
   archivo_selects: Tstringlist;  // alk temporal para guardar las consultas
   repetidos_str:TStringList;  // para controlar los repetidos  ALK
   ancho: Integer = 90; //80;
   alto: Integer = 50; //40;

   iNombre: Integer;
   es_bbva: Boolean;
   dgryy: tStringlist; //usado para generar archivo excel - en su momento quitar
   archivo_lista: String; //usado para generar archivo excel - en su momento quitar

   doc_auto : integer;   //para indicar cuando viene de la documentacion automatica

   sGlbLENG_VISUSTIN_DGR_CBL: String = '';
   sGlbLENG_VISUSTIN_DGR_CPY: String = '';

procedure indica_doc_auto(indicador : integer);   //para indicar cuando viene de la documentacion
function indica_doc_a(): integer;    //para mandar el indicador al producto que lo pida ptsdiagjcl   alk

procedure GlbNuevoDiagrama( atParDiagrama: TatDiagram );

procedure GlbBlockFlow( atParDiagrama: TatDiagram;
   sParTipoBlock: String;
   sParName: String; //nombre componente
   dParLeft, dParTop, dParWidth, dParHeight: Double; //posicion y tamaño
   aParBlockColor, aParFontColor: TColor; //color: block y font
   sParTexto: String ); overload;

//utilizado para diagrama de clases, incluye zona: atributos y metodos
procedure GlbBlockFlow( atParDiagrama: TatDiagram;
   sParTipoBlock: String;
   sParName: String; //nombre componente
   dParLeft, dParTop, dParWidth, dParHeight: Double; //posicion y tamaño
   aParBlockColor, aParFontColor: TColor; //color: block y font
   sParTexto: String;
   slParAtributos, slParOperaciones: TStringList ); overload;

//construye las ligas a traves de metodos, un solo tipo de linea ( TDiagramSideLine es el deafult)
procedure GlbLinkPoints( atParDiagrama: TatDiagram;
   sParNameOrigen, sParNameDestino: String;
   iParPointOrigen, iParPointDestino: Smallint;
   asParTipoFlecha: TArrowShape; psParEstiloLinea: TPenStyle ); overload;

//construye las ligas a traves de metodos, varios tipos de linea
procedure GlbLinkPoints( atParDiagrama: TatDiagram;
   sParNameOrigen, sParNameDestino: String;
   iParPointOrigen, iParPointDestino: Smallint;
   sParTipoLinea: String; asParTipoFlecha: TArrowShape; psParEstiloLinea: TPenStyle ); overload;

//construye las ligas a traves de texto
procedure GlbLinkPoints( iParNumLinea: Integer;
   sParNFisicoBlock: String;
   iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
   sParNameOrigen, sParNameDestino: String;
   iParPointOrigen, iParPointDestino: Smallint;
   slParLinkPoint: TStringList;
   sParTipoFlecha, sParTipoLinea, sParEstiloLinea: String ); overload;

//cuando seleccionas varios elementos de un diagrama, no se seleccionan las lineas o links
procedure GlbNoSelecLink( atParDiagrama: TatDiagram; ParADControl: TDiagramControl );

//exporta un diagrama a imagen(WMF)
procedure GlbExportarDgr_A_WMF( atParDiagrama: TatDiagram; sParArchivoSalida: String );

//exporta una imagen(WMF) a Visio(VSD)
procedure GlbExportarDgr_A_VSD( sParArchivoWMF: String; sParArchivoSalida: String );

//exporta una imagen(WMF) a PDF
procedure GlbExportarDgr_A_PDF( sParArchivoWMF: String; sParArchivoSalida: String );

//abre dialogo de windows para obtener: ruta y nombre del archivo
function sGlbExportarDiagramaDialogo( exParTipoExport: TTipoExport;
   atParDiagrama: TatDiagram; sParNombreArchivo: String ): String;

procedure GlbDiagramaSubTitulo( atParDiagrama: TatDiagram; sParSubTitulo: String );
///
procedure dgr_clasecolor( clase: string; colorw: string );
function dgr_ccolor( clase: string ): TColor;
function dgr_repetido(
   clase: string; bib: string; prog: string; sis: string; ren: integer; col: integer; sParNombreBlock: String ): Integer;
///
procedure GlbArmaDiagramaBloques( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String; sParSistema: String; sParSubtitulo: String );
procedure GlbArmaDiagramaAImpacto( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String; sParSistema: String; sParSubtitulo: String );
procedure GlbArmaDiagramaProcesos( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String; sParSistema: String; sParSubtitulo: String );

function GLbCreaDiagramaFlujo(
   sParClase, sParBib, sParProg: String;
   sParArchivoFte, sParRutaSalida, sParArchivoSalida: String ): Boolean;

{function GLbCreaDiagramaFlujo_y_Jerarquico(
   sParClase, sParBib, sParProg: String;
   sParArchivoFte, sParRutaSalida, sParArchivoSalida, sParTipoDiagrama: String ): Boolean;  }

function GLbCreaDiagramaActividad(
   sParClase, sParBib, sParProg: String;
   sParArchivoFte, sParRutaSalida, sParArchivoSalida: String ): Boolean;

// ___ ALK para diagrama de bloques __
procedure ConsultaDgrBloques(sParSistema, sParProg, sParBib, sParClase: string);
implementation
uses
   ptsmain, ptsgral, ptsdm, dxBar;

procedure GlbNuevoDiagrama
( atParDiagrama: TatDiagram );
begin
   atParDiagrama.Clear;
   atParDiagrama.ClearUndoStack;
   atParDiagrama.ClearDControls;

   with atParDiagrama do begin
      LeftRuler.Visible := True;
      TopRuler.Visible := True;
      SnapGrid.Style := gsRuler;
      SnapGrid.Pen.Color := clSilver;
      SnapGrid.Pen.Style := psDot;
      SnapGrid.SnapToRuler := True;
      SnapGrid.Visible := True;
      MouseWheelMode := mwVertical;
      ShowCrossIndicators := True;
      Color := clWhite;
      Font.Name := 'Tahoma';
      DragStyle := dsShape;
      HandlesStyle := hsVisio;
      ClearUndoStack;
      WheelZoom := True;
      AutoPage := True;
      PageLines.Visible := True;
   end;
end;

procedure GlbLinkPoints( atParDiagrama: TatDiagram;
   sParNameOrigen, sParNameDestino: String;
   iParPointOrigen, iParPointDestino: Smallint;
   asParTipoFlecha: TArrowShape; psParEstiloLinea: TPenStyle );
//Para asParTipoFlecha: asDiamond, asLineArrow, asSolidArrow... etc.;
//Para psParEstiloLinea: psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame
//Tipo de Linea: TDiagramSideLine, TDiagramBlock, TDiagramLineJoin, TTextBlock, TDiagramLine, TDiagramPolyLine, TPolygonBlock, TDiagramArc, TDiagramBezier
var
   DiagramLine: TDiagramLine;
   DiagramSideLine: TDiagramSideLine;

   DiagramControlOrigen: TDiagramControl;
   DiagramControlDestino: TDiagramControl;

   sNameDCOrigen: String;
   sNameDCDestino: String;
begin
   DiagramControlOrigen := atParDiagrama.FindDControl( sParNameOrigen );
   DiagramControlDestino := atParDiagrama.FindDControl( sParNameDestino );

   sNameDCOrigen := UpperCase( DiagramControlOrigen.ClassName );
   sNameDCDestino := UpperCase( DiagramControlDestino.ClassName );

   DiagramSideLine := TDiagramSideLine.Create( atParDiagrama.Owner );

   with DiagramSideLine do begin
      Diagram := atParDiagrama;

      Pen.Style := psParEstiloLinea;
      SelPen.Style := psParEstiloLinea;
      SelPen.Color := clRed; //resalta la linea al seleccionarla
      SelPen.Width := 4; //resalta la linea al seleccionarla
      TargetArrow.Shape := asParTipoFlecha;
      TargetArrow.Width := 7;
      TargetArrow.Height := 7;
      Restrictions := [ crNoMove ]; //crNoSelect, crNoEdit, crNoDelete ]; //Restricciones;
      SendToBack;

      //link origen
      if sNameDCOrigen = UpperCase( 'TFlowActionBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowActionBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowDecisionBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowDecisionBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowTerminalBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowTerminalBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDatabaseBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDatabaseBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowDataBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowDataBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowDocumentBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowDocumentBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowInputBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowInputBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDFDProcessBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDFDProcessBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDFDInterfaceBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDFDInterfaceBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDFDDataStoreBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDFDDataStoreBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TUMLPackageBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TUMLPackageBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TUMLClassBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TUMLClassBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TChevronArrowBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TChevronArrowBlock ).LinkPoints[ iParPointOrigen ];

      //link destino
      if sNameDCDestino = UpperCase( 'TFlowActionBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowActionBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowDecisionBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowDecisionBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowTerminalBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowTerminalBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDatabaseBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDatabaseBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowDataBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowDataBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowDocumentBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowDocumentBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowInputBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowInputBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDFDProcessBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDFDProcessBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDFDInterfaceBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDFDInterfaceBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDFDDataStoreBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDFDDataStoreBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TUMLPackageBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TUMLPackageBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TUMLClassBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TUMLClassBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TChevronArrowBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TChevronArrowBlock ).LinkPoints[ iParPointDestino ];
   end;
end;

procedure GlbLinkPoints( atParDiagrama: TatDiagram;
   sParNameOrigen, sParNameDestino: String;
   iParPointOrigen, iParPointDestino: Smallint;
   sParTipoLinea: String; asParTipoFlecha: TArrowShape; psParEstiloLinea: TPenStyle );
//Para asParTipoFlecha: asDiamond, asLineArrow, asSolidArrow... etc.;
//Para psParEstiloLinea: psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame
//Para sParTipoLinea: TDiagramSideLine, TDiagramLine, TDiagramArc, etc...
var
   BaseDiagramLine: TBaseDiagramLine;

   DiagramLine: TDiagramLine;
   DiagramSideLine: TDiagramSideLine;
   DiagramArc: TDiagramArc;
   DiagramBezier: TDiagramBezier;
   DiagramPolyLine: TDiagramPolyLine;

   DiagramControlOrigen: TDiagramControl;
   DiagramControlDestino: TDiagramControl;
   sNameDCOrigen: String;
   sNameDCDestino: String;
begin
   DiagramControlOrigen := atParDiagrama.FindDControl( sParNameOrigen );
   DiagramControlDestino := atParDiagrama.FindDControl( sParNameDestino );
   sNameDCOrigen := UpperCase( DiagramControlOrigen.ClassName );
   sNameDCDestino := UpperCase( DiagramControlDestino.ClassName );

   if UpperCase( sParTipoLinea ) = UpperCase( 'TDiagramLine' ) then begin
      DiagramLine := TDiagramLine.Create( atParDiagrama.Owner );
      BaseDiagramLine := DiagramLine as TBaseDiagramLine;
   end;

   if UpperCase( sParTipoLinea ) = UpperCase( 'TDiagramSideLine' ) then begin
      DiagramSideLine := TDiagramSideLine.Create( atParDiagrama.Owner );
      BaseDiagramLine := DiagramSideLine as TBaseDiagramLine;
   end;

   if UpperCase( sParTipoLinea ) = UpperCase( 'TDiagramArc' ) then begin
      DiagramArc := TDiagramArc.Create( atParDiagrama.Owner );
      BaseDiagramLine := DiagramArc as TBaseDiagramLine;
   end;

   if UpperCase( sParTipoLinea ) = UpperCase( 'TDiagramBezier' ) then begin
      DiagramBezier := TDiagramBezier.Create( atParDiagrama.Owner );
      BaseDiagramLine := DiagramBezier as TBaseDiagramLine;
   end;

   if UpperCase( sParTipoLinea ) = UpperCase( 'TDiagramPolyLine' ) then begin
      DiagramPolyLine := TDiagramPolyLine.Create( atParDiagrama.Owner );
      BaseDiagramLine := DiagramPolyLine as TBaseDiagramLine;
   end;

   //with DiagramSideLine do begin
   with BaseDiagramLine do begin
      Diagram := atParDiagrama;

      Pen.Style := psParEstiloLinea;
      SelPen.Style := psParEstiloLinea;
      SelPen.Color := clRed; //resalta la linea al seleccionarla
      SelPen.Width := 4; //resalta la linea al seleccionarla
      TargetArrow.Shape := asParTipoFlecha;
      TargetArrow.Width := 7;
      TargetArrow.Height := 7;
      Restrictions := [ crNoMove ]; //crNoSelect, crNoEdit, crNoDelete ]; //Restricciones;
      SendToBack;

      //link origen
      if sNameDCOrigen = UpperCase( 'TFlowActionBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowActionBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowDecisionBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowDecisionBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowTerminalBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowTerminalBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDatabaseBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDatabaseBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowDataBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowDataBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowDocumentBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowDocumentBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TFlowInputBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TFlowInputBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDFDProcessBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDFDProcessBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDFDInterfaceBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDFDInterfaceBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TDFDDataStoreBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TDFDDataStoreBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TUMLPackageBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TUMLPackageBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TUMLClassBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TUMLClassBlock ).LinkPoints[ iParPointOrigen ];
      if sNameDCOrigen = UpperCase( 'TChevronArrowBlock' ) then
         SourceLinkPoint.AnchorLink := ( DiagramControlOrigen as TChevronArrowBlock ).LinkPoints[ iParPointOrigen ];

      //link destino
      if sNameDCDestino = UpperCase( 'TFlowActionBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowActionBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowDecisionBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowDecisionBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowTerminalBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowTerminalBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDatabaseBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDatabaseBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowDataBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowDataBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowDocumentBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowDocumentBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TFlowInputBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TFlowInputBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDFDProcessBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDFDProcessBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDFDInterfaceBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDFDInterfaceBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TDFDDataStoreBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TDFDDataStoreBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TUMLPackageBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TUMLPackageBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TUMLClassBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TUMLClassBlock ).LinkPoints[ iParPointDestino ];
      if sNameDCDestino = UpperCase( 'TChevronArrowBlock' ) then
         TargetLinkPoint.AnchorLink := ( DiagramControlDestino as TChevronArrowBlock ).LinkPoints[ iParPointDestino ];
   end;
end;

procedure GlbLinkPoints( iParNumLinea: Integer;
   sParNFisicoBlock: String;
   iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
   sParNameOrigen, sParNameDestino: String;
   iParPointOrigen, iParPointDestino: Smallint;
   slParLinkPoint: TStringList;
   sParTipoFlecha, sParTipoLinea, sParEstiloLinea: String );
//sParTipoFlecha: asDiamond, asLineArrow, asSolidArrow... etc.;
//sParTipoLinea: TDiagramSideLine, TDiagramLine
//sParEstiloLinea: psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame

   procedure ObtenerDatosBlock( sParBlock: String;
      var iParLeft, iParTop, iParWidth, iParHeight: Double );
   var
      i: Integer;
   begin
      iParLeft := 0;
      iParTop := 0;
      iParWidth := 0;
      iParHeight := 0;

      for i := 0 to length( aGlbBlockAtributos ) - 1 do
         if aGlbBlockAtributos[ i ].NFisicoBlock = sParBlock then begin
            iParLeft := aGlbBlockAtributos[ i ].Columna;
            iParTop := aGlbBlockAtributos[ i ].Renglon;
            iParWidth := aGlbBlockAtributos[ i ].Ancho;
            iParHeight := aGlbBlockAtributos[ i ].Alto;

            Break;
         end;
   end;
var
   iLeftOrigen, iTopOrigen, iWidthOrigen, iHeightOrigen: Double;
   iLeftDestino, iTopDestino, iWidthDestino, iHeightDestino: Double;
begin
   iWidthOrigen := 0;
   iWidthDestino := 0;

   if sParNameOrigen = sParNFisicoBlock then begin
      iLeftOrigen := iParColumna;
      iTopOrigen := iParRenglon;
      iWidthOrigen := iParAncho;
      iHeightOrigen := iParAlto;

      ObtenerDatosBlock( sParNameDestino,
         iLeftDestino, iTopDestino, iWidthDestino, iHeightDestino );
   end;

   if sParNameDestino = sParNFisicoBlock then begin
      ObtenerDatosBlock( sParNameOrigen,
         iLeftOrigen, iTopOrigen, iWidthOrigen, iHeightOrigen );

      iLeftDestino := iParColumna;
      iTopDestino := iParRenglon;
      iWidthDestino := iParAncho;
      iHeightDestino := iParAlto;
   end;

   if ( iWidthOrigen = 0 ) or ( iWidthDestino = 0 ) then
      Exit;

   {//calcular Orx Origen
   if iParPointOrigen = 1 then begin
      iLeftOrigen := iLeftOrigen + ( iWidthOrigen / 2 );
      iTopOrigen := iTopOrigen + iHeightOrigen;

      iLeftDestino := iLeftDestino + ( iWidthDestino / 2 );
      iTopDestino := iTopDestino;
   end;

   if iParPointOrigen = 2 then begin
      iLeftOrigen := iLeftOrigen;
      iTopOrigen := iTopOrigen + ( iHeightOrigen / 2 );

      iLeftDestino := iLeftDestino + iWidthDestino;
      iTopDestino := iTopDestino + ( iHeightDestino / 2 );
   end;

   if iParPointOrigen = 3 then begin
      iLeftOrigen := iLeftOrigen + iWidthOrigen;
      iTopOrigen := iTopOrigen + ( iHeightOrigen / 2 );

      iLeftDestino := iLeftDestino;
      iTopDestino := iTopDestino + ( iHeightDestino / 2 );
   end;}

   //slParLinkPoint.Add( '  object DiagramSideLine' + IntToStr( iParNumLinea ) + ': ' + sParTipoLinea );
   slParLinkPoint.Add( '  object DiagramSideLine' + IntToStr( iParNumLinea ) + ': ' + sParTipoLinea );
   slParLinkPoint.Add( '    Pen.Style = ' + sParEstiloLinea );
   slParLinkPoint.Add( '    SelPen.Style = ' + sParEstiloLinea );
   slParLinkPoint.Add( '    SelPen.Color = clRed' ); //resalta la linea al seleccionarla
   slParLinkPoint.Add( '    SelPen.Width = 4' ); //resalta la linea al seleccionarla
   slParLinkPoint.Add( '    TargetArrow.Shape = ' + sParTipoFlecha );
   slParLinkPoint.Add( '    TargetArrow.Width = 7' );
   slParLinkPoint.Add( '    TargetArrow.Height = 7' );
   slParLinkPoint.Add( '    Handles = <' );
   slParLinkPoint.Add( '      item' );
   slParLinkPoint.Add( '        OrX = ' + FloatToStr( iLeftOrigen ) );
   slParLinkPoint.Add( '        OrY = ' + FloatToStr( iTopOrigen ) );
   slParLinkPoint.Add( '      end' );
   slParLinkPoint.Add( '      item' );
   slParLinkPoint.Add( '        OrX = ' + FloatToStr( iLeftDestino ) );
   slParLinkPoint.Add( '        OrY = ' + FloatToStr( iTopDestino ) );
   slParLinkPoint.Add( '      end>' );
   slParLinkPoint.Add( '    LinkPoints = <' );
   slParLinkPoint.Add( '      item' );
   slParLinkPoint.Add( '        Anchor = __DSOwner___.' + sParNameOrigen );
   slParLinkPoint.Add( '        AnchorIndex = ' + IntToStr( iParPointOrigen ) );
   slParLinkPoint.Add( '      end' );
   slParLinkPoint.Add( '      item' );
   slParLinkPoint.Add( '        Anchor = __DSOwner___.' + sParNameDestino );
   slParLinkPoint.Add( '        AnchorIndex = ' + IntToStr( iParPointDestino ) );
   slParLinkPoint.Add( '      end>' );
   slParLinkPoint.Add( '  end' );
end;

procedure GlbNoSelecLink( atParDiagrama: TatDiagram; ParADControl: TDiagramControl );
var
   iTotalSelect: Integer;
   sClassName: String;
begin
   iTotalSelect := atParDiagrama.SelectedCount( );

   if iTotalSelect = 1 then
      Exit;

   sClassName := UpperCase( ParADControl.ClassName );

   if sClassName = 'TDIAGRAMLINE' then
      ( ParADControl as TDiagramLine ).Selected := False;

   if sClassName = 'TDIAGRAMSIDELINE' then
      ( ParADControl as TDiagramSideLine ).Selected := False;

   if sClassName = 'TDIAGRAMARC' then
      ( ParADControl as TDiagramArc ).Selected := False;

   if sClassName = 'TDIAGRAMBEZIER' then
      ( ParADControl as TDiagramBezier ).Selected := False;

   if sClassName = 'TDIAGRAMPOLYLINE' then
      ( ParADControl as TDiagramPolyLine ).Selected := False;
end;

function indica_doc_a(): integer;    //para mandar el indicador al producto que lo pida ptsdiagjcl   alk
begin
   Result:=doc_auto;
end;

procedure indica_doc_auto(indicador : integer);   //para indicar cuando viene de la documentacion
begin
   doc_auto:=indicador;    //1 - doc auto    -     0 - arbol
end;

procedure GlbExportarDgr_A_WMF( atParDiagrama: TatDiagram; sParArchivoSalida: String );
var
   atDiagrama: TatDiagram;
   sel : integer;
begin
   if atParDiagrama = nil then
      Exit;
   try
      atParDiagrama.ExportAsWMF( sParArchivoSalida, esStandard );
   except
      on E : Exception do begin              // aviso alk
         if doc_auto <> 1 then  //si no viene de documentacion automatica, mostrar el mensaje
            sel:= MessageDlg('AVISO: El tamaño excede el limite para exportar'+chr(13)+
                             'a formatos como WMF, PDF y Visio.'+chr(13)+chr(13)+
                             'Se recomienda:'+chr(13)+
                             '1. Utilizar la impresora del sistema: '+chr(13)+
                             '       En el menú Archivo, la opcion Imprimir.'+chr(13)+
                             '2. Exportar a Excel:'+chr(13)+
                             '       En el menú Exportar, la opcion Excel.',
                             mtInformation,[mbOk],0);

        {
         sel:= MessageDlg('AVISO: El tamaño excede el limite para impresion WMF'+chr(13)+chr(13)+'¿Desea utilizar la impresora del sistema?',
                        mtInformation,[mbYes,mbNo],0);

         if sel = idYes then begin
{            try
               atDiagrama.Print( True );
            except
               on E : Exception do begin}
//                  atDiagrama.PrintSettings.Copies:=1;
                  //atDiagrama.PrintSettings.PageNumbers:='';
//                  atDiagrama.Print( True );          //codigo para mandar llamar la impresora de microsoft
               {end
            end;}

      //   end;
      end;
   end;
end;

procedure GlbExportarDgr_A_VSD( sParArchivoWMF: String; sParArchivoSalida: String );
var
   AppVisio: OLEVariant;
   DocVisio: OLEVariant;
   visioPage: OLEVariant;
begin
   if not FileExists( sParArchivoWMF ) then
      Exit;

   if FileExists( sParArchivoSalida ) then
      Exit;

   AppVisio := CreateOleObject( 'Visio.InvisibleApp' );
   try
      DocVisio := AppVisio.Documents.Add( '' );
      try
         visioPage := AppVisio.ActiveWindow.Page;
         visioPage.Import( sParArchivoWMF ); //Importar archivo WMF

         try
            visioPage.ResizeToFitContents; //Ajuste Automatico de la pagina
         except
         end;

         DocVisio.SaveAs( sParArchivoSalida ); //Guardar como archivo VSD
      finally
         try
            DocVisio.Close; //Cerrar Documento
         except
         end;
      end;
   finally
      try
         AppVisio.Quit; //Cerrar Visio
      except
      end;
   end;
end;

procedure GlbExportarDgr_A_PDF( sParArchivoWMF: String; sParArchivoSalida: String );
const
   visFixedFormatPDF = 1; //visFixedFormatXPS = 2;
   visPrintAll = 0;
   //visPrintAll = 1;
   visDocExIntentPrint = 3;
var
   AppVisio: OLEVariant;
   DocVisio: OLEVariant;
   visioPage: OLEVariant;
begin
   if not FileExists( sParArchivoWMF ) then
      Exit;

   if FileExists( sParArchivoSalida ) then
      Exit;

   AppVisio := CreateOleObject( 'Visio.InvisibleApp' );
   try
      DocVisio := AppVisio.Documents.Add( '' );
      try
         visioPage := AppVisio.ActiveWindow.Page;
         visioPage.Import( sParArchivoWMF ); //Importar archivo WMF

         try
            visioPage.ResizeToFitContents; //Ajuste Automatico de la pagina
         except
         end;

         try
            //Exportar a PDF
            DocVisio.ExportAsFixedFormat(
               visFixedFormatPDF, sParArchivoSalida, visDocExIntentPrint, visPrintAll );
         except
         end;

      finally
         try
            DocVisio.Saved := True;
            DocVisio.Close; //Cerrar Documento
         except
         end;
      end;
   finally
      try
         AppVisio.Quit; //Cerrar Visio
      except
      end;
   end;
end;

function sGlbExportarDiagramaDialogo( exParTipoExport: TTipoExport;
   atParDiagrama: TatDiagram; sParNombreArchivo: String ): String;
var
   SaveDialog: TSaveDialog;
begin
   SaveDialog := TSaveDialog.Create( atParDiagrama );
   try
      with SaveDialog do begin
         InitialDir := GlbObtenerRutaMisDocumentos;

         case exParTipoExport of
            exDiagrama: begin
                  DefaultExt := '.dgr';
                  Filter := 'Diagramas (*.dgr)|*.dgr';
               end;
            exExcel: begin
                  DefaultExt := '.xls';
                  Filter := 'Archivos de Excel(*.xls)|*.xls';
               end;
            exImgWMF: begin
                  DefaultExt := '.wmf';
                  Filter := 'Formato de imagen WMF(*.wmf)|*.wmf';
               end;
            exVisio: begin
                  DefaultExt := '.vsd';
                  Filter := 'Archivos de Visio(*.vsd)|*.vsd';
               end;
            exPDF: begin
                  DefaultExt := '.pdf';
                  Filter := 'Archivos PDF(*.pdf)|*.pdf';
               end;
         end;

         bGlbQuitaCaracteres( sParNombreArchivo );

         FileName := sParNombreArchivo + DefaultExt;

         if Execute then
            Result := FileName
         else
            Result := '';
      end;
   finally
      SaveDialog.Free;
   end;
end;

procedure GlbDiagramaSubTitulo( atParDiagrama: TatDiagram; sParSubTitulo: String );
begin
   if Trim( sParSubtitulo ) <> '' then
      GlbBlockFlow( atParDiagrama, 'TextBlock', 'SUBTITULO', 5, 5, 600, 20, clNone, clBlack, sParSubtitulo );
end;

procedure GlbBlockFlow( atParDiagrama: TatDiagram; sParTipoBlock: String;
   sParName: String; //nombre componente
   dParLeft, dParTop, dParWidth, dParHeight: Double; //posicion y tamaño
   aParBlockColor, aParFontColor: TColor; //color: block y font
   sParTexto: String );
var
   TextBlock1: TTextBlock;
   FlowActionBlock1: TFlowActionBlock;
   FlowDecisionBlock1: TFlowDecisionBlock;
   FlowTerminalBlock1: TFlowTerminalBlock;
   DatabaseBlock1: TDatabaseBlock;
   FlowDataBlock1: TFlowDataBlock;
   FlowDocumentBlock1: TFlowDocumentBlock;
   FlowInputBlock1: TFlowInputBlock;
   FlowCommentBlock1: TFlowCommentBlock;
   FlowListBlock1: TFlowListBlock;

   DFDProcessBlock1: TDFDProcessBlock;
   DFDInterfaceBlock1: TDFDInterfaceBlock;
   DFDDataStoreBlock1: TDFDDataStoreBlock;

   UMLPackageBlock1: TUMLPackageBlock;
   UMLClassBlock1: TUMLClassBlock;

   ChevronArrowBlock1: TChevronArrowBlock;

   ///
   Operaciones: TUMLOperations;
   Parametros: TUMLParameters;
   iCount: Integer;
begin
   if UpperCase( sParTipoBlock ) = UpperCase( 'TextBlock' ) then begin
      TextBlock1 := TTextBlock.Create( atParDiagrama.Owner );
      with TextBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         MinWidth := 20;
         MinHeight := 20;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'Tahoma';
         if Length(sParTexto) < 30 then
            Font.Size := 8
         else
            Font.Size := 6;
         //Font.Style := [ fsBold ];
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         //Strings.Add( sParTexto );
         TextCells.Items[ 0 ].Text := sParTexto;
         TextCells.Items[ 0 ].Alignment := taLeftJustify;
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowActionBlock' ) then begin
      FlowActionBlock1 := TFlowActionBlock.Create( atParDiagrama.Owner );
      with FlowActionBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         MinWidth := 10;
         MinHeight := 10;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowDecisionBlock' ) then begin
      FlowDecisionBlock1 := TFlowDecisionBlock.Create( atParDiagrama.Owner );
      with FlowDecisionBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowTerminalBlock' ) then begin
      FlowTerminalBlock1 := TFlowTerminalBlock.Create( atParDiagrama.Owner );
      with FlowTerminalBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         MinWidth := 20;
         MinHeight := 20;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'DatabaseBlock' ) then begin
      DatabaseBlock1 := TDatabaseBlock.Create( atParDiagrama.Owner );
      with DatabaseBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowDataBlock' ) then begin
      FlowDataBlock1 := TFlowDataBlock.Create( atParDiagrama.Owner );
      with FlowDataBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowDocumentBlock' ) then begin
      FlowDocumentBlock1 := TFlowDocumentBlock.Create( atParDiagrama.Owner );
      with FlowDocumentBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowInputBlock' ) then begin
      FlowInputBlock1 := TFlowInputBlock.Create( atParDiagrama.Owner );
      with FlowInputBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowCommentBlock' ) then begin
      FlowCommentBlock1 := TFlowCommentBlock.Create( atParDiagrama.Owner );
      with FlowCommentBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         MinWidth := 20;
         MinHeight := 20;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'FlowListBlock' ) then begin
      FlowListBlock1 := TFlowListBlock.Create( atParDiagrama.Owner );
      with FlowListBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'DFDProcessBlock' ) then begin
      DFDProcessBlock1 := TDFDProcessBlock.Create( atParDiagrama.Owner );
      with DFDProcessBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'DFDInterfaceBlock' ) then begin
      DFDInterfaceBlock1 := TDFDInterfaceBlock.Create( atParDiagrama.Owner );
      with DFDInterfaceBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'DFDDataStoreBlock' ) then begin
      DFDDataStoreBlock1 := TDFDDataStoreBlock.Create( atParDiagrama.Owner );
      with DFDDataStoreBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'UMLPackageBlock' ) then begin
      UMLPackageBlock1 := TUMLPackageBlock.Create( atParDiagrama.Owner );
      with UMLPackageBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'UMLClassBlock' ) then begin
      UMLClassBlock1 := TUMLClassBlock.Create( atParDiagrama.Owner );

      with UMLClassBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := dParWidth; //80 default
         Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         //ShowOperations := False;
         //ShowParameters := True;
         Strings.Clear;
         Strings.Add( sParTexto );
      end;
   end;

   if UpperCase( sParTipoBlock ) = UpperCase( 'ChevronArrowBlock' ) then begin
      ChevronArrowBlock1 := TChevronArrowBlock.Create( atParDiagrama.Owner );
      with ChevronArrowBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         Width := 100;
         Height := 50;
         ShaftLength := 10;
         ShaftWidth := 80;
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         if Length(sParTexto) < 30 then
            Font.Size := 6
         else
            Font.Size := 4;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         Strings.Clear;
         Strings.Add( sParTexto );
      end;
   end;
end;

procedure GlbBlockFlow( atParDiagrama: TatDiagram;
   sParTipoBlock: String;
   sParName: String; //nombre componente
   dParLeft, dParTop, dParWidth, dParHeight: Double; //posicion y tamaño
   aParBlockColor, aParFontColor: TColor; //color: block y font
   sParTexto: String;
   slParAtributos, slParOperaciones: TStringList ); overload;

//slParAtributos = PCPROG,HCPROG,EXTERNO,MODO
//slParOperaciones = PCPROG,HCPROG,EXTERNO,MODO,COMENT
var
   i: Integer;
   UMLClassBlock1: TUMLClassBlock;

   Operaciones: TUMLOperations;
   //Parametros: TUMLParameters;

   slAtributo: TStringList;
   slOperacion: TStringList;

   sSignoVisibility: String;
begin
   if UpperCase( sParTipoBlock ) = UpperCase( 'UMLClassBlock' ) then begin
      UMLClassBlock1 := TUMLClassBlock.Create( atParDiagrama.Owner );

      with UMLClassBlock1 do begin
         Diagram := atParDiagrama;
         Name := sParName; //no se debe repetir el name
         Left := dParLeft;
         Top := dParTop;
         //Width := dParWidth; //80 default
         //Height := dParHeight; //40 default
         Color := aParBlockColor;
         Font.Color := aParFontColor;
         Font.Name := 'MS Sans Serif';
         Font.Size := 6;
         Restrictions := [ crNoRotation ]; //crNoRotation, crNoEdit, crNoDelete, ...
         //ShowAttributes := False;
         //ShowOperations := False;
         //ShowParameters := True;

         //TextCells.Items[ 0 ].Text := '1.' + sParTexto; //nombnre de la clase
         //TextCells.Items[ 1 ].Text := '2.' + sParTexto; //atributos o variables
         //TextCells.Items[ 2 ].Text := '3.' + sParTexto; //metodos u operaciones
         //TextCells.Items[ 3 ].Text := '4.' + sParTexto; //herencia

         UMLClassName := sParTexto;

         //Ingresa los atributos o variables
         slAtributo := TStringList.Create;
         try
            for i := 0 to slParAtributos.Count - 1 do begin
               slAtributo.Clear;
               slAtributo.CommaText := slParAtributos[ i ];

               if slAtributo[ 0 ] = UMLClassName then
                  with Attributes.Add do begin
                     Name := slAtributo[ 1 ];
                     TypeName := slAtributo[ 2 ];

                     Visibility := uvPrivate;
                     if LowerCase( slAtributo[ 3 ] ) = 'private' then // (-)
                        Visibility := uvPrivate
                     else if LowerCase( slAtributo[ 3 ] ) = 'public' then // (+)
                        Visibility := uvPublic
                     else if LowerCase( slAtributo[ 3 ] ) = 'protected' then // (#)
                        Visibility := uvProtected;
                  end;
            end;
         finally
            slAtributo.Free;
         end;

         //ingresa las operaciones o metodos
         slOperacion := TStringList.Create;
         Operaciones := TUMLOperations.Create( atParDiagrama.Owner, TUMLOperation );
         try
            for i := 0 to slParOperaciones.Count - 1 do begin
               slOperacion.Clear;
               slOperacion.CommaText := slParOperaciones[ i ];

               if slOperacion[ 0 ] = UMLClassName then
                  with Operaciones.Add do begin
                     Name := slOperacion[ 1 ];
                     ReturnType := slOperacion[ 2 ];

                     Visibility := uvPrivate;
                     sSignoVisibility := '-';

                     if LowerCase( slOperacion[ 3 ] ) = 'private' then begin // (-)
                        Visibility := uvPrivate;
                        sSignoVisibility := '-';
                     end
                     else if LowerCase( slOperacion[ 3 ] ) = 'public' then begin // (+)
                        Visibility := uvPublic;
                        sSignoVisibility := '+';
                     end
                     else if LowerCase( slOperacion[ 3 ] ) = 'protected' then begin // (#)
                        Visibility := uvProtected;
                        sSignoVisibility := '#';
                     end;

                     CustomText :=
                        sSignoVisibility + ' ' +
                        slOperacion[ 1 ] + '(' +
                        slOperacion[ 4 ] + '): ' +
                        slOperacion[ 2 ];
                  end;
            end;

            {Parametros := TUMLParameters.Create( atParDiagrama.Owner, TUMLParameter );
            with Parametros.Add do begin
               Name := 'param1';
               ParamType := 'date';
            end;

            Parametros.Insert( 0 );
            Parametros.Items[ 0 ].Name := 'param1';
            Parametros.Items[ 0 ].ParamType := 'date';
            Parametros.Items[ 0 ].DisplayName := 'pp';
            Parametros.Items[ 0 ].CustomText := 'xyz';

            Parameters := Parametros;
            Operaciones[ 0 ].Parameters := Parametros;}

            //asigna las operaciones a UMLClassBlock1.Operations
            Operations := Operaciones;

         finally
            slOperacion.Free;
            Operaciones.Free;
         end;
      end;
   end;
end;

procedure dgr_clasecolor( clase: string; colorw: string );
var
   k: integer;
begin
   k := length( dgrcol );
   setlength( dgrcol, k + 1 );
   dgrcol[ k ].clase := clase;
   dgrcol[ k ].color := colorw;
   dgrcol[ k ].wColor := StringToColor( colorw ); //'clNone' ); //'$0000FF00' ); //10092543;
end;

function dgr_ccolor( clase: string ): TColor;
var
   i: integer;
begin
   dgr_ccolor := StringToColor( '$00FCFCFC' ); //'$0000FF00' ); //10092543;

   for i := 0 to length( dgrcol ) - 1 do
      if dgrcol[ i ].clase = clase then begin
         dgr_ccolor := dgrcol[ i ].wColor;
         Break;
      end;
end;

function dgr_repetido(
   clase: string; bib: string; prog: string; sis: string; ren: integer; col: integer; sParNombreBlock: String ): Integer;
var
   i, k: integer;
begin
   for i := 0 to length( dgrcom ) - 1 do begin
      if ( dgrcom[ i ].clase = clase ) and
         ( dgrcom[ i ].bib = bib ) and
         ( dgrcom[ i ].prog = prog ) and
         ( dgrcom[ i ].sistema = sis ) then begin
         dgr_repetido := i;
         Exit;
      end;
   end;

   k := length( dgrcom );
   setlength( dgrcom, k + 1 );
   dgrcom[ k ].clase := clase;
   dgrcom[ k ].bib := bib;
   dgrcom[ k ].prog := prog;
   dgrcom[ k ].sistema := sis;
   dgrcom[ k ].ren := ren;
   dgrcom[ k ].col := col;
   dgrcom[ k ].desplaza := -1;
   dgrcom[ k ].NombreBlock := sParNombreBlock;
   dgr_repetido := -1;
end;

procedure RegistraBlockDgrBloques(
   sParClase, sParBib, sParProg: String;
   iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
   sParNFisicoBlock, sParNLogicoBlock: String;
   sParTipoBlock: String;
   sParLigaBlockOrigen, sParLigaBlockDestino: String;
   tParColor: TColor;
   sParTexto: String;
   sParEntProSal: String );
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
   aGlbBlockAtributos[ iLongitudArreglo ].EntProSal := sParEntProSal;
end;

procedure LogicaArmadoDgrBloques( sParSistema, sParClase, sParBib, sParProg: String );
var
   i: Integer;
   sNombreBlockOrigen: String;
   sNombreBlockDestino: String;
   wColor: TColor;
   iRenglon: Integer;
   iColumna: Integer;
   sTipoBlock: String;
   sTexto: String;
   existentes_e,existentes_s : TStringList;
begin
   existentes_e:= TStringList.Create;
   existentes_s:= TStringList.Create;

   //obtiene datos de Tsrela y los deposita en aGLBTsrela
   //dm.TaladrarTsrela( DrillDown, sParSistema, sParProg, sParBib, sParClase, not bREGISTRA_REPETIDOS );

   { :::::  Cambio ALK para utilizar el procedimiento de Carlos ::::: }
   ConsultaDgrBloques(sParSistema, sParProg, sParBib, sParClase);

   iGlbRenglon := 50;
   iGlbColumna := 250;
   iGlbAncho := 100;
   iGlbAlto := 50;
   iGlbEspacioEntreColumnas := 100;
   iGlbEspacioEntreRenglones := 20;

   inc( iGlbNombreBlock );
   sNombreBlockOrigen := '_' + IntToStr( iGlbNombreBlock ) + '_UMLPAQ';
   RegistraBlockDgrBloques(
      sParClase, sParBib, sParProg,
      iGlbColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
      sNombreBlockOrigen, sParClase + '|' + sParBib + '|' + sParProg,
      'FlowActionBlock',
      '', '', $FF8080, sParProg, 'P' );

   //--------------- Entradas
   iGlbRenglon := 50;
   iRenglon := iGlbRenglon;

   for i := 0 to Length( aGLBTsrela ) - 1 do begin
      if ( aGLBTsrela[ i ].sHCCLASE = 'BMS' ) or

         ( aGLBTsrela[ i ].sHCCLASE = 'FDV' ) or

      ( ( aGLBTsrela[ i ].sHCCLASE = 'TAB' ) or
         ( aGLBTsrela[ i ].sHCCLASE = 'UPD' ) or
         ( aGLBTsrela[ i ].sHCCLASE = '' ) or
         ( aGLBTsrela[ i ].sHCCLASE = 'DEL' ) ) or

      ( ( aGLBTsrela[ i ].sHCCLASE = 'LOC' ) and
         ( ( aGLBTsrela[ i ].sMODO = 'I' ) or
         ( aGLBTsrela[ i ].sMODO = 'U' ) or
         ( aGLBTsrela[ i ].sMODO = '' ) or
         ( aGLBTsrela[ i ].sMODO = 'A' ) ) ) then begin

         wColor := $00FCFCFC; //default
         sTipoBlock := 'FlowActionBlock'; //default

         if ( aGLBTsrela[ i ].sHCCLASE = 'FDV' ) then begin
            wColor := $EEEEAF;
            sTipoBlock := 'DFDInterfaceBlock';
            sTexto := aGLBTsrela[ i ].sHCPROG+'_FDV';
         end;


         if ( aGLBTsrela[ i ].sHCCLASE = 'TAB' ) or
            ( aGLBTsrela[ i ].sHCCLASE = 'UPD' ) or
            ( aGLBTsrela[ i ].sHCCLASE = 'DEL' ) then begin
            wColor := 16770229;
            sTipoBlock := 'DatabaseBlock';
         end
         else begin
            if aGLBTsrela[ i ].sHCCLASE = 'LOC' then begin
               wColor := $D8BFD8;
               sTipoBlock := 'ChevronArrowBlock';
            end
            else begin
               if aGLBTsrela[ i ].sHCCLASE = 'BMS' then begin
                  wColor := 10092543;
                  sTipoBlock := 'FlowInputBlock';
               end;
            end;
         end;

         iColumna := iGlbColumna - iGlbAncho - iGlbEspacioEntreColumnas;

         if sTipoBlock = 'DatabaseBlock' then begin             // le pone el contenido al bloque del diagrama
            //--que le ponga la palabra completa, lado izquierdo
            if aGLBTsrela[ i ].sHCCLASE = 'TAB' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Select'
            else if aGLBTsrela[ i ].sHCCLASE = 'DEL' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Delete'
            else if aGLBTsrela[ i ].sHCCLASE = 'UPD' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Update'
            else if aGLBTsrela[ i ].sHCCLASE = 'INS' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Insert'
            else
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: ' + aGLBTsrela[ i ].sHCCLASE;
         end;
         if sTipoBlock = 'ChevronArrowBlock' then begin
            //--que le ponga la palabra completa, lado izquierdo
            if aGLBTsrela[ i ].sHCCLASE = 'LOC' then begin
               if aGLBTsrela[ i ].sMODO = 'I' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Input'
               else if aGLBTsrela[ i ].sMODO = 'O' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Output'
               else if aGLBTsrela[ i ].sMODO = 'U' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: I-O'
               else if aGLBTsrela[ i ].sMODO = 'A' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Append'
               else if aGLBTsrela[ i ].sMODO = '' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Null'
               else
                  sTexto := aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: ' + aGLBTsrela[ i ].sHCCLASE + '; ' + 'Tipo: ' + aGLBTsrela[ i ].sORGANIZACION + '; ' + 'Archivo: ' + aGLBTsrela[ i ].sEXTERNO;
            end;
         end;
         if sTipoBlock = 'FlowInputBlock' then begin
            sTexto := aGLBTsrela[ i ].sHCPROG;
         end;


         inc( iGlbNombreBlock );
         sNombreBlockDestino := '_' + IntToStr( iGlbNombreBlock ) + '_UMLPAQ';

         //------  Prueba ALK para evitar repetidos ---
         if existentes_e.IndexOf(sTexto) > -1 then
            sTexto:='XXX'
         else
            existentes_e.add(sTexto);
         //---------------------------------------------

         if sTexto <> 'XXX' then begin            // ALK
            if iRenglon <> iGlbRenglon then
               iGlbRenglon := iGlbRenglon + iGlbAlto + iGlbEspacioEntreRenglones;

            RegistraBlockDgrBloques(
               aGLBTsrela[ i ].sHCCLASE, aGLBTsrela[ i ].sHCBIB, aGLBTsrela[ i ].sHCPROG,
               iColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
               sNombreBlockDestino,
               aGLBTsrela[ i ].sHCCLASE + '|' + aGLBTsrela[ i ].sHCBIB + '|' + aGLBTsrela[ i ].sHCPROG,
               sTipoBlock,
               sNombreBlockOrigen, sNombreBlockDestino, wColor,
               sTexto, 'E' );

            iRenglon := iRenglon + 1;
         end;

      end;
   end;

   //--------------- Salidas
   iGlbRenglon := 50;
   iRenglon := iGlbRenglon;

   for i := 0 to Length( aGLBTsrela ) - 1 do begin
      if ( ( aGLBTsrela[ i ].sHCCLASE = 'INS' ) or
         ( aGLBTsrela[ i ].sHCCLASE = 'UPD' ) or
         ( aGLBTsrela[ i ].sHCCLASE = 'DEL' ) ) or

      ( ( aGLBTsrela[ i ].sHCCLASE = 'LOC' ) and
         ( ( aGLBTsrela[ i ].sMODO = 'O' ) or
         ( aGLBTsrela[ i ].sMODO = 'U' ) or
         ( aGLBTsrela[ i ].sMODO = 'A' ) ) ) then begin

         wColor := $00FCFCFC; //default
         sTipoBlock := 'FlowActionBlock'; //default

         if ( aGLBTsrela[ i ].sHCCLASE = 'INS' ) or
            ( aGLBTsrela[ i ].sHCCLASE = 'UPD' ) or
            ( aGLBTsrela[ i ].sHCCLASE = 'DEL' ) then begin
            wColor := 16770229;
            sTipoBlock := 'DatabaseBlock';
         end
         else if aGLBTsrela[ i ].sHCCLASE = 'LOC' then begin
            wColor := $D8BFD8;
            sTipoBlock := 'ChevronArrowBlock';
         end;

         iColumna := iGlbColumna + iGlbAncho + iGlbEspacioEntreColumnas;

         if sTipoBlock = 'DatabaseBlock' then begin
            //--que le ponga la palabra completa, lado derecho   diagrama de bloques
            if aGLBTsrela[ i ].sHCCLASE = 'TAB' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Select'
            else if aGLBTsrela[ i ].sHCCLASE = 'DEL' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Delete'
            else if aGLBTsrela[ i ].sHCCLASE = 'UPD' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Update'
            else if aGLBTsrela[ i ].sHCCLASE = 'INS' then
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Insert'
            else
               sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: ' + aGLBTsrela[ i ].sHCCLASE;
         end
         else if sTipoBlock = 'ChevronArrowBlock' then begin
            //--que le ponga la palabra completa, lado izquierdo
            if aGLBTsrela[ i ].sHCCLASE = 'LOC' then begin
               if aGLBTsrela[ i ].sMODO = 'I' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Input'
               else if aGLBTsrela[ i ].sMODO = 'O' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Output'
               else if aGLBTsrela[ i ].sMODO = 'U' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: I-O'
               else if aGLBTsrela[ i ].sMODO = 'A' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Append'
               else if aGLBTsrela[ i ].sMODO = '' then
                  sTexto :=aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: Null'
               else
                  sTexto := aGLBTsrela[ i ].sHCPROG + '; ' + 'Modo: ' + aGLBTsrela[ i ].sHCCLASE + '; ' + 'Tipo: ' + aGLBTsrela[ i ].sORGANIZACION + '; ' + 'Archivo: ' + aGLBTsrela[ i ].sEXTERNO;
            end;
         end;
         inc( iGlbNombreBlock );
         sNombreBlockDestino := '_' + IntToStr( iGlbNombreBlock ) + '_UMLPAQ';

         //------  Prueba ALK para evitar repetidos ---
         if existentes_s.IndexOf(sTexto) > -1 then
            sTexto:='XXX'
         else
            existentes_s.add(sTexto);
         //---------------------------------------------
         if sTexto <> 'XXX' then begin            // ALK
            if iRenglon <> iGlbRenglon then
               iGlbRenglon := iGlbRenglon + iGlbAlto + iGlbEspacioEntreRenglones;

            RegistraBlockDgrBloques(
               aGLBTsrela[ i ].sHCCLASE, aGLBTsrela[ i ].sHCBIB, aGLBTsrela[ i ].sHCPROG,
               iColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
               sNombreBlockDestino,
               aGLBTsrela[ i ].sHCCLASE + '|' + aGLBTsrela[ i ].sHCBIB + '|' + aGLBTsrela[ i ].sHCPROG,
               sTipoBlock,
               sNombreBlockOrigen, sNombreBlockDestino, wColor,
               sTexto, 'S' );

            iRenglon := iRenglon + 1
         end;
      end;
   end;
end;

procedure GlbArmaDiagramaBloques( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String; sParSistema: String; sParSubtitulo: String );
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
   LogicaArmadoDgrBloques( sParSistema, sParClase, sParBib, sParProg );

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

   //crea las ligas con metodos directos
   for i := 0 to length( aGlbBlockAtributos ) - 1 do
      with aGlbBlockAtributos[ i ] do
         if ( LigaBlockOrigen <> '' ) and
            ( LigaBlockDestino <> '' ) then
            if EntProSal = 'E' then begin
               if TipoBlock = 'DatabaseBlock' then
                  GlbLinkPoints( atParDiagrama,
                     LigaBlockDestino, LigaBlockOrigen, 3, 2, asLineArrow, psSolid )
               else if TipoBlock = 'ChevronArrowBlock' then
                  GlbLinkPoints( atParDiagrama,
                     LigaBlockDestino, LigaBlockOrigen, 1, 2, asLineArrow, psSolid )
               else if TipoBlock= 'DFDInterfaceBlock' then
                  GlbLinkPoints( atParDiagrama,
                     LigaBlockDestino, LigaBlockOrigen, 3, 2, asLineArrow, psSolid )
               else if TipoBlock = 'FlowInputBlock' then
                  GlbLinkPoints( atParDiagrama,
                     LigaBlockDestino, LigaBlockOrigen, 2, 2, asLineArrow, psSolid );
            end
            else if EntProSal = 'S' then begin
               if TipoBlock = 'DatabaseBlock' then
                  GlbLinkPoints( atParDiagrama,
                     LigaBlockOrigen, LigaBlockDestino, 3, 2, asLineArrow, psSolid )
               else if TipoBlock = 'ChevronArrowBlock' then
                  GlbLinkPoints( atParDiagrama,
                     LigaBlockOrigen, LigaBlockDestino, 3, 0, asLineArrow, psSolid );
            end;

   //reacomoda las lineas
   atParDiagrama.MoveBlocks( 1, 0, True );
   atParDiagrama.ClearUndoStack;
   //activa todas las paginas
   atParDiagrama.AutoScroll := False;
   atParDiagrama.AutoScroll := True;
end;

procedure RegistraBlockAImpacto(
   sParClase, sParBib, sParProg: String;
   iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
   iParDesplaza: Integer;
   sParNFisicoBlock, sParNLogicoBlock: String;
   sParTipoBlock: String;
   sParLigaBlockOrigen, sParLigaBlockDestino: String;
   tParColor: TColor;
   sParTexto: String );
var
   iLongitudArreglo: Integer;
   sColorV: Tcolor;
   iRenV: Integer;
   iColV: Integer;

begin
   // Registrar en arreglo aGlbBlockAtributos
   iLongitudArreglo := Length( aGlbBlockAtributos );

   IF iLongitudArreglo < 7800 THEN BEGIN //limite de bloques!!!  alk
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
      aGlbBlockAtributos[ iLongitudArreglo ].Desplaza := iParDesplaza;
   end
   else begin
      showmessage('REbasa');
   END;

   if sParTipoBlock <> 'FlowTerminalBlock' then begin
      sColorV := dgr_ccolor( sParClase );
      iRenV := Round( iParRenglon / 10 ) + 2;
      iColV := Round( iParColumna / 10 );
      iColV := Trunc( iColV / 10 ) + 1;

      sParProg := StringReplace( sParProg, '"', '', [ rfReplaceAll ] ); //aqui juanita
      sParProg := StringReplace( sParProg, ';', '', [ rfReplaceAll ] ); //aqui juanita

      dgryy.add(
         'D' + ' ' +
         Q + sParClase + '|' +
         sParBib + '|' +
         sParProg + Q + ' ' + inttostr( iColV ) +
         ' ' + inttostr( iRenV ) + ' ' + colortostring( sColorV ) );
   end;
end;

procedure TaladrarAImpacto( pclase: string; pbib: string; pprog: string;
   clase: string; bib: string; prog: string; Sis: string;
   renglon: integer; columna: integer; tabla: string; sParNombreBlockLink: String );
//coment: string );
var
   k, despla, xnum_regs, iRenV, iColV, n,nn: integer;
   tipo, nom, tamano: string;
   bas: string;
   qq: Tadoquery;
   qa: Tadoquery;
   sNombreBlock: String;
   sNombreBlockTerminal: String;
   sSistema: String;
   consulta: String;
   sqlclasehijo:string;
begin
   tipo := clase;
   nom := bib + ' ' + prog;
   tamano := '6';
   if clase = 'STE' then begin
      k := pos( '_', nom );
      nom := copy( nom, k + 1, 100 );
      k := pos( '_', nom );
      nom := copy( nom, k + 1, 100 );
      tamano := '8';
   end
   else begin
      if es_bbva then begin
         tipo := copy( bib, 4, 3 );
         nom := prog;
         tamano := '8';
      end;
   end;

   inc( iNombre );
   sNombreBlock := 'AI_' + IntToStr( iNombre );
   //registrar en memoria
   RegistraBlockAImpacto(
      Trim( Clase ), Trim( Bib ), Trim( Prog ),
      columna, renglon, ancho, alto, 0,
      sNombreBlock, Trim( Prog ) + '|' + Trim( Bib ) + '|' + Trim( Clase ),
      'FlowActionBlock',
      sNombreBlock, sParNombreBlockLink, dgr_ccolor( clase ), tipo + ' ' + nom );

   k := dgr_repetido( clase, bib, prog, sis, renglon, columna, sNombreBlock );
   if k <> -1 then begin //Ya existe
      if dgrcom[ k ].desplaza = -1 then begin
         dgrcom[ k ].desplaza := desplaza;
         desplaza := ( desplaza + 20 ) mod 180;
      end;

      inc( iNombre );
      sNombreBlockTerminal := 'AI_' + IntToStr( iNombre );
      //registrar en memoria
      RegistraBlockAImpacto(
         Trim( Clase ), Trim( Bib ), Trim( Prog ),
         columna + ancho + 20, renglon + 10, 20, 20, desplaza,
         sNombreBlockTerminal, Trim( Prog ) + '|' + Trim( Bib ) + '|' + Trim( Clase ),
         'FlowTerminalBlock',
         sNombreBlockTerminal, sNombreBlock, $00FCFCFC, inttostr( k ) );

      iRenV := Round( renglon / 10 ) + 1;

      iColV := Round( columna / 10 );
      iColV := Trunc( iColV / 10 ) + 1;
      dgryy.add( 'D' + ' ' + inttostr( k ) + ' ' + inttostr( iColV ) +
         ' ' + inttostr( iRenV ) + ' ' + '$00FDFDFD' );
   end
   else begin
      xnum_regs := 0;
      qq := Tadoquery.Create( nil );
      qq.Connection := dm.ADOConnection1;
      qa := Tadoquery.Create( nil );
      qa.Connection := dm.ADOConnection1;
      {if dm.sqlselect( qq, 'select distinct pcprog,pcbib,pcclase from ' + tabla +
         ' where hcprog=' + g_q + prog + g_q +
         ' and   hcbib=' + g_q + bib + g_q +
         ' and   hcclase=' + g_q + clase + g_q +
         ' and   pcclase<>' + g_q + 'CLA' + g_q +
         ' order by hcclase,hcbib,hcprog' ) then begin// se quita distinct por group by
      }

      prog:= stringreplace( trim( prog ), '(CICLADO)', '', [ rfReplaceAll ] );     //para que encuentre el componente  ALK
      if clase='TAB' then
         sqlclasehijo:=' and   hcclase in (' +
            g_q+'TAB'+g_q+','+
            g_q+'INS'+g_q+','+
            g_q+'UPD'+g_q+','+
            g_q+'DEL'+g_q+') '
      else
         sqlclasehijo:=' and   hcclase=' + g_q + clase + g_q;
      consulta:='select ' + '/*+ INDEX( TSRELA IDX_TSRELA_HIJO ) */' + ' pcprog,pcbib,pcclase ' +
         ' from ' + tabla +
         ' where ' + '/*+ INDEX( TSRELA IDX_TSRELA_HIJO) */' +
         ' hcprog=' + g_q + prog + g_q +
         ' and   hcbib=' + g_q + bib + g_q +
         sqlclasehijo +
         ' and   pcclase<>' + g_q + 'CLA' + g_q +
         ' group by pcprog,pcbib,pcclase ' +
         ' order by pcprog,pcbib,pcclase';
      //archivo_selects.Add(consulta);
      if dm.sqlselect( qq, consulta ) then begin
         xnum_regs := qq.Recordcount;
         // _______________ alk para limite de registros _________________________
         consulta:= 'select dato from parametro where clave='+ g_q +'LIMBLOQ'+ g_q;
         if dm.sqlselect(dm.q5, consulta) then
            n:= dm.q5.FieldByName( 'dato' ).AsInteger
         else
            n:=150;
         {     Pone circulo rojo con total de registros. Se cambia para que ponga los mayores a n
         if xnum_regs > n then begin
            inc( iNombre );
            sNombreBlockTerminal := 'AI_' + IntToStr( iNombre );
            //registrar en memoria
            RegistraBlockAImpacto(
               Trim( Clase ), Trim( Bib ), Trim( Prog ),
               columna + ancho + 20, renglon + 10, 20, 20, 0,
               sNombreBlockTerminal, Trim( Prog ) + '|' + Trim( Bib ) + '|' + Trim( Clase ),
               'FlowTerminalBlock',
               sNombreBlockTerminal, sNombreBlock, $004F4FFF, inttostr( xnum_regs ) + ' regs' );

            iRenV := Round( renglon / 10 ) + 1;
            iColV := Round( columna / 10 );
            iColV := Trunc( iColV / 10 ) + 1;
            dgryy.add( 'D' + ' ' + inttostr( xnum_regs ) + ' ' + inttostr( iColV ) +
               ' ' + inttostr( iRenV ) + ' ' + '$000404FF' );

            qq.Free;
            exit;
         end;
         }
         // __________________________________________________________________
         nn:=0;
         while not qq.Eof do begin
            inc(nn);
            if nn > n then begin
               inc( iNombre );
               sNombreBlockTerminal := 'AI_' + IntToStr( iNombre );
               //registrar en memoria
               RegistraBlockAImpacto(
                  Trim( Clase ), Trim( Bib ), Trim( Prog ),
                  columna + ancho + 20, iGLBRenglon + 70, 20, 20, 0,
                  sNombreBlockTerminal, Trim( Prog ) + '|' + Trim( Bib ) + '|' + Trim( Clase ),
                  'FlowTerminalBlock',
                  sNombreBlockTerminal, sNombreBlock, $004F4FFF, inttostr( xnum_regs-n ) + ' regs' );

               iRenV := Round( renglon / 10 ) + 1;
               iColV := Round( columna / 10 );
               iColV := Trunc( iColV / 10 ) + 1;
               dgryy.add( 'D' + ' ' + inttostr( xnum_regs ) + ' ' + inttostr( iColV ) +
                  ' ' + inttostr( iRenV ) + ' ' + '$000404FF' );

               qq.Free;
               exit;
            end;
            consulta:='select * from  tsrela ' +
               ' where pcprog=' + g_q + qq.FieldByName( 'pcprog' ).Asstring + g_q +
               ' and   pcbib=' + g_q + qq.FieldByName( 'pcbib' ).Asstring + g_q +
               ' and   pcclase=' + g_q + qq.FieldByName( 'pcclase' ).Asstring + g_q;
            //archivo_selects.Add(consulta);
            if dm.sqlselect( qa, consulta ) then begin
               sSistema := qa.FieldByName( 'sistema' ).Asstring;
            end;

            if ( pclase = qq.FieldByName( 'pcclase' ).Asstring ) and
               ( pbib = qq.FieldByName( 'pcbib' ).Asstring ) and
               ( pprog = qq.FieldByName( 'pcprog' ).Asstring ) then begin
               qq.Next;
               continue;
            end;
            {if qq.fieldbyname( 'coment' ).AsString = 'LIBRARY' then begin
               qq.Next;
               continue;
            end;}
            if renglon <> iGlbRenglon then
               iGlbRenglon := iGlbRenglon + alto + 20;

            TaladrarAImpacto( clase, bib, prog,
               qq.fieldbyname( 'pcclase' ).AsString,
               qq.fieldbyname( 'pcbib' ).AsString,
               qq.fieldbyname( 'pcprog' ).AsString,
               sSistema, iGlbRenglon, columna + ancho + 30, tabla, sNombreBlock );
            //qq.fieldbyname( 'coment' ).AsString );
            renglon := renglon + 1;
            qq.Next;
         end;
      end;
      qq.Free;
      qa.Free;
   end;
end;

procedure LogicaArmadoDgrAImpacto( sParClase, sParBib, sParProg, sParSistema: String );
var
   i, iRenV, iColV: Integer;
   xClave, xColorw: String;
   sNombreBlockTerminal: String;
begin
   //usado para generar archivo excel - en su momento quitar
   dgryy := Tstringlist.create;
   archivo_lista := trim(sParClase) + trim(sParBib) + trim(sParProg);
   bGlbQuitaCaracteres( archivo_lista );
   archivo_lista := g_tmpdir + '\Impacto' + archivo_lista;
   //fin usado para generar archivo ...

   try
      setlength( dgrcol, 0 );
      if dm.sqlselect( dm.q2, 'SELECT * FROM PARAMETRO WHERE CLAVE LIKE ' + g_q + 'WCOLOR_%' + g_q ) then begin
         while not dm.q2.Eof do begin
            xclave := copy( dm.q2.fieldbyname( 'CLAVE' ).AsString, 8, 3 );
            xcolorw := dm.q2.fieldbyname( 'DATO' ).AsString;
            dgr_clasecolor( xclave, xcolorw );
            dm.q2.Next;
         end;
      end;

      if dm.sqlselect( dm.q1, 'SELECT * FROM PARAMETRO ' +
         ' WHERE CLAVE=' + g_q + 'EMPRESA-NOMBRE-1' + g_q ) then
         es_bbva := ( copy( dm.q1.FieldByName( 'DATO' ).AsString, 1, 4 ) = 'BBVA' );

      iGlbRenglon := 40; //desde este renglon empieza a diagramar
      //TaladrarAImpacto( '', '', '', sParClase, sParBib, sParProg, sParSistema, iGlbRenglon, 20, 'tsrela', '', '' );
      TaladrarAImpacto( '', '', '', sParClase, sParBib, sParProg, sParSistema, iGlbRenglon, 20, 'tsrela', '' );

      for i := 0 to length( dgrcom ) - 1 do begin
         if dgrcom[ i ].desplaza <> -1 then begin
            inc( iNombre );

            sNombreBlockTerminal := 'AI_' + IntToStr( iNombre );
            // registrar en memoria
            RegistraBlockAImpacto(
               dgrcom[ i ].Clase, dgrcom[ i ].Bib, dgrcom[ i ].prog,
               dgrcom[ i ].col + ancho + 5, dgrcom[ i ].ren - 10, 20, 20, dgrcom[ i ].desplaza,
               sNombreBlockTerminal, dgrcom[ i ].prog + '|' + dgrcom[ i ].Bib + '|' + dgrcom[ i ].Clase,
               'FlowTerminalBlock',
               dgrcom[ i ].NombreBlock, sNombreBlockTerminal, $008AFFFF, inttostr( i ) );

            iRenV := Round( dgrcom[ i ].ren / 10 ) + 1;
            iColV := Round( dgrcom[ i ].col / 10 );
            iColV := Trunc( iColV / 10 ) + 1;
            dgryy.add( 'D' + ' ' + inttostr( i ) + ' ' + inttostr( iColV ) +
               ' ' + inttostr( iRenV ) + ' ' + '$0080FFFF' );
         end;
      end;

      dgryy.SaveToFile( archivo_lista );
      g_borrar.Add( archivo_lista );
      g_control := stringreplace( archivo_lista, g_tmpdir + '\Impacto', '', [ rfreplaceall ] );

   finally
      dgryy.Free;
   end;
end;

procedure GlbArmaDiagramaAImpacto( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String; sParSistema: String; sParSubtitulo: String );
var
   i: Integer;
   slLinkPoint: TStringList;
   slArchivoDGR: TStringList;
   sArchivoPaso1, sArchivoPaso2: String;
begin
   GlbNuevoDiagrama( atParDiagrama );

   iGlbNombreBlock := 0;
   SetLength( dgrcom, 0 ); //control para los repetidos, checar rutina y hacerla global
   SetLength( aGlbBlockAtributos, 0 );

   //crea subtitulo en atParDiagrama
   GlbDiagramaSubTitulo( atParDiagrama, sParSubtitulo );

   //logica de llenado de aGlbBlockAtributos y asignacion de renlones y columnas.
   LogicaArmadoDgrAImpacto( sParClase, sParBib, sParProg, sParSistema );

   //crea los block's
   for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      //with ftsmain.dxBarProgress do
         //if Visible = ivAlways then begin
         //   StepIt;
         //   ftsmain.Refresh
         //end;// crea rutina

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

   //crea las ligas a traves de un TStringList armado
   slLinkPoint := Tstringlist.Create;
   try
      for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
         if ( aGlbBlockAtributos[ i ].LigaBlockOrigen <> '' ) and
            ( aGlbBlockAtributos[ i ].LigaBlockDestino <> '' ) then
            if ( aGlbBlockAtributos[ i ].Color = $008AFFFF ) and
               ( aGlbBlockAtributos[ i ].TipoBlock = 'FlowTerminalBlock' ) then
               GlbLinkPoints( i,
                  aGlbBlockAtributos[ i ].NFisicoBlock,
                  aGlbBlockAtributos[ i ].Columna, aGlbBlockAtributos[ i ].Renglon,
                  aGlbBlockAtributos[ i ].Ancho, aGlbBlockAtributos[ i ].Alto,
                  aGlbBlockAtributos[ i ].LigaBlockOrigen, aGlbBlockAtributos[ i ].LigaBlockDestino, 3, 2,
                  slLinkPoint, 'asDiamond', 'TDiagramSideLine', 'psSolid' )
            else
               GlbLinkPoints( i,
                  aGlbBlockAtributos[ i ].NFisicoBlock,
                  aGlbBlockAtributos[ i ].Columna, aGlbBlockAtributos[ i ].Renglon,
                  aGlbBlockAtributos[ i ].Ancho, aGlbBlockAtributos[ i ].Alto,
                  aGlbBlockAtributos[ i ].LigaBlockOrigen, aGlbBlockAtributos[ i ].LigaBlockDestino, 2, 3,
                  slLinkPoint, 'asDiamond', 'TDiagramSideLine', 'psSolid' );
      end;

      //guardar dgr y pegarle el contenido de slLinkPoint
      sArchivoPaso1 := g_tmpdir + '\paso1.dgr';
      //sArchivoPaso := Caption + '.dgr';

      atParDiagrama.SaveToFile( sArchivoPaso1 );
      slArchivoDGR := Tstringlist.Create;
      try
         slArchivoDGR.LoadFromFile( sArchivoPaso1 );
         for i := 0 to slArchivoDGR.Count - 1 do begin //asi hace que las lineas sean send to back
            if pos( 'object SUBTITULO', slArchivoDGR[ i ] ) > 0 then begin
               slArchivoDGR[ i ] := slLinkPoint.Text + ' ' + slArchivoDGR[ i ];
               Break;
            end;
         end;
         sArchivoPaso2 := g_tmpdir + '\paso2.dgr';
         slArchivoDGR.SaveToFile( sArchivoPaso2 );
      finally
         slArchivoDGR.Free;
      end;

   finally
      slLinkPoint.Free;
   end;
   atParDiagrama.LoadFromFile( sArchivoPaso2 );
   DeleteFile( PChar( sArchivoPaso1 ) );
   DeleteFile( PChar( sArchivoPaso2 ) );
   /// fin de crea las ligas a traves de un TStringList armado (slLinkPoint)

   //reacomoda las lineas
   atParDiagrama.MoveBlocks( 1, 0, True );
   atParDiagrama.ClearUndoStack;
   //activa todas las paginas
   atParDiagrama.AutoScroll := False;
   atParDiagrama.AutoScroll := True;
end;

procedure RegistraBlockProcesos(
   sParClase, sParBib, sParProg, sParSistema: String;
   iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
   iParDesplaza: Integer;
   sParNFisicoBlock, sParNLogicoBlock: String;
   sParTipoBlock: String;
   sParLigaBlockOrigen, sParLigaBlockDestino: String;
   tParColor: TColor;
   sParTexto: String );
var
   iLongitudArreglo: Integer;
   sColorV: Tcolor;
   iRenV: Integer;
   iColV: Integer;

begin
   // Registrar en arreglo aGlbBlockAtributos
   iLongitudArreglo := Length( aGlbBlockAtributos );

   IF iLongitudArreglo < 7800 THEN BEGIN //aqui juanita
      SetLength( aGlbBlockAtributos, iLongitudArreglo + 1 );

      aGlbBlockAtributos[ iLongitudArreglo ].Clase := sParClase;
      aGlbBlockAtributos[ iLongitudArreglo ].Biblioteca := sParBib;
      aGlbBlockAtributos[ iLongitudArreglo ].Programa := sParProg;
      aGlbBlockAtributos[ iLongitudArreglo ].Sistema := sParSistema;
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
      aGlbBlockAtributos[ iLongitudArreglo ].Desplaza := iParDesplaza;
   END;

   if sParTipoBlock <> 'FlowTerminalBlock' then begin
      sColorV := dgr_ccolor( sParClase );
      iRenV := Round( iParRenglon / 10 ) + 2;
      iColV := Round( iParColumna / 10 );
      iColV := Trunc( iColV / 10 ) + 1;

      sParProg := StringReplace( sParProg, '"', '', [ rfReplaceAll ] ); //aqui juanita
      sParProg := StringReplace( sParProg, ';', '', [ rfReplaceAll ] ); //aqui juanita

      dgryy.add(
         'D' + ' ' +
         Q + sParClase + '|' +
         sParBib + '|' +
         sParProg + Q + ' ' + inttostr( iColV ) +
         ' ' + inttostr( iRenV ) + ' ' + colortostring( sColorV ) );
   end;
end;

procedure dgr_clasesDProcesos;
var
   lwInSQL, cons: string;
   prodclase, lwSale, Wuser, lwLista: String;
   m: tstringlist;
   j: Integer;
begin
   dgrfisicos := Tstringlist.Create;

   //if dm.sqlselect( dm.q1, 'select * from tsclase where diagramabloque=' + g_q + 'ACTIVO' + g_q +
      //' and  estadoactual =' + g_q + 'ACTIVO' + g_q + ' order by cclase' ) then begin
      //while not dm.q1.Eof do begin
         //dgrfisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
         //dm.q1.Next;
      //end;
   //end;

   Wuser := 'ADMIN'; //Temporal  JCR
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' +
      g_q + 'CLASESXPRODUCTO' + g_q ) then
      ProdClase := dm.q1.fieldbyname( 'dato' ).AsString;

   lwSale := 'FALSE';
   while lwSale = 'FALSE' do begin
      if ProdClase <> 'TRUE' then begin
         if dm.sqlselect( dm.q1, 'select * from tsclase where diagramabloque=' + g_q + 'ACTIVO' + g_q +
            ' and  estadoactual =' + g_q + 'ACTIVO' + g_q + ' order by cclase' ) then begin
            while not dm.q1.Eof do begin
               dgrfisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
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
            cons:='select distinct hcclase from tsrela ' +
               ' where hcclase in (' + lwInSQL + ')' + ' order by hcclase';
            if dm.sqlselect( dm.q2, cons ) then begin
               while not dm.q2.Eof do begin
                  cons:='select cclase,descripcion from tsclase ' +
                     ' where cclase = ' + g_q + dm.q2.fieldbyname( 'hcclase' ).AsString + g_q +
                     ' order by cclase';
                  if dm.sqlselect( dm.q1, cons ) then begin
                     dgrfisicos.Add( dm.q1.fieldbyname( 'cclase' ).AsString );
                  end;
                  dm.q2.Next;
               end;
            end;
         end;
         lwSale := 'TRUE';
      end;
   end;
end;

procedure TaladrarProcesos( pclase: string; pbib: string; pprog: string;
                            clase: string; bib: string; prog: string; sis: string;
                            renglon: integer; columna: integer; tabla: string;
                            sParNombreBlockLink: String );
var
   k, despla, xnum_regs, iRenV, iColV: integer;
   tipo, nom, tamano, bas, cons, str_repetido: string;
   qq, qa: Tadoquery;
   sParSistema, sNombreBlock, sNombreBlockTerminal: String;
begin
   // -----  filtro para repetidos  -----   ALK   ------
   str_repetido:= pprog + '|' + pclase + '|' + pbib + '|' +
                  prog + '|' + clase + '|' + bib + '|' + sis;
   if (repetidos_str.indexof(str_repetido)=-1) then   //si no esta, agregarlo
      repetidos_str.Add(str_repetido)
   else begin
      iGlbRenglon := iGlbRenglon + alto - 120;
      renglon:= iGlbRenglon;
      exit;
   end;

   // --------------------------------------------------

   tipo := clase;
   nom := bib + ' ' + prog;
   tamano := '6';
   if clase = 'STE' then begin
      k := pos( '_', nom );
      nom := copy( nom, k + 1, 100 );
      k := pos( '_', nom );
      nom := copy( nom, k + 1, 100 );
      tamano := '8';
   end
   else begin
      if es_bbva then begin
         tipo := copy( bib, 4, 3 );
         nom := prog;
         tamano := '8';
      end;
   end;

   inc( iNombre );
   sNombreBlock := 'DP_' + IntToStr( iNombre );
   //registrar en memoria
   try      //alk para out of memory
      RegistraBlockProcesos(
         Trim( Clase ), Trim( Bib ), Trim( Prog ), Trim( Sis ),
         columna, renglon, ancho, alto, 0,
         sNombreBlock, Trim( Prog ) + '|' + Trim( Bib ) + '|' + Trim( Clase ),
         'FlowActionBlock',
         sNombreBlock, sParNombreBlockLink, dgr_ccolor( clase ), tipo + ' ' + nom );
   except
      showmessage('Este proceso excedió sus actuales recursos, libere algunos de éstos y vuelva a intentar');
      abort;
   end;
   //if sParComent = 'LIBRARY' then //solicitado para Algol, pero aplica para todos (22/01/2014)
      //Exit;

   k := dgr_repetido( clase, bib, prog, sis, renglon, columna, sNombreBlock );
   if k <> -1 then begin //Ya existe
      if dgrcom[ k ].desplaza = -1 then begin
         dgrcom[ k ].desplaza := desplaza;
         desplaza := ( desplaza + 20 ) mod 180;
      end;

      inc( iNombre );
      sNombreBlockTerminal := 'DP_' + IntToStr( iNombre );
      //registrar en memoria
      try         // alk para out of memory
         RegistraBlockProcesos(
            Trim( Clase ), Trim( Bib ), Trim( Prog ), Trim( Sis ),
            columna + ancho + 20, renglon + 10, 20, 20, desplaza,
            sNombreBlockTerminal, Trim( Prog ) + '|' + Trim( Bib ) + '|' + Trim( Clase ),
            'FlowTerminalBlock',
            sNombreBlockTerminal, sNombreBlock, $00FCFCFC, inttostr( k ) );
      except
         showmessage('Este proceso excedió sus actuales recursos, libere algunos de éstos y vuelva a intentar');
         abort;
      end;
      iRenV := Round( renglon / 10 ) + 1;

      iColV := Round( columna / 10 );
      iColV := Trunc( iColV / 10 ) + 1;
      dgryy.add( 'D' + ' ' + inttostr( k ) + ' ' + inttostr( iColV ) +
         ' ' + inttostr( iRenV ) + ' ' + '$00FDFDFD' );
   end
   else begin
      xnum_regs := 0;
      qq := Tadoquery.Create( nil );
      qq.Connection := dm.ADOConnection1;
      qa := Tadoquery.Create( nil );
      qa.Connection := dm.ADOConnection1;
      //if dm.sqlselect( qq, 'SELECT HCPROG,HCBIB,HCCLASE FROM ' + tabla +
      {cons:='SELECT DISTINCT HCPROG,HCBIB,HCCLASE FROM ' + tabla +
         ' WHERE PCPROG=' + g_q + prog + g_q +
         ' AND PCBIB=' + g_q + bib + g_q +
         ' AND PCCLASE=' + g_q + clase + g_q +
         //' ORDER BY ORDEN' ) then begin
         ' ORDER BY HCPROG,HCBIB,HCCLASE'; }
      cons:= 'select * from tsrela ' +
      ' where pcprog=' + g_q + prog + g_q +
      ' and   pcbib=' + g_q + bib + g_q +
      ' and   pcclase=' + g_q + clase + g_q +
      ' order by orden';
      //archivo_selects.Add(cons);
      if dm.sqlselect( qq, cons ) then begin

         xnum_regs := qq.Recordcount;      // numero de hijos maximo 199
         if xnum_regs > 200 then begin
            inc( iNombre );
            sNombreBlockTerminal := 'DP_' + IntToStr( iNombre );
            //registrar en memoria
            try    // alk para out of memory
               RegistraBlockProcesos(
                  Trim( Clase ), Trim( Bib ), Trim( Prog ), Trim( Sis ),
                  columna + ancho + 20, renglon + 10, 20, 20, 0,
                  sNombreBlockTerminal, Trim( Prog ) + '|' + Trim( Bib ) + '|' + Trim( Clase ),
                  'FlowTerminalBlock',
                  sNombreBlockTerminal, sNombreBlock, $004F4FFF, inttostr( xnum_regs ) + ' regs' );
            except
               showmessage('Este proceso excedió sus actuales recursos, libere algunos de éstos y vuelva a intentar');
               abort;
            end;
            iRenV := Round( renglon / 10 ) + 1;
            iColV := Round( columna / 10 );
            iColV := Trunc( iColV / 10 ) + 1;
            dgryy.add( 'D' + ' ' + inttostr( xnum_regs ) + ' ' + inttostr( iColV ) +
               ' ' + inttostr( iRenV ) + ' ' + '$000404FF' );

            qq.Free;
            exit;
         end;
         while not qq.Eof do begin
            if ( pclase = qq.FieldByName( 'hcclase' ).Asstring ) and
               ( pbib = qq.FieldByName( 'hcbib' ).Asstring ) and
               ( pprog = qq.FieldByName( 'hcprog' ).Asstring ) then begin
               qq.Next;
               continue;
            end;
            // filtro de las calses que encuentra
            if dgrfisicos.IndexOf( qq.fieldbyname( 'hcclase' ).AsString ) > -1 then begin
               if renglon <> iGlbRenglon then
                  iGlbRenglon := iGlbRenglon + alto + 20;

               //if dm.sqlselect( qa, 'SELECT Distinct sistema, coment  FROM ' + tabla +
               cons:='SELECT DISTINCT SISTEMA FROM ' + tabla +
                  ' WHERE HCPROG=' + g_q + qq.fieldbyname( 'hcprog' ).AsString + g_q +
                  ' AND HCBIB=' + g_q + qq.fieldbyname( 'hcbib' ).AsString + g_q +
                  ' AND HCCLASE=' + g_q + qq.fieldbyname( 'hcclase' ).AsString + g_q;
               //archivo_selects.Add(cons);
               if dm.sqlselect( qa, cons ) then
                  sParSistema := qa.fieldbyname( 'sistema' ).AsString;


               TaladrarProcesos( clase, bib, prog,
                  qq.fieldbyname( 'hcclase' ).AsString,
                  qq.fieldbyname( 'hcbib' ).AsString,
                  qq.fieldbyname( 'hcprog' ).AsString, sParSistema, iGlbRenglon, columna + ancho + 30, tabla,
                  sNombreBlock ); //, qa.fieldbyname( 'coment' ).AsString );

               renglon := renglon + 1;
            end;
            qq.Next;
         end;
      end;
      qq.Free;
      qa.free;
   end;
end;

procedure LogicaArmadoDgrProcesos( sParClase, sParBib, sParProg, sParSistema: String );
var
   i, iRenV, iColV: Integer;
   xClave, xColorw: String;
   sNombreBlockTerminal: String;
begin
   //usado para generar archivo excel - en su momento quitar
   dgryy := Tstringlist.create;
   archivo_lista := trim(sParClase) + trim(sParBib) + trim(sParProg);
   bGlbQuitaCaracteres( archivo_lista );
   //fin usado para generar archivo...

   try
      setlength( dgrcol, 0 );

      dgr_clasesDProcesos;    //obtiene las clases activas para el diagrama de bloque

      if dm.sqlselect( dm.q2, 'SELECT * FROM PARAMETRO WHERE CLAVE LIKE ' + g_q + 'WCOLOR_%' + g_q ) then begin
         while not dm.q2.Eof do begin
            xclave := copy( dm.q2.fieldbyname( 'CLAVE' ).AsString, 8, 3 );
            xcolorw := dm.q2.fieldbyname( 'DATO' ).AsString;
            dgr_clasecolor( xclave, xcolorw );
            dm.q2.Next;
         end;
      end;

      if dm.sqlselect( dm.q1, 'SELECT * FROM PARAMETRO ' +
         ' WHERE CLAVE=' + g_q + 'EMPRESA-NOMBRE-1' + g_q ) then
         es_bbva := ( copy( dm.q1.FieldByName( 'DATO' ).AsString, 1, 4 ) = 'BBVA' );

      iGlbRenglon := 40; //desde este renglon empieza a diagramar
      TaladrarProcesos( '', '', '', sParClase, sParBib, sParProg, sParSistema, iGlbRenglon, 20, 'tsrela', '' ); //, '' );
      if length(aGlbBlockAtributos)>2000 then begin
         showmessage('El Diagrama es demasiado grande y por lo tanto ilegible, no será generado');
         SetLength( dgrcom, 0 ); //control para los repetidos, checar rutina y hacerla global
         SetLength( aGlbBlockAtributos, 0 );
         exit;
      end;
      for i := 0 to length( dgrcom ) - 1 do begin
         if dgrcom[ i ].desplaza <> -1 then begin
            inc( iNombre );

            sNombreBlockTerminal := 'DP_' + IntToStr( iNombre );
            // registrar en memoria
            try     // alk para out of memory
               RegistraBlockProcesos(
                  dgrcom[ i ].Clase, dgrcom[ i ].Bib, dgrcom[ i ].prog, dgrcom[ i ].sistema,
                  dgrcom[ i ].col + ancho + 5, dgrcom[ i ].ren - 10, 20, 20, dgrcom[ i ].desplaza,
                  sNombreBlockTerminal, dgrcom[ i ].prog + '|' + dgrcom[ i ].Bib + '|' + dgrcom[ i ].Clase,
                  'FlowTerminalBlock',
                  dgrcom[ i ].NombreBlock, sNombreBlockTerminal, $008AFFFF, inttostr( i ) );
            except
               showmessage('Este proceso excedió sus actuales recursos, libere algunos de éstos y vuelva a intentar');
               abort;
            end;
            iRenV := Round( dgrcom[ i ].ren / 10 ) + 1;
            iColV := Round( dgrcom[ i ].col / 10 );
            iColV := Trunc( iColV / 10 ) + 1;
            dgryy.add( 'D' + ' ' + inttostr( i ) + ' ' + inttostr( iColV ) +
               ' ' + inttostr( iRenV ) + ' ' + '$0080FFFF' );
         end;
      end;
      bGlbQuitaCaracteres( archivo_lista );
      archivo_lista := g_tmpdir + '\DiagramaProceso' + archivo_lista;
      dgryy.SaveToFile( archivo_lista );
      g_borrar.Add( archivo_lista );
      //g_borrar.Add( archivo_lista + '.dgr' );
      g_control := stringreplace( archivo_lista, g_tmpdir + '\DiagramaProceso', '', [ rfreplaceall ] );
   finally
      dgryy.Free;
   end;
end;

procedure GlbArmaDiagramaProcesos( atParDiagrama: TatDiagram;
   sParClase, sParBib, sParProg: String; sParSistema: String; sParSubtitulo: String );
var
   i: Integer;
   slLinkPoint: TStringList;
   slArchivoDGR: TStringList;
   sArchivoPaso1, sArchivoPaso2: String;
begin
   archivo_selects:=TstringList.Create;
   repetidos_str:=TstringList.Create;
   GlbNuevoDiagrama( atParDiagrama );

   iGlbNombreBlock := 0;
   SetLength( dgrcom, 0 ); //control para los repetidos, checar rutina y hacerla global
   SetLength( aGlbBlockAtributos, 0 );

   //crea subtitulo en atParDiagrama
   GlbDiagramaSubTitulo( atParDiagrama, sParSubtitulo );

   //logica de llenado de aGlbBlockAtributos y asignacion de renlones y columnas.
   LogicaArmadoDgrProcesos( sParClase, sParBib, sParProg, sParSistema );
   if length(aGlbBlockAtributos )=0 then exit;
   //crea los block's
   for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      //with ftsmain.dxBarProgress do
         //if Visible = ivAlways then begin
         //   StepIt;
         //   ftsmain.Refresh
         //end;// crea rutina

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

   //crea las ligas a traves de un TStringList armado
   slLinkPoint := Tstringlist.Create;
   try
      for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
         if ( aGlbBlockAtributos[ i ].LigaBlockOrigen <> '' ) and
            ( aGlbBlockAtributos[ i ].LigaBlockDestino <> '' ) then
            if ( aGlbBlockAtributos[ i ].Color = $008AFFFF ) and
               ( aGlbBlockAtributos[ i ].TipoBlock = 'FlowTerminalBlock' ) then
               GlbLinkPoints( i,
                  aGlbBlockAtributos[ i ].NFisicoBlock,
                  aGlbBlockAtributos[ i ].Columna, aGlbBlockAtributos[ i ].Renglon,
                  aGlbBlockAtributos[ i ].Ancho, aGlbBlockAtributos[ i ].Alto,
                  aGlbBlockAtributos[ i ].LigaBlockOrigen, aGlbBlockAtributos[ i ].LigaBlockDestino, 3, 2,
                  slLinkPoint, 'asDiamond', 'TDiagramSideLine', 'psSolid' )
            else
               GlbLinkPoints( i,
                  aGlbBlockAtributos[ i ].NFisicoBlock,
                  aGlbBlockAtributos[ i ].Columna, aGlbBlockAtributos[ i ].Renglon,
                  aGlbBlockAtributos[ i ].Ancho, aGlbBlockAtributos[ i ].Alto,
                  aGlbBlockAtributos[ i ].LigaBlockDestino, aGlbBlockAtributos[ i ].LigaBlockOrigen, 3, 2,
                  slLinkPoint, 'asDiamond', 'TDiagramSideLine', 'psSolid' );
      end;

      //guardar dgr y pegarle el contenido de slLinkPoint
      sArchivoPaso1 := g_tmpdir + '\paso1.dgr';
      //sArchivoPaso := Caption + '.dgr';

      atParDiagrama.SaveToFile( sArchivoPaso1 );
      slArchivoDGR := Tstringlist.Create;
      try
         slArchivoDGR.LoadFromFile( sArchivoPaso1 );
         for i := 0 to slArchivoDGR.Count - 1 do begin //asi hace que las lineas sean send to back
            if pos( 'object SUBTITULO', slArchivoDGR[ i ] ) > 0 then begin
               slArchivoDGR[ i ] := slLinkPoint.Text + ' ' + slArchivoDGR[ i ];
               Break;
            end;
         end;
         sArchivoPaso2 := g_tmpdir + '\paso2.dgr';
         slArchivoDGR.SaveToFile( sArchivoPaso2 );
      finally
         slArchivoDGR.Free;
      end;

   finally
      slLinkPoint.Free;
   end;
   atParDiagrama.LoadFromFile( sArchivoPaso2 );
   DeleteFile( PChar( sArchivoPaso1 ) );
   DeleteFile( PChar( sArchivoPaso2 ) );
   /// fin de crea las ligas a traves de un TStringList armado (slLinkPoint)

   //reacomoda las lineas
   atParDiagrama.MoveBlocks( 1, 0, True );
   atParDiagrama.ClearUndoStack;
   //activa todas las paginas
   atParDiagrama.AutoScroll := False;
   atParDiagrama.AutoScroll := True;

   //archivo_selects.Add(dgrfisicos.commaText);
   //archivo_selects.SaveToFile(g_tmpdir + '\ALKselectDiagrama_'+sParProg+'.txt');
   archivo_selects.Free;

   repetidos_str.Free;
end;


//  Funcion unica para generar diagramas visustin ALK
function GLbCreaDiagramaFlujo(sParClase, sParBib, sParProg: String;
   sParArchivoFte, sParRutaSalida, sParArchivoSalida: String): Boolean;
var
   sNombreArchivo: string;
   sArchivoConf: string;
   slArchivoConf: TStringList;
   sArchivoPDF_Visustin: string;
   bEjecuta: Boolean;
   clave_len: string;
begin
   Result := False;

   if not ( ( sParClase = 'CBL' ) or ( sParClase = 'CPY' ) or
      ( sParClase = 'TDC' ) or ( sParClase = 'USH' ) or ( sParClase = 'CCH' ) or
      ( sParClase = 'JAV' ) or ( sParClase = 'JLA' ) or ( sParClase = 'PCK' ) or
      ( sParClase = 'JSP' ) or ( sParClase = 'JS' ) or
      ( sParClase = 'CUX' ) or ( sParClase = 'HUX' ) or
      ( sParClase = 'PUX' ) or ( sParClase = 'SUX' ) or
      ( sParClase = 'JCL' ) or ( sParClase = 'JOB' ) ) then
      Exit;

   if sParBib = 'SCRATCH' then  //si no tiene fuente
      exit;

   if not FileExists( sParArchivoFte ) then
      Exit;


   sNombreArchivo := sParClase + '_' + sParBib + '_' + sParProg;
   bGlbQuitaCaracteres( sNombreArchivo );
   sArchivoConf := g_tmpdir + '\' + sNombreArchivo + '.VJB';

   slArchivoConf := TStringList.Create;
   // ponerle la clave de acuerdo a la clase (lenguaje)
   clave_len:=sParClase;                              //JS JSP
   if (sParClase='CBL') or (sParClase='CPY')then      //cobol
      clave_len:='COBFIX';
   if (sParClase='SUX') or (sParClase='USH')then      //shell
      clave_len:='KSH';
   if (sParClase='JCL') or (sParClase='JOB') then      // jcl  /  job
      clave_len:='XSLT';
   if (sParClase='TDC') or (sParClase='CCH') or (sParClase='CUX') or (sParClase='PUX') or (sParClase='HUX') then      //c
      clave_len:='C';
   if (sParClase='JLA') or (sParClase='PCK') or (sParClase='JAV') then      // Clase Java, Paquete Java
      clave_len:='JAVA';
   try
      with slArchivoConf do begin
         Add( '; Visustin bulk flowchart job' );
         Add( '[Job]' );
         Add( 'Language='+clave_len );
         Add( 'OutputPath=' + sParRutaSalida );
         Add( 'Split=False' );
         Add( 'OutputMulti=False' );
         Add( 'OutputFormat=pdf1' );
         Add( 'Recursive=False' );
         Add( ' ' );
         Add( '[Source]' );
         Add( sParArchivoFte );
         SaveToFile( sArchivoConf );
      end;
   finally
      slArchivoConf.Free;
      g_borrar.add( sArchivoConf );
   end;

   bEjecuta := dm.ejecuta_espera( 'VISUSTIN' + ' ' + sArchivoConf, SW_HIDE );

   if not bEjecuta then
      Exit
   else
      Result := True;

   sArchivoPDF_Visustin := LowerCase( sParArchivoFte );
   sArchivoPDF_Visustin := StringReplace( sArchivoPDF_Visustin, ' ', '_', [ rfReplaceAll ] );
   sArchivoPDF_Visustin := StringReplace( sArchivoPDF_Visustin, '.txt', '.pdf', [ rfReplaceAll ] );

   if not FileExists( sArchivoPDF_Visustin ) then
      Exit;

   DeleteFile( PAnsiChar( sParArchivoSalida ) );
   if RenameFile( sArchivoPDF_Visustin, sParArchivoSalida ) then
      Result := True;
end;


{  Funcion para crear diagramas juanita
function GLbCreaDiagramaFlujo(
   sParClase, sParBib, sParProg: String;
   sParArchivoFte, sParRutaSalida, sParArchivoSalida: String ): Boolean;
var
   sNombreArchivo: string;
   sArchivoConf: string;
   slArchivoConf: TStringList;
   sArchivoPDF_Visustin: string;
   bEjecuta: Boolean;

   function sObtenerLenguajeVisustin( sParClase: String; sParVariable: String ): String;
   var
      qParametro: TADOQuery;
   begin
      Result := '';

      if sParVariable = '' then begin
         qParametro := TADOQuery.Create( nil );
         try
            qParametro.Connection := dm.ADOConnection1;

            if dm.sqlselect( qParametro, 'SELECT DATO FROM PARAMETRO' +
               ' WHERE CLAVE =' + g_q + 'LENG_VISUSTIN_DGR_' + sParClase + g_q +
               ' AND TRIM( DATO ) <> ' + g_q + ' ' + g_q ) then begin
               sGlbLENG_VISUSTIN_DGR_CBL := qParametro.FieldByName( 'DATO' ).AsString;
               Result := qParametro.FieldByName( 'DATO' ).AsString;
            end
            else begin
               if sParClase = 'CBL' then begin
                  sGlbLENG_VISUSTIN_DGR_CBL := sDEFAULT_LENG_VISUSTIN_DGR_CBL;
                  Result := sDEFAULT_LENG_VISUSTIN_DGR_CBL;
               end
               else if sParClase = 'CPY' then begin
                  sGlbLENG_VISUSTIN_DGR_CPY := sDEFAULT_LENG_VISUSTIN_DGR_CPY;
                  Result := sDEFAULT_LENG_VISUSTIN_DGR_CPY;
               end
               else
                  Result := '';
            end;
         finally
            qParametro.Free;
         end;
      end
      else
         Result := sParVariable;
   end;

begin
   Result := False;

   if not ( ( sParClase = 'CBL' ) or ( sParClase = 'CPY' ) or
      ( sParClase = 'TDC' ) or ( sParClase = 'USH' ) or
      ( sParClase = 'JAV' ) or
      ( sParClase = 'CUX' ) or ( sParClase = 'HUX' ) or
      ( sParClase = 'PUX' ) or ( sParClase = 'SUX' ) or
      ( sParClase = 'JCL' ) ) then
      Exit;
   if not FileExists( sParArchivoFte ) then
      Exit;

   sNombreArchivo := sParClase + '_' + sParBib + '_' + sParProg;
   bGlbQuitaCaracteres( sNombreArchivo );
   sArchivoConf := g_tmpdir + '\' + sNombreArchivo + '.VJB';

   slArchivoConf := TStringList.Create;
   try
      with slArchivoConf do begin
         Add( '; Visustin bulk flowchart job' );
         Add( '[Job]' );

         if ( sParClase = 'TDC' ) or ( sParClase = 'CUX' ) or
            ( sParClase = 'PUX' ) or ( sParClase = 'HUX' ) then
            Add( 'Language=C' );

         if ( sParClase = 'USH' ) or ( sParClase = 'SUX' ) then
            Add( 'Language=SH' );

         if ( sParClase = 'JAV' ) then
            Add( 'Language=JAVA' );

         if ( sParClase = 'CBL' ) or ( sParClase = 'CPY' ) then begin
            //Add( 'Language=COBFIX' );
            if sParClase = 'CBL' then
               Add( 'Language=' + sObtenerLenguajeVisustin( sParClase, sGlbLENG_VISUSTIN_DGR_CBL ) );
            if sParClase = 'CPY' then
               Add( 'Language=' + sObtenerLenguajeVisustin( sParClase, sGlbLENG_VISUSTIN_DGR_CPY ) );
         end;

         if ( sParClase = 'JCL' ) then
            Add( 'Language=JCL' );

         Add( 'OutputPath=' + sParRutaSalida );
         Add( 'Split=False' );
         Add( 'OutputMulti=False' );
         Add( 'OutputFormat=pdf1' );
         Add( 'Recursive=False' );
         Add( ' ' );
         Add( '[Source]' );
         Add( sParArchivoFte );
         SaveToFile( sArchivoConf );
      end;
   finally
      slArchivoConf.Free;
      g_borrar.add( sArchivoConf );
   end;

   bEjecuta := dm.ejecuta_espera( 'VISUSTIN' + ' ' + sArchivoConf, SW_HIDE );

   if not bEjecuta then
      Exit;

   sArchivoPDF_Visustin := LowerCase( sParArchivoFte );
   sArchivoPDF_Visustin := StringReplace( sArchivoPDF_Visustin, ' ', '_', [ rfReplaceAll ] );
   sArchivoPDF_Visustin := StringReplace( sArchivoPDF_Visustin, '.txt', '.pdf', [ rfReplaceAll ] );

   if not FileExists( sArchivoPDF_Visustin ) then
      Exit;

   DeleteFile( PAnsiChar( sParArchivoSalida ) );
   if RenameFile( sArchivoPDF_Visustin, sParArchivoSalida ) then
      Result := True;
end;
}

{function GLbCreaDiagramaFlujo_y_Jerarquico(       //Funcion que se utilizaba para la documentacion automatica
   sParClase, sParBib, sParProg: String;
   sParArchivoFte, sParRutaSalida, sParArchivoSalida, sparTipoDiagrama: String ): Boolean;
var
   sNombreArchivo: string;
   sArchivoConf: string;
   sArchivoConfSal: string;
   slArchivoConf: TStringList;
   sArchivoPDF_Diagramador: string;
   sArchivoPDF_Diagramador1: string;
   bEjecuta: Boolean;
   lProgramaDiagramador, lcaracteres, lMensaje, lClaseDiagrama: string;
   lArchDiagFlujo,lArchDiagJerarquico, lBorrar: String;
begin
   Result := False;

   if not ( ( sParClase = 'WFL' ) or ( sParClase = 'ALG' )
      or ( sParClase = 'TMC' ) or ( sParClase = 'TMP' )
      or ( sParClase = 'CBL' ) ) then        //alk cambio para nuevos diagramas CBL
      Exit;

   if not FileExists( sParArchivoFte + '.txt' ) then
      Exit;

   sNombreArchivo := sParClase + '_' + sParBib + '_' + sParProg;
   bGlbQuitaCaracteres( sNombreArchivo );
   sArchivoConf := g_tmpdir + '\' + sNombreArchivo + '.BAT';
   sArchivoConfSal := g_tmpdir + '\' + sNombreArchivo + '.SAL';

   if sParclase = 'WFL' then begin
      lProgramaDiagramador := 'gendiagramawfl';
      lcaracteres := '\gdwfl_';
      lMensaje := 'Ejemplo: gendiagramawfl File_Input FileOutput';
      if sparTipoDiagrama = 'FLUJO' then begin
         lClaseDiagrama := sDIGRA_FLUJO_WFL;
         lArchDiagFlujo := stringreplace( trim( sParArchivoFte ), '\Fte', '\' + sDiGRA_FLUJO_WFL, [ rfReplaceAll ] ) + '_f.pdf ';
         lArchDiagFlujo := stringreplace( trim( lArchDiagFlujo ), ' ', '_' , [ rfReplaceAll ] );
         sArchivoPDF_Diagramador := lArchDiagFlujo;
      end
      else begin
         lClaseDiagrama := sDIGRA_JERARQUICO_WFL;
         lArchDiagJerarquico := stringreplace( trim( sParArchivoFte ), '\Fte', '\' + sDiGRA_JERARQUICO_WFL, [ rfReplaceAll ] ) + '_p.pdf ';
         lArchDiagJerarquico := stringreplace( trim( lArchDiagJerarquico ), ' ', '_', [ rfReplaceAll ] ) + '_p.pdf';
         sArchivoPDF_Diagramador := lArchDiagJerarquico;
      end;
   end
   else begin
      if sParclase = 'ALG' then begin
         lProgramaDiagramador := 'gendiagramaalgol';
         lcaracteres := '\gdalg_';
         lMensaje := 'Ejemplo: gendiagramaalgol File_Input FileOutput';
         if sparTipoDiagrama = 'FLUJO' then begin
            lClaseDiagrama := sDIGRA_FLUJO_ALG;
            lArchDiagFlujo := stringreplace( trim( sParArchivoFte ), '\Fte', '\' + sDiGRA_FLUJO_ALG, [ rfReplaceAll ] ) + '_f.pdf ';
            lArchDiagFlujo := stringreplace( trim(   lArchDiagFlujo ), ' ', '_' , [ rfReplaceAll ] );
            sArchivoPDF_Diagramador := lArchDiagFlujo;
         end
         else begin
            lClaseDiagrama := sDIGRA_JERARQUICO_ALG;
            lArchDiagJerarquico := stringreplace( trim( sParArchivoFte ), '\Fte', '\' + sDiGRA_JERARQUICO_ALG, [ rfReplaceAll ] ) + '_p.pdf ';
            lArchDiagJerarquico := stringreplace( trim( lArchDiagJerarquico ), ' ', '_' , [ rfReplaceAll ] ) + '_p.pdf';
            sArchivoPDF_Diagramador := lArchDiagJerarquico;
         end;
      end
      else begin
         if sParclase = 'TMC' then begin
            lProgramaDiagramador := 'gendiagramamacros';
            lcaracteres := '\gdtmc_';
            lMensaje := 'Ejemplo: gendiagramamacros File_Input FileOutput';
            lClaseDiagrama := sDIGRA_FLUJO_TMC;
            lArchDiagFlujo := stringreplace( trim( sParArchivoFte ), '\Fte', '\' + sDiGRA_FLUJO_TMC, [ rfReplaceAll ] ) + '_f.pdf ';
            lArchDiagFlujo := stringreplace( trim(   lArchDiagFlujo ), ' ', '_' , [ rfReplaceAll ] );
            sArchivoPDF_Diagramador := lArchDiagFlujo;
         end
         else begin
            if sParclase = 'TMP' then begin
               lProgramaDiagramador := 'gendiagramaMacros';
               lcaracteres := '\gdtmp_';
               lMensaje := 'Ejemplo: gendiagramamacros File_Input FileOutput';
               lClaseDiagrama := sDIGRA_FLUJO_TMP;
               lArchDiagFlujo := stringreplace( trim( sParArchivoFte ), '\Fte', '\' + sDiGRA_FLUJO_TMP, [ rfReplaceAll ] ) + '_f.pdf ';
               lArchDiagFlujo := stringreplace( trim(   lArchDiagFlujo ), ' ', '_' , [ rfReplaceAll ] );
               sArchivoPDF_Diagramador := lArchDiagFlujo;
            end;
         end;
      end;
   end;

   slArchivoConf := TStringList.Create;
   try
      with slArchivoConf do begin
         sArchivoConf := g_tmpdir + lCaracteres + sNombreArchivo + '.BAT';
         Add( 'ECHO OFF                    ' );
         Add( 'IF %1.==. GOTO HELP         ' );
         Add( 'Copy  ' + Q + sParArchivoFte + '.txt' + Q + ' ' + Q + sParArchivoFte + Q + ' >> ' + sArchivoConfSal ); //El programa que diagrama lo busca sin estensión
         Add( 'IF NOT EXIST %1 GOTO NOFILE ' );
         Add( 'ECHO .                    ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO Procesando "%1"...   ' + ' >> ' + sArchivoConfSal );

         Add( 'C:\sysmining\' + lProgramaDiagramador + ' ' + Q + sParArchivoFte + Q + ' ' + Q + sParArchivoFte + Q + ' >> ' + sArchivoConfSal );

         Add( 'IF errorlevel 1 GOTO ERRORGEN ' );

         Add( 'dot.exe -Tpdf -Gcharset=latin1 -o ' + Q + lArchDiagFlujo + Q + ' ' + Q + sParArchivoFte + '_f.dot' + Q + ' >> ' + sArchivoConfSal );

         if ( sParClase <> 'TMC' ) and ( sParClase <> 'TMP' ) then
            Add( 'dot.exe -Tpdf -o ' + Q + lArchDiagJerarquico + Q + ' ' + Q + sParArchivoFte + '_p.dot ' + Q + ' >> ' + sArchivoConfSal );

         Add( 'IF errorlevel 1 GOTO ERRORGJ ' );
         Add( 'GOTO FIN ' );
         Add( ':HELP ' );
         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "Genera el archivo de directivas p/la generación de digramas"     ' + ' >> ' + sArchivoConfSal );

         Add( 'ECHO ' + Q + lMensaje + Q + ' >> ' + sArchivoConfSal );

         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );
         Add( 'GOTO FIN ' );
         Add( ':NOFILE ' );
         Add( 'ECHO "El archivo %1 no existe"                                         ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO.                                                                  ' + ' >> ' + sArchivoConfSal );
         Add( 'GOTO FIN ' );
         Add( ':ERRORGEN ' );
         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );

         Add( 'ECHO "=Fallo la ejecución de ' + lProgramaDiagramador + ' con: %1"     ' + ' >> ' + sArchivoConfSal );

         Add( 'ECHO "=Verificar error.                           "                    ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );
         Add( 'GOTO FIN ' );
         Add( ':ERRORGF ' );
         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "=Fallo la ejecución de GraphViz Flujo con: %1"                   ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "=Verificar error.                           "                    ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );
         Add( 'GOTO FIN ' );
         Add( ':ERRORGJ ' );
         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "=Fallo la ejecución de GraphViz jerarquico con: %1"              ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "=Verificar error.                           "                    ' + ' >> ' + sArchivoConfSal );
         Add( 'ECHO "============================================================="   ' + ' >> ' + sArchivoConfSal );
         Add( 'GOTO FIN ' );
         Add( ':FIN ' );
         Add( 'Del ' + Q + sParArchivoFte + Q  +          ' >> ' + sArchivoConfSal );
         Add( 'Del ' + Q + sParArchivoFte+'_paso' + Q  +  ' >> ' + sArchivoConfSal );
         Add( 'Del ' + Q + sParArchivoFte+'_p.*' + Q  +   ' >> ' + sArchivoConfSal );
         Add( 'Del ' + Q + sParArchivoFte+'_f.*' + Q  +   ' >> ' + sArchivoConfSal );
         Add( 'ECHO "TERMINANDO..." %1                                                ' + ' >> ' + sArchivoConfSal );

         savetofile( sArchivoConf );
      end;
   finally
      slArchivoConf.Free;
      g_borrar.add( sArchivoConf );
   end;

   bEjecuta := dm.ejecuta_espera( sArchivoConf + ' ' + Q + sParArchivoFte + Q, SW_HIDE );

   if not bEjecuta then
      Exit;

   if not FileExists( sArchivoPDF_Diagramador ) then
      Exit;

   if RenameFile( sArchivoPDF_Diagramador, sParArchivoSalida ) then
      Result := True;
end;   }

function GLbCreaDiagramaActividad( //pervio cambiar en Vsustin opcion UML Activity
   sParClase, sParBib, sParProg: String;
   sParArchivoFte, sParRutaSalida, sParArchivoSalida: String ): Boolean;
var
   sNombreArchivo: String;
   sArchivoConf: String;
   slArchivoConf: TStringList;

   sArchivoPDF_Visustin: String;

   bEjecuta: Boolean;
begin
   Result := False;

   if not ( ( sParClase = 'JAV' ) ) then
      Exit;
   if not FileExists( sParArchivoFte ) then
      Exit;

   sNombreArchivo := sParClase + '_' + sParBib + '_' + sParProg;
   bGlbQuitaCaracteres( sNombreArchivo );
   sArchivoConf := g_tmpdir + '\' + sNombreArchivo + '.VJB';

   slArchivoConf := TStringList.Create;
   try
      with slArchivoConf do begin
         Add( '; Visustin bulk flowchart job' );
         Add( '[Job]' );
         Add( 'Language=JAVA' );
         Add( 'OutputPath=' + sParRutaSalida );
         Add( 'Split=False' );
         Add( 'OutputMulti=False' );
         Add( 'OutputFormat=pdf1' );
         Add( 'Recursive=False' );
         Add( ' ' );
         Add( '[Source]' );
         Add( sParArchivoFte );
         SaveToFile( sArchivoConf );
      end;
   finally
      slArchivoConf.Free;
      g_borrar.add( sArchivoConf );
   end;

   bEjecuta := dm.ejecuta_espera( 'VISUSTIN' + ' ' + sArchivoConf, SW_HIDE );

   if not bEjecuta then
      Exit;

   sArchivoPDF_Visustin := LowerCase( sParArchivoFte );
   sArchivoPDF_Visustin := StringReplace( sArchivoPDF_Visustin, ' ', '_', [ rfReplaceAll ] );
   sArchivoPDF_Visustin := StringReplace( sArchivoPDF_Visustin, '.txt', '.pdf', [ rfReplaceAll ] );

   if not FileExists( sArchivoPDF_Visustin ) then
      Exit;

   DeleteFile( PAnsiChar( sParArchivoSalida ) );
   if RenameFile( sArchivoPDF_Visustin, sParArchivoSalida ) then
      Result := True;
end;


//  _______________ ALK para diagrama de bloques ________________________  //
procedure ConsultaDgrBloques(sParSistema, sParProg, sParBib, sParClase: string);
var
   conCBLgral, conCBLprog, conLOC, conIDX, conIDXprog, conCPY, conCPYdet, conFDV : string;
   clase, bib, prog, clase_aux, bib_aux, prog_aux : string;
   i: integer;
   cpys : array of aCPY;
   fmBloques : TfmBloques;
   //***********************************************************************
   procedure recursivoCPY (sis,cla,prog,bib:String);
   var
      l : integer;
      conCPYrec: string;
   begin
      l:=length(cpys);
      l:=l+1;
      SetLength(cpys,l);

      //guardar el CPY para buscar posteriormente las tablas
      cpys[l-1].sistema:=sis;
      cpys[l-1].prog:=prog;
      cpys[l-1].clase:=cla;
      cpys[l-1].bib:=bib;

      // realizar consulta de todos los CPY recursivamente
      conCPYrec:= 'select * from tsrela' +
                  ' where sistema=' + g_q + sis + g_q +
                  ' and pcclase=' + g_q + cla + g_q +
                  ' and pcbib=' + g_q + bib + g_q +
                  ' and pcprog=' + g_q + prog + g_q +
                  ' and hcclase=' + g_q + 'CPY' + g_q;
      if dm.sqlselect( dm.q5, conCPYrec ) then begin
         while not dm.q5.Eof do begin
            if (dm.q5.FieldByName( 'hcclase' ).AsString <> cla) and
               (dm.q5.FieldByName( 'hcprog' ).AsString <> prog) and
               (dm.q5.FieldByName( 'hcbib' ).AsString <> bib) then
               recursivoCPY (dm.q5.FieldByName( 'sistema' ).AsString,
                             dm.q5.FieldByName( 'hcclase' ).AsString,
                             dm.q5.FieldByName( 'hcprog' ).AsString,
                             dm.q5.FieldByName( 'hcbib' ).AsString);
         dm.q5.Next;
         end;
      end;
   end;
   //****************************************************************************
   procedure guardaConsulta( consulta: tADOquery );
   var
      sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN: String;
      sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT: String;
      sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS: String;
      iParLINEAINICIO, iParLINEAFINAL, iLineaInicio, iLineaFinal: Integer;
      sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE: String;
      sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE: String;
      bParRepetido: Boolean;
      sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido: String;
   begin
      while not consulta.Eof do begin
         sParCPROGRepetido:= '';
         sParCBIBRepetido:= '';
         sParCCLASERepetido:= '';

         if consulta.FieldByName( 'LINEAINICIO' ).AsString = '' then
            iLineaInicio := 0
         else
            iLineaInicio := consulta.FieldByName( 'LINEAINICIO' ).AsInteger;

         if consulta.FieldByName( 'LINEAFINAL' ).AsString = '' then
            iLineaFinal := 0
         else
            iLineaFinal := consulta.FieldByName( 'LINEAFINAL' ).AsInteger;

         sParPCPROG:= consulta.FieldByName( 'PCPROG' ).AsString;
         sParPCBIB:= consulta.FieldByName( 'PCBIB' ).AsString;
         sParPCCLASE:= consulta.FieldByName( 'PCCLASE' ).AsString;
         sParHCPROG:= consulta.FieldByName( 'HCPROG' ).AsString;
         sParHCBIB:= consulta.FieldByName( 'HCBIB' ).AsString;
         sParHCCLASE:= consulta.FieldByName( 'HCCLASE' ).AsString;
         sParORDEN:= consulta.FieldByName( 'ORDEN' ).AsString;
         sParMODO:= consulta.FieldByName( 'MODO' ).AsString;
         sParORGANIZACION:= consulta.FieldByName( 'ORGANIZACION' ).AsString;
         sParEXTERNO:= consulta.FieldByName( 'EXTERNO' ).AsString;
         sParCOMENT:= consulta.FieldByName( 'COMENT' ).AsString;
         sParOCPROG:= consulta.FieldByName( 'OCPROG' ).AsString;
         sParOCBIB:= consulta.FieldByName( 'OCBIB' ).AsString;
         sParOCCLASE:= consulta.FieldByName( 'OCCLASE' ).AsString;
         sParSISTEMA:= consulta.FieldByName( 'SISTEMA' ).AsString;
         sParATRIBUTOS:= consulta.FieldByName( 'ATRIBUTOS' ).AsString;
         iParLINEAINICIO:= iLineaInicio;
         iParLINEAFINAL:= iLineaFinal;
         sParAMBITO:= consulta.FieldByName( 'AMBITO' ).AsString;
         sParICPROG:= consulta.FieldByName( 'ICPROG' ).AsString;
         sParICBIB:= consulta.FieldByName( 'ICBIB' ).AsString;
         sParICCLASE:= consulta.FieldByName( 'ICCLASE' ).AsString;
         sParPOLIMORFISMO:= consulta.FieldByName( 'POLIMORFISMO' ).AsString;
         sParXCCLASE:= consulta.FieldByName( 'XCCLASE' ).AsString;
         sParAUXILIAR:= consulta.FieldByName( 'AUXILIAR' ).AsString;
         sParHSISTEMA:= consulta.FieldByName( 'HSISTEMA' ).AsString;
         sParHPARAMETROS:= consulta.FieldByName( 'HPARAMETROS' ).AsString;
         sParHINTERFASE:= consulta.FieldByName( 'HINTERFASE' ).AsString;

         bParRepetido := bGlbRepetidoTsrela( sParHCPROG, sParHCBIB, sParHCCLASE );

         if bParRepetido then begin
            sParCPROGRepetido := sParHCPROG;
            sParCBIBRepetido := sParHCBIB;
            sParCCLASERepetido := sParHCCLASE;
         end;

         //guardar en el arreglo aGLBTsrela
         GlbRegistraArregloTsrela(
               sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN,
               sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT,
               sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS,
               iParLINEAINICIO, iParLINEAFINAL,
               sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE,
               sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE,
               bParRepetido, sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido);
      consulta.Next;
      end;
   end;
   // ***************************************************************************
begin
   //busca los existentes en tsprog
   ZeroMemory(@aGLBTsrela, SizeOf(aGLBTsrela));  //vaciar el arreglo
   {conCBLgral:= 'select distinct sistema,cclase,cbib,cprog' +
                ' from tsprog  where sistema =' + g_q + sParSistema + g_q +
                ' and cclase=' + g_q + sParClase + g_q +
                ' and cbib=' + g_q + sParBib + g_q;
                //' and cprog=' + g_q + sParProg + g_q;
   if dm.sqlselect( dm.q1, conCBLgral ) then begin
      i:=dm.q1.FieldCount;
      while not dm.q1.Eof do begin
         clase:= dm.q1.FieldByName( 'cclase' ).AsString;
         bib:= dm.q1.FieldByName( 'cbib' ).AsString;
         prog:= dm.q1.FieldByName( 'cprog' ).AsString;
         }
         clase:= sParClase;
         bib:= sParBib;
         prog:= sParProg;

         //consulta de las tablas, todas se insertan
         conCBLprog:= 'select * from tsrela' +
                      ' where sistema =' + g_q + sParSistema + g_q +
                      ' and occlase=' + g_q + clase + g_q +  //' and pcclase=' + g_q + clase + g_q +
                      ' and ocbib=' + g_q + bib + g_q +   //' and pcbib=' + g_q + bib + g_q +
                      ' and ocprog=' + g_q + prog + g_q +    //' and pcprog=' + g_q + prog + g_q +
                      ' and hcclase in ('
                      + g_q + 'TAB' + g_q + ','
                      + g_q + 'UPD' + g_q + ','
                      + g_q + 'INS' + g_q + ','
                      + g_q + 'DEL' + g_q + ')';
         if dm.sqlselect( dm.q2, conCBLprog ) then begin
            //funcion para guardar los datos en arreglo para diagramar
            guardaConsulta( dm.q2 );

         end;   //fin de si existen tablas

         {   ................................................................
                                      Componenetes LOC
             ................................................................  }
         //Buscar si tiene componentes LOC
         conLOC:= 'select * from tsrela' +
                  ' where sistema =' + g_q + sParSistema + g_q +
                  ' and occlase=' + g_q + clase + g_q +   //' and pcclase=' + g_q + clase + g_q +
                  ' and ocbib=' + g_q + bib + g_q +     //' and pcbib=' + g_q + bib + g_q +
                  ' and ocprog=' + g_q + prog + g_q +  //' and pcprog=' + g_q + prog + g_q +
                  ' and hcclase = ' + g_q + 'LOC' + g_q;
         if dm.sqlselect( dm.q2, conLOC ) then begin
            //funcion para guardar los datos en arreglo para diagramar
            guardaConsulta( dm.q2 );

         end;   // fin de archivos LOC


         {   ................................................................
                                      Componenetes FDV
             ................................................................  }
         //Buscar si tiene componentes FDV
         conFDV:= 'select * from tsrela' +
                  ' where sistema =' + g_q + sParSistema + g_q +
                  ' and occlase=' + g_q + clase + g_q +
                  ' and ocbib=' + g_q + bib + g_q +     //' and pcbib=' + g_q + bib + g_q +
                  ' and ocprog=' + g_q + prog + g_q +  //' and pcprog=' + g_q + prog + g_q +
                  ' and hcclase = ' + g_q + 'FDV' + g_q;
         if dm.sqlselect( dm.q2, conFDV ) then begin
            //funcion para guardar los datos en arreglo para diagramar
            guardaConsulta( dm.q2 );
         end;   // fin de archivos FDV


         {   ................................................................
                                      TABLAS   EN   LOS  INDICES
             ................................................................  }
         //Buscar si tiene archivos con IDX en clase y FIND en comentario
         conIDX:= 'select distinct hcprog,hcclase,hcbib from tsrela' +
                  ' where sistema =' + g_q + sParSistema + g_q +
                  ' and pcclase=' + g_q + clase + g_q +
                  ' and pcbib=' + g_q + bib + g_q +
                  ' and pcprog=' + g_q + prog + g_q +
                  ' and hcclase = ' + g_q + 'IDX' + g_q +
                  ' and coment= ' + g_q + 'FIND' + g_q;
          if dm.sqlselect( dm.q3, conIDX ) then begin
             while not dm.q3.Eof do begin
                clase_aux:= dm.q3.FieldByName( 'hcclase' ).AsString;
                bib_aux:= dm.q3.FieldByName( 'hcbib' ).AsString;
                prog_aux:= dm.q3.FieldByName( 'hcprog' ).AsString;

                //Buscando tablas en los indices
                conIDXprog:= 'select * from tsrela' +
                             ' where sistema =' + g_q + sParSistema + g_q +
                             ' and pcclase=' + g_q + clase_aux + g_q +
                             ' and pcbib=' + g_q + bib_aux + g_q +
                             ' and pcprog=' + g_q + prog_aux + g_q +
                             ' and hcclase = ' + g_q + 'TAB' + g_q;
                if dm.sqlselect( dm.q2, conIDXprog ) then begin
                   //funcion para guardar los datos en arreglo para diagramar
                   guardaConsulta( dm.q2 );

                end;   // fin de la tabla de detalle de programa IDX
             dm.q3.Next;
             end;
          end;  //fin de tabla de indices  IDX


         {   ................................................................
                                   TABLAS   EN   LOS  CPY
             ................................................................  }
         //Buscar en los CPY recursivamente
         conCPY:= 'select distinct hcprog,hcclase,hcbib, sistema from tsrela' +
                  ' where sistema =' + g_q + sParSistema + g_q +
                  ' and pcclase=' + g_q + clase + g_q +
                  ' and pcbib=' + g_q + bib + g_q +
                  ' and pcprog=' + g_q + prog + g_q +
                  ' and hcclase=' + g_q + 'CPY' + g_q;
         if dm.sqlselect( dm.q4, conCPY ) then begin
            while not dm.q4.Eof do begin           //modificacion ALK
               clase_aux:= dm.q4.FieldByName( 'hcclase' ).AsString;
               bib_aux:= dm.q4.FieldByName( 'hcbib' ).AsString;
               prog_aux:= dm.q4.FieldByName( 'hcprog' ).AsString;

               ZeroMemory(@cpys, SizeOf(cpys));  //vaciar el arreglo
               recursivoCPY (dm.q4.FieldByName( 'sistema' ).AsString,
                   clase_aux, prog_aux, bib_aux);
            dm.q4.Next;
            end;
         end;     // fin tabla de CPY

         {   ................................................................
                      ENCONTRAR TAB Y LOC PARA ARCHIVOS CPY
             ................................................................  }
         //Para cada elemento del arreglo de la estructura, buscar sus tablas

         for i:=length(cpys)-1 downto 0 do begin
            clase_aux:= cpys[i].clase;
            bib_aux:= cpys[i].bib;
            prog_aux:= cpys[i].prog;


            //   *************  BUSCA TAB  *************

            conCPYdet:= 'select * from tsrela' +
                        ' where sistema =' + g_q + cpys[i].sistema + g_q +
                        ' and pcclase=' + g_q + clase_aux + g_q +
                        ' and pcbib=' + g_q + bib_aux + g_q +
                        ' and pcprog=' + g_q + prog_aux + g_q +
                        ' and hcclase in ('
                        + g_q + 'TAB' + g_q + ','
                        + g_q + 'UPD' + g_q + ','
                        + g_q + 'INS' + g_q + ','
                        + g_q + 'DEL' + g_q + ')';
            if dm.sqlselect( dm.q2, conCPYdet ) then begin
               //funcion para guardar los datos en arreglo para diagramar
               guardaConsulta( dm.q2 );
            end;    // fin de CPY para TAB


            //   *************  BUSCA LOC  *************

            conCPYdet:= 'select * from tsrela' +
                        ' where sistema =' + g_q + cpys[i].sistema + g_q +
                        ' and pcclase=' + g_q + clase_aux + g_q +
                        ' and pcbib=' + g_q + bib_aux + g_q +
                        ' and pcprog=' + g_q + prog_aux + g_q +
                        ' and hcclase=' + g_q + 'LOC' + g_q;
            if dm.sqlselect( dm.q2, conCPYdet ) then begin
               //funcion para guardar los datos en arreglo para diagramar
               guardaConsulta( dm.q2 );
            end;    // fin de CPY para LOC


            //   *************  BUSCA IDX  *************

            conIDX:= 'select * from tsrela' +
                        ' where sistema =' + g_q + cpys[i].sistema + g_q +
                        ' and pcclase=' + g_q + clase_aux + g_q +
                        ' and pcbib=' + g_q + bib_aux + g_q +
                        ' and pcprog=' + g_q + prog_aux + g_q +
                        ' and hcclase = ' + g_q + 'IDX' + g_q +
                        ' and coment= ' + g_q + 'FIND' + g_q;
            if dm.sqlselect( dm.q3, conIDX ) then begin
               while not dm.q3.Eof do begin
                  clase_aux:= dm.q3.FieldByName( 'cclase' ).AsString;
                  bib_aux:= dm.q3.FieldByName( 'cbib' ).AsString;
                  prog_aux:= dm.q3.FieldByName( 'cprog' ).AsString;

                  //Buscando tablas en los indices
                  conIDXprog:= 'select * from tsrela' +
                               ' where sistema =' + g_q + dm.q3.FieldByName( 'sistema' ).AsString + g_q +
                               ' and pcclase=' + g_q + clase_aux + g_q +
                               ' and pcbib=' + g_q + bib_aux + g_q +
                               ' and pcprog=' + g_q + prog_aux + g_q +
                               ' and hcclase = ' + g_q + 'TAB' + g_q;

                  if dm.sqlselect( dm.q2, conIDXprog ) then begin
                     //funcion para guardar los datos en arreglo para diagramar
                     guardaConsulta( dm.q2 );

                  end;   //fin de detalle de tablas de IDX
               dm.q3.Next;
               end;
            end;    // fin de CPY para IDX
         end; //fin del for  para detalles de CPY

      {dm.q1.Next;
      end;      //fin de ciclo principal
   end;}
{   for i:= length(aGLBTsrela)-1 downto 0 do begin
      fmBloques.pintaMemo(aGLBTsrela[i].sOCPROG);
   end;}
end;
//  _____________________________________________________________________________________  //

end.

