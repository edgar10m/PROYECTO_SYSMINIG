unit podbcno;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls, ShellAPI, ComCtrls;

type
   Tfodbcno = class( TForm )
      Button1: TButton;
      GroupBox1: TGroupBox;
      Label2: TLabel;
      Label1: TLabel;
      Label3: TLabel;
    lblodbc: TLabel;
      procedure Button1Click( Sender: TObject );
      procedure FormActivate( Sender: TObject );
    procedure FormCreate(Sender: TObject);
   private
    { Private declarations }
   public
    { Public declarations }
   end;

var
   fodbcno: Tfodbcno;
   procedure PR_ODBCNO;
implementation
uses ptsdm;
{$R *.DFM}
procedure PR_ODBCNO;
begin
   Application.CreateForm( Tfodbcno, fodbcno );
   try
      fodbcno.Showmodal;
   finally
      fodbcno.Free;
   end;
end;
procedure Tfodbcno.Button1Click( Sender: TObject );
begin
   close;
end;

procedure Tfodbcno.FormActivate( Sender: TObject );
begin
   try
      { BDE
      dm.databasedb.Connected :=  true;
      }
      dm.ADOConnection1.Connected:=false;
      dm.ADOConnection1.Connected:=true;
   except
      application.MessageBox( 'No puede conectar con la Base de Datos', 'ERROR', MB_OK );
      groupbox1.Visible := true;
      button1.Visible := true;
      exit;
   end;
end;

procedure Tfodbcno.FormCreate(Sender: TObject);
begin
   lblodbc.Caption:=g_odbc;
end;

end.
