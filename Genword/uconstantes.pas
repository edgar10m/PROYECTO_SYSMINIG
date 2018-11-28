unit uconstantes;

interface
type
   TTsrela = record // registro en memoria de TSRELA
      sPCPROG: String; //pk
      sPCBIB: String; //pk
      sPCCLASE: String; //pk
      sHCPROG: String; //pk
      sHCBIB: String; //pk
      sHCCLASE: String; //pk
      sORDEN: String; //pk
      sMODO: String;
      sORGANIZACION: String;
      sEXTERNO: String;
      sCOMENT: String;
      sOCPROG: String; //pk
      sOCBIB: String;
      sOCCLASE: String;
      sSISTEMA: String;
      sATRIBUTOS: String;
      iLINEAINICIO: Integer;
      iLINEAFINAL: Integer;
      sAMBITO: String;
      sICPROG: String;
      sICBIB: String;
      sICCLASE: String;
      sPOLIMORFISMO: String;
      sXCCLASE: String;
      sAUXILIAR: String;
      sHSISTEMA: String;
      sHPARAMETROS: String;
      sHINTERFASE: String;

      iNivel: Integer;
      bRepetido: Boolean;
      sCPROGRepetido: String;
      sCBIBRepetido: String;
      sCCLASERepetido: String;
   end;
var
   aGLBTsrela: array of TTsrela;
   alkErrorGral : String;  // para guardar los errores que se generan docAuto outSyst prueba  ALK
   function GlbObtenerRutaMisDocumentos: String;

   function sGlbAbrirDialogo: String;
//registra en aGLBTsrela el resultado de dm.TaladrarTsrela
   procedure GlbRegistraArregloTsrela(
      sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN: String;
      sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT: String;
      sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS: String;
      iParLINEAINICIO, iParLINEAFINAL: Integer;
      sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE: String;
      sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE: String;
      bParRepetido: Boolean; sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido: String ); overload;
//registra en aGLBTsrela el programa, bib y clase (padres)
   procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String ); overload;
//ALK para registrar relaciones basicas   Diagrama sistema
   procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE,
                                    sParHCPROG, sParHCBIB, sParHCCLASE,
                                    sParMODO: String ); overload;
//elimina caracteres especiales de una cadena o texto
   function bGlbQuitaCaracteres( var sParTexto: String ): Boolean;
//auxiliar para determinar repetidos y no se cicle en dm.TaladrarTsrela
   function bGlbRepetidoTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String ): Boolean;
implementation
uses sysutils,dialogs,ShlObj;

function GlbObtenerRutaMisDocumentos: String;
var
   bLongBool: Boolean;
//   sPath: array[ 0..Max_Path ] of Char;
   sPath: array[ 0..5000 ] of Char;
begin
   bLongBool := ShGetSpecialFolderPath( 0, sPath, CSIDL_Personal, False );

   if not bLongBool then
      Result := 'C:'
   else
      Result := sPath;
end;


function sGlbAbrirDialogo: String;
var
   OpenDialog: TOpenDialog;
begin
   OpenDialog := TOpenDialog.Create( nil );
   try
      with OpenDialog do begin
         InitialDir := GlbObtenerRutaMisDocumentos;

         Filter := 'Cualquier archivo (*.*)|*.*';

         if Execute then
            Result := FileName
         else
            Result := '';
      end;
   finally
      OpenDialog.Free;
   end;
end;

procedure GlbRegistraArregloTsrela(
   sParPCPROG, sParPCBIB, sParPCCLASE, sParHCPROG, sParHCBIB, sParHCCLASE, sParORDEN: String;
   sParMODO, sParORGANIZACION, sParEXTERNO, sParCOMENT: String;
   sParOCPROG, sParOCBIB, sParOCCLASE, sParSISTEMA, sParATRIBUTOS: String;
   iParLINEAINICIO, iParLINEAFINAL: Integer;
   sParAMBITO, sParICPROG, sParICBIB, sParICCLASE, sParPOLIMORFISMO, sParXCCLASE: String;
   sParAUXILIAR, sParHSISTEMA, sParHPARAMETROS, sParHINTERFASE: String;
   bParRepetido: Boolean; sParCPROGRepetido, sParCBIBRepetido, sParCCLASERepetido: String );
var
   iLongitudArreglo: Integer;
   iArreglo: Integer;
begin
   // Registrar en arreglo aGLBTsrela
   iLongitudArreglo := Length( aGLBTsrela );
   iArreglo := iLongitudArreglo;
   iLongitudArreglo := iLongitudArreglo + 1;

   //TRY
   SetLength( aGLBTsrela, iLongitudArreglo ); // SetLength( aGLBTsrela, iLongitudArreglo + 1 );

   aGLBTsrela[ iArreglo ].sPCPROG := sParPCPROG;
   aGLBTsrela[ iArreglo ].sPCBIB := sParPCBIB;
   aGLBTsrela[ iArreglo ].sPCCLASE := sParPCCLASE;
   aGLBTsrela[ iArreglo ].sHCPROG := sParHCPROG;
   aGLBTsrela[ iArreglo ].sHCBIB := sParHCBIB;
   aGLBTsrela[ iArreglo ].sHCCLASE := sParHCCLASE;
   aGLBTsrela[ iArreglo ].sORDEN := sParORDEN;
   aGLBTsrela[ iArreglo ].sMODO := sParMODO;
   aGLBTsrela[ iArreglo ].sORGANIZACION := sParORGANIZACION;
   aGLBTsrela[ iArreglo ].sEXTERNO := sParEXTERNO;
   aGLBTsrela[ iArreglo ].sCOMENT := sParCOMENT;
   aGLBTsrela[ iArreglo ].sOCPROG := sParOCPROG;
   aGLBTsrela[ iArreglo ].sOCBIB := sParOCBIB;
   aGLBTsrela[ iArreglo ].sOCCLASE := sParOCCLASE;
   aGLBTsrela[ iArreglo ].sSISTEMA := sParSISTEMA;
   aGLBTsrela[ iArreglo ].sATRIBUTOS := sParATRIBUTOS;
   aGLBTsrela[ iArreglo ].iLINEAINICIO := iParLINEAINICIO;
   aGLBTsrela[ iArreglo ].iLINEAFINAL := iParLINEAFINAL;
   aGLBTsrela[ iArreglo ].sAMBITO := sParAMBITO;
   aGLBTsrela[ iArreglo ].sICPROG := sParICPROG;
   aGLBTsrela[ iArreglo ].sICBIB := sParICBIB;
   aGLBTsrela[ iArreglo ].sICCLASE := sParICCLASE;
   aGLBTsrela[ iArreglo ].sPOLIMORFISMO := sParPOLIMORFISMO;
   aGLBTsrela[ iArreglo ].sXCCLASE := sParXCCLASE;
   aGLBTsrela[ iArreglo ].sAUXILIAR := sParAUXILIAR;
   aGLBTsrela[ iArreglo ].sHSISTEMA := sParHSISTEMA;
   aGLBTsrela[ iArreglo ].sHPARAMETROS := sParHPARAMETROS;
   aGLBTsrela[ iArreglo ].sHINTERFASE := sParHINTERFASE;

   aGLBTsrela[ iArreglo ].bRepetido := bParRepetido;
   aGLBTsrela[ iArreglo ].sCPROGRepetido := sParCPROGRepetido;
   aGLBTsrela[ iArreglo ].sCBIBRepetido := sParCBIBRepetido;
   aGLBTsrela[ iArreglo ].sCCLASERepetido := sParCCLASERepetido;
end;

procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String );
var
   iLongitudArreglo: Integer;
begin
   // Registrar en arreglo aGLBTsrela
   iLongitudArreglo := Length( aGLBTsrela );
   SetLength( aGLBTsrela, iLongitudArreglo + 1 );

   aGLBTsrela[ iLongitudArreglo ].sPCPROG := sParPCPROG;
   aGLBTsrela[ iLongitudArreglo ].sPCBIB := sParPCBIB;
   aGLBTsrela[ iLongitudArreglo ].sPCCLASE := sParPCCLASE;
end;

// ----------------------  ALK --------------------------------------
procedure GlbRegistraArregloTsrela( sParPCPROG, sParPCBIB, sParPCCLASE,
                                    sParHCPROG, sParHCBIB, sParHCCLASE,
                                    sParMODO: String );
var
   iLongitudArreglo: Integer;
begin
   // Registrar en arreglo aGLBTsrela
   iLongitudArreglo := Length( aGLBTsrela );
   SetLength( aGLBTsrela, iLongitudArreglo + 1 );

   aGLBTsrela[ iLongitudArreglo ].sPCPROG := sParPCPROG;
   aGLBTsrela[ iLongitudArreglo ].sPCBIB := sParPCBIB;
   aGLBTsrela[ iLongitudArreglo ].sPCCLASE := sParPCCLASE;
   aGLBTsrela[ iLongitudArreglo ].sHCPROG := sParHCPROG;
   aGLBTsrela[ iLongitudArreglo ].sHCBIB := sParHCBIB;
   aGLBTsrela[ iLongitudArreglo ].sHCCLASE := sParHCCLASE;
   aGLBTsrela[ iLongitudArreglo ].sMODO := sParMODO;
end;
function bGlbRepetidoTsrela( sParPCPROG, sParPCBIB, sParPCCLASE: String ): Boolean;
var
   i: Integer;
begin
   Result := False;

   for i := 0 to Length( aGLBTsrela ) - 1 do
      if ( aGLBTsrela[ i ].sPCPROG = sParPCPROG ) and
         ( aGLBTsrela[ i ].sPCBIB = sParPCBIB ) and
         ( aGLBTsrela[ i ].sPCCLASE = sParPCCLASE ) then begin
         Result := True;
         Break;
      end;
end;
function bGlbQuitaCaracteres( var sParTexto: String ): Boolean;
//elimina o quita caracteres especiales, diferentes a los validos (sVALIDOS).
const
   sVALIDOS = [ ' ', '_', '0'..'9', 'A'..'Z', 'a'..'z' ];
var
   i: Integer;
   bQuito: Boolean;
   sTexto: String;
begin
   bQuito := False;
   sTexto := '';

   for i := 1 to Length( sParTexto ) do
      if sParTexto[ i ] in sVALIDOS then
         sTexto := sTexto + sParTexto[ i ]
      else
         bQuito := True;

   sParTexto := Trim( sTexto );
   Result := bQuito;
end;

end.
