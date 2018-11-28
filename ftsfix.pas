unit ftsfix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, ComCtrls, DB, ADODB;

type
  Ttsfix = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    grbOriginales: TGroupBox;
    dbg: TDBGrid;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    bdir: TBitBtn;
    txtmascara: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbib: TComboBox;
    barchivo: TBitBtn;
    bcompara: TBitBtn;
    cmbcopylib: TComboBox;
    butileria: TBitBtn;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    fuente: TMemo;
    mresultado: TMemo;
    Memo1: TMemo;
    ttsprog: TADOQuery;
    DataSource1: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure cmbsistemaChange(Sender: TObject);
    procedure cmbclaseChange(Sender: TObject);
   procedure cmbbibChange(Sender: TObject);
  private
    { Private declarations }
    mm:Tstringlist;
    g_modomsj:word;
   fmensaje:textfile;
   b_noprocesa:boolean;
   valores:Tstringlist;
   procedure smensaje(mensaje:string);
  public
    { Public declarations }
  end;

var
  tsfix: Ttsfix;
   procedure PR_FIX;

implementation
uses ptsdm,ptspropaga, ptsutileria;

{$R *.dfm}

procedure PR_FIX;
begin
   Application.CreateForm( Ttsfix, tsfix );
   try
      tsfix.Showmodal;
   finally
      tsfix.Free;
   end;
end;

procedure Ttsfix.FormCreate(Sender: TObject);
begin
   dm.feed_combo(cmbcopylib,'select distinct cbib from tsprog where cclase='+g_q+'CPY'+g_q+' order by 1');
   if cmbcopylib.Items.Count=1 then
      cmbcopylib.ItemIndex:=0;
   dm.feed_combo( cmbsistema, 'select csistema from tssistema order by csistema' );
   if cmbsistema.Items.Count = 1 then
      cmbsistema.ItemIndex := 0;
//   progok := Tstringlist.Create;
//   progmal := Tstringlist.Create;
//   bf := Tstringlist.Create;
   ttsprog.Connection := dm.ADOConnection1;
   mm:=Tstringlist.Create;
   valores:=Tstringlist.Create;
end;
procedure Ttsfix.smensaje(mensaje:string);
var
   fMsj: TextFile;
   sFechaHoraActual: String;
begin
   AssignFile(fMsj,g_tmpdir+'\ptsanaprog_mensajes.txt');

   if FileExists(g_tmpdir+'\ptsanaprog_mensajes.txt') then
      Append(fMsj)
   else
      Rewrite(fMsj);

   sFechaHoraActual:=formatdatetime('YYYY/MM/DD HH:NN:SS',now);

   writeln(fMsj,sFechaHoraActual,'<>',mensaje);
   closefile(fMsj);
end;

procedure Ttsfix.cmbsistemaChange(Sender: TObject);
begin
   dm.feed_combo( cmbclase, 'select distinct cclase from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' order by cclase' );
   cmbbib.clear;
   barchivo.enabled := false;
   bdir.enabled := false;
   ttsprog.Close;

end;

procedure Ttsfix.cmbclaseChange(Sender: TObject);
var
   lista: Tstringlist;
   bib: string;
begin
   dm.feed_combo( cmbbib, 'select distinct cbib from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and   cclase=' + g_q + cmbclase.text + g_q +
      ' order by cbib' );
   barchivo.enabled := false;
   bdir.enabled := false;
   ttsprog.Close;
end;

procedure Ttsfix.cmbbibChange(Sender: TObject);
begin
   ttsprog.Close;
   ttsprog.SQL.Clear;
   ttsprog.SQL.Add( 'select cprog Componente from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and cclase=' + g_q + cmbclase.Text + g_q +
      ' and cbib=' + g_q + cmbbib.Text + g_q +
      ' and cprog like ' + g_q + stringreplace( txtmascara.Text, '*', '%', [ rfreplaceall ] ) + g_q +
      ' order by cprog' );
   ttsprog.open;
   if ttsprog.Eof then begin
      //   if ttsprog.RecordCount=0 then begin
      Application.MessageBox( pchar( dm.xlng( 'Sin registros' ) ),
         pchar( dm.xlng( 'Conversión ' ) ), MB_OK );
      barchivo.Enabled := false;
      bdir.Enabled := false;
      bcompara.Enabled := false;
   end
   else
      ttsprog.First;
   bdir.Enabled := ( ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   bcompara.Enabled := barchivo.Enabled;

end;


end.
