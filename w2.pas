unit w2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleServer, Word2000, ComCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    bsig: TButton;
    procedure Button1Click(Sender: TObject);
    procedure bsigClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  WordApp: TWordApplication;
  end;

var
  Form2: TForm2;
  
implementation
uses w1;
{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var ww1:Tform1;
    form1:Tform1;
    i,j:integer;
begin
  form1:=Tform1.Create(self);
  //form1.Show;
  progressbar1.Min:=0;
  progressbar1.Max:=24;
  progressbar1.Step:=1;
  progressbar1.Visible:=true;
  screen.Cursor:=crHourGlass;
  for j:=0 to 3 do begin
     WordApp := TWordApplication.Create(Self);
     wordapp.Visible:=true;

  for i:=0 to 24 do begin
     form1.bremotoClick(self);
     progressbar1.StepIt;
  end;
      wordapp.Free;
      sleep(10000);
  end;
  form1.Free;
  progressbar1.Visible:=false;
  wordapp.Visible:=true;
  screen.Cursor:=crdefault;
  // ww1:=application.
end;

procedure TForm2.bsigClick(Sender: TObject);
begin
  form1:=Tform1.Create(self);
  form1.ShowModal;
  form1.Free;

end;

end.
