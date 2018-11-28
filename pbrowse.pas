unit pbrowse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, StdCtrls, ComCtrls, shellapi, Buttons, ExtCtrls,
  ValEdit, ADODB, dxBar;

type
  Tfbrowse = class(TForm)
    DataSource1: TDataSource;
    dbg: TDBGrid;
    Panel4: TPanel;
    Label1: TLabel;
    lblwhere: TLabel;
    Label3: TLabel;
    ScrollBox1: TScrollBox;
    lstcampos: TListBox;
    vl: TValueListEditor;
    lstorder: TListBox;
    yck: TPanel;
    Splitter1: TSplitter;
    qq: TADOQuery;
    mnuPrincipal: TdxBarManager;
    mnuEjecutar: TdxBarButton;
    labTotal: TdxBarButton;
    mnuExportar: TdxBarButton;
    procedure bsalirClick(Sender: TObject);
    procedure bokClick(Sender: TObject);
    procedure lstorderDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lstorderDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstorderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure mnuEjecutarClick(Sender: TObject);
    procedure mnuExportarClick(Sender: TObject);
  private
    { Private declarations }
    renglon:integer;
    nite:integer;
  public
    { Public declarations }
    sele:string;
    campos:Tstringlist;
    ck:array of Tcheckbox;
  end;

var
  fbrowse: Tfbrowse;
  procedure PR_BROWSE;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_BROWSE;
begin
   Application.CreateForm( Tfbrowse, fbrowse );
   fbrowse.campos:=Tstringlist.Create;
   fbrowse.qq.Connection:=dm.ADOConnection1;
end;
procedure Tfbrowse.bsalirClick(Sender: TObject);
begin
   close;
end;

procedure Tfbrowse.bokClick(Sender: TObject);
var sep,orden:string;
    i:integer;
    cam,cam2 : String;
begin
   qq.Close;
   qq.SQL.Clear;
   qq.SQL.Add(sele);
   orden:=' ';
   qq.Filter:='';
   for i:=1 to vl.RowCount-1 do begin
      if trim(vl.cells[i,i])<>'' then begin
         qq.Filter:=qq.Filter+orden+campos[i-1]+'='+vl.cells[i,i];
         orden:=' and ';
      end;
   end;
   sep:=' order by ';
   if lstorder.SelCount>0 then begin
      for i:=0 to lstorder.Items.Count-1 do begin
         if lstorder.Selected[i] then begin
            orden:='';
            if ck[i].Checked then
               orden:=' desc ';
            qq.SQL.Add(sep+copy(lstorder.Items[i],pos('.',lstorder.Items[i])+1,10)+orden);
            sep:=',';
         end;
      end;
   end;
   lstorder.TopIndex:=0;
//   qq.ExecSQL;
   qq.Open;
   if lstcampos.SelCount>0 then begin
      for i:=0 to lstcampos.Items.Count-1 do begin
         dbg.Columns[i].Visible:=lstcampos.Selected[i];
         cam:= copy(dbg.Columns.Items[i].Title.Caption,5,100);
         cam2:= stringreplace(cam,'_AST','',[rfreplaceall]);
         cam:= stringreplace(cam2,'_',' ',[rfreplaceall]);
         dbg.Columns.Items[i].Title.Caption:= cam;
      end;
   end;
   //lblrecords.Caption:=dm.xlng('Registros: '+inttostr(qq.RecordCount));
   labTotal.Caption:=dm.xlng('Registros: '+inttostr(qq.RecordCount));
end;

procedure Tfbrowse.lstorderDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var a:Tpoint;
begin
   a.X:=x;
   a.Y:=y;
   renglon:=lstorder.ItemAtPos(a,true);
   if nite= -1 then
      lstorder.Items.Add((source as Tlistbox).Items[nite])
   else
      lstorder.Items.Insert(renglon,(source as Tlistbox).Items[nite]);
   if nite>renglon then
      lstorder.Items.Delete(nite+1)
   else
      lstorder.Items.Delete(nite);
end;

procedure Tfbrowse.lstorderDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
   accept:=sender is Tlistbox;
end;

procedure Tfbrowse.lstorderMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a:Tpoint;
begin
   a.X:=x;
   a.Y:=y;
   nite:=lstorder.ItemAtPos(a,true);
end;

procedure Tfbrowse.FormCreate(Sender: TObject);
begin
   if g_language='ENGLISH' then begin
      vl.TitleCaptions[0]:='Field';
      vl.TitleCaptions[1]:='Value';
      //bok.Caption:='Execute';
      //bsalir.hint:='Exit';
   end;
end;

procedure Tfbrowse.mnuEjecutarClick(Sender: TObject);
var
   sep,orden:string;
   i:integer;
   cam,cam2 : String;
begin
   qq.Close;
   qq.SQL.Clear;
   qq.SQL.Add(sele);
   orden:=' ';
   qq.Filter:='';
   for i:=1 to vl.RowCount-1 do begin
      if trim(vl.cells[i,i])<>'' then begin
         qq.Filter:=qq.Filter+orden+campos[i-1]+'='+vl.cells[i,i];
         orden:=' and ';
      end;
   end;
   sep:=' order by ';
   if lstorder.SelCount>0 then begin
      for i:=0 to lstorder.Items.Count-1 do begin
         if lstorder.Selected[i] then begin
            orden:='';
            if ck[i].Checked then
               orden:=' desc ';
            qq.SQL.Add(sep+copy(lstorder.Items[i],pos('.',lstorder.Items[i])+1,10)+orden);
            sep:=',';
         end;
      end;
   end;
   lstorder.TopIndex:=0;
//   qq.ExecSQL;
   qq.Open;
   if lstcampos.SelCount>0 then begin
      for i:=0 to lstcampos.Items.Count-1 do begin
         dbg.Columns[i].Visible:=lstcampos.Selected[i];
         cam:= copy(dbg.Columns.Items[i].Title.Caption,5,100);
         cam2:= stringreplace(cam,'_AST','',[rfreplaceall]);
         cam:= stringreplace(cam2,'_',' ',[rfreplaceall]);
         dbg.Columns.Items[i].Title.Caption:= cam;
      end;
   end;
   //lblrecords.Caption:=dm.xlng('Registros: '+inttostr(qq.RecordCount));
   labTotal.Caption:=dm.xlng('Registros: '+inttostr(qq.RecordCount));
end;

procedure Tfbrowse.mnuExportarClick(Sender: TObject);
var
   i,ii,iii : Integer;
   sl : Tstringlist;
   txt: string;
   archivocsv : string;
begin
   sl := Tstringlist.create;
   ii := qq.FieldCount;
   qq.First;
   dbg.Visible:=FALSE;

   while not qq.Eof do begin
        txt:='';
        for iii:=0 to ii -1 do  begin
            txt:=txt+(qq.Fields[iii].AsString)+',';
        end;
        sl.add(txt);
        qq.Next
   end;
   qq.First;
   dbg.Visible:=TRUE;
   archivocsv:=g_tmpdir+'\Cat'+caption+formatdatetime('YYYYMMDDHHNNSS',now)+'.csv';
   sl.SaveToFile(archivocsv);
   if ShellExecute(Handle, nil,pchar(archivocsv),nil, nil, SW_SHOW) <= 32 then
      Application.MessageBox(pchar(dm.xlng('No puede ejecutar '+archivocsv)),
                             pchar(dm.xlng('Error')), MB_ICONEXCLAMATION);
   sl.Free;
   exit;
end;

end.
