unit ufmBloques;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSDiagrama, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBar, dxBarExtItems, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
   DgrCombo, StdCtrls, DgrSelectors, atDiagram, ComCtrls, uConstantes,
  ImgList;

type
   TfmBloques = class( TfmSVSDiagrama )
    Memo1: TMemo;
      procedure atDiagramaDControlDblClick( Sender: TObject;
         ADControl: TDiagramControl );
      procedure FormClose( Sender: TObject; var Action: TCloseAction ); //alk
   private
      { Private declarations }
      Opciones: Tstringlist;

      function ArmarOpciones( b1: Tstringlist ): integer;
   public
      { Public declarations }
      procedure PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
         sParCaption: String );
      procedure pintaMemo(agrega:String);   //Prueba ALK para pintar arreglo en memo
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas,parbol;

{$R *.dfm}

procedure TfmBloques.FormClose( Sender: TObject; var Action: TCloseAction );    //alk
begin
   dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,5);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,5);     //borrar elemento del arreglo de productos
   }
   Action := caFree;
end;

//Prueba ALK para pintar arreglo en memo
procedure TfmBloques.pintaMemo(agrega:String);
begin
   if Memo1.Visible = false then
      Memo1.Clear;

   Memo1.Lines.Add(agrega);
   Memo1.Visible:=true;
end;
//   ------------------------------------

procedure TfmBloques.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
   sParCaption: String );
var
   i: Integer;
begin
   if not (( sParClase = 'CBL' ) or ( sParClase = 'CMA' )) then begin
      Application.MessageBox( 'No se puede generar el Diagrama' + Chr( 13 ) +
         'para este tipo de componente', 'Aviso', MB_OK );
      Exit;
   end;

   gral.PubMuestraProgresBar( True );
   try
      Caption := sParCaption;

      GlbArmaDiagramaBloques( atDiagrama, sParClase, sParBib, sParProg, sParSistema, Caption );

      //guarda en slPubDiagrama informacion para uso posterior
      for i := 0 to length( aGlbBlockAtributos ) - 1 do
         with slPubDiagrama, aGlbBlockAtributos[ i ] do
            if ( TipoBlock = 'FlowActionBlock' ) or
               ( TipoBlock = 'ChevronArrowBlock' ) or
               ( TipoBlock = 'DatabaseBlock' ) or
               ( TipoBlock = 'FlowInputBlock' ) then
               Add( NFisicoBlock + ',' +
                  Clase + ',' + Biblioteca + ',' + Programa + ',' +
                  IntToStr( Columna ) + ',' + IntToStr( Renglon ) + ',' +
                  LigaBlockOrigen + ',' + LigaBlockDestino + ',' + sParsistema );
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmBloques.atDiagramaDControlDblClick( Sender: TObject;
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
         sNombre := slNLogicoBlock[ 3 ] + '|' + slNLogicoBlock[ 2 ] + '|' + slNLogicoBlock[ 1 ]+ '|' + slNLogicoBlock[ 8 ];

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

function TfmBloques.ArmarOpciones( b1: Tstringlist ): integer;
begin
   gral.EjecutaOpcionB( b1, 'Análisis de Impacto' );
end;



end.

