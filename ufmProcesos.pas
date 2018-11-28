unit ufmProcesos;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSDiagrama, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxmdaset, dxBar, dxBarExtItems, cxGridLevel, cxGridCustomTableView,
   cxGridTableView, cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
   DgrCombo, StdCtrls, DgrSelectors, atDiagram, ComCtrls, uConstantes,
  ImgList,ADODB,shellapi;

type
   TfmProcesos = class( TfmSVSDiagrama )
    SaveDialog1: TSaveDialog;
      procedure atDiagramaDControlDblClick( Sender: TObject;
         ADControl: TDiagramControl );
      procedure mnuExportarExcelClick( Sender: TObject );
      procedure FormActivate( Sender: TObject );
      procedure FormClose( Sender: TObject; var Action: TCloseAction );
    procedure mnuExportarPDFClick(Sender: TObject); //alk
   private
      { Private declarations }
      Opciones: Tstringlist;
      numero_registros:integer;
      Clase, Bib, Prog: String;
      function ArmarOpciones( b1: Tstringlist ): integer;
      procedure exporta_texto( sParClase, sParBib, sParProg: String);
   public
      { Public declarations }
      procedure PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
         sParCaption: String );
   end;

implementation
uses
   ptsdm, ptsgral, uDiagramaRutinas, HTML_HELP,parbol;

{$R *.dfm}

procedure TfmProcesos.FormClose( Sender: TObject; var Action: TCloseAction );    //alk
begin
   dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,3);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,3);     //borrar elemento del arreglo de productos
   }
   Action := caFree;
end;

procedure TfmProcesos.PubGeneraDiagrama( sParClase, sParBib, sParProg, sParSistema: String;
   sParCaption: String );
var
   i: Integer;
begin
   if not ( ( sParClase <> 'USERPRO' ) and
      ( sParClase <> 'CLA' ) ) then begin
      Application.MessageBox( 'No se puede generar el Diagrama' + Chr( 13 ) +
         'para este tipo de componente', 'Aviso', MB_OK );
      Exit;
   end;
   clase:=sParClase;
   bib:=sParBib;
   prog:=sParProg;

   gral.PubMuestraProgresBar( True );
   try
      Caption := sParCaption;

      GlbArmaDiagramaProcesos( atDiagrama, sParClase, sParBib, sParProg,sParSistema, Caption );
      numero_registros:=length(aGlbBlockAtributos);

      //guarda en slPubDiagrama informacion para uso posterior
      for i := 0 to length( aGlbBlockAtributos ) - 1 do
         with slPubDiagrama, aGlbBlockAtributos[ i ] do
            if TipoBlock = 'FlowActionBlock' then
               Add( NFisicoBlock + ',' +
                  Clase + ',' + Biblioteca + ',' + Programa + ',' +
                  IntToStr( Columna ) + ',' + IntToStr( Renglon ) + ',' +
                  LigaBlockOrigen + ',' + LigaBlockDestino + ',' + sParSistema  );
   finally
      gral.PubMuestraProgresBar( False );
   end;
   if length(aGlbBlockAtributos )=0 then close;
end;

function TfmProcesos.ArmarOpciones( b1: Tstringlist ): integer;
begin
   gral.EjecutaOpcionB( b1, 'Diagrama' );
end;

procedure TfmProcesos.atDiagramaDControlDblClick( Sender: TObject;
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
         Opciones := gral.ArmarMenuConceptualWeb( bgral, 'diagrama_proceso' );

         y := ArmarOpciones( Opciones );
         gral.PopGral.Popup( g_X, g_Y );
      end;
   finally
      slNLogicoBlock.Free;
      screen.Cursor := crdefault;
   end;
end;

procedure TfmProcesos.mnuExportarExcelClick( Sender: TObject );
begin
   inherited;

   gral.exportaProc( sender );
end;

procedure TfmProcesos.FormActivate( Sender: TObject );
var
   l_control: string;
begin
   inherited;
   g_producto := 'MENÚ CONTEXTUAL-DIAGRAMA DE PROCESO';
   l_control := stringreplace( caption, sDIGRA_PROCESOS + ' ', '', [ rfreplaceall ] );
   g_control := stringreplace( l_control, ' ', '|', [ rfreplaceall ] );

   iHelpContext := IDH_TOPIC_T02600;
end;

procedure TfmProcesos.mnuExportarPDFClick(Sender: TObject);
begin
   if numero_registros>500 then begin
      if application.MessageBox('Involucra más de 2000 registros, desea exportar a formato texto separado por comas?','Aviso',MB_YESNO)=IDYES then
         dm.exporta_texto_GlbBlockAtributos('Diagrama de Proceso',clase,bib,prog);
      exit;
   end;
  inherited;

end;

procedure TfmProcesos.exporta_texto( sParClase, sParBib, sParProg: String);
var qq:TADOquery;               // se cicla, no es confiable
  F: TextFile;
  i,previo:integer;
  x:string;
begin
   savedialog1.DefaultExt:='csv';
   savedialog1.Filter:='Texto separado por comas (*.csv)|*.csv';
   savedialog1.FileName:='DgmProceso_'+sParclase+'_'+sParbib+'_'+sParprog+'.csv';
   if savedialog1.Execute=false then exit;
   if fileexists(savedialog1.FileName) then begin
      if application.MessageBox('El archivo ya existe, desea reemplazarlo?','Confirme',MB_YESNO)=IDNO then exit;
   end;
   qq:=TADOquery.Create(self);
   qq.ConnectionString:=dm.ADOConnection1.ConnectionString;
   if dm.sqlselect(qq,'select level,pcprog,pcbib,pcclase,hcprog,hcbib,hcclase '+
      ' FROM TSRELA t '+
      ' START WITH T.pCPROG = '+g_q+sParProg+g_q+
      '        AND T.pCBIB = '+g_q+sParbib+g_q+
      '        AND T.pCCLASE = '+g_q+sParClase+g_q+
      ' CONNECT BY NOCYCLE '+
      ' PRIOR T.hCPROG = T.pCPROG AND '+
      ' PRIOR T.hCBIB = T.pCBIB AND '+
      ' PRIOR T.hCCLASE = T.pCCLASE') then begin
      AssignFile( F, savedialog1.FileName);
      Rewrite( F );
      writeln(f,'Diagrama de Proceso '+sParclase+' '+sParbib+' '+sParprog);
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
         ' START WITH T.pCPROG = '+g_q+sParProg+g_q+
         '        AND T.pCBIB = '+g_q+sParbib+g_q+
         '        AND T.pCCLASE = '+g_q+sParClase+g_q+
         ' CONNECT BY NOCYCLE '+
         ' PRIOR T.hCPROG = T.pCPROG AND '+
         ' PRIOR T.hCBIB = T.pCBIB AND '+
         ' PRIOR T.hCCLASE = T.pCCLASE '+
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

end.

