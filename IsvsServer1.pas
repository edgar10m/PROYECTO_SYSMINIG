// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : K:\pbsi5\webcliente\IsvsServer.xml
// Encoding : utf-8
// Version  : 1.0
// (05/05/2009 07:19:07 p.m. - 1.33.2.5)
// ************************************************************************ //

unit IsvsServer1;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"
  // !:int             - "http://www.w3.org/2001/XMLSchema"


  // ************************************************************************ //
  // Namespace : urn:svsIntf-IsvsServer
  // soapAction: urn:svsIntf-IsvsServer#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // binding   : IsvsServerbinding
  // service   : IsvsServerservice
  // port      : IsvsServerPort
  // URL       : http://200.94.198.216/cgi-bin/svsserver.exe/soap/IsvsServer
  // ************************************************************************ //
  IsvsServer = interface(IInvokable)
  ['{03B87834-D2A1-AAD5-FA10-4F5DFE67D10D}']
    function  analisis_impacto(const componente: WideString): WideString; stdcall;
    function  altappt(const pais: WideString; const entidad: WideString; const proyecto: WideString; const entorno: WideString; const aplicacion: WideString; const registros: WideString; var mensaje: WideString; var ppt: Integer): Integer; stdcall;
    function  cambioppt(const ppt: Integer; const pais: WideString; const entidad: WideString; const proyecto: WideString; const entorno: WideString; const aplicacion: WideString; const registros: WideString; const elementos: WideString; var mensaje: WideString): Integer; stdcall;
    function  bajappt(const ppt: Integer; var mensaje: WideString): Integer; stdcall;
    function  consultappt(const ppt: Integer; var mensaje: WideString; var archivo: WideString): Integer; stdcall;
    function  consultaelemento(const ppt: Integer; var mensaje: WideString; var archivo: WideString): Integer; stdcall;
    function  generaplan(const ppt: Integer; var mensaje: WideString; var archivo: WideString): Integer; stdcall;
    procedure SetTxt(const AValue: WideString); stdcall;
    function  GetTxt(const dato: WideString): WideString; stdcall;
  end;

function GetIsvsServer(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IsvsServer;


implementation

function GetIsvsServer(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IsvsServer;
const
  defWSDL = 'K:\pbsi5\webcliente\IsvsServer.xml';
  defURL  = 'http://200.94.198.216/cgi-bin/svsserver.exe/soap/IsvsServer';
  defSvc  = 'IsvsServerservice';
  defPrt  = 'IsvsServerPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IsvsServer);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(IsvsServer), 'urn:svsIntf-IsvsServer', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IsvsServer), 'urn:svsIntf-IsvsServer#%operationName%');

end. 