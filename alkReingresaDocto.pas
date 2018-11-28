unit alkReingresaDocto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ptsdm, uConstantes;

type
  TalkGridReingresa = class(TForm)
    grdReingresa: TStringGrid;
    procedure grdReingresaSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure llena_grid (consulta: String);
  end;

var
  alkGridReingresa: TalkGridReingresa;

implementation

{$R *.dfm}

procedure TalkGridReingresa.llena_grid(consulta: String);
var
   i,y:integer;
begin
   if dm.sqlselect(dm.q1,consulta) then begin
      grdReingresa.ColCount:=dm.q1.FieldCount;
      grdReingresa.RowCount:=dm.q1.RecordCount+1;


      for i:=0 to dm.q1.FieldCount-1 do begin
         // poner los titulos de las columnas
         grdReingresa.Cells[i,0]:= dm.q1.Fields[i].FieldName;
         //poner tamaño de las columnas
         grdReingresa.ColWidths[i]:=strlen(pchar(dm.q1.Fields[i].AsString))*10;
      end;

      y:=1;

      while not dm.q1.Eof do begin
         for i:=0 to dm.q1.FieldCount-1 do
            grdReingresa.Cells[i,y]:=dm.q1.Fields[i].AsString;

         y:=y+1;
         dm.q1.Next;
      end;
      alkReingDoctoExterna:=1;
   end
   else begin
      ShowMessage('No existen Registros en uso');
      alkReingDoctoExterna:=0;
      Self.Close;
   end;

end;

procedure TalkGridReingresa.grdReingresaSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
   i: Integer;
begin
   for i:=0 to grdReingresa.ColCount-1 do
      Reingresar.Add(grdReingresa.Cells[i,ARow]);

   alksReingresaDoctoExterna:= Reingresar[1];
   case Application.MessageBox(pchar( dm.xlng('¿Desea liberar el documento?' + chr( 13 ) +
                               Reingresar[1])),pchar( dm.xlng('Documentacion Externa')),
                               Mb_OkCancel+MB_IconQuestion) of
      ID_OK:
         begin
            // --- Madar el string list a ufmDocumentacion para procesarlo ---
            alkReingDoctoExterna:=1;
            Self.Close;
         end;
      ID_CANCEL:      //  --  Si cancela, no hace nada  --
         begin
            alkReingDoctoExterna:=0;
            Reingresar.Clear;
         end;
   end;
end;

end.
