unit ufmScheduler;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSDiagrama, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBar, dxBarExtItems, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
   DgrCombo, StdCtrls, DgrSelectors, atDiagram, ComCtrls, uConstantes,
  ImgList;

type
   TfmScheduler = class( TfmSVSDiagrama )
      mnuSelDependencias: TdxBarSubItem;
      mnuSelDepAbajo: TdxBarButton;
      mnuSelDepArriba: TdxBarButton;
      procedure atDiagramaDControlDblClick( Sender: TObject;
         ADControl: TDiagramControl );
      procedure mnuSelDepAbajoClick( Sender: TObject );
      procedure mnuSelDepArribaClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction ); //alk
   private
      { Private declarations }
      sPriClaseInicial: String;
      Opciones: Tstringlist;

      procedure PriArmaDiagrama( sParClase, sParBib, sParProg, SParSistema: String;
         sParSubtitulo: String );
      procedure PriLogicaArmado( sParClase, sParBib, sParProg, sParSistema: String );
      procedure PriRegistraBlock(
         sParClase, sParBib, sParProg: String;
         iParColumna, iParRenglon, iParAncho, iParAlto: Integer;
         sParNFisicoBlock, sParNLogicoBlock: String;
         sParTipoBlock: String;
         sParLigaBlockOrigen, sParLigaBlockDestino: String;
         tParColor: TColor;
         sParTexto: String );
      procedure PriTaladrar(
         sParClase, sParBib, sParProg, sParSistema: String;
         sParNombreBlockLink: String ); //(DrillDown, DrillTop)

      procedure PriSeleccionarDependencias( selParSelDependencia: TSelDependencia );

      function ArmarOpciones( b1: Tstringlist ): integer;
   public
      { Public declarations }
      sistema : string;  //para obtener el sistma
      procedure PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
         sParCaption: String );
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas, ADODB, FlowchartBlocks,parbol;

{$R *.dfm}

procedure TfmScheduler.FormClose( Sender: TObject; var Action: TCloseAction );    //alk
begin
   dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,4);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,4);     //borrar elemento del arreglo de productos
   }
   Action := caFree;
end;

procedure TfmScheduler.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
   sParCaption: String );
begin
   sistema:=sParSistema;
   if not ( ( sParClase = 'CTR' ) or ( sParClase = 'CTM' ) ) then begin
      Application.MessageBox( 'No se puede generar el Diagrama' + Chr( 13 ) +
         'para este tipo de componente', 'Aviso', MB_OK );
      Exit;
   end;

   gral.PubMuestraProgresBar( True );
   try
      Caption := sParCaption;

      PriArmaDiagrama(
         sParClase, sParBib, sParProg, sParSistema, Caption );

      atDiagrama.MoveBlocks( 1, 0, True ); //reacomoda las lineas
      atDiagrama.ClearUndoStack;
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmScheduler.PriArmaDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
   sParSubtitulo: String );
var
   i: Integer;
   slLinkPoint: TStringList;
   slArchivoDGR: TStringList;
   sArchivoPaso: String;
begin
   GlbNuevoDiagrama( atDiagrama );
   
   iGlbNombreBlock := 0;
   SetLength( dgrcom, 0 ); //control para los repetidos, checar rutina y hacerla global
   SetLength( aGlbBlockAtributos, 0 );

   //crea subtitulo en atDiagrama
   GlbDiagramaSubTitulo( atDiagrama, sParSubtitulo );

   //logica de llenado de aGlbBlockAtributos y asignacion de renlones y columnas.
   PriLogicaArmado( sParClase, sParBib, sParProg, sParSistema );

   //guarda en slPubDiagrama informacion para uso posterior
   for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      with slPubDiagrama, aGlbBlockAtributos[ i ] do begin
         if ( TipoBlock = 'FlowActionBlock' ) or ( TipoBlock = 'FlowTerminalBlock' ) then
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
            //FindField( 'Desplaza' ).AsInteger := aGlbBlockAtributos[ i ].Desplaza;
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
   {for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
      if ( aGlbBlockAtributos[ i ].LigaBlockOrigen <> '' ) and
         ( aGlbBlockAtributos[ i ].LigaBlockDestino <> '' ) then
         if aGlbBlockAtributos[ i ].TipoBlock = 'FlowActionBlock' then
            GlbLinkPoints( atDiagrama,
               aGlbBlockAtributos[ i ].LigaBlockOrigen,
               aGlbBlockAtributos[ i ].LigaBlockDestino, 1, 0, asLineArrow, psSolid )
   end;}

   //crea las ligas a traves de un TStringList armado
   slLinkPoint := Tstringlist.Create;
   try
      for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
         if ( aGlbBlockAtributos[ i ].LigaBlockOrigen <> '' ) and
            ( aGlbBlockAtributos[ i ].LigaBlockDestino <> '' ) then

            if aGlbBlockAtributos[ i ].Nivel > 1 then
               //GlbLinkPointsV3( i,
               GlbLinkPoints( i,
                  aGlbBlockAtributos[ i ].NFisicoBlock,
                  aGlbBlockAtributos[ i ].Columna, aGlbBlockAtributos[ i ].Renglon,
                  aGlbBlockAtributos[ i ].Ancho, aGlbBlockAtributos[ i ].Alto,
                  aGlbBlockAtributos[ i ].LigaBlockOrigen, aGlbBlockAtributos[ i ].LigaBlockDestino, 1, 0,
                  slLinkPoint, 'asLineArrow', 'TDiagramLine', 'psSolid' );
      end;

      //guardar dgr y pegarle el contenido de slLinkPoint
      sArchivoPaso := g_tmpdir + '\paso.dgr';
      //sArchivoPaso := Caption + '.dgr';

      atDiagrama.SaveToFile( sArchivoPaso );
      slArchivoDGR := Tstringlist.Create;
      try
         slArchivoDGR.LoadFromFile( sArchivoPaso );
         for i := 0 to slArchivoDGR.Count - 1 do begin //asi hace que las lineas sean send to back
            if pos( 'object SUBTITULO', slArchivoDGR[ i ] ) > 0 then begin
               slArchivoDGR[ i ] := slLinkPoint.Text + ' ' + slArchivoDGR[ i ];
               Break;
            end;
         end;
         slArchivoDGR.SaveToFile( sArchivoPaso );
      finally
         slArchivoDGR.Free;
      end;

   finally
      slLinkPoint.Free;
   end;
   atDiagrama.LoadFromFile( sArchivoPaso );
   DeleteFile( sArchivoPaso );
   /// fin de crea las ligas a traves de un TStringList armado (slLinkPoint)
end;

procedure TfmScheduler.PriTaladrar(
   sParClase, sParBib, sParProg, sParSistema: String;
   sParNombreBlockLink: String ); //(DrillDown, DrillTop)
var
   iRepetido: Integer;
   sNombreBlock: String;
   qConsulta: TAdoQuery;
   sTipoBlock: String;
   sWhereHCCLASE: String;
   ColorBlock: Tcolor;
   consulta:string;
begin
   sistema:=sParSistema;
   iGlbAncho := 55; //52
   iGlbAlto := 20;

   if ( sParClase = 'CTR' ) or ( sParClase = 'CTM' ) then begin
      sTipoBlock := 'FlowActionBlock';
      ColorBlock := $00CCFFFF; //10092543;
   end
   else if sParClase = 'JOB' then begin
      sTipoBlock := 'FlowTerminalBlock'; //'DFDProcessBlock';
      ColorBlock := 16764057;
   end;

   if sPriClaseInicial = 'CTR' then
      sWhereHCCLASE := ' AND HCCLASE = ' + g_q + 'CTM' + g_q;
   if sPriClaseInicial = 'CTM' then
      sWhereHCCLASE := ' AND HCCLASE IN (' + g_q + 'CTM' + g_q + ',' + g_q + 'JOB' + g_q + ')';

   inc( iGlbNombreBlock );
   sNombreBlock := '_' + IntToStr( iGlbNombreBlock ) + '_SCH';

   iRepetido := dgr_repetido( sParClase, sParBib, sParProg, sParSistema, 0, 0, '' );
   if iRepetido = -1 then begin // no existe
      if iGlbNombreBlock = 1 then //color al primer block
         ColorBlock := clYellow;

      PriRegistraBlock(
         sParClase, sParBib, sParProg,
         0, 0, iGlbAncho, iGlbAlto,
         sNombreBlock, sParClase + '|' + sParBib + '|' + sParProg,
         sTipoBlock, //'FlowActionBlock',
         sParNombreBlockLink, sNombreBlock, ColorBlock, //10092543,
         sParProg );

      qConsulta := Tadoquery.Create( nil );
      try
         qConsulta.Connection := dm.ADOConnection1;

         consulta:=' SELECT HCPROG,HCBIB,HCCLASE,HSISTEMA' +   //falta sistema!!!  alk
            ' FROM TSRELA' +
            ' WHERE' +
            '    PCPROG = ' + g_q + sParProg + g_q +
            '    AND PCBIB = ' + g_q + sParBib + g_q +
            '    AND PCCLASE = ' + g_q + sParClase + g_q +
            //'    AND HCCLASE = ' + g_q + 'CTM' + g_q +
            //'    AND HCCLASE in (' + g_q + 'CTM' + g_q + ',' + g_q + 'JOB' + g_q + ')' +
            sWhereHCCLASE +
            ' ORDER BY ORDEN';

         if dm.sqlselect( qConsulta, consulta ) then begin
            while not qConsulta.Eof do begin
               PriTaladrar(
                  qConsulta.FieldByName( 'HCCLASE' ).AsString,
                  qConsulta.FieldByName( 'HCBIB' ).AsString,
                  qConsulta.FieldByName( 'HCPROG' ).AsString,
                  qConsulta.FieldByName( 'HSISTEMA' ).AsString,
                  sNombreBlock );

               qConsulta.Next;
            end;
         end;
      finally
         qConsulta.Free;
      end;
   end
   else begin
      PriRegistraBlock(
         sParClase, sParBib, sParProg,
         0, 0, iGlbAncho, iGlbAlto,
         sNombreBlock, sParClase + '|' + sParBib + '|' + sParProg,
         sTipoBlock, //'FlowTerminalBlock',
         sParNombreBlockLink, sNombreBlock, 13434828, sParProg );
   end;
end;

procedure TfmScheduler.PriLogicaArmado( sParClase, sParBib, sParProg, sParSistema: String );
type
   TNivelBlockEnc = record
      BlockPadre: String;
      Nivel: Integer;
      Total: Integer;
   end;

   TNivelBlockDet = record
      BlockPadre: String;
      Nivel: Integer;
      NFisicoBlock: String;
   end;

var
   aNivelBlockDet: array of TNivelBlockDet;
   aNivelBlockEnc: array of TNivelBlockEnc;
   iLongBlockDet: Integer;
   iLongBlockEnc: Integer;

   procedure ListaBlocksPadre( slParBlocks: TStringList ); //lista de blocks padre
   var
      i: Integer;
      sNombreBlock: String;
   begin
      sNombreBlock := '';
      for i := 0 to Length( aGlbBlockAtributos ) - 1 do
         if aGlbBlockAtributos[ i ].LigaBlockOrigen <> '' then
            if sNombreBlock <> aGlbBlockAtributos[ i ].LigaBlockOrigen then begin
               if pos( aGlbBlockAtributos[ i ].LigaBlockOrigen, slParBlocks.Text ) = 0 then
                  slParBlocks.Add( aGlbBlockAtributos[ i ].LigaBlockOrigen );

               sNombreBlock := aGlbBlockAtributos[ i ].LigaBlockOrigen;
            end;
   end;

   function iRenglonBlock( sParBlock: String; var iParNivel: Integer ): Integer; //busca el renglon del padre
   var
      i: Integer;
   begin
      Result := 0;
      for i := 0 to length( aGlbBlockAtributos ) - 1 do
         if aGlbBlockAtributos[ i ].NFisicoBlock = sParBlock then begin
            iParNivel := aGlbBlockAtributos[ i ].Nivel;
            Result := aGlbBlockAtributos[ i ].Renglon;
            Break;
         end;
   end;

   procedure NivelesBlocks( sParBlockPadre: String; iParNivel: Integer; sParBlockName: String );

      procedure Taladrar( sParBlockName: String );
      var
         i, j: Integer;
         bExisteEnc: Boolean;
      begin
         for i := 0 to length( aGlbBlockAtributos ) - 1 do begin
            if ( aGlbBlockAtributos[ i ].LigaBlockOrigen = sParBlockName ) and
               ( aGlbBlockAtributos[ i ].LigaBlockDestino <> '' ) then begin

               iLongBlockDet := Length( aNivelBlockDet );
               SetLength( aNivelBlockDet, iLongBlockDet + 1 );

               aNivelBlockDet[ iLongBlockDet ].BlockPadre := sParBlockPadre;
               aNivelBlockDet[ iLongBlockDet ].Nivel := aGlbBlockAtributos[ i ].Nivel;
               aNivelBlockDet[ iLongBlockDet ].NFisicoBlock := aGlbBlockAtributos[ i ].LigaBlockDestino;

               bExisteEnc := False;
               for j := 0 to length( aNivelBlockEnc ) - 1 do begin
                  if ( aNivelBlockEnc[ j ].Nivel = aGlbBlockAtributos[ i ].Nivel ) and
                     ( aNivelBlockEnc[ j ].BlockPadre = sParBlockPadre ) then begin
                     aNivelBlockEnc[ j ].Total := aNivelBlockEnc[ j ].Total + 1;
                     bExisteEnc := True;
                  end;
               end;

               if not bExisteEnc then begin
                  iLongBlockEnc := Length( aNivelBlockEnc );
                  SetLength( aNivelBlockEnc, iLongBlockEnc + 1 );
                  aNivelBlockEnc[ iLongBlockEnc ].BlockPadre := sParBlockPadre;
                  aNivelBlockEnc[ iLongBlockEnc ].Nivel := aGlbBlockAtributos[ i ].Nivel;
                  aNivelBlockEnc[ iLongBlockEnc ].Total := 1;
               end;

               Taladrar( aGlbBlockAtributos[ i ].LigaBlockDestino );
            end;
         end;
      end;

   begin
      SetLength( aNivelBlockEnc, 0 );
      SetLength( aNivelBlockDet, 0 );

      iLongBlockEnc := Length( aNivelBlockEnc );
      SetLength( aNivelBlockEnc, iLongBlockEnc + 1 );
      aNivelBlockEnc[ iLongBlockEnc ].BlockPadre := sParBlockPadre;
      aNivelBlockEnc[ iLongBlockEnc ].Nivel := iParNivel;
      aNivelBlockEnc[ iLongBlockEnc ].Total := 1;

      iLongBlockDet := Length( aNivelBlockDet );
      SetLength( aNivelBlockDet, iLongBlockDet + 1 );
      aNivelBlockDet[ iLongBlockDet ].BlockPadre := sParBlockPadre;
      aNivelBlockDet[ iLongBlockDet ].Nivel := iParNivel;
      aNivelBlockDet[ iLongBlockDet ].NFisicoBlock := sParBlockName;

      Taladrar( sParBlockName );
   end;

   function iMaxBlocksNivel( sParBlock: String ): Integer;
   var
      i: Integer;
      iMax: Integer;
   begin
      iMax := 0;

      for i := 0 to Length( aNivelBlockEnc ) - 1 do
         if aNivelBlockEnc[ i ].BlockPadre = sParBlock then
            if iMax < aNivelBlockEnc[ i ].Total then
               iMax := aNivelBlockEnc[ i ].Total;

      Result := iMax;
   end;

   procedure AsignarColumnasBlocks(
      sParBlock: String; iMaxTotal: Integer; var iParColumnaIni: Integer );
   var
      i, j, k: Integer;
      iTotalAncho: Integer;
      iReglaTres, iColumnaInicial: Integer;
   begin
      iTotalAncho := iMaxTotal * ( iGlbAncho + iGlbEspacioEntreColumnas );

      for i := 0 to Length( aNivelBlockEnc ) - 1 do
         if aNivelBlockEnc[ i ].BlockPadre = sParBlock then begin
            iReglaTres := Trunc( ( iTotalAncho * aNivelBlockEnc[ i ].Total ) / iMaxTotal );
            if iTotalAncho - iReglaTres > 0 then
               iColumnaInicial := Trunc( ( iTotalAncho - iReglaTres ) / 2 )
            else
               iColumnaInicial := 0;

            iGlbColumna := iColumnaInicial;
            for j := 0 to Length( aNivelBlockDet ) - 1 do
               if ( aNivelBlockEnc[ i ].BlockPadre = aNivelBlockDet[ j ].BlockPadre ) and
                  ( aNivelBlockEnc[ i ].Nivel = aNivelBlockDet[ j ].Nivel ) then
                  for k := 0 to length( aGlbBlockAtributos ) - 1 do
                     if aNivelBlockDet[ j ].NFisicoBlock = aGlbBlockAtributos[ k ].NFisicoBlock then begin
                        aGlbBlockAtributos[ k ].Columna := iParColumnaIni + iGlbColumna;
                        iGlbColumna := iGlbColumna + iGlbAncho + iGlbEspacioEntreColumnas;
                     end;
         end;

      iParColumnaIni := iParColumnaIni + iTotalAncho;
   end;

var
   i, j: Integer;
   slBlocksPadre: TStringList;

   iNivel: Integer;
   iMaximoTotal: Integer;
   iColumnaIni: Integer;

begin
   sPriClaseInicial := sParClase;
   sistema:=sParSistema;

   PriTaladrar( sParClase, sParBib, sParProg, SParSistema, '' ); //obtiene datos de Tsrela

   iGlbRenglon := 50; //desde este renglon empieza a diagramar
   //iGlbEspacioEntreRenglones := 25;

   slBlocksPadre := TStringlist.Create;
   try
      //// Alineacion Vertical
      ListaBlocksPadre( slBlocksPadre );

      aGlbBlockAtributos[ 0 ].Renglon := iGlbRenglon;
      aGlbBlockAtributos[ 0 ].Nivel := 0;
      for j := 0 to slBlocksPadre.Count - 1 do begin
         iGlbRenglon := iRenglonBlock( slBlocksPadre[ j ], iNivel );

         for i := 0 to length( aGlbBlockAtributos ) - 1 do
            if slBlocksPadre[ j ] = aGlbBlockAtributos[ i ].LigaBlockOrigen then
               if aGlbBlockAtributos[ i ].Renglon = 0 then begin
                  aGlbBlockAtributos[ i ].Renglon := iGlbRenglon + iGlbAlto + iGlbEspacioEntreRenglones;
                  aGlbBlockAtributos[ i ].Nivel := iNivel + 1;
               end;
      end;

      //// Alineacion Horizontal - Blocks Padre
      aGlbBlockAtributos[ 0 ].Columna := iGlbEspacioEntreColumnas;

      //columna inicial donde empieza a diagramar horizontal
      iColumnaIni := ( iGlbAncho + iGlbEspacioEntreColumnas ) * 2; //ó iGlbEspacioEntreColumnas;

      for i := Length( aGlbBlockAtributos ) - 1 downto 0 do
         //for i := 1 to Length( aGlbBlockAtributos ) - 1 do // empieza en nivel 1
         if aGlbBlockAtributos[ i ].Nivel = 1 then
            if pos( aGlbBlockAtributos[ i ].NFisicoBlock, slBlocksPadre.Text ) > 0 then begin //Block Padre
               //alimenta arreglos: aNivelBlockEnc, aNivelBlockDet
               NivelesBlocks( aGlbBlockAtributos[ i ].NFisicoBlock,
                  aGlbBlockAtributos[ i ].Nivel, aGlbBlockAtributos[ i ].NFisicoBlock );

               //maximo total de blocks en un nivel por block padre
               iMaximoTotal := iMaxBlocksNivel( aGlbBlockAtributos[ i ].NFisicoBlock );

               //Asignar columnas de acuerdo con los niveles y maximo total de blocks
               AsignarColumnasBlocks(
                  aGlbBlockAtributos[ i ].NFisicoBlock, iMaximoTotal, iColumnaIni );
            end;

      //// Alineacion de blocks NO Padre
      iGlbColumna := iGlbEspacioEntreColumnas; //iColumnaIni;
      iGlbRenglon := 50 + iGlbAlto + iGlbEspacioEntreRenglones; //iGlbRenglon; // + iGlbEspacioEntreRenglones;
      for i := 1 to Length( aGlbBlockAtributos ) - 1 do // empieza en nivel 1
         if aGlbBlockAtributos[ i ].Nivel = 1 then
            if pos( aGlbBlockAtributos[ i ].NFisicoBlock, slBlocksPadre.Text ) = 0 then begin //Block NO Padre
               aGlbBlockAtributos[ i ].Columna := iGlbColumna + iGlbEspacioEntreColumnas;
               aGlbBlockAtributos[ i ].Renglon := iGlbRenglon;

               iGlbRenglon := iGlbRenglon + iGlbAlto + iGlbEspacioEntreRenglones;
               //iGlbColumna := iGlbColumna + iGlbAncho + iGlbEspacioEntreColumnas;
            end;

   finally
      slBlocksPadre.Free;
   end;
end;

procedure TfmScheduler.PriRegistraBlock(
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

procedure TfmScheduler.atDiagramaDControlDblClick( Sender: TObject;
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
      for i := 0 to slPubDiagrama.Count - 1 do
         if pos( ADControl.Name, slPubDiagrama[ i ] ) > 0 then begin
            slNLogicoBlock.CommaText := slPubDiagrama[ i ];

            Break;
         end;

      if slNLogicoBlock.Count > 0 then begin
         //ShowMessage(slNLogicoBlock.CommaText);
         sNombre := slNLogicoBlock[ 3 ] + '|' + slNLogicoBlock[ 2 ] + '|' + slNLogicoBlock[ 1 ] + '|' + sistema;

         bgral := sNombre;
         Opciones := gral.ArmarMenuConceptualWeb( bgral, '' );

         y := ArmarOpciones( Opciones );
         gral.PopGral.Popup( g_X, g_Y );
      end;
   finally
      slNLogicoBlock.Free;
      screen.Cursor := crdefault;
   end;
end;

function TfmScheduler.ArmarOpciones( b1: Tstringlist ): integer;
begin
   //gral.EjecutaOpcionB( b1, 'Análisis de Impacto' );
   gral.EjecutaOpcionB( b1, '' );
end;

procedure TfmScheduler.mnuSelDepAbajoClick( Sender: TObject );
begin
   inherited;

   PriSeleccionarDependencias( selAbajo );
end;

procedure TfmScheduler.mnuSelDepArribaClick( Sender: TObject );
begin
   inherited;

   PriSeleccionarDependencias( selArriba );
end;

procedure TfmScheduler.PriSeleccionarDependencias( selParSelDependencia: TSelDependencia );
var
   i: Integer;
   dcControl, dcControlLink: TDiagramControl;
   sClassName: String;
   sNFisicoBlock: String;
   slBlocksMarcar: TStringList;

   procedure ObtenerBlocksSeleccionar( sParBlockName: String );
   var
      i: Integer;
      slBlocks: TStringList;
      slBlockOrigen: TStringList;
   begin
      slBlocksMarcar.Add( sParBlockName );

      slBlocks := Tstringlist.Create;
      try
         slBlocks.Assign( slPubDiagrama );

         for i := 0 to slBlocks.Count - 1 do
            if pos( sParBlockName, slBlocks[ i ] ) > 0 then begin
               slBlockOrigen := Tstringlist.Create;
               try
                  slBlockOrigen.CommaText := slBlocks[ i ];

                  if ( slBlockOrigen[ 6 ] <> '' ) and
                     ( slBlockOrigen[ 7 ] <> '' ) then
                     case selParSelDependencia of
                        selAbajo:
                           if slBlockOrigen[ 6 ] = sParBlockName then
                              ObtenerBlocksSeleccionar( slBlockOrigen[ 7 ] );
                        selArriba:
                           if slBlockOrigen[ 7 ] = sParBlockName then
                              ObtenerBlocksSeleccionar( slBlockOrigen[ 6 ] );
                     end;
               finally
                  slBlockOrigen.Free;
               end;
            end;

      finally
         slBlocks.Free;
      end;
   end;

begin
   inherited;

   if atDiagrama.SelectedCount( ) < 1 then begin
      Application.MessageBox( 'Seleccione un Block.', 'Aviso', MB_OK );
      Exit;
   end;

   if atDiagrama.SelectedCount( ) > 1 then begin
      Application.MessageBox( 'Para esta acción NO debe seleccionar más de un Block.', 'Aviso', MB_OK );
      Exit;
   end;

   for i := 0 to atDiagrama.SelectedCount( ) - 1 do
      dcControl := atDiagrama.Selecteds[ i ];

   sClassName := UpperCase( dcControl.ClassName );
   if not ( ( sClassName = 'TFLOWACTIONBLOCK' ) or ( sClassName = 'TFLOWTERMINALBLOCK' ) ) then begin
      Application.MessageBox( 'Seleccione un Block para esta acción', 'Aviso', MB_OK );
      Exit;
   end;

   sNFisicoBlock := dcControl.Name;

   slBlocksMarcar := Tstringlist.Create;
   try
      Screen.Cursor := crSqlWait;

      ObtenerBlocksSeleccionar( sNFisicoBlock );

      for i := 0 to slBlocksMarcar.Count - 1 do begin
         dcControlLink := atDiagrama.FindDControl( slBlocksMarcar[ i ] );
         dcControlLink.Selected := True;
         {with ( dcControlLink as TFlowActionBlock ) do begin
            Selected := True;
            //Pen.Color := clBlue;
            //Pen.Width := 3;
            //BringToFront;
         end;}
      end;

   finally
      Screen.Cursor := crDefault;
      slBlocksMarcar.Free;
   end;
end;

procedure TfmScheduler.FormActivate( Sender: TObject );
begin
   inherited;
   g_producto := 'MENÚ CONTEXTUAL-SHEDULER';
end;

end.

