unit ufmUMLClases;

interface

uses                             
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSDiagrama, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBar, dxBarExtItems, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
   DgrCombo, StdCtrls, DgrSelectors, atDiagram, ComCtrls, uConstantes;

type
   TfmUMLClases = class( TfmSVSDiagrama )
    procedure FormActivate(Sender: TObject);
   private
      { Private declarations }
      procedure PriArmaDiagrama( sParClase, sParBib, sParProg: String;
         sParSubtitulo: String );
      procedure PriLogicaArmado( sParClase, sParBib, sParProg: String );
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
      procedure PubGeneraDiagrama( sParClase, sParBib, sParProg: String;
         sParCaption: String );
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas, ADODB;

{$R *.dfm}

procedure TfmUMLClases.PubGeneraDiagrama( sParClase, sParBib, sParProg: String;
   sParCaption: String );
begin
   if not ( sParClase = 'JAV' ) then begin
      Application.MessageBox( 'No se puede generar el Diagrama' + Chr( 13 ) +
         'para este tipo de componente', 'Aviso', MB_OK );
      Exit;
   end;

   gral.PubMuestraProgresBar( True );
   try
      Caption := sParCaption;

      PriArmaDiagrama(
         sParClase, sParBib, sParProg, Caption );

      atDiagrama.MoveBlocks( 1, 0, True ); //reacomoda las lineas
      atDiagrama.ClearUndoStack;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmUMLClases.PriArmaDiagrama( sParClase, sParBib, sParProg: String;
   sParSubtitulo: String );
var
   i: Integer;
   slLinkPoint: TStringList;
   slArchivoDGR: TStringList;

begin
   iGlbNombreBlock := 0;
   SetLength( dgrcom, 0 );
   SetLength( aGlbBlockAtributos, 0 );

   //crea subtitulo en atDiagrama
   GlbDiagramaSubTitulo( atDiagrama, sParSubtitulo );

   //logica de llenado de aGlbBlockAtributos y asignacion de renglones y columnas.
   PriLogicaArmado( sParClase, sParBib, sParProg );

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

   //guarda en tabComponente para mostrar el grid
   {with tabComponente do begin
      if not Active then
         Active := True;

      for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
         if aGlbBlockAtributos[ i ].TipoBlock = 'FlowActionBlock' then begin
            Append;
            FindField( 'Clase' ).AsString := aGlbBlockAtributos[ i ].Clase;
            FindField( 'Biblioteca' ).AsString := aGlbBlockAtributos[ i ].Biblioteca;
            FindField( 'Programa' ).AsString := aGlbBlockAtributos[ i ].Programa;
            FindField( 'Renglon' ).AsInteger := aGlbBlockAtributos[ i ].Renglon;
            FindField( 'Columna' ).AsInteger := aGlbBlockAtributos[ i ].Columna;
            FindField( 'NFisicoBlock' ).AsString := aGlbBlockAtributos[ i ].NFisicoBlock;
            FindField( 'NLogicoBlock' ).AsString := aGlbBlockAtributos[ i ].NLogicoBlock;
            FindField( 'LigaBlockOrigen' ).AsString := aGlbBlockAtributos[ i ].LigaBlockOrigen;
            FindField( 'LigaBlockDestino' ).AsString := aGlbBlockAtributos[ i ].Li
            gaBlockDestino;
            FindField( 'TipoBlock' ).AsString := aGlbBlockAtributos[ i ].TipoBlock;
            //Post;
         end;
      end;
   end;}

   //crea los block's
   for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      //with ftsmain.dxBarProgress do
         //if Visible = ivAlways then begin
         //   StepIt;
         //   ftsmain.Refresh
         //end;// crea rutina

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

   {//crea las ligas a traves de un TStringList armado
   atDiagrama.SaveToFile( Caption + '.dgr' );
   slLinkPoint := Tstringlist.Create;
   try
      for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
         if ( aGlbBlockAtributos[ i ].LigaBlockOrigen <> '' ) and
            ( aGlbBlockAtributos[ i ].LigaBlockDestino <> '' ) then

            if aGlbBlockAtributos[ i ].Nivel > 1 then
               GlbLinkPointsV3( i,
                  aGlbBlockAtributos[ i ].NFisicoBlock,
                  aGlbBlockAtributos[ i ].Columna, aGlbBlockAtributos[ i ].Renglon,
                  aGlbBlockAtributos[ i ].Ancho, aGlbBlockAtributos[ i ].Alto,
                  aGlbBlockAtributos[ i ].LigaBlockOrigen, aGlbBlockAtributos[ i ].LigaBlockDestino, 1, 0,
                  slLinkPoint, 'asLineArrow', 'psSolid' );
      end;

      //guardar dgr y pegarle el contenido de slLinkPoint
      slArchivoDGR := Tstringlist.Create;
      try
         slArchivoDGR.LoadFromFile( Caption + '.dgr' );
         slArchivoDGR.Delete( slArchivoDGR.Count - 1 );
         slArchivoDGR.Add( slLinkPoint.Text );
         slArchivoDGR.Add( 'end' );
         slArchivoDGR.SaveToFile( Caption + '.dgr' );
      finally
         slArchivoDGR.Free;
      end;
   finally
      slLinkPoint.Free;
   end;
   atDiagrama.LoadFromFile( Caption + '.dgr' );
   DeleteFile( Caption + '.dgr' );
   /// fin de crea las ligas a traves de un TStringList armado (slLinkPoint)}
end;

function TfmUMLClases.sPriObtenerNombreClase( sParPrograma: String ): String;
var
   //i: Integer;
   //slPrograma: TStringList;
   sPrograma: String;
begin
   sPrograma := sParPrograma;

   if pos( '.', sParPrograma ) > 0 then
      sPrograma := StringReplace( ExtractFileExt( sParPrograma ),'.','',[ rfReplaceAll ] );

   Result := sPrograma;
end;

procedure TfmUMLClases.PriLogicaArmado( sParClase, sParBib, sParProg: String );
var
   iRepetido: integer;
   qPaquetes: Tadoquery;

   sNombreBlockOrigen: String;
   sNombreBlockDestino: String;

   sNombrePrograma: String;
   wColor: TColor;
   iRenglon: Integer;
   iColumna: Integer;

begin
   iGlbRenglon := 50;
   iGlbColumna := 250; //300; //250

   iGlbAncho := 70; //80;
   iGlbAlto := 70;
   iGlbEspacioEntreColumnas := 130; //130
   iGlbEspacioEntreRenglones := 20;

   inc( iGlbNombreBlock );
   sNombreBlockOrigen := '_' + IntToStr( iGlbNombreBlock ) + '_UMLPAQ';
   PriRegistraBlock(
      sParClase, sParBib, sParProg,
      iGlbColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
      sNombreBlockOrigen, sParClase + '|' + sParBib + '|' + sParProg,
      'UMLClassBlock',
      '', '', $00FCFCFC, sPriObtenerNombreClase( sParProg ) );

   qPaquetes := Tadoquery.Create( nil );
   try
      qPaquetes.Connection := dm.ADOConnection1;

      iGlbRenglon := 50;
      iRenglon := iGlbRenglon;
      if dm.sqlselect( qPaquetes,
         ' SELECT HCPROG,HCBIB,HCCLASE' +
         ' FROM TSRELA' +
         ' WHERE ' +
         '    PCPROG = ' + g_q + sParProg + g_q +
         '    AND PCBIB = ' + g_q + sParBib + g_q +
         '    AND PCCLASE = ' + g_q + sParClase + g_q +
         '    AND HCBIB = ' + g_q + 'SCRATCH' + g_q +
         '    AND HCCLASE = ' + g_q + 'JAV' + g_q +
         ' GROUP BY HCPROG,HCBIB,HCCLASE' +
         ' ORDER BY HCPROG,HCBIB,HCCLASE' ) then begin
         with qPaquetes do begin
            while not Eof do begin
               sNombrePrograma := sPriObtenerNombreClase( FieldByName( 'HCPROG' ).AsString );

               iRepetido := dgr_repetido( sParClase, sParBib, sNombrePrograma, 0, 0, '' );
               if iRepetido = -1 then begin // no repetido
                  if iRenglon <> iGlbRenglon then
                     iGlbRenglon := iGlbRenglon + iGlbAlto + iGlbEspacioEntreRenglones;

                  wColor := $004AFF4A;
                  iColumna := iGlbColumna + iGlbAncho + iGlbEspacioEntreColumnas;

                  if FieldByName( 'HCBIB' ).AsString = 'SCRATCH' then begin
                     wColor := $004080FF;
                     iColumna := iGlbColumna - iGlbEspacioEntreColumnas - iGlbAncho;
                  end;

                  inc( iGlbNombreBlock );
                  sNombreBlockDestino := '_' + IntToStr( iGlbNombreBlock ) + '_UMLPAQ';
                  PriRegistraBlock(
                     FieldByName( 'HCCLASE' ).AsString, FieldByName( 'HCBIB' ).AsString, FieldByName( 'HCPROG' ).AsString,
                     iColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
                     sNombreBlockDestino,
                     FieldByName( 'HCCLASE' ).AsString + '|' + FieldByName( 'HCBIB' ).AsString + '|' + FieldByName( 'HCPROG' ).AsString,
                     'UMLClassBlock',
                     sNombreBlockOrigen, sNombreBlockDestino, wColor, sNombrePrograma );

                  iRenglon := iRenglon + 1
               end;

               Next;
            end;
         end;
      end;
      ///
      iGlbRenglon := 50;
      iRenglon := iGlbRenglon;
      if dm.sqlselect( qPaquetes,
         ' SELECT HCPROG,HCBIB,HCCLASE' +
         ' FROM TSRELA' +
         ' WHERE ' +
         '    PCPROG = ' + g_q + sParProg + g_q +
         '    AND PCBIB = ' + g_q + sParBib + g_q +
         '    AND PCCLASE = ' + g_q + sParClase + g_q +
         '    AND HCBIB <> ' + g_q + 'SCRATCH' + g_q +
         '    AND HCCLASE = ' + g_q + 'JAV' + g_q +
         ' GROUP BY HCPROG,HCBIB,HCCLASE' +
         ' ORDER BY HCPROG,HCBIB,HCCLASE' ) then begin
         with qPaquetes do begin
            while not Eof do begin
               sNombrePrograma := sPriObtenerNombreClase( FieldByName( 'HCPROG' ).AsString );

               iRepetido := dgr_repetido( sParClase, sPArBib, sNombrePrograma, 0, 0, '' );
               if iRepetido = -1 then begin // no repetido
                  if iRenglon <> iGlbRenglon then
                     iGlbRenglon := iGlbRenglon + iGlbAlto + iGlbEspacioEntreRenglones;

                  wColor := $004AFF4A;
                  iColumna := iGlbColumna + iGlbAncho + iGlbEspacioEntreColumnas;

                  if FieldByName( 'HCBIB' ).AsString = 'SCRATCH' then begin
                     wColor := $004080FF;
                     iColumna := iGlbColumna - iGlbEspacioEntreColumnas - iGlbAncho;
                  end;

                  inc( iGlbNombreBlock );
                  sNombreBlockDestino := '_' + IntToStr( iGlbNombreBlock ) + '_UMLPAQ';
                  PriRegistraBlock(
                     FieldByName( 'HCCLASE' ).AsString, FieldByName( 'HCBIB' ).AsString, FieldByName( 'HCPROG' ).AsString,
                     iColumna, iGlbRenglon, iGlbAncho, iGlbAlto,
                     sNombreBlockDestino,
                     FieldByName( 'HCCLASE' ).AsString + '|' + FieldByName( 'HCBIB' ).AsString + '|' + FieldByName( 'HCPROG' ).AsString,
                     'UMLClassBlock',
                     sNombreBlockOrigen, sNombreBlockDestino, wColor, sNombrePrograma );

                  iRenglon := iRenglon + 1
               end;                                

               Next;
            end;
         end;
      end;

   finally
      qPaquetes.Free;
   end;
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

procedure TfmUMLClases.FormActivate(Sender: TObject);
begin
  inherited;
   g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE CLASES';
end;

end.

