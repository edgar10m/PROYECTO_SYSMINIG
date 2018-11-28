unit ztestbfr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, dxGDIPlusClasses, ComCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Button2: TButton;
    RadioButton1: TRadioButton;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses ptsbfr;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//   ftsbfr.arma('c:\componentes_banorte\mex\bntebfr\crpe');
   PR_BFR('c:\componentes_banorte\mex\bntebfr\crpe');
end;

procedure TForm1.Button2Click(Sender: TObject);
var edit:Tedit;
    gb:Tgroupbox;
begin
   gb:=Tgroupbox.Create(tabsheet1);
   gb.Parent:=tabsheet1;
   gb.Visible:=true;
   gb.Color:=clyellow;
   edit:=Tedit.Create(gb);
   edit.Parent:=gb;
   edit.Visible:=true;
   edit.Top:=100;

end;

end.
