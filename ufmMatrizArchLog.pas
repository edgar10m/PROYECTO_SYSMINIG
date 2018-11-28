unit ufmMatrizArchLog;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ufmSVSLista, cxStyles, cxCustomData, cxGraphics, cxFilter,
   cxData, cxDataStorage, cxEdit, DB, cxDBData, dxPSGlbl, dxPSUtl, dxPSEngn,
   dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
   dxPSEdgePatterns, cxGridTableView, ImgList, dxPSCore, dxPScxGridLnk,
   dxBarDBNav, dxmdaset, dxBar, dxStatusBar, cxGridLevel, cxClasses,
   cxControls, cxGridCustomView, cxGridCustomTableView, cxGridDBTableView,
   cxGrid, cxPC, StdCtrls;

type
   TTsrelaAux = record
      //sPCPROG: String;
      //sPCBIB: String;
      //sPCCLASE: String;
      sHCPROG: String;
      sHCBIB: String;
      sHCCLASE: String;
      sORDEN: String;
      sOCPROG: String;
      sOCBIB: String;
      sOCCLASE: String;
   end;

type
   TfmMatrizArchLog = class( TfmSVSLista )
   private
      { Private declarations }
      sPriClase, sPriBib, sPriProg, sPriSistema: String;
      aPriTsrelaAux: array of TTsrelaAux;

      function bPriPoblarTabla: Boolean;
      procedure PriRegistraListaArchLog( var slParLista: TStringList );
      procedure PriRegistrarProgFisicos; //para registrar MACRO/JCL

      procedure PriRegistraTsrelaAux(
         sParHCPROG, sParHCBIB, sParHCCLASE: String;
         sParOCPROG, sParOCBIB, sParOCCLASE: String );
      procedure FormClose( Sender: TObject; var Action: TCloseAction ); //alk
   public
      { Public declarations }
      procedure PubGeneraLista( sParClase, sParBib, sParProg: String;sParSistema: String; sParCaption: String );
   end;

implementation
uses
   ptsdm, uListaRutinas, uConstantes,parbol,ptsgral;

{$R *.dfm}

procedure TfmMatrizArchLog.FormClose( Sender: TObject; var Action: TCloseAction );    //alk
begin
   dm.PubEliminarVentanaActiva(Caption);  //quitar nombre de lista de abiertos
   {gral.borra_elemento(Caption,6);     //borrar elemento del arreglo de productos
   farbol.borra_elemento_a(Caption,6);     //borrar elemento del arreglo de productos
   }
   Action := caFree;
end;

procedure TfmMatrizArchLog.PubGeneraLista( sParClase, sParBib, sParProg: String; sParSistema: String; sParCaption: String );
var
   i: Integer;
begin
   sPriProg := Trim( sParProg );
   sPriBib := Trim( sParBib );
   sPriClase := Trim( sParClase );
   sPriSistema := Trim( sParSistema );

   Caption := sParCaption;
   tabLista.Caption := Caption;

   if bPriPoblarTabla then begin
      GlbHabilitarOpcionesMenu( mnuPrincipal, tabDatos.RecordCount > 0 );
      GlbCrearCamposGrid( grdDatosDBTableView1 );
      GlbCrearRecID( grdDatosDBTableView1, True );

      //necesario para la busqueda
      //en este caso usar grEspejo para apoyarse en las busquedas y llenar slPublista
      GlbCrearCamposGrid( grdEspejoDBTableView1 );
      GlbCargarLista( grdEspejo, grdEspejoDBTableView1, slPubLista );
      //fin necesario para la busqueda

      with grdDatosDBTableView1 do
         for i := 0 to ColumnCount - 1 do
            if ( Columns[ i ].DataBinding.FieldName = 'PCPROG' ) or
               ( Columns[ i ].DataBinding.FieldName = 'PCBIB' ) or
               ( Columns[ i ].DataBinding.FieldName = 'PCCLASE' ) then
               Columns[ i ].Visible := False;

      grdDatosDBTableView1.ApplyBestFit( );

      if Visible = True then
         GlbFocusPrimerItemGrid( grdDatos, grdDatosDBTableView1 );

      tabDatos.ReadOnly := True;
   end;
end;

procedure TfmMatrizArchLog.PriRegistraListaArchLog( var slParLista: TStringList );
var
   i: Integer;
   sUso: String;
   sOrganizacion: String;
begin
   slParLista.Add(
      'PCPROG:String:250' + ',' + 'PCBIB:String:250' + ',' + 'PCCLASE:String:10' + ',' +
      'ARCHIVO_LOGICO:String:250' + ',' +
      'PROGRAMA:String:250' + ',' +
      'USO:String:10' + ',' +
      'ORGANIZACION:String:10' + ',' +
      'MACRO_JCL:String:250' + ',' +
      'ARCHIVO_FISICO:String:50' );

   for i := 0 to Length( aGLBTsrela ) - 1 do begin
      if ( aGLBTsrela[ i ].sHCCLASE = sPriClase ) and
         ( aGLBTsrela[ i ].sHCBIB = sPriBib ) and
         ( aGLBTsrela[ i ].sHCPROG = sPriProg ) and
         ( aGLBTsrela[ i ].sPCCLASE = 'CBL' ) then begin

         sUso := aGLBTsrela[ i ].sMODO;
         if UpperCase( aGLBTsrela[ i ].sMODO ) = 'I' then
            sUso := 'Input'
         else if UpperCase( aGLBTsrela[ i ].sMODO ) = 'O' then
            sUso := 'Output'
         else if UpperCase( aGLBTsrela[ i ].sMODO ) = 'U' then
            sUso := 'Update';

         sOrganizacion := aGLBTsrela[ i ].sORGANIZACION;
         if UpperCase( aGLBTsrela[ i ].sORGANIZACION ) = 'IX' then
            sOrganizacion := 'Indexed'
         else if UpperCase( aGLBTsrela[ i ].sORGANIZACION ) = 'RX' then
            sOrganizacion := 'Random'
         else if UpperCase( aGLBTsrela[ i ].sORGANIZACION ) = 'SX' then
            sOrganizacion := 'Secuential';

         slParLista.Add(
            Q + aGLBTsrela[ i ].sPCPROG + Q + ',' +
            Q + aGLBTsrela[ i ].sPCBIB + Q + ',' +
            Q + aGLBTsrela[ i ].sPCCLASE + Q + ',' +
            Q + aGLBTsrela[ i ].sHCPROG + Q + ',' +
            Q + aGLBTsrela[ i ].sPCBIB + '.' + aGLBTsrela[ i ].sPCPROG + Q + ',' +
            Q + sUso + Q + ',' +
            Q + sOrganizacion + Q + ',' +
            Q + '' + Q + ',' +
            Q + aGLBTsrela[ i ].sEXTERNO + Q );
      end;
   end;
end;

procedure TfmMatrizArchLog.PriRegistrarProgFisicos;
var
   i: Integer;
begin
   SetLength( aPriTsrelaAux, 0 );

   for i := 0 to Length( aGLBTsrela ) - 1 do begin
      if ( aGLBTsrela[ i ].sPCCLASE <> 'CLA' ) and
         ( aGLBTsrela[ i ].sHCCLASE = 'CBL' ) then begin
         //pendiente por Carlos pasar clases fisicas
         //crear rutina incorporar y descriminar por clase fisica a OCCLASE

         PriRegistraTsrelaAux(
            aGLBTsrela[ i ].sHCPROG, aGLBTsrela[ i ].sHCBIB, aGLBTsrela[ i ].sHCCLASE,
            aGLBTsrela[ i ].sOCPROG, aGLBTsrela[ i ].sOCBIB, aGLBTsrela[ i ].sOCCLASE );
      end;
   end;
end;

function TfmMatrizArchLog.bPriPoblarTabla: Boolean;
var
   i: Integer;
   slArchLog: TStringList;
   bPoblarTabla: Boolean;
   sMacro_JCL: String;
begin
   Result := False;
   Screen.Cursor := crSqlWait;
   try
      stbLista.Panels[ 0 ].Text := ''; //limpia count de registros
      //obtiene datos de Tsrela y los deposita en aGLBTsrela
      dm.TaladrarTsrela( DrillUp, sPriSistema, sPriProg, sPriBib, sPriClase, not bREGISTRA_REPETIDOS );

      slArchLog := TStringList.Create;
      try
         PriRegistraListaArchLog( slArchLog );
         GlbQuitarFiltrosGrid( grdDatosDBTableView1 );
         bPoblarTabla := bGlbPoblarTablaMem( slArchLog, tabDatos );
      finally
         slArchLog.Free;
      end;

      if bPoblarTabla then begin
         with tabDatos do begin
            if RecordCount > 0 then begin
               PriRegistrarProgFisicos;

               First;

               while not Eof do begin
                  sMacro_JCL := '';
                  for i := 0 to Length( aPriTsrelaAux ) - 1 do
                     if ( FieldByName( 'PCPROG' ).AsString = aPriTsrelaAux[ i ].sHCPROG ) and
                        ( FieldByName( 'PCBIB' ).AsString = aPriTsrelaAux[ i ].sHCBIB ) and
                        ( FieldByName( 'PCCLASE' ).AsString = aPriTsrelaAux[ i ].sHCCLASE ) then begin
                        sMacro_JCL := sMacro_JCL +
                           //aPriTsrelaAux[ i ].sOCBIB + '.' + aPriTsrelaAux[ i ].sOCPROG + CHR( 13 );
                           aPriTsrelaAux[ i ].sOCBIB + '.' + aPriTsrelaAux[ i ].sOCPROG + '-';   //en vez de espacio le pongo una diagonal para que pueda exportarlo despues con el programa csv2excel   ALK
                     end;

                     if sMacro_JCL <> '' then begin
                        sMacro_JCL := Copy( sMacro_JCL, 1, Length( sMacro_JCL ) - 1 );
                        Edit;
                        FieldByName( 'MACRO_JCL' ).AsString := sMacro_JCL;
                     end;

                  Next;
               end;

               if tabDatos.State in [ dsEdit ] then
                  tabDatos.Post;
            end;

            ReadOnly := True;
         end;

         stbLista.Panels[ 0 ].Text := IntToStr( tabDatos.RecordCount ) + ' Registros';
         Result := True;
      end;

   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmMatrizArchLog.PriRegistraTsrelaAux(
   sParHCPROG, sParHCBIB, sParHCCLASE: String;
   sParOCPROG, sParOCBIB, sParOCCLASE: String );
var
   iLongitudArreglo: Integer;

   function bRepetidoTsrelaAux: Boolean;
   var
      i: Integer;
   begin
      Result := False;

      for i := 0 to Length( aPriTsrelaAux ) - 1 do
         if ( aPriTsrelaAux[ i ].sHCPROG = sParHCPROG ) and
            ( aPriTsrelaAux[ i ].sHCBIB = sParHCBIB ) and
            ( aPriTsrelaAux[ i ].sHCCLASE = sParHCCLASE ) and
            ( aPriTsrelaAux[ i ].sOCPROG = sParOCPROG ) and
            ( aPriTsrelaAux[ i ].sOCBIB = sParOCBIB ) and
            ( aPriTsrelaAux[ i ].sOCCLASE = sParOCCLASE ) then begin
            Result := True;
            Break;
         end;
   end;

begin
   if not bRepetidoTsrelaAux then begin
      // Registrar en arreglo aPriTsrelaAux
      iLongitudArreglo := Length( aPriTsrelaAux );
      SetLength( aPriTsrelaAux, iLongitudArreglo + 1 );

      aPriTsrelaAux[ iLongitudArreglo ].sHCPROG := sParHCPROG;
      aPriTsrelaAux[ iLongitudArreglo ].sHCBIB := sParHCBIB;
      aPriTsrelaAux[ iLongitudArreglo ].sHCCLASE := sParHCCLASE;
      aPriTsrelaAux[ iLongitudArreglo ].sOCPROG := sParOCPROG;
      aPriTsrelaAux[ iLongitudArreglo ].sOCBIB := sParOCBIB;
      aPriTsrelaAux[ iLongitudArreglo ].sOCCLASE := sParOCCLASE;
   end;
end;

end.

