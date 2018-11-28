unit pbarra;
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;
{$R *.dfm}
type
  Tfbarra = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
              Panel: TStatusPanel; const Rect: TRect);
    procedure pinta_barra();
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  fbarra: Tfbarra;
  procedure PR_BARRA;
implementation
procedure PR_BARRA;
begin
  Application.CreateForm(Tfbarra, fbarra);
  try
     fbarra.ShowModal;
  finally
     fbarra.Free;
  end;

end;

procedure Tfbarra.FormCreate(Sender: TObject);
var
  ProgressBarStyle: integer;
begin
  StatusBar1.Panels[1].Style := psOwnerDraw;
  ProgressBar1.Parent := StatusBar1;
  ProgressBarStyle := GetWindowLong(ProgressBar1.Handle,GWL_EXSTYLE);
  ProgressBarStyle := ProgressBarStyle - WS_EX_STATICEDGE;
  SetWindowLong(ProgressBar1.Handle, GWL_EXSTYLE, ProgressBarStyle);
end;

procedure Tfbarra.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel = StatusBar.Panels[1] then
    with ProgressBar1 do begin 
     Left := Rect.Left;
     Width := Rect.Right - Rect.Left - 15;
     Height := Rect.Bottom - Rect.Top;
    end;
    pinta_barra();
end;

procedure Tfbarra.pinta_barra();
var
  i : integer;
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := 50;
  for i := 0 to 50 do begin
    ProgressBar1.Position := i;
    Sleep(5);
  end;
  close;
end;
end.

