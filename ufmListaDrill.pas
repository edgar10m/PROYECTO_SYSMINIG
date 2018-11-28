unit ufmListaDrill;

interface                                                                                           

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
   ufmSVSLista, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
   cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
   dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, cxGridTableView, ImgList,
   dxPSCore, dxPScxGridLnk, dxBarDBNav, dxmdaset, dxBar, dxStatusBar, cxGridLevel,
   cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView,
   cxGrid, cxPC, uConstantes, StdCtrls;

type
   TfmListaDrill = class( TfmSVSLista )
   private
      { Private declarations }
      sPriSistema, sPriClase, sPriBib, sPriProg: String;
      PriDrill: TDrill;

      function bPriPoblarTabla: Boolean;
   public
      { Public declarations }
      procedure PubGeneraLista( ParDrill: TDrill; sParClase, sParBib, sParProg: String;
         sParCaption: String );
   end;

implementation

uses
   ptsdm, uListaRutinas;

{$R *.dfm}

procedure TfmListaDrill.PubGeneraLista( ParDrill: TDrill; sParClase, sParBib, sParProg: String;
   sParCaption: String );
var
   i: Integer;
begin
   PriDrill := ParDrill;
   sPriProg := Trim( sParProg );
   sPriBib := Trim( sParBib );
   sPriClase := Trim( sParClase );

   Caption := sParCaption;
   tabLista.Caption := Caption;

   if bPriPoblarTabla then begin
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      GlbCrearCamposGrid( grdDatosDBTableView1 );
      GlbCrearRecID( grdDatosDBTableView1, True );

      //necesario para la busqueda
      //en este caso usar grdEspejo para apoyarse en las busquedas y llenar slPublista
      GlbCrearCamposGrid( grdEspejoDBTableView1 );
      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      //fin necesario para la busqueda

      if ParDrill = DrillUp then
         with grdDatosDBTableView1 do //crear rutina global para ocultar o mostrar, diccionario de datos
            for i := 0 to ColumnCount - 1 do
               if UpperCase( Columns[ i ].DataBinding.FieldName ) = 'NIVEL' then
                  Columns[ i ].Visible := False;

      grdDatosDBTableView1.ApplyBestFit( );
      GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );
      
      tabDatos.ReadOnly := True;
   end;
end;

function TfmListaDrill.bPriPoblarTabla: Boolean;
var
   slListaPaso: TStringList;
begin
   Result := False;

   Screen.Cursor := crSqlWait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros

      //obtiene datos de Tsrela y los deposita en aGLBTsrela
      if PriDrill = DrillDown then
         dm.TaladrarTsrela( PriDrill, sPriSistema, sPriProg, sPriBib, sPriClase, bREGISTRA_REPETIDOS )
      else
         dm.TaladrarTsrela( PriDrill, sPriSistema, sPriProg, sPriBib, sPriClase, False );

      slListaPaso := TStringList.Create;
      try
         //exporta a un StringList el resultado de TaladrarTsrela
         GlbExportaArregloTsrela( slListaPaso );
         //modifica cabecera de columnas
         if slListaPaso.Count > 0 then
            slListaPaso[ 0 ] :=
               'Nivel:Integer:0' + ',' +
               'PCPROG:String:250' + ',' + 'PCBIB:String:250' + ',' + 'PCCLASE:String:10' + ',' +
               'HCPROG:String:250' + ',' + 'HCBIB:String:250' + ',' + 'HCCLASE:String:10' + ',' +
               'ORDEN:String:10' + ',' + 'MODO:String:10' + ',' + 'ORGANIZACION:String:10' + ',' +
               'EXTERNO:String:50' + ',' + 'COMENT:String:200' + ',' + 'OCPROG:String:250' + ',' +
               'OCBIB:String:250' + ',' + 'OCCLASE:String:10' + ',' + 'SISTEMA:String:30' + ',' +
               'ATRIBUTOS:String:4000' + ',' + 'LINEAINICIO:Integer:0' + ',' + 'LINEAFINAL:Integer:0' + ',' +
               'AMBITO:String:10' + ',' + 'ICPROG:String:250' + ',' + 'ICBIB:String:250' + ',' +
               'ICCLASE:String:10' + ',' + 'POLIMORFISMO:String:500' + ',' + 'XCCLASE:String:250' + ',' +
               'AUXILIAR:String:100' + ',' + 'HSISTEMA:String:30' + ',' + 'HPARAMETROS:String:500' + ',' +
               'HINTERFASE:String:100' + ',' +
               'Repetido:Boolean:0' + ',' + 'CPROGRepetido:String:250' + ',' + 'CBIBRepetido:String:250' + ',' +
               'CCLASERepetido:String:10';

         GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
         if bGlbPoblarTablaMem( slListaPaso, tabDatos ) then begin
            stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';
            Result := True;
         end;
      finally
         slListaPaso.Free;
      end;

   finally
      Screen.Cursor := crDefault;
   end;
end;

end.

