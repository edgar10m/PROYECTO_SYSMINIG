unit tsfds;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, ADODB, Grids, DBGrids;

type
  Ttsfds_A = class(TForm)
    Panel1: TPanel;
    lblMascara: TLabel;
    txtMascara: TEdit;
    btnMascara: TButton;
    cbProg: TComboBox;
    lblProg: TLabel;
    btnProg: TButton;
    Splitter1: TSplitter;
    procedure btnMascaraClick(Sender: TObject);
    procedure btnProgClick(Sender: TObject);
    //procedure selecciona;
    procedure paso2(cprog,cbib,cclase:string);
    procedure paso3(cprog,cbib,cclase:string);
    procedure paso4(cprog,cbib,cclase:string);
    procedure paso5(cprog,cbib,cclase:string);
    procedure paso6(cprog,cbib,cclase,creg,ccampo:string);
    procedure paso7(cprog,cbib,cclase,creg:string);
  private
    { Private declarations }
  public
    { Public declarations }
    hcclase,hcbib,externo, hcprog : String;
    pcclase,pcprog,pcbib:String;
    hcprog2,hcbib2 : String;
    hcprog3,hcbib3 : String;
    hcprog4,hcbib4, hccampo : String;
    pcprog2,pcbib2,hcreg:String;
  end;

var
  tsfds_A: Ttsfds_A;
  procedure PR_TSFDS;

implementation
uses ptsdm;

{$R *.dfm}
procedure PR_TSFDS;
begin
   Application.CreateForm( Ttsfds_A, tsfds_A );
   try
      tsfds_A.ShowModal;
   finally
      tsfds_A.Free;
   end;
end;

procedure Ttsfds_A.btnMascaraClick(Sender: TObject);
var
   masc, consulta : String;
begin
   hcclase:='FIL';
   hcbib:= 'DISK';
   lblProg.Visible:=true;
   cbProg.Visible:=true;
   btnProg.Visible:=true;
   masc:=UpperCase(txtMascara.Text);
   consulta:='select distinct hcprog from tsrela where hcclase='+g_q+
   hcclase+g_q+' and hcbib='+g_q+hcbib+g_q+' and hcprog like '+g_q+'%'+masc+'%'+g_q+
   ' order by 1';
   //showMessage(consulta);
   dm.feed_combo(cbProg,consulta);
end;

procedure Ttsfds_A.btnProgClick(Sender: TObject);
var qq:Tadoquery;
   i:integer;
begin
   for i:=componentcount-1 downto 0   do begin
      if components[i] is tmemo then
         components[i].Free;
   end;
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   hcprog:=cbProg.Text;
   if dm.sqlselect(qq,'select * from tsrela '+
      ' where hcclase='+g_q+hcclase+g_q+
      ' and hcbib='+g_q+hcbib+g_q+
      ' and hcprog = '+g_q+hcprog+g_q+
      ' and pcclase = '+g_q+'STE'+g_q+
      ' and externo is not NULL' )then begin
      while not qq.Eof do begin
         externo:=qq.fieldbyname('externo').AsString;
         pcclase:='STE';
        // showMessage('Paso 1 OK');
         paso2(qq.FieldByName('pcprog').AsString,
               qq.FieldByName('pcbib').AsString,
               qq.FieldByName('pcclase').AsString);
         paso3(qq.FieldByName('pcprog').AsString,
               qq.FieldByName('pcbib').AsString,
               qq.FieldByName('pcclase').AsString);
         qq.Next;
      end;
   end;
   qq.Free;
end;

procedure Ttsfds_A.paso2(cprog,cbib,cclase:string);
var qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsrela '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase='+g_q+cclase+g_q+
      ' and hcclase='+g_q+'CTC'+g_q) then begin
      while not qq.Eof do begin
         paso3(qq.FieldByName('hcprog').AsString,
               qq.FieldByName('hcbib').AsString,
               qq.FieldByName('hcclase').AsString);
         qq.Next;
      end;
   end
end;

procedure Ttsfds_A.paso3(cprog,cbib,cclase:string);
var qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsrela '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase='+g_q+cclase+g_q+
      ' and hcclase='+g_q+'CBL'+g_q) then begin
      while not qq.Eof do begin
         paso5(qq.FieldByName('hcprog').AsString,
               qq.FieldByName('hcbib').AsString,
               qq.FieldByName('hcclase').AsString);
         qq.Next;
      end;
   end;
   qq.Free;
   {
      hcprog2:=dm.q1.FieldByName('hcprog').AsString;
      hcbib2:=dm.q1.FieldByName('hcbib').AsString;
      //showMessage('hcbib '+hcbib2+' hcprog '+hcprog2);
   if((dm.q1.FieldByName('hcprog').IsNull) or (dm.q1.FieldByName('hcbib').IsNull)) then
   begin
      //showMessage('vacio');
      dm.sqlselect(dm.q1,'select * from tsrela where pcprog='+g_q+pcprog+g_q+
      ' and pcbib='+g_q+pcbib+g_q+' and pcclase='+g_q+pcclase+g_q+
      ' and hcclase='+g_q+'CTC'+g_q);
      hcprog2:=dm.q1.FieldByName('hcprog').AsString;
      hcbib2:=dm.q1.FieldByName('hcbib').AsString;
      if((dm.q1.FieldByName('hcprog').IsNull) or (dm.q1.FieldByName('hcbib').IsNull)) then
      begin
         showMessage('No contiene resultados');
      end
      else begin
         //showMessage('hcbib '+hcbib2+' hcprog '+hcprog2);
         showMessage('Paso 3 OK');
         paso4;
      end;
   end;
   }
end;

procedure Ttsfds_A.paso4(cprog,cbib,cclase:string);
var qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq, 'select * from tsrela'+
      ' where pcprog=' +g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase=' +g_q+'CTC'+g_q+
      ' and hcclase=' +g_q+'CBL' +g_q) then begin
      while not qq.Eof do begin
         paso5(qq.fieldbyname('hcprog').asstring,
               qq.fieldbyname('hcbib').asstring,
               qq.fieldbyname('hcclase').asstring);
         qq.Next;
      end;
   end;
   qq.Free;
   {
   hcprog3:=dm.q1.FieldByName('hcprog').AsString;
   hcbib3:=dm.q1.FieldByName('hcbib').AsString;
   //showMessage('hcbib '+hcbib3+' hcprog '+hcprog3);
   showMessage('Paso 4 OK');
   paso5;
   }
end;

procedure Ttsfds_A.paso5(cprog,cbib,cclase:string);
var qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq,'select * from tsrelavcbl '+
      ' where pcprog='+g_q+externo+g_q+
      ' and   pcbib='+g_q+'DISK'+g_q+
      ' and pcclase='+g_q+'FIL'+g_q+
      ' and hcprog='+g_q+cprog+g_q+
      ' and hcbib='+g_q+cbib+g_q+
      ' and hcclase='+g_q+cclase+g_q) then begin

   //hcprog4:=dm.q1.FieldByName('hcprog').AsString;
   //hcbib4:=dm.q1.FieldByName('hcbib').AsString;
   //hccampo:=dm.q1.FieldByName('hccampo').AsString;
   //showMessage('hcbib '+hcbib4+' hcprog '+hcprog4+' hccampo '+hccampo);
   //showMessage('Paso 5 OK');
      while not qq.Eof do begin
         paso6(qq.fieldbyname('hcprog').asstring,
               qq.fieldbyname('hcbib').asstring,
               qq.fieldbyname('hcclase').asstring,
               qq.fieldbyname('hcreg').asstring,
               qq.fieldbyname('hccampo').asstring);
         qq.Next;
      end;
   end;
   qq.Free;
end;

procedure Ttsfds_A.paso6(cprog,cbib,cclase,creg,ccampo:string);
var qq:Tadoquery;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   if dm.sqlselect(qq, 'select * from tsrelavcbl '+
      ' where pcprog='+g_q+cprog+g_q+
      ' and pcbib='+g_q+cbib+g_q+
      ' and pcclase='+g_q+cclase+g_q+
      ' and pcreg='+g_q+creg+g_q+
      ' and pccampo='+g_q+ccampo+g_q) then begin
      while not qq.Eof do begin
         paso7(qq.FieldByName('hcprog').AsString,
               qq.FieldByName('hcbib').AsString,
               qq.FieldByName('hcclase').AsString,
               qq.FieldByName('hcreg').AsString);
         qq.Next;
      end;
   end;
   qq.free;
   {
   pcprog2:=dm.q1.FieldByName('pcprog').AsString;
   pcbib2:=dm.q1.FieldByName('pcbib').AsString;
   hcreg:=dm.q1.FieldByName('hcreg').AsString;
   //showMessage('pcbib '+pcbib2+' pcprog '+pcprog2+' hcreg '+hcreg);
   showMessage('Paso 6 OK');
   paso7;
   }
end;

procedure Ttsfds_A.paso7(cprog,cbib,cclase,creg:string);
var
   consulta: String;
   memo:Tmemo;
   qq:Tadoquery;
   split: TSplitter;
   inicial, longitud, final :integer;
begin
   qq:=Tadoquery.Create(self);
   qq.Connection:=dm.ADOConnection1;
   memo:=Tmemo.Create(tsfds_a);
   split:=TSplitter.Create(tsfds_a);
   memo.Parent:=tsfds_a;
   split.Parent:=tsfds_a;
   memo.Visible:=true;
   split.Visible:=true;
   memo.Align:=alleft;
   split.Align:=alleft;
   memo.WordWrap:=false;
   memo.Font.Name:='Courier New';
   consulta:='select inicial, longitud, texto from tsvarcbl '+
      ' where cprog='+g_q+cprog+g_q+
      ' and cbib='+g_q+cbib+g_q+
      ' and cclase='+g_q+cclase+g_q+
      ' and creg='+g_q+creg+g_q+
      ' order by linea';
   if dm.sqlselect(qq,consulta) then begin
      while not qq.Eof do begin
         inicial:=qq.FieldByName('INICIAL').AsInteger;
         longitud:=qq.FieldByName('longitud').AsInteger;
         final:= (inicial+longitud)-1;
        { showMessage('inicial '+IntToStr(inicial)+
                     'long '+IntToStr(longitud)+
                     'final '+IntToStr(final));  }
         memo.Lines.Add('Inicial: '+IntToStr(inicial)+' , Final: '+IntToStr(final));
         //memo.Lines.Add('Final: '+IntToStr(final));
         memo.Lines.Add(qq.fieldbyname('texto').AsString);
         memo.Width:=250;
         qq.Next;
      end;
   end;
   qq.Free;
   {
   adoProg.Connection:=dm.ADOConnection1;
   qq.Close;
   qq.SQL.Clear;
   qq.SQL.Add(consulta);
   qq.Open;
   dbg.Columns[0].Width:=300;
  { gridProg.Columns[1].Width:=100;
   gridProg.Columns[2].Width:=100;
   gridProg.Columns[3].Width:=200;
   gridProg.Columns[4].Width:=100;
   gridProg.Columns[5].Width:=100;
   gridProg.Columns[6].Width:=150;
   gridProg.Columns[7].Width:=100;
   gridProg.Columns[8].Width:=100;
   gridProg.Columns[9].Width:=100;
   gridProg.Columns[10].Width:=100;
   gridProg.Columns[11].Width:=100;
   gridProg.Columns[12].Width:=100;
   gridProg.Columns[13].Width:=100;
   gridProg.Columns[14].Width:=100;     }
end;

end.
