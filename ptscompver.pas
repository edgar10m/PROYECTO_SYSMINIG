unit ptscompver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,ADODB;

type
  Tftscompver = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    RichEdit1: TRichEdit;
    Panel2: TPanel;
    Splitter2: TSplitter;
    Label5: TLabel;
    cmbclase: TComboBox;
    Label3: TLabel;
    txtfil: TEdit;
    Button1: TButton;
    lver: TListView;
    lv: TListView;
    Panel3: TPanel;
    bcompara: TButton;
    Button3: TButton;
    Panel4: TPanel;
    lbltotal: TLabel;
    bmas: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bmasClick(Sender: TObject);
    procedure lvClick(Sender: TObject);
    procedure cmbclaseClick(Sender: TObject);
    procedure lverClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    qq:TADOquery;
    n:integer;
   clase:string;
  public
    { Public declarations }
  end;

var
  ftscompver: Tftscompver;
   procedure PR_COMPVER;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_COMPVER;
begin
   ftscompver.Show;
end;

procedure Tftscompver.FormCreate(Sender: TObject);
begin
   //busca texto en el nombre y descripcion de la clase con minúsculas y mayúsculas. //
   dm.feed_combo(cmbclase,'select cclase||'+g_q+','+g_q+'||descripcion from tsclase '
      +' order by cclase');
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;

end;

procedure Tftscompver.Button1Click(Sender: TObject);
begin
   screen.Cursor:=crsqlwait;
   if txtfil.Text='' then
      txtfil.Text:='*';
   if dm.sqlselect(qq,'select cprog,cbib from tsprog '+
      ' where cclase='+g_q+clase+g_q+
      ' and cprog like '+g_q+stringreplace(txtfil.Text,'*','%',[rfreplaceall])+g_q+
      ' order by cprog') then begin
      bmasclick(sender);
   end;
   screen.Cursor:=crdefault;
end;

procedure Tftscompver.bmasClick(Sender: TObject);
var ite:Tlistitem;
begin
   while not qq.Eof do begin
      ite:=lv.Items.Add;
      ite.Caption:=qq.fieldbyname('cbib').AsString;
      ite.SubItems.Add(qq.fieldbyname('cprog').AsString);
      qq.Next;
      n:=n+1;
      if n mod 1000=0 then break;
   end;
   if not qq.Eof then begin
      lbltotal.Caption:='Total  '+inttostr(qq.RecordCount)+'  (1 - '+inttostr(n)+')';
      bmas.Visible:=true;
   end
   else begin
      lbltotal.Caption:='Total  '+inttostr(qq.RecordCount);
      bmas.Visible:=false;
   end;
end;

procedure Tftscompver.lvClick(Sender: TObject);
var ite:Tlistitem;
begin
   if lv.SelCount=0 then exit;
   lver.Items.Clear;
   ite:=lv.Selected;
   if dm.sqlselect(dm.q1,'select fecha,paquete from tsversion '+
      ' where cclase='+g_q+clase+g_q+
      ' and cbib='+g_q+ite.Caption+g_q+
      ' and cprog='+g_q+ite.SubItems[0]+g_q) then begin
      while not dm.q1.Eof do begin
         ite:=lver.Items.Add;
         ite.Caption:=formatdatetime('YYYY-MM-DD HH:NN:SS',dm.q1.fieldbyname('fecha').AsDateTime);
         ite.SubItems.Add(dm.q1.fieldbyname('paquete').AsString);
         dm.q1.Next;
      end;
   end;
end;

procedure Tftscompver.cmbclaseClick(Sender: TObject);
begin
   lv.Items.Clear;
   clase:=copy(cmbclase.Text,1,3);

end;

procedure Tftscompver.lverClick(Sender: TObject);
begin
   bcompara.Visible:=(lver.SelCount=2);
end;

procedure Tftscompver.Button3Click(Sender: TObject);
begin
   Close;
end;

end.
