unit ptsutileria;

interface                                                       

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, dxBar, HTML_HELP, HTMLHlp;

type
  Tftsutileria = class(TForm)
    cmbutileria: TComboBox;
    txtpath: TEdit;
    OpenDialog1: TOpenDialog;
    txtdescripcion: TEdit;
    dtfecha: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dtfile: TDateTimePicker;
    Label5: TLabel;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    mnuPrincipal: TdxBarManager;
    mnuCargar: TdxBarButton;
    mnuDirectivas: TdxBarButton;
    mnuReservadas: TdxBarButton;
    BitBtn1 : TBitBtn;
    mnuAyuda: TdxBarButton;
    procedure bsalirClick(Sender: TObject);
    procedure cmbutileriaClick(Sender: TObject);
    procedure bokClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure txtpathChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure mnuCargarClick(Sender: TObject);
    procedure mnuDirectivasClick(Sender: TObject);
    procedure mnuReservadasClick(Sender: TObject);
    procedure mnuAyudaClick(Sender: TObject);

  private
    { Private declarations }
    util:String;
    exten:string;
    ultimo:Tstringlist;
    ult:integer;
  public
    { Public declarations }
  end;

var
  ftsutileria: Tftsutileria;
  procedure PR_UTILERIA;

implementation
uses ptsdm, ptsgral;
{$R *.dfm}
procedure PR_UTILERIA;
begin
   Application.CreateForm( Tftsutileria, ftsutileria );
   try
      ftsutileria.Showmodal;
   finally
      ftsutileria.Free;
   end;
end;

procedure Tftsutileria.bsalirClick(Sender: TObject);
begin
   close;
end;

procedure Tftsutileria.cmbutileriaClick(Sender: TObject);
begin
//   bok.Enabled:=true;
   util:=cmbutileria.Text;
   { mientras defino lo más práctico
   exten:='';
   if copy(util,1,7)='RGMLANG' then begin
      exten:=copy(util,8,100);
      util:=copy(util,1,7);
   end;
   }
   txtdescripcion.Text:='';
   txtpath.Text:='';
   if dm.sqlselect(dm.q1,'select descripcion, fecha, path from tsutileria,tsblob'+
      ' where cutileria='+g_q+util+g_q+
      ' and tsutileria.cblob=tsblob.cblob') then begin
      txtdescripcion.Text:=dm.q1.fieldbyname('descripcion').AsString;
      txtpath.Text:=dm.q1.fieldbyname('path').AsString;
      dtfecha.DateTime:=dm.q1.fieldbyname('fecha').AsDateTime;
      if fileexists(txtpath.Text) then begin
         dtfile.datetime:=FileDateToDateTime(FileAge(txtpath.Text));
         if dtfecha.DateTime<dtfile.DateTime then
            dtfile.Color:=clred
         else
            dtfile.Color:=clgreen;
      end
      else
            dtfile.Color:=clred
   end;
end;

procedure Tftsutileria.bokClick(Sender: TObject);
var blo,magic:string;
begin
   blo:=dm.file2blob(txtpath.Text,magic);
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+util+g_q+
      ' and cblob is not null') then begin
      if dm.sqldelete('delete tsblob '+
         ' where cblob='+g_q+dm.q1.fieldbyname('cblob').AsString+g_q)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... no puede borrar BLOB anterior')),
                              pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
         exit;
      end;
   end;
   if dm.sqlupdate('update tsutileria set cblob='+g_q+blo+g_q+','+
      ' magic='+g_q+magic+g_q+','+
      ' fecha='+dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS')+
      ' where cutileria='+g_q+cmbutileria.Text+g_q)=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar BLOB ')),
                             pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
      exit;
   end;
   cmbutileriaClick(Sender);
   Application.MessageBox(pchar(dm.xlng('Utileria cargada correctamente')),
                          pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
end;


procedure Tftsutileria.FormCreate(Sender: TObject);
begin
   if g_language='ENGLISH' then begin
      label1.Caption:='Utility';
      label2.Caption:='Description';
      label4.Caption:='Date';
      label5.Caption:='Date of Source File';
      caption:='Load of Utilities';
      //bok.Caption:='LOAD';
      //bsalir.Hint:='Exit';
   end;
   dm.feed_combo(cmbutileria,'select cutileria from tsutileria order by 1');
   ultimo:=Tstringlist.Create;
   ult:=0;
   if fileexists(g_tmpdir+'\ultima_util.txt') then begin
      ultimo.LoadFromFile(g_tmpdir+'\ultima_util.txt');
      try
         ult:=strtoint(ultimo[0]);
      except
         ult:=0;
      end;
   end;
   if cmbutileria.Items.Count>0 then begin
      cmbutileria.ItemIndex:=ult;
      cmbutileriaClick(sender);
   end;
end;

procedure Tftsutileria.BitBtn1Click(Sender: TObject);
begin
   if trim(txtpath.Text)<>'' then
      opendialog1.InitialDir:=extractfiledir(txtpath.Text);
   if opendialog1.Execute=false then exit;
   if fileexists(opendialog1.FileName) then
      txtpath.Text:=opendialog1.FileName;
end;

procedure Tftsutileria.txtpathChange(Sender: TObject);
begin
   mnuCargar.Enabled:=(trim(txtpath.Text)<>'');
end;

procedure Tftsutileria.SpeedButton1Click(Sender: TObject);
begin
   if savedialog1.Execute=false then exit;
   if cmbutileria.Text='' then exit;
   if fileexists(savedialog1.FileName) then begin
      if application.MessageBox(pchar('El archivo '+savedialog1.filename+
         ' ya existe, desea reemplazarlo?'),
         'Confirme',MB_YESNO)=IDNO then
         exit;
   end;
   dm.get_utileria(cmbutileria.Text,savedialog1.FileName);
end;

procedure Tftsutileria.mnuCargarClick(Sender: TObject);
var blo,magic:string;
begin
   if fileexists(txtpath.Text)=false then begin
      showmessage('ERROR... no existe el archivo '+txtpath.Text);
      exit;
   end;
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   blo:=dm.file2blob(txtpath.Text,magic);
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+util+g_q+
      ' and cblob is not null') then begin
      if dm.sqldelete('delete tsblob '+
         ' where cblob='+g_q+dm.q1.fieldbyname('cblob').AsString+g_q)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... no puede borrar BLOB anterior')),
                              pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
         exit;
      end;
   end;
   if dm.sqlupdate('update tsutileria set cblob='+g_q+blo+g_q+','+
      ' magic='+g_q+magic+g_q+','+
      ' fecha='+dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS')+
      ' where cutileria='+g_q+cmbutileria.Text+g_q)=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar BLOB ')),
                             pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
      exit;
   end;
   cmbutileriaClick(Sender);
   gral.PubMuestraProgresBar( False );
   screen.Cursor := crdefault;
   Application.MessageBox(pchar(dm.xlng('Utileria cargada correctamente')),
                          pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
   ultimo.Clear;
   ultimo.Add(inttostr(cmbutileria.ItemIndex));
   ultimo.SaveToFile(g_tmpdir+'\ultima_util.txt');

end;

procedure Tftsutileria.mnuDirectivasClick(Sender: TObject);
var blo,magic:string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   blo:=dm.file2blob(txtpath.Text,magic);
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+util+g_q+
      ' and cblob is not null') then begin
      if dm.sqldelete('delete tsblob '+
         ' where cblob='+g_q+dm.q1.fieldbyname('cblob').AsString+g_q)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... no puede borrar BLOB anterior')),
                              pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
         exit;
      end;
   end;
   if dm.sqlupdate('update tsutileria set cblob='+g_q+blo+g_q+','+
      ' magic='+g_q+magic+g_q+','+
      ' fecha='+dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS')+
      ' where cutileria='+g_q+cmbutileria.Text+g_q)=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar BLOB ')),
                             pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
      exit;
   end;
   cmbutileriaClick(Sender);
   gral.PubMuestraProgresBar( False );
   screen.Cursor := crdefault;
   Application.MessageBox(pchar(dm.xlng('Utileria cargada correctamente')),
                          pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
end;

procedure Tftsutileria.mnuReservadasClick(Sender: TObject);
var blo,magic:string;
begin
   screen.Cursor := crsqlwait;
   gral.PubMuestraProgresBar( True );
   blo:=dm.file2blob(txtpath.Text,magic);
   if dm.sqlselect(dm.q1,'select * from tsutileria '+
      ' where cutileria='+g_q+util+g_q+
      ' and cblob is not null') then begin
      if dm.sqldelete('delete tsblob '+
         ' where cblob='+g_q+dm.q1.fieldbyname('cblob').AsString+g_q)=false then begin
         Application.MessageBox(pchar(dm.xlng('ERROR... no puede borrar BLOB anterior')),
                              pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
         exit;
      end;
   end;
   if dm.sqlupdate('update tsutileria set cblob='+g_q+blo+g_q+','+
      ' magic='+g_q+magic+g_q+','+
      ' fecha='+dm.datedb(formatdatetime('YYYY/MM/DD HH:NN:SS',now),'YYYY/MM/DD HH24:MI:SS')+
      ' where cutileria='+g_q+cmbutileria.Text+g_q)=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar BLOB ')),
                             pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
      exit;
   end;
   cmbutileriaClick(Sender);
   gral.PubMuestraProgresBar( False );
   screen.Cursor := crdefault;
   Application.MessageBox(pchar(dm.xlng('Utileria cargada correctamente')),
                          pchar(dm.xlng('Mantenimiento de utilerías')), MB_OK );
end;

procedure Tftsutileria.mnuAyudaClick(Sender: TObject);
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [ Application.HelpFile,HTML_HELP.IDH_TOPIC_T02213 ])),HH_DISPLAY_TOPIC, 0);
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;
end.
