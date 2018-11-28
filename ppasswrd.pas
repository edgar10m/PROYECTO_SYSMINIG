unit ppasswrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, HTML_HELP, HtmlHlp,
  Dialogs, StdCtrls, dxBar;

type
  Tfpasswrd = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    txtpassword: TEdit;
    bcancel: TButton;
    bok: TButton;
    Label3: TLabel;
    txtconfirmar: TEdit;
    cmbusuario: TComboBox;
    mnuPrincipal: TdxBarManager;
    mnuAyuda: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure bokClick(Sender: TObject);
    procedure bcancelClick(Sender: TObject);
    procedure cmbusuarioChange(Sender: TObject);
    procedure cmbusuarioClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure mnuAyudaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fpasswrd: Tfpasswrd;
  procedure PR_PASSWORD;

implementation
uses ptsdm;
{$R *.dfm}
procedure PR_PASSWORD;
begin
   Application.CreateForm( Tfpasswrd, fpasswrd );
   try
      fpasswrd.Showmodal;
   finally
      fpasswrd.Free;
   end;
end;

procedure Tfpasswrd.FormCreate(Sender: TObject);
begin
   fpasswrd.Caption:='Cambio de Password';
   if dm.capacidad('cambio de password (todos)') then
      dm.feed_combo(cmbusuario,'select cuser from tsuser order by cuser')
   else begin
      cmbusuario.Items.Add(g_usuario);
      cmbusuario.ItemIndex:=0;
      cmbusuario.Enabled:=false;
   end;
end;

procedure Tfpasswrd.bokClick(Sender: TObject);
begin
   if txtpassword.Text<>txtconfirmar.Text then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... password no confirmado')),
                             pchar(dm.xlng('Cambiar password ')), MB_OK );
      exit;
   end;
   if dm.sqlupdate('update tsuser set password='+g_q+dm.encripta(txtpassword.Text)+g_q+
      ' where cuser='+g_q+cmbusuario.Text+g_q)=false then begin
      Application.MessageBox(pchar(dm.xlng('ERROR... no puede actualizar password')),
                             pchar(dm.xlng('Cambiar password ')), MB_OK );
      exit;
   end;
   close;
end;

procedure Tfpasswrd.bcancelClick(Sender: TObject);
begin
   close;
end;

procedure Tfpasswrd.cmbusuarioChange(Sender: TObject);
begin
   bok.Enabled:=(trim(cmbusuario.text)<>'') and
                (trim(txtpassword.Text)<>'') and
                (trim(txtconfirmar.Text)<>'');
end;

procedure Tfpasswrd.cmbusuarioClick(Sender: TObject);
begin
    iHelpContext :=  IDH_TOPIC_T02102;
end;

procedure Tfpasswrd.FormActivate(Sender: TObject);
begin
   iHelpContext :=  IDH_TOPIC_T02102;
end;

function Tfpasswrd.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
      CallHelp := False;
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

procedure Tfpasswrd.mnuAyudaClick(Sender: TObject);
begin
   try
      HtmlHelp(Application.Handle,
            PChar(Format('%s::/T%5.5d.htm',
           //[Application.HelpFile,ActiveControl.HelpContext])),HH_DISPLAY_TOPIC, 0);
           [Application.HelpFile,iHelpContext ])),HH_DISPLAY_TOPIC, 0);
   except
      Application.MessageBox( 'No existe ayuda para la pantalla ó campo seleccionado','Ayuda ' , MB_OK );
   end;
end;

end.
