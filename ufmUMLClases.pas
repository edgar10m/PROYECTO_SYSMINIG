unit ufmUMLClases;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSDiagrama, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBar, dxBarExtItems, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
   DgrCombo, StdCtrls, DgrSelectors, atDiagram, ComCtrls, uConstantes,
   ImgList;

type
   TfmUMLClases = class( TfmSVSDiagrama )
      procedure FormActivate( Sender: TObject );
      procedure FormCreate( Sender: TObject );
      procedure FormDestroy( Sender: TObject );
   private
      { Private declarations }

      slPriAtributos: TStringList;
      slPriOperaciones: TStringList;

      procedure PriArmaDiagrama( sParSistema, sParClase, sParBib, sParProg: String;
         sParSubtitulo: String );
      procedure PriLogicaArmado( sParSistema, sParClase, sParBib, sParProg: String );
      procedure PriRegistraBlock(
         sParClase, sParBib, sParProg: String;
         iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
         sParNFisicoBlock, sParNLogicoBlock: String;
         sParTipoBlock: String;
         sParLigaBlockOrigen, sParLigaBlockDestino: String;
         tParColor: TColor;
         sParTexto: String );
      function sPriObtenerNombreClase( sParPrograma: String ): String;
   public
      { Public declarations }
      procedure PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
         sParCaption: String );
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas, ADODB;

{$R *.dfm}

procedure TfmUMLClases.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
   sParCaption: String );
begin
   if not ( ( sParClase = 'JAV' ) or ( sParClase = 'JLA' ) ) then begin
      Application.MessageBox( 'No se puede generar el Diagrama' + Chr( 13 ) +
         'para este tipo de componente', 'Aviso', MB_OK );
      Exit;
   end;

   gral.PubMuestraProgresBar( True );
   try
      Caption := sParCaption;

      PriArmaDiagrama(
         sParSistema, sParClase, sParBib, sParProg, Caption );

      atDiagrama.MoveBlocks( 1, 0, True ); //reacomoda las lineas
      atDiagrama.ClearUndoStack;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmUMLClases.PriArmaDiagrama( sParSistema, sParClase, sParBib, sParProg: String;
   sParSubtitulo: String );
var
   i: Integer;

begin
   GlbNuevoDiagrama( atDiagrama );
   
   iGlbNombreBlock := 0;
   SetLength( dgrcom, 0 );
   SetLength( aGlbBlockAtributos, 0 );

   //crea subtitulo en atDiagrama
   GlbDiagramaSubTitulo( atDiagrama, sParSubtitulo );

   //logica de llenado de aGlbBlockAtributos y asignacion de renglones y columnas.
   PriLogicaArmado( sParSistema, sParClase, sParBib, sParProg );
                                                                    
   //guarda en slPubDiagrama informacion para uso posterior
   for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      with slPubDiagrama, aGlbBlockAtributos[ i ] do begin
         if TipoBlock = 'UMLClassBlock' then
            Add( NFisicoBlock + ',' +
               Clase + ',' + Biblioteca + ',' + Programa + ',' +
               IntToStr( Columna ) + ',' + IntToStr( Renglon ) + ',' +
               LigaBlockOrigen + ',' + LigaBlockDestino );
      end;
   end;

   //crea los block's
   for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      if aGlbBlockAtributos[ i ].TipoBlock = 'UMLClassBlock' then
         GlbBlockFlow( atDiagrama,
            aGlbBlockAtributos[ i ].TipoBlock,
            aGlbBlockAtributos[ i ].NFisicoBlock,
            aGlbBlockAtributos[ i ].Columna,
            aGlbBlockAtributos[ i ].Renglon,
            aGlbBlockAtributos[ i ].Ancho,
            aGlbBlockAtributos[ i ].Alto,
            aGlbBlockAtributos[ i ].Color,
            clBlack,
            aGlbBlockAtributos[ i ].Texto,
            slPriAtributos,
            slPriOperaciones )
      else
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

   //crea las ligas con metodos directos
   for i := 0 to length( aGlbBlockAtributos ) - 1 do
      with aGlbBlockAtributos[ i ] do
         if ( LigaBlockOrigen <> '' ) and
            ( LigaBlockDestino <> '' ) then
            if ( Color = $004080FF ) and
               ( TipoBlock = 'UMLClassBlock' ) then
               GlbLinkPoints( atDiagrama,
                  LigaBlockOrigen, LigaBlockDestino, 6, 9, asLineArrow, psDash )
            else
               GlbLinkPoints( atDiagrama,
                  LigaBlockOrigen, LigaBlockDestino, 9, 6, asLineArrow, psDash );
end;

function TfmUMLClases.sPriObtenerNombreClase( sParPrograma: String ): String;
var
   sPrograma: String;
begin
   sPrograma := sParPrograma;

   if pos( '.', sParPrograma ) > 0 then
      sPrograma := StringReplace( ExtractFileExt( sParPrograma ), '.', '', [ rfReplaceAll ] );

   Result := sPrograma;
end;

procedure TfmUMLClases.PriLogicaArmado( sParSistema, sParClase, sParBib, sParProg: String );
var
   iRepetido: integer;
   sNombreBlockOrigen: String;
   sNombreBlockDestino: String;
   wColor: TColor;
   iRenglon: Integer;
   iColumna: Integer;

   //slListaPaso: TStringList;

   //llena slPriAtributos con los atributos de todas las clases
   procedure ListaAtributos;
   var
      i: Integer;
   begin
      for i := 0 to Length( aGLBTsrela ) - 1 do
         if ( UpperCase( aGLBTsrela[ i ].sPCCLASE ) = 'JLA' ) and
            ( UpperCase( aGLBTsrela[ i ].sHCCLASE ) = 'VAR' ) then
            slPriAtributos.Add(
               Q + aGLBTsrela[ i ].sPCPROG + Q + ',' +
               Q + aGLBTsrela[ i ].sHCPROG + Q + ',' +
               Q + aGLBTsrela[ i ].sEXTERNO + Q + ',' +
               Q + aGLBTsrela[ i ].sMODO + Q );
   end;

   //llena slPriOperaciones con las operaciones de todas las clases
   procedure ListaOperaciones;
   var
      i: Integer;
   begin
      for i := 0 to Length( aGLBTsrela ) - 1 do
         if ( UpperCase( aGLBTsrela[ i ].sPCCLASE ) = 'JLA' ) and
            ( ( UpperCase( aGLBTsrela[ i ].sHCCLASE ) = 'ATR' ) or
            ( UpperCase( aGLBTsrela[ i ].sHCCLASE ) = 'ETP' ) ) then
            slPriOperaciones.Add(
               Q + aGLBTsrela[ i ].sPCPROG + Q + ',' +
               Q + aGLBTsrela[ i ].sHCPROG + Q + ',' +
               Q + aGLBTsrela[ i ].sEXTERNO + Q + ',' +
               Q + aGLBTsrela[ i ].sMODO + Q + ',' +
               Q + aGLBTsrela[ i ].sCOMENT + Q );
   end;

begin
   //obtiene datos de Tsrela y los deposita en aGLBTsrela
   dm.TaladrarTsrela( DrillDown, sParSistema, sParProg, sParBib, sParClase, not bREGISTRA_REPETIDOS );

   ListaAtributos;
   ListaOperaciones;

   {slListaPaso := TStringList.Create; //quitar
   try
      GlbExportaArregloTsrela( slListaPaso );
      slListaPaso.SaveToFile( g_tmpdir + '\mineria_' + sParClase + '_' + sParBib + '_' + sParProg + '.txt' );
   finally
      slListaPaso.Free;
   end;}

   iGlbRenglon := 50;
   iGlbColumna := 250;
   iGlbAncho := 70;
   iGlbAlto := 70;
   iGlbEspacioEntreColumnas := 130;
   iGlbEspacioEntreRenglones := 20;

   inc( iGlbNombreBlock );
   sNombreBlockOrigen := '_' + IntToStr( iGlbNombreBlock ) + '_UMLCLA';
   PriRegistraBlock(
      sParClase, sParBib, sParProg,
      iGlbColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
      sNombreBlockOrigen, sParClase + '|' + sParBib + '|' + sParProg,
      'UMLClassBlock',
      //'', '', $00FCFCFC, sPriObtenerNombreClase( sParProg ) );
      '', '', $00FCFCFC, sParProg );
end;

procedure TfmUMLClases.PriRegistraBlock(
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

procedure TfmUMLClases.FormActivate( Sender: TObject );
begin
   inherited;
   g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE CLASES';
end;

procedure TfmUMLClases.FormCreate( Sender: TObject );
begin
   inherited;

   slPriAtributos := TStringList.Create;
   slPriOperaciones := TStringList.Create;
end;

procedure TfmUMLClases.FormDestroy( Sender: TObject );
begin
   inherited;

   slPriAtributos.Free;
   slPriOperaciones.Free;
end;

end.

