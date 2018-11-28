unit ptsrecjava;

interface

uses
  Qdialogs, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, FileCtrl, Grids, DBGrids, ExtCtrls, Buttons,
  ImgList;
type
   TMyRec = record
      ruta: string;
   end;

type
  Tftsrecjava = class(TForm)
    Panel2: TPanel;
    pie: TLabel;
    Panel4: TPanel;
    bsalir: TSpeedButton;
    Splitter5: TSplitter;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    txtsufijo: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbiblioteca: TComboBox;
    barchivo: TBitBtn;
    bseltodo: TBitBtn;
    chkversion: TCheckBox;
    cmboficina: TComboBox;
    rgnombre: TRadioGroup;
    chkexiste: TCheckBox;
    chkanaliza: TCheckBox;
    chkgoogle: TCheckBox;
    blog: TButton;
    GroupBox3: TGroupBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    gtsprog: TDBGrid;
    gtsversion: TDBGrid;
    rxfuente: TMemo;
    rxfc: TMemo;
    barra: TProgressBar;
    grbRecepcion: TGroupBox;
    Splitter4: TSplitter;
    archivo: TFileListBox;
    Splitter6: TSplitter;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    ypath: TPanel;
    Panel1: TPanel;
    braiz: TButton;
    txtraiz: TEdit;
    tv: TTreeView;
    procedure bsalirClick(Sender: TObject);
    procedure braizClick(Sender: TObject);
    procedure tvMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    reg:^Tmyrec;
    nodo_actual: Ttreenode;
    procedure AddDirectories(theNode: tTreeNode; cPath: string);
  public
    { Public declarations }
  end;

var
  ftsrecjava: Tftsrecjava;
  procedure PR_RECJAVA;

implementation

{$R *.dfm}
procedure PR_RECJAVA;
begin
   Application.CreateForm( Tftsrecjava, ftsrecjava );
   try
      ftsrecjava.Showmodal;
   finally
      ftsrecjava.Free;
   end;
end;

procedure Tftsrecjava.bsalirClick(Sender: TObject);
begin
   close;
end;
procedure Tftsrecjava.AddDirectories(theNode: tTreeNode; cPath: string);
var   sr: TSearchRec;
   FileAttrs: Integer;
   theNewNode : tTreeNode;
begin
   FileAttrs := faDirectory;
   // Only care about directories
   if FindFirst(cPath+'\*.*', FileAttrs, sr) = 0 then begin
      repeat
         if ((sr.Attr and FileAttrs) = sr.Attr) and (copy(sr.Name,1,1) <> '.') then begin
            theNewNode := tv.Items.AddChild(theNode,sr.name);
            thenewnode.ImageIndex:=0;
            new(reg);
            reg.ruta:=cPath+'\'+sr.Name;
            thenewnode.Data:=reg;
            AddDirectories(theNewNode,cPath+'\'+sr.Name);
         end;
      until FindNext(sr) <> 0;
      FindClose(sr);
   end;
end;
procedure Tftsrecjava.braizClick(Sender: TObject);
var   sr: TSearchRec;
      FileAttrs: Integer;
      theRootNode : tTreeNode;
      theNode : tTreeNode;
      dato:string;
begin
   if selectdirectory('Directorio Raiz','',dato)=false then exit;
   txtraiz.Text:=dato;
   tv.Items.Clear;
   theRootNode := tv.Items.AddFirst(nil,txtraiz.Text);
   theRootNode.ImageIndex:=0;
   new(reg);
   reg.ruta:=txtraiz.Text;
   theRootnode.Data:=reg;
   AddDirectories(theRootNode,txtraiz.text);
//   AddDirectories(theRootNode,txtraiz.text+'\'+sr.Name);
   tv.FullExpand;
end;

procedure Tftsrecjava.tvMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   HT: THitTests;
   reg:^Tmyrec;
begin
   HT:=tv.GetHitTestInfoAt( X, Y );
   if not (htOnItem in HT)  then exit;
   nodo_actual:=tv.GetNodeAt( X, Y );
   nodo_actual.Selected:=true;
   reg:=nodo_actual.Data;
   archivo.Directory:=reg.ruta;
end;

end.
