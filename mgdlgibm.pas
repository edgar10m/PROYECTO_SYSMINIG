unit mgdlgibm;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, Buttons, IdBaseComponent, IdComponent,
   IdTCPConnection, IdTCPClient, IdFTP;

type
   Tfmgdlgibm = class( TForm )
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      txtpassword: TEdit;
      cmbusuario: TComboBox;
      cmbhost: TComboBox;
      bsalida: TBitBtn;
      bconectar: TBitBtn;
      bdesconectar: TBitBtn;
      bok: TBitBtn;
      procedure FormCreate( Sender: TObject );
      procedure bconectarClick( Sender: TObject );
      procedure bokClick( Sender: TObject );
      procedure bdesconectarClick( Sender: TObject );
      procedure bsalidaClick( Sender: TObject );
      procedure cmbhostChange( Sender: TObject );
      procedure cmbusuarioChange( Sender: TObject );
      procedure txtpasswordChange( Sender: TObject );
   private
    { Private declarations }
   public
    { Public declarations }
    ftpibm:TIDFtp;
    g_dirftpibm:string;
   end;

var
   fmgdlgibm: Tfmgdlgibm;
   resultado: boolean;
function PR_DLGIBM(var ftpibm:TIDFtp): boolean;

implementation

uses ptsdm, {mgveribm,} IdFTPCommon;

{$R *.dfm}

function PR_DLGIBM(var ftpibm:TIDFtp): boolean;
begin
   Application.CreateForm( Tfmgdlgibm, fmgdlgibm );
   resultado := false;
   try
      fmgdlgibm.ShowModal;
      ftpibm.Host := fmgdlgibm.ftpibm.Host;
      ftpibm.Username := fmgdlgibm.ftpibm.username;
      ftpibm.Password := fmgdlgibm.ftpibm.password;
      fmgdlgibm.ftpibm.Disconnect;
      fmgdlgibm.ftpibm.Free;
      ftpibm.Connect(true);
   finally
      fmgdlgibm.Free;
   end;
   PR_DLGIBM := resultado;
end;

procedure Tfmgdlgibm.FormCreate( Sender: TObject );
begin
   dm.feed_combo( cmbhost, 'select distinct dato from parametro ' +
      ' where clave=' + g_q + 'FSTFTP1' + g_q + ' order by dato' );
   dm.feed_combo( cmbusuario, 'select distinct dato from parametro ' +
      ' where clave=' + g_q + 'FSTFTP2' + g_q + ' order by dato' );
   ftpibm:=TIDFtp.Create(self);
   if ftpibm.Connected then
   begin
      cmbhost.Text := ftpibm.Host;
      cmbusuario.Text := ftpibm.Username;
      txtpassword.Text := ftpibm.Password;
      bdesconectar.Enabled := true;
      bconectar.Enabled := false;
   end
   else
   begin
      if cmbhost.Items.Count > 0 then
         cmbhost.ItemIndex := 0;
      if cmbusuario.Items.Count > 0 then
         cmbusuario.ItemIndex := 0;
      bdesconectar.Enabled := false;
   end;
   bok.Enabled := ftpibm.connected;
end;

procedure Tfmgdlgibm.bconectarClick( Sender: TObject );
begin
   ftpibm.Host := cmbhost.Text;
   ftpibm.Username := cmbusuario.Text;
   ftpibm.Password := txtpassword.Text;
   try
      ftpibm.Connect( true );
      ftpibm.TransferType := ftascii;
      g_dirftpibm := ftpibm.retrievecurrentdir;
   except
      application.MessageBox( 'No se puede conectar, verifique datos', 'Error', MB_OK );
      exit;
   end;
   bdesconectar.Enabled := true;
   bconectar.Enabled := false;
   bok.Enabled := true;
end;

procedure Tfmgdlgibm.bdesconectarClick( Sender: TObject );
begin
   ftpibm.Disconnect;
   bok.Enabled := false;
   bdesconectar.Enabled := false;
   bconectar.Enabled := ( ( cmbhost.Text <> '' ) and ( cmbusuario.Text <> '' ) and ( txtpassword.Text <> '' ) );
end;

procedure Tfmgdlgibm.cmbhostChange( Sender: TObject );
begin
   bconectar.Enabled := ( ( cmbhost.Text <> '' ) and ( cmbusuario.Text <> '' ) and ( txtpassword.Text <> '' ) );

end;

procedure Tfmgdlgibm.cmbusuarioChange( Sender: TObject );
begin
   bconectar.Enabled := ( ( cmbhost.Text <> '' ) and ( cmbusuario.Text <> '' ) and ( txtpassword.Text <> '' ) );

end;

procedure Tfmgdlgibm.txtpasswordChange( Sender: TObject );
begin
   bconectar.Enabled := ( ( cmbhost.Text <> '' ) and ( cmbusuario.Text <> '' ) and ( txtpassword.Text <> '' ) );

end;

procedure Tfmgdlgibm.bsalidaClick( Sender: TObject );
begin
   resultado := false;
   close;

end;

procedure Tfmgdlgibm.bokClick( Sender: TObject );
begin
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'FSTFTP1' + g_q +
      ' and dato=' + g_q + trim( cmbhost.Text ) + g_q ) = false then
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'FSTFTP1' + g_q + ',1,' + g_q + cmbhost.Text + g_q + ')' );
   if dm.sqlselect( dm.q1, 'select * from parametro where clave=' + g_q + 'FSTFTP2' + g_q +
      ' and dato=' + g_q + trim( cmbusuario.Text ) + g_q ) = false then
      dm.sqlinsert( 'insert into parametro (clave,secuencia,dato) values(' +
         g_q + 'FSTFTP2' + g_q + ',1,' + g_q + cmbusuario.Text + g_q + ')' );
   resultado := true;
   close;
end;

end.
