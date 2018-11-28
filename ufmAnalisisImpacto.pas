unit ufmAnalisisImpacto;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSDiagrama, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBar, dxBarExtItems, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
   DgrCombo, StdCtrls, DgrSelectors, atDiagram, ComCtrls, uConstantes,
   ImgList,ADODB,shellapi;

type
   TfmAnalisisImpacto = class( TfmSVSDiagrama )
    SaveDialog1: TSaveDialog;
      procedure atDiagramaDControlDblClick( Sender: TObject;
         ADControl: TDiagramControl );
      procedure mnuExportarExcelClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction ); //alk
      procedure mnuExportarPDFClick( Sender: TObject );
   private
      { Private declarations }
      Opciones: Tstringlist;
      numero_registros:integer;
      Clase, Bib, Prog: String;
      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure exporta_texto( sParClase, sParBib, sParProg: String);
   public
      { Public declarations }
      procedure PubGeneraDiagrama( sParClase, sParBib, sParProg: String;
         sParSistema: String; sParCaption: String );
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas, HTML_HELP,parbol;

{$R *.dfm}
procedure TfmAnalisisImpacto.mnuExportarPDFClick( Sender: TObject );
begin
   if numero_registros>500 then begin
      if application.MessageBox('Involucra más de 2000 registros, desea exportar a formato texto separado por comas?','Aviso',MB_YESNO)=IDYES then
         dm.exporta_texto_GlbBlockAtributos('Analisis de impacto',clase,bib,prog);
      exit;
   end;
   inherited;
end;
procedure TfmAnalisisImpacto.exporta_texto( sParClase, sParBib, sParProg: String);
var qq:TADOquery;         // parece que se cicla. No es confiable y no se usa
  F: TextFile;
  i,previo:integer;
  x:string;
begin
   savedialog1.DefaultExt:='csv';
   savedialog1.Filter:='Texto separado por comas (*.csv)|*.csv';
   savedialog1.FileName:='DgmImpacto_'+sParclase+'_'+sParbib+'_'+sParprog+'.csv';
   if savedialog1.Execute=false then exit;
   if fileexists(savedialog1.FileName) then begin
      if application.MessageBox('El archivo ya existe, desea reemplazarlo?','Confirme',MB_YESNO)=IDNO then exit;
   end;
   qq:=TADOquery.Create(self);
   qq.ConnectionString:=dm.ADOConnection1.ConnectionString;
   if dm.sqlselect(qq,'select level,pcprog,pcbib,pcclase,hcprog,hcbib,hcclase '+
      ' FROM TSRELA t '+
      ' where t.pcclase<>'+g_q+'CLA'+g_q+
      ' START WITH T.hCPROG = '+g_q+sParProg+g_q+
      '        AND T.hCBIB = '+g_q+sParbib+g_q+
      '        AND T.hCCLASE = '+g_q+sParClase+g_q+
      ' CONNECT BY NOCYCLE '+
      ' PRIOR T.pCPROG = T.hCPROG AND '+
      ' PRIOR T.pCBIB = T.hCBIB AND '+
      ' PRIOR T.pCCLASE = T.hCCLASE') then begin
      AssignFile( F, savedialog1.FileName);
      Rewrite( F );
      x:='"'+qq.fieldbyname('hcclase').asstring+
         ' '+qq.fieldbyname('hcbib').asstring+
         ' '+qq.fieldbyname('hcprog').asstring+'",';
      previo:=0;
      while not qq.eof do begin
         if qq.FieldByName('LEVEL').AsInteger<=previo then begin
            writeln(f,x);
            x:='';
            for i:=1 to qq.fieldbyname('LEVEL').AsInteger do x:=x+',';
         end;
         x:=x+'"'+qq.fieldbyname('pcclase').asstring+
            ' '+qq.fieldbyname('pcbib').asstring+
            ' '+qq.fieldbyname('pcprog').asstring+'",';
         previo:=qq.FieldByName('LEVEL').AsInteger;
         qq.Next;
      end;
      writeln(f,x);
      if dm.sqlselect(qq,'select pcprog,pcbib,pcclase,count(*) '+
         ' FROM TSRELA t '+
         ' where t.pcclase<>'+g_q+'CLA'+g_q+
         ' START WITH T.hCPROG = '+g_q+sParProg+g_q+
         '        AND T.hCBIB = '+g_q+sParbib+g_q+
         '        AND T.hCCLASE = '+g_q+sParClase+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.pCPROG = T.hCPROG AND '+
         ' PRIOR T.pCBIB = T.hCBIB AND '+
         ' PRIOR T.pCCLASE = T.hCCLASE '+
         ' group by pcprog,pcbib,pcclase '+
         ' order by pcclase,pcbib,pcprog ') then begin
         writeln(f,'RESUMEN');
         while not qq.eof do begin
            x:='"'+qq.fieldbyname('pcclase').asstring+
               ' '+qq.fieldbyname('pcbib').asstring+
               ' '+qq.fieldbyname('pcprog').asstring+'",'+
               qq.fields[3].asstring;
            writeln(f,x);
            qq.Next;
         end;
      end;
      closefile(f);
      if FileExists(savedialog1.FileName) then
         ShellExecute( 0, 'open', pchar( savedialog1.FileName ), nil, PChar( ExtractFilePath(savedialog1.FileName)), SW_SHOW );
   end;
   qq.Free;
end;

procedure TfmAnalisisImpacto.FormClose( Sender: TObject; var Action: TCloseAction );
begin
   dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,2);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,2);     //borrar elemento del arreglo de productos
   }
   Action := caFree;
end;

procedure TfmAnalisisImpacto.PubGeneraDiagrama( sParClase, sParBib, sParProg: String;
   SParSistema: String; sParCaption: String );
var
   i: Integer;
begin
   if not ( ( sParClase <> 'EMPRESA' ) and
      ( sParClase <> 'OFICINA' ) and
      ( sParClase <> 'USERPRO' ) and
      ( sParClase <> 'SISTEMA' ) and
      ( sParClase <> 'SUBCLASE' ) and
      ( sParClase <> 'CLA' ) ) then begin
      Application.MessageBox( 'No se puede generar el Diagrama' + Chr( 13 ) +
         'para este tipo de componente', 'Aviso', MB_OK );
      Exit;
   end;
   clase:=sParClase;
   bib:=sParBib;
   prog:=sParProg;
   gral.PubMuestraProgresBar( True );
   {
   numero_registros:=dm.cuenta_registros('select count(*) '+
      ' FROM TSRELA t '+
      ' where t.pcclase<>'+g_q+'CLA'+g_q+
      ' and rownum<6000 '+
      ' START WITH T.hCPROG = '+g_q+sParProg+g_q+
      '        AND T.hCBIB = '+g_q+sParbib+g_q+
      '        AND T.hCCLASE = '+g_q+sParClase+g_q+
      ' CONNECT BY NOCYCLE '+
      ' PRIOR T.pCPROG = T.hCPROG AND '+
      ' PRIOR T.pCBIB = T.hCBIB AND '+
      ' PRIOR T.pCCLASE = T.hCCLASE');
   }
   try
      Caption := sParCaption;

      GlbArmaDiagramaAImpacto( atDiagrama, sParClase, sParBib, sParProg, sParSistema, Caption );
      numero_registros:=length(aGlbBlockAtributos);

      //guarda en slPubDiagrama informacion para uso posterior
      for i := 0 to length( aGlbBlockAtributos ) - 1 do
         with slPubDiagrama, aGlbBlockAtributos[ i ] do
            if TipoBlock = 'FlowActionBlock' then
               Add( NFisicoBlock + ',' +
                  Clase + ',' + Biblioteca + ',' + Programa + ',' +
                  IntToStr( Columna ) + ',' + IntToStr( Renglon ) + ',' +
                  LigaBlockOrigen + ',' + LigaBlockDestino + ',' + sParSistema );
   finally
      gral.PubMuestraProgresBar( False );
   end;
end;

procedure TfmAnalisisImpacto.atDiagramaDControlDblClick( Sender: TObject;
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
         sNombre := slNLogicoBlock[ 3 ] + '|' + slNLogicoBlock[ 2 ] + '|' + slNLogicoBlock[ 1 ] + '|' + slNLogicoBlock[ 8 ];

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

function TfmAnalisisImpacto.ArmarOpciones( b1: Tstringlist ): integer;
begin
   gral.EjecutaOpcionB( b1, 'Análisis de Impacto' );
end;

procedure TfmAnalisisImpacto.mnuExportarExcelClick( Sender: TObject );
begin
   inherited;

   gral.exporta( Sender );
end;

procedure TfmAnalisisImpacto.FormActivate( Sender: TObject );
var
   l_control: string;
begin
   inherited;
   g_producto := 'MENÚ CONTEXTUAL-ANÁLISIS DE IMPACTO';
   l_control := stringreplace( caption, sDIGRA_AIMPACTO + ' ', '', [ rfreplaceall ] );
   g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );

   //g_control := g_tmpdir + '\Impacto' +  stringreplace( g_control, '|', '', [ rfreplaceall ] );
   iHelpContext := IDH_TOPIC_T02400;
end;

end.

