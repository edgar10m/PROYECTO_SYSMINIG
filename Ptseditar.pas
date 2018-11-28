unit Ptseditar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, dxBar;

type
  TEditar = class(TForm)
    Ayuda: TRichEdit;
    mnuPrincipal: TdxBarManager;
    mnuActualizar: TdxBarButton;
    mnuCancelar: TdxBarButton;
    procedure mnuActualizarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private

  public
    titulo, Wtexto: string;
    function EditarTexto( texto: string; pos: integer; lon: integer ):string;
  end;

var
  Editar: TEditar;
  Wtexto: string;

implementation

uses ptsdm, ptsgral;

{$R *.dfm}

function  Teditar.EditarTexto( texto: string; pos: integer; lon: integer ):string;
var
   i,ii,iii : integer;
   fil:tstringlist;
   SQL_linea, linea: string;
begin
  {   Wtexto:=texto;

      fil := Tstringlist.Create;

     if texto <> '' then
        fil.add(texto)
      else
        fil.LoadFromFile( 'FN.txt' );

      ii:=fil.Count;
      SQL_linea := '';
      for iii:=0 to ii-1 do begin
         SQL_linea := SQL_linea + trim(copy(fil[iii],1,500)) +' ';
      end;
      //i:=Ayuda.CaretPos.y;
      fil.Free;

      EditarTexto := SQl_linea;
   }
end;
procedure TEditar.mnuActualizarClick(Sender: TObject);
begin
  Ayuda.Lines.SaveToFile('FN.txt');
  close;
end;

procedure TEditar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if FormStyle = fsMDIChild then
      Action := caFree;

end;

procedure TEditar.FormCreate(Sender: TObject);
begin
 if gral.iPubVentanasActivas > 0 then  
      gral.PubExpandeMenuVentanas( True );
end;

procedure TEditar.FormDestroy(Sender: TObject);
begin

   dm.PubEliminarVentanaActiva( Caption );

   if gral.iPubVentanasActivas in [ 0, 1 ] then  
      gral.PubExpandeMenuVentanas( False );

end;

end.
