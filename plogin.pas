unit plogin;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ExtCtrls, jpeg, Buttons, ShellApi, dxGDIPlusClasses;

type
   Tflogin = class( TForm )
      txtusuario: TEdit;
      Label1: TLabel;
      txtpassword: TEdit;
      //Label2: TLabel;
      Button1: TButton;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      Label8: TLabel;
      Cancelar: TBitBtn;
      bok: TBitBtn;
      Label2: TLabel;
      Label7: TLabel;
      lblempresa: TLabel;
      procedure bokClick( Sender: TObject );
      procedure txtusuarioChange( Sender: TObject );
      procedure bcancelarClick( Sender: TObject );
      procedure FormCreate( Sender: TObject );
   private
      { Private declarations }
      errores: integer;
   public
      { Public declarations }
      b_ok: boolean;
   end;

var
   flogin: Tflogin;

function PR_LOGIN: boolean;

implementation
uses
   ptsdm;

{$R *.dfm}

function PR_LOGIN: boolean;
begin
   if dm.sqlselect( dm.q1, 'select * from parametro ' +
      ' where clave=' + g_q + 'EMPRESA-NOMBRE-1' + g_q ) then begin
      g_empresa := dm.q1.fieldbyname( 'dato' ).AsString;
   end;
   Application.CreateForm( Tflogin, flogin );
   flogin.lblempresa.Caption := g_empresa;
   flogin.Caption := 'SysViewSoft S.A. de C.V.                     Copyright 1995,2004 ' +
      '                                         ' + g_odbc;
   try
      flogin.b_ok := false;
      flogin.Showmodal;
   finally
      PR_LOGIN := flogin.b_ok;
      flogin.Free;
   end;
end;

procedure Tflogin.bokClick( Sender: TObject );
var
   pass: string;
begin
   if dm.sqlselect( dm.q1, 'select * from tsuser where cuser=' + g_q + txtusuario.text + g_q ) then begin
      if dm.sqlselect( dm.q2, 'select * from tsroluser where cuser=' + g_q + txtusuario.text + g_q ) then begin
         if dm.sqlselect( dm.q3, 'select * from parametro where clave=' + g_q + 'ROL_' + dm.q2.fieldbyname( 'crol' ).AsString + g_q ) then begin
            g_caduca := dm.q3.fieldbyname( 'dato' ).AsString;
            g_caduca := dm.desencripta( g_caduca );
         end
         else begin
            if ( txtusuario.text <> 'ADMIN' )
               and ( txtusuario.text <> 'SVS' ) then begin
               Application.MessageBox( pchar( dm.xlng( 'Rol: ' + g_q + 'ROL_' + dm.q2.fieldbyname( 'crol' ).AsString + g_q +
                  ' sin fecha de caducidad, consultar al administrador' ) ),
                  pchar( dm.xlng( 'Login' ) ), MB_OK );
               application.Terminate;
            end
            else begin
               g_caduca := formatdatetime( 'YYYYMMDD', now );
            end;
         end;
      end;

      pass := dm.encripta( txtpassword.Text );
      if pass <> dm.q1.fieldbyname( 'password' ).AsString then begin
         Application.MessageBox( pchar( dm.xlng( 'ERROR... Password incorrecto' ) ),
            pchar( dm.xlng( 'Login' ) ), MB_OK );
         inc( errores );
         if errores > 2 then
            application.Terminate;
      end
      else begin
         if formatdatetime( 'YYYYMMDD', now ) > g_caduca then begin
            Application.MessageBox( pchar( dm.xlng( 'ERROR... Licencia caducada' ) ),
               pchar( dm.xlng( 'Validar licencia' ) ), MB_OK );
            application.Terminate;
            exit;
         end;
         if copy( formatdatetime( 'YYYYMMDD', now ), 1, 6 ) = copy( g_caduca, 1, 6 ) then begin
            Application.MessageBox( pchar( dm.xlng( 'WARNING... Licencia caducadará el día ' + copy( g_caduca, 7, 2 ) + ' de este mes' ) ),
               pchar( dm.xlng( 'Validar licencia' ) ), MB_OK );
         end;
         g_usuario := txtusuario.text;
         b_ok := true;
         close;
      end;
   end
   else begin
      Application.MessageBox( pchar( dm.xlng( 'ERROR... Password incorrecto' ) ),
         pchar( dm.xlng( 'Login' ) ), MB_OK );
      inc( errores );
      if errores > 2 then
         application.Terminate;
   end;
end;

procedure Tflogin.txtusuarioChange( Sender: TObject );
begin
   bok.Enabled := ( trim( txtusuario.text ) <> '' ) and ( trim( txtpassword.Text ) <> '' );
end;

procedure Tflogin.bcancelarClick( Sender: TObject );
begin
   b_ok := False;

   Close;
end;

procedure Tflogin.FormCreate( Sender: TObject );
var
   lis: string;
begin
   if g_language = 'ENGLISH' then begin
      label1.Caption := 'User';
   end;
   lis := copy( g_version_tit, pos( 'Management', g_version_tit ) + 11, 100 );
end;

end.

