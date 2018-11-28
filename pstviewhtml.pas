unit pstviewhtml;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  Tftsviewhtml = class(TForm)
    Web: TWebBrowser;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    titulo: string;
    procedure arma( clase: string; bib: string; nombre: string; sistema: string );
    { Public declarations }
  end;

var
  ftsviewhtml: Tftsviewhtml;

implementation

uses ptsdm, ptsgral;

{$R *.dfm}

procedure Tftsviewhtml.arma( clase: string; bib: string; nombre: string; sistema: string );
var
    FteTodo: Tstringlist;

begin
    g_existe := 0;
    FteTodo := Tstringlist.Create;
    if dm.trae_fuente( sistema, nombre, bib, clase, FteTodo ) then begin;
        if FteTodo.Count > 0 then
            FteTodo.savetofile( g_tmpdir+'\'+nombre+'L');
    end else begin
         Application.MessageBox( pchar( dm.xlng( 'Archivo fuente no existe ' ) ),
            pchar( dm.xlng( 'Vista Previa ' ) ), MB_OK );
         FteTodo.free;
         g_existe := 1;
         exit;
    end;
    FteTodo.free;
end;



procedure Tftsviewhtml.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if FormStyle = fsMDIChild then
      Action := caFree;
end;

procedure Tftsviewhtml.FormDestroy(Sender: TObject);
begin
   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );
end;

end.
