unit alkJerCla;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TalkFormJerCla = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    rgSist: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure rgSistClick(Sender: TObject);
  private
    { Private declarations }
    sel:String;
  public
    { Public declarations }
    procedure llena_sistemas(sistemas:TStringList);
  end;

var
  alkFormJerCla: TalkFormJerCla;

implementation
uses
   uConstantes;
{$R *.dfm}

procedure TalkFormJerCla.llena_sistemas(sistemas:TStringList);
var
   i:integer;
begin
   for i:=0 to sistemas.Count-1 do
      rgSist.items.Add(sistemas[i]);
end;


procedure TalkFormJerCla.Button1Click(Sender: TObject);
begin
   alkSistema:=sel;
   Self.Close;
end;

procedure TalkFormJerCla.rgSistClick(Sender: TObject);
begin
   sel:=rgSist.Items.Strings[rgSist.ItemIndex];
   if sel <> '' then begin
      Button1.Enabled:=true;
   end;
end;

end.

