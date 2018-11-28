unit ptsmodiliver;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, Grids, DBGrids, ExtCtrls,shellapi,
  FileCtrl;

type
  Tftsmodiliver = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    grbOriginales: TGroupBox;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label6: TLabel;
    bdir: TBitBtn;
    txtmascara: TEdit;
    cmbsistema: TComboBox;
    cmbclase: TComboBox;
    cmbbib: TComboBox;
    barchivo: TBitBtn;
    bcompara: TBitBtn;
    butileria: TBitBtn;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    memo: TRichEdit;
    SaveDialog1: TSaveDialog;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Panel1: TPanel;
    DriveComboBox1: TDriveComboBox;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure cmbsistemaChange(Sender: TObject);
    procedure cmbclaseChange(Sender: TObject);
    procedure cmbbibChange(Sender: TObject);
    procedure barchivoClick(Sender: TObject);
    procedure bcomparaClick(Sender: TObject);
    procedure bdirClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure txtmascaraChange(Sender: TObject);
  private
    { Private declarations }
   el_fuente:string;
   dir_salida:string;
   b_trae_utilerias:boolean;
    { Public declarations }
  end;

var
  ftsmodiliver: Tftsmodiliver;
   procedure PR_MODILIVER;

implementation
uses ptsdm,ptscnv;

{$R *.dfm}

procedure PR_MODILIVER;
begin
   Application.CreateForm( Tftsmodiliver, ftsmodiliver );
   try
      ftsmodiliver.Showmodal;
   finally
      ftsmodiliver.Free;
   end;
end;

procedure Tftsmodiliver.FormCreate(Sender: TObject);
begin
   {
   dm.feed_combo( cmbsistema, 'select csistema from tssistema order by csistema' );
   if cmbsistema.Items.Count = 1 then begin
      cmbsistema.ItemIndex := 0;
      cmbsistemachange(sender);
   end;
   }
      ptscnv.inicia;
      ptscnv.set_inicio(1);
      ptscnv.set_final(72);
      ptscnv.chas('SACC.PROD.SOMS.SOM.PROCPROD','DESA.SOMS.CPY.PROCLIB');
      ptscnv.chas('SACC.PROD.SOMS.SOM.LOADLIB','DESA.SOMS.CPY.LOADLIB');
      ptscnv.chas('SYS2.DB2.DSNR.SDSNLOAD','SYS2.DB2.DSNT.SDSNLOAD');
      ptscnv.chas('PGM=FTP','PGM=IEFBR14');
      ptscnv.chas('PROD.PDM.','DESA.PDM.');
      ptscnv.chas('PROD.SOMS.','DESA.SOMS.');
      ptscnv.chas('SYSTEM(DSNR)','SYSTEM(DSNT)');
      ptscnv.chas('(SOBPLNP)','(SOBPLNC)');
   b_trae_utilerias:=true;
end;

procedure Tftsmodiliver.cmbsistemaChange(Sender: TObject);
begin
   dm.feed_combo( cmbclase, 'select distinct cclase from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' order by cclase' );
   cmbbib.clear;
   barchivo.enabled := false;
end;

procedure Tftsmodiliver.cmbclaseChange(Sender: TObject);
var
   lista: Tstringlist;
   bib: string;
begin
   dm.feed_combo( cmbbib, 'select distinct cbib from tsprog ' +
      ' where sistema=' + g_q + cmbsistema.text + g_q +
      ' and   cclase=' + g_q + cmbclase.text + g_q +
      ' order by cbib' );
   barchivo.enabled := false;
   if (cmbclase.Text='CTC') or
      (cmbclase.Text='JOB') or
      (cmbclase.Text='JCL') then begin
      ptscnv.inicia;
      ptscnv.set_inicio(1);
      ptscnv.set_final(72);
      ptscnv.chas('SACC.PROD.SOMS.SOM.PROCPROD','DESA.SOMS.CPY.PROCLIB');
      ptscnv.chas('SACC.PROD.SOMS.SOM.LOADLIB','DESA.SOMS.CPY.LOADLIB');
      ptscnv.chas('SYS2.DB2.DSNR.SDSNLOAD','SYS2.DB2.DSNT.SDSNLOAD');
      ptscnv.chas('EXEC=FTP','EXEC=IEFBR14');
      ptscnv.chas('PROD.PDM.','DESA.PDM.');
      ptscnv.chas('PROD.SOMS.','DESA.SOMS.');
      ptscnv.chas('SYSTEM(DSNR)','SYSTEM(DSNT)');
      ptscnv.chas('(SOBPLNP)','(SOBPLNC)');
   end;
end;

procedure Tftsmodiliver.cmbbibChange(Sender: TObject);
begin
   {
   dir_salida:='';
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
      Application.MessageBox( pchar( dm.xlng( 'Sin registros' ) ),
         pchar( dm.xlng( 'Conversión ' ) ), MB_OK );
      barchivo.Enabled := false;
   end
   else
      ttsprog.First;
   barchivo.Enabled := ( ( dbg.SelectedField <> nil ) and
      ( cmbclase.Text <> '' ) and
      ( trim( cmbsistema.text ) <> '' ) and
      ( trim( cmbbib.text ) <> '' ) );
   el_fuente:='';
   }
end;

procedure Tftsmodiliver.barchivoClick(Sender: TObject);
var i:integer;
begin
   if filelistbox1.ItemIndex=-1 then exit;
   screen.Cursor := crsqlwait;
   if dir_salida='' then begin
      savedialog1.FileName:=filelistbox1.FileName;
      if savedialog1.Execute=false then exit;
      dir_salida:=extractfilepath(savedialog1.FileName);
   end;
   for i:=0 to filelistbox1.Items.Count-1 do begin
      if filelistbox1.Selected[i] then begin
         filelistbox1.ItemIndex:=i;
         if ptscnv.procesa(filelistbox1.filename,
            dir_salida+'\'+extractfilename(filelistbox1.filename))=false then begin
            showmessage('ERROR... '+ptscnv.mensaje_error);
         end;
      end;
   end;
   screen.Cursor := crdefault;
end;

procedure Tftsmodiliver.bcomparaClick(Sender: TObject);
begin
   if b_trae_utilerias then begin
      dm.get_utileria('COMPARACION DE FUENTES',g_tmpdir+'\htacompara.exe');
      b_trae_utilerias:=false;
   end;
   if dir_salida='' then begin
      savedialog1.FileName:=filelistbox1.filename;
      if savedialog1.Execute=false then exit;
      dir_salida:=extractfilepath(savedialog1.FileName);
   end;
   ShellExecute( 0, 'open', pchar( g_tmpdir+'\htacompara.exe' ),
      pchar(filelistbox1.filename+' '
      +dir_salida+extractfilename(filelistbox1.filename)), PChar( g_tmpdir ), SW_SHOW );

end;

procedure Tftsmodiliver.bdirClick(Sender: TObject);
begin
   filelistbox1.SelectAll;
end;

procedure Tftsmodiliver.FileListBox1Click(Sender: TObject);
begin
   memo.Lines.LoadFromFile(filelistbox1.FileName);
end;

procedure Tftsmodiliver.txtmascaraChange(Sender: TObject);
begin
   filelistbox1.Mask:=txtmascara.Text;
end;

end.
