unit mgcodigo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;
type
  Tfmgcodigo = class(TForm)
    Memo1: TMemo;
    procedure memo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure Tfmgcodigo.memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   memo1.SetFocus;
end;

procedure Tfmgcodigo.Memo1Click(Sender: TObject);
begin
   bringtofront;
   memo1.setfocus;
end;

end.
