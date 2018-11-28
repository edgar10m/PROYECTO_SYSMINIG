unit pbfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,DB;

type
  Tftsbfile = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    function bfile2memo( clave: string; var memo: Tmemo):boolean;
    function leebfile( clave: string; var Buffer: PChar):boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ftsbfile: Tftsbfile;
  procedure PR_BFILE;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_BFILE;
begin
   Application.CreateForm( Tftsbfile, ftsbfile );
   try
      ftsbfile.Showmodal;
   finally
      ftsbfile.Free;
   end;
end;
function Tftsbfile.bfile2memo( clave: string; var memo: Tmemo):boolean;
var
  buffer:pchar;
begin
   bfile2memo:=false;
   if leebfile(clave,buffer) then begin
      Memo.SetTextBuf(Buffer);
      freemem(buffer);
      bfile2memo:=true;
   end;
end;
function Tftsbfile.leebfile( clave: string; var Buffer: PChar):boolean;
var
   st:Tmemorystream;
   tam:integer;
begin
   leebfile:=false;
   st:=Tmemorystream.Create;
   try
      dm.ADOQ.Close;
      dm.ADOQ.SQL.CLear;
      dm.ADOQ.SQL.Add('Select * from archivos where nombre='+g_q+clave+g_q);
      dm.ADOQ.Open;
      dm.ADOQ.First;
      St.Clear;
      TBlobField(dm.ADOQ.FieldByName('arch')).SaveToStream(St);
      st.Seek(0,soFromBeginning);
      tam:=st.size+1;
      getMem(buffer,tam);
      st.Read(buffer^,tam);
      leebfile:=true;
   finally
      St.Free;
   end;
end;

procedure Tftsbfile.Button1Click(Sender: TObject);
begin
   bfile2memo('salida',memo1);
   exit;
   if dm.sqlselect(dm.q1,'select * from archivos') then begin
      while not dm.q1.Eof do begin
         edit1.Text:=dm.q1.fieldbyname('nombre').asstring;
         dm.blob2memo(edit1.Text,memo1);
         dm.q1.Next;
      end;
   end;
end;

end.
